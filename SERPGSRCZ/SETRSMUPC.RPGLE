     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade settlements db updat controller')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRSMUPC - Trade Settlement Database Update Controller      *
      *                                                               *
      *  Function: This module is the main module for Midas data-     *
      *            base update for the incoming Trade Settlement      *
      *            details. This will apply valid transactions to     *
      *            the database.                                      *
      *                                                               *
      *  Component of: SETRSMUPP                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CAP182  *CREATE    Date 13Mar03               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP182 - Auto Settlement of Trades                           *
      *         - Conversion of SE Trade Settlement Input maintence   *
      *           function to modular structure to use as APIs.       *
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
      ** Valid Trade Settlement File
     FSEVTRSMPD UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Valid Trade Settlements by STDR/SEDE/SFSI/SRIN/TMST
     FSEVTRSML1 UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEVTRSMD0:SEVTRSMD1)
      *
      ** Valid Trade Settlements error file
     FSEVETRSMPDO    E             DISK    INFSR(*PSSR)
     F                                     RENAME(SEVTRSMD0:SEVTRSMERR)
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SETRSMU001
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
     D WDBerrUpd       C                   CONST('DB error in TRSM API update')
      *
      ** String for error message to the operator
     D WProcErr        C                   CONST('Error in module')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** DS for TRSM data area details
     D SETRSMUPC       DS             1    DTAARA(SETRSMUPC)
      *
      ** SE Trade Settlements for file update - file format
     D NwTSFilFmt    E DS                  EXTNAME(SEVTRSMPD)
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
     D PObject         S             10A   INZ('SETRSMUPC')
     D PLockObj        S             10A   INZ('SETRSMLCK')
     D PLib            S             10A   INZ('*LIBL')
     D PObjtype        S              7A   INZ('*DTAARA')
     D PLockStateE     S              7A   INZ('*EXCL')
     D PLockStateS     S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('*CLS')
     D PDlcobj         S              1A
     D PReturn         S              7A
     D WMQError        S             28A
     D PMQErrLong      S            132A
     D PDBError        S             28A
     D PMsgSndRtn      S             10A
     D PReturnCde      S             10A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PReturn2        S              7A
     D PEndjob         S              1A   INZ('Y')
      *
      ** Key Fields
     D WTradeNo        S                   LIKE(VTSSTDR)
     D WMoveDat        S                   LIKE(VTSSEDE)
     D WFullSet        S                   LIKE(VTSSFSI)
     D WReversal       S                   LIKE(VTSSRIN)
     D WTimestamp      S                   LIKE(VTSTMST)
      *
      ** Dummy message Id and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
      *
      ** Parameter list for QRCVDTAQ
     D PDtqNam         S             10A   INZ('APTRSMDTQ')
     D PDtqLib         S             10A   INZ('*LIBL')
     D PDtqLen         S              5P 0 INZ(10)
     D PDtqDta         S             10A
     D PDtqWait        S              5P 0 INZ(-1)
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,SETRSMU002
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
      *
      /COPY WNCPYSRC,SETRSMU003
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DtaQName = 'APTRSMDTQ'
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
     C                   EVAL      PDtqNam = 'APTRSMDTQ'
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
 
      ** If data queue entry is 'END', leave the loop at this point
      *
     C                   IF        PDtqDta = 'END'
     C                   LEAVE
     C                   ENDIF
      *
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
     C                   PARM      *Blanks       PReturn
      *
      ** If the "*EXCL" allocation is impossible, it is most likely because
      ** another update controller is already running for the same API,
      ** (possible if, for example, submitted twice to a hold job queue,
      ** which was released some time later), or because there is something
      ** else wrong (data area not existing, or not authorised...).
      ** In any case, terminate the current module.
      *
 B3  C                   IF        PReturn <> *Blanks
     C                   SETON                                        LR
     C                   LEAVE
 E3  C                   ENDIF
      *
      /COPY WNCPYSRC,SETRSMU004
      *
      ** Position file cursor to start of file to prevent problems on
      ** later calls.
      *
     C     1             SETLL     SEVTRSMPD
      *
      ** Read valid Trade Settlement details.
      *
     C                   READ      SEVTRSMD0                              01
      *
     C                   DOW       EndOfFile = False
      *
      /COPY WNCPYSRC,SETRSMU005
      *
      ** Load the API Dump data area with as many fields from the message
      ** header as are available, so that dumps in any lower level modules
      ** will include the key information.
      *
     C                   EVAL      ARFOTranID = VTSFRNT
     C                   EVAL      ARFOAsocID = *BLANKS
     C                   EVAL      ARRprLocn  = VTSREPA
      *
      /COPY WNCPYSRC,SETRSMU006
      *
      ** Save key fields.
      *
     C                   EVAL      WTradeNo  = VTSSTDR
     C                   EVAL      WMoveDat  = VTSSEDE
     C                   EVAL      WFullSet  = VTSSFSI
     C                   EVAL      WReversal = VTSSRIN
     C                   EVAL      WTimestamp = VTSTMST
      *
      *
      /COPY WNCPYSRC,SETRSMU007
      *
     C                   CALLB     'SETRSMUPD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Trade Settlement Details for file update - file format
     C                   PARM                    NwTSFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Run day number
     C                   PARM                    BJRDNB
      *
      /COPY WNCPYSRC,SETRSMU008
      *
      ** Check for exception error from any program lower in the stack.
      ** If error detected, send message to system operator, rollback
      ** changes and terminate program.
      *
     C                   IN        APDUMP
      *
      /COPY WNCPYSRC,SETRSMU009
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
      /COPY WNCPYSRC,SETRSMU010
      *
      ** Commit updates if no error.
     C                   IF        RetCodeOut = '*ERROR ' OR
     C                             RetCodeOut = '*RECUPD'
     C                   ROLBK
     C                   ELSE
     C                   DELETE    SEVTRSMD0
     C                   COMMIT
     C                   ENDIF
      *
      /COPY WNCPYSRC,SSETRSM011
      *
      ** If an error has occurred, reaccess record in error and remove from
      ** the file to prevent program processing the same record again.
     C                   IF        RetCodeOut = '*ERROR ' OR
     C                             RetCodeOut = '*RECUPD'
 
     C     KTRSML1       CHAIN     SEVTRSML1                          02
      *
      ** Write details of record to error file (same format as SEVTRSMPD).
     C                   WRITE     SEVTRSMERR
     C                   DELETE    SEVTRSMD1
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
     C                   READ      SEVTRSMD0                              01
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
      /COPY WNCPYSRC,SETRSMU012
      *
      ** Exit from program.
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,SETRSMU013
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
 
      *  Check if an existing DBU_TRSM job is active in the subsystem.
 
     C                   CALL      'SCC0520'
     C                   PARM                    PLockObj
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockStateE
     C                   PARM                    PMember
     C                   PARM                    PEndjob
     C                   PARM                    PReturn2
      *
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
     C                   IF        PReturn <> *Blanks
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
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
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile= 'SDSTRDPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Get ZMUSER information.
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Define key list for SEVTRSML1.
     C     KTRSML1       KLIST
     C                   KFLD                    WTradeNo
     C                   KFLD                    WMoveDat
     C                   KFLD                    WFullSet
     C                   KFLD                    WReversal
     C                   KFLD                    WTimestamp
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,SETRSMU014
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
(c) Finastra International Limited 2003
