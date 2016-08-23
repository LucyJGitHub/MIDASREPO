     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE header DB update controller')              *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLBITHUPC - Journal Batch Entry Header Database Update       *
      *              Controller                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR862086           Date 15Oct12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSC024             Date 07Feb05               *
      *                 BUG1898            Date 20Apr04               *
      *                 212722             Date 16Jan03               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01.02 ----------------------------------------*
      *                 202442             Date 16Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR862086 - DBU_BITH job produces a big log file              *
      *           - Applied for AR1026929 (Child:AR1026930)           *
      *  CSC024 - Open Month End (Recompile)                          *
      *  BUG1898- Add extra parameter for call to GLBITHUPD           *
      *  212722 - Removal of fix 202442                               *
      *  202442 - Change PDtqWait to -1.                              *
      *  201589 - Change to check a new locking dataarea GLBITHLCK    *
      *           to determine whether this DBU is already active.    *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Valid JE Headers file
     FGLVBITHPD UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Valid JE Headers file by Front Office Id and Timestamp
     FGLVBITHL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLVBITHD0:GLVBITHD1)
      *
      ** Valid JE Headers in Error file
     FGLVEBITHPDO    E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLVBITHD0:GLVBITHERR)
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,GLBITHU001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
      *
      /COPY ZACPYSRC,DTAQCHKDCL
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D WDBerrUpd       C                   CONST('DB error in JE API update')
      *
      ** String for error message to the operator
     D WProcErr        C                   CONST('Error in module')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Valid JE Header (DS) - for file update
     D PVBITH        E DS                  EXTNAME(GLVBITHPD)
      *
     D GLBITHUPC       DS             1
      *
      ** Externally described DS for API ICD Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      *
      ** Externally described DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** DS for Access Programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PObject         S             10A   INZ('GLBITHUPC')
     D PLockObj        S             10A   INZ('GLBITHLCK')                                   201589
     D PLib            S             10A   INZ('*LIBL')
     D PObjtype        S              7A   INZ('*DTAARA')
     D PLockStateE     S              7A   INZ('*EXCL')
     D PLockStateS     S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('*CLS')
     D PDlcobj         S              1A
     D PReturn         S              7A
     D PReturn2        S              7A                                                      201589
     D PEndjob         S              1A   INZ('Y')                                           201589
      *
     D WTimestamp      S             26Z
      *
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
      *
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,GLBITHU002
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      /COPY WNCPYSRC,GLBITHU003
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DtaQName = 'APBITHDTQ'
      *
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'
      ** message to the data queue if there are not.
      *
      /COPY ZACPYSRC,DTAQCHK
      *
      ** Initialise data queue parameters.
      *
     C                   EVAL      PDtqLen = 10
     C**********         EVAL      PDtqWait = 5                                               202442
     C**********         EVAL      PDtqWait = -1                                       202442 212722
     C                   EVAL      PDtqWait = 5                                               212722
     C                   EVAL      PDtqNam = 'APBITHDTQ'
     C                   EVAL      PDtqLib = '*LIBL'
     C                   EVAL      PObjType = '*DTAARA'
      *
      ** Wait for data queue prompt.
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file.
      *
     C     PDtqDta       DOWNE     'END'
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    PDtqNam          10
     C                   PARM                    PDtqLib          10
     C                   PARM                    PDtqLen           5 0
     C                   PARM                    PDtqDta          10
     C                   PARM                    PDtqWait          5 0
      *
     C     PDtqDta       IFEQ      'GO'
      *
      ** Lock allocation data area.
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateE
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcobj
     C                   PARM                    PReturn
      *
      /COPY WNCPYSRC,GLBITHU004
      *
      ** Position file cursor to start of file to prevent problems on
      ** later calls.
      *
     C     1             SETLL     GLVBITHPD
      *
      ** Read valid JE Header record.
      *
     C                   READ      GLVBITHD0                              01
      *
     C     *IN01         DOWEQ     *OFF
      *
      /COPY WNCPYSRC,GLBITHU005
      *
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      ** will include the key information.
      *
     C                   EVAL      ARFOTranID = B1FRNT
     C                   EVAL      ARFOAsocID = B1AFRT
      *
      /COPY WNCPYSRC,GLBITHU006
      *
      ** Update JE Headers file.
      *
     C                   CALLB     'GLBITHUPD'
      *                             =========
      ** Return code
     C                   PARM                    PRTCD             7
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Security on Journal Entry
     C                   PARM                    CGL008
      *
      ** Valid JE Headers (DS) - for file update
     C                   PARM                    PVBITH
      *                                                                                      BUG1898
      ** Parameter to contain error message for java user                                    BUG1898
     C                   PARM      *BLANKS       JERRMSG           7                         BUG1898
      *
      /COPY WNCPYSRC,GLBITHU007
      *
      ** Check for exception error from any program lower in the stack.
      ** If error detected, send message to system operator, rollback
      ** changes and terminate program.
      *
     C                   IN        APDUMP
      *
      /COPY WNCPYSRC,GLBITHU008
      *
     C     ARErrMod      IFNE      *BLANK
     C                   EVAL      PMQErrLong = *blank
     C                   MOVEL     WProcErr      WMQError
     C                   MOVE      ARErrMod      WMQError         28
     C                   MOVEL     WMQError      PMQErrLong
      *
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn
     C                   PARM                    PMQErrLong      132
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
      *
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARErrMod = *BLANK
     C                   OUT       APDUMP
     C                   ROLBK
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      /COPY WNCPYSRC,GLBITHU009
      *
      ** Commit updates if no error.
      *
     C     PRTCD         IFEQ      '*ERROR '
     C                   ROLBK
     C                   ELSE
     C                   DELETE    GLVBITHD0
     C                   COMMIT
     C                   ENDIF
      *
      /COPY WNCPYSRC,GLBITHU010
      *
      ** If an error has occurred, reaccess record in error and remove from
      ** the file to prevent program processing the same record again.
      *
     C     PRTCD         IFEQ      '*ERROR '
      *
     C     KBITHL1       CHAIN     GLVBITHL1                          02
      *
      ** Write details of record to error file (same format as GLVBITHPD).
      *
     C                   WRITE     GLVBITHERR
     C                   DELETE    GLVBITHD1
      *
      ** Send message to system operator.
      *
     C                   MOVEL     WDBerrUpd     PDBError         28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn       10
     C                   PARM                    PDBError
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
     C                   ENDIF
      *
     C                   EVAL      PRTCD = *BLANKS
      *
      ** Read valid JE Header record.
      *
     C                   READ      GLVBITHD0                              01
     C                   ENDDO
      *
      ** After processing all records in valid transactions file                            AR862086
      ** set PDtqWait to wait for data queue prompt to avoid looping.                       AR862086
      *                                                                                     AR862086
     C                   EVAL      PDtqWait = -1                                            AR862086
      *                                                                                     AR862086
      /COPY WNCPYSRC,GLBITHU011
      *
      ** Execute Time-out processing.
      *
     C                   CALLB     'GLBITHUPF'
      *                             =========
      ** STANDING DATA
      ** =============
      *
      ** SDAPI - Batch Items Interval in Seconds
     C                   PARM                    GHBINT
      *
      /COPY WNCPYSRC,GLBITHU012
      *
      ** Check for exception error from any program lower in the stack.
      ** If error detected, send message to system operator, rollback
      ** changes and terminate program.
      *
     C                   IN        APDUMP
      *
      /COPY WNCPYSRC,GLBITHU013
      *
     C     ARErrMod      IFNE      *BLANK
     C                   EVAL      PMQErrLong = *blank
     C                   MOVEL     WProcErr      WMQError
     C                   MOVE      ARErrMod      WMQError
     C                   MOVEL     WMQError      PMQErrLong
      *
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn
     C                   PARM                    PMQErrLong
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
      *
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARErrMod = *BLANK
     C                   OUT       APDUMP
     C                   ROLBK
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      /COPY WNCPYSRC,GLBITHU014
      *
      ** Unlock allocation data area.
      *
     C                   CALLB     'APCDLCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateE
     C                   PARM                    PMember
     C                   PARM                    PReturn
      *
     C                   ENDIF
      *
      ** End loop for data queue prompt.
      *
     C                   ENDDO
      *
      /COPY WNCPYSRC,GLBITHU015
      *
      ** Exit from program.
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,GLBITHU016
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Define data area used to check if DB update running.
      *
     C     *DTAARA       DEFINE                  GLBITHUPC
      *
      ** Define key list for GLVBITHL1.
      *
     C     KBITHL1       KLIST
     C                   KFLD                    B1FRNT
     C                   KFLD                    B1TMST
      *
      *  Check if an existing DBU_BITH job is active in the subsystem.                        201589
                                                                                              201589
     C                   CALL      'SCC0520'                                                  201589
     C                   PARM                    PLockObj                                     201589
     C                   PARM                    PLib                                         201589
     C                   PARM                    PObjType                                     201589
     C                   PARM                    PLockStateE                                  201589
     C                   PARM                    PMember                                      201589
     C                   PARM                    PEndjob                                      201589
     C                   PARM                    PReturn2                                     201589
                                                                                              201589
      **  Lock allocation data area.
      *
      **  The data area is allocated *SHRRD here and *EXCL whilst processing
      **  of the valid file is actually taking place.
      **  The function to submit this updater tries to get a *EXCL lock.
      **  The controller tries to get a *SHRRD lock.
      **
      **                        Submitter             Controller
      **
      **                Lock      Lock     Submitter     Lock     Controller
      **     Status    Status   Successful   Action   Successful    Action
      **     ------    ------   ---------- ---------  ----------  ----------
      **
      **  Not running  None        Yes      Submit       Yes        Prompt
      **                                    updater                 updater
      **  Running not  *SHRRD      No        None        Yes        Prompt
      **   processing                                               updater
      **  Processing   *EXCL       No        None        No         None
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateS
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcobj
     C                   PARM                    PReturn
      *
      ** Create required QTEMP objects.
      *
     C                   CALL      'APCCRTQTO'
     C                   PARM                    PReturnCde       10
      *
      ** Access API ICD details.
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST  '    POPTN             7
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANK
     C                   MOVEL(P)  POPTN         DBKEY
     C                   MOVEL(P)  'SDAPIPD'     DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if CGL008 (Security on Journal
      ** Entry) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL008'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.  Issue database error
      ** only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CGL008'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CGL008            1
     C                   ELSE
     C                   MOVE      'N'           CGL008
     C                   ENDIF
     C/COPY WNCPYSRC,GLBITHUC01
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,GLBITHU017
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
