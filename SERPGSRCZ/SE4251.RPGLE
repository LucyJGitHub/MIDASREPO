     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Request of securities statement')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE4251 - Midas SE Request of Securities Statement Maint.     *
      *                                                               *
      *  Function:  This module handles the input and the validation  *
      *             of the request of Securities Statement.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CSE040   *CREATE   Date 19Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
 
     FSERQSTL0  UF A E           K DISK    COMMIT  PREFIX(Up_)
      ** Midas SE Request of Securities Statement - Update
     F                                     INFSR(*PSSR)
 
     FSERQSTL1  IF   E           K DISK    RENAME(SERQSTD0:SERQSTD1)
      ** Midas SE Request of Securities Statement - Index
     F                                     INFSR(*PSSR)
 
     FSERQSTL2  IF   E           K DISK    RENAME(SERQSTD0:SERQSTD2)
      ** Midas SE Request of Securities Statement by Custodian, Type, Branches
     F                                     INFSR(*PSSR)
 
     FSESTHSL0  UF A E           K DISK    COMMIT  INFSR(*PSSR)
      ** Midas SE Statement History by Message Reference
 
     FSERSTRL0  UF A E           K DISK    COMMIT  PREFIX(Up_)
      ** Midas SE Request of Securities Statement - Repetitive information - Update
     F                                     INFSR(*PSSR)
 
     FSERSTRL1  IF   E           K DISK    RENAME(SERSTRD0:SERSTRD1)
      ** Midas SE Request of Securities Statement - Repetitive information - Index
     F                                     INFSR(*PSSR)
 
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
      ** Midas Security Details
 
     FDPOSNL    IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Depot Position
 
     FSDSECSL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Securities clients retrieval
 
     FMGRQSTPD  O    E             DISK    USROPN INFSR(*PSSR)
      ** Midas MG Request of SE Statement - Driver
 
     FMGRSTRPD  O    E           K DISK    USROPN INFSR(*PSSR)
      ** Midas MG Request of SE Statement - Repetitive
 
     FSE4251DF  CF   E             WORKSTN
      ** Midas SE Request of Securities Statement - Display
     F                                     SFILE(SE4251S0:C0RRN)
     F                                     SFILE(SE4251S1:C1RRN)
      *
 
      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Display Conditioning Indicators                                        *
      *                                                                        *
      * 01 - Allow Use of the F10 Key                                          *
      * 02 - Allow Use of the F11 key                                          *
      * 27 - Access LF/SERSTRL1 file                                           *
      * 36 - Protect Fields - Prohibit Refresh                                 *
      *                                                                        *
      * Error Indicators                                                       *
      *                                                                        *
      * 40 - General Error Indicator                                           *
      * (The DS IN40_TO_70 is used to cover the whole set of reserved error    *
      *  indicators)                                                           *
      *                                                                        *
      * Subfile Management Indicators                                          *
      *                                                                        *
      * 23 - SFLEND (Messages Subfile)                                         *
      *                                                                        *
      * Action key Indicators                                                  *
      *                                                                        *
      * KC - Exit Program                                                      *
      * KE - Refresh Screen                                                    *
      * KJ - Confirm Deletion                                                  *
      * KL - Previous Screen                                                   *
      *                                                                        *
      * Database Error Indicators                                              *
      *                                                                        *
      * U7 - Abnormal Completion                                               *
      * U8 - File Out of Balance                                               *
      * U7 + U8 - Database Error                                               *
      *                                                                        *
      * Other Indicators                                                       *
      *                                                                        *
      * 98 - Date format flag (*On if MDY / *Off if DMY)                       *
      * 99 - Multi-purpose                                                     *
      *                                                                        *
      *========================================================================*
 
      *========================================================================*
      ** Automatically included D-specs
      ** ==============================
      *
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      ** Manually included D-specs
      ** =========================
      *
 
      ** Named constants
      ** ---------------
      *
 
      ** Arrays and Data Structures
      ** --------------------------
      *
 
      ** Data to be passed to the window controller
      *
      /COPY QWINDSRC,SE4251DTA
 
      **  Arrays to retrieve the status of the request.
     D                 DS
     D Status                        11    DIM(6) CTDATA PERRCD(1)
     D    StatusID                    1    OVERLAY(Status)
     D    StatusText                 10    OVERLAY(Status:*NEXT)
 
     D DsSFL0        E DS                  EXTNAME(SE4251DF:SE4251S0)
      ** Data structure to redefine Sub-file 0 - Status/reason Code
     D   DsSfl0Seq                   13    OVERLAY(DsSFL0:1)
     D   DsSfl0Dtl                   26    Overlay(DsSFL0:14)
 
     D DsSFL1        E DS                  EXTNAME(SE4251DF:SE4251S1)
      ** Data structure to redefine Sub-file 1 - Reference Code
     D   DsSfl1Seq                   13    OVERLAY(DsSFL1:1)
     D   DsSfl1Dtl                   20    Overlay(DsSFL1:14)
 
     D WkMsgRef        DS
      ** DS used to retrieve the message reference
     D  WkModId                       2    INZ('SE')                            Module Id
     D  WkRQCUST                           LIKE(RQCUST)                         SafeKeeping Customer
     D  CurSWIFTDt                    6                                         Current Swift Date
     D  WkMsgSeq                      2S 0                                      Message Sequence
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** Standing Data Dataarea
      *
 
     D DsUSER        E DS                  EXTNAME(MUSERDD)
      ** User details record format data structure
      *
 
     D DsCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer details record format data structure
      *
 
     D DsBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFAC1      E                     EXTFLD(QQDFAC)                                     CGL029
      ** Branch details record format data structure
      *
 
     D DsRQST        E DS                  EXTNAME(SERQSTPD)
      ** Request of Securities Statements
      *
 
     D DsUpRQST      E DS                  EXTNAME(SERQSTPD) Prefix(Up_)
      ** Request of Securities Statements
      *
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS (short) used as output parameter for Access Objects
      *
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects
      *
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** DS (longest) used as output parameter for Access Objects
      *
 
      ** Declared variables
      ** ------------------
      *
     D RequestDate     S              5P 0                                      Request Date
     D RequestSeq      S              5P 0                                      Request Sequence
     D DefaultCust     S              6                                         Default Custodian
 
     D Idx             S              5U 0                                      Index
     D Idy             S              5U 0                                      Index
     D Sav0RRN         S              5U 0                                      Save RRN
     D Sav1RRN         S              5U 0                                      Save RRN
     D SflToShow       S              1A                                        Subfile to Show S/R
     D First0Err       S              5U 0                                      First RRN in Error
     D First1Err       S              5U 0                                      First RRN in Error
 
     D SavActCode      S                   LIKE(ActionCode)                     Save Action Code
 
     D SavCUST         S                   LIKE(F0CUST)                         Save Custodian Nb.
     D SavORIG         S                   LIKE(F0ORIG)                         Save Original Branch
 
     D SavRQST         S                   LIKE(DsRQST)                         Save Request details
 
     D SavSfl0Dtl      S                   LIKE(DsSfl0Dtl)                      Save Subfile 0 Dtls
     D SavSfl1Dtl      S                   LIKE(DsSfl1Dtl)                      Save Subfile 1 Dtls
 
     D WkIntCust       S                   LIKE(A8BICN)                         Branch Internal Cust
     D WkMSTD          S                   LIKE(RQMSTD)                         Working Start Date
     D WkMETD          S                   LIKE(RQMETD)                         Working End Date
 
     D StartDate       S               D   DATFMT(*ISO) INZ(D'1971-12-31')      Start Date
     D WkDate          S               D   DATFMT(*ISO)                         Working Date
     D DftDate         S                   LIKE(F0MSTD)                         Default Run date
 
     D KDate           S                   LIKE(RQDATE)                         Request Input Date
     D KReqSeq         S                   LIKE(RQRSEQ)                         Request Sequence
     D*KCustNb**       S              6  0                                    Customer Number CSD027
     D KCustNb         S              6A                                        Customer Numb CSD027
 
      ** Error Indicators Array
      *
     D IN40_TO_70      S              1    DIM(31)
 
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *
 
      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C     SavActCode    PARM                    ActionCode
     C                   PARM                    CallerIn         10
     C                   PARM                    RequestDate
     C                   PARM                    RequestSeq
     C                   PARM                    DefaultCust
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR subroutine
 
      ** Main loop until F3 or F10 or F12 or no error
      *  ============================================
 B1  C                   DOU       *INKC OR *INKJ OR *INKL OR NOT *IN40
 
      ** -- Display the screens
      *     -------------------
      *
     C                   WRITE     SE4251H0                                     Header
     C                   WRITE     #MSGCTL                                      Bottom
     C                   WRITE     SE4251F0                                     Details
 
     C                   IF        SflToShow = 'S'                              Subfile Status
     C                   EXFMT     SE4251C0
     C                   ELSE                                                   Subfile Reference
     C                   EXFMT     SE4251C1
     C                   ENDIF
 
      ** -- Clear the program message queue and the error indicators
      *     --------------------------------------------------------
     C                   EXSR      $ClrErrSF
     C                   MOVEA     *Zeros        IN40_TO_70
     C                   MOVEA     IN40_TO_70    *IN(40)
 
      ** -- Action keys management
      *     ----------------------
      ** ---- F3 ==> Exit program
      *
 B2  C                   IF        *INKC
     C                   MOVEL(P)  '*EXIT'       RetCodeOut
     C                   ITER
 E2  C                   ENDIF
 
      ** ---- F5 ==> Refresh the screen
      *
 B2  C                   IF        *INKE
     C                   EXSR      $IniScreen
     C                   EXSR      $InitSFL
     C                   EVAL      *IN40 = *On
     C                   ITER
 E2  C                   ENDIF
 
      ** ---- F10 ==> Confirm deletion of the record
      *
 B2  C                   IF        ActionCode = 'D'
 B2  C                             AND NOT *INKJ
     C                   MOVE      'ST00001'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   EVAL      *IN40 = *On
     C                   ITER
 E2  C                   ENDIF
 
      ** ---- F11 ==> Toggle Status/Reason Code to Reference Code
      *
 B2  C                   IF        *INKK
     C                   IF        SflToShow = 'S'                              Subfile Status
     C                   EVAL      SflToShow = 'R'
     C                   ELSE
     C                   EVAL      SflToShow = 'S'
     C                   ENDIF
     C                   EXSR      $InitSFL
     C                   EVAL      *IN40 = *On
     C                   ITER
 E2  C                   ENDIF
 
      ** ---- F12 ==> Return to the previous screen
      *
 B2  C                   IF        *INKL
     C                   MOVEL(P)  '*PRV'        RetCodeOut
     C                   ITER
 E2  C                   ENDIF
 
      ** ---- F24 ==> Confirm the release of message
      *
      ** There is 2 manners to release a message:
      ** - Action Code 'R' from browse
      ** - Action Code 'I' or 'A', with the possibility to release the message
      **   In this case, if the user do not press F24, the processing stops.
      *
 B2  C                   IF        ActionCode = 'R'
 B2  C                             AND NOT *INKY
     C                   IF        SavActCode = 'R'
     C                   MOVE      'ST00032'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   EVAL      *IN40 = *On
     C                   ITER
     C                   ELSE
     C                   EXSR      $ExitMod
 E2  C                   ENDIF
 E2  C                   ENDIF
 
      ** ---- Roll Up ==> Load blank lines
      *
 B2  C                   IF        *IN25
     C                   IF        SflToShow = 'S'                              Subfile Status
     C                   EXSR      $FilSFL0
     C                   ELSE
     C                   EXSR      $FilSFL1
 E2  C                   ENDIF
     C                   EVAL      *IN40 = *ON
     C                   ITER
 E2  C                   ENDIF
 
      ** -- Validate the screen
      *     -------------------
 
     C                   IF        ActionCode = 'I'                             Insert
     C                             OR ActionCode = 'A'                          Amend
     C                             OR ActionCode = 'R'                          Release
     C                   EXSR      $ValidatSc
     C                   ENDIF
 
      ** -- Window processing if no validation error
      *     -----------------
 B2   *
     C  N40              EXSR      $Window
 E2   *
      ** -- Update database
      *     ---------------
 
     C                   IF        ActionCode <> 'E'
     C  N40              EXSR      $UpdateDb
     C                   ENDIF
 
      ** -- Prepare Release for routing officer
      *     -----------------------------------
 
     C                   IF        ActionCode = 'I'
     C                             OR ActionCode = 'A'
     C  N40              EXSR      $PrRelease
     C                   ENDIF
 
 E1  C                   ENDDO
 
      ** Exit module
      *
     C                   EXSR      $ExitMod
 
      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*
 
      *========================================================================*
      * $ValidatSc: Validate the screen                                        *
      *------------------------------------------------------------------------*
     C     $ValidatSc    BEGSR
      *    ----------    ------
 
      ** Set up error indicators
      *
     C                   MOVEA     IN40_TO_70    *IN(40)
 
     C                   EVAL      WkIntCust = *Blanks                          Internal Customer
     C                   EVAL      F0DREF = *Blanks                             Depot Reference
     C                   EVAL      WkMSTD = *Zeros                              Start Date
     C                   EVAL      WkMETD = *Zeros                              End Date
      *
     C                   READ      SE4251F0
 
      ** Priority / Delivery Notification
      *  --------------------------------
 
     C                   IF        F0PRTY = *Blanks
     C                   EVAL      F0PRTY = 'N'                                 Priority
     C                   ENDIF
      *
     C                   IF        F0NOTF = *Blanks
     C                   EVAL      F0NOTF = '2'                                 Delivery Notificat.
     C                   ENDIF
      *
     C                   IF        %SCAN('?':F0PRTY) > *ZEROS
     C                             OR %SCAN('?':F0NOTF) > *ZEROS
     C                   CALL      'Y2VLLSR'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      1215011       @Y2LS
     C                   PARM      *BLANKS       @INVL
     C                   IF        @RtCd  = *Blanks
     C                   EVAL      F0PRTY = %SUBST(@INVL:1:1)
     C                   EVAL      F0NOTF = %SUBST(@INVL:3:1)
     C                   ENDIF
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
      *
     C                   EVAL      @INVL = F0PRTY + ' ' + F0NOTF
      *
     C                   CALL      'Y2RVCNR'                                    Text of Frequency
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      1215011       @Y2LS
     C                   PARM                    @INVL
     C                   PARM      *BLANK        @VLMP
     C                   PARM                    @TEXT
     C                   IF        @Rtcd <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN42 = *ON
     C                   MOVE      'ST00002'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
 
 
      ** Sending Branch
      *  --------------
     C                   IF        F0SNDR = *Blanks                             Default
     C                   EVAL      F0SNDR = DBRN
     C                   ENDIF
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      F0SNDR        @Brch             3
     C*****DsBRCH        PARM                    DSFDY                                        CGL029
     C     DsBRCH        PARM                    DSSDY                                        CGL029
     C                   IF        @RtCd <> *Blanks                             Invalid branch
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN43 = *ON
     C                   MOVE      'ST00003'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
      *
     C                   IF        %SCAN('?':F0SNDR) > *Zeros                   If selection
     C                   EVAL      *IN40 = *ON
     C  N41              EVAL      F0SNDR = A8BRCD
     C                   ENDIF
 
      ** The branch should have a TID Address
      *
     C                   IF        A8BTID = *Blanks
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN43 = *ON
     C                   MOVE      'ST00004'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
 
      ** The user should be authorized to the branch
      *
     C                   IF        NOT *IN43
     C  N37              CALL      'ZVACTU'
     C                   PARM      ActionCode    @ZACTN            1
     C                   PARM      *Zeros        @ERR              1 0
     C   37              CALL      'ZVACTBU'
     C                   PARM      ActionCode    @ZACTN
     C                   PARM      F0SNDR        @ZBR              3
     C                   PARM      *Zeros        @ERR
      *
     C     @ERR          IFNE      *Zeros
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN43 = *ON
     C                   MOVE      'ST00031'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
     C                   ENDIF
 
      ** Originating Branch
      *  ------------------
      ** If the originating branch is blank or the Midas system has only one branch,
      ** load the sending branch into Originating branch.
      *
     C                   IF        F0ORIG = *Blanks
     C                             OR AGMBIN = 'N'
     C                   EVAL      F0ORIG = F0SNDR
     C                   ENDIF
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      F0ORIG        @Brch             3
     C*****DsBRCH        PARM                    DSFDY                                        CGL029
     C     DsBRCH        PARM                    DSSDY                                        CGL029
     C                   IF        @RtCd <> *Blanks                             Invalid branch
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN44 = *ON
     C                   MOVE      'ST00005'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
 
     C                   IF        %SCAN('?':F0ORIG) > *Zeros
     C                   EVAL      *IN40 = *ON
     C  N44              EVAL      F0ORIG = A8BRCD
     C                   ENDIF
 
     C  N44              EVAL      WkIntCust = A8BICN                           Internal Account
 
      ** The user should be authorized to the branch
      *
     C                   IF        NOT *IN44
     C  N37              CALL      'ZVACTU'
     C                   PARM      ActionCode    @ZACTN            1
     C                   PARM      *Zeros        @ERR              1 0
     C   37              CALL      'ZVACTBU'
     C                   PARM      ActionCode    @ZACTN
     C                   PARM      F0ORIG        @ZBR              3
     C                   PARM      *Zeros        @ERR
      *
     C     @ERR          IFNE      *Zeros
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN44 = *ON
     C                   MOVE      'ST00031'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
     C                   ENDIF
 
      ** Custodian
      *  ---------
 
      ** Selection
      *
     C                   IF        %SCAN('?':F0CUST) > *ZEROS                   Selection
     C                   CALL      'SD0340S'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      *BLANKS       F0CUST
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      F0CUST = *BLANKS
     C                   ENDIF
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
      ** Valid Customer
      *
     C                   CALLB     'AOCUSTR0'                                   Customer Report Name
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      F0CUST        @Key1            10
     C                   PARM                    @Kyst             7
     C     DsCUST        PARM                    DSSDY
     C                   IF        @RtCd <> *Blanks                             Invalid branch
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN45 = *ON
     C                   MOVE      'ST00006'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
 
     C  N45              EVAL      F0CRNM = BBCRNM
     C   45              EVAL      F0CRNM = *Blanks
 
      ** The Customer should be a Security Trading Customer with a Classification M, C, E or X
      *
     C                   IF        NOT *IN45
     C     F0CUST        CHAIN     SDSECSL1
     C                   IF        NOT %FOUND(SDSECSL1)
     C                             OR  BFCLAS <> 'M'                            Market
     C                             AND BFCLAS <> 'X'                            Depot
     C                             AND BFCLAS <> 'E'                            Euroclear
     C                             AND BFCLAS <> 'C'                            Cedel
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN45 = *ON
     C                   MOVE      'ST00034'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
     C                   ENDIF
      *
      ** The Customer should have a SWIFT address.
      *
     C                   IF        BBCSID = *Blanks
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN45 = *ON
     C                   MOVE      'ST00007'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
 
      ** Depot reference
      *
     C                   IF        NOT *IN45
     C                   CALLB     'SEDORFRTV'
     C                   PARM      *Blanks       PReturnCode      10            Return Code
     C                   PARM      F0CUST        PDepotCNum        6            Depot Customer Numb.
     C                   PARM      WkIntCust     PCntrPCNum        6            Counterparty Cust Nb
     C                   PARM                    PSKALRef         20            Safekeeping Ac. Ref.
     C                   IF        PReturnCode <> *Blanks
     C                             OR PSKALRef =  *Blanks
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN45 = *ON
     C                   MOVE      'ST00008'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ELSE
     C                   EVAL      F0DREF = PSKALRef
     C                   ENDIF
     C                   ENDIF
 
 
      ** Send a warning, if the Originating branch does not have depot to this Custodian.
      *
     C                   IF        *IN44                                        Originater in error
     C                             OR *IN45                                     Custodian in error
     C                   EVAL      SavORIG = *BLANKS                            Save Original Branch
     C                   EVAL      SavCust = *Blanks                            Save Customer Nb.
     C                   ELSE
 
     C                   MOVE      F0CUST        KCustNb
     C     KLDepCust     SETLL     DPOSNL
     C                   IF        NOT %EQUAL
     C                             AND SavORIG <> F0ORIG
     C                             OR NOT %EQUAL
     C                             AND SavCUST <> F0CUST
     C                   EVAL      SavCUST = F0CUST                             Save Custodian Nb.
     C                   EVAL      SavORIG = F0ORIG                             Save Original Branch
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN45 = *ON
     C                   MOVE      'ST00009'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
     C                   ENDIF
 
      ** Type of Statement
      *  -----------------
     C                   IF        %SCAN('?':F0STTY) > *ZEROS
     C                   CALL      'Y2VLLSR'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      1215000       @Y2LS
     C     F0STTY        PARM      *BLANKS       @INVL
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
      *
     C                   CALL      'Y2RVCNR'                                    Text of Frequency
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      1215000       @Y2LS
     C                   PARM      F0STTY        @INVL
     C                   PARM      *BLANK        @VLMP
     C     F0STNM        PARM                    @TEXT
     C                   IF        @Rtcd <> *BLANKS
     C                   EVAL      F0STNM = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN46 = *ON
     C                   MOVE      'ST00010'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
 
      ** Frequence
      *  ---------
     C                   IF        F0FREQ = *BLANKS                             Default
     C                   EVAL      F0FREQ = 'Z'
     C                   ENDIF
      *
     C                   IF        %SCAN('?':F0FREQ) > *ZEROS
     C                   CALL      'Y2VLLSR'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      1215001       @Y2LS
     C     F0FREQ        PARM      *BLANKS       @INVL
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
      *
     C                   CALL      'Y2RVCNR'                                    Text of Frequency
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      1215001       @Y2LS
     C                   PARM      F0FREQ        @INVL
     C                   PARM      *BLANK        @VLMP
     C     F0FRNM        PARM                    @TEXT
     C                   IF        @Rtcd <> *BLANKS
     C                   EVAL      F0FRNM = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN47 = *ON
     C                   MOVE      'ST00011'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
 
      ** Start Date
      *  ----------
     C                   IF        F0MSTD = *Blanks
     C                   EVAL      F0MSTD = DftDate                             Start Date
     C                   ENDIF
      *
     C  N98*DMY0         TEST(DE)                F0MSTD
     C   98*MDY0         TEST(DE)                F0MSTD
     C                   IF        %ERROR
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN48 = *ON
     C                   MOVE      'ST00012'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ELSE
     C  N98*DMY0         MOVE      F0MSTD        WkDate
     C   98*MDY0         MOVE      F0MSTD        WkDate
     C     WkDate        SUBDUR    StartDate     WkMSTD:*D
     C                   ENDIF
 
      ** Start Time
      *  ----------
      *
      ** Validate the start time, if inputted,
      ** OR, that the end time is inputted.
      ** Ps. For Movements Full Statement (MF) the both times should be inputted
      **     or both times should be empty.
 
     C                   IF        F0STTM <> *Blanks
     C                             OR F0STTY = 'MF'
     C                             AND F0ENTM <> *Blanks
     C     *ISO0         TEST(ET)                F0STTM
     C                   IF        %ERROR
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN49 = *ON
     C                   MOVE      'ST00013'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
     C                   ENDIF
 
      ** End Date
      *  --------
      ** Only valid for Movements full statement
      *
     C                   IF        F0STTY <> 'MF'
      *
     C                   IF        F0METD <> *Blanks
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN50 = *ON
     C                   MOVE      'ST00014'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
      *
      ** Otherwise,
      *
     C                   ELSE
      *
     C  N98*DMY0         TEST(DE)                F0METD
     C   98*MDY0         TEST(DE)                F0METD
     C                   IF        %ERROR
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN50 = *ON
     C                   MOVE      'ST00015'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ELSE
     C  N98*DMY0         MOVE      F0METD        WkDate
     C   98*MDY0         MOVE      F0METD        WkDate
     C     WkDate        SUBDUR    StartDate     WkMETD:*D
     C                   ENDIF
     C                   ENDIF
 
      ** End Time
      *  --------
      *
      ** Only valid for Movements full statement
      *
     C                   IF        F0STTY <> 'MF'
      *
     C                   IF        F0ENTM <> *Blanks
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN51 = *ON
     C                   MOVE      'ST00016'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
      *
      ** Otherwise,
      *
     C                   ELSE
      *
      ** Validate the start time, if inputted,
      ** OR, that the end time is inputted.
      ** Ps. For Movements Full Statement (MF) the both times should be inputted
      **     or both times should be empty.
      *
     C                   IF        F0ENTM <> *BLANKS
     C                             OR F0STTM <> *BLANKS
     C     *ISO0         TEST(ET)                F0ENTM
     C                   IF        %ERROR
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN51 = *ON
     C                   MOVE      'ST00017'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** The end date/time should be greater than start date/time
      *
     C                   IF        F0STTY = 'MF'
     C                             AND *IN48 = *Off
     C                             AND *IN49 = *Off
     C                             AND *IN50 = *Off
     C                             AND *IN51 = *Off
     C                   IF        WkMSTD > WkMETD
     C                             OR  WkMSTD = WkMETD
     C                             AND F0STTM >= F0ENTM
     C                   EVAL      *IN40 = *ON
     C                   MOVEA     '1111'        *IN(48)
     C                   MOVE      'ST00018'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
     C                   ENDIF
 
      ** Validation of Repetitive details
      *  --------------------------------
      *
     C                   IF        *IN22 = *On
 
      ** Validation of Status/Reason codes details
      *  -----------------------------------------
      *
     C                   IF        SflToShow = 'S'
      *
     C                   EVAL      First0Err = *Zeros
     C                   EVAL      *IN24 = *On                                  SFLNXTCHG
      *
     C                   READC     SE4251S0
      *
     C                   DOW       NOT %EOF(SE4251DF)
      *
     C                   MOVEA     '00000'       *IN(52)                        Error Indicators
 
      ** Status
      *  ------
      *
      ** The status is mandatory if other details are inserted.
      * ==> But, it will be optional for SWIFT changes 2003.
      *
     C                   IF        S0STAT <> *Blanks                            Status
     C                             OR S0SSTA <> *Blanks                         Sub-Status
      *
     C                   SELECT                                                 Retrieve Key
     C                   WHEN      F0STTY = 'MF'                                Transactions
     C                   EVAL      @Y2LS = 1215004
     C                   WHEN      F0STTY = 'PE'                                Pending Transactions
     C                   EVAL      @Y2LS = 1215006
     C                   OTHER                                                  Holdings
     C                   EVAL      @Y2LS = 1215002
     C                   ENDSL
      *
      ** Selection
      *
     C                   IF        %SCAN('?':S0STAT) > *ZEROS                   Status
     C                             OR %SCAN('?':S0SSTA) > *ZEROS                Sub-Status
      *
     C                   CALL      'Y2VLLSR'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM                    @Y2LS
     C                   PARM      *BLANKS       @INVL
     C                   IF        @Rtcd  = *Blanks
     C                   EVAL      S0STAT = %SUBST(@INVL:1:4)
     C                   EVAL      S0SSTA = %SUBST(@INVL:6:4)
     C                   ENDIF
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
      *
      ** Validate
      *
     C                   EVAL      @INVL = S0STAT + ' ' + S0SSTA
      *
     C                   CALL      'Y2RVCNR'                                    Text of Frequency
     C                   PARM      *BLANKS       @RtCd
     C                   PARM                    @Y2LS
     C                   PARM                    @INVL
     C                   PARM      *BLANK        @VLMP
     C                   PARM                    @TEXT
      *
     C                   IF        @Rtcd <> *Blanks
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN52 = *ON
     C                   EVAL      *IN53 = *ON
     C                   MOVE      'ST00020'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
     C                   ENDIF
 
      ** Reason
      *  ------
      *
     C                   IF        S0REAS <> *Blanks                            Reason
     C                             OR S0SREA <> *Blanks                         Sub-Reason
      *
     C                   SELECT                                                 Retrieve Key
     C                   WHEN      F0STTY = 'MF'                                Transactions
     C                   EVAL      @Y2LS = 1215005
     C                   WHEN      F0STTY = 'PE'                                Pending Transactions
     C                   EVAL      @Y2LS = 1215007
     C                   OTHER                                                  Holdings
     C                   EVAL      @Y2LS = 1215003
     C                   ENDSL
      *
      ** Selection
      *
     C                   IF        %SCAN('?':S0REAS) > *ZEROS                   Reason
     C                             OR %SCAN('?':S0SREA) > *ZEROS                Sub-Reason
      *
     C                   CALL      'Y2VLLSR'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM                    @Y2LS
     C                   PARM      *BLANKS       @INVL
     C                   IF        @Rtcd  = *Blanks
     C                   EVAL      S0REAS = %SUBST(@INVL:1:4)
     C                   EVAL      S0SREA = %SUBST(@INVL:6:4)
     C                   ENDIF
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
      *
      ** Validate
      *
     C                   EVAL      @INVL = S0REAS + ' ' + S0SREA
      *
     C                   CALL      'Y2RVCNR'                                    Text of Frequency
     C                   PARM      *BLANKS       @RtCd
     C                   PARM                    @Y2LS
     C                   PARM                    @INVL
     C                   PARM      *BLANK        @VLMP
     C                   PARM                    @TEXT
      *
     C                   IF        @Rtcd <> *Blanks
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN54 = *ON
     C                   EVAL      *IN55 = *ON
     C                   MOVE      'ST00021'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
      *
      ** If inserted, the reason code should be the same as the sub-status code.
      *
     C                   IF        S0REAS <> *Blanks                            Reason
     C                             AND S0REAS <> S0SSTA                         Sub-status
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN54 = *ON
     C                   MOVE      'ST00022'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
     C                   ENDIF
 
      ** Security
      *  --------
      *
     C                   EVAL      S0SRPN = *Blanks
      *
     C                   IF        S0SESN <> *BLANKS
      *
     C                   IF        %SCAN('?':S0SESN) > *ZEROS
     C                   CALL      'SE0043'
     C                   PARM      *Blanks       @AcCd             1
     C                   PARM                    S0SESN
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
      *
     C     S0SESN        CHAIN     SECTY
     C                   IF        NOT %FOUND
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN56 = *ON
     C                   MOVE      'ST00023'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ELSE
     C                   EVAL      S0SRPN = SRPN
     C                   ENDIF
     C                   ENDIF
 
      ** Save the first RRN in error.
      *
     C                   IF        First0Err = *Zeros
     C                   IF        *IN52 OR *IN53 OR *IN54 OR *IN55 OR *IN56
     C                   EVAL      First0Err = C0RRN
     C                   ENDIF
     C                   ENDIF
      *
     C                   UPDATE    SE4251S0
      *
     C                   READC     SE4251S0
      *
     C                   ENDDO
 
      ** Check if no duplicate
      *
     C                   IF        NOT *IN40
      *
     C     1             DO        Sav0RRN       Idx
     C     Idx           CHAIN     SE4251S0
     C                   IF        DsSfl0Dtl = *Blanks
     C                   ITER
     C                   ENDIF
     C                   EVAL      SavSfl0Dtl = DsSfl0Dtl
     C                   EVAL      Idy = Idx + 1
      *
     C     Idy           DO        Sav0RRN       Idy
     C     Idy           CHAIN     SE4251S0
     C                   IF        DsSfl0Dtl <> *Blanks
     C                             AND DsSfl0Dtl = SavSfl0Dtl
     C                   EVAL      *IN40 = *ON
     C                   MOVEA     '11111'       *IN(52)
     C                   MOVE      'ST00024'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   UPDATE    SE4251S0
     C                   IF        C0RRN < First0Err
     C                   EVAL      First0Err = C0RRN
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDDO
     C                   ENDIF
 
      ** Restore the first RRN in error.
      *
     C                   IF        First0Err <> *Zeros
     C                   EVAL      C0RRN = First0Err
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validation of Reference details
      *  -------------------------------
      *
     C                   IF        SflToShow = 'R'
      *
     C                   EVAL      First1Err = *Zeros
      *
     C                   READC     SE4251S1
      *
     C                   DOW       NOT %EOF(SE4251DF)
      *
     C                   EVAL      *IN24 = *On                                  SFLNXTCHG
     C                   MOVEA     '00000'       *IN(52)                        Error Indicators
 
      ** Reference Code
      *
     C                   IF        S1REFC <> *Blanks                            Reference Code
     C                             OR S1REFE <> *Blanks                         Reference Text
      *
     C                   SELECT                                                 Retrieve Key
     C                   WHEN      F0STTY = 'MF'                                Transactions
     C                   EVAL      @Y2LS = 1215009
     C                   WHEN      F0STTY = 'PE'                                Pending Transactions
     C                   EVAL      @Y2LS = 1215010
     C                   OTHER                                                  Holdings
     C                   EVAL      @Y2LS = 1215008
     C                   ENDSL
      *
      ** Selection
      *
     C                   IF        %SCAN('?':S1REFC) > *ZEROS                   Reference Code
     C                   CALL      'Y2VLLSR'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM                    @Y2LS
     C                   PARM      *BLANKS       @INVL
     C                   IF        @Rtcd  = *Blanks
     C                   EVAL      S1REFC = %SUBST(@INVL:1:4)
     C                   ENDIF
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
      *
      ** Validate
      *
     C                   CALL      'Y2RVCNR'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM                    @Y2LS
     C                   PARM      S1REFC        @INVL
     C                   PARM      *BLANK        @VLMP
     C                   PARM                    @TEXT
      *
     C                   IF        @Rtcd <> *Blanks
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN52 = *ON
     C                   MOVE      'ST00025'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
 
      ** Reference Text
      *
     C                   IF        S1REFE = *Blanks
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN53 = *ON
     C                   MOVE      'ST00026'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        First1Err = *Zeros
     C                   IF        *IN52 OR *IN53
     C                   EVAL      First1Err = C1RRN
     C                   ENDIF
     C                   ENDIF
      *
     C                   UPDATE    SE4251S1
      *
     C                   READC     SE4251S1
      *
     C                   ENDDO
 
      ** Check if no duplicate
      *
     C                   IF        NOT *IN40
      *
     C     1             DO        Sav1RRN       Idx
     C     Idx           CHAIN     SE4251S1
     C                   IF        DsSfl1Dtl = *Blanks
     C                   ITER
     C                   ENDIF
     C                   EVAL      SavSfl1Dtl = DsSfl1Dtl
     C                   EVAL      Idy = Idx + 1
      *
     C     Idy           DO        Sav1RRN       Idy
     C     Idy           CHAIN     SE4251S1
     C                   IF        DsSfl1Dtl <> *Blanks
     C                             AND DsSfl1Dtl = SavSfl1Dtl
     C                   EVAL      *IN40 = *ON
     C                   MOVEA     '11111'       *IN(52)
     C                   MOVE      'ST00027'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   UPDATE    SE4251S1
     C                   IF        C1RRN < First0Err
     C                   EVAL      First1Err = C1RRN
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDDO
     C                   ENDIF
 
      ** Restore the first RRN in error.
      *
     C                   IF        First1Err <> *Zeros
     C                   EVAL      C1RRN = First1Err
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * $Window   : Window processing                                          *
      *------------------------------------------------------------------------*
     C     $Window       BEGSR
      *    ----------    ------
      ** Hook to enable the set up of data for the window controller
      *
      /COPY WNCPYSRC,SE4251MOV1
 
      ** Call the window manager
      *
     C                   CALL      'WN0010'
     C                   PARM      'SE4251  '    WdwPgm           10
     C                   PARM      *Blanks       WdwKey            2
     C                   PARM      ActionCode    WdwAction         1
     C                   PARM                    Data
     C                   PARM      *Blanks       WdwRtCd           7
     C                   PARM      *Blanks       WdwSpare        256
 
      ** If the returncode isn't blank, always issue a roll back command to
      ** cancel the eventual changes made in the window(s), and set up the
      ** appropriate action key (nothing to do for F12, any other value is
      ** considered as F3)
      *
 B1  C                   IF        WdwRtCd <> *Blanks
     C                   ROLBK
     C                   EVAL      *IN40 = *On
 
 B2  C                   IF        WdwRtCd <> 'USR0790'
     C                   EVAL      *INKC = *On
 E2  C                   ENDIF
 
 E1  C                   ENDIF
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * $UpdateDb : Update Database                                            *
      *------------------------------------------------------------------------*
     C     $UpdateDb     BEGSR
      *    ----------    ------
 
      ** Check if no duplicate Requests
      *  ------------------------------
 
      ** For insert, retrieve request sequence
      *  -------------------------------------
      *
     C                   IF        ActionCode = 'I'
 
      ** Date input
      *
     C                   EVAL      Up_RQDATE = AGRDNB
 
      ** Request Sequence
      *
     C                   EVAL      KDate = Up_RQDATE
     C                   EVAL      KReqSeq = *Hival
     C     KLRequest     SETGT     SERQSTL1
     C     KDate         READPE    SERQSTL1
     C                   IF        %EOF(SERQSTL1)
     C                   EVAL      Up_RQRSEQ = 1
     C                   ELSE
     C                   EVAL      Up_RQRSEQ = RQRSEQ + 1
     C                   ENDIF
 
      ** For other actions, Retrieve the record to amend
      *  -----------------------------------------------
      *
     C                   ELSE
 
     C                   EVAL      KDate   = RequestDate
     C                   EVAL      KReqSeq = RequestSeq
     C     KLRequest     CHAIN     SERQSTL0
 
      ** If the record has been updated by another user, stop the update.
      *
     C                   IF        NOT %FOUND(SERQSTL0)
     C                             OR DsUpRQST <> SavRQST
     C                   EVAL      *IN40 = *ON
     C                   MOVEA     '11111'       *IN(43)
     C                   MOVE      'ST00029'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ROLBK
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
 
      ** Process action codes
      *  --------------------
      *
     C                   SELECT
 
      ** Insert
      *  ------
      *
     C                   WHEN      ActionCode = 'I'
     C                   EXSR      $MovScrFil                                   Load file
     C                   EVAL      Up_RQLCD  = AGRDNB                           Last change date
     C                   EVAL      Up_RQCHTP = ActionCode                       Type of last change
     C                   EVAL      Up_RQUSER = PSUSER                           Last User
     C                   TIME                    Up_RQTIME                      Last Time Change
     C                   WRITE     SERQSTD0
     C                   EXSR      $UpdRepDb
     C                   EVAL      RequestDate = Up_RQDATE
     C                   EVAL      RequestSeq  = Up_RQRSEQ
 
      ** Amend
      *  -----
      *
     C                   WHEN      ActionCode = 'A'
     C                   EXSR      $MovScrFil                                   Load file
      **   In case of amend on today's request, keep the insert indicator
     C                   IF        Up_RQLCD  <> AGRDNB
     C                   EVAL      Up_RQCHTP = ActionCode                       Type of last change
     C                   ENDIF
     C                   EVAL      Up_RQLCD  = AGRDNB                           Last change date
     C                   EVAL      Up_RQUSER = PSUSER                           Last User
     C                   TIME                    Up_RQTIME                      Last Time Change
     C                   UPDATE    SERQSTD0
     C                   EXSR      $UpdRepDb
 
      ** Delete
      *  ------
      *
     C                   WHEN      ActionCode = 'D'
     C                   EVAL      Up_RQLCD  = AGRDNB                           Last change date
     C                   EVAL      Up_RQCHTP = ActionCode                       Type of last change
     C                   EVAL      Up_RQUSER = PSUSER                           Last User
     C                   TIME                    Up_RQTIME                      Last Time Change
     C                   UPDATE    SERQSTD0
 
      ** Release
      *  ------
      *
     C                   WHEN      ActionCode = 'R'
 
      ** Retrieve message reference
      *
     C                   EXSR      $RtvMREF                                     Message Reference
      *
     C                   EVAL      Up_RQMREF = WkMsgRef
 
      ** Add message in Statement History
      *
     C                   EXSR      $AddSHist
 
      ** Mark the request as pending
      *
     C                   EVAL      Up_RQLCD  = AGRDNB                           Last change date
     C                   EVAL      Up_RQCHTP = 'P'                              Type of last change
     C                   EVAL      Up_RQUSER = PSUSER                           Last User
     C                   TIME                    Up_RQTIME                      Last Time Change
     C                   UPDATE    SERQSTD0
 
      ** Export the message via Midas Export
      *
     C                   EXSR      $Export
 
      ** Update the message according the result of the export
      *
     C                   EVAL      KDate   = Up_RQDATE
     C                   EVAL      KReqSeq = Up_RQRSEQ
     C     KLRequest     CHAIN     SERQSTL0
     C                   IF        %FOUND(SERQSTL0)
     C                   IF        ReturnCode = *Blanks
     C                   EVAL      Up_RQCHTP = 'R'                              Release
     C                   ELSE
     C                   EVAL      Up_RQCHTP = 'F'                              Failed
     C                   EVAL      Up_RQMREF = *Blanks
     C                   ENDIF
     C                   TIME                    Up_RQTIME                      Last Time Change
     C                   UPDATE    SERQSTD0
     C                   ENDIF
 
      ** Update the message history according the result of the export
      *
     C     Up_RQMREF     CHAIN     SESTHSL0
     C                   IF        %FOUND(SESTHSL0)
     C                   IF        ReturnCode = *Blanks
     C                   EVAL      SHSTAT = 'COMP'                              Release
     C                   ELSE
     C                   EVAL      SHSTAT = 'FAIL'                              Failed
     C                   EVAL      SHMREF = *Blanks
     C                   ENDIF
     C                   UPDATE    SESTHSD0
     C                   ENDIF
     C                   ENDSL
 
     C                   COMMIT
 
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * $MovScrFil: Move screen fields to file fields                          *
      *------------------------------------------------------------------------*
     C     $MovScrFil    BEGSR
      *    ----------    ------
 
     C                   EVAL      Up_RQMREF = *Blanks                          Message Request Refe
     C                   EVAL      Up_RQPRTY = F0PRTY                           Priority
     C                   EVAL      Up_RQNOTF = F0NOTF                           Delivery Notificat.
     C                   EVAL      Up_RQSNDR = F0SNDR                           Sending Branch
     C                   EVAL      Up_RQORIG = F0ORIG                           Originating Branch
     C                   EVAL      Up_RQCUST = F0CUST                           Customer Number
     C                   EVAL      Up_RQDREF = F0DREF                           Depot Reference
     C                   EVAL      Up_RQSTTY = F0STTY                           Statement Type
     C                   SELECT
     C                   WHEN      F0STTY = 'TF'                                Trade Date Complet
     C                   EVAL      Up_RQMTYP = '535'                            Message Type Request
     C                   EVAL      Up_RQCODE = 'C'                              Complete / Delta
     C                   EVAL      Up_RQSTDT = 'T'                              Statement Date Type
     C                   WHEN      F0STTY = 'VF'                                Value Date Complet
     C                   EVAL      Up_RQMTYP = '535'                            Message Type Request
     C                   EVAL      Up_RQCODE = 'C'                              Complete / Delta
     C                   EVAL      Up_RQSTDT = 'V'                              Statement Date Type
     C                   WHEN      F0STTY = 'SF'                                Settl Date Complet
     C                   EVAL      Up_RQMTYP = '535'                            Message Type Request
     C                   EVAL      Up_RQCODE = 'C'                              Complete / Delta
     C                   EVAL      Up_RQSTDT = 'S'                              Statement Date Type
     C                   WHEN      F0STTY = 'TC'                                Trade Date Change
     C                   EVAL      Up_RQMTYP = '535'                            Message Type Request
     C                   EVAL      Up_RQCODE = 'D'                              Complete / Delta
     C                   EVAL      Up_RQSTDT = 'T'                              Statement Date Type
     C                   WHEN      F0STTY = 'VC'                                Value Date Change
     C                   EVAL      Up_RQMTYP = '535'                            Message Type Request
     C                   EVAL      Up_RQCODE = 'D'                              Complete / Delta
     C                   EVAL      Up_RQSTDT = 'V'                              Statement Date Type
     C                   WHEN      F0STTY = 'SC'                                Settl Date Change
     C                   EVAL      Up_RQMTYP = '535'                            Message Type Request
     C                   EVAL      Up_RQCODE = 'D'                              Complete / Delta
     C                   EVAL      Up_RQSTDT = 'S'                              Statement Date Type
     C                   WHEN      F0STTY = 'MF'                                Movement Full Stat.
     C                   EVAL      Up_RQMTYP = '536'                            Message Type Request
     C                   EVAL      Up_RQCODE = 'C'                              Complete / Delta
     C                   EVAL      Up_RQSTDT = ' '                              Statement Date Type
     C                   WHEN      F0STTY = 'PE'                                Pending Transaction
     C                   EVAL      Up_RQMTYP = '537'                            Message Type Request
     C                   EVAL      Up_RQCODE = 'D'                              Complete / Delta
     C                   EVAL      Up_RQSTDT = ' '                              Statement Date Type
     C                   ENDSL
     C                   EVAL      Up_RQTYPE = 'C'                              Custody/Accounting
     C                   EVAL      Up_RQFREQ = F0FREQ                           Frequency Code
     C                   EVAL      Up_RQMSTD = WkMSTD                           Midas Start Date
     C                   MOVE      F0STTM        Up_RQSTTM                      Start Time
     C                   EVAL      Up_RQMETD = WkMETD                           Midas End Date
     C                   MOVE      F0ENTM        Up_RQENTM                      End Time
 
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * $UpdRepDb : Update Repetitive Database                                 *
      *------------------------------------------------------------------------*
     C     $UpdRepDb     BEGSR
      *    ----------    ------
 
      ** Delete all existing repetitive details, before to re-create them.
      *
     C                   EVAL      KDate   = Up_RQDATE
     C                   EVAL      KReqSeq = Up_RQRSEQ
     C                   DOU       NOT %FOUND(SERSTRL0)
     C     KLRequest     DELETE    SERSTRD0
     C                   ENDDO
 
     C                   EVAL      Up_RRCSEQ = *Zeros
 
     C                   IF        *IN22 = *On
 
      ** Status/Reason codes details
      *  ---------------------------
 
     C                   IF        SflToShow = 'S'
 
     C     1             DO        Sav0RRN       Idx
     C     Idx           CHAIN     SE4251S0
     C                   IF        DsSfl0Dtl <> *Blanks
     C                   EVAL      Up_RRDATE  = Up_RQDATE                       Request Input Date
     C                   EVAL      Up_RRRSEQ  = Up_RQRSEQ                       Request Sequence
     C                   EVAL      Up_RRCSEQ  = Up_RRCSEQ + 1                   Code Sequence
     C                   EVAL      Up_RRSTAT  = S0STAT                          Status
     C                   EVAL      Up_RRSSTA  = S0SSTA                          Sub Status
     C                   EVAL      Up_RRREAS  = S0REAS                          Reason
     C                   EVAL      Up_RRSREA  = S0SREA                          Sub Reason
     C                   EVAL      Up_RRSESN  = S0SESN                          Security
     C                   EVAL      Up_RRREFC  = *Blanks                         Reference Code
     C                   EVAL      Up_RRREFE  = *Blanks                         Reference
     C                   WRITE     SERSTRD0
     C                   ENDIF
     C                   ENDDO
 
      ** Reference codes details
      *  -----------------------
 
     C                   ELSE
 
     C     1             DO        Sav1RRN       Idx
     C     Idx           CHAIN     SE4251S1
     C                   IF        DsSfl1Dtl <> *Blanks
     C                   EVAL      Up_RRDATE  = Up_RQDATE                       Request Input Date
     C                   EVAL      Up_RRRSEQ  = Up_RQRSEQ                       Request Sequence
     C                   EVAL      Up_RRCSEQ  = Up_RRCSEQ + 1                   Code Sequence
     C                   EVAL      Up_RRSTAT  = *Blanks                         Status
     C                   EVAL      Up_RRSSTA  = *Blanks                         Sub Status
     C                   EVAL      Up_RRREAS  = *Blanks                         Reason
     C                   EVAL      Up_RRSREA  = *Blanks                         Sub Reason
     C                   EVAL      Up_RRSESN  = *Blanks                         Security
     C                   EVAL      Up_RRREFC  = S1REFC                          Reference Code
     C                   EVAL      Up_RRREFE  = S1REFE                          Reference
     C                   WRITE     SERSTRD0
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDIF
     C                   ENDIF
      *                  ------
     C                   ENDSR
 
      *====================================================================*
      * $RtvMREF  - Retrieve Message Reference                             *
      *--------------------------------------------------------------------*
     C     $RtvMREF      BEGSR
      *    ---------     -----
 
      ** The message reference is:
      **    - Module Id 'SE'                 -> WkModId
      **    - Safekeeping Customer Number    -> Up_RQCUST
      **    - System Rundate in SWIFT format -> CurSWIFTDt
      **    - Sequence                       -> WkMsgSeq
 
      ** To retrieve the new number, retrieve the last one of the day
      ** and add 1 to the sequence.
 
      ** Retrieve the last message for the Customer
 
     C                   EVAL      WkRQCUST = Up_RQCUST
     C                   EVAL      WkMsgSeq = 99
     C     WkMsgRef      SETGT     SESTHSL0
     C                   READP     SESTHSL0
 
      ** No message
 
     C                   IF        %EOF(SESTHSL0)
     C                   EVAL      WkMsgSeq = 01
     C                   ELSE
 
      ** No message for the Customer today
 
     C                   IF        %SUBST(SHMREF:3:6) <> Up_RQCUST
     C                             OR %SUBST(SHMREF:9:6) <> CurSWIFTDt
     C                   EVAL      WkMsgSeq = 01
     C                   ELSE
 
      ** Message for the Customer
 
     C                   MOVE      SHMREF        WkMsgSeq
     C                   IF        WkMsgSeq = 99
     C                   EVAL      WkMsgSeq = 01
     C                   ELSE
     C                   EVAL      WkMsgSeq = WkMsgSeq + 1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      *                  -----
     C                   ENDSR
      *====================================================================*
      * $AddSHist - Add message in Statement History                       *
      *--------------------------------------------------------------------*
     C     $AddSHist     BEGSR
      *    ---------     -----
 
     C                   CLEAR                   SESTHSD0
     C                   EVAL      SHDATE = Up_RQDATE                           Input Date
     C                   EVAL      SHRSEQ = Up_RQRSEQ                           Request Sequence
     C                   EVAL      SHMREF = Up_RQMREF                           Message Request Ref.
     C                   EVAL      SHPRTY = Up_RQPRTY                           Priority
     C                   EVAL      SHNOTF = Up_RQNOTF                           Delivery Notificat.
     C                   EVAL      SHSNDR = Up_RQSNDR                           Sending Branch
     C                   EVAL      SHORIG = Up_RQORIG                           Originating Branch
     C                   EVAL      SHCUST = Up_RQCUST                           Customer Number
     C                   EVAL      SHTYPE = Up_RQSTTY                           Statement Type
     C                   SELECT                                                 Complete / Delta
     C                   WHEN      Up_RQCODE = 'C'
     C                   EVAL      SHCODE = 'COMP'                              Complete
     C                   WHEN      Up_RQCODE = 'D'
     C                   EVAL      SHCODE = 'DELT'                              Delta
     C                   ENDSL
     C                   SELECT                                                 Statement Frequency
     C                   WHEN      Up_RQFREQ = 'Z'
     C                   EVAL      SHSFRE = 'ADHO'                              Ad-Hoc
     C                   WHEN      Up_RQFREQ = 'D'
     C                   EVAL      SHSFRE = 'DAIL'                              Daily
     C                   WHEN      Up_RQFREQ = 'I'
     C                   EVAL      SHSFRE = 'INDA'                              Intra-Day
     C                   WHEN      Up_RQFREQ = 'M'
     C                   EVAL      SHSFRE = 'MNTH'                              Monthly
     C                   WHEN      Up_RQFREQ = 'W'
     C                   EVAL      SHSFRE = 'WEEK'                              Weekly
     C                   WHEN      Up_RQFREQ = 'Y'
     C                   EVAL      SHSFRE = 'YEAR'                              Yearly
     C                   ENDSL
     C                   SELECT                                                 Custody/Accounting
     C                   WHEN      Up_RQTYPE = 'C'
     C                   EVAL      SHSTTY = 'CUST'
     C                   ENDSL
     C                   SELECT                                                 Statement Basis
     C                   WHEN      Up_RQSTDT = 'T'
     C                   EVAL      SHSTBA = 'TRAD'                              Trade Date
     C                   WHEN      Up_RQSTDT = 'V'
     C                   EVAL      SHSTBA = 'CONT'                              Value Date
     C                   WHEN      Up_RQSTDT = 'S'
     C                   EVAL      SHSTBA = 'SETT'                              Settle Date
     C                   ENDSL
     C                   EVAL      SHMSTD = Up_RQMSTD                           Midas Start Date
     C                   EVAL      SHSTRM = Up_RQSTTM                           Start Time
     C                   EVAL      SHMETD = Up_RQMETD                           Midas End Date
     C                   EVAL      SHENTM = Up_RQENTM                           End Time
     C                   EVAL      SHMTYP = '549'                               Message Type
     C                   EVAL      SHSTAT = 'PEND'                              Status of Message
     C                   WRITE     SESTHSD0
 
      *                  -----
     C                   ENDSR
      *========================================================================*
      * $Export   : Export Message                                             *
      *------------------------------------------------------------------------*
     C     $Export       BEGSR
      *    ----------    ------
 
      ** Open files for Midas Export
      *
     C                   OPEN      MGRQSTPD
     C                   OPEN      MGRSTRPD
 
      ** Retrieve System Id
      *
     C                   IN        SDSTAT
     C
      ** Write Driver information
      *
     C                   CLEAR                   MGRQSTD0
 
     C                   EVAL      MGMREF = Up_RQMREF                           Message Request Ref.
     C                   EVAL      MGSYID = LIBR                                System Id
     C                   EVAL      MGPRTY = Up_RQPRTY                           Priority
     C                   EVAL      MGNOTF = Up_RQNOTF                           Delivery Notificatio
     C                   EVAL      MGSNDR = Up_RQSNDR                           Sending Branch
     C                   EVAL      MGORIG = Up_RQORIG                           Originating Branch
     C                   EVAL      MGCUST = Up_RQCUST                           Custodian Number
     C                   EVAL      MGDREF = Up_RQDREF                           Depot Reference
     C                   EVAL      MGSTTY = Up_RQSTTY                           Statement Type
     C                   EVAL      MGMTYP = Up_RQMTYP                           Message Type Request
     C                   EVAL      MGCODE = Up_RQCODE                           Complete / Delta
     C                   EVAL      MGFREQ = Up_RQFREQ                           Frequency Code
     C                   EVAL      MGTYPE = Up_RQTYPE                           Custody/Accounting
     C                   EVAL      MGSTDT = Up_RQSTDT                           Statement Date Type
     C                   EVAL      MGMSTD = Up_RQMSTD                           Midas Start Date
     C     StartDate     ADDDUR    MGMSTD:*D     WkDate
     C     *ISO          MOVE      WkDate        MGSSTD                         SWIFT Start Date
     C                   EVAL      MGSTTM = Up_RQSTTM                           Start Time
     C                   EVAL      MGMETD = Up_RQMETD                           Midas End Date
     C                   IF        MGMETD <> *Zeros
     C     StartDate     ADDDUR    MGMETD:*D     WkDate
     C     *ISO          MOVE      WkDate        MGSETD                         SWIFT End Date
     C                   ENDIF
     C                   EVAL      MGENTM = Up_RQENTM                           End Time
 
     C                   WRITE     MGRQSTD0
 
      ** Write Repetitive Information
      *
     C                   EVAL      KDate   = Up_RQDATE
     C                   EVAL      KReqSeq = Up_RQRSEQ
     C     KLRequest     SETLL     SERSTRL1
     C     KLRequest     READE     SERSTRL1
     C                   DOW       NOT %EOF(SERSTRL1)
     C                   CLEAR                   MGRSTRD0
     C                   EVAL      MRMREF = Up_RQMREF                           Message Request Refe
     C                   EVAL      MRSTAT = RRSTAT                              Status Code
     C                   EVAL      MRSSTA = RRSSTA                              Sub Status Code
     C                   EVAL      MRREAS = RRREAS                              Reason Code
     C                   EVAL      MRSREA = RRSREA                              Sub Reason Code
     C                   EVAL      MRSESN = RRSESN                              Security Shortname
     C                   IF        RRSESN <> *Blanks
     C     RRSESN        CHAIN     SECTY
     C                   IF        %FOUND
     C                   EVAL      MRSRPN = SRPN                                Security Report Name
     C                   EVAL      MRSFN1 = SFN1                                Security Full Name 1
     C                   EVAL      MRSFN2 = SFN2                                Security Full Name 2
     C                   EVAL      MRSCOR = SCOR                                Country of Risk
     C                   EVAL      MRISIN = ISIN                                ISIN Number
     C                   EVAL      MRSREF = SREF                                Sedol Reference
     C                   EVAL      MRT2RF = T2RF                                Telekurs Reference
     C                   EVAL      MRCSPN = CSPN                                Cusip Number
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      MRREFC = RRREFC                              Reference Code
     C                   EVAL      MRREFE = RRREFE                              Reference
     C                   EVAL      MRCPTM = *Zeros                              Multiple Count
     c                   WRITE     MGRSTRD0
     C     KLRequest     READE     SERSTRL1
     C                   ENDDO
 
      ** Write dummy record as, at least, one repetitive record should exist for Midas Export
      *
     C                   CLEAR                   MGRSTRD0
     C                   EVAL      MRMREF = Up_RQMREF
     c                   WRITE     MGRSTRD0
 
      ** Close files for Midas Export
      *
     C                   CLOSE     MGRQSTPD
     C                   CLOSE     MGRSTRPD
 
      ** Call Midas Export Processing
      *
     C                   CALLB     'SEC4251'
     C                   PARM      *Blanks       ReturnCode
     C                   PARM      ZAPGM         CallerOut        10
 
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * $PrRelease: Prepare Release                                            *
      *------------------------------------------------------------------------*
     C     $PrRelease    BEGSR
      *    ----------    ------
 
      ** To Release the message the user should be a Systems Routing Officer
      *
     C                   IF        ROUF <> 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** It should be authorize to release action for the sending and original branches
 
     C  N37              CALL      'ZVACTU'
     C                   PARM      'R'           @ZACTN            1
     C                   PARM      *Zeros        @ERR              1 0
     C   37              CALL      'ZVACTBU'
     C                   PARM      'R'           @ZACTN
     C                   PARM      F0SNDR        @ZBR              3
     C                   PARM      *Zeros        @ERR
      *
     C     @ERR          IFNE      *Zeros
     C                   LEAVESR
     C                   ENDIF
 
     C  N37              CALL      'ZVACTU'
     C                   PARM      'R'           @ZACTN            1
     C                   PARM      *Zeros        @ERR              1 0
     C   37              CALL      'ZVACTBU'
     C                   PARM      'R'           @ZACTN
     C                   PARM      F0ORIG        @ZBR              3
     C                   PARM      *Zeros        @ERR
      *
     C     @ERR          IFNE      *Zeros
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      ActionCode = 'R'
 
      ** Format the screen according to the received action code
      *
     C                   EXSR      $IniScreen
     C                   EXSR      $InitSFL
 
     C                   EVAL      *IN40 = *On
 
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * $IniScreen: Format the screen                                          *
      *------------------------------------------------------------------------*
     C     $IniScreen    BEGSR
      *    ----------    ------
 
      **  Clear screens
      *
     C                   CLEAR                   SE4251F0
 
      **  Reset indicators and working fields
      *
     C                   MOVEA     *Zeros        IN40_TO_70
     C                   MOVEA     IN40_TO_70    *IN(40)
     C                   EVAL      SavCUST = *Blanks                            Save Custodian Nb.
     C                   EVAL      SavORIG = *Blanks                            Save Request Branch
     C                   EVAL      SavRQST = *Blanks                            Save Request Details
 
      ** Protect fields or not
      *
     C                   IF        ActionCode = 'I' OR ActionCode = 'A'
     C                   EVAL      *IN36 = *Off
     C                   ELSE
     C                   EVAL      *IN36 = *On
     C                   ENDIF
 
      ** Allow F10 key
      *
     C                   IF        ActionCode = 'D'
     C                   EVAL      *IN01 = *ON
     C                   ENDIF
 
      ** Allow F11 Toggle
      *
     C                   IF        ActionCode = 'I'
     C                             OR ActionCode = 'A'
     C                   EVAL      *IN02 = *On
     C                   ELSE
     C                   EVAL      *IN02 = *Off
     C                   ENDIF
 
      ** Allow F24 Toggle
      *
     C                   IF        ActionCode = 'R'                             Release function
     C                             AND ROUF = 'Y'                               Routing Officer
     C                   EVAL      *IN03 = *On                                  Release function
     C                   ELSE
     C                   EVAL      *IN03 = *Off
     C                   ENDIF
 
      ** In insert mode, default the input screen
      *
     C                   IF        ActionCode = 'I'
 
     C                   EVAL      F0PRTY = 'N'                                 Priority
     C                   EVAL      F0NOTF = '2'                                 Delivery Notificat.
     C                   EVAL      F0SNDR = DBRN                                Sending Branch
     C                   EVAL      F0ORIG = F0SNDR                              Originating Branch
     C                   EVAL      F0CUST = DefaultCust                         Default Custodian
     C                   EVAL      F0FREQ = 'Z'                                 Frequency
 
     C                   CALL      'Y2RVCNR'                            99      Text of Frequency
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      1215001       @Y2LS             7 0
     C                   PARM      'Z'           @INVL            20
     C                   PARM      *BLANK        @VLMP             1
     C     F0FRNM        PARM                    @TEXT            50
     C                   IF        *IN99 OR @Rtcd <> *BLANKS
     C                   EVAL      F0FRNM = *BLANKS
     C                   ENDIF
 
     C                   EVAL      F0MSTD = DftDate                             Start Date
 
     C                   ELSE
      *
      ** Otherwise, retrieve the request details
      *
     C                   EVAL      KDate   = RequestDate
     C                   EVAL      KReqSeq = RequestSeq
     C     KLRequest     CHAIN     SERQSTL1
 
     ** -- Record not found --> Error
 
     C                   IF        NOT %FOUND(SERQSTL1)
     C                   EVAL      *IN40 = *ON
     C                   MOVE      'ST00030'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   LEAVESR
     C                   ENDIF
 
      ** -- Check the action code regarding the current status of the request.
      ** -- => Replace action code by 'E' enquiry.
 
     C                   IF        ActionCode = 'A'
     C                             OR ActionCode = 'D'
     C                             OR ActionCode = 'R'
     C                   IF        RQCHTP = 'P'
     C                             OR RQCHTP = 'R'
     C                   EVAL      *IN40 = *ON
     C                   MOVE      'SE00033'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   EVAL      ActionCode = 'E'
     C                   EVAL      *IN01 = *Off                                 Delete
     C                   EVAL      *IN02 = *Off                                 Toggle
     C                   EVAL      *IN03 = *Off                                 Release
     C                   EVAL      *IN36 = *On                                  Protect
     C                   ENDIF
     C                   ENDIF
 
      **
 
     C                   EVAL      SavRQST = DsRQST                             Save Request Details
 
     C                   EVAL      Idx = 1                                      Status
     C     RQCHTP        LOOKUP    StatusID(Idx)                          99
     C                   IF        *IN99
     C                   EVAL      F0STAT = StatusText(Idx)
     C                   ENDIF
     C     RQMREF        COMP      *BLANKS                            3838      Message Reference
     C                   EVAL      F0MREF = RQMREF
     C                   EVAL      F0PRTY = RQPRTY                              Priority
     C                   EVAL      F0NOTF = RQNOTF                              Delivery Notificat.
     C                   EVAL      F0SNDR = RQSNDR                              Sending Branch
     C                   EVAL      F0ORIG = RQORIG                              Originating Branch
     C                   EVAL      F0CUST = RQCUST                              Customer Number
 
     C                   CALLB     'AOCUSTR0'                                   Customer Report Name
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      RQCUST        @Key1            10
     C                   PARM                    @Kyst             7
     C     DsCUST        PARM                    DSSDY
     C                   IF        @RtCd = *Blanks
     C                   EVAL      F0CRNM = BBCRNM
     C                   ENDIF
 
     C                   EVAL      F0DREF = RQDREF                              Depot Reference
     C                   EVAL      F0STTY = RQSTTY                              Type of Statement
 
     C                   CALL      'Y2RVCNR'                            99      Text of Type
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      1215000       @Y2LS
     C                   PARM      RQSTTY        @INVL
     C                   PARM      *BLANK        @VLMP
     C     F0STNM        PARM                    @TEXT
     C                   IF        *IN99 OR @Rtcd <> *BLANKS
     C                   EVAL      F0STNM = *BLANKS
     C                   ENDIF
 
     C                   EVAL      F0FREQ = RQFREQ                              Frequency
 
     C                   CALL      'Y2RVCNR'                            99      Text of Frequency
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      1215001       @Y2LS
     C                   PARM      RQFREQ        @INVL
     C                   PARM      *BLANK        @VLMP
     C     F0FRNM        PARM                    @TEXT
     C                   IF        *IN99 OR @Rtcd <> *BLANKS
     C                   EVAL      F0FRNM = *BLANKS
     C                   ENDIF
 
     C                   IF        RQMSTD = *ZEROS                              Start Date
     C                   EVAL      F0MSTD = *BLANKS
     C                   ELSE
     C     StartDate     ADDDUR    RQMSTD:*D     WkDate
     C  N98*DMY0         MOVE      WkDate        F0MSTD
     C   98*MDY0         MOVE      WkDate        F0MSTD
     C                   ENDIF
 
     C                   IF        RQSTTM = *ZEROS                              Start Time
     C                             AND RQENTM = *ZEROS                          End Time
     C                   EVAL      F0STTM = *BLANKS
     C                   ELSE
     C                   MOVE      RQSTTM        F0STTM
     C                   ENDIF
 
     C                   IF        RQMETD = *ZEROS                              End Date
     C                   EVAL      F0METD = *BLANKS
     C                   ELSE
     C     StartDate     ADDDUR    RQMETD:*D     WkDate
     C  N98*DMY0         MOVE      WkDate        F0METD
     C   98*MDY0         MOVE      WkDate        F0METD
     C                   ENDIF
 
     C                   IF        RQENTM = *ZEROS                              End Time
     C                             AND RQSTTM = *ZEROS                          Start Time
     C                             OR  RQSTTY <> 'MF'                           Transaction
     C                   EVAL      F0ENTM = *BLANKS
     C                   ELSE
     C                   MOVE      RQENTM        F0ENTM
     C                   ENDIF
 
     C                   ENDIF
 
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * $InitSFL : Format Subfile Details                                      *
      *------------------------------------------------------------------------*
     C     $InitSFL      BEGSR
      *    ----------    ------
 
     C                   MOVEA     '00000'       *IN(52)
     C                   EXSR      $ClrSFL0
     C                   EXSR      $ClrSFL1
 
      ** Retrieve Repetitive information.
 
     C                   IF        ActionCode <> 'I'
     C                   EVAL      KDate   = RequestDate
     C                   EVAL      KReqSeq = RequestSeq
     C     KLRequest     SETLL     SERSTRL1
     C     KLRequest     READE     SERSTRL1                               27
     C                   ELSE
     C                   EVAL      *IN27 = *ON
     C                   ENDIF
 
      ** According the information defined for the Request, load
      ** - the Status/reason Code
      ** - OR the Reference Code
 
     C                   IF        *IN27 = *OFF
     C                   EVAL      *IN02 = *OFF                                 No Toggle
     C                   IF        RRREFC <> *BLANKS
     C                   EVAL      SflToShow = 'R'
     C                   ELSE
     C                   EVAL      SflToShow = 'S'
     C                   ENDIF
     C                   ENDIF
 
      ** Load subfile
 
     C                   IF        SflToShow = 'S'
     C  N27              EXSR      $LoaSFL0
     C                   EXSR      $FilSFL0
     C   22              EVAL      C0RRN   = 1
     C                   ELSE
     C  N27              EXSR      $LoaSFL1
     C                   EXSR      $FilSFL1
     C   22              EVAL      C1RRN   = 1
     C                   ENDIF
 
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * $ClrSFL0 : Clear Subfile 0 - Status/Reason Code                        *
      *------------------------------------------------------------------------*
     C     $ClrSFL0      BEGSR
      *    ----------    ------
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   WRITE     SE4251C0
     C                   EVAL      *IN21 = *ON
     C                   EVAL      Sav0RRN = *ZEROS
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * $ClrSFL1 : Clear Subfile 1 - Reference Code                            *
      *------------------------------------------------------------------------*
     C     $ClrSFL1      BEGSR
      *    ----------    ------
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   WRITE     SE4251C1
     C                   EVAL      *IN21 = *ON
     C                   EVAL      Sav1RRN = *ZEROS
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * $LoaSFL0 : Load Subfile 0 - Status/Reason Code                         *
      *------------------------------------------------------------------------*
     C     $LoaSFL0      BEGSR
      *    ----------    ------
      *
      ** Fill the subfile with the Status/Reason Code information when exists
      *
     C                   EVAL      C0RRN = Sav0RRN
 
     C                   DOW       NOT *IN27
 
     C                   CLEAR                   SE4251S0
 
     C                   EVAL      S0DATE = RRDATE                              Input Date
     C                   EVAL      S0RSEQ = RRRSEQ                              Request Sequence
     C                   EVAL      S0CSEQ = RRCSEQ                              Code Sequence
     C                   EVAL      S0STAT = RRSTAT                              Status
     C                   EVAL      S0SSTA = RRSSTA                              Sub-status
     C                   EVAL      S0REAS = RRREAS                              Reason
     C                   EVAL      S0SREA = RRSREA                              Sub-Reason
     C                   EVAL      S0SESN = RRSESN                              Security
     C     RRSESN        CHAIN     SECTY
     C                   IF        %FOUND
     C                   EVAL      S0SRPN = SRPN
     C                   ENDIF
 
     C                   EVAL      C0RRN = C0RRN + 1
     C                   EVAL      *IN22 = *ON                                  SFLDSP
     C                   WRITE     SE4251S0
     C     KLRequest     READE     SERSTRL1                               27
     C                   ENDDO
 
     C                   EVAL      Sav0RRN = C0RRN
     C   22              EVAL      C0RRN   = 1
     C                   EVAL      *IN23 = *ON                                  SFLEND
 
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * $FilSFL0 : Fill Subfile 0 with blank lines                             *
      *------------------------------------------------------------------------*
     C     $FilSFL0      BEGSR
      *    ----------    ------
      *
      ** In case of insert or amend, load empty lines to fill screen.
      *
     C                   IF        ActionCode = 'I' OR ActionCode = 'A'
 
      ** Retrieve the number of line to fill blanks
      *
     C                   EVAL      Idx = 7 - (%REM(Sav0RRN:7))
 
     C                   EVAL      C0RRN = Sav0RRN
 
     C     1             DO        Idx
     C                   CLEAR                   SE4251S0
     C                   EVAL      C0RRN = C0RRN + 1
     C                   WRITE     SE4251S0
     C                   EVAL      *IN22 = *ON                                  SFLDSP
     C                   ENDDO
 
     C                   EVAL      Sav0RRN = C0RRN
     C                   EVAL      *IN23 = *OFF
 
     C                   ENDIF
 
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * $LoaSFL1 : Load Subfile 1 - Reference Code                             *
      *------------------------------------------------------------------------*
     C     $LoaSFL1      BEGSR
      *    ----------    ------
      *
      ** Fill the subfile with the Reference Code information when exists,
      ** Otherwise, fill blank lines.
      *
     C                   EVAL      C1RRN = Sav1RRN
 
     C                   DOW       NOT *IN27
 
     C                   CLEAR                   SE4251S1
 
     C                   EVAL      S1DATE = RRDATE                              Input Date
     C                   EVAL      S1RSEQ = RRRSEQ                              Request Sequence
     C                   EVAL      S1CSEQ = RRCSEQ                              Code Sequence
     C                   EVAL      S1REFC = RRREFC                              Reference
     C                   EVAL      S1REFE = RRREFE                              Reference
 
     C                   EVAL      C1RRN = C1RRN + 1
     C                   EVAL      *IN22 = *ON                                  SFLDSP
     C                   WRITE     SE4251S1
     C     KLRequest     READE     SERSTRL1                               27
     C                   ENDDO
 
     C                   EVAL      Sav1RRN = C1RRN
     C   22              EVAL      C1RRN   = 1
     C                   EVAL      *IN23 = *ON
 
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * $FilSFL1 : Fill Subfile 1 with blank lines                             *
      *------------------------------------------------------------------------*
     C     $FilSFL1      BEGSR
      *    ----------    ------
      *
      ** In case of insert or amend, load empty lines to fill screen.
      *
     C                   IF        ActionCode = 'I' OR ActionCode = 'A'
 
      ** Retrieve the number of line to fill blanks
      *
     C                   EVAL      Idx = 7 - (%REM(Sav1RRN:7))
 
     C                   EVAL      C1RRN = Sav1RRN
 
     C     1             DO        Idx
     C                   CLEAR                   SE4251S1
     C                   EVAL      C1RRN = C1RRN + 1
     C                   WRITE     SE4251S1
     C                   EVAL      *IN22 = *ON                                  SFLDSP
     C                   ENDDO
 
     C                   EVAL      Sav1RRN = C1RRN
     C                   EVAL      *IN23 = *OFF
 
     C                   ENDIF
 
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * $ClrErrSF : Clear program message queue                                *
      *------------------------------------------------------------------------*
     C     $ClrErrSF     BEGSR
      *    ----------    ------
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * $ZaSndMsg : Send message to the program message queue                  *
      *------------------------------------------------------------------------*
     C     $ZaSndMsg     BEGSR
      *    ----------    ------
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * $ExitMod  : Exit from the module                                       *
      *------------------------------------------------------------------------*
     C     $ExitMod      BEGSR
      *    ----------    ------
 
     C                   MOVE      *On           *INLR
     C                   RETURN
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *========================================================================*
     C     *INZSR        BEGSR
      *    ----------    ------
      ** Initialise Copyright Array
      *
     C                   MOVEA     CPY@          CPY@@            80
 
      ** Define fields used by the clear message queue function
      *
      ** -- If no named caller --> set-up ZAPGM with the current program name
      *
     C                   IF        CallerIn = *Blanks
     C                   MOVEL     PSProcName    ZAPGM            10
 
      ** -- Otherwise set-up ZAPGM with the caller name
      *
     C                   ELSE
     C                   MOVEL     CallerIn      ZAPGM
     C                   ENDIF
 
     C                   MOVEL     'SEUSRMSG'    ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *Blanks       ZAMSID            7
     C                   MOVEL     *Blanks       ZAMSDA          132
     C                   MOVEL     *Blanks       ZAMSTP            7
 
     C                   CALL      'AOUSERR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      PSUSER        @USRP            10
     C     DsUSER        PARM      *Blanks       DSSDY
     C                   IF        @RTCD <> *Blanks
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set up Working fields
      *
      *
     C                   IN        RUNDAT
     C     AGDFF         COMP      'M'                                    98
     C     AGMBIN        COMP      'Y'                                    37
 
     C                   EVAL      SflToShow = 'S'
 
      ** Default Date
      *
     C     StartDate     ADDDUR    AGRDNB:*D     WkDate                         Current Date
     C  N98*DMY0         MOVE      WkDate        DftDate                        Curr. Date DDMMYY
     C   98*MDY0         MOVE      WkDate        DftDate                        Curr. Date MMDDYY
     C     *YMD0         MOVE      WkDate        CurSWIFTDt                     Curr. Date YYMMDD
 
      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Format the screen according to the received action code
      *
     C                   EXSR      $IniScreen
     C                   EXSR      $InitSFL
 
      ** Key list to access Request Statement
      *
     C     KLRequest     KLIST
     C                   KFLD                    KDate
     C                   KFLD                    KReqSeq
 
      ** Key list to access Request Statement by Custodian, Type, Branches
      *
     C     KLReqCTBB     KLIST
     C                   KFLD                    F0CUST
     C                   KFLD                    F0STTY
     C                   KFLD                    F0SNDR
     C                   KFLD                    F0ORIG
 
      ** Key list to access Bank Depot Position by Branch/Customer
      *
     C     KLDepCust     KLIST
     C                   KFLD                    F0ORIG                         Originater
     C                   KFLD                    KCustNb                        Custodian Number
      *
 
      *                  ------
     C                   ENDSR
 
      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
     C     *PSSR         BEGSR
      *    ----------    ------
     C                   DUMP
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
 
     C                   CALLB     'DBERRCTL'                           99
 
     C                   MOVEL(P)  '*ERROR'      RetCodeOut
     C                   EXSR      $ExitMod
      *                  ------
     C                   ENDSR
 
      *========================================================================*
**CTDATA Status
AAmended
DDeleted
ICreated
FFailed
PPending
RReleased
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2003
