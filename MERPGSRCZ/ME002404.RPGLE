     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME MT941/2 Generation Schedules- Browse Dest')   *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002404 - Midas ME MT941/2 Generation Schedules       *
      *                   Description Maintenance (1st Browse to      *
      *                   Select a Destination)                       *
      *                                                               *
      *  Function:  This module manages a subfile that allows to      *
      *             select some Network Account MT94x Details         *
      *             descriptions, in order to work with the linked    *
      *             Generation Schedules.                             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
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
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
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

     FGLNW94L6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D6)
      ** Midas GL Network Accounts - MT94x - Allowing MT941/942 Generation on Schedule
      *

     FME002404DFCF   E             WORKSTN SFILE(ME002404S0:S0RRN)
      ** Midas ME Network Account MT94x Details Browse Display
      *

      *****************************************************************
      * Use of Indicators                                             *
      *                                                               *
      * Display Conditioning Indicators                               *
      *                                                               *
      * 01 - Reserved for future use (display Insert)                 *
      * 02 - Display Amend                                            *
      * 03 - Display Enquire                                          *
      * 04 - Reserved for future use (display Delete)                 *
      * 05 - Display .......... (Future Use)                          *
      * 06 - Display MT941 Schedules (Action Code)                    *
      * 07 - Display MT942 Schedules (Action Code)                    *
      * 08 - Display .......... (Future Use)                          *
      * 09 - Display .......... (Future Use)                          *
      * 10 - Display .......... (Future Use)                          *
      * 11 - Reserved for future use (display Select)                 *
      * 12 - Reserved for future use (Display and allow F12)          *
      *                                                               *
      * Action key Indicators                                         *
      *                                                               *
      * KC - Exit Program                                             *
      * KE - Refresh Screen                                           *
      *                                                               *
      * Error Indicators                                              *
      *                                                               *
      * 40 - General Error Indicator                                  *
      * 41 - Error On Action Code                                     *
      * (The DS IN40_TO_70 is used to cover the whole set of reserved *
      *  error indicators)                                            *
      *                                                               *
      * Subfile Management Indicators                                 *
      *                                                               *
      * 21 - SFLDSPCTL if *ON / SFLCLR if *OFF                        *
      * 22 - SFLDSP                                                   *
      * 23 - SFLEND                                                   *
      * 24 - SFLNXTCHG                                                *
      * 25 - Rollup                                                   *
      *                                                               *
      * Database Access Indicators                                    *
      *                                                               *
      * 27 - Access GLNW94L6                                          *
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

     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *

     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)
      ** User Informations DS
      *

     D DsNW94        E DS                  EXTNAME(GLNW94PD)
      ** Network Account MT94x Details record format data structure
      *

     D DsACCNT       E DS                  EXTNAME(ACCNTAB) PREFIX(AC_)
      ** Account details record format data structure
      *

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects
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
     D  CurDSTN                            LIKE(C0DSTN)
     D  Cur1AGS                            LIKE(C01AGS)
     D  Cur2AGS                            LIKE(C02AGS)

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
     D  C0DSTN
     D  C01AGS
     D  C02AGS

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
     D  EffDSTN                            LIKE(C0DSTN)
     D  Eff1AGS                            LIKE(C01AGS)
     D  Eff2AGS                            LIKE(C02AGS)

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

      ** Working fields
      *
     D TestCNUM        S             +1    LIKE(C0CNUM)
     D TestACOD        S             +1    LIKE(C0ACOD)
     D TestACSQ        S             +1    LIKE(C0ACSQ)
     D WkActCode       S              1A
     D KMsgType        S              3A
     D ScanCNUM        S                   LIKE(C0CNUM)
     D ScanACOD        S                   LIKE(C0ACOD)
     D ScanACSQ        S                   LIKE(C0ACSQ)
     D ScanACNO        S                   LIKE(C0ACNO)

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
     C     KGLNW94L6     KLIST
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

      ** -- Display the screen (header, error messages and subfile)
      *
     C                   WRITE     ME002404H0
     C                   WRITE     #MSGCTL
     C                   EXFMT     ME002404C0

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

      ** ---- Roll-Up
      *
     C                   IF        *IN25

      ** ------ Restore stored key value and reposition file in order to
      **        continue subfile filling from the right point
      *
     C                   MOVEL     KeyPos        KeyUsed

     C     KGLNW94L6     CHAIN     GLNW94D6                           27

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

      ** -- Action codes management (If *IN22 is on, the subfile exists)
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

      ** Network (always key field, because it's the first one)
      *
     C                   IF        C0NWRK <> *Blanks
     C                   MOVEL (P) C0NWRK        KeyNWRK
     C                   ELSE
     C                   MOVE      'N'           FillKey
     C                   ENDIF

      ** Branch Code (key or selection field)
      *
     C                   IF        C0BRCH <> *Blanks AND FillKey = 'Y'
     C                   MOVEL     C0BRCH        KeyBRCA
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
     C                   ELSE
     C                   MOVEL     C0CNUM        EffCNUM
     C                   MOVE      'N'           FillKey
     C                   ENDIF

     C**********         ELSE                                                                 CSD027
     C**********         MOVEL     C0CNUM        EffCNUM                                      CSD027
     C**********         MOVE      'N'           FillKey                                      CSD027
     C**********         ENDIF                                                                CSD027

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
     C                   MOVEL     C0ACOD        KeyACCD
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

      ** Destination (key or selection field)
      *
     C                   IF        C0DSTN <> *Blanks AND FillKey = 'Y'
     C                   MOVEL (P) C0DSTN        KeyDSTN
     C                   ELSE
     C                   MOVEL     C0DSTN        EffDSTN
     C                   MOVE      'N'           FillKey
     C                   ENDIF

      ** Retail Account Number (always selection field)
      *
     C                   MOVEL     C0ACNO        EffACNO

      ** MT941 Generation on Schedule Allowed (always selection field)
      *
     C                   MOVEL     C01AGS        Eff1AGS

      ** MT942 Generation on Schedule Allowed (always selection field)
      *
     C                   MOVEL     C02AGS        Eff2AGS

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
      ** correct according to the displayed record values
      *
     C                   READC     ME002404S0                             99

 B1  C                   DOW       NOT *IN99
     C                   MOVE      *Off          *IN24
     C                   MOVE      *Off          *IN41

      ** -- Only process non blank action codes
      **    (In order to have them processed by the next subroutine, their
      **     Modified Data Tag is reset to ON by using *IN24 - SFLNXTCHG -)
      *
 B2  C                   IF        S0ACTCDE <> *Blanks
     C                   MOVE      *On           *IN24
     C     S0ACTCDE      LOOKUP    ValActCd                               99

      ** ---- Invalid Action Code
      *
 B3  C                   IF        NOT *IN99
     C                             OR
     C                             (S0RECI = 'D' AND (S0ACTCDE = 'A' OR
     C                                                (OptionIn = '*MAINT' AND
     C                                                 (S0ACTCDE = '1' OR
     C                                                  S0ACTCDE = '2'))))
     C                             OR
     C                             (S0ACTCDE = '1' AND S01AGS <> 'Y')
     C                             OR
     C                             (S0ACTCDE = '2' AND S02AGS <> 'Y')
     C                   MOVE      *On           *IN41
     C                   MOVE      'ME00029'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      'N'           ValidCodes
 E3  C                   ENDIF

 E2  C                   ENDIF

     C                   UPDATE    ME002404S0
     C                   READC     ME002404S0                             99
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
     C                   READC     ME002404S0                             99

 B1  C                   DOW       NOT *IN99
     C                   MOVE      *Off          *IN41
     C                   MOVE      *Off          *IN24

 B2  C                   SELECT

      ** Amend record
      *
 X2  C                   WHEN      S0ACTCDE = 'A' OR
     C                             (OptionIn = '*MAINT' AND (S0ACTCDE = '1' OR
     C                                                       S0ACTCDE = '2'))
     C                   EXSR      $AmendRcd

 B3  C                   IF        RetCodeIn = *Blanks
     C     KGLNW94L6     CHAIN     GLNW94D6                           27

 B4  C                   IF        NOT *IN27
     C                   EXSR      $FillSF
     C                   UPDATE    ME002404S0
 E4  C                   ENDIF

 X3  C                   ELSE

 B4  C                   IF        RetCodeIn = '*PRV' OR *IN41
     C  N41              MOVE      *Blanks       S0ACTCDE
     C                   UPDATE    ME002404S0
 E4  C                   ENDIF

     C                   GOTO      FPrcActCde
 E3  C                   ENDIF

      ** Enquire the Record
      *
 X2  C                   WHEN      S0ACTCDE = 'E' OR
     C                             (OptionIn = '*DSPLY' AND (S0ACTCDE = '1' OR
     C                                                       S0ACTCDE = '2'))
     C                   EXSR      $EnquirRcd

 B3  C                   IF        RetCodeIn = *Blanks
     C                   MOVE      *Blanks       S0ACTCDE
     C                   UPDATE    ME002404S0
 X3  C                   ELSE

 B4  C                   IF        RetCodeIn = '*PRV' OR *IN41
     C  N41              MOVE      *Blanks       S0ACTCDE
     C                   UPDATE    ME002404S0
 E4  C                   ENDIF

     C                   GOTO      FPrcActCde
 E3  C                   ENDIF

 E2  C                   ENDSL

     C                   READC     ME002404S0                             99
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
      * $AmendRcd : Amend a record                                             *
      *------------------------------------------------------------------------*
     C     $AmendRcd     BEGSR
      *    ----------    ------
      ** Set-up key used parameter and acces the record to fill DsNW94
      *
     C                   EVAL      KeyNWRK = S0NWRK
     C                   EVAL      KeyBRCA = S0BRCH
     C                   EVAL      KeyCNUM = S0CNUM
     C                   EVAL      KeyCCY  = S0CCY
     C                   EVAL      KeyACCD = S0ACOD
     C                   EVAL      KeyACSQ = S0ACSQ
     C                   EVAL      KeyNATY = S0NATY
     C                   EVAL      KeyDSTN = S0DSTN
     C     KGLNW94L6     CHAIN     GLNW94D6                           27

      ** If not found
      *
     C                   IF        *IN27
     C                   EVAL      *IN41 = *On
     C                   EVAL      *IN24 = *On
     C                   MOVE      'ME00032'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   EVAL      RetCodeIn = '*MSG'
     C                   GOTO      @AmendRcd
     C                   ENDIF

      ** If the record is deleted
      *
     C                   IF        N4RECI = '*'
     C                   EVAL      *IN41 = *On
     C                   EVAL      *IN24 = *On
     C                   MOVE      'ME00033'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   EVAL      RetCodeIn = '*MSG'
     C                   GOTO      @AmendRcd
     C                   ENDIF

      ** Call the Generation Schedules Browse controller
      ** N.B.: the processing is run twice, as each destination may be parent
      **       of up to two sets of generation schedules (1 for MT941, the
      **       other for MT942)
      *
     C                   EVAL      WkActCode = '1'
     C                   EVAL      KMsgType  = '941'

 B1  C                   DO        2
      *
 B2  C                   IF        S0ACTCDE = 'A' OR S0ACTCDE = WkActCode
     C                   CALLB     'ME002405'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      '*MAINT'      OptionOut        10
     C                   PARM      ZAPGM         CallerOut        10
     C                   PARM      '1'           CommitInd         1
     C                   PARM                    DsNW94
     C                   PARM                    KMsgType
      *
 B3  C                   IF        RetCodeIn <> *Blanks
     C                   LEAVE
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
     C                   EVAL      WkActCode = '2'
     C                   EVAL      KMsgType  = '942'
 E1  C                   ENDDO
      *    ----------    ------
     C     @AmendRcd     ENDSR

      *========================================================================*
      * $EnquirRcd: Full screen display of a record                            *
      *------------------------------------------------------------------------*
     C     $EnquirRcd    BEGSR
      *    ----------    ------
      ** Set-up key used parameter and acces the record to fill DsNW94
      *
     C                   EVAL      KeyNWRK = S0NWRK
     C                   EVAL      KeyBRCA = S0BRCH
     C                   EVAL      KeyCNUM = S0CNUM
     C                   EVAL      KeyCCY  = S0CCY
     C                   EVAL      KeyACCD = S0ACOD
     C                   EVAL      KeyACSQ = S0ACSQ
     C                   EVAL      KeyNATY = S0NATY
     C                   EVAL      KeyDSTN = S0DSTN
     C     KGLNW94L6     CHAIN     GLNW94D6                           27

      ** If not found
      *
     C                   IF        *IN27
     C                   EVAL      *IN41 = *On
     C                   EVAL      *IN24 = *On
     C                   MOVE      'ME00032'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   EVAL      RetCodeIn = '*MSG'
     C                   GOTO      @EnquirRcd
     C                   ENDIF

      ** Call the Generation Schedules Browse controller
      ** N.B.: the processing is run twice, as each destination may be parent
      **       of up to two sets of generation schedules (1 for MT941, the
      **       other for MT942)
      *
     C                   EVAL      WkActCode = '1'
     C                   EVAL      KMsgType  = '941'

 B1  C                   DO        2
      *
 B2  C                   IF        S0ACTCDE = 'E' OR S0ACTCDE = WkActCode
     C                   CALLB     'ME002405'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      '*DSPLY'      OptionOut        10
     C                   PARM      ZAPGM         CallerOut        10
     C                   PARM      '0'           CommitInd         1
     C                   PARM                    DsNW94
     C                   PARM                    KMsgType
      *
 B3  C                   IF        RetCodeIn <> *Blanks
     C                   LEAVE
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
     C                   EVAL      WkActCode = '2'
     C                   EVAL      KMsgType  = '942'
 E1  C                   ENDDO
      *    ----------    ------
     C     @EnquirRcd    ENDSR

      *========================================================================*
      * $IniSubFil: Initialise Subfile                                         *
      *------------------------------------------------------------------------*
     C     $IniSubFil    BEGSR
      *    ----------    ------
      ** Clear the subfile
      *
     C                   MOVE      *Off          *IN21
     C                   WRITE     ME002404C0
     C                   MOVE      *On           *IN21

      ** Reset the saving field of the subfile line number
      *
     C                   Z-ADD     0             WSavRRN

      ** Restore key values corresponding to selection criteria
      *
     C                   MOVE      KeySav        KeyUsed

      ** Position within GLNW94L6 according to first key field
      **     If not blank ==> key value
      **     If blank     ==> *LOVAL
      *
     C                   IF        KeyNWRK <> *Blanks
     C     KGLNW94L6     SETLL     GLNW94D6
     C                   ELSE
     C     *LOVAL        SETLL     GLNW94D6
     C                   ENDIF

      ** First read of GLNW94L6
      *
     C                   READ      GLNW94D6                               27

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
     C                   WRITE     ME002404S0

 E2  C                   ENDIF

      ** -- Current reading
      *
     C                   READ      GLNW94D6                               27
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
     C                   MOVE      N4NWRK        KeyPosNWRK
     C                   MOVE      N4BRCA        KeyPosBRCA
     C                   MOVE      N4CNUM        KeyPosCNUM
     C                   MOVE      N4CCY         KeyPosCCY
     C                   MOVE      N4ACCD        KeyPosACCD
     C                   MOVE      N4ACSQ        KeyPosACSQ
     C                   MOVE      N4NATY        KeyPosNATY
     C                   MOVE      N4DSTN        KeyPosDSTN
     C                   LEAVE
 E2  C                   ENDIF

      ** -- Current reading
      *
     C                   READE     GLNW94D6                               27
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
     C                             %Scan(%Trim(EffBRCH):N4BRCA) = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF

      ** -- Customer Number
      *
     C                   MOVEL     N4CNUM        ScanCNUM

     C                   IF        EffCNUM <> *Blanks AND
     C                             %Scan(%Trim(EffCNUM):ScanCNUM) = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF

      ** -- Currency Code
      *
     C                   IF        EffCCY <> *Blanks AND
     C                             %Scan(%Trim(EffCCY):N4CCY) = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF

      ** -- Account Code
      *
     C                   MOVEL     N4ACCD        ScanACOD

     C                   IF        EffACOD <> *Blanks AND
     C                             %Scan(%Trim(EffACOD):ScanACOD) = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF

      ** -- Account Sequence
      *
     C                   MOVEL     N4ACSQ        ScanACSQ

     C                   IF        EffACSQ <> *Blanks AND
     C                             %Scan(%Trim(EffACSQ):ScanACSQ) = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF

      ** -- Network Account Type
      *
     C                   IF        EffNATY <> *Blanks AND
     C                             EffNATY <> N4NATY
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

      ** -- Destination
      *
     C                   IF        EffDSTN <> *Blanks AND
     C                             %Scan(%Trim(EffDSTN):N4DSTN) = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF

      ** -- Allow MT941 on Schedule
      *
     C                   IF        Eff1AGS <> *Blanks AND
     C                             Eff1AGS <> N41AGS
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF

      ** -- Allow MT942 on Schedule
      *
     C                   IF        Eff2AGS <> *Blanks AND
     C                             Eff2AGS <> N42AGS
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
      *    ----------    ------
     C     @SelectRcd    ENDSR

      *========================================================================*
      * $RtvACCNT : Retrieve an account record                                 *
      *------------------------------------------------------------------------*
     C     $RtvACCNT     BEGSR
      *    ----------    ------
     C                   MOVEL     N4CNUM        ScanCNUM
     C                   MOVEL     N4ACCD        ScanACOD
     C                   MOVEL     N4ACSQ        ScanACSQ

 B1  C                   IF        ScanCNUM <> @CNUM OR N4CCY    <> @CUCD OR
     C                             ScanACOD <> @ACCD OR ScanACSQ <> @ACSQ OR
     C                             N4BRCA   <> @BRCA

     C                   CALLB     'AOACCTR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      *Blanks       @RETL            10
     C                   PARM      ScanCNUM      @CNUM             6
     C                   PARM      N4CCY         @CUCD             3
     C**********         PARM      ScanACOD      @ACCD             4                          CGL029
     C                   PARM      ScanACOD      @ACCD            10                          CGL029
     C                   PARM      ScanACSQ      @ACSQ             2
     C                   PARM      N4BRCA        @BRCA             3
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
     C                   CLEAR                   ME002404S0

     C                   IF        N4RECI = '*'
     C                   MOVEL     'D'           S0RECI
     C                   ENDIF

     C                   EVAL      S0NWRK = N4NWRK
     C                   EVAL      S0BRCH = N4BRCA
     C                   MOVEL     N4CNUM        S0CNUM
     C                   EVAL      S0CCY  = N4CCY
     C                   MOVEL     N4ACCD        S0ACOD
     C                   MOVEL     N4ACSQ        S0ACSQ
     C                   EVAL      S0NATY = N4NATY
     C                   MOVEL     AC_ACNO       S0ACNO
     C                   EVAL      S0DSTN = N4DSTN
     C                   EVAL      S01AGS = N41AGS
     C                   EVAL      S02AGS = N42AGS
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

      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks

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
     C                   MOVEA (P) ' AE  12   '  ValActCd
      *
 X1  C                   WHEN      OptionIn = '*DSPLY'
     C                   MOVEA (P) '  E  12   '  ValActCd
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
