     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Market Trades Enquiry')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFEXTRenq - Futures and Options Screen enquiry               *
      *             (Exchange-Traded)                                 *
      *                                                               *
      *  Function:  This is the main screen enquiry function          *
      *             for Futures and Options.                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BG9185             Date 08Nov05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS002             Date 14Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 13Feb01               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CGL007 *Create     Date 26Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS002 - Hedge Strategy/Linkage (Recompile)                  *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  CGL007 - Account Postings Enquiry                            *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRP002 - Retrieve Transaction                                *
      *  SRP003 - Put A Transaction on the Main Details Screen        *
      *  SRP004 - Process Screen: Main Details                        *
      *  SRP005 - End Program                                         *
      *  SRP006 - Cancel on Main Details Screen                       *
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the FF standard declares:
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
      *
     D/COPY ZACPYSRC,FVAL_ARRAY
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
     D/COPY QWINDSRC,FFTRANSDTA
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Transaction Details - File Format
      *
     D CurTranFil    E DS                  EXTNAME(TRANSD)
      ** Current transaction in file format
      *
      ** Transaction Details - Screen Format
      *
     D NewTranScn    E DS                  EXTNAME(FFEXTRPD)
      ** New transaction in screen format
      *
      ** Transaction Details - OK Flags
      *
     D OKTransDet    E DS                  EXTNAME(FFEEXTRPD)
      ** External data structure for transaction details OK flags
      *
      ** Customer and Broker Settlement Details - File Format
      *
     D CurTrstFil    E DS                  EXTNAME(TRSETD)
      ** Settlements in file format
     D                                     PREFIX(ST)
      *
      ** Customer Settlement Details - Screen Format
      *
     D NewCuStScn    E DS                  EXTNAME(FFCSETPD)
      ** New Customer Settlement details in screen format
      *
      ** Broker Settlement Details - Screen Format
      *
     D NewBrStScn    E DS                  EXTNAME(FFBSETPD)
      ** New broker settlement details in screen format
      *
      ** Settlement Details - OK Flags
      *
     D OKBrokSet     E DS                  EXTNAME(FFEBSETPD)
      ** External data structure for broker settlement flags
      *
     D OKCustSet     E DS                  EXTNAME(FFECSETPD)
      ** External data structure for customer settlement flags
      *
     D InstType      E DS                  EXTNAME(INTYPD)  PREFIX(IT)
      ** Instrument types
      *
      ** Screen Control Indicators
      *
     D @CCI@M          DS
      ** Current Control Indicators for main details screen
      *
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKG                 3      3
     D  @EINKH                 4      4
     D  @EINKJ                 5      5
     D  @EINKP                 7      7
      *
     D @PCI@M          DS             7
      ** Previous Control Indicators for main detail screen
      *
      ** Standing Data files
      ** passed as data structures to lower level modules.
      **
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Modules details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger ICD
      *
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                    CPM003
      ** Portfolio Management ICD
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  #ACCD1       E                     EXTFLD(QQACCD)                                     CGL029
      ** Dealing ICD
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFF007
     D  SLCD         E                     EXTFLD(LCD)                                        CFF007
      ** Switchable Features Details                                                          CFF007
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access programs
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
      *
     D RespMode        S              1A   INZ('S')
      *
      ** Enhanced OTCs feature flag (not used, but passed as a blank PARM)
      *
     D CustBrokFl      S              1A
      ** Customer/Broker Flag (B = Broker, C = Customer)
      *
     D LinkEnq         S              1A   INZ('N')
      ** Flag to indicate that the FFEXTRRTV is not being called
      ** as a linked enquiry.
      *                                                                                       CFF007
     D Idx             S              3P 0                                                    CFF007
      ** Index for arrays of of error message ids etc                                         CFF007
      *                                                                                       CFF007
     D CFF007          S              1A                                                      CFF007
      ** CFF007 enhancement                                                                   CFF007
      *                                                                                       CFF007
     D PSARD           S              6A                                                      CFF007
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P001 - Main Processing                                       *
      *                                                               *
      *  Calls:     SRP002 - Retrieve Transaction                     *
      *             SRP003 - Put a Transaction on the Main Details    *
      *                      Screen                                   *
      *             SRP004 - Process Screen: Main Details             *
      *                                                               *
      *****************************************************************
      *
     C                   EXSR      SRP002
      *
     C                   If        OKACTN = 'N' or OKTNBR = 'N'
     C                             or OKMRKT = 'N'
     C                   Eval      PRET = 'E'
     C                   ELSE
     C                   EXSR      SRP003
     C                   ENDIF
      *
     C                   DOW       PRET = *blanks
     C                   EXSR      SRP004
     C                   ENDDO
      *
     C                   Eval      *INLR = *On
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP002 - Retrieve Transaction                                *
      *                                                               *
      *  Called By: P001   - Main Processing                          *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRP002        BEGSR
      *
     C                   CALLB     'FFEXTRRTV'
      *
      ** Return code
      *
     C                   PARM                    ReturnCode
      *
      ** Inputs
      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface) (6A)
      *
     C                   PARM      '      '      @@MODE            6
      *
      ** Response mode (1A)
      *
     C                   PARM      'S'           @@RSMD            1
      *
      ** Action Code (1A)
      *
     C                   PARM      PACT          SACTN
      *
      ** Front Office Transaction ID (20A)
      *
     C                   PARM                    FOTRID           20
      *
      ** (Midas) Transaction Number (6A)
      *
     C                   PARM      WREF          STNBR
      *
      ** (Midas) Market (2A)
      *
     C                   PARM      PMKT          SMRKT
      *
      ** Module being called as linked enquiry (1A)
      *
     C                   PARM      'Y'           LinkEnq
      *
      ** Bank details ICD
      *
     C                   PARM                    SDBANK
      *
      ** General Ledger ICD
      *
     C                   PARM                    SDGELR
      *
      ** Multibranching indicator
      *
     C                   PARM                    BGMBIN
      *
      ** Outputs
      ** Current transaction in file format
      *
     C                   PARM                    CurTranFil
      *
      ** Current settlements in file format
      *
     C                   PARM                    CurTrstFil
      *
      ** Instrument types
      *
     C                   PARM                    InstType
      *
      ** OK - Action code (1A)
      *
     C                   PARM      *BLANK        OKACTN
      *
      ** OK - Transaction Number (1A)
      *
     C                   PARM      *BLANK        OKTNBR
      *
      ** OK - Market (1A)
      *
     C                   PARM                    OKMRKT            1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
      *
     C**********         PARM      *ZERO         Idx               1                          CFF007
     C                   PARM      *ZERO         Idx                                          CFF007
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP003 - Put a Transaction on the main Details Screen        *
      *                                                               *
      *  Called By: P001   - Main Processing                          *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRP003        BEGSR
      *
      ** Call program to fill screen fields with data from TRANSD
      *
     C                   CALLB     'FFEXTRCVT'
      *
      ** Inputs
      *
     C                   PARM                    ReturnCode
      *
      ** Transaction in file format
      *
     C                   PARM                    CurTranFil
      *
      ** ICD
      *
     C                   PARM                    SDBANK
     C                   PARM                    SDDEAL
     C                   PARM                    SDMMOD
     C                   PARM                    SDPORT
      *
      ** Outputs
      ** Transaction in screen format
      *
     C                   PARM                    NewTranScn
      *
      ** Transaction Status
      *
     C                   PARM                    FFSTS            24
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      *
     C                   EVAL      CustBrokFl = 'B'
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLCVT'
      *
      ** Outputs
      ** Return code (10A, returned to caller)
      *
     C                   PARM                    ReturnCode
      *
      ** Customer settlement instructions, screen format
      *
     C                   PARM                    NewCuStScn
      *
      ** Broker settlement instructions, screen format
      *
     C                   PARM                    NewBrStScn
      *
      ** Inputs
      ** Settlements in file format
      *
     C                   PARM                    CurTrstFil
      *
      ** Customer/broker flag (1A)
      *
     C                   PARM                    CustBrokFl
      *
      ** Midas Transaction Number
      *
     C                   PARM                    STNBR
      *
      ** Instrument currency
      *
     C                   PARM                    ISCY
      *
     C                   EVAL      CustBrokFl = 'C'
      *
     C                   RESET                   ReturnCode
     C                   CALLB     'FFSETLCVT'
      *
      ** Outputs
      ** Return code (10A, returned to caller)
      *
     C                   PARM                    ReturnCode
      *
      ** Customer settlement instructions, screen format
      *
     C                   PARM                    NewCuStScn
      *
      ** Broker settlement instructions, screen format
      *
     C                   PARM                    NewBrStScn
      *
      ** Inputs
      ** ~~~~~~
      ** Settlements in file format
      *
     C                   PARM                    CurTrstFil
      *
      ** Customer/broker flag (1A)
      *
     C                   PARM                    CustBrokFl
      *
      ** Midas Transaction Number
      *
     C                   PARM                    STNBR
      *
      ** Instrument currency
      *
     C                   PARM                    ISCY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP004 - Process Screen: Main Details                        *
      *                                                               *
      *  Called By: P001   - Main Processing                          *
      *                                                               *
      *  Calls:     SRP005 - End Program                              *
      *             SRP006 - Cancel on Main Details Screen            *
      *                                                               *
      *****************************************************************
 
     C     SRP004        BEGSR
      *
      ** Write/read display screen
      *
     C                   CALLB     'FFEXTRDSP'
     C                   PARM                    ReturnCode
      *
      ** Transaction (In Screen Format)
      *
     C                   PARM                    NewBrStScn
     C                   PARM                    NewCuStScn
     C                   PARM                    NewTranScn
      *
      ** Transaction Status
      *
     C                   PARM                    FFSTS            24
      *
      ** ICD
      *
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
      *
      ** Fields In Error
      *
     C                   PARM                    OKBrokSet
     C                   PARM                    OKCustSet
     C                   PARM                    OKTransDet
      *
      ** Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Disable Key & Detail Fields
      *
     C                   PARM      'N'           @EKYFD            1
     C                   PARM      'N'           @EDTFD            1
      *
      ** Disable Function Keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Confirm Delete
      ** KP = Command Key 15 = Browse
      *
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKJ            1
     C                   PARM      'N'           @EINKP            1
     C**********         PARM      'N'           @EINKT            1                          CFF007
      *
      ** Succesful Insert Transaction
      *
     C                   PARM                    @SIDN             6
      *
      ** Output Parameters
      *
      ** Function Keys
      *
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKP             1
     C**********         PARM                    @INKT             1                          CFF007
      *
      ** Write screen with no read indicator
      *
     C                   PARM      'N'           WriteOnly
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
      *
      ** Reset Errors
      *
     C                   MOVE      *ALL'Y'       OKBrokSet
     C                   MOVE      *ALL'Y'       OKCustSet
     C                   MOVE      *ALL'Y'       OKTransDet
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** F3 - End Program
      *
     C     @INKC         CASEQ     '1'           SRP005
      *
      ** F12 - Cancel on Main Details Screen
      *
     C     @INKL         CASEQ     '1'           SRP006
      *
     C                   ENDCS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP005 - End Program                                         *
      *                                                               *
      *  Called By: SRP004 - Process Screen: Main Details             *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRP005        BEGSR
      *
     C                   MOVEL     'Q'           PRET
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP006 - Cancel on Main Details Screen                       *
      *                                                               *
      *  Called By: SRP004 - Process Screen: Main Details             *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRP006        BEGSR
      *
     C                   MOVEL     'P'           PRET
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *  Called By: P001   - Main Processing                          *
      *                                                               *
      *  Calls:     AOBANKR0 - Bank ICD Access Object                 *
      *             AOMMODR0 - Midas Module Access Object             *
      *             AOGELRR0 - General Ledger Details Access Object   *
      *             AODEALR0 - Dealing ICD Access Object              *
      *             AOPORTR0 - Portfolio Management Access Object     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Access Bank details via access program
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Get the module flags
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Get the General Ledger ICD
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Access Dealing ICD
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      ** Get the portfolio ICD
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   ENDIF
                                                                                              CFF007
      ** Determine if CFF007 is installed                                                     CFF007
                                                                                              CFF007
     C                   CALLB     'AOSARDR0'                                                 CFF007
     C                   PARM      *BLANKS       @RTCD                                        CFF007
     C                   PARM      '*VERIFY'     @OPTN                                        CFF007
     C                   PARM      'CFF007'      PSARD                                        CFF007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFF007
                                                                                              CFF007
     C     @RTCD         IFEQ      *BLANKS                                                    CFF007
     C                   MOVE      'Y'           CFF007                                       CFF007
     C                   ELSE                                                                 CFF007
     C                   MOVE      'N'           CFF007                                       CFF007
     C                   ENDIF                                                                CFF007
                                                                                              CFF007
      *
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C     *ENTRY        PLIST
     C                   PARM                    PACT              1
     C                   PARM                    PREF              6 0
     C                   PARM                    PMKT              2
     C                   PARM                    PRET              1
      *
     C                   Move      PREF          WREF              6
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
