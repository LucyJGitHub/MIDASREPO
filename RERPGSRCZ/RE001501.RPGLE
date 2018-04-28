     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Account Balance Check Online Updater')        *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE001501 - Account Balance Check I/C Update                  *
      *                                                               *
      *  Function:  This program will update available balance in     *
      *             GL Account Master Extension File.                 *
      *                                                               *
      *  Called By: REC001501 - Account Balance Check Update job      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CRE090             Date 14Feb14               *
      *  Prev Amend No. MD023738           Date 06Dec13               *
      *                 AR1095876          Date 30Sep13               *
      *                 AR1089341          Date 18Feb13               *
      *                 AR1039172          Date 31Jan13               *
      *                 AR1039177          Date 11Jan13               *
      *                 AR1039174          Date 11Jan13               *
      *                 CLE148             Date 23Jul12               *
      *                 AR978497           Date 25May12               *
      *                 AR966775           Date 11May12               *
      *                 AR968308           Date 10May12               *
      *                 AR958145           Date 26Apr12               *
      *                 AR899028           Date 25Jan12               *
      *                 AR847269           Date 09Nov11               *
      *                 CER042             Date 11May11               *
      *                 CRE075             Date 06Dec10               *
      *                 BUG28103           Date 06Sep10               *
      *                 BUG28007           Date 17Aug10               *
      *                 BUG27831A          Date 03Aug10               *
      *                 BUG27923           Date 30Jul10               *
      *                 BUG27674           Date 26Jul10               *
      *                 BUG27719A          Date 07Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27346           Date 31Mar10               *
      *                 BUG27356           Date 30Mar10               *
      *                 CAP205  *CREATE    Date 15Feb10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  MD023738 - Incomplete to complete transaction created both   *
      *             a reservations and forward movements              *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877)                           *
      *  AR1089341 - Projected Available Balance not updated by       *
      *              Deleted Held Items                               *
      *  AR1039172 - Calculation of the forward available balances    *
      *              does not seem to be using the processing types   *
      *              correctly                                        *
      *  AR1039177 - Treatment of expiry of Held Items                *
      *  AR1039174 - Treatment of expiry of Overdraft Line            *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR978497 - Expiry date for Overdraft line or limit           *
      *           - Rundate wasn't populated for new accounts         *
      *  AR966775 - Expiry Dates for Held Items and Overdraft Limits  *
      *           - Applied fix for AR975927                          *
      *  AR968308 - Today's Available Balance in PABE did not include *
      *             the OD Line amount.                               *
      *           - Applied fix for AR975746                          *
      *  AR958145 - ABC First day processing enhancement              *
      *           - Applied fix for AR975746                          *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179) (Recompile)                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG28103 - Erroneous today's available balance.              *
      *  BUG28007 - ABC Performed Flag update must be done in java.   *
      *             Remove Bug27831A changes in this program .        *
      *  BUG27831A - Forward Account Transfer Processing              *
      *  BUG27923 - Incorrect update balance when there is hard held  *
      *             ite mand OD line                                  *
      *  BUG27674 - Blocked Collateral Amount was deducted twice      *
      *  BUG27719A-Retail Account Balance Check change control        *
      *            RetailAPI050 (Use of Account Balance fields for    *
      *            minimum balance check).                            *
      *  BUG27346- Currency decimal places not considered in          *
      *            overdraft amount                                   *
      *  BUG27356- Program REC001501 ended abnormally                 *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         Error Indicator                                 *
      *    60         End-of-File Indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  Main routine                                                 *
      *  *INZSR         - Initialise                                  *
      *  *PSSR          - Error handling subroutine                   *
      *  SrRSACTrans    - Process RSACMTPD journal record             *
      *  SrHELDTrans    - Process Held Items                          *
      *  SrAcctTrans    - Process Accounts                            *
      *  SrReset        - Initialise variables                        *
      *  SrLoadFields   - Load GLACNTQD Dates and Balances fields     *
      *                   into work arrays.                           *
      *  SrGetProcType  - Get Processing Type from SDABCIPD depending *
      *                   on Module and Movement Type.                *
      *  SrProcAvailBal - Add/Subtract Movement Amount to Available   *
      *                   Balances.                                   *
      *  SrUpdate       - Update Available Balances in GLACNTQD       *
      *  SRCancReserv   - Cancel reservation in T_MLRSVTRN            *
      *  SrLoadHeld     - Load Current/Previous Hard & Soft Held Items*
      *  SrLoadOvDrft   - Load OverDraft Line                         *
      *  SrLoadBlColl   - Load Blocked Collateral                     *
      *  SrLoadHeld2    - Load Hard & Soft Held Items                 *
      *  SrLoadPrvVal   - Load previous value by debiting overdraft   *
      *                   line amount                                 *
      *  SrAmndCurVal   - Amend current value by crediting overdraft  *
      *                   line amount                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGLACNTL4  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas GL Account Master Extension
     F/COPY WNCPYSRC,REH00091
 
     FHELDIL1   IF   E           K DISK    INFSR(*PSSR) PREFIX(H)
     F                                     IGNORE(HELDIHAF:HELDIHCF)
      ** Midas RE Held Items File
 
     FREODHSL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Overdraft history by account and history date
 
     F**REABCRL0  IF   E           K DISK    INFSR(*PSSR)                                   AR958145
      ***Midas*RE*Account*Balance*Check*Required***********************                     AR958145
 
     FSDABCIPD  IF   E           K DISK    INFSR(*PSSR)
      ** Retail Account Balance Check ICD File
 
     FGLCOLLLG  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Live Collateral Details by Account
 
     FGLCOLLQ0  IF   E           K DISK    INFSR(*PSSR) PREFIX(Q)
      ** Midas GL Collateral Details Extension
 
     F***GLATMIL5  UF   E           K DISK    INFSR(*PSSR)                        BUG27831A BUG28007
     F**********                           COMMIT                                 BUG27831A BUG28007
      ***Midas*GL*Account*Transfers*File*******************************           BUG27831A BUG28007
      *****************************************************************           BUG27831A BUG28007
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for Switchable Features
 
     D AccBeforeImg  E DS                  EXTNAME(HELDIHB) PREFIX(B)
      **  External DS for Before Image Held Items Detail
 
     D AcctAfterImg  E DS                  EXTNAME(HELDIHB) PREFIX(A)
      **  External DS for Before Image Held Items Detail
 
     D CurHELDIHB    E DS                  EXTNAME(HELDIHB) PREFIX(H)
      **  External DS for Current Held Items Detail
 
     D ActBeforeImg  E DS                  EXTNAME(ACCNTAB) PREFIX(C)
      **  External DS for Before Image Account Detail
 
     D AcntAfterImg  E DS                  EXTNAME(ACCNTAB) PREFIX(D)
      **  External DS for After Image Account Detail
 
     D GLCOLLPD_BEF  E DS                  EXTNAME(GLCOLLPD) PREFIX(BEF_)
      ** Before image of GLCOLLPD
 
     D GLCOLLPD_AFT  E DS                  EXTNAME(GLCOLLPD) PREFIX(AFT_)
      ** After image of GLCOLLPD
 
     D GLCOLLPD_CUR  E DS                  EXTNAME(GLCOLLPD)
      ** Current image of GLCOLLPD
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                BUG27346
      ***  External data structures for Currency Details                                    BUG27346
                                                                                            BUG27346
     D SDSTAT        E DS                  EXTNAME(SDSTAT)                                  AR958145
      ** Data Area for Standing Data Details                                                AR958145
                                                                                            AR958145
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access programs, long data structure
 
     D/COPY ZACPYSRC,PSDS
      ** The Following /COPY Line Includes All The Defined Fields In
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
 
      ** +--------------------------------------+
      ** ¦ Arrays AND Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D                 DS                                                                   AR958145
      *** Data structure of workdates                                                       AR958145
     D  F2DAT0                 1      3P 0                                                  AR958145
     D  F2DAT1                 4      6P 0                                                  AR958145
     D  F2DAT2                 7      9P 0                                                  AR958145
     D  F2DAT3                10     12P 0                                                  AR958145
     D  F2DAT4                13     15P 0                                                  AR958145
     D  F2DAT5                16     18P 0                                                  AR958145
     D  F2DAT6                19     21P 0                                                  AR958145
     D  F2DAT7                22     24P 0                                                  AR958145
     D  F2DAT8                25     27P 0                                                  AR958145
     D  F2DAT9                28     30P 0                                                  AR958145
     D  F2DATS                 1     30P 0                                                  AR958145
     D                                     DIM(10) ASCEND                                   AR958145
     D AVAIL_DATES     DS
     D  F1DAT0
     D  F1DAT1
     D  F1DAT2
     D  F1DAT3
     D  F1DAT4
     D  F1DAT5
     D  F1DAT6
     D  F1DAT7
     D  F1DAT8
     D  F1DAT9
     D AvailDatesArr                       LIKE(F1DAT0) DIM(10)
     D                                     OVERLAY(AVAIL_DATES)
 
     D***BASE_BAL        DS                                                                BUG27719A
     D***F1BAV0                                                                            BUG27719A
     D***F1BAV1                                                                            BUG27719A
     D***F1BAV2                                                                            BUG27719A
     D***F1BAV3                                                                            BUG27719A
     D***F1BAV4                                                                            BUG27719A
     D***F1BAV5                                                                            BUG27719A
     D***F1BAV6                                                                            BUG27719A
     D***F1BAV7                                                                            BUG27719A
     D***F1BAV8                                                                            BUG27719A
     D***F1BAV9                                                                            BUG27719A
     D*BaseBalanceArr                      LIKE(F1BAV0) DIM(10)                            BUG27719A
     D**********                           OVERLAY(BASE_BAL)                               BUG27719A
 
     D AVAIL_BAL       DS
     D  F1AVA0
     D  F1AVA1
     D  F1AVA2
     D  F1AVA3
     D  F1AVA4
     D  F1AVA5
     D  F1AVA6
     D  F1AVA7
     D  F1AVA8
     D  F1AVA9
     D AvailBalArr                         LIKE(F1AVA0) DIM(10)
     D                                     OVERLAY(AVAIL_BAL)
     D/COPY WNCPYSRC,REH00092
     D/COPY ZSRSRC,ZHOLILE                                                                  AR958145
     D/COPY ZSRSRC,ZHOLELE                                                                  AR958145
 
     D ABCData         DS
 
      ** Event Type
 
     D  WEventType             1     20
     D  WTrigEvent            21     21
 
      ** Event Detail
 
     D  WDetail               22   4021
     D  WAfter                22   2021
     D  WBefore             2022   4021
 
     D RSAC          E DS                  EXTNAME(RSACMTPD)
      ** RSACMTPD details
 
     D GLACNT        E DS                  EXTNAME(ACCNTAB) PREFIX(AA)
      ** Account details
 
     D LDA             DS           256
      ** Local data area for database error details
 
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256
 
     D***CurSoftHeld     S             13P 0 DIM(10)                                       AR1089341
     D***PrvSoftHeld     S             13P 0 DIM(10)                                       AR1089341
 
     D***CurHardHeld     S             13P 0 DIM(10)                                       AR1089341
     D***PrvHardHeld     S             13P 0 DIM(10)                                       AR1089341
 
     D***SoftHeld        S             13P 0 DIM(10)                                       AR1089341
     D***HardHeld        S             13P 0 DIM(10)                                       AR1089341
 
     D***BaseAvailBal    S             15P 0 DIM(10)                                       BUG27719A
     D***BlockedColl     S             15P 0 DIM(10)                                       AR1089341
     D***BlockCollPrev   S             15P 0 DIM(10)                                       AR1089341
     D AvailBalance    S             15P 0 DIM(10)
     D AcctBalance     S             15P 0 DIM(10)                                         BUG27719A
     D OvrdraftLine    S             11P 0 DIM(11)                                         AR1089341
     D CurSoftHeld     S             13P 0 DIM(11)                                         AR1089341
     D PrvSoftHeld     S             13P 0 DIM(11)                                         AR1089341
     D CurHardHeld     S             13P 0 DIM(11)                                         AR1089341
     D PrvHardHeld     S             13P 0 DIM(11)                                         AR1089341
     D SoftHeld        S             13P 0 DIM(11)                                         AR1089341
     D HardHeld        S             13P 0 DIM(11)                                         AR1089341
     D BlockedColl     S             15P 0 DIM(11)                                         AR1089341
     D BlockCollPrev   S             15P 0 DIM(11)                                         AR1089341
     D***OvrdraftLine    S             11P 0 DIM(10)                                       AR1089341
     D/COPY WNCPYSRC,REH00093
 
     D Rundate         S              5P 0 DIM(10)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRtCd           S              7A
     D POptn           S              7A
     D PAcno           S             10A
     D PCusn           S              6A
     D PCurr           S              3A
     D PACod           S             10A
     D PASeq           S              2A
     D PBrch           S              3A
     D PSard           S              6
 
     D KCusn           S              6A
     D KCurr           S              3A
     D KAcod           S             10S 0
     D KAseq           S              2S 0
     D KBrch           S              3A
     D KBranch         S                   LIKE(QCDXBRC)
     D KCollRef        S                   LIKE(QCDXREF)
     D*KyTREF***       S                   LIKE(R1TREF)                           BUG27831A BUG28007
     D*KyEXDT***       S                   LIKE(R1EXDT)                           BUG27831A BUG28007
 
     D WDorc           S              1S 0
     D WProcType       S              1S 0
     D WExpiry         S              5P 0
     D WRun            S              1A
     D WUpdate         S              1A
     D Returncode      S              6A
     D CommitID        S             10A
     D CRE001          S              1A
     D Ix              S              2S 0
     D i               S              3P 0
     D Wndyf           S              5P 0
     D WCTR            S              3  0                                                  AR958145
     D LOCIND          S              1A                                                    AR958145
     D ACTIND          S              1A                                                    AR958145
     D NoDays          S              3S 0                                                  AR958145
     D WKSysNoDays     S              1A                                                    AR958145
     D WDATEIN         S              5  0                                                  AR958145
     D PSysVal         S             20    DIM(10)                                          AR958145
     D PCurSet         S            200    DIM(10)                                          AR958145
     D DtqLen          S              5P 0                                                  AR958145
     D DtqLib          S             10A                                                    AR958145
     D DtqNam          S             10A                                                    AR958145
     D WLength         S              4S 0                                                  AR958145
     D Wloop           S              1A                                                    AR958145
     ** System value for Overdraft Processing Type                                         AR1039174
     D WKOvrdPtype     S              1                                                    AR1039174
     ** System value for Held Items Processing Type                                        AR1039177
     D WKHeldPtype     S              1                                                    AR1039177
     D WNWD            S              3  0                                                 AR1095876
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************
 
     C                   SELECT
 
     C                   WHEN      WEventType = 'TRAN_RSACMTPD'
     C                   EXSR      SrRSACTrans
 
     C                   WHEN      WEventType = 'MNT_HELDIHB'
     C                   EXSR      SrHELDTrans
 
     C                   WHEN      WEventType = 'MNT_ACCNTAB'
     C                   EXSR      SrACCTTrans
 
     C                   WHEN      WEventType = 'GLOBAL_TRANSACTION'
     C                   EXSR      SrCancReserv
 
     C                   WHEN      WEventType = 'MNT_GLCOLLPD'
     C                   EXSR      SrGLCOLTrans
 
     C                   ENDSL
 
      ** If GLACNTQD was updated or a reservation was cancelled, issue
      ** COMMIT.
 
     C                   IF        WUpdate = 'Y'
     C                   COMMIT
     C                   ENDIF
 
      ** Terminate program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRSACTrans - Process RSACMTPD journal record                 *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrRSACTrans   BEGSR
 
     C                   EXSR      SrReset
 
     C                   EVAL      RSAC  = WDetail
     C                   EVAL      WDorc = DORC
 
     C                   EVAL      PCusn = CUSN
     C                   EVAL      PCurr = CCYD
     C                   EVAL      PBrch = BRCA
     C                   MOVE(P)   ACDE          PACod
     C                   MOVE(P)   ASNC          PASeq
 
     C                   CALL      'AOACCTR0'    PAccntab
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'AOACCTR0'
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBKEY = PCusn + PCurr + PACod +
     C                                     PASeq + PBrch
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Continue processing only when account has no attached facility
      ** and account was not just inserted today.
 
     C                   IF        AAFCCU  = *BLANKS AND
     C                             AAFACT  = *ZEROS  AND
     C**********                   AAFCNO  = *ZEROS  AND                                    AR958145
     C**********                   AAORED <> BJRDNB                                         AR958145
     C                             AAFCNO  = *ZEROS                                         AR958145
 
      ** Access records from GLACNTQD
 
     C                   EVAL      KCusn = CUSN
     C                   EVAL      KCurr = CCYD
     C                   EVAL      KAcod = ACDE
     C                   EVAL      KAseq = ASNC
     C                   EVAL      KBrch = BRCA
 
     C     KGlacnt       CHAIN     GLACNTL4
     C                   IF        NOT %FOUND( GLACNTL4 )
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE001501'
     C                   EVAL      DBFILE = 'GLACNTQD'
     C                   EVAL      DBKEY = KCusn + KCurr + %TRIM(%CHAR(KAcod)) +
     C                                     %TRIM(%CHAR(KAseq)) + KBrch
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C/COPY WNCPYSRC,REH00094
      ***Access*records*from*REABCRPD**********************************                     AR958145
 
     C*****KGlacnt       CHAIN     REABCRL0                                                 AR958145
     C**********         IF        NOT %FOUND( REABCRL0 )                                   AR958145
     C******LOCK         IN        LDA                                                      AR958145
     C**********         EVAL      DBPGM = 'RE001501'                                       AR958145
     C**********         EVAL      DBFILE = 'REABCRPD'                                      AR958145
     C**********         EVAL      DBKEY = KCusn + KCurr + %TRIM(%CHAR(KAcod)) +            AR958145
     C**********                           %TRIM(%CHAR(KAseq)) + KBrch                      AR958145
     C**********         EVAL      DBASE = 6                                                AR958145
     C**********         OUT       LDA                                                      AR958145
     C**********         EXSR      *PSSR                                                    AR958145
     C**********         ENDIF                                                              AR958145
 
      ** Continue processing when Include Account Balance Check flag is Y
      ** and has not been set to Y just today.
 
     C**********         IF        F1IABC = 'Y' AND MLIABC = 'Y'                            AR958145
     C                   IF        F1IABC = 'Y' OR AAATYP = 'R'                             AR958145
 
      ** Load GLACNTCD dates and balances in work array.
 
     C                   EXSR      SrLoadFields
 
      ** Get the corresponding Processing Type of RSAC transaction
      ** based on Module and Movement Type.
 
     C                   EXSR      SrGetProcType
 
      ** Process Available Balances
 
     C                   EXSR      SrProcAvailBal
 
      ** Update Available Balance in GLACNTQD
 
     C                   EXSR      SrUpdate
      *****************************************************************           BUG27831A BUG28007
      ***Update*ABC*Performed*flag*in*GLATMIPD*************************           BUG27831A BUG28007
      *****************************************************************           BUG27831A BUG28007
     C**********         EXSR      SrUpdATMI                                      BUG27831A BUG28007
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrHELDTrans - Process Held Items                              *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrHELDTrans   BEGSR
 
     C                   EXSR      SrReset
 
     C                   EVAL      AccBeforeImg = WBefore
     C                   EVAL      AcctAfterImg = WAfter
 
      ** Retrieve Account Details
 
     C                   EVAL      PCusn = ACNUM
     C                   EVAL      PCurr = ACCY
     C                   EVAL      PBrch = ABRCA
     C                   MOVE(P)   AACOD         PACod
     C                   MOVE(P)   AACSQ         PASeq
 
     C                   CALL      'AOACCTR0'    PAccntab
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE001501'
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBKEY = PCusn + PCurr + PACod +
     C                                     PASeq + PBrch
     C                   EVAL      DBASE = 7
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C**********         IF        AAORED <> BJRDNB                                         AR958145
 
     C                   EVAL      KCusn = ACNUM
     C                   EVAL      KCurr = ACCY
     C                   EVAL      KAcod = AACOD
     C                   EVAL      KAseq = AACSQ
     C                   EVAL      KBrch = ABRCA
 
     C     KGlacnt       CHAIN     GLACNTL4
     C                   IF        NOT %FOUND( GLACNTL4 )
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE001501'
     C                   EVAL      DBFILE = 'GLACNTQD'
     C                   EVAL      DBKEY = KCusn + KCurr + %TRIM(%CHAR(KAcod)) +
     C                                     %TRIM(%CHAR(KAseq)) + KBrch
     C                   EVAL      DBASE = 8
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C/COPY WNCPYSRC,REH00095
      ***Access*records*from*REABCRPD**********************************                     AR958145
 
     C*****KGlacnt       CHAIN     REABCRL0                                                 AR958145
     C**********         IF        NOT %FOUND( REABCRL0 )                                   AR958145
     C******LOCK         IN        LDA                                                      AR958145
     C**********         EVAL      DBPGM = 'RE001501'                                       AR958145
     C**********         EVAL      DBFILE = 'REABCRPD'                                      AR958145
     C**********         EVAL      DBKEY = KCusn + KCurr + %TRIM(%CHAR(KAcod)) +            AR958145
     C**********                           %TRIM(%CHAR(KAseq)) + KBrch                      AR958145
     C**********         EVAL      DBASE = 9                                                AR958145
     C**********         OUT       LDA                                                      AR958145
     C**********         EXSR      *PSSR                                                    AR958145
     C**********         ENDIF                                                              AR958145
 
      ** Continue processing when Include Account Balance Check flag is Y
      ** and has not been set to Y just today.
 
     C**********         IF        F1IABC = 'Y' AND MLIABC = 'Y'                            AR958145
     C                   IF        F1IABC = 'Y' OR AAATYP = 'R'                             AR958145
 
      ** Load GLACNTCD dates and balances in work array.
 
     C                   EXSR      SrLoadFields
 
      ***Trigger*Event*is*Insert*Add*current*held*amount*from*base*****                    BUG27719A
      ***available*and*available*balances.*****************************                    BUG27719A
                                                                                           BUG27719A
      ** Trigger Event is Insert: Add current held amount to the                           BUG27719A
      ** available balances.                                                               BUG27719A
 
     C                   IF        WTrigEvent = '1' OR
     C                             (WTrigEvent = '3' AND BRECI = '*'
     C                             AND ARECI = 'D')
 
     C                   FOR       Ix = 1 to Wndyf
 
     C**********         IF        Rundate(Ix) <= AHEXP                                     AR966775
     C                   IF        Rundate(Ix) < AHEXP                                      AR966775
     C                             AND WKHeldPtype = '2'                                   AR1039177
     C                             OR AHEXP > BJRDNB                                       AR1039177
     C                             AND WKHeldPtype = '3'                                   AR1039177
     C                             OR AHEXP >= BJRDNB                                      AR1039177
     C                             AND WKHeldPtype = '4'                                   AR1039177
     C**********         EVAL      BaseAvailBal(Ix) = BaseAvailBal(Ix) + AHLDA             BUG27719A
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) + AHLDA
     C/COPY WNCPYSRC,REH00096
 
     C                   IF        AHHIT = 'Y'
     C**********         EVAL      CurHardHeld(Ix) = CurHardHeld(Ix) + AHLDA                BUG27923
     C                   IF        AcctAfterImg <> CurHELDIHB                               MD023738
     C                   EVAL      PrvHardHeld(Ix) = PrvHardHeld(Ix) - AHLDA                BUG27923
     C                   ELSE                                                               MD023738
     C                   EVAL      CurHardHeld(Ix) = CurHardHeld(Ix) + AHLDA                MD023738
     C                   ENDIF                                                              MD023738
     C                   ELSE
     C                   IF        AcctAfterImg <> CurHELDIHB                               MD023738
     C**********         EVAL      CurSoftHeld(Ix) = CurSoftHeld(Ix) + AHLDA                BUG27923
     C**********         EVAL      PrvHardHeld(Ix) = PrvHardHeld(Ix) - AHLDA       BUG27923 BUG28103
     C                   EVAL      PrvSoftHeld(Ix) = PrvSoftHeld(Ix) - AHLDA                BUG28103
     C                   ELSE                                                               MD023738
     C                   EVAL      CurSoftHeld(Ix) = CurSoftHeld(Ix) + AHLDA                MD023738
     C                   ENDIF                                                              MD023738
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   ELSE
 
      ***Trigger*Event*is*Delete.*Subtract*current*held*amount*from*based*available        BUG27719A
      ***and*available*balances.***************************************                    BUG27719A
 
      ** Trigger Event is Delete: Subtract current held amount from the                    BUG27719A
      ** available balances.                                                               BUG27719A
 
     C                   IF        WTrigEvent = '3' AND BRECI = 'D'
     C                             AND ARECI = '*'
 
     C                   FOR       Ix = 1 to Wndyf
     C**********         IF        Rundate(Ix) <= AHEXP                                     AR966775
     C                   IF        Rundate(Ix) < AHEXP                                      AR966775
     C                             AND WKHeldPtype = '2'                                   AR1039177
     C                             OR AHEXP > BJRDNB                                       AR1039177
     C                             AND WKHeldPtype = '3'                                   AR1039177
     C                             OR AHEXP >= BJRDNB                                      AR1039177
     C                             AND WKHeldPtype = '4'                                   AR1039177
     C**********         EVAL      BaseAvailBal(Ix) = BaseAvailBal(Ix) - AHLDA             BUG27719A
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) - AHLDA
     C/COPY WNCPYSRC,REH00097
 
     C                   IF        AHHIT = 'Y'
     C                   EVAL      PrvHardHeld(Ix) = PrvHardHeld(Ix) + AHLDA
     C                   ELSE
     C                   EVAL      PrvSoftHeld(Ix) = PrvSoftHeld(Ix) + AHLDA
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDFOR
 
      ** OtherwiseTrigger Event is Update. Load back previous value by crediting
      ** held amount then update new value by debiting held amount.
 
     C                   ELSE
 
      ** Credit Before Image Held Amount
 
     C                   FOR       Ix = 1 to Wndyf
 
     C**********         IF        Rundate(Ix) <= BHEXP                                     AR966775
     C                   IF        Rundate(Ix) < BHEXP                                      AR966775
     C                             AND WKHeldPtype = '2'                                   AR1039177
     C                             OR BHEXP > BJRDNB                                       AR1039177
     C                             AND WKHeldPtype = '3'                                   AR1039177
     C                             OR BHEXP >= BJRDNB                                      AR1039177
     C                             AND WKHeldPtype = '4'                                   AR1039177
     C**********         EVAL      BaseAvailBal(Ix) = BaseAvailBal(Ix) - BHLDA             BUG27719A
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) - BHLDA
     C/COPY WNCPYSRC,REH00098
 
     C                   IF        BHHIT = 'Y'
     C                   EVAL      PrvHardHeld(Ix) = PrvHardHeld(Ix) + BHLDA
     C                   ELSE
     C                   EVAL      PrvSoftHeld(Ix) = PrvSoftHeld(Ix) + BHLDA
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDFOR
 
      ** Debit  After Image Held Amount
 
     C                   FOR       Ix = 1 to Wndyf
 
     C**********         IF        Rundate(Ix) <= AHEXP                                     AR966775
     C                   IF        Rundate(Ix) < AHEXP                                      AR966775
     C                             AND WKHeldPtype = '2'                                   AR1039177
     C                             OR AHEXP > BJRDNB                                       AR1039177
     C                             AND WKHeldPtype = '3'                                   AR1039177
     C                             OR AHEXP >= BJRDNB                                      AR1039177
     C                             AND WKHeldPtype = '4'                                   AR1039177
     C**********         EVAL      BaseAvailBal(Ix) = BaseAvailBal(Ix) + AHLDA             BUG27719A
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) + AHLDA
     C/COPY WNCPYSRC,REH00099
 
     C                   IF        AHHIT = 'Y'
     C                   EVAL      CurHardHeld(Ix) = CurHardHeld(Ix) + AHLDA
     C                   ELSE
     C                   EVAL      CurSoftHeld(Ix) = CurSoftHeld(Ix) + AHLDA
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   ENDIF
 
     C                   ENDIF
 
      ***Update*Base*Available*and*Available*Balances*array************                    BUG27719A
      ** Update Available Balances array                                                   BUG27719A
 
     C                   FOR       Ix = 1 to Wndyf
 
      ** If Current Hard Held Items Array and blocked collateral amount is zero, check an overdraft
      ** line for this account. If there is, credit this amount from the Base Available and
      ** available Balances.
 
     C                   IF        CurHardHeld(Ix) = 0 AND BlockedColl(Ix) = 0
     C                             AND OvrdraftLine(Ix) <> 0
     C                             AND PrvHardHeld(Ix) <> 0                                 BUG27923
     C**********         EVAL      BaseAvailBal(Ix) = BaseAvailBal(Ix) -                   BUG27719A
     C**********                                      OvrdraftLine(Ix)                     BUG27719A
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) -
     C                                                OvrdraftLine(Ix)
     C/COPY WNCPYSRC,REH00100
     C                   ENDIF
 
     C                   IF        PrvHardHeld(Ix) = 0 AND BlockedColl(Ix) = 0
     C                             AND OvrdraftLine(Ix) <> 0
     C                             AND CurHardHeld(Ix) <> 0                                 BUG27923
     C**********         EVAL      BaseAvailBal(Ix) = BaseAvailBal(Ix) +                   BUG27719A
     C**********                                      OvrdraftLine(Ix)                     BUG27719A
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) +
     C                                                OvrdraftLine(Ix)
     C/COPY WNCPYSRC,REH00101
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   EXSR      SrUpdate
 
     C                   ENDIF
 
     C**********         ENDIF                                                              AR958145
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrACCTTrans - Process Account                                 *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrACCTTrans   BEGSR
 
     C                   EXSR      SrReset
 
     C                   EVAL      ActBeforeImg = WBefore
     C                   IF        WBefore = *BLANKS                                        AR958145
     C                   CLEAR                   ActBeforeImg                               AR958145
     C                   ENDIF                                                              AR958145
     C                   EVAL      AcntAfterImg = WAfter
 
     C                   IF        CODLN <> DODLN OR CODED <> DODED
     C                             OR WTrigEvent = '1'                                      AR958145
 
     C**********         IF        DORED <> BJRDNB                                          AR958145
 
      ** Retrieve Account Details
 
     C                   EVAL      PCusn = DCNUM
     C                   EVAL      PCurr = DCCY
     C                   EVAL      PBrch = DBRCA
     C                   MOVE(P)   DACOD         PACod
     C                   MOVE(P)   DACSQ         PASeq
 
     C                   CALL      'AOACCTR0'    PAccntab
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'ACCNTAB'
     C                   EVAL      DBKey = PCusn + PCurr + PACod +
     C                                     PASeq + PBrch
     C                   EVAL      DBASE = 12
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      KCusn = DCNUM
     C                   EVAL      KCurr = DCCY
     C                   EVAL      KAcod = DACOD
     C                   EVAL      KAseq = DACSQ
     C                   EVAL      KBrch = DBRCA
     C                   EVAL      Wloop = 'N'                                              AR958145
 
     C     KGlacnt       CHAIN     GLACNTL4
     C                   IF        NOT %FOUND(GLACNTL4)
     C                   IF        WTrigEvent = '1'                                         AR958145
     C                   EVAL      Wloop = 'Y'                                              AR958145
     C                   EVAL      DtqLib = LIBR + 'DPLIB'                                  AR958145
     C     ' '           CHECKR    ABCData       WLength                                    AR958145
                                                                                            AR958145
     C                   CALL      'QSNDDTAQ'                                               AR958145
     C                   PARM      'CREABCQ'     DtqNam                                     AR958145
     C                   PARM                    DtqLib                                     AR958145
     C                   PARM      WLength       DtqLen                                     AR958145
     C                   PARM                    ABCData                                    AR958145
                                                                                            AR958145
     C                   ELSE                                                               AR958145
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'GLACNTQD'
     C                   EVAL      DBKey = KCusn + KCurr + %TRIM(%CHAR(KAcod)) +
     C                                     %TRIM(%CHAR(KAseq)) + KBrch
     C                   EVAL      DBase = 13
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF                                                              AR958145
     C                   ENDIF
 
     C/COPY WNCPYSRC,REH00102
      ***Access*records*from*REABCRPD**********************************                     AR958145
 
     C*****KGlacnt       CHAIN     REABCRL0                                                 AR958145
     C**********         IF        NOT %FOUND( REABCRL0 )                                   AR958145
     C******LOCK         IN        LDA                                                      AR958145
     C**********         EVAL      DBFile = 'REABCRPD'                                      AR958145
     C**********         EVAL      DBKey = KCusn + KCurr + %TRIM(%CHAR(KAcod)) +            AR958145
     C**********                           %TRIM(%CHAR(KAseq)) + KBrch                      AR958145
     C**********         EVAL      DBase = 14                                               AR958145
     C**********         OUT       LDA                                                      AR958145
     C**********         EXSR      *PSSR                                                    AR958145
     C**********         ENDIF                                                              AR958145
     C                   IF        Wloop = 'N'                                              AR958145
 
      ** Continue processing when Include Account Balance Check flag is Y
      ** and has not been set to Y just today.
 
     C**********         IF        F1IABC = 'Y' AND MLIABC = 'Y'                            AR958145
     C                   IF        F1IABC = 'Y' OR AAATYP = 'R'                             AR958145
                                                                                            AR958145
     C                   IF        F1DAT1 = 0                                               AR958145
     C                   EXSR      SrLoadDates                                              AR958145
     C                   EXSR      SRGetCurrD                                               AR968308
     C                   EXSR      SrAmndCurVal                                             AR968308
     C                   ELSE                                                               AR958145
 
      ** Load GLACNTCD dates and balances in work array.
 
     C                   EXSR      SrLoadFields
     C                   ENDIF                                                              AR958145
 
      ** Update Available Balance in GLACNTQD
 
     C                   EXSR      SrUpdate
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGLCOLTrans - Blocked Collateral Processing                 *
      *                                                               *
      *  Called by: Main routine                                      *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SrGLCOLTrans  BEGSR
 
     C                   EXSR      SrReset
 
     C                   EVAL      GLCOLLPD_BEF = WBefore
     C                   EVAL      GLCOLLPD_AFT = WAfter
 
      ** Trigger event is insert or logical delete
 
     C                   IF        WTrigEvent = '1'
     C                                   OR
     C                             WTrigEvent = '3'
     C                                AND BEF_CDRECI = 'D'
     C                                AND AFT_CDRECI = 'R'
 
      ** Block Collateral = 'Y'
      ** Collateral Processing Type = 'A'
 
     C                   IF        AFT_CDBCOL = 'Y'
     C                                AND AFT_CDCOPT = 'A'
 
     C                   EVAL      KCusn = AFT_CDCCNM
     C                   EVAL      KCurr = AFT_CDCCCY
     C                   EVAL      KBrch = AFT_CDCBRC
     C                   EVAL      KAcod = AFT_CDCACD
     C                   EVAL      KAseq = AFT_CDCSEQ
 
     C                   EXSR      SrCollProcess
 
     C**********         IF        AAORED <> BJRDNB                                BUG27356 AR958145
                                                                                            BUG27356
     C                   IF        WTrigEvent = '1'
     C                   EXSR      SrLoadCurr
     C                   ELSE
     C                   EXSR      SrLoadPrev
     C                   ENDIF
 
     C                   EXSR      SrRecompute
     C                   EXSR      SrAccUpdate
                                                                                            BUG27356
     C**********         ENDIF                                                     BUG27356 AR958145
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Trigger Event is Update
                                                                                            BUG27674
     C                   IF        BEF_CDNAMT <> AFT_CDNAMT                                 BUG27674
     C                             OR BEF_CDEDAT <> AFT_CDEDAT                              BUG27674
     C                             OR BEF_CDVDAT <> AFT_CDVDAT                              BUG27674
     C                             OR BEF_CDCCNM <> AFT_CDCCNM                              BUG27674
     C                             OR BEF_CDCCCY <> AFT_CDCCCY                              BUG27674
     C                             OR BEF_CDCBRC <> AFT_CDCBRC                              BUG27674
     C                             OR BEF_CDCACD <> AFT_CDCACD                              BUG27674
     C                             OR BEF_CDCSEQ <> AFT_CDCSEQ                              BUG27674
 
      ** Process before image(GLCOLLPD_BEF)
 
     C                   IF        BEF_CDBCOL = 'Y'
     C                                AND BEF_CDCOPT = 'A'
 
     C                   EVAL      KCusn = BEF_CDCCNM
     C                   EVAL      KCurr = BEF_CDCCCY
     C                   EVAL      KBrch = BEF_CDCBRC
     C                   EVAL      KAcod = BEF_CDCACD
     C                   EVAL      KAseq = BEF_CDCSEQ
 
     C                   EXSR      SrCollProcess
 
     C**********         IF        AAORED <> BJRDNB                                BUG27356 AR958145
                                                                                            BUG27356
     C                   EXSR      SrLoadPrev
 
     C                   EXSR      SrAccUpdate
                                                                                            BUG27356
     C**********         ENDIF                                                     BUG27356 AR958145
     C
     C                   ENDIF
 
      ** Process after image(GLCOLLPD_AFT)
 
     C                   IF        AFT_CDBCOL = 'Y'
     C                                AND AFT_CDCOPT = 'A'
 
     C                   EVAL      KCusn = AFT_CDCCNM
     C                   EVAL      KCurr = AFT_CDCCCY
     C                   EVAL      KBrch = AFT_CDCBRC
     C                   EVAL      KAcod = AFT_CDCACD
     C                   EVAL      KAseq = AFT_CDCSEQ
 
     C                   EXSR      SrCollProcess
 
     C**********         IF        AAORED <> BJRDNB                                BUG27356 AR958145
                                                                                            BUG27356
     C                   EXSR      SrLoadCurr
 
     C                   EXSR      SrRecompute
 
     C                   EXSR      SrAccUpdate
                                                                                            BUG27356
     C**********         ENDIF                                                     BUG27356 AR958145
     C
     C                   ENDIF
                                                                                            BUG27674
     C                   ENDIF                                                              BUG27674
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCollProcess - Blocked Collateral Processing                *
      *                                                               *
      *  Called by: SrGLCOLTrans                                      *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SrCollProcess BEGSR
 
     C                   EVAL      PCusn  =  KCusn
     C                   EVAL      PCurr  =  KCurr
     C                   EVAL      PACod  =  %EDITC(KAcod:'X')
     C                   EVAL      PASeq  =  %EDITC(KAseq:'X')
     C                   EVAL      PBrch  =  KBrch
 
      ** Access account details
 
     C                   CALL      'AOACCTR0'    PAccntab
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'ACCNTAB'
     C                   EVAL      DBKey = PCusn + PCurr + PACod + PASeq + PBrch
     C                   EVAL      DBase = 15
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If account's original entry date is today, bypass processing
 
     C**********         IF        AAORED <> BJRDNB                                         AR958145
 
      ** Access balances and dates in GLACNTQD
 
     C     KGlacnt       CHAIN     GLACNTL4
 
     C                   IF        NOT %FOUND( GLACNTL4 )
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'GLACNTQD'
     C                   EVAL      DBKey = KCusn + KCurr + %EDITC(KAcod:'X') +
     C                                     %EDITC(KAseq:'X') + KBrch
     C                   EVAL      DBase = 16
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C/COPY WNCPYSRC,REH00103
      ** Access account balance check required flag
 
     C*****KGlacnt       CHAIN     REABCRL0                                                 AR958145
 
     C**********         IF        NOT %FOUND(REABCRL0)                                     AR958145
     C******LOCK         IN        LDA                                                      AR958145
     C**********         EVAL      DBFile = 'REABCRPD'                                      AR958145
     C**********         EVAL      DBKey = KCusn + KCurr + %EDITC(KAcod:'X') +              AR958145
     C**********                           %EDITC(KAseq:'X') + KBrch                        AR958145
     C**********         EVAL      DBase = 17                                               AR958145
     C**********         OUT       LDA                                                      AR958145
     C**********         EXSR      *PSSR                                                    AR958145
     C**********         ENDIF                                                              AR958145
 
      ** Process only if include account balance check indicator fromn GLACNTQD
      ** and REABCRPD is 'Y'
 
     C                   IF        F1IABC = 'Y'
     C**********                      AND MLIABC = 'Y'                                      AR958145
     C                                OR AAATYP = 'R'                                       AR958145
      *                                                                                     BUG27346
     C                   EXSR      SRGetCurrD                                               BUG27346
 
      ** Load balances and dates from GLACNTQD to work arrays
 
     C                   EVAL      RunDate         = AvailDatesArr
     C**********         EVAL      BaseAvailBal    = BaseBalanceArr                        BUG27719A
     C                   EVAL      AvailBalance    = AvailBalArr
     C/COPY WNCPYSRC,REH00104
 
      ** Load Held Items to work arrays
 
     C                   EXSR      SrLoadHeld2
 
      ** Load overdraft lines to work arrays
      ** (If Overdraft Interest Calculations switchable feature is ON,
      ** use overdraft line based on value date
      ** else, use overdraft line from account table)
 
     C                   IF        CRE001 = 'Y'
 
     C     KHeldI        SETLL     REODHSL0
     C     KHeldI        READE     REODHSL0
 
     C                   DOW       NOT %EOF(REODHSL0)
 
     C                   FOR       i = 1 TO WNdyf
     C                   IF        RunDate(i) >= HISD
     C**********                      AND RunDate(i) <= ODED                                AR966775
     C                                AND RunDate(i) < ODED                                 AR966775
     C                                AND WKOvrdPtype = '2'                                AR1039174
     C                             OR ODED > BJRDNB                                        AR1039174
     C                             AND WKOvrdPtype = '3'                                   AR1039174
     C                             OR ODED >= BJRDNB                                       AR1039174
     C                             AND WKOvrdPtype = '4'                                   AR1039174
 
     C**********         EVAL      OvrdraftLine(i) = ODLN                                   BUG27346
     C                   EVAL      OvrdraftLine(i) = ODLN * (10**A6NBDP)                    BUG27346
     C
     C                   ENDIF
     C                   ENDFOR
     C     KHeldI        READE     REODHSL0
     C                   ENDDO
     C                   ELSE
 
     C                   FOR       i = 1 TO WNdyf
     C**********         IF        RunDate(i) <= AAODED                                     AR966775
     C                   IF        RunDate(i) < AAODED                                      AR966775
     C                             AND WKOvrdPtype = '2'                                   AR1039174
     C                             OR AAODED > BJRDNB                                      AR1039174
     C                             AND WKOvrdPtype = '3'                                   AR1039174
     C                             OR AAODED >= BJRDNB                                     AR1039174
     C                             AND WKOvrdPtype = '4'                                   AR1039174
     C**********         EVAL      OvrdraftLine(i) = AAODLN                                 BUG27346
     C                   EVAL      OvrdraftLine(i) = AAODLN * (10**A6NBDP)                  BUG27346
     C                   ENDIF
     C                   ENDFOR
     C                   ENDIF
 
      ** Load blocked collaterals in work arrays
 
     C     KHeldI        SETLL     GLCOLLLG
     C     KHeldI        READE     GLCOLLLG
 
     C                   DOW       NOT %EOF(GLCOLLLG)
     C                   IF        CDCOPT = 'A'
     C                                AND CDBCOL = 'Y'
     C                                AND GLCOLLPD_AFT <> GLCOLLPD_CUR
     C                   FOR       i = 1 TO WNdyf
 
     C                   IF        RunDate(i) >= CDVDAT
     C                                AND RunDate(i) <= CDEDAT
 
     C                   EVAL      KBranch  = CDCBRC
     C                   EVAL      KCollRef = CDCREF
 
     C     KBrchRef      CHAIN     GLCOLLQ0
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'GLCOLLQD'
     C                   EVAL      DBKey  = KBranch + KCollRef
     C                   EVAL      DBase  = 18
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      BlockedColl(i) = BlockedColl(i) + QCDXCBC
     C                   EVAL      BlockCollPrev(i) = BlockCollPrev(i) + QCDXCBC
     C
     C                   ENDIF
     C                   ENDFOR
     C                   ENDIF
     C     KHeldI        READE     GLCOLLLG
     C                   ENDDO
 
     C                   ENDIF
     C**********         ENDIF                                                              AR958145
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRecompute - Routine to adjust the balances by the overdraft *
      *               lines if necessary                              *
      *                                                               *
      * Called by: SrGLCOLTrans                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrRecompute   BEGSR
 
     C                   FOR       i = 1 TO WNdyf
 
      ** If there's no current blocked collateral and there is previous blocked collateral
      ** and there's no hard held items,
      ** Include overdraft line in balances calculation
 
 
     C                   IF        BlockedColl(i) = *Zero
     C                                AND BlockCollPrev(i) <> *Zero
     C                                AND HardHeld(i) = *Zero
     C                                AND OvrdraftLine(i) <> *Zero
 
     C**********         EVAL      BaseAvailBal(i) = BaseAvailBal(i) -                     BUG27719A
     C**********                                     OvrdraftLine(i)                       BUG27719A
 
     C                   EVAL      AvailBalance(i) = AvailBalance(i) -
     C                                               OvrdraftLine(i)
     C/COPY WNCPYSRC,REH00105
 
     C                   ENDIF
 
      ** If there is current blocked collateral and there is no previous blocked collateral,
      ** and there's no hard held items,
      ** put back the overdraft line by debiting the balances
 
     C                   IF        BlockedColl(i) <> *Zero
     C                                AND BlockCollPrev(i) = *Zero
     C                                AND HardHeld(i) = *Zero
     C                                AND OvrdraftLine(i) <> *Zero
 
     C**********         EVAL      BaseAvailBal(i) = BaseAvailBal(i) +                     BUG27719A
     C**********                                     OvrdraftLine(i)                       BUG27719A
 
     C                   EVAL      AvailBalance(i) = AvailBalance(i) +
     C                                               OvrdraftLine(i)
     C/COPY WNCPYSRC,REH00106
 
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoadCurr - Routine to adjust the balances by the current    *
      *               blocked collateral amount                       *
      *                                                               *
      * Called by: SrGLCOLTrans                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrLoadCurr    BEGSR
 
     C                   FOR       i = 1 TO WNdyf
 
     C                   IF        Rundate(i) >= AFT_CDVDAT
     C                                AND Rundate(i) <= AFT_CDEDAT
 
     C                   EVAL      KBranch  = AFT_CDCBRC
     C                   EVAL      KCollRef = AFT_CDCREF
 
     C     KBrchRef      CHAIN     GLCOLLQ0
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'GLCOLLQD'
     C                   EVAL      DBKey  = KBranch + KCollRef
     C                   EVAL      DBase  = 19
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C**********         EVAL      BaseAvailBal(i) = BaseAvailBal(i) + QCDXCBC             BUG27719A
     C                   EVAL      AvailBalance(i) = AvailBalance(i) + QCDXCBC
     C                   EVAL      BlockedColl(i)  = BlockedColl(i) + QCDXCBC
     C/COPY WNCPYSRC,REH00107
     C
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoadPrev - Routine to adjust the balances by the previous   *
      *               blocked collateral amount                       *
      *                                                               *
      * Called by: SrGLCOLTrans                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrLoadPrev    BEGSR
 
     C                   FOR       i = 1 TO WNdyf
 
     C                   IF        Rundate(i) >= BEF_CDVDAT
     C                                AND Rundate(i) <= BEF_CDEDAT
 
     C                   EVAL      KBranch  = BEF_CDCBRC
     C                   EVAL      KCollRef = BEF_CDCREF
 
     C     KBrchRef      CHAIN     GLCOLLQ0
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'GLCOLLQD'
     C                   EVAL      DBKey  = KBranch + KCollRef
     C                   EVAL      DBase  = 20
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        WTrigEvent = '3'
     C                                AND BEF_CDRECI = 'D'
     C                                AND AFT_CDRECI = 'R'
 
     C**********         EVAL      BaseAvailBal(i) = BaseAvailBal(i) - QCDXCBC             BUG27719A
     C                   EVAL      AvailBalance(i) = AvailBalance(i) - QCDXCBC
     C                   EVAL      BlockCollPrev(i) = BlockCollPrev(i) - QCDXCBC
     C/COPY WNCPYSRC,REH00108
 
     C                   ELSE
 
     C**********         EVAL      BaseAvailBal(i) = BaseAvailBal(i) - QCDXPBC             BUG27719A
     C                   EVAL      AvailBalance(i) = AvailBalance(i) - QCDXPBC
     C                   EVAL      BlockCollPrev(i) = BlockCollPrev(i) - QCDXPBC
     C/COPY WNCPYSRC,REH00109
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAccUpdate- Update GLACNTQD fields from base available and   *
      *              available balances arrays                        *
      *                                                               *
      *  Called by: SrGLCOLTrans                                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrAccUpdate   BEGSR
 
     C**********         EVAL      BaseBalanceArr = BaseAvailBal                           BUG27719A
     C                   EVAL      AvailBalArr    = AvailBalance
 
     C                   UPDATE    GLACNTD0
 
     C                   EVAL      WUPDATE = 'Y'
     C/COPY WNCPYSRC,REH00110
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrReset  - Initialise variables                               *
      *                                                               *
      * Called by: SrRSACTrans                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrReset       BEGSR
 
     C                   CLEAR                   Rundate
     C                   CLEAR                   AvailBalance
     C                   CLEAR                   AcctBalance                               BUG27719A
     C/COPY WNCPYSRC,REH00111
     C                   CLEAR                   RSAC
 
     C                   EVAL      WProcType = *ZEROS
     C                   EVAL      WUpdate   = *BLANKS
     C                   EVAL      WDorc     = *ZEROS
 
      ** Event type is Held Items Transactions.
 
     C                   IF        WEventType = 'MNT_HELDIHB'
     C                   CLEAR                   CurSoftHeld
     C                   CLEAR                   PrvSoftHeld
     C                   CLEAR                   CurHardHeld
     C                   CLEAR                   PrvHardHeld
     C**********         CLEAR                   BaseAvailBal                              BUG27719A
     C                   CLEAR                   BlockedColl
     C                   CLEAR                   AvailBalance
     C/COPY WNCPYSRC,REH00112
     C                   CLEAR                   OvrdraftLine
     C                   CLEAR                   Rundate
     C                   ENDIF
 
      ** Event type is Account Maintenance
 
     C                   IF        WEventType = 'MNT_ACCNTAB'
     C                   CLEAR                   SoftHeld
     C                   CLEAR                   HardHeld
     C**********         CLEAR                   BaseAvailBal                              BUG27719A
     C                   CLEAR                   BlockedColl
     C                   CLEAR                   AvailBalance
     C/COPY WNCPYSRC,REH00113
     C                   CLEAR                   Rundate
     C                   ENDIF
 
      ** Initialize Arrays
 
     C                   IF        WEventType = 'MNT_GLCOLLPD'
     C                   CLEAR                   SoftHeld
     C                   CLEAR                   CurHardHeld
     C**********         CLEAR                   BaseAvailBal                              BUG27719A
     C                   CLEAR                   AvailBalance
     C                   CLEAR                   OvrdraftLine
     C                   CLEAR                   RunDate
     C                   CLEAR                   BlockedColl
     C                   CLEAR                   BlockCollPrev
     C/COPY WNCPYSRC,REH00114
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoadFields - Load GLACNTQD Dates and Balances fields        *
      *                into work arrays.                              *
      *                                                               *
      * Called by: SrRSACTrans                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrLoadFields  BEGSR
      *                                                                                     BUG27346
     C                   EXSR      SRGetCurrD                                               BUG27346
 
      ** Load Dates 1 to 10 into Rundates array
 
     C                   EVAL      Rundate(1)  = F1DAT0
     C                   EVAL      Rundate(2)  = F1DAT1
     C                   EVAL      Rundate(3)  = F1DAT2
     C                   EVAL      Rundate(4)  = F1DAT3
     C                   EVAL      Rundate(5)  = F1DAT4
     C                   EVAL      Rundate(6)  = F1DAT5
     C                   EVAL      Rundate(7)  = F1DAT6
     C                   EVAL      Rundate(8)  = F1DAT7
     C                   EVAL      Rundate(9)  = F1DAT8
     C                   EVAL      Rundate(10) = F1DAT9
 
      ** Load Available Balances 1 to 10 into AvailBalance array
 
     C                   Eval      AvailBalance(1)  = F1AVA0
     C                   Eval      AvailBalance(2)  = F1AVA1
     C                   Eval      AvailBalance(3)  = F1AVA2
     C                   Eval      AvailBalance(4)  = F1AVA3
     C                   Eval      AvailBalance(5)  = F1AVA4
     C                   Eval      AvailBalance(6)  = F1AVA5
     C                   Eval      AvailBalance(7)  = F1AVA6
     C                   Eval      AvailBalance(8)  = F1AVA7
     C                   Eval      AvailBalance(9)  = F1AVA8
     C                   Eval      AvailBalance(10) = F1AVA9
     C/COPY WNCPYSRC,REH00115
 
      ** Load Account Balances 1 to 10 into AccountBalance array                           BUG27719A
                                                                                           BUG27719A
     C                   Eval      AcctBalance(1) = F1BAV0                                 BUG27719A
     C                   Eval      AcctBalance(2) = F1BAV1                                 BUG27719A
     C                   Eval      AcctBalance(3) = F1BAV2                                 BUG27719A
     C                   Eval      AcctBalance(4) = F1BAV3                                 BUG27719A
     C                   Eval      AcctBalance(5) = F1BAV4                                 BUG27719A
     C                   Eval      AcctBalance(6) = F1BAV5                                 BUG27719A
     C                   Eval      AcctBalance(7) = F1BAV6                                 BUG27719A
     C                   Eval      AcctBalance(8) = F1BAV7                                 BUG27719A
     C                   Eval      AcctBalance(9) = F1BAV8                                 BUG27719A
     C                   Eval      AcctBalance(10) = F1BAV9                                BUG27719A
     C/COPY WNCPYSRC,REH00116
                                                                                           BUG27719A
      ** When Event Type is Held Transaction
 
     C                   IF        WEventType = 'MNT_HELDIHB'
 
      ***Load*Base*Available*Balances*1*to*10*into*BaseAvailBal*array**                    BUG27719A
      *****************************************************************                    BUG27719A
     C**********         Eval      BaseAvailBal(1)  = F1BAV0                               BUG27719A
     C**********         Eval      BaseAvailBal(2)  = F1BAV1                               BUG27719A
     C**********         Eval      BaseAvailBal(3)  = F1BAV2                               BUG27719A
     C**********         Eval      BaseAvailBal(4)  = F1BAV3                               BUG27719A
     C**********         Eval      BaseAvailBal(5)  = F1BAV4                               BUG27719A
     C**********         Eval      BaseAvailBal(6)  = F1BAV5                               BUG27719A
     C**********         Eval      BaseAvailBal(7)  = F1BAV6                               BUG27719A
     C**********         Eval      BaseAvailBal(8)  = F1BAV7                               BUG27719A
     C**********         Eval      BaseAvailBal(9)  = F1BAV8                               BUG27719A
     C**********         Eval      BaseAvailBal(10) = F1BAV9                               BUG27719A
 
      ** Load Current/Previous Hard and Soft Held Items
 
     C                   EXSR      SrLoadHeld
 
      ** Load Overdraft Line to array
 
     C                   EXSR      SrLoadOvDrft
 
      ** Load Blocked Collateral Amount
 
     C                   EXSR      SrLoadBlColl
 
     C                   ENDIF
 
      ** When Event Type is Account Transaction
 
     C                   IF        WEventType = 'MNT_ACCNTAB'
 
      ***Load*Base*Available*Balances*1*to*10*into*BaseAvailBal*array**                    BUG27719A
      *****************************************************************                    BUG27719A
     C**********         Eval      BaseAvailBal(1)  = F1BAV0                               BUG27719A
     C**********         Eval      BaseAvailBal(2)  = F1BAV1                               BUG27719A
     C**********         Eval      BaseAvailBal(3)  = F1BAV2                               BUG27719A
     C**********         Eval      BaseAvailBal(4)  = F1BAV3                               BUG27719A
     C**********         Eval      BaseAvailBal(5)  = F1BAV4                               BUG27719A
     C**********         Eval      BaseAvailBal(6)  = F1BAV5                               BUG27719A
     C**********         Eval      BaseAvailBal(7)  = F1BAV6                               BUG27719A
     C**********         Eval      BaseAvailBal(8)  = F1BAV7                               BUG27719A
     C**********         Eval      BaseAvailBal(9)  = F1BAV8                               BUG27719A
     C**********         Eval      BaseAvailBal(10) = F1BAV9                               BUG27719A
 
      ** Load Hard and Soft Held Items
 
     C                   EXSR      SrLoadHeld2
 
      ** Load Blocked Collateral Amount
 
     C                   EXSR      SrLoadBlColl
 
      ** Load back previous values by debiting overdraft
      ** line amount
 
     C                   EXSR      SrLoadPrvVal
 
      ** Amend current value by crediting overdraft line
      ** amount
 
     C                   EXSR      SrAmndCurVal
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGetProcType - Get Processing Type from SDABCIPD depending   *
      *                 on Module and Movement Type.                  *
      *                                                               *
      * Called by: SrRSACTrans                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrGetProcType BEGSR
 
     C                   SELECT
 
      ** Funds Transfer
 
     C                   WHEN      CMOD = 'FT'
 
      ** Debit Movement
 
     C                   IF        WDorc = 0
     C                   EVAL      WProcType = ABFTDR
     C                   ELSE
 
      ** Credit Movement
 
     C                   EVAL      WProcType = ABFTCR
     C                   ENDIF
 
      ** Securities
 
     C                   WHEN      CMOD = 'SE'
 
      ** Debit Movement
 
     C                   IF        WDorc = 0
     C                   EVAL      WProcType = ABSEDR
     C                   ELSE
 
      ** Credit Movement
 
     C                   EVAL      WProcType = ABSECR
     C                   ENDIF
 
      ** Journal Entry
 
     C                   WHEN      CMOD = 'GL' AND TRYP = 'ME'
 
      ** Debit Movement
 
     C                   IF        WDorc = 0
     C                   EVAL      WProcType = ABJEDR
     C                   ELSE
 
      ** Credit Movement
 
     C                   EVAL      WProcType = ABJECR
     C                   ENDIF
 
      ** Account Transfer (Same/Forward)
 
     C                   WHEN      CMOD  = 'GL' AND TRYP = 'ZT'
 
      ** Debit Movement
 
     C                   IF        WDorc = 0
 
     C                   IF        MTYP  = 'S'
     C                   EVAL      WProcType = ABTSDR
     C                   ELSE
     C                   IF        MTYP  = 'F'
     C                   EVAL      WProcType = ABTFDR
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
      ** Credit Movement
 
     C                   IF        MTYP  = 'S'
     C                   EVAL      WProcType = ABTSCR
     C                   ELSE
     C                   IF        MTYP  = 'F'
     C                   EVAL      WProcType = ABTFCR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Transaction Module
 
     C                   OTHER
 
      ** Debit Movement
 
     C                   IF        WDorc = 0
 
     C                   IF        MTYP  = 'S'
     C                   EVAL      WProcType = ABTVDR
     C                   ELSE
     C                   IF        MTYP  = 'F'
     C                   EVAL      WProcType = ABAFDR
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
      ** Credit Movement
 
     C                   IF        MTYP  = 'S'
     C                   EVAL      WProcType = ABTVCR
     C                   ELSE
     C                   IF        MTYP  = 'F'
     C                   EVAL      WProcType = ABAFCR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcAvailBal - Add/Subtract Movement Amount to Available    *
      *                  Balances.                                    *
      *                                                               *
      * Called by: SrRSACTrans                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrProcAvailBalBEGSR
 
     C                   EVAL      Ix = *ZEROS
 
     C                   SELECT
 
      ** Process Type 1: The movement is included from today and all subsequent balances.
 
     C                   WHEN      WProcType = 1
 
     C                   FOR       Ix = 1 to Wndyf
 
      ** If amount is Debit (Add), if Credit (Subtract)
      ** Movement Ammount to Available Balances and Account Balances                       BUG27719A
 
     C                   IF        DORC = 0
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) + MVAM
     C                   EVAL      AcctBalance(Ix) = AcctBalance(Ix) + MVAM                BUG27719A
     C/COPY WNCPYSRC,REH00117
     C                   ELSE
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) - MVAM
     C                   EVAL      AcctBalance(Ix) = AcctBalance(Ix) - MVAM                BUG27719A
     C/COPY WNCPYSRC,REH00118
     C                   ENDIF
 
     C                   ENDFOR
 
      ** Process Type 2: The movement is included from the movement value date and
      ** all subsequent balances.
      ** Or if Value Date is not an availability date (i.e. movements with a               AR1095876
      ** value date that is a holiday in system currency), update the                      AR1095876
      ** balance of the preceding availability date. This processing is                    AR1095876
      ** 'in advance'                                                                      AR1095876
 
     C                   WHEN      WProcType = 2
 
     C                   IF        VUDT <= Rundate(Wndyf)
     C                             OR VUDT < F1OAD                                         AR1095876
 
     C                   FOR       Ix = 1 to Wndyf
                                                                                           AR1095876
     C                   IF        Ix = Wndyf                                              AR1095876
     C                   EVAL      WNWD = Ix                                               AR1095876
     C                   ELSEIF    Ix < Wndyf                                              AR1095876
     C                   EVAL      WNWD = Ix + 1                                           AR1095876
     C                   ENDIF                                                             AR1095876
 
     C                   IF        VUDT <= Rundate(Ix)
     C                             OR VUDT > Rundate(Ix)                                   AR1095876
     C                             AND VUDT < Rundate(WNWD)                                AR1095876
     C                             OR VUDT > Rundate(Ix)                                   AR1095876
     C                             AND VUDT < F1OAD                                        AR1095876
     C                             AND Ix = Wndyf                                          AR1095876
 
      ** If amount is Debit (Add), if Credit (Subtract)
      ** Movement Ammount to Available Balances and Account Balances                       BUG27719A
 
     C                   IF        DORC = 0
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) + MVAM
     C                   EVAL      AcctBalance(Ix) = AcctBalance(Ix) + MVAM                BUG27719A
     C/COPY WNCPYSRC,REH00119
     C                   ELSE
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) - MVAM
     C                   EVAL      AcctBalance(Ix) = AcctBalance(Ix) - MVAM                BUG27719A
     C/COPY WNCPYSRC,REH00120
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   ENDIF
 
      ** Process Type 3: The movement is included from today and all subsequent
      ** balances if and only if the movement execution / posting date is today or earlier.
      ** Else it is not included.
 
     C                   WHEN      WProcType = 3
 
     C**********         IF        PTDT <= BJRDNB                                          AR1039172
     C                   IF        VUDT <= BJRDNB                                          AR1039172
 
     C                   FOR       Ix = 1 to Wndyf
     C                   IF        VUDT <= Rundate(Ix)
 
 
      ** If amount is Debit (Add), if Credit (Subtract)
      ** Movement Ammount to Available Balances and Account Balances                       BUG27719A
 
     C                   IF        DORC = 0
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) + MVAM
     C                   EVAL      AcctBalance(Ix) = AcctBalance(Ix) + MVAM                BUG27719A
     C/COPY WNCPYSRC,REH00121
     C                   ELSE
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) - MVAM
     C                   EVAL      AcctBalance(Ix) = AcctBalance(Ix) - MVAM                BUG27719A
     C/COPY WNCPYSRC,REH00122
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDFOR
 
 
     C                   ENDIF
 
      ** Process Type 4: The movement is never included.
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoadPrvVal - Load previous value by debiting overdraft line *
      *                amount                                         *
      *                                                               *
      * Called by: SrLoadFields                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrLoadPrvVal  BEGSR
 
     C                   FOR       Ix = 1 to Wndyf
 
     C                   IF        HardHeld(Ix) = 0 AND BlockedColl(Ix) = 0
 
     C                   IF        CRE001 = 'N'
 
     C**********         IF        RunDate(Ix) <= CODED                                     AR966775
     C                   IF        RunDate(Ix) < CODED                                      AR966775
     C                             AND WKOvrdPtype = '2'                                   AR1039174
     C                             OR CODED > BJRDNB                                       AR1039174
     C                             AND WKOvrdPtype = '3'                                   AR1039174
     C                             OR CODED >= BJRDNB                                      AR1039174
     C                             AND WKOvrdPtype = '4'                                   AR1039174
     C**********         EVAL      BaseAvailBal(Ix) = BaseAvailBal(Ix) + CODLN              BUG27346
     C**********         EVAL      AvailBalance(Ix) = AvailBalance(Ix) + CODLN              BUG27346
     C**********         EVAL      BaseAvailBal(Ix) = BaseAvailBal(Ix) +          BUG27346 BUG27719A
     C**********                   (CODLN * (10**A6NBDP))                         BUG27346 BUG27719A
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) +                    BUG27346
     C                             (CODLN * (10**A6NBDP))                                   BUG27346
     C/COPY WNCPYSRC,REH00123
     C                   ENDIF
 
     C                   ELSE
 
     C     KHeldI        SETGT     REODHSL0
     C     KHeldI        READPE    REODHSL0
     C                   IF        %FOUND(REODHSL0)
 
     C                   IF        CODED <> DODED
     C                   EVAL      WExpiry = CODED
     C                   ELSE
     C                   EVAL      WExpiry = ODED
     C                   ENDIF
 
     C                   IF        RunDate(Ix) >= HISD AND
     C**********                   RunDate(Ix) <= WExpiry                                   AR966775
     C                             RunDate(Ix) < WExpiry                                    AR966775
     C                             AND WKOvrdPtype = '2'                                   AR1039174
     C                             OR WExpiry > BJRDNB                                     AR1039174
     C                             AND WKOvrdPtype = '3'                                   AR1039174
     C                             OR WExpiry >= BJRDNB                                    AR1039174
     C                             AND WKOvrdPtype = '4'                                   AR1039174
     C**********         EVAL      BaseAvailBal(Ix) = BaseAvailBal(Ix) + CODLN              BUG27346
     C**********         EVAL      AvailBalance(Ix) = AvailBalance(Ix) + CODLN              BUG27346
     C**********         EVAL      BaseAvailBal(Ix) = BaseAvailBal(Ix) +          BUG27346 BUG27719A
     C**********                   (CODLN * (10**A6NBDP))                         BUG27346 BUG27719A
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) +                    BUG27346
     C                             (CODLN * (10**A6NBDP))                                   BUG27346
     C/COPY WNCPYSRC,REH00124
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAmndCurVal - Amend current value by crediting overdraft     *
      *                line amount                                    *
      *                                                               *
      * Called by: SrLoadFields                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrAmndCurVal  BEGSR
 
     C                   FOR       Ix = 1 to Wndyf
 
     C                   IF        HardHeld(Ix) = 0 AND BlockedColl(Ix) = 0
 
     C                   IF        CRE001 = 'N'
 
     C**********         IF        RunDate(Ix) <= DODED                                     AR966775
     C                   IF        RunDate(Ix) < DODED                                      AR966775
     C                             AND WKOvrdPtype = '2'                                   AR1039174
     C                             OR DODED > BJRDNB                                       AR1039174
     C                             AND WKOvrdPtype = '3'                                   AR1039174
     C                             OR DODED >= BJRDNB                                      AR1039174
     C                             AND WKOvrdPtype = '4'                                   AR1039174
     C**********         EVAL      BaseAvailBal(Ix) = BaseAvailBal(Ix) - DODLN              BUG27346
     C**********         EVAL      AvailBalance(Ix) = AvailBalance(Ix) - DODLN              BUG27346
     C**********         EVAL      BaseAvailBal(Ix) = BaseAvailBal(Ix) -          BUG27346 BUG27719A
     C**********                   (DODLN * (10**A6NBDP))                         BUG27346 BUG27719A
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) -                    BUG27346
     C                             (DODLN * (10**A6NBDP))                                   BUG27346
     C/COPY WNCPYSRC,REH00125
     C                   ENDIF
 
     C                   ELSE
 
     C     KHeldI        SETGT     REODHSL0
     C     KHeldI        READPE    REODHSL0
     C                   IF        %FOUND(REODHSL0)
 
     C**********         IF        RunDate(Ix) >= HISD AND RunDate(Ix) <= ODED              AR966775
     C                   IF        RunDate(Ix) >= HISD AND RunDate(Ix) < ODED               AR966775
     C                             AND WKOvrdPtype = '2'                                   AR1039174
     C                             OR ODED > BJRDNB                                        AR1039174
     C                             AND WKOvrdPtype = '3'                                   AR1039174
     C                             OR ODED >= BJRDNB                                       AR1039174
     C                             AND WKOvrdPtype = '4'                                   AR1039174
     C**********         EVAL      BaseAvailBal(Ix) = BaseAvailBal(Ix) - DODLN              BUG27346
     C**********         EVAL      AvailBalance(Ix) = AvailBalance(Ix) - DODLN              BUG27346
     C**********         EVAL      BaseAvailBal(Ix) = BaseAvailBal(Ix) -          BUG27346 BUG27719A
     C**********                   (DODLN * (10**A6NBDP))                         BUG27346 BUG27719A
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) -                    BUG27346
     C                             (DODLN * (10**A6NBDP))                                   BUG27346
     C/COPY WNCPYSRC,REH00126
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUpdate - Update Available Balances in GLACNTQD              *
      *                                                               *
      * Called by: SrRSACTrans                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrUpdate      BEGSR
 
     C                   EVAL      F1AVA0 = AvailBalance(1)
     C                   EVAL      F1AVA1 = AvailBalance(2)
     C                   EVAL      F1AVA2 = AvailBalance(3)
     C                   EVAL      F1AVA3 = AvailBalance(4)
     C                   EVAL      F1AVA4 = AvailBalance(5)
     C                   EVAL      F1AVA5 = AvailBalance(6)
     C                   EVAL      F1AVA6 = AvailBalance(7)
     C                   EVAL      F1AVA7 = AvailBalance(8)
     C                   EVAL      F1AVA8 = AvailBalance(9)
     C                   EVAL      F1AVA9 = AvailBalance(10)
 
     C                   EVAL      F1BAV0 = AcctBalance(1)                                 BUG27719A
     C                   EVAL      F1BAV1 = AcctBalance(2)                                 BUG27719A
     C                   EVAL      F1BAV2 = AcctBalance(3)                                 BUG27719A
     C                   EVAL      F1BAV3 = AcctBalance(4)                                 BUG27719A
     C                   EVAL      F1BAV4 = AcctBalance(5)                                 BUG27719A
     C                   EVAL      F1BAV5 = AcctBalance(6)                                 BUG27719A
     C                   EVAL      F1BAV6 = AcctBalance(7)                                 BUG27719A
     C                   EVAL      F1BAV7 = AcctBalance(8)                                 BUG27719A
     C                   EVAL      F1BAV8 = AcctBalance(9)                                 BUG27719A
     C                   EVAL      F1BAV9 = AcctBalance(10)                                BUG27719A
                                                                                           BUG27719A
      ***Held*Items*transaction****************************************                    BUG27719A
      ***or*Account*Maintenance*amendments*****************************                    BUG27719A
      *****************************************************************                    BUG27719A
     C**********         IF        WEventType = 'MNT_HELDIHB'                              BUG27719A
     C**********                   OR WEventType = 'MNT_ACCNTAB'                           BUG27719A
     C**********         EVAL      F1BAV0 = BaseAvailBal(1)                                BUG27719A
     C**********         EVAL      F1BAV1 = BaseAvailBal(2)                                BUG27719A
     C**********         EVAL      F1BAV2 = BaseAvailBal(3)                                BUG27719A
     C**********         EVAL      F1BAV3 = BaseAvailBal(4)                                BUG27719A
     C**********         EVAL      F1BAV4 = BaseAvailBal(5)                                BUG27719A
     C**********         EVAL      F1BAV5 = BaseAvailBal(6)                                BUG27719A
     C**********         EVAL      F1BAV6 = BaseAvailBal(7)                                BUG27719A
     C**********         EVAL      F1BAV7 = BaseAvailBal(8)                                BUG27719A
     C**********         EVAL      F1BAV8 = BaseAvailBal(9)                                BUG27719A
     C**********         EVAL      F1BAV9 = BaseAvailBal(10)                               BUG27719A
      **********                                                                           BUG27719A
     C**********         ENDIF                                                             BUG27719A
 
     C                   UPDATE    GLACNTD0                             99
     C/COPY WNCPYSRC,REH00127
     C  N99              EVAL      WUpdate = 'Y'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCancReserv - Cancel reservation in T_MLRSVTRN              *
      *                                                               *
      *  Called by: Main routine                                      *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRCancReserv  BEGSR
 
     C                   EVAL      CommitId = WDetail
 
      ** Call reservation cancellation program
 
     C                   CALL      'GP001501'
     C                   PARM                    CommitId
     C                   PARM      *BLANKS       Returncode
 
     C                   IF        Returncode = '*ERROR'
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'GP001501'
     C                   EVAL      DBFILE = 'GPWTRAPPD'
     C                   EVAL      DBKEY = CommitId
     C                   EVAL      DBTXT = *BLANKS
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WUpdate = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoadHeld - Load Current/Previous Hard and Soft Held Items   *
      *                                                               *
      * Called by: SrLoadFields                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrLoadHeld    BEGSR
 
     C     KHeldI        SETLL     HELDIL1
     C     KHeldI        READE     HELDIL1
     C                   DOW       NOT %EOF( HELDIL1 )
 
     C                   IF        HRECI = 'D'
 
     C                   FOR       Ix = 1 to Wndyf
 
     C                   IF        AcctAfterImg <> CurHELDIHB
 
     C**********         IF        Rundate(Ix) <= HHEXP                                     AR966775
     C                   IF        Rundate(Ix) < HHEXP                                      AR966775
     C                             AND WKHeldPtype = '2'                                   AR1039177
     C                             OR HHEXP > BJRDNB                                       AR1039177
     C                             AND WKHeldPtype = '3'                                   AR1039177
     C                             OR HHEXP >= BJRDNB                                      AR1039177
     C                             AND WKHeldPtype = '4'                                   AR1039177
 
     C                   IF        HHHIT = 'Y'
     C                   EVAL      CurHardHeld(Ix) = CurHardHeld(Ix) + HHLDA
     C                   EVAL      PrvHardHeld(Ix) = PrvHardHeld(Ix) + HHLDA
     C                   ELSE
     C                   EVAL      CurSoftHeld(Ix) = CurSoftHeld(Ix) + HHLDA
     C                   EVAL      PrvSoftHeld(Ix) = PrvSoftHeld(Ix) + HHLDA
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   ENDIF
 
     C     KHeldI        READE     HELDIL1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoadHeld2 - Load Hard and Soft Held Items                   *
      *                                                               *
      * Called by: SrLoadFields                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrLoadHeld2   BEGSR
 
     C     KHeldI        SETLL     HELDIL1
     C     KHeldI        READE     HELDIL1
     C                   DOW       NOT %EOF( HELDIL1 )
 
     C                   IF        HRECI = 'D'
 
     C                   FOR       Ix = 1 to Wndyf
 
     C**********         IF        Rundate(Ix) <= HHEXP                                     AR966775
     C                   IF        Rundate(Ix) < HHEXP                                      AR966775
     C                             AND WKHeldPtype = '2'                                   AR1039177
     C                             OR HHEXP > BJRDNB                                       AR1039177
     C                             AND WKHeldPtype = '3'                                   AR1039177
     C                             OR HHEXP >= BJRDNB                                      AR1039177
     C                             AND WKHeldPtype = '4'                                   AR1039177
 
     C                   IF        HHHIT = 'Y'
     C                   EVAL      HardHeld(Ix) = HardHeld(Ix) + HHLDA
     C                   ELSE
     C                   EVAL      SoftHeld(Ix) = SoftHeld(Ix) + HHLDA
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   ENDIF
 
     C     KHeldI        READE     HELDIL1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoadOvDrft - Load OverDraft Line                            *
      *                                                               *
      * Called by: SrLoadFields                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrLoadOvDrft  BEGSR
 
     C                   IF        CRE001 = 'Y'
 
     C     KHeldI        SETLL     REODHSL0
     C     KHeldI        READE     REODHSL0
     C                   DOW       NOT %EOF( REODHSL0 )
 
     C                   FOR       Ix = 1 to Wndyf
 
     C                   IF        Rundate(Ix) >= HISD AND
     C**********                   Rundate(Ix) <= ODED                                      AR966775
     C                             Rundate(Ix) < ODED                                       AR966775
     C                             AND WKOvrdPtype = '2'                                   AR1039174
     C                             OR ODED > BJRDNB                                        AR1039174
     C                             AND WKOvrdPtype = '3'                                   AR1039174
     C                             OR ODED >= BJRDNB                                       AR1039174
     C                             AND WKOvrdPtype = '4'                                   AR1039174
     C**********         EVAL      OvrdraftLine(Ix) = ODLN                                  BUG27346
     C                   EVAL      OvrdraftLine(Ix) = ODLN * (10**A6NBDP)                   BUG27346
     C                   ENDIF
 
     C                   ENDFOR
 
     C     KHeldI        READE     REODHSL0
     C                   ENDDO
 
      ** CRE001 is NOT installed
 
     C                   ELSE
 
     C                   FOR       Ix = 1 to Wndyf
     C                   IF        Rundate(Ix) < AAODED                                     AR966775
     C                             AND WKOvrdPtype = '2'                                   AR1039174
     C                             OR AAODED > BJRDNB                                      AR1039174
     C                             AND WKOvrdPtype = '3'                                   AR1039174
     C                             OR AAODED >= BJRDNB                                     AR1039174
     C                             AND WKOvrdPtype = '4'                                   AR1039174
     C**********         EVAL      OvrdraftLine(Ix) = AAODLN                                BUG27346
     C                   EVAL      OvrdraftLine(Ix) = AAODLN * (10**A6NBDP)                 BUG27346
     C                   ENDIF                                                              AR966775
     C                   ENDFOR
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoadBlColl - Load Blocked Collateral                        *
      *                                                               *
      * Called by: SrLoadFields                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrLoadBlColl  BEGSR
 
     C     KHeldI        SETLL     GLCOLLLG
     C     KHeldI        READE     GLCOLLLG
     C                   DOW       NOT %EOF( GLCOLLLG )
 
     C                   IF        CDCOPT = 'A' AND CDBCOL = 'Y'
 
     C                   FOR       Ix = 1 to Wndyf
 
     C                   IF        Rundate(Ix) >= CDVDAT AND
     C                             Rundate(Ix) <= CDEDAT
 
     C     KGlcollq      CHAIN     GLCOLLQ0
     C                   IF        NOT %FOUND( GLCOLLQ0 )
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE001501'
     C                   EVAL      DBFILE = 'GLCOLLQD'
     C                   EVAL      DBKEY = CDCBRC + CDCREF
     C                   EVAL      DBASE = 10
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      BlockedColl(Ix) = BlockedColl(Ix) + QCDXCBC
 
     C                   ENDIF
 
     C                   ENDFOR
     C
     C                   ENDIF
 
     C     KHeldI        READE     GLCOLLLG
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************                     BUG27346
      /EJECT                                                                                BUG27346
      *****************************************************************                     BUG27346
      *                                                               *                     BUG27346
      *  SRGetCurrD - Subroutine that Retrieves Currency Details      *                     BUG27346
      *                                                               *                     BUG27346
      *****************************************************************                     BUG27346
     C     SRGetCurrD    BEGSR                                                              BUG27346
                                                                                            BUG27346
     C                   CALL      'AOCURRR0'                                               BUG27346
     C                   PARM      *BLANKS       PRtCd                                      BUG27346
     C                   PARM      '*KEY   '     POptn                                      BUG27346
     C                   PARM                    PCurr                                      BUG27346
     C     SDCURR        PARM      SDCURR        DSSDY                                      BUG27346
                                                                                            BUG27346
     C                   IF        PRtCd <> *BLANKS                                         BUG27346
     C     *LOCK         IN        LDA                                                      BUG27346
     C                   EVAL      DBFILE = 'SDCURRPD'                                      BUG27346
     C                   EVAL      DBKEY = PCurr                                            BUG27346
     C                   EVAL      DBASE = 11                                               BUG27346
     C                   OUT       LDA                                                      BUG27346
     C                   EXSR      *PSSR                                                    BUG27346
     C                   ENDIF                                                              BUG27346
                                                                                            BUG27346
     C                   ENDSR                                                              BUG27346
                                                                                            BUG27346
      *****************************************************************           BUG27831A BUG28007
      ***/EJECT********************************************************           BUG27831A BUG28007
      *****************************************************************           BUG27831A BUG28007
      *****************************************************************           BUG27831A BUG28007
      ***SRUpdATMI*-*Subroutine*that*updates*ABC*Performed*flag*in*****           BUG27831A BUG28007
      ***************GLATMIPD******************************************           BUG27831A BUG28007
      *****************************************************************           BUG27831A BUG28007
      *****************************************************************           BUG27831A BUG28007
     C*****SRUpdATMI     BEGSR                                                    BUG27831A BUG28007
      *****************************************************************           BUG27831A BUG28007
     C**********         IF        CMOD = 'GL' AND TRYP = 'ZT'                    BUG27831A BUG28007
      *****************************************************************           BUG27831A BUG28007
     C**********         MOVEL     OTR1          KyTREF                           BUG27831A BUG28007
     C**********         EVAL      KyEXDT = PTDT                                  BUG27831A BUG28007
     C*****KeyATMI       CHAIN     GLATMIL5                                       BUG27831A BUG28007
     C**********         IF        %FOUND(GLATMIL5)                               BUG27831A BUG28007
     C**********                   AND R1ABCF <> 'Y'                              BUG27831A BUG28007
     C**********         EVAL      R1ABCF = 'Y'                                   BUG27831A BUG28007
     C**********         UPDATE    GLATMID0                                       BUG27831A BUG28007
     C**********         ENDIF                                                    BUG27831A BUG28007
      *****************************************************************           BUG27831A BUG28007
     C**********         ENDIF                                                    BUG27831A BUG28007
      *****************************************************************           BUG27831A BUG28007
     C**********         ENDSR                                                    BUG27831A BUG28007
      *****************************************************************           BUG27831A BUG28007
                                                                                            AR958145
      *****************************************************************                     AR958145
      /EJECT                                                                                AR958145
      *****************************************************************                     AR958145
      *                                                               *                     AR958145
      * SrLoadDates - Load Available Balance Dates                    *                     AR958145
      *                                                               *                     AR958145
      * Called by: SrACCTTrans                                        *                     AR958145
      *                                                               *                     AR958145
      * Calls: None                                                   *                     AR958145
      *                                                               *                     AR958145
      *****************************************************************                     AR958145
                                                                                            AR958145
     C     SrLoadDates   BEGSR                                                              AR958145
                                                                                            AR958145
     C                   EVAL      WKSysNoDays = PCurSet(1)                                 AR958145
     C                   EVAL      NoDays = %INT(%TRIM(WKSysNoDays)) + 1                    AR958145
                                                                                            AR958145
      ** Initialize variables                                                               AR958145
                                                                                            AR958145
     C                   MOVEA     *ZERO         F2DATS                                     AR958145
                                                                                            AR958145
      ** current rundate has already been changed so we will set this                       AR958145
      ** as F1DAT1 and F1DAT0 as today also                                                 AR958145
                                                                                            AR958145
     C                   IF        NoDays >= 1                                              AR958145
     C                   Z-ADD     BJRDNB        F2DAT0                                     AR958145
     C                   EndIf                                                              AR958145
                                                                                            AR958145
     C                   IF        NoDays >= 2                                              AR958145
     C                   Z-ADD     BJRDNB        F2DAT1                                     AR958145
     C                   ENDIF                                                              AR958145
                                                                                            AR958145
      ** get the third day to tenth day                                                     AR958145
                                                                                            AR958145
     C                   IF        NoDays >= 3                                              AR958145
     C                   Z-ADD     3             WCTR                                       AR958145
     C     BJRDNB        ADD       1             WDATEIN                                    AR958145
                                                                                            AR958145
     C                   DOW       WCTR <= NoDays                                           AR958145
                                                                                            AR958145
      ** Location currency                                                                  AR958145
                                                                                            AR958145
     C                   Z-ADD     WDATEIN       ZDAYNO                                     AR958145
     C                   MOVE      BJLCCY        ZCCY                                       AR958145
     C                   MOVE      *BLANKS       ZLOC                                       AR958145
     C                   MOVE      *BLANKS       ZIND                                       AR958145
                                                                                            AR958145
     C                   EXSR      ZCHKH                                                    AR958145
                                                                                            AR958145
     C                   MOVE      ZIND          LOCIND                                     AR958145
                                                                                            AR958145
      ***Account*currency**********************************************           AR958145 AR1095876
                                                                                            AR958145
     C**********         Z-ADD     WDATEIN       ZDAYNO                           AR958145 AR1095876
     C**********         MOVE      AACCY         ZCCY                             AR958145 AR1095876
     C**********         MOVE      *BLANKS       ZLOC                             AR958145 AR1095876
     C**********         MOVE      *BLANKS       ZIND                             AR958145 AR1095876
                                                                                            AR958145
     C**********         EXSR      ZCHKH                                          AR958145 AR1095876
                                                                                            AR958145
     C**********         MOVE      ZIND          ACTIND                           AR958145 AR1095876
                                                                                            AR958145
     C**********         IF        LOCIND = 'W' OR ACTIND = 'W'                   AR958145 AR1095876
     C                   IF        LOCIND = 'W'                                            AR1095876
     C                   EVAL      F2DATS(WCTR) = WDATEIN                                   AR958145
     C                   ADD       1             WCTR                                       AR958145
     C                   ENDIF                                                              AR958145
     C                                                                                      AR958145
     C                   ADD       1             WDATEIN                                    AR958145
                                                                                            AR958145
     C                   ENDDO                                                              AR958145
     C                   ENDIF                                                              AR958145
      *                                                                                    AR1095876
      ** Get the next working day after the last ABC availability date and                 AR1095876
      ** put it in F1OAD field                                                             AR1095876
      *                                                                                    AR1095876
     C                   EVAL      WDATEIN = F2DATS(NoDays) + 1                            AR1095876
     C                   EVAL      LOCIND = *BLANK                                         AR1095876
      *                                                                                    AR1095876
     C                   DOW       LOCIND <> 'W'                                           AR1095876
      *                                                                                    AR1095876
      ** Location currency                                                                 AR1095876
      *                                                                                    AR1095876
     C                   Z-ADD     WDATEIN       ZDAYNO                                    AR1095876
     C                   MOVE      BJLCCY        ZCCY                                      AR1095876
     C                   MOVE      *BLANKS       ZLOC                                      AR1095876
     C                   MOVE      *BLANKS       ZIND                                      AR1095876
      *                                                                                    AR1095876
     C                   EXSR      ZCHKH                                                   AR1095876
      *                                                                                    AR1095876
     C                   MOVE      ZIND          LOCIND                                    AR1095876
     C                   IF        LOCIND = 'W'                                            AR1095876
     C                   EVAL      F1OAD = WDATEIN                                         AR1095876
     C                   ENDIF                                                             AR1095876
     C                   ADD       1             WDATEIN                                   AR1095876
     C                   ENDDO                                                             AR1095876
                                                                                            AR958145
     C                   EVAL      F1DAT0 = F2DAT0                                          AR958145
     C                   EVAL      F1DAT1 = F2DAT1                                          AR958145
     C                   EVAL      F1DAT2 = F2DAT2                                          AR958145
     C                   EVAL      F1DAT3 = F2DAT3                                          AR958145
     C                   EVAL      F1DAT4 = F2DAT4                                          AR958145
     C                   EVAL      F1DAT5 = F2DAT5                                          AR958145
     C                   EVAL      F1DAT6 = F2DAT6                                          AR958145
     C                   EVAL      F1DAT7 = F2DAT7                                          AR958145
     C                   EVAL      F1DAT8 = F2DAT8                                          AR958145
     C                   EVAL      F1DAT9 = F2DAT9                                          AR958145
                                                                                            AR958145
     C                   EVAL      RunDate = AvailDatesArr                                  AR978497
     C                   ENDSR                                                              AR958145
                                                                                            AR958145
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *        AOSARDR0                                               *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    ABCData
 
     C     PAccntab      PLIST
     C                   PARM      '*BLANKS'     PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      *BLANKS       PAcno
     C                   PARM                    PCusn
     C                   PARM                    PCurr
     C                   PARM                    PACod
     C                   PARM                    PASeq
     C                   PARM                    PBrch
     C     GLACNT        PARM      '*BLANKS'     DSSDY
 
     C     KGlacnt       KLIST
     C                   KFLD                    KCusn
     C                   KFLD                    KCurr
     C                   KFLD                    KAcod
     C                   KFLD                    KAseq
     C                   KFLD                    KBrch
 
     C     KHeldI        KLIST
     C                   KFLD                    KBrch
     C                   KFLD                    KCusn
     C                   KFLD                    KCurr
     C                   KFLD                    KAcod
     C                   KFLD                    KAseq
 
     C     KGlcollq      KLIST
     C                   KFLD                    CDCBRC
     C                   KFLD                    CDCREF
 
     C     KBrchRef      KLIST
     C                   KFLD                    KBranch
     C                   KFLD                    KCollRef
      *****************************************************************           BUG27831A BUG28007
     C*****KeyATMI       KLIST                                                    BUG27831A BUG28007
     C**********         KFLD                    KyTREF                           BUG27831A BUG28007
     C**********         KFLD                    KyEXDT                           BUG27831A BUG28007
 
      ** Read in data area
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = 'RE001501'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBTXT  = *BLANKS
     C                   EVAL      DBASE  = 0
     C                   OUT       LDA
 
     C     *DTAARA       DEFINE                  SDSTAT                                     AR958145
     C                   IN        SDSTAT                                                   AR958145
                                                                                            AR958145
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBPGM  =  'AOBANKR0'
     C                   EVAL      DBASE  =  1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   READ      SDABCIPD                               60
 
     C                   EVAL      WNdyf = ABNDYF + 1
 
      ** Check if Switchable Feature CRE001 is installed.
 
     C                   EVAL      CRE001= 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CRE001'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CRE001 = 'Y'
     C                   ENDIF
 
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = PRtcd
     C                   EVAL      DBPGM  = 'AOSARDR0'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                            AR958145
     C                   CLEAR                   PSysVal                                    AR958145
     C                   CLEAR                   PCurSet                                    AR958145
     C                   EVAL      PSysVal(1)  = 'ABCNoDaysForward'                         AR958145
     C                   EVAL      PSysVal(2)  = 'ABCOvrdrftPtype'                         AR1039174
     C                   EVAL      PSysVal(3)  = 'ABCHeldItemPtype'                        AR1039177
                                                                                            AR958145
     C                   CALL      'AOSVALR0'                                               AR958145
     C                   PARM      *BLANKS       PRtcd                                      AR958145
     C                   PARM                    PSysVal(1)                                 AR958145
     C                   PARM                    PCurSet(1)                                 AR958145
     C                   PARM                    PSysVal(2)                                 AR958145
     C                   PARM                    PCurSet(2)                                 AR958145
     C                   PARM                    PSysVal(3)                                 AR958145
     C                   PARM                    PCurSet(3)                                 AR958145
     C                   PARM                    PSysVal(4)                                 AR958145
     C                   PARM                    PCurSet(4)                                 AR958145
     C                   PARM                    PSysVal(5)                                 AR958145
     C                   PARM                    PCurSet(5)                                 AR958145
     C                   PARM                    PSysVal(6)                                 AR958145
     C                   PARM                    PCurSet(6)                                 AR958145
     C                   PARM                    PSysVal(7)                                 AR958145
     C                   PARM                    PCurSet(7)                                 AR958145
     C                   PARM                    PSysVal(8)                                 AR958145
     C                   PARM                    PCurSet(8)                                 AR958145
     C                   PARM                    PSysVal(9)                                 AR958145
     C                   PARM                    PCurSet(9)                                 AR958145
     C                   PARM                    PSysVal(10)                                AR958145
     C                   PARM                    PCurSet(10)                                AR958145
                                                                                            AR958145
     C                   IF        PCurSet(1) = '*NRF' OR                                   AR958145
     C                             PCurSet(2) = '*NRF' OR                                  AR1039174
     C                             PCurSet(3) = '*NRF' OR                                  AR1039177
     C                             PRTCD <> '*NRF' AND                                      AR958145
     C                             PRTCD <> *BLANKS                                         AR958145
     C     *LOCK         IN        LDA                                                      AR958145
     C                   EVAL      DBKEY   = PSysVal(1)                                     AR958145
     C                   EVAL      DBFILE  = 'SDSVALPD'                                     AR958145
     C                   EVAL      DBPGM  = 'AOSVALR0'                                      AR958145
     C                   EVAL      DBASE   = 21                                             AR958145
     C                   OUT       LDA                                                      AR958145
     C                   EXSR      *PSSR                                                    AR958145
     C                   ELSE                                                              AR1039174
     C                   EVAL      WKOvrdPtype = PCurSet(2)                                AR1039174
     C                   EVAL      WKHeldPtype = PCurSet(3)                                AR1039177
     C                   ENDIF                                                              AR958145
 
     C/COPY WNCPYSRC,REH00128
     C                   ENDSR
     C/COPY ZSRSRC,ZCHKHLE                                                                  AR958145
     C/COPY ZSRSRC,ZACCHLE                                                                  AR958145
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   ROLBK
     C                   RETURN
 
     C                   ENDSR
 
