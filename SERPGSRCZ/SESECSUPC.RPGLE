     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Security database update controller')         *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECSUPC - Security database update controller              *
      *                                                               *
      *  Function: This module is the main module for Midas database  *
      *            update of security details processed thru the API. *
      *                                                               *
      *  Component of: SESECSUPP                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL032             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 CER001             Date 25Apr05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSC022             Date 24Feb04               *
      *                 CSE037             Date 29Apr02               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 27Nov01               *
      *                 193883             Date 20Nov01               *
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 12Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL032 - Automatic Exchange of Information (Recompile)       *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CSE037 - Countervalue rounding                               *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  193883 - Recompile over changed SESECSUPD.                   *
      *  201589 - Change to check a new locking dataarea SESECSLCK    *
      *           to determine whether this DBU is already active.    *
      *  CSD006 - Market Data Feed                                    *
      *  CSE023 - Treaty Withholding Tax (Recompile)                  *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Valid security details file
     FSEVSECSPD UF   E             DISK    COMMIT
      *
      ** Valid security details file - LF
     FSEVSECSL1 UF   E           K DISK    RENAME(SEVSECSD0:SEVSECSD1)
      *
      ** Valid security details error file
     FSEVESECSPDO    E             DISK    RENAME(SEVSECSD0:SEVSECSERR)
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SESECSU001
                                                                                              CER001
     FSEVSELX2L1UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
     FSEVESEX2PDO    E             DISK    USROPN                                             CER001
     F                                     RENAME(SEVSELXD4:SEVSELXD4R)                       CER001
                                                                                              CER001
     FSEVSELX3L1UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
     FSEVESEX3PDO    E             DISK    USROPN                                             CER001
     F                                     RENAME(SEVSELXD6:SEVSELXD6R)                       CER001
                                                                                              CER001
     FSEVSELX1L1UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
     FSEVESEX1PDO    E             DISK    USROPN                                             CER001
     F                                     RENAME(SEVSELXDL:SEVSELXDLR)                       CER001
                                                                                              CER001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
      *
      /COPY ZACPYSRC,DTAQCHKDCL
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** String for error message to the operator
     D WDBerrUpd       C                   CONST('DB error in SE API update')
      *
      ** String for error message to the operator
     D WProcErr        C                   CONST('Error in module')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
                                                                                              CSC022
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022
      *
      ** DS for SECS data area details
     D SESECSUPC       DS             1    DTAARA(SESECSUPC)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
 
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Externally described DS for Midas Modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for securities trading ICD details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)                    S01117
      *
      ** DS for access programs - first data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs - second data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PDBRN                 11     13
                                                                                              CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PObject         S             10A   INZ('SESECSUPC')
     D PLockObj        S             10A   INZ('SESECSLCK')                                   201589
     D PLib            S             10A   INZ('*LIBL')
     D PObjtype        S              7A   INZ('*DTAARA')
     D PLockStateE     S              7A   INZ('*EXCL')
     D PLockStateS     S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('*CLS')
     D PDlcobj         S              1A
     D PReturn         S              7A
     D PReturn2        S              7A                                                      201589
     D PEndjob         S              1A   INZ('Y')                                           201589
     D WMQError        S             28A
     D PMQErrLong      S            132A
     D PDBError        S             28A
     D PMsgSndRtn      S             10A
     D PReturnCde      S             10A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D CSE007          S              1A
     D CEU017          S              1A
     D S01511          S              1A
     D CSD006          S              1A                                                      CSD006
     D CSE031          S              1A                                                      CSE031
     D CSE037          S              1A                                                      CSE037
     D CSE071          S              1A                                                      CSE071
      *
     D WTimestamp      S             26Z
     D WSecurity       S             10A
      *
      ** Dummy message Id and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
      *
      ** Parameter list for QRCVDTAQ
     D PDtqNam         S             10A
     D PDtqLib         S             10A
     D PDtqLen         S              5P 0
     D PDtqDta         S             10A
     D PDtqWait        S              5P 0
                                                                                              CSC022
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,SESECSU002
      *                                                                                       CER001
      ** New valid extended Secur File                                                        CER001
      *                                                                                       CER001
     D SEVSELX4      E DS                  EXTNAME(SEVSELX2L1)                                CER001
     D SEVSELX4S     E DS                  EXTNAME(SEVSELX2L1)                                CER001
     D                                     PREFIX(SS)                                         CER001
      *                                                                                       CER001
      ** New valid extended Secur File                                                        CER001
      *                                                                                       CER001
     D SEVSELX6      E DS                  EXTNAME(SEVSELX3L1)                                CER001
     D SEVSELX6S     E DS                  EXTNAME(SEVSELX3L1)                                CER001
     D                                     PREFIX(SS)                                         CER001
      *                                                                                       CER001
      ** New valid extended Secur File                                                        CER001
      *                                                                                       CER001
     D SEVSELXL      E DS                  EXTNAME(SEVSELX1L1)                                CER001
     D SEVSELXLS     E DS                  EXTNAME(SEVSELX1L1)                                CER001
     D                                     PREFIX(SS)                                         CER001
                                                                                              CER001
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      /COPY WNCPYSRC,SESECSU003
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DtaQName = 'APSECSDTQ'
      *
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'
      ** message to the data queue if there are not.
      *
      /COPY ZACPYSRC,DTAQCHK
      *
      ** Initialise data queue parms.
      *
     C                   EVAL      PDtqLen = 10
     C                   EVAL      PDtqWait = -1
     C                   EVAL      PDtqNam = 'APSECSDTQ'
     C                   EVAL      PDtqLib = '*LIBL'
     C                   EVAL      PObjType = '*DTAARA'
      *
      ** Wait for data queue prompt.
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file.
      *
     C     PDtqDta       DOWNE     'END'
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    PDtqNam
     C                   PARM                    PDtqLib
     C                   PARM                    PDtqLen
     C                   PARM                    PDtqDta
     C                   PARM                    PDtqWait
      *
     C     PDtqDta       IFEQ      'GO'
      *
      ** Lock allocation data area.
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateE
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcobj
     C                   PARM                    PReturn
      *
      /COPY WNCPYSRC,SESECSU004
      *
      ** Position file cursor to start of file to prevent problems on
      ** later calls.
      *
     C     1             SETLL     SEVSECSPD
      *
      ** Read valid security details.
      *
     C                   READ      SEVSECSD0                              01
      *
     C     *IN01         DOWEQ     '0'
      *
      /COPY WNCPYSRC,SESECSU005
      *
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      ** will include the key information.
      *
     C                   EVAL      ARFOTranID = S1FRNT
     C                   EVAL      ARFOAsocID = *BLANKS
     C                   EVAL      ARRprLocn  = S1REPA
      *
      /COPY WNCPYSRC,SESECSU006
      *
      ** Save key fields.
      *
     C                   EVAL      WSecurity = S1SESN
     C                   EVAL      WTimestamp = S1TMST
      *
      /COPY WNCPYSRC,SESECSU007
      *
      ** Process only insert, amend and delete transactions.
      *
     C                   IF        S1CHTP = 'I' OR S1CHTP = 'A' OR
     C                             S1CHTP = 'D'
      *
      /COPY WNCPYSRC,SESECSU008
      *
      ** Update Security details file.
     C                   CALLB     'SESECSUPD'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Security details for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDSTRD - Extel option
     C                   PARM                    BVEXOP
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - Midas Run Day Number
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Corporate Actions
     C                   PARM                    CSE007
      *
      ** Securities Redenomination
     C                   PARM                    CEU017
      *
      ** Market migration
     C                   PARM                    S01511
      *                                                                                       CSD006
      ** Market Data Feed Switchable Feature                                                  CSD006
     C                   PARM                    CSD006                                       CSD006
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes.                                               CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE037
      ** Countervalue rounding                                                                CSE037
     C                   PARM                    CSE037                                       CSE037
      *                                                                                       CSE071
      ** Multiple Holidays                                                                    CSE071
     C                   PARM                    CSE071                                       CSE071
      *
     C/COPY WNCPYSRC,SESECSUC01
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESECSU009
      *
      ** Check for exception error from any program lower in the stack.
      ** If error detected, send message to system operator, rollback
      ** changes and terminate program.
      *
     C                   IN        APDUMP
      *
      /COPY WNCPYSRC,SESECSU010
      *
     C     ARErrMod      IFNE      *BLANK
     C                   EVAL      PMQErrLong = *BLANK
     C                   MOVEL     WProcErr      WMQError
     C                   MOVE      ARErrMod      WMQError
     C                   MOVEL     WMQError      PMQErrLong
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn
     C                   PARM                    PMQErrLong
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
 
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARErrMod = *BLANK
     C                   OUT       APDUMP
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESECSU011
     C                   IF        S1CHTP = 'I' OR S1CHTP = 'A' OR                            CER001
     C                             S1CHTP = 'D'                                               CER001
      *                                                                                       CER001
      ** Update IML extension files                                                           CER001
      *                                                                                       CER001
     C                   IF        ULX610 = 'Y' and RetCodeOut = *BLANKS                      CER001
      *                                                                                       CER001
     C     S1FRNT        CHAIN     SEVSELX2L1                                                 CER001
     C                   IF        %FOUND                                                     CER001
     C                   CALLB     'SESECS2UP'                                                CER001
     C                   PARM                    S1CHTP                                       CER001
     C                   PARM      *BLANK        RetCodeOut                                   CER001
     C                   PARM      *BLANK        @@FIND            1                          CER001
     C                   PARM                    SEVSELX4                                     CER001
     C                   PARM      *BLANK        SEVSELX4S                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        RetCodeOut = *BLANKS                                       CER001
      *                                                                                       CER001
     C     S1FRNT        CHAIN     SEVSELX3L1                                                 CER001
     C                   IF        %FOUND                                                     CER001
     C                   CALLB     'SESECS3UP'                                                CER001
     C                   PARM                    S1CHTP                                       CER001
     C                   PARM      *BLANK        RetCodeOut                                   CER001
     C                   PARM      *BLANK        @@FIND            1                          CER001
     C                   PARM                    SEVSELX6                                     CER001
     C                   PARM      *BLANK        SEVSELX6S                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Update NEW IBLC extension file                                                       CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y' and RetCodeOut = *BLANKS                      CER001
      *                                                                                       CER001
     C     S1FRNT        CHAIN     SEVSELX1L1                                                 CER001
     C                   IF        %FOUND                                                     CER001
     C                   CALLB     'SESECS4UP'                                                CER001
     C                   PARM                    S1CHTP                                       CER001
     C                   PARM      *BLANK        RetCodeOut                                   CER001
     C                   PARM      *BLANK        @@FIND            1                          CER001
     C                   PARM                    SEVSELXL                                     CER001
     C                   PARM      *BLANK        SEVSELXLS                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      *
      ** Commit updates if no error.
     C                   IF        RetCodeOut = '*ERROR ' OR
     C                             RetCodeOut = '*RECUPD'
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   ELSE
     C                   DELETE    SEVSECSD0
     C/COPY WNCPYSRC,SESECSUC02
      *                                                                                       CER001
      ** Delete IML extension files before COMMIT                                             CER001
      *                                                                                       CER001
     C                   IF        ULX610 = 'Y'                                               CER001
      *                                                                                       CER001
     C     S1FRNT        CHAIN     SEVSELX2L1                                                 CER001
     C                   IF        %FOUND()                                                   CER001
     C                   DELETE    SEVSELXD4                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     S1FRNT        CHAIN     SEVSELX3L1                                                 CER001
     C                   IF        %FOUND()                                                   CER001
     C                   DELETE    SEVSELXD6                                                  CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Delete NEW IBLC extension file before COMMIT                                         CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
      *                                                                                       CER001
     C     S1FRNT        CHAIN     SEVSELX1L1                                                 CER001
     C                   IF        %FOUND()                                                   CER001
     C                   DELETE    SEVSELXDL                                                  CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESECSU012
      *
      ** If an error has occurred, reaccess record in error and remove from
      ** the file to prevent program processing the same record again.
     C                   IF        RetCodeOut = '*ERROR ' OR
     C                             RetCodeOut = '*RECUPD'
 
     C     KSEVL1        CHAIN     SEVSECSL1                          02
      *
      ** Write details of record to error file (same format as SEVSECSPD).
     C                   WRITE     SEVSECSERR
     C                   DELETE    SEVSECSD1
 
     C/COPY WNCPYSRC,SESECSUC03
      *                                                                                       CER001
      ** Write IML extension error files and delete valid ext file                            CER001
      *                                                                                       CER001
     C                   IF        ULX610 = 'Y'                                               CER001
      *                                                                                       CER001
     C     S1FRNT        CHAIN     SEVSELX2L1                                                 CER001
     C                   IF        %FOUND                                                     CER001
     C                   WRITE     SEVSELXD4R                                                 CER001
     C                   DELETE    SEVSELXD4                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     S1FRNT        CHAIN     SEVSELX3L1                                                 CER001
     C                   IF        %FOUND                                                     CER001
     C                   WRITE     SEVSELXD6R                                                 CER001
     C                   DELETE    SEVSELXD6                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Write  NEW IBLC extension error file and delete valid ext file                       CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
      *                                                                                       CER001
     C     S1FRNT        CHAIN     SEVSELX1L1                                                 CER001
     C                   IF        %FOUND                                                     CER001
     C                   WRITE     SEVSELXDLR                                                 CER001
     C                   DELETE    SEVSELXDL                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *
      ** Send message to system operator.
     C                   MOVEL     WDBerrUpd     PDBError
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn
     C                   PARM                    PDBError
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
 
     C                   ENDIF
 
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ** Read valid security details.
     C                   READ      SEVSECSD0                              01
      *
     C                   ENDDO
      *
      ** Unlock allocation data area.
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateE
     C                   PARM                    PMember
     C                   PARM                    PReturn
 
     C                   ENDIF
      *
      ** End loop for data queue prompt.
     C                   ENDDO
      *
      /COPY WNCPYSRC,SESECSU013
      *
      ** Exit from program.
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,SESECSU014
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Define key list for SEVSECSL1.
      *
     C     KSEVL1        KLIST
     C                   KFLD                    WSecurity
     C                   KFLD                    WTimestamp
      *
      *  Check if an existing DBU_SECS job is active in the subsystem.                        201589
                                                                                              201589
     C                   CALL      'SCC0520'                                                  201589
     C                   PARM                    PLockObj                                     201589
     C                   PARM                    PLib                                         201589
     C                   PARM                    PObjType                                     201589
     C                   PARM                    PLockStateE                                  201589
     C                   PARM                    PMember                                      201589
     C                   PARM                    PEndjob                                      201589
     C                   PARM                    PReturn2                                     201589
                                                                                              201589
      **  Lock allocation data area.
      *
      **  The data area is allocated *SHRRD here and *EXCL whilst processing
      **  of the valid file is actually taking place.
      **  The function to submit this updater tries to get a *EXCL lock.
      **  The controller tries to get a *SHRRD lock.
      **
      **                        Submitter             Controller
      **
      **                Lock      Lock     Submitter     Lock     Controller
      **     Status    Status   Successful   Action   Successful    Action
      **     ------    ------   ---------- ---------  ----------  ----------
      **
      **  Not running  None        Yes      Submit       Yes        Prompt
      **                                    updater                 updater
      **  Running not  *SHRRD      No        None        Yes        Prompt
      **   processing                                               updater
      **  Processing   *EXCL       No        None        No         None
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateS
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcobj
     C                   PARM                    PReturn
      *
      ** Create required QTEMP objects.
      *
     C                   CALL      'APCCRTQTO'
     C                   PARM                    PReturnCde
      *
      ** Access Bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   Z-ADD     1             DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas Modules details.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error.
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFile = 'SDMMODPD'
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access ICD details for securities trading.
      *
     C                   CALL      'AOSTRDR0'                                                  S0111
     C                   PARM      *BLANKS       PRTCD                                         S0111
     C                   PARM      '*FIRST '     POPTN                                         S0111
     C     SDSTRD        PARM      SDSTRD        DSSDY                                         S0111
      *
      ** Database error
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDSTRDPD'
     C                   Z-ADD     3             DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE007 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE007'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRtcd         IFNE      *BLANKS
     C     PRtcd         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'CSE007'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     4             DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     PRtcd         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSE007
     C                   ELSE
     C                   MOVEL     'N'           CSE007
     C                   ENDIF
      *
      ** Access SAR file to determine if CEU017 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU017'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRtcd         IFNE      *BLANKS
     C     PRtcd         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'CEU017'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     5             DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     PRtcd         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU017
     C                   ELSE
     C                   MOVEL     'N'           CEU017
     C                   ENDIF
      *
      ** Access SAR file to determine if S01511 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01511'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRtcd         IFNE      *BLANKS
     C     PRtcd         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'S01511'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     6             DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     PRtcd         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01511
     C                   ELSE
     C                   MOVEL     'N'           S01511
     C                   ENDIF
      *                                                                                       CSD006
      ** Access SAR details file to determine if MDF Switchable feature                       CSD006
      ** is switched on                                                                       CSD006
      *                                                                                       CSD006
     C                   CALLB     'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD             6                          CSD006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD006
     C     @RTCD         IFEQ      *BLANK                                                     CSD006
     C                   MOVEL     'Y'           CSD006            1                          CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVEL     'N'           CSD006                                       CSD006
     C                   END                                                                  CSD006
                                                                                              CSD006
      *                                                                                       CSE031
      ** Access SAR file to determine if CSE031                                               CSE031
      ** (Coupon Fixing for Floating Rate Notes) is installed.                                CSE031
      *                                                                                       CSE031
     C                   CALLB     'AOSARDR0'                                                 CSE031
     C                   PARM      *BLANKS       PRtcd                                        CSE031
     C                   PARM      '*VERIFY'     POptn                                        CSE031
     C                   PARM      'CSE031'      PSARD                                        CSE031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE031
      *                                                                                       CSE031
      ** An NRF (No Record Found) return code is valid.                                       CSE031
      ** Issue database error only for error return codes.                                    CSE031
      *                                                                                       CSE031
     C                   IF        PRtcd <> *BLANKS AND                                       CSE031
     C                             PRtcd <> '*NRF   '                                         CSE031
     C     *LOCK         IN        LDA                                                        CSE031
     C                   EVAL      DBKey = 'CSE031'                                           CSE031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSE031
     C                   Z-ADD     7             DBase                                        CSE031
     C                   OUT       LDA                                                        CSE031
     C                   EXSR      *PSSR                                                      CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        PRtcd = *BLANKS                                            CSE031
     C                   EVAL      CSE031 = 'Y'                                               CSE031
     C                   ELSE                                                                 CSE031
     C                   EVAL      CSE031 = 'N'                                               CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
      *                                                                                       CSE037
      ** Access SAR details file to determine if Countervalue rounding                        CSE037
      ** is switched on                                                                       CSE037
      *                                                                                       CSE037
     C                   CALLB     'AOSARDR0'                                                 CSE037
     C                   PARM      *BLANKS       @RTCD                                        CSE037
     C                   PARM      '*VERIFY'     @OPTN                                        CSE037
     C                   PARM      'CSE037'      @SARD                                        CSE037
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE037
     C     @RTCD         IFEQ      *BLANK                                                     CSE037
     C                   MOVEL     'Y'           CSE037                                       CSE037
     C                   ELSE                                                                 CSE037
     C                   MOVEL     'N'           CSE037                                       CSE037
     C                   END                                                                  CSE037
                                                                                              CSE037
      ** Access SAR details file to determine if CSE071 is installed                          CSE071
      *                                                                                       CSE071
     C                   CALLB     'AOSARDR0'                                                 CSE071
     C                   PARM      *BLANKS       @RTCD                                        CSE071
     C                   PARM      '*VERIFY'     @OPTN                                        CSE071
     C                   PARM      'CSE071'      @SARD                                        CSE071
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE071
                                                                                              CSE071
     C     @RTCD         IFEQ      *BLANK                                                     CSE071
     C                   MOVE      'Y'           CSE071                                       CSE071
     C                   ELSE                                                                 CSE071
     C                   MOVE      'N'           CSE071                                       CSE071
     C                   ENDIF                                                                CSE071
      *
      ** Get ZMUSER information.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,SESECSU015
      *                                                                                       CER001
      ** Access Module Details to verify if Lux Return feature is                             CER001
      ** active                                                                               CER001
      *                                                                                       CER001
     C                   CALL      'AOMMODR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*FIRST '     @OPTN                                        CER001
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER001
      *                                                                                       CER001
      ** ULX610 - API Luxembourg - Function SESECS                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX610            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX610'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD  = *BLANKS  AND                                      CER001
     C                             BGLRIN = 'Y'                                               CER001
     C                   EVAL      ULX610  = 'Y'                                              CER001
     C                   OPEN      SEVSELX2L1                                                 CER001
     C                   OPEN      SEVSELX3L1                                                 CER001
     C                   OPEN      SEVESEX2PD                                                 CER001
     C                   OPEN      SEVESEX3PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX043 - NEW IBLC                                                                    CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX043            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD  = *BLANKS  AND                                      CER001
     C                             ULX610 = 'Y'                                               CER001
     C                   EVAL      ULX043  = 'Y'                                              CER001
     C                   OPEN      SEVSELX1L1                                                 CER001
     C                   OPEN      SEVESEX1PD                                                 CER001
     C                   ENDIF                                                                CER001
      *
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       PRTCD                                        CSC022
     C                   Parm      '*VERIFY'     POPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C                   If        PRtCd = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   Eval      WCommitSkip = 'N'                                          CSC022
      *                                                                                       CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
     C                   MoveA     ComitJob      WCmtJobArr                                   CSC022
      *                                                                                       CSC022
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                  CSC022
     C                   If        *IN87 = *ON                                                CSC022
     C                   Eval      WCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** If return code <> *NRF, call program exception error routine                         CSC022
      *                                                                                       CSC022
     C                   If        PRtCd <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 8                                                  CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
