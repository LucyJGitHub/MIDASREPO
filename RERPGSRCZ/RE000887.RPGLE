     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Retail Advice for FT')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE000882 - Midas RE Retail Advice for RE                     *
      *                                                               *
      *  Function:  This program handles the generation of Retail     *
      *             Advices if Correspondence Manager is switched     *
      *             off.                                              *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 23Feb10               *
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
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
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
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRMainIC  - Controls main flow of program if called from IC  *
      *  SRMainCOB - Controls main flow of program if called from COB *
      *  SRPrtAdv  - Prints Transaction Advices.                      *
      *  SRCvtVDat - Converts Value Dates into report-friendly        *
      *               dates.                                          *
      *  SRCvtMAmt - Converts Movement Amounts into report-friendly   *
      *               amounts.                                        *
      *  SRGetCust - Gets Customer Details.                           *
      *  SRExtNarr - Extended Narrative validation                    *                       CER030
      *  SROfCh    - Check for Overflow Indicator                     *                       CER030
      *  SRRegP1    - Registers the P1 printer file via ZSFILE.       *
      *  SRRegAU    - Registers the AU printer file via ZSFILE.       *
      *  SRAudit    - Prints the audit report.                        *
      *  *PSSR     - Program Exception Subroutine                     *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas RE Settled Transaction Index File
     FREADVCL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas RE Account Movements for Online Printing Adv by FUND
     FRERSACL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas Retail Interest and Charges File
     FREIAC     IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas RE Debit/Credit Retail Transaction Advices
     FRE000881P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLP1)
 
      ** Midas RE Debit/Credit Retail Transaction Advices Audit
     FRE000881AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLAU)
      *                                                                                       CER030
      ** Midas FT Inc. Payments                                                               CER030
      *                                                                                       CER030
     FINPAY     IF   E           K DISK    INFSR(*PSSR)                                       CER030
      *                                                                                       CER030
      ** Midas FT Out. Payments                                                               CER030
      *                                                                                       CER030
     FOTPAY     IF   E           K DISK    INFSR(*PSSR)                                       CER030
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D WKeySysVal1     C                   CONST('IncomingPayments    ')
     D WKeySysVal2     C                   CONST('Out/RegularPayments ')
     D WKeySysVal3     C                   CONST('ChequesToBePaid     ')
     D WKeySysVal4     C                   CONST('ChequesToBeCollected')
     D WKeySysVal5     C                   CONST('InRequestForTransfer')
     D WKeySysVal6     C                   CONST('CustCreditTransfer  ')
     D WKeySysVal7     C                   CONST('NostroTransfer      ')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Local Data Area for Database Error Details
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
      ** Data structure for access objects, first DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data structure for access objects, second DS
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Currency Details Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Customer Details Data Structure
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for GL Accounts master detail
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D  BRCA_ACCNT   E                     EXTFLD(BRCA)
 
      ** External DS for  GL Account Movements
     D WDsRSAC       E DS                  EXTNAME(RSACMTPD)
     D  WModule               57     57A
     D  WDelete               58     58A
     D  WSeqnNum              70     72A
 
      ** P1 File Information Data Structure
     D SPOOLP1         DS
     D  PZFileP1              83     92
     D  PZFNumP1             123    124B 0
     D  POfLine              188    189B 0                                                    CER030
     D  PrtLine              367    368B 0                                                    CER030
 
      ** AU File Information Data Structure
     D SPOOLAU         DS
     D  PZFileAU              83     92
     D  PZFNumAU             123    124B 0
 
      ** DS for data to be passed to the Extract Program
     D PDsRetRsac      DS           155
     D  WRetailNum             1     10
     D  WRsacDetls            11    155
 
      ** Data structure for AOSVALR0 string
     D WSVal1          DS           200
     D  PSVal1                 1    200
     D  WSVal1_1               1      1
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
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameter fields
     D PRtnCode        S              7A
     D PInp_CtlPgm     S             10A
 
      ** Parameter fields
     D POption         S              7A
     D PSequence       S              5A
     D PRetail         S             10A
     D PCnum           S              6A
     D PCucd           S              3A
     D PAccd           S             10A
     D PAcsq           S              2A
     D PBrca           S              3A
     D PChgType        S              1A
     D PCcy            S              3A
     D PCust           S             10A
     D PKySt           S              7A
     D PSValK1         S             20A
     D PSValK2         S             20A
     D PSVal2          S            200A
     D PSValK3         S             20A
     D PSVal3          S            200A
     D PSValK4         S             20A
     D PSVal4          S            200A
     D PSValK5         S             20A
     D PSVal5          S            200A
     D PSValK6         S             20A
     D PSVal6          S            200A
     D PSValK7         S             20A
     D PSVal7          S            200A
     D PSValK8         S             20A
     D PSVal8          S            200A
     D PSValK9         S             20A
     D PSVal9          S            200A
     D PSValK0         S             20A
     D PSVal0          S            200A
      *                                                                                       CER030
      ** Parameters for CER030                                                                CER030
      *                                                                                       CER030
     D PSard           S              6A                                                      CER030
     D CER031          S              1A                                                      CER030
     D CFT003          S              1A                                                      CER030
     D WCusno          S              6A                                                      CER030
     D WAcod           S             10A                                                      CER030
     D WAcsq           S              2A                                                      CER030
     D WFund           S             15A                                                      CER030
     D WRem            S              2  0                                                    CER030
      *                                                                                       CER030
     D PNwrk           S              6A                                                      CER030
     D PMsgTyp         S              3A                                                      CER030
     D*PCusno***       S              6  0                                            CER030  CER059
     D PCusno          S              6A                                                      CER059
     D PAcod           S             10S 0                                                    CER030
     D PAcsqn          S              2S 0                                                    CER030
     D PDCIn           S              1A                                                      CER030
     D PRtty           S              5A                                                      CER030
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
 
      ** Standard Utility Parameters
     D PZDayNo         S              5P 0
     D PZDatFmt        S              1A
     D PZDate          S              6P 0
     D PZADate         S              7A
     D PZAmt           S             16A
     D PZNoDP          S              1P 0
     D PZSNum          S              6P 0
     D PZSeq           S              5A
     D PZEnty          S              3A
     D PZSErr          S              1A
 
      ** Key List Fields for REIAC
     D*KCnum****       S              6S 0                                                    CSD027
     D KCnum           S              6A                                                      CSD027
     D KCcy            S              3A
     D KAcod           S             10S 0
     D KAcsq           S              2S 0
     D KBrca           S              3A
 
      ** Work Variables
     D WCounter        S              5P 0
     D WFTRef          S             21A
     D WVDat           S              7A
     D WMAmt           S             16A
     D WRecCnt         S              5P 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Execute main subroutine
 
     C                   IF        PInp_CtlPgm = 'REC000079'
     C                   EXSR      SRMainCOB
     C                   ELSE
     C                   EXSR      SRMainIC
     C                   ENDIF
 
      ** Print the audit report.
 
     C                   EXSR      SRAudit
 
      ** Termination
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMainIC - Controls main flow of program for Input Cycle     *
      *                                                               *
      *****************************************************************
     C     SRMainIC      BEGSR
 
     C                   EVAL      WRecCnt = *ZERO
 
      ** Process all the records from RE Settled Transaction Index File
      ** with Transaction Maintenance Program equal to Control Program.
 
     C     PInp_CtlPgm   SETLL     READVCL0
     C     PInp_CtlPgm   READE     READVCL0                               10
 
     C                   DOW       *IN10 = *OFF
 
     C                   EVAL      WFTRef = RREFNO
 
      ** Process only those records on Movements File which refer to
      ** the Transaction read.
 
     C     WFTRef        SETGT     RERSACL1
     C     WFTRef        READPE    RERSACL1                               11
 
     C                   DOW       *IN11 = *OFF
 
     C                   IF        WDelete = '*'
     C                   IF        RSEQNO = WSeqnNum
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WDelete <> '*'
 
     C                   IF        RSEQNO = WSeqnNUm
 
      ** The account must refer to a Retail Account.
 
     C                   MOVEL     CUSN          PCnum
     C                   EVAL      PCucd = CCYD
     C                   MOVEL     ACDE          PAccd
     C                   MOVEL     ASNC          PAcsq
     C                   EVAL      PBrca = BRCA
 
     C                   CALL      'AOACCTR0'
     C                   PARM      '*MSG'        PRtnCode
     C                   PARM      '*KEY  '      POption
     C                   PARM      *BLANK        PRetail
     C                   PARM                    PCnum
     C                   PARM                    PCucd
     C                   PARM                    PAccd
     C                   PARM                    PAcsq
     C                   PARM                    PBrca
     C     ACCNT         PARM      ACCNT         DSSDY
 
     C                   IF        PRtnCode <> *BLANKS
     C                   EVAL      DBFILE = 'AOACCTR0'
     C                   EVAL      DBKEY = PCnum + PCucd + PAccd + PAcsq + PBrca
     C                   EVAL      DBASE  = 01
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        ATYP = 'R'
 
      ** The account must allow printing of Transaction Advices.
 
     C                   EVAL      KCnum = CUSN
     C                   EVAL      KCcy  = CCYD
     C                   EVAL      KAcod = ACDE
     C                   EVAL      KAcsq = ASNC
     C                   EVAL      KBrca = BRCA
 
     C     KReiac        CHAIN     REIAC                              11
 
     C                   IF        *IN11 = *OFF AND PTRA = 'Y'
 
      ** Print Transaction Advice
 
     C                   EVAL      WRecCnt = WRecCnt + 1
     C                   EXSR      SRPrtAdv
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Read next record until EOF or end of processing for the
      ** transaction read.
 
     C     WFTRef        READPE    RERSACL1                               11
 
     C                   IF        *IN11 = *OFF AND
     C                             WDelete = '*'
     C                   IF        RSEQNO = WSeqnNum
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
      ** If no error occurred, set the Retail Settlement Advice Print Indicator
      ** to 'Y'.
 
     C                   EVAL      RSAPIN = 'Y'
     C                   UPDATE    READVCD0
 
     C                   COMMIT
 
     C     PInp_CtlPgm   READE     READVCL0                               10
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMainCOB - Controls main flow of program for Input Cycle    *
      *                                                               *
      *****************************************************************
     C     SRMainCOB     BEGSR
 
      ** Read all records in Midas RE Account Movements for Online Printing Advice.
 
     C     *LOVAL        SETLL     RERSACL1
     C                   READ      RERSACL1                               11
 
     C                   DOW       *IN11 = *OFF
 
     C                   IF        WModule = 'G'
 
      ** Initialise the first system value key
 
     C                   SELECT
 
     C                   WHEN      TRYP = 'IN'
     C                   EVAL      PSValK1 = WKeySysVal1
 
     C                   WHEN      TRYP = 'OP' or
     C                             TRYP = 'RP'
     C                   EVAL      PSValK1 = WKeySysVal2
 
     C                   WHEN      TRYP = 'CP'
     C                   EVAL      PSValK1 = WKeySysVal3
 
     C                   WHEN      TRYP = 'CC'
     C                   EVAL      PSValK1 = WKeySysVal4
 
     C                   WHEN      TRYP = 'RI' or
     C                             TRYP = 'RO'
     C                   EVAL      PSValK1 = WKeySysVal5
 
     C                   WHEN      TRYP = 'BI' or
     C                             TRYP = 'BO'
     C                   EVAL      PSValK1 = WKeySysVal6
 
     C                   WHEN      TRYP = 'NT'
     C                   EVAL      PSValK1 = WKeySysVal7
 
     C                   ENDSL
 
      * Retrieve the system value
 
     C                   CALL      'AOSVALR0'
     C                   PARM                    PRtnCode
     C                   PARM                    PSValK1
     C                   PARM                    PSVal1
     C                   PARM                    PSValK2
     C                   PARM                    PSVal2
     C                   PARM                    PSValK3
     C                   PARM                    PSVal3
     C                   PARM                    PSValK4
     C                   PARM                    PSVal4
     C                   PARM                    PSValK5
     C                   PARM                    PSVal5
     C                   PARM                    PSValK6
     C                   PARM                    PSVal6
     C                   PARM                    PSValK7
     C                   PARM                    PSVal7
     C                   PARM                    PSValK8
     C                   PARM                    PSVal8
     C                   PARM                    PSValK9
     C                   PARM                    PSVal9
     C                   PARM                    PSValK0
     C                   PARM                    PSVal0
 
      ** If the system value is not found then issue a database error
 
     C                   IF        PRtnCode <> *BLANKS
     C                   IF        PSVal0 = '*NRF'
     C                   EVAL      DBKEY  = PSValK0
     C                   ENDIF
     C                   IF        PSVal9 = '*NRF'
     C                   EVAL      DBKEY  = PSValK9
     C                   ENDIF
     C                   IF        PSVal8 = '*NRF'
     C                   EVAL      DBKEY  = PSValK8
     C                   ENDIF
     C                   IF        PSVal7 = '*NRF'
     C                   EVAL      DBKEY  = PSValK7
     C                   ENDIF
     C                   IF        PSVal6 = '*NRF'
     C                   EVAL      DBKEY  = PSValK6
     C                   ENDIF
     C                   IF        PSVal5 = '*NRF'
     C                   EVAL      DBKEY  = PSValK5
     C                   ENDIF
     C                   IF        PSVal4 = '*NRF'
     C                   EVAL      DBKEY  = PSValK4
     C                   ENDIF
     C                   IF        PSVal3 = '*NRF'
     C                   EVAL      DBKEY  = PSValK3
     C                   ENDIF
     C                   IF        PSVal2 = '*NRF'
     C                   EVAL      DBKEY  = PSValK2
     C                   ENDIF
     C                   IF        PSVal1 = '*NRF'
     C                   EVAL      DBKEY  = PSValK1
     C                   ENDIF
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE  = 02
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        WSVal1_1 =  'Y'
 
     C                   MOVEL     CUSN          PCnum
     C                   EVAL      PCucd = CCYD
     C                   MOVEL     ACDE          PAccd
     C                   MOVEL     ASNC          PAcsq
     C                   EVAL      PBrca = BRCA
 
     C                   CALL      'AOACCTR0'
     C                   PARM      '*MSG'        PRtnCode
     C                   PARM      '*KEY  '      POption
     C                   PARM      *BLANK        PRetail
     C                   PARM                    PCnum
     C                   PARM                    PCucd
     C                   PARM                    PAccd
     C                   PARM                    PAcsq
     C                   PARM                    PBrca
     C     ACCNT         PARM      ACCNT         DSSDY
 
     C                   IF        PRtnCode <> *BLANKS
     C                   EVAL      DBFILE = 'AOACCTR0'
     C                   EVAL      DBKEY = PCnum + PCucd + PAccd + PAcsq + PBrca
     C                   EVAL      DBASE  = 03
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        ATYP = 'R'
 
      ** The account must allow printing of Transaction Advices.
 
     C                   EVAL      KCnum = CUSN
     C                   EVAL      KCcy  = CCYD
     C                   EVAL      KAcod = ACDE
     C                   EVAL      KAcsq = ASNC
     C                   EVAL      KBrca = BRCA
 
     C     KReiac        CHAIN     REIAC                              11
 
     C                   IF        *IN11 = *OFF AND PTRA = 'Y'
 
      ** Print Transaction Advice.
 
     C                   EVAL      WRecCnt = WRecCnt + 1
     C                   EXSR      SRPrtAdv
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record until EOF.
 
     C                   READ      RERSACL1                               11
 
     C                   ENDDO
 
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
 
     C                   EVAL      RPTREF = FUND
 
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
 
     C                   SELECT
 
     C                   WHEN      TRYP = 'IN'
     C                   EVAL      RPTRTD = 'INCOMING PAYMENTS'
 
     C                   WHEN      TRYP = 'OP'
     C                   EVAL      RPTRTD = 'OUTGOING PAYMENTS'
 
     C                   WHEN      TRYP = 'RP'
     C                   EVAL      RPTRTD = 'REGULAR PAYMENTS'
 
     C                   WHEN      TRYP = 'CP'
     C                   EVAL      RPTRTD = 'CHEQUES TO BE PAID'
 
     C                   WHEN      TRYP = 'CC'
     C                   EVAL      RPTRTD = 'CHEQUES TO BE COLLECTED'
 
     C                   WHEN      TRYP = 'BI'
     C                   EVAL      RPTRTD = 'INCOMING CUSTOMER CREDIT TRANSFER'
 
     C                   WHEN      TRYP = 'BO'
     C                   EVAL      RPTRTD = 'OUTGOING CUSTOMER CREDIT TRANSFER'
 
     C                   WHEN      TRYP = 'RI'
     C                   EVAL      RPTRTD = 'INCOMING REQUEST FOR TRANSFER'
 
     C                   WHEN      TRYP = 'RO'
     C                   EVAL      RPTRTD = 'OUTGOING REQUEST FOR TRANSFER'
 
     C                   WHEN      TRYP = 'NT'
     C                   EVAL      RPTRTD = 'NOSTRO TRANSFER'
 
     C                   ENDSL
 
      ** Transaction Narrative
 
     C                   IF        FUND <> *BLANKS
     C                   EVAL      RPTNAR = FUND
     C                   ELSE
     C                   EVAL      RPTNAR = 'FUNDS TRANSFER TRANSACTION'
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
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      CCYD          PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtnCode = *BLANKS
 
     C                   EVAL      PZAmt = *Blanks
     C                   MOVE      MVAM          PZAmt
 
     C                   CALL      'ZEDIT'
     C                   PARM                    PZAmt
     C                   PARM      A6NBDP        PZNoDP
 
     C                   EVAL      WMAmt = PZAmt
 
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBKey = PCcy
     C                   EVAL      DBase = 04
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
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCust
     C                   PARM      *BLANKS       PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRtnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBKey = PCust
     C                   EVAL      DBase = 05
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
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialization routine                               *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRtnCode
     C                   PARM                    PInp_CtlPgm
 
      ** Key list for REIAC
 
     C     KReiac        KLIST
     C                   KFLD                    KCnum
     C                   KFLD                    KCcy
     C                   KFLD                    KAcod
     C                   KFLD                    KAcsq
     C                   KFLD                    KBrca
 
      ** Register the printer files.
 
     C                   EXSR      SRRegP1
     C                   EXSR      SRRegAU
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtnCode <> *BLANKS
     C                   EVAL      DBFILE = 'AOBANKR0'
     C                   EVAL      DBKEY = POption
     C                   EVAL      DBASE  = 06
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CER030
      ** Check If CER031 is enabled                                                           CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtnCode                                     CER030
     C                   PARM      '*VERIFY'     POption                                      CER030
     C                   PARM      'CER031'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtnCode = *BLANKS                                         CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtnCode <> '*NRF   '                                      CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBKEY = PSard                                              CER030
     C                   EVAL      DBASE  = 07                                                CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER031 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check If CFT003 is enabled                                                           CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtnCode                                     CER030
     C                   PARM      '*VERIFY'     POption                                      CER030
     C                   PARM      'CFT003'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
     C                   IF        PRtnCode = *BLANKS                                         CER030
     C                   EVAL      CFT003 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        PRtnCode <> '*NRF   '                                      CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBKEY = PSard                                              CER030
     C                   EVAL      DBASE  = 08                                                CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CFT003 = 'N'                                               CER030
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
      *  Calls : SROfCh                                               *                       CER030
      *                                                               *                       CER030
      *****************************************************************                       CER030
      *                                                                                       CER030
     C     SRExtNarr     BEGSR                                                                CER030
      *                                                                                       CER030
     C                   EVAL      WFund = FUND                                               CER030
     C                   IF        TRYP = 'IN'                                                CER030
     C     WFund         CHAIN     INPAY                                                      CER030
      *                                                                                       CER030
     C                   IF        %FOUND(INPAY)                                              CER030
      *                                                                                       CER030
     C                   IF        BNCT <> 'C' AND                                            CER030
     C                             BNCT <> 'S' AND                                            CER030
     C                             BNCT <> 'A' AND                                            CER030
     C                             BNCT <> *BLANKS                                            CER030
      *                                                                                       CER030
     C                   EVAL      WCusno = %SUBST(BNC1:1:6)                                  CER030
     C                   EVAL      PCcy = %SUBST(BNC1:7:3)                                    CER030
     C                   EVAL      WAcod = %SUBST(BNC1:10:10)                                 CER030
     C                   EVAL      WAcsq = %SUBST(BNC1:20:2)                                  CER030
     C                   EVAL      PBrca = %SUBST(BNC1:22:3)                                  CER030
      *                                                                                       CER030
     C                   MOVEL     WCusno        PCusno                                       CER030
     C                   MOVEL     WAcod         PAcod                                        CER030
     C                   MOVEL     WAcsq         PAcsqn                                       CER030
     C                   EVAL      WCusno = *BLANKS                                           CER030
     C                   EVAL      WAcod = *BLANKS                                            CER030
     C                   EVAL      WAcsq = *BLANKS                                            CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   EVAL      PCusno = *ZEROS                                            CER030
     C                   EVAL      PCcy  = *BLANKS                                            CER030
     C                   EVAL      PAcod = *ZEROS                                             CER030
     C                   EVAL      PAcsqn = *ZEROS                                            CER030
     C                   EVAL      PBrca = *BLANKS                                            CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   CALL      'MG001900'                                                 CER030
     C                   PARM                    PRtnCode                                     CER030
     C                   PARM      '*FORMAT'     POption                                      CER030
     C                   PARM                    PNwrk                                        CER030
     C                   PARM                    PMsgTyp                                      CER030
     C                   PARM                    PBrca                                        CER030
     C                   PARM                    PCusno                                       CER030
     C                   PARM                    PCcy                                         CER030
     C                   PARM                    PAcod                                        CER030
     C                   PARM                    PAcsqn                                       CER030
     C                   PARM                    PDCin                                        CER030
     C                   PARM                    PRtty                                        CER030
     C                   PARM      IEXT1         PNarr1                                       CER030
     C                   PARM      IEXT2         PNarr2                                       CER030
     C                   PARM      IEXT3         PNarr3                                       CER030
     C                   PARM      IEXT4         PNarr4                                       CER030
     C                   PARM      IEXT5         PNarr5                                       CER030
     C                   PARM      IEXT6         PNarr6                                       CER030
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
     C                   EVAL      EXTNARC = PRtFLn1                                          CER030
     C                   WRITE     P1HEDRC                                                    CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln2 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn2                                          CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln3 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn3                                          CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln4 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn4                                          CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln5 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn5                                          CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln6 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn6                                          CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln7 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn7                                          CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln8 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn8                                          CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln9 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn9                                          CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln10 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn10                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln11 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn11                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln12 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn12                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln13 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn13                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln14 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn14                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln15 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn15                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln16 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn16                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln17 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn17                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln18 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn18                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln19 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn19                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln20 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn20                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ELSEIF    TRYP = 'OP'                                                CER030
     C     WFund         CHAIN     OTPAY                                                      CER030
      *                                                                                       CER030
     C                   IF        %FOUND(OTPAY)                                              CER030
      *                                                                                       CER030
     C                   IF        DSTT = 'F' OR                                              CER030
     C                             DSTT = 'R' OR                                              CER030
     C                             DSTT = 'G'                                                 CER030
      *                                                                                       CER030
     C                   EVAL      WCusno = %SUBST(DST1:1:6)                                  CER030
     C                   EVAL      PCcy = %SUBST(DST1:7:3)                                    CER030
     C                   EVAL      WAcod = %SUBST(DST1:10:10)                                 CER030
     C                   EVAL      WAcsq = %SUBST(DST1:20:2)                                  CER030
     C                   EVAL      PBrca = %SUBST(DST1:22:3)                                  CER030
      *                                                                                       CER030
     C                   MOVEL     WCusno        PCusno                                       CER030
     C                   MOVEL     WAcod         PAcod                                        CER030
     C                   MOVEL     WAcsq         PAcsqn                                       CER030
     C                   EVAL      WCusno = *BLANKS                                           CER030
     C                   EVAL      WAcod = *BLANKS                                            CER030
     C                   EVAL      WAcsq = *BLANKS                                            CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   EVAL      PCusno = *ZEROS                                            CER030
     C                   EVAL      PCcy = *BLANKS                                             CER030
     C                   EVAL      PAcod = *ZEROS                                             CER030
     C                   EVAL      PAcsqn = *ZEROS                                            CER030
     C                   EVAL      PBrca = *BLANKS                                            CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   CALL      'MG001900'                                                 CER030
     C                   PARM                    PRtnCode                                     CER030
     C                   PARM      '*FORMAT'     POption                                      CER030
     C                   PARM                    PNwrk                                        CER030
     C                   PARM                    PMsgTyp                                      CER030
     C                   PARM                    PBrca                                        CER030
     C                   PARM                    PCusno                                       CER030
     C                   PARM                    PCcy                                         CER030
     C                   PARM                    PAcod                                        CER030
     C                   PARM                    PAcsqn                                       CER030
     C                   PARM                    PDCin                                        CER030
     C                   PARM                    PRtty                                        CER030
     C                   PARM      OPEXT1        PNarr1                                       CER030
     C                   PARM      OPEXT2        PNarr2                                       CER030
     C                   PARM      OPEXT3        PNarr3                                       CER030
     C                   PARM      OPEXT4        PNarr4                                       CER030
     C                   PARM      OPEXT5        PNarr5                                       CER030
     C                   PARM      OPEXT6        PNarr6                                       CER030
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
      ** For Credit                                                                           CER030
      *                                                                                       CER030
     C                   IF        CFT003 = 'Y'                                               CER030
      *                                                                                       CER030
     C                   IF        ORCT = 'R' OR                                              CER030
     C                             ORCT = 'P' OR                                              CER030
     C                             ORCT = 'I'                                                 CER030
      *                                                                                       CER030
     C                   EVAL      WCusno = %SUBST(ORC1:1:6)                                  CER030
     C                   EVAL      PCcy = %SUBST(ORC1:7:3)                                    CER030
     C                   EVAL      WAcod = %SUBST(ORC1:10:10)                                 CER030
     C                   EVAL      WAcsq = %SUBST(ORC1:20:2)                                  CER030
     C                   EVAL      PBrca = %SUBST(ORC1:22:3)                                  CER030
      *                                                                                       CER030
     C                   MOVEL     WCusno        PCusno                                       CER030
     C                   MOVEL     WAcod         PAcod                                        CER030
     C                   MOVEL     WAcsq         PAcsqn                                       CER030
     C                   EVAL      WCusno = *BLANKS                                           CER030
     C                   EVAL      WAcod = *BLANKS                                            CER030
     C                   EVAL      WAcsq = *BLANKS                                            CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   EVAL      PCusno = *ZEROS                                            CER030
     C                   EVAL      PCcy = *BLANKS                                             CER030
     C                   EVAL      PAcod = *ZEROS                                             CER030
     C                   EVAL      PAcsqn = *ZEROS                                            CER030
     C                   EVAL      PBrca = *BLANKS                                            CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   CALL      'MG001900'                                                 CER030
     C                   PARM                    PRtnCode                                     CER030
     C                   PARM      '*FORMAT'     POption                                      CER030
     C                   PARM                    PNwrk                                        CER030
     C                   PARM                    PMsgTyp                                      CER030
     C                   PARM                    PBrca                                        CER030
     C                   PARM                    PCusno                                       CER030
     C                   PARM                    PCcy                                         CER030
     C                   PARM                    PAcod                                        CER030
     C                   PARM                    PAcsqn                                       CER030
     C                   PARM                    PDCin                                        CER030
     C                   PARM                    PRtty                                        CER030
     C                   PARM      OPEXC1        PNarr1                                       CER030
     C                   PARM      OPEXC2        PNarr2                                       CER030
     C                   PARM      OPEXC3        PNarr3                                       CER030
     C                   PARM      OPEXC4        PNarr4                                       CER030
     C                   PARM      OPEXC5        PNarr5                                       CER030
     C                   PARM      OPEXC6        PNarr6                                       CER030
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
     C                   EXSR      SROfCh                                                     CER030
      *                                                                                       CER030
     C                   IF        WRem >= POfLine                                            CER030
     C                   WRITE     ADVICE                                                     CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln1 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn1                                          CER030
     C                   WRITE     P1HEDRC                                                    CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln2 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn2                                          CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln3 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn3                                          CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln4 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn4                                          CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln5 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn5                                          CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln6 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn6                                          CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln7 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn7                                          CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln8 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn8                                          CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln9 <> *BLANKS                                         CER030
     C                   EVAL      EXTNARC = PRtFLn9                                          CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln10 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn10                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln11 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn11                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln12 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn12                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln13 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn13                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln14 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn14                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln15 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn15                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln16 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn16                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln17 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn17                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln18 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn18                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln19 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn19                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln20 <> *BLANKS                                        CER030
     C                   EVAL      EXTNARC = PRtFLn20                                         CER030
     C                   WRITE     P1EXTNARC                                                  CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
     C                   ENDIF                                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDSR                                                                CER030
      *****************************************************************                       CER030
      /EJECT                                                                                  CER030
      *****************************************************************                       CER030
      *                                                               *                       CER030
      *  SROfCh - Check for Overflow Indicator                        *                       CER030
      *                                                               *                       CER030
      *  Called by : SRExtNarr                                        *                       CER030
      *                                                               *                       CER030
      *  Calls : None                                                 *                       CER030
      *                                                               *                       CER030
      *****************************************************************                       CER030
      *                                                                                       CER030
     C     SROfCh        BEGSR                                                                CER030
      *                                                                                       CER030
     C                   EVAL      WRem = 2                                                   CER030
      *                                                                                       CER030
     C                   IF        PRtFln1 <> *BLANKS                                         CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln2 <> *BLANKS                                         CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln3 <> *BLANKS                                         CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln4 <> *BLANKS                                         CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln5 <> *BLANKS                                         CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln6 <> *BLANKS                                         CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln7 <> *BLANKS                                         CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln8 <> *BLANKS                                         CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln9 <> *BLANKS                                         CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln10 <> *BLANKS                                        CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln11 <> *BLANKS                                        CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln12 <> *BLANKS                                        CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln13 <> *BLANKS                                        CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln14 <> *BLANKS                                        CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln15 <> *BLANKS                                        CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln16 <> *BLANKS                                        CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln17 <> *BLANKS                                        CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln18 <> *BLANKS                                        CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln19 <> *BLANKS                                        CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtFln20 <> *BLANKS                                        CER030
     C                   EVAL      WRem = WRem + 1                                            CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   EVAL      WRem = WRem + PrtLine                                      CER030
      *                                                                                       CER030
     C                   ENDSR                                                                CER030
