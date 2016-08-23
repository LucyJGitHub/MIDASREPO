     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Retail Advice for GL')                        *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  RE000882 - Midas RE Retail Advice for GL                     *
      *                                                               *
      *  Function:  This program handles the generation of GL         *
      *             advices if Correspondence Manager is switched     *
      *             off.                                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CRE020   *CREATE   Date 20Jan04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of Indicators                                       *
      *                                                               *
      *  U7+U8 - Database Error                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRIC       - Handles Input Cycle processing.                 *
      *  SRChkAdv   - Checks the advice index file.                   *
      *  SRChkAcc   - Checks the current account.                     *
      *  SRIsRetAcc - Checks if the current account is a RE Account.  *
      *  SRAcAPTrA  - Checks if the current account allows the        *
      *               printing of Transaction Advices.                *
      *  SRRTAPTrA  - Checks if the current Retail Transaction Type   *
      *               allows the printing of Transaction Advices.     *
      *  SRPrtAdv   - Prints Transaction Advices.                     *
      *  SRCvtVDat  - Converts Value Dates into report-friendly       *
      *               dates.                                          *
      *  SRCvtMAmt  - Converts Movement Amounts into report-friendly  *
      *               amounts.                                        *
      *  SRGetCust  - Gets Customer Details.                          *
      *  SRRegP1    - Registers the P1 printer file via ZSFILE.       *
      *  SRRegAU    - Registers the AU printer file via ZSFILE.       *
      *  SRExtNarr  - Extended Narrative validation                   *                       CER030
      *  SRAudit    - Prints the audit report.                        *
      *  *PSSR      - Program Exception Subroutine                    *
      *  *INZSR     - Program Initialisation Subroutine               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FREADVCL0  UF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Settled Transaction Index File by RPRGMN/RREFNO
 
     FRERSACL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account Movements by TNMR/TRYP
 
     FGLJENPL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Journal Entry Posting Update by BTBTNB/BTBINB
 
     FREIAC     IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Interest & Charges File by CNUM/CCY/ACOD/ASEQ/BRCH
 
     FRE000881P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLP1)
      ** Midas RE Debit/Credit Retail Transaction Advices
 
     FRE000881AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLAU)
      ** Midas RE Debit/Credit Retail Transaction Advices Audit
 
      *                                                                                       CER030
      ** Midas GL Journal entry add Info Retrieval                                            CER030
      *                                                                                       CER030
     FGLJENXL2  IF   E           K DISK    INFSR(*PSSR)                                       CER030
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local Data Area for Database Error Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details Data Structure
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details Data Structure
 
     D SDRETR        E DS                  EXTNAME(SDRETRPD)
      ** Retail Transaction Type Details Data Structure
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer Details Data Structure
 
     D GLACNT        E DS                  EXTNAME(ACCNTAB)
     D  BRCH         E                     EXTFLD(BRCA)
      ** Account Details Data Structure
 
     D GLACMT        E DS                  EXTNAME(RSACMTPD)
      ** Account Details Data Structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Access Object Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Access Object Data Structure
 
     D SPOOLP1         DS
     D  PZFileP1              83     92
     D  PZFNumP1             123    124B 0
      ** P1 File Information Data Structure
 
     D SPOOLAU         DS
     D  PZFileAU              83     92
     D  PZFNumAU             123    124B 0
      ** AU File Information Data Structure
 
      *                                                                                       CER030
      ** External DS for SAR Details                                                          CER030
      *                                                                                       CER030
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER030
     D SCA_LCD       E                     EXTFLD(LCD)                                        CER030
      *                                                                                       CER030
      ** Array of error message data                                                          CER030
      *                                                                                       CER030
     D MsgDtaXAr       S             45A   DIM(40)                                            CER030
      *                                                                                       CER030
      ** Array of error message IDs                                                           CER030
      *                                                                                       CER030
     D MsgIDXAr        S              7A   DIM(40)                                            CER030
      *                                                                                       CER030
      ** Array of Fields with warnings                                                        CER030
      *                                                                                       CER030
     D WFldNmXAr       S             10A   DIM(40)                                            CER030
      *                                                                                       CER030
      ** Array of warning message data                                                        CER030
      *                                                                                       CER030
     D WMsgDtXAr       S             45A   DIM(40)                                            CER030
      *                                                                                       CER030
      ** Array of warning message IDs                                                         CER030
      *                                                                                       CER030
     D WMsgIDXAr       S              7A   DIM(40)                                            CER030
      *                                                                                       CER030
      ** Array of Fields in error                                                             CER030
      *                                                                                       CER030
     D FldNamXAr       S             10A   DIM(40)                                            CER030
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program Parameters
     D PRtCd           S              7A
     D PCtrlPgm        S             10A
 
      ** Access Object Parameters
     D POptn           S              7A
     D PRetAcc         S             10A
     D PCNum           S              6A
     D PCcy            S              3A
     D PACod           S             10A
     D PASeq           S              2A
     D PBrch           S              3A
     D PRTTyp          S              5A
     D PCust           S             10A
     D PKySt           S              7A
 
      ** Standard Utility Parameters
     D PZSeq           S              5A
     D PZEnty          S              3A
     D PZSNum          S              6P 0
     D PZSErr          S              1A
     D PZDayNo         S              5P 0
     D PZDatFmt        S              1A
     D PZDate          S              6P 0
     D PZADate         S              7A
     D PZAmt           S             16A
     D PZNoDP          S              1P 0
 
      ** Working Variables
     D WRetAcc         S              1A
     D WAcAPTrA        S              1A
     D WRTAPTrA        S              1A
     D WPrtAdv         S              1A
     D WVDat           S              7A
     D WMAmt           S             16A
     D WRecCnt         S              5P 0
 
      *                                                                                       CER030
      ** Varaibles for CER030                                                                 CER030
      *                                                                                       CER030
     D PSard           S              6A                                                      CER030
     D CER031          S              1A                                                      CER030
     D PNwrk           S              6A                                                      CER030
     D PMsgTyp         S              3A                                                      CER030
     D*PCusno***       S              6  0                                            CER030  CER059
     D PCusno          S              6A                                                      CER059
     D PAccd           S             10S 0                                                    CER030
     D PAcsq           S              2S 0                                                    CER030
     D PDCIn           S              1A                                                      CER030
     D PNarr1          S             65A                                                      CER030
     D PNarr2          S             65A                                                      CER030
     D PNarr3          S             65A                                                      CER030
     D PNarr4          S             65A                                                      CER030
     D PNarr5          S             65A                                                      CER030
     D PNarr6          S             65A                                                      CER030
     D PRtFln1         S             70A                                                      CER030
     D PRtFln2         S             70A                                                      CER030
     D PRtFln3         S             70A                                                      CER030
     D PRtFln4         S             70A                                                      CER030
     D PRtFln5         S             70A                                                      CER030
     D PRtFln6         S             70A                                                      CER030
     D PRtFln7         S             70A                                                      CER030
     D PRtFln8         S             70A                                                      CER030
     D PRtFln9         S             70A                                                      CER030
     D PRtFln10        S             70A                                                      CER030
     D PRtFln11        S             70A                                                      CER030
     D PRtFln12        S             70A                                                      CER030
     D PRtFln13        S             70A                                                      CER030
     D PRtFln14        S             70A                                                      CER030
     D PRtFln15        S             70A                                                      CER030
     D PRtFln16        S             70A                                                      CER030
     D PRtFln17        S             70A                                                      CER030
     D PRtFln18        S             70A                                                      CER030
     D PRtFln19        S             70A                                                      CER030
     D PRtFln20        S             70A                                                      CER030
     D Idx             S              3  0                                                    CER030
      ** Key Fields
     D KCNum           S                   LIKE(CNUM)
     D KCcy            S                   LIKE(CCY)
     D KACod           S                   LIKE(ACOD)
     D KAcSq           S                   LIKE(ACSQ)
     D KBrch           S                   LIKE(BRCA)
     D KPrgMn          S                   LIKE(RPRGMN)
     D KBatchNo        S                   LIKE(BTBTNB)
     D KItemNo         S                   LIKE(BTBINB)
     D KTNmr           S                   LIKE(TNMR)
     D KTryp           S                   LIKE(TRYP)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Main Processing
      ** ===============
 
     C                   EXSR      SRIC
 
      ** Print the audit report.
 
     C                   EXSR      SRAudit
 
      ** Pop values off the stack.
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIC - Handles Input Cycle processing.                       *
      *                                                               *
      *****************************************************************
     C     SRIC          BEGSR
 
     C                   EVAL      WRecCnt = *ZERO
 
     C                   EVAL      KPrgMn = PCtrlPgm
 
     C     KPrgMn        SETLL     READVCL0
     C     KPrgMn        READE     READVCL0
 
     C                   DOW       NOT %EOF
 
      ** Check the current advice.
 
     C                   EXSR      SRChkAdv
 
      ** At this point, all Transaction Advices had been submitted
      ** if necessary.
 
     C                   EVAL      RSAPIN = 'Y'
     C                   UPDATE    READVCD0
 
     C     KPrgMn        READE     READVCL0
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkAdv - Checks the advice index file.                     *
      *                                                               *
      *****************************************************************
     C     SRChkAdv      BEGSR
 
     C                   MOVEL     RREFNO        KTNmr
     C                   MOVE      RTRTYP        KTryp
 
     C     KRSAC         SETGT     RERSACL0
     C     KRSAC         READPE    RERSACL0
 
     C                   IF        NOT %EOF
 
     C                   EXSR      SRChkAcc
 
      ** Print the advice if necessary.
 
     C                   IF        WPrtAdv = 'Y'
     C                   EXSR      SRPrtAdv
     C                   EVAL      WRecCnt = WRecCnt + 1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkAcc - Checks the current account.                       *
      *                                                               *
      *****************************************************************
     C     SRChkAcc      BEGSR
 
     C                   EVAL      WPrtAdv = 'N'
 
      ** Check if the current account is a Retail Account.
 
     C                   EXSR      SRIsRetAcc
 
     C                   IF        WRetAcc <> 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Check if the current account allows printing of advices.
 
     C                   EXSR      SRAcAPTrA
 
     C                   IF        WAcAPTrA <> 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Check if the current RE Transaction Type allows the printing
      ** of advices.
 
     C                   EXSR      SRRTAPTrA
 
     C                   IF        WRTAPTrA <> 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   EVAL      WPrtAdv = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIsRetAcc - Checks if the current account is a Retail       *
      *               Account via AOACCTR0.                           *
      *                                                               *
      *****************************************************************
     C     SRIsRetAcc    BEGSR
 
     C                   EVAL      WRetAcc = 'N'
 
     C                   MOVE      CUSN          PCNum
     C                   MOVE      CCYD          PCcy
     C                   MOVE      ACDE          PACod
     C                   MOVE      ASNC          PASeq
     C                   MOVE      BRCA          PBrch
 
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PRetAcc
     C                   PARM                    PCNum
     C                   PARM                    PCcy
     C                   PARM                    PACod
     C                   PARM                    PASeq
     C                   PARM                    PBrch
     C     GLACNT        PARM      GLACNT        DSSDY
 
     C                   IF        PRtCd = *BLANKS
 
     C                   IF        ATYP = 'R'
     C                   EVAL      WRetAcc = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'ACCNTAB'
     C                   EVAL      DBKey = PCNum + PCcy + PACod +
     C                                     PASeq + PBrch
     C                   EVAL      DBase = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcAPTrA - Checks if the current account allows the         *
      *              printing of Transaction Advices.                 *
      *                                                               *
      *****************************************************************
     C     SRAcAPTrA     BEGSR
 
     C                   EVAL      WAcAPTrA = 'N'
 
     C                   EVAL      KCnum = CUSN
     C                   EVAL      KCcy = CCYD
     C                   EVAL      KACod = ACDE
     C                   EVAL      KAcSq = ASNC
     C                   EVAL      KBrch = BRCA
 
     C     KIAC          CHAIN     REIAC
 
     C                   IF        %FOUND AND
     C                             PTRA = 'Y'
     C                   EVAL      WAcAPTrA = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRTAPTrA - Checks if the current Retail Transaction Type    *
      *              allows the printing of Transaction Advices via   *
      *              AORETRR0.                                        *
      *                                                               *
      *****************************************************************
     C     SRRTAPTrA     BEGSR
 
     C                   EVAL      WRTAPTrA = 'N'
 
     C                   MOVEL     TNMR          KBatchNo
     C                   MOVE      TNMR          KItemNo
 
     C     KJENP         CHAIN     GLJENPL0
 
     C                   IF        %FOUND
 
     C                   IF        BTTRTY = *BLANKS
     C                   EVAL      WRTAPTrA = 'Y'
     C                   ELSE
 
     C                   EVAL      PRTTyp = BTTRTY
 
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PRTTyp
     C     SDRETR        PARM      SDRETR        DSFDY
 
     C                   IF        PRtCd = *BLANKS
 
     C                   IF        A1PADI = 'Y'
     C                   EVAL      WRTAPTrA = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDRETRPD'
     C                   EVAL      DBKey = PRTTyp
     C                   EVAL      DBase = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrtAdv - Prints Transaction Advices.                       *
      *                                                               *
      *****************************************************************
     C     SRPrtAdv      BEGSR
 
      ** Transaction Reference
 
     C                   EVAL      RPTREF = TNMR
 
      ** Debit/Credit
 
     C                   IF        DORC = 0
     C                   EVAL      RPDRCR = 'debited '
     C                   ELSE
     C                   EVAL      RPDRCR = 'credited'
     C                   ENDIF
 
      ** Retail Account Number
 
     C                   MOVE      ACNO          RPACCT
 
      ** Value Date
 
     C                   EXSR      SRCvtVDat
     C                   EVAL      RPVDAT = WVDat
 
      ** Transaction Type Description
 
     C                   EVAL      RPTRTD = *BLANKS
 
     C                   IF        TRYP = 'ME'
     C                   EVAL      RPTRTD = 'JOURNAL ENTRY'
     C                   ENDIF
 
      ** Transaction Narrative
 
     C                   IF        NRTD <> *BLANKS
     C                   EVAL      RPTNAR = NRTD
     C                   ELSE
     C                   EVAL      RPTNAR = 'General Ledger +
     C                             Transaction'
     C                   ENDIF
 
      ** Currency
 
     C                   EVAL      RPTCCY = CCYD
 
      ** Posting Amount
 
     C                   EXSR      SRCvtMAmt
     C                   EVALR     RPPAMT = WMAmt
 
      ** Last Transaction Change Type
 
     C                   EVAL      RPCHTP = *BLANKS
 
      ** Customer Details
 
     C                   EXSR      SRGetCust
     C                   EVAL      RPCNA1 = BBCNA1
     C                   EVAL      RPCNA2 = BBCNA2
     C                   EVAL      RPCNA3 = BBCNA3
     C                   EVAL      RPCNA4 = BBCNA4
 
     C                   WRITE     ADVICE
      *                                                                                       CER030
     C                   IF        CER031 = 'Y'                                               CER030
     C                   EXSR      SRExtNarr                                                  CER030
     C                   ENDIF                                                                CER030
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtVDat - Converts Value Dates into report-friendly        *
      *              dates.                                           *
      *                                                               *
      *****************************************************************
     C     SRCvtVDat     BEGSR
 
     C                   CALL      'ZDATE2'
     C                   PARM      VUDT          PZDayNo
     C                   PARM      BJDFIN        PZDatFmt
     C                   PARM      *ZERO         PZDate
     C                   PARM      *BLANKS       PZADate
 
     C                   EVAL      WVDat = PZADate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtMAmt - Converts Movement Amounts into report-friendly   *
      *              amounts.                                         *
      *                                                               *
      *****************************************************************
     C     SRCvtMAmt     BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      CCYD          PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd = *BLANKS
 
     C                   MOVE      MVAM          PZAmt
 
     C                   CALL      'ZEDIT'
     C                   PARM                    PZAmt
     C                   PARM      A6NBDP        PZNoDP
 
     C                   EVAL      WMAmt = PZAmt
 
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBKey = PCcy
     C                   EVAL      DBase = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCust - Gets Customer Details.                           *
      *                                                               *
      *****************************************************************
     C     SRGetCust     BEGSR
 
     C                   MOVEL     CUSN          PCust
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C                   PARM      *BLANKS       PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBKey = PCust
     C                   EVAL      DBase = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Prints the audit report.                           *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
     C                   WRITE     HEADAU
 
     C                   IF        WRecCnt = *ZERO
     C                   WRITE     NODTLS
     C                   ELSE
     C                   EVAL      RCOUNT = WRecCnt
     C                   WRITE     DETAILS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRegP1 - Registers the P1 printer file via ZSFILE.          *
      *                                                               *
      *****************************************************************
     C     SRRegP1       BEGSR
 
     C                   EVAL      PZSNum = PZFNumP1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PZSeq
     C                   PARM                    PZEnty
     C                   PARM                    PZFileP1
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr
 
     C                   IF        PZSErr = 'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRegAU - Registers the AU printer file via ZSFILE.          *
      *                                                               *
      *****************************************************************
     C     SRRegAU       BEGSR
 
     C                   EVAL      PZSNum = PZFNumAU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PZSeq
     C                   PARM                    PZEnty
     C                   PARM                    PZFileAU
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr
 
     C                   IF        PZSErr = 'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry Parameters
      ** ================
 
     C     *ENTRY        PLIST
 
      ** Return Code
      ** Control Program
 
     C                   PARM                    PRtCd
     C                   PARM                    PCtrlPgm
 
      ** Midas GL Journal Entry Posting Update Key List
 
     C     KJENP         KLIST
     C                   KFLD                    KBatchNo
     C                   KFLD                    KItemNo
 
      ** Midas RE Interest & Charges File Key List
 
     C     KIAC          KLIST
     C                   KFLD                    KCNum
     C                   KFLD                    KCcy
     C                   KFLD                    KACod
     C                   KFLD                    KAcSq
     C                   KFLD                    KBrch
 
      ** Midas GL Account Movements Key List
 
     C     KRSAC         KLIST
     C                   KFLD                    KTNmr
     C                   KFLD                    KTryp
 
      ** Register the printer files.
 
     C                   EXSR      SRRegP1
     C                   EXSR      SRRegAU
 
      ** Get bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER030
      ** Check If CER031 is enabled                                                           CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER031'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtCd = *BLANKS                                            CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
     C                   IF        PRtCd <> '*NRF   '                                         CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   EVAL      DBFile = 'SCSARDPD'                                        CER030
     C                   EVAL      DBKey = PSard                                              CER030
     C                   EVAL      DBase = 6                                                  CER030
     C                   OUT       LDA                                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER031 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
 
     C                   ENDSR
      *****************************************************************                       CER030
      /EJECT                                                                                  CER030
      *****************************************************************                       CER030
      *                                                               *                       CER030
      *  SRExtNarr - Extended Narrative validation                    *                       CER030
      *                                                               *                       CER030
      *  Called by : SRPrtAdv                                         *                       CER030
      *                                                               *                       CER030
      *  Calls : *PSSR                                                *                       CER030
      *                                                               *                       CER030
      *****************************************************************                       CER030
      *                                                                                       CER030
     C     SRExtNarr     BEGSR                                                                CER030
      *                                                                                       CER030
     C     KBatchNo      CHAIN     GLJENXL2                                                   CER030
      *                                                                                       CER030
     C                   IF        NOT %FOUND(GLJENXL2)                                       CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   EVAL      DBFile = 'GLJENXL2'                                        CER030
     C                   EVAL      DBKey = KBatchNo                                           CER030
     C                   EVAL      DBase = 7                                                  CER030
     C                   OUT       LDA                                                        CER030
     C                   EXSR      *PSSR                                                      CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   MOVEL     BTCUST        PCusno                                       CER030
     C                   EVAL      PCcy = BTCYCD                                              CER030
     C                   MOVEL     BTACCD        PAccd                                        CER030
     C                   MOVEL     BTACSN        PAcsq                                        CER030
     C                   EVAL      PBrch = BTBCBH                                             CER030
      *                                                                                       CER030
     C                   CALL      'MG001900'                                                 CER030
     C                   PARM                    PRtCd                                        CER030
     C                   PARM      '*FORMAT'     POptn                                        CER030
     C                   PARM                    PNwrk                                        CER030
     C                   PARM                    PMsgTyp                                      CER030
     C                   PARM                    PBrch                                        CER030
     C                   PARM                    PCusno                                       CER030
     C                   PARM                    PCcy                                         CER030
     C                   PARM                    PAccd                                        CER030
     C                   PARM                    PAcsq                                        CER030
     C                   PARM                    PDCin                                        CER030
     C                   PARM                    PRTTyp                                       CER030
     C                   PARM      BAADI1        PNarr1                                       CER030
     C                   PARM      BAADI2        PNarr2                                       CER030
     C                   PARM      BAADI3        PNarr3                                       CER030
     C                   PARM      BAADI4        PNarr4                                       CER030
     C                   PARM      BAADI5        PNarr5                                       CER030
     C                   PARM      BAADI6        PNarr6                                       CER030
     C                   PARM                    PRtFln1                                      CER030
     C                   PARM                    PRtFLn2                                      CER030
     C                   PARM                    PRtFLn3                                      CER030
     C                   PARM                    PRtFLn4                                      CER030
     C                   PARM                    PRtFLn5                                      CER030
     C                   PARM                    PRtFLn6                                      CER030
     C                   PARM                    PRtFLn7                                      CER030
     C                   PARM                    PRtFLn8                                      CER030
     C                   PARM                    PRtFLn9                                      CER030
     C                   PARM                    PRtFLn10                                     CER030
     C                   PARM                    PRtFLn11                                     CER030
     C                   PARM                    PRtFLn12                                     CER030
     C                   PARM                    PRtFLn13                                     CER030
     C                   PARM                    PRtFLn14                                     CER030
     C                   PARM                    PRtFLn15                                     CER030
     C                   PARM                    PRtFLn16                                     CER030
     C                   PARM                    PRtFLn17                                     CER030
     C                   PARM                    PRtFLn18                                     CER030
     C                   PARM                    PRtFLn19                                     CER030
     C                   PARM                    PRtFLn20                                     CER030
     C                   PARM                    Idx                                          CER030
     C                   PARM                    FldNamXAr                                    CER030
     C                   PARM                    MsgIDXAr                                     CER030
     C                   PARM                    MsgDtaXAr                                    CER030
     C                   PARM                    WFldNmXAr                                    CER030
     C                   PARM                    WMsgIDXAr                                    CER030
     C                   PARM                    WMsgDtXAr                                    CER030
      *                                                                                       CER030
     C                   IF        PRtFln1 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARD = PRtFLn1                                          CER030
     C                   WRITE     P1HEDRD                                                    CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln2 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARD = PRtFLn2                                          CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln3 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARD = PRtFLn3                                          CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln4 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARD = PRtFLn4                                          CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln5 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARD = PRtFLn5                                          CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln6 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARD = PRtFLn6                                          CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln7 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARD = PRtFLn7                                          CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln8 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARD = PRtFLn8                                          CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln9 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARD = PRtFLn9                                          CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln10 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARD = PRtFLn10                                         CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln11 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARD = PRtFLn11                                         CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln12 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARD = PRtFLn12                                         CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln13 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARD = PRtFLn13                                         CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln14 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARD = PRtFLn14                                         CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln15 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARD = PRtFLn15                                         CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln16 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARD = PRtFLn16                                         CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln17 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARD = PRtFLn17                                         CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln18 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARD = PRtFLn18                                         CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln19 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARD = PRtFLn19                                         CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln20 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARD = PRtFLn20                                         CER030
     C                   WRITE     P1EXTNARD                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDSR                                                                CER030
