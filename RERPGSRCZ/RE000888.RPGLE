     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Retail Advice for FF')                        *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  RE000888 - Midas RE Retail Advice for FF                     *
      *                                                               *
      *  Function:  This program handles the generation of FF         *
      *             advices if Correspondence Manager is switched     *
      *             off.                                              *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL154             Date 13Oct14               *
      *                 CAP208             Date 06Dec10               *
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
      *  MD046248 - Finastra Rebranding                               *
      *  CGL154 - FATCA Reporting (Recompile)                         *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
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
      *  SRRegP1    - Registers the P1 printer file via ZSFILE.       *
      *  SRRegAU    - Registers the AU printer file via ZSFILE.       *
      *  SRAudit    - Prints the audit report.                        *
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
 
     FGLJENPL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Journal Entry Posting Update by BTBTNB/BTBINB
 
     FREIAC     IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Interest & Charges File by CNUM/CCY/ACOD/ASEQ/BRCH
 
     FTRANS     IF   E           K DISK    INFSR(*PSSR)
      ** Midas FF Transaction Details
 
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
 
     D FFINTY        E DS                  EXTNAME(INTYPD)
     D  FFRECI       E                     EXTFLD(RECI)
     D  FFLCD        E                     EXTFLD(LCD)
     D  FFCHTP       E                     EXTFLD(CHTP)
     D  FFTNLU       E                     EXTFLD(TNLU)
      ** Instrument Type Details Data Structure
 
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
     D PInsTyp         S              5A
     D PSysVal01       S             20A   INZ('ExerciseanOption    ')
     D PCurSet01       S            200A
     D PSysVal02       S             20A   INZ('ClosingTradesInput  ')
     D PCurSet02       S            200A
     D PSysVal03       S             20A   INZ('NoncurrencyOTCs     ')
     D PCurSet03       S            200A
     D PSysVal04       S             20A   INZ('OTCTransactions     ')
     D PCurSet04       S            200A
     D PSysVal05       S             20A   INZ('ExchangeTradedInstr ')
     D PCurSet05       S            200A
     D PSysVal06       S             20A
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
     D WValue          S             10A
     D WRetAcc         S              1A
     D WAcAPTrA        S              1A
     D WRevAcc         S              1A
     D WChkAcc         S              1A
     D WChar           S              1A
     D WTmp            S              2A
     D WMod            S              1A
     D WPrtAdv         S              1A
     D WExOpAdv        S              1A   INZ('N')
     D WClTrAdv        S              1A   INZ('N')
     D WNOtCAdv        S              1A   INZ('N')
     D WCOtCAdv        S              1A   INZ('N')
     D WExTrAdv        S              1A   INZ('N')
     D WVDat           S              7A
     D WMAmt           S             16A
     D WNarr           S             28A
     D WRecCnt         S              5P 0
 
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
     D KTnBr           S                   LIKE(TNBR)
 
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
 
      ** Print the audit report.
 
     C                   EXSR      SRAudit
 
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
     C                   EVALR     KTryp = %TRIM(RTRTYP)
 
     C     KRSAC         SETGT     RERSACL0
     C     KRSAC         READPE    RERSACL0
 
     C                   DOW       NOT %EOF
 
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
     C                   LEAVE
     C                   ENDIF
 
     C     KRSAC         READPE    RERSACL0
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
     C                   MOVE      TRYP          WChar
 
     C                   SELECT
     C                   WHEN      WChar = 'P'
     C                   EVAL      RPTRTD = 'PURCHASE'
     C                   WHEN      WChar = 'S'
     C                   EVAL      RPTRTD = 'SALE'
     C                   WHEN      WChar = 'E'
     C                   EVAL      RPTRTD = 'EXERCISE AN OPTION'
     C                   ENDSL
 
      ** Transaction Narrative
 
     C                   EVAL      RPTNAR = *BLANKS
     C                   EVAL      WNarr = *BLANKS
     C                   MOVEL     NRTD          WNarr
 
     C                   SELECT
     C                   WHEN      %SUBST(NRTD:1:3) = 'OTC'
     C                   EVAL      RPTNAR = 'OTC PREMIUM'
     C                   WHEN      %SUBST(NRTD:1:6) = 'MARKET'
     C                   EVAL      RPTNAR = 'MARKET TRADE'
     C                   OTHER
     C                   EVAL      RPTNAR = WNarr
     C                   ENDSL
 
      ** Currency
 
     C                   EVAL      RPTCCY = CCYD
 
      ** Posting Amount
 
     C                   EXSR      SRCvtMAmt
     C                   EVAL      RPPAMT = WMAmt
 
      ** Last Transaction Change Type
 
     C                   EVAL      RPCHTP = *BLANKS
 
     C                   IF        PCtrlPgm <> 'REC000079'
     C                   SELECT
     C                   WHEN      RCHTYP = 'D'  OR
     C                             WRevAcc = 'Y'
     C                   EVAL      RPCHTP = 'CANCELLATION'
     C                   WHEN      RCHTYP = 'A'
     C                   EVAL      RPCHTP = 'AMENDMENT TO'
     C                   ENDSL
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
 
      ** Check first if the record was written by a FF maintenance.
 
     C                   MOVE      NRTD          WTmp
     C                   MOVEL     WTmp          WMod
 
     C                   IF        WMod <> 'F'
     C                   LEAVESR
     C                   ENDIF
 
     C                   MOVE      TNMR          KTnBr
 
     C     KTnBr         CHAIN     TRANS
 
     C                   IF        NOT %FOUND
     C                   LEAVESR
     C                   ENDIF
 
      ** Only select records of particular Transaction Types.
 
     C                   SELECT
 
     C                   WHEN      %TRIM(TRYP) = 'P' OR
     C                             %TRIM(TRYP) = 'S'
 
      ** Check the Closure Reference.
 
     C                   IF        CLSR = *ZERO
 
      ** Get Instrument Type details.
 
     C                   MOVE      ISTT          PInsTyp
 
     C                   CALL      'AOFFITR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PInsTyp
     C     FFINTY        PARM      FFINTY        DSSDY
 
     C                   IF        PRtCd = '*NRF'
     C                   LEAVESR
     C                   ENDIF
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'INTYPD'
     C                   EVAL      DBKey = PInsTyp
     C                   EVAL      DBase = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Process OTC Trades (Instrument Indicator = 'Y').
 
     C                   IF        ISTI = 'Y'
 
      ** Non-currency OTCs.
 
     C                   IF        ISPT <> 5
 
      ** Exit the subroutine if advice is not necessary.
 
     C                   IF        WNOtCAdv <> 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ELSE
 
      ** Currency OTCs.
 
     C                   IF        WCOtCAdv <> 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Check if Exchange-Traded transactions require advices.
 
     C                   IF        WExTrAdv <> 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Check if Closing Trades require advices.
 
     C                   IF        WClTrAdv <> 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   WHEN      %TRIM(TRYP) = 'E'
 
      ** Check if Exercise an Option transactions require advices.
 
     C                   IF        WExOpAdv <> 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDSL
 
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
 
      ** Exercise an Option
      ** Closing Trades Input
      ** Non-currency OTCs
      ** Currency OTCs
      ** Exchange-Traded Instruments
 
     C                   MOVEL     PCurSet01     WExOpAdv
     C                   MOVEL     PCurSet02     WClTrAdv
     C                   MOVEL     PCurSet03     WNOtCAdv
     C                   MOVEL     PCurSet04     WCOtCAdv
     C                   MOVEL     PCurSet05     WExTrAdv
 
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
     C                   ENDSL
 
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
