     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network A/c MT94x Dtl Desc.- D.B. Update')    *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002360 - Midas ME Network Account MT94x Details      *
      *                   Description Maintenance (Database Update)   *
      *                                                               *
      *  Function:  This module updates the files related to a        *
      *             Network Account MT94x Details description.        *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR647426           Date 19Aug14               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 17Mar10               *
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 27Oct03               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  AR647426 - Schedules must be updated also when floors change.*
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
/*    *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************

     FGLNW94L0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas GL Network Accounts MT94x Details - Update
      *

     FGLACBTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account Balances Today
      *

     FRSACMTL2  IF   E           K DISK    INCLUDE(APOSTPDF) INFSR(*PSSR)
      ** Midas GL Account Movements.
      *

     FGLPOSTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Postings for MT94x Messages
      *
     FGLPOSTPD  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLPOSTD0:GLPOSTDD)
     F                                     COMMIT

     FGLRSACL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL MT94x Used Account Movements
      *
     FGLRSACPD  O    E             DISK    INFSR(*PSSR)
     F                                     RENAME(GLRSACD0:GLRSACDD)
     F                                     COMMIT

      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Database Access Indicators                                    *
      *                                                               *
      * 27 - Access GLNW94L0                                          *
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

      *========================================================================*
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

     D CurFilRcd     E DS                  EXTNAME(GLNW94PD)
      ** Current Network File Record (i.e. state of the record when entering this module)
      *

     D PrvFilRcd     E DS                  EXTNAME(GLNW94PD) PREFIX(PRV_)
      ** Previous Network File Record (i.e. initial state of the record)
      *

     D NewFilRcd     E DS                  EXTNAME(GLNW94PD) PREFIX(NEW_)
      ** New Network File Record (i.e. new state after amendments)
      *

     D PrvSchRcd     E DS                  EXTNAME(GLGS94PD) PREFIX(PRV_)
     D  PrecQQACCD   E                     EXTFLD(QQACCD)                                     CGL029
      ** Previous Generation Schedule File Record (dummy use here)
      *

     D NewSchRcd     E DS                  EXTNAME(GLGS94PD)
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
      ** New Generation Schedule File Record (only to pass reference of
      ** the destination to process to ME002460, in case of Deletion)
      *
                                                                                            AR647426
     D PrvRqsRcd     E DS                  EXTNAME(GLMR94PD) PREFIX(PRV_)                   AR647426
     D  PrevQQACCD1  E                     EXTFLD(QQACCD)                                   AR647426
      ** Previous Message Request File Record (dummy use here)                              AR647426
      *                                                                                     AR647426
                                                                                            AR647426
     D NewRqsRcd     E DS                  EXTNAME(GLMR94PD)                                AR647426
     D  NewQQACCD1   E                     EXTFLD(QQACCD)                                   AR647426
      ** New Message Request File Record (only to pass reference of                         AR647426
      ** the schedule to process to ME002560, in case of                                    AR647426
      ** Deletion/Hold/Release)                                                             AR647426
      *                                                                                     AR647426

     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *

      ** Declared variables
      ** ------------------
      *
     D MsgType         S                   LIKE(MGMTPY)

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
     C                   PARM                    PrvFilRcd
     C                   PARM                    NewFilRcd

      ** Key lists
      *
     C     KGLNW94L0     KLIST
     C                   KFLD                    NEW_N4NWRK
     C                   KFLD                    NEW_N4BRCA
     C                   KFLD                    NEW_N4CNUM
     C                   KFLD                    NEW_N4CCY
     C                   KFLD                    NEW_N4ACCD
     C                   KFLD                    NEW_N4ACSQ
     C                   KFLD                    NEW_N4NATY
     C                   KFLD                    NEW_N4DSTN

     C     KGLACBTL0     KLIST
     C                   KFLD                    N4CNUM
     C                   KFLD                    N4CCY
     C                   KFLD                    N4ACCD
     C                   KFLD                    N4ACSQ
     C                   KFLD                    N4BRCA

     C     KRSACMTL2     KLIST
     C                   KFLD                    N4BRCA
     C                   KFLD                    N4CNUM
     C                   KFLD                    N4CCY
     C                   KFLD                    N4ACCD
     C                   KFLD                    N4ACSQ

     C     KGLPOSTL0     KLIST
     C                   KFLD                    N4NWRK
     C                   KFLD                    N4BRCA
     C                   KFLD                    N4CNUM
     C                   KFLD                    N4CCY
     C                   KFLD                    N4ACCD
     C                   KFLD                    N4ACSQ
     C                   KFLD                    N4NATY
     C                   KFLD                    N4DSTN
     C                   KFLD                    MsgType

     C     KGLRSACL0     KLIST
     C                   KFLD                    N4NWRK
     C                   KFLD                    N4BRCA
     C                   KFLD                    N4CNUM
     C                   KFLD                    N4CCY
     C                   KFLD                    N4ACCD
     C                   KFLD                    N4ACSQ
     C                   KFLD                    N4NATY
     C                   KFLD                    N4DSTN
     C                   KFLD                    MsgType

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

      ** Process updating according to the action code
      *
     C                   SELECT

      ** -- Insert a record
      *
     C                   WHEN      ActionCode = 'I'
     C                   EXSR      $InsertRcd

      ** -- Update a record
      *
     C                   WHEN      ActionCode = 'A'
     C                   EXSR      $UpdateRcd

      ** -- Delete a record
      *
     C                   WHEN      ActionCode = 'D'
     C                   EXSR      $DeleteRcd

     C                   ENDSL

      ** End of the module
      *
     C                   EXSR      $ExitMod

      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*

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
     C                   EXSR      $UpdBalanc
     C                   EVAL      N4RECI = 'D'
     C                   EVAL      N4LCDT = AGRDNB
     C                   EVAL      N4CHTP = 'I'
     C                   EVAL      N4USER = PSUser
     C                   WRITE     GLNW94D0
      *    ----------    ------
     C     @InsertRcd    ENDSR

      *========================================================================*
      * $UpdateRcd: Update a record                                            *
      *------------------------------------------------------------------------*
     C     $UpdateRcd    BEGSR
      *    ----------    ------
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

      ** Amend the record
      *
     C                   MOVEL     NewFilRcd     CurFilRcd
     C                   EXSR      $UpdBalanc
     C                   EVAL      N4RECI = 'D'
     C                   EVAL      N4LCDT = AGRDNB
     C                   EVAL      N4CHTP = 'A'
     C                   EVAL      N4USER = PSUser
     C                   UPDATE    GLNW94D0
      *                                                                                     AR647426
      ** If the "Process All" was requested by the caller, the                              AR647426
      ** reference passed to ME002560 is the one of the received                            AR647426
      ** destination. Else, it is the one of the current schedule                           AR647426
      *                                                                                     AR647426
     C                   CLEAR                   PrvRqsRcd                                  AR647426
     C                   CLEAR                   NewRqsRcd                                  AR647426
      *                                                                                     AR647426
     C                   EVAL      MRNWRK = N4NWRK                                          AR647426
     C                   EVAL      MRBRCA = N4BRCA                                          AR647426
     C                   EVAL      MRCNUM = N4CNUM                                          AR647426
     C                   EVAL      MRCCY  = N4CCY                                           AR647426
     C                   EVAL      MRACCD = N4ACCD                                          AR647426
     C                   EVAL      MRACSQ = N4ACSQ                                          AR647426
     C                   EVAL      MRNATY = N4NATY                                          AR647426
     C                   EVAL      MRDSTN = N4DSTN                                          AR647426
     C                   EVAL      MR2FLD = N42FLD                                          AR647426
     C                   EVAL      MR2FLC = N42FLC                                          AR647426
      *                                                                                     AR647426
     C                   CALLB     'ME002560'                                               AR647426
     C                   PARM      *Blanks       RetCodeIn                                  AR647426
     C                   PARM      ZAPGM         CallerOut        10                        AR647426
     C                   PARM                    ActionCode                                 AR647426
     C                   PARM      'Y'           OProcesAll        1                        AR647426
     C                   PARM                    PrvRqsRcd                                  AR647426
     C                   PARM                    NewRqsRcd                                  AR647426
      *                                                                                     AR647426
     C                   IF        RetCodeIn <> *Blanks                                     AR647426
     C                   EVAL      RetCodeOut = RetCodeIn                                   AR647426
     C                   EXSR      $ExitMod                                                 AR647426
     C                   ENDIF                                                              AR647426
      *                                                                                     AR647426
      *    ----------    ------
     C     @UpdateRcd    ENDSR

      *========================================================================*
      * $UpdBalanc: Update the different closing balances and sttlmt dates     *
      *------------------------------------------------------------------------*
     C     $UpdBalanc    BEGSR
      *    ----------    ------
      ** If the "Generates MT940" indicator was changed from "N" to "Y":
      *
 B1  C                   IF        N4G940 = 'Y' AND N4G940 <> PRV_N4G940
      *
      ** -- If the related last settlement date is zero, sets up the last
      **    closing balance with the general ledger balance and the last
      **    settlement date and time with their current values
      *
 B2  C                   IF        N40LSD = 0
     C     KGLACBTL0     CHAIN     GLACBLF                            99
     C   99              CLEAR     *ALL          GLACBLF
     C                   EVAL      N40LCA = LDBL
     C                   EVAL      N40LSD = AGRDNB
     C                   TIME                    N40LST
 E2  C                   ENDIF
      *
      ** -- If there are no postings reported for MT940 in GLPOSTPD,
      **    duplicates the ones existing in CLEARPD
      *
     C                   MOVE      '940'         MsgType
     C     KGLPOSTL0     SETLL     GLPOSTD0                               99
      *
 B2  C                   IF        NOT *IN99
     C     KRSACMTL2     SETLL     APOSTPDF
     C     KRSACMTL2     READE     APOSTPDF                               99
      *
 B3  C                   DOW       NOT *IN99
     C                   EVAL      OCCY = *Blanks
     C                   EVAL      OAMT = 0
     C                   EVAL      MGNWRK = N4NWRK
     C                   EVAL      MGNATY = N4NATY
     C                   EVAL      MGDSTN = N4DSTN
     C                   EVAL      MGMTPY = '940'
     C                   EVAL      MGADI1 = *Blanks
     C                   EVAL      MGADI2 = *Blanks
     C                   EVAL      MGADI3 = *Blanks
     C                   EVAL      MGADI4 = *Blanks
     C                   EVAL      MGADI5 = *Blanks
     C                   EVAL      MGADI6 = *Blanks
     C                   EVAL      MGAERI = *Blanks
     C                   EVAL      MGPROC = 'Y'
     C                   WRITE     GLPOSTDD
     C     KRSACMTL2     READE     APOSTPDF                               99
 E3  C                   ENDDO
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF

      ** If the "Generates MT941" indicator was changed from "N" to "Y":
      *
 B1  C                   IF        N4G941 = 'Y' AND N4G941 <> PRV_N4G941
      *
      ** -- If the related last settlement date is zero, sets up the last
      **    closing balance, last settlement date and time with the
      **    corresponding values from MT940
      *
 B2  C                   IF        N41LSD = 0
     C                   EVAL      N41LCB = N40LCA
     C                   EVAL      N41LSD = N40LSD
     C                   EVAL      N41LST = N40LST
 E2  C                   ENDIF
      *
      ** -- If there are no postings reported for MT941 in GLPOSTPD,
      **    duplicates the ones of MT940 in GLPOSTPD and GLRSACPD
      *
     C                   MOVE      '941'         MsgType
     C     KGLPOSTL0     SETLL     GLPOSTD0                               99
      *
 B2  C                   IF        NOT *IN99
     C                   MOVE      '940'         MsgType
     C     KGLPOSTL0     SETLL     GLPOSTD0
     C     KGLPOSTL0     READE     GLPOSTD0                               99
      *
 B3  C                   DOW       NOT *IN99
     C                   MOVE      '941'         MGMTPY
     C                   WRITE     GLPOSTDD
     C     KGLPOSTL0     READE     GLPOSTD0                               99
 E3  C                   ENDDO
      *----
     C     KGLRSACL0     SETLL     GLRSACD0
     C     KGLRSACL0     READE     GLRSACD0                               99
      *
 B3  C                   DOW       NOT *IN99
     C                   MOVE      '941'         MGMTPY
     C                   WRITE     GLRSACDD
     C     KGLRSACL0     READE     GLRSACD0                               99
 E3  C                   ENDDO
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF

      ** If the "Generates MT942" indicator was changed from "N" to "Y":
      *
 B1  C                   IF        N4G942 = 'Y' AND N4G942 <> PRV_N4G942
      *
      ** -- If the related last settlement date is zero, sets up the last
      **    settlement date and time with the corresponding values from MT940
      *
 B2  C                   IF        N42LSD = 0
     C                   EVAL      N42LSD = N40LSD
     C                   EVAL      N42LST = N40LST
 E2  C                   ENDIF
      *
      ** -- If there are no postings reported for MT942 in GLPOSTPD,
      **    duplicates the ones of MT940 in GLPOSTPD and GLRSACPD
      *
     C                   MOVE      '942'         MsgType
     C     KGLPOSTL0     SETLL     GLPOSTD0                               99
      *
 B2  C                   IF        NOT *IN99
     C                   MOVE      '940'         MsgType
     C     KGLPOSTL0     SETLL     GLPOSTD0
     C     KGLPOSTL0     READE     GLPOSTD0                               99
      *
 B3  C                   DOW       NOT *IN99
     C                   MOVE      '942'         MGMTPY
     C                   WRITE     GLPOSTDD
     C     KGLPOSTL0     READE     GLPOSTD0                               99
 E3  C                   ENDDO
      *----
     C     KGLRSACL0     SETLL     GLRSACD0
     C     KGLRSACL0     READE     GLRSACD0                               99
      *
 B3  C                   DOW       NOT *IN99
     C                   MOVE      '942'         MGMTPY
     C                   WRITE     GLRSACDD
     C     KGLRSACL0     READE     GLRSACD0                               99
 E3  C                   ENDDO
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *    ----------    ------
     C     @UpdBalanc    ENDSR

      *========================================================================*
      * $DeleteRcd: Delete a record                                            *
      *------------------------------------------------------------------------*
     C     $DeleteRcd    BEGSR
      *    ----------    ------
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

      ** Delete the eventual linked Generation Schedules
      *
     C                   CLEAR                   PrvSchRcd
     C                   CLEAR                   NewSchRcd

     C                   EVAL      GSNWRK = N4NWRK
     C                   EVAL      GSBRCA = N4BRCA
     C                   EVAL      GSCNUM = N4CNUM
     C                   EVAL      GSCCY  = N4CCY
     C                   EVAL      GSACCD = N4ACCD
     C                   EVAL      GSACSQ = N4ACSQ
     C                   EVAL      GSNATY = N4NATY
     C                   EVAL      GSDSTN = N4DSTN

     C                   CALLB     'ME002460'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut        10
     C                   PARM                    ActionCode
     C                   PARM      'Y'           ProcessAll        1
     C                   PARM                    PrvSchRcd
     C                   PARM                    NewSchRcd
     C                   PARM                    @2FLD            15 0                        222373
     C                   PARM                    @2FLC            15 0                        222373

     C                   IF        RetCodeIn <> *Blanks
     C                   EVAL      RetCodeOut = RetCodeIn
     C                   EXSR      $ExitMod
     C                   ENDIF

      ** Logically delete the record
      *
     C                   EVAL      N4RECI = '*'
     C                   EVAL      N4LCDT = AGRDNB
     C                   EVAL      N4CHTP = 'D'
     C                   EVAL      N4USER = PSUser
     C                   UPDATE    GLNW94D0
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

      ** Retrieve RUNDAT
      *
     C                   IN        RUNDAT

      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks

      ** Access file on the specified Key
      *
     C     KGLNW94L0     CHAIN     GLNW94D0                           27
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
(c) Finastra International Limited 2002
