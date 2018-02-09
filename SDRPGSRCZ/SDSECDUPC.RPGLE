     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer details datab. update controller')
      *****************************************************************
      *                                                               *
      *  Midas - SD Standing Data ILE Module                          *
      *                                                               *
      *  SDSECDUPC - SD CUSTOMERS Security Details CONTROLLER         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 243070             Date 10Jul06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSE070             Date 15Feb05               *
      *                 CSE042             Date 05Feb03               *
      *                 CSE041             Date 05Feb03               *
      *                 CSE039             Date 05Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 193883             Date 20Nov01               *
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039  *CREATE    Date 03Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  243070 - Recompile over changed PF/SDVSECDPD                 *
      *  CSE070 - Repo Coupon Claims Report                           *
      *  CSE042 - Auto Feed of Trades and Movements (Recompile)       *
      *  CSE041 - DVP/RVP Processing (Recompile)                      *
      *  CSE039 - Automatic Settlement of Trades (Recompile)          *
      *  193883 - Recompile over changed SDSECDUPD.                   *
      *  201589 - Change to check a new locking dataarea SDSECDLCK    *
      *           to determine whether this DBU is already active.    *
      *  CSE022 - Depository Definition Enhancement                   *
      *  CAP039 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
     FSDVSECDPD UF   E             DISK
     F                                     COMMIT
     FSDVSECDL1 UF   E           K DISK
     F                                     RENAME(SDVSECDD0:SDVSECDD1)
 
     FSDVESECDPDO    E             DISK
     F                                     RENAME(SDVSECDD0:SDVSECDERR)
                                                                                              CSE022
     FSDVCSDRL1 UF   E           K DISK                                                       CSE022
     F                                     COMMIT                                             CSE022
     FSDVECSDRPDO    E             DISK                                                       CSE022
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDSECDU001
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in SECD API update')
 
      *****************************************************************
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID CUSTOMER
     D SDVSEC        E DS                  EXTNAME(SDVSECDPD)
 
     D SDSECDUPC       DS             1    DTAARA(SDSECDUPC)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
 
     D Object          S             10A   INZ('SDSECDUPC')
     D LockObj         S             10A   INZ('SDSECDLCK')                                   201589
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
     D DtqNam          S             10A   INZ('APSECDDTQ')
     D DtqLib          S             10A   INZ('*LIBL')
     D DtqDta          S             10A
 
 
      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDSECDU002
 
      *******************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *******************************************************************
 
      /COPY WNCPYSRC,SDSECDU003
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APSECDDTQ'
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
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
 
 
      /COPY WNCPYSRC,SDSECDU004
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     SDVSECDPD
 
      ** READ VALID SD CUSTOMER
     C                   READ      SDVSECDD0                              99    *
     C     *IN99         DOWEQ     '0'
 
      /COPY WNCPYSRC,SDSECDU005
 
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lower level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = SEFRNT
     C                   EVAL      ARFOAsocID = SEAFRT
     C                   EVAL      ARRprLocn  = SEREPA
     C                   EVAL      @Timestamp = SETMES
 
      /COPY WNCPYSRC,SDSECDU006
 
      ** SD DATABASE UPDATE
     C                   CALLB     'SDSECDUPD'
     C                   PARM      *BLANK        @@RTCD            7
     C                   PARM                    SDVSEC
 
      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C                   ROLBK
     C                   ELSE
     C                   DELETE    SDVSECDD0
                                                                                              CSE022
     C     SECUST        SETLL     SDVCSDRL1                                                  CSE022
     C     SECUST        READE     SDVCSDRL1                              98                  CSE022
     C                   DOW       *IN98 <> True                                              CSE022
     C                   DELETE    SDVCSDRD0                                                  CSE022
     C     SECUST        READE     SDVCSDRL1                              98                  CSE022
     C                   ENDDO                                                                CSE022
                                                                                              CSE022
     C                   COMMIT
     C                   ENDIF
 
      /COPY WNCPYSRC,SDSECDU007
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'
     C                   EVAL      @CuSecd = SECUST
     C                   EVAL      @Timestamp = SETMES
     C     @KeySecdL1    CHAIN     SDVSECDL1                          89
     ** Write details of record to error file (same format as SDVSECDPD)
     C                   WRITE     SDVSECDERR
     C                   DELETE    SDVSECDD1
                                                                                              CSE022
     C     SECUST        SETLL     SDVCSDRL1                                                  CSE022
     C     SECUST        READE     SDVCSDRL1                              98                  CSE022
     C                   DOW       *IN98 <> True                                              CSE022
     C                   WRITE     SDVECSDRD0                                                 CSE022
     C                   DELETE    SDVCSDRD0                                                  CSE022
     C     SECUST        READE     SDVCSDRL1                              98                  CSE022
     C                   ENDDO                                                                CSE022
                                                                                              CSE022
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** READ VALID SD Security Client Details
     C                   READ      SDVSECDD0                              99    *
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
 
      /COPY WNCPYSRC,SDSECDU008
 
      * EXIT FROM PROGRAM
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDSECDU009
 
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
 
      *  Define key list for SDVSECDL1
     C     @KeySecdL1    KLIST
     C                   KFLD                    @CuSecd           6
     C                   KFLD                    @Timestamp
 
      *  Check if an existing DBU_SECD job is active in the subsystem.                        201589
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
     C* Overrride SDSECSLR
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDSECDU010
 
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
     C                   MOVEL     'SDSECDUPD'   DBPGM            10
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
(c) Finastra International Limited 2001
** ##OX1
OVRDBF FILE(SDSECSLR) TOFILE(SDSECSL0) SHARE(*NO)
