     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Retail Advice for SE')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading                                   *
      *                                                               *
      *  RE000886 - Midas RE Retail Advice for SE                     *
      *                                                               *
      *  Function:  This program handles the generation of SE         *
      *             advices if Correspondence Manager is switched     *
      *             off.                                              *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
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
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
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
      *  SRMain     - Handles main program execution.                 *
      *  SRIC       - Handles Input Cycle processing.                 *
      *  SRChkAdv   - Checks the advice index file.                   *
      *  SRChkAcc   - Checks the current account.                     *
      *  SRIsRetAcc - Checks if the current account is a RE Account.  *
      *  SRAcAPTrA  - Checks if the current account allows the        *
      *               printing of Transaction Advices.                *
      *  SRIsRevAcc - Checks if the current account is a reversed     *
      *               account.                                        *
      *  SRPrtAdv   - Prints Transaction Advices.                     *
      *  SRCoB      - Handles Close of Business processing.           *
      *  SRSelAcc   - Selects accounts.                               *
      *  SRCvtVDat  - Converts Value Dates into report-friendly       *
      *               dates.                                          *
      *  SRCvtMAmt  - Converts Movement Amounts into report-friendly  *
      *               amounts.                                        *
      *  SRGetCust  - Gets Customer Details.                          *
      *  SrRCFP1    - Registers the Printer file via ZSFILE           *
      *  SrRCFAU    - Registers the audit file via ZSFILE             *
      *  *INZSR     - Program Initialisation Subroutine               *
      *  *PSSR      - Program Exception Subroutine                    *
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
 
     FRERSACL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RSACMTPO:RERSACL2F)
      ** Midas GL Account Movements by TNMR/TRYP
 
     FREIAC     IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Interest & Charges File by CNUM/CCY/ACOD/ASEQ/BRCH
 
     FTRADS     IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Transaction Details
 
     FTRADBLK   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TRADSDF:TRADBLKF)
      ** Midas SE Bulk Transaction Details
 
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
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer Details Data Structure
 
     D GLACNT        E DS                  EXTNAME(ACCNTAB)
     D  BRCH         E                     EXTFLD(BRCA)
      ** Account Details Data Structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Access Object Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Access Object Data Structure
 
      ** REC000881P1 File Information
     D SPOOL1          DS
     D  PZFile                83     92
     D  PZFNum               123    124B 0
 
      ** REC000881AU File Information
     D SPOOLAU         DS
     D  PZFileAU              83     92
     D  PZFNumAU             123    124B 0
 
      ** Data structure for Transaction Ref No.
     D RREFNO          DS            30
     D  KTrRef                 1      6
     D  KSec                   1     10
     D  KCParty               11     16
     D  KBranch               17     19
     D  KDDate                20     24
     D  KType                 25     26
 
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
     D PSysVal01       S             20A   INZ('SecuritiesTrades    ')
     D PCurSet01       S            200A
     D PSysVal02       S             20A   INZ('DepotMovements      ')
     D PCurSet02       S            200A
     D PSysVal03       S             20A   INZ('DepotMovementsWalkIn')
     D PCurSet03       S            200A
     D PSysVal04       S             20A   INZ('DepotMovementWalkOut')
     D PCurSet04       S            200A
     D PSysVal05       S             20A   INZ('PositionSettlement  ')
     D PCurSet05       S            200A
     D PSysVal06       S             20A   INZ('BulkTrades          ')
     D PCurSet06       S            200A
     D PSysVal07       S             20A
     D PCurSet07       S            200A
     D PSysVal08       S             20A
     D PCurSet08       S            200A
     D PSysVal09       S             20A
     D PCurSet09       S            200A
     D PSysVal10       S             20A
     D PCurSet10       S            200A
     D PCust           S             10A
     D PKySt           S              7A
 
      ** Standard Utility Parameters
     D PZSeq           S              5A
     D PZLevel         S              1A
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
     D WRecCnt         S             15S 0
     D WRetAcc         S              1A
     D WAcAPTrA        S              1A
     D WRevAcc         S              1A
     D WChkAcc         S              1A
     D WChar           S              1A
     D WPrtAdv         S              1A
     D WSecTAdv        S              1A   INZ('N')
     D WDptmAdv        S              1A   INZ('N')
     D WDpWIAdv        S              1A   INZ('N')
     D WDpWOAdv        S              1A   INZ('N')
     D WPoStAdv        S              1A   INZ('N')
     D WBkTrAdv        S              1A   INZ('N')
     D WVDat           S              7A
     D WMAmt           S             16A
     D WDDate          S              5S 0
     D KTrTyp          S              2A
     D WSec            S             21A
     D WIsTrade        S              1A
     D WIsPosSet       S              1A
     D WIsDepot        S              1A
     D WModule         S              1A
     D WTNLU           S              5A
 
      ** Key Fields
     D KCNum           S                   LIKE(CNUM)
     D KCcy            S                   LIKE(CCY)
     D KACod           S                   LIKE(ACOD)
     D KAcSq           S                   LIKE(ACSQ)
     D KBrch           S                   LIKE(BRCA)
     D KPrgMn          S                   LIKE(RPRGMN)
 
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
 
     C                   EXSR      SRMain
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Handles main program execution.                     *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
 
      ** Determine processing mode.
 
     C                   IF        PCtrlPgm <> 'REC000079'
     C                   EXSR      SRIC
     C                   ELSE
     C                   EXSR      SRCoB
     C                   ENDIF
 
      ** Audit processing
 
     C                   EXSR      SRAudit
 
     C                   ENDSR
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
 
 
      ** Check of Type of Transaction
 
     C                   EVAL      WIsTrade = 'N'
     C                   EVAL      WIsPosSet = 'N'
     C                   EVAL      WIsDepot = 'N'
 
     C                   SELECT
     C                   WHEN      RTRTYP = 'TP' or
     C                             RTRTYP = 'TS'
     C                   EVAL      WIsTrade = 'Y'
 
     C                   WHEN      RTRTYP = 'CP' or
     C                             RTRTYP = 'DV' or
     C                             RTRTYP = 'MT' or
     C                             RTRTYP = 'PP' or
     C                             RTRTYP = 'MP' or
     C                             RTRTYP = 'RC'
     C                   EVAL      WIsPosSet = 'Y'
 
     C                   WHEN      RTRTYP = 'WI' or
     C                             RTRTYP = 'WO' or
     C                             RTRTYP = 'DT' or
     C                             RTRTYP = 'BL' or
     C                             RTRTYP = 'BB' or
     C                             RTRTYP = 'RP' or
     C                             RTRTYP = 'RR' or
     C                             RTRTYP = 'PL'
     C                   EVAL      WIsDepot = 'Y'
     C                   ENDSL
 
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
 
     C                   SELECT
 
      ** If Trade Transactions, check using Transaction Ref and Type
 
     C                   WHEN      WIsTrade = 'Y'
     C                   EVAL      KTrTyp = RTRTYP
     C     KRersacl0     SETGT     RERSACL0
     C     KRersacl0     READPE    RERSACL0                               11
 
      ** If Position Settlement, check using Security Shortname, Counterparty,
      ** Branch + Due Date + Event Type
 
     C                   WHEN      WIsPosSet = 'Y'
     C                   MOVE      KDDate        WDDate
     C                   MOVEL     KSec          WSec
     C                   MOVEL     RENARR        WTNLU
     C                   MOVE      WTNLU         WSec
     C     KRersacl2     SETGT     RERSACL2
     C     KRersacl2     READPE    RERSACL2                               11
 
      ** If Depot movement Transaction, use Transaction Ref and Type
 
     C                   WHEN      WIsDepot = 'Y'
     C                   EVAL      KTrTyp = RTRTYP
     C     KRersacl0     SETGT     RERSACL0
     C     KRersacl0     READPE    RERSACL0                               11
 
     C                   ENDSL
 
     C                   DOW       *IN11 = *OFF
 
      ** Stop processing if Insert and record from RSACMTPD is reversal
 
     C                   MOVE      NRTD          WChar
     C                   IF        WChar = '*'  and
     C                             RCHTYP = 'I'
     C                   LEAVESR
     C                   ENDIF
 
     C                   EXSR      SRChkAcc
 
      ** Check first if this account is reversed.
 
     C                   EXSR      SRIsRevAcc
 
      ** Print the advice if necessary.
 
     C                   IF        WPrtAdv = 'Y'
     C                   EXSR      SRPrtAdv
     C                   EVAL      WRecCnt = WRecCnt + 1
     C                   ENDIF
 
      ** Stop processing if necessary.
 
     C                   IF        WRevAcc = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Read next record
 
     C                   SELECT
     C                   WHEN      WIsTrade = 'Y' or
     C                             WIsDepot = 'Y'
     C     KRersacl0     READPE    RERSACL0                               11
 
     C                   WHEN      WIsPosSet = 'Y'
     C     KRersacl2     READPE    RERSACL2                               11
     C                   ENDSL
 
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
     C                   EVAL      DBase = 3
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
      *  SRIsRevAcc - Checks if the current account is a reversed     *
      *               account.                                        *
      *                                                               *
      *****************************************************************
     C     SRIsRevAcc    BEGSR
 
     C                   EVAL      WRevAcc = 'N'
 
     C                   MOVE      NRTD          WChar
 
     C                   IF        WChar = '*'
     C                   EVAL      WRevAcc = 'Y'
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
 
      ** Set up subroutine stack name
 
     C                   IF        WRecCnt = 1
     C                   EXSR      SrRCFP1
     C                   ENDIF
 
      ** Transaction Reference
 
     C                   IF        WIsPosSet = 'Y'
     C                   EVAL      RPTREF = %SUBST(FUND:1:10)
     C                   ELSE
     C                   EVAL      RPTREF = TNMR
     C                   ENDIF
 
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
     C                   WHEN      TRYP = 'TP'
     C                   EVAL      RPTRTD = 'TRADE PURCHASE'
     C                   WHEN      TRYP = 'TS'
     C                   EVAL      RPTRTD = 'TRADE SALE'
     C                   WHEN      TRYP = 'CP'
     C                   EVAL      RPTRTD = 'COUPON PAYMENT'
     C                   WHEN      TRYP = 'DV'
     C                   EVAL      RPTRTD = 'DIVIDEND PAYMENT'
     C                   WHEN      TRYP = 'PP'
     C                   EVAL      RPTRTD = 'PARTLY PAID'
     C                   WHEN      TRYP = 'MT'
     C                   EVAL      RPTRTD = 'MATURITY'
     C                   WHEN      TRYP = 'MP'
     C                   EVAL      RPTRTD = 'MORTGAGE PAYMENT'
     C                   WHEN      TRYP = 'RC'
     C                   EVAL      RPTRTD = 'REDEMPTION CALL'
     C                   WHEN      TRYP = 'WI'
     C                   EVAL      RPTRTD = 'WALK-IN'
     C                   WHEN      TRYP = 'WO'
     C                   EVAL      RPTRTD = 'WALK-OUT'
     C                   WHEN      TRYP = 'BB'
     C                   EVAL      RPTRTD = 'BOND BORROWING'
     C                   WHEN      TRYP = 'BL'
     C                   EVAL      RPTRTD = 'BOND LENDING'
     C                   WHEN      TRYP = 'RP'
     C                   EVAL      RPTRTD = 'REPURCHASE AGREEMENT (REPO)'
     C                   WHEN      TRYP = 'RL'
     C                   EVAL      RPTRTD = 'REVERSE REPO'
     C                   WHEN      TRYP = 'PL'
     C                   EVAL      RPTRTD = 'PLEDGED LOAN'
     C                   WHEN      TRYP = 'PD'
     C                   EVAL      RPTRTD = 'PLEDGED DEPOSIT'
     C                   WHEN      TRYP = 'DT'
     C                   EVAL      RPTRTD = 'DEPOT TRANSFER'
     C                   WHEN      TRYP = 'PS'
     C                   EVAL      RPTRTD = 'POSITION SETTLEMENT'
     C                   ENDSL
 
      ** Transaction Narrative
 
     C                   EVAL      RPTNAR = *BLANKS
 
     C                   SELECT
     C                   WHEN      TRYP = 'CP' or
     C                             TRYP = 'MT'
     C                   EVAL      RPTNAR = 'INTEREST'
     C                   WHEN      WIsTrade = 'Y'
     C                   EVAL      RPTNAR = 'VALUE'
     C                   WHEN      WIsDepot = 'Y'
     C                   EVAL      RPTNAR = 'CHARGES'
     C                   WHEN      TRYP   = 'PS' or
     C                             TRYP   = 'DV' or
     C                             TRYP   = 'PP' or
     C                             TRYP   = 'MP' or
     C                             TRYP   = 'RC' or
     C                             TRYP   = 'RP'
     C                   EVAL      RPTNAR = 'SECURITIES SETTLEMENTS'
     C                   OTHER
     C                   EVAL      RPTNAR = 'SECURITIES TRANSACTION'
     C                   ENDSL
 
      ** Currency
 
     C                   EVAL      RPTCCY = CCYD
 
      ** Posting Amount
 
     C                   EXSR      SRCvtMAmt
     C                   EVAL      RPPAMT = WMAmt
 
      ** Last Transaction Change Type
 
     C                   EVAL      RPCHTP = *BLANKS
 
     C                   SELECT
     C                   WHEN      RCHTYP = 'D'  OR
     C                             WRevAcc = 'Y'
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
      *  SRCoB - Handles Close of Business processing.                *
      *                                                               *
      *****************************************************************
     C     SRCoB         BEGSR
 
     C                   EVAL      WRecCnt = *ZERO
 
     C     *LOVAL        SETLL     RERSACL0
     C                   READ      RERSACL0
 
     C                   DOW       NOT %EOF
 
      ** Select accounts.
 
     C                   EXSR      SRSelAcc
 
     C                   IF        WChkAcc <> 'Y'
     C                   READ      RERSACL0
     C                   ITER
     C                   ENDIF
 
      ** Check accounts.
 
     C                   EXSR      SRChkAcc
 
     C                   IF        WPrtAdv <> 'Y'
     C                   READ      RERSACL0
     C                   ITER
     C                   ENDIF
 
      ** Check first if this account is reversed.
 
     C                   EXSR      SRIsRevAcc
 
      ** Print the advice.
 
     C                   EXSR      SRPrtAdv
     C                   EVAL      WRecCnt = WRecCnt + 1
 
     C                   READ      RERSACL0
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSelAcc - Selects accounts.                                 *
      *                                                               *
      *****************************************************************
     C     SRSelAcc      BEGSR
 
     C                   EVAL      WChkAcc = 'N'
 
     C                   EVAL      WIsTrade = 'N'
     C                   EVAL      WIsPosSet = 'N'
     C                   EVAL      WIsDepot = 'N'
 
      ** If position 29 of projection narrative is not 'S', then it is not
      ** Securities transaction, leave the subroutine
 
     C                   EVAL      WModule = %SUBST(NRTD:29:1)
     C                   IF        WModule <> 'S'
     C                   LEAVESR
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      TRYP = 'TP' or
     C                             TRYP = 'TS'
     C                   EVAL      WIsTrade = 'Y'
 
     C                   WHEN      TRYP = 'CP' or
     C                             TRYP = 'DV' or
     C                             TRYP = 'MT' or
     C                             TRYP = 'PP' or
     C                             TRYP = 'MP' or
     C                             TRYP = 'RC' or
     C                             TRYP = 'PS'
     C                   EVAL      WIsPosSet = 'Y'
 
     C                   WHEN      TRYP = 'WI' or
     C                             TRYP = 'WO' or
     C                             TRYP = 'DT' or
     C                             TRYP = 'BL' or
     C                             TRYP = 'BB' or
     C                             TRYP = 'RP' or
     C                             TRYP = 'RR' or
     C                             TRYP = 'PL'
     C                   EVAL      WIsDepot = 'Y'
     C                   ENDSL
 
      ** If Position Settlement, check if security exist
 
     C                   IF        WIsPosSEt = 'Y'
 
     C                   IF        WPoStAdv = 'N'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
      ** If Securities Trade, check if inserted via Trade Input or Bulk Input
 
     C                   IF        WIsTrade = 'Y'
     C     TNMR          CHAIN     TRADS
 
     C                   IF        NOT %FOUND(TRADS)
     C     TNMR          CHAIN     TRADBLK
 
     C                   IF        NOT %FOUND(TRADBLK)
     C                   LEAVESR
     C                   ELSE
 
     C                   IF        WBkTrAdv = 'N'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
     C                   ELSE
 
     C                   IF        WSecTAdv = 'N'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** At this point, the current record is right for processing.
 
     C                   EVAL      WChkAcc = 'Y'
 
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
     C                   EVAL      DBase = 5
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
 
     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBKey = PCust
     C                   EVAL      DBase = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
 
     C                   IF        WRecCnt  = 0
 
     C                   WRITE     NODTLS
 
     C                   ELSE
 
      ** Else, report on number of advices printed
 
     C                   EVAL      RCOUNT = WRecCnt
     C                   WRITE     DETAILS
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRCFP1   - Registers the printer file via ZSFILE.           *
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
 
      ** Midas RE Interest & Charges File Key List
 
     C     KIAC          KLIST
     C                   KFLD                    KCNum
     C                   KFLD                    KCcy
     C                   KFLD                    KACod
     C                   KFLD                    KAcSq
     C                   KFLD                    KBrch
 
      ** Key list for RERSACL0
 
     C     KRersacl0     KLIST
     C                   KFLD                    KTrRef
     C                   KFLD                    KTrTyp
 
      ** Key list for RERSACL2
 
     C     KRersacl2     KLIST
     C                   KFLD                    WSec
     C                   KFLD                    KCParty
     C                   KFLD                    KBranch
     C                   KFLD                    WDDate
     C                   KFLD                    KType
 
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
 
      ** Check for System Values.
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    PSysVal01
     C                   PARM                    PCurSet01
     C                   PARM                    PSysVal02
     C                   PARM                    PCurSet02
     C                   PARM                    PSysVal03
     C                   PARM                    PCurSet03
     C                   PARM                    PSysVal04
     C                   PARM                    PCurSet04
     C                   PARM                    PSysVal05
     C                   PARM                    PCurSet05
     C                   PARM                    PSysVal06
     C                   PARM                    PCurSet06
     C                   PARM                    PSysVal07
     C                   PARM                    PCurSet07
     C                   PARM                    PSysVal08
     C                   PARM                    PCurSet08
     C                   PARM                    PSysVal09
     C                   PARM                    PCurSet09
     C                   PARM                    PSysVal10
     C                   PARM                    PCurSet10
 
     C                   IF        PRtCd = *BLANKS
 
      ** Securities Trades
      ** Depot Movements
      ** Depot Movements Walk In
      ** Depot Movements Walk Out
      ** Position Settlement
      ** Bulk Trades
 
     C                   MOVEL     PCurSet01     WSecTAdv
     C                   MOVEL     PCurSet02     WDptmAdv
     C                   MOVEL     PCurSet03     WDpWIAdv
     C                   MOVEL     PCurSet04     WDpWOAdv
     C                   MOVEL     PCurSet05     WPoStAdv
     C                   MOVEL     PCurSet06     WBkTrAdv
 
     C                   ELSE
 
     C                   IF        PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase = 2
 
     C                   SELECT
     C                   WHEN      PCurSet01 = '*NRF'
     C                   EVAL      DBKey = PSysVal01
     C                   WHEN      PCurSet02 = '*NRF'
     C                   EVAL      DBKey = PSysVal02
     C                   WHEN      PCurSet03 = '*NRF'
     C                   EVAL      DBKey = PSysVal03
     C                   WHEN      PCurSet04 = '*NRF'
     C                   EVAL      DBKey = PSysVal04
     C                   WHEN      PCurSet05 = '*NRF'
     C                   EVAL      DBKey = PSysVal05
     C                   WHEN      PCurSet06 = '*NRF'
     C                   EVAL      DBKey = PSysVal06
     C                   ENDSL
 
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
