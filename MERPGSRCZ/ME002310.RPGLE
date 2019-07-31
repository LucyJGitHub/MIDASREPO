     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network A/c MT94x Dtl Desc.- Dspl Ctrl')      *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002310 - Midas ME Network Account MT94x Details      *
      *                   Description Maintenance (Display Control)   *
      *                                                               *
      *  Function:  This module coordinates the display screens seq.  *
      *             and the update of a Network Account MT94x Details *
      *             record.                                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
 
     FGLNW94L1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D1)
      ** Midas GL Network Accounts - MT94x - Retrieval
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
 
     D PrvFilRcd     E DS                  EXTNAME(GLNW94PD) PREFIX(PRV_)
      ** Previous Network Account MT94x Details File Record (i.e. initial state of the record)
      *
 
     D NewFilRcd     E DS                  EXTNAME(GLNW94PD)
      ** New Network Account MT94x Details File Record (i.e. new state after amendments)
      *
 
      ** Declared variables
      ** ------------------
      *
 
      ** Record Key to process (entry parameter)
      *
     D KeyUsed         DS
     D  KeyNWRK                            LIKE(N4NWRK)
     D  KeyBRCA                            LIKE(N4BRCA)
     D  KeyCNUM                            LIKE(N4CNUM)
     D  KeyCCY                             LIKE(N4CCY)
     D  KeyACCD                            LIKE(N4ACCD)
     D  KeyACSQ                            LIKE(N4ACSQ)
     D  KeyNATY                            LIKE(N4NATY)
     D  KeyDSTN                            LIKE(N4DSTN)
 
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
     C                   PARM                    ActionCod2        2
     C                   PARM                    CommitInd         1
 
      ** Parameter list for screens display modules (Note that the
      ** return code, although being declared, isn't used for the moment)
      *
     C     PME00232x     PLIST
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    ActionCode
     C                   PARM      ZAPGM         CallerOut        10
     C     *INKC         PARM      *Off          KCIn              1
     C     *INKJ         PARM      *Off          KJIn              1
     C     *INKL         PARM      *INKL         KLIn              1
     C                   PARM                    NewFilRcd
 
      ** Key lists
      *
     C     KGLNW94L1     KLIST
     C                   KFLD                    KeyNWRK
     C                   KFLD                    KeyBRCA
     C                   KFLD                    KeyCNUM
     C                   KFLD                    KeyCCY
     C                   KFLD                    KeyACCD
     C                   KFLD                    KeyACSQ
     C                   KFLD                    KeyNATY
     C                   KFLD                    KeyDSTN
 
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
     C                   CALLB     'ME002320'    PME00232x
 
 B3  C                   IF        ActionCode = 'A'
     C                   EVAL      PrvFilRcd = NewFilRcd
 E3  C                   ENDIF
 
      ** ---- Display the first details screen format (Destination)
      *
 X2  C                   WHEN      CurFormat = 2
     C                   CALLB     'ME002321'    PME00232x
 
      ** ---- Display the second details screen format (MT940)
      *
 X2  C                   WHEN      CurFormat = 3
     C                   CALLB     'ME002322'    PME00232x
 
      ** ---- Display the third details screen format (MT941/1)
      *
 X2  C                   WHEN      CurFormat = 4
     C                   CALLB     'ME002323'    PME00232x
 
      ** ---- Display the fourth details screen format (MT941/2)
      *
 X2  C                   WHEN      CurFormat = 5
     C                   CALLB     'ME002324'    PME00232x
 
      ** ---- Display the fifth details screen format (MT942/1)
      *
 X2  C                   WHEN      CurFormat = 6
     C                   CALLB     'ME002325'    PME00232x
 
      ** ---- Display the sixth details screen format (MT942/2)
      *
 X2  C                   WHEN      CurFormat = 7
     C                   CALLB     'ME002326'    PME00232x
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
 
      ** ---- Update record if last record format and not Delete or Enquire
      *
 B2  C                   IF        CurFormat = NbrFormat  AND
     C                             ActionCode <> 'D' AND ActionCode <> 'E'
     C                   EXSR      $UpdatRcd
     C                   MOVE      RetCodeIn     RetCodeOut
     C                   LEAVE
 
      ** ---- If no need to update yet, display the next screen
      **      Remark: if last format with Enquire action code --> End of module
      *
 X2  C                   ELSE
 
 B3  C                   IF        CurFormat = NbrFormat AND ActionCode = 'E'
     C                   MOVE      *Blanks       RetCodeOut
     C                   LEAVE
 E3  C                   ENDIF
 
 B3  C                   IF        CurFormat < NbrFormat
     C                   ADD       1             CurFormat
     C                   ADD       1             DspFormat
 E3  C                   ENDIF
 
 E2  C                   ENDIF
 
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
     C                   CALLB     'ME002360'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut
     C                   PARM                    ActionCode
     C                   PARM                    PrvFilRcd
     C                   PARM                    NewFilRcd
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
      ** Commit eventual changes if allowed by the caller and all's right
      *
     C                   IF        CommitInd = '1' AND
     C                             RetCodeOut = *Blanks AND ActionCode <> 'E'
     C                   COMMIT
     C                   ENDIF
 
      ** Roll back if allowed by the caller, and exit
      *
     C                   IF        CommitInd = '1'
     C                   ROLBK
     C                   ENDIF
 
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
      ** -- Key format if Insert
      *
 B1  C                   IF        %Subst(ActionCod2:1:1) = 'I'
     C                   Z-ADD     1             CurFormat         2 0
 
      ** -- Otherwise required format depending on the action code
      *
 X1  C                   ELSE
     C                   Z-ADD     2             CurFormat
 
 B2  C                   SELECT
 X2  C                   WHEN      %Subst(ActionCod2:2:1) = '0'
     C                   Z-ADD     3             CurFormat
 
 X2  C                   WHEN      %Subst(ActionCod2:2:1) = '1'
     C                   Z-ADD     4             CurFormat
 
 X2  C                   WHEN      %Subst(ActionCod2:2:1) = '2'
     C                   Z-ADD     6             CurFormat
 E2  C                   ENDSL
 
 E1  C                   ENDIF
 
      ** Set up the number of the last format to process before amending the file record
      *
     C                   Z-ADD     7             NbrFormat         2 0
 
 B1  C                   SELECT
 X1  C                   WHEN      %Subst(ActionCod2:2:1) = '0'
     C                   Z-ADD     3             NbrFormat
 
 X1  C                   WHEN      %Subst(ActionCod2:2:1) = '1'
     C                   Z-ADD     5             NbrFormat
 E1  C                   ENDSL
 
      ** Set up the count of displayed formats since the first
      ** This field will be mainly used for F12 management
      *
     C                   Z-ADD     0             DspFormat         2 0
 
      ** If not Insert, check if the record exists
      *
 B1  C                   IF        %Subst(ActionCod2:1:1) <> 'I'
     C     KGLNW94L1     CHAIN     GLNW94D1                           99
 
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
 B3  C                   IF        N4RECI = '*' AND
     C                             %Subst(ActionCod2:1:1) <> 'E'
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
 
      ** If Insert, sets up the fixed part of the record key (Network Account reference)
      *
 X1  C                   ELSE
     C                   EVAL      N4NWRK = KeyNWRK
     C                   EVAL      N4BRCA = KeyBRCA
     C                   EVAL      N4CNUM = KeyCNUM
     C                   EVAL      N4CCY  = KeyCCY
     C                   EVAL      N4ACCD = KeyACCD
     C                   EVAL      N4ACSQ = KeyACSQ
     C                   EVAL      N4NATY = KeyNATY
 
 E1  C                   ENDIF
 
      ** Prepare the action code used by the rest of the processing
      *
     C                   EVAL      ActionCode = %Subst(ActionCod2:1:1)
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
