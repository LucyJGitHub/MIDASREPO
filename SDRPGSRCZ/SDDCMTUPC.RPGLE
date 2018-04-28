     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Document Management Update Controller')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDDCMTUPC - SD Document Management Update Interface Control  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSD093  *CREATE    Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************
 
     FSDVDCMTPD UF   E             DISK    COMMIT
     FSDVDCMTL1 UF   E           K DISK    RENAME(SDVDCMTD0:SDVDCMTD1)
     FSDEDCMTPD O    E             DISK    RENAME(SDEDCMTD0:SDVDCMTERR)
 
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
 
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   Const('DB error in DCMT API update')
 
      *****************************************************************
 
      ** Externally Described Data Structure for Valid Document Management
     D SDVDCMT       E DS                  Extname(SDVDCMTPD)
 
     D SDDCMTUPC       DS             1    Dtaara(SDDCMTUPC)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  Extname(DSFDY)
 
     D Object          S             10A   INZ('SDDCMTUPC')
     D LockObj         S             10A   INZ('SDDCMTLCK')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockStateE      S              7A   INZ('*EXCL')
     D LockStateS      S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('*CLS')
     D Dlcobj          S              1A
     D RETURN          S              7A
     D RETURN2         S              7A
     D Endjob          S              1A   INZ('Y')
     D PCuCUST         S             10A
     D PCuRTYP         S              1A
     D PCuCODE         S              2A
     D PCuSEQN         S              3S 0
     D PTimestamp      S             26A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   Like(#MsgID)
     D DummyMsgF       S             10A
 
      ** Data queue details
      ** ------------------
     D DtqLen          S              5P 0 Inz(10)
     D DtqWait         S              5P 0 Inz(-1)
     D DtqNam          S             10A   Inz('APDCMTDTQ')
     D DtqLib          S             10A   Inz('*LIBL')
     D DtqDta          S             10A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *******************************************************************
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APDCMTDTQ'
 
     D/COPY ZACPYSRC,DTAQCHK
 
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
     C                   IF        DtqDta = 'GO'
 
      ** Allocate with exclusive lock state
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    RETURN
 
      ** Ensure the U7 and U8 indicators are off, to prevent problems
      ** caused by earlier errors.
     C                   CLEAR                   *INU7
     C                   CLEAR                   *INU8
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     SDVDCMTPD
 
      ** Read Valid SD Document Management
     C                   READ      SDVDCMTD0                              99
     C                   DOW       *IN99 = *OFF
 
      ** Load the API dump data area with as many fields from the message
      **  header as are available, so that dumps in any lower level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = DVFOID
     C                   EVAL      ARFOAsocID = *BLANKS
     C                   EVAL      ARRprLocn  = DVREPA
     C                   EVAL      PTimestamp = DVTMST
 
      ** SD Database Update
     C                   CALLB     'SDDCMTUPD'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM                    SDVDCMT
 
      ** Commit updates if no error
     C                   IF        PRTCD  = '*ERROR '
     C                             OR PRTCD  = '*RECUPD'
     C                   ROLBK
     C                   ELSE
     C                   DELETE    SDVDCMTD0
     C                   COMMIT
     C                   ENDIF
 
      ** If an error has occurred, reaccess record in error and remove from
      ** the file to prevent program processing the same record again
     C                   IF        PRTCD  = '*ERROR '
     C                             OR PRTCD  = '*RECUPD'
     C                   EVAL      PCuCUST = DVREFN
     C                   EVAL      PCuRTYP = DVRTYP
     C                   EVAL      PCuCODE = DVCODE
     C                   EVAL      PCuSEQN = DVSEQN
     C                   EVAL      PTimestamp = DVTMST
 
     C     KValRec       CHAIN     SDVDCMTL1                          89
 
      ** Write details of record to error file (same format as SDVDCMTPD)
     C                   WRITE     SDVDCMTERR
     C                   DELETE    SDVDCMTD1
 
      ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
     C                   READ      SDVDCMTD0                              99
     C                   ENDDO
 
      ** Unlock allocation data area
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    RETURN
 
     C                   ENDIF
      ** End loop for data queue prompt
     C                   ENDDO
 
      ** Exit from program
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Define key list for SDVDCMTL0
     C     KValRec       KLIST
     C                   KFLD                    PCuCUST
     C                   KFLD                    PCuRTYP
     C                   KFLD                    PCuCODE
     C                   KFLD                    PCuSEQN
     C                   KFLD                    PTimestamp
 
      ** Check if an existing DBU_DCMT job is active in the subsystem.
     C                   CALL      'SCC0520'
     C                   PARM                    LockObj
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Endjob
     C                   PARM                    RETURN2
 
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
     C                   PARM                    RETURN
 
      ** Create required QTEMP objects
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde        10
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - Exception errors                                      *
      *                                                               *
      *****************************************************************
 
     C     SRERR         BEGSR
 
     C                   EVAL      PRTCD  = '*ERROR '
     C                   EVAL      DBPGM  = 'SDDCMTUPD'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
 
      **  Terminate the program
     C                   RETURN
 
     C                   ENDSR
 
      ****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
