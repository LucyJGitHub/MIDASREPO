     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account database update controller')          *
      *****************************************************************
      *                                                               *
      *  Midas - GL General ILE Module                                *
      *                                                               *
      *  GLAMADUPC - GL Account Database Update Controller            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE090             Date 14Feb14               *
      *  Prev Amend No. AR1095876          Date 30Sep13               *
      *                 AR1037730          Date 15Oct12               *
      *                 AR899028           Date 25Jan12               *
      *                 AR847269           Date 09Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CER042             Date 11May11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE015             Date 18Dec09               *
      *                 CAP205             Date 04Jan10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243973             Date 15Sep06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 CAP086             Date 08Jun05               *
      *                 LLN022             Date 24Jan05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CSD012             Date 15Oct02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 198865             Date 25Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 190343             Date 07Dec01               *
      *                 193883             Date 20Nov01               *
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 10Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 23Aug99               *
      *                 CFT004             Date 05Nov99               *
      *                 CAP035  *CREATE    Date 10May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE090 - Delay Capitalisation of Interest (Recompile)        *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  AR1037730 - Trigger error due to object lock                 *
      *              (Child:AR1037731)                                *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179) (Recompile)                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  243973 - to add missing account master extension record      *
      *           within file GLACNTQD, for accounts coming from      *
      *           MQSeries API Interface.                             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD012 - Standing Data Authorisation                         *
      *  208221 - Default Margin from Rate/Spread changes (Recompile) *
      *  198865 - Attempt to write duplicate to RECOMD.               *
      *  190343 - Recompile over changed GLAMADUPD.                   *
      *  193883 - Recompile over changed GLAMADUPD.                   *
      *  201589 - Change to check a new locking dataarea GLAMADLCK    *
      *           to determine whether this DBU is already active.    *
      *  CDE002 - CCRM Revenue Analysis - Addition of Margin Int. Flds*
      *  CPB001 - Meridian DBA Middleware Replication Customisation.  *
      *           Recompiled due to database changes.                 *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers                  *
      *  CAP035 - Midas API Conversion for ToF                        *
      *                                                               *
      *****************************************************************
     FGLVAMADPD UF   E             DISK
     F                                     COMMIT
     F***GLVAMBXL0 UF   E           K DISK                                                    CGL029
     FGLVAMBXL2 UF   E           K DISK                                                       CGL029
     F                                     COMMIT
     F***GLVAMRIL0 UF   E           K DISK                                                    CGL029
     FGLVAMRIL2 UF   E           K DISK                                                       CGL029
     F                                     COMMIT
     F***GLVAMCOL0 UF   E           K DISK                                                    CGL029
     FGLVAMCOL2 UF   E           K DISK                                                       CGL029
     F                                     COMMIT
     F***GLVAMPWL0 UF   E           K DISK                                                    CGL029
     FGLVAMPWL2 UF   E           K DISK                                                       CGL029
     F                                     COMMIT
     FGLVAMPPL2 UF   E           K DISK                                                       CRE015
     F                                     COMMIT                                             CRE015
     FGLVAMADL1 UF   E           K DISK
     F                                     RENAME(GLVAMADD0:GLVAMADD1)
     FGLVAMBXL1 UF   E           K DISK
     F                                     RENAME(GLVAMBXD0:GLVAMBXD1)
     FGLVAMRIL1 UF   E           K DISK
     F                                     RENAME(GLVAMRID0:GLVAMRID1)
     FGLVAMCOL1 UF   E           K DISK
     F                                     RENAME(GLVAMCOD0:GLVAMCOD1)
     FGLVAMPWL1 UF   E           K DISK
     F                                     RENAME(GLVAMPWD0:GLVAMPWD1)
     FGLVAMPPL1 UF   E           K DISK                                                       CRE015
     F                                     RENAME(GLVAMPPD0:GLVAMPPD1)                        CRE015
     FGLVEAMADPDO    E             DISK
     F                                     RENAME(GLVAMADD0:GLVAMADERR)
     FGLVEAMBXPDO    E             DISK
     F                                     RENAME(GLVAMBXD0:GLVAMBXERR)
     FGLVEAMRIPDO    E             DISK
     F                                     RENAME(GLVAMRID0:GLVAMRIERR)
     FGLVEAMCOPDO    E             DISK
     F                                     RENAME(GLVAMCOD0:GLVAMCOERR)
     FGLVEAMPWPDO    E             DISK
     F                                     RENAME(GLVAMPWD0:GLVAMPWERR)
     FGLVEAMPPPDO    E             DISK                                                       CRE015
     F                                     RENAME(GLVAMPPD0:GLVAMPPERR)                       CRE015
      ** Retail III Table file
     FTABTBRE   IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(R_)
                                                                                              243973
      ** Account Master Extension File.                                                       243973
     FGLACNTL3  UF A E           K DISK    INFSR(*PSSR)                                       243973
     F                                     USROPN                                          AR1037730
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,GLAMADU008
                                                                                              CER001
     FGLVAMLX1L1UF   E           K DISK    USROPN                                             CER001
     F                                     COMMIT                                             CER001
     FGLVEAMX1PDO    E             DISK    USROPN                                             CER001
     F                                     RENAME(GLVAMLXD6:GLVAMLXD6R)                       CER001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in ACCN API update')
 
      *****************************************************************
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID SECURITY
     D GLVAMAD       E DS                  EXTNAME(GLVAMADPD)
     D GLVAMBX       E DS                  EXTNAME(GLVAMBXPD)
     D GLBXACOD      E                     EXTFLD(QQACOD)                                     CGL029
     D GLVAMRI       E DS                  EXTNAME(GLVAMRIPD)
     D GLRIACOD      E                     EXTFLD(QQACOD)                                     CGL029
     D GLVAMCO       E DS                  EXTNAME(GLVAMCOPD)
     D GLCOACOD      E                     EXTFLD(QQACOD)                                     CGL029
     D GLVAMPW       E DS                  EXTNAME(GLVAMPWPD)
     D GLPWACOD      E                     EXTFLD(QQACOD)                                     CGL029
     D GLVAMPP       E DS                  EXTNAME(GLVAMPPPD)                                 CRE015
 
     D GLAMADUPC       DS             1    DTAARA(GLAMADUPC)
 
      **  Data Structure for AOSVALR0 string                                                  CSD012
     DSVAL1            DS           200                                                       CSD012
     DSVAL11                   1      1                                                       CSD012
                                                                                              CSD012
      ** Fields Defined for CSD012                                                            CSD012
     D CSD012          S              1A                                                      CSD012
     D SVALKK          C                   CONST('AuthReqAccntMaint')                         CSD012
                                                                                              CSD012
      ** Override SDAULGL0                                                                    CSD012
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
 
     D Object          S             10A   INZ('GLAMADUPC')
     D LockObj         S             10A   INZ('GLAMADLCK')                                   201589
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockStateE      S              7A   INZ('*EXCL')
     D LockStateS      S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('*CLS')
     D Dlcobj          S              1A
     D Return          S              7A
     D Return2         S              7A                                                      201589
     D Endjob          S              1A   INZ('Y')                                           201589
     D @Timestamp      S             26Z
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Key fields for access to L1 files
     D @BRCA           S                   LIKE(AMBRCA)
     D @CNUM           S                   LIKE(AMCNUM)
     D @CCY            S                   LIKE(AMCCY)
     D @ACOD           S                   LIKE(AMACOD)
     D @ACSQ           S                   LIKE(AMACSQ)
 
      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX2           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX3           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX4           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX5           S              1    DIM(50) CTDATA PERRCD(50)
     D ##OX6           S              1    DIM(50) CTDATA PERRCD(50)                          CRE015
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,GLAMADU009
                                                                                              CER001
      ** New valid extended SD Customer File                                                  CER001
     D GLVAMLX6      E DS                  EXTNAME(GLVAMLX1L1)                                CER001
     D GLVAMLX6S     E DS                  EXTNAME(REACX1PD)                                  CER001
     D                                     PREFIX(SS)                                         CER001
                                                                                              CER001
     D ULX004          S              1A                                                      CER001
     D ULX606          S              1A                                                      CER001
                                                                                              CER001
     D @TYPE           S              1A                                                      CER001
     D @@FIND          S              1A                                                      CER001
     D @Return         S              6A                                                      CER001
     D @FrontID        S                   LIKE(AMFRNT)                                       CER001
 
      *******************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *******************************************************************
 
      /COPY WNCPYSRC,GLAMADU001
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APAMADDTQ'
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
 
      *  Initialise Data queue parms
     C                   EVAL      DtqLen = 10
     C                   EVAL      DtqWait = -1
     C                   EVAL      DtqNam = 'APAMADDTQ'
     C                   EVAL      DtqLib = '*LIBL'
     C                   EVAL      ObjType = '*DTAARA'
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file
     C     DtqDta        DOWNE     'END'
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam           10
     C                   PARM                    DtqLib           10
     C                   PARM                    DtqLen            5 0
     C                   PARM                    DtqDta           10
     C                   PARM                    DtqWait           5 0
     C     DtqDta        IFEQ      'GO'
      *  Lock allocation data area
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      /COPY WNCPYSRC,GLAMADU002
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     GLVAMADPD
 
      ** READ VALID ACCOUNT
     C                   READ      GLVAMADD0                              80
     C     *IN80         DOWEQ     '0'
 
      /COPY WNCPYSRC,GLAMADU003
 
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lower level modules
      **  will include the key information
     C**********         EVAL      FrontOff   = AMFRNT                                        CGL029
     C                   EVAL      FrontOff   = AMFRNT + AMAFRT                               CGL029
     C                   EVAL      ARFOTranID = AMFRNT
     C                   EVAL      ARFOAsocID = AMAFRT
     C                   EVAL      ARRprLocn  = AMREPA
 
      /COPY WNCPYSRC,GLAMADU004
 
      ** GET EXTENSION FILE DETAILS
 
     C                   CLEAR                   GLVAMBX
     C                   CLEAR                   GLVAMRI
     C                   CLEAR                   GLVAMCO
     C                   CLEAR                   GLVAMPW
     C                   CLEAR                   GLVAMPP                                      CRE015
 
 
      /COPY WNCPYSRC,GLAMADU005
      *                                                                                       CER001
     C     ULX606        IFNE      'Y'                                                        CER001
      *                                                                                       CER001
 
     C*****@KeyAccnL0    CHAIN     GLVAMBXL0                          81                      CGL029
     C     @KeyAccnL0    CHAIN     GLVAMBXL2                          81                      CGL029
 
     C*****@KeyAccnL0    CHAIN     GLVAMRIL0                          81                      CGL029
     C     @KeyAccnL0    CHAIN     GLVAMRIL2                          81                      CGL029
 
     C*****@KeyAccnL0    CHAIN     GLVAMCOL0                          81                      CGL029
     C     @KeyAccnL0    CHAIN     GLVAMCOL2                          81                      CGL029
 
     C     *IN81         IFEQ      *ON                                          198865
     C*****AMCNUM        ANDNE     *ZERO                                               198865 CSD027
     C     AMCNUM        ANDNE     *BLANKS                                                    CSD027
     C     AMCCY         ANDNE     *BLANK                                       198865
     C     AMACOD        ANDNE     *ZERO                                        198865
     C     AMACSQ        ANDNE     *ZERO                                        198865
     C     AMBRCA        ANDNE     *BLANK                                       198865
     C**********         Z-ADD     AMCNUM        COCNUM                                198865 CSD027
     C                   EVAL      COCNUM = AMCNUM                                            CSD027
     C                   Move      AMCCY         COCCY                          198865
     C                   Z-ADD     AMACOD        COACOD                         198865
     C                   Z-ADD     AMACSQ        COACSQ                         198865
     C                   Move      AMBRCA        COBRCA                         198865
     C                   ENDIF                                                  198865
      *                                                                         198865
     C*****@KeyAccnL0    CHAIN     GLVAMPWL0                          81                      CGL029
     C     @KeyAccnL0    CHAIN     GLVAMPWL2                          81                      CGL029
                                                                                              CRE015
     C     @KeyAccnL0    CHAIN     GLVAMPPL2                          81                      CRE015
 
      ** ACCOUNT DATABASE UPDATE
     C                   CALLB     'GLAMADUPD'
     C                   PARM      *BLANK        @@RTCD            7
     C                   PARM      'A'           RespMode          1
     C                   PARM                    GLVAMAD
     C                   PARM                    GLVAMBX
     C                   PARM                    GLVAMRI
     C                   PARM                    GLVAMCO
     C                   PARM                    GLVAMPW
     C                   PARM                    GLVAMPP                                      CRE015
     C                   PARM                    CEU013
     C                   PARM                    CRT001
     C                   PARM                    CRT002
     C                   PARM                    CRE001
     C                   PARM                    CRT101
     C                   PARM                    CFT004                         CFT004
     C                   PARM                    CDE002                         CDE002
     C                   PARM                    R_FACH
     C                   PARM                    R_TSTMC
      * Base Rate Auth Req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
 
     C/COPY WNCPYSRC,GLAMADUC01
      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C                   ROLBK
     C                   ELSE
     C                   DELETE    GLVAMADD0
     C*****@KeyAccnL0    CHAIN     GLVAMBXL0                          81                      CGL029
     C     @KeyAccnL0    CHAIN     GLVAMBXL2                          81                      CGL029
     C  N81              DELETE    GLVAMBXD0
     C*****@KeyAccnL0    CHAIN     GLVAMRIL0                          81                      CGL029
     C     @KeyAccnL0    CHAIN     GLVAMRIL2                          81                      CGL029
     C  N81              DELETE    GLVAMRID0
     C*****@KeyAccnL0    CHAIN     GLVAMCOL0                          81                      CGL029
     C     @KeyAccnL0    CHAIN     GLVAMCOL2                          81                      CGL029
     C  N81              DELETE    GLVAMCOD0
     C*****@KeyAccnL0    CHAIN     GLVAMPWL0                          81                      CGL029
     C     @KeyAccnL0    CHAIN     GLVAMPWL2                          81                      CGL029
     C  N81              DELETE    GLVAMPWD0
     C     @KeyAccnL0    CHAIN     GLVAMPPL2                          81                      CRE015
     C  N81              DELETE    GLVAMPPD0                                                  CRE015
                                                                                              243973
      ** Add record within Account Master Extension File (done from Java layer).              243973
     C                   IF        AMCHTP = 'I'                                               243973
     C                   EXSR      WriteACNTQD                                                243973
     C                   END                                                                  243973
                                                                                              243973
     C/COPY WNCPYSRC,GLAMADUC02
     C                   COMMIT
     C                   END
 
      /COPY WNCPYSRC,GLAMADU006
      *                                                                                       CER001
      ** ULX606 - API Luxembourg - Function GLAMAD                                            CER001
      *                                                                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
     C     @KeyAccnL0    CHAIN     GLVAMBXL2                          81                      CER001
                                                                                              CER001
     C     @KeyAccnL0    CHAIN     GLVAMRIL2                          81                      CER001
                                                                                              CER001
     C     @KeyAccnL0    CHAIN     GLVAMCOL2                          81                      CER001
                                                                                              CER001
     C     @KeyAccnL0    CHAIN     GLVAMPWL2                          81                      CER001
                                                                                              CRE015
     C     @KeyAccnL0    CHAIN     GLVAMPPL2                          81                      CRE015
                                                                                              CER001
      ** ACCOUNT DATABASE UPDATE                                                              CER001
     C                   CALLB     'GLAMADUPD'                                                CER001
     C                   PARM      *BLANK        @@RTCD                                       CER001
     C                   PARM      'A'           RespMode                                     CER001
     C                   PARM                    GLVAMAD                                      CER001
     C                   PARM                    GLVAMBX                                      CER001
     C                   PARM                    GLVAMRI                                      CER001
     C                   PARM                    GLVAMCO                                      CER001
     C                   PARM                    GLVAMPW                                      CER001
     C                   PARM                    GLVAMPP                                      CRE015
     C                   PARM                    CEU013                                       CER001
     C                   PARM                    CRT001                                       CER001
     C                   PARM                    CRT002                                       CER001
     C                   PARM                    CRE001                                       CER001
     C                   PARM                    CRT101                                       CER001
     C                   PARM                    CFT004                                       CER001
     C                   PARM                    CDE002                                       CER001
     C                   PARM                    R_FACH                                       CER001
     C                   PARM                    R_TSTMC                                      CER001
      * Base Rate Auth Req                                                                    CER001
     C                   PARM                    AUTHRQ                                       CER001
      * Authorisation Mode                                                                    CER001
     C                   PARM                    AUTHMD                                       CER001
      *                                                                                       CER001
     C                   IF        @@RTCD = *blank                                            CER001
      *                                                                                       CER001
     C                   DELETE    GLVAMADD0                                                  CER001
     C     @KeyAccnL0    CHAIN     GLVAMBXL2                          81                      CER001
     C  N81              DELETE    GLVAMBXD0                                                  CER001
     C     @KeyAccnL0    CHAIN     GLVAMRIL2                          81                      CER001
     C  N81              DELETE    GLVAMRID0                                                  CER001
     C     @KeyAccnL0    CHAIN     GLVAMCOL2                          81                      CER001
     C  N81              DELETE    GLVAMCOD0                                                  CER001
     C     @KeyAccnL0    CHAIN     GLVAMPWL2                          81                      CER001
     C  N81              DELETE    GLVAMPWD0                                                  CER001
     C     @KeyAccnL0    CHAIN     GLVAMPPL2                          81                      CRE015
     C  N81              DELETE    GLVAMPPD0                                                  CRE015
      *                                                                                       CER001
      *                                                                                       CER001
     C                   CLEAR                   GLVAMLX6                                     CER001
     C                   CLEAR                   GLVAMLX6S                                    CER001
      *                                                                                       CER001
     C     @KeyAccnL0    CHAIN     GLVAMLX1L1                         89                      CER001
      *                                                                                       CER001
      ** Extension files update                                                               CER001
      ** No physical delete on extension files, it is done during                             CER001
      ** COB when system 'purge' master files                                                 CER001
      *                                                                                       CER001
     C                   IF        AMCHTP = 'I' or                                            CER001
     C                             AMCHTP = 'A'                                               CER001
      *                                                                                       CER001
      ** Retrieve Extended valid record                                                       CER001
      *                                                                                       CER001
     C                   IF        ULX606 = 'Y' And                                           CER001
     C                             ULX004 = 'Y'                                               CER001
      *                                                                                       CER001
      ** not update extended file if the action code is amend and                             CER001
      ** action is done via Meridian.                                                         CER001
      *                                                                                       CER001
     C                   IF        AMCHTP = 'A' And                                           CER001
     C                             @TYPE  = '0'                                               CER001
     C                   MOVE      *BLANK        @@RTCD                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      ** GL Extended database update                                                          CER001
      *                                                                                       CER001
     C                   CALLB     'GLAMAD6UP'                                                CER001
     C                   PARM                    AMCHTP                                       CER001
     C                   PARM      *BLANK        @@RTCD                                       CER001
     C                   PARM      *BLANK        @@FIND                                       CER001
     C                   PARM                    GLVAMLX6                                     CER001
     C                   PARM                    GLVAMLX6S                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      * Put here other extension....                                                          CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @@RTCD = *Blanks                                           CER001
     C                   DELETE    GLVAMLXD6                                                  CER001
                                                                                              243973
      ** Add record within Account Master Extension File (done from Java layer).              243973
     C                   IF        AMCHTP = 'I'                                               243973
     C                   EXSR      WriteACNTQD                                                243973
     C                   END                                                                  243973
                                                                                              243973
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      *                                                                                       CER001
      ** COMIT Updates if no error                                                            CER001
      *                                                                                       CER001
      *                                                                                       CER001
     C                   IF        @@RTCD = '*ERROR ' OR                                      CER001
     C                             @@RTCD = '*RECUPD'                                         CER001
     C                   ROLBK                                                                CER001
     C                   ELSE                                                                 CER001
     C                   COMMIT                                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If an error has occurred, remove record in error from                                CER001
      ** the file and write details of record to error valid file                             CER001
      *                                                                                       CER001
     C                   IF        ULX606 = 'Y' AND                                           CER001
     C                             ULX004 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   IF        @@RTCD = '*ERROR ' OR                                      CER001
     C                             @@RTCD = '*RECUPD'                                         CER001
      *                                                                                       CER001
     C                   WRITE     GLVAMLXD6R                                                 CER001
     C                   DELETE    GLVAMLXD6                                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C                   EVAL      @BRCA = AMBRCA
     C                   EVAL      @CNUM = AMCNUM
     C                   EVAL      @CCY  = AMCCY
     C                   EVAL      @ACOD = AMACOD
     C                   EVAL      @ACSQ = AMACSQ
     C                   EVAL      @Timestamp = AMTMST
     C     @KeyAccnL1    CHAIN     GLVAMADL1                          89
     ** Write details of record to error file (same format as GLVAMADPD)
     C                   WRITE     GLVAMADERR
     C                   DELETE    GLVAMADD1
     C     @KeyAccnL1    CHAIN     GLVAMBXL1                          89
     ** Write details of record to error file (same format as GLVAMBXPD)
     C     *IN89         IFEQ      '0'
     C                   WRITE     GLVAMBXERR
     C                   DELETE    GLVAMBXD1
     C                   END
     C     @KeyAccnL1    CHAIN     GLVAMRIL1                          89
     ** Write details of record to error file (same format as GLVAMRIPD)
     C     *IN89         IFEQ      '0'
     C                   WRITE     GLVAMRIERR
     C                   DELETE    GLVAMRID1
     C                   END
     C     @KeyAccnL1    CHAIN     GLVAMCOL1                          89
     ** Write details of record to error file (same format as GLVAMCOPD)
     C     *IN89         IFEQ      '0'
     C                   WRITE     GLVAMCOERR
     C                   DELETE    GLVAMCOD1
     C                   END
     C     @KeyAccnL1    CHAIN     GLVAMPWL1                          89
     ** Write details of record to error file (same format as GLVAMPWPD)
     C     *IN89         IFEQ      '0'
     C                   WRITE     GLVAMPWERR
     C                   DELETE    GLVAMPWD1
     C                   END
                                                                                              CRE015
     C     @KeyAccnL1    CHAIN     GLVAMPPL1                          89                      CRE015
     C     *IN89         IFEQ      '0'                                                        CRE015
     C                   WRITE     GLVAMPPERR                                                 CRE015
     C                   DELETE    GLVAMPPD1                                                  CRE015
     C                   END                                                                  CRE015
     C/COPY WNCPYSRC,GLAMADUC03
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** READ VALID ACCOUNTS
     C                   READ      GLVAMADD0                              80
     C                   END
     ** Unlock allocation data area
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Return
     C                   END
      ** End loop for data queue prompt
     C                   END
 
      /COPY WNCPYSRC,GLAMADU007
 
      * EXIT FROM PROGRAM
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,GLAMADU010
 
      *****************************************************************                       243973
      /EJECT                                                                                  243973
      *****************************************************************                       243973
      *                                                               *                       243973
      * WriteACNTQD - WRITE Account Master Extension record (done     *                       243973
      *               from Java layer).                               *                       243973
      *                                                               *                       243973
      *****************************************************************                       243973
     C     WriteACNTQD   BEGSR                                                                243973
                                                                                              243973
      ** When opening new accounts in ACCNTAB, write a corresponding                          243973
      ** record in the account details extension file GLACNTQD.                               243973
                                                                                              243973
     C     @KeyAcntL3    KLIST                                                                243973
     C                   KFLD                    AMCNUM                                       243973
     C                   KFLD                    AMCCY                                        243973
     C                   KFLD                    AMACOD                                       243973
     C                   KFLD                    AMACSQ                                       243973
     C                   KFLD                    AMBRCA                                       243973
                                                                                              243973
     C                   OPEN      GLACNTL3                                                AR1037730
     C     @KeyAcntL3    CHAIN     GLACNTD0                           82                      243973
                                                                                              243973
     C     *IN82         IFEQ      *ON                                                        243973
     C                   EVAL      F1CNUM = AMCNUM                                            243973
     C                   EVAL      F1CCY  = AMCCY                                             243973
     C                   EVAL      F1ACOD = AMACOD                                            243973
     C                   EVAL      F1ACSQ = AMACSQ                                            243973
     C                   EVAL      F1BRCA = AMBRCA                                            243973
     C                   EVAL      F1FCHD = *ZEROS                                            243973
     C                   EVAL      F1LFCD = *ZEROS                                            243973
     C                   EVAL      F1ACBL = *ZEROS                                            243973
     C                   EVAL      F1TEXO = *ZEROS                                            243973
     C                   EVAL      F1TEOF = *ZEROS                                            243973
     C                   EVAL      F1TEOC = *ZEROS                                            243973
     C                   WRITE     GLACNTD0                                                   243973
                                                                                              243973
     C                   ENDIF                                                                243973
     C                   CLOSE     GLACNTL3                                                AR1037730
                                                                                              243973
     C                   ENDSR                                                                243973
      *****************************************************************                       243973
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
                                                                                              CSD012
      * Override SDAULGL0                                                                     CSD012
     C                   Z-ADD     50            CMDLEN           15 5                        CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD                                          CSD012
     C                   PARM                    CMDLEN                                       CSD012
      *
      *  Check if an existing DBU_AMAD job is active in the subsystem.                        201589
                                                                                              201589
     C                   CALL      'SCC0520'                                                  201589
     C                   PARM                    LockObj                                      201589
     C                   PARM                    Lib                                          201589
     C                   PARM                    ObjType                                      201589
     C                   PARM                    LockStateE                                   201589
     C                   PARM                    Member                                       201589
     C                   PARM                    Endjob                                       201589
     C                   PARM                    Return2                                      201589
                                                                                              201589
      ** Determine whether program is running interactively or in batch                       CER001
      **  ( 0 = batch   1 = interactive)                                                      CER001
      *                                                                                       CER001
     C                   CALLB     'ZARTVJOBA'                                                CER001
     C                   PARM                    @Return                                      CER001
     C                   PARM                    @TYPE                                        CER001
      *                                                                                       CER001
      ** Access SAR details file to determine if CEU013
      ** (EMU Account Postings Narrative) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CEU013'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU013            1
     C                   ELSE
     C                   MOVEL     'N'           CEU013
     C                   END
      *
      ** Access SAR details file to determine if CRE001
      ** (Overdraft Interest Calculations) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRE001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRE001            1
     C                   ELSE
     C                   MOVEL     'N'           CRE001
     C                   END
      *
      ** Access SAR details file to determine if CRT101
      ** (Password on Retail Account Facility) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT101'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT101            1
     C                   ELSE
     C                   MOVEL     'N'           CRT101
     C                   END
      *                                                                         CFT004
      ** Access SAR details file to determine if CFT004                         CFT004
      ** (International Bank Account Number) is on.                             CFT004
      *                                                                         CFT004
     C                   CALLB     'AOSARDR0'                                   CFT004
     C                   PARM      *BLANKS       @RTCD                          CFT004
     C                   PARM      '*VERIFY'     @OPTN                          CFT004
     C                   PARM      'CFT004'      @SARD                          CFT004
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT004
      *                                                                         CFT004
     C     @RTCD         IFEQ      *BLANK                                       CFT004
     C                   MOVEL     'Y'           CFT004            1            CFT004
     C                   ELSE                                                   CFT004
     C                   MOVEL     'N'           CFT004                         CFT004
     C                   END                                                    CFT004
      *
      ** Access SAR details file to determine if CDE002 is on.                  CDE002
      *                                                                         CDE002
     C                   CALLB     'AOSARDR0'                                   CDE002
     C                   PARM      *BLANKS       @RTCD                          CDE002
     C                   PARM      '*VERIFY'     @OPTN                          CDE002
     C                   PARM      'CDE002'      @SARD                          CDE002
     C     SCSARD        PARM      SCSARD        DSFDY                          CDE002
                                                                                CDE002
     C     @RTCD         IFEQ      *BLANK                                       CDE002
     C                   MOVEL     'Y'           CDE002            1            CDE002
     C                   ELSE                                                   CDE002
     C                   MOVEL     'N'           CDE002                         CDE002
     C                   END                                                    CDE002
      *                                                                         CDE002
      ** Access SAR details file to determine if CRT001
      ** (Retail Teller System) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT001            1
     C                   ELSE
     C                   MOVEL     'N'           CRT001
     C                   END
      *
      ** Access SAR details file to determine if CRT002
      ** (Retail Branch Access) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT002            1
     C                   ELSE
     C                   MOVEL     'N'           CRT002
     C                   END
                                                                                              CRE015
      ** Determine if 'Term and Notice Account' is installed                                  CRE015
                                                                                              CRE015
     C                   CALLB     'AOSARDR0'                                                 CRE015
     C                   PARM      *BLANKS       @RTCD                                        CRE015
     C                   PARM      '*VERIFY'     @OPTN                                        CRE015
     C                   PARM      'CRE015'      @SARD                                        CRE015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE015
      *                                                                                       CRE015
     C     @RTCD         IFEQ      *BLANK                                                     CRE015
     C                   MOVEL     'Y'           CRE015            1                          CRE015
     C                   ELSE                                                                 CRE015
     C                   MOVEL     'N'           CRE015                                       CRE015
     C                   END                                                                  CRE015
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Retail III Table file
     C     BGNXST        IFEQ      'Y'
     C     BGNYST        OREQ      'Y'
     C                   READ      TABTBRE                                80
     C     *IN80         IFEQ      '1'
     C     R_RECI        ORNE      'D'
     C     *LOCK         IN        LDA
     C                   MOVEL     'TABTBRE '    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     *Blanks       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD012
      ** Access SAR details file to determine if CSD012                                       CSD012
      ** (Standing Data Authorisation) is on.                                                 CSD012
      *                                                                                       CSD012
     C                   CALLB     'AOSARDR0'                                                 CSD012
     C                   PARM      *BLANKS       @RTCD                                        CSD012
     C                   PARM      '*VERIFY'     @OPTN                                        CSD012
     C                   PARM      'CSD012'      @SARD                                        CSD012
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD012
      *                                                                                       CSD012
     C     @RTCD         IFEQ      *BLANK                                                     CSD012
     C                   MOVE      'Y'           CSD012                                       CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           CSD012                                       CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
      ** If CSD012 is ON, Check if Account Authorisation is ON                                CSD012
 B1  C     CSD012        IFEQ      'Y'                                                        CSD012
      *                                                                                       CSD012
     C                   CALL      'AOSVALR0'                                                 CSD012
     C                   PARM                    @RTCD                                        CSD012
     C                   PARM      SVALKK        SVALK1           20                          CSD012
     C                   PARM                    SVAL1           200                          CSD012
     C                   PARM                    SVALK2           20                          CSD012
     C                   PARM                    SVAL2           200                          CSD012
     C                   PARM                    SVALK3           20                          CSD012
     C                   PARM                    SVAL3           200                          CSD012
     C                   PARM                    SVALK4           20                          CSD012
     C                   PARM                    SVAL4           200                          CSD012
     C                   PARM                    SVALK5           20                          CSD012
     C                   PARM                    SVAL5           200                          CSD012
     C                   PARM                    SVALK6           20                          CSD012
     C                   PARM                    SVAL6           200                          CSD012
     C                   PARM                    SVALK7           20                          CSD012
     C                   PARM                    SVAL7           200                          CSD012
     C                   PARM                    SVALK8           20                          CSD012
     C                   PARM                    SVAL8           200                          CSD012
     C                   PARM                    SVALK9           20                          CSD012
     C                   PARM                    SVAL9           200                          CSD012
     C                   PARM                    SVALK0           20                          CSD012
     C                   PARM                    SVAL10          200                          CSD012
      *                                                                                       CSD012
     C     @RTCD         IFNE      *BLANKS                                                    CSD012
                                                                                              CSD012
     C     SVAL10        IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK0        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL9         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK9        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL8         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK8        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL7         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK7        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL6         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK6        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL5         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK5        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL4         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK4        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL3         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK3        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL2         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK2        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL1         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK1        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
     C     *LOCK         IN        LDA                                                        CSD012
     C                   Z-ADD     3             DBASE                                        CSD012
     C                   MOVE      'SDSVALPD'    DBFILE                                       CSD012
     C                   MOVE      'GLAMADUPC'   DBPGM                                        CSD012
     C                   OUT       LDA                                                        CSD012
     C                   EXSR      *PSSR                                                      CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** If Account Authorisation is On set to Authorise                                      CSD012
     C     SVAL11        IFEQ      'Y'                                                        CSD012
     C                   MOVE      'Y'           AUTHRQ            1                          CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           AUTHRQ                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
 E1  C                   ENDIF                                                                CSD012
      *
      *  Define key list for L0
     C     @KeyAccnL0    KLIST
     C**********         KFLD                    FrontOff         20                          CGL029
     C                   KFLD                    FrontOff         40                          CGL029
 
      *  Define key list for L1
     C     @KeyAccnL1    KLIST
     C                   KFLD                    @BRCA
     C                   KFLD                    @CNUM
     C                   KFLD                    @CCY
     C                   KFLD                    @ACOD
     C                   KFLD                    @ACSQ
     C                   KFLD                    @Timestamp
 
 
      *  Lock allocation data area
 
      *   The data area is allocated *SHRRD here and *EXCL whilst processing
      *    of the valid file is actually taking place.
      *   The function to submit this updater tries to get a *EXCL lock.
      *   The controller tries to get a *SHRRD lock.
 
      *                         Submitter             Controller
      *                 Lock      Lock     Submitter     Lock     Controller
      *      Status    Status   Successful   Action   Successful    Action
      *      ------    ------   ---------- ---------  ----------  ----------
      *   Not running  None        Yes      Submit       Yes        Prompt
      *                                     updater                 updater
 
      *   Running not  *SHRRD      No        None        Yes        Prompt
      *    processing                                               updater
 
      *   Processing   *EXCL       No        None        No         None
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateS
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      ** Create required QTEMP objects
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde        10
 
     C* Overrride ACCBR
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
     C* Overrride ACCNTL0
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX2
     C                   PARM                    MESLEN
     C* Overrride REIAC
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX3
     C                   PARM                    MESLEN
     C* Overrride RECOM
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX4
     C                   PARM                    MESLEN
     C* Overrride REAPWDL0
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX5
     C                   PARM                    MESLEN
     C* Override REPRSHL0                                                                     CRE015
     C                   CALL      'QCMDEXC'                                                  CRE015
     C                   PARM                    ##OX6                                        CRE015
     C                   PARM                    MESLEN                                       CRE015
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,GLAMADU011
      *                                                                                       CER001
      ** ULX004 - European Reporting as Feature                                               CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX004                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   MOVEL     'Y'           ULX004                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX606 - API Luxembourg - Function GLAMAD                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX606                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX606'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   MOVEL     'Y'           ULX606                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX606 = 'Y' AND                                           CER001
     C                             ULX004 = 'Y'                                               CER001
     C                   OPEN      GLVAMLX1L1                                                 CER001
     C                   OPEN      GLVEAMX1PD                                                 CER001
     C                   ENDIF                                                                CER001
 
     C                   ENDSR
     C****************************************************************
      /EJECT
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** ##OX1
OVRDBF FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)
** ##OX2
OVRDBF FILE(ACCNTL1) TOFILE(ACCNTL0) SHARE(*NO)
** ##OX3
OVRDBF FILE(REIACXX) TOFILE(REIAC) SHARE(*NO)
** ##OX4
OVRDBF FILE(RECOMXX) TOFILE(RECOM) SHARE(*NO)
** ##OX5
OVRDBF FILE(REAPWDL1) TOFILE(REAPWDL0) SHARE(*NO)
** CMD
OVRDBF FILE(SDAULGL0) TOFILE(SDAULGL0) SHARE(*NO)
** ##OX6                                                                                      CRE015
OVRDBF FILE(REPRSHL1) TOFILE(REPRSHL0) SHARE(*NO)                                             CRE015
