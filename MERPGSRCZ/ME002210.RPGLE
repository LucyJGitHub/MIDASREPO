     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network Account Desc.- Display Controller')
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002210 - Midas ME Network Account Description Maint. *
      *                   (Display Controller)                        *
      *                                                               *
      *  Function:  This module coordinates the display screens seq.  *
      *             and the update of a Network Account record.       *
      *                                                               *
      *  Function:  This module enables the user to generate MT941    *
      *             and MT942 on manual request.                      *
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
 
     FGLNWACL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNWACD0:GLNWACD1)
      ** Midas GL Network Accounts - Retrieval
      *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Action key Indicators                                         *
      *                                                               *
      * KC - Exit Program                                             *
      * KJ - Delete Record                                            *
      * KL - Previous Screen                                          *
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
 
     D PrvFilRcd     E DS                  EXTNAME(GLNWACPD) PREFIX(PRV_)
      ** Previous Network Account File Record (i.e. initial state of the record)
      *
 
     D NewFilRcd     E DS                  EXTNAME(GLNWACPD)
      ** New Network Account File Record (i.e. new state after amendments)
      *
 
      ** Declared variables
      ** ------------------
      *
 
      ** Record Key to process (entry parameter)
      *
     D KeyUsed         DS
     D  KeyNWRK                            LIKE(NANWRK)
     D  KeyBRCH                            LIKE(NABRCH)
     D  KeyCNUM                            LIKE(NACNUM)
     D  KeyCCY                             LIKE(NACCY)
     D  KeyACOD                            LIKE(NAACOD)
     D  KeyACSQ                            LIKE(NAACSQ)
     D  KeyNATY                            LIKE(NANATY)
 
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *
 
      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    CallerIn         10
     C                   PARM                    KeyUsed
     C                   PARM                    ActionCode
 
      ** Parameter list for screens display modules (Note that the
      ** return code, although being declared, isn't used for the moment)
      *
     C     PME00222x     PLIST
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    ActionCode
     C                   PARM      ZAPGM         CallerOut        10
     C     *INKC         PARM      *Off          KCIn              1
     C     *INKJ         PARM      *Off          KJIn              1
     C     *INKL         PARM      *INKL         KLIn              1
     C                   PARM                    NewFilRcd
 
 
      ** Parameter list for MT94x details maintenance browse module
      *
     C     PME002305     PLIST
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    OptionOut        10
     C                   PARM      ZAPGM         CallerOut
     C                   PARM      '1'           CommitInd         1
     C                   PARM                    NewFilRcd
 
      ** Key lists
      *
     C     KGLNWACL1     KLIST
     C                   KFLD                    KeyNWRK
     C                   KFLD                    KeyBRCH
     C                   KFLD                    KeyCNUM
     C                   KFLD                    KeyCCY
     C                   KFLD                    KeyACOD
     C                   KFLD                    KeyACSQ
     C                   KFLD                    KeyNATY
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR subroutine
 
      ** Main loop until F3 taken from any screen
      *  ========================================
 B1  C                   DOU       *INKC
 
      ** If Action Code = Delete, Message "Press F10"
      *
 B2  C                   IF        ActionCode = 'D'
     C                   MOVE      'ME00031'     ZAMSID
     C                   EXSR      $ZaSndMsg
 E2  C                   ENDIF
 
      ** -- Display screen according to the current record format number
      *     ------------------------------------------------------------
 B2  C                   SELECT
 
      ** ---- Display the key screen format
      ** N.B.: The user may have requested to reinput a previously deleted record,
      **       so we need to avoid the updater module to issue an error in Amend mode
      *
 X2  C                   WHEN      CurFormat = 1
     C                   CALLB     'ME002220'    PME00222x
 
 B3  C                   IF        ActionCode = 'A'
     C                   EVAL      PrvFilRcd = NewFilRcd
 E3  C                   ENDIF
 
      ** ---- Display the first details screen format
      *
 X2  C                   WHEN      CurFormat = 2
     C                   CALLB     'ME002221'    PME00222x
 
      ** ---- Display the second details screen format (MT94x details)
      *
 X2  C                   WHEN      CurFormat = 3
     C                   CALLB     'ME002305'    PME002305
 
 B3  C                   SELECT
 X3  C                   WHEN      RetCodeIn = '*EXIT' OR RetCodeIn = '*ERROR'
     C                   EVAL      *INKC = *On
 
 X3  C                   WHEN      RetCodeIn = '*PRV'
     C                   EVAL      *INKL = *On
 E3  C                   ENDSL
 
 E2  C                   ENDSL
 
      ** -- Action keys management
      *     ----------------------
      ** ---- F3 ==> Exit program
      *
 B2  C                   IF        *INKC
     C                   MOVEL(P)  '*EXIT'       RetCodeOut
     C                   ITER
 E2  C                   ENDIF
 
      ** ---- F10 ==> Confirm record deletion
      *
 B2  C                   IF        *INKJ
     C                   EXSR      $UpdatRcd
     C                   MOVE      RetCodeIn     RetCodeOut
     C                   LEAVE
 E2  C                   ENDIF
 
      ** ---- F12 ==> Return to the previous screen
      *
 B2  C                   IF        *INKL
 
      ** ------ If first displayed format --> Return to the caller
      *
 B3  C                   IF        DspFormat = 0
     C                   MOVEL(P)  '*PRV'        RetCodeOut
     C                   LEAVE
 
      ** ------ Otherwise return to the previous screen
      *
 X3  C                   ELSE
     C                   SUB       1             DspFormat
     C                   SUB       1             CurFormat
     C                   ITER
 E3  C                   ENDIF
 
 E2  C                   ENDIF
 
      ** -- Check if record has to be updated
      *     ---------------------------------
 
      ** ---- Update record if second record format and not Delete or Enquire
      *
 B2  C                   IF        CurFormat = 2 AND
     C                             ActionCode <> 'D' AND ActionCode <> 'E'
     C                   EXSR      $UpdatRcd
 
 B3  C                   IF        RetCodeIn <> *Blanks
     C                   ITER
 E3  C                   ENDIF
 
 E2  C                   ENDIF
 
      ** -- Display the next screen
      *     -----------------------
      **    Remark: if last format with action code <> 'D' --> End of module
      *
 B3  C                   IF        CurFormat = NbrFormat AND ActionCode <> 'D'
     C                   MOVE      *Blanks       RetCodeOut
     C                   LEAVE
 E3  C                   ENDIF
 
 B3  C                   IF        CurFormat < NbrFormat
     C                   ADD       1             CurFormat
     C                   ADD       1             DspFormat
 E3  C                   ENDIF
 
 E1  C                   ENDDO
 
      ** Exit module
      *
     C                   EXSR      $ExitMod
 
      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*
 
      *========================================================================*
      * $UpdatRcd : Update Records                                             *
      *------------------------------------------------------------------------*
     C     $UpdatRcd     BEGSR
      *    ----------    ------
      ** Call the updater
      *
     C                   CALLB     'ME002260'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut
     C                   PARM                    ActionCode
     C                   PARM                    PrvFilRcd
     C                   PARM                    NewFilRcd
 
      ** Commit eventual changes if all's right
      *
     C                   IF        RetCodeIn = *Blanks
     C                   COMMIT
     C                   ENDIF
 
      ** Always roll back
      *
     C                   ROLBK
      *    ----------    ------
     C     @UpdatRcd     ENDSR
 
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
      ** Always roll back and exit
      *
     C                   ROLBK
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
 
     C                   MOVEL(P)  'MEMSG'       ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *Blanks       ZAMSID            7
     C                   MOVEL     *Blanks       ZAMSDA          132
     C                   MOVEL     *Blanks       ZAMSTP            7
 
      ** Reset fields
      *
     C                   CLEAR                   PrvFilRcd
     C                   CLEAR                   NewFilRcd
 
      ** Set up screen format flag according to the received action code
      *
      ** -- First details format if Amend, Enquire, or Delete
      *
     C                   IF        ActionCode = 'A' OR ActionCode = 'E' OR
     C                             ActionCode = 'D'
     C                   Z-ADD     2             CurFormat         2 0
 
      ** -- Otherwise key format
      *
     C                   ELSE
     C                   Z-ADD     1             CurFormat
     C                   ENDIF
 
      ** Set up the number of the last format to process
      ** N.B.: For Deletion, the processing doesn't go thru the MT940x
      **       Details Maintenance (i.e. no call to ME002305)
      *
     C                   IF        ActionCode = 'D'
     C                   Z-ADD     2             NbrFormat         2 0
     C                   ELSE
     C                   Z-ADD     3             NbrFormat
     C                   ENDIF
 
      ** Set up the count of displayed formats since the first
      ** This field will be mainly used for F12 management
      *
     C                   Z-ADD     0             DspFormat         2 0
 
      ** If not Insert, check if record exists
      *
 B1  C                   IF        ActionCode <> 'I'
     C     KGLNWACL1     CHAIN     GLNWACD1                           99
 
      ** -- Record not found --> Error
      *
 B2  C                   IF        *IN99
     C                   MOVE      'ME00032'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   EXSR      $ExitMod
 
      ** -- Check if record is live
      *
 X2  C                   ELSE
 
      ** ---- If record deleted and not Enquire --> Error
      *
 B3  C                   IF        NARECI = '*' AND ActionCode <> 'E'
     C                   MOVE      'ME00033'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   EXSR      $ExitMod
 
      ** ---- Save the current value of the record
      *
 X3  C                   ELSE
     C                   MOVE      NewFilRcd     PrvFilRcd
 E3  C                   ENDIF
 
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
      ** Prepare the processing mode for ME002305 (MT94x Details Maintenance)
      *
     C                   IF        ActionCode = 'E'
     C                   EVAL      OptionOut = '*DSPLY'
     C                   ELSE
     C                   EVAL      OptionOut = '*MAINT'
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
(c) Finastra International Limited 2002
