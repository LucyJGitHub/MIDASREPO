000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas SE Trade database update controller')            *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - SE Securities Trading Module                         *
000900200529      *                                                               *
001000200529      *  SETRADUPC - SE TRADES DATABASE UPDATE CONTROLLER             *
001100200529      *                                                               *
001200200529      *  (c) Finastra International Limited 2001                      *
001300200529      *                                                               *
001400200604      *  Last Amend No. 248683             Date 22May20               *
001500200529      *  Prev Amend No. MD046248           Date 27Oct17               *
001600200529      *                 CSW210             Date 04May10               *
001700200529      *                 CER059             Date 19Jul10               *
001800200529      *                 CER054             Date 07Apr09               *
001900200529      *                 BUG22911           Date 17Feb09               *
002000200529      *                 CER048             Date 19May08               *
002100200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
002200200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
002300200529      * Midas Plus 1.4 Base ------------------------------------------*
002400200529      * Midas Plus 1.3 ----------- Base ------------------------------*
002500200529      *                 CSD027             Date 09Dec05               *
002600200529      *                 CER001             Date 25Apr05               *
002700200529      *                 CGL031             Date 05Jul04               *
002800200529      *                 222373             Date 23Oct03               *
002900200529      *                 CSE045             Date 24Mar03               *
003000200529      *                 CAS006             Date 21Jan03               *
003100200529      *                 CSD015             Date 14Oct02               *
003200200529      * Midas Release 4.01.03 ----------------------------------------*
003300200529      *                 210517             Date 21Nov02               *
003400200529      * Midas Release 4.01 -------------------------------------------*
003500200529      *                 CAP067             Date 24Sep01               *
003600200529      *                 201589             Date 03Jan02               *
003700200529      * Midas Release 4 --------------- Base -------------------------*
003800200529      * Midas DBA 3.04 -----------------------------------------------*
003900200529      *                 CSE023             Date 12Jul00               *
004000200529      * Midas DBA 3.02 -----------------------------------------------*
004100200529      *                 CAP051             Date 16Nov99               *
004200200529      *                 CPB001             Date 17Aug99               *
004300200529      * Midas DBA 3.00 ---------------- Base -------------------------*
004400200529      *                 CAP006             Date 17Mar99               *
004500200529      *                 154562             Date 01Feb99               *
004600200529      *                 CAP006             Date 19Jan99               *
004700200529      *                 CAP003  *CREATE    Date 15JUL98               *
004800200529      *                                                               *
004900200529      *---------------------------------------------------------------*
005000200529      *                                                               *
005100200529      *  248683 - Initialize Data Area for SE1806 Flag.               *
005200200529      *  MD046248 - Finastra Rebranding                               *
005300200529      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
005400200529      *  CER059 - German Feature Upgrade to Delhi                     *
005500200529      *  CER054 - German Features - Church Tax (Recompile)            *
005600200529      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
005700200529      *  CER048 - German Features - Taxes (Recompile)                 *
005800200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
005900200529      *  CER001 - LUX Upgrade to MidasPlus                            *
006000200529      *  CGL031 - Taxation of Savings Income                          *
006100200529      *  222373 - Parameter Mismatch                                  *
006200200529      *  CSE045 - API for Extended Settlement for Trade Input and     *
006300200529      *           Depot Movement                                      *
006400200529      *  CAS006 - Hedge Accounting Phase B                            *
006500200529      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
006600200529      *  210517 - Missing TRADSDX2 record from the API                *
006700200529      *  CAP067 - Repurchase Agreements API.                          *
006800200529      *  201589 - Change to check a new locking dataarea SETRADLCK    *
006900200529      *           to determine whether this DBU is already active.    *
007000200529      *  CSE023 - Treaty Withholding Tax. (Recompiled)                *
007100200529      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
007200200529      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
007300200529      *           Recompiled due to database changes                  *
007400200529      *  CAP006 - Check for deal being updated by another workstation *
007500200529      *  154562 - Only 1 record is needed on TRADSDX1 if CSW003 is off*
007600200529      *  CAP006 - Send prompt to DTAQ to restart update process after *
007700200529      *           failure.                                            *
007800200529      *  CAP003 - Conversion of MM inputs into modular structure to   *
007900200529      *           use as APIs.                                        *
008000200529      *                                                               *
008100200529      *****************************************************************
008200200529     FSEVTRADPD UF   E             DISK
008300200529     F                                     COMMIT
008400200529     FSEVTRX1L0 UF   E           K DISK
008500200529     F                                     COMMIT
008600200529     FSEVTRX2L0 UF   E           K DISK                                                       CSE045
008700200529     F                                     COMMIT                                             CSE045
008800200529     FSEVTRADL1 UF   E           K DISK
008900200529     F                                     RENAME(SEVTRADD0:SEVTRADD1)
009000200529     FSEVTRX1L1 UF   E           K DISK
009100200529     F                                     RENAME(SEVTRX1PD0:SEVTRX1D1)
009200200529     FSEVETRADPDO    E             DISK
009300200529     F                                     RENAME(SEVTRADD0:SEVTRADERR)
009400200529     FSEVETRX1PDO    E             DISK
009500200529     F                                     RENAME(SEVTRX1PD0:SEVTRX1ERR)
009600200529     FSEVETRX2PDO    E             DISK                                                       CSE045
009700200529     F                                     RENAME(SEVTRX2D0:SEVTRX2ERR)                       CSE045
009800200529     FSEVTRX2L1 UF   E           K DISK                                                       CSE045
009900200529     F                                     RENAME(SEVTRX2D0:SEVTRX2D1)                        CSE045
010000200529
010100200529      * Hook to enable non-core files to be included
010200200529      /COPY WNCPYSRC,SETRADU008
010300200529      *                                                                                       CER001
010400200529     FSEVTDLX1L1UF   E           K DISK    USROPN                                             CER001
010500200529     F                                     INFSR(*pssr)                                       CER001
010600200529     F                                     COMMIT                                             CER001
010700200529     FSEVETDX1PDO    E             DISK    USROPN                                             CER001
010800200529     F                                     RENAME(SEVTDLXD6:SEVTDLXD6R)                       CER001
010900200529      *                                                                                       CER001
011000200529
011100200529      *****************************************************************
011200200529      ** +--------------------------------------+
011300200529      ** ¦ Automatically included D-specs       ¦
011400200529      ** ¦ ==============================       ¦
011500200529      ** +--------------------------------------+
011600200529      **
011700200529      ** Standard D-specs
011800200529      ** ================
011900200529      **
012000200529      ** The following /COPY line includes the LDA layout,
012100200529      ** the copyright array definition,
012200200529      ** and the following named constants:
012300200529      **    True       logical = *on (for indcator processing)
012400200529      **    False      logical = *off (for indcator processing)
012500200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
012600200529      **                                    handler)
012700200529      ** and the following variables:
012800200529      **    RunBefore  1A (for the PSSR)
012900200529
013000200529     D/COPY ZACPYSRC,STD_D_SPEC
013100200529
013200200529      ** Include the MM standard declares
013300200529     D/COPY ZACPYSRC,STDDECLARE
013400200529
013500200529      ** Program Status Data Structure
013600200529      ** =============================
013700200529      ** The following /COPY line includes all the defined fields in the
013800200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
013900200529
014000200529     D/COPY ZACPYSRC,PSDS
014100200529
014200200529      **------------------------------------------------------------------------CAP006--------------
014300200529      ** The following /COPY line includes the definitions for fields           CAP006
014400200529      ** used in checking whether there are messages on the data queue.         CAP006
014500200529     D/COPY ZACPYSRC,DTAQCHKDCL                                                 CAP006
014600200529      **------------------------------------------------------------------------CAP006--------------
014700200529                                                                                CAP006
014800200529      *                                                                                       CAP067
014900200529      ** The following /COPY line includes the definitions for error and                      CAP067
015000200529      ** warning message arrays.                                                              CAP067
015100200529     D/COPY ZACPYSRC,ERR_ARRAYS                                                               CAP067
015200200529      *                                                                                       CAP067
015300200529      ** +--------------------------------------+
015400200529      ** ¦ End of automatically included D-specs¦
015500200529      ** ¦ =====================================¦
015600200529      ** +--------------------------------------+
015700200529     D DBerrUpd        C                   CONST('DB error in TRAD API update')
015800200529                                                                                CAP006
015900200529     D Command         DS                                                       CAP006
016000200529      ** OVRDBF command for QCMDEXC to run                                      CAP006
016100200529     D                         1     26    INZ('OVRDBF TRADSDY1 SHARE(*NO)')    CAP006
016200200529
016300200529      *****************************************************************
016400200529
016500200529      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID SECURITY
016600200529     D SEVTRD        E DS                  EXTNAME(SEVTRADPD)
016700200529     D SEVTRDX1      E DS                  EXTNAME(SEVTRX1PD)
016800200529     D SEVTRDX2      E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
016900200529     D SEVTRDX1A     E DS                  EXTNAME(SEVTRX1PD)
017000200529     D                                     PREFIX(A_)
017100200529     D SEVTRDX1B     E DS                  EXTNAME(SEVTRX1PD)
017200200529     D                                     PREFIX(B_)
017300200529     D SEVTRD1       E DS                  EXTNAME(SEVTRADPD)                                 CAP067
017400200529     D                                     PREFIX(W1)                                         CAP067
017500200529     D SEVTRDX1A1    E DS                  EXTNAME(SEVTRX1PD)                                 CAP067
017600200529     D                                     PREFIX(WA)                                         CAP067
017700200529     D SEVTRDX1B1    E DS                  EXTNAME(SEVTRX1PD)                                 CAP067
017800200529     D                                     PREFIX(WB)                                         CAP067
017900200529     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)                                  CAP067
018000200529      ** Book Details                                                                         CAP067
018100200529     D SEVTRDX2A     E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
018200200529     D                                     PREFIX(A_)                                         CSE045
018300200529     D SEVTRDX2B     E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
018400200529     D                                     PREFIX(B_)                                         CSE045
018500200529
018600200529     D SETRADUPC       DS             1    DTAARA(SETRADUPC)
018700200529
018800200529
018900200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)
019000200529     D SCA_LCD       E                     EXTFLD(LCD)
019100200529      ** EXTERNAL DS FOR SAR DETAILS
019200200529     D DSFDY         E DS                  EXTNAME(DSFDY)
019300200529      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
019400200529     D PMCWL           DS          9999                                                       CSD015
019500200529      ** Additional entry parameter for Midas Compliance Watch                                CSD015
019600200529
019700200529
019800200529     D Object          S             10A   INZ('SETRADUPC')
019900200529     D LockObj         S             10A   INZ('SETRADLCK')                                   201589
020000200529     D Lib             S             10A   INZ('*LIBL')
020100200529     D ObjType         S              7A   INZ('*DTAARA')
020200200529     D LockStateE      S              7A   INZ('*EXCL')
020300200529     D LockStateS      S              7A   INZ('*SHRRD')
020400200529     D Member          S             10A
020500200529     D WaitTime        S              6A   INZ('*CLS')
020600200529     D Dlcobj          S              1A
020700200529     D Return          S              7A
020800200529     D Return2         S              7A                                                      201589
020900200529     D Endjob          S              1A   INZ('Y')                                           201589
021000200529     D @Timestamp      S             26Z
021100200529
021200200529      ** Dummy message ID and message file fields for use on the calls to
021300200529      ** ZAMSGTOOPR
021400200529     D DummyMsgID      S                   LIKE(#MsgID)
021500200529     D DummyMsgF       S             10A
021600200529                                                                                CAP006
021700200529      ** Command length for QCMDEXC                                             CAP006
021800200529     D CommandLen      S             15P 5 INZ(26)                              CAP006
021900200529
022000200529     D Idx             S              3P 0                                                    CAP067
022100200529                                                                                              210517
022200200529     D PMODE           S              3A                                                      210517
022300200529
022400200529     D ULX603          S              1A   INZ('N')                                           CER001
022500200529     D CAS006          S              1                                                       CAS006
022600200529     D PRTCD           S              7                                                       CAS006
022700200529     D POPTN           S              7                                                       CAS006
022800200529     D PSARD           S              6                                                       CAS006
022900200529                                                                                              CAS006
023000200529     D CGL031          S              1A                                                      CGL031
023100200529      ** +--------------------------------------+
023200200529      ** ¦ End of D-specs                       ¦
023300200529      ** ¦ ==============                       ¦
023400200529      ** +--------------------------------------+
023500200529
023600200529      ** +----------------------------------------+
023700200529      ** ¦ Hook for non-core D-specs (all types)  ¦
023800200529      ** ¦ also any I-specs (if necessary)        ¦
023900200529      ** ¦ =====================================  ¦
024000200529      ** +----------------------------------------+
024100200529      /COPY WNCPYSRC,SETRADU009
024200200529      *                                                                                       CER001
024300200529      ** External data structures for Midas Modules                                           CER001
024400200529      *                                                                                       CER001
024500200529     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CER001
024600200529      *                                                                                       CER001
024700200529      ** New valid extended Trade File                                                        CER001
024800200529      *                                                                                       CER001
024900200529     D SEVTDLX6      E DS                  EXTNAME(SEVTDLX1L1)                                CER001
025000200529     D SEVTDLX6S     E DS                  EXTNAME(SEVTDLX1L1)                                CER001
025100200529     D                                     PREFIX(SS)                                         CER001
025200200529
025300200529      *******************************************************************
025400200529      ** +--- Start of Main processing -----------------------------------+
025500200529      ** ¦                                                                ¦
025600200529      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
025700200529      ** ¦ executed at program activation.                                ¦
025800200529      ** ¦                                                                ¦
025900200529      ** +----------------------------------------------------------------+
026000200529      *******************************************************************
026100200529
026200200529      /COPY WNCPYSRC,SETRADU001
026300200529
026400200529      ** Set up the name of the server/database updater data queue.             CAP006
026500200529     C                   EVAL      DtaQName = 'APTRADDTQ'                       CAP006
026600200529                                                                                CAP006
026700200529      **------------------------------------------------------------------------CAP006--------------
026800200529      ** The following /COPY line includes a check for whether there            CAP006
026900200529      ** are messages on the server/updater data queue, and sends a 'GO'.       CAP006
027000200529      ** message to the data queue if there are not.                            CAP006
027100200529     D/COPY ZACPYSRC,DTAQCHK                                                    CAP006
027200200529      **------------------------------------------------------------------------CAP006--------------
027300200529                                                                                CAP006
027400200529      *  Initialise Data queue parms
027500200529     C                   EVAL      DtqLen = 10
027600200529     C                   EVAL      DtqWait = -1
027700200529     C                   EVAL      DtqNam = 'APTRADDTQ'
027800200529     C                   EVAL      DtqLib = '*LIBL'
027900200529     C                   EVAL      ObjType = '*DTAARA'
028000200529      ** Wait for data queue prompt
028100200529      ** Server program will send data queue entry when record is
028200200529      ** written to the valid transactions file
028300200529     C     DtqDta        DOWNE     'END'
028400200529     C                   CALL      'QRCVDTAQ'
028500200529     C                   PARM                    DtqNam           10
028600200529     C                   PARM                    DtqLib           10
028700200529     C                   PARM                    DtqLen            5 0
028800200529     C                   PARM                    DtqDta           10
028900200529     C                   PARM                    DtqWait           5 0
029000200529     C     DtqDta        IFEQ      'GO'
029100200529      *  Lock allocation data area
029200200529     C                   CALLB     'APCALCOBJ'
029300200529     C                   PARM                    Object
029400200529     C                   PARM                    Lib
029500200529     C                   PARM                    ObjType
029600200529     C                   PARM                    LockStateE
029700200529     C                   PARM                    Member
029800200529     C                   PARM                    WaitTime
029900200529     C                   PARM                    Dlcobj
030000200529     C                   PARM                    Return
030100200529
030200200529      /COPY WNCPYSRC,SETRADU002
030300200529
030400200529      ** Position file cursor to start of file to prevent problems on
030500200529      ** later calls
030600200529     C     1             SETLL     SEVTRADPD
030700200529
030800200529      ** READ VALID SE TRADE
030900200529     C                   READ      SEVTRADD0                              99    *
031000200529     C     *IN99         DOWEQ     '0'
031100200529
031200200529      /COPY WNCPYSRC,SETRADU003
031300200529
031400200529      ** Load the API Dump data area with as many fields from the message
031500200529      **  header as are available, so that dumps in any lower level modules
031600200529      **  will include the key information
031700200529     C                   EVAL      ARFOTranID = FRNT
031800200529     C                   EVAL      ARFOAsocID = AFRT
031900200529     C                   EVAL      ARRprLocn  = REPA
032000200529
032100200529      /COPY WNCPYSRC,SETRADU004
032200200529
032300200529      ** GET EXTENSION FILE DETAILS (RECORDS A & B)
032400200529
032500200529     C                   CLEAR                   SEVTRDX1A
032600200529     C                   CLEAR                   SEVTRDX1B
032700200529     C                   CLEAR                   SEVTRDX2A                                    CSE045
032800200529     C                   CLEAR                   SEVTRDX2B                                    CSE045
032900200529
033000200529
033100200529      /COPY WNCPYSRC,SETRADU005
033200200529      *                                                                                       CER001
033300200529      ** ULX603 - API Luxembourg - Function SETRAD                                            CER001
033400200529      *                                                                                       CER001
033500200529     C     ULX603        IFNE      'Y'                                          B1            CER001
033600200529      *                                                                                       CER001
033700200529
033800200529     C     CSW003        IFEQ      'Y'                                          154562
033900200529     C                   EVAL      T1WHEN = 'A'
034000200529     C                   ELSE                                                   154562
034100200529     C                   EVAL      T1WHEN = ' '                                 154562
034200200529     C                   END                                                    154562
034300200529     C     @KeyTrx1L0    CHAIN     SEVTRX1L0                          98
034400200529     C  N98              EVAL      SEVTRDX1A = SEVTRDX1
034500200529     C                   IF        CSE045 = 'Y'                                               CSE045
034600200529     C     @KeyTrx1L0    CHAIN     SEVTRX2L0                          98                      CSE045
034700200529     C  N98              EVAL      SEVTRDX2A = SEVTRDX2                                       CSE045
034800200529     C                   ENDIF                                                                CSE045
034900200529
035000200529     C                   EVAL      T1WHEN = 'B'
035100200529     C     @KeyTrx1L0    CHAIN     SEVTRX1L0                          98
035200200529     C  N98              EVAL      SEVTRDX1B = SEVTRDX1
035300200529     C                   IF        CSE045 = 'Y'                                               CSE045
035400200529     C     @KeyTrx1L0    CHAIN     SEVTRX2L0                          98                      CSE045
035500200529     C  N98              EVAL      SEVTRDX2B = SEVTRDX2                                       CSE045
035600200529     C                   ENDIF                                                                CSE045
035700200529
035800200529      ** SE DATABASE UPDATE
035900200529     C                   CALLB     'SETRADUPD'
036000200529     C                   PARM      *BLANK        @@RTCD            7
036100200529     C                   PARM                    SEVTRD
036200200529     C                   PARM                    SEVTRDX1A
036300200529     C                   PARM                    SEVTRDX1B
036400200529     C                   PARM                    S01401            1
036500200529     C                   PARM                    CSW003            1            154562
036600200529     C                   PARM                    CAP051            1            CAP051
036700200529     C                   PARM                    CAS006                                       CAS006
036800200529     C                   PARM                    CGL031                                       CGL031
036900200529     C                   PARM      'UPC'         PMODE                                        210517
037000200529                                                                                              CSD015
037100200529      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
037200200529      **  Watch Enhancement.                                                                  CSD015
037300200529     C                   PARM                    PMCWL                                        CSD015
037400200529     C                   PARM                    SEVTRDX2A                                    CSE045
037500200529     C                   PARM                    SEVTRDX2B                                    CSE045
037600200529     C/COPY WNCPYSRC,SETRADUC01
037700200529
037800200529      * COMIT UPDATES IF NO ERROR
037900200529     C     @@RTCD        IFEQ      '*ERROR '
038000200529     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
038100200529     C                   ROLBK
038200200529     C                   ELSE
038300200529      *                                                                                       CAP067
038400200529      ** If MM Repos enhancement is installed and trade is a                                  CAP067
038500200529      ** leg of a buy sell back, then save link reference and                                 CAP067
038600200529      ** book code processed.                                                                 CAP067
038700200529      *                                                                                       CAP067
038800200529     C                   EVAL      WLinkRef = *BLANKS                                         CAP067
038900200529     C                   EVAL      WChTp = *BLANK                                             CAP067
039000200529     C                   EVAL      Idx = *ZERO                                                CAP067
039100200529      *                                                                                       CAP067
039200200529     C                   IF        CAP067 = 'Y'                                               CAP067
039300200529     C                   EVAL      WLinkRef = LKRF                                            CAP067
039400200529     C                   EVAL      WChTp = CHTP                                               CAP067
039500200529     C                   EVAL      WBook = TDBK                                               CAP067
039600200529     C                   ENDIF                                                                CAP067
039700200529      *                                                                                       CAP067
039800200529     C                   DELETE    SEVTRADD0
039900200529     C     CSW003        IFEQ      'Y'                                          154562
040000200529     C                   EVAL      T1WHEN = 'A'
040100200529     C                   ELSE                                                   154562
040200200529     C                   EVAL      T1WHEN = ' '                                 154562
040300200529     C                   END                                                    154562
040400200529     C     @KeyTrx1L0    CHAIN     SEVTRX1L0                          98
040500200529     C  N98              DELETE    SEVTRX1PD0
040600200529     C                   IF        CSE045 = 'Y'                                               CSE045
040700200529     C     @KeyTrx1L0    CHAIN     SEVTRX2L0                          98                      CSE045
040800200529     C  N98              DELETE    SEVTRX2D0                                                  CSE045
040900200529     C                   ENDIF                                                                CSE045
041000200529     C                   EVAL      T1WHEN = 'B'
041100200529     C     @KeyTrx1L0    CHAIN     SEVTRX1L0                          98
041200200529     C  N98              DELETE    SEVTRX1PD0
041300200529     C                   IF        CSE045 = 'Y'                                               CSE045
041400200529     C     @KeyTrx1L0    CHAIN     SEVTRX2L0                          98                      CSE045
041500200529     C  N98              DELETE    SEVTRX2D0                                                  CSE045
041600200529     C                   ENDIF                                                                CSE045
041700200529     C/COPY WNCPYSRC,SETRADUC02
041800200529      *                                                                                       CAP067
041900200529      ** Delete, approve or authorise the other side of buy-sell                              CAP067
042000200529      ** if action is the same for the first buy-sell back.                                   CAP067
042100200529      *                                                                                       CAP067
042200200529     C                   IF        WLinkRef <> *BLANKS AND                                    CAP067
042300200529     C                             (WCHTP = 'D' OR                                            CAP067
042400200529     C                             WCHTP = 'P' OR                                             CAP067
042500200529     C                             WCHTP = 'Y')                                               CAP067
042600200529     C                   EXSR      SRBuySell                                                  CAP067
042700200529     C                   ENDIF                                                                CAP067
042800200529      *                                                                                       CAP067
042900200529      ** If there are errors encountered, roll back changes                                   CAP067
043000200529      *                                                                                       CAP067
043100200529     C                   IF        Idx <> *ZERO                                               CAP067
043200200529     C                   EVAL      @@RTCD = '*ERROR'                                          CAP067
043300200529     C                   ENDIF                                                                CAP067
043400200529      *                                                                                       CAP067
043500200529     C                   IF        @@RTCD = '*ERROR' OR                                       CAP067
043600200529     C                             @@RTCD = '*RECUPD'                                         CAP067
043700200529     C                   ROLBK                                                                CAP067
043800200529     C                   ELSE                                                                 CAP067
043900200529     C                   COMMIT
044000200529     C                   ENDIF                                                                CAP067
044100200529     C                   END
044200200529
044300200529      /COPY WNCPYSRC,SETRADU006
044400200529      *                                                                                       CER001
044500200529     C                   ELSE                                                   X1            CER001
044600200529      *                                                                                       CER001
044700200529      ** Master files update                                                                  CER001
044800200529      *                                                                                       CER001
044900200529     C     CSW003        IFEQ      'Y'                                                        CER001
045000200529     C                   EVAL      T1WHEN = 'A'                                               CER001
045100200529     C                   ELSE                                                                 CER001
045200200529     C                   EVAL      T1WHEN = ' '                                               CER001
045300200529     C                   END                                                                  CER001
045400200529      *                                                                                       CER001
045500200529     C     @KeyTrx1L0    CHAIN     SEVTRX1L0                          98                      CER001
045600200529     C  N98              EVAL      SEVTRDX1A = SEVTRDX1                                       CER001
045700200529                                                                                              CER001
045800200529     C                   EVAL      T1WHEN = 'B'                                               CER001
045900200529     C     @KeyTrx1L0    CHAIN     SEVTRX1L0                          98                      CER001
046000200529     C  N98              EVAL      SEVTRDX1B = SEVTRDX1                                       CER001
046100200529      *                                                                                       CER001
046200200529     C                   CALLB     'SETRADUPD'                                                CER001
046300200529     C                   PARM      *BLANKS       @@RTCD                                       CER001
046400200529     C                   PARM                    SEVTRD                                       CER001
046500200529     C                   PARM                    SEVTRDX1A                                    CER001
046600200529     C                   PARM                    SEVTRDX1B                                    CER001
046700200529     C                   PARM                    S01401            1                          CER001
046800200529     C                   PARM                    CSW003            1                          CER001
046900200529     C                   PARM                    CAP051            1                          CER001
047000200529     C                   PARM                    CAS006                                       CER001
047100200529     C                   PARM      'UPC'         PMODE                                        CER001
047200200529     C                   PARM                    PMCWL                                        CER001
047300200529     C                   PARM                    SEVTRDX2A                                    CER001
047400200529     C                   PARM                    SEVTRDX2B                                    CER001
047500200529      *                                                                                       CER001
047600200529     C     @@RTCD        IFEQ      *BLANKS                                      B2            CER001
047700200529      *                                                                                       CER001
047800200529     C                   DELETE    SEVTRADD0                                                  CER001
047900200529      *                                                                                       CER001
048000200529     C     CSW003        IFEQ      'Y'                                                        CER001
048100200529     C                   EVAL      T1WHEN = 'A'                                               CER001
048200200529     C                   ELSE                                                                 CER001
048300200529     C                   EVAL      T1WHEN = ' '                                               CER001
048400200529     C                   END                                                                  CER001
048500200529      *                                                                                       CER001
048600200529     C     @KeyTrx1L0    CHAIN     SEVTRX1L0                          98                      CER001
048700200529     C  N98              DELETE    SEVTRX1PD0                                                 CER001
048800200529     C                   EVAL      T1WHEN = 'B'                                               CER001
048900200529     C     @KeyTrx1L0    CHAIN     SEVTRX1L0                          98                      CER001
049000200529     C  N98              DELETE    SEVTRX1PD0                                                 CER001
049100200529      *                                                                                       CER001
049200200529      *                                                                                       CER001
049300200529      ** Extension files update                                                               CER001
049400200529      ** For SE, no physical delete on extension files, it is done during                     CER001
049500200529      ** COB when system 'purge' SE master files                                              CER001
049600200529      *                                                                                       CER001
049700200529     C     K@KEY1        CHAIN     SEVTDLX1L1                         89                      CER001
049800200529      *                                                                                       CER001
049900200529     C     CHTP          IFEQ      'I'                                          B3            CER001
050000200529     C     CHTP          OREQ      'A'                                                        CER001
050100200529      *                                                                                       CER001
050200200529      ** Retrieve Extended valid records                                                      CER001
050300200529      *                                                                                       CER001
050400200529     C     ULX603        IFEQ      'Y'                                          B4            CER001
050500200529      *                                                                                       CER001
050600200529     C                   CALLB     'SETRAD2UP'                                                CER001
050700200529     C                   PARM                    CHTP                                         CER001
050800200529     C                   PARM      *BLANK        @@RTCD                                       CER001
050900200529     C                   PARM      *BLANK        @@FIND            1                          CER001
051000200529     C                   PARM                    SEVTDLX6                                     CER001
051100200529     C                   PARM      *BLANK        SEVTDLX6S                                    CER001
051200200529      *                                                                                       CER001
051300200529     C                   ENDIF                                                  E4            CER001
051400200529      *                                                                                       CER001
051500200529      ** Put here other extension....                                                         CER001
051600200529      *                                                                                       CER001
051700200529     C                   ENDIF                                                  E3            CER001
051800200529      *                                                                                       CER001
051900200529     C     @@RTCD        IFEQ      *BLANK                                       B5            CER001
052000200529     C                   DELETE    SEVTDLXD6                                                  CER001
052100200529     C                   ENDIF                                                  E5            CER001
052200200529      *                                                                                       CER001
052300200529     C                   ENDIF                                                  E2            CER001
052400200529      *                                                                                       CER001
052500200529      *                                                                                       CER001
052600200529      ** COMIT Updates if no error                                                            CER001
052700200529      *                                                                                       CER001
052800200529      *                                                                                       CER001
052900200529     C     @@RTCD        IFEQ      '*ERROR '                                    B2            CER001
053000200529     C     @@RTCD        OREQ      '*RECUPD'                                                  CER001
053100200529     C                   ROLBK                                                                CER001
053200200529     C                   ELSE                                                   X2            CER001
053300200529     C                   COMMIT                                                               CER001
053400200529     C                   ENDIF                                                  E2            CER001
053500200529      *                                                                                       CER001
053600200529     C                   ENDIF                                                  E1            CER001
053700200529      *                                                                                       CER001
053800200529      ** If an error has occurred, reaccess record in error and remove from                   CER001
053900200529      ** the file and write details of record to error valid file                             CER001
054000200529      *                                                                                       CER001
054100200529     C     ULX603        IFEQ      'Y'                                          B1            CER001
054200200529      *                                                                                       CER001
054300200529     C     @@RTCD        IFEQ      '*ERROR '                                    B2            CER001
054400200529     C     @@RTCD        OREQ      '*RECUPD'                                                  CER001
054500200529      *                                                                                       CER001
054600200529     C     K@KEY1        CHAIN     SEVTDLX1L1                         89                      CER001
054700200529      *                                                                                       CER001
054800200529     C                   WRITE     SEVTDLXD6R                                                 CER001
054900200529     C                   DELETE    SEVTDLXD6                                                  CER001
055000200529      *                                                                                       CER001
055100200529     C                   ENDIF                                                  E2            CER001
055200200529      *                                                                                       CER001
055300200529     C                   ENDIF                                                  E1            CER001
055400200529
055500200529     ** If an error has occurred, reaccess record in error and remove from
055600200529     ** the file to prevent program processing the same record again
055700200529     C     @@RTCD        IFEQ      '*ERROR '
055800200529     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
055900200529     C                   EVAL      @TradeRef  = TDRF
056000200529     C                   EVAL      @Timestamp = TMST
056100200529     C     @KeyTradL1    CHAIN     SEVTRADL1                          89
056200200529     ** Write details of record to error file (same format as SEVTRADPD)
056300200529     C                   WRITE     SEVTRADERR
056400200529     C                   DELETE    SEVTRADD1
056500200529     C                   EVAL      @When = 'A'
056600200529     C     @KeyTrx1L1    CHAIN     SEVTRX1L1                          89
056700200529     ** Write details of record to error file (same format as SEVTRX1PD)
056800200529     C     *IN89         IFEQ      '0'
056900200529     C                   WRITE     SEVTRX1ERR
057000200529     C                   DELETE    SEVTRX1D1
057100200529     C                   END
057200200529     C                   IF        CSE045 = 'Y'                                               CSE045
057300200529     C     @KeyTrx1L1    CHAIN     SEVTRX2L1                          89                      CSE045
057400200529     ** Write details of record to error file (same format as SEVTRX2PD)                      CSE045
057500200529     C     *IN89         IFEQ      '0'                                                        CSE045
057600200529     C                   WRITE     SEVTRX2ERR                                                 CSE045
057700200529     C                   DELETE    SEVTRX2D1                                                  CSE045
057800200529     C                   ENDIF                                                                CSE045
057900200529     C                   ENDIF                                                                CSE045
058000200529     C                   EVAL      @When = 'B'
058100200529     C     @KeyTrx1L1    CHAIN     SEVTRX1L1                          89
058200200529     ** Write details of record to error file (same format as SEVTRX1PD)
058300200529     C     *IN89         IFEQ      '0'
058400200529     C                   WRITE     SEVTRX1ERR
058500200529     C                   DELETE    SEVTRX1D1
058600200529     C                   END
058700200529     C                   IF        CSE045 = 'Y'                                               CSE045
058800200529     C     @KeyTrx1L1    CHAIN     SEVTRX2L1                          89                      CSE045
058900200529     ** Write details of record to error file (same format as SEVTRX2PD)                      CSE045
059000200529     C     *IN89         IFEQ      '0'                                                        CSE045
059100200529     C                   WRITE     SEVTRX2ERR                                                 CSE045
059200200529     C                   DELETE    SEVTRX2D1                                                  CSE045
059300200529     C                   ENDIF                                                                CSE045
059400200529     C                   ENDIF                                                                CSE045
059500200529     C/COPY WNCPYSRC,SETRADUC03
059600200529     ** Send message to system operator
059700200529     C                   MOVEL     DBerrUpd      DBError          28
059800200529     C                   CALLB     'ZAMSGTOOPR'
059900200529     C                   PARM                    MsgSndRtn        10
060000200529     C                   PARM                    DBError
060100200529     C                   PARM                    DummyMsgID
060200200529     C                   PARM                    DummyMsgF
060300200529
060400200529     C                   ENDIF
060500200529
060600200529      ** READ VALID SE TRADES
060700200529     C                   READ      SEVTRADD0                              99    *
060800200529     C                   END
060900200529     ** Unlock allocation data area
061000200529     C                   CALLB     'APCDLCOBJ'
061100200529     C                   PARM                    Object
061200200529     C                   PARM                    Lib
061300200529     C                   PARM                    ObjType
061400200529     C                   PARM                    LockStateE
061500200529     C                   PARM                    Member
061600200529     C                   PARM                    Return
061700200529     C                   END
061800200529      ** End loop for data queue prompt
061900200529     C                   END
062000200529
062100200529      /COPY WNCPYSRC,SETRADU007
062200200529
062300200529      * EXIT FROM PROGRAM
062400200529     C                   RETURN
062500200529
062600200529      * Hook to enable non-core subroutines to be included
062700200529      /COPY WNCPYSRC,SETRADU010
062800200529      *                                                                                       CAP067
062900200529      *****************************************************************                       CAP067
063000200529      /EJECT                                                                                  CAP067
063100200529      *****************************************************************                       CAP067
063200200529      *                                                               *                       CAP067
063300200529      *  SRBuySell - Process other side of buy-sell back              *                       CAP067
063400200529      *                                                               *                       CAP067
063500200529      *****************************************************************                       CAP067
063600200529      *                                                                                       CAP067
063700200529     C     SRBuySell     BEGSR                                                                CAP067
063800200529      *                                                                                       CAP067
063900200529      ** Check first if book code is buy-sell back book code.                                 CAP067
064000200529      *                                                                                       CAP067
064100200529     C                   CALL      'AOBOOKR0'                                                 CAP067
064200200529     C                   PARM      *BLANKS       @RTCD             7                          CAP067
064300200529     C                   PARM      '*KEY   '     @OPTN             7                          CAP067
064400200529     C                   PARM                    WBook             2                          CAP067
064500200529     C     SDBOOK        PARM      SDBOOK        DSFDY                                        CAP067
064600200529      *                                                                                       CAP067
064700200529     C     BDBYSL        IFEQ      'Y'                                                        CAP067
064800200529      *                                                                                       CAP067
064900200529      ** Initialise records                                                                   CAP067
065000200529      *                                                                                       CAP067
065100200529     C                   CLEAR                   SEVTRD1                                      CAP067
065200200529     C                   CLEAR                   SEVTRDX1A1                                   CAP067
065300200529     C                   CLEAR                   SEVTRDX1B1                                   CAP067
065400200529      *                                                                                       CAP067
065500200529      ** Get trade details                                                                    CAP067
065600200529      *                                                                                       CAP067
065700200529     C                   CALLB     'SETRADRTV'                                                CAP067
065800200529      *                             =========                                                 CAP067
065900200529      ** INPUTS                                                                               CAP067
066000200529      *  ======                                                                               CAP067
066100200529      *                                                                                       CAP067
066200200529      ** Return code                                                                          CAP067
066300200529     C                   PARM      *BLANK        RetCodeOut                                   CAP067
066400200529      *                                                                                       CAP067
066500200529      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                                 CAP067
066600200529      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                             CAP067
066700200529     C                   PARM      *BLANKS       @@MODE            6                          CAP067
066800200529      *                                                                                       CAP067
066900200529      ** Response mode                                                                        CAP067
067000200529     C                   PARM      *BLANK        @@RSMD            1                          CAP067
067100200529      *                                                                                       CAP067
067200200529      ** Action Code                                                                          CAP067
067300200529     C                   PARM                    WCHTP             1                          CAP067
067400200529      *                                                                                       CAP067
067500200529      ** Front Office Transaction ID                                                          CAP067
067600200529     C                   PARM      *BLANKS       FOTRID           20                          CAP067
067700200529      *                                                                                       CAP067
067800200529      ** (Midas) Trade Reference                                                              CAP067
067900200529     C                   PARM                    WLinkRef          6                          CAP067
068000200529      *                                                                                       CAP067
068100200529      ** MT5XX - Phase 2 Message Generation is on.                                            CAP067
068200200529     C                   PARM                    CSW003                                       CAP067
068300200529      *                                                                                       CAP067
068400200529      ** Buy-sell back                                                                        CAP067
068500200529     C                   PARM                    PFBYSL            1                          CAP067
068600200529      *                                                                                       CAP067
068700200529      ** Trade Reference                                                                      CAP067
068800200529     C                   PARM                    PFTDRF            6                          CAP067
068900200529      *                                                                                       CAP067
069000200529      ** OUTPUTS                                                                              CAP067
069100200529      *  =======                                                                              CAP067
069200200529      *                                                                                       CAP067
069300200529      ** (Current) TRADE in file format                                                       CAP067
069400200529     C                   PARM                    SEVTRD1                                      CAP067
069500200529     C                   PARM                    SEVTRDX1A1                                   CAP067
069600200529     C                   PARM                    SEVTRDX1B1                                   CAP067
069700200529      *                                                                                       CAP067
069800200529      ** OK - Action code                                                                     CAP067
069900200529     C                   PARM      *BLANK        DDACTNOK          1                          CAP067
070000200529      *                                                                                       CAP067
070100200529      ** OK - Trade Reference                                                                 CAP067
070200200529     C                   PARM      *BLANK        DDTDRFOK          1                          CAP067
070300200529      *                                                                                       CAP067
070400200529      ** Error fields/message IDs/message data (arrays) from/to caller                        CAP067
070500200529     C                   PARM      *BLANKS       FldNameArr                                   CAP067
070600200529     C                   PARM      *BLANKS       MsgIdArr                                     CAP067
070700200529     C                   PARM      *BLANKS       MsgDtaArr                                    CAP067
070800200529      *                                                                                       CAP067
070900200529      ** Array index (3P0) from/to caller                                                     CAP067
071000200529     C                   PARM      *ZERO         Idx                                          CAP067
071100200529      *                                                                                       CAP067
071200200529      ** If there no errors present, perform update of the second                             CAP067
071300200529      ** deal.                                                                                CAP067
071400200529      *                                                                                       CAP067
071500200529     C                   IF        Idx = *ZEROS                                               CAP067
071600200529     C                   EVAL      W1CHTP = WCHTP                                             CAP067
071700200529      *                                                                                       CAP067
071800200529     C                   CALLB     'SETRADUPD'                                                CAP067
071900200529     C                   PARM      *BLANK        @@RTCD                                       CAP067
072000200529     C                   PARM                    SEVTRD1                                      CAP067
072100200529     C                   PARM                    SEVTRDX1A1                                   CAP067
072200200529     C                   PARM                    SEVTRDX1B1                                   CAP067
072300200529     C                   PARM                    S01401                                       CAP067
072400200529     C                   PARM                    CSW003                                       CAP067
072500200529     C                   PARM                    CAP051                                       CAP067
072600200529     C                   PARM                    CAS006                                       CAS006
072700200529     C                   PARM                    CGL031                                       CGL031
072800200529     C                   PARM      'UPC'         PMODE                                        210517
072900200529                                                                                              CSD015
073000200529      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
073100200529      **  Watch Enhancement.                                                                  CSD015
073200200529     C                   PARM                    PMCWL                                        CSD015
073300200529     C                   PARM                    SEVTRDX2A                                    222373
073400200529     C                   PARM                    SEVTRDX2B                                    222373
073500200529      *                                                                                       CAP067
073600200529     C                   ENDIF                                                                CAP067
073700200529      *                                                                                       CAP067
073800200529     C                   ENDIF                                                                CAP067
073900200529      *                                                                                       CAP067
074000200529     C                   ENDSR                                                                CAP067
074100200529
074200200529      /EJECT
074300200529      *****************************************************************
074400200529      *                                                               *
074500200529      * *INZSR - Program Initialisation routine                       *
074600200529      *                                                               *
074700200529      * Called by: Main processing                                    *
074800200529      *                                                               *
074900200529      * Calls: None                                                   *
075000200529      *                                                               *
075100200529      *****************************************************************
075200200529     C     *INZSR        BEGSR
075300200529      *                                                                                       248683
075400200529      ** Initialize Data Area for SE1806 Flag                                                 248683
075500200529      *                                                                                       248683
075600200529     C                   CALL      'SECDTARA'                                                 248683
075700200529     C                   PARM      'SETRADRPR'   PGMNAM           10                          248683
075800200529     C                   PARM      *BLANKS       WRTFLG            1                          248683
075900200529
076000200529      *  Define key list for SEVTRX1L0
076100200529     C     @KeyTrx1L0    KLIST
076200200529     C                   KFLD                    FRNT
076300200529     C                   KFLD                    T1WHEN
076400200529
076500200529      *  Define key list for SEVTRADL1
076600200529     C     @KeyTradL1    KLIST
076700200529     C                   KFLD                    @TradeRef         6
076800200529     C                   KFLD                    @Timestamp
076900200529
077000200529      *  Define key list for SEVTRX1L1
077100200529     C     @KeyTrx1L1    KLIST
077200200529     C                   KFLD                    @TradeRef         6
077300200529     C                   KFLD                    @When             1
077400200529     C                   KFLD                    @Timestamp
077500200529      *                                                                                       CER001
077600200529      ** Define key list for SEVTDLX1L1                                                       CER001
077700200529      *                                                                                       CER001
077800200529     C     K@KEY1        KLIST                                                                CER001
077900200529     C                   KFLD                    FRNT                                         CER001
078000200529     C                   KFLD                    TMST                                         CER001
078100200529
078200200529      *  Check if an existing DBU_TRAD job is active in the subsystem.                        201589
078300200529                                                                                              201589
078400200529     C                   CALL      'SCC0520'                                                  201589
078500200529     C                   PARM                    LockObj                                      201589
078600200529     C                   PARM                    Lib                                          201589
078700200529     C                   PARM                    ObjType                                      201589
078800200529     C                   PARM                    LockStateE                                   201589
078900200529     C                   PARM                    Member                                       201589
079000200529     C                   PARM                    Endjob                                       201589
079100200529     C                   PARM                    Return2                                      201589
079200200529                                                                                              201589
079300200529      *  Lock allocation data area
079400200529
079500200529      *   The data area is allocated *SHRRD here and *EXCL whilst processing
079600200529      *    of the valid file is actually taking place.
079700200529      *   The function to submit this updater tries to get a *EXCL lock.
079800200529      *   The controller tries to get a *SHRRD lock.
079900200529
080000200529      *                         Submitter             Controller
080100200529      *                 Lock      Lock     Submitter     Lock     Controller
080200200529      *      Status    Status   Successful   Action   Successful    Action
080300200529      *      ------    ------   ---------- ---------  ----------  ----------
080400200529      *   Not running  None        Yes      Submit       Yes        Prompt
080500200529      *                                     updater                 updater
080600200529
080700200529      *   Running not  *SHRRD      No        None        Yes        Prompt
080800200529      *    processing                                               updater
080900200529
081000200529      *   Processing   *EXCL       No        None        No         None
081100200529
081200200529     C                   CALLB     'APCALCOBJ'
081300200529     C                   PARM                    Object
081400200529     C                   PARM                    Lib
081500200529     C                   PARM                    ObjType
081600200529     C                   PARM                    LockStateS
081700200529     C                   PARM                    Member
081800200529     C                   PARM                    WaitTime
081900200529     C                   PARM                    Dlcobj
082000200529     C                   PARM                    Return
082100200529
082200200529      ** Create required QTEMP objects
082300200529     C                   CALL      'APCCRTQTO'
082400200529     C                   PARM                    ReturnCde        10
082500200529                                                                                CAP006
082600200529      ** Override SE Extension file (used in *UPD and *RTV modules)             CAP006
082700200529                                                                                CAP006
082800200529     C                   CALL      'QCMDEXC'                                    CAP006
082900200529     C                   PARM                    Command                        CAP006
083000200529     C                   PARM                    CommandLen                     CAP006
083100200529      *
083200200529      ** Access SAR details file to determine if S01401
083300200529      ** (MT5XX Message Generation) is on.
083400200529      *
083500200529     C                   CALLB     'AOSARDR0'
083600200529     C                   PARM      *BLANKS       @RTCD             7
083700200529     C                   PARM      '*VERIFY'     @OPTN             7
083800200529     C                   PARM      'S01401'      @SARD             6
083900200529     C     SCSARD        PARM      SCSARD        DSFDY
084000200529      *
084100200529     C     @RTCD         IFEQ      *BLANK
084200200529     C                   MOVEL     'Y'           S01401            1
084300200529     C                   ELSE
084400200529     C                   MOVEL     'N'           S01401
084500200529     C                   END
084600200529      *                                                                         154562
084700200529      ** Access SAR details file to determine if CSW003                         154562
084800200529      ** (MT5XX - Phase 2 Message Generation) is on.                            154562
084900200529      *                                                                         154562
085000200529     C                   CALLB     'AOSARDR0'                                   154562
085100200529     C                   PARM      '*BLANKS'     @RTCD                          154562
085200200529     C                   PARM      '*VERIFY'     @OPTN                          154562
085300200529     C                   PARM      'CSW003'      @SARD                          154562
085400200529     C     SCSARD        PARM      SCSARD        DSFDY                          154562
085500200529      *                                                                         154562
085600200529     C     @RTCD         IFEQ      *BLANK                                       154562
085700200529     C                   MOVE      'Y'           CSW003            1            154562
085800200529     C                   ELSE                                                   154562
085900200529     C                   MOVE      'N'           CSW003                         154562
086000200529     C                   ENDIF                                                  154562
086100200529      *                                                                         CAP051
086200200529      ** Access SAR details file to determine if CAP051 is on.                  CAP051
086300200529      ** (Automatic Authorisation (SE Trades Part))                             CAP051
086400200529      *                                                                         CAP051
086500200529     C                   CALLB     'AOSARDR0'                                   CAP051
086600200529     C                   PARM      *BLANKS       @RTCD                          CAP051
086700200529     C                   PARM      '*VERIFY'     @OPTN                          CAP051
086800200529     C                   PARM      'CAP051'      @SARD                          CAP051
086900200529     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
087000200529      *                                                                         CAP051
087100200529     C     @RTCD         IFEQ      *BLANK                                       CAP051
087200200529     C                   MOVEL     'Y'           CAP051            1            CAP051
087300200529     C                   ELSE                                                   CAP051
087400200529     C                   MOVEL     'N'           CAP051                         CAP051
087500200529     C                   END                                                    CAP051
087600200529      *                                                                                       CAP067
087700200529      ** Access SAR details file to determine if CAP067 is on.                                CAP067
087800200529      ** MM Repos API.                                                                        CAP067
087900200529      *                                                                                       CAP067
088000200529     C                   CALLB     'AOSARDR0'                                                 CAP067
088100200529     C                   PARM      *BLANKS       @RTCD                                        CAP067
088200200529     C                   PARM      '*VERIFY'     @OPTN                                        CAP067
088300200529     C                   PARM      'CAP067'      @SARD                                        CAP067
088400200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP067
088500200529      *                                                                                       CAP067
088600200529     C     @RTCD         IFEQ      *BLANK                                                     CAP067
088700200529     C                   MOVEL     'Y'           CAP067            1                          CAP067
088800200529     C                   ELSE                                                                 CAP067
088900200529     C                   MOVEL     'N'           CAP067                                       CAP067
089000200529     C                   ENDIF                                                                CAP067
089100200529                                                                                              CAS006
089200200529      ** Check if enhancement CAS006 (Hedge Accounting Phase B) is installed                  CAS006
089300200529                                                                                              CAS006
089400200529     C                   CALLB     'AOSARDR0'                                                 CAS006
089500200529     C                   PARM      *BLANKS       PRTCD                                        CAS006
089600200529     C                   PARM      '*VERIFY'     POPTN                                        CAS006
089700200529     C                   PARM      'CAS006'      PSARD                                        CAS006
089800200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
089900200529                                                                                              CAS006
090000200529     C                   IF        PRTCD = *BLANKS                                            CAS006
090100200529     C                   EVAL      CAS006 = 'Y'                                               CAS006
090200200529     C                   ELSE                                                                 CAS006
090300200529     C                   EVAL      CAS006 = 'N'                                               CAS006
090400200529     C                   ENDIF                                                                CAS006
090500200529      *                                                                                       CSE045
090600200529      ** Access SAR details file to determine if CSE045 is on.                                CSE045
090700200529      ** API Extended Settlements for Trade Input and Depot Movement                          CSE045
090800200529      *                                                                                       CSE045
090900200529     C                   CALLB     'AOSARDR0'                                                 CSE045
091000200529     C                   PARM      *BLANKS       @RTCD                                        CSE045
091100200529     C                   PARM      '*VERIFY'     @OPTN                                        CSE045
091200200529     C                   PARM      'CSE045'      @SARD                                        CSE045
091300200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE045
091400200529      *                                                                                       CSE045
091500200529     C     @RTCD         IFEQ      *BLANK                                                     CSE045
091600200529     C                   MOVEL     'Y'           CSE045            1                          CSE045
091700200529     C                   ELSE                                                                 CSE045
091800200529     C                   MOVEL     'N'           CSE045                                       CSE045
091900200529     C                   END                                                                  CSE045
092000200529
092100200529      ** Access SAR details file to determine if CGL031                                       CGL031
092200200529      ** (Taxation of savings Income) is on.                                                  CGL031
092300200529                                                                                              CGL031
092400200529     C                   CALLB     'AOSARDR0'                                                 CGL031
092500200529     C                   PARM      '*BLANKS'     PRTCD                                        CGL031
092600200529     C                   PARM      '*VERIFY'     POPTN                                        CGL031
092700200529     C                   PARM      'CGL031'      PSARD                                        CGL031
092800200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
092900200529      *                                                                                       CGL031
093000200529     C     PRTCD         IFEQ      *BLANK                                                     CGL031
093100200529     C                   MOVE      'Y'           CGL031                                       CGL031
093200200529     C                   ELSE                                                                 CGL031
093300200529     C                   MOVE      'N'           CGL031                                       CGL031
093400200529     C                   ENDIF                                                                CGL031
093500200529      *                                                                                       CGL031
093600200529      *  Hook to enable non-core initial processing to be included
093700200529      /COPY WNCPYSRC,SETRADU011
093800200529      *                                                                                       CER001
093900200529      ** Access Module Details to verify if Lux Return feature is active                      CER001
094000200529      *                                                                                       CER001
094100200529     C                   CALL      'AOMMODR0'                                                 CER001
094200200529     C                   PARM      *BLANKS       @RTCD                                        CER001
094300200529     C                   PARM      '*FIRST '     @OPTN                                        CER001
094400200529     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER001
094500200529      *                                                                                       CER001
094600200529      ** ULX603 - API Luxembourg - Function SETRAD                                            CER001
094700200529      *                                                                                       CER001
094800200529     C                   MOVEL     'N'           ULX603            1                          CER001
094900200529     C                   CALL      'AOSARDR0'                                                 CER001
095000200529     C                   PARM      *BLANKS       @RTCD                                        CER001
095100200529     C                   PARM      '*VERIFY'     @OPTN                                        CER001
095200200529     C                   PARM      'ULX603'      @SARD                                        CER001
095300200529      *                                                                                       CER001
095400200529     C     @RTCD         IFEQ      *BLANKS                                                    CER001
095500200529     C     BGLRIN        ANDEQ     'Y'                                                        CER001
095600200529     C                   MOVEL     'Y'           ULX603                                       CER001
095700200529     C                   OPEN      SEVTDLX1L1                                                 CER001
095800200529     C                   OPEN      SEVETDX1PD                                                 CER001
095900200529     C                   ENDIF                                                                CER001
096000200529      *                                                                                       CER001
096100200529
096200200529     C                   ENDSR
096300200529     C****************************************************************
096400200529      /EJECT
096500200529      ** The following /COPY contains the standard program status
096600200529      ** subroutine, including a bound call to the DBERRCTL module.
096700200529     C/COPY ZACPYSRC,PSSR_ILE
096800200529      /EJECT
096900200529**  CPY@
097000200529(c) Finastra International Limited 2001
