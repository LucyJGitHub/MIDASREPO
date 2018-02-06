     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal contracts retrieve a record')        *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABINTCR - AB Internal Contracts retrieve a record            *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 261962             Date 23Sep09               *
      *                 259924A            Date 31May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 13JAN06               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CDL018             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CAP084  *CREATE    Date 05Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions (recompile) *
      *  261962 - Amended so that system can get the associated front *
      *           office ID from Java for INTC.                       *
      *  259924A- Amended so that system can get the front office ID  *
      *           from Java.                                          *
      *  CSD027 - Recompiled due to PF changes.                       *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL018 - Multiple Settlement Accounts in Loans/Deposits      *
      *           (Recompile)                                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     F/COPY WNCPYSRC,ABH00001
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------
 
     D/COPY WNCPYSRC,ABH00002
     D INTCScnFmt    E DS                  EXTNAME(ABINTCPD)
      * Deal in screen format
 
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      * Receive settlement instructions in screen format
 
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      * Pay settlement instructions in screen format
 
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS settlement instructions in screen format
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D INTCFilFmt    E DS                  EXTNAME(ABVINTCPD)
      ** Deal in file format
 
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Deal Front Office ID                                                                259924A
     D DDFOID          S             20                                                      259924A
     D DDAFID          S             20                                                       261962
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDL1DN_In         6
     C                   PARM                    DDL2DN_In         6
     C                   PARM                    DDBRCD_In         3
     C                   PARM                    DDORBR_In         3
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
     C/COPY WNCPYSRC,ABH00018
 
      * Set up the name of the primary message file from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,ABINTC02
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   INTCFilFmt
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      ABINTCRED
     C                   ELSE
      ** MOVE ALL THE KEY FIELDS REQUIRED HERE TO THE @XXXX FORMAT
     C                   MOVEL     DDL1DN_IN     @DLRED1           6
     C                   MOVEL     DDL2DN_IN     @DLRED2           6
     C                   MOVEL     DDBRCD_IN     @DBRCD            3
     C                   MOVEL     DDORBR_IN     @DORBR            3
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal read and no error message returned
     C                   IF        ReturnCode = *BLANK and
     C                             @DLRED1 <> *Blank
      *
      * Retrieve deal details (all key fields required for call to rtv module)
     C                   MOVEL     @DLRED1       DDL1DN
     C                   MOVEL     @DLRED2       DDL2DN
     C                   MOVEL     @DBRCD        DDBRCD
     C                   MOVEL     @DORBR        DDORBR
     C                   EXSR      ABINTCRTV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      ABINTCCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDDLNO'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   EVAL                    Buffer = INTCScnFmt
     C                                           + DDL2RT  + DDL2CB
     C                                           + DDL2BA  + DDL2CS
     C                                           + DDL2SA  + DDLOIA
     C*********                                  + DDDPIA  + DDSTS                           259924A
     C                                           + DDDPIA  + DDSTS + DDFOID                  259924A
     C                                           + DDAFID                                     261962
     C/COPY WNCPYSRC,ABH00003
     C                                           + ##RECS  + ##PAYS
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     ABINTCRED     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'ABINTCRED'
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM      DDL1DN_IN     DDDLNO            6
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @DLRED            6
 
     C                   ENDSR
      **********************************************************************
     C     ABINTCRTV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'ABINTCRTV'
 
      * INPUTS
 
      * Return code
     C                   PARM                    ReturnCode
 
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE        1
 
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) First Deal Number
     C                   PARM                    DDL1DN            6
      *
      * (Midas) Second Deal Number
     C                   PARM                    DDL2DN            6
      *
      * Booking branch
     C                   PARM                    DDBRCD            3
      *
      * Originating branch
     C                   PARM                    DDORBR            3
 
      * OUTPUTS
 
      * (Current) deal in file format
     C                   PARM                    INTCFilFmt
 
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - First Deal Number
     C                   PARM                    ddL1DNok          1
      *
      * OK - Second Deal Number
     C                   PARM                    ddL2DNok          1
      *
      * OK - Booking branch
     C                   PARM                    ddBRCDok          1
      *
      * OK - Originating branch
     C                   PARM                    ddORBRok          1
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C/COPY WNCPYSRC,ABH00004
 
     C                   ENDSR
      **********************************************************************
     C     ABINTCCVT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'ABINTCCVT'
 
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    INTCFilFmt
 
      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    INTCScnfmt
      *
      * 2nd Leg Exchange Rate
      * 2nd Leg Buy Currency
      * 2nd Leg Buy Amount
      * 2nd Leg Sell Currency
      * 2nd Leg Sell Amount
      * Loan Interest Amount
      * Deposit Interest Amount
     C                   PARM                    DDL2RT           13
     C                   PARM                    DDL2CB            3
     C                   PARM                    DDL2BA           16
     C                   PARM                    DDL2CS            3
     C                   PARM                    DDL2SA           16
     C                   PARM                    DDLOIA           17
     C                   PARM                    DDDPIA           17
      * Deal Status
     C                   PARM                    DDSTS            24
      *                                                                                       261962
      ** Front Office Transaction ID                                                          261962
      ** Associated Front Office Transaction ID                                               261962
      *                                                                                       261962
     C                   PARM                    DDFOID                                       261962
     C                   PARM                    DDAFID                                       261962
      *                                                                                       261962
     C/COPY WNCPYSRC,ABH00005
 
      ** AMEND CHECKING
     C                   RESET                   ReturnCode
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
