     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Non Currency OTC Retrieve a Record')          *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options module                           *
      *                                                               *
      *  FFOTCOR   - FF Non Currency OTC Retrieve a record            *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG8163            Date 16Aug05               *
      *                 BG9185             Date 08Nov05               *
      *                 BUG4258            Date 13Sep04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 23Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8163 - Timestamp not shown after completion               *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  BUG4258- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time.      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Creation of wrappers for use with front end.        *
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
 
     D OTCOScnFmt    E DS                  EXTNAME(FFOTCOPD)
     D  NewPBScn             219    244
      * Transaction in  screen format
 
     D NewCuStScn    E DS                  EXTNAME(FFCSETPD)
      ** New Customer Settlement details in screen format
 
     D NewBrStScn    E DS                  EXTNAME(FFBSETPD)
      ** New broker settlement details in screen format
                                                                                             BUG4258
     D***ExtData       E DS                  EXTNAME(FFOTEXPD)                       BUG4258 BUG8163
      * Extra data in file format                                                            BUG4258
 
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D OTCOFilFmt    E DS                  EXTNAME(TRANSD)
      ** Transaction in file format
 
     D OTSTFilFmt    E DS                  EXTNAME(TRSETD)
     D                                     PREFIX(@)
      ** Transaction Settlement details in file format
 
     D InstType      E DS                  EXTNAME(INTYPD)  PREFIX(IT)
      ** Market centre details
 
     D DTRNO_In        DS
      ** Key fields data structure
      **-----------------------------------------------------------------------
 
     D Idx             S              3P 0
      ** Index for arrays of of error message ids etc
 
     D WIdx            S              3P 0
      ** Index for arrays of warning message ids etc
 
      ** Standing Data files
      ** ~~~~~~~~ ~~~~ ~~~~~
      ** passed as data structures to lower level modules.
      **
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Modules details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger ICD
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** Portfolio Management ICD
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  DEALACCD     E                     EXTFLD(QQACCD)
      ** Dealing ICD
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SLCD         E                     EXTFLD(LCD)
      ** Switchable Features Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access programs
 
      ** +--------------------------------------+                                            BUG4258
      ** ¦ Declared work variables              ¦                                            BUG4258
      ** +--------------------------------------+                                            BUG4258
     D SPREM           S             15A                                                     BUG4258
     D NEWINST         S              1A                                                     BUG4258
                                                                                             BUG4258
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDTRNO_In         6
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
     C                   EVAL      MsgFArray(1) = 'FFUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,FFOTCO02
 
      ** Access Bank details via access program
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Get the module flags
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Get the General Ledger ICD
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Access Dealing ICD
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
      ** Get the portfolio ICD
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   ENDIF
 
      ** Access SAR Details to determine whether Enhanced OTCs is present
     C                   EVAL      CFF001 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFF001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *blank
     C                   EVAL      CFF001 = 'Y'
     C                   ENDIF
 
      ** Determine if CFF007 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFF007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CFF007
     C                   ELSE
     C                   MOVE      'N'           CFF007
     C                   ENDIF
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   OTCOFilFmt
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
     C                   EXSR      FFOTCORED
     C                   ELSE
     C                   MOVEL     DDTRNO_In     @TRRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If transaction read and no error message returned
     C                   IF        RetCodeOut = *BLANK and
     C                             @TRRED <> *Blank
      *
      * Retrieve transaction details (all key fields required for call to rtv module)
     C                   MOVEL     @TRRED        DDTRNO
     C                   EXSR      FFOTCORTV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      FFOTCOCVT
     C                   EXSR      ZASETINCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        RetCodeOut <> *BLANK OR @ERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDTRNO'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   MOVE      TMST          @TimeStamp       26                         BUG4258
     C                   EVAL      Buffer = OTCOScnFmt + NewCuStScn
     C**********                            + ExtData                                BUG4258 BUG8163
     C                                      + @TimeStamp                                     BUG4258
     C                             + SPREM + NEWINST                                         BUG4258
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     FFOTCORED     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FFOTCORED'
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * TRANSACTION NUMBER POINTER
     C                   PARM      DDTRNO_In     DDTRNO            6
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * Bank details
     C                   PARM                    SDBANK
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * TRANSACTION NUMBER READ
     C                   PARM      *BLANK        @TRRED            6
 
     C                   ENDSR
      **********************************************************************
     C     FFOTCORTV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FFOTCCRTV'
 
      * INPUTS
 
      * Return code
     C                   PARM                    RetCodeOut
 
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      *BLANKS       ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE        1
 
      * Action Code
     C                   PARM                    DDACTN            1
      * Front Office Transaction ID (20A)
     C                   PARM                    FOTRID           20
 
      * Parm all Key fields required e.g.
     C                   PARM                    DDTRNO
 
      ** Module being called as linked enquiry (1A)
     C                   PARM      'N'           LnkEnq            1
      * Standing Data and multi-branching indicator
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    BGMBIN
 
      ** Transaction type
 
     C                   PARM      'OTCO'        TransType         4
 
      * OUTPUTS
 
      * (Current) transaction in file format
     C                   PARM                    OTCOFilFmt
 
      ** (Current) transaction settlement details in file format
     C                   PARM                    OTSTFilFmt
      ** Instrument Types
     C                   PARM                    InstType
 
      * OK - Action code
     C                   PARM      *BLANKS       DDActnOK          1
 
      * OK - Transaction Number
     C                   PARM      *BLANKS       DDTRnoOK          1
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
 
 
     C                   ENDSR
      **********************************************************************
     C     FFOTCOCVT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'FFOTCOCVT'
      * INPUTS
      * Return Code
     C                   PARM                    RetCodeOut
      * (Current) Transaction in file format
     C                   PARM                    OTCOFilFmt
      * Instrument types
     C                   PARM                    InstType
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDDEAL
     C                   PARM                    SDMMOD
     C                   PARM                    SDPORT
      ** CFF001 Enhancement
     C                   PARM                    CFF001            1
      ** CFF007 Enhancement
     C                   PARM                    CFF007            1
 
      * OUTPUTS
      * (Current) Transaction in screen format
     C                   PARM                    OTCOScnfmt
      * Premium
     C                   PARM                    SPREM            15
      * Transaction Status
     C                   PARM                    FFSTS            24
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     ZASETINCVT    BEGSR
      *
 
     C                   EVAL      CustBrokFl = 'C'
 
     C                   CALLB     'FFSETLCVT'
      *
      * Outputs
      * ~~~~~~~
      ** Return code (10A, returned to caller)
     C                   PARM      *BLANKS       RetCodeOut
      ** Customer settlement instructions, screen format
     C                   PARM                    NewCuStScn
      ** Broker settlement instructions, screen format
     C                   PARM                    NewBrStScn
      *
      * Inputs
      * ~~~~~~
      * Settlements in file format
     C                   PARM                    OTSTFilFmt
      ** Customer/broker flag (1A)
     C                   PARM                    CustBrokFl        1
      ** Midas Transaction Number
     C                   PARM                    DDTRNO
      ** Instrument currency
     C                   PARM                    ISCY
      *
     C                   ENDSR
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
