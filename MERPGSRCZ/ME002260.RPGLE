     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network Account Desc.- Database Update')
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002260 - Midas ME Network Account Description Maint. *
      *                   (Database Update)                           *
      *                                                               *
      *  Function:  This module updates the files related to a Netwrk *
      *             Account Description.                              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
 
     FGLNWACL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas GL Network Accounts - Update
      *
 
     FGLACBTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account Balances Today
      *
 
      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Database Access Indicators                                             *
      *                                                                        *
      * 27 - Access GLNWACL0                                                   *
      *                                                                        *
      * Database Error Indicators                                              *
      *                                                                        *
      * U7 - Abnormal Completion                                               *
      * U8 - File Out of Balance                                               *
      * U7 + U8 - Database Error                                               *
      *                                                                        *
      * Other Indicators                                                       *
      *                                                                        *
      * 99 - Multi-purpose                                                     *
      *                                                                        *
      *========================================================================*
 
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
 
     D CurFilRcd     E DS                  EXTNAME(GLNWACPD)
      ** Current Network File Record (i.e. state of the record when entering this module)
      *
 
     D PrvFilRcd     E DS                  EXTNAME(GLNWACPD) PREFIX(PRV_)
      ** Previous Network File Record (i.e. initial state of the record)
      *
 
     D NewFilRcd     E DS                  EXTNAME(GLNWACPD) PREFIX(NEW_)
      ** New Network File Record (i.e. new state after amendments)
      *
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *
 
      ** Declared variables
      ** ------------------
      *
 
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
     C     KGLNWACL0     KLIST
     C                   KFLD                    NEW_NANWRK
     C                   KFLD                    NEW_NABRCH
     C                   KFLD                    NEW_NACNUM
     C                   KFLD                    NEW_NACCY
     C                   KFLD                    NEW_NAACOD
     C                   KFLD                    NEW_NAACSQ
     C                   KFLD                    NEW_NANATY
 
     C     KGLACBTL0     KLIST
     C                   KFLD                    NACNUM
     C                   KFLD                    NACCY
     C                   KFLD                    NAACOD
     C                   KFLD                    NAACSQ
     C                   KFLD                    NABRCH
 
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
     C                   EVAL      NARECI = 'D'
     C                   EVAL      NALCDT = AGRDNB
     C                   EVAL      NACHTP = 'I'
     C                   EVAL      NAUSER = PSUser
     C                   WRITE     GLNWACD0
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
     C                   EVAL      NARECI = 'D'
     C                   EVAL      NALCDT = AGRDNB
     C                   EVAL      NACHTP = 'A'
     C                   EVAL      NAUSER = PSUser
     C                   UPDATE    GLNWACD0
      *    ----------    ------
     C     @UpdateRcd    ENDSR
 
      *========================================================================*
      * $UpdBalanc: Update the MT950 closing balance and last sttlmt date      *
      *------------------------------------------------------------------------*
     C     $UpdBalanc    BEGSR
      *    ----------    ------
      ** If the "Generates MT950" indicator was changed from "N" to "Y" and the
      ** related last settlement date is zero, sets up the last closing balance
      ** with the general ledger balance and the last settlement date and time
      ** with their current values
      *
     C                   IF        NAG950 = 'Y' AND NAG950 <> PRV_NAG950 AND
     C                             NA5LSD = 0
     C     KGLACBTL0     CHAIN     GLACBLF                            99
     C   99              CLEAR     *ALL          GLACBLF
     C                   EVAL      NA5LCB = LDBL
     C                   EVAL      NA5LSD = AGRDNB
     C                   TIME                    NA5LST
     C                   ENDIF
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
 
      ** Logically delete the record
      *
     C                   EVAL      NARECI = '*'
     C                   EVAL      NALCDT = AGRDNB
     C                   EVAL      NACHTP = 'D'
     C                   EVAL      NAUSER = PSUser
     C                   UPDATE    GLNWACD0
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
     C     KGLNWACL0     CHAIN     GLNWACD0                           27
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
