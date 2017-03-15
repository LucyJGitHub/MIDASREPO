     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Retail Advice for Accnt Trans')               *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  RE000889 - Midas RE Retail Advice for GL Account Transfers   *
      *                                                               *
      *  Function:  This program handles the generation of GL         *
      *             advices if Correspondence Manager is switched     *
      *             off.                                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. CGL154             Date 13Oct14               *
      *  Prev Amend No. AR1000542 *CREATE  Date 26Apr16               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CGL154 - FATCA Reporting (Recompile)                         *
      *  AR1000542 - Online Printing of Retail Advices not printed    *
      *              for Account Transfers. Created RE000889 to       *
      *              handle printing of account transfer retail       *
      *              advice.                                          *
      *            - Applied for MD033905                             *
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
      *  SRAudit    - Prints the audit report.                        *
      *  *PSSR      - Program Exception Subroutine                    *
      *  *INZSR     - Program Initialisation Subroutine               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** � F-specs                              �
      ** � =======                              �
      ** +--------------------------------------+

     FREADVCL0  UF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Settled Transaction Index File by RPRGMN/RREFNO

     FRERSACL4  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account Movements by OTR1

     FGLATMIL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL GL Account Transfer Manual Input R1BRCA/R1TREF

     FREIAC     IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Interest & Charges File by CNUM/CCY/ACOD/ASEQ/BRCH

     FRE000881P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLP1)
      ** Midas RE Debit/Credit Retail Transaction Advices

     FRE000881AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLAU)
      ** Midas RE Debit/Credit Retail Transaction Advices Audit

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** � D-specs                              �
      ** � =======                              �
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** � Named Constants                      �
      ** � ===============                      �
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** � Arrays and Data Structures           �
      ** � ==========================           �
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

      ** +--------------------------------------+
      ** � Declared Variables                   �
      ** � ==================                   �
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
     D WDrCrCount      S              5P 0

      ** Key Fields
     D KCNum           S                   LIKE(CNUM)
     D KCcy            S                   LIKE(CCY)
     D KACod           S                   LIKE(ACOD)
     D KAcSq           S                   LIKE(ACSQ)
     D KBrch           S                   LIKE(BRCA)
     D KPrgMn          S                   LIKE(RPRGMN)
     D KTNmr           S                   LIKE(TNMR)
     D KTref           S                   LIKE(R1TREF)
     D KOtr1           S                   LIKE(OTR1)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------- Start of Main Processing -------------------+
      ** �                                                            �
      ** �  *INZSR is automatically executed at program activation.   �
      ** �                                                            �
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

     C                   EVAL      WDrCrCount = 0
     C                   MOVEL     RREFNO        KOtr1

     C     KOtr1         SETGT     RERSACL4
     C     KOtr1         READPE    RERSACL4                               11

     C                   DOW       *IN11 = *OFF

     C                   IF        RCHTYP='R'
     C                   EVAL      WDrCrCount= WDrCrCount + 1
     C                   ENDIF

     C                   EXSR      SRChkAcc

      ** Print the advice if necessary.

     C                   IF        WPrtAdv = 'Y'
     C                   EXSR      SRPrtAdv
     C                   EVAL      WRecCnt = WRecCnt + 1
     C                   ENDIF

     C     KOtr1         READPE    RERSACL4                               11

     C                   IF        RCHTYP='R'
     C                             AND WDrCrCount=2
     C                   EVAL      *IN11 = *ON
     C                   ENDIF

     C                   ENDDO

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

     C                   MOVEL     BRCA          KBrch
     C                   MOVEL     KOtr1         KTref

     C     KRATM         CHAIN     GLATMIL0

     C                   IF        %FOUND

     C                   IF        R1DRTT = *BLANKS AND DORC = 0
     C                             OR R1CRTT = *BLANKS AND DORC = 1
     C                   EVAL      WRTAPTrA  = 'Y'
     C                   ELSE

     C                   IF        DORC = 0
     C                   EVAL      PRTTyp = R1DRTT
     C                   ELSE
     C                   EVAL      PRTTyp = R1CRTT
     C                   ENDIF

     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PRTTyp
     C     SDRETR        PARM      SDRETR        DSFDY

     C                   IF        PRtCd = *BLANKS

     C                   IF        A1PADI = 'Y'
     C                   EVAL      WRTAPTrA  = 'Y'
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

     C                   EVAL      RPTREF = OTR1

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

     C                   IF        TRYP = 'ZT'
     C                   EVAL      RPTRTD = 'ACCOUNT TRANSFER'
     C                   ENDIF

      ** Transaction Narrative

     C                   IF        NRTD <> *BLANKS
     C                   EVAL      RPTNAR = NRTD
     C                   ELSE
     C                   EVAL      RPTNAR = 'Account Transfer +
     C                             Transaction'
     C                   ENDIF
      *
      ** Narrative should correspond to its posting during cancellation
      *
     C                   IF        RCHTYP = 'R'
     C                   IF        DORC=1
     C                             AND R1DBSN <> *BLANKS
     C                   EVAL      RPTNAR = R1DBSN
     C                   ELSE
     C                   IF        R1CRSN <> *BLANKS
     C                   EVAL      RPTNAR = R1CRSN
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   IF        DORC=0
     C                             AND R1DBSN <> *BLANKS
     C                   EVAL      RPTNAR = R1DBSN
     C                   ELSE
     C                   IF        R1CRSN <> *BLANKS
     C                   EVAL      RPTNAR = R1CRSN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** Currency

     C                   EVAL      RPTCCY = CCYD

      ** Posting Amount

     C                   EXSR      SRCvtMAmt
     C                   EVALR     RPPAMT = WMAmt

      ** Last Transaction Change Type

     C                   EVAL      RPCHTP = *BLANKS
     C                   IF        RCHTYP = 'R'
     C                   EVAL      RPCHTP = 'CANCELLATION'
     C                   ENDIF

      ** Customer Details

     C                   EXSR      SRGetCust
     C                   EVAL      RPCNA1 = BBCNA1
     C                   EVAL      RPCNA2 = BBCNA2
     C                   EVAL      RPCNA3 = BBCNA3
     C                   EVAL      RPCNA4 = BBCNA4

     C                   WRITE     ADVICE

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

     C     KRATM         KLIST
     C                   KFLD                    KBrch
     C                   KFLD                    KTref

      ** Midas RE Interest & Charges File Key List

     C     KIAC          KLIST
     C                   KFLD                    KCNum
     C                   KFLD                    KCcy
     C                   KFLD                    KACod
     C                   KFLD                    KAcSq
     C                   KFLD                    KBrch

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

     C                   ENDSR
