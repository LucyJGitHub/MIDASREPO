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
      *  Last Amend No. BA6026             Date 18Jan23               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
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
      *  BA6026 - Structuring Current MT940 and SEPA Compliance.      *
      *           Include GSH026.                                     *
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
     FA6NW94L0  IF   E           K DISK    INFSR(*PSSR)                                      BA6026
     F                                     RENAME(A6NW94D0:A6NW94D2)                         BA6026
      ** Midas GL Network Accounts - MT94x Extension File (Rtv)                              BA6026
      *                                                                                      BA6026
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
                                                                                             BA6026
     D PrvFilRcd2    E DS                  EXTNAME(A6NW94PD) PREFIX(PR2_)                    BA6026
      ** Previous Network Account MT94x Details - Extension File                             BA6026
      *                                                                                      BA6026
     D NewFilRcd2    E DS                  EXTNAME(A6NW94PD)                                 BA6026
      ** New Network Account MT94x Details - Extension File                                  BA6026
      *                                                                                      BA6026
     D DSFDY         E DS                  EXTNAME(DSFDY)                                    BA6026
      ** First DS for Access Programs, Short Data Structure                                  BA6026
      *                                                                                      BA6026
     D DSLDY         E DS                  EXTNAME(DSLDY)                                    BA6026
      ** DS (longest) used as output parameter for Access Objects                            BA6026
      *                                                                                      BA6026
     D DsNWRK        E DS                  EXTNAME(SDNWRKPD)                                 BA6026
      ** Network details record format data structure                                        BA6026
      *                                                                                      BA6026

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
      *                                                                                      BA6026
      ** Parameters for ME002322 where extension file is added.                              BA6026
      *                                                                                      BA6026
     C     PME00232x1    PLIST                                                               BA6026
     C                   PARM      *Blanks       RetCodeIn                                   BA6026
     C                   PARM                    ActionCode                                  BA6026
     C                   PARM      ZAPGM         CallerOut        10                         BA6026
     C     *INKC         PARM      *Off          KCIn              1                         BA6026
     C     *INKJ         PARM      *Off          KJIn              1                         BA6026
     C     *INKL         PARM      *INKL         KLIn              1                         BA6026
     C                   PARM                    NewFilRcd                                   BA6026
     C                   PARM                    NewFilRcd2                                  BA6026
      *                                                                                      BA6026
     C     KA6NW94L0     KLIST                                                               BA6026
     C                   KFLD                    N4NWRK                                      BA6026
     C                   KFLD                    N4BRCA                                      BA6026
     C                   KFLD                    N4CNUM                                      BA6026
     C                   KFLD                    N4CCY                                       BA6026
     C                   KFLD                    N4ACCD                                      BA6026
     C                   KFLD                    N4ACSQ                                      BA6026
     C                   KFLD                    N4NATY                                      BA6026
     C                   KFLD                    N4DSTN                                      BA6026

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
     C                   If        BA6026 = 'Y' And EDPROT = '*SWIFT' And                     BA6026
     C                             N4G940 = 'Y'                                               BA6026
     C                   Eval      PrvFilRcd2 = NewFilRcd2                                    BA6026
     C                   EndIf                                                                BA6026
 E3  C                   ENDIF

      ** ---- Display the first details screen format (Destination)
      *
 X2  C                   WHEN      CurFormat = 2
     C                   CALLB     'ME002321'    PME00232x
     C                   If        BA6026 = 'Y' And EDPROT = '*SWIFT' And                     BA6026
     C                             N4G940 = 'Y'                                               BA6026
     C                   If        ActionCode = 'D' And *INKJ = '1'                           BA6026
     C     KA6NW94L0     Chain     A6NW94D2                           98                      BA6026
     C                   If        *IN98 = *Off                                               BA6026
     C                   Eval      PR2_G4RECI = N4RECI                                        BA6026
     C                   Eval      PR2_G4NWRK = N4NWRK                                        BA6026
     C                   Eval      PR2_G4BRCA = N4BRCA                                        BA6026
     C                   Eval      PR2_G4CNUM = N4CNUM                                        BA6026
     C                   Eval      PR2_G4CCY  = N4CCY                                         BA6026
     C                   Eval      PR2_G4ACCD = N4ACCD                                        BA6026
     C                   Eval      PR2_G4ACSQ = N4ACSQ                                        BA6026
     C                   Eval      PR2_G4NATY = N4NATY                                        BA6026
     C                   Eval      PR2_G4DSTN = N4DSTN                                        BA6026
     C                   Eval      PR2_G4SF86 = G4SF86                                        BA6026
     C                   EndIf                                                                BA6026
     C                   EndIf                                                                BA6026
     C                   EndIf                                                                BA6026

      ** ---- Display the second details screen format (MT940)
      *
 X2  C                   WHEN      CurFormat = 3
     C*****              CALLB     'ME002322'    PME00232x                                    BA6026
     C                   If        BA6026 = 'Y' And EDPROT = '*SWIFT' And                     BA6026
     C                             N4G940 = 'Y'                                               BA6026
     C                   If        ActionCode = 'E' Or ActionCode = 'A'                       BA6026
     C     KA6NW94L0     Chain     A6NW94D2                           98                      BA6026
     C                   If        *IN98 = *OFF                                               BA6026
     C                   Eval      PR2_G4RECI = N4RECI                                        BA6026
     C                   Eval      PR2_G4NWRK = N4NWRK                                        BA6026
     C                   Eval      PR2_G4BRCA = N4BRCA                                        BA6026
     C                   Eval      PR2_G4CNUM = N4CNUM                                        BA6026
     C                   Eval      PR2_G4CCY  = N4CCY                                         BA6026
     C                   Eval      PR2_G4ACCD = N4ACCD                                        BA6026
     C                   Eval      PR2_G4ACSQ = N4ACSQ                                        BA6026
     C                   Eval      PR2_G4NATY = N4NATY                                        BA6026
     C                   Eval      PR2_G4DSTN = N4DSTN                                        BA6026
     C                   Eval      PR2_G4SF86 = G4SF86                                        BA6026
     C                   EndIf                                                                BA6026
     C                   Else                                                                 BA6026
     C                   If        ActionCode = 'I'                                           BA6026
     C                   Eval      G4DSTN = N4DSTN                                            BA6026
     C                   EndIf                                                                BA6026
     C                   EndIf                                                                BA6026
     C                   EndIf                                                                BA6026
      *                                                                                       BA6026
     C                   CallB     'ME002322'    PME00232x1                                   BA6026

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
     C                   PARM                    PrvFilRcd2                                   BA6026
     C                   PARM                    NewFilRcd2                                   BA6026
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
      *                                                                                       BA6026
      ** Access SAR file to determine if BA6026 is installed.                                 BA6026
      *                                                                                       BA6026
     C                   Call      'AOSARDR0'                                                 BA6026
     C                   Parm      *BLANKS       WRTCD             7                          BA6026
     C                   Parm      '*VERIFY'     WOPTN             7                          BA6026
     C                   Parm      'BA6026'      WSARD             6                          BA6026
     C                   Parm                    DSFDY                                        BA6026
      *                                                                                       BA6026
     C                   Select                                                               BA6026
     C                   When      WRTCD=*BLANKS                                              BA6026
     C                   Move      'Y'           BA6026            1                          BA6026
      *                                                                                       BA6026
     C                   When      WRTCD='*NRF   '                                            BA6026
     C                   Move      'N'           BA6026                                       BA6026
      *                                                                                       BA6026
     C                   Other                                                                BA6026
     C                   Eval      DBKEY =  WOPTN                                             BA6026
     C                   Eval      DBFILE = 'SCSARDPD'                                        BA6026
     C                   Eval      DBASE =  001                                               BA6026
     C                   Exsr      *PSSR                                                      BA6026
     C                   EndSl                                                                BA6026
      *                                                                                       BA6026
     C                   If        BA6026 = 'Y'                                               BA6026
     C                   Clear                   PrvFilRcd2                                   BA6026
     C                   Clear                   NewFilRcd2                                   BA6026
     C                   EndIf                                                                BA6026
      *                                                                                       BA6026
      ** Retrieve the associated network record                                               BA6026
      *                                                                                       BA6026
     C                   CallB     'AONWRKR1'                                                 BA6026
     C                   Parm      *Blanks       WRTCD                                        BA6026
     C                   Parm      '*KEY'        WOPTN                                        BA6026
     C                   Parm      KEYNWRK       @NWRK             6                          BA6026
     C     DsNWRK        Parm                    DSLDY                                        BA6026
      *                                                                                       BA6026
     C                   If        WRTCD <> *Blanks                                           BA6026
     C                   Eval      DBKEY =  WOPTN                                             BA6026
     C                   Eval      DBFILE = 'SCSARDPD'                                        BA6026
     C                   Eval      DBASE =  002                                               BA6026
     C                   Exsr      *PSSR                                                      BA6026
     C                   Endif                                                                BA6026
                                                                                              BA6026
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
     C                   If        BA6026 = 'Y' And EDPROT = '*SWIFT' And                     BA6026
     C                             N4G940 = 'Y'                                               BA6026
     C                   Move      NewFilRcd2    PrvFilRcd2                                   BA6026
     C                   EndIf                                                                BA6026
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
      *                                                                             BA6026 MD062357
     C**********         If        BA6026 = 'Y' And EDPROT = '*SWIFT'               BA6026 MD062357
     C**********         Eval      G4NWRK = KeyNWRK                                 BA6026 MD062357
     C**********         Eval      G4BRCA = KeyBRCA                                 BA6026 MD062357
     C**********         Eval      G4CNUM = KeyCNUM                                 BA6026 MD062357
     C**********         Eval      G4CCY  = KeyCCY                                  BA6026 MD062357
     C**********         Eval      G4ACCD = KeyACCD                                 BA6026 MD062357
     C**********         Eval      G4ACSQ = KeyACSQ                                 BA6026 MD062357
     C**********         Eval      G4NATY = KeyNATY                                 BA6026 MD062357
     C**********         Eval      G4DSTN = KeyDSTN                                 BA6026 MD062357
 E1  C**********         EndIf                                                      BA6026 MD062357

 E1  C                   ENDIF

      ** Prepare the action code used by the rest of the processing
      *
     C                   EVAL      ActionCode = %Subst(ActionCod2:1:1)
      *                                                                                    MD062357
      ** Save the extension fields during Insert or Amend                                  MD062357
      *                                                                                    MD062357
     C                   IF        BA6026 = 'Y' And EDPROT = '*SWIFT'                      MD062357
     C                             AND (ActionCode = 'I' OR                                MD062357
     C                                  ActionCode = 'A')                                  MD062357
     C                   EVAL      G4NWRK = KeyNWRK                                        MD062357
     C                   EVAL      G4BRCA = KeyBRCA                                        MD062357
     C                   EVAL      G4CNUM = KeyCNUM                                        MD062357
     C                   EVAL      G4CCY  = KeyCCY                                         MD062357
     C                   EVAL      G4ACCD = KeyACCD                                        MD062357
     C                   EVAL      G4ACSQ = KeyACSQ                                        MD062357
     C                   EVAL      G4NATY = KeyNATY                                        MD062357
     C                   EVAL      G4DSTN = KeyDSTN                                        MD062357
     C                   ENDIF                                                             MD062357
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
