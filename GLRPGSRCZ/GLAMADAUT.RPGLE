     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account details authorisation')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  GLAMADAUT - Accounts Maintenance Authorisation               *
      *                                                               *
      *  Function:  This program performs the update processes that   *
      *             are to be carrired out on the unauthorised record *
      *             for Account details.                              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 CSD101             Date 07Dec18               *
      *                 MD046248           Date 27Oct17               *
      *                 CRE101             Date 27Aug14               *
      *                 CRE095             Date 25Apr14               *
      *                 CGL165             Date 17Feb15               *
      *                 CRE090             Date 14Feb14               *
      *                 AR1095876          Date 30Sep13               *
      *                 AR899028           Date 25Jan12               *
      *                 AR847269           Date 09Nov11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CER042             Date 11May11               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE015             Date 18Dec09               *
      *                 CAP205             Date 04Jan10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG5340            Date 06Apr05               *
      *                 BUG4684            Date 29Oct04               *
      *                 CLE040             Date 05Jul04               *
      *                 BUG3825            Date 27Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2733            Date 19May04               *
      *                 BUG2059            Date 03May04               *
      *                 TDA084             Date 16Apr04               *
      *                 TDA033             Date 18Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 225539             Date 10Mar04               *
      *                 CSD012  *CREATE    Date 15Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD101 - Password Encryption                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE101 - Interim Interest Statement on a Frequency           *
      *           Added hooks: CRE101_006, CRE101_007, CRE101_008,    *
      *                        CRE101_009, CRE10_021                  *
      *  CRE095 - Rate Fixing for RE Accounts (Recompile)             *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179) (Recompile)                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  BUG5340 - Validate TI account details.                       *
      *  BUG4684 - Rename WCOA to COLA same as ACCNTAB. (Recompile)   *
      *  CLE040 - Collateralised Lending Phase 2 (Recompile)          *
      *  BUG3825 - Account authorization deletion not deleting        *
      *           GLACNTQD record for account. (GLAMADAUT changed.)   *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG2733 - Make sure files are mapped correctly (RECOMD/      *
      *            GLVAMCOPD and REAPWDPD/GLVAMPWPD)                  *
      *  BUG2059 - Recompiled over changed GLAMADUPD (SP8GL0001).     *
      *  TDA084 - Replace the #1DREIAC parameter of GLAMADUPD to      *
      *           GLVAMRI in order to match with receiving GLVAMRI    *
      *           parameter.  Contents of #1DREIAC were moved  to     *
      *           matching fields of GLVAMRI beforehand.              *
      *  TDA033 - Missing fields in GLBXSHPD (Recompile)              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  225539 - Fields were not compared correctly.  Reposition     *
      *           compared fields based on SDAUFDPD.                  *
      *  CSD012 - Standing Data Authorisation                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FACCBR     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AC_)
     FACCNTBXC  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AX_)
     FREIAC     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(RE_)
     FRECOM     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(RC_)
     F**********REAPWDL0  IF   E           K DISK    INFSR(*PSSR)                             CSD101
     F**********                                     PREFIX(RW_)                              CSD101
     FREPRPNPD  IF   E           K DISK    INFSR(*PSSR)                                       CRE015
 
     FGLACSHL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:GLACSHD0)
     F                                     PREFIX(AC_)
     FGLACSHL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:GLACSHD1)
      ** Midas GL Account Details Shadow File
 
     FGLBXSHL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AX_)
     FGLBXSHL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLBXSHD0:GLBXSHD1)
      ** Midas GL Account extension Details Shadow File
 
     FREIASHL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(RE_)
     FREIASHL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REIASHD0:REIASHD1)
      ** Midas RE Retail Int and Charges Details Shadow File
 
     FRECMSHL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(RC_)
     FRECMSHL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(RECMSHD0:RECMSHD1)
      ** Midas RE commission Details Shadow File
 
     F***REPWSHL0  IF   E           K DISK    INFSR(*PSSR)                                    CSD101
     F***                                     PREFIX(RW_)                                     CSD101
     F***REPWSHL1  UF A E           K DISK    INFSR(*PSSR)                                    CSD101
     F***                                     RENAME(REPWSHD0:REPWSHD1)                       CSD101
      ** Midas RE Paswword Details Shadow File
                                                                                              CRE015
     FREPRSHL0  IF   E           K DISK    INFSR(*PSSR)                                       CRE015
     FREPRSHL1  UF A E           K DISK    INFSR(*PSSR)                                       CRE015
     F                                     RENAME(REPRSHD0:REPRSHD1)                          CRE015
 
     FSDAULGL0  IF   E           K DISK    INFSR(*PSSR)
     FSDAULGL1  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDAULGD0:SDAULGD1)
      ** Midas SD Authorisation Log - by Key
 
     F/COPY WNCPYSRC,GLH00523
     FGLACNTL3  UF   E           K DISK    INFSR(*PSSR)                                      BUG3825
      ** Midas GL Account Extension File Key                                                 BUG3825
     FTABTBRE   IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(R_) USROPN
      ** Retail III Table file
                                                                                             BUG5340
      *                                                                                      BUG5340
      ** GL Accounts by branch, TI A/c no and TI A/c suffix                                  BUG5340
      *                                                                                      BUG5340
     FACCNTTI   IF   E           K DISK    INFSR(*PSSR)                                      BUG5340
     F                                     RENAME(ACCNTABF:ACCNTTIF)                         BUG5340
     F                                     PREFIX(TI_)                                       BUG5340
                                                                                              CRE015
      ** Account code extension file                                                          CRE015
                                                                                              CRE015
     FSDACD1L0  IF   E           K DISK    INFSR(*PSSR)                                       CRE015
 
     F/COPY WNCPYSRC,GLAMADF001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA Layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Fisrt DS for Access Programs, Short Data Structure
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * DATA STRUCTURE FOR Midas Modules Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      * DATA STRUCTURE FOR Midas SAR Details
 
     D @1DACCNT      E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(AC_)
      * Stored Account details file format fields
 
     D @1DACCNTBX    E DS                  EXTNAME(ACCNTBXC)
     D                                     PREFIX(AX_)
      * Stored Extension Account Details file format fields
 
     D @1DREIAC      E DS                  EXTNAME(REIACD)
     D                                     PREFIX(RE_)
      * Stored Ret Int & Charges details file format fields
 
     D @1DRECOM      E DS                  EXTNAME(RECOMD)
     D                                     PREFIX(RC_)
      * Stored Ret Commission details file format fields
 
     D***@1DREAPW      E DS                  EXTNAME(REAPWDPD)                                CSD101
     D***                                    PREFIX(RW_)                                      CSD101
      * Stored Ret Password details file format fields
 
     D #1DACCNT      E DS                  EXTNAME(ACCNTAB) PREFIX(#AC)
     D #1PART1                 1    396
     D #1CHTP                397    397
     D***#1PART3               398    553                                                     CGL029
     D #1PART3               398    573                                                       CGL029
      * Stored Account details Shadow file format fields
 
     D #1DACCNTBX    E DS                  EXTNAME(ACCNTBXC) PREFIX(#AX)
      * Stored Extension Account Details Shadow file format fields
 
     D #1DREIAC      E DS                  EXTNAME(REIACD) PREFIX(#RE)
     D DREIACsh                1    144                                                       TDA084
     D DREIACex              146    218                                                       TDA084
                                                                                              TDA084
      * Stored Ret Int & Charges details Shadow file format fields
 
     D #1DRECOM      E DS                  EXTNAME(RECOMD) PREFIX(#RC)
     D DRECOMsh                1    286                                                      BUG2733
     D DRECOMex              287    296                                                      BUG2733
      * Stored Ret Commission details Shadow file format fields
 
     D***#1DREAPW      E DS                  EXTNAME(REAPWDPD) PREFIX(#RW)                    CSD101
     D***DREAPWsh                1     33                                             BUG2733 CSD101
     D***DREAPWex               34     43                                             BUG2733 CSD101
      **Stored*Ret*Password*details*Shadow*File*format*fields**********                       CSD101
                                                                                              TDA084
     D GLVAMRI       E DS                  EXTNAME(GLVAMRIPD)                                 TDA084
     D GLVAMRIsh               1    144                                                       TDA084
     D GLVAMRIex             212    284                                                       TDA084
     D GLVAMCO       E DS                  EXTNAME(GLVAMCOPD)                                BUG2733
     D                                     PREFIX(CO_)                                       BUG2733
     D GLVAMCOsh               1    286                                                      BUG2733
     D GLVAMCOex             354    363                                                      BUG2733
     D GLVAMPW       E DS                  EXTNAME(GLVAMPWPD)                         BUG2733 CSD101
     D                                     PREFIX(CV_)                                BUG2733 CSD101
     D***GLVAMPWsh               1     33                                             BUG2733 CSD101
     D***GLVAMPWex             101    110                                             BUG2733 CSD101
     D GLVAMPWsh               1    146                                                       CSD101
     D GLVAMPWex             214    223                                                       CSD101
     D GLVAMPP       E DS                  EXTNAME(GLVAMPPPD)                                 CRE015
     D/COPY OFCPYSRCZ,CRE101_006                                                              CRE101
 
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
      **  Data Structure for AOSVALR0 string
     DSVAL1            DS           200
     DSVAL11                   1      1
 
      ** Fields defined used for SDAULGL0
     D***PKEY***         DS            20                                                     CGL029
     D PKEY            DS            26                                                       CGL029
     D PkeyBRCA                1      3
     D PkeyCNUM                4      9
     D PkeyCCY                10     12
     D***PKeyACOD               13     16                                                     CGL029
     D***PkeyACSQ               17     18                                                     CGL029
     D PKeyACOD               13     22                                                       CGL029
     D PkeyACSQ               23     24                                                       CGL029
 
     D UBA             DS          5000
      **  1st Record Format
     D  MAINUBA                            LIKE(@1DACCNT)
     D  EXT1UBA                            LIKE(@1DACCNTBX)
     D***EXT2UBA                          LIKE(@1DREIAC)                                      225539
     D***EXT2UBA                            LIKE(@1DREAPW)                             225539 CSD101
     D  EXT3UBA                            LIKE(@1DRECOM)
     D***EXT4UBA                         LIKE(@1DREAPW)                                       225539
     D  EXT4UBA                            LIKE(@1DREIAC)                                     225539
     D  EXT5UBA                    3000                                                       CRE015
     D/COPY WNCPYSRC,GLAMADD001
 
     D UPA             DS          5000
      **  2nd Record Format
     D  MAINUPA                            LIKE(@1DACCNT)
     D  EXT1UPA                            LIKE(@1DACCNTBX)
     D***EXT2UPA                           LIKE(@1DREIAC)                                     225539
     D***EXT2UPA                            LIKE(@1DREAPW)                             225539 CSD101
     D  EXT3UPA                            LIKE(@1DRECOM)
     D***EXT4UPA                           LIKE(@1DREAPW)                                     225539
     D  EXT4UPA                            LIKE(@1DREIAC)                                     225539
     D  EXT5UPA                    3000                                                       CRE015
     D/COPY WNCPYSRC,GLAMADD002
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Override GLACSHL0,GLBXSHL0,REIASHL0,RECMSHL0 &REPPSHL0 .
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)
     D CMD1            S              1    DIM(50) CTDATA PERRCD(50)
     D CMD2            S              1    DIM(50) CTDATA PERRCD(50)
     D CMD3            S              1    DIM(50) CTDATA PERRCD(50)
     D***CMD4            S              1    DIM(50) CTDATA PERRCD(50)                        CSD101
     D CMD5            S              1    DIM(50) CTDATA PERRCD(50)                          CRE015
 
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
     D CSD012          S              1A
     D SVALKK          C                   CONST('AuthReqAccntMaint')
     D @RUN            S              1
     D CPY2@           S             80
 
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
                                                                                              CSC022
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
     D X               S              3  0                                                    CRE015
     D CRE015          S              1A                                                      CRE015
     D REPRPN        E DS                  EXTNAME(REPRPNPD)                                  CRE015
     D ArrFilBuf       S                   DIM(26) LIKE(REPRPN)                               CRE015
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *----------------------------------------------------------------
      ** Access record from authorisation log
     C     PKEY          CHAIN     SDAULGL0                           80
      *
     C                   IF        *IN80 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDAULGPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *----------------------------------------------------------------
      ** Access record from master file
     C                   MOVEL     PKeyBRCA      KeyBRCA
     C                   MOVEL     PKeyCNUM      KeyCNUM
     C                   MOVEL     PKeyCCY       KeyCCY
     C                   MOVEL     PKeyACOD      KeyACOD
     C                   MOVEL     PKeyACSQ      KeyACSQ
 
     C     Rehiskey      CHAIN     ACCBR                              81
      *
     C                   IF        *IN81 = '1' AND ALACTN = 'A'
     C     *LOCK         IN        LDA
     C                   MOVEL     'ACCNTAB'     DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   MOVEL     *BLANKS       MAINUBA
     C                   MOVEL     @1DACCNT      MAINUBA
     C                   ENDIF
 
     C     BGWDPR        IFEQ      'Y'
     C     BGSWRT        ANDEQ     'Y'
     C     AC_ATYP       ANDEQ     'R'
     C     BGWDPR        OREQ      'Y'
     C     BGNTST        ANDEQ     'Y'
     C     AC_ATYP       ANDEQ     'R'
     C     BGWDPR        OREQ      'Y'
     C     R_FACH        ANDEQ     'Y'
     C     AC_ATYP       ANDEQ     'R'
     C     BGWDPR        OREQ      'Y'
     C     R_TSTMC       ANDEQ     'Y'
     C     AC_ATYP       ANDEQ     'R'
      *
     C     Accntkey      CHAIN     ACCNTBXC                           82
      *
     C                   IF        *IN82 = '1' AND ALACTN = 'A'
     C     *LOCK         IN        LDA
     C                   MOVEL     'ACCNTBXC'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   MOVEL     *BLANKS       EXT1UBA
     C                   MOVEL     @1DACCNTBX    EXT1UBA
     C                   ENDIF
      *
     C                   ENDIF
 
     C     BGNXST        IFEQ      'Y'
     C     BGNYST        OREQ      'Y'
     C                   IF        AC_ATYP = 'R'
      *
     C     Accntkey      CHAIN     REIAC                              83
     C                   IF        *IN83 = '1' AND ALACTN = 'A'
     C     *LOCK         IN        LDA
     C                   MOVEL     'REIACD'      DBFILE
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C**********         MOVEL     *BLANKS       EXT2UBA                                      225539
     C**********         MOVEL     @1DREIAC      EXT2UBA                                      225539
     C                   MOVEL     *BLANKS       EXT4UBA                                      225539
     C                   MOVEL     @1DREIAC      EXT4UBA                                      225539
     C                   ENDIF
 
     C     RehisKey      CHAIN     RECOM                              84
     C                   IF        *IN84 = '1' AND ALACTN = 'A'
     C     *LOCK         IN        LDA
     C                   MOVEL     'RECOMD'      DBFILE
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     *BLANKS       EXT3UBA
     C                   MOVEL     @1DRECOM      EXT3UBA
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
 
      ** If CRT101 (Password on Retail Accounts) is installed and
      ** CRT001 (Retail Teller System) is on
      *
     C                   IF        CRT101='Y' and CRT001='Y' and
     C                             AC_ATYP='R' and AC_STYP='S'
      *
     C*****Accntkey      CHAIN     REAPWDL0                           85                      CSD101
     C**********         IF        *IN85 = '1' AND ALACTN = 'A'                               CSD101
     C******LOCK         IN        LDA                                                        CSD101
     C**********         MOVEL     'REAPWDPD'    DBFILE                                       CSD101
     C**********         MOVEL     '006'         DBASE                                        CSD101
     C**********         MOVEL     PKEY          DBKEY                                        CSD101
     C**********         OUT       LDA                                                        CSD101
     C**********         EXSR      *PSSR                                                      CSD101
     C**********         ELSE                                                                 CSD101
     C**********         MOVEL     *BLANKS       EXT4UBA                                      225539
     C**********         MOVEL     @1DREAPW      EXT4UBA                                      225539
     C**********         MOVEL     *BLANKS       EXT2UBA                               225539 CSD101
     C**********         MOVEL     @1DREAPW      EXT2UBA                               225539 CSD101
     C**********         ENDIF                                                                CSD101
      *
     C                   ENDIF
                                                                                              CRE015
      ** Access period and penalty details if CRE015 is on and the                            CRE015
      ** account is a term and notice account                                                 CRE015
                                                                                              CRE015
     C                   IF        CRE015 = 'Y'                                               CRE015
     C     PKeyACOD      CHAIN     SDACD1L0                                                   CRE015
     C                   IF        NOT %FOUND(SDACD1L0)                                       CRE015
     C                   EVAL      A5ATTY = *BLANKS                                           CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                             AND A5ATTY = 'P'                                           CRE015
                                                                                              CRE015
     C                   EVAL      ArrFilBuf = *BLANKS                                        CRE015
     C                   EVAL      X = 0                                                      CRE015
                                                                                              CRE015
     C     RehisKey      SETLL     REPRPNPD                                                   CRE015
     C     RehisKey      READE     REPRPNPD                                                   CRE015
     C                   DOW       NOT %EOF(REPRPNPD)                                         CRE015
                                                                                              CRE015
     C                   EVAL      X = X + 1                                                  CRE015
     C                   EVAL      ArrFilBuf(X) = REPRPN                                      CRE015
                                                                                              CRE015
     C     RehisKey      READE     REPRPNPD                                                   CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
     C                   MOVEA     ArrFilBuf     EXT5UBA                                      CRE015
     C                   ENDIF                                                                CRE015
      *----------------------------------------------------------------
      ** Access record from shadow Account files
 
     C     Rehiskey      CHAIN     GLACSHL0                           86
      *
     C                   IF        ALACTN = 'A'
     C                   MOVEL     *BLANKS       MAINUPA
     C                   MOVEL     @1DACCNT      MAINUPA
     C                   ELSE
     C                   MOVEL     *BLANKS       MAINUBA
     C                   MOVEL     @1DACCNT      MAINUBA
     C                   ENDIF
 
     C     Accntkey      CHAIN     GLBXSHL0                           87
      *
     C                   IF        *IN87 = '1'
     C                   CLEAR                   @1DACCNTBX
     C                   MOVEL     @1DACCNTBX    EXT1UBA
     C                   MOVEL     @1DACCNTBX    EXT1UPA
      *
     C                   ELSE
     C                   IF        ALACTN = 'A'
     C                   MOVEL     *BLANKS       EXT1UPA
     C                   MOVEL     @1DACCNTBX    EXT1UPA
     C                   ELSE
     C                   MOVEL     *BLANKS       EXT1UBA
     C                   MOVEL     @1DACCNTBX    EXT1UBA
     C                   ENDIF
      *
     C                   ENDIF
 
     C     Rehiskey      CHAIN     REIASHL0                           88
      *
     C                   IF        *IN88 = '1'
     C                   CLEAR                   @1DREIAC
     C**********         MOVEL     @1DREIAC      EXT2UBA                                      225539
     C**********         MOVEL     @1DREIAC      EXT2UPA                                      225539
     C                   MOVEL     @1DREIAC      EXT4UBA                                      225539
     C                   MOVEL     @1DREIAC      EXT4UPA                                      225539
      *
     C                   ELSE
     C                   IF        ALACTN = 'A'
     C**********         MOVEL     *BLANKS       EXT2UPA                                      225539
     C**********         MOVEL     @1DREIAC      EXT2UPA                                      225539
     C                   MOVEL     *BLANKS       EXT4UPA                                      225539
     C                   MOVEL     @1DREIAC      EXT4UPA                                      225539
     C                   ELSE
     C**********         MOVEL     *BLANKS       EXT2UBA                                      225539
     C**********         MOVEL     @1DREIAC      EXT2UBA                                      225539
     C                   MOVEL     *BLANKS       EXT4UBA                                      225539
     C                   MOVEL     @1DREIAC      EXT4UBA                                      225539
     C                   ENDIF
      *
     C                   ENDIF
 
     C     Rehiskey      CHAIN     RECMSHL0                           89
      *
     C                   IF        *IN89 = '1'
     C                   CLEAR                   @1DRECOM
     C                   MOVEL     @1DRECOM      EXT3UBA
     C                   MOVEL     @1DRECOM      EXT3UPA
      *
     C                   ELSE
     C                   IF        ALACTN = 'A'
     C                   MOVEL     *BLANKS       EXT3UPA
     C                   MOVEL     @1DRECOM      EXT3UPA
     C                   ELSE
     C                   MOVEL     *BLANKS       EXT3UBA
     C                   MOVEL     @1DRECOM      EXT3UBA
     C                   ENDIF
      *
     C                   ENDIF
 
     C*****Accntkey      CHAIN     REPWSHL0                           90                      CSD101
      *
     C**********         IF        *IN90 = '1'                                                CSD101
     C**********         CLEAR                   @1DREAPW                                     CSD101
     C**********         MOVEL     @1DREAPW      EXT4UBA                                      225539
     C**********         MOVEL     @1DREAPW      EXT4UPA                                      225539
     C**********         MOVEL     @1DREAPW      EXT2UBA                               225539 CSD101
     C**********         MOVEL     @1DREAPW      EXT2UPA                               225539 CSD101
      *
     C**********         ELSE                                                                 CSD101
     C**********         IF        ALACTN = 'A'                                               CSD101
     C**********         MOVEL     *BLANKS       EXT4UPA                                      225539
     C**********         MOVEL     @1DREAPW      EXT4UPA                                      225539
     C**********         MOVEL     *BLANKS       EXT2UPA                               225539 CSD101
     C**********         MOVEL     @1DREAPW      EXT2UPA                               225539 CSD101
     C**********         ELSE                                                                 CSD101
     C**********         MOVEL     *BLANKS       EXT4UBA                                      225539
     C**********         MOVEL     @1DREAPW      EXT4UBA                                      225539
     C**********         MOVEL     *BLANKS       EXT2UBA                               225539 CSD101
     C**********         MOVEL     @1DREAPW      EXT2UBA                               225539 CSD101
     C**********         ENDIF                                                                CSD101
      *
     C**********         ENDIF                                                                CSD101
                                                                                              CRE015
      ** Period and penalty details                                                           CRE015
                                                                                              CRE015
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                             AND A5ATTY = 'P'                                           CRE015
                                                                                              CRE015
     C                   EVAL      ArrFilBuf = *BLANKS                                        CRE015
     C                   EVAL      X = 0                                                      CRE015
                                                                                              CRE015
     C     RehisKey      SETLL     REPRSHL0                                                   CRE015
     C     RehisKey      READE     REPRSHL0                                                   CRE015
     C                   DOW       NOT %EOF(REPRSHL0)                                         CRE015
                                                                                              CRE015
     C                   EVAL      X = X + 1                                                  CRE015
     C                   EVAL      ArrFilBuf(X) = REPRPN                                      CRE015
                                                                                              CRE015
     C     RehisKey      READE     REPRSHL0                                                   CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
     C                   IF        ALACTN = 'A'                                               CRE015
     C                   MOVEA     ArrFilBuf     EXT5UPA                                      CRE015
     C                   ELSE                                                                 CRE015
     C                   MOVEA     ArrFilBuf     EXT5UBA                                      CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
 
     C/COPY WNCPYSRC,GLAMADC002
      *----------------------------------------------------------------
      *
      ** Call program SDAUTHCMP to display differences
 
     C                   CALLB     'SDAUTHCMP'
     C                   PARM      *BLANKS       RETCODE
     C                   PARM      'ACCNTAB'     FILE             10
     C                   PARM                    UBA
     C                   PARM                    UPA
 
     C                   PARM                    PKEY
     C                   PARM                    PACTN
      * Command Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKI             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
 
      * Exit program if Enquire or F3 or F12
     C                   IF        PACTN = 'E' OR @INKC = '1' OR @INKL = '1'
     C                   MOVEL     RETCODE       ERRMSG
     C                   EXSR      SREnd
     C                   ENDIF
 
      * Authorise Requested
     C                   IF        @INKI = '1'
     C                   EXSR      SRUpdate
     C                   EXSR      SRDelete
     C                   ENDIF
 
      * Delete Requested
     C                   IF        @INKJ = '1'
     C                   EXSR      SRDelete
     C                   ENDIF
      *
      ** End program
     C                   EXSR      SREnd
      /EJECT
      *****************************************************************
      * SRDelete - Delete Authorisation request from Log file and     *
      *            Shadow file.                                       *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls    :                                                    *
      *****************************************************************
     C     SRDelete      BEGSR
 
      ** Delete record from Audit Log
     C     PKEY          CHAIN     SDAULGL1                           91
      *
     C                   IF        *IN91 = '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDAULGPD'    DBFILE
     C                   MOVEL     '007'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   DELETE    SDAULGL1
     C                   ENDIF
      *----------------------------------------------------------------
      ** Delete record from Account Shadow File
     C     Rehiskey      CHAIN     GLACSHL1                           92
      *
     C                   IF        *IN92 = '0'
     C                   DELETE    GLACSHD1
     C                   ENDIF
      *
      *----------------------------------------------------------------
      ** Delete record from Account extension shadow file
 
     C     BGWDPR        IFEQ      'Y'
     C     BGSWRT        ANDEQ     'Y'
     C     AC_ATYP       ANDEQ     'R'
     C     BGWDPR        OREQ      'Y'
     C     BGNTST        ANDEQ     'Y'
     C     AC_ATYP       ANDEQ     'R'
     C     BGWDPR        OREQ      'Y'
     C     R_FACH        ANDEQ     'Y'
     C     AC_ATYP       ANDEQ     'R'
     C     BGWDPR        OREQ      'Y'
     C     R_TSTMC       ANDEQ     'Y'
     C     AC_ATYP       ANDEQ     'R'
 
     C     Accntkey      CHAIN     GLBXSHL1                           93
      *
     C                   IF        *IN93 = '0'
     C                   DELETE    GLBXSHD1
     C                   ENDIF
      *
     C                   ENDIF
      *----------------------------------------------------------------
      ** Delete record from RE Int & Charges Account Shadow file
 
     C     BGNXST        IFEQ      'Y'
     C     BGNYST        OREQ      'Y'
      *
     C                   IF        AC_ATYP = 'R'
      *
     C     Rehiskey      CHAIN     REIASHL1                           94
      *
     C                   IF        *IN94 = '0'
     C                   DELETE    REIASHD1
     C                   ENDIF
      *
     C     Rehiskey      CHAIN     RECMSHL1                           95
      *
     C                   IF        *IN95 = '0'
     C                   DELETE    RECMSHD1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *----------------------------------------------------------------
      ** If CRT101 (Password on Retail Accounts) is installed and
      ** CRT001 (Retail Teller System) is on
      *
     C                   IF        CRT101='Y' and CRT001='Y' and
     C                             AC_ATYP='R' and AC_STYP='S'
      *
     C*****Accntkey      CHAIN     REPWSHL1                           96                      CSD101
      *                                                                                       CSD101
     C**********         IF        *IN96 = '0'                                                CSD101
     C**********         DELETE    REPWSHD1                                                   CSD101
     C**********         ENDIF
      *
     C                   ENDIF
      *                                                                                      BUG3825
      *----------------------------------------------------------------                      BUG3825
      ** If delete requested and account does not exist                                      BUG3825
      ** Delete record from Collateralized Lending extension file                            BUG3825
     C                   IF        @INKJ = '1'                                               BUG3825
     C     Rehiskey      CHAIN     ACCBR                              97                     BUG3825
     C                   IF        *IN97 = '1'                                               BUG3825
     C     AccntKey      CHAIN     GLACNTD0                           97                     BUG3825
     C                   IF        *IN97 = '0'                                               BUG3825
     C                   DELETE    GLACNTD0                                                  BUG3825
     C/COPY WNCPYSRC,GLH00524
     C                   ENDIF                                                               BUG3825
     C                   ENDIF                                                               BUG3825
     C                   ENDIF                                                               BUG3825
      *----------------------------------------------------------------                      BUG3825
                                                                                              CRE015
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                             AND A5ATTY = 'P'                                           CRE015
     C     RehisKey      SETLL     REPRSHL1                                                   CRE015
     C     RehisKey      READE     REPRSHL1                                                   CRE015
     C                   DOW       NOT %EOF(REPRSHL1)                                         CRE015
     C                   DELETE    REPRSHD1                                                   CRE015
     C     RehisKey      READE     REPRSHL1                                                   CRE015
     C                   ENDDO                                                                CRE015
     C                   ENDIF                                                                CRE015
 
     C/COPY WNCPYSRC,GLAMADC003
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRUpdate - Update master file with shadow file details        *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls    :                                                    *
      *****************************************************************
     C     SRUpdate      BEGSR
 
      ** Hold shadow record image for the 5 Account master files
 
     C     Rehiskey      CHAIN     GLACSHL0                           86
 B1  C                   IF        *IN86 = '0'
     C                   MOVEL     @1DACCNT      #1DACCNT
      *
      *----------------------------------------------------------------
     C     BGWDPR        IFEQ      'Y'
     C     BGSWRT        ANDEQ     'Y'
     C     AC_ATYP       ANDEQ     'R'
     C     BGWDPR        OREQ      'Y'
     C     BGNTST        ANDEQ     'Y'
     C     AC_ATYP       ANDEQ     'R'
     C     BGWDPR        OREQ      'Y'
     C     R_FACH        ANDEQ     'Y'
     C     AC_ATYP       ANDEQ     'R'
     C     BGWDPR        OREQ      'Y'
     C     R_TSTMC       ANDEQ     'Y'
     C     AC_ATYP       ANDEQ     'R'
      *
     C     Accntkey      CHAIN     GLBXSHL0                           87
      *
     C                   IF        *IN87 = '0'
     C                   MOVEL     @1DACCNTBX    #1DACCNTBX
     C                   ENDIF
      *
      ** Clear Data Structure
     C                   ELSE
      *
     C                   CLEAR                   @1DACCNTBX
     C                   MOVEL     @1DACCNTBX    #1DACCNTBX
     C                   ENDIF
      *----------------------------------------------------------------
 B1  C     BGNXST        IFEQ      'Y'
     C     BGNYST        OREQ      'Y'
      *
 B2  C                   IF        AC_ATYP = 'R'
      *
     C     Rehiskey      CHAIN     REIASHL0                           88
      *
 B3  C                   IF        *IN88 = '0'
     C                   MOVEL     @1DREIAC      #1DREIAC
 E3  C                   ENDIF
      *
     C     Rehiskey      CHAIN     RECMSHL0                           89
      *
 B3  C                   IF        *IN89 = '0'
     C                   MOVEL     @1DRECOM      #1DRECOM
 E3  C                   ENDIF
      *
      ** Clear Data Structure
 X2  C                   ELSE
      *
     C                   CLEAR                   @1DREIAC
     C                   MOVEL     @1DREIAC      #1DREIAC
     C                   CLEAR                   @1DRECOM
     C                   MOVEL     @1DRECOM      #1DRECOM
 E2  C                   ENDIF
      *
      ** Clear Data Structure
 X1  C                   ELSE
      *
     C                   CLEAR                   @1DREIAC
     C                   MOVEL     @1DREIAC      #1DREIAC
     C                   CLEAR                   @1DRECOM
     C                   MOVEL     @1DRECOM      #1DRECOM
 E1  C                   ENDIF
      *----------------------------------------------------------------
      *
      ** If CRT101 (Password on Retail Accounts) is installed and
      ** CRT001 (Retail Teller System) is on
      *
     C**********         IF        CRT101='Y' and CRT001='Y' and                              CSD101
     C**********                   AC_ATYP='R' and AC_STYP='S'                                CSD101
      *
     C*****Accntkey      CHAIN     REPWSHL0                           90                      CSD101
      *
     C**********         IF        *IN90 = '0'                                                CSD101
     C**********         MOVEL     @1DREAPW      #1DREAPW                                     CSD101
     C**********         ENDIF                                                                CSD101
      *
      ** Clear Data Structure
     C**********         ELSE                                                                 CSD101
      *
     C**********         CLEAR                   @1DREAPW                                     CSD101
     C**********         MOVEL     @1DREAPW      #1DREAPW                                     CSD101
     C**********         ENDIF                                                                CSD101
      *---------------------------------------------------------------                        CRE015
                                                                                              CRE015
     C                   CLEAR                   GLVAMPP                                      CRE015
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                             AND A5ATTY = 'P'                                           CRE015
                                                                                              CRE015
      ** Initialise array with file format structure                                          CRE015
                                                                                              CRE015
     C                   CLEAR                   REPRPN                                       CRE015
     C                   DO        26            X                                            CRE015
     C                   EVAL      ArrFilBuf(X) = REPRPN                                      CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
      ** Load array with data from shadow file                                                CRE015
                                                                                              CRE015
     C                   EVAL      X = 0                                                      CRE015
     C     RehisKey      SETLL     REPRSHL0                                                   CRE015
     C     RehisKey      READE     REPRSHL0                                                   CRE015
     C                   DOW       NOT %EOF(REPRSHL0)                                         CRE015
                                                                                              CRE015
     C                   EVAL      X = X + 1                                                  CRE015
     C                   EVAL      ArrFilBuf(X) = REPRPN                                      CRE015
                                                                                              CRE015
     C     RehisKey      READE     REPRSHL0                                                   CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
      ** Move array into the valid file data structure                                        CRE015
                                                                                              CRE015
     C                   MOVEA     ArrFilBuf     GLVAMPP                                      CRE015
     C                   ENDIF                                                                CRE015
      *----------------------------------------------------------------
      *
     C     Rehiskey      CHAIN     ACCBR                              81
      *
 B1  C     *IN81         IFEQ      *ON
     C     ALACTN        ANDNE     'I'
     C     *LOCK         IN        LDA
     C                   MOVEL     'ACCNTAB'     DBFILE
     C                   MOVEL     '008'         DBASE
     C                   MOVEL     PKEY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
 X1  C                   ELSE
      *                                                                                      BUG5340
      ** Validate TI acocunt if insert mode                                                  BUG5340
      *                                                                                      BUG5340
     C                   EVAL      *IN82 = *OFF                                              BUG5340
     C                   IF        BGN3ST = 'Y' AND #ACA5TIAC = 'Y'                          BUG5340
     C                             AND ALACTN = 'I'                                          BUG5340
     C                   IF        #ACA5TIAN <> *BLANKS                                      BUG5340
     C                             AND #ACA5TIAS <> *BLANKS                                  BUG5340
     C     WACCNT        CHAIN     ACCNTTI                                                   BUG5340
     C                   IF        %FOUND                                                    BUG5340
     C                   EVAL      *IN82 = *ON                                               BUG5340
     C                   MOVEL     'RE71060'     ERRMSG                                      BUG5340
     C                   EXSR      SREnd                                                     BUG5340
     C                   ENDIF                                                               BUG5340
     C                   ELSE                                                                BUG5340
      *                                                                                      BUG5340
      ** Error if TI account details are blank                                               BUG5340
      *                                                                                      BUG5340
     C                   EVAL      *IN82 = *ON                                               BUG5340
     C                   MOVEL     'RE71061'     ERRMSG                                      BUG5340
     C                   EXSR      SREnd                                                     BUG5340
     C                   ENDIF                                                               BUG5340
     C                   ENDIF                                                               BUG5340
     C                   IF        *IN82 = *OFF                                              BUG5340
     C                   MOVEL     PACTN         AUTHMD
     C                   MOVEL     ALACTN        #1CHTP
 
      ** Update Master files
 
     C                   CLEAR                   GLVAMRI                                      TDA084
     C                   MOVEL     DREIACsh      GLVAMRIsh                                    TDA084
     C                   MOVEL     DREIACex      GLVAMRIex                                    TDA084
     C                   CLEAR                   GLVAMCO                                     BUG2733
     C                   MOVEL     DRECOMsh      GLVAMCOsh                                   BUG2733
     C                   MOVEL     DRECOMex      GLVAMCOex                                   BUG2733
     C                   CLEAR                   GLVAMPW                                     BUG2733
     C**********         MOVEL     DREAPWsh      GLVAMPWsh                            BUG2733 CSD101
     C**********         MOVEL     DREAPWex      GLVAMPWex                            BUG2733 CSD101
     C/COPY OFCPYSRCZ,CRE101_007                                                              CRE101
     C                   CALLB     'GLAMADUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    RespMode          1
     C                   PARM                    #1DACCNT
     C                   PARM                    #1DACCNTBX
     C**********         PARM                    #1DREIAC                                     TDA084
     C                   PARM                    GLVAMRI                                      TDA084
     C**********         PARM                    #1DRECOM                                    BUG2733
     C                   PARM                    GLVAMCO                                     BUG2733
     C**********         PARM                    #1DREAPW                                    BUG2733
     C                   PARM                    GLVAMPW                                     BUG2733
     C                   PARM                    GLVAMPP                                      CRE015
     C/COPY OFCPYSRCZ,CRE101_021                                                              CRE101
     C                   PARM                    CEU013            1
     C                   PARM                    CRT001            1
     C                   PARM                    CRT002            1
     C                   PARM                    CRE001            1
     C                   PARM                    CRT101            1
     C                   PARM                    CFT004            1
     C                   PARM                    CDE002            1
     C/COPY OFCPYSRCZ,CRE101_008                                                              CRE101
     C                   PARM                    R_FACH            1
     C                   PARM                    R_TSTMC           1
      ** Base Rate Auth req
     C                   PARM                    AUTHRQ            1
      ** Authorisation Mode
     C                   PARM                    AUTHMD            1
      *
      ** IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      ** UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
 B2  C                   IF        @RTCD <> *BLANK
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
      *
 B3  C                   IF        @RTCD =  '*ERROR '
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EXSR      SREND
      *
 X3  C                   ELSE
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
 E3  C                   ENDIF
 E3  C                   ENDIF                                                               BUG5340
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
 
     C/COPY WNCPYSRC,GLAMADC004
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SREnd - End Program                                           *
      *                                                               *
      * Called by: Main routine                                       *
      * Calls    : None                                               *
      *****************************************************************
     C     SREnd         BEGSR
 
      ** Terminate program
 
     C                   EVAL      *INLR = *ON
 
      ** Exit program
 
     C                   RETURN
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *  Calls    :                                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Override GLACSHL0
     C                   Z-ADD     50            CMDLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD
     C                   PARM                    CMDLEN
 
      * Override GLBXSHL0
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD1
     C                   PARM                    CMDLEN
 
      * Override REIASHL0
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD2
     C                   PARM                    CMDLEN
 
      * Override RECMSHL0
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD3
     C                   PARM                    CMDLEN
 
      **Override*REPWSHL0**********************************************                       CSD101
     C**********         CALL      'QCMDEXC'                                                  CSD101
     C**********         PARM                    CMD4                                         CSD101
     C**********         PARM                    CMDLEN                                       CSD101
                                                                                              CRE015
      * Override REPRSHL0                                                                     CRE015
     C                   CALL      'QCMDEXC'                                                  CRE015
     C                   PARM                    CMD5                                         CRE015
     C                   PARM                    CMDLEN                                       CRE015
 
      ** Set up copyright parameter
 
     C                   MOVEA     CPY@          CPY2@
 
      ** Receive entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    RETCODE           7
     C**********         PARM                    PKEY             20                          CGL029
     C                   PARM                    PKEY             26                          CGL029
     C                   PARM                    PACTN             1
     C                   PARM                    ERRMSG            7
     C                   PARM                    @INKC
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'GLAMADAUT'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   OUT       LDA
 
      ** Access SAR details file to determine if CSD012 is on.
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSD012'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD012
     C                   ELSE
     C                   MOVE      'N'           CSD012
     C                   ENDIF
      *
      ** If CSD012 is ON, Check if Account Authorisation is ON
 B1  C     CSD012        IFEQ      'Y'
      *
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD
     C                   PARM      SVALKK        SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM                    SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM                    SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK0           20
     C                   PARM                    SVAL10          200
      *
     C     @RTCD         IFNE      *BLANKS
 
     C     SVAL10        IFEQ      '*NRF'
     C                   MOVE      SVALK0        DBKEY
     C                   ENDIF
     C     SVAL9         IFEQ      '*NRF'
     C                   MOVE      SVALK9        DBKEY
     C                   ENDIF
     C     SVAL8         IFEQ      '*NRF'
     C                   MOVE      SVALK8        DBKEY
     C                   ENDIF
     C     SVAL7         IFEQ      '*NRF'
     C                   MOVE      SVALK7        DBKEY
     C                   ENDIF
     C     SVAL6         IFEQ      '*NRF'
     C                   MOVE      SVALK6        DBKEY
     C                   ENDIF
     C     SVAL5         IFEQ      '*NRF'
     C                   MOVE      SVALK5        DBKEY
     C                   ENDIF
     C     SVAL4         IFEQ      '*NRF'
     C                   MOVE      SVALK4        DBKEY
     C                   ENDIF
     C     SVAL3         IFEQ      '*NRF'
     C                   MOVE      SVALK3        DBKEY
     C                   ENDIF
     C     SVAL2         IFEQ      '*NRF'
     C                   MOVE      SVALK2        DBKEY
     C                   ENDIF
     C     SVAL1         IFEQ      '*NRF'
     C                   MOVE      SVALK1        DBKEY
     C                   ENDIF
 
     C     *LOCK         IN        LDA
     C                   MOVEL     '009'         DBASE
     C                   MOVE      'SDSVALPD'    DBFILE
     C                   MOVE      'GLAMADAUT'   DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If Account Authorisation is On set to Authorise
     C     SVAL11        IFEQ      'Y'
     C                   MOVE      'Y'           AUTHRQ
     C                   ELSE
     C                   MOVE      'N'           AUTHRQ
     C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Access SAR details file to determine if CEU013 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU013'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU013
     C                   ELSE
     C                   MOVEL     'N'           CEU013
     C                   ENDIF
      *
      ** Access SAR details file to determine if CRE001 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRE001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRE001
     C                   ELSE
     C                   MOVEL     'N'           CRE001
     C                   ENDIF
      *
      ** Access SAR details file to determine if CRT001 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT001
     C                   ELSE
     C                   MOVEL     'N'           CRT001
     C                   ENDIF
      *
      ** Access SAR details file to determine if CRT002 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT002
     C                   ELSE
     C                   MOVEL     'N'           CRT002
     C                   ENDIF
      *
      ** Access SAR details file to determine if CRT101 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT101'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT101
     C                   ELSE
     C                   MOVEL     'N'           CRT101
     C                   ENDIF
      *
      ** Access SAR details file to determine if CFT004 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CFT004
     C                   ELSE
     C                   MOVEL     'N'           CFT004
     C                   ENDIF
      *
      ** Access SAR details file to determine if CDE002 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CDE002
     C                   ELSE
     C                   MOVEL     'N'           CDE002
     C                   ENDIF
 
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        @RTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   EVAL      WCMTSK = 'N'                                               CSC022
                                                                                              CSC022
     C                   IN        SCCMTJOB                                                   CSC022
                                                                                              CSC022
     C                   IF        COMITNUM > 0                                               CSC022
                                                                                              CSC022
     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
                                                                                              CSC022
     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
     C                   EVAL      WCMTSK = 'Y'                                               CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
     C                   IF        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 11                                                 CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
      ** Access SAR details file to determine if CRE015 is on                                 CRE015
                                                                                              CRE015
     C                   CALLB     'AOSARDR0'                                                 CRE015
     C                   PARM      *BLANKS       @RTCD                                        CRE015
     C                   PARM      '*VERIFY'     @OPTN                                        CRE015
     C                   PARM      'CRE015'      @SARD                                        CRE015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE015
                                                                                              CRE015
     C     @RTCD         IFEQ      *BLANK                                                     CRE015
     C                   MOVEL     'Y'           CRE015                                       CRE015
     C                   ELSE                                                                 CRE015
     C                   MOVEL     'N'           CRE015                                       CRE015
     C                   ENDIF                                                                CRE015
     C/COPY OFCPYSRCZ,CRE101_009                                                              CRE101
     C/COPY WNCPYSRC,GLH00525
      ** Access Modules details
      ** (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Access Retail III Table file
     C     BGNXST        IFEQ      'Y'
     C     BGNYST        OREQ      'Y'
     C                   OPEN      TABTBRE
     C     1             CHAIN     TABTBRE                            80
     C     *IN80         IFEQ      '1'
     C     R_RECI        ORNE      'D'
     C     *LOCK         IN        LDA
     C                   MOVEL     'TABTBRE '    DBFILE
     C                   MOVEL     '010'         DBASE
     C                   MOVEL     *Blanks       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   CLOSE     TABTBRE
      *
      ** Define key list for file GLACSHL0, RECMDSHL0 and REIASHL0.
     C     RehisKey      KLIST
     C                   KFLD                    KeyBRCA           3
     C*********          KFLD                    KeyCNUM           6 0                        CSD027
     C                   KFLD                    KeyCNUM           6                          CSD027
     C                   KFLD                    KeyCCY            3
     C**********         KFLD                    KeyACOD           4 0                        CGL029
     C                   KFLD                    KeyACOD          10 0                        CGL029
     C                   KFLD                    KeyACSQ           2 0
      *
      ** Define key list for file REPWSHL0, GLBXSHL0.
     C     AccntKey      KLIST
     C                   KFLD                    KeyCNUM
     C                   KFLD                    KeyCCY
     C                   KFLD                    KeyACOD
     C                   KFLD                    KeyACSQ
     C                   KFLD                    KeyBRCA
 
      *                                                                                      BUG5340
      ** Define key list for ACCNTTI                                                         BUG5340
      *                                                                                      BUG5340
     C     WACCNT        KLIST                                                               BUG5340
     C                   KFLD                    #ACBRCA                                     BUG5340
     C                   KFLD                    #ACA5TIAN                                   BUG5340
     C                   KFLD                    #ACA5TIAS                                   BUG5340
     C/COPY WNCPYSRC,GLAMADC001
 
     C                   ENDSR
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      * Removed ** CMD4 OVRDBF FILE(REPWSHL0) TOFILE(REPWSHL0) SHARE(*NO)                     CSD101
**  CPY@
(c) Finastra International Limited 2002
** CMD
OVRDBF FILE(GLACSHL0) TOFILE(GLACSHL0) SHARE(*NO)
** CMD1
OVRDBF FILE(GLBXSHL0) TOFILE(GLBXSHL0) SHARE(*NO)
** CMD2
OVRDBF FILE(REIASHL0) TOFILE(REIASHL0) SHARE(*NO)
** CMD3
OVRDBF FILE(RECMSHL0) TOFILE(RECMSHL0) SHARE(*NO)
** CMD5                                                                                       CRE015
OVRDBF FILE(REPRSHL0) TOFILE(REPRSHL0) SHARE(*NO)                                             CRE015
