     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV database update controller')             *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEDPMVUPC - Depot Movement Database Update Controller        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 235844             Date 05Sep05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSC022             Date 24Feb04               *
      *                 222373             Date 14Oct02               *
      *                 222727             Date 05Nov03               *
      *                 CSD015             Date 14Oct02               *
      *                 CSE039             Date 21Jan03               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 207006             Date 18Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 167486             Date 11Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE015             Date 06Dec99               *
      *                 CSE017             Date 20Oct99               *
      *                 CSE012             Date 16Aug99               *
      *                 CPB001             Date 26Aug99               *
      *                 167354             Date 09Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 17Mar99               *
      *                 CAP003 *CREATE     Date 24Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  235844 - Parameter missing when call SEDPMVUPD.              *
      *           Change /COPY SEDPMVU005.                            *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  222373 - Parameter Mismatch                                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CSE039 - Auto-settle of trades.  Recompile                   *
      *  207006 - Add Counterparty & Market Centre to SSI (Recompile) *
      *  201589 - Change to check a new locking dataarea SEDPMVLCK    *
      *           to determine whether this DBU is already active.    *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *           (Recompiled).                                       *
      *  167486 - Default and write record to extension file.         *
      *  CSE015 - Forward Valued Depot Movements (Recompiled)         *
      *  CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled)    *
      *  CSE012 - SE Depot Movement Narratives (Recompiled).          *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *         - 'Private Banking' Module                            *
      *           Recompiled due to database changes                  *
      *  167354 - Depot movement interface crashes & update function  *
      *           rejects movements on SEVDPMVPD.                     *
      *           (Module re-compiled over new layout of SEVDPMVPD)   *
      *  CAP006 - Check for deal being updated by another workstation *
      *         - Send prompt to DTAQ to restart update process after *
      *           failure.                                            *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FSEVDPMVPD UF   E             DISK    COMMIT
     F                                     INFSR(*PSSR)
 
     FSEVDPMVL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEVDPMVD0:SEVDPMVD1)
 
     FSEVEDPMVPDO    E             DISK    INFSR(*PSSR)
     F                                     RENAME(SEVDPMVD0:SEVDPMVERR)
 
     FDPTMVDY1  UF A E           K DISK    INFSR(*PSSR)                                       167486
     F                                     COMMIT                                             167486
                                                                                              167486
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SEDPMVU007
                                                                                              CER001
     FSEVEDMX3PDO    E             DISK    USROPN                                             CER001
     F                                     RENAME(SEVDMLXD6:SEVDMLXD6R)                       CER001
     FSEVDMLX1L1UF   E           K DISK    USROPN                                             CER001
     F                                     COMMIT                                             CER001
     F                                     RENAME(SEVDMLXD6:SEVDMLXZ6R)                       CER001
 
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
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022
 
     D DBerrUpd        C                   CONST('DB error in SE API update')
 
      ** Externally Dexcribe DS for Valid DPMV Trans
     D SEDPMVS       E DS                  EXTNAME(SEVDPMVPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  167486
                                                                                              167486
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     167486
                                                                                              167486
     D SEDPMVUPC       DS             1    DTAARA(SEDPMVUPC)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
     D  WLCD         E                     EXTFLD(LCD)                                        CSC022
      ** DS for SAR Detail record                                                             CSC022
                                                                                              CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
                                                                                              CSC022
      ** Additional entry parameter for Midas Compliance Watch                                CSD015
     D PMCWL           DS          9999                                                       CSD015
                                                                                              CSD015
     D Object          S             10A   INZ('SEDPMVUPC')
     D LockObj         S             10A   INZ('SEDPMVLCK')                                   201589
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
                                                                                              CGL031
      ** access object                                                                        CGL031
     D PRtcd           S              7A                                                      CGL031
     D POptn           S              7A                                                      CGL031
     D PSard           S              6A                                                      CGL031
     D CGL031          S              1A                                                      CGL031
                                                                                              CSC022
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
      *                                                                                       CER001
      ** Introduced by CER001                                                                 CER001
      *                                                                                       CER001
     D ULX602          S              1A                                                      CER001
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SEDPMVU008
      *                                                                                       CER001
      ** External data structures for Midas Modules                                           CER001
      *                                                                                       CER001
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CER001
                                                                                              CER001
      ** New valid extended Depot File                                                        CER001
     D SEVDMLX6      E DS                  EXTNAME(SEVDMLX1L0)                                CER001
     D SEVDMLX6S     E DS                  EXTNAME(SEVDMLX1L0)                                CER001
     D                                     PREFIX(SS)                                         CER001
                                                                                              CER001
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** MAIN BODY
      ** ---------
      *
 
      /COPY WNCPYSRC,SEDPMVU001
 
      ** Set up the name of the server/database updater data queue.             CAP006
     C                   EVAL      DtaQName = 'APDPMVDTQ'                       CAP006
                                                                                CAP006
      **------------------------------------------------------------------------CAP006--------------
      ** The following /COPY line includes a check for whether there            CAP006
      ** are messages on the server/updater data queue, and sends a 'GO'.       CAP006
      ** message to the data queue if there are not.                            CAP006
     D/COPY ZACPYSRC,DTAQCHK                                                    CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006
      ** Initialise Data queue parms
      *
     C                   EVAL      DtqLen = 10
     C                   EVAL      DtqWait = -1
     C                   EVAL      DtqNam = 'APDPMVDTQ'
     C                   EVAL      DtqLib = '*LIBL'
      *
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file
      *
     C     DtqDta        DOWNE     'END'
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam           10
     C                   PARM                    DtqLib           10
     C                   PARM                    DtqLen            5 0
     C                   PARM                    DtqDta           10
     C                   PARM                    DtqWait           5 0
      *
      ** Lock allocation data area
      *
     C     DtqDta        IFEQ      'GO'
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      /COPY WNCPYSRC,SEDPMVU002
 
      *
      ** Position file cursor to start of file to prevent problems on
      ** later calls
      *
     C     1             SETLL     SEVDPMVPD
      *
      ** Read Valid SE DPMV Transactions
      *
     C                   READ      SEVDPMVPD                              99    *
 
     C     *IN99         DOWEQ     '0'
 
      /COPY WNCPYSRC,SEDPMVU003
 
      *
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lowere level modules
      **  will include the key information
      *
     C                   EVAL      ARFOTranID = DMFRNT
     C                   EVAL      ARRprLocn  = DMREPA
      *                                                                                       CER001
     C                   EVAL      #6LXWNFOTR = DMFRNT                                        CER001
     C                   EVAL      #6LXWNTMES = DMTMST                                        CER001
 
      /COPY WNCPYSRC,SEDPMVU004
      *                                                                                       CER001
      ** ULX602 - API Luxembourg - Function SEPDMV                                            CER001
      *                                                                                       CER001
     C                   IF        ULX602 <> 'Y'                                              CER001
 
      *
      ** SE Database update
      *
     C                   CALLB     'SEDPMVUPD'                                                167354
     C                   PARM      *BLANK        @@RTCD           10                          167354
     C                   PARM                    SEDPMVS                                      167354
     C                   PARM                    PMCWL                                        CSD015
     C                   PARM                    V_NOTM            7                          222373
     C                   PARM                    V_MSGK           40                          222373
     C                   PARM                    CGL031                                       CGL031
     C/COPY WNCPYSRC,SEDPMVUC04
                                                                                              167354
     C     CHTP          IFEQ      'I'                                                        167486
     C                   EXSR      SRUpdExtF                                                  167486
     C                   END                                                                  167486
                                                                                              167486
     C*****@@RTCD********IFNE      '*RECUPD'                                           CAP006 167354
     C*****CHTP**********IFEQ      'I'                                                        167354
     C*****CHTP**********OREQ      'A'                                                        167354
     C*****CHTP**********OREQ      'D'                                                        167354
     C*******************CALLB     'SEDPMVUPD'                                                167354
     C*******************PARM                    @@RTCD            7                          167354
     C*******************PARM                    SEDPMVS                                      167354
     C*******************END                                                                  167354
     C*******************END                                                           CAP006 167354
      *
      ** COMIT Updates if no error
      *
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   ELSE
 
     C                   DELETE    SEVDPMVPD                            98
 
     C     *IN98         IFEQ      '1'
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   MOVEL     'SEVDPMVPD'   DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     *BLANKS       DBKEY                          ************
     C                   MOVE      DMFRNT        DBKEY
     C                   MOVEL     DMTMST        DBKEY
     C                   EXSR      *PSSR
     C                   END
     C/COPY WNCPYSRC,SEDPMVUC05
      *                                                                                       CSC022
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
 
     C                   END
 
      /COPY WNCPYSRC,SEDPMVU005
      *                                                                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
      ** Master files update                                                                  CER001
      *                                                                                       CER001
     C                   CALLB     'SEDPMVUPD'                                                CER001
     C                   PARM      *BLANKS       @@RTCD                                       CER001
     C                   PARM                    SEDPMVS                                      CER001
     C                   PARM                    PMCWL                                        CER001
     C                   PARM                    V_NOTM                                       CER001
     C                   PARM                    V_MSGK                                       CER001
      *                                                                                       CER001
     C                   IF        @@RTCD = *BLANKS                                           CER001
      *                                                                                       CER001
     C                   DELETE    SEVDPMVPD                            98                    CER001
     C                   IF        *IN98 = '1'                                                CER001
      *                                                                                       CER001
     C                   IF        (CSC022 <> 'Y')                                            CER001
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CER001
     C                   ROLBK                                                                CER001
     C                   ENDIF                                                                CER001
     C                   EVAL      DBFILE = 'SEVDPMVPD'                                       CER001
     C                   EVAL      DBASE  = 004                                               CER001
     C                   EVAL      DBKEY  = *BLANKS                                           CER001
     C                   MOVE      DMFRNT        DBKEY                                        CER001
     C                   MOVEL     DMTMST        DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** When no error in master files update, update extension files                         CER001
      ** For SE, no physical delete on extension files, it is done during                     CER001
      ** COB when system 'purge' SE master files                                              CER001
      *                                                                                       CER001
     C     K@XZ6         CHAIN     SEVDMLX1L1                         89                      CER001
      *                                                                                       CER001
     C                   IF        CHTP = 'I' OR                                              CER001
     C                             CHTP = 'A'                                                 CER001
      *                                                                                       CER001
      ** Retrieve Extended valid records                                                      CER001
      *                                                                                       CER001
     C                   CALLB     'SEDPMV2UP'                                                CER001
     C                   PARM                    CHTP                                         CER001
     C                   PARM      *BLANKS       @@RTCD                                       CER001
     C                   PARM      *BLANKS       @@FIND            1                          CER001
     C                   PARM                    SEVDMLX6                                     CER001
     C                   PARM      *BLANKS       SEVDMLX6S                                    CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @@RTCD = *BLANKS                                           CER001
     C                   DELETE    SEVDMLXZ6R                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** COMIT Updates if no error                                                            CER001
      *                                                                                       CER001
     C                   IF        @@RTCD = '*ERROR ' OR                                      CER001
     C                             @@RTCD = '*RECUPD'                                         CER001
      *                                                                                       CER001
     C                   IF        (CSC022 <> 'Y')                                            CER001
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CER001
     C                   ROLBK                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ELSE                                                                 CER001
      *                                                                                       CER001
     C                   IF        (CSC022 <> 'Y')                                            CER001
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CER001
     C                   COMMIT                                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If an error has occurred, reaccess record in error and remove from                   CER001
      ** the file and write details of record to error valid file                             CER001
      *                                                                                       CER001
     C                   IF        ULX602 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   IF        @@RTCD = '*ERROR ' OR                                      CER001
     C                             @@RTCD = '*RECUPD'                                         CER001
      *                                                                                       CER001
     C     K@XZ6         CHAIN     SEVDMLX1L1                         89                      CER001
      *                                                                                       CER001
     C                   WRITE     SEVDMLXD6R                                                 CER001
     C                   DELETE    SEVDMLXZ6R                                                 CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
 
      *
      ** If an error has occurred, reaccess record in error and remove from
      ** the file to prevent program processing the same record again
      *
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
 
     C                   EVAL      @Dealno = DPRN
     C                   EVAL      @Timestamp = DMTMST
 
     C     @KDPMVL1      CHAIN     SEVDPMVL1                          89
      *
      ** Write details of record to error file (same format as SEVDPMVPD)
      *
     C                   WRITE     SEVDPMVERR                           98
 
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'SEVEDPMVPD'  DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   MOVEL     *BLANKS       DBKEY                          ************
     C                   MOVE      DMFRNT        DBKEY
     C                   MOVEL     DMTMST        DBKEY
     C                   EXSR      *PSSR
     C                   END
 
     C                   DELETE    SEVDPMVD1                            98
 
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'SEVDPMVPD'   DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 003*
     C                   MOVEL     *BLANKS       DBKEY                          ************
     C                   MOVE      DPRN          DBKEY
     C                   MOVEL     DMTMST        DBKEY
     C                   EXSR      *PSSR
     C                   END
     C/COPY WNCPYSRC,SEDPMVUC06
      *
      ** Send message to system operator
      *
     C                   MOVEL     DBerrUpd      DBError          28
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
      *
      ** Read Valid SE DPMV Transaction
      *
     C                   READ      SEVDPMVPD                              99    *
     C                   END
      *
      ** Unlock allocation data area
      *
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Return
     C                   END
      *
      ** End loop for data queue prompt
      *
     C                   END
 
      /COPY WNCPYSRC,SEDPMVU006
      *
      ** Exit from program
      *
     C                   IF        ULX602 = 'Y'                                               CER001
     C                   CLOSE     SEVEDMX3PD                                                 CER001
     C                   CLOSE     SEVDMLX1L1                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SEDPMVU009
 
      *****************************************************************
      /EJECT
      *****************************************************************                       167486
      *                                                               *                       167486
      * SRUpdExtF - Extension File Details update routine             *                       167486
      *                                                               *                       167486
      * Called by: Main processing                                    *                       167486
      *                                                               *                       167486
      * Calls: None                                                   *                       167486
      *                                                               *                       167486
      *****************************************************************                       167486
                                                                                              167486
     C     SRUpdExtF     BEGSR                                                                167486
                                                                                              167486
      *                                                                                       167486
      ** Clear extension file fields                                                          167486
      *                                                                                       167486
     C                   CLEAR                   DPTMVDD1                                     167486
      *                                                                                       167486
      ** Default fields                                                                       167486
      *                                                                                       167486
     C                   MOVE      DPSS          DPDPSS                                       167486
     C                   MOVE      DPRN          DPDPRN                                       167486
     C                   MOVE      'N'           DPCONG                                       167486
     C                   MOVE      'N'           DPRCDG                                       167486
     C                   Z-ADD     BJRDNB        DPLCD                                        167486
     C                   MOVE      'N'           DPGMES                                       167486
     C                   MOVE      'F'           DPFIND                                       167486
     C                   MOVE      'N'           DPGMEC                                       167486
                                                                                              167486
     C                   TIME                    WWTIME            6 0                        167486
     C                   MOVEL     WWTIME        DPTRTT                                       167486
                                                                                              167486
     C                   MOVE      'Y'           DPSCMG                                       167486
     C                   MOVE      'S'           DPWHEN                                       167486
     C/COPY WNCPYSRC,SEDPMVUC01
      *                                                                                       167486
      ** Write details of record to extension file                                            167486
      *                                                                                       167486
     C                   WRITE     DPTMVDD1                                                   167486
     C/COPY WNCPYSRC,SEDPMVUC02
                                                                                              167486
     C                   ENDSR                                                                167486
     C****************************************************************                        167486
      /EJECT                                                                                  167486
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *InzSR        BEGSR
      *
      **  Define key list for SEVDPMVL1
      *
     C     @KDPMVL1      KLIST
     C                   KFLD                    @Dealno           6
     C                   KFLD                    @Timestamp
      *                                                                                       CER001
     C     K@XZ6         KLIST                                                                CER001
     C                   KFLD                    #6LXWNFOTR                                   CER001
     C                   KFLD                    #6LXWNTMES                                   CER001
 
     C                   MOVEL     'SEDPMVUPC'   DBPGM
      *
      *  Check if an existing DBU_DPMV job is active in the subsystem.                        201589
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
      ** Lock allocation data area
      ** -------------------------
      *
      ** *******************************************************************
      **  The data area is allocated *SHRRD here and *EXCL whilst processing
      **  of the valid file is actually taking place.
      **  The function to submit this updater tries to get a *EXCL lock.
      **  The controller tries to get a *SHRRD lock.
      ** *******************************************************************
 
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
      *                                                                                       167486
      ** Access bank details                                                                  167486
      *                                                                                       167486
     C                   CALLB     'AOBANKR0'                                                 167486
     C                   PARM      *BLANKS       @RTCD             7                          167486
     C                   PARM      '*FIRST '     @OPTN             7                          167486
     C     SDBANK        PARM      SDBANK        DSFDY                                        167486
      *                                                                                       167486
      * DATABASE ERROR                                                                        167486
      *                                                                                       167486
     C     @RTCD         IFNE      *BLANKS                                                    167486
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************  167486
     C                   MOVEL     '901'         DBASE                          * DBERR 901*  167486
     C                   MOVEL     @OPTN         DBKEY                          ************  167486
     C                   EXSR      *PSSR                                                      167486
     C                   END                                                                  167486
      *                                                                                       CSC022
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD             6                          CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
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
     C                   If        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 902                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
                                                                                              CGL031
      ** Access Switchable Features File, for Taxation Savings Income CGL031                  CGL031
                                                                                              CGL031
     C                   MOVE      'N'           CGL031                                       CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtcd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSard                                        CGL031
                                                                                              CGL031
     C                   IF        PRtcd = *BLANKS                                            CGL031
     C                   MOVE      'Y'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
      ** Database Error                                                                       CGL031
                                                                                              CGL031
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '                    CGL031
     C                   MOVEL     'CGL031 '     DBKEY                                        CGL031
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL031
     C                   MOVEL     '902'         DBASE                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SEDPMVU010
      *                                                                                       CER001
      ** Access Module Details to verify if Lux Return feature is active                      CER001
      *                                                                                       CER001
     C                   CALL      'AOMMODR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*FIRST '     @OPTN                                        CER001
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER001
      *                                                                                       CER001
      ** Call program exception error routine for database error                              CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS                                           CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = '*FIRST'                                           CER001
     C                   EVAL      DBFILE = 'SDMMODPD'                                        CER001
     C                   EVAL      DBASE = 903                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX602 - API Luxembourg - Function SEDPMV                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX602                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX602'      @SARD                                        CER001
     C     SCSARD        Parm      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS AND                                        CER001
     C                             BGLRIN = 'Y'                                               CER001
     C                   EVAL      ULX602 = 'Y'                                               CER001
     C                   OPEN      SEVEDMX3PD                                                 CER001
     C                   OPEN      SEVDMLX1L1                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If return code <> *NRF, call program exception error routine                         CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF'                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX602'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 904                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     KLX602        KLIST                                                                CER001
     C                   KFLD                    DPSS                                         CER001
     C                   KFLD                    DPRN                                         CER001
      *                                                                                       CER001
 
     C                   ENDSR
     C/COPY WNCPYSRC,SEDPMVUC03
     C****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
