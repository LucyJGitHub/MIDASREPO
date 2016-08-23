     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Schedule Generated Requests -Browse')         *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002505 - Midas ME MT941/2 Schedule Generated         *
      *                   Requests Maintenance (Browse)               *
      *                                                               *
      *  Function:  This module manages a subfile that allows to work *
      *             with the MT941/2 Schedule Generated Requests.     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
 
     FGLMR94L1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLMR94D0:GLMR94D1)
      ** Midas GL MT941/942 Messages Requests - Retrieve
      *
 
     FME002505DFCF   E             WORKSTN SFILE(ME002505S0:S0RRN)
      ** Midas ME MT941/2 Schedule Generated Requests Display
      *
      *****************************************************************
      * Use of Indicators                                             *
      *                                                               *
      * Display Conditioning Indicators                               *
      *                                                               *
      * 01 - Reserved for future use (display Insert)                 *
      * 02 - Reserved for future use (display Amend)                  *
      * 03 - Reserved for future use (display Enquire)                *
      * 04 - Display Delete                                           *
      * 05 - Display Hold                                             *
      * 06 - Display Release                                          *
      * 07 - Display .......... (Future Use)                          *
      * 08 - Display .......... (Future Use)                          *
      * 09 - Display .......... (Future Use)                          *
      * 10 - Display .......... (Future Use)                          *
      * 11 - Reserved for future use (display Select)                 *
      * 12 - Display and allow F12                                    *
      *                                                               *
      * Action key Indicators                                         *
      *                                                               *
      * KC - Exit Program                                             *
      * KE - Refresh Screen                                           *
      * KL - Previous Screen                                          *
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
      * 27 - Access GLMR94L1                                          *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 98 - Date format flag (*On if MDY / *Off if DMY)              *
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
 
     D PrvFilRcd     E DS                  EXTNAME(GLMR94PD) PREFIX(PRV_)
      ** Previous MT941/2 Message Requests File Record (i.e. initial state of the record)
      *
 
     D NewFilRcd     E DS                  EXTNAME(GLMR94PD)
      ** New MT941/2 Message Requests File Record (i.e. new state after amendments)
      *
 
     D DsGS94        E DS                  EXTNAME(GLGS94PD)
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
      ** MT941/2 Generation Schedules record format data structure
      *
 
     D DsACCNT       E DS                  EXTNAME(ACCNTAB) PREFIX(AC_)
      ** Account details record format data structure
      *
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects
      *
 
      ** Really used key
      *
     D KeyUsed         DS
     D  KeyNWRK                            LIKE(MRNWRK)
     D  KeyBRCA                            LIKE(MRBRCA)
     D  KeyCNUM                            LIKE(MRCNUM)
     D  KeyCCY                             LIKE(MRCCY)
     D  KeyACCD                            LIKE(MRACCD)
     D  KeyACSQ                            LIKE(MRACSQ)
     D  KeyNATY                            LIKE(MRNATY)
     D  KeyDSTN                            LIKE(MRDSTN)
     D  KeyMTPY                            LIKE(MRMTPY)
     D  KeySORQ                            LIKE(MRSORQ)
     D  KeySDTE                            LIKE(MRSDTE)
     D  KeySTIM                            LIKE(MRSTIM)
     D  KeyRDTE                            LIKE(MRRDTE)
     D  KeyRTIM                            LIKE(MRSRTIM)
 
      ** Position key
      *
     D KeyPos          DS
     D  KeyPosNWRK                         LIKE(MRNWRK)
     D  KeyPosBRCA                         LIKE(MRBRCA)
     D  KeyPosCNUM                         LIKE(MRCNUM)
     D  KeyPosCCY                          LIKE(MRCCY)
     D  KeyPosACCD                         LIKE(MRACCD)
     D  KeyPosACSQ                         LIKE(MRACSQ)
     D  KeyPosNATY                         LIKE(MRNATY)
     D  KeyPosDSTN                         LIKE(MRDSTN)
     D  KeyPosMTPY                         LIKE(MRMTPY)
     D  KeyPosSORQ                         LIKE(MRSORQ)
     D  KeyPosSDTE                         LIKE(MRSDTE)
     D  KeyPosSTIM                         LIKE(MRSTIM)
     D  KeyPosRDTE                         LIKE(MRRDTE)
     D  KeyPosRTIM                         LIKE(MRSRTIM)
 
      ** Saved key
      *
     D KeySav          DS
     D  KeySavNWRK                         LIKE(MRNWRK)
     D  KeySavBRCA                         LIKE(MRBRCA)
     D  KeySavCNUM                         LIKE(MRCNUM)
     D  KeySavCCY                          LIKE(MRCCY)
     D  KeySavACCD                         LIKE(MRACCD)
     D  KeySavACSQ                         LIKE(MRACSQ)
     D  KeySavNATY                         LIKE(MRNATY)
     D  KeySavDSTN                         LIKE(MRDSTN)
     D  KeySavMTPY                         LIKE(MRMTPY)
     D  KeySavSORQ                         LIKE(MRSORQ)
     D  KeySavSDTE                         LIKE(MRSDTE)
     D  KeySavSTIM                         LIKE(MRSTIM)
     D  KeySavRDTE                         LIKE(MRRDTE)
     D  KeySavRTIM                         LIKE(MRSRTIM)
 
      ** Declared variables
      ** ------------------
      *
 
      ** Valid action codes for current user
      *
     D ValActCd        S              1    DIM(11)
 
      ** Error indicators array
      *
     D IN40_TO_70      S              1    DIM(31)
 
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
     C                   PARM                    DsGS94
 
      ** Key lists
      *
     C     KGLMR94L1     KLIST
     C                   KFLD                    KeyNWRK
     C                   KFLD                    KeyBRCA
     C                   KFLD                    KeyCNUM
     C                   KFLD                    KeyCCY
     C                   KFLD                    KeyACCD
     C                   KFLD                    KeyACSQ
     C                   KFLD                    KeyNATY
     C                   KFLD                    KeyDSTN
     C                   KFLD                    KeyMTPY
     C                   KFLD                    KeySORQ
     C                   KFLD                    KeySDTE
     C                   KFLD                    KeySTIM
     C                   KFLD                    KeyRDTE
     C                   KFLD                    KeyRTIM
 
     C     KGLMR94L1P    KLIST
     C                   KFLD                    KeyNWRK
     C                   KFLD                    KeyBRCA
     C                   KFLD                    KeyCNUM
     C                   KFLD                    KeyCCY
     C                   KFLD                    KeyACCD
     C                   KFLD                    KeyACSQ
     C                   KFLD                    KeyNATY
     C                   KFLD                    KeyDSTN
     C                   KFLD                    KeyMTPY
     C                   KFLD                    KeySORQ
     C                   KFLD                    KeySDTE
     C                   KFLD                    KeySTIM
 
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
     C                   WRITE     ME002505H0
     C                   WRITE     #MSGCTL
     C                   WRITE     ME002505F0
     C                   EXFMT     ME002505C0
 
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
 
     C     KGLMR94L1     CHAIN     GLMR94D1                           27
 
      ** ------ Load Subfile
      *
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
     C                   READC     ME002505S0                             99
 
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
     C                             (S0ACTCDE = 'D' AND S0STAT = '*DELETED')
     C                             OR
     C                             (S0ACTCDE = 'H' AND S0STAT <> 'WAITING')
     C                             OR
     C                             (S0ACTCDE = 'R' AND S0STAT <> 'HELD')
     C                   MOVE      *On           *IN41
     C                   MOVE      'ME00029'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      'N'           ValidCodes
 E3  C                   ENDIF
 
      ** ---- Warning message if Deletion asked for a submitted Request
      *
 B3  C                   IF        S0WARN1 <> 'Y' AND S0ACTCDE = 'D' AND
     C                             ValidCodes = 'Y' AND S0STAT = 'SUBMITTED'
     C                   MOVE      *On           *IN41
     C                   MOVE      'ME00094'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      'N'           ValidCodes
     C                   MOVE      'Y'           S0WARN1
 E3  C                   ENDIF
 
 E2  C                   ENDIF
 
     C                   UPDATE    ME002505S0
     C                   READC     ME002505S0                             99
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
     C                   READC     ME002505S0                             99
 
 B1  C                   DOW       NOT *IN99
     C                   MOVE      *Off          *IN41
     C                   MOVE      *Off          *IN24
 
 B2  C                   SELECT
 
      ** Delete Record
      *
 X2  C                   WHEN      S0ACTCDE = 'D'
     C                   EXSR      $ProcRcd
      *
 B3  C                   IF        RetCodeIn = *Blanks
      *
 B4  C                   IF        CommitInd = '1'
     C                   COMMIT
 E4  C                   ENDIF
      *
     C                   EVAL      S0ACTCDE = *Blanks
     C                   EVAL      S0WARN1 = *Blanks
     C                   EVAL      S0STAT = '*DELETED'
     C                   UPDATE    ME002505S0
 X3  C                   ELSE
      *
 B4  C                   IF        CommitInd = '1'
     C                   ROLBK
 E4  C                   ENDIF
      *
     C   41              EVAL      *IN24 = *On
     C   41              UPDATE    ME002505S0
     C                   GOTO      FPrcActCde
 E3  C                   ENDIF
 
      ** Hold or Release a record
      *
 X2  C                   WHEN      S0ACTCDE = 'H' OR S0ACTCDE = 'R'
     C                   EXSR      $ProcRcd
      *
 B3  C                   IF        RetCodeIn = *Blanks
      *
 B4  C                   IF        CommitInd = '1'
     C                   COMMIT
 E4  C                   ENDIF
      *
     C     KGLMR94L1     CHAIN     GLMR94D1                           27
      *
 B4  C                   IF        NOT *IN27
     C                   EXSR      $FillSF
     C                   UPDATE    ME002505S0
 E4  C                   ENDIF
      *
 X3  C                   ELSE
      *
 B4  C                   IF        CommitInd = '1'
     C                   ROLBK
 E4  C                   ENDIF
      *
     C   41              EVAL      *IN24 = *On
     C   41              UPDATE    ME002505S0
     C                   GOTO      FPrcActCde
 E3  C                   ENDIF
 
 E2  C                   ENDSL
 
     C                   READC     ME002505S0                             99
 E1  C                   ENDDO
 
      ** All the action codes have been processed ==> Re-load the subfile
      *
     C                   CLEAR                   KeyUsed
     C                   EXSR      $IniSubFil
     C                   EXSR      $LoadSubfl
 
     C     FPrcActCde    TAG
      *    ----------    ------
      ** If F3 taken during the process ==> Exit (The DB Updater doesn't set the
      *                                           return code to *EXIT)
      * **               IF        RetCodeIn = '*EXIT'
      * **               MOVEL(P)  '*EXIT'       RetCodeOut
      * **               EXSR      $ExitMod
      * **               ENDIF
      *    ----------    ------
     C     @PrcActCde    ENDSR
 
      *========================================================================*
      * $ProcRcd  : Process a record (Delete / Hold / Release)                 *
      *------------------------------------------------------------------------*
     C     $ProcRcd      BEGSR
      *    ----------    ------
      ** Set-up key used parameter
      *
     C                   EVAL      KeyNWRK = GSNWRK
     C                   EVAL      KeyBRCA = GSBRCA
     C                   EVAL      KeyCNUM = GSCNUM
     C                   EVAL      KeyCCY  = GSCCY
     C                   EVAL      KeyACCD = GSACCD
     C                   EVAL      KeyACSQ = GSACSQ
     C                   EVAL      KeyNATY = GSNATY
     C                   EVAL      KeyDSTN = GSDSTN
     C                   EVAL      KeyMTPY = GSMTPY
     C                   EVAL      KeySORQ = 'SCHEDULE'
     C                   EVAL      KeySDTE = GSSDTE
     C                   EVAL      KeySTIM = GSSTIM
 
     C                   MOVEL(P)  S0RDTE        @IDate
      *
     C                   CALLB     'ZDATCVT'
     C                   PARM                    @IDate
     C                   PARM      *IN98         @IDatTyp
     C                   PARM      *Blanks       @IFmt
     C                   PARM      '*MIDAS'      @OFmt
     C                   PARM      '*NONE'       @OSep
     C                   PARM                    @ODate
     C                   PARM                    @RtnCod
      *
     C                   MOVEL     @ODate        KeyRDTE
 
     C                   IF        S0RTIM = 'IMED'
     C                   MOVEL     S0RTIM        KeyRTIM
     C                   ELSE
     C                   EVAL      KeyRTIM = %Subst(S0RTIM:1:2) +
     C                                       %Subst(S0RTIM:4:2)
     C                   ENDIF
 
      ** Call the Message Requests database updater
      *
     C     KGLMR94L1     CHAIN     GLMR94D1                           27
     C   27              EVAL      *IN41 = *On
     C   27              MOVE      'ME00032'     ZAMSID
     C   27              EXSR      $ZaSndMsg
     C   27              MOVEL(P)  '*MSG'        RetCodeIn
     C   27              GOTO      @ProcRcd
 
     C                   EVAL      PrvFilRcd = NewFilRcd
 
     C                   CALLB     'ME002560'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut        10
     C                   PARM      S0ACTCDE      ActionCode
     C                   PARM      'N'           ProcessAll        1
     C                   PARM                    PrvFilRcd
     C                   PARM                    NewFilRcd
      *    ----------    ------
     C     @ProcRcd      ENDSR
 
      *========================================================================*
      * $IniSubFil: Initialise Subfile                                         *
      *------------------------------------------------------------------------*
     C     $IniSubFil    BEGSR
      *    ----------    ------
      ** Clear the subfile
      *
     C                   MOVE      *Off          *IN21
     C                   WRITE     ME002505C0
     C                   MOVE      *On           *IN21
 
      ** Reset the saving field of the subfile line number
      *
     C                   Z-ADD     0             WSavRRN
 
      ** Restore key values corresponding to selection criteria
      *
     C                   MOVE      KeySav        KeyUsed
 
      ** Position within GLMR94L1
      *
     C     KGLMR94L1     SETLL     GLMR94D1
 
      ** First read of GLMR94L1 taking into account the fixed part of the key
      *
     C     KGLMR94L1P    READE     GLMR94D1                               27
 
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
 B1  C                   DOW       NOT *IN27 AND WCount < 8
 
      ** -- Call the select record subroutine
      *
     C                   EXSR      $SelectRcd
 
      ** -- If the record is selected, write the corresponding subfile record
      *
 B2  C                   IF        SelectRec = 'Y'
     C                   EXSR      $FillSF
     C                   ADD       1             S0RRN
     C                   ADD       1             WCount
     C                   WRITE     ME002505S0
 E2  C                   ENDIF
 
      ** -- Current reading
      *
     C     KGLMR94L1P    READE     GLMR94D1                               27
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
     C                   MOVE      GSNWRK        KeyPosNWRK
     C                   MOVE      GSBRCA        KeyPosBRCA
     C                   MOVE      GSCNUM        KeyPosCNUM
     C                   MOVE      GSCCY         KeyPosCCY
     C                   MOVE      GSACCD        KeyPosACCD
     C                   MOVE      GSACSQ        KeyPosACSQ
     C                   MOVE      GSNATY        KeyPosNATY
     C                   MOVE      GSDSTN        KeyPosDSTN
     C                   MOVE      GSMTPY        KeyPosMTPY
     C                   MOVEL(P)  'SCHEDULE'    KeyPosSORQ
     C                   MOVE      GSSDTE        KeyPosSDTE
     C                   MOVE      GSSTIM        KeyPosSTIM
     C                   MOVE      MRRDTE        KeyPosRDTE
     C                   MOVE      MRSRTIM       KeyPosRTIM
     C                   LEAVE
 E2  C                   ENDIF
 
      ** -- Current reading
      *
     C     KGLMR94L1P    READE     GLMR94D1                               27
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
      ** N.B.: There is no selection field in the current subfile processing
      *
      *    ----------    ------
     C     @SelectRcd    ENDSR
 
      *========================================================================*
      * $FillSF   : Load the subfile record with the current file record values*
      *------------------------------------------------------------------------*
     C     $FillSF       BEGSR
      *    ----------    ------
     C                   CLEAR                   ME002505S0
 
 B1  C                   IF        MRRDTE <> 0
     C                   MOVEL(P)  MRRDTE        @IDate
      *
     C   98              EVAL      @OFmt = '*MDY'
     C  N98              EVAL      @OFmt = '*DMY'
      *
     C                   CALLB     'ZDATCVT'
     C                   PARM                    @IDate           10
     C                   PARM      *IN98         @IDatTyp          1
     C                   PARM      '*MIDAS'      @IFmt             7
     C                   PARM                    @OFmt             7
     C                   PARM      '*NONE'       @OSep             5
     C                   PARM                    @ODate           10
     C                   PARM                    @RtnCod           1
      *
 B2  C                   IF        @RtnCod = '0'
     C                   MOVEL     @ODate        S0RDTE
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
 
 B1  C                   IF        MRSRTIM = 'IMED'
     C                   MOVEL(P)  MRSRTIM       S0RTIM
 X1  C                   ELSE
     C                   EVAL      S0RTIM = %Subst(MRSRTIM:1:2) + ':' +
     C                                      %Subst(MRSRTIM:3:2) + ':00'
 E1  C                   ENDIF
 
 B1  C                   IF        MRMGDT <> 0
     C                   MOVEL(P)  MRMGDT        @IDate
      *
     C   98              EVAL      @OFmt = '*MDY'
     C  N98              EVAL      @OFmt = '*DMY'
      *
     C                   CALLB     'ZDATCVT'
     C                   PARM                    @IDate           10
     C                   PARM      *IN98         @IDatTyp          1
     C                   PARM      '*MIDAS'      @IFmt             7
     C                   PARM                    @OFmt             7
     C                   PARM      '*NONE'       @OSep             5
     C                   PARM                    @ODate           10
     C                   PARM                    @RtnCod           1
      *
 B2  C                   IF        @RtnCod = '0'
     C                   MOVEL     @ODate        S0MGDT
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
 
     C                   EVAL      S0MGTM = MRMGTM
     C                   EVAL      S0STAT = MRSTAT
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
 
      ** Retrieve RUNDAT
      *
     C                   IN        RUNDAT
     C     AGDFF         COMP      'M'                                    98
 
      ** Retrieve default branch for current user
      *
     C                   IN        ZMUSER
     C                   MOVE      DBRN          WUserBrch         3
 
      ** Initialize available action codes array
      *
 B1  C                   SELECT
 X1  C                   WHEN      OptionIn = '*MAINT'
     C                   MOVEA (P) '   DHR    '  ValActCd
      *                             1...+...10
 X1  C                   WHEN      OptionIn = '*DSPLY'
     C                   MOVEA (P) '          '  ValActCd
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
 
      ** Clear key DS's
      *
     C                   CLEAR                   KeyUsed
     C                   CLEAR                   KeyPos
     C                   CLEAR                   KeySav
 
      ** Set up the fixed part of the save key DS with the values received in
      ** the MT941/2 Generation Schedule record parameter
      *
     C                   EVAL      KeySavNWRK = GSNWRK
     C                   EVAL      KeySavBRCA = GSBRCA
     C                   EVAL      KeySavCNUM = GSCNUM
     C                   EVAL      KeySavCCY  = GSCCY
     C                   EVAL      KeySavACCD = GSACCD
     C                   EVAL      KeySavACSQ = GSACSQ
     C                   EVAL      KeySavNATY = GSNATY
     C                   EVAL      KeySavDSTN = GSDSTN
     C                   EVAL      KeySavMTPY = GSMTPY
     C                   EVAL      KeySavSORQ = 'SCHEDULE'
     C                   EVAL      KeySavSDTE = GSSDTE
     C                   EVAL      KeySavSTIM = GSSTIM
 
      ** Set up the header and key fields formats (ME002505H0/F0)
      ** with the values received as parameters
      *
     C                   EVAL      H0MGTP = 'MT' + GSMTPY
 
     C                   EVAL      F0NWRK = GSNWRK
     C                   EVAL      F0BRCA = GSBRCA
     C                   EVAL      F0CNUM = GSCNUM
     C                   EVAL      F0CCY  = GSCCY
     C                   EVAL      F0ACCD = GSACCD
     C                   EVAL      F0ACSQ = GSACSQ
     C                   EVAL      F0NATY = GSNATY
     C                   EVAL      F0DSTN = GSDSTN
     C                   EVAL      F0SDTE = 0
     C                   EVAL      F0STIM = GSSTIM
     C                   EVAL      F0SPRD = GSSPRD
     C                   EVAL      F0EDTE = 0
     C                   EVAL      F0ETIM = GSETIM
     C                   EVAL      F0STUS = GSSTUS
 
     C                   EXSR      $RtvACCNT
     C                   EVAL      F0ACNO = AC_ACNO
     C                   EVAL      F0ANAM = AC_ANAM
 
 B1  C                   IF        GSSDTE <> 0
     C                   MOVEL(P)  GSSDTE        @IDate
      *
     C   98              EVAL      @OFmt = '*MDY'
     C  N98              EVAL      @OFmt = '*DMY'
      *
     C                   CALLB     'ZDATCVT'
     C                   PARM                    @IDate           10
     C                   PARM      *IN98         @IDatTyp          1
     C                   PARM      '*MIDAS'      @IFmt             7
     C                   PARM                    @OFmt             7
     C                   PARM      '*NONE'       @OSep             5
     C                   PARM                    @ODate           10
     C                   PARM                    @RtnCod           1
      *
 B2  C                   IF        @RtnCod = '0'
     C                   MOVEL     @ODate        F0SDTE
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
 
 B1  C                   IF        GSEDTE <> 0
     C                   MOVEL(P)  GSEDTE        @IDate
      *
     C   98              EVAL      @OFmt = '*MDY'
     C  N98              EVAL      @OFmt = '*DMY'
      *
     C                   CALLB     'ZDATCVT'
     C                   PARM                    @IDate           10
     C                   PARM      *IN98         @IDatTyp          1
     C                   PARM      '*MIDAS'      @IFmt             7
     C                   PARM                    @OFmt             7
     C                   PARM      '*NONE'       @OSep             5
     C                   PARM                    @ODate           10
     C                   PARM                    @RtnCod           1
      *
 B2  C                   IF        @RtnCod = '0'
     C                   MOVEL     @ODate        F0EDTE
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
 
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
(c) Misys International Banking Systems Ltd. 2002
