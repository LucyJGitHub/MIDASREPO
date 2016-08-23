     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade database update controller')            *
      *****************************************************************
      *                                                               *
      *  Midas - SE Securities Trading Module                         *
      *                                                               *
      *  SETRADUPC - SE TRADES DATABASE UPDATE CONTROLLER             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSW210             Date 04May10               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22911           Date 17Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 CGL031             Date 05Jul04               *
      *                 222373             Date 23Oct03               *
      *                 CSE045             Date 24Mar03               *
      *                 CAS006             Date 21Jan03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210517             Date 21Nov02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067             Date 24Sep01               *
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 16Nov99               *
      *                 CPB001             Date 17Aug99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 17Mar99               *
      *                 154562             Date 01Feb99               *
      *                 CAP006             Date 19Jan99               *
      *                 CAP003  *CREATE    Date 15JUL98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CGL031 - Taxation of Savings Income                          *
      *  222373 - Parameter Mismatch                                  *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  210517 - Missing TRADSDX2 record from the API                *
      *  CAP067 - Repurchase Agreements API.                          *
      *  201589 - Change to check a new locking dataarea SETRADLCK    *
      *           to determine whether this DBU is already active.    *
      *  CSE023 - Treaty Withholding Tax. (Recompiled)                *
      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *  154562 - Only 1 record is needed on TRADSDX1 if CSW003 is off*
      *  CAP006 - Send prompt to DTAQ to restart update process after *
      *           failure.                                            *
      *  CAP003 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FSEVTRADPD UF   E             DISK
     F                                     COMMIT
     FSEVTRX1L0 UF   E           K DISK
     F                                     COMMIT
     FSEVTRX2L0 UF   E           K DISK                                                       CSE045
     F                                     COMMIT                                             CSE045
     FSEVTRADL1 UF   E           K DISK
     F                                     RENAME(SEVTRADD0:SEVTRADD1)
     FSEVTRX1L1 UF   E           K DISK
     F                                     RENAME(SEVTRX1PD0:SEVTRX1D1)
     FSEVETRADPDO    E             DISK
     F                                     RENAME(SEVTRADD0:SEVTRADERR)
     FSEVETRX1PDO    E             DISK
     F                                     RENAME(SEVTRX1PD0:SEVTRX1ERR)
     FSEVETRX2PDO    E             DISK                                                       CSE045
     F                                     RENAME(SEVTRX2D0:SEVTRX2ERR)                       CSE045
     FSEVTRX2L1 UF   E           K DISK                                                       CSE045
     F                                     RENAME(SEVTRX2D0:SEVTRX2D1)                        CSE045
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SETRADU008
      *                                                                                       CER001
     FSEVTDLX1L1UF   E           K DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
     FSEVETDX1PDO    E             DISK    USROPN                                             CER001
     F                                     RENAME(SEVTDLXD6:SEVTDLXD6R)                       CER001
      *                                                                                       CER001
 
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
 
      **------------------------------------------------------------------------CAP006--------------
      ** The following /COPY line includes the definitions for fields           CAP006
      ** used in checking whether there are messages on the data queue.         CAP006
     D/COPY ZACPYSRC,DTAQCHKDCL                                                 CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006
      *                                                                                       CAP067
      ** The following /COPY line includes the definitions for error and                      CAP067
      ** warning message arrays.                                                              CAP067
     D/COPY ZACPYSRC,ERR_ARRAYS                                                               CAP067
      *                                                                                       CAP067
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in TRAD API update')
                                                                                CAP006
     D Command         DS                                                       CAP006
      ** OVRDBF command for QCMDEXC to run                                      CAP006
     D                         1     26    INZ('OVRDBF TRADSDY1 SHARE(*NO)')    CAP006
 
      *****************************************************************
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID SECURITY
     D SEVTRD        E DS                  EXTNAME(SEVTRADPD)
     D SEVTRDX1      E DS                  EXTNAME(SEVTRX1PD)
     D SEVTRDX2      E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
     D SEVTRDX1A     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(A_)
     D SEVTRDX1B     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(B_)
     D SEVTRD1       E DS                  EXTNAME(SEVTRADPD)                                 CAP067
     D                                     PREFIX(W1)                                         CAP067
     D SEVTRDX1A1    E DS                  EXTNAME(SEVTRX1PD)                                 CAP067
     D                                     PREFIX(WA)                                         CAP067
     D SEVTRDX1B1    E DS                  EXTNAME(SEVTRX1PD)                                 CAP067
     D                                     PREFIX(WB)                                         CAP067
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)                                  CAP067
      ** Book Details                                                                         CAP067
     D SEVTRDX2A     E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
     D                                     PREFIX(A_)                                         CSE045
     D SEVTRDX2B     E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
     D                                     PREFIX(B_)                                         CSE045
 
     D SETRADUPC       DS             1    DTAARA(SETRADUPC)
 
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D PMCWL           DS          9999                                                       CSD015
      ** Additional entry parameter for Midas Compliance Watch                                CSD015
 
 
     D Object          S             10A   INZ('SETRADUPC')
     D LockObj         S             10A   INZ('SETRADLCK')                                   201589
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
                                                                                CAP006
      ** Command length for QCMDEXC                                             CAP006
     D CommandLen      S             15P 5 INZ(26)                              CAP006
 
     D Idx             S              3P 0                                                    CAP067
                                                                                              210517
     D PMODE           S              3A                                                      210517
 
     D ULX603          S              1A   INZ('N')                                           CER001
     D CAS006          S              1                                                       CAS006
     D PRTCD           S              7                                                       CAS006
     D POPTN           S              7                                                       CAS006
     D PSARD           S              6                                                       CAS006
                                                                                              CAS006
     D CGL031          S              1A                                                      CGL031
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SETRADU009
      *                                                                                       CER001
      ** External data structures for Midas Modules                                           CER001
      *                                                                                       CER001
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CER001
      *                                                                                       CER001
      ** New valid extended Trade File                                                        CER001
      *                                                                                       CER001
     D SEVTDLX6      E DS                  EXTNAME(SEVTDLX1L1)                                CER001
     D SEVTDLX6S     E DS                  EXTNAME(SEVTDLX1L1)                                CER001
     D                                     PREFIX(SS)                                         CER001
 
      *******************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *******************************************************************
 
      /COPY WNCPYSRC,SETRADU001
 
      ** Set up the name of the server/database updater data queue.             CAP006
     C                   EVAL      DtaQName = 'APTRADDTQ'                       CAP006
                                                                                CAP006
      **------------------------------------------------------------------------CAP006--------------
      ** The following /COPY line includes a check for whether there            CAP006
      ** are messages on the server/updater data queue, and sends a 'GO'.       CAP006
      ** message to the data queue if there are not.                            CAP006
     D/COPY ZACPYSRC,DTAQCHK                                                    CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006
      *  Initialise Data queue parms
     C                   EVAL      DtqLen = 10
     C                   EVAL      DtqWait = -1
     C                   EVAL      DtqNam = 'APTRADDTQ'
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
 
      /COPY WNCPYSRC,SETRADU002
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     SEVTRADPD
 
      ** READ VALID SE TRADE
     C                   READ      SEVTRADD0                              99    *
     C     *IN99         DOWEQ     '0'
 
      /COPY WNCPYSRC,SETRADU003
 
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lower level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = FRNT
     C                   EVAL      ARFOAsocID = AFRT
     C                   EVAL      ARRprLocn  = REPA
 
      /COPY WNCPYSRC,SETRADU004
 
      ** GET EXTENSION FILE DETAILS (RECORDS A & B)
 
     C                   CLEAR                   SEVTRDX1A
     C                   CLEAR                   SEVTRDX1B
     C                   CLEAR                   SEVTRDX2A                                    CSE045
     C                   CLEAR                   SEVTRDX2B                                    CSE045
 
 
      /COPY WNCPYSRC,SETRADU005
      *                                                                                       CER001
      ** ULX603 - API Luxembourg - Function SETRAD                                            CER001
      *                                                                                       CER001
     C     ULX603        IFNE      'Y'                                          B1            CER001
      *                                                                                       CER001
 
     C     CSW003        IFEQ      'Y'                                          154562
     C                   EVAL      T1WHEN = 'A'
     C                   ELSE                                                   154562
     C                   EVAL      T1WHEN = ' '                                 154562
     C                   END                                                    154562
     C     @KeyTrx1L0    CHAIN     SEVTRX1L0                          98
     C  N98              EVAL      SEVTRDX1A = SEVTRDX1
     C                   IF        CSE045 = 'Y'                                               CSE045
     C     @KeyTrx1L0    CHAIN     SEVTRX2L0                          98                      CSE045
     C  N98              EVAL      SEVTRDX2A = SEVTRDX2                                       CSE045
     C                   ENDIF                                                                CSE045
 
     C                   EVAL      T1WHEN = 'B'
     C     @KeyTrx1L0    CHAIN     SEVTRX1L0                          98
     C  N98              EVAL      SEVTRDX1B = SEVTRDX1
     C                   IF        CSE045 = 'Y'                                               CSE045
     C     @KeyTrx1L0    CHAIN     SEVTRX2L0                          98                      CSE045
     C  N98              EVAL      SEVTRDX2B = SEVTRDX2                                       CSE045
     C                   ENDIF                                                                CSE045
 
      ** SE DATABASE UPDATE
     C                   CALLB     'SETRADUPD'
     C                   PARM      *BLANK        @@RTCD            7
     C                   PARM                    SEVTRD
     C                   PARM                    SEVTRDX1A
     C                   PARM                    SEVTRDX1B
     C                   PARM                    S01401            1
     C                   PARM                    CSW003            1            154562
     C                   PARM                    CAP051            1            CAP051
     C                   PARM                    CAS006                                       CAS006
     C                   PARM                    CGL031                                       CGL031
     C                   PARM      'UPC'         PMODE                                        210517
                                                                                              CSD015
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
     C                   PARM                    SEVTRDX2A                                    CSE045
     C                   PARM                    SEVTRDX2B                                    CSE045
     C/COPY WNCPYSRC,SETRADUC01
 
      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
     C                   ROLBK
     C                   ELSE
      *                                                                                       CAP067
      ** If MM Repos enhancement is installed and trade is a                                  CAP067
      ** leg of a buy sell back, then save link reference and                                 CAP067
      ** book code processed.                                                                 CAP067
      *                                                                                       CAP067
     C                   EVAL      WLinkRef = *BLANKS                                         CAP067
     C                   EVAL      WChTp = *BLANK                                             CAP067
     C                   EVAL      Idx = *ZERO                                                CAP067
      *                                                                                       CAP067
     C                   IF        CAP067 = 'Y'                                               CAP067
     C                   EVAL      WLinkRef = LKRF                                            CAP067
     C                   EVAL      WChTp = CHTP                                               CAP067
     C                   EVAL      WBook = TDBK                                               CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
     C                   DELETE    SEVTRADD0
     C     CSW003        IFEQ      'Y'                                          154562
     C                   EVAL      T1WHEN = 'A'
     C                   ELSE                                                   154562
     C                   EVAL      T1WHEN = ' '                                 154562
     C                   END                                                    154562
     C     @KeyTrx1L0    CHAIN     SEVTRX1L0                          98
     C  N98              DELETE    SEVTRX1PD0
     C                   IF        CSE045 = 'Y'                                               CSE045
     C     @KeyTrx1L0    CHAIN     SEVTRX2L0                          98                      CSE045
     C  N98              DELETE    SEVTRX2D0                                                  CSE045
     C                   ENDIF                                                                CSE045
     C                   EVAL      T1WHEN = 'B'
     C     @KeyTrx1L0    CHAIN     SEVTRX1L0                          98
     C  N98              DELETE    SEVTRX1PD0
     C                   IF        CSE045 = 'Y'                                               CSE045
     C     @KeyTrx1L0    CHAIN     SEVTRX2L0                          98                      CSE045
     C  N98              DELETE    SEVTRX2D0                                                  CSE045
     C                   ENDIF                                                                CSE045
     C/COPY WNCPYSRC,SETRADUC02
      *                                                                                       CAP067
      ** Delete, approve or authorise the other side of buy-sell                              CAP067
      ** if action is the same for the first buy-sell back.                                   CAP067
      *                                                                                       CAP067
     C                   IF        WLinkRef <> *BLANKS AND                                    CAP067
     C                             (WCHTP = 'D' OR                                            CAP067
     C                             WCHTP = 'P' OR                                             CAP067
     C                             WCHTP = 'Y')                                               CAP067
     C                   EXSR      SRBuySell                                                  CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
      ** If there are errors encountered, roll back changes                                   CAP067
      *                                                                                       CAP067
     C                   IF        Idx <> *ZERO                                               CAP067
     C                   EVAL      @@RTCD = '*ERROR'                                          CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
     C                   IF        @@RTCD = '*ERROR' OR                                       CAP067
     C                             @@RTCD = '*RECUPD'                                         CAP067
     C                   ROLBK                                                                CAP067
     C                   ELSE                                                                 CAP067
     C                   COMMIT
     C                   ENDIF                                                                CAP067
     C                   END
 
      /COPY WNCPYSRC,SETRADU006
      *                                                                                       CER001
     C                   ELSE                                                   X1            CER001
      *                                                                                       CER001
      ** Master files update                                                                  CER001
      *                                                                                       CER001
     C     CSW003        IFEQ      'Y'                                                        CER001
     C                   EVAL      T1WHEN = 'A'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      T1WHEN = ' '                                               CER001
     C                   END                                                                  CER001
      *                                                                                       CER001
     C     @KeyTrx1L0    CHAIN     SEVTRX1L0                          98                      CER001
     C  N98              EVAL      SEVTRDX1A = SEVTRDX1                                       CER001
                                                                                              CER001
     C                   EVAL      T1WHEN = 'B'                                               CER001
     C     @KeyTrx1L0    CHAIN     SEVTRX1L0                          98                      CER001
     C  N98              EVAL      SEVTRDX1B = SEVTRDX1                                       CER001
      *                                                                                       CER001
     C                   CALLB     'SETRADUPD'                                                CER001
     C                   PARM      *BLANKS       @@RTCD                                       CER001
     C                   PARM                    SEVTRD                                       CER001
     C                   PARM                    SEVTRDX1A                                    CER001
     C                   PARM                    SEVTRDX1B                                    CER001
     C                   PARM                    S01401            1                          CER001
     C                   PARM                    CSW003            1                          CER001
     C                   PARM                    CAP051            1                          CER001
     C                   PARM                    CAS006                                       CER001
     C                   PARM      'UPC'         PMODE                                        CER001
     C                   PARM                    PMCWL                                        CER001
     C                   PARM                    SEVTRDX2A                                    CER001
     C                   PARM                    SEVTRDX2B                                    CER001
      *                                                                                       CER001
     C     @@RTCD        IFEQ      *BLANKS                                      B2            CER001
      *                                                                                       CER001
     C                   DELETE    SEVTRADD0                                                  CER001
      *                                                                                       CER001
     C     CSW003        IFEQ      'Y'                                                        CER001
     C                   EVAL      T1WHEN = 'A'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      T1WHEN = ' '                                               CER001
     C                   END                                                                  CER001
      *                                                                                       CER001
     C     @KeyTrx1L0    CHAIN     SEVTRX1L0                          98                      CER001
     C  N98              DELETE    SEVTRX1PD0                                                 CER001
     C                   EVAL      T1WHEN = 'B'                                               CER001
     C     @KeyTrx1L0    CHAIN     SEVTRX1L0                          98                      CER001
     C  N98              DELETE    SEVTRX1PD0                                                 CER001
      *                                                                                       CER001
      *                                                                                       CER001
      ** Extension files update                                                               CER001
      ** For SE, no physical delete on extension files, it is done during                     CER001
      ** COB when system 'purge' SE master files                                              CER001
      *                                                                                       CER001
     C     K@KEY1        CHAIN     SEVTDLX1L1                         89                      CER001
      *                                                                                       CER001
     C     CHTP          IFEQ      'I'                                          B3            CER001
     C     CHTP          OREQ      'A'                                                        CER001
      *                                                                                       CER001
      ** Retrieve Extended valid records                                                      CER001
      *                                                                                       CER001
     C     ULX603        IFEQ      'Y'                                          B4            CER001
      *                                                                                       CER001
     C                   CALLB     'SETRAD2UP'                                                CER001
     C                   PARM                    CHTP                                         CER001
     C                   PARM      *BLANK        @@RTCD                                       CER001
     C                   PARM      *BLANK        @@FIND            1                          CER001
     C                   PARM                    SEVTDLX6                                     CER001
     C                   PARM      *BLANK        SEVTDLX6S                                    CER001
      *                                                                                       CER001
     C                   ENDIF                                                  E4            CER001
      *                                                                                       CER001
      ** Put here other extension....                                                         CER001
      *                                                                                       CER001
     C                   ENDIF                                                  E3            CER001
      *                                                                                       CER001
     C     @@RTCD        IFEQ      *BLANK                                       B5            CER001
     C                   DELETE    SEVTDLXD6                                                  CER001
     C                   ENDIF                                                  E5            CER001
      *                                                                                       CER001
     C                   ENDIF                                                  E2            CER001
      *                                                                                       CER001
      *                                                                                       CER001
      ** COMIT Updates if no error                                                            CER001
      *                                                                                       CER001
      *                                                                                       CER001
     C     @@RTCD        IFEQ      '*ERROR '                                    B2            CER001
     C     @@RTCD        OREQ      '*RECUPD'                                                  CER001
     C                   ROLBK                                                                CER001
     C                   ELSE                                                   X2            CER001
     C                   COMMIT                                                               CER001
     C                   ENDIF                                                  E2            CER001
      *                                                                                       CER001
     C                   ENDIF                                                  E1            CER001
      *                                                                                       CER001
      ** If an error has occurred, reaccess record in error and remove from                   CER001
      ** the file and write details of record to error valid file                             CER001
      *                                                                                       CER001
     C     ULX603        IFEQ      'Y'                                          B1            CER001
      *                                                                                       CER001
     C     @@RTCD        IFEQ      '*ERROR '                                    B2            CER001
     C     @@RTCD        OREQ      '*RECUPD'                                                  CER001
      *                                                                                       CER001
     C     K@KEY1        CHAIN     SEVTDLX1L1                         89                      CER001
      *                                                                                       CER001
     C                   WRITE     SEVTDLXD6R                                                 CER001
     C                   DELETE    SEVTDLXD6                                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                  E2            CER001
      *                                                                                       CER001
     C                   ENDIF                                                  E1            CER001
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
     C                   EVAL      @TradeRef  = TDRF
     C                   EVAL      @Timestamp = TMST
     C     @KeyTradL1    CHAIN     SEVTRADL1                          89
     ** Write details of record to error file (same format as SEVTRADPD)
     C                   WRITE     SEVTRADERR
     C                   DELETE    SEVTRADD1
     C                   EVAL      @When = 'A'
     C     @KeyTrx1L1    CHAIN     SEVTRX1L1                          89
     ** Write details of record to error file (same format as SEVTRX1PD)
     C     *IN89         IFEQ      '0'
     C                   WRITE     SEVTRX1ERR
     C                   DELETE    SEVTRX1D1
     C                   END
     C                   IF        CSE045 = 'Y'                                               CSE045
     C     @KeyTrx1L1    CHAIN     SEVTRX2L1                          89                      CSE045
     ** Write details of record to error file (same format as SEVTRX2PD)                      CSE045
     C     *IN89         IFEQ      '0'                                                        CSE045
     C                   WRITE     SEVTRX2ERR                                                 CSE045
     C                   DELETE    SEVTRX2D1                                                  CSE045
     C                   ENDIF                                                                CSE045
     C                   ENDIF                                                                CSE045
     C                   EVAL      @When = 'B'
     C     @KeyTrx1L1    CHAIN     SEVTRX1L1                          89
     ** Write details of record to error file (same format as SEVTRX1PD)
     C     *IN89         IFEQ      '0'
     C                   WRITE     SEVTRX1ERR
     C                   DELETE    SEVTRX1D1
     C                   END
     C                   IF        CSE045 = 'Y'                                               CSE045
     C     @KeyTrx1L1    CHAIN     SEVTRX2L1                          89                      CSE045
     ** Write details of record to error file (same format as SEVTRX2PD)                      CSE045
     C     *IN89         IFEQ      '0'                                                        CSE045
     C                   WRITE     SEVTRX2ERR                                                 CSE045
     C                   DELETE    SEVTRX2D1                                                  CSE045
     C                   ENDIF                                                                CSE045
     C                   ENDIF                                                                CSE045
     C/COPY WNCPYSRC,SETRADUC03
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** READ VALID SE TRADES
     C                   READ      SEVTRADD0                              99    *
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
 
      /COPY WNCPYSRC,SETRADU007
 
      * EXIT FROM PROGRAM
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SETRADU010
      *                                                                                       CAP067
      *****************************************************************                       CAP067
      /EJECT                                                                                  CAP067
      *****************************************************************                       CAP067
      *                                                               *                       CAP067
      *  SRBuySell - Process other side of buy-sell back              *                       CAP067
      *                                                               *                       CAP067
      *****************************************************************                       CAP067
      *                                                                                       CAP067
     C     SRBuySell     BEGSR                                                                CAP067
      *                                                                                       CAP067
      ** Check first if book code is buy-sell back book code.                                 CAP067
      *                                                                                       CAP067
     C                   CALL      'AOBOOKR0'                                                 CAP067
     C                   PARM      *BLANKS       @RTCD             7                          CAP067
     C                   PARM      '*KEY   '     @OPTN             7                          CAP067
     C                   PARM                    WBook             2                          CAP067
     C     SDBOOK        PARM      SDBOOK        DSFDY                                        CAP067
      *                                                                                       CAP067
     C     BDBYSL        IFEQ      'Y'                                                        CAP067
      *                                                                                       CAP067
      ** Initialise records                                                                   CAP067
      *                                                                                       CAP067
     C                   CLEAR                   SEVTRD1                                      CAP067
     C                   CLEAR                   SEVTRDX1A1                                   CAP067
     C                   CLEAR                   SEVTRDX1B1                                   CAP067
      *                                                                                       CAP067
      ** Get trade details                                                                    CAP067
      *                                                                                       CAP067
     C                   CALLB     'SETRADRTV'                                                CAP067
      *                             =========                                                 CAP067
      ** INPUTS                                                                               CAP067
      *  ======                                                                               CAP067
      *                                                                                       CAP067
      ** Return code                                                                          CAP067
     C                   PARM      *BLANK        RetCodeOut                                   CAP067
      *                                                                                       CAP067
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                                 CAP067
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                             CAP067
     C                   PARM      *BLANKS       @@MODE            6                          CAP067
      *                                                                                       CAP067
      ** Response mode                                                                        CAP067
     C                   PARM      *BLANK        @@RSMD            1                          CAP067
      *                                                                                       CAP067
      ** Action Code                                                                          CAP067
     C                   PARM                    WCHTP             1                          CAP067
      *                                                                                       CAP067
      ** Front Office Transaction ID                                                          CAP067
     C                   PARM      *BLANKS       FOTRID           20                          CAP067
      *                                                                                       CAP067
      ** (Midas) Trade Reference                                                              CAP067
     C                   PARM                    WLinkRef          6                          CAP067
      *                                                                                       CAP067
      ** MT5XX - Phase 2 Message Generation is on.                                            CAP067
     C                   PARM                    CSW003                                       CAP067
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      ** Trade Reference                                                                      CAP067
     C                   PARM                    PFTDRF            6                          CAP067
      *                                                                                       CAP067
      ** OUTPUTS                                                                              CAP067
      *  =======                                                                              CAP067
      *                                                                                       CAP067
      ** (Current) TRADE in file format                                                       CAP067
     C                   PARM                    SEVTRD1                                      CAP067
     C                   PARM                    SEVTRDX1A1                                   CAP067
     C                   PARM                    SEVTRDX1B1                                   CAP067
      *                                                                                       CAP067
      ** OK - Action code                                                                     CAP067
     C                   PARM      *BLANK        DDACTNOK          1                          CAP067
      *                                                                                       CAP067
      ** OK - Trade Reference                                                                 CAP067
     C                   PARM      *BLANK        DDTDRFOK          1                          CAP067
      *                                                                                       CAP067
      ** Error fields/message IDs/message data (arrays) from/to caller                        CAP067
     C                   PARM      *BLANKS       FldNameArr                                   CAP067
     C                   PARM      *BLANKS       MsgIdArr                                     CAP067
     C                   PARM      *BLANKS       MsgDtaArr                                    CAP067
      *                                                                                       CAP067
      ** Array index (3P0) from/to caller                                                     CAP067
     C                   PARM      *ZERO         Idx                                          CAP067
      *                                                                                       CAP067
      ** If there no errors present, perform update of the second                             CAP067
      ** deal.                                                                                CAP067
      *                                                                                       CAP067
     C                   IF        Idx = *ZEROS                                               CAP067
     C                   EVAL      W1CHTP = WCHTP                                             CAP067
      *                                                                                       CAP067
     C                   CALLB     'SETRADUPD'                                                CAP067
     C                   PARM      *BLANK        @@RTCD                                       CAP067
     C                   PARM                    SEVTRD1                                      CAP067
     C                   PARM                    SEVTRDX1A1                                   CAP067
     C                   PARM                    SEVTRDX1B1                                   CAP067
     C                   PARM                    S01401                                       CAP067
     C                   PARM                    CSW003                                       CAP067
     C                   PARM                    CAP051                                       CAP067
     C                   PARM                    CAS006                                       CAS006
     C                   PARM                    CGL031                                       CGL031
     C                   PARM      'UPC'         PMODE                                        210517
                                                                                              CSD015
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
     C                   PARM                    SEVTRDX2A                                    222373
     C                   PARM                    SEVTRDX2B                                    222373
      *                                                                                       CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
     C                   ENDSR                                                                CAP067
 
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
 
      *  Define key list for SEVTRX1L0
     C     @KeyTrx1L0    KLIST
     C                   KFLD                    FRNT
     C                   KFLD                    T1WHEN
 
      *  Define key list for SEVTRADL1
     C     @KeyTradL1    KLIST
     C                   KFLD                    @TradeRef         6
     C                   KFLD                    @Timestamp
 
      *  Define key list for SEVTRX1L1
     C     @KeyTrx1L1    KLIST
     C                   KFLD                    @TradeRef         6
     C                   KFLD                    @When             1
     C                   KFLD                    @Timestamp
      *                                                                                       CER001
      ** Define key list for SEVTDLX1L1                                                       CER001
      *                                                                                       CER001
     C     K@KEY1        KLIST                                                                CER001
     C                   KFLD                    FRNT                                         CER001
     C                   KFLD                    TMST                                         CER001
 
      *  Check if an existing DBU_TRAD job is active in the subsystem.                        201589
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
                                                                                CAP006
      ** Override SE Extension file (used in *UPD and *RTV modules)             CAP006
                                                                                CAP006
     C                   CALL      'QCMDEXC'                                    CAP006
     C                   PARM                    Command                        CAP006
     C                   PARM                    CommandLen                     CAP006
      *
      ** Access SAR details file to determine if S01401
      ** (MT5XX Message Generation) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'S01401'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01401            1
     C                   ELSE
     C                   MOVEL     'N'           S01401
     C                   END
      *                                                                         154562
      ** Access SAR details file to determine if CSW003                         154562
      ** (MT5XX - Phase 2 Message Generation) is on.                            154562
      *                                                                         154562
     C                   CALLB     'AOSARDR0'                                   154562
     C                   PARM      '*BLANKS'     @RTCD                          154562
     C                   PARM      '*VERIFY'     @OPTN                          154562
     C                   PARM      'CSW003'      @SARD                          154562
     C     SCSARD        PARM      SCSARD        DSFDY                          154562
      *                                                                         154562
     C     @RTCD         IFEQ      *BLANK                                       154562
     C                   MOVE      'Y'           CSW003            1            154562
     C                   ELSE                                                   154562
     C                   MOVE      'N'           CSW003                         154562
     C                   ENDIF                                                  154562
      *                                                                         CAP051
      ** Access SAR details file to determine if CAP051 is on.                  CAP051
      ** (Automatic Authorisation (SE Trades Part))                             CAP051
      *                                                                         CAP051
     C                   CALLB     'AOSARDR0'                                   CAP051
     C                   PARM      *BLANKS       @RTCD                          CAP051
     C                   PARM      '*VERIFY'     @OPTN                          CAP051
     C                   PARM      'CAP051'      @SARD                          CAP051
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
      *                                                                         CAP051
     C     @RTCD         IFEQ      *BLANK                                       CAP051
     C                   MOVEL     'Y'           CAP051            1            CAP051
     C                   ELSE                                                   CAP051
     C                   MOVEL     'N'           CAP051                         CAP051
     C                   END                                                    CAP051
      *                                                                                       CAP067
      ** Access SAR details file to determine if CAP067 is on.                                CAP067
      ** MM Repos API.                                                                        CAP067
      *                                                                                       CAP067
     C                   CALLB     'AOSARDR0'                                                 CAP067
     C                   PARM      *BLANKS       @RTCD                                        CAP067
     C                   PARM      '*VERIFY'     @OPTN                                        CAP067
     C                   PARM      'CAP067'      @SARD                                        CAP067
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP067
      *                                                                                       CAP067
     C     @RTCD         IFEQ      *BLANK                                                     CAP067
     C                   MOVEL     'Y'           CAP067            1                          CAP067
     C                   ELSE                                                                 CAP067
     C                   MOVEL     'N'           CAP067                                       CAP067
     C                   ENDIF                                                                CAP067
                                                                                              CAS006
      ** Check if enhancement CAS006 (Hedge Accounting Phase B) is installed                  CAS006
                                                                                              CAS006
     C                   CALLB     'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRTCD                                        CAS006
     C                   PARM      '*VERIFY'     POPTN                                        CAS006
     C                   PARM      'CAS006'      PSARD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRTCD = *BLANKS                                            CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   ENDIF                                                                CAS006
      *                                                                                       CSE045
      ** Access SAR details file to determine if CSE045 is on.                                CSE045
      ** API Extended Settlements for Trade Input and Depot Movement                          CSE045
      *                                                                                       CSE045
     C                   CALLB     'AOSARDR0'                                                 CSE045
     C                   PARM      *BLANKS       @RTCD                                        CSE045
     C                   PARM      '*VERIFY'     @OPTN                                        CSE045
     C                   PARM      'CSE045'      @SARD                                        CSE045
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE045
      *                                                                                       CSE045
     C     @RTCD         IFEQ      *BLANK                                                     CSE045
     C                   MOVEL     'Y'           CSE045            1                          CSE045
     C                   ELSE                                                                 CSE045
     C                   MOVEL     'N'           CSE045                                       CSE045
     C                   END                                                                  CSE045
 
      ** Access SAR details file to determine if CGL031                                       CGL031
      ** (Taxation of savings Income) is on.                                                  CGL031
                                                                                              CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      '*BLANKS'     PRTCD                                        CGL031
     C                   PARM      '*VERIFY'     POPTN                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
      *                                                                                       CGL031
     C     PRTCD         IFEQ      *BLANK                                                     CGL031
     C                   MOVE      'Y'           CGL031                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVE      'N'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
      *                                                                                       CGL031
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SETRADU011
      *                                                                                       CER001
      ** Access Module Details to verify if Lux Return feature is active                      CER001
      *                                                                                       CER001
     C                   CALL      'AOMMODR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*FIRST '     @OPTN                                        CER001
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER001
      *                                                                                       CER001
      ** ULX603 - API Luxembourg - Function SETRAD                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX603            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX603'      @SARD                                        CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C     BGLRIN        ANDEQ     'Y'                                                        CER001
     C                   MOVEL     'Y'           ULX603                                       CER001
     C                   OPEN      SEVTDLX1L1                                                 CER001
     C                   OPEN      SEVETDX1PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
 
     C                   ENDSR
     C****************************************************************
      /EJECT
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
