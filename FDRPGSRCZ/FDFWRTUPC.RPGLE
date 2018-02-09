     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD Forward rates database update controller')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing ILE Module                                   *
      *                                                               *
      *  FDFWRTUPC - FD Forward Rates Database Update Controller      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 241919             Date 22Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG8233            Date 23Aug05               *
      *                 BUG8141            Date 11Aug05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 19Oct00               *
      *                 CAP059             Date 19Oct00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 19Jan99               *
      *                 CAP005  *CREATE    Date 17Oct98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  241919 - Recompiled due to changes done to FDVFWRTPD.        *
      *  BUG8233- Error in Forward Rates upload via File Adapter API  *
      *           (Recompile)                                         *
      *  BUG8141- Recompiled due to changes to FDVFWRTPD              *
      *  201589 - Change to check a new locking dataarea FDFWRTLCK    *
      *           to determine whether this DBU is already active.    *
      *  CSD006 - Recompiled due to MDF changes.                      *
      *  CAP059 - Conversion of Forward Rates into Modular APIs       *
      *  CAP006 - Send prompt to DTAQ to restart update process after *
      *           failure.                                            *
      *  CAP005 - Conversion of Citydealer Rates upload to use APIs   *
      *                                                               *
      *****************************************************************
     FFDVFWRTPD UF   E             DISK
     F                                     COMMIT
     FFDVFWRTL1 UF   E           K DISK
     F                                     RENAME(FDVFWRTD0:FDVFWRTD1)
     FFDVEFWRTPDO    E             DISK
     F                                     RENAME(FDVFWRTD0:FDVFWRTERR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
     D DBerrUpd        C                   CONST('DB error in Fwd Rt update')
 
      *****************************************************************
 
      **  Externally described data structure for valid Forward Rates record
     D FDVFWR        E DS                  EXTNAME(FDVFWRTPD)
 
     D FDFWRTUPC       DS             1
 
     D Object          S             10A   INZ('FDFWRTUPC')
     D LockObj         S             10A   INZ('FDFWRTLCK')                                   201589
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
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
 
      /COPY WNCPYSRC,FDFWRTU001
 
      ** Set up the name of the server/database updater data queue.             CAP006
     C                   EVAL      DtaQName = 'APFWRTDTQ'                       CAP006
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
     C                   EVAL      DtqNam = 'APFWRTDTQ'
     C                   EVAL      DtqLib = '*LIBL'
     C                   EVAL      ObjType = '*DTAARA'
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid forward rates file
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
 
      /COPY WNCPYSRC,FDFWRTU002
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     FDVFWRTPD
 
      ** Read valid Forward Rates record
     C                   READ      FDVFWRTD0                              99    *
     C     *IN99         DOWEQ     '0'
 
      /COPY WNCPYSRC,FDFWRTU003
 
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = FWCCY
     C                   EVAL      ARRprLocn  = FWREPA
 
      /COPY WNCPYSRC,FDFWRTU004
 
      ** FD DATABASE UPDATE
     C                   CALLB     'FDFWRTUPD'
     C                   PARM                    @@RTCD            7
     C                   PARM                    FDVFWR
 
      /COPY WNCPYSRC,FDFWRTU005
 
      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C                   ROLBK
     C                   ELSE
     C                   DELETE    FDVFWRTD0
     C                   COMMIT
     C                   END
 
      /COPY WNCPYSRC,FDFWRTU006
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C                   EVAL      @Currency = FWCCY
     C                   EVAL      @Timestamp = FWTMESTMP
     C     @KFWRL1       CHAIN     FDVFWRTL1                          89
     ** Write details of record to error file (same format as FDVFWRTPD)
     C                   WRITE     FDVFWRTERR
     C                   DELETE    FDVFWRTD1
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** Read valid forward rates record
     C                   READ      FDVFWRTD0                              99    *
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
 
      /COPY WNCPYSRC,FDFWRTU007
 
      * EXIT FROM PROGRAM
     C                   RETURN
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
 
      *  Define data area used to check if DB update running
     C     *DTAARA       DEFINE                  FDFWRTUPC
 
      *  Define key list for FDFWRTLL1
     C     @KFWRL1       KLIST
     C                   KFLD                    @Currency         3
     C                   KFLD                    @Timestamp
 
      *  Check if an existing DBU_FWRT job is active in the subsystem.                        201589
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
 
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2001
