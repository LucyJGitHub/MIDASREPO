     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Security diary events DB updat controller')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDEUPC - Security Diary Events Database Update Controller *
      *                                                               *
      *  Function: This module is the main module for Midas data-     *
      *            base update for the incoming Security diary        *
      *            events.  This will apply valid transactions to     *
      *            the database.                                      *
      *                                                               *
      *  Component of: SESEDEUPP                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. DUG502             Date 05Dec17               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE074             Date 30Aug05               *
      *                 BUG7029            Date 09Jun05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 09Nov01               *
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP140  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DUG502 - Security Diary Enhancements                         *
      *           Add hooks DUG502_113->_119                          *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation on Savings Income (Recompile)              *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
      *  201589 - Change to check a new locking dataarea SESEDELCK    *
      *           to determine whether this DBU is already active.    *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Use for chaining to file                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Valid Security Diary Events
     FSEVSEDEPD UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Valid Security Diary Events by SESN/TMST
     FSEVSEDEL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEVSEDED0:SEVSEDED1)
     F/COPY WNCPYSRC,DUG502_114                                                               DUG502
      *
      ** Valid Security Diary Events error file
     FSEVESEDEPDO    E             DISK    INFSR(*PSSR)
     F                                     RENAME(SEVSEDED0:SEVSEDEERR)
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SESEDEU001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
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
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
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
     D WDBerrUpd       C                   CONST('DB error in SEDE API update')
      *
      ** String for error message to the operator
     D WProcErr        C                   CONST('Error in module')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** DS for SEDE data area details
     D SESEDEUPC       DS             1    DTAARA(SESEDEUPC)
      *
      ** SE Diary Events for file update - file format
     D NwDEFilFmt    E DS                  EXTNAME(SEVSEDEPD)
      *
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Externally described DS for securities trading ICD details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** DS for access programs - first data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs - second data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PDBRN                 11     13
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
     D PObject         S             10A   INZ('SESEDEUPC')
     D PLockObj        S             10A   INZ('SESEDELCK')                                   201589
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
     D WMQError        S             28A
     D PMQErrLong      S            132A
     D PDBError        S             28A
     D PMsgSndRtn      S             10A
     D PReturnCde      S             10A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D CSE010          S              1A
     D S01509          S              1A
     D CSE031          S              1A                                                      CSE031
      *
     D WTimestamp      S             26Z
     D WSecurity       S             10A
     D WEvtDate        S              5P 0
     D WEvtType        S              2A
      *
      ** Dummy message Id and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
      *
      ** Parameter list for QRCVDTAQ
     D PDtqNam         S             10A
     D PDtqLib         S             10A
     D PDtqLen         S              5P 0
     D PDtqDta         S             10A
     D PDtqWait        S              5P 0
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,SESEDEU002
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
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *                                                                                      BUG7029
      ** Get ZMUSER information.                                                             BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
      *
      /COPY WNCPYSRC,SESEDEU003
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DtaQName = 'APSEDEDTQ'
      *
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'
      ** message to the data queue if there are not.
      *
      /COPY ZACPYSRC,DTAQCHK
      *
      ** Initialise data queue parms.
      *
     C                   EVAL      PDtqLen = 10
     C                   EVAL      PDtqWait = -1
     C                   EVAL      PDtqNam = 'APSEDEDTQ'
     C                   EVAL      PDtqLib = '*LIBL'
     C                   EVAL      PObjType = '*DTAARA'
      *
      ** Wait for data queue prompt.
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file.
      *
     C                   DOW       PDtqDta <> 'END'
 
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    PDtqNam
     C                   PARM                    PDtqLib
     C                   PARM                    PDtqLen
     C                   PARM                    PDtqDta
     C                   PARM                    PDtqWait
 
     C                   IF        PDtqDta = 'GO'
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
      /COPY WNCPYSRC,SESEDEU004
      *
      ** Position file cursor to start of file to prevent problems on
      ** later calls.
      *
     C     1             SETLL     SEVSEDEPD
      *
      ** Read valid security details.
      *
     C                   READ      SEVSEDED0                              01
      *
     C                   DOW       EndOfFile = False
      *
      /COPY WNCPYSRC,SESEDEU005
      *
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      ** will include the key information.
      *
     C                   EVAL      ARFOTranID = S2FRNT
     C                   EVAL      ARFOAsocID = *BLANKS
     C                   EVAL      ARRprLocn  = S2REPA
      *
      /COPY WNCPYSRC,SESEDEU006
      *
      ** Save key fields.
      *
     C                   EVAL      WSecurity  = S2SDSN
     C                   EVAL      WEvtDate   = S2SDED
     C                   EVAL      WEvtType   = S2SDET
     C                   EVAL      WTimestamp = S2TMST
     C/COPY WNCPYSRC,DUG502_115                                                               DUG502
      *
      /COPY WNCPYSRC,SESEDEU007
      *
      ** Process only insert, amend and delete transactions.
      *
     C                   IF        S2CHTP = 'I' OR S2CHTP = 'A' OR
     C                             S2CHTP = 'D'
      *
      /COPY WNCPYSRC,SESEDEU008
      *
      ** Update Security Diary Events file.
     C                   CALLB     'SESEDEUPD'
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events for file update - file format
     C                   PARM                    NwDEFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single branch code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - Run day number
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDSTRD - Back value period
     C                   PARM                    BVBVP
      *
      ** ZMUSER - Default branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** SE Transaction enhancement
     C                   PARM                    CSE010
      *
      ** Value Ccy to be Ccy of issuer payment
     C                   PARM                    S01509
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
      *                                                                                       CSE074
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE074
     C                   PARM                    CSE065            1                          CSE074
      *
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESEDEU009
      *
      ** Check for exception error from any program lower in the stack.
      ** If error detected, send message to system operator, rollback
      ** changes and terminate program.
      *
     C                   IN        APDUMP
      *
      /COPY WNCPYSRC,SESEDEU010
      *
     C     ARErrMod      IFNE      *BLANK
     C                   EVAL      PMQErrLong = *BLANK
     C                   MOVEL     WProcErr      WMQError
     C                   MOVE      ARErrMod      WMQError
     C                   MOVEL     WMQError      PMQErrLong
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn
     C                   PARM                    PMQErrLong
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
 
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARErrMod = *BLANK
     C                   OUT       APDUMP
     C                   ROLBK
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESEDEU011
      *
      ** Commit updates if no error.
     C                   IF        RetCodeOut = '*ERROR ' OR
     C                             RetCodeOut = '*RECUPD'
     C                   ROLBK
     C                   ELSE
     C                   DELETE    SEVSEDED0
     C                   COMMIT
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESEDEU012
      *
      ** If an error has occurred, reaccess record in error and remove from
      ** the file to prevent program processing the same record again.
     C                   IF        RetCodeOut = '*ERROR ' OR
     C                             RetCodeOut = '*RECUPD'
 
     C/COPY WNCPYSRC,DUG502_116                                                               DUG502
     C     KSEVL1        CHAIN     SEVSEDEL1                          02
     C/COPY WNCPYSRC,DUG502_117                                                               DUG502
      *
      ** Write details of record to error file (same format as SEVSEDEPD).
     C                   WRITE     SEVSEDEERR
     C/COPY WNCPYSRC,DUG502_118                                                               DUG502
     C                   DELETE    SEVSEDED1
     C/COPY WNCPYSRC,DUG502_119                                                               DUG502
      *
      ** Send message to system operator.
     C                   MOVEL     WDBerrUpd     PDBError
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn
     C                   PARM                    PDBError
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
 
     C                   ENDIF
 
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ** Read valid security details.
     C                   READ      SEVSEDED0                              01
      *
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
 
     C                   ENDIF
      *
      ** End loop for data queue prompt.
     C                   ENDDO
      *
      /COPY WNCPYSRC,SESEDEU013
      *
      ** Exit from program.
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,SESEDEU014
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
      *  Check if an existing DBU_SEDE job is active in the subsystem.                        201589
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
     C                   PARM                    PReturnCde
      *
      ** Access Bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C     PRtcd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile= 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access ICD details for securities trading.
      *
     C                   CALLB     'AOSTRDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Database error
      *
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile= 'SDSTRDPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if "SE Transaction enhancement"
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE010'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'CSE010'
     C                   EVAL      DBFile= 'SCSARDPD'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           CSE010
     C                   ELSE
     C                   MOVEL     'N'           CSE010
     C                   ENDIF
      *
      ** Access SAR file to determine if "Value currency to be
      ** currency of the issuer payment" is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01509'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'S01509'
     C                   EVAL      DBFile= 'SCSARDPD'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           S01509
     C                   ELSE
     C                   MOVEL     'N'           S01509
     C                   ENDIF
      *                                                                                       CSE031
      ** Access SAR file to determine if "Coupon Fixing for                                   CSE031
      ** Floating Rate Notes" is installed.                                                   CSE031
      *                                                                                       CSE031
     C                   CALLB     'AOSARDR0'                                                 CSE031
     C                   PARM      *BLANKS       PRtcd                                        CSE031
     C                   PARM      '*VERIFY'     POptn                                        CSE031
     C                   PARM      'CSE031'      PSarD                                        CSE031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE031
      *                                                                                       CSE031
      ** An NRF (No Record Found) return code is valid.                                       CSE031
      ** Issue database error only for error return codes.                                    CSE031
      *                                                                                       CSE031
     C                   IF        PRtcd <> *BLANKS AND                                       CSE031
     C                             PRtcd <> '*NRF   '                                         CSE031
     C     *LOCK         IN        LDA                                                        CSE031
     C                   EVAL      DBKey = 'CSE031'                                           CSE031
     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE031
     C                   EVAL      DBase = 005                                                CSE031
     C                   OUT       LDA                                                        CSE031
     C                   EXSR      *PSSR                                                      CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        PRtcd = *BLANKS                                            CSE031
     C                   MOVEL     'Y'           CSE031                                       CSE031
     C                   ELSE                                                                 CSE031
     C                   MOVEL     'N'           CSE031                                       CSE031
     C                   ENDIF                                                                CSE031
      **********                                                                             BUG7029
      ***Get*ZMUSER*information.                                                             BUG7029
      **********                                                                             BUG7029
     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C**********         IN        ZMUSER                                                    BUG7029
      *
      ** Define key list for SEVSEDEL1.
      *
     C     KSEVL1        KLIST
     C                   KFLD                    WSecurity
     C                   KFLD                    WEvtDate
     C                   KFLD                    WEvtType
     C                   KFLD                    WTimestamp
     C/COPY WNCPYSRC,DUG502_113                                                               DUG502
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,SESEDEU015
      *
     C                   ENDSR
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
