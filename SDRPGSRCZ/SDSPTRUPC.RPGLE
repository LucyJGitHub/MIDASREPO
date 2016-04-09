     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Spot rate database update controller')        *
      *****************************************************************
      *                                                               *
      *  Midas - SD Standing Data ILE Module                          *
      *                                                               *
      *  SDSPTRUPC - SD SPOT RATES UPDATE CONTROLLER                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT147             Date 14Jan13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG8205            Date 22Aug05               *
      *                 BUG8130            Date 10Aug05               *
      *                 CAP084             Date 26Aug03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      *                 200420             Date 22Nov01               *
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 03Nov00               *
      *                 CAP057  *CREATE    Date 03Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT147 - Automatic update of payment charges definitions     *
      *           Added hooks: CFT147_029, CFT147_030, CFT147_031,    *
      *           CFT147_032, CFT147_033, CFT147_034, CFT147_035      *
      *  BUG8205 - Recompiled due to changes in file SDVSPTRPD        *
      *            Applied fix 209061                                 *
      *  BUG8130- Recompiled as there have been changes to SDVSPTRPD  *
      *  CAP084 - API Wrapper project.  Override file SDCURRL0.       *
      *  204923 - Rate Fix Days Adjustment (OIS)                      *
      *           (Recompiled over changed SDVSPTRPD)                 *
      *  200420 - Database error due to file SDCURRL1 is being open   *
      *           when it is already opened                           *
      *  201589 - Change to check a new locking dataarea SDSPTRLCK    *
      *           to determine whether this DBU is already active.    *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP057 - Conversion of SPOT Rates into Modular APIs         *
      *                                                               *
      *****************************************************************
     FSDVSPTRPD UF   E             DISK
     F                                     COMMIT
     FSDVSPTRL1 UF   E           K DISK
     F                                     RENAME(SDVSPTRD0:SDVSPTRD1)
 
     FSDVESPTRPDO    E             DISK
     F                                     RENAME(SDVSPTRD0:SDVSPTRERR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDSPTRC001
 
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
 
      ** Include the SD standard declares
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
     D DBerrUpd        C                   CONST('DB error in SPTR API update')
 
      *****************************************************************
 
     D SDVTrn        E DS                  EXTNAME(SDVSPTRPD)
      **  Externally described data structure for valid transaction
 
     D SDSPTRUPC       DS             1    DTAARA(SDSPTRUPC)
 
     D/COPY OFCPYSRCZ,CFT147_029                                                              CFT147
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
 
     D Object          S             10A   INZ('SDSPTRUPC')
     D LockObj         S             10A   INZ('SDSPTRLCK')                                   201589
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
 
      ** Command length for QCMDEXC
     D CommandLen      S             15P 5 INZ(26)
 
      ** Data queue details
      ** ------------------
     D DtqLen          S              5P 0 INZ(10)
     D DtqWait         S              5P 0 INZ(-1)
     D DtqNam          S             10A   INZ('APSPTRDTQ')
     D DtqLib          S             10A   INZ('*LIBL')
     D DtqDta          S             10A
 
     D/COPY OFCPYSRCZ,CFT147_030                                                              CFT147
 
      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
      ** Override Database Table                                                              200420
     D*PCMD************S            100    DIM(2) CTDATA PERRCD(1)                      200420CAP084
     D PCMD            S            100    DIM(4) CTDATA PERRCD(1)                      200420CAP084
     D/COPY OFCPYSRCZ,CFT147_031                                                              CFT147
 
      ** Define module parameter fields for call to Update module
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDSPTRC002
 
      *******************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *******************************************************************
 
      /COPY WNCPYSRC,SDSPTRC003
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APSPTRDTQ'
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     C/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file
     C                   DOW       DtqDta <> 'END'
 
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam
     C                   PARM                    DtqLib
     C                   PARM                    DtqLen
     C                   PARM                    DtqDta
     C                   PARM                    DtqWait
 
      ** If data queue entry is 'END', leave the DOW loop at this point
     C                   IF        DtqDta = 'END'
     C                   LEAVE
     C                   ENDIF
 
      ** If data queue entry says run, first lock allocation data area
     C     DtqDta        IFEQ      'GO'
 
      ** Allocate with exclusive lock state
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      ** Ensure the U7 and U8 indicators are off, to prevent problems
      ** caused by earlier errors.
     C                   CLEAR                   *inu7
     C                   CLEAR                   *inu8
 
 
      /COPY WNCPYSRC,SDSPTRC004
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     SDVSPTRPD
 
      ** READ VALID SD Transaction
     C                   READ      SDVSPTRD0                              99    *
     C     *IN99         DOWEQ     '0'
 
      /COPY WNCPYSRC,SDSPTRC005
                                                                                              CAP084
      ** Override SDCURRL0                                                                    CAP084
                                                                                              CAP084
     C                   Z-ADD     32            MESLEN                                       CAP084
     C                   CALL      'QCMDEXC'                                                  CAP084
     C                   PARM                    PCMD(3)                                      CAP084
     C                   PARM                    MESLEN                                       CAP084
 
      ** Override SDCURRL1                                                                    200420
                                                                                              200420
     C                   Z-ADD     32            MESLEN                                       200420
     C                   CALL      'QCMDEXC'                                                  200420
     C                   PARM                    PCMD(1)                                      200420
     C                   PARM                    MESLEN                                       200420
                                                                                              200420
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lower level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = AVFOTRANID
     C                   EVAL      ARRprLocn  = AVRPRLOCN
     C                   EVAL      @Timestamp = AVTMESTMP
 
      /COPY WNCPYSRC,SDSPTRC006
 
      ** SD DATABASE UPDATE
     C                   CALLB     'SDSPTRUPD'
     C                   PARM      *BLANK        @@RTCD            7
     C                   PARM                    SDVTRN
     C/COPY OFCPYSRCZ,CFT147_032                                                              CFT147
                                                                                              CAP084
      ** Delete override of SDCURRL0                                                          CAP084
                                                                                              CAP084
     C                   Z-ADD     21            MESLEN                                       CAP084
     C                   CALL      'QCMDEXC'                                                  CAP084
     C                   PARM                    PCMD(4)                                      CAP084
     C                   PARM                    MESLEN                                       CAP084
 
      *                                                                                       200420
      ** Delete override of SDCURRL1                                                          200420
     C                   Z-ADD     21            MESLEN                                       200420
     C                   CALL      'QCMDEXC'                                                  200420
     C                   PARM                    PCMD(2)                                      200420
     C                   PARM                    MESLEN                                       200420
      *                                                                                       200420
      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C                   ROLBK
     C                   ELSE
     C                   DELETE    SDVSPTRD0
     C                   COMMIT
     C/COPY OFCPYSRCZ,CFT147_033                                                              CFT147
     C                   ENDIF
 
      /COPY WNCPYSRC,SDSPTRC007
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C                   EVAL      @TrSPTR = AVCYCD
     C                   EVAL      @Timestamp = AVTMESTMP
     C     @KeySPTRL1    CHAIN     SDVSPTRL1
     ** Write details of record to error file (same format as SDVSPTRPD)
     C                   WRITE     SDVSPTRERR
     C                   DELETE    SDVSPTRD1
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** READ VALID SD Transaction Details
     C                   READ      SDVSPTRD0                              99    *
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
 
      /COPY WNCPYSRC,SDSPTRC008
 
      * EXIT FROM PROGRAM
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDSPTRC009
 
      *****************************************************************
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
 
      *  Define key list for SDVSPTRL1
     C     @KeySPTRL1    KLIST
     C                   KFLD                    @TrSPTR           3
     C                   KFLD                    @Timestamp
 
      *  Check if an existing DBU_SPRT job is active in the subsystem.                        201589
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
      *
     C* Overrride SDSPTRLR
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDSPTRC010
     C/COPY OFCPYSRCZ,CFT147_034                                                              CFT147
 
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'SDSPTRUPD'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** ##OX1
OVRDBF FILE(SDCURRLR) TOFILE(SDCURRL0) SHARE(*NO)
** PCMD                                                                                       200420
OVRDBF FILE(SDCURRL1) SHARE(*NO)                                                              200420
DLTOVR FILE(SDCURRL1)                                                                         200420
OVRDBF FILE(SDCURRL0) SHARE(*NO)                                                              CAP084
DLTOVR FILE(SDCURRL0)                                                                         CAP084
     X/COPY OFCPYSRCZ,CFT147_035                                                              CFT147
