     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Retail Advice for RE')                        *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  RE000883 - Midas RE Retail Advice for RE                     *
      *                                                               *
      *  Function:  This program handles the generation of RE         *
      *             advices if Correspondence Manager is switched     *
      *             off.                                              *
      *                                                               *
      *  Called By: REC000881 in Input Cycle                          *
      *             REC000079 in Close of Business                    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL154             Date 13Oct14               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 23Feb10               *
      *                 CAP204             Date 09Feb10               *
      *                 CAP187             Date 21Aug09               *
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
      *  CGL154 - FATCA Reporting (Recompile)                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CAP187 - Document Linkage (Recompile)                        *
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
      *  SRRegP1    - Registers the P1 printer file via ZSFILE.       *
      *  SRRegAU    - Registers the AU printer file via ZSFILE.       *
      *  SRAudit    - Prints the audit report.                        *
      *  *INZSR    - Program Initialisation Subroutine                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FREADVCL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas RE Settled Transaction Index File
 
     FRERSACL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Account Movements for Online Printing Adv by TNMR/TRYP
 
     FREIAC     IF   E           K DISK    INFSR(*PSSR)
      ** Midas Retail Interest and Charges File
 
     FSTAND     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(STANDSBF)
      ** Midas RE Standing Orders
 
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
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D WKeySysVal1     C                   CONST('StandingOrders      ')
     D WKeySysVal2     C                   CONST('CustomerExchange    ')
 
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
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Retail Transaction Type Details Data Structure
     D SDRETR        E DS                  EXTNAME(SDRETRPD)
 
      ** Midas Switchable features file accessed via access program
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SCLCD        E                     EXTFLD(LCD)
 
      ** External DS for GL Accounts master detail
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D  BRCA_ACCNT   E                     EXTFLD(BRCA)
 
      ** External DS for  GL Account Movements
     D WDsRSAC       E DS                  EXTNAME(RSACMTPD)
     D  WModule               57     57A
     D  WDelete               58     58A
     D  WDebCreInd           125    127A
 
      ** DS for data to be passed to the Extract Program
     D PDsRetRsac      DS           155
     D  WRetailNum             1     10
     D  WRsacDetls            11    155
 
      ** P1 File Information Data Structure
     D SPOOLP1         DS
     D  PZFileP1              83     92
     D  PZFNumP1             123    124B 0
 
      ** AU File Information Data Structure
     D SPOOLAU         DS
     D  PZFileAU              83     92
     D  PZFNumAU             123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameter fields
     D PRtnCode        S              7A
     D PInp_CtlPgm     S             10A
 
      ** Parameter fields
     D POption         S              7A
     D PRetail         S             10A
     D PCnum           S              6A
     D PCucd           S              3A
     D PAccd           S             10A
     D PAcsq           S              2A
     D PBrca           S              3A
     D PCust           S             10A
     D PKySt           S              7A
     D PTranType       S              5A
     D PSARD           S              6A
     D PSValK1         S             20A
     D PSVal1          S            200A
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
 
      ** Key List Fields for RERSACPD
     D KTnmr           S              6A
     D KTryp           S              2A
 
      ** Key List Fields for REIAC
     D*KCnum****       S              6S 0                                                    CSD027
     D KCnum           S              6A                                                      CSD027
     D KCcy            S              3A
     D KAcod           S             10S 0
     D KAcsq           S              2S 0
     D KBrca           S              3A
 
      ** Work Variables
     D WReversal       S              1A
     D WSVal1          S              1A
     D WChar           S              1A
     D WVDat           S              7A
     D WMAmt           S             16A
     D WNarr           S             28A
     D WStor           S              5S 0
     D WPrintAdv       S              1A
     D WRecCnt         S              5P 0
     D WIter           S              1P 0
     D S01466          S              1A
     D WrkDC           S              1S 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
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
 
      ** Initialize the flag.
 
     C                   EVAL      WReversal = *BLANKS
 
      ** Set the key to be used to access Account Movements File.
 
     C                   IF        RTRTYP = 'CE'
     C                   EVAL      KTnmr = RREFNO
     C                   ENDIF
 
     C                   IF        RTRTYP = 'SO'
     C                   EVAL      %SUBST(KTnmr:1:1) = *BLANK
     C                   EVAL      %SUBST(KTnmr:2:5) = RREFNO
     C                   ENDIF
 
     C                   EVAL      KTryp = RTRTYP
     C                   EVAL      WrkDC = 9
 
      ** Process only those records on Movements File which refer to
      ** the Transaction read.
 
     C     KReRsac       SETGT     RERSACL0
     C     KReRsac       READPE    RERSACL0                               11
 
      ** Set the Reversal Flag to 'Y' if the record read from the
      ** Account Movements File has '*' on position 30 of the narrative
      ** (Reversal Record) and the current change type <> to 'A'.
 
     C                   DOW       *IN11 = *OFF
 
     C                   IF        RPRGMN = 'RE0253' AND
     C                             RCHTYP = 'I' AND
     C                             WDelete <> '*' OR
 
     C                             RPRGMN = 'RE0253' AND
     C                             RCHTYP = 'A' OR
 
     C                             RPRGMN = 'RE0253' AND
     C                             RCHTYP = 'D' AND
     C                             WrkDC <> DORC OR
 
     C                             RPRGMN = 'RE0150' AND
     C                             RSEQNO = WDebCreInd
 
     C                   EVAL      WrkDC = DORC
     C                   EVAL      WIter = WIter + 1
 
      ** Store GL Account Movement Details to a work variable.
 
     C                   EVAL      NRTD = %SUBST(NRTD:1:28)
     C                   MOVEL     WDsRsac       WRsacDetls
 
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
 
     C                   IF        PRtnCode <> *BLANKS AND
     C                             PRtnCode <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'ACCNTAB'
     C                   EVAL      DBKey = PCnum + PCucd + PAccd + PAcsq + PBrca
     C                   EVAL      DBase = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        ATYP = 'R'
 
      ** Move Retail Account number to an alphanumeric variable.
 
     C                   MOVEL     ACNO          WRetailNum
 
      ** The account must allow printing of Transaction Advices.
 
     C                   EVAL      KCnum = CUSN
     C                   EVAL      KCcy  = CCYD
     C                   EVAL      KAcod = ACDE
     C                   EVAL      KAcsq = ASNC
     C                   EVAL      KBrca = BRCA
 
     C     KReiac        CHAIN     REIAC                              11
 
     C                   IF        *IN11 = *OFF AND PTRA = 'Y'
 
     C                   EVAL      WPrintAdv = 'Y'
 
      ** For Standing Order Transactions, Transaction Type must
      ** allow printing of Transaction Advices.
 
     C                   IF        RPRGMN = 'RE0253' AND
     C                             S01466 = 'Y'
 
     C                   EVAL      WPrintAdv = 'N'
 
     C                   MOVE      KTnmr         WStor
     C     WStor         CHAIN     STAND                              12
 
     C                   IF        *IN12 = *ON
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'STANDSB'
     C                   EVAL      DBKey = KTnmr
     C                   EVAL      DBase = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   EVAL      PTranType = TRAT
 
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PTranType
     C     SDRETR        PARM      SDRETR        DSFDY
 
     C                   IF        PRtnCode = *BLANKS
 
     C                   IF        A1PADI = 'Y'
     C                   EVAL      WPrintAdv = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PRtnCode <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDRETRPD'
     C                   EVAL      DBKey = PTranType
     C                   EVAL      DBase = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WPrintAdv = 'Y'
 
      ** Print transaction advices.
 
     C                   EXSR      SRPrtAdv
     C                   EVAL      WRecCnt = WRecCnt + 1
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** At this point, we already got the a/c movement record for RE0150.
 
     C                   IF        RPRGMN = 'RE0150'
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        RPRGMN = 'RE0253'
 
      ** Loop 4 times if the current change type = 'A'.
 
     C                   IF        RCHTYP = 'A'
     C                   IF        WIter = 4
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
      ** Loop 2 times if the current change type = 'I' or 'D'.
 
     C                   IF        RCHTYP = 'I' OR
     C                             RCHTYP = 'D'
     C                   IF        WIter = 2
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C     KReRsac       READPE    RERSACL0                               11
 
     C                   ENDDO
 
      ** Set the Retail Settlement Advice Print Indicator to 'Y'.
 
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
      *  SRMainCOB - Controls main flow of program for COB            *
      *                                                               *
      *****************************************************************
     C     SRMainCOB     BEGSR
 
     C                   EVAL      WRecCnt = *ZERO
 
      ** Read all records in Midas RE Account Movements for Online Printing Advice.
 
     C     *LOVAL        SETLL     RERSACL0
     C                   READ      RERSACL0                               11
 
     C                   DOW       *IN11 = *OFF
 
     C                   IF        WModule = 'R'
 
      ** Store GL Account Movement Details to a work variable.
 
     C                   EVAL      NRTD = %SUBST(NRTD:1:28)
     C                   MOVEL     WDsRsac       WRsacDetls
 
      ** Initialise the first system value key
 
     C                   SELECT
 
     C                   WHEN      TRYP = 'SO'
     C                   MOVEL     PSVal1        WSVal1
 
     C                   WHEN      TRYP = 'CE'
     C                   MOVEL     PSVal2        WSVal1
 
     C                   OTHER
     C                   MOVE      *BLANK        WSVal1
 
     C                   ENDSL
 
     C                   IF        WSVal1 = 'Y'
 
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
 
     C                   IF        PRtnCode <> *BLANKS AND
     C                             PRtnCode <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'AOACCTR0'
     C                   EVAL      DBKey = PCnum + PCucd + PAccd + PAcsq + PBrca
     C                   EVAL      DBase = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        ATYP = 'R'
 
      ** Move Retail Account Number to an alphanumeric variable.
 
     C                   MOVEL     ACNO          WRetailNum
 
      ** The account must allow printing of transaction advices.
 
     C                   EVAL      KCnum = CUSN
     C                   EVAL      KCcy  = CCYD
     C                   EVAL      KAcod = ACDE
     C                   EVAL      KAcsq = ASNC
     C                   EVAL      KBrca = BRCA
 
     C     KReiac        CHAIN     REIAC                              11
 
     C                   IF        *IN11 = *OFF AND PTRA = 'Y'
 
     C                   EVAL      WPrintAdv = 'Y'
 
      ** For Standing Order Transactions, Transaction Type must
      ** allow printing of Transaction Advices.
 
     C                   IF        TRYP = 'SO' AND
     C                             S01466 = 'Y'
 
     C                   EVAL      WPrintAdv = 'N'
 
     C                   MOVE      TNMR          WStor
     C     WStor         CHAIN     STAND                              12
 
     C                   IF        *IN12 = *ON
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'STANDSB'
     C                   EVAL      DBKey = TNMR
     C                   EVAL      DBase = 8
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   EVAL      PTranType = TRAT
 
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PTranType
     C     SDRETR        PARM      SDRETR        DSFDY
 
     C                   IF        PRtnCode = *BLANKS
 
     C                   IF        A1PADI = 'Y'
     C                   EVAL      WPrintAdv = 'Y'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        PRtnCode <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDRETRPD'
     C                   EVAL      DBKey = PTranType
     C                   EVAL      DBase = 7
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WPrintAdv = 'Y'
 
      ** Print transaction advices.
 
     C                   EXSR      SRPrtAdv
     C                   EVAL      WRecCnt = WRecCnt + 1
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record until EOF.
 
     C                   READ      RERSACL0                               11
 
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
 
     C                   SELECT
     C                   WHEN      TRYP = 'SO'
     C                   EVAL      RPTRTD = 'Standing Orders'
     C                   WHEN      TRYP = 'CE'
     C                   EVAL      RPTRTD = 'Customer Exchange'
     C                   OTHER
     C                   EVAL      RPTRTD = TRYP
     C                   ENDSL
 
      ** Transaction Narrative
 
     C                   EVAL      RPTNAR = *BLANKS
     C                   EVAL      WNarr = *BLANKS
     C                   MOVEL     NRTD          WNarr
 
     C                   IF        PInp_CtlPgm = 'REC000079'
     C                   EVAL      RPTNAR = 'RETAIL TRANSACTION'
     C                   ELSE
 
     C                   IF        WNarr <> *BLANKS
     C                   EVAL      RPTNAR = WNarr
     C                   ELSE
     C                   EVAL      RPTNAR = 'RETAIL TRANSACTION'
     C                   ENDIF
     C                   ENDIF
 
      ** Currency
 
     C                   EVAL      RPTCCY = CCYD
 
      ** Posting Amount
 
     C                   EXSR      SRCvtMAmt
     C                   EVAL      RPPAMT = WMAmt
 
      ** Last Transaction Change Type
 
     C                   EVAL      RPCHTP = *BLANKS
 
     C                   MOVE      NRTD          WChar
 
     C                   SELECT
     C                   WHEN      RCHTYP = 'D'  OR
     C                             WChar = '*'
     C                   EVAL      RPCHTP = 'CANCELLATION'
     C                   WHEN      RCHTYP = 'A'
     C                   EVAL      RPCHTP = 'AMENDMENT TO'
     C                   ENDSL
 
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
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      CCYD          PCucd
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtnCode = *BLANKS
 
     C                   MOVE      MVAM          PZAmt
 
     C                   CALL      'ZEDIT'
     C                   PARM                    PZAmt
     C                   PARM      A6NBDP        PZNoDP
 
     C                   EVAL      WMAmt = PZAmt
 
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBKey = PCucd
     C                   EVAL      DBase = 8
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
     C                   EVAL      DBase = 9
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
 
     C     *ENTRY        PLIST
     C                   PARM                    PRtnCode
     C                   PARM                    PInp_CtlPgm
 
      ** Key list for RERSACL0
 
     C     KReRsac       KLIST
     C                   KFLD                    KTnmr
     C                   KFLD                    KTryp
 
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
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if Standing Order Transaction Types is on.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'S01466'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   EVAL      S01466 = 'N'
 
     C                   IF        PRtnCode = *BLANKS
     C                   EVAL      S01466 = 'Y'
     C                   ELSE
 
     C                   IF        PRtnCode <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = 'S01466'
     C                   EVAL      DBase = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Retrieve system values.
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      WKeySysVal1   PSValK1
     C                   PARM                    PSVal1
     C                   PARM      WKeySysVal2   PSValK2
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
 
      ** If the system value is not found then issue a database error.
 
     C                   IF        PRtnCode <> *BLANKS AND
     C                             PRtnCode <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase = 3
 
     C                   SELECT
     C                   WHEN      PSVal1 = '*NRF'
     C                   EVAL      DBKey = PSValK1
     C                   WHEN      PSVal2 = '*NRF'
     C                   EVAL      DBKey = PSValK2
     C                   ENDSL
 
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
