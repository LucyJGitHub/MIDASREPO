     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network Description - Browse')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200105 - Midas SD Network Description Maintenance    *
      *                   (Browse)                                    *
      *                                                               *
      *  Function:  This module manages a subfile that allows to work *
      *             with the Network descriptions                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG23028           Date 20Feb09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL013  *CREATE    Date 25Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23028 - Webfacing issue (Recompile)                       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
 
     FSDNWRKL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@EDREJZ:SDNWRKD1)
      ** Midas Message Network Details
      *
 
     FGLNWACL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNWACD0:GLNWACD1)
      ** Midas GL Network Accounts
      *
 
     FSD200105DFCF   E             WORKSTN SFILE(SD200105S0:S0RRN)
      ** Midas SD Networks Browse Display
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
      * 11 - Display Select                                                    *
      * 12 - Display 'F12=Previous...' & allow use of F12 key                  *
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
      * 27 - Access SDNWRKL1                                                   *
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
 
      ** Current selection
      *
     D CurSelect       DS
     D  CurNWRK                            LIKE(C0NWRK)
     D  CurNETD                            LIKE(C0NETD)
     D  CurPROT                            LIKE(C0PROT)
     D  CurM940                            LIKE(C0M940)
     D  CurM941                            LIKE(C0M941)
     D  CurM942                            LIKE(C0M942)
     D  CurM950                            LIKE(C0M950)
     D  CurAMDS                            LIKE(C0AMDS)
     D  CurENRA                            LIKE(C0ENRA)
 
      ** Displayed selection
      *
     D ScrSelect       DS
     D  C0NWRK
     D  C0NETD
     D  C0PROT
     D  C0M940
     D  C0M941
     D  C0M942
     D  C0M950
     D  C0AMDS
     D  C0ENRA
 
      ** Effective Selection
      *
     D EffSelect       DS
     D  EffNETD                            LIKE(C0NETD)
     D  EffPROT                            LIKE(C0PROT)
     D  EffM940                            LIKE(C0M940)
     D  EffM941                            LIKE(C0M941)
     D  EffM942                            LIKE(C0M942)
     D  EffM950                            LIKE(C0M950)
     D  EffAMDS                            LIKE(C0AMDS)
     D  EffENRA                            LIKE(C0ENRA)
 
      ** Really used key
      *
     D KeyUsed         DS
     D  KeyNWRK                            LIKE(C0NWRK)
 
      ** Position key
      *
     D KeyPos          DS
     D  KeyPosNWRK                         LIKE(C0NWRK)
 
      ** Saved key
      *
     D KeySav          DS
     D  KeySavNWRK                         LIKE(C0NWRK)
 
      ** Declared variables
      ** ------------------
      *
 
      ** Valid action codes for current user
      *
     D ValActCd        S              1    DIM(11)
 
      ** Error indicators array
      *
     D IN40_TO_70      S              1    DIM(31)
 
      ** Working field for %SCAN Operations
      *
     D WFld            S              3  0
 
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
     C                   PARM      S0NWRK        @NWRK             6
 
      ** Key lists
      *
     C     KSDNWRKL1     KLIST
     C                   KFLD                    KeyNWRK
 
     C     KGLNWACL1     KLIST
     C                   KFLD                    S0NWRK
 
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
     C  N22              MOVE      'USR3969'     ZAMSID
     C  N22              EXSR      $ZaSndMsg
 
      ** -- Display the screen (error messages, header and subfile)
      *
     C                   WRITE     SD200105H0
     C                   WRITE     #MSGCTL
     C                   EXFMT     SD200105C0
 
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
 
      ** ---- F12 ==> Back to previous screen
      *
     C                   IF        *INKL
     C                   MOVEL(P)  '*PRV'        RetCodeOut
     C                   ITER
     C                   ENDIF
 
      ** ---- Roll-Up
      *
     C                   IF        *IN25
 
      ** ------ Restore stored key value and reposition file in order to
      **        continue subfile filling from the right point
      *
     C                   MOVEL     KeyPos        KeyUsed
 
     C     KSDNWRKL1     CHAIN     SDNWRKD1                           27
 
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
 
      ** Network Id. (always key field, because it's the first -and only- one)
      *
     C                   IF        C0NWRK <> *Blanks
     C                   MOVEL (P) C0NWRK        KeyNWRK
     C                   ELSE
     C                   MOVE      'N'           FillKey
     C                   ENDIF
 
      ** Network description (always selection field)
      *
      **    NOTE: The commented lines are an example to show what     **
      **          should be done if there is more than one key field. **
      *
      *    **            IF        C0NETD <> *Blanks AND FillKey = 'Y'
      *    **            MOVEL     C0NETD        KeyNETD
      *    **            ELSE
     C                   MOVEL     C0NETD        EffNETD
      *    **            MOVE      'N'           FillKey
      *    **            ENDIF
 
      ** Protocol type (always selection field)
      *
     C                   MOVEL     C0PROT        EffPROT
 
      ** Allows MT940 generation (always selection field)
      *
     C                   MOVEL     C0M940        EffM940
 
      ** Allows MT941 generation (always selection field)
      *
     C                   MOVEL     C0M941        EffM941
 
      ** Allows MT942 generation (always selection field)
      *
     C                   MOVEL     C0M942        EffM942
 
      ** Allows MT950 generation (always selection field)
      *
     C                   MOVEL     C0M950        EffM950
 
      ** Allows multiple destinations for MT94x (always selection field)
      *
     C                   MOVEL     C0AMDS        EffAMDS
 
      ** Allows extended narratives (always selection field)
      *
     C                   MOVEL     C0ENRA        EffENRA
 
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
     C                   READC     SD200105S0                             99
 
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
     C                             (S0DLTF = 'D' AND (S0ACTCDE = 'A' OR
     C                                                S0ACTCDE = 'D' OR
     C                                                S0ACTCDE = '1'))
     C                   MOVE      *On           *IN41
     C                   MOVE      'USR3967'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      'N'           ValidCodes
     C                   ENDIF
 
     C                   ENDIF
 
     C                   UPDATE    SD200105S0
     C                   READC     SD200105S0                             99
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
     C                   READC     SD200105S0                             99
 
 B1  C                   DOW       NOT *IN99
     C                   MOVE      *Off          *IN41
     C                   MOVE      *Off          *IN24
 
 B2  C                   SELECT
 
      ** Amend record
      *
 X2  C                   WHEN      S0ACTCDE = 'A'
     C                   EXSR      $AmendRcd
 
 B3  C                   IF        RetCodeIn = *Blanks
     C     KSDNWRKL1     CHAIN     SDNWRKD1                           27
 
 B4  C                   IF        NOT *IN27
     C                   EXSR      $FillSF
     C                   UPDATE    SD200105S0
 E4  C                   ENDIF
 
 X3  C                   ELSE
 
 B4  C                   IF        RetCodeIn = '*PRV'
     C                   MOVE      *Blanks       S0ACTCDE
     C                   UPDATE    SD200105S0
 E4  C                   ENDIF
 
     C                   GOTO      FPrcActCde
 E3  C                   ENDIF
 
      ** Enquire the Record
      *
 X2  C                   WHEN      S0ACTCDE = 'E'
     C                   EXSR      $EnquirRcd
 
 B3  C                   IF        RetCodeIn = *Blanks
     C                   MOVE      *Blanks       S0ACTCDE
     C                   UPDATE    SD200105S0
 X3  C                   ELSE
 
 B4  C                   IF        RetCodeIn = '*PRV'
     C                   MOVE      *Blanks       S0ACTCDE
     C                   UPDATE    SD200105S0
 E4  C                   ENDIF
 
     C                   GOTO      FPrcActCde
 E3  C                   ENDIF
 
      ** Delete Record (not possible if at least one Network
      **                Account exists for the selected network)
      *
 X2  C                   WHEN      S0ACTCDE = 'D'
     C                   MOVEL     'Y'           DeletOK           1
 
     C     KGLNWACL1     SETLL     GLNWACD1
     C     KGLNWACL1     READE     GLNWACD1                               99
 
 B3  C                   DOW       NOT *IN99
 
 B4  C                   IF        NARECI <> '*'
     C                   MOVEL     'N'           DeletOK
     C                   LEAVE
 E4  C                   ENDIF
 
     C     KGLNWACL1     READE     GLNWACD1                               99
 E3  C                   ENDDO
 
 B3  C                   IF        DeletOK = 'Y'
     C                   EXSR      $DeletRcd
 
 B4  C                   IF        RetCodeIn = *Blanks
     C     KSDNWRKL1     CHAIN     SDNWRKD1                           27
 
 B5  C                   IF        NOT *IN27
     C                   EXSR      $FillSF
     C                   UPDATE    SD200105S0
 E5  C                   ENDIF
 
 X4  C                   ELSE
 
 B5  C                   IF        RetCodeIn = '*PRV'
     C                   MOVE      *Blanks       S0ACTCDE
     C                   UPDATE    SD200105S0
 E5  C                   ENDIF
 
     C                   GOTO      FPrcActCde
 E4  C                   ENDIF
 
 X3  C                   ELSE
     C                   MOVE      'USR3968'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN41
     C                   MOVE      *On           *IN24
     C                   UPDATE    SD200105S0
     C                   GOTO      FPrcActCde
 E3  C                   ENDIF
 
      ** Select the Record
      *
 X2  C                   WHEN      S0ACTCDE = '1'
     C                   EXSR      $ReturnRcd
 
      ** -- The code may reach this point only if an error occurs
      **    in $ReturnRcd
      *
     C                   MOVE      *On           *IN24
     C                   UPDATE    SD200105S0
     C                   GOTO      FPrcActCde
 E2  C                   ENDSL
 
     C                   READC     SD200105S0                             99
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
     C                   MOVE      '*EXIT'       RetCodeOut
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
     C                   MOVE      *Blanks       KeyUsed
 
      ** Call the Network full screen display controller
      *
     C                   CALLB     'SD200110'
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
 
      ** Call the Network full screen display controller
      *
     C                   CALLB     'SD200110'
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
 
      ** Call the Network full screen display controller
      *
     C                   CALLB     'SD200110'
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
 
      ** Call the Network full screen display controller
      *
     C                   CALLB     'SD200110'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut
     C                   PARM                    KeyUsed
     C                   PARM      'D'           ActionCode
      *    ----------    ------
     C     @DeletRcd     ENDSR
 
      *========================================================================*
      * $ReturnRcd: Returns the first selected network id. to the caller       *
      *------------------------------------------------------------------------*
     C     $ReturnRcd    BEGSR
      *    ----------    ------
      ** Access the file with the selected record key value
      *
     C                   MOVE      S0NWRK        KeyNWRK
     C     KSDNWRKL1     CHAIN     SDNWRKD1                           27
 
      ** -- Record Not Found
      *
 B1  C                   IF        *IN27
     C                   MOVE      'USR4003'     ZAMSID
     C                   MOVE      *On           *IN41
     C                   EXSR      $ZaSndMsg
 
      ** -- Otherwise check if the record has not been deleted
      *
 X1  C                   ELSE
 
 B2  C                   IF        EDTYLC = 'D'
     C                   MOVE      'USR4004'     ZAMSID
     C                   MOVE      *On           *IN41
     C                   EXSR      $ZaSndMsg
 
      ** -- All's OK, exit the program returning the selected network id.
      *
 X2  C                   ELSE
     C                   MOVE      *Blanks       RetCodeOut
     C                   EXSR      $ExitMod
 E2  C                   ENDIF
 
 E1  C                   ENDIF
      *    ----------    ------
     C     @ReturnRcd    ENDSR
 
      *========================================================================*
      * $IniSubFil: Initialise Subfile                                         *
      *------------------------------------------------------------------------*
     C     $IniSubFil    BEGSR
      *    ----------    ------
      ** Clear the subfile
      *
     C                   MOVE      *Off          *IN21
     C                   WRITE     SD200105C0
     C                   MOVE      *On           *IN21
 
      ** Reset the saving field of the subfile line number
      *
     C                   Z-ADD     0             WSavRRN
 
      ** Restore key values corresponding to selection criteria
      *
     C                   MOVE      KeySav        KeyUsed
 
      ** Position within SDNWRKL1 according to first key field
      **     If not blank ==> key value
      **     If blank     ==> *LOVAL
      *
     C                   IF        KeyNWRK <> *Blanks
     C     KSDNWRKL1     SETLL     SDNWRKD1
     C                   ELSE
     C     *LOVAL        SETLL     SDNWRKD1
     C                   ENDIF
 
      ** First read of SDNWRKL1
      *
     C                   READ      SDNWRKD1                               27
 
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
     C                   WRITE     SD200105S0
 E2  C                   ENDIF
 
      ** -- Current reading
      *
     C                   READ      SDNWRKD1                               27
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
     C                   MOVE      EDNWRK        KeyPosNWRK
     C                   LEAVE
 E2  C                   ENDIF
 
      ** -- Current reading
      *
     C                   READ      SDNWRKD1                               27
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
      ** -- Network description
      *
     C                   IF        EffNETD <> *Blanks
     C                   EVAL      WFld = %SCAN(%TRIM(EffNETD):EDNETD)
 
     C                   IF        Wfld = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
     C                   ENDIF
 
      ** -- Protocol type
      *
     C                   IF        EffPROT <> *Blanks
     C                   EVAL      WFld = %SCAN(%TRIM(EffPROT):EDPROT)
 
     C                   IF        Wfld = 0
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
     C                   ENDIF
 
      ** -- Allows MT940 generation
      *
     C                   IF        EffM940 <> *Blanks AND EffM940 <> EDM940
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Allows MT941 generation
      *
     C                   IF        EffM941 <> *Blanks AND EffM941 <> EDM941
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Allows MT942 generation
      *
     C                   IF        EffM942 <> *Blanks AND EffM942 <> EDM942
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Allows MT950 generation
      *
     C                   IF        EffM950 <> *Blanks AND EffM950 <> EDM950
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Allows multiple destinations for MT94x
      *
     C                   IF        EffAMDS <> *Blanks AND EffAMDS <> EDAMDS
     C                   MOVE      'N'           SelectRec
     C                   GOTO      @SelectRcd
     C                   ENDIF
 
      ** -- Allows extended narratives
      *
     C                   IF        EffENRA <> *Blanks AND EffENRA <> EDENRA
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
     C                   CLEAR                   SD200105S0
 
     C                   IF        EDTYLC = 'D'
     C                   MOVEL     'D'           S0DLTF
     C                   ELSE
     C                   MOVE      *Blank        S0DLTF
     C                   ENDIF
 
     C                   MOVEL     EDNWRK        S0NWRK
     C                   MOVEL     EDNETD        S0NETD
     C                   MOVEL     EDPROT        S0PROT
     C                   MOVEL     EDM940        S0M940
     C                   MOVEL     EDM941        S0M941
     C                   MOVEL     EDM942        S0M942
     C                   MOVEL     EDM950        S0M950
     C                   MOVEL     EDAMDS        S0AMDS
     C                   MOVEL     EDENRA        S0ENRA
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
 
     C                   MOVEL     'SDUSRMSG'    ZAMSGF           10
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
 X1  C                   WHEN      OptionIn = '*SELECT'
     C                   MOVEA (P) '  E       '  ValActCd
     C                   MOVE      '1'           ValActCd(11)
     C                   MOVE      *On           *IN11
     C                   MOVE      *On           *IN12
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
      ** If the module wasn't called for a network id. selection, or if there
      ** was something wrong, the returned network id. must be blanked out
      *
     C                   IF        OptionIn <> '*SELECT' OR
     C                             RetCodeOut <> *Blanks
     C                   MOVE      *Blanks       S0NWRK
     C                   ENDIF
 
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
 
     C                   CALLB     'DBERRCTL'
 
     C                   MOVEL(P)  '*ERROR'      RetCodeOut
     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR
 
      *========================================================================*
**  CPY@
(c) Finastra International Limited 2003
