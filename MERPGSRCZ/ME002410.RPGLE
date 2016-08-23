     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME MT941/2 Generation Schedules-Dspl Ctrl')
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002410 - Midas ME Generation Schedules Description   *
      *                   Maintenance (Display Controller)            *
      *                                                               *
      *  Function:  This module coordinates the display screens seq.  *
      *             and the update of a Generation Schedule record.   *
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
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
 
     FGLGS94L1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLGS94D0:GLGS94D1)
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
 
     D PrvFilRcd     E DS                  EXTNAME(GLGS94PD) PREFIX(PRV_)
      ** Previous Generation Schedule File Record (i.e. initial state of the record)
      *
 
     D NewFilRcd     E DS                  EXTNAME(GLGS94PD)
      ** New Generation Schedule File Record (i.e. new state after amendments)
      *
 
      ** Declared variables
      ** ------------------
      *
 
      ** Record Key to process (entry parameter)
      *
     D KeyUsed         DS
     D  KeyNWRK                            LIKE(GSNWRK)
     D  KeyBRCA                            LIKE(GSBRCA)
     D  KeyCNUM                            LIKE(GSCNUM)
     D  KeyCCY                             LIKE(GSCCY)
     D  KeyACCD                            LIKE(GSACCD)
     D  KeyACSQ                            LIKE(GSACSQ)
     D  KeyNATY                            LIKE(GSNATY)
     D  KeyDSTN                            LIKE(GSDSTN)
     D  KeyMTPY                            LIKE(GSMTPY)
     D  KeySDTE                            LIKE(GSSDTE)
     D  KeySTIM                            LIKE(GSSTIM)
 
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
     C                   PARM                    CommitInd         1
     C                   PARM                    @2FLD            15 0
     C                   PARM                    @2FLC            15 0
 
      ** Parameter list for screens display modules (Note that the
      ** return code, although being declared, isn't used for the moment)
      *
     C     PME00242x     PLIST
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    ActionCode
     C                   PARM      ZAPGM         CallerOut        10
     C     *INKC         PARM      *Off          KCIn              1
     C     *INKJ         PARM      *Off          KJIn              1
     C     *INKL         PARM      *INKL         KLIn              1
     C                   PARM                    NewFilRcd
 
      ** Key lists
      *
     C     KGLGS94L1     KLIST
     C                   KFLD                    KeyNWRK
     C                   KFLD                    KeyBRCA
     C                   KFLD                    KeyCNUM
     C                   KFLD                    KeyCCY
     C                   KFLD                    KeyACCD
     C                   KFLD                    KeyACSQ
     C                   KFLD                    KeyNATY
     C                   KFLD                    KeyDSTN
     C                   KFLD                    KeyMTPY
     C                   KFLD                    KeySDTE
     C                   KFLD                    KeySTIM
 
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
      *
 B2  C                   SELECT
 
      ** ---- Display the key/details screen format
      *
 X2  C                   WHEN      CurFormat = 1
     C                   CALLB     'ME002420'    PME00242x
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
 
      ** ---- Update record if last record format and not Delete
      *
 B2  C                   IF        CurFormat = NbrFormat  AND
     C                             ActionCode <> 'D'
     C                   EXSR      $UpdatRcd
     C                   MOVE      RetCodeIn     RetCodeOut
     C                   LEAVE
 
      ** ---- If no need to update yet, display the next screen
      *
 X2  C                   ELSE
 
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
     C                   CALLB     'ME002460'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut
     C                   PARM                    ActionCode
     C                   PARM      'N'           ProcessAll        1
     C                   PARM                    PrvFilRcd
     C                   PARM                    NewFilRcd
     C                   PARM                    @2FLD
     C                   PARM                    @2FLC
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
     C                             RetCodeOut = *Blanks
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
      ** -- Only one format is used
      ** -- (the module can be called only for Insert and Delete)
      *
     C                   Z-ADD     1             CurFormat         2 0
 
      ** Set up the number of the last format to process before amending the file record
      *
     C                   Z-ADD     1             NbrFormat         2 0
 
      ** Set up the count of displayed formats since the first
      ** This field will be mainly used for F12 management
      *
     C                   Z-ADD     0             DspFormat         2 0
 
      ** If not Insert, check if the record exists
      *
 B1  C                   IF        ActionCode <> 'I'
     C     KGLGS94L1     CHAIN     GLGS94D1                           99
 
      ** -- Record not found --> Error
      *
 B2  C                   IF        *IN99
     C                   MOVE      'ME00032'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   EXSR      $ExitMod
 X2  C                   ELSE
 
      ** ---- Save the current value of the record
      *
     C                   MOVE      NewFilRcd     PrvFilRcd
 E2  C                   ENDIF
 
      ** If Insert, sets up the fixed part of the record key
      ** (Network Account MT94x Details reference and Message Type)
      *
 X1  C                   ELSE
     C                   EVAL      GSNWRK = KeyNWRK
     C                   EVAL      GSBRCA = KeyBRCA
     C                   EVAL      GSCNUM = KeyCNUM
     C                   EVAL      GSCCY  = KeyCCY
     C                   EVAL      GSACCD = KeyACCD
     C                   EVAL      GSACSQ = KeyACSQ
     C                   EVAL      GSNATY = KeyNATY
     C                   EVAL      GSDSTN = KeyDSTN
     C                   EVAL      GSMTPY = KeyMTPY
 E1  C                   ENDIF
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
