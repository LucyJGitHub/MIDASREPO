     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Historic Market Data Report')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS001020 - Midas AS Historic Market Data Report              *
      *                                                               *
      *  Function:  This module lists the historic market data of a   *
      *             given hedge linkage. The hedge linkage ID should  *
      *             have been validated and be using the regression   *
      *             method.                                           *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    21         Dealing                                         *
      *    22         Lending                                         *
      *    23         Securities                                      *
      *    24         Data Type 'V'                                   *
      *    25         Data Type 'C'                                   *
      *    26         Data Type 'R'                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRInit - Initialisation                                       *
      * SRProc - Process report                                       *
      * SRHedgeData - Process hedge transaction details               *
      * SRMarketData - Process market data details                    *
      * SRRcfP1 - Detail Spool File recorded by RCF                   *
      * SRRcfAU - Subroutine to register the AU Printer File via RCF  *
      * SRDate - Convert Midas Date to DDMMMYY format                 *
      * SRCcy - Access currency details                               *
      * SREdit - Convert numeric value to appropriate string format   *
      * SRChkLin - Checks for printer file overflow condition         *
      * SRAudt - Outputs Audit report and ends program                *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FAS001020P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
      ** AS Historic Market Data detail report
 
     FAS001020AUO    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      ** AS Historic Market Data detail report
 
     FASHGLKL1  IF   E           K DISK    INFSR(*PSSR)
      ** AS Hedge Linkage Details
 
     FASHTRNL1  IF   E           K DISK    INFSR(*PSSR)
      ** AS Hedge Transactions File Retrieve
 
     FSDHGSTL1  IF   E           K DISK    INFSR(*PSSR)
      ** SD Hedge Strategy File
 
     FASDLHML3  IF   E           K DISK    RENAME(ASDLHMD0:ASDLHMDD)
     F                                     PREFIX(D_:2)
     F                                     INFSR(*PSSR)
      ** AS Dealing Historic Market Data by Deal No/Value Date
 
     FASDLHML2  IF   E           K DISK    INFSR(*PSSR)
      ** AS Dealing Historic Market Data by Deal No/Value Date
 
     FASLEHML2  IF   E           K DISK    INFSR(*PSSR)
      ** AS Lending Historic Market Data by Loan No/Value Date
 
     FASSEHML0  IF   E           K DISK    INFSR(*PSSR)
      ** AS Securities Historic Market Data by Sec Position/Value Date
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** File Information Data Structure for AS001020P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** File Information Data Structure for AS001020AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry list parameter
     D PSeq            S              5A
     D PLevel          S              1A
     D PEnty           S              3A
     D PHedgeID        S              6A
 
      ** Parameter for ZSFILE
     D PSerr           S              1A
     D PFileNum1       S              6  0
     D PFileNumU       S              6  0
 
      ** Parameters for ZDATE2
     D PZDate          S              6  0
     D PZADate         S              7A
     D PDate           S              5  0
 
      ** Parameters for ZSEDIT
     D PFld15          S             15P 0
     D PDecs           S              1P 0
     D PECode          S              1A
     D POut21          S             21A
 
      ** Parameters for standard access objects
     D PRtCd           S              7A
     D POption         S              7A
     D PCurrency       S              3A
 
      ** Work Variables
     D WRqdLn1         S              3P 0
     D WDifLn1         S              4P 0
     D WOverFlowFlg    S              1A
 
     D WDataPoints     S              4  0
     D WDataCount      S              4  0
     D WHModule        S              2A
     D WBankCcyNDP     S              1P 0
 
      ** Key Field Variables
     D KHedgeID        S                   LIKE(FSHEDI)
     D KDHIndicator    S                   LIKE(FSDHIN)
     D KDrvt           S                   LIKE(FSDLNO)
     D KDlno           S                   LIKE(FSDLNO)
     D KSesn           S                   LIKE(FSFPSE)
     D KBrca           S                   LIKE(FSBRCA)
     D KBkcd           S                   LIKE(FSBKCD)
     D KMkti           S                   LIKE(FSMKTI)
     D KBhtv           S                   LIKE(FSBHTV)
     D KVdat           S                   LIKE(XXVDAT)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EXSR      SRInit
 
     C                   EXSR      SRProc
 
     C                   EXSR      SRAudt
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialisation                                       *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ** RCF Processing for printer file.
 
     C                   EXSR      SRRcfP1
 
      ** RCF Processing for audit file.
 
     C                   EXSR      SRRcfAU
 
      ** Report Work fields.
 
     C                   EVAL      WRqdLn1 = *ZERO
     C                   EVAL      WDifLn1 = *ZERO
     C                   EVAL      WOverFlowFlg = 'N'
     C                   EVAL      PrtLn1 = *ZERO
     C                   EVAL      RCOUNT = *ZERO
 
      **
 
     C                   EVAL      PCurrency = BJCYCD
     C                   EXSR      SRCcy
     C                   EVAL      WBankCcyNDP = A6NBDP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProc - Process report                                       *
      *                                                               *
      *****************************************************************
 
     C     SRProc        BEGSR
 
      ** Print Header
 
     C                   WRITE     HEADP1
 
      ** Access all Hedge linkages if parameter is set to 'ALL   '
      ** =========================================================
 
     C                   IF        PHedgeID = 'ALL   '
     C                   READ      ASHGLKL1
     C                   DOW       NOT %EOF(ASHGLKL1)
 
      ** Process live or discontinued hedge linkages only
 
     C                   IF        FSRECI = 'D' OR FSRECI = 'X'
 
      ** ...and only those with method of effectiveness equal to 'R'
 
     C     FSHGST        CHAIN     SDHGSTL1
     C                   IF        %FOUND(SDHGSTL1)
     C                   IF        FSMEFF = 'R'
     C                   MOVE      FSHEDI        KHedgeID
     C                   EXSR      SRHedgeData
     C                   ENDIF
     C                   ELSE
 
      ** Process database error
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDHGSTL1'
     C                   EVAL      DBKEY = FSHGST
     C                   EVAL      DBASE = 3
     C                   EVAL      DBPROC =  'SRProc'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Read next hedge linkage
 
     C                   READ      ASHGLKL1
     C                   ENDDO
 
      ** else, process specified hedge linkage
      ** ======================================
 
     C                   ELSE
     C                   MOVE      PHedgeID      KHedgeID
     C     KHedgeID      CHAIN     ASHGLKL1
     C                   IF        %FOUND(ASHGLKL1)
     C                   EXSR      SRHedgeData
     C                   ELSE
 
      ** Process database error
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'ASHGLKL1'
     C                   EVAL      DBKEY = PHedgeID
     C                   EVAL      DBASE = 4
     C                   EVAL      DBPROC =  'SRProc'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
 
      ** When EOF, write trailer
 
     C                   EVAL      WRqdLn1 = 4
     C                   EXSR      SRChkLin
 
     C                   WRITE     TRAILP1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHedgeData - Process hedge transaction details               *
      *                                                               *
      *****************************************************************
 
     C     SRHedgeData   BEGSR
 
      ** Set Hedge Linkage ID, Strategy, Effective Date for report.
 
     C                   MOVE      FSHEDI        RHEDI
     C                   EVAL      RHGST = FSHGST
     C                   EVAL      PDate = FSEFFD
     C                   EXSR      SRDate
     C                   EVAL      REFFD = PZADate
 
      ** Retrieve data points and data type to determine number
      ** of historic data and type of data to be printed.
 
     C                   Z-ADD     FSDPTS        WDataPoints
 
      ** Initialise indicators
 
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
 
      ** Set on report indicators to display appropriate label for
      ** collected data based on data type (Market Value, Market
      ** Value Change, or Interest Rates/Market Prices/Index Values)
 
     C                   SELECT
     C                   WHEN      FSDTTP = 'V'
     C                   EVAL      *IN24 = *ON
     C                   WHEN      FSDTTP = 'C'
     C                   EVAL      *IN25 = *ON
     C                   WHEN      FSDTTP = 'R'
     C                   EVAL      *IN26 = *ON
     C                   ENDSL
 
      ** Access Hedge Transaction Details - Derivatives
      ** ===============================================
 
     C                   EVAL      KDHIndicator = 'D'
     C     KHedgeTrn     CHAIN     ASHTRNL1
 
     C                   IF        %FOUND(ASHTRNL1)
     C                   EVAL      KDrvt = FSDLNO
     C                   MOVE      FSDLNO        RDRVT
 
      ** Access Hedge Transaction Details - Hedged Items
      ** ===============================================
 
     C                   EVAL      KDHIndicator = 'H'
     C     KHedgeTrn     CHAIN     ASHTRNL1
 
      ** Set on report indicators to display appropriate header
      ** detail about hedged item
 
     C                   IF        %FOUND(ASHTRNL1)
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *OFF
 
      ** Save Hedged Item's module
 
     C                   EVAL      WHModule = FSMOD
 
     C                   SELECT
      ** Dealing
     C                   WHEN      WHModule = 'DL'
     C                   EVAL      *IN21 = *ON
     C                   EVAL      KDlno = FSDLNO
     C                   MOVE      FSDLNO        RDLNO
      ** Lending
     C                   WHEN      WHModule = 'LE'
     C                   EVAL      *IN22 = *ON
     C                   EVAL      KDlno = FSDLNO
     C                   MOVE      FSDLNO        RDLNO
      ** Securities
     C                   WHEN      WHModule = 'SE'
     C                   EVAL      *IN23 = *ON
 
     C                   EVAL      KSesn = FSFPSE
     C                   EVAL      KBrca = FSBRCA
     C                   EVAL      KBkcd = FSBKCD
     C                   EVAL      KMkti = FSMKTI
     C                   EVAL      KBhtv = FSBHTV
 
     C                   EVAL      RSESN = FSFPSE
     C                   EVAL      RBRCA = FSBRCA
     C                   EVAL      RBKCD = FSBKCD
     C                   EVAL      RMKTI = FSMKTI
     C                   EVAL      RBHTV = FSBHTV
     C                   ENDSL
 
      ** Check for overflow
 
     C                   EVAL      WRqdLn1 = 12
     C                   EXSR      SRChkLin
 
      ** Print Sub-header (Hedge linkage and transaction details)
 
     C                   WRITE     DETAIL1
 
      ** Process Historic Market Details
 
     C                   EXSR      SRMarketData
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMarketData - Process market data details                    *
      *                                                               *
      *****************************************************************
 
     C     SRMarketData  BEGSR
 
      ** Print Sub-header (Historic market data labels)
 
     C                   WRITE     DETAIL2
 
      ** Initialise work variable
 
     C                   EVAL      WDataCount = *ZERO
     C                   EVAL      WOverFlowFlg = 'N'
 
      ** Print historic data if found and while data count is not more
      ** than data points required.
 
     C     KDerivatv     SETLL     ASDLHML3
     C     KDerivatv     READE     ASDLHML3
 
      ** If none was found, write 'No Market Data Collected'
 
     C                   IF        %EOF(ASDLHML3)
     C                   WRITE     DETAIL4
     C                   ENDIF
 
     C                   DOW       NOT %EOF(ASDLHML3) AND
     C                             WDataPoints > WDataCount
 
      ** Initialise report detail output fields
 
     C                   EVAL      RVDAT = *BLANKS
     C                   EVAL      RDMTV = *BLANKS
     C                   EVAL      RHMTV = *BLANKS
 
      ** Value Date
      ** ==========
 
     C                   EVAL      PDate = D_VDAT
     C                   EXSR      SRDate
     C                   EVALR     RVDAT = PZADate
 
      ** Historic Market Data - Hedge Derivative
      ** =======================================
 
     C                   EVAL      PDecs = WBankCcyNDP
     C                   EVAL      PECode = *BLANK
     C                   Z-ADD     *ZERO         PFld15
 
     C                   SELECT
     C                   WHEN      FSDTTP = 'V'
     C                   MOVE      D_MVAL        PFld15
     C                   WHEN      FSDTTP = 'C'
     C                   MOVE      D_MVCA        PFld15
     C                   WHEN      FSDTTP = 'R'
     C                   MOVE      D_MRAT        PFld15
     C                   EVAL      PDecs = 8
     C                   ENDSL
     C                   EVAL      PECode = 'L'
 
     C                   EXSR      SREDIT
     C                   EVALR     RDMTV = POut21
 
      ** Historic Market Data - Hedged Item
      ** ==================================
 
     C                   EVAL      KVdat = D_VDAT
 
     C                   SELECT
     C                   WHEN      WHModule = 'DL'
     C     KDLMktDta     CHAIN     ASDLHML2
     C                   WHEN      WHModule = 'LE'
     C     KDLMktDta     CHAIN     ASLEHML2
     C                   WHEN      WHModule = 'SE'
     C     KSeMktDta     CHAIN     ASSEHML0
     C                   ENDSL
 
     C                   IF        %FOUND (ASDLHML2) AND WHModule = 'DL' OR
     C                             %FOUND (ASLEHML2) AND WHModule = 'LE' OR
     C                             %FOUND (ASSEHML0) AND WHModule = 'SE'
 
     C                   EVAL      PDecs = WBankCcyNDP
     C                   EVAL      PECode = *BLANK
     C                   Z-ADD     *ZERO         PFld15
 
     C                   SELECT
     C                   WHEN      FSDTTP = 'V'
     C                   MOVE      XXMVAL        PFld15
     C                   WHEN      FSDTTP = 'C'
     C                   MOVE      XXMVCA        PFld15
     C                   WHEN      FSDTTP = 'R'
     C                   MOVE      XXMRAT        PFld15
     C                   EVAL      PDecs = 8
     C                   ENDSL
     C                   EVAL      PECode = 'L'
 
     C                   EXSR      SREDIT
     C                   EVALR     RHMTV = POut21
 
     C                   ENDIF
 
      ** Check for overflow
 
     C                   EVAL      WRqdLn1 = 1
     C                   EXSR      SRCHKLIN
 
      ** If overflow, reprint sub-header (Data market labels)
 
     C                   IF        WOverFlowFlg = 'Y'
     C                   WRITE     DETAIL2
     C                   EVAL      WOverFlowFlg = 'N'
     C                   ENDIF
 
 
      ** Print Detail
 
     C                   WRITE     DETAIL3
 
      ** Increment data point counter and record counter
 
     C                   EVAL      WDataCount = WDataCount + 1
     C                   EVAL      RCOUNT = RCOUNT + 1
 
     C     KDerivatv     READE     ASDLHML3
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRcfP1 - Detail Spool File recorded by RCF                   *
      *                                                               *
      *****************************************************************
 
     C     SRRcfP1       BEGSR
 
     C                   OPEN      AS001020P1
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM      PSFNum1       PFileNum1
     C                   PARM      *BLANKS       PSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        PSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRcfAU - Subroutine to register the AU Printer File via RCF  *
      *                                                               *
      *****************************************************************
 
     C     SRRcfAU       BEGSR
 
     C                   OPEN      AS001020AU
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM      PSFNumU       PFileNumU
     C                   PARM      *BLANKS       PSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        PSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDate - Convert Midas Date to DDMMMYY format                 *
      *                                                               *
      *****************************************************************
 
     C     SRDate        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDate
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCcy - Access currency details                               *
      *                                                               *
      *****************************************************************
 
     C     SRCcy         BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POption
     C                   PARM                    PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PCurrency
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREdit - Convert numeric value to appropriate string format   *
      *                                                               *
      *****************************************************************
 
     C     SREdit        BEGSR
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PFld15
     C                   PARM                    PDecs
     C                   PARM                    PECode
     C                   PARM                    POut21
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkLin - Checks for printer file overflow condition         *
      *                                                               *
      *****************************************************************
 
     C     SRChkLin      BEGSR
 
     C                   EVAL      WDifLn1 = OflLn1 - PrtLn1
 
     C                   IF        WDifLn1 <= WRqdLn1
     C                   WRITE     HEADP1
     C                   EVAL      WOverFlowFlg = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SRAudt - Outputs Audit report and ends program                *
      *                                                               *
      *****************************************************************
      *
     C     SRAudt        BEGSR
 
      ** Output report header and file controls
 
     C                   WRITE     HEADAU
 
      ** If there is a DB error, output the DB error information
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Or, if no records read, output "No Details" message
 
     C                   IF        RCOUNT = *ZERO
     C                   WRITE     NODTLS
     C                   ELSE
 
      ** else, output number of data processed
 
     C                   WRITE     CONTROL
     C                   ENDIF
     C                   ENDIF
 
      ** End program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty
     C                   PARM                    PHedgeID
 
      ** Set the Database Program Name
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPgm = 'AS001020'
     C                   OUT       LDA
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key List For ASHTRNL1
 
     C     KHedgeTrn     KLIST
     C                   KFLD                    KHedgeID
     C                   KFLD                    KDHIndicator
 
      ** Key List For ASDLHML2
 
     C     KDerivatv     KLIST
     C                   KFLD                    KHedgeID
     C                   KFLD                    KDrvt
 
      ** Key List For ASDLHML2/ASLEHML2
 
     C     KDLMktDta     KLIST
     C                   KFLD                    KHedgeID
     C                   KFLD                    KDlno
     C                   KFLD                    KVdat
 
      ** Key List For ASSEHML0
 
     C     KSeMktDta     KLIST
     C                   KFLD                    KHedgeID
     C                   KFLD                    KSesn
     C                   KFLD                    KBrca
     C                   KFLD                    KBkcd
     C                   KFLD                    KMkti
     C                   KFLD                    KBhtv
     C                   KFLD                    KVdat
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
 
     C                   EXSR      SRAudt
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
