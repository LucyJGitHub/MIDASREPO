     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME MT941/2 Message Requests - D.B. Update')      *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002560 - Midas ME MT941/2 Message Requests Maint.    *
      *                   (Database Update)                           *
      *                                                               *
      *  Function:  This module updates the files related to a        *
      *             Message Request.                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. AR647426           Date 19Aug14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR647426 - Schedules must be updated also when floors change.*
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
 
     FGLMR94L0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas GL MT941/2 Message Requests - Update
      *
 
     FGLMR94L4  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLMR94D0:GLMR94D4)
      ** Midas GL MT941/2 Message Requests - Duplicates Retrieve
      *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Database Access Indicators                                    *
      *                                                               *
      * 27 - Access GLMR94L0                                          *
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
 
     D CurFilRcd     E DS                  EXTNAME(GLMR94PD)
      ** Current Message Request File Record
      ** (i.e. state of the record when entering this module)
      *
 
     D PrvFilRcd     E DS                  EXTNAME(GLMR94PD) PREFIX(PRV_)
      ** Previous Message Request File Record (i.e. initial state of the record)
      *
 
     D NewFilRcd     E DS                  EXTNAME(GLMR94PD) PREFIX(NEW_)
      ** New Message Request File Record (i.e. new state after amendments)
      *
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
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
 
      ** Key lists
      *
     C     KGLMR94L0     KLIST
     C                   KFLD                    NEW_MRNWRK
     C                   KFLD                    NEW_MRBRCA
     C                   KFLD                    NEW_MRCNUM
     C                   KFLD                    NEW_MRCCY
     C                   KFLD                    NEW_MRACCD
     C                   KFLD                    NEW_MRACSQ
     C                   KFLD                    NEW_MRNATY
     C                   KFLD                    NEW_MRDSTN
     C                   KFLD                    NEW_MRMTPY
     C                   KFLD                    NEW_MRSORQ
     C                   KFLD                    NEW_MRSDTE
     C                   KFLD                    NEW_MRSTIM
     C                   KFLD                    NEW_MRRDTE
     C                   KFLD                    NEW_MRSRTIM
 
     C     KGLMR94L0D    KLIST
     C                   KFLD                    NEW_MRNWRK
     C                   KFLD                    NEW_MRBRCA
     C                   KFLD                    NEW_MRCNUM
     C                   KFLD                    NEW_MRCCY
     C                   KFLD                    NEW_MRACCD
     C                   KFLD                    NEW_MRACSQ
     C                   KFLD                    NEW_MRNATY
     C                   KFLD                    NEW_MRDSTN
 
     C     KGLMR94L0S    KLIST
     C                   KFLD                    NEW_MRNWRK
     C                   KFLD                    NEW_MRBRCA
     C                   KFLD                    NEW_MRCNUM
     C                   KFLD                    NEW_MRCCY
     C                   KFLD                    NEW_MRACCD
     C                   KFLD                    NEW_MRACSQ
     C                   KFLD                    NEW_MRNATY
     C                   KFLD                    NEW_MRDSTN
     C                   KFLD                    NEW_MRMTPY
     C                   KFLD                    NEW_MRSORQ
     C                   KFLD                    NEW_MRSDTE
     C                   KFLD                    NEW_MRSTIM
 
     C     KGLMR94L4     KLIST
     C                   KFLD                    MRNWRK
     C                   KFLD                    MRBRCA
     C                   KFLD                    MRCNUM
     C                   KFLD                    MRCCY
     C                   KFLD                    MRACCD
     C                   KFLD                    MRACSQ
     C                   KFLD                    MRNATY
     C                   KFLD                    MRDSTN
     C                   KFLD                    MRMTPY
     C                   KFLD                    MRRDTE
     C                   KFLD                    MRSRTIM
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR subroutine
 
      ** Do until end of process detected
      *
 B1  C                   DOU       WWEndMod = 'Y'
 
      ** Process the schedule updating according to the action code
      *
 B2  C                   SELECT
 
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
 
      ** Amend a record                                                                     AR647426
      *                                                                                     AR647426
 X2  C                   WHEN      ActionCode = 'A'                                         AR647426
     C                   EXSR      $AmndRcd                                                 AR647426
      *                                                                                     AR647426
 E2  C                   ENDSL
 
      ** If the module was called to process all the requests of a given
      ** destination or schedule, read the following request
      *
 B2  C  N27              IF        ProcessAll = 'Y'
 
 B3  C                   IF        NEW_MRSORQ = *Blanks
     C     KGLMR94L0D    READE     GLMR94D0                               27
 X3  C                   ELSE
     C     KGLMR94L0S    READE     GLMR94D0                               27
 E3  C                   ENDIF
 
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
      * $HoldRcd  : Hold a request                                             *
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
 
      ** Update only the 'WAITING' requests
      *
     C                   IF        MRSTAT <> 'WAITING'
     C                   GOTO      @HoldRcd
     C                   ENDIF
 
      ** Hold the record
      *
     C                   EVAL      MRSTAT = 'HELD'
     C                   UPDATE    GLMR94D0
      *    ----------    ------
     C     @HoldRCd      ENDSR
 
      *========================================================================*
      * $ReleasRcd: Release a request                                          *
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
 
      ** Update only the 'HELD' requests
      *
     C                   IF        MRSTAT <> 'HELD'
     C                   GOTO      @ReleasRcd
     C                   ENDIF
 
      ** Release the record
      *
     C                   TIME                    WWTime6N0         6 0
     C                   MOVEL     WWTime6N0     WWTime4A          4
 
     C     KGLMR94L4     SETLL     GLMR94D4                               99
 
 B1  C                   SELECT
 
      ** Status "EXPIRED" if the current system date and time is greater than
      ** the request date and time
      *
 X1  C                   WHEN      MRRDTE < AGRDNB OR
     C                             (MRRDTE = AGRDNB AND (MRSRTIM = 'IMED' OR
     C                                                   MRSRTIM < WWTime4A))
     C                   EVAL      MRSTAT = 'EXPIRED'
 
      ** Status "DUPLICATE" if there is another request for the same destination,
      ** message type, request date and time, with a status "WAITING" or "SUBMITTED"
      *
 X1  C                   WHEN      *IN99
     C                   EVAL      MRSTAT = 'DUPLICATE'
 
      ** Status "WAITING" otherwise
      *
     C                   OTHER
     C                   EVAL      MRSTAT = 'WAITING'
 E1  C                   ENDSL
 
     C                   UPDATE    GLMR94D0
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
     C                   DELETE    GLMR94D0
      *    ----------    ------
     C     @DeleteRcd    ENDSR
 
      *****************************************************************                     AR647426
      /EJECT                                                                                AR647426
      *****************************************************************                     AR647426
      *                                                               *                     AR647426
      * $AmndRcd  : Amend a request                                   *                     AR647426
      *                                                               *                     AR647426
      * Called by: Main Processing                                    *                     AR647426
      *                                                               *                     AR647426
      * Calls: None                                                   *                     AR647426
      *                                                               *                     AR647426
      *****************************************************************                     AR647426
     C     $AmndRcd      BEGSR                                                              AR647426
      *                                                                                     AR647426
      ** If the "Process All" indicator is "Y" and no record to                             AR647426
      ** process, exit the subroutine                                                       AR647426
      *                                                                                     AR647426
     C                   IF        ProcessAll = 'Y' AND *IN27                               AR647426
     C                   GOTO      @AmndRcd                                                 AR647426
     C                   ENDIF                                                              AR647426
      *                                                                                     AR647426
      ** Record not found ==> Error                                                         AR647426
      *                                                                                     AR647426
     C                   IF        *IN27                                                    AR647426
     C                   MOVE      'ME00050'     ZAMSID                                     AR647426
     C                   EXSR      $ZaSndMsg                                                AR647426
     C                   MOVEL(P)  '*MSG'        RetcodeOut                                 AR647426
     C                   EXSR      $ExitMod                                                 AR647426
     C                   ENDIF                                                              AR647426
      *                                                                                     AR647426
      ** If record already modified by another user ==> Error                               AR647426
      *                                                                                     AR647426
     C                   IF        CurFilRcd <> PrvFilRcd                                   AR647426
     C                   MOVE      'ME00051'     ZAMSID                                     AR647426
     C                   EXSR      $ZaSndMsg                                                AR647426
     C                   MOVEL(P)  '*MSG'        RetcodeOut                                 AR647426
     C                   EXSR      $ExitMod                                                 AR647426
     C                   ENDIF                                                              AR647426
      *                                                                                     AR647426
      ** Update only the 'WAITING' requests                                                 AR647426
      *                                                                                     AR647426
     C                   IF        MRSTAT <> 'WAITING'                                      AR647426
     C                   GOTO      @AmndRcd                                                 AR647426
     C                   ENDIF                                                              AR647426
      *                                                                                     AR647426
      ** Amend only 2 fields on the record                                                  AR647426
      *                                                                                     AR647426
     C                   IF        MR2FLD <> NEW_MR2FLD or +                                AR647426
     C                             MR2FLC <> NEW_MR2FLC                                     AR647426
      *                                                                                     AR647426
     C                   EVAL      MR2FLD = NEW_MR2FLD                                      AR647426
     C                   EVAL      MR2FLC = NEW_MR2FLC                                      AR647426
      *                                                                                     AR647426
     C                   UPDATE    GLMR94D0                                                 AR647426
     C                   ENDIF                                                              AR647426
      *                                                                                     AR647426
     C     @AmndRCd      ENDSR                                                              AR647426
                                                                                            AR647426
      *****************************************************************                     AR647426
      /EJECT                                                                                AR647426
      *****************************************************************                     AR647426
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
 
      ** Retrieve RUNDAT
      *
     C                   IN        RUNDAT
 
      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks
 
      ** If the module was called to process all the schedules of one given
      ** destination, first read of the file with key "destination"
      ** If the module was called to process all the requests of one given
      ** schedule, first read of the file with key "schedule"
      ** Else, access the file on the specified (complete) key
      *
     C                   IF        ProcessAll <> 'Y'
     C     KGLMR94L0     CHAIN     GLMR94D0                           27
     C                   EVAL      WWEndMod = 'Y'
     C                   ELSE
 
     C                   IF        NEW_MRSORQ = *Blanks
     C     KGLMR94L0D    SETLL     GLMR94D0
     C     KGLMR94L0D    READE     GLMR94D0                               27
     C                   ELSE
     C     KGLMR94L0S    SETLL     GLMR94D0
     C     KGLMR94L0S    READE     GLMR94D0                               27
     C                   ENDIF
 
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
