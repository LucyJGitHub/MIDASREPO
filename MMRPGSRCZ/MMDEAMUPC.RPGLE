     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal amendments controller for updates')      *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMDEAMUPC - DEAL AMENDMENTS CONTROLLER FOR UPDATES           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201589             Date 03Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 175784             Date 01Mar00               *
      *                 CAP051             Date 12Nov99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 09Mar99               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMVDEAMPD*
      *  201589 - Change to check a new locking dataarea MMDEAMLCK    *
      *           to determine whether this DBU is already active.    *
      *  175784 - Batch update functions can fail repeatedly if one   *
      *           error occurs                                        *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMDEAMPP               *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDEAMPP               *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *         - Send prompt to DTAQ to restart update process after *
      *           failure.                                            *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
     FMMVDEAMPD UF   E             DISK
     F                                     COMMIT
 
     FMMVDEAML2 UF   E           K DISK
     F                                     RENAME(MMVDEAMD0:MMVDEAMD2)
     FMMVEDEAMPDO    E             DISK
     F                                     RENAME(MMVDEAMD0:MMVDEAMERR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,MMDEAMU010
 
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
 
     D DBerrUpd        C                   CONST('DB error in DEAM API update')
                                                                                              CDL006
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL006
      ** External data structure for SAR details                                              CDL006
                                                                                              CDL006
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CDL006
      ** First DS for access programs, short data structure                                   CDL006
 
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID DEAL AMENDMENTS
     D MMVDEM        E DS                  EXTNAME(MMVDEAMPD)
 
     D MMDEAMUPC       DS             1    DTAARA(MMDEAMUPC)
 
     D Object          S             10A   INZ('MMDEAMUPC')
     D LockObj         S             10A   INZ('MMDEAMLCK')                                   201589
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
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMDEAMU011
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
 
      /COPY WNCPYSRC,MMDEAMU001
 
      ** Set up the name of the server/database updater data queue.             CAP006
     C                   EVAL      DtaQName = 'APDEAMDTQ'                       CAP006
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
     C                   EVAL      DtqNam = 'APDEAMDTQ'
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
 
      /COPY WNCPYSRC,MMDEAMU002
 
      ** Position file cursor to start of file to prevent problems on
      ** later calls
     C     1             SETLL     MMVDEAMPD
 
      ** READ VALID DEAL AMENDMENTS
     C                   READ      MMVDEAMD0                              99    *
     C     *IN99         DOWEQ     '0'
 
      /COPY WNCPYSRC,MMDEAMU003
 
      ** Load the API Dump data area with as many fields from the message
      **  header as are available, so that dumps in any lower level modules
      **  will include the key information
     C                   EVAL      ARFOTranID = IGFRNT
     C                   EVAL      ARFOAsocID = IGAFRT
     C                   EVAL      ARRprLocn  = IGREPA
 
      /COPY WNCPYSRC,MMDEAMU004
 
      ** MM DATABASE UPDATE
     C                   CALLB     'MMDEAMUPM'
     C*******************PARM                    @@RTCD            7            175784
     C                   PARM      *BLANKS       @@RTCD            7            175784
     C                   PARM                    MMVDEM
 
      /COPY WNCPYSRC,MMDEAMU005
 
      ** DL DATABASE UPDATE IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C                   ROLBK
     C                   ELSE
     C     @@RTCD        IFNE      '*RECUPD'                                    CAP006
     C     IGCHTP        IFEQ      'I'
     C     IGCHTP        OREQ      'A'
     C     IGCHTP        OREQ      'R'
 
      /COPY WNCPYSRC,MMDEAMU006
 
     C                   CALLB     'MMDEAMUPD'
     C                   PARM                    @@RTCD            7
     C                   PARM                    MMVDEM
     C                   END
     C                   END                                                    CAP006
     C                   END
 
      /COPY WNCPYSRC,MMDEAMU007
 
      * COMIT UPDATES IF NO ERROR
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
     C                   ROLBK
     C                   ELSE
     C                   DELETE    MMVDEAMD0
     C                   COMMIT
     C                   END
 
      /COPY WNCPYSRC,MMDEAMU008
 
     ** If an error has occurred, reaccess record in error and remove from
     ** the file to prevent program processing the same record again
     C     @@RTCD        IFEQ      '*ERROR '
     C     @@RTCD        OREQ      '*RECUPD'                                    CAP006
     C                   EVAL      @Dealno = IGDA38
     C                   EVAL      @VDatYY = IGVDYY
     C                   EVAL      @VDatMM = IGVDMM
     C                   EVAL      @VDatDD = IGVDDD
     C                   EVAL      @DeamSeq = IGDS38
     C                   EVAL      @Timestamp = IGTMESTMP
     C     @KMMDL1       CHAIN     MMVDEAML2                          89
     ** Write details of record to error file (same format as MMVDEAMPD)
     C                   WRITE     MMVDEAMERR
     C                   DELETE    MMVDEAMD2
     ** Send message to system operator
     C                   MOVEL     DBerrUpd      DBError          28
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   ENDIF
 
      ** READ VALID DEAL AMENDMENTS
     C                   READ      MMVDEAMD0                              99    *
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
 
      /COPY WNCPYSRC,MMDEAMU009
 
      * EXIT FROM PROGRAM
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMDEAMU012
 
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
      *
      *  Define key list for MMVDEAML1
     C     @KMMDL1       KLIST
     C                   KFLD                    @Dealno           6 0
     C                   KFLD                    @VdatYY           4 0
     C                   KFLD                    @VdatMM           2 0
     C                   KFLD                    @VdatDD           2 0
     C                   KFLD                    @DeamSeq          3 0
     C                   KFLD                    @Timestamp
                                                                                              CDL006
      *  Check if an existing DBU_DEAM job is active in the subsystem.                        201589
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
      ** Check if Dealing Fiduciary is switched ON                                            CDL006
                                                                                              CDL006
     C                   CALLB     'MMFIDINIT'                                                CDL006
     C                   PARM      *BLANKS       WRTCD             7                          CDL006
 
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
      /COPY WNCPYSRC,MMDEAMU013
 
     C                   ENDSR
     C****************************************************************
      /EJECT
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
