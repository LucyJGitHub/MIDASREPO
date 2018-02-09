     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Account Review Update Controller')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDACRVUPC - SD Account Review Update Interface Controller    *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD092  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
 
     FSDVACRVPD UF   E             DISK    COMMIT
     FSDVACRVL1 UF   E           K DISK    RENAME(SDVACRVD0:SDVACRVD1)
     FSDVEACRVPDO    E             DISK    RENAME(SDVACRVD0:SDVACRVERR)
 
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
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in ACRV +
     D                                          API update')
 
      *****************************************************************
 
      ** Externally Described Data Structure for Valid Account Review
     D SDVACRV       E DS                  EXTNAME(SDVACRVPD)
 
     D SDACRVUPC       DS             1    DTAARA(SDACRVUPC)
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
     D SCALCD        E                     EXTFLD(LCD)
      ** External DS for SAR details
 
     D Object          S             10A   INZ('SDACRVUPC')
     D LockObj         S             10A   INZ('SDACRVLCK')
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
     D WCuCUST         S              6A
     D WCuSCDT         S              5P 0
     D WCuSEQN         S              3S 0
     D WTimestamp      S             26A
     D WWRTCD          S              7A
     D ReturnCde       S             10A
     D DBError         S             28A
     D MsgSndRtn       S             10A
      ** Dummy message ID and message file fields for use on the
      ** calls to ZAMSGTOOPR
     D DummyMsgID      S                   Like(#MsgID)
     D DummyMsgF       S             10A
 
      ** Data queue details
      ** ------------------
     D DtqLen          S              5P 0 INZ(10)
     D DtqWait         S              5P 0 INZ(-1)
     D DtqNam          S             10A   INZ('APACRVDTQ')
     D DtqLib          S             10A   INZ('*LIBL')
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
     C                   EVAL      DtaQName = 'APACRVDTQ'
 
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
     C     1             SETLL     SDVACRVPD
 
      ** Read Valid SD Account Review
     C                   READ      SDVACRVD0                              99
     C                   DOW       *IN99 = *OFF
 
      ** Load the API dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      ** will include the key information
     C                   EVAL      ARFOTranID = AVFOID
     C                   EVAL      ARFOAsocID = *BLANKS
     C                   EVAL      ARRprLocn  = AVREPA
     C                   EVAL      WTimestamp = AVTMST
 
      ** SD Database Update
     C                   CALLB     'SDACRVUPD'
     C                   PARM      *BLANKS       WWRTCD
     C                   PARM                    SDVACRV
 
      ** Commit updates if no error
     C                   IF        WWRTCD = '*ERROR '
     C                             OR WWRTCD = '*RECUPD'
     C                   ROLBK
     C                   ELSE
     C                   DELETE    SDVACRVD0
     C                   COMMIT
     C                   ENDIF
 
      ** If an error has occurred, reaccess record in error and remove from
      ** the file to prevent program processing the same record again
     C                   IF        WWRTCD = '*ERROR '
     C                             OR WWRTCD = '*RECUPD'
     C                   EVAL      WCuCUST = AVCUST
     C                   EVAL      WCuSCDT = AVSCDT
     C                   EVAL      WCuSEQN = AVSEQN
     C                   EVAL      WTimestamp = AVTMST
 
     C     KKeyAcrvL1    CHAIN     SDVACRVL1                          89
 
      ** Write details of record to error file (same format as SDVACRVPD)
     C                   WRITE     SDVACRVERR
     C                   DELETE    SDVACRVD1
 
      ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
     C                   READ      SDVACRVD0                              99
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
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Define key list for SDVACRVL1
     C     KKeyAcrvL1    KLIST
     C                   KFLD                    WCuCUST
     C                   KFLD                    WCuSCDT
     C                   KFLD                    WCuSEQN
     C                   KFLD                    WTimestamp
 
      ** Check if an existing DBU_ACRV job is active in the subsystem.
     C                   CALL      'SCC0520'
     C                   PARM                    LockObj
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Endjob
     C                   PARM                    RETURN2
 
      *  Lock allocation data area
 
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
     C                   PARM                    ReturnCde
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - Exception errors                                      *
      *                                                               *
      * Called by: Exception errors                                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRERR         BEGSR
 
     C                   MOVEL     '*ERROR '     WWRTCD
     C                   MOVEL     'SDACRVUPC'   Dbpgm
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
(c) Finastra International Limited 2014
