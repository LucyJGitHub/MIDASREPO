     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Statmts Prod. Requests - DB Update Ctrl')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SESTPRUPC - Statement Production Requests              *
      *                  - D.B. Update Controller                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSE040   *CREATE   Date 28Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEVSTPRPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Valid Statement Production Requests
 
     FSEVESTPRPDO    E             DISK    INFSR(*PSSR)
     F                                     RENAME(SEVSTPRD0:SEVESTPRD0)
     F                                     COMMIT
      ** Valid Statement Production Requests in Error from D.B.U.
 
      /COPY WNCPYSRC,SESTPRU001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
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
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *****************************************************************
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
 
     D DBerrUpd        C                   CONST('DB error in STPR API update')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D NewSESTPR     E DS                  EXTNAME(SEVSTPRPD)
      ** Valid Statement Production Request record layout
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for APCALCOBJ
     D Object          S             10A   INZ('SESTPRUPC')
     D LockObj         S             10A   INZ('SESTPRLCK')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockStateE      S              7A   INZ('*EXCL')
     D LockStateS      S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('*CLS')
     D Dlcobj          S              1A
     D Return          S              7A
     D Return2         S              7A
     D Endjob          S              1A   INZ('Y')
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Data queue details
     D DtqNam          S             10A   INZ('APSTPRDTQ')
     D DtqLib          S             10A   INZ('*LIBL')
     D DtqLen          S              5P 0 INZ(10)
     D DtqDta          S             10A
     D DtqWait         S              5P 0 INZ(-1)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      /COPY WNCPYSRC,SESTPRU002
 
      *****************************************************************
      /EJECT
      *******************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SESTPRU003
 
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DtaQName = 'APSTPRDTQ'
      *
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
 
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file
      *
 B1  C                   DOW       DtqDta <> 'END'
      *
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam
     C                   PARM                    DtqLib
     C                   PARM                    DtqLen
     C                   PARM                    DtqDta
     C                   PARM                    DtqWait
      *
      ** If data queue entry is 'END', leave the loop at this point
      *
 B2  C                   IF        DtqDta = 'END'
     C                   LEAVE
 E2  C                   ENDIF
      *
      ** If data queue entry says run, first lock allocation data area
      *
 B2  C                   IF        DtqDta = 'GO'
      *
      ** Allocate with exclusive lock state
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *Blanks       Return
      *
      ** If the "*EXCL" allocation is impossible, it is most likely because
      ** another update controller is already running for the same API,
      ** (possible if, for example, submitted twice to a hold job queue,
      ** which was released some time later), or because there is something
      ** else wrong (data area not existing, or not authorised...).
      ** In any case, terminate the current module.
      *
 B3  C                   IF        Return <> *Blanks
     C                   SETON                                        LR
     C                   LEAVE
 E3  C                   ENDIF
      *
      /COPY WNCPYSRC,SESTPRU004
      *
      ** Position file cursor to start of file to prevent problems on
      ** later calls
      *
     C     1             SETLL     SEVSTPRD0
      *
      ** Read next valid record
      *
     C                   READ      SEVSTPRD0                              99
      *
 B3  C                   DOW       NOT *IN99
      *
      /COPY WNCPYSRC,SESTPRU005
      *
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      ** will include the key information
      *
     C                   EVAL      ARFOTRANID = VSPFRNT
     C                   EVAL      ARFOASOCID = VSPAFRT
     C                   EVAL      ARRPRLOCN  = VSPREPA
      *
      /COPY WNCPYSRC,SESTPRU006
      *
      ** SE Statement Production Request Database Update
      *
     C                   CALLB     'SESTPRUPD'
     C                   PARM      *Blanks       @RtCd
     C                   PARM                    VSPCHTP
     C                   PARM                    NewSESTPR
      *
      ** If error: .Roll back any changes done by the update module
      **           .Send a message to the system operator
      **           .Write the current valid record into the valid error file
      *
 B4  C                   IF        @RtCd = '*ERROR ' OR
     C                             @RtCd = '*RECUPD'
     C                   ROLBK
      *
     C                   MOVEL     DBerrUpd      DBError
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError          28
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
      *
 B5  C                   IF        VSPCHTP = 'I'
     C                   EVAL      VSPRSEQ = 9999999
 E5  C                   ENDIF
      *
     C                   WRITE     SEVESTPRD0
 E4  C                   ENDIF
      *
      /COPY WNCPYSRC,SESTPRU007
      *
      ** The current valid record must anyway be deleted. Then commit all changes,
      ** including those from the update module, if there was no error.
      *
     C                   DELETE    SEVSTPRD0
     C                   COMMIT
      *
      /COPY WNCPYSRC,SESTPRU008
      *
      ** Read next valid record
      *
     C                   READ      SEVSTPRD0                              99
 E3  C                   ENDDO
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
 E2  C                   ENDIF
      *
      ** End loop for data queue prompt
      *
 E1  C                   ENDDO
 
      /COPY WNCPYSRC,SESTPRU009
 
      ** Exit from Module
      *
     C                   RETURN
 
      /COPY WNCPYSRC,SESTPRU010
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
      *  Check if an existing DBU_STPR job is active in the subsystem.
 
     C                   CALL      'SCC0520'
     C                   PARM                    LockObj
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Endjob
     C                   PARM                    Return2
      *
      ** Lock allocation data area
      *
      ** The data area is allocated *SHRRD here and *EXCL whilst processing
      **  of the valid file is actually taking place.
      ** The function to submit this updater tries to get a *EXCL lock.
      ** The controller tries to get a *SHRRD lock. If it doesn't work,
      ** it can be because: .Another database updtate is already running for
      **                     this API.
      **                    .The allocation data area doesn't exist or can't
      **                     be accessed.
      **                    .In any case, terminate the current module.
      *
      **                          Submitter                    Controller
      **                  Lock      Lock     Submitter       Lock     Controller
      **     Status      Status   Successful   Action     Successful    Action
      **     ------      ------   ---------- ---------    ----------  ----------
      **  Not running    None        Yes      Submit         Yes        Prompt
      **                                      updater                   updater
      *
      **  Running not    *SHRRD      No        None          Yes        Prompt
      **   processing                                                   updater
      *
      **  Processing     *EXCL       No        None          No         Exit
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateS
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *Blanks       Return
      *
     C                   IF        Return <> *Blanks
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      ** Create required QTEMP objects
      *
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde        10
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      /COPY WNCPYSRC,SESTPRU011
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2003
