     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Customer income report')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE7604 - Customer Income Report                              *
      *                                                               *
      *  Function: This module generates customer income report.      *
      *                                                               *
      *  Component of: SEC7604 - Customer Income Report               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 190964             Date 12Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186231             Date 13Nov00               *
      *                 186053             Date 10Nov00               *
      *                 185758             Date 30Oct00               *
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  190964 - Display file change missed from 186231 - recompile  *
      *  185758 - Recipient code is always blank in the report        *
      *  186231 - Add reporting currency to prompt - to allow user    *
      *           to print report in one currency.                    *
      *  186053 - Incorrect grand and subtotals, and subtotal breaks  *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of Report Narrative printing                *
      *   02-03       File processing (CHAIN/READ)                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProc - Detail Processing                                   *
      *  SRAudt - Produce Audit Report and End Program                *
      *  SRRcP1 - RCF Processing for P1 Report                        *
      *  SRRcAu - RCF Processing for Audit Report                     *
      *  SRHash - Perform hash totals                                 *
      *  SRHas2 - Perform grand hash totals                           *
      *  SRFmtAmt - Format Amount                                     *
      *  *INZSR - Initialise                                          *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Customer income details file
     FSDCUINL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Security details file
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F)
      *
      ** Customer income report - Details
     FSE7604P1  O    E             PRINTER INFDS(SPOOL1)
     F                                     OFLIND(*IN50)
     F                                     USROPN
      *
      ** Customer income report - Audit
     FSE7604AU  O    E             PRINTER INFDS(SPOOLU)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
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
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
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
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** +-------- The converted ZPOWERZ1 starts here --------------------+                   186231
      *                                                                                       186231
     D POArr           S              7  3 DIM(7) CTDATA PERRCD(1)              POWER ARRAY   186231
      *                                                                                       186231
      ** +-------- The converted ZPOWERZ1 ends here ----------------------+                   186231
      *
     D SPOOL1          DS
      *
      ** File Information Data Structure for SE7604P1.
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
      *
     D SPOOLU          DS
      *
      ** File Information Data Structure for SE7604AU.
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
      *
     D PPARM           DS           100
     D  PFDAT                  1      6A
     D  PTDAT                  7     12A
     D  PCTAX                 13     14A
     D  PETYP                 15     16A
     D  PCNUM                 17     22A
     D  PBOWN                 23     48A
     D  PCDOC                 49     49A
     D  PRCCY                 50     52A                                                      186231
      *
      ** Value Date
     D RVDAT1          DS
     D  RVMTH                  1      2A
     D  RVDAY                  3      4A
     D  RVYR                   5      6A
      *
      ** From Date
     D RFDAT1          DS
     D  RFMNT                  1      2A
     D  RFDAY                  3      4A
     D  RFYR                   5      6A
      *
      ** To Date
     D RTDAT1          DS
     D  RTMNT                  1      2A
     D  RTDAY                  3      4A
     D  RTYR                   5      6A
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @ExRate         S             15  8                                                    186231
     D @ECcyDP         S              1  0                                                    186231
     D @RccyDP         S              1  0                                                    186231
     D @ResultDP       S              1  0
     D PSeq            S              5A
     D PRtcd           S              7A
     D POptn           S              7A
     D PCcy            S              3A
     D PCrtx           S              2
     D PTxbs           S              2
     D PVald           S              5  0
     D PNarr           S             15
     D PTxrt           S              6  4
     D WNBDP           S              1P 0
     D WNMDP           S              1P 0
     D WTaxRate        S             11  7
     D WTaxRateC       S             12
     D*WInzFlg***      S              1                                                       186053
     D WSpcFlg         S              1
     D WSpcInd         S              1
 
     D RFDAT           S              5P 0
     D RTDAT           S              5P 0
 
     D RQDLN1          S              3P 0
     D DIFLN1          S              3P 0
     D SENTY           S              3A
     D ZSERR           S              1A
     D ZSNUM           S              6P 0
     D ZSNUMU          S              6P 0
      *
      ** KList variables
     D KCCY            S              3A   INZ(*BLANKS)
     D KINCD           S              2A   INZ(*BLANKS)
     D KDEPO           S              6A   INZ(*BLANKS)
     D KEXCD           S              2A   INZ(*BLANKS)
     D KTXBS           S              2A   INZ(*BLANKS)
     D KSVAL           S              5P 0 INZ(*ZEROS)
     D KSECS           S             10A   INZ(*BLANKS)
      *
      ** Parameter list for ZDATE1
     D PDateIs         S              6A
     D PDayNoOut       S              5P 0
     D PErrorFlag      S              1A
      *
      ** Parameter list for ZDATE2
     D PDateIn         S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *
      ** Parameter list for ZSEDITF
     D PAmtIn          S             15P 0
                                                                                              186053
     D*WOAmt*****      S             15P 8                                                    186053
     D WOAmt           S             15  0                                                    186053
     D*WAmt0*****      S             15P 0                                                    186053
     D WAmt0           S             15  0                                                    186053
     D*WAmt1*****      S             15P 1                                                    186053
     D WAmt1           S             15  1                                                    186053
     D*WAmt2*****      S             15P 2                                                    186053
     D WAmt2           S             15  2                                                    186053
     D*WAmt3*****      S             15P 3                                                    186053
     D WAmt3           S             15  3                                                    186053
      *
     D PZDecs          S              1P 0
     D PZECode         S              1A
     D PZEChar         S              1A
     D PZOut21         S             21A
      *
      ** Work variables
     D*WTGROS****      S             15P 8                                                    186053
     D WTGROS          S             15  0                                                    186053
     D*WTTXWS****      S             15P 8                                                    186053
     D WTTXWS          S             15  0                                                    186053
     D*WTTXWU****      S             15P 8                                                    186053
     D WTTXWU          S             15  0                                                    186053
     D*WTNETD****      S             15P 8                                                    186053
     D WTNETD          S             15  0                                                    186053
 
     D*WGGROS****      S             15P 8                                                    186053
     D WGGROS          S             15  0                                                    186053
     D*WGTXWS****      S             15P 8                                                    186053
     D WGTXWS          S             15  0                                                    186053
     D*WGTXWU****      S             15P 8                                                    186053
     D WGTXWU          S             15  0                                                    186053
     D*WGNETD****      S             15P 8                                                    186053
     D WGNETD          S             15  0                                                    186053
 
     D*WGros*****      S             15P 8                                                    186053
     D WGros           S             15  0                                                    186053
     D*WTxws*****      S             15P 8                                                    186053
     D WTxws           S             15  0                                                    186053
     D*WTxwu*****      S             15P 8                                                    186053
     D WTxwu           S             15  0                                                    186053
 
     D WBenAmt1        S             23P 8 INZ(0)                                             186053
     D WBenAmt2        S             23P 8 INZ(0)                                             186053
     D WBenAmt3        S             23P 8 INZ(0)                                             186053
     D WBenAmt4        S             23P 8 INZ(0)                                             186053
                                                                                              186053
     D WIncAmt1        S             23P 8 INZ(0)                                             186053
     D WIncAmt2        S             23P 8 INZ(0)                                             186053
     D WIncAmt3        S             23P 8 INZ(0)                                             186053
     D WIncAmt4        S             23P 8 INZ(0)                                             186053
                                                                                              186053
     D WDepAmt1        S             23P 8 INZ(0)                                             186053
     D WDepAmt2        S             23P 8 INZ(0)                                             186053
     D WDepAmt3        S             23P 8 INZ(0)                                             186053
     D WDepAmt4        S             23P 8 INZ(0)                                             186053
                                                                                              186053
     D WTaxAmt1        S             23P 8 INZ(0)                                             186053
     D WTaxAmt2        S             23P 8 INZ(0)                                             186053
     D WTaxAmt3        S             23P 8 INZ(0)                                             186053
     D WTaxAmt4        S             23P 8 INZ(0)                                             186053
                                                                                              186053
     D W_BOWN          S             26A                                                      186053
     D W_INCD          S              2A                                                      186053
     D W_DEPO          S              6A                                                      186053
                                                                                              186053
     D WCount          S              3P 0
     D WRun            S              1A
     D WriteHead       S              1A
 
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
      *
      ** Perform detail processing.
      *
     C                   EXSR      SRProc
      *
      ** Return.
      *
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Perform detail processing                           *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
      *
      ** Read first record from file.
      *
     C     KPARM         SETLL     SDCUINL0
     C                   READ      SDCUINL0                               02
 
     C                   EVAL      WCount = *ZERO
 
     C                   DOW       *IN02 = *OFF
      *
      ** If event type, customer, beneficiary owner or customer
      ** received documentation status are entered, then process
      ** records based on this selection.
      *
     C                   IF        (PCNUM = *BLANKS OR
     C                             PCNUM = CUCUST) AND
     C                             (PBOWN = *BLANKS OR
     C                             PBOWN = CUBNOW) AND
     C                             (PETYP = *BLANKS OR
     C                             PETYP = CUPSTP) AND
     C                             (PCDOC = *BLANKS OR
     C                             PCDOC = CUCSDC)
      *
      ** Format Date.
     C                   Z-ADD     CUVALD        PDateIn
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *BLANKS       PADateOut
     C                   MOVEL     PDateOut      RVDAT1
      *
      ** Only process records with value date between From Date and
      ** To Date.
     C                   IF        RFDAT <= CUVALD AND
     C                             RTDAT >= CUVALD
     C                   EVAL      WCount = WCount + 1
     C                   EXSR      SRRept
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Read next record.
      *
     C                   READ      SDCUINL0                               02
 
     C                   ENDDO
      *
      ** Perform audit reporting if no records processed. Otherwise,
      ** perform hash totals.
     C                   IF        WCount = *ZERO
     C                   EXSR      SRAudt
     C                   ELSE
     C                   EVAL      *IN01 = *ON
     C***********        EXSR      SRSTotal                                                   186053
     C                   EXSR      SRRept                                                     186053
     C                   EXSR      SRGTotal
     C                   ENDIF
      *
      ** Close printer file.
      *
     C                   CLOSE     SE7604P1
     C                   EXSR      SRRCP1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRept - Perform detail processing                           *
      *                                                               *
      *****************************************************************
     C     SRRept        BEGSR
 
     C                   EVAL      WriteHead = 'N'
     C***********        EVAL      WInzFlg = 'N'                                              186053
     C                   EVAL      WSpcFlg = 'N'
     C                   EVAL      WSpcInd = 'N'
     C                   EVAL      RRECD = CURPCD                               185758
      *
      ** Check if beneficiary owner, Income code, Depot, Exemption code or
      ** Tax basket changes
      *
     C                   EVAL      W_BOWN = RBOWN                                             186053
     C                   IF        CUCUST <> RCNUM AND
     C                             CUBNOW = *BLANKS OR
     C                             CUBNOW <> RBOWN
     C                             OR *IN02 = *ON                                             186053
      *
      ** If not first record read, process subtotal for the
      ** beneficiary owner.
      *
     C                   IF        RBOWN <> *ALL'*'
     C                   EVAL      WSpcFlg = 'Y'
     C                   EVAL      WSpcInd = 'Y'
     C                   EVAL      RSTLE = 'Beneficiary Customer'
     C                   Z-ADD     WBenAmt1      WTGROS                                       186053
     C                   Z-ADD     WBenAmt2      WTTXWS                                       186053
     C                   Z-ADD     WBenAmt3      WTTXWU                                       186053
     C                   Z-ADD     WBenAmt4      WTNETD                                       186053
     C                   EXSR      SRSTotal
     C***********        EVAL      WInzFlg = 'Y'                                              186053
     C                   EXSR      SRInitBen                                                  186053
     C                   ELSE                                                                 186053
     C                   EVAL      W_BOWN = CUBNOW                                            186053
     C                   ENDIF
     C***********        EVAL      RBOWN = CUBNOW                                             186053
     C                   EVAL      WriteHead = 'Y'
 
     C                   ENDIF
 
     C                   EVAL      W_INCD = RINCD                                             186053
     C                   IF        CUINCD <> RINCD
     C                             OR CUBNOW <> W_BOWN                                        186053
     C                             OR *IN02 = *ON                                             186053
      *
      ** If not first record read, process subtotal for the
      ** income code.
      *
     C                   IF        RINCD <> *ALL'*'
 
     C                   IF        WSpcInd = 'Y'
     C                   EVAL      WSpcFlg = 'N'
     C                   ELSE
     C                   EVAL      WSpcFlg = 'Y'
     C                   EVAL      WSpcInd = 'Y'
     C                   ENDIF
 
     C                   EVAL      RSTLE = 'Income code'
     C                   Z-ADD     WIncAmt1      WTGROS                                       186053
     C                   Z-ADD     WIncAmt2      WTTXWS                                       186053
     C                   Z-ADD     WIncAmt3      WTTXWU                                       186053
     C                   Z-ADD     WIncAmt4      WTNETD                                       186053
     C                   EXSR      SRSTotal
     C***********        EVAL      WInzFlg = 'Y'                                              186053
     C                   EXSR      SRInitInc                                                  186053
     C                   ELSE                                                                 186053
     C                   EVAL      W_INCD = CUINCD                                            186053
     C                   ENDIF
     C***********        EVAL      RINCD = CUINCD                                             186053
     C                   EVAL      WriteHead = 'Y'
 
     C                   ENDIF
 
     C                   EVAL      W_DEPO = RDEPO                                             186053
     C                   IF        CUDPTN <> RDEPO
     C                             OR CUBNOW <> W_BOWN                                        186053
     C                             OR CUINCD <> W_INCD                                        186053
     C                             OR *IN02 = *ON                                             186053
      *
      ** If not first record read, process subtotal for the
      ** depot.
      *
     C                   IF        RDEPO <> *ALL'*'
 
     C                   IF        WSpcInd = 'Y'
     C                   EVAL      WSpcFlg = 'N'
     C                   ELSE
     C                   EVAL      WSpcFlg = 'Y'
     C                   EVAL      WSpcInd = 'Y'
     C                   ENDIF
 
     C                   EVAL      RSTLE = 'Depot'
     C                   Z-ADD     WDepAmt1      WTGROS                                       186053
     C                   Z-ADD     WDepAmt2      WTTXWS                                       186053
     C                   Z-ADD     WDepAmt3      WTTXWU                                       186053
     C                   Z-ADD     WDepAmt4      WTNETD                                       186053
     C                   EXSR      SRSTotal
     C***********        EVAL      WInzFlg = 'Y'                                              186053
     C                   EXSR      SRInitDep                                                  186053
     C                   ELSE                                                                 186053
     C                   EVAL      W_DEPO = CUDPTN                                            186053
     C                   ENDIF
     C***********        EVAL      RDEPO = CUDPTN                                             186053
     C                   EVAL      WriteHead = 'Y'
 
     C                   ENDIF
 
      ** Delete level break for Excemption Code:                                              186053
     C***********        IF        CUEXCD <> REXCD                                            186053
      ***********                                                                             186053
      ***If*not*first record read, process subtotal for the                                   186053
      ***excemption code.                                                                     186053
      ***********                                                                             186053
     C***********        IF        REXCD <> *ALL'*'                                           186053
      ***********                                                                             186053
     C***********        IF        WSpcInd = 'Y'                                              186053
     C***********        EVAL      WSpcFlg = 'N'                                              186053
     C***********        ELSE                                                                 186053
     C***********        EVAL      WSpcFlg = 'Y'                                              186053
     C***********        EVAL      WSpcInd = 'Y'                                              186053
     C***********        ENDIF                                                                186053
      ***********                                                                             186053
     C***********        EVAL      RSTLE = 'Excemption Code'                                  186053
     C***********        EXSR      SRSTotal                                                   186053
     C***********        EVAL      WInzFlg = 'Y'                                              186053
     C***********        ENDIF                                                                186053
     C                   EVAL      REXCD = CUEXCD
     C***********        EVAL      WriteHead = 'Y'                                            186053
      ***********                                                                             186053
     C***********        ENDIF                                                                186053
 
     C                   IF        CUTXBS <> RTXBS
     C                             OR CUBNOW <> W_BOWN                                        186053
     C                             OR CUINCD <> W_INCD                                        186053
     C                             OR CUDPTN <> W_DEPO                                        186053
     C                             OR *IN02 = *ON                                             186053
      *
      ** If not first record read, process subtotal for the
      ***excemption*code.***                                                                  186053
      ** tax basket.                                                                          186053
      *
     C                   IF        RTXBS <> *ALL'*'
 
     C                   IF        WSpcInd = 'Y'
     C                   EVAL      WSpcFlg = 'N'
     C                   ELSE
     C                   EVAL      WSpcFlg = 'Y'
     C                   EVAL      WSpcInd = 'Y'
     C                   ENDIF
 
     C                   EVAL      RSTLE = 'Tax Basket '
     C                   Z-ADD     WTaxAmt1      WTGROS                                       186053
     C                   Z-ADD     WTaxAmt2      WTTXWS                                       186053
     C                   Z-ADD     WTaxAmt3      WTTXWU                                       186053
     C                   Z-ADD     WTaxAmt4      WTNETD                                       186053
     C                   EXSR      SRSTotal
     C***********        EVAL      WInzFlg = 'Y'                                              186053
     C                   EXSR      SRInitTax                                                  186053
     C                   ENDIF
     C***********        EVAL      RTXBS = CUTXBS                                             186053
     C                   EXSR      SRTaxRate
     C***********        EVAL      RTXRT = WTaxRateC                                          186231
     C                   EVAL      WriteHead = 'Y'
 
     C                   ENDIF
 
     C                   EVAL      RBOWN = CUBNOW                                             186053
     C                   EVAL      RINCD = CUINCD                                             186053
     C                   EVAL      RDEPO = CUDPTN                                             186053
     C                   EVAL      RTXBS = CUTXBS                                             186053
                                                                                              186053
     C***********        IF        WInzFlg = 'Y'                                              186053
     C***********        Z-ADD     *ZERO         WTGROS                                       186053
     C***********        Z-ADD     *ZERO         WTTXWS                                       186053
     C***********        Z-ADD     *ZERO         WTTXWU                                       186053
     C***********        Z-ADD     *ZERO         WTNETD                                       186053
     C***********        ENDIF                                                                186053
 
      *
      ** Check if customer changes.
      *
     C                   IF        CUCUST <> RCNUM
     C                             AND *IN02 = *OFF                                           186053
      *
      ** If not first record read, process totals for the
      ** customer.
     C                   IF        RCNUM <> *BLANKS
     C                   EXSR      SRGTotal
     C***********        Z-ADD     *ZERO         WTGROS                                       186053
     C***********        Z-ADD     *ZERO         WTTXWS                                       186053
     C***********        Z-ADD     *ZERO         WTTXWU                                       186053
     C***********        Z-ADD     *ZERO         WTNETD                                       186053
 
     C                   Z-ADD     *ZERO         WGGROS
     C                   Z-ADD     *ZERO         WGTXWS
     C                   Z-ADD     *ZERO         WGTXWU
     C                   Z-ADD     *ZERO         WGNETD
                                                                                              186053
     C                   EXSR      SRInitBen                                                  186053
     C                   EXSR      SRInitInc                                                  186053
     C                   EXSR      SRInitDep                                                  186053
     C                   EXSR      SRInitTax                                                  186053
     C                   ENDIF
      *
      ** Check if currency changes.
      *
     C                   IF        CUNCY <> RCCY
     C                   EVAL      RCTAX = CUCRTT
     C                   EVAL      RCCY = CUNCY
                                                                                              186231
     C                   IF        *IN34 = '0'                                                186231
     C                   EVAL      RRCCY = RCCY                                               186231
     C                   ELSE                                                                 186231
     C                   EVAL      RRCCY = PRCCY                                              186231
     C                   END                                                                  186231
      *
      ** Get Nominal currency no. of decimal places.
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      CUNCY         PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     A6NBDP        WNBDP
     C                   Z-ADD     A6NBDP        @ECcyDP                                      186231
 
     C                   ENDIF
      *                                                                                       186231
      ** Get report currency no. of decimal places.                                           186231
     C                   IF        PRCCY <> RCCY                                              186231
     C                   CALLB     'AOCURRR0'                                                 186231
     C                   PARM      *BLANKS       PRtCd                                        186231
     C                   PARM      '*KEY   '     POptn                                        186231
     C                   PARM      RRCCY         PCcy                                         186231
     C     SDCURR        PARM      SDCURR        DSSDY                                        186231
                                                                                              186231
     C                   IF        PRtCd <> *BLANKS                                           186231
     C     *LOCK         IN        LDA                                                        186231
     C                   EVAL      DBKEY = RRCCY                                              186231
     C                   EVAL      DBFILE = 'SDCURRPD'                                        186231
     C                   EVAL      DBASE = 5                                                  186231
     C                   OUT       LDA                                                        186231
     C                   EXSR      *PSSR                                                      186231
     C                   ENDIF                                                                186231
                                                                                              186231
     C                   Z-ADD     A6NBDP        WNBDP                                        186231
     C                   Z-ADD     A6NBDP        @RCcyDP                                      186231
     C                   ENDIF                                                                186231
      *
      ** Prepare main header fields.
     C                   EVAL      RCNUM = CUCUST
     C                   EVAL      RGCNUM = CUCUST
     C                   EVAL      RCADR = CUCNAM
     C                   WRITE     SE7604H1
     C                   EVAL      WriteHead = 'Y'
     C                   ENDIF
      *
      ** Write sub-header details.
      *
     C                   IF        WriteHead = 'Y'
     C                             AND *IN02 = *OFF                                           186053
     C                   WRITE     SE7604L1
     C                   WRITE     SE7604H2
     C                   WRITE     SE7604H3
     C                   ENDIF
      *
      ** Process record details.
      *
     C                   IF        *IN02 = *OFF                                               186053
     C                   EXSR      SRWRec
     C                   ENDIF                                                                186053
     C
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWRec - Process record details                              *
      *                                                               *
      *****************************************************************
     C     SRWRec        BEGSR
      *
      ** Format Date.
      *
     C                   Z-ADD     CUVALD        PDateIn
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDateOut
     C                   PARM      *BLANKS       PADateOut
     C                   MOVEL     PDateOut      RVDAT1
      *
     C                   EVAL      RSECN = CUSECS
     C                   EVAL      RETYP = CUPSTP
      *
      ** Get security's nominal decimal places.
      *
     C     CUSECS        CHAIN     SECTY                              03
     C                   IF        *IN03 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SECTY  '
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     FNMDP         WNMDP
      *
      ** Format report amounts.
      ** (Only if Report Currency conversion is not needed)                                   186231
      *
     C                   IF        *IN34 = '0'                                                186231
     C                   Z-ADD     *ZERO         PAmtIn
     C                   MOVE      CUNOML        PAmtIn
     C                   Z-ADD     WNMDP         PZDecs
     C                   MOVE      *BLANK        PZECode
     C                   EXSR      SRFmtAmt
     C                   EVAL      RNOMA = PZout21
      *                                                                                       186231
      ** ELSE get exchange Rate                                                               186231
      *                                                                                       186231
     C                   ELSE                                                                 186231
                                                                                              186231
     C                   EVAL      @Amt = 100000                                              186231
     C                   CALL      'GL0765'                                                   186231
     C                   PARM                    @RTCD             7                          186231
     C                   PARM      RCCY          @FrmCcy           3                          186231
     C                   PARM      PRCCY         @ToCcy            3                          186231
     C                   PARM      CUVALD        @PDATE            5 0                        186231
     C                   PARM                    @Amt             19 0                        186231
      *                                                                                       186231
      ** Adjust the amount with DP for the event ccy and report ccy                           186231
      *                                                                                       186231
     C                   EVAL      @ResultDP = 4 + @ECcyDP - @RCcyDP                          186231
     C                   EVAL      @ExRate = @Amt * PoArr(@ResultDP) /100000                  186231
                                                                                              186231
     C                   Z-ADD     *ZERO         PAmtIn                                       186231
     C                   MOVE      @ExRate       PAmtIn                                       186231
     C                   Z-ADD     8             PZDecs                                       186231
     C                   MOVE      'J'           PZECode                                      186231
     C                   EXSR      SRFmtAmt                                                   186231
     C                   EVAL      RNOMA = PZout21                                            186231
     C                   ENDIF                                                                186231
      *
      ** Gross Dividend.
     C                   IF        CUPSTP = 'MT'
     C                   Z-ADD     CUDAMT        WOAmt
     C                   ELSE
     C                   Z-ADD     CUGRDI        WOAmt
     C                   ENDIF
      *                                                                                       186231
      ** If reporting ccy is not the same as event ccy                                        186231
      *                                                                                       186231
     C                   IF        *IN34 = '1'                                                186231
     C                   EVAL      @Amt = WOAmt                                               186231
     C                   CALL      'GL0765'                                                   186231
     C                   PARM                    @RTCD             7                          186231
     C                   PARM      RCCY          @FrmCcy           3                          186231
     C                   PARM      PRCCY         @ToCcy            3                          186231
     C                   PARM      CUVALD        @PDATE            5 0                        186231
     C                   PARM                    @Amt             19 0                        186231
                                                                                              186231
     C                   EVAL      WOAmt = @Amt                                               186231
                                                                                              186231
     C                   ENDIF                                                                186231
      *
     C                   EXSR      SRHalfAdj
     C                   Z-ADD     WNBDP         PZDecs
     C                   MOVE      'J'           PZECode
     C                   EXSR      SRFmtAmt
     C                   EVAL      RGROS = PZout21
     C***********        ADD       WOAmt         WTGROS                                       186053
     C                   ADD       WOAmt         WGGROS                                       186053
     C                   ADD       WOAmt         WBenAmt1                                     186053
     C                   ADD       WOAmt         WIncAmt1                                     186053
     C                   ADD       WOAmt         WDepAmt1                                     186053
     C                   ADD       WOAmt         WTaxAmt1                                     186053
     C                   Z-ADD     WOAmt         WGros
      *
      ** Tax Withheld At Source.
     C                   Z-ADD     CUTXWS        WOAmt
      *                                                                                       186231
      ** If reporting ccy is not the same as event ccy                                        186231
      *                                                                                       186231
     C                   IF        *IN34 = '1'                                                186231
     C                   EVAL      @Amt = WOAmt                                               186231
     C                   CALL      'GL0765'                                                   186231
     C                   PARM                    @RTCD             7                          186231
     C                   PARM      RCCY          @FrmCcy           3                          186231
     C                   PARM      PRCCY         @ToCcy            3                          186231
     C                   PARM      CUVALD        @PDATE            5 0                        186231
     C                   PARM                    @Amt             19 0                        186231
                                                                                              186231
     C                   EVAL      WOAmt = @Amt                                               186231
                                                                                              186231
     C                   ENDIF                                                                186231
     C                   EXSR      SRHalfAdj
     C                   EXSR      SRFmtAmt
     C                   EVAL      RTXWS = PZout21
     C***********        ADD       WOAmt         WTTXWS                                       186053
     C                   ADD       WOAmt         WGTXWS                                       186053
     C                   ADD       WOAmt         WBenAmt2                                     186053
     C                   ADD       WOAmt         WIncAmt2                                     186053
     C                   ADD       WOAmt         WDepAmt2                                     186053
     C                   ADD       WOAmt         WTaxAmt2                                     186053
     C                   Z-ADD     WOAmt         WTxws
      *
      ** Tax Withheld By User.
     C                   Z-ADD     CUTXWU        WOAmt
      *                                                                                       186231
      ** If reporting ccy is not the same as event ccy                                        186231
      *                                                                                       186231
     C                   IF        *IN34 = '1'                                                186231
     C                   EVAL      @Amt = WOAmt                                               186231
     C                   CALL      'GL0765'                                                   186231
     C                   PARM                    @RTCD             7                          186231
     C                   PARM      RCCY          @FrmCcy           3                          186231
     C                   PARM      PRCCY         @ToCcy            3                          186231
     C                   PARM      CUVALD        @PDATE            5 0                        186231
     C                   PARM                    @Amt             19 0                        186231
                                                                                              186231
     C                   EVAL      WOAmt = @Amt                                               186231
                                                                                              186231
     C                   ENDIF                                                                186231
     C                   EXSR      SRHalfAdj
     C                   EXSR      SRFmtAmt
     C                   EVAL      RTXWU = PZout21
     C***********        ADD       WOAmt         WTTXWU                                       186053
     C                   ADD       WOAmt         WGTXWU                                       186053
     C                   ADD       WOAmt         WBenAmt3                                     186053
     C                   ADD       WOAmt         WIncAmt3                                     186053
     C                   ADD       WOAmt         WDepAmt3                                     186053
     C                   ADD       WOAmt         WTaxAmt3                                     186053
     C                   Z-ADD     WOAmt         WTxwu
      *
      ** Net Dividend.
     C                   Z-ADD     CUNTDV        WOAmt
      *                                                                                       186231
      ** If reporting ccy is not the same as event ccy                                        186231
      *                                                                                       186231
     C                   IF        *IN34 = '1'                                                186231
     C                   EVAL      @Amt = WOAmt                                               186231
     C                   CALL      'GL0765'                                                   186231
     C                   PARM                    @RTCD             7                          186231
     C                   PARM      RCCY          @FrmCcy           3                          186231
     C                   PARM      PRCCY         @ToCcy            3                          186231
     C                   PARM      CUVALD        @PDATE            5 0                        186231
     C                   PARM                    @Amt             19 0                        186231
                                                                                              186231
     C                   EVAL      WOAmt = @Amt                                               186231
                                                                                              186231
     C                   ENDIF                                                                186231
                                                                                              186231
     C                   EVAL      WOAmt = WGros - WTxws - WTxwu
     C                   EXSR      SRHalfAdj
     C                   EXSR      SRFmtAmt
     C                   EVAL      RNETD = PZOut21
     C***********        ADD       WOAmt         WTNETD                                       186053
     C                   ADD       WOAmt         WGNETD                                       186053
     C                   ADD       WOAmt         WBenAmt4                                     186053
     C                   ADD       WOAmt         WIncAmt4                                     186053
     C                   ADD       WOAmt         WDepAmt4                                     186053
     C                   ADD       WOAmt         WTaxAmt4                                     186053
      *
      ** Check that sufficient lines remain for the format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     SE7604H1
     C                   WRITE     SE7604H2
     C                   ENDIF
      *
      ** Write out detail record.
      *
     C                   WRITE     SE7604D1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSTotal - Write Subtotals                                   *
      *                                                               *
      *****************************************************************
     C     SRSTotal      BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C***********        Z-ADD     4             RQDLN1                                       186053
     C                   Z-ADD     9             RQDLN1                                       186053
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     SE7604H1
     C                   WRITE     SE7604H2
     C                   ENDIF
 
     C                   EXSR      SRHash
      *
      ** Write subtotal format.
      *
     C                   IF        WSpcFlg = 'Y'
     C                   WRITE     SE7604L1
     C                   ENDIF
 
     C                   WRITE     SE7604T1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGTotal - Write Grand Totals                                *
      *                                                               *
      *****************************************************************
     C     SRGTotal      BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     SE7604H1
     C                   WRITE     SE7604H2
     C                   ENDIF
 
     C                   EXSR      SRHas2
      *
      ** Write grand total format.
      *
     C                   WRITE     SE7604T2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHash - Perform hash totals                                 *
      *                                                               *
      *****************************************************************
     C     SRHash        BEGSR
      *
      ** Gross Dividend.
     C                   MOVE      'J'           PZECode                                      186231
     C                   Z-ADD     WTGROS        WOAmt
     C                   EXSR      SRHalfAdj
     C                   Z-ADD     WNBDP         PZDecs
     C                   EXSR      SRFmtAmt
     C                   EVAL      RTGROS = PZOut21
     C***********        ADD       WOAmt         WGGROS                                       186053
      *
      ** Tax Withheld At Source.
     C                   Z-ADD     WTTXWS        WOAmt
     C                   EXSR      SRHalfAdj
     C                   EXSR      SRFmtAmt
     C                   EVAL      RTTXWS = PZOut21
     C***********        ADD       WOAmt         WGTXWS                                       186053
      *
      ** Tax Withheld by User.
     C                   Z-ADD     WTTXWU        WOAmt
     C                   EXSR      SRHalfAdj
     C                   EXSR      SRFmtAmt
     C                   EVAL      RTTXWU = PZOut21
     C***********        ADD       WOAmt         WGTXWU                                       186053
      *
      ** Net Dividend.
     C                   Z-ADD     WTNETD        WOAmt
     C                   EXSR      SRHalfAdj
     C                   EXSR      SRFmtAmt
     C                   EVAL      RTNETD = PZOut21
     C***********        ADD       WOAmt         WGNETD                                       186053
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHas2 - Perform grand hash totals                           *
      *                                                               *
      *****************************************************************
     C     SRHas2        BEGSR
      *
      ** Gross Dividend.
     C                   MOVE      'J'           PZECode                                      186231
     C                   Z-ADD     WGGROS        WOAmt
     C                   EXSR      SRHalfAdj
     C                   Z-ADD     WNBDP         PZDecs
     C                   EXSR      SRFmtAmt
     C                   EVAL      RGGROS = PZOut21
      *
      ** Tax Withheld at Source.
     C                   Z-ADD     WGTXWS        WOAmt
     C                   EXSR      SRHalfAdj
     C                   EXSR      SRFmtAmt
     C                   EVAL      RGTXWS = PZOut21
      *
      ** Tax Withheld by User.
     C                   Z-ADD     WGTXWU        WOAmt
     C                   EXSR      SRHalfAdj
     C                   EXSR      SRFmtAmt
     C                   EVAL      RGTXWU = PZOut21
      *
      ** Net Dividend.
     C                   Z-ADD     WGNETD        WOAmt
     C                   EXSR      SRHalfAdj
     C                   EXSR      SRFmtAmt
     C                   EVAL      RGNETD = PZOut21
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHalfAdj - Half adjust 13,8 amounts based on nominal dec.   *
      *              places                                           *
      *                                                               *
      *****************************************************************
     C     SRHalfAdj     BEGSR
 
     C                   Z-ADD     *ZERO         PAmtIn
 
     C                   SELECT
     C                   WHEN      WNBDP = 1
     C                   Z-ADD(H)  WOAmt         WAmt1
     C                   Z-ADD     WAmt1         WOamt
     C                   MOVE      WAmt1         PAmtIn
 
     C                   WHEN      WNBDP = 2
     C                   Z-ADD(H)  WOAmt         WAmt2
     C                   Z-ADD     WAmt2         WOamt
     C                   MOVE      WAmt2         PAmtIn
 
     C                   WHEN      WNBDP = 3
     C                   Z-ADD(H)  WOAmt         WAmt3
     C                   Z-ADD     WAmt3         WOamt
     C                   MOVE      WAmt3         PAmtIn
 
     C                   OTHER
     C                   Z-ADD(H)  WOAmt         WAmt0
     C                   Z-ADD     WAmt0         WOamt
     C                   MOVE      WAmt0         PAmtIn
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtAmt - Format amount for display                         *
      *                                                               *
      *****************************************************************
     C     SRFmtAmt      BEGSR
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    PAmtIn
     C                   PARM                    PZDecs
     C                   PARM                    PZECode
     C                   PARM      *BLANK        PZEChar
     C                   PARM                    PZOut21
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCAu - Subroutine to register the AU Printer File via RCF. *
      *                                                               *
      *****************************************************************
     C     SRRCAu        BEGSR
 
     C                   Z-ADD     SFNUMU        ZSNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C
     C     ZSERR         IFEQ      'Y'
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
      *  SRTaxRate - Get Tax Rate                                     *
      *                                                               *
      *****************************************************************
     C     SRTaxRate     BEGSR
 
     C                   IF        CUTXBS <> *BLANKS
     C                   CALLB     'AOTXBSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      CUCRTT        PCrtx
     C                   PARM      CUTXBS        PTxbs
     C                   PARM      CUVALD        PVald
     C                   PARM      *BLANKS       PNarr
     C                   PARM      *ZERO         PTxrt
 
      ** Database error in file SDTXBSPD
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SDTXBSPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      PTxrt = 0
     C                   ENDIF
 
     C*************      MOVE      *BLANKS       WTaxRateC                                    186231
     C*************      EVAL      WTaxRate = PTxrt                                           186231
     C*************      CALL      'ZM0010'                                                   186231
     C*************      PARM                    WTaxRate                                     186231
     C*************      PARM                    WTaxRateC                                    186231
     C                   Z-ADD     *ZERO         PAmtIn                                       186231
     C                   MOVE      PTxrt         PAmtIn                                       186231
     C                   Z-ADD     4             PZDecs                                       186231
     C                   MOVE      *BLANK        PZECode                                      186231
     C                   EXSR      SRFmtAmt                                                   186231
     C                   MOVE      PZout21       RTXRT                                        186231
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCP1 - Subroutine to register the P1 Printer File via RCF. *
      *                                                               *
      *****************************************************************
     C     SRRCP1        BEGSR
 
     C                   Z-ADD     SFNUM1        ZSNUM
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM                    SENTY
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudt - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *****************************************************************
     C     SRAudt        BEGSR
      *
      ** Output Report header.
      *
     C                   WRITE     SE7604A1
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C                   IF        *INU7 =  *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** If no records read, Output "No Details" message.
      *
     C                   IF        WCount = *ZERO
     C                   WRITE     SE7604A2
     C                   ENDIF
     C                   ENDIF
      *
      ** End Program and Return.
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  186053
      *****************************************************************                       186053
      *                                                               *                       186053
      *  SRInitBen - Initialise Beneficiary Owner subtotals           *                       186053
      *                                                               *                       186053
      *****************************************************************                       186053
     C     SRInitBen     BEGSR                                                                186053
                                                                                              186053
     C                   Z-ADD     *ZERO         WBenAmt1                                     186053
     C                   Z-ADD     *ZERO         WBenAmt2                                     186053
     C                   Z-ADD     *ZERO         WBenAmt3                                     186053
     C                   Z-ADD     *ZERO         WBenAmt4                                     186053
                                                                                              186053
     C                   ENDSR                                                                186053
                                                                                              186053
      *****************************************************************                       186053
      /EJECT                                                                                  186053
      *****************************************************************                       186053
      *                                                               *                       186053
      *  SRInitInc - Initialise Income Code subtotals                 *                       186053
      *                                                               *                       186053
      *****************************************************************                       186053
     C     SRInitInc     BEGSR                                                                186053
                                                                                              186053
     C                   Z-ADD     *ZERO         WIncAmt1                                     186053
     C                   Z-ADD     *ZERO         WIncAmt2                                     186053
     C                   Z-ADD     *ZERO         WIncAmt3                                     186053
     C                   Z-ADD     *ZERO         WIncAmt4                                     186053
                                                                                              186053
     C                   ENDSR                                                                186053
                                                                                              186053
      *****************************************************************                       186053
      /EJECT                                                                                  186053
      *****************************************************************                       186053
      *                                                               *                       186053
      *  SRInitDep - Initialise Depot subtotals                       *                       186053
      *                                                               *                       186053
      *****************************************************************                       186053
     C     SRInitDep     BEGSR                                                                186053
                                                                                              186053
     C                   Z-ADD     *ZERO         WDepAmt1                                     186053
     C                   Z-ADD     *ZERO         WDepAmt2                                     186053
     C                   Z-ADD     *ZERO         WDepAmt3                                     186053
     C                   Z-ADD     *ZERO         WDepAmt4                                     186053
                                                                                              186053
     C                   ENDSR                                                                186053
                                                                                              186053
      *****************************************************************                       186053
      /EJECT                                                                                  186053
      *****************************************************************                       186053
      *                                                               *                       186053
      *  SRInitTax - Initialise Tax Basket subtotals                  *                       186053
      *                                                               *                       186053
      *****************************************************************                       186053
     C     SRInitTax     BEGSR                                                                186053
                                                                                              186053
     C                   Z-ADD     *ZERO         WTaxAmt1                                     186053
     C                   Z-ADD     *ZERO         WTaxAmt2                                     186053
     C                   Z-ADD     *ZERO         WTaxAmt3                                     186053
     C                   Z-ADD     *ZERO         WTaxAmt4                                     186053
                                                                                              186053
     C                   ENDSR                                                                186053
                                                                                              186053
      *****************************************************************                       186053
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ
     C                   PARM                    PPARM
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   OUT       LDA
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Generate audit report.
      *
     C                   EXSR      SRRCAU
      *
      ** Report Work fields.
      *
     C                   EVAL      RQDLN1 = *ZERO
     C                   EVAL      DIFLN1 = *ZERO
      *
      ** Define key lists.
      *
     C     KPARM         KLIST
     C                   KFLD                    PCTAX
     C                   KFLD                    KCCY
     C                   KFLD                    PCNUM
     C                   KFLD                    PBOWN
     C                   KFLD                    KINCD
     C                   KFLD                    KDEPO
     C                   KFLD                    KEXCD
     C                   KFLD                    KTXBS
     C                   KFLD                    KSVAL
     C                   KFLD                    KSECS
      *
      ** Initialise RBOWN to be equal to all '*'.
      *
     C                   EVAL      RBOWN = *ALL'*'
     C                   EVAL      RINCD = *ALL'*'
     C                   EVAL      RDEPO = *ALL'*'
     C************       EVAL      REXCD = *ALL'*'                                            186053
     C                   EVAL      RTXBS = *ALL'*'
      *
      ** Format header date.
      *
     C                   EVAL      RFDAT1 = PFDAT
     C                   EVAL      RTDAT1 = PTDAT
      *
      ** Convert From/To Date to day number.
      *
     C                   EVAL      PDateIs = PFDAT
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDateIs
     C                   PARM      *ZERO         PDayNoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrorFlag
     C                   Z-ADD     PDayNoOut     RFDAT
      *
     C                   EVAL      PDateIs = PTDAT
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDateIs
     C                   PARM      *ZERO         PDayNoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        PErrorFlag
     C                   Z-ADD     PDayNoOut     RTDAT
                                                                                              186231
     C                   IF        PRCCY = *BLANK                                             186231
     C                   MOVE      '0'           *IN34                                        186231
     C                   ELSE                                                                 186231
     C                   MOVE      '1'           *IN34                                        186231
     C                   END                                                                  186231
      *
      ** Open printer file.
      *
     C                   OPEN      SE7604P1
     C                   EXSR      SRRCP1
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
 
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
      *
      ** Check to see that *PSSR has not already been called.
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   EXSR      SRAudt
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  POArr - ARRAY OF POWERS FOR CURRENCY CONVERSION  (MEMBER ZPOWERZ2)
0000001
0000010
0000100
0001000
0010000
0100000
1000000
