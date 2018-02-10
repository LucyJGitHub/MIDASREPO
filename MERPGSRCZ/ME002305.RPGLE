     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network A/c MT94x Dtl Desc.- Browse')         *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002305 - Midas ME Network Account MT94x Details      *
      *                   Description Maintenance (Browse)            *
      *                                                               *
      *  Function:  This module manages a subfile that allows to work *
      *             with the Network Account MT94x Details            *
      *             descriptions.                                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
 
     FGLNW94L1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D1)
      ** Midas GL Network Accounts - MT94x - Retrieval
      *
 
     FGLGS94L1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLGS94D0:GLGS94D1)
      ** Midas GL MT941/942 Generation Schedules - Retrieve
      *
 
     FGLMR94L2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLMR94D0:GLMR94D2)
      ** Midas GL MT941/942 Messages Requests - "SUBMITTED"
      *
 
     FGLMR94L3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLMR94D0:GLMR94D3)
      ** Midas GL MT941/942 Messages Requests - "WAITING"
      *
 
     FME002305DFCF   E             WORKSTN SFILE(ME002305S0:S0RRN)
      ** Midas ME Network Account MT94x Details Browse Display
      *
 
      *========================================================================*
      * Use of Indicators                                                      *
      *                                                                        *
      * Display Conditioning Indicators                                        *
      *                                                                        *
      * 01 - Display Insert                                                    *
      * 02 - Display Amend                                                     *
      * 03 - Display Enquire                                                   *
      * 04 - Display Delete                                                    *
      * 05 - Display MT940 Details (Action Code)                               *
      * 06 - Display MT941 Details (Action Code)                               *
      * 07 - Display MT942 Details (Action Code)                               *
      * 08 - Display .......... (Future Use)                                   *
      * 09 - Display .......... (Future Use)                                   *
      * 10 - Display .......... (Future Use)                                   *
      * 11 - Reserved for future use (display Select)                          *
      * 12 - Display and allow F12                                             *
      * 13 - Display the warning mention '**DELETED**'                         *
      *                                                                        *
      * Action key Indicators                                                  *
      *                                                                        *
      * KC - Exit Program                                                      *
      * KE - Refresh Screen                                                    *
      * KI - Insert Mode                                                       *
      * KL - Previous Screen                                                   *
      *                                                                        *
      * Error Indicators                                                       *
      *                                                                        *
      * 40 - General Error Indicator                                           *
      * 41 - Error On Action Code                                              *
      * (The DS IN40_TO_70 is used to cover the whole set of reserved error    *
      *  indicators)                                                           *
      *                                                                        *
      * Subfile Management Indicators                                          *
      *                                                                        *
      * 21 - SFLDSPCTL if *ON / SFLCLR if *OFF                                 *
      * 22 - SFLDSP                                                            *
      * 23 - SFLEND                                                            *
      * 24 - SFLNXTCHG                                                         *
      * 25 - Rollup                                                            *
      *                                                                        *
      * Database Access Indicators                                             *
      *                                                                        *
      * 27 - Access GLNW94L1                                                   *
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
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *
 
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)
      ** User Informations DS
      *
 
     D DsNWAC        E DS                  EXTNAME(GLNWACPD)
      ** Network Account record format data structure
      *
 
     D DsNWRK        E DS                  EXTNAME(SDNWRKPD)
      ** Network details record format data structure
      *
 
     D DsACCNT       E DS                  EXTNAME(ACCNTAB) PREFIX(AC_)
      ** Account details record format data structure
      *
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects
      *
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** DS (longest) used as output parameter for Access Objects
      *
 
     D DummyNW94     E DS                  EXTNAME(GLNW94PD)
      ** Dummy DS to oblige zoned numeric fields to be taken as they are
      ** by the compiler (otherwise they are considered as packed numeric)
      *
 
      ** Current selection
      *
     D CurSelect       DS
     D  CurDSTN                            LIKE(C0DSTN)
     D  CurDSTD                            LIKE(C0DSTD)
     D  CurG940                            LIKE(C0G940)
     D  CurG941                            LIKE(C0G941)
     D  CurG942                            LIKE(C0G942)
 
      ** Displayed selection
      *
     D ScrSelect       DS
     D  C0DSTN
     D  C0DSTD
     D  C0G940
     D  C0G941
     D  C0G942
 
      ** Effective Selection
      *
     D EffSelect       DS
     D  EffDSTD                            LIKE(C0DSTD)
     D  EffG940                            LIKE(C0G940)
     D  EffG941                            LIKE(C0G941)
     D  EffG942                            LIKE(C0G942)
 
      ** Really used key
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
 
      ** Position key
      *
     D KeyPos          DS
     D  KeyPosNWRK                         LIKE(N4NWRK)
     D  KeyPosBRCA                         LIKE(N4BRCA)
     D  KeyPosCNUM                         LIKE(N4CNUM)
     D  KeyPosCCY                          LIKE(N4CCY)
     D  KeyPosACCD                         LIKE(N4ACCD)
     D  KeyPosACSQ                         LIKE(N4ACSQ)
     D  KeyPosNATY                         LIKE(N4NATY)
     D  KeyPosDSTN                         LIKE(N4DSTN)
 
      ** Saved key
      *
     D KeySav          DS
     D  KeySavNWRK                         LIKE(N4NWRK)
     D  KeySavBRCA                         LIKE(N4BRCA)
     D  KeySavCNUM                         LIKE(N4CNUM)
     D  KeySavCCY                          LIKE(N4CCY)
     D  KeySavACCD                         LIKE(N4ACCD)
     D  KeySavACSQ                         LIKE(N4ACSQ)
     D  KeySavNATY                         LIKE(N4NATY)
     D  KeySavDSTN                         LIKE(N4DSTN)
 
      ** Declared variables
      ** ------------------
      *
 
      ** Valid action codes for current user
      *
     D ValActCd        S              1    DIM(11)
 
      ** Error indicators array
      *
     D IN40_TO_70      S              1    DIM(31)
 
      ** Number of destinations existing for the current network account
      *
     D DestNbr         S              5  0
 
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *
 
      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    OptionIn         10
     C                   PARM                    CallerIn         10
     C                   PARM                    CommitInd         1
     C                   PARM                    DsNWAC
 
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
 
     C     KGLNW94L1P    KLIST
     C                   KFLD                    KeyNWRK
     C                   KFLD                    KeyBRCA
     C                   KFLD                    KeyCNUM
     C                   KFLD                    KeyCCY
     C                   KFLD                    KeyACCD
     C                   KFLD                    KeyACSQ
     C                   KFLD                    KeyNATY
 
     C     KGLGS94L1     KLIST
     C                   KFLD                    KeyNWRK
     C                   KFLD                    KeyBRCA
     C                   KFLD                    KeyCNUM
     C                   KFLD                    KeyCCY
     C                   KFLD                    KeyACCD
     C                   KFLD                    KeyACSQ
     C                   KFLD                    KeyNATY
     C                   KFLD                    S0DSTN
 
     C     KGLMR94Lx     KLIST
     C                   KFLD                    KeyNWRK
     C                   KFLD                    KeyBRCA
     C                   KFLD                    KeyCNUM
     C                   KFLD                    KeyCCY
     C                   KFLD                    KeyACCD
     C                   KFLD                    KeyACSQ
     C                   KFLD                    KeyNATY
     C                   KFLD                    S0DSTN
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR SR
 
      ** Initialize the subfile
      *
     C                   EXSR      $IniSubFil
 
      ** Load the subfile
      *
     C                   EXSR      $LoadSubfl
 
      ** Main loop (based on F3 and F12 indicators)
      *  ------------------------------------------
     C                   DOW       NOT *INKC AND NOT *INKL
 
      ** -- Informational message if the subfile is empty
      *
     C  N22              MOVE      'ME00001'     ZAMSID
     C  N22              EXSR      $ZaSndMsg
 
      ** -- Display the screen (header, error messages, key fields and subfile)
      *
     C                   WRITE     ME002305H0
     C                   WRITE     #MSGCTL
     C                   WRITE     ME002305F0
     C                   EXFMT     ME002305C0
 
      ** -- Clear the error messages subfile
      *
     C                   EXSR      $ClrErrSF
 
      ** -- Action keys management
      *     ----------------------
      ** ---- F3 ==> Exit Module
      *
     C                   IF        *INKC
     C                   MOVEL (P) '*EXIT'       RetCodeOut
     C                   ITER
     C                   ENDIF
 
      ** ---- F5 ==> Refresh screen: .Restore selection fields
      **                             .Re-load subfile
      *
     C                   IF        *INKE
     C                   MOVEL     CurSelect     ScrSelect
     C                   EXSR      $IniSubFil
     C                   EXSR      $LoadSubfl
     C                   ITER
     C                   ENDIF
 
      ** ---- F9 ==> Add a record
      *
     C                   IF        *INKI
 
      ** ------ It is not possible to insert several destinations if the
      **        network doesn't allow it
      *
     C                   IF        EDAMDS <> 'Y' AND DestNbr > 0
     C                   MOVE      'ME00132'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   ITER
     C                   ENDIF
 
     C                   EXSR      $InsertRcd
 
      ** ------ If F3 taken during the addition process => Exit
      *
     C                   IF        RetCodeIn = '*EXIT'
     C                   MOVEL (P) '*EXIT'       RetCodeOut
     C                   LEAVE
     C                   ENDIF
 
      ** ------ Re-load subfile
      *
     C                   EXSR      $IniSubFil
     C                   EXSR      $LoadSubfl
     C                   ITER
     C                   ENDIF
 
      ** ---- F12 ==> Previous Screen
      *
     C                   IF        *INKL
     C                   MOVEL (P) '*PRV'        RetCodeOut
     C                   ITER
     C                   ENDIF
 
      ** ---- Roll-Up
      *
     C                   IF        *IN25
 
      ** ------ Restore stored key value and reposition file in order to
      **        continue subfile filling from the right point
      *
     C                   MOVEL     KeyPos        KeyUsed
 
     C     KGLNW94L1     CHAIN     GLNW94D1                           27
 
      ** ------ Load Subfile
      *
     C                   EXSR      $LoadSubfl
     C                   ITER
     C                   ENDIF
 
      ** -- Selection criteria management
      *     -----------------------------
      ** -- If selection criteria were changed, re-load the subfile
      *     according to the new selection
      *
     C                   IF        ScrSelect <> CurSelect
     C                   EXSR      $IniSelect
     C                   EXSR      $IniSubFil
     C                   EXSR      $LoadSubfl
     C                   ITER
     C                   ENDIF
 
      ** -- Action codes management (If *in22 is on, the subfile exists)
      *     -----------------------
     C   22              EXSR      $ValActCde
 
      ** ---- If there is no subfile, or if no action code has been entered,
      **      the control should return to the caller
      *
     C                   IF        NOT *IN22 OR NoActCode = 'Y'
     C                   LEAVE
     C                   ENDIF
 
      ** ---- If no error process action codes, else redisplay the screen
      *
     C                   IF        ValidCodes = 'Y'  AND *IN22
     C                   EXSR      $PrcActCde
     C                   ELSE
     C                   ITER
     C                   ENDIF
 
     C                   ENDDO
 
      ** End Program
      *
     C                   EXSR      $ExitMod
 
      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*
 
      *========================================================================*
      * $IniSelect - Initialize selection keys / criteria by screen entries    *
      *------------------------------------------------------------------------*
     C     $IniSelect    BEGSR
      *    ----------    ------
      ** Save entries
      *
     C                   MOVEL     ScrSelect     CurSelect
 
      ** Reset key and effective selection DS's
      *
     C                   CLEAR                   KeyUsed
     C                   CLEAR                   EffSelect
 
      ** Reset fill key flag
      *
     C                   MOVE      'Y'           FillKey           1
 
      ** FillKey = 'Y' ---> Continue with filling 'key used' fields
      ** FillKey = 'N' ---> Continue with filling 'effective selection' fields
 
      **    The method to fill key / selection DS's is as follows :   **
      **                                                              **
      **    Check if every screen field corresponding to a file       **
      **    key field is blank or not. This must be done in the       **
      **    same order as the KLIST.                                  **
      **                                                              **
      **    If the field is filled, move it to the corresponding      **
      **    key list field, and continue to do so until finding a     **
      **    blank key field.                                          **
      **                                                              **
      **    In this case move N to the fill key flag and move the     **
      **    remaining screen fields corresponding to a file key field **
      **    to the corresponding fields of the selection DS.          **
      **                                                              **
      **    When all screen key fields have been processed, continue  **
      **    to fill the selection DS with the screen fields that are  **
      **    only for selection purpose.                               **
 
      ** Destination (always key field, because it's the first one)
      *
     C                   IF        C0DSTN <> *Blanks
     C                   MOVEL (P) C0DSTN        KeyDSTN
     C                   ELSE
     C                   MOVE      'N'           FillKey
     C                   ENDIF
 
      ** Destination Description (always selection field)
      *
      *  **              IF        C0DSTD <> *Blanks AND FillKey = 'Y'
      *  **              MOVEL     C0DSTD        KeyDSTD
      *  **              ELSE
     C                   MOVEL     C0DSTD        EffDSTD
      *  **              MOVE      'N'           FillKey
      *  **              ENDIF
 
      ** Generates MT940 (always selection field)
      *
     C                   MOVEL     C0G940        EffG940
 
      ** Generates MT941 (always selection field)
      *
     C                   MOVEL     C0G941        EffG941
 
      ** Generates MT942 (always selection field)
      *
     C                   MOVEL     C0G942        EffG942
 
      ** Set up the fixed part of the key, received in the Network Account
      ** parameter data structure
      *
     C                   EVAL      KeyNWRK = NANWRK
     C                   EVAL      KeyBRCA = NABRCH
     C                   EVAL      KeyCNUM = NACNUM
     C                   EVAL      KeyCCY  = NACCY
     C                   EVAL      KeyACCD = NAACOD
     C                   EVAL      KeyACSQ = NAACSQ
     C                   EVAL      KeyNATY = NANATY
 
      ** Save key values corresponding to selection criteria
      *
     C                   MOVE      KeyUsed       KeySav
      *    ----------    ------
     C     @IniSelect    ENDSR
 
      *========================================================================*
      * $ValActCde: Validate action codes                                      *
      *------------------------------------------------------------------------*
     C     $ValActCde    BEGSR
      *    ----------    ------
      ** Reset valid code flag (Default to 'Y') and RRN
      *
     C                   MOVE      'Y'           ValidCodes        1
     C                   Z-ADD     1             S0RRN
 
      ** Reset the "No action code" indicator
      *
     C                   MOVE      'Y'           NoActCode         1
 
      ** Check if action code is within the action code array and
      ** correct according to the displayed record values
      *
     C                   READC     ME002305S0                             99
 
 B1  C                   DOW       NOT *IN99
     C                   MOVE      *Off          *IN24
     C                   MOVE      *Off          *IN41
 
      ** -- Only process non blank action codes
      **    (In order to have them processed by the next subroutine, their
      **     Modified Data Tag is reset to ON by using *IN24 - SFLNXTCHG -)
      *
 B2  C                   IF        S0ACTCDE <> *Blanks
     C                   MOVE      'N'           NoActCode
     C                   MOVE      *On           *IN24
     C     S0ACTCDE      LOOKUP    ValActCd                               99
 
      ** ---- Invalid Action Code
      *
 B3  C                   IF        NOT *IN99
     C                             OR
     C                             (S0RECI = 'D' AND (S0ACTCDE = 'A' OR
     C                                                S0ACTCDE = 'D' OR
     C                                                (OptionIn = '*MAINT' AND
     C                                                 (S0ACTCDE = '0' OR
     C                                                  S0ACTCDE = '1' OR
     C                                                  S0ACTCDE = '2'))))
     C                             OR
     C                             (S0ACTCDE = '0' AND S0G940 <> 'Y')
     C                             OR
     C                             (S0ACTCDE = '1' AND S0G941 <> 'Y')
     C                             OR
     C                             (S0ACTCDE = '2' AND S0G942 <> 'Y')
     C                   MOVE      *On           *IN41
     C                   MOVE      'ME00029'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      'N'           ValidCodes
 E3  C                   ENDIF
 
      ** ---- Warning message if Deletion and at least one Schedule, or one
      **      submitted Message Request, exists for the current destination
      *
 B3  C                   IF        S0WARN1 <> 'Y' AND S0ACTCDE = 'D' AND
     C                             ValidCodes = 'Y'
     C     KGLGS94L1     SETLL     GLGS94D1                               99
     C  N99KGLMR94Lx     SETLL     GLMR94D2                               99
     C   99              MOVE      *On           *IN41
     C   99              MOVE      'ME00054'     ZAMSID
     C   99              EXSR      $ZaSndMsg
     C   99              MOVE      'N'           ValidCodes
     C   99              MOVE      'Y'           S0WARN1
 E3  C                   ENDIF
 
 E2  C                   ENDIF
 
     C                   UPDATE    ME002305S0
     C                   READC     ME002305S0                             99
 E1  C                   ENDDO
      *    ----------    ------
     C     @ValActCde    ENDSR
 
      *========================================================================*
      * $PrcActCde: Process action codes                                       *
      *------------------------------------------------------------------------*
     C     $PrcActCde    BEGSR
      *    ----------    ------
      ** Reset RRN and loop on the subfile
      *
     C                   Z-ADD     1             S0RRN
     C                   READC     ME002305S0                             99
 
 B1  C                   DOW       NOT *IN99
     C                   MOVE      *Off          *IN41
     C                   MOVE      *Off          *IN24
 
 B2  C                   SELECT
 
      ** Amend record
      *
 X2  C                   WHEN      S0ACTCDE = 'A' OR
     C                             (OptionIn = '*MAINT' AND (S0ACTCDE = '0' OR
     C                                                       S0ACTCDE = '1' OR
     C                                                       S0ACTCDE = '2'))
     C                   EXSR      $AmendRcd
 
 B3  C                   IF        RetCodeIn = *Blanks
     C     KGLNW94L1     CHAIN     GLNW94D1                           27
 
 B4  C                   IF        NOT *IN27
     C                   EXSR      $FillSF
     C                   UPDATE    ME002305S0
 E4  C                   ENDIF
 
 X3  C                   ELSE
 
 B4  C                   IF        RetCodeIn = '*PRV'
     C                   MOVE      *Blanks       S0ACTCDE
     C                   MOVE      *Blanks       S0WARN1
     C                   UPDATE    ME002305S0
 E4  C                   ENDIF
 
     C                   GOTO      FPrcActCde
 E3  C                   ENDIF
 
      ** Enquire the Record
      *
 X2  C                   WHEN      S0ACTCDE = 'E' OR
     C                             (OptionIn = '*DSPLY' AND (S0ACTCDE = '0' OR
     C                                                       S0ACTCDE = '1' OR
     C                                                       S0ACTCDE = '2'))
     C                   EXSR      $EnquirRcd
 
 B3  C                   IF        RetCodeIn = *Blanks
     C                   MOVE      *Blanks       S0ACTCDE
     C                   MOVE      *Blanks       S0WARN1
     C                   UPDATE    ME002305S0
 X3  C                   ELSE
 
 B4  C                   IF        RetCodeIn = '*PRV'
     C                   MOVE      *Blanks       S0ACTCDE
     C                   MOVE      *Blanks       S0WARN1
     C                   UPDATE    ME002305S0
 E4  C                   ENDIF
 
     C                   GOTO      FPrcActCde
 E3  C                   ENDIF
 
      ** Delete Record (not possible if at least one active Message Request
      **                exists for the selected destination, with a non
      **                "Schedule" Source value)
      *
 X2  C                   WHEN      S0ACTCDE = 'D'
     C     KGLMR94Lx     SETLL     GLMR94D3
 
 B3  C                   DOU       *IN99
     C     KGLMR94Lx     READE     GLMR94D3                               99
 
 B4  C  N99              IF        MRSORQ <> 'SCHEDULE'
     C                   LEAVE
 E4  C                   ENDIF
 
 E3  C                   ENDDO
 
 B3  C                   IF        *IN99
     C                   EXSR      $DeletRcd
 
 B4  C                   IF        RetCodeIn = *Blanks
     C     KGLNW94L1     CHAIN     GLNW94D1                           27
 
 B5  C                   IF        NOT *IN27
     C                   EXSR      $FillSF
     C                   UPDATE    ME002305S0
 E5  C                   ENDIF
 
 X4  C                   ELSE
 
 B5  C                   IF        RetCodeIn = '*PRV'
     C                   MOVE      *Blanks       S0ACTCDE
     C                   MOVE      *Blanks       S0WARN1
     C                   UPDATE    ME002305S0
 E5  C                   ENDIF
 
     C                   GOTO      FPrcActCde
 E4  C                   ENDIF
 
 X3  C                   ELSE
     C                   MOVE      'ME00055'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN41
     C                   MOVE      *On           *IN24
     C                   UPDATE    ME002305S0
     C                   GOTO      FPrcActCde
 E3  C                   ENDIF
 
 E2  C                   ENDSL
 
     C                   READC     ME002305S0                             99
 E1  C                   ENDDO
 
      ** All the action codes have been processed ==> Re-load the subfile
      *
     C                   CLEAR                   KeyUsed
     C                   EXSR      $IniSubFil
     C                   EXSR      $LoadSubfl
 
     C     FPrcActCde    TAG
      *    ----------    ------
      ** If F3 taken during the process ==> Exit
      *
     C                   IF        RetCodeIn = '*EXIT'
     C                   MOVEL(P)  '*EXIT'       RetCodeOut
     C                   EXSR      $ExitMod
     C                   ENDIF
      *    ----------    ------
     C     @PrcActCde    ENDSR
 
      *========================================================================*
      * $InsertRcd: Insert a new record                                        *
      *------------------------------------------------------------------------*
     C     $InsertRcd    BEGSR
      *    ----------    ------
      ** Set-up key used parameter
      *
     C                   EVAL      KeyNWRK = NANWRK
     C                   EVAL      KeyBRCA = NABRCH
     C                   EVAL      KeyCNUM = NACNUM
     C                   EVAL      KeyCCY  = NACCY
     C                   EVAL      KeyACCD = NAACOD
     C                   EVAL      KeyACSQ = NAACSQ
     C                   EVAL      KeyNATY = NANATY
     C                   CLEAR                   KeyDSTN
 
      ** Call the Network Account MT94x Details full screen display controller
      *
     C                   CALLB     'ME002310'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut        10
     C                   PARM                    KeyUsed
     C                   PARM      'I '          ActionCod2        2
     C                   PARM                    CommitInd
      *    ----------    ------
     C     @InsertRcd    ENDSR
 
      *========================================================================*
      * $AmendRcd : Amend a record                                             *
      *------------------------------------------------------------------------*
     C     $AmendRcd     BEGSR
      *    ----------    ------
      ** Set-up key used parameter
      *
     C                   EVAL      KeyNWRK = NANWRK
     C                   EVAL      KeyBRCA = NABRCH
     C                   EVAL      KeyCNUM = NACNUM
     C                   EVAL      KeyCCY  = NACCY
     C                   EVAL      KeyACCD = NAACOD
     C                   EVAL      KeyACSQ = NAACSQ
     C                   EVAL      KeyNATY = NANATY
     C                   EVAL      KeyDSTN = S0DSTN
 
      ** Call the Network Account MT94x Details full screen display controller
      *
     C                   EVAL      ActionCod2 = 'A' + S0ACTCDE
 
     C                   CALLB     'ME002310'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut
     C                   PARM                    KeyUsed
     C                   PARM                    ActionCod2
     C                   PARM                    CommitInd
      *    ----------    ------
     C     @AmendRcd     ENDSR
 
      *========================================================================*
      * $EnquirRcd: Full screen display of a record                            *
      *------------------------------------------------------------------------*
     C     $EnquirRcd    BEGSR
      *    ----------    ------
      ** Set-up key used parameter
      *
     C                   EVAL      KeyNWRK = NANWRK
     C                   EVAL      KeyBRCA = NABRCH
     C                   EVAL      KeyCNUM = NACNUM
     C                   EVAL      KeyCCY  = NACCY
     C                   EVAL      KeyACCD = NAACOD
     C                   EVAL      KeyACSQ = NAACSQ
     C                   EVAL      KeyNATY = NANATY
     C                   EVAL      KeyDSTN = S0DSTN
 
      ** Call the Network Account MT94x Details full screen display controller
      *
     C                   EVAL      ActionCod2 = 'E' + S0ACTCDE
 
     C                   CALLB     'ME002310'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut
     C                   PARM                    KeyUsed
     C                   PARM                    ActionCod2
     C                   PARM                    CommitInd
      *    ----------    ------
     C     @EnquirRcd    ENDSR
 
      *========================================================================*
      * $DeletRcd : Delete a record                                            *
      *------------------------------------------------------------------------*
     C     $DeletRcd     BEGSR
      *    ----------    ------
      ** Set-up key used parameter
      *
     C                   EVAL      KeyNWRK = NANWRK
     C                   EVAL      KeyBRCA = NABRCH
     C                   EVAL      KeyCNUM = NACNUM
     C                   EVAL      KeyCCY  = NACCY
     C                   EVAL      KeyACCD = NAACOD
     C                   EVAL      KeyACSQ = NAACSQ
     C                   EVAL      KeyNATY = NANATY
     C                   EVAL      KeyDSTN = S0DSTN
 
      ** Call the Network Account MT94x Details full screen display controller
      *
     C                   CALLB     'ME002310'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut
     C                   PARM                    KeyUsed
     C                   PARM      'D '          ActionCod2
     C                   PARM                    CommitInd
      *    ----------    ------
     C     @DeletRcd     ENDSR
 
      *========================================================================*
      * $IniSubFil: Initialise Subfile                                         *
      *------------------------------------------------------------------------*
     C     $IniSubFil    BEGSR
      *    ----------    ------
      ** Clear the subfile
      *
     C                   MOVE      *Off          *IN21
     C                   WRITE     ME002305C0
     C                   MOVE      *On           *IN21
 
      ** Reset the saving field of the subfile line number
      *
     C                   Z-ADD     0             WSavRRN
 
      ** Restore key values corresponding to selection criteria
      *
     C                   MOVE      KeySav        KeyUsed
 
      ** Position within GLNW94L1
      *
     C     KGLNW94L1     SETLL     GLNW94D1
 
      ** First read of GLNW94L1 taking into account the fixed part of the key
      *
     C     KGLNW94L1P    READE     GLNW94D1                               27
 
      ** Reset error indicators (40 - 70)
      *
     C                   MOVEA     *Zeros        IN40_TO_70
     C                   MOVEA     IN40_TO_70    *IN(40)
 
      ** Reset the number of destinations field
      *
     C                   Z-ADD     0             DestNbr
      *    ----------    ------
     C     @IniSubFil    ENDSR
 
      *========================================================================*
      * $LoadSubfl: Load a subfile page                                        *
      *------------------------------------------------------------------------*
     C     $LoadSubfl    BEGSR
      *    ----------    ------
     C                   Z-ADD     WSavRRN       S0RRN             4 0
     C                   Z-ADD     0             WCount            2 0
     C                   MOVE      *Blanks       S0ACTCDE
     C                   MOVE      *Off          *IN41
 
      ** Fill subfile loop
      *
 B1  C                   DOW       NOT *IN27 AND WCount < 10
 
      ** -- Call the select record subroutine
      *
     C                   EXSR      $SelectRcd
 
      ** -- If the record is selected, write the corresponding subfile record
      *
 B2  C                   IF        SelectRec = 'Y'
     C                   EXSR      $FillSF
     C                   ADD       1             S0RRN
     C                   ADD       1             WCount
     C                   WRITE     ME002305S0
 
 B3  C                   IF        S0RECI <> 'D'
     C                   ADD       1             DestNbr
 E3  C                   ENDIF
 
 E2  C                   ENDIF
 
      ** -- Current reading
      *
     C     KGLNW94L1P    READE     GLNW94D1                               27
 E1  C                   ENDDO
 
      ** Save the number of the last subfile record written
      ** and set up the page to display
      *
     C                   Z-ADD     S0RRN         WSavRRN           4 0
     C                   Z-ADD     S0RRN         C0RRN
 
      ** Default end of subfile to Yes
      *
     C                   MOVE      *On           *IN23
 
      ** Continue loop to see if there is remaining records to display,
      ** in order to set correctly the end of subfile indicator
      *
 B1  C                   DOW       NOT *IN27 AND *IN23
 
      ** -- Call the select record subroutine
      *
     C                   EXSR      $SelectRcd
 
      ** -- If the record is selected :
      *
      **    . Set end of subfile to No
      **    . Store current key values
      **    . Quit the loop
      *
 B2  C                   IF        SelectRec = 'Y'
     C                   MOVE      *Off          *IN23
     C                   MOVE      NANWRK        KeyPosNWRK
     C                   MOVE      NABRCH        KeyPosBRCA
     C                   MOVE      NACNUM        KeyPosCNUM
     C                   MOVE      NACCY         KeyPosCCY
     C                   MOVE      NAACOD        KeyPosACCD
     C                   MOVE      NAACSQ        KeyPosACSQ
     C                   MOVE      NANATY        KeyPosNATY
     C                   MOVE      N4DSTN        KeyPosDSTN
     C                   LEAVE
 E2  C                   ENDIF
 
      ** -- Current reading
      *
     C     KGLNW94L1P    READE     GLNW94D1                               27
 E1  C                   ENDDO
 
      ** Do not display the subfile if it is empty
      *                                                               >><<==
     C     S0RRN         COMP      0                                  22
      *    ----------    ------
     C     @LoadSubfl    ENDSR
 
      *========================================================================*
      * $SelectRcd: Tests if a record has to be displayed                      *
      *------------------------------------------------------------------------*
     C     $SelectRcd    BEGSR
      *    ----------    ------
      ** Default the select record flag to Yes (Parameter returned by the routine)
      *
     C                   MOVE      'Y'           SelectRec         1
 
      ** For each SELECTION criterion check if it is not blank and, if not,
      ** if its value exists in the corresponding field of the current file record
      *
      ** -- Destination Description
      *
     C                   IF        EffDSTD <> *Blanks AND
     C                             %Scan(%Trim(EffDSTD):N4DSTD) = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Generates MT940
      *
     C                   IF        EffG940 <> *Blanks AND
     C                             EffG940 <> N4G940
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Generates MT941
      *
     C                   IF        EffG941 <> *Blanks AND
     C                             EffG941 <> N4G941
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Generates MT942
      *
     C                   IF        EffG942 <> *Blanks AND
     C                             EffG942 <> N4G942
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
      *    ----------    ------
     C     @SelectRcd    ENDSR
 
      *========================================================================*
      * $FillSF   : Load the subfile record with the current file record values*
      *------------------------------------------------------------------------*
     C     $FillSF       BEGSR
      *    ----------    ------
     C                   CLEAR                   ME002305S0
 
     C                   IF        N4RECI = '*'
     C                   MOVEL     'D'           S0RECI
     C                   ENDIF
 
     C                   EVAL      S0DSTN = N4DSTN
     C                   EVAL      S0DSTD = N4DSTD
     C                   EVAL      S0G940 = N4G940
     C                   EVAL      S0G941 = N4G941
     C                   EVAL      S0G942 = N4G942
      *    ----------    ------
     C     @FillSF       ENDSR
 
      *========================================================================*
      * $ClrErrSF : Clear program message queue                                *
      *------------------------------------------------------------------------*
     C     $ClrErrSF     BEGSR
      *    ----------    ------
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
      *    ----------    ------
     C     @ClrErrSF     ENDSR
 
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
      * $RtvACCNT : Retrieve an account record                                 *
      *------------------------------------------------------------------------*
     C     $RtvACCNT     BEGSR
      *    ----------    ------
     C                   MOVEL     F0CNUM        @CNUM
     C                   MOVEL     F0ACCD        @ACCD
     C                   MOVEL     F0ACSQ        @ACSQ
 
     C                   CALLB     'AOACCTR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      *Blanks       @RETL            10
     C                   PARM                    @CNUM             6
     C                   PARM      F0CCY         @CUCD             3
     C**********         PARM                    @ACCD             4                          CGL029
     C                   PARM                    @ACCD            10                          CGL029
     C                   PARM                    @ACSQ             2
     C                   PARM      F0BRCA        @BRCA             3
     C     DsACCNT       PARM                    DSSDY
 
     C                   IF        @RtCd <> *Blanks
     C                   CLEAR                   DsACCNT
     C                   ENDIF
      *    ----------    ------
     C     @RtvACCNT     ENDSR
 
      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *========================================================================*
     C     *INZSR        BEGSR
      *    ----------    ------
      ** Initialise copyright array
      *
     C                   MOVEA     CPY@          CPY@@            80
 
      ** Define fields used by the message sending function
      *
     C                   IF        CallerIn <> *Blanks
     C                   MOVEL     CallerIn      ZAPGM            10
     C                   ELSE
     C                   MOVEL     PSProcPgm     ZAPGM
     C                   ENDIF
 
     C                   MOVEL(P)  'MEMSG'       ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *Blanks       ZAMSID            7
     C                   MOVEL     *Blanks       ZAMSDA          132
     C                   MOVEL     *Blanks       ZAMSTP            7
 
      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Retrieve the associated network record from the Id. received as
      ** parameter in the Network Account record data structure
      *
     C                   CALLB     'AONWRKR1'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      NANWRK        @NWRK             6
     C     DsNWRK        PARM                    DSLDY
 
     C                   IF        @RtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDNWRKPD'                          *=======*
     C                   EVAL      DBKey  = NANWRK                              *       *
     C                   EVAL      DBPgm  = ZAPGM                               * Error *
     C                   EVAL      DBase  = 001                                 *       *
     C                   EVAL      DBMod  = PSProcMod                           *  001  *
     C                   EVAL      DBProc = PSProcName                          *       *
     C                   OUT       LDA                                          *=======*
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If the associated network doesn't allow the generation of MT940/41/42,
      ** immediate return to the caller
      *
     C                   IF        EDM940 <> 'Y' AND EDM941 <> 'Y' AND
     C                             EDM942 <> 'Y'
     C                   EXSR      $ExitMod
     C                   ENDIF
 
      ** Retrieve RUNDAT
      *
     C                   IN        RUNDAT
 
      ** Retrieve default branch for current user
      *
     C                   IN        ZMUSER
     C                   MOVE      DBRN          WUserBrch         3
 
      ** Initialize available action codes array
      *
 B1  C                   SELECT
 X1  C                   WHEN      OptionIn = '*MAINT'
     C                   MOVEA (P) 'IAED012   '  ValActCd
      *
 X1  C                   WHEN      OptionIn = '*DSPLY'
     C                   MOVEA (P) '  E 012   '  ValActCd
      *
 X1  C                   OTHER
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = *Blanks                             *=======*
     C                   EVAL      DBKey  = 'Wrong Option'                      *       *
     C                   EVAL      DBPgm  = ZAPGM                               * Error *
     C                   EVAL      DBase  = 002                                 *       *
     C                   EVAL      DBMod  = PSProcMod                           *  002  *
     C                   EVAL      DBProc = PSProcName                          *       *
     C                   OUT       LDA                                          *=======*
     C                   EXSR      *PSSR
 E1  C                   ENDSL
 
      ** Correct the array according to what generation the network allows
      *
     C                   IF        EDM940 <> 'Y'
     C                   EVAL      ValActCd(5) = *Blank
     C                   ENDIF
 
     C                   IF        EDM941 <> 'Y'
     C                   EVAL      ValActCd(6) = *Blank
     C                   ENDIF
 
     C                   IF        EDM942 <> 'Y'
     C                   EVAL      ValActCd(7) = *Blank
     C                   ENDIF
 
      ** Validate each action code for the current user
      *
 B1  C     1             DO        10            X                 3 0
 
 B2  C                   IF        ValActCd(X) <> *Blank
 
      ** -- Check authority for user and branch if multi-branching system
      *
 B3  C                   IF        AGMBIN = 'Y'
     C                   CALL      'ZVACTBU'
     C                   PARM      ValActCd(X)   WActCode          1
     C                   PARM                    WUserBrch
     C                   PARM      0             WReturn           1 0
 
      ** -- Check authority for user if single-branching system
      *
 X3  C                   ELSE
     C                   CALL      'ZVACTU'
     C                   PARM      ValActCd(X)   WActCode
     C                   PARM      0             WReturn
 E3  C                   ENDIF
 
 B3  C                   IF        WReturn = 0
     C                   MOVE      *On           *IN(X)
 X3  C                   ELSE
     C                   MOVE      *Off          *IN(X)
     C                   MOVE      *Blank        ValActCd(X)
 E3  C                   ENDIF
 
 E2  C                   ENDIF
 
 E1  C                   ENDDO
 
      ** Clear the current selection DS
      *
     C                   CLEAR                   CurSelect
 
      ** Clear key DS's
      *
     C                   CLEAR                   KeyUsed
     C                   CLEAR                   KeyPos
     C                   CLEAR                   KeySav
 
      ** Set up the fixed part of the save key DS with the values received in
      ** the Network Account parameter data structure
      *
     C                   EVAL      KeySavNWRK = NANWRK
     C                   EVAL      KeySavBRCA = NABRCH
     C                   EVAL      KeySavCNUM = NACNUM
     C                   EVAL      KeySavCCY  = NACCY
     C                   EVAL      KeySavACCD = NAACOD
     C                   EVAL      KeySavACSQ = NAACSQ
     C                   EVAL      KeySavNATY = NANATY
 
      ** Set up of the key fields format (ME002305F0) with the values received
      ** in the Network Account parameter data structure
      *
     C                   EVAL      F0NWRK = NANWRK
     C                   EVAL      F0BRCA = NABRCH
     C                   EVAL      F0CNUM = NACNUM
     C                   EVAL      F0CCY  = NACCY
     C                   EVAL      F0ACCD = NAACOD
     C                   EVAL      F0ACSQ = NAACSQ
     C                   EVAL      F0NATY = NANATY
 
     C                   EXSR      $RtvACCNT
     C                   EVAL      F0ACNO = AC_ACNO
     C                   EVAL      F0ANAM = AC_ANAM
 
     C     NARECI        COMP      '*'                                    13
 
      ** Allows F12
      *
     C                   EVAL      *IN12 = *On
      *    ----------    ------
     C     @INZSR        ENDSR
 
      *========================================================================*
      * $ExitMod  : Exit Program                                               *
      *------------------------------------------------------------------------*
     C     $ExitMod      BEGSR
      *    ----------    ------
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *    ----------    ------
     C     @ExitMod      ENDSR
 
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
