     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Retail Advice for DL')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE000884 - Midas RE Retail Advice for DL                     *
      *                                                               *
      *  Function:  This program handles the generation of DL         *
      *             advices if Correspondence Manager is switched     *
      *             off.                                              *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 23Feb10               *
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11May06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
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
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
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
      *  SrPrint   - Setup report fields and print                    *
      *  SrAudit   - Setup Audit report and print                     *
      *  SrRCFP1   - Registers the Printer file via ZSFILE            *
      *  SrRCFAU   - Registers the audit file via ZSFILE              *
      *  SrCvtDate - Convert Midas Date format to Alphanumeric format *
      *  SrCvtAmt  - Convert Amounts                                  *
      *  *INZSR    - Initialise                                       *
      *  *PSSR     - Program Exception Subroutine                     *
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

     FREADVCL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas RE Settled Transaction Index File

     FRERSACL3  IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Account Movements for Online Printing Adv

     FDEALALL   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(Dl)
      ** Midas DL All deals

     FREIAC     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(Re)
      ** Midas Retail Interest & Charges File

     FRE000881P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
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

     D WKeySysVal1     C                   CONST('DealAmendments      ')
     D WKeySysVal2     C                   CONST('ForeignExchangeDeals')
     D WKeySysVal3     C                   CONST('LoansDeposNAsIssued ')
     D WKeySysVal4     C                   CONST('NAsPurchased        ')
     D WKeySysVal5     C                   CONST('NAsSold             ')
     D WKeySysVal6     C                   CONST('ForwardRateAgreement')
     D WKeySysVal7     C                   CONST('SngleCcyIntRateSwaps')
     D WKeySysVal8     C                   CONST('CrossCcyIntRateSwaps')
     D WKeySysVal9     C                   CONST('CapsCollarsFloorsMnt')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Compile-time array to contain Deal Type Codes/Narratives
     D WTabCod         S              2    DIM(51) CTDATA PERRCD(1)
     D WTabNar         S             30    DIM(51) ALT(WTabCod)

     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local Data Area for Database Error Details

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

      ** External DS for GL Accounts master detail
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D  BRCA_ACCNT   E                     EXTFLD(BRCA)

      ** External DS for  GL Account Movements
     D WDsRSAC       E DS                  EXTNAME(RSACMTPD)
     D  WNarratv              29     57A
     D  WModule               57     57A
     D  WDelete               58     58A
     D  WSeqnNum             125    127A

      ** Data structure for AOSVALR0 string
     D WSVal1          DS           200
     D  PSVal1                 1    200
     D  WSVal1_1               1      1

      ** REC000881P1 File Information
     D SPOOL1          DS
     D  PZFile                83     92
     D  PZFNum               123    124B 0

      ** REC000881AU File Information
     D SPOOLAU         DS
     D  PZFileAU              83     92
     D  PZFNumAU             123    124B 0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Entry parameter fields
     D PInp_CtlPgm     S             10A

      ** Standard Utility Parameters
     D PZDayNo         S              5P 0
     D PZDatFmt        S              1A
     D PZDate          S              6P 0
     D PZADate         S              7A
     D PZAmt           S             16A
     D PZNoDP          S              1P 0
     D PZSeq           S              5A
     D PZEnty          S              3A
     D PZSNum          S              6P 0
     D PZSErr          S              1A

      ** Parameter fields
     D PRtnCode        S              7A
     D POption         S              7A
     D PSequence       S              5A
     D PRetail         S             10A
     D PCurr           S              3A
     D PCust           S             10A
     D PKySt           S              7A
     D PCnum           S              6A
     D PCucd           S              3A
     D PAccd           S             10A
     D PAcsq           S              2A
     D PBrca           S              3A
     D PChgType        S              1A
     D PSValK1         S             20
     D PSValK2         S             20
     D PSVal2          S            200
     D PSValK3         S             20
     D PSVal3          S            200
     D PSValK4         S             20
     D PSVal4          S            200
     D PSValK5         S             20
     D PSVal5          S            200
     D PSValK6         S             20
     D PSVal6          S            200
     D PSValK7         S             20
     D PSVal7          S            200
     D PSValK8         S             20
     D PSVal8          S            200
     D PSValK9         S             20
     D PSVal9          S            200
     D PSValK0         S             20
     D PSVal0          S            200

      ** Key List Fields for RERSACPD
     D KTnmr           S              6A
     D KTryp           S              2A
     D KVudt           S              5S 0

      ** Key List Fields for REIAC
     D*KCnum****       S              6S 0                                                    CSD027
     D KCnum           S              6A                                                      CSD027
     D KCcy            S              3A
     D KAcod           S             10S 0
     D KAcsq           S              2S 0
     D KBrca           S              3A

      ** Work Variables
     D WCounter        S              5P 0
     D KDlno           S              6P 0
     D WReversal       S              1A
     D Index           S              3P 0
     D WSValK          S             20

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
     C                   END

      ** Audit processing

     C                   EXSR      SRAudit

      ** Termination

     C                   MOVE      *ON           *INLR
     C                   RETURN

      *****************************************************************
      *                                                               *
      *  SRMainIC - Controls main flow of program for Input Cycle     *
      *                                                               *
      *****************************************************************
     C     SRMainIC      BEGSR

      ** Process all the records from RE Settled Transaction Index File
      ** with Transaction Maintenance Program equal to Control Program

     C     PInp_CtlPgm   SETLL     READVCL0
     C     PInp_CtlPgm   READE     READVCL0                               10

     C                   DOW       *IN10 = *OFF

      ** Initialize the flag.

     C                   EVAL      WReversal = *BLANKS

      ** Set the key to be used to access Account Movements File.

     C                   EVAL      KTnmr = RREFNO
     C                   EVAL      KTryp = RTRTYP
     C                   EVAL      KVudt = RVUDT

      ** Process only those records on Movements File which refer to
      ** the Index File Record read.

     C     KReRsac       SETGT     RERSACL3
     C     KReRsac       READPE    RERSACL3                               11

      ** Set the Reversal Flag to 'Y' if the record read from the
      ** Account Movements File has '*' on position 30 of the narrative.
      ** (Reversal Record)

      ** If the Change Type is insert and the record read from the
      ** Account Movements File has '*' on position 30 of the narrative,
      ** No record will be processed for this Index File record.

     C                   IF        *IN11 = *OFF AND RENARR = WNarratv
     C                             AND RSEQNO = WSeqnNum AND WDelete = '*'

     C                   EVAL      WReversal = 'Y'

     C                   IF        RCHTYP = 'I'
     C                   EVAL      *IN11 = *ON
     C                   ENDIF

     C                   ENDIF

     C                   DOW       *IN11 = *OFF


     C                   IF        RENARR = WNarratv
     C                             AND RSEQNO = WSeqnNum

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
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'AOACCTR0'
     C                   EVAL      DBKey = PCnum + PCucd + PAccd + PAcsq + PBrca
     C                   EVAL      DBase = 1
     C                   OUT       LDA
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

     C                   IF        *IN11 = *OFF AND RePTRA = 'Y'

      ** If the record read from the Account Movement File has '*' on
      ** position 30 if the narrative field, set Change Type to 'R'.
      ** (REVERSAL).  Else set if to Change Type Value from Settled
      ** Transaction Index File.

     C                   IF        WDelete = '*'
     C                   EVAL      PChgType = 'R'
     C                   ELSE
     C                   EVAL      PChgType = RCHTYP
     C                   ENDIF

      ** Increment the count of RERSACPD records processed.

     C                   ADD       1             WCounter

      ** Setup Report Fields and print by calling print subroutine

     C                   EXSR      SrPrint

     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      ** Read next record until EOF or end of processing for the
      ** Settled Transaction Index File record read.

     C     KReRsac       READPE    RERSACL3                               11


     C                   IF        *IN11 = *OFF AND RENARR = WNarratv
     C                             AND RSEQNO = WSeqnNum

     C                   IF        (WReversal = 'Y' and WDelete = ' ')
     C                             OR (RCHTYP = 'I' and WDelete = '*')
     C                   EVAL      *IN11 = *ON
     C                   ELSE
     C                   IF        WDelete = '*'
     C                   EVAL      WReversal = 'Y'
     C                   ENDIF
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
      *  SRMainCOB - Controls main flow of program for Close of       *
      *              Business                                         *
      *                                                               *
      *****************************************************************
     C     SRMainCOB     BEGSR

      ** Read all records in Midas RE Account Movements for Online Printing Adv


     C     *LOVAL        SETLL     RERSACL3
     C                   READ      RERSACL3                               11

     C                   DOW       *IN11 = *OFF

     C                   IF        WModule = 'D'

     C                   MOVE      TNMR          KDlno
     C     KDlno         CHAIN     DEALALL                            13

     C                   IF        *IN13 = *OFF

      * Clear all the AOSVALR0 input parameters

     C                   CLEAR                   PSValK1

      * Initialise the first system value key

     C                   SELECT

     C                   WHEN      WSeqnNum <> *BLANKS
     C                   EVAL      PSValK1 = WKeySysVal1

     C                   WHEN      DlRCDT = 'B'
     C                   EVAL      PSValK1 = WKeySysVal2

     C                   WHEN      DlRCDT = 'C'
     C                   EVAL      PSValK1 = WKeySysVal3

     C                   WHEN      DlRCDT = 'D'
     C                   EVAL      PSValK1 = WKeySysVal4

     C                   WHEN      DlRCDT = 'E'
     C                   EVAL      PSValK1 = WKeySysVal5

     C                   WHEN      DlRCDT = 'G' AND DlDTYP = 'FR'
     C                   EVAL      PSValK1 = WKeySysVal6

     C                   WHEN      DlRCDT = 'G' AND DlDTYP = 'RS'
     C                   EVAL      PSValK1 = WKeySysVal7

     C                   WHEN      DlRCDT = 'G' AND DlDTYP = 'RX'
     C                   EVAL      PSValK1 = WKeySysVal8

     C                   WHEN      DlRCDT = 'G' AND (DlDTYP <> 'FR' OR
     C                             DlDTYP <> 'RS' OR DlDTYP <> 'RX')
     C                   EVAL      PSValK1 = WKeySysVal9

     C                   ENDSL

      * Retrieve the system value

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtnCode
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

      * If the system value is not found then issue a database error

     C                   IF        PRtnCode <> *BLANKS
     C                   IF        PSVal0 = '*NRF'
     C                   EVAL      WSValK = PSValK0
     C                   ENDIF
     C                   IF        PSVal9 = '*NRF'
     C                   EVAL      WSValK = PSValK9
     C                   ENDIF
     C                   IF        PSVal8 = '*NRF'
     C                   EVAL      WSValK = PSValK8
     C                   ENDIF
     C                   IF        PSVal7 = '*NRF'
     C                   EVAL      WSValK = PSValK7
     C                   ENDIF
     C                   IF        PSVal6 = '*NRF'
     C                   EVAL      WSValK = PSValK6
     C                   ENDIF
     C                   IF        PSVal5 = '*NRF'
     C                   EVAL      WSValK = PSValK5
     C                   ENDIF
     C                   IF        PSVal4 = '*NRF'
     C                   EVAL      WSValK = PSValK4
     C                   ENDIF
     C                   IF        PSVal3 = '*NRF'
     C                   EVAL      WSValK = PSValK3
     C                   ENDIF
     C                   IF        PSVal2 = '*NRF'
     C                   EVAL      WSValK = PSValK2
     C                   ENDIF
     C                   IF        PSVal1 = '*NRF'
     C                   EVAL      WSValK = PSValK1
     C                   ENDIF
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = WSValK
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase = 3
     C                   OUT       LDA
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
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'AOACCTR0'
     C                   EVAL      DBKey = PCnum + PCucd + PAccd + PAcsq + PBrca
     C                   EVAL      DBase = 4
     C                   OUT       LDA
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

     C                   IF        *IN11 = *OFF AND RePTRA = 'Y'

      ** Set Change Type to 'I'.

     C                   EVAL      PChgType = 'I'

      ** Increment the count of RERSACPD records processed.

     C                   ADD       1             WCounter

      ** Setup Report Fields and print by calling print subroutine

     C                   EXSR      SrPrint

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Read next record until EOF.

     C                   READ      RERSACL3                               11

     C                   ENDDO

      ** Unwind subroutine stack name

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPrint -  Setup Report fields and print                     *
      *                                                               *
      *****************************************************************
     C     SrPrint       BEGSR

      ** Set up subroutine stack name

     C                   IF        WCounter = 1
     C                   EXSR      SrRCFP1
     C                   ENDIF

      ** Load values to report fields

      ** Transaction Number

     C                   EVAL      RPTREF = TNMR

      ** Debit Credit Indicator

     C                   IF        DORC = 0
     C                   EVAL      RPDRCR = 'debited'
     C                   ELSE
     C                   EVAL      RPDRCR = 'credited'
     C                   ENDIF

      ** Retail Account Number

     C                   MOVE      ACNO          RPACCT

      ** Value Date

     C                   EVAL      RPVDAT = *BLANKS

     C                   IF        VUDT <> *ZEROS
     C                   EVAL      PZDayNo = VUDT
     C                   EXSR      SrCvtDate
     C                   EVAL      RPVDAT = PZADate
     C                   ENDIF

      ** Transaction Type Description

     C                   Z-ADD     1             Index
     C     TRYP          LOOKUP    WTabCod(Index)                         40
     C                   IF        %EQUAL
     C                   EVAL      RPTRTD = WTabNar(Index)
     C                   ENDIF
      *
     C                   IF        FUND <> *BLANKS
     C                   EVAL      RPTRTD = *BLANKS
     C                   SELECT
     C                   WHEN      TRYP  = 'PI'
     C                   EVAL      RPTRTD = 'Principal Increase'
     C                   WHEN      TRYP  = 'PD'
     C                   EVAL      RPTRTD = 'Principal Decrease'
     C                   WHEN      TRYP  = 'SC'
     C                   EVAL      RPTRTD = 'Rate Change'
     C                   WHEN      TRYP  = 'CI'
     C                   EVAL      RPTRTD = 'Capitalise Interest'
     C                   WHEN      TRYP  = 'SI'
     C                   EVAL      RPTRTD = 'Interest Payment Date'
     C                   ENDSL
     C                   ENDIF

      ** Transaction Narrative

     C                   IF        PInp_CtlPgm = 'REC000079'
     C                   EVAL      RPTNAR = 'DEALING TRANSACTION'
     C                   ELSE
     C                   IF        %SUBST(NRTD:1:28) <> *BLANKS
     C                   EVAL      RPTNAR = %SUBST(NRTD:1:28)
     C                   ELSE
     C                   EVAL      RPTNAR = 'DEALING TRANSACTION'
     C                   ENDIF
     C                   ENDIF

      ** Currency

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      CCYD          PCurr
     C     SDCURR        PARM      SDCURR        DSSDY

     C     PRtnCode      IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBKey = CCYD
     C                   EVAL      DBase = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      RPTCCY = CCYD

      ** Amount

     C                   EVAL      PZAmt = *Blanks
     C                   MOVE      MVAM          PZAmt
     C                   EVAL      PZNoDP = A6NBDP
     C                   EXSR      SrCvtAmt
     C                   EVALR     RPPAMT = PZAmt

      ** Type of Last Change

     C                   EVAL      RPCHTP = *BLANKS
     C                   SELECT
     C                   WHEN      PChgType = 'A'
     C                   EVAL      RPCHTP = 'AMENDMENT TO'
     C                   WHEN      PChgType = 'D' OR
     C                             PChgType = 'R'
     C                   EVAL      RPCHTP = 'CANCELLATION'
     C                   ENDSL

      ** Customer Details

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
     C                   EVAL      DBase = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

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
      *  SrAudit - Setup Audit Report and Print                       *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR

      ** If no records were processed, output "No Details to Report"

     C                   WRITE     HEADAU

     C                   IF        WCounter = 0

     C                   WRITE     NODTLS

     C                   ELSE

      ** Else, report on number of advices printed

     C                   EVAL      RCOUNT = WCounter
     C                   WRITE     DETAILS

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRCFP1 - Registers the printer file via ZSFILE.             *
      *                                                               *
      *****************************************************************
     C     SrRCFP1       BEGSR

     C                   EVAL      PZSNum = PZFNum

     C                   CALL      'ZSFILE'
     C                   PARM                    PZSeq
     C                   PARM                    PZEnty
     C                   PARM                    PZFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr

     C                   IF        PZSErr = 'Y'
     C                   DUMP
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
      *  SrRCFAU - Registers the audit file via ZSFILE.               *
      *                                                               *
      *****************************************************************
     C     SrRCFAU       BEGSR

     C                   EVAL      PZSNum = PZFNumAU

     C                   CALL      'ZSFILE'
     C                   PARM                    PZSeq
     C                   PARM                    PZEnty
     C                   PARM                    PZFileAU
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr

     C                   IF        PZSErr = 'Y'
     C                   DUMP
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
      *  SrCvtDate - Convert Midas Date format to Alphanumeric format *
      *                                                               *
      *****************************************************************
     C     SrCvtDate     BEGSR

     C                   CALL      'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM                    PZDatFmt
     C                   PARM                    PZDate
     C                   PARM                    PZADate

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCvtAmt - Convert Amounts                                   *
      *                                                               *
      *****************************************************************
     C     SrCvtAmt      BEGSR

     C                   CALL      'ZEDIT'
     C                   PARM                    PZAmt
     C                   PARM                    PZNoDP

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

      ** Call RCF Processign for Audit File
     C                   EXSR      SrRCFAU

      ** Key list for RERSACL3

     C     KReRsac       KLIST
     C                   KFLD                    KTnmr
     C                   KFLD                    KTryp
     C                   KFLD                    KVudt

      ** Key list for REIAC

     C     KReiac        KLIST
     C                   KFLD                    KCnum
     C                   KFLD                    KCcy
     C                   KFLD                    KAcod
     C                   KFLD                    KAcsq
     C                   KFLD                    KBrca

      ** Access bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PRtnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'AOBANKR0'
     C                   EVAL      DBKey = POption
     C                   EVAL      DBase = 7
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Initialize the counter.

     C                   Z-ADD     *ZERO         WCounter

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
** WTabCod/WTabNar  - Deal Code/Deal Type Narratives
FPPURCHASE
FSSALE
PIPURCHASE COVERING INTEREST
SISALE COVERING INTEREST
CXCROSS DEAL
OPOPTION
OTOPTION TAKE DOWN
SWSWAP
PSINTERNAL CONTRACT
ITDEPOSIT TAKEN
IPDEPOSIT PLACED
CDCALL/NOTICE DEPOSIT
CLCALL/NOTICE DEPOSIT PLACED
LNCOMMERCIAL LOAN
TDTIME DEPOSIT
DLDEMAND LOAN
TITIME LOAN
BDBILL DISCOUNTED
BRBILL REDISCOUNTED
TBTREASURY BILL PURCHASED
TSTREASURY BILL SOLD
DAACCEPTANCE - DISCOUNTED BANKS
RAACCEPTANCE REDISCOUNTED BANKS
TATRADE ACCEPTANCES DISCOUNTED
TRTRADE ACCEPTANCES REDISC
BPBOND PURCHASED
BSBOND SOLD
C1PRIMARY CD PURCHASED
C2SECONDARY CD PURCHASED
CSCD SOLD
CICD ISSUED
NXNOSTRO TRANSFER
BABANK ACCEPTANCE
BIBILL
BOBOND
CPCALL/NOTICE DEPOSIT PLACED
CTCALL/NOTICE DEPOSIT TAKEN
ILINTERNAL LOAN PLACED
IDINTERNAL DEPOSIT TAKEN
FLFIDUCIARY DEPOSIT TERM PLACED
DPFIDUCIARY DEPOSIT CALL PLACED
LPFIDUCIARY LOAN CALL PLACED
FTFIDUCIARY DEPOSIT TERM TAKEN
DTFIDUCIARY DEPOSIT CALL TAKEN
LTFIDUCIARY LOAN CALL TAKEN
FRFORWARD RATE AGREEMENT
RSINTEREST RATE SWAP- SINGLE CCY
RXINTEREST RATE SWAP- CROSS CCY
RPINTEREST RATE CAP
RRINTEREST RATE COLLAR
RFINTEREST RATE FLOOR
