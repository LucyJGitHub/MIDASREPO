     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Joint A/c Member Details UPD Controller')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDJACMUPC - Midas SD Joint Account Member Details Update     *
      *              Controller                                       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL031 - Taxation on Savings Income.                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDVJACMPD UF   E             DISK    INFSR(*PSSR) COMMIT
      ** Midas SD Valid Joint A/c Members
 
     FSDVJACML1 UF   E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(SDVJACMD0:SDVJACMD1)
      ** Midas SD Valid JAcM by Joint A/c No./Customer No./Timestamp
 
     FSDVJACML2 UF   E           K DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(SDVJACMD0:SDVJACMD2)
      ** Midas SD Valid JAcM by Joint A/c No./Non-a/c Holder/Timestamp
 
     FSDVEJACMPDO    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDVJACMD0:SDVEJACMD0)
      ** Midas SD JAcM Records in Error from DBU Function
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Declares for Data Queue Checking
     D/COPY ZACPYSRC,DTAQCHKDCL
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D DBerrUpd        C                   CONST('DB error in JACM API update')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Valid Joint A/c Member Details Data Structure
     D SDVJACM       E DS                  EXTNAME(SDVJACMPD)
 
      ** Update Controller Allocation Data Area
     D SDJACMUPC       DS             1    DTAARA(SDJACMUPC)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** API Parameters
     D PRetCode        S              7A
     D Object          S             10A   INZ('SDJACMUPC')
     D LockObj         S             10A   INZ('SDJACMLCK')
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
     D Timestamp       S               Z
 
      ** Standard Utility Parameters
     D DBError         S             28A
     D MsgSndRtn       S             10A
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
     D DtqLen          S              5P 0 INZ(10)
     D DtqWait         S              5P 0 INZ(-1)
     D DtqNam          S             10A   INZ('APJACMDTQ')
     D DtqLib          S             10A   INZ('*LIBL')
     D DtqDta          S             10A
 
      ** Key Fields
     D KJANo           S                   LIKE(JAJANO)
     D KCust           S                   LIKE(JACUST)
     D KNAHo           S                   LIKE(JANAHO)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Set up the name of the server/database updater data queue.
 
     C                   EVAL      DtaQName = 'APJACMDTQ'
 
      **---------------------------------------------------------------
      ** Data Queue Checking
     D/COPY ZACPYSRC,DTAQCHK
      **---------------------------------------------------------------
 
      ** Wait for data queue prompt.
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file.
 
     C                   DOW       DtqDta <> 'END'
 
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam
     C                   PARM                    DtqLib
     C                   PARM                    DtqLen
     C                   PARM                    DtqDta
     C                   PARM                    DtqWait
 
      ** If data queue entry is 'END', leave the DOW loop at this point.
 
     C                   IF        DtqDta = 'END'
     C                   LEAVE
     C                   ENDIF
 
      ** If data queue entry says run, first lock allocation data area.
 
     C                   IF        DtqDta = 'GO'
 
      ** Allocate with exclusive lock state.
 
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
 
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF
 
      ** Position file cursor to start of file to prevent problems on later calls.
 
     C     1             SETLL     SDVJACMPD
 
      ** Read valid Joint A/c Member details.
 
     C                   READ      SDVJACMD0
 
     C                   DOW       NOT %EOF
 
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      ** will include the key information.
 
     C                   EVAL      ARFOTranID = JAFRNT
     C                   EVAL      ARRprLocn  = JAREPA
     C                   EVAL      Timestamp = JATMST
 
     C                   CALLB     'SDJACMUPD'
      **                 *********************
 
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    SDVJACM
 
      ** Commit updates if no errors have occurred.
 
     C                   IF        PRetCode <> '*ERROR ' AND
     C                             PRetCode <> '*RECUPD'
     C                   DELETE    SDVJACMD0
     C                   COMMIT
     C                   ELSE
 
      ** If an error has occurred, reaccess record in error and remove from
      ** the file to prevent the program from processing the same record again.
 
     C                   EVAL      KJANo = JAJANO
 
     C                   IF        JACUST <> *BLANKS
 
     C                   EVAL      KCust = JACUST
     C     KVJA1         CHAIN     SDVJACML1
     C                   WRITE     SDVEJACMD0
     C                   DELETE    SDVJACMD1
 
     C                   ELSE
 
     C                   EVAL      KNAHo = JANAHO
     C     KVJA2         CHAIN     SDVJACML2
     C                   WRITE     SDVEJACMD0
     C                   DELETE    SDVJACMD2
 
     C                   ENDIF
 
      ** Commit details of record to error file (same format as SDVJACMPD).
 
     C                   COMMIT
 
      ** Send message to system operator.
 
     C                   EVAL      DBError = DBerrUpd
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
     C                   READ      SDVJACMD0
     C                   ENDDO
 
     ** Unlock allocation data area.
 
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Return
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Key Lists
 
     C     KVJA1         KLIST
     C                   KFLD                    KJANo
     C                   KFLD                    KCust
 
     C     KVJA2         KLIST
     C                   KFLD                    KJANo
     C                   KFLD                    KNAHo
 
      ** Check if an existing DBU_JACM job is active in the subsystem.
 
     C                   CALL      'SCC0520'
     C                   PARM                    LockObj
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Endjob
     C                   PARM                    Return2
 
      ** Lock Allocation Data Area
 
      ** The data area is allocated *SHRRD here and *EXCL whilst processing
      ** of the valid file is actually taking place.
      ** The function to submit this updater tries to get a *EXCL lock.
      ** The controller tries to get a *SHRRD lock.
 
      **                       Submitter             Controller
      **               Lock      Lock     Submitter     Lock     Controller
      **    Status    Status   Successful   Action   Successful    Action
      **    ------    ------   ---------- ---------  ----------  ----------
      ** Not running  None        Yes      Submit       Yes        Prompt
      **                                   updater                 updater
 
      ** Running not  *SHRRD      No        None        Yes        Prompt
      **  processing                                               updater
 
      ** Processing   *EXCL       No        None        No         None
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateS
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      ** Create required QTEMP objects.
 
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCode
 
      **---------------------------------------------------------------
      ** Program, Module, & Procedure Names for DB Error Processing
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** ILE RPG Program Status Subroutine
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2004
