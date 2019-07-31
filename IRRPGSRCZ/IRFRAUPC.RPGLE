     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR FRA database update controller')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRFRAUPC - Forward Rate Agreements                           *
      *             DATABASE UPDATE CONTROLLER                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 245219             Date 09Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7166            Date 12May05               *
      *                 TDA011             Date 31Mar04               *
      *                 222727             Date 05Nov03               *
      *                 CAS006             Date 21Jan03               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 168981             Date 20May99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 15Mar99               *
      *                 CAP004             Date 10Sep98               *
      *                 CAP003  *CREATE    Date 01May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245219 - Missing deals in extension file DLDLDGQD (done from *
      *           Java layer).                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7166- Valid file does not match DEALSDG (Recompile)       *
      *  TDA011 - Rate Fix Ccy writes to the wrong field (Recompile)  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CAP056 - Automatic Authorisation of Interface deals.         *
      *  CIR008 - FRA/IRS Deals Authorisation.                        *
      *  201589 - Change to check a new locking dataarea IRFRALCK     *
      *           to determine whether this DBU is already active.    *
      *  CIR005 - FRA/IRS Business Day Conventions (Recompiled)       *
      *  168981 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*.      *
      *           (recompiled)                                        *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *         - Send prompt to DTAQ to restart update process after *
      *           failure.                                            *
      *  CAP004 - API's Phase 3.                                      *
      *           Add hooks                                           *
      *  CAP003 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FIRVFRAPD  UF   E             DISK
     F                                     COMMIT
     FIRVFRAL1  UF   E           K DISK
     F                                     RENAME(IRVFRAD0:IRVFRAD1)
     FIRVEFRAPD O    E             DISK
     F                                     RENAME(IRVFRAD0:IRVFRAERR)
 
                                                                                              245219
      ** Midas DL IRS Deals Extension Details.                                                245219
     FDLDEALL5  UF A E           K DISK    INFSR(*PSSR)                                       245219
     F                                     IGNORE(DLDLDBD0)                                   245219
     F                                     IGNORE(DLDLDCD0)                                   245219
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,IRFRAUP008
 
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
 
      **------------------------------------------------------------------------CAP006--------------
      ** The following /COPY line includes the definitions for fields           CAP006
      ** used in checking whether there are messages on the data queue.         CAP006
     D/COPY ZACPYSRC,DTAQCHKDCL                                                 CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D DBerrUpd        C                   CONST('DB error in FRA API update')
 
      *****************************************************************
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID LOAN & DEPOSIT
     D IRVFRA        E DS                  EXTNAME(IRVFRAPD)
 
     D IRFRAUPC        DS             1    DTAARA(IRFRAUPC)
                                                                                              CIR008
      ** External DS for SAR Details                                                          CIR008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CIR008
     D SCA_LCD       E                     EXTFLD(LCD)                                        CIR008
                                                                                              CIR008
      ** First DS for access programs, short data structure                                   CIR008
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CIR008
 
     D Object          S             10A   INZ('IRFRAUPC')
     D LockObj         S             10A   INZ('IRFRALCK')                                    201589
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockStateE      S              7A   INZ('*EXCL')
     D LockStateS      S              7A   INZ('*SHRRD')
     D Member          S             10A
     D PRetCode        S              7A                                                      CIR008
     D POption         S              7A                                                      CIR008
     D PSARD           S              6A                                                      CIR008
     D PModeOfOp       S              6A                                                      CAP056
     D WaitTime        S              6A   INZ('*CLS')
     D Dlcobj          S              1A
     D Return          S              7A
     D Return2         S              7A                                                      201589
     D Endjob          S              1A   INZ('Y')                                           201589
     D @Timestamp      S             26Z
     D WkActn          S              1A                                                      245219
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Switchable Feature Parameter                                                         CIR008
     D CIR008          S              1A                                                      CIR008
     D CAP056          S              1A                                                      CAP056
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,IRFRAUP009
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
                                                                                CAP004
      /COPY WNCPYSRC,IRFRAUP001                                                 CAP004
 
      ** Set up the name of the server/database updater data queue.             CAP006
     C                   EVAL      DtaQName = 'APFRADTQ'                        CAP006
                                                                                CAP006
      **------------------------------------------------------------------------CAP006--------------
      ** The following /COPY line includes a check for whether there            CAP006
      ** are messages on the server/updater data queue, and sends a 'GO'.       CAP006
      ** message to the data queue if there are not.                            CAP006
     D/COPY ZACPYSRC,DTAQCHK                                                    CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006
      *  Initialise Data queue parms
     C                   EVAL      DtqLen = 10
     C                   EVAL      DtqWait = -1
     C                   EVAL      DtqNam = 'APFRADTQ'
     C                   EVAL      DtqLib = '*LIBL'
      ** Wait for data queue prompt
      ** Server program will send data queue entry when record is
      ** written to the valid transactions file
     C     DtqDta        DOWNE     'END'
     C                   CALL      'QRCVDTAQ'
     C                   PARM                    DtqNam           10
     C                   PARM                    DtqLib           10
     C                   PARM                    DtqLen            5 0
     C                   PARM                    DtqDta           10
     C                   PARM                    DtqWait           5 0
     C     DtqDta        IFEQ      'GO'
      *  Lock allocation data area
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateE
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
                                                                                CAP004
      /COPY WNCPYSRC,IRFRAUP002                                                 CAP004
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     IRVFRAPD
 
      ** READ VALID LOANS & DEPOSITS
     C                   READ      IRVFRAD0                               99    *
     C     *IN99         DOWEQ     '0'
                                                                                CAP004
      /COPY WNCPYSRC,IRFRAUP003                                                 CAP004
 
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lowere level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = FRFRNT
     C                   EVAL      ARRprLocn  = FRREPA
                                                                                CAP004
      /COPY WNCPYSRC,IRFRAUP004                                                 CAP004
 
      ** DL DATABASE UPDATE
     C     @@RTCD        IFNE      '*RECUPD'                                    CAP006
     C     FRCHTP        IFEQ      'I'
     C     FRCHTP        OREQ      'A'
     C     FRCHTP        OREQ      'R'
     C     FRCHTP        OREQ      'X'                                                        CIR008
     C     CIR008        ANDEQ     'Y'                                                        CIR008
     C                   Eval      WkActn = FRCHTP                                            245219
                                                                                              245219
     C                   CALLB     'IRFRAUPD'
     C                   PARM                    @@RTCD            7
     C                   PARM      '*FRONT'      PModeOfOp                                    CAP056
     C                   PARM                    IRVFRA
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    CAP056                                       CAP056
                                                                                CAP004
      /COPY WNCPYSRC,IRFRAUP005                                                 CAP004
     C                   END                                                    CAP006
     C                   END
 
      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
     C                   ROLBK
     C                   ELSE
                                                                                              245219
      ** Add record to DLDLDGQD once deal is on DEALSDG as this is what java does             245219
     C                   IF        WkActn = 'I'                                               245219
     C                   EXSR      WriteDLDLDG                                                245219
     C                   END                                                                  245219
                                                                                              245219
     C                   DELETE    IRVFRAD0
     C                   COMMIT
     C/COPY WNCPYSRC,IRFRAUC001
     C                   END
                                                                                CAP004
      /COPY WNCPYSRC,IRFRAUP006                                                 CAP004
                                                                                CAP004
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
     C                   EVAL      @Dealno = FRDLNO
     C                   EVAL      @Timestamp = FRTMESTMP
     C     @KFRAL1       CHAIN     IRVFRAL1                           89
     ** Write details of record to error file (same format as IRVFRAPD)
     C                   WRITE     IRVFRAERR
     C                   DELETE    IRVFRAD1
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** READ VALID FORWARD RATE AGREEMENTS
     C                   READ      IRVFRAD0                               99    *
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
                                                                                CAP004
      /COPY WNCPYSRC,IRFRAUP007                                                 CAP004
 
      * EXIT FROM PROGRAM
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRFRAUP010
 
      *****************************************************************                       245219
      /EJECT                                                                                  245219
      *****************************************************************                       245219
      *                                                               *                       245219
      * WriteDLDLDG - WRITE IRS Extension record                      *                       245219
      *               (usually done from java layer)                  *                       245219
      *                                                               *                       245219
      *****************************************************************                       245219
     C     WriteDLDLDG   BEGSR                                                                245219
      *                                                                                       245219
      ** When opening new deals within DEALSDG, write a corresponding                         245219
      ** record in the Deals details extension file DLDLDGQD.                                 245219
      *                                                                                       245219
     C     @KeyDealL5    KLIST                                                                245219
     C                   KFLD                    F1DLNO                                       245219
      *                                                                                       245219
     C                   MOVE      FRDLNO        F1DLNO                                       245219
     C     @KeyDealL5    CHAIN     DLDLDGD0                           82                      245219
      *                                                                                       245219
     C     *IN82         IFEQ      *ON                                                        245219
     C                   EVAL      F1BRCA = FRBRCA                                            245219
     C                   WRITE     DLDLDGD0                                                   245219
                                                                                              245219
     C                   ENDIF                                                                245219
                                                                                              245219
     C                   ENDSR                                                                245219
      *****************************************************************                       245219
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
      *  Define key list for IRVFRAL1
     C     @KFRAL1       KLIST
     C                   KFLD                    @Dealno           6 0
     C                   KFLD                    @Timestamp
                                                                                              CIR008
      **  Access SAR details file to determine if CIR008 is installed                         CIR008
                                                                                              CIR008
     C                   CALL      'AOSARDR0'                                                 CIR008
     C                   PARM      *BLANKS       PRetCode                                     CIR008
     C                   PARM      '*VERIFY'     POption                                      CIR008
     C                   PARM      'CIR008'      PSARD                                        CIR008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR008
                                                                                              CIR008
     C                   IF        PRetCode <> *BLANKS and PRetCode <> '*NRF   '              CIR008
     C     *LOCK         IN        LDA                                                        CIR008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR008
     C                   EVAL      DBASE = 901                                                CIR008
     C                   EVAL      DBKEY = 'CIR008'                                           CIR008
     C                   OUT       LDA                                                        CIR008
     C                   EXSR      *PSSR                                                      CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   IF        PRetCode = *BLANKS                                         CIR008
     C                   EVAL      CIR008 = 'Y'                                               CIR008
     C                   ELSE                                                                 CIR008
     C                   EVAL      CIR008 = 'N'                                               CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CAP056
      **  Access SAR details file to determine if CAP056 is installed                         CAP056
                                                                                              CAP056
     C                   CALL      'AOSARDR0'                                                 CAP056
     C                   PARM      *BLANKS       PRetCode                                     CAP056
     C                   PARM      '*VERIFY'     POption                                      CAP056
     C                   PARM      'CAP056'      PSARD                                        CAP056
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP056
                                                                                              CAP056
     C                   IF        PRetCode <> *BLANKS and PRetCode <> '*NRF   '              CAP056
     C     *LOCK         IN        LDA                                                        CAP056
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP056
     C                   EVAL      DBASE = 902                                                CAP056
     C                   EVAL      DBKEY = 'CAP056'                                           CAP056
     C                   OUT       LDA                                                        CAP056
     C                   EXSR      *PSSR                                                      CAP056
     C                   ENDIF                                                                CAP056
                                                                                              CAP056
     C                   IF        PRetCode = *BLANKS                                         CAP056
     C                   EVAL      CAP056 = 'Y'                                               CAP056
     C                   ELSE                                                                 CAP056
     C                   EVAL      CAP056 = 'N'                                               CAP056
     C                   ENDIF                                                                CAP056
      *
      *  Check if an existing DBU_FRA job is active in the subsystem.                         201589
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
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRFRAUP011
 
     C                   ENDSR
     C****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE                                                                 CIR008
      /EJECT                                                                                  CIR008
**  CPY@
(c) Finastra International Limited 2001
