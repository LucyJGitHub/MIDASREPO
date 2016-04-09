     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME MT941/2 Generation Schedules-D.B. Update')
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002460 - Midas ME MT941/2 Generation Schedules       *
      *                   Description Maintenance (Database Update)   *
      *                                                               *
      *  Function:  This module updates the files related to a        *
      *             Generation Schedule description.                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
 
     FGLGS94L0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas GL MT941/2 Generation Schedules - Update
      *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Database Access Indicators                                    *
      *                                                               *
      * 27 - Access GLGS94L0                                          *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 99 - Multi-purpose                                            *
      *                                                               *
      *****************************************************************
 
      ** Automatically included D-specs
      ** ==============================
      *
 
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
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      ** Manually included D-specs
      ** =========================
      *
 
      ** Named constants
      ** ---------------
      *
 
      ** Arrays and Data Structures
      ** --------------------------
      *
 
     D CurFilRcd     E DS                  EXTNAME(GLGS94PD)
      ** Current Generation Schedule File Record
      ** (i.e. state of the record when entering this module)
      *
 
     D PrvFilRcd     E DS                  EXTNAME(GLGS94PD) PREFIX(PRV_)
      ** Previous Generation Schedule File Record (i.e. initial state of the record)
      *
 
     D NewFilRcd     E DS                  EXTNAME(GLGS94PD) PREFIX(NEW_)
      ** New Generation Schedule File Record (i.e. new state after amendments)
      *
 
     D PrvRqsRcd     E DS                  EXTNAME(GLMR94PD) PREFIX(PRV_)
     D  PrevQQACCD1  E                     EXTFLD(QQACCD)                                     CGL029
      ** Previous Message Request File Record (dummy use here)
      *
 
     D NewRqsRcd     E DS                  EXTNAME(GLMR94PD)
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
      ** New Message Request File Record (only to pass reference of
      ** the schedule to process to ME002560, in case of Deletion/Hold/Release)
      *
 
      ** Declared variables
      ** ------------------
      *
     D WWEndMod        S              1A
 
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *
 
      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    CallerIn         10
     C                   PARM                    ActionCode
     C                   PARM                    ProcessAll        1
     C                   PARM                    PrvFilRcd
     C                   PARM                    NewFilRcd
     C                   PARM                    @2FLD            15 0
     C                   PARM                    @2FLC            15 0
 
      ** Key lists
      *
     C     KGLGS94L0     KLIST
     C                   KFLD                    NEW_GSNWRK
     C                   KFLD                    NEW_GSBRCA
     C                   KFLD                    NEW_GSCNUM
     C                   KFLD                    NEW_GSCCY
     C                   KFLD                    NEW_GSACCD
     C                   KFLD                    NEW_GSACSQ
     C                   KFLD                    NEW_GSNATY
     C                   KFLD                    NEW_GSDSTN
     C                   KFLD                    NEW_GSMTPY
     C                   KFLD                    NEW_GSSDTE
     C                   KFLD                    NEW_GSSTIM
 
     C     KGLGS94L0P    KLIST
     C                   KFLD                    NEW_GSNWRK
     C                   KFLD                    NEW_GSBRCA
     C                   KFLD                    NEW_GSCNUM
     C                   KFLD                    NEW_GSCCY
     C                   KFLD                    NEW_GSACCD
     C                   KFLD                    NEW_GSACSQ
     C                   KFLD                    NEW_GSNATY
     C                   KFLD                    NEW_GSDSTN
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR subroutine
 
      ** Do until end of process detected
      *
 B1  C                   DOU       WWEndMod = 'Y'
 
      ** Update the requests linked to the current schedule, or
      ** to the requested destination if called to do so
      *
 B2  C                   IF        ActionCode <> 'I'
     C                   EXSR      $UpdRqsts
 E2  C                   ENDIF
 
      ** Process the schedule updating according to the action code
      *
 B2  C                   SELECT
 
      ** -- Insert a record
      *
 X2  C                   WHEN      ActionCode = 'I'
     C                   EXSR      $InsertRcd
 
      ** -- Hold a record
      *
 X2  C                   WHEN      ActionCode = 'H'
     C                   EXSR      $HoldRcd
 
      ** -- Release a record
      *
 X2  C                   WHEN      ActionCode = 'R'
     C                   EXSR      $ReleasRcd
 
      ** -- Delete a record
      *
 X2  C                   WHEN      ActionCode = 'D'
     C                   EXSR      $DeleteRcd
 
 E2  C                   ENDSL
 
      ** If the module was called to process all the schedules of a given
      ** destination, read the following schedule
      *
 B2  C  N27              IF        ProcessAll = 'Y'
     C     KGLGS94L0P    READE     GLGS94D0                               27
     C  N27              EVAL      PrvFilRcd = CurFilRcd
     C   27              EVAL      WWEndMod = 'Y'
 E2  C                   ENDIF
 
 E1  C                   ENDDO
 
      ** End of the module
      *
     C                   EXSR      $ExitMod
 
      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*
 
      *========================================================================*
      * $UpdRqsts : Process the linked message requests                        *
      *------------------------------------------------------------------------*
     C     $UpdRqsts     BEGSR
      *    ----------    ------
      ** If the "Process All" was requested by the caller, the reference
      ** passed to ME002560 is the one of the received destination
      ** Else, it is the one of the current schedule
      *
     C                   CLEAR                   PrvRqsRcd
     C                   CLEAR                   NewRqsRcd
 
     C                   EVAL      MRNWRK = GSNWRK
     C                   EVAL      MRBRCA = GSBRCA
     C                   EVAL      MRCNUM = GSCNUM
     C                   EVAL      MRCCY  = GSCCY
     C                   EVAL      MRACCD = GSACCD
     C                   EVAL      MRACSQ = GSACSQ
     C                   EVAL      MRNATY = GSNATY
     C                   EVAL      MRDSTN = GSDSTN
 
     C                   IF        ProcessAll <> 'Y'
     C                   EVAL      MRMTPY = GSMTPY
     C                   EVAL      MRSORQ = 'SCHEDULE'
     C                   EVAL      MRSDTE = GSSDTE
     C                   EVAL      MRSTIM = GSSTIM
     C                   ENDIF
 
     C                   CALLB     'ME002560'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut        10
     C                   PARM                    ActionCode
     C                   PARM      'Y'           OProcesAll        1
     C                   PARM                    PrvRqsRcd
     C                   PARM                    NewRqsRcd
 
     C                   IF        RetCodeIn <> *Blanks
     C                   EVAL      RetCodeOut = RetCodeIn
     C                   EXSR      $ExitMod
     C                   ENDIF
      *    ----------    ------
     C     @UpdRqsts     ENDSR
 
      *========================================================================*
      * $InsertRcd: Insert a new record                                        *
      *------------------------------------------------------------------------*
     C     $InsertRcd    BEGSR
      *    ----------    ------
      ** Record already exists ==> Error
 
     C                   IF        NOT *IN27
     C                   MOVE      'ME00049'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF
 
      ** Insert the new record
      *
     C                   MOVEL     NewFilRcd     CurFilRcd
     C                   EVAL      GSSTUS = 'ACTIVE'
     C                   WRITE     GLGS94D0
 
      ** Generates the involved message generation requests
      *
     C                   CALLB     'ME002561'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut        10
     C                   PARM                    NewFilRcd
     C                   PARM                    @2FLD
     C                   PARM                    @2FLC
 
     C                   IF        RetCodeIn <> *Blanks
     C                   EVAL      RetCodeOut = RetCodeIn
     C                   EXSR      $ExitMod
     C                   ENDIF
      *    ----------    ------
     C     @InsertRcd    ENDSR
 
      *========================================================================*
      * $HoldRcd  : Hold a schedule record                                     *
      *------------------------------------------------------------------------*
     C     $HoldRcd      BEGSR
      *    ----------    ------
      ** If the "Process All" indicator is "Y" and no record to process, exit
      ** the subroutine
      *
     C                   IF        ProcessAll = 'Y' AND *IN27
     C                   GOTO      @HoldRcd
     C                   ENDIF
 
      ** Record not found ==> Error
      *
     C                   IF        *IN27
     C                   MOVE      'ME00050'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF
 
      ** If record already modified by another user ==> Error
      *
     C                   IF        CurFilRcd <> PrvFilRcd
     C                   MOVE      'ME00051'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF
 
      ** Hold the record
      *
     C                   EVAL      GSSTUS = 'HELD'
     C                   UPDATE    GLGS94D0
      *    ----------    ------
     C     @HoldRCd      ENDSR
 
      *========================================================================*
      * $ReleasRcd: Release a schedule record                                  *
      *------------------------------------------------------------------------*
     C     $ReleasRcd    BEGSR
      *    ----------    ------
      ** If the "Process All" indicator is "Y" and no record to process, exit
      ** the subroutine
      *
     C                   IF        ProcessAll = 'Y' AND *IN27
     C                   GOTO      @ReleasRcd
     C                   ENDIF
 
      ** Record not found ==> Error
      *
     C                   IF        *IN27
     C                   MOVE      'ME00050'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF
 
      ** If record already modified by another user ==> Error
      *
     C                   IF        CurFilRcd <> PrvFilRcd
     C                   MOVE      'ME00051'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF
 
      ** Release the record
      *
     C                   EVAL      GSSTUS = 'ACTIVE'
     C                   UPDATE    GLGS94D0
      *    ----------    ------
     C     @ReleasRcd    ENDSR
 
      *========================================================================*
      * $DeleteRcd: Delete a record                                            *
      *------------------------------------------------------------------------*
     C     $DeleteRcd    BEGSR
      *    ----------    ------
      ** If the "Process All" indicator is "Y" and no record to process, exit
      ** the subroutine
      *
     C                   IF        ProcessAll = 'Y' AND *IN27
     C                   GOTO      @DeleteRcd
     C                   ENDIF
 
      ** Record not found ==> Error
      *
     C                   IF        *IN27
     C                   MOVE      'ME00052'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF
 
      ** If record already modified by another user ==> Error
      *
     C                   IF        CurFilRcd <> PrvFilRcd
     C                   MOVE      'ME00053'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetcodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF
 
      ** Delete the record
      *
     C                   DELETE    GLGS94D0
      *    ----------    ------
     C     @DeleteRcd    ENDSR
 
      *========================================================================*
      * $ZaSndMsg : Send message to the program message queue                  *
      *------------------------------------------------------------------------*
     C     $ZaSndMsg     BEGSR
      *    ----------    ------
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *    ----------    ------
     C     @ZaSndMsg     ENDSR
 
      *========================================================================*
      * $ExitMod  : Exit from the module                                       *
      *------------------------------------------------------------------------*
     C     $ExitMod      BEGSR
      *    ----------    ------
     C                   MOVE      *On           *INLR
     C                   RETURN
      *    ----------    ------
     C     @ExitMod      ENDSR
 
      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *========================================================================*
     C     *INZSR        BEGSR
      *    ----------    ------
      ** Initialise Copyright Array
      *
     C                   MOVEA     CPY@          CPY@@            80
 
      ** Define fields used by the message sending function
      *
      ** -- If no named caller --> set-up ZAPGM with the current program name
      *
     C                   IF        CallerIn = *Blanks
     C                   MOVEL     PSProcPgm     ZAPGM            10
 
      ** -- Otherwise set-up ZAPGM with the caller name
      *
     C                   ELSE
     C                   MOVEL     CallerIn      ZAPGM
     C                   ENDIF
 
     C                   MOVEL     'MEMSG'       ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *Blanks       ZAMSID            7
     C                   MOVEL     *Blanks       ZAMSDA          132
     C                   MOVEL     *Blanks       ZAMSTP            7
 
      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks
 
      ** If the module was called to process all the schedules of one given
      ** destination, first read of the file
      ** Else, access the file on the specified (complete) key
      *
     C                   IF        ProcessAll <> 'Y'
     C     KGLGS94L0     CHAIN     GLGS94D0                           27
     C                   EVAL      WWEndMod = 'Y'
     C                   ELSE
     C     KGLGS94L0P    SETLL     GLGS94D0
     C     KGLGS94L0P    READE     GLGS94D0                               27
     C  N27              EVAL      PrvFilRcd = CurFilRcd
     C   27              EVAL      WWEndMod = 'Y'
     C                   ENDIF
      *    ----------    ------
     C     @INZSR        ENDSR
 
      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
     C     *PSSR         BEGSR
      *    ----------    ------
     C                   DUMP
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
 
     C                   CALLB     'DBERRCTL'                           99
 
     C                   MOVEL(P)  '*ERROR'      RetCodeOut
     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR
 
      *========================================================================*
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
