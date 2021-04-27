     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network A/c MT94x Dtl Desc.- Detail 4 Scr')   *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002324 - Midas ME Network Account MT94x Details      *
      *                   Description Maintenance                     *
      *                   (Details 4 Screen Display - MT941/2 Dtls)   *
      *                                                               *
      *  Function:  This module handles the input and the validation  *
      *             of the fourth screen of fields of a Network       *
      *             Account MT94x Details.                            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CMG008             Date 20Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL178             Date 04Aug16               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL178 - Generate MT942 based on MT950.                      *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
 
     FME002324DFCF   E             WORKSTN
      ** Midas ME Networks Account MT94x Details 4 Screen Display
      *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Display Conditioning Indicators                               *
      *                                                               *
      * 01 - Allow Use of the F10 Key                                 *
      * 02 - Display the warning mention '**DELETED**'                *
      * 03 - Protect "Allow Generation on External Request"           *
      * 04 - Protect "Allow Generation on Schedule"                   *
      * 05 - Protect "Allow Generation on Manual Request"             *
      * 36 - Protect Fields - Prohibit Refresh                        *
      *                                                               *
      * Error Indicators                                              *
      *                                                               *
      * 40 - General Error Indicator                                  *
      * 41 - Generation if no Movement                                *
      * 42 - Allow Generation on External Request                     *
      * 43 - Allow Generation on Schedule                             *
      * 44 - Allow Generation on Manual Request                       *
      * 45 - Re-Extract all Postings from Last MT940                  *
      * 46 - Re-Extract all Shadow Postings                           *
      * (The DS IN40_TO_70 is used to cover the whole set of reserved *
      *  error indicators)                                            *
      *                                                               *
      * Subfile Management Indicators                                 *
      *                                                               *
      * 23 - SFLEND (Messages Subfile)                                *
      *                                                               *
      * Action key Indicators                                         *
      *                                                               *
      * KC - Exit Program                                             *
      * KE - Refresh Screen                                           *
      * KJ - Confirm Deletion                                         *
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
 
      ** Data to be passed to the window controller
      *
      /COPY QWINDSRC,ME002324DT
 
     D NewFilRcd     E DS                  EXTNAME(GLNW94PD)
      ** New Network Account MT94x Details File Record (i.e. new state after amendments)
      *
 
     D ScrLayout     E DS                  EXTNAME(ME002324DF:ME002324F4)
      ** Details 4 Screen Layout
      *
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *
 
     D DsNWRK        E DS                  EXTNAME(SDNWRKPD)
      ** Network details record format data structure
      *
 
     D DsACCNT       E DS                  EXTNAME(ACCNTAB) PREFIX(AC_)
      ** Account details record format data structure
      *
 
     D DsCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency details record format data structure
      *
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects
      *
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** DS (longest) used as output parameter for Access Objects
      *
 
      ** Declared variables
      ** ------------------
      *
 
      ** Error Indicators Array
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
     C                   PARM                    ActionCode
     C                   PARM                    CallerIn         10
     C                   PARM      *INKC         KCOut             1
     C                   PARM      *INKJ         KJOut             1
     C     *INKL         PARM      *INKL         KLOut             1
     C                   PARM                    NewFilRcd
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR subroutine
 
      ** Main loop until F3 or F10 or F12 or no error
      *  ============================================
 B1  C                   DOU       *INKC OR *INKJ OR *INKL OR NOT *IN40
 
      ** -- Display the screen
      *     ------------------
      *
     C                   WRITE     ME002324H0
     C                   WRITE     #MSGCTL
     C                   WRITE     ME002324F0
     C                   EXFMT     ME002324F4
 
      ** -- Clear the program message queue and the error indicators
      *     --------------------------------------------------------
     C                   EXSR      $ClrErrSF
     C                   MOVEA     *Zeros        IN40_TO_70
     C                   MOVEA     IN40_TO_70    *IN(40)
 
      ** -- Action keys management
      *     ----------------------
      ** ---- F3 ==> Exit program
      *
 B2  C                   IF        *INKC
     C                   MOVEL(P)  '*EXIT'       RetCodeOut
     C                   ITER
 E2  C                   ENDIF
 
      ** ---- F5 ==> Refresh the screen
      *
 B2  C                   IF        *INKE
     C                   EXSR      $IniScreen
     C                   EVAL      *IN40 = *On
     C                   ITER
 E2  C                   ENDIF
 
      ** ---- F10 ==> Confirm deletion of the record
      *
 B2  C                   IF        *INKJ
     C                   MOVEL(P)  '*DLTCONF'    RetCodeOut
     C                   ITER
 E2  C                   ENDIF
 
      ** ---- F12 ==> Return to the previous screen
      *
 B2  C                   IF        *INKL
     C                   MOVEL(P)  '*PRV'        RetCodeOut
     C                   ITER
 E2  C                   ENDIF
 
      ** -- Validate the screen
      *     -------------------
      ** ---- Fields defaulting (if Insert or Amend)
      *
     C                   EXSR      $FldDflt
 
      ** ---- Validation
      *
     C                   EXSR      $ValidatSc
 
      ** -- Window processing if no validation error
      *     -----------------
 B2  C                   IF        NOT *IN40
     C                   EXSR      $Window
 E2  C                   ENDIF
 
 E1  C                   ENDDO
 
      ** Exit module
      *
     C                   EXSR      $ExitMod
 
      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*
 
      *========================================================================*
      * $FldDflt  : Screen fields defaulting                                   *
      *------------------------------------------------------------------------*
     C     $FldDflt      BEGSR
      *    ----------    ------
      ** No defaulting if Delete or Enquire
      *
     C                   IF        ActionCode = 'D' OR ActionCode = 'E'
     C                   GOTO      @FldDflt
     C                   ENDIF
 
      ** Generation if no Movement: default is the related network value or 'N'
      *
 B1  C                   IF        F41GNM = *Blank
     C                   EVAL      F41GNM = ED1GNM
      *
 B2  C                   IF        F41GNM = *Blank
     C                   EVAL      F41GNM = 'N'
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
 
      ** Allow Generation on External Request: default is 'N'
      *
     C                   IF        F41AER = *Blank
     C                   EVAL      F41AER = 'N'
     C                   ENDIF
 
      ** Allow Generation on Schedule: default is 'N'
      *
     C                   IF        F41AGS = *Blank
     C                   EVAL      F41AGS = 'N'
     C                   ENDIF
 
      ** Allow Generation on Manual Request: default is 'N'
      *
     C                   IF        F41AMR = *Blank
     C                   EVAL      F41AMR = 'N'
     C                   ENDIF
 
      ** "Allow generation on external request" may be forced to 'N' and
      ** locked if the related network doesn't allow it
      *
     C                   IF        ED1AER = 'N'
     C                   EVAL      F41AER = 'N'
     C                   EVAL      *IN03 = *On
     C                   ENDIF
 
      ** "Allow generation on schedule" may be forced to 'N' and
      ** locked if the related network doesn't allow it
      *
     C                   IF        ED1AGS = 'N'
     C                   EVAL      F41AGS = 'N'
     C                   EVAL      *IN04 = *On
     C                   ENDIF
 
      ** "Allow generation on manual request" may be forced to 'N' and
      ** locked if the related network doesn't allow it
      *
     C                   IF        ED1AMR = 'N'
     C                   EVAL      F41AMR = 'N'
     C                   EVAL      *IN05 = *On
     C                   ENDIF
 
      ** Re-Extract all Postings from Last MT940: default is the related network value
      *
 B1  C                   IF        F41RPL = *Blank
     C                   EVAL      F41RPL = ED1RPL
      *
      ** -- The field can be 'Y' only if the MT940 statement frequency isn't
      **    'D' or blank
      *
 B2  C                   IF        F41RPL = 'Y' AND
     C                             (N40SFR = 'D' OR N40SFR = *Blank)
     C                   EVAL      F41RPL = 'N'
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
 
      ** Re-Extract all Shadow Postings: default is the related network value
      *
     C                   IF        F41RAS = *Blank
     C                   EVAL      F41RAS = ED1RSP
     C                   ENDIF
      *    ----------    ------
     C     @FldDflt      ENDSR
 
      *========================================================================*
      * $ValidatSc: Validate the screen                                        *
      *------------------------------------------------------------------------*
     C     $ValidatSc    BEGSR
      *    ----------    ------
      ** Call the details 4 screen validation module if Amend or Insert
      *
     C                   IF        ActionCode = 'I' OR ActionCode = 'A'
     C                   CALLB     'ME002344'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut        10
     C                   PARM                    ScrLayout
     C                   PARM                    IN40_TO_70
     C                   PARM                    NewFilRcd
     C                   PARM      N40SFR        MT940StFq         1
     C                   ENDIF
 
      ** Set up error indicators
      *
     C                   MOVEA     IN40_TO_70    *IN(40)
      *    ----------    ------
     C     @ValidatSc    ENDSR
 
      *========================================================================*
      * $Window   : Window processing                                          *
      *------------------------------------------------------------------------*
     C     $Window       BEGSR
      *    ----------    ------
      ** Hook to enable the set up of data for the window controller
      *
      /COPY WNCPYSRC,ME002324MV
 
      ** Call the window manager
      *
     C                   CALL      'WN0010'
     C                   PARM      'ME002324'    WdwPgm           10
     C                   PARM      *Blanks       WdwKey            2
     C                   PARM      ActionCode    WdwAction         1
     C                   PARM                    Data
     C                   PARM      *Blanks       WdwRtCd           7
     C                   PARM      *Blanks       WdwSpare        256
 
      ** If the returncode isn't blank, always issue a roll back command to
      ** cancel the eventual changes made in the window(s), and set up the
      ** appropriate action key (nothing to do for F12, any other value is
      ** considered as F3)
      *
 B1  C                   IF        WdwRtCd <> *Blanks
     C                   ROLBK
 
 B2  C                   IF        WdwRtCd <> 'USR0790'
     C                   EVAL      *INKC = *On
 E2  C                   ENDIF
 
 E1  C                   ENDIF
      *    ----------    ------
     C     @Window       ENDSR
 
      *========================================================================*
      * $IniScreen: Format the screen according to the received action code    *
      *------------------------------------------------------------------------*
     C     $IniScreen    BEGSR
      *    ----------    ------
      ** Fields value
      *
     C                   EVAL      F0NWRK = N4NWRK
     C                   EVAL      F0BRCA = N4BRCA
     C                   EVAL      F0CNUM = N4CNUM
     C                   EVAL      F0CCY  = N4CCY
     C                   EVAL      F0ACCD = N4ACCD
     C                   EVAL      F0ACSQ = N4ACSQ
     C                   EVAL      F0NATY = N4NATY
     C                   EVAL      F0DSTN = N4DSTN
 
     C                   EXSR      $RtvACCNT
 
     C                   IF        AC_ACNO <> 0
     C                   MOVEL     AC_ACNO       F0ACNO
     C                   ENDIF
     C                   EVAL      F0ANAM = AC_ANAM
      *------------------
     C                   EVAL      F41GNM = N41GNM
     C                   EVAL      F41AER = N41AER
     C                   EVAL      F41AGS = N41AGS
     C                   EVAL      F41AMR = N41AMR
     C                   EVAL      F41RPL = N41RPL
     C                   EVAL      F41RAS = N41RAS
     C                   EVAL      F41LSP = N41LSP
     C                   EVAL      F41LST = N41LST
     C                   EVAL      F41LDN = N41LDN
     C                   EVAL      F41LCN = N41LCN
 
     C                   EXSR      $RtvCURR
 
     C                   CALLB     'ZSEDIT'
     C                   PARM      N41LCB        ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      *Blank        ZECODE            1
     C                   PARM                    ZOUT21           21
      *
     C                   EVAL      F41LCB = %Subst(ZOUT21:5:17) + ' '
      *
 B1  C                   IF        %Subst(ZOUT21:21:1) = '-'
     C                   MOVE      'CR'          F41LCB
 X1  C                   ELSE
     C                   MOVE      'DB'          F41LCB
 E1  C                   ENDIF
 
 B1  C                   IF        N41LSD <> 0
     C                   MOVEL(P)  N41LSD        @IDate
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
     C                   EVAL      F41LSD = @ODate
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
 
     C                   CALLB     'ZSEDIT'
     C                   PARM      N41LDA        ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      *Blank        ZECODE            1
     C                   PARM                    ZOUT21           21
      *
     C                   EVAL      F41LDA = %Subst(ZOUT21:5:17) + ' '
      *
 
     C                   CALLB     'ZSEDIT'
     C                   PARM      N41LCA        ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      *Blank        ZECODE            1
     C                   PARM                    ZOUT21           21
      *
     C                   EVAL      F41LCA = %Subst(ZOUT21:5:17) + ' '
      *
 
      ** Fields defaulting
      *
     C                   EXSR      $FldDflt
 
      ** Protect fields or not
      *
     C                   IF        ActionCode = 'I' OR ActionCode = 'A'
     C                   EVAL      *IN36 = *Off
     C                   ELSE
     C                   EVAL      *IN36 = *On
     C                   ENDIF
 
      ** If MT940 not to be generated (only in case CGL178 is on)                             CGL178
     C                   IF        N4G940 = 'N'                                               CGL178
     C                   SETON                                        49                      CGL178
     C                   ELSE                                                                 CGL178
     C                   SETOFF                                       49                      CGL178
     C                   ENDIF                                                                CGL178
                                                                                              CGL178
      ** Allow F10 key
      *                                                               >><<==
     C     ActionCode    COMP      'D'                                    01
 
      ** Display the warning mention '**DELETED**'
      *                                                               >><<==
     C     N4RECI        COMP      '*'                                    02
      *    ----------    ------
     C     @IniScreen    ENDSR
 
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
      * $RtvCURR  : Retrieve a currency detail record                          *
      *------------------------------------------------------------------------*
     C     $RtvCURR      BEGSR
      *    ----------    ------
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      F0CCY         @CUCD
     C     DsCURR        PARM                    DSSDY
 
     C                   IF        @RtCd <> *Blanks
     C                   CLEAR                   DsCURR
     C                   ENDIF
      *    ----------    ------
     C     @RtvCURR      ENDSR
 
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
      * $ExitMod  : Exit from the module                                       *
      *------------------------------------------------------------------------*
     C     $ExitMod      BEGSR
      *    ----------    ------
      ** Set up the file record layout to be returned if all's right
      ** and the current action is Insert or Amend
      *
     C                   IF        RetCodeOut = *Blanks AND
     C                             (ActionCode = 'I' OR ActionCode = 'A')
     C                   EXSR      $ScrToFile
     C                   ENDIF
 
     C                   MOVE      *On           *INLR
     C                   RETURN
      *    ----------    ------
     C     @ExitMod      ENDSR
 
      *========================================================================*
      * $ScrToFile: Move fields from the screen to the file record             *
      *========================================================================*
     C     $ScrToFile    BEGSR
      *    ----------    ------
     C                   EVAL      N41GNM = F41GNM
     C                   EVAL      N41AER = F41AER
     C                   EVAL      N41AGS = F41AGS
     C                   EVAL      N41AMR = F41AMR
     C                   EVAL      N41RPL = F41RPL
     C                   EVAL      N41RAS = F41RAS
      *    ----------    ------
     C     @ScrToFile    ENDSR
 
      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *========================================================================*
     C     *INZSR        BEGSR
      *    ----------    ------
      ** Initialise Copyright Array
      *
     C                   MOVEA     CPY@          CPY@@            80
 
      ** Define fields used by the clear message queue function
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
 
     C                   MOVEL     '*SAME'       ZAPGRL            5
 
      ** Retrieve RUNDAT
      *
     C                   IN        RUNDAT
     C     AGDFF         COMP      'M'                                    98
 
      ** Clear the screen format and the return code
      *
     C                   CLEAR                   ME002324F4
     C                   EVAL      RetCodeOut = *Blanks
 
      ** If the current destination doesn't generate MT941's, simply
      ** move the cleared screen fields to the file and exit
      *
     C                   IF        N4G941 <> 'Y'
     C                   EXSR      $ExitMod
     C                   ENDIF
 
      ** Retrieve the associated network record
      *
     C                   CALLB     'AONWRKR1'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      N4NWRK        @NWRK             6
     C     DsNWRK        PARM                    DSLDY
 
     C                   IF        @RtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDNWRKPD'                          *=======*
     C                   EVAL      DBKey  = N4NWRK                              *       *
     C                   EVAL      DBPgm  = ZAPGM                               * Error *
     C                   EVAL      DBase  = 001                                 *       *
     C                   EVAL      DBMod  = PSProcMod                           *  001  *
     C                   EVAL      DBProc = PSProcName                          *       *
     C                   OUT       LDA                                          *=======*
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Format the screen according to the received action code
      *
     C                   EXSR      $IniScreen
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
