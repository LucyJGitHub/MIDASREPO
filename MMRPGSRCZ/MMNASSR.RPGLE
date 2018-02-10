     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs sold retrieve a record')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASSR   - Negotiable Assets Sold - Retrieve a record       *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239400             Date 26Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG6512            Date 22Apr05               *
      *                 BUG4146            Date 31Aug04               *
      *                 CDL018             Date 03Feb04               *
      *                 TCA002             Date 26Mar04               *
      *                 CAP084  *CREATE    Date 15Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  239400 - Add Front Office ID to be used by SOAP Interface    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG6512 - Retrieve TRAM details                              *
      *  BUG4146 - Stopping two users to update the same record at the*
      *            same time.                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TCA002 - 10-Digit Account Code Errors - Retrieve a/c details.*
      *  CAP084 - API Wrapper project.                                *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
     D DealScnFmt    E DS                  EXTNAME(MMNASSPD)
      * Deal in screen format
 
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
      * Receive settlement instructions in screen format
 
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
      * Pay settlement instructions in screen format
 
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS settlement instructions in screen format
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D DealFilFmt    E DS                  EXTNAME(MMDENSPP)
      ** Deal in file format
     D DENSRecIns            328    382                                                       TCA002
     D DENSPayIns            397    941                                                       TCA002
     D*DENSRecIns************314    382                                                       TCA002
     D*DENSPayIns************383    941                                                       TCA002
 
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
     D**FLREC******************1     69                                                       TCA002
     D  FLREC2                21     75                                                       TCA002
      * Receive settlement instructions in file format
 
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
     D**FLPAY******************1    559                                                       TCA002
     D  FLPAY2                21    565                                                       TCA002
      * Pay settlement instructions in file format
 
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
      * FRA/IRS settlement instructions in file format
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
      **-----------------------------------------------------------------------
 
      ** Index for arrays of error message IDs, etc.
     D Idx             S              3P 0
 
      ** Index for arrays of warning message IDs, etc.
     D WIdx            S              3P 0
 
      ** Front office transaction ID
     D  FOTrID         S                   LIKE(HMFRNT)
     D DDFOID          S             20                                                       239400
 
      ** Associated front office trasaction ID
     D  FOAsID         S                   LIKE(HMAFRT)
 
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A
      **-----------------------------------------------------------------------
      **  Start of main processing
      **-----------------------------------------------------------------------
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDDLNO_In         6
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,MMNASSM01
 
      **  Get ZMUSER to access default branch.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
      * If the action code is blank, Enquire unless Authorising
     C                   CLEAR                   DealFilFmt
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
     C                   EXSR      MMNASSRED
     C                   ELSE
     C                   MOVEL     DDDLNO_In     @DLRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal was read and no error message returned
     C                   IF        ReturnCode = *BLANK and
     C                             @DLRED <> *Blank
      *
      * Retrieve deal details (all key fields required for call to RTV module)
     C                   MOVEL     @DLRED        DDDLNO
     C                   EXSR      MMNASSRTV
                                                                                             BUG6512
      *                                                                                      BUG6512
      * Retrieve TRAM details                                                                BUG6512
      *                                                                                      BUG6512
     C                   EXSR      ZACFFEERTV                                                BUG6512
                                                                                             BUG6512
      *
      * Convert to screen format
     C     Idx           IFEQ      0
     C                   EXSR      MMNASSCVT
     C                   EXSR      ZASETINCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDDLNO'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   MOVEL     HMTMST        @TimeStamp       26                         BUG4146
     C                   EVAL                    Buffer = DealScnfmt
     C                                           + CPST     + DSPCP                          BUG6512
     C                                           + BKST     + DSPBK                          BUG6512
     C                                           + @TimeStamp                                BUG4146
     C                                           + DDFOID                                     239400
     C                                           + InRecSttmt
     C                                           + InPaySttmt
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     MMNASSRED     BEGSR
      *
     C                   CALLB     'MMNASSRED'
      * Input parameters
      * ----------------
      * Return code
     C                   PARM      *BLANK        ReturnCode
      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not front office transaction interface)
     C                   PARM      '      '      @@MODE            6
      * Action code
     C                   PARM                    DDACTN            1
      * Deal number pointer
     C                   PARM      DDDLNO_In     DDDLNO            6
      * Front Office ID
     C                   PARM                    FOTrID
      * Read Forwards
     C                   PARM                    @RDFWD            1
      * Read Backwards
     C                   PARM                    @RDBCK            1
      *
      * Output parameters
      * ------------------
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      * Deal number read
     C                   PARM      *BLANK        @DLRED            6
      * Front Office ID read
     C                   PARM                    @FTRED           20
 
     C                   ENDSR
      **********************************************************************
     C     MMNASSRTV     BEGSR
      *
     C                   CALLB     'MMNASSRTV'
      * INPUTS
      * ------
      * Return code
     C                   PARM      *BLANK        ReturnCode
      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not Front office transaction interface)
     C                   PARM      *BLANK        ModeofOp          6
      * Response mode
     C                   PARM      'S'           RespMode          1
      * Action Code
     C                   PARM                    DDACTN
      * Front Office Transaction ID
     C                   PARM                    FOTrID
      * Front Office Associated Transaction ID
     C                   PARM                    FOAsID
      * (Midas) Deal Number
     C                   PARM                    DDDLNO
      * (Midas) Associated Deal Number
     C                   PARM                    DDDADN
      * OUTPUTS
      * -------
      * (Current) deal in file format
     C                   PARM                    DealFilFmt
      * OK - Action code
     C                   PARM      'Y'           DDActnOK          1
      * OK - Deal Number
     C                   PARM      'Y'           DDDlnoOK          1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
     C                   ENDSR
      **********************************************************************
     C     MMNASSCVT     BEGSR
 
     C                   CALLB     'MMNASSCVT'
      * INPUTS
      * ------
      * Return Code
     C                   PARM      *BLANK        ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
      * OUTPUTS
      * -------
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * Deal Status
     C                   PARM                    DDSTS            24
 
     C                   EVAL      DDFOID = HMFRNT                                            239400
                                                                                              239400
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     ZASETINCVT    BEGSR
      *
      * Set up Payment instructions from deal
     C*******************MOVEL     DENSPayIns    FLPAY                                        TCA002
     C                   MOVEL     HMPSTM        FLPSTM                                       TCA002
     C                   MOVEL     HMPONS        FLPONS                                       TCA002
     C                   MOVEL     DENSPayIns    FLPAY2                                       TCA002
     C                   MOVEL     HMCVMR        FLCVMR
     C                   MOVEL     HMSTCY        FLPSCY
     C                   MOVEL     HMIC72        FLIC72
      *
      * Set up receive instructions from deal
     C*******************MOVEL     DENSRecIns    FLREC                                        TCA002
     C                   MOVEL     HMRSTM        FLRSTM                                       TCA002
     C                   MOVEL     HMRONS        FLRONS                                       TCA002
     C                   MOVEL     DENSRecIns    FLREC2                                       TCA002
     C                   MOVEL     HMROBR        FLROBR
     C                   MOVEL     HMSTCY        FLRSCY
      *
     C                   CALLB     'ZASETINCVT'
      *
      ** Inputs
      ** File payment settlement instruction
     C                   PARM                    DBPaySttmt
      *
      ** File receipt settlement instruction
     C                   PARM                    DBRecSttmt
      *
      ** File FRA/IRS settlement instruction
     C                   PARM      *BLANK        DBFRASttmt
      *
      ** Outputs
      ** Screen payment settlement instruction
     C                   PARM      *BLANK        InPaySttmt
      *
      ** Screen receipt settlement instruction
     C                   PARM      *BLANK        InRecSttmt
      *
      ** Screen FRA/IRS settlement instruction
     C                   PARM      *BLANK        InFRASttmt
     C                   PARM      HMCCY         InRCCY                                      CSF011A
     C                   PARM      HMCCY         InPCCY                                      CSF011A
      *
     C                   ENDSR
      **********************************************************************                 BUG6512
     C     ZACFFEERTV    BEGSR                                                               BUG6512
                                                                                             BUG6512
     C                   CALLB     'ZACFFEERTV'                                              BUG6512
      *                                                                                      BUG6512
      * INPUTS                                                                               BUG6512
      *                                                                                      BUG6512
      * Return code                                                                          BUG6512
     C                   PARM      *BLANK        RetCodeIn        10                         BUG6512
      *                                                                                      BUG6512
      * Action Code                                                                          BUG6512
     C                   PARM                    DDACTN            1                         BUG6512
      *                                                                                      BUG6512
      * (Midas) Deal Number                                                                  BUG6512
     C                   PARM                    DDDLNO            6                         BUG6512
      *                                                                                      BUG6512
      * Broker                                                                               BUG6512
     C                   PARM                    HMBKCD            4                         BUG6512
      *                                                                                      BUG6512
      * OUTPUTS                                                                              BUG6512
      *                                                                                      BUG6512
      * OK - Action code                                                                     BUG6512
     C                   PARM      'Y'           DDActnOK          1                         BUG6512
      *                                                                                      BUG6512
      * Counterparty Status                                                                  BUG6512
     C                   PARM                    CPST              2                         BUG6512
     C                   PARM                    DSPCP             1                         BUG6512
      *                                                                                      BUG6512
      * Broker Status                                                                        BUG6512
     C                   PARM                    BKST              2                         BUG6512
     C                   PARM                    DSPBK             1                         BUG6512
      *                                                                                      BUG6512
      * Error fields/message IDs/message data (arrays) from/to caller                        BUG6512
     C                   PARM                    FldNameArr                                  BUG6512
     C                   PARM                    MsgIdArr                                    BUG6512
     C                   PARM                    MsgDtaArr                                   BUG6512
      *                                                                                      BUG6512
      * Array index (3P0) from/to caller                                                     BUG6512
     C                   PARM                    Idx                                         BUG6512
                                                                                             BUG6512
      ** Warning error fields/message IDs/message data (arrays) from/to caller               BUG6512
                                                                                             BUG6512
     C                   PARM      *BLANKS       WFldNamArr                                  BUG6512
     C                   PARM      *BLANKS       WMsgIdArr                                   BUG6512
     C                   PARM      *BLANKS       WMsgDtaArr                                  BUG6512
                                                                                             BUG6512
      ** Warning array index (3P0) from/to caller                                            BUG6512
                                                                                             BUG6512
     C                   PARM      *ZEROS        WIdx                                        BUG6512
                                                                                             BUG6512
     C                   ENDSR                                                               BUG6512
      **********************************************************************                 BUG6512
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
