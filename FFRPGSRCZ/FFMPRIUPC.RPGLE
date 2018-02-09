     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Mkt Prc code dbase update controller')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFMPRIUPC - Midas FF Market Prices Update Controller         *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 03May06               *
      *                 CDL038             Date 10May05               *
      *                 CAP183  *Create    Date 05Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs.                              *
      *                                                               *
      *****************************************************************
     FFFVMPRIPD UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Valid FF Market Prices transactions with errors from this function
     FFFVEMPRIPDO    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FFVMPRID0:FFVMPRIERR)
 
      ** Midas FF Instrument Types
     FINTYP     IF   E           K DISK
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,FFMPRIC001
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in MPRI API update')
 
      *****************************************************************
 
      ** Externally described data structure for Valid Transactions
     D FFVTrn        E DS                  EXTNAME(FFVMPRIPD)
 
      ** First DS for access programs, short data structure
     D FFMPRIUPC       DS             1    DTAARA(FFMPRIUPC)
 
     D Object          S             10A   INZ('FFMPRIUPC')
     D LockObj         S             10A   INZ('FFMPRILCK')
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
 
      ** Command length for QCMDEXC
     D CommandLen      S             15P 5 INZ(26)
 
      ** Data queue details
      ** ------------------
     D DtqLen          S              5P 0 INZ(10)
     D DtqWait         S              5P 0 INZ(-1)
     D DtqNam          S             10A   INZ('APMPRIDTQ')
     D DtqLib          S             10A   INZ('*LIBL')
     D DtqDta          S             10A
     D wInsType        S              2A
 
      ** APYOVR  parameter
     D wMember         S              2A
 
      ** Flags
     D POTCFlag        S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FFMPRIC002
 
      *******************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *******************************************************************
 
      /COPY WNCPYSRC,FFMPRIC003
 
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APMPRIDTQ'
 
      **-----------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **-----------------------------------------------------------------
 
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
     C                   PARM                    Return
 
      ** Ensure the U7 and U8 indicators are off, to prevent problems
      ** caused by earlier errors.
     C                   CLEAR                   *inu7
     C                   CLEAR                   *inu8
 
 
      /COPY WNCPYSRC,FFMPRIC004
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     FFVMPRIPD
 
      ** Read Valid FF Market Prices Transaction
     C                   READ      FFVMPRID0                              99
     C                   DOW       *IN99 = *OFF
 
     C                   EXSR      SrOTCCheck
 
     C                   IF        POTCFlag = 'Y'
     C                   EVAL      wMember = 'OT'
     C                   ELSE
     C                   EVAL      wMember = DVISTT
     C                   ENDIF
 
     C                   CALLB     'FFAPYOVR'
     C                   PARM                    ReturnCode
     C                   PARM                    wMember
 
      /COPY WNCPYSRC,FFMPRIC005
 
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      ** will include the key information
     C                   EVAL      ARFOTranID = DVFRNT
     C                   EVAL      ARFOAsocID = DVAFRT
     C                   EVAL      ARRprLocn  = DVREPA
 
      /COPY WNCPYSRC,FFMPRIC006
 
      ** FF Market Prices Database Update
     C                   CALLB     'FFMPRIUPD'
     C                   PARM      *BLANK        @@RTCD            7
     C                   PARM                    FFVTRN
     C                   PARM                    POTCFlag
 
      ** Commit Updates if No Error
     C                   IF        @@RTCD = '*ERROR ' OR
     C                             @@RTCD = '*RECUPD'
 
      /COPY WNCPYSRC,FFMPRIC007
 
      ** If an error has occurred, reaccess record in error and remove from
      ** the file to prevent program processing the same record again
      ** Write details of record to error file (same format as FFVMPRIPD)
     C                   WRITE     FFVMPRIERR
 
      ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** Delete from valids file
     C                   DELETE    FFVMPRID0
     C                   COMMIT
 
      ** Remove the multimembered file overrides
     C                   RESET                   ReturnCode
     C                   CALLB     'FFDLTOVR'
     C                   PARM                    ReturnCode
 
      ** Read Valid Market Prices Transaction Details
     C                   READ      FFVMPRID0                              99
     C                   ENDDO
 
      ** Unlock allocation data area
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Return
     C                   ENDIF
 
      ** End loop for data queue prompt
     C                   ENDDO
 
      /COPY WNCPYSRC,FFMPRIC008
 
      ** Exit from Program
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FFMPRIC009
 
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
 
      ** Check if an existing DBU_MPRI job is active in the subsystem.
     C                   CALL      'SCC0520'
     C                   PARM                    LockObj
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    Endjob
     C                   PARM                    Return2
 
      ** Lock allocation data area
 
      ** The data area is allocated *SHRRD here and *EXCL whilst processing
      ** of the valid file is actually taking place.
      ** The function to submit this updater tries to get a *EXCL lock.
      ** The controller tries to get a *SHRRD lock.
 
      **                        Submitter             Controller
      **                Lock      Lock     Submitter     Lock     Controller
      **    Status    Status   Successful   Action   Successful    Action
      **    ------    ------   ---------- ---------  ----------  ----------
      ** Not running  None        Yes      Submit       Yes        Prompt
      **                                   updater                 updater
 
      ** Running not  *SHRRD      No        None        Yes        Prompt
      ** processing                                                updater
 
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
 
      ** Create required QTEMP objects
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde        10
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FFMPRIC010
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * SrOTCCheck - Check if instrument is OTC
      *****************************************************************
     C     SrOTCCheck    BEGSR
 
      ** Chain to INTYP
     C     DVISTT        CHAIN     INTYP
 
     C                   EVAL      POTCFlag = 'N'
     C                   IF        %FOUND(INTYP) AND ISTI = 'Y'
      ** If Found and Instrument Indicator is 'Y', assume that it is
      ** an OTC instrument.
     C                   EVAL      POTCFlag = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2006
