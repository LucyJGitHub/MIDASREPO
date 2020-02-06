     H DEBUG
     H COPYRIGHT('(c)Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Drop Records from READVCPD')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE000080 - Midas RE Drop Records from READVCPD               *
      *                                                               *
      *  Function:  This program will drop records from the Online    *
      *             Printing of Advice Index File (READVCPD) when     *
      *             1) The Record's Last Change Type is D             *
      *             and Authorize Indicator is Y                      *
      *             and Print Index Advice Indicator is Y.            *
      *             2) The READVCPD Record does not exist on the      *
      *             system (i.e. no record in master file)            *
      *                                                               *
      *  (c)Finastra International Limited 2004                       *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 AR847010           Date 25May16               *
      *                 MD031950           Date 17Jun15               *
      *                 CAP212             Date 15Sep14               *
      *                 CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD027587           Date 19Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP187             Date 21Aug09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11May06               *
      *                 CPK024             Date 13Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 CDL038             Date 10May05               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL028             Date 07Feb05               *
      *                 221761             Date 04May04               *
      *                 BUG2304            Date 30Apr04               *
      *                 CRE020  *CREATE    Date 20Jan04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  AR847010 - Audit report not found in FCREPTPD causing comp.  *
      *             failure. RCF processing for audit file is removed *
      *             as it is not necessary. (Child: AR847011)         *
      *           - Applied for MD-38715                              *
      *  MD031950 - Recompiled due to changed PF/CUSEXZ1.             *
      *  CAP212 - FT Nostro Transfer API (Recompile)                  *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  MD027587 - Unable to used the C for Copy and T for Template  *
      *             (Recompile)                                       *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CAP187 - Document Linkage (recompile)                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CPK024 - Renamed field OPIN of INPAY/OTPAY                   *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  221761 - Rename field RSEQNO from FT101HL3.                  *
      *  BUG2304 - Various file layout changes. Recompile.            *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrChkDeal   - Check Deals File if Read READVCPD record exists*
      *  SrChkFO     - Check Transactions file if Read READVCPD       *
      *                record exists                                  *
      *  SrChkFunds  - Check Transactions file if Read READVCPD       *
      *                record exists                                  *
      *  SrChkGenLedg- Check General Ledger Postings File to check    *
      *                 if READVCPD record exists                     *
      *  SrChkLend   - Check Lending files for read READVCPD records  *
      *  SrChkRetail - Check Retail Files for Read READVCPD record    *
      *  SrChkSecu   - Check Securities files for Read READVCPD record*
      *  SrAudit     - Setup Audit Report and Print                   *
      *  SrRCFAU     - Registers the audit file via ZSFILE.           *
      *  *INZSR      - Initialise                                     *
      *  *PSSR       - Program Exception Subroutine                   *
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

     FREADVCL1  UF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Settled Transaction Index File

     FDEALALL   IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDFF)
      ** Midas DL All Deals

     FDEAMS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEAMSDHF)
     F                                     IGNORE(DEAMSDJF)
      ** Midas DL All Deals

     FTRANS     IF   E           K DISK    INFSR(*PSSR)
      ** Midas FF Transaction Details

     FFT101HL3  IF   E           K DISK    INFSR(*PSSR)
      ** Midas FF RFT Header

     FFT101DL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas FF RFT Details

     FFT102HL3  IF   E           K DISK    INFSR(*PSSR)
      ** Midas FF RFT Header

     FFT102DL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas FF RFT Details

     FPMIOPML0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas PM FT Incoming/Outgoing Payments

     FCQPAC     IF   E           K DISK    INFSR(*PSSR)
      ** Midas FT Cheques to be Paid

     FCQCOD     IF   E           K DISK    INFSR(*PSSR)
      ** Midas FT Cheques For Collection

     FNTRAN     IF   E           K DISK    INFSR(*PSSR)
      ** Midas FT Nostro Transfers

     FGLJENPL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Journal Entry Posting Rtv

     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
      ** Midas LE Loans File

     FLOAMSOM4  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Loan amendments

     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas LE Lending fees master detail inputs

     FSTAND     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(STANDSAF)
      ** Midas RE Standing Orders

     FCUSEX     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CUSEXH1F)
      ** Midas RE Customer Exchanges

     FPOSET     IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Position Settlements file

     FDPTMVR    IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Depot Movements file

     FTRADS     IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Trades master file

     FRE000080AUO    E             PRINTER INFSR(*PSSR)
     F**********                           INFDS(SPOOLAU)                                   AR847010
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

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Local Data Area for Database Error Details
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)

      ** Data structure for access objects, second DS
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for Bank Details
     D WPosSetDS       DS
     D  KSecSh                 1     10A
     D**KCounPty              11     16S 0                                                    CSD027
     D  KCounPty              11     16A                                                      CSD027
     D  KBrch                 17     19A
     D  WDueDate              20     24S 0
     D  KEvnt                 25     26A

      ** RE000080AU File Information
     D*SPOOLAU**       DS                                                                   AR847010
     D**PZFileAU              83     92                                                     AR847010
     D**PZFNumAU             123    124B 0                                                  AR847010

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Entry parameter fields

      ** Standard Utility Parameters
     D*PZSeq****       S              5A                                                    AR847010
     D*PZEnty***       S              3A                                                    AR847010
     D*PZSNum***       S              6P 0                                                  AR847010
     D*PZSErr***       S              1A                                                    AR847010

      ** Parameter fields
     D PRtCd           S              7A
     D POption         S              7A

      ** Key List Fields for LEFEEDL1
     D*KCnum****       S              6S 0                                                    CSD027
     D KCnum           S              6A                                                      CSD027
     D*KLoan****       S              6S 0                                                    CLE148
     D KLoan           S              6A                                                      CLE148
     D KFacl           S              5S 0

      ** Key List Fields for CQPAC/CQCOD
     D KPref           S             15A
     D KSeqNo          S              2S 0

      ** Key Fields
     D KDealNo         S              6S 0
     D KValDate        S              5P 0
     D KDeAmSeq        S              3S 0
     D KTranNo         S              6S 0
     D KTranId         S             16A
     D KBatchId        S              3A
     D KRFTId          S             15A
     D KCCTId          S             15A
     D KXferRef        S             15A
     D KDocN           S              6A
     D KTrdf           S              6A
     D KStoR           S              5S 0
     D KDpRn           S              6A
     D KDueDate        S              5P 0

      ** Work Variables
     D WCounter        S              5P 0
     D WPrefix         S              2A
     D WCnumA          S              6A
     D WLoanA          S              6A
     D WFaclA          S              5A

      ** Rename Variables

     IINPAYDDF                                                                  CPK024
     I              OPIN                        IOPIN                           CPK024
                                                                                CPK024
     IOTPAYDDF                                                                  CPK024
     I              OPIN                        OOPIN                           CPK024
                                                                                CPK024
     ICLOANCLF
     I              CRSK                        CounRisk

     IFT102HD0
     I              SINST                       CCTSINST

     IPOSETDF
     I              PREF                        PosPREF
     I              PSEQ                        PosPSEQ

     ILOAMSDKF
     I              PNAM                        LPNAM

     IFT101HD0                                                                                221761
     I              RSEQNO                      RSEQNOX                                       221761
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      ** Set up subroutine stack name

     C     *LOVAL        SETLL     READVCL1
     C                   READ      READVCL1

     C                   DOW       NOT %EOF(READVCL1)

      ** Records should be marked for deletion when a) RAUTHI = 'Y' and
      ** b) RCHTYP = 'D' or 'R'  and  c) RSAPIN = 'Y'

     C                   IF        RAUTHI = 'Y' AND RCHTYP = 'D'
     C                             AND RSAPIN = 'Y'
     C                             OR RAUTHI = 'Y' AND RCHTYP = 'R'
     C                             AND RSAPIN = 'Y'

     C                   EVAL      RCHTYP = '*'

     C                   ELSE

     C                   EVAL      WPrefix = %SUBST(RPRGMN:1:2)

      ** Set the key to be used to access Account Movements File.

     C                   SELECT

      ** Process READVCPD Records per Module.
      ** Valid modules (those that are writing to READVCPD) are
      ** DL, FX, IR, MM, FF, FT, GL, LE, RE, and SE

     C                   WHEN      WPrefix = 'DL'
     C                             OR WPrefix = 'FX'
     C                             OR WPrefix = 'IR'
     C                             OR WPrefix = 'MM'
     C                   EXSR      SrChkDeal

     C                   WHEN      WPrefix = 'FF'
     C                   EXSR      SrChkFO

     C                   WHEN      WPrefix = 'FT'
     C                   EXSR      SrChkFunds

     C                   WHEN      WPrefix = 'GL'
     C                   EXSR      SrChkGenLedg

     C                   WHEN      WPrefix = 'LE'
     C                   EXSR      SrChkLend

     C                   WHEN      WPrefix = 'RE'
     C                   EXSR      SrChkRetail

     C                   WHEN      WPrefix = 'SE'
     C                   EXSR      SrChkSecu

     C                   ENDSL

     C                   ENDIF

     C                   IF        RCHTYP = '*'
     C                   UPDATE    READVCD0
     C                   EVAL      WCounter = WCounter + 1
     C                   ENDIF

     C                   READ      READVCL1
     C                   ENDDO

     C                   EXSR      SrAudit

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkDeal - Check Deals File if Read READVCPD record exists  *
      *                                                               *
      *****************************************************************
     C     SrChkDeal     BEGSR

     C                   SELECT

      ** Records should also be deleted when the record does not exist
      ** on the Deals Amendments Master File

     C                   WHEN      RPRGMN = 'MMDEAMUPD'

     C                   MOVEL     RREFNO        KDealNo
     C                   MOVEL     RVUDT         KValDate
     C                   MOVEL     RSEQNO        KDeAmSeq

     C     KDeam         CHAIN     DEAMS

     C                   IF        NOT %FOUND(DEAMS)
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   OTHER

      ** Records should aslo be deleted when the record does not exist
      ** on the Deals Master File

     C                   MOVEL     RREFNO        KDealNo

     C     KDealNo       CHAIN     DEALALL

     C                   IF        NOT %FOUND(DEALALL)
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   ENDSL


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkFO - Check Transactions file if Read READVCPD           *
      *            record exists                                      *
      *                                                               *
      *****************************************************************
     C     SrChkFO       BEGSR

      ** Records should aslo be deleted when the record does not exist
      ** on the Futures and Options Master File

     C                   MOVEL     RREFNO        KTranNo

     C     KTranNo       CHAIN     TRANS

     C                   IF        NOT %FOUND(TRANS)
     C                             OR RECI <> 'D'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkFunds - Check Transactions file if Read READVCPD        *
      *               record exists                                   *
      *                                                               *
      *****************************************************************
     C     SrChkFunds    BEGSR

      ** Records should aslo be deleted when the record does not exist
      ** on their corresponding Master File

     C                   SELECT

     C                   WHEN      RPRGMN = 'FTM101UPD'

      ** For Request For Transfer Transactions

     C                   MOVEL     RREFNO        KRFTId

      ** Check If Header Exists, if it doesn't, mark for deletion

     C     KRFTId        CHAIN     FT101HL3

     C                   IF        %FOUND(FT101HL3)

      ** If Header Exists, Check that the detail transaction entry
      ** exist too, if it doesn't, mark it for deletion, except for '000'
      ** which identifies the record as the header.

     C                   EVAL      KTranID = %SUBST(RREFNO:1:13) + RSEQNO

     C     KTranId       CHAIN     FT101DL1
     C                   IF        NOT %FOUND(FT101DL1)
     C                             AND RSEQNO <> '000'
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF


     C                   WHEN      RPRGMN = 'FTM102UPD'

      ** For Customer Credit Transfer Transactions

     C                   MOVEL     RREFNO        KCCTId

      ** Check If Header Exists, if it doesn't, mark for deletion

     C     KCCTId        CHAIN     FT102HL3

     C                   IF        %FOUND(FT102HL3)

      ** If Header Exists, Check that the detail transaction entry
      ** exist too, if it doesn't, mark it for deletion, except for '000'
      ** which identifies the record as the header.

     C                   EVAL      KTranID = %SUBST(RREFNO:1:13) + RSEQNO

     C     KCCTDet       CHAIN     FT102DL0
     C                   IF        NOT %FOUND(FT102DL0)
     C                             AND RSEQNO <> '000'
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   ELSE
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   WHEN      RPRGMN = 'FT0060'
     C                             OR RPRGMN = 'FT0803'

      ** For Incoming/Outgoing Payments

     C                   MOVEL     RREFNO        KPref

      ** Check If Payment Reference exists. If it doesn't, mark for deletion

     C     KPref         CHAIN     PMIOPML0

     C                   IF        NOT %FOUND(PMIOPML0)
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   WHEN      RPRGMN = 'FT0090'

      ** For Cheques to be Paid/Cheques to be Collected

     C                   SELECT

     C                   WHEN      RTRTYP = 'CP'
     C                   MOVEL     RREFNO        KPref
     C                   MOVE      RSEQNO        KSeqNo

      ** Check If Cheque (PREF and CQSQ) Exists.
      ** If it doesn't, mark for deletion

     C     KChqNo        CHAIN     CQPAC

     C                   IF        NOT %FOUND(CQPAC)
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   WHEN      RTRTYP = 'CC'
     C                   MOVEL     RREFNO        KPref
     C                   MOVE      RSEQNO        KSeqNo

      ** Check If Cheque (PREF and CQSQ) Exists.
      ** If it doesn't, mark for deletion

     C     KChqNo        CHAIN     CQCOD

     C                   IF        NOT %FOUND(CQCOD)
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   ENDSL

     C                   WHEN      RPRGMN = 'FT0105'

      ** For Nostro Transfers

     C                   MOVEL     RREFNO        KXferRef

      ** Check If Payment Reference exists. If it doesn't, mark for deletion

     C     KXferRef      CHAIN     NTRAN

     C                   IF        NOT %FOUND(NTRAN)
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkGenLedg - Check General Ledger Postings File to check   *
      *                 if READVCPD record exists                     *
      *                                                               *
      *****************************************************************
     C     SrChkGenLedg  BEGSR

      ** Records should aslo be deleted when the record does not exist
      ** on the Postings Master File

     C                   MOVEL     RREFNO        KBatchID

     C     KBatchID      CHAIN     GLJENPL1

     C                   IF        NOT %FOUND(GLJENPL1)
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkLend - Check Lending files for read READVCPD records    *
      *                                                               *
      *****************************************************************
     C     SrChkLend     BEGSR

      ** Records should aslo be deleted when the record does not exist
      ** on either the Lending Master, Fees, or Amendments Files

     C                   SELECT

     C                   WHEN      RPRGMN = 'LECLIPUPD'

      ** For Customer Loans Transactions

     C                   MOVEL     RREFNO        KLoan

      ** Check If Loan Number exists. If it doesn't, mark for deletion

     C     KLoan         CHAIN     CLOAN

     C                   IF        NOT %FOUND(CLOAN)
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   WHEN      RPRGMN = 'LELOAMUPD'
     C                             OR RPRGMN = 'LERPSCUPD'
     C                             OR RPRGMN = 'LEMAPYUPD'

      ** For Loan Amendments, Scheduled Repayments and Manual Repayments

     C                   MOVEL     RREFNO        KLoan

      ** Check If Loan Number exists. If it doesn't, mark for deletion

     C     KLoan         CHAIN     LOAMSOM4

     C                   IF        NOT %FOUND(LOAMSOM4)
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   WHEN      RPRGMN = 'LEFEEMUPD'

      ** For Customer Loans Transactions
      ** L1 = Loan Fee, L2 = Facility Fee

     C                   IF        RTRTYP = 'L1'
     C                   EVAL      WCnumA = %SUBST(RREFNO:1:6)
     C                   EVAL      WLoanA = %SUBST(RREFNO:7:6)
     C                   EVAL      KFacl = *ZEROS
     C                   MOVE      WCnumA        KCnum
     C                   MOVE      WLoanA        KLoan
     C                   ELSE
     C                   EVAL      WCnumA = %SUBST(RREFNO:1:6)
     C                   EVAL      WFaclA = %SUBST(RREFNO:7:5)
     C**********         EVAL      KLoan = *ZEROS                                             CLE148
     C                   EVAL      KLoan = *BLANKS                                            CLE148
     C                   MOVE      WCnumA        KCnum
     C                   MOVE      WFaclA        KFacl
     C                   ENDIF

      ** Check if Fee exists on fees main file

     C     KFee          CHAIN     LEFEEDL1

     C                   IF        NOT %FOUND(LEFEEDL1)
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkRetail - Check Retail Files for Read READVCPD record    *
      *                                                               *
      *****************************************************************
     C     SrChkRetail   BEGSR

     C                   SELECT

     C                   WHEN      RPRGMN = 'RE0253'

      ** Check if Fee exists on fees main file

     C                   MOVEL     RREFNO        KSTOR

     C     KSTOR         CHAIN     STAND

     C                   IF        NOT %FOUND(STAND)
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   WHEN      RPRGMN = 'RE0150'

      ** Check if Fee exists on fees main file

     C                   MOVEL     RREFNO        KDOCN

     C     KDOCN         CHAIN     CUSEX

     C                   IF        NOT %FOUND(CUSEX)
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkSecu - Check Securities files for Read READVCPD record  *
      *                                                               *
      *****************************************************************
     C     SrChkSecu     BEGSR

     C                   SELECT

     C                   WHEN      RPRGMN = 'SE0170'

      ** Check if Position Settlement exists on POSETD file

     C                   MOVEL     RREFNO        WPosSetDS
     C                   Z-ADD     WDueDate      KDueDate

     C     KPosSet       CHAIN     POSET

     C                   IF        NOT %FOUND(POSET)
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   WHEN      RPRGMN = 'SEDPMVUPD'

      ** Check if Depot Movement exist in Depot Movement file

     C                   MOVEL     RREFNO        KDPRN

     C     KDPRN         CHAIN     DPTMVR

     C                   IF        NOT %FOUND(DPTMVR)
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   WHEN      RPRGMN = 'SETRADUPD'

      ** Check if Trade exists in Trades file

     C                   MOVEL     RREFNO        KTRDF

     C     KTRDF         CHAIN     TRADS

     C                   IF        NOT %FOUND(TRADS)
     C                   EVAL      RCHTYP = '*'
     C                   ENDIF

     C                   ENDSL


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

      ** Else, report on number of advcices printed

     C                   EVAL      RCOUNT = WCounter
     C                   WRITE     DETAILS

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************                     AR847010
      ***SrRCFAU*-*Registers*the*audit*file*via*ZSFILE.****************                     AR847010
      *****************************************************************                     AR847010
      *****************************************************************
     C*****SrRCFAU       BEGSR                                                              AR847010

     C**********         EVAL      PZSNum = PZFNumAU                                        AR847010

     C**********         CALL      'ZSFILE'                                                 AR847010
     C**********         PARM                    PZSeq                                      AR847010
     C**********         PARM                    PZEnty                                     AR847010
     C**********         PARM                    PZFileAU                                   AR847010
     C**********         PARM                    PZSNum                                     AR847010
     C**********         PARM      *BLANK        PZSErr                                     AR847010

     C**********         IF        PZSErr = 'Y'                                             AR847010
     C**********         DUMP                                                               AR847010
     C**********         EVAL      *INU7 = *ON                                              AR847010
     C**********         EVAL      *INU8 = *ON                                              AR847010
     C**********         EVAL      *INLR = *ON                                              AR847010
     C**********         RETURN                                                             AR847010
     C**********         ENDIF                                                              AR847010

     C**********         ENDSR                                                              AR847010
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

      ** Call RCF Processing for Audit File
     C**********         EXSR      SrRCFAU                                                  AR847010

      ** Key list for RERSACL0

      ** Access bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'AOBANKR0'
     C                   EVAL      DBKey = POption
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Deal Amendments Key List

     C     KDeam         KLIST
     C                   KFLD                    KDealNo
     C                   KFLD                    KValDate
     C                   KFLD                    KDeAmSeq

      ** Cheques Key List

     C     KChqNo        KLIST
     C                   KFLD                    KPref
     C                   KFLD                    KSeqNo

      ** Fees Key List

     C     KFee          KLIST
     C                   KFLD                    KCnum
     C                   KFLD                    KFacl
     C                   KFLD                    KLoan

      ** CCT Details Key List

     C     KCCTDet       KLIST
     C                   KFLD                    KCCTId
     C                   KFLD                    KTranId

      ** Positons Settlement Key List

     C     KPosSet       KLIST
     C                   KFLD                    KBrch
     C                   KFLD                    KSecSh
     C                   KFLD                    KCounPty
     C                   KFLD                    KDueDate
     C                   KFLD                    KEvnt

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
