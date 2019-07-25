     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Account Balance Check Online Updater')        *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE001502 - Account Balance Check I/C Update                  *
      *                                                               *
      *  Function:  This program will update available balance in     *
      *             GL Account Master Extension File.                 *
      *                                                               *
      *  Called By: GL007011 - Background update of ABC files         *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Prev Amend No. MD022132D          Date 09Mar18               *
      *                 MD022132 *CREATE   Date 09Mar18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD022132D- Process all retail accounts.                      *
      *           - Applied for MD-35969.                             *
      *  MD022132 - Triggers don't pick up Rollback deletes of ABC    *
      *             files.                                            *
      *           - Applied for MD-35969.                             *
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
      *  SrReset        - Initialise variables                        *
      *  SrLoadFields   - Load GLACNTQD Dates and Balances fields     *
      *                   into work arrays.                           *
      *  SrGetProcType  - Get Processing Type from SDABCIPD depending *
      *                   on Module and Movement Type.                *
      *  SrProcAvailBal - Add/Subtract Movement Amount to Available   *
      *                   Balances.                                   *
      *  SrUpdate       - Update Available Balances in GLACNTQD       *
      *  SRCancReserv   - Cancel reservation in T_MLRSVTRN            *
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

     FSDABCIPD  IF   E           K DISK    INFSR(*PSSR)
      ** Retail Account Balance Check ICD File

     FHELDIL1   IF   E           K DISK    INFSR(*PSSR) PREFIX(H)
     F                                     IGNORE(HELDIHAF:HELDIHCF)
      ** Midas RE Held Items File

     FREODHSL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas RE Overdraft history by account and history date

     FGLCOLLLG  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Live Collateral Details by Account

     FGLCOLLQ0  IF   E           K DISK    INFSR(*PSSR) PREFIX(Q)
      ** Midas GL Collateral Details Extension

      *****************************************************************
      /EJECT
      *****************************************************************

      /COPY UTCPYSRC,UTRJNE0200
      /COPY UTCPYSRC,UTERRC0100
      /COPY UTCPYSRC,UTS00701TP

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External DS for Switchable Features

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External data structures for Currency Details

     D SDSTAT        E DS                  EXTNAME(SDSTAT)
      ** Data Area for Standing Data Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access programs, long data structure

     D HeldItemImg   E DS                  EXTNAME(HELDIHB) PREFIX(A)
      **  External DS for Held Items Detail

     D CurHELDIHB    E DS                  EXTNAME(HELDIHB) PREFIX(H)
      **  External DS for Current Held Items Detail

     D AccountImg    E DS                  EXTNAME(ACCNTAB) PREFIX(D)
      **  External DS for Account Detail

     D GLCOLLPDImg   E DS                  EXTNAME(GLCOLLPD) PREFIX(G)
      ** External DS for GLCOLLPD

     D CurGLCOLLPD   E DS                  EXTNAME(GLCOLLPD)
      ** Current image of GLCOLLPD

     D/COPY ZACPYSRC,PSDS
      ** The Following /COPY Line Includes All The Defined Fields In
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.

      ** +--------------------------------------+
      ** ¦ Arrays AND Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D                 DS
      *** Data structure of workdates
     D  F2DAT0                 1      3P 0
     D  F2DAT1                 4      6P 0
     D  F2DAT2                 7      9P 0
     D  F2DAT3                10     12P 0
     D  F2DAT4                13     15P 0
     D  F2DAT5                16     18P 0
     D  F2DAT6                19     21P 0
     D  F2DAT7                22     24P 0
     D  F2DAT8                25     27P 0
     D  F2DAT9                28     30P 0
     D  F2DATS                 1     30P 0
     D                                     DIM(10) ASCEND
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
     D/COPY ZSRSRC,ZHOLILE
     D/COPY ZSRSRC,ZHOLELE

     D ABCData         DS

      ** Event Type

     D  WEventType             1     20
     D  WTrigEvent            21     21

      ** Event Detail

     D  WDetail               22   4021

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

     D CurSoftHeld     S             13P 0 DIM(10)
     D PrvSoftHeld     S             13P 0 DIM(10)

     D CurHardHeld     S             13P 0 DIM(10)
     D PrvHardHeld     S             13P 0 DIM(10)

     D SoftHeld        S             13P 0 DIM(10)
     D HardHeld        S             13P 0 DIM(10)

     D BlockedColl     S             15P 0 DIM(10)
     D BlockCollPrev   S             15P 0 DIM(10)
     D AvailBalance    S             15P 0 DIM(10)
     D AcctBalance     S             15P 0 DIM(10)
     D OvrdraftLine    S             13P 0 DIM(10)

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

     D WDorc           S              1S 0
     D WProcType       S              1S 0
     D WExpiry         S              5P 0
     D WRun            S              1A
     D WUpdate         S              1A
     D Returncode      S              6A
     D CRE001          S              1A
     D Ix              S              2S 0
     D i               S              3P 0
     D Wndyf           S              5P 0
     D WCTR            S              3  0
     D LOCIND          S              1A
     D ACTIND          S              1A
     D NoDays          S              3S 0
     D WKSysNoDays     S              1A
     D WDATEIN         S              5  0
     D PSysVal         S             20    DIM(10)
     D PCurSet         S            200    DIM(10)
     D WLength         S              4S 0
     D Wloop           S              1A
     D WNWD            S              3  0
     D PCmd            S             13A   Inz('DLYJOB DLY(1)')
     D PCmd_Len        S             15  5

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

     C                   WHEN      WEventType = 'MNT_GLCOLLPD'
     C                   EXSR      SrGLCOLTrans

     C                   ENDSL

      ** Terminate program

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRSACTrans - Process GZRSACMTPD journal record               *
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

      ** Access records from GLACNTQD

     C                   EVAL      KCusn = CUSN
     C                   EVAL      KCurr = CCYD
     C                   EVAL      KAcod = ACDE
     C                   EVAL      KAseq = ASNC
     C                   EVAL      KBrch = BRCA

     C     KGlacnt       CHAIN     GLACNTL4
     C                   IF        NOT %FOUND( GLACNTL4 )
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE001502'
     C                   EVAL      DBFILE = 'GLACNTQD'
     C                   EVAL      DBKEY = KCusn + KCurr + %TRIM(%CHAR(KAcod)) +
     C                                     %TRIM(%CHAR(KAseq)) + KBrch
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Continue processing when Include Account Balance Check flag is Y

     C**********         IF        F1IABC = 'Y'                                            MD022132D
     C                   IF        F1IABC = 'Y' OR                                         MD022132D
     C                             AAATYP = 'R'                                            MD022132D

      ** Load GLACNTQD dates and balances in work array.

     C                   EXSR      SrLoadFields

      ** Get the corresponding Processing Type of RSAC transaction
      ** based on Module and Movement Type.

     C                   EXSR      SrGetProcType

      ** Process Available Balances

     C                   IF        WTrigEvent = '3'
     C                   Z-SUB     MVAM          MVAM
     C                   ENDIF
     C                   EXSR      SrProcAvailBal

      ** Update Available Balance in GLACNTQD

     C                   EXSR      SrUpdate

     C                   ELSE
     C                   UPDATE    GLACNTD0                             99
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

     C                   EVAL      HeldItemImg = WDetail

      ** Retrieve Account Details

     C                   EVAL      PCusn = ACNUM
     C                   EVAL      PCurr = ACCY
     C                   EVAL      PBrch = ABRCA
     C                   MOVE(P)   AACOD         PACod
     C                   MOVE(P)   AACSQ         PASeq

     C                   CALL      'AOACCTR0'    PAccntab
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE001502'
     C                   EVAL      DBFILE = 'ACCNTAB'
     C                   EVAL      DBKEY = PCusn + PCurr + PACod +
     C                                     PASeq + PBrch
     C                   EVAL      DBASE = 7
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      KCusn = ACNUM
     C                   EVAL      KCurr = ACCY
     C                   EVAL      KAcod = AACOD
     C                   EVAL      KAseq = AACSQ
     C                   EVAL      KBrch = ABRCA

     C     KGlacnt       CHAIN     GLACNTL4
     C                   IF        NOT %FOUND( GLACNTL4 )
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE001502'
     C                   EVAL      DBFILE = 'GLACNTQD'
     C                   EVAL      DBKEY = KCusn + KCurr + %TRIM(%CHAR(KAcod)) +
     C                                     %TRIM(%CHAR(KAseq)) + KBrch
     C                   EVAL      DBASE = 8
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Continue processing when Include Account Balance Check flag is Y

     C**********         IF        F1IABC = 'Y'                                            MD022132D
     C                   IF        F1IABC = 'Y' OR                                         MD022132D
     C                             AAATYP = 'R'                                            MD022132D

      ** Load GLACNTQD dates and balances in work array.

     C                   EXSR      SrLoadFields

      ** Trigger Event is Add: Add current held amount to the
      ** available balances.

     C                   IF        WTrigEvent = '1'

     C                   FOR       Ix = 1 to Wndyf

     C                   IF        Rundate(Ix) < AHEXP
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) + AHLDA

     C                   IF        AHHIT = 'Y'
     C                   EVAL      PrvHardHeld(Ix) = PrvHardHeld(Ix) - AHLDA
     C                   ELSE
     C                   EVAL      PrvSoftHeld(Ix) = PrvSoftHeld(Ix) - AHLDA
     C                   ENDIF

     C                   ENDIF

     C                   ENDFOR

     C                   ENDIF

      ** Trigger Event is Subtract: Subtract current held amount from the
      ** available balances.

     C                   IF        WTrigEvent = '3' AND ARECI = 'D'

     C                   FOR       Ix = 1 to Wndyf
     C                   IF        Rundate(Ix) < AHEXP
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) - AHLDA

     C                   IF        AHHIT = 'Y'
     C                   EVAL      PrvHardHeld(Ix) = PrvHardHeld(Ix) + AHLDA
     C                   ELSE
     C                   EVAL      PrvSoftHeld(Ix) = PrvSoftHeld(Ix) + AHLDA
     C                   ENDIF

     C                   ENDIF

     C                   ENDFOR

     C                   ENDIF

      ** Update Available Balances array

     C                   FOR       Ix = 1 to Wndyf

      ** If Current Hard Held Items Array and blocked collateral amount is zero, check an overdraft
      ** line for this account. If there is, credit this amount from the Base Available and
      ** available Balances.

     C                   IF        CurHardHeld(Ix) = 0 AND BlockedColl(Ix) = 0
     C                             AND OvrdraftLine(Ix) <> 0
     C                             AND PrvHardHeld(Ix) <> 0
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) -
     C                                                OvrdraftLine(Ix)
     C                   ENDIF

     C                   IF        PrvHardHeld(Ix) = 0 AND BlockedColl(Ix) = 0
     C                             AND OvrdraftLine(Ix) <> 0
     C                             AND CurHardHeld(Ix) <> 0
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) +
     C                                                OvrdraftLine(Ix)
     C                   ENDIF

     C                   ENDFOR

      ** Update Available Balance in GLACNTQD

     C                   EXSR      SrUpdate

     C                   ELSE
     C                   UPDATE    GLACNTD0                             99
     C                   ENDIF

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

     C                   EVAL      AccountImg = WDetail

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
     C                   EVAL      Wloop = 'N'

     C     KGlacnt       CHAIN     GLACNTL4
     C                   IF        NOT %FOUND(GLACNTL4)
     C                   IF        WTrigEvent = '1'
     C                   EVAL      Wloop = 'Y'
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'GLACNTQD'
     C                   EVAL      DBKey = KCusn + KCurr + %TRIM(%CHAR(KAcod)) +
     C                                     %TRIM(%CHAR(KAseq)) + KBrch
     C                   EVAL      DBase = 13
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

     C                   IF        Wloop = 'N'

      ** Continue processing when Include Account Balance Check flag is Y

     C**********         IF        F1IABC = 'Y'                                            MD022132D
     C                   IF        F1IABC = 'Y' OR                                         MD022132D
     C                             AAATYP = 'R'                                            MD022132D

     C                   EXSR      SrDelay
     C                   IF        F1DAT1 = 0
     C                   EXSR      SrLoadDates
     C                   EXSR      SRGetCurrD
     C                   EXSR      SrAmndCurVal
     C                   ELSE
      ** Load GLACNTQD dates and balances in work array.

     C                   EXSR      SrLoadFields
     C                   ENDIF

      ** Update Available Balance in GLACNTQD

     C                   EXSR      SrUpdate

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
     C                   EVAL      GLCOLLPDImg = WDetail

      ** Block Collateral = 'Y'
      ** Collateral Processing Type = 'A'

     C                   IF        GCDBCOL = 'Y' AND GCDCOPT = 'A'
     C                   EVAL      KCusn = GCDCCNM
     C                   EVAL      KCurr = GCDCCCY
     C                   EVAL      KBrch = GCDCBRC
     C                   EVAL      KAcod = GCDCACD
     C                   EVAL      KAseq = GCDCSEQ

     C                   EXSR      SrCollProcess
     C                   EXSR      SrLoadCurr
     C                   EXSR      SrRecompute
     C                   EVAL      AvailBalArr    = AvailBalance
     C                   UPDATE    GLACNTD0
     C                   EVAL      WTrigEvent = '9'
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

      ** Process only if include account balance check indicator is 'Y'

     C**********         IF        F1IABC = 'Y'                                            MD022132D
     C                   IF        F1IABC = 'Y' OR                                         MD022132D
     C                             AAATYP = 'R'                                            MD022132D
     C                   EXSR      SRGetCurrD

      ** Load balances and dates from GLACNTQD to work arrays

     C                   EVAL      RunDate         = AvailDatesArr
     C                   EVAL      AvailBalance    = AvailBalArr

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
     C                                AND RunDate(i) < ODED
     C                   EVAL      OvrdraftLine(i) = ODLN * (10**A6NBDP)
     C                   ENDIF

     C                   ENDFOR
     C     KHeldI        READE     REODHSL0
     C                   ENDDO

     C                   ELSE
     C                   FOR       i = 1 TO WNdyf
     C                   IF        RunDate(i) < AAODED
     C                   EVAL      OvrdraftLine(i) = AAODLN * (10**A6NBDP)
     C                   ENDIF
     C                   ENDFOR
     C                   ENDIF

      ** Load blocked collaterals in work arrays

     C     KHeldI        SETLL     GLCOLLLG
     C     KHeldI        READE     GLCOLLLG

     C                   DOW       NOT %EOF(GLCOLLLG)
     C                   IF        CDCOPT = 'A' AND CDBCOL = 'Y'
     C                                AND GLCOLLPDImg <> CurGLCOLLPD
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
     C                   ENDIF
     C
     C                   ENDFOR
     C                   ENDIF
     C     KHeldI        READE     GLCOLLLG
     C                   ENDDO

     C                   ENDIF

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

     C                   EVAL      AvailBalance(i) = AvailBalance(i) -
     C                                               OvrdraftLine(i)
     C                   ENDIF

      ** If there is current blocked collateral and there is no previous blocked collateral,
      ** and there's no hard held items,
      ** put back the overdraft line by debiting the balances

     C                   IF        BlockedColl(i) <> *Zero
     C                                AND BlockCollPrev(i) = *Zero
     C                                AND HardHeld(i) = *Zero
     C                                AND OvrdraftLine(i) <> *Zero

     C                   EVAL      AvailBalance(i) = AvailBalance(i) +
     C                                               OvrdraftLine(i)
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

     C                   IF        Rundate(i) >= GCDVDAT
     C                                AND Rundate(i) <= GCDEDAT

     C                   EVAL      KBranch  = GCDCBRC
     C                   EVAL      KCollRef = GCDCREF

     C     KBrchRef      CHAIN     GLCOLLQ0

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'GLCOLLQD'
     C                   EVAL      DBKey  = KBranch + KCollRef
     C                   EVAL      DBase  = 19
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      AvailBalance(i) = AvailBalance(i) + QCDXCBC
     C                   EVAL      BlockedColl(i)  = BlockedColl(i) + QCDXCBC
     C                   ENDIF

     C                   ENDFOR

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
     C                   CLEAR                   AcctBalance
     C                   CLEAR                   RSAC

     C                   EVAL      WProcType = *ZEROS
     C                   EVAL      WUpdate   = *BLANKS
     C                   EVAL      WDorc     = *ZEROS

     C                   IF        WEventType = 'MNT_HELDIHB'
     C                   CLEAR                   CurSoftHeld
     C                   CLEAR                   PrvSoftHeld
     C                   CLEAR                   CurHardHeld
     C                   CLEAR                   PrvHardHeld
     C                   CLEAR                   BlockedColl
     C                   CLEAR                   AvailBalance
     C                   CLEAR                   OvrdraftLine
     C                   CLEAR                   Rundate
     C                   ENDIF

      ** Event type is Account Maintenance

     C                   IF        WEventType = 'MNT_ACCNTAB'
     C                   CLEAR                   SoftHeld
     C                   CLEAR                   HardHeld
     C                   CLEAR                   BlockedColl
     C                   CLEAR                   AvailBalance
     C                   CLEAR                   Rundate
     C                   ENDIF

      ** Initialize Arrays

     C                   IF        WEventType = 'MNT_GLCOLLPD'
     C                   CLEAR                   SoftHeld
     C                   CLEAR                   CurHardHeld
     C                   CLEAR                   AvailBalance
     C                   CLEAR                   OvrdraftLine
     C                   CLEAR                   RunDate
     C                   CLEAR                   BlockedColl
     C                   CLEAR                   BlockCollPrev
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
      *
     C                   EXSR      SRGetCurrD

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

      ** Load Account Balances 1 to 10 into AccountBalance array

     C                   Eval      AcctBalance(1) = F1BAV0
     C                   Eval      AcctBalance(2) = F1BAV1
     C                   Eval      AcctBalance(3) = F1BAV2
     C                   Eval      AcctBalance(4) = F1BAV3
     C                   Eval      AcctBalance(5) = F1BAV4
     C                   Eval      AcctBalance(6) = F1BAV5
     C                   Eval      AcctBalance(7) = F1BAV6
     C                   Eval      AcctBalance(8) = F1BAV7
     C                   Eval      AcctBalance(9) = F1BAV8
     C                   Eval      AcctBalance(10) = F1BAV9

     C                   IF        WEventType = 'MNT_HELDIHB'

      ** Load Current/Previous Hard and Soft Held Items

     C                   EXSR      SrLoadHeld

      ** Load Overdraft Line to array

     C                   EXSR      SrLoadOvDrft

      ** Load Blocked Collateral Amount

     C                   EXSR      SrLoadBlColl

     C                   ENDIF

      ** When Event Type is Account Transaction

     C                   IF        WEventType = 'MNT_ACCNTAB'

      ** Load Hard and Soft Held Items

     C                   EXSR      SrLoadHeld2

      ** Load Blocked Collateral Amount

     C                   EXSR      SrLoadBlColl

      ** Load back previous values by debiting overdraft line amount

     C                   IF        WTrigEvent = '3'
     C                   EXSR      SrLoadPrvVal
     C                   ENDIF

      ** Amend current value by crediting overdraft line amount

     C                   IF        WTrigEvent = '1'
     C                   EXSR      SrAmndCurVal
     C                   ENDIF

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
      ** Movement Ammount to Available Balances and Account Balances

     C                   IF        DORC = 0
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) + MVAM
     C                   EVAL      AcctBalance(Ix) = AcctBalance(Ix) + MVAM
     C                   ELSE
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) - MVAM
     C                   EVAL      AcctBalance(Ix) = AcctBalance(Ix) - MVAM
     C                   ENDIF

     C                   ENDFOR

      ** Process Type 2: The movement is included from the movement value date and
      ** all subsequent balances.
      ** Or if Value Date is not an availability date (i.e. movements with a
      ** value date that is a holiday in system currency), update the
      ** balance of the preceding availability date. This processing is
      ** 'in advance'

     C                   WHEN      WProcType = 2

     C                   IF        VUDT <= Rundate(Wndyf)
     C                             OR VUDT < F1OAD

     C                   FOR       Ix = 1 to Wndyf

     C                   IF        Ix = Wndyf
     C                   EVAL      WNWD = Ix
     C                   ELSEIF    Ix < Wndyf
     C                   EVAL      WNWD = Ix + 1
     C                   ENDIF

     C                   IF        VUDT <= Rundate(Ix)
     C                             OR VUDT > Rundate(Ix)
     C                             AND VUDT < Rundate(WNWD)
     C                             OR VUDT > Rundate(Ix)
     C                             AND VUDT < F1OAD
     C                             AND Ix = Wndyf

      ** If amount is Debit (Add), if Credit (Subtract)
      ** Movement Ammount to Available Balances and Account Balances

     C                   IF        DORC = 0
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) + MVAM
     C                   EVAL      AcctBalance(Ix) = AcctBalance(Ix) + MVAM
     C                   ELSE
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) - MVAM
     C                   EVAL      AcctBalance(Ix) = AcctBalance(Ix) - MVAM
     C                   ENDIF

     C                   ENDIF

     C                   ENDFOR

     C                   ENDIF

      ** Process Type 3: The movement is included from today and all subsequent
      ** balances if and only if the movement execution / posting date is today or earlier.
      ** Else it is not included.

     C                   WHEN      WProcType = 3

     C                   IF        VUDT <= BJRDNB

     C                   FOR       Ix = 1 to Wndyf
     C                   IF        VUDT <= Rundate(Ix)

      ** If amount is Debit (Add), if Credit (Subtract)
      ** Movement Amount to Available Balances and Account Balances

     C                   IF        DORC = 0
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) + MVAM
     C                   EVAL      AcctBalance(Ix) = AcctBalance(Ix) + MVAM
     C                   ELSE
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) - MVAM
     C                   EVAL      AcctBalance(Ix) = AcctBalance(Ix) - MVAM
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

     C                   IF        RunDate(Ix) < DODED
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) +
     C                             (DODLN * (10**A6NBDP))
     C                   ENDIF

     C                   ELSE

     C     KHeldI        SETGT     REODHSL0
     C     KHeldI        READPE    REODHSL0
     C                   IF        %FOUND(REODHSL0)
     C                   EVAL      WExpiry = DODED

     C                   IF        RunDate(Ix) >= HISD AND
     C                             RunDate(Ix) < WExpiry
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) +
     C                             (DODLN * (10**A6NBDP))
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

     C                   IF        RunDate(Ix) < DODED
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) -
     C                             (DODLN * (10**A6NBDP))
     C                   ENDIF

     C                   ELSE

     C     KHeldI        SETGT     REODHSL0
     C     KHeldI        READPE    REODHSL0
     C                   IF        %FOUND(REODHSL0)

     C                   IF        RunDate(Ix) >= HISD AND RunDate(Ix) < ODED
     C                   EVAL      AvailBalance(Ix) = AvailBalance(Ix) -
     C                             (DODLN * (10**A6NBDP))
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

     C                   EVAL      F1BAV0 = AcctBalance(1)
     C                   EVAL      F1BAV1 = AcctBalance(2)
     C                   EVAL      F1BAV2 = AcctBalance(3)
     C                   EVAL      F1BAV3 = AcctBalance(4)
     C                   EVAL      F1BAV4 = AcctBalance(5)
     C                   EVAL      F1BAV5 = AcctBalance(6)
     C                   EVAL      F1BAV6 = AcctBalance(7)
     C                   EVAL      F1BAV7 = AcctBalance(8)
     C                   EVAL      F1BAV8 = AcctBalance(9)
     C                   EVAL      F1BAV9 = AcctBalance(10)

     C                   UPDATE    GLACNTD0                             99
     C  N99              EVAL      WTrigEvent = '9'

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

     C                   IF        HeldItemImg <> CurHELDIHB

     C                   IF        Rundate(Ix) < HHEXP

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

     C                   IF        Rundate(Ix) < HHEXP

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
     C                             Rundate(Ix) < ODED
     C                   EVAL      OvrdraftLine(Ix) = ODLN * (10**A6NBDP)
     C                   ENDIF

     C                   ENDFOR

     C     KHeldI        READE     REODHSL0
     C                   ENDDO

      ** CRE001 is NOT installed

     C                   ELSE

     C                   FOR       Ix = 1 to Wndyf
     C                   IF        Rundate(Ix) < AAODED
     C                   EVAL      OvrdraftLine(Ix) = AAODLN * (10**A6NBDP)
     C                   ENDIF
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
     C                   EVAL      DBPGM = 'RE001502'
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

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetCurrD - Subroutine that Retrieves Currency Details      *
      *                                                               *
      *****************************************************************
     C     SRGetCurrD    BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCurr
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = PCurr
     C                   EVAL      DBASE = 11
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoadDates - Load Available Balance Dates                    *
      *                                                               *
      * Called by: SrACCTTrans                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrLoadDates   BEGSR

     C                   EVAL      WKSysNoDays = PCurSet(1)
     C                   EVAL      NoDays = %INT(%TRIM(WKSysNoDays)) + 1

      ** Initialize variables

     C                   MOVEA     *ZERO         F2DATS

      ** current rundate has already been changed so we will set this
      ** as F1DAT1 and F1DAT0 as today also

     C                   IF        NoDays >= 1
     C                   Z-ADD     BJRDNB        F2DAT0
     C                   EndIf

     C                   IF        NoDays >= 2
     C                   Z-ADD     BJRDNB        F2DAT1
     C                   ENDIF

      ** get the third day to tenth day

     C                   IF        NoDays >= 3
     C                   Z-ADD     3             WCTR
     C     BJRDNB        ADD       1             WDATEIN

     C                   DOW       WCTR <= NoDays

      ** Location currency

     C                   Z-ADD     WDATEIN       ZDAYNO
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   MOVE      *BLANKS       ZIND

     C                   EXSR      ZCHKH

     C                   MOVE      ZIND          LOCIND
     C                   IF        LOCIND = 'W'
     C                   EVAL      F2DATS(WCTR) = WDATEIN
     C                   ADD       1             WCTR
     C                   ENDIF
     C
     C                   ADD       1             WDATEIN

     C                   ENDDO
     C                   ENDIF
      *
      ** Get the next working day after the last ABC availability date and
      ** put it in F1OAD field
      *
     C                   EVAL      WDATEIN = F2DATS(NoDays) + 1
     C                   EVAL      LOCIND = *BLANK
      *
     C                   DOW       LOCIND <> 'W'
      *
      ** Location currency
      *
     C                   Z-ADD     WDATEIN       ZDAYNO
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   MOVE      *BLANKS       ZIND
      *
     C                   EXSR      ZCHKH
      *
     C                   MOVE      ZIND          LOCIND
     C                   IF        LOCIND = 'W'
     C                   EVAL      F1OAD = WDATEIN
     C                   ENDIF
     C                   ADD       1             WDATEIN
     C                   ENDDO

     C                   EVAL      F1DAT0 = F2DAT0
     C                   EVAL      F1DAT1 = F2DAT1
     C                   EVAL      F1DAT2 = F2DAT2
     C                   EVAL      F1DAT3 = F2DAT3
     C                   EVAL      F1DAT4 = F2DAT4
     C                   EVAL      F1DAT5 = F2DAT5
     C                   EVAL      F1DAT6 = F2DAT6
     C                   EVAL      F1DAT7 = F2DAT7
     C                   EVAL      F1DAT8 = F2DAT8
     C                   EVAL      F1DAT9 = F2DAT9

     C                   EVAL      RunDate = AvailDatesArr
     C                   ENDSR

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

      ** Read in data area

     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = 'RE001502'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBTXT  = *BLANKS
     C                   EVAL      DBASE  = 0
     C                   OUT       LDA

     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT

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

     C                   CLEAR                   PSysVal
     C                   CLEAR                   PCurSet
     C                   EVAL      PSysVal(1)  = 'ABCNoDaysForward'

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    PSysVal(1)
     C                   PARM                    PCurSet(1)
     C                   PARM                    PSysVal(2)
     C                   PARM                    PCurSet(2)
     C                   PARM                    PSysVal(3)
     C                   PARM                    PCurSet(3)
     C                   PARM                    PSysVal(4)
     C                   PARM                    PCurSet(4)
     C                   PARM                    PSysVal(5)
     C                   PARM                    PCurSet(5)
     C                   PARM                    PSysVal(6)
     C                   PARM                    PCurSet(6)
     C                   PARM                    PSysVal(7)
     C                   PARM                    PCurSet(7)
     C                   PARM                    PSysVal(8)
     C                   PARM                    PCurSet(8)
     C                   PARM                    PSysVal(9)
     C                   PARM                    PCurSet(9)
     C                   PARM                    PSysVal(10)
     C                   PARM                    PCurSet(10)

     C                   IF        PCurSet(1) = '*NRF' OR
     C                             PRTCD <> '*NRF' AND
     C                             PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY   = PSysVal(1)
     C                   EVAL      DBFILE  = 'SDSVALPD'
     C                   EVAL      DBPGM  = 'AOSVALR0'
     C                   EVAL      DBASE   = 21
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
     C/COPY ZSRSRC,ZCHKHLE
     C/COPY ZSRSRC,ZACCHLE

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDelay - Delay Job for 1 second                             *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrDelay       BEGSR
      *
     C                   EVAL      PCmd_Len = %Len(PCmd)
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCmd
     C                   PARM                    PCmd_Len
      *
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

