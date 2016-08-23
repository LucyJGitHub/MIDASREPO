     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs purchased database update controller')    *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMNASPUPC - NAS PURCHASED CONTROLLER FOR UPDATES             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. LLN022A            Date 03Jun15               *
      *  Prev Amend No. LLN022             Date 03Jun15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9711            Date 26Jan06               *
      *                 CER001             Date 25Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CAP086             Date 08Jun05               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 201589             Date 03Jan02               *
      *                 187397             Date 09Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 175784             Date 01Mar00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 11Mar99               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LLN022A- BOE Upgrade to MidasPlus - incorporate code from    *
      *           /COPY members and add switchability.                *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *           Compiled over MMNASPU007                            *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9711- Changes to MMVNASPPD/MMVNASSPD (re-compile)         *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMVNASPPD*
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  201589 - Change to check a new locking dataarea MMNASPLCK    *
      *           to determine whether this DBU is already active.    *
      *  187397 - If chain failed in MMVNASPL1 during rollback process*
      *           there is no need to attempt to delete the record    *
      *           (since it is not there anyway).                     *
      *  175784 - Batch update functions can fail repeatedly if one   *
      *           error occurs                                        *
      *  CAP006 - Check for deal being updated by another workstation *
      *         - Send prompt to DTAQ to restart update process after *
      *           failure.                                            *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FMMVNASPPD UF   E             DISK
     F                                     COMMIT
     FMMVNASPL1 UF   E           K DISK
     F                                     RENAME(MMVNASPD0:MMVNASPD1)
     FMMVENASPPDO    E             DISK
     F                                     RENAME(MMVNASPD0:MMVNASPERR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,MMNASPU010
                                                                                              CER001
     FMMVNPLX1L1UF   E           K DISK    USROPN                                             CER001
     F                                     COMMIT                                             CER001
     FMMVENPX1PDO    E             DISK    USROPN                                             CER001
     F                                     RENAME(MMVNPLXD6:MMVNPLXD6R)                       CER001
                                                                                              CER001
 
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
     D DBerrUpd        C                   CONST('DB error in NASP API update')
 
      *****************************************************************
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID NAS PURCHASED
     D MMVNAP        E DS                  EXTNAME(MMVNASPPD)
 
     D MMNASPUPC       DS             1    DTAARA(MMNASPUPC)
                                                                                              CER001
      *                                                                                       CER001
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER001
      ** First DS for access programs, short date structure                                   CER001
      *                                                                                       CER001
 
     D Object          S             10A   INZ('MMNASPUPC')
     D LockObj         S             10A   INZ('MMNASPLCK')                                   201589
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
 
     D ULX004          S              1A                                                      CER001
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMNASPU011
      *                                                                                       CER001
      ** External data structures for Midas Modules                                           CER001
      *                                                                                       CER001
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CER001
      *                                                                                       CER001
      ** New valid extended Deal File                                                         CER001
      *                                                                                       CER001
     D MMVNPLX6      E DS                  EXTNAME(MMVNPLX1L1)                                CER001
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
 
      /COPY WNCPYSRC,MMNASPU001
 
      ** Set up the name of the server/database updater data queue.             CAP006
     C                   EVAL      DtaQName = 'APNASPDTQ'                       CAP006
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
     C                   EVAL      DtqNam = 'APNASPDTQ'
     C                   EVAL      DtqLib = '*LIBL'
     C                   EVAL      ObjType = '*DTAARA'
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
 
      /COPY WNCPYSRC,MMNASPU002
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     MMVNASPPD
 
      ** READ VALID NAS PURCHASED
      *
     C                   READ      MMVNASPD0                              99    *
     C     *IN99         DOWEQ     '0'
 
      /COPY WNCPYSRC,MMNASPU003
 
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lower level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = IHFRNT
     C                   EVAL      ARFOAsocID = IHAFRT
     C                   EVAL      ARRprLocn  = IHREPA
 
      /COPY WNCPYSRC,MMNASPU004
 
      ** MM DATABASE UPDATE
      *
     C                   CALLB     'MMNASPUPM'
     C*******************PARM                    @@RTCD            7            175784
     C                   PARM      *BLANKS       @@RTCD            7            175784
     C                   PARM                    MMVNAP
 
      /COPY WNCPYSRC,MMNASPU005
 
      ** DL DATABASE UPDATE IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C                   ROLBK
     C                   ELSE
     C     @@RTCD        IFNE      '*RECUPD'                                    CAP006
     C     IHCHTP        IFEQ      'I'
     C     IHCHTP        OREQ      'A'
     C     IHCHTP        OREQ      'R'
 
      /COPY WNCPYSRC,MMNASPU006
 
     C                   CALLB     'MMNASPUPD'
     C                   PARM                    @@RTCD            7
     C                   PARM                    MMVNAP
     C                   END
     C                   END                                                    CAP006
     C                   END
 
      /COPY WNCPYSRC,MMNASPU007
      *                                                                                      LLN022A
      ** If BOE installed                                                                    LLN022A
     C                   IF        LLN022 = 'Y'                                              LLN022A
      ** MM BYNASPX0 UPDATE                                                                  LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'MMLNASPXUP'                                              LLN022A
     C                   PARM                    IHDN38                                      LLN022A
     C                   PARM                    IHLACT                                      LLN022A
     C                   PARM                    @@RTCD                                      LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       CER001
      ** ULX004 - Lux MMNASP Extension Data                                                   CER001
      *                                                                                       CER001
     C                   IF        ULX004 = 'Y'                                               CER001
                                                                                              CER001
     C                   IF        @@RTCD = *Blanks                                           CER001
      *                                                                                       CER001
      ** When no error in master files update, update extension file                          CER001
      ** For MM, no physical delete on extension file, it is done                             CER001
      ** during COB when system 'purge' MM master files                                       CER001
      *                                                                                       CER001
      ** Retrieve Extended valid record                                                       CER001
      *                                                                                       CER001
     C     IHFRNT        CHAIN     MMVNPLX1L1                         89                      CER001
      *                                                                                       CER001
     C                   IF        IHLACT = 'I' or                                            CER001
     C                             IHLACT = 'A'                                               CER001
     C                   CALLB     'MMNASP2UP'                                                CER001
     C                   PARM      *BLANK        @@RTCD                                       CER001
     C                   PARM                    IHCHTP                                       CER001
     C                   PARM                    MMVNPLX6                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @@RTCD        IFEQ      *BLANK                                                     CER001
     C                   DELETE    MMVNPLXD6                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
 
      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
     C                   ROLBK
     C                   ELSE
     C                   DELETE    MMVNASPD0
     C                   COMMIT
     C                   END
 
      /COPY WNCPYSRC,MMNASPU008
      *                                                                                       CER001
      ** If an error has occurred, reaccess record in error and remove                        CER001
      ** from the file and write details of record to error valid file                        CER001
      *                                                                                       CER001
     C     ULX004        IFEQ      'Y'                                                        CER001
      *                                                                                       CER001
     C     @@RTCD        IFEQ      '*ERROR '                                                  CER001
     C     @@RTCD        OREQ      '*RECUPD'                                                  CER001
      *                                                                                       CER001
     C     IHFRNT        CHAIN     MMVNPLX1L1                         89                      CER001
      *                                                                                       CER001
     C                   WRITE     MMVNPLXD6R                                                 CER001
     C                   DELETE    MMVNPLXD6                                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
     C                   EVAL      @Dealno = IHDN38
     C                   EVAL      @Timestamp = IHTMESTMP
     C     @KMMDL1       CHAIN     MMVNASPL1                          89
     ** Write details of record to error file (same format as MMVNASPPD)
     C                   WRITE     MMVNASPERR
     C     *IN89         IFEQ      '0'                                                        187397
     C                   DELETE    MMVNASPD1
     C                   ENDIF                                                                187397
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
      *
      ** READ VALID NAS PURCHASED
      *
     C                   READ      MMVNASPD0                              99    *
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
 
      /COPY WNCPYSRC,MMNASPU009
 
      * EXIT FROM PROGRAM
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMNASPU012
 
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
      *  Define key list for MMVNASPL1
     C     @KMMDL1       KLIST
     C                   KFLD                    @Dealno           6 0
     C                   KFLD                    @Timestamp
 
      *  Check if an existing DBU_NASP job is active in the subsystem.                        201589
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
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMNASPU013
      *                                                                                       CER001
      ** Access Module Details to verify if Lux Return feature is                             CER001
      ** active                                                                               CER001
      *                                                                                       CER001
     C                   CALL      'AOMMODR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*FIRST '     @OPTN                                        CER001
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        @RTCD <> *BLANK                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = @OPTN                                              CER001
     C                   EVAL      DBFILE = 'SDMMODPD'                                        CER001
     C                   EVAL      DBASE = 1                                                  CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX004 - LUX NASP Extra Data                                                         CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX004                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
                                                                                              CER001
     C                   IF        @RTCD <> *BLANK  AND @RTCD <> '*NRF   '                    CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = @SARD                                              CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 2                                                  CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C     BGLRIN        ANDEQ     'Y'                                                        CER001
     C                   MOVEL     'Y'           ULX004                                       CER001
     C                   OPEN      MMVNPLX1L1                                                 CER001
     C                   OPEN      MMVENPX1PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Access Switchable Features file to determine whether                                LLN022A
      ** LLN022 (Bank of England) processing is installed.                                   LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN022            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANK        @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN022'      @SARD                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *BLANK                                            LLN022A
     C                   MOVE      'Y'           LLN022                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
 
     C                   ENDSR
     C****************************************************************
      /EJECT
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
