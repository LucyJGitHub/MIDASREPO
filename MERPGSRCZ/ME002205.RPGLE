     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network Account Desc.- Browse')               *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002205 - Midas ME Network Account Description Maint. *
      *                   (Browse)                                    *
      *                                                               *
      *  Function:  This module manages a subfile that allows to work *
      *             with the Network Account descriptions             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
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
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
 
     FGLNWACL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNWACD0:GLNWACD1)
      ** Midas GL Network Accounts
      *
 
     FGLNW94L2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D2)
      ** Midas GL Network Accounts - Live Network Accounts allowing MT940
      *
 
     FGLNW94L3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D3)
      ** Midas GL Network Accounts - Live Network Accounts allowing MT941
      *
 
     FGLNW94L4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D4)
      ** Midas GL Network Accounts - Live Network Accounts allowing MT942
      *
 
     FGLNW94L5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D5)
      ** Midas GL Network Accounts - Live MT94x Details
      *
 
     FME002205DFCF   E             WORKSTN SFILE(ME002205S0:S0RRN)
      ** Midas ME Networks Accounts Browse Display
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
      * 05 - Display .......... (Future Use)                                   *
      * 06 - Display .......... (Future Use)                                   *
      * 07 - Display .......... (Future Use)                                   *
      * 08 - Display .......... (Future Use)                                   *
      * 09 - Display .......... (Future Use)                                   *
      * 10 - Display .......... (Future Use)                                   *
      * 11 - Reserved for future use (display Select)                          *
      * 12 - Reserved for future use (display and allow F12)                   *
      *                                                                        *
      * Action key Indicators                                                  *
      *                                                                        *
      * KC - Exit Program                                                      *
      * KE - Refresh Screen                                                    *
      * KI - Insert Mode                                                       *
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
      * 27 - Access GLNWACL1                                                   *
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
 
     D DsACCNT       E DS                  EXTNAME(ACCNTAB) PREFIX(AC_)
      ** Account details record format data structure
      *
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects
      *
 
     D DummyNWAC     E DS                  EXTNAME(GLNWACPD)
      ** Dummy DS to oblige zoned numeric fields to be taken as they are
      ** by the compiler (otherwise they are considered as packed numeric)
      *
 
      ** Current selection
      *
     D CurSelect       DS
     D  CurNWRK                            LIKE(C0NWRK)
     D  CurBRCH                            LIKE(C0BRCH)
     D  CurCNUM                            LIKE(C0CNUM)
     D  CurCCY                             LIKE(C0CCY)
     D  CurACOD                            LIKE(C0ACOD)
     D  CurACSQ                            LIKE(C0ACSQ)
     D  CurNATY                            LIKE(C0NATY)
     D  CurACNO                            LIKE(C0ACNO)
     D  CurG940                            LIKE(C0G940)
     D  CurG941                            LIKE(C0G941)
     D  CurG942                            LIKE(C0G942)
     D  CurG950                            LIKE(C0G950)
 
      ** Displayed selection
      *
     D ScrSelect       DS
     D  C0NWRK
     D  C0BRCH
     D  C0CNUM
     D  C0CCY
     D  C0ACOD
     D  C0ACSQ
     D  C0NATY
     D  C0ACNO
     D  C0G940
     D  C0G941
     D  C0G942
     D  C0G950
 
      ** Effective Selection
      *
     D EffSelect       DS
     D  EffBRCH                            LIKE(C0BRCH)
     D  EffCNUM                            LIKE(C0CNUM)
     D  EffCCY                             LIKE(C0CCY)
     D  EffACOD                            LIKE(C0ACOD)
     D  EffACSQ                            LIKE(C0ACSQ)
     D  EffNATY                            LIKE(C0NATY)
     D  EffACNO                            LIKE(C0ACNO)
     D  EffG940                            LIKE(C0G940)
     D  EffG941                            LIKE(C0G941)
     D  EffG942                            LIKE(C0G942)
     D  EffG950                            LIKE(C0G950)
 
      ** Really used key
      *
     D KeyUsed         DS
     D  KeyNWRK                            LIKE(NANWRK)
     D  KeyBRCH                            LIKE(NABRCH)
     D  KeyCNUM                            LIKE(NACNUM)
     D  KeyCCY                             LIKE(NACCY)
     D  KeyACOD                            LIKE(NAACOD)
     D  KeyACSQ                            LIKE(NAACSQ)
     D  KeyNATY                            LIKE(NANATY)
 
      ** Position key
      *
     D KeyPos          DS
     D  KeyPosNWRK                         LIKE(NANWRK)
     D  KeyPosBRCH                         LIKE(NABRCH)
     D  KeyPosCNUM                         LIKE(NACNUM)
     D  KeyPosCCY                          LIKE(NACCY)
     D  KeyPosACOD                         LIKE(NAACOD)
     D  KeyPosACSQ                         LIKE(NAACSQ)
     D  KeyPosNATY                         LIKE(NANATY)
 
      ** Saved key
      *
     D KeySav          DS
     D  KeySavNWRK                         LIKE(NANWRK)
     D  KeySavBRCH                         LIKE(NABRCH)
     D  KeySavCNUM                         LIKE(NACNUM)
     D  KeySavCCY                          LIKE(NACCY)
     D  KeySavACOD                         LIKE(NAACOD)
     D  KeySavACSQ                         LIKE(NAACSQ)
     D  KeySavNATY                         LIKE(NANATY)
 
      ** Declared variables
      ** ------------------
      *
 
      ** Valid action codes for current user
      *
     D ValActCd        S              1    DIM(11)
 
      ** Error indicators array
      *
     D IN40_TO_70      S              1    DIM(31)
 
      ** Working fields for %SCAN Operations
      *
     D ScanCNUM        S                   LIKE(C0CNUM)
     D ScanACOD        S                   LIKE(C0ACOD)
     D ScanACSQ        S                   LIKE(C0ACSQ)
     D ScanACNO        S                   LIKE(C0ACNO)
 
      ** Working fields for numeric testings
      *
     D TestCNUM        S             +1    LIKE(C0CNUM)
     D TestACOD        S             +1    LIKE(C0ACOD)
     D TestACSQ        S             +1    LIKE(C0ACSQ)
 
      ** Working fields for MT94x Message Generation flags
      *
     D Flg940          S                   LIKE(C0G940)
     D Flg941          S                   LIKE(C0G941)
     D Flg942          S                   LIKE(C0G942)
 
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
 
     C     KGLNW94L5     KLIST
     C                   KFLD                    S0NWRK
     C                   KFLD                    S0BRCH
     C                   KFLD                    S0CNUM
     C                   KFLD                    S0CCY
     C                   KFLD                    S0ACOD
     C                   KFLD                    S0ACSQ
     C                   KFLD                    S0NATY
 
     C     KMT94xFlg     KLIST
     C                   KFLD                    NANWRK
     C                   KFLD                    NABRCH
     C                   KFLD                    NACNUM
     C                   KFLD                    NACCY
     C                   KFLD                    NAACOD
     C                   KFLD                    NAACSQ
     C                   KFLD                    NANATY
 
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
 
      ** Main loop (based on F3 indicator)
      *  ---------------------------------
     C                   DOW       NOT *INKC
 
      ** -- Informational message if the subfile is empty
      *
     C  N22              MOVE      'ME00001'     ZAMSID
     C  N22              EXSR      $ZaSndMsg
 
      ** -- Display the screen (error messages, header and subfile)
      *
     C                   WRITE     ME002205H0
     C                   WRITE     #MSGCTL
     C                   EXFMT     ME002205C0
 
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
 
      ** ---- Roll-Up
      *
     C                   IF        *IN25
 
      ** ------ Restore stored key value and reposition file in order to
      **        continue subfile filling from the right point
      *
     C                   MOVEL     KeyPos        KeyUsed
 
     C     KGLNWACL1     CHAIN     GLNWACD1                           27
 
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
 
      ** Network Id. (always key field, because it's the first one)
      *
     C                   IF        C0NWRK <> *Blanks
     C                   MOVEL (P) C0NWRK        KeyNWRK
     C                   ELSE
     C                   MOVE      'N'           FillKey
     C                   ENDIF
 
      ** Branch Code (key or selection field)
      *
     C                   IF        C0BRCH <> *Blanks AND FillKey = 'Y'
     C                   MOVEL     C0BRCH        KeyBRCH
     C                   ELSE
     C                   MOVEL     C0BRCH        EffBRCH
     C                   MOVE      'N'           FillKey
     C                   ENDIF
 
      ** Customer Number (key or selection field)
      *
     C                   IF        C0CNUM <> *Blanks AND FillKey = 'Y'
     C                   EVAL      TestCNUM = C0CNUM + '0'
     C**********         TESTN                   TestCNUM             9999                    CSD027
      **********                                                                              CSD027
     C**********         IF        *IN99                                                      CSD027
     C                   MOVEL     C0CNUM        KeyCNUM
     C**********         ELSE                                                                 CSD027
     C**********         MOVEL     C0CNUM        EffCNUM                                      CSD027
     C**********         MOVE      'N'           FillKey                                      CSD027
     C**********         ENDIF                                                                CSD027
 
     C                   ELSE
     C                   MOVEL     C0CNUM        EffCNUM
     C                   MOVE      'N'           FillKey
     C                   ENDIF
 
      ** Currency Code (key or selection field)
      *
     C                   IF        C0CCY <> *Blanks AND FillKey = 'Y'
     C                   MOVEL     C0CCY         KeyCCY
     C                   ELSE
     C                   MOVEL     C0CCY         EffCCY
     C                   MOVE      'N'           FillKey
     C                   ENDIF
 
      ** Account Code (key or selection field)
      *
     C                   IF        C0ACOD <> *Blanks AND FillKey = 'Y'
     C                   EVAL      TestACOD = C0ACOD + '0'
     C                   TESTN                   TestACOD             9999
 
     C                   IF        *IN99
     C                   MOVEL     C0ACOD        KeyACOD
     C                   ELSE
     C                   MOVEL     C0ACOD        EffACOD
     C                   MOVE      'N'           FillKey
     C                   ENDIF
 
     C                   ELSE
     C                   MOVEL     C0ACOD        EffACOD
     C                   MOVE      'N'           FillKey
     C                   ENDIF
 
      ** Account Sequence (key or selection field)
      *
     C                   IF        C0ACSQ <> *Blanks AND FillKey = 'Y'
     C                   EVAL      TestACSQ = C0ACSQ + '0'
     C                   TESTN                   TestACSQ             9999
 
     C                   IF        *IN99
     C                   MOVEL     C0ACSQ        KeyACSQ
     C                   ELSE
     C                   MOVEL     C0ACSQ        EffACSQ
     C                   MOVE      'N'           FillKey
     C                   ENDIF
 
     C                   ELSE
     C                   MOVEL     C0ACSQ        EffACSQ
     C                   MOVE      'N'           FillKey
     C                   ENDIF
 
      ** Network Account Type (key or selection field)
      *
     C                   IF        C0NATY <> *Blanks AND FillKey = 'Y'
     C                   MOVEL     C0NATY        KeyNATY
     C                   ELSE
     C                   MOVEL     C0NATY        EffNATY
     C                   MOVE      'N'           FillKey
     C                   ENDIF
 
      ** Retail Account Number (always selection field)
      *
     C                   MOVEL     C0ACNO        EffACNO
 
      ** Generates MT940 (always selection field)
      *
     C                   MOVEL     C0G940        EffG940
 
      ** Generates MT941 (always selection field)
      *
     C                   MOVEL     C0G941        EffG941
 
      ** Generates MT942 (always selection field)
      *
     C                   MOVEL     C0G942        EffG942
 
      ** Generates MT950 (always selection field)
      *
     C                   MOVEL     C0G950        EffG950
 
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
 
      ** Check if action code is within the action code array and
      ** correct according to the displayed record deletion flag
      *
     C                   READC     ME002205S0                             99
 
     C                   DOW       NOT *IN99
     C                   MOVE      *Off          *IN24
     C                   MOVE      *Off          *IN41
 
      ** -- Only process non blank action codes
      **    (In order to have them processed by the next subroutine, their
      **     Modified Data Tag is reset to ON by using *IN24 - SFLNXTCHG -)
      *
     C                   IF        S0ACTCDE <> *Blanks
     C                   MOVE      *On           *IN24
     C     S0ACTCDE      LOOKUP    ValActCd                               99
 
      ** ---- Invalid Action Code
      *
     C                   IF        NOT *IN99
     C                             OR
     C                             (S0RECI = 'D' AND (S0ACTCDE = 'A' OR
     C                                                S0ACTCDE = 'D'))
     C                   MOVE      *On           *IN41
     C                   MOVE      'ME00029'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      'N'           ValidCodes
     C                   ENDIF
 
     C                   ENDIF
 
     C                   UPDATE    ME002205S0
     C                   READC     ME002205S0                             99
     C                   ENDDO
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
     C                   READC     ME002205S0                             99
 
 B1  C                   DOW       NOT *IN99
     C                   MOVE      *Off          *IN41
     C                   MOVE      *Off          *IN24
 
 B2  C                   SELECT
 
      ** Amend record
      *
 X2  C                   WHEN      S0ACTCDE = 'A'
     C                   EXSR      $AmendRcd
 
 B3  C                   IF        RetCodeIn = *Blanks
     C     KGLNWACL1     CHAIN     GLNWACD1                           27
 
 B4  C                   IF        NOT *IN27
     C                   EXSR      $FillSF
     C                   UPDATE    ME002205S0
 E4  C                   ENDIF
 
 X3  C                   ELSE
 
 B4  C                   IF        RetCodeIn = '*PRV'
     C                   MOVE      *Blanks       S0ACTCDE
     C                   UPDATE    ME002205S0
 E4  C                   ENDIF
 
     C                   GOTO      FPrcActCde
 E3  C                   ENDIF
 
      ** Enquire the Record
      *
 X2  C                   WHEN      S0ACTCDE = 'E'
     C                   EXSR      $EnquirRcd
 
 B3  C                   IF        RetCodeIn = *Blanks
     C                   MOVE      *Blanks       S0ACTCDE
     C                   UPDATE    ME002205S0
 X3  C                   ELSE
 
 B4  C                   IF        RetCodeIn = '*PRV'
     C                   MOVE      *Blanks       S0ACTCDE
     C                   UPDATE    ME002205S0
 E4  C                   ENDIF
 
     C                   GOTO      FPrcActCde
 E3  C                   ENDIF
 
      ** Delete Record (not possible if at least one Live MT94x
      **                Detail exists for the selected network account)
      *
 X2  C                   WHEN      S0ACTCDE = 'D'
     C     KGLNW94L5     SETLL     GLNW94D5                               99
 
 B3  C                   IF        NOT *IN99
     C                   EXSR      $DeletRcd
 
 B4  C                   IF        RetCodeIn = *Blanks
     C     KGLNWACL1     CHAIN     GLNWACD1                           27
 
 B5  C                   IF        NOT *IN27
     C                   EXSR      $FillSF
     C                   UPDATE    ME002205S0
 E5  C                   ENDIF
 
 X4  C                   ELSE
 
 B5  C                   IF        RetCodeIn = '*PRV'
     C                   MOVE      *Blanks       S0ACTCDE
     C                   UPDATE    ME002205S0
 E5  C                   ENDIF
 
     C                   GOTO      FPrcActCde
 E4  C                   ENDIF
 
 X3  C                   ELSE
     C                   MOVE      'ME00030'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN41
     C                   MOVE      *On           *IN24
     C                   UPDATE    ME002205S0
     C                   GOTO      FPrcActCde
 E3  C                   ENDIF
 
 E2  C                   ENDSL
 
     C                   READC     ME002205S0                             99
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
     C                   CLEAR                   KeyUsed
 
      ** Call the Network Account full screen display controller
      *
     C                   CALLB     'ME002210'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut
     C                   PARM                    KeyUsed
     C                   PARM      'I'           ActionCode
      *    ----------    ------
     C     @InsertRcd    ENDSR
 
      *========================================================================*
      * $AmendRcd : Amend a record                                             *
      *------------------------------------------------------------------------*
     C     $AmendRcd     BEGSR
      *    ----------    ------
      ** Set-up key used parameter
      *
     C                   MOVE      S0NWRK        KeyNWRK
     C                   MOVE      S0BRCH        KeyBRCH
     C                   MOVE      S0CNUM        KeyCNUM
     C                   MOVE      S0CCY         KeyCCY
     C                   MOVE      S0ACOD        KeyACOD
     C                   MOVE      S0ACSQ        KeyACSQ
     C                   MOVE      S0NATY        KeyNATY
 
      ** Call the Network Account full screen display controller
      *
     C                   CALLB     'ME002210'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut        10
     C                   PARM                    KeyUsed
     C                   PARM      'A'           ActionCode
      *    ----------    ------
     C     @AmendRcd     ENDSR
 
      *========================================================================*
      * $EnquirRcd: Full screen display of a record                            *
      *------------------------------------------------------------------------*
     C     $EnquirRcd    BEGSR
      *    ----------    ------
      ** Set-up key used parameter
      *
     C                   MOVE      S0NWRK        KeyNWRK
     C                   MOVE      S0BRCH        KeyBRCH
     C                   MOVE      S0CNUM        KeyCNUM
     C                   MOVE      S0CCY         KeyCCY
     C                   MOVE      S0ACOD        KeyACOD
     C                   MOVE      S0ACSQ        KeyACSQ
     C                   MOVE      S0NATY        KeyNATY
 
      ** Call the Network Account full screen display controller
      *
     C                   CALLB     'ME002210'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut
     C                   PARM                    KeyUsed
     C                   PARM      'E'           ActionCode
      *    ----------    ------
     C     @EnquirRcd    ENDSR
 
      *========================================================================*
      * $DeletRcd : Delete a record                                            *
      *------------------------------------------------------------------------*
     C     $DeletRcd     BEGSR
      *    ----------    ------
      ** Set-up key used parameter
      *
     C                   MOVE      S0NWRK        KeyNWRK
     C                   MOVE      S0BRCH        KeyBRCH
     C                   MOVE      S0CNUM        KeyCNUM
     C                   MOVE      S0CCY         KeyCCY
     C                   MOVE      S0ACOD        KeyACOD
     C                   MOVE      S0ACSQ        KeyACSQ
     C                   MOVE      S0NATY        KeyNATY
 
      ** Call the Network full screen display controller
      *
     C                   CALLB     'ME002210'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut
     C                   PARM                    KeyUsed
     C                   PARM      'D'           ActionCode
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
     C                   WRITE     ME002205C0
     C                   MOVE      *On           *IN21
 
      ** Reset the saving field of the subfile line number
      *
     C                   Z-ADD     0             WSavRRN
 
      ** Restore key values corresponding to selection criteria
      *
     C                   MOVE      KeySav        KeyUsed
 
      ** Position within GLNWACL1 according to first key field
      **     If not blank ==> key value
      **     If blank     ==> *LOVAL
      *
     C                   IF        KeyNWRK <> *Blanks
     C     KGLNWACL1     SETLL     GLNWACD1
     C                   ELSE
     C     *LOVAL        SETLL     GLNWACD1
     C                   ENDIF
 
      ** First read of GLNWACL1
      *
     C                   READ      GLNWACD1                               27
 
      ** Reset error indicators (40 - 70)
      *
     C                   MOVEA     *Zeros        IN40_TO_70
     C                   MOVEA     IN40_TO_70    *IN(40)
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
 B1  C                   DOW       NOT *IN27 AND WCount < 12
 
      ** -- Call the select record subroutine
      *
     C                   EXSR      $SelectRcd
 
      ** -- If the record is selected, write the corresponding subfile record
      *
 B2  C                   IF        SelectRec = 'Y'
     C                   EXSR      $FillSF
     C                   ADD       1             S0RRN
     C                   ADD       1             WCount
     C                   WRITE     ME002205S0
 E2  C                   ENDIF
 
      ** -- Current reading
      *
     C                   READ      GLNWACD1                               27
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
     C                   MOVE      NABRCH        KeyPosBRCH
     C                   MOVE      NACNUM        KeyPosCNUM
     C                   MOVE      NACCY         KeyPosCCY
     C                   MOVE      NAACOD        KeyPosACOD
     C                   MOVE      NAACSQ        KeyPosACSQ
     C                   MOVE      NANATY        KeyPosNATY
     C                   LEAVE
 E2  C                   ENDIF
 
      ** -- Current reading
      *
     C                   READ      GLNWACD1                               27
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
      ** -- Branch Code
      *
     C                   IF        EffBRCH <> *Blanks AND
     C                             %Scan(%Trim(EffBRCH):NABRCH) = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Customer Number
      *
     C                   MOVEL     NACNUM        ScanCNUM
 
     C                   IF        EffCNUM <> *Blanks AND
     C                             %Scan(%Trim(EffCNUM):ScanCNUM) = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Currency Code
      *
     C                   IF        EffCCY <> *Blanks AND
     C                             %Scan(%Trim(EffCCY):NACCY) = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Account Code
      *
     C                   MOVEL     NAACOD        ScanACOD
 
     C                   IF        EffACOD <> *Blanks AND
     C                             %Scan(%Trim(EffACOD):ScanACOD) = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Account Sequence
      *
     C                   MOVEL     NAACSQ        ScanACSQ
 
     C                   IF        EffACSQ <> *Blanks AND
     C                             %Scan(%Trim(EffACSQ):ScanACSQ) = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Network Account Type
      *
     C                   IF        EffNATY <> *Blanks AND
     C                             EffNATY <> NANATY
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Retail Account Number
      *
     C                   EXSR      $RtvACCNT
     C                   MOVEL     AC_ACNO       ScanACNO
 
     C                   IF        EffACNO <> *Blanks AND
     C                             %Scan(%Trim(EffACNO):ScanACNO) = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Generates MT950
      *
     C                   IF        EffG950 <> *Blanks AND
     C                             EffG950 <> NAG950
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Generates MT94x
      *
     C                   IF        EffG940 <> *Blanks Or
     C                             EffG941 <> *Blanks Or
     C                             EffG942 <> *Blanks
 
     C                   EVAL      Flg940 = *BLANKS
     C                   EVAL      Flg941 = *BLANKS
     C                   EVAL      Flg942 = *BLANKS
 
      ** Retrieve the message generation indicator of destinations.
      ** If the flag is 'B', it means that the network account has a destination generati
      ** message and another one not generating message.
 
     C     KMT94xFlg     SETLL     GLNW94D5
     C     KMT94xFlg     READE     GLNW94D5                               99
 
      ** Network account without destination, all generation MT94x flags are 'N'.
      *
     C                   IF        *IN99
     C                   EVAL      Flg940 = 'N'
     C                   EVAL      Flg941 = 'N'
     C                   EVAL      Flg942 = 'N'
     C                   ELSE
 
      ** Otherwise, retrieve generation MT94x flags.
      *
     C                   DOW       NOT *IN99
 
     C                   SELECT
     C                   WHEN      Flg940 =  *Blanks
     C                   EVAL      Flg940 =  N4G940
     C                   WHEN      Flg940 <> N4G940
     C                   EVAL      Flg940 =  'B'
     C                   ENDSL
 
     C                   SELECT
     C                   WHEN      Flg941 =  *Blanks
     C                   EVAL      Flg941 =  N4G941
     C                   WHEN      Flg941 <> N4G941
     C                   EVAL      Flg941 =  'B'
     C                   ENDSL
 
     C                   SELECT
     C                   WHEN      Flg942 =  *Blanks
     C                   EVAL      Flg942 =  N4G942
     C                   WHEN      Flg942 <> N4G942
     C                   EVAL      Flg942 =  'B'
     C                   ENDSL
 
      **  To avoid un-necessary access, if the network account has a destination generati
      **  message and another one not generating message, leave the read loop.
 
     C                   IF        Flg940 = 'B' And
     C                             Flg941 = 'B' And
     C                             Flg942 = 'B'
     C                   LEAVE
     C                   ENDIF
 
     C     KMT94xFlg     READE     GLNW94D5                               99
     C                   ENDDO
 
     C                   ENDIF
 
      ** -- Generates MT940
      *
     C                   IF        EffG940 <> *Blanks AND
     C                             Flg940  <> 'B'     AND
     C                             EffG940 <> Flg940
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Generates MT941
      *
     C                   IF        EffG941 <> *Blanks AND
     C                             Flg941  <> 'B'     AND
     C                             EffG941 <> Flg941
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Generates MT942
      *
     C                   IF        EffG942 <> *Blanks AND
     C                             Flg942  <> 'B'     AND
     C                             EffG942 <> Flg942
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
     C                   ENDIF
 
      *    ----------    ------
     C     @SelectRcd    ENDSR
 
      *========================================================================*
      * $RtvACCNT : Retrieve an account record                                 *
      *------------------------------------------------------------------------*
     C     $RtvACCNT     BEGSR
      *    ----------    ------
     C                   MOVEL     NACNUM        ScanCNUM
     C                   MOVEL     NAACOD        ScanACOD
     C                   MOVEL     NAACSQ        ScanACSQ
 
 B1  C                   IF        ScanCNUM <> @CNUM OR NACCY    <> @CUCD OR
     C                             ScanACOD <> @ACCD OR ScanACSQ <> @ACSQ OR
     C                             NABRCH   <> @BRCA
 
     C                   CALLB     'AOACCTR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      *Blanks       @RETL            10
     C                   PARM      ScanCNUM      @CNUM             6
     C                   PARM      NACCY         @CUCD             3
     C**********         PARM      ScanACOD      @ACCD             4                          CGL029
     C                   PARM      ScanACOD      @ACCD            10                          CGL029
     C                   PARM      ScanACSQ      @ACSQ             2
     C                   PARM      NABRCH        @BRCA             3
     C     DsACCNT       PARM                    DSSDY
 
 B2  C                   IF        @RtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'ACCNTAB'                           *=======*
     C                   EVAL      DBKey  = @CNUM+@CUCD+@ACCD+@ACSQ+@BRCA       *       *
     C                   EVAL      DBPgm  = ZAPGM                               * Error *
     C                   EVAL      DBase  = 002                                 *       *
     C                   EVAL      DBMod  = PSProcMod                           *  002  *
     C                   EVAL      DBProc = PSProcName                          *       *
     C                   OUT       LDA                                          *=======*
     C                   EXSR      *PSSR
 E2  C                   ENDIF
 
 E1  C                   ENDIF
      *    ----------    ------
     C     @RtvACCNT     ENDSR
 
      *========================================================================*
      * $FillSF   : Load the subfile record with the current file record values*
      *------------------------------------------------------------------------*
     C     $FillSF       BEGSR
      *    ----------    ------
     C                   EXSR      $RtvACCNT
     C                   CLEAR                   ME002205S0
 
     C                   IF        NARECI = '*'
     C                   MOVEL     'D'           S0RECI
     C                   ELSE
     C                   MOVE      *Blank        S0RECI
     C                   ENDIF
 
     C                   MOVEL     NANWRK        S0NWRK
     C                   MOVEL     NABRCH        S0BRCH
     C**********         Z-ADD     NACNUM        S0CNUM                                       CSD027
     C                   EVAL      S0CNUM  =  NACNUM                                          CSD027
     C                   MOVEL     NACCY         S0CCY
     C                   Z-ADD     NAACOD        S0ACOD
     C                   Z-ADD     NAACSQ        S0ACSQ
     C                   MOVEL     NANATY        S0NATY
     C                   Z-ADD     AC_ACNO       S0ACNO
     C                   MOVEL     NAG950        S0G950
     C
     C                   MOVEL     'N'           S0G940
     C                   MOVEL     'N'           S0G941
     C                   MOVEL     'N'           S0G942
     C
     C     KMT94xFlg     SETLL     GLNW94D2                               99
     C   99              MOVEL     'Y'           S0G940
     C
     C     KMT94xFlg     SETLL     GLNW94D3                               99
     C   99              MOVEL     'Y'           S0G941
     C
     C     KMT94xFlg     SETLL     GLNW94D4                               99
     C   99              MOVEL     'Y'           S0G942
     C
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
     C                   MOVEA (P) 'IAED      '  ValActCd
      *
 X1  C                   WHEN      OptionIn = '*DSPLY'
     C                   MOVEA (P) '  E       '  ValActCd
      *
 X1  C                   OTHER
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = *Blanks                             *=======*
     C                   EVAL      DBKey  = 'Wrong Option'                      *       *
     C                   EVAL      DBPgm  = ZAPGM                               * Error *
     C                   EVAL      DBase  = 001                                 *       *
     C                   EVAL      DBMod  = PSProcMod                           *  001  *
     C                   EVAL      DBProc = PSProcName                          *       *
     C                   OUT       LDA                                          *=======*
     C                   EXSR      *PSSR
 E1  C                   ENDSL
 
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
