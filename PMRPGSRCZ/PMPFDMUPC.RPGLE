     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio definitions DB upd controller')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDMUPC - Portfolio Definition Details Database Update     *
      *              Controller                                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 13Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  201589 - Change to check a new locking dataarea PMPFDMLCK    *
      *           to determine whether this DBU is already active.    *
      *  CPB002 - New Private Banking Customer Processing.            *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FPMVPFDMPD UF   E             DISK
      ** Valid Portfolio Defn Details File
     F                                     COMMIT
      *
     FPMVPFDML1 UF   E           K DISK
      ** Valid Portfolio Defn Details File - LF
     F                                     RENAME(PMVPFDMD0:PMVPFDMD1)
      *
     FPMVEPFDMPDO    E             DISK
      ** Valid Portfolio Defn Details in Error File
     F                                     RENAME(PMVPFDMD0:PMVPFDMERR)
      *
      /COPY WNCPYSRC,PMPFDMU001
      ** Hook to enable non-core files to be included
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
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
      ** String for error message to the operator
     D WDBerrUpd       C                   CONST('DB error in PM API update')
      *
      ** String for error message to the operator
     D WProcErr        C                   CONST('Error in module')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D PMVPFD        E DS                  EXTNAME(PMVPFDMPD)
      ** Externally described data structure for valid Portfolio
      ** Definition record
      *
     D PMPFDMUPC       DS             1
      *
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** Externally described DS for Portfolio Management ICD Details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Externally described DS for Midas Modules Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs - short data structure
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PObject         S             10A   INZ('PMPFDMUPC')
     D PLockObj        S             10A   INZ('PMPFDMLCK')                                   201589
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
                                                                                CPB002
      ** Override Database Table                                                CPB002
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)            CPB002
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,PMPFDMU002
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
      /COPY WNCPYSRC,PMPFDMU003
      *
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APPFDMDTQ'
      *
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'
      ** message to the data queue if there are not.
      /COPY ZACPYSRC,DTAQCHK
      *
      ** Initialise data queue parms.
     C                   EVAL      PDtqLen = 10
     C                   EVAL      PDtqWait = -1
     C                   EVAL      PDtqNam = 'APPFDMDTQ'
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
      /COPY WNCPYSRC,PMPFDMU004
      *
      ** Position file cursor to start of file to prevent problems on
      ** later calls.
     C     1             SETLL     PMVPFDMPD
      *
      ** Read valid Portfolio Definition.
      *
     C                   READ      PMVPFDMD0                              01
      *
     C     *IN01         DOWEQ     '0'
      *
      /COPY WNCPYSRC,PMPFDMU005
      *
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      ** will include the key information.
     C                   EVAL      ARFOTranID = P1PNFRNT
     C                   EVAL      ARFOAsocID = P1PNAFRT
     C                   EVAL      ARRprLocn  = P1PNREPA
      *
      /COPY WNCPYSRC,PMPFDMU006
      *
      ** Save keys.
     C                   EVAL      WCustno = P1PNCNUM
     C                   EVAL      WPortfolioRef = P1PNPTFR
     C                   EVAL      WTimestamp = P1PNTMST
      *
      /COPY WNCPYSRC,PMPFDMU007
      *
      ** Process only insert, amend and close transactions.
     C     P1PNCHTP      IFEQ      'I'
     C     P1PNCHTP      OREQ      'A'
     C     P1PNCHTP      OREQ      'C'
      *
      /COPY WNCPYSRC,PMPFDMU008
      *
      ** Update Portfolio Definitions file.
      *
     C                   CALLB     'PMPFDMUPD'
      *
     C                   PARM      *BLANKS       PRTCD             7
      *
      ** Valid Portfolio Definition Details
     C                   PARM                    PMVPFD
      *
      ** STANDING DATA
      ** =============
      *
      ** SDPORT - Portfolios Supported
     C                   PARM                    FCPORS
      *
      ** SDMMOD - Portfolio Management
     C                   PARM                    BGPFMG
      *                                                                         CPB002
      ** SDMMOD - Private Banking                                               CPB002
     C                   PARM                    BGN4ST                         CPB002
      *
     C                   ENDIF
      *
      /COPY WNCPYSRC,PMPFDMU009
      *
      ** Check for exception error from any program lower in the stack.
      ** If error detected, send message to system operator, rollback
      ** changes and terminate program.
      *
     C                   IN        APDUMP
      *
      /COPY WNCPYSRC,PMPFDMU010
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
      /COPY WNCPYSRC,PMPFDMU011
      *
      ** Commit updates if no error.
     C     PRTCD         IFEQ      '*ERROR '
     C     PRTCD         OREQ      '*RECUPD'
     C                   ROLBK
     C                   ELSE
     C                   DELETE    PMVPFDMD0
     C                   COMMIT
     C                   ENDIF
      *
      /COPY WNCPYSRC,PMPFDMU012
      *
      ** If an error has occurred, reaccess record in error and remove from
      ** the file to prevent program processing the same record again.
      *
     C     PRTCD         IFEQ      '*ERROR '
     C     PRTCD         OREQ      '*RECUPD'
      *
     C     KPMDL1        CHAIN     PMVPFDML1                          02
      *
      ** Write details of record to error file (same format as PMVPFDMPD).
     C                   WRITE     PMVPFDMERR
     C                   DELETE    PMVPFDMD1
      *
      ** Send message to system operator.
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
      ** Read valid Portfolio Definition.
     C                   READ      PMVPFDMD0                              01
     C                   ENDDO
      *
      ** Unlock allocation data area.
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
     C                   ENDDO
      *
      /COPY WNCPYSRC,PMPFDMU013
      *
      ** Exit from program.
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,PMPFDMU014
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
     C     *INZSR        BEGSR
      *
      ** Define data area used to check if DB update running.
     C     *DTAARA       DEFINE                  PMPFDMUPC
      *
      ** Define key list for PMVPFDML1.
     C     KPMDL1        KLIST
     C**********         KFLD                    WCustno           6 0                        CSD027
     C                   KFLD                    WCustno           6                          CSD027
     C                   KFLD                    WPortfolioRef     4
     C                   KFLD                    WTimestamp
      *
      *  Check if an existing DBU_PFDM job is active in the subsystem.                        201589
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
     C                   CALL      'APCCRTQTO'
     C                   PARM                    PReturnCde       10
      *
      ** Access Midas Modules details.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRETD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error
     C     PRETD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If Portfolio Management is installed, access ICD details.
      *
     C     BGPFMG        IFEQ      'Y'
      *
     C                   CALLB     'AOPORTR0'
     C                   PARM      *BLANKS       PRETD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      ** Database error
     C     PRETD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                         CPB002
     C* Overrride SDPBDSLR                                                      CPB002
     C                   Z-ADD     50            MESLEN           15 5          CPB002
     C                   CALL      'QCMDEXC'                                    CPB002
     C                   PARM                    ##OX1                          CPB002
     C                   PARM                    MESLEN                         CPB002
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      /COPY WNCPYSRC,PMPFDMU015
      ** Hook to enable non-core initial processing to be included
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
(c) Finastra International Limited 2001
** ##OX1
OVRDBF FILE(SDPBDSLR) TOFILE(SDPBDSL0) SHARE(*NO)
