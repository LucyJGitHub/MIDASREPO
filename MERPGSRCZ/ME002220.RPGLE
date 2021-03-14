     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network Account Desc.- Key Screen')           *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002220 - Midas ME Network Account Description Maint. *
      *                   (Key Screen Display)                        *
      *                                                               *
      *  Function:  This module handles the input and the validation  *
      *             of the key fields of a Network Account record.    *
      *             Note that this module should only be called for   *
      *             "Insert".                                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
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
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************

     FME002220DFCF   E             WORKSTN
      ** Midas ME Network Accounts Key Screen Display
      *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Display Conditioning Indicators                               *
      *                                                               *
      * 36 - Protect Fields - Prohibit Refresh                        *
      *                                                               *
      * Error Indicators                                              *
      *                                                               *
      * 40 - General Error Indicator                                  *
      * 41 - Network Id.                                              *
      * 42 - Branch Code                                              *
      * 43 - Customer Number                                          *
      * 44 - Currency Code                                            *
      * 45 - Account Code                                             *
      * 46 - Account Sequence                                         *
      * 47 - Retail Account Number                                    *
      * 48 - Network Account Type                                     *
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

     D NewFilRcd     E DS                  EXTNAME(GLNWACPD)
      ** New Network Account File Record (i.e. new state after amendments)
      *

     D ScrLayout     E DS                  EXTNAME(ME002220DF:ME002220F0)
      ** Key Screen Layout
      *

     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *

     D DsACCNT       E DS                  EXTNAME(ACCNTAB) PREFIX(AC_)
      ** Account details record format data structure
      *

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects
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

      ** Entry Parameters (Note that *INKJ -F10- isn't used by this module)
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    ActionCode
     C                   PARM                    CallerIn         10
     C                   PARM      *INKC         KCOut             1
     C                   PARM      *Off          KJOut             1
     C     *INKL         PARM      *INKL         KLOut             1
     C                   PARM                    NewFilRcd

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

      ** Main loop until F3 or F12 or no error
      *  =====================================
 B1  C                   DOU       *INKC OR *INKL OR NOT *IN40

      ** -- Display the screen
      *     ------------------
     C                   WRITE     ME002220H0
     C                   WRITE     #MSGCTL
     C                   EXFMT     ME002220F0

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

      ** ---- F12 ==> Return to the previous screen
      *
 B2  C                   IF        *INKL
     C                   MOVEL(P)  '*PRV'        RetCodeOut
     C                   ITER
 E2  C                   ENDIF

      ** -- Validate the screen
      *     -------------------
     C                   EXSR      $ValidatSc
 E1  C                   ENDDO

      ** Exit module
      *
     C                   EXSR      $ExitMod

      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*

      *========================================================================*
      * $ValidatSc: Validate the screen                                        *
      *------------------------------------------------------------------------*
     C     $ValidatSc    BEGSR
      *    ----------    ------
      ** Call the key screen validation module
      *
     C                   CALLB     'ME002240'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    ActionCode
     C                   PARM      ZAPGM         CallerOut        10
     C                   PARM                    ScrLayout
     C                   PARM                    IN40_TO_70
     C                   PARM                    NewFilRcd

      ** Set up error indicators
      *
     C                   MOVEA     IN40_TO_70    *IN(40)
      *    ----------    ------
     C     @ValidatSc    ENDSR

      *========================================================================*
      * $IniScreen: Format the screen for Insert                               *
      *------------------------------------------------------------------------*
     C     $IniScreen    BEGSR
      *    ----------    ------
      ** Fields value
      *
     C                   CLEAR                   ME002220F0

     C                   EVAL      F0NWRK = NANWRK
     C                   EVAL      F0BRCH = NABRCH

     C**********         IF        NACNUM <> 0                                                CSD027
     C                   IF        NACNUM <> *BLANKS                                          CSD027
     C                   MOVEL     NACNUM        F0CNUM
     C                   ENDIF

     C                   EVAL      F0CCY  = NACCY

     C                   IF        NAACOD <> 0
     C                   MOVEL     NAACOD        F0ACOD
     C                   ENDIF

     C                   IF        NAACSQ <> 0
     C                   MOVEL     NAACSQ        F0ACSQ
     C                   ENDIF

     C                   EVAL      F0NATY = NANATY

     C                   EXSR      $RtvACCNT

     C                   IF        AC_ACNO <> 0
     C                   MOVEL     AC_ACNO       F0ACNO
     C                   ENDIF

      ** N.B.: The following statement should be deleted when the Network
      **       Account Type will no more be hidden
      *
     C                   EVAL      F0NATY = 'S'

      ** Don't protect fields
      *
     C                   EVAL      *IN36 = *Off
      *    ----------    ------
     C     @IniScreen    ENDSR

      *========================================================================*
      * $RtvACCNT : Retrieve an account record                                 *
      *------------------------------------------------------------------------*
     C     $RtvACCNT     BEGSR
      *    ----------    ------
     C                   CALLB     'AOACCTR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      *Blanks       @RETL            10
     C                   PARM      F0CNUM        @CNUM             6
     C                   PARM      F0CCY         @CUCD             3
     C**********         PARM      F0ACOD        @ACCD             4                          CGL029
     C                   PARM      F0ACOD        @ACCD            10                          CGL029
     C                   PARM      F0ACSQ        @ACSQ             2
     C                   PARM      F0BRCH        @BRCA             3
     C     DsACCNT       PARM                    DSSDY

     C                   IF        @RtCd <> *Blanks
     C                   CLEAR                   DsACCNT
     C                   ENDIF
      *    ----------    ------
     C     @RtvACCNT     ENDSR

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
      ** Set up the file record layout to be returned if not F3 or F12
      *
     C                   IF        NOT *INKC AND NOT *INKL
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
     C                   EVAL      NANWRK = F0NWRK
     C                   EVAL      NABRCH = F0BRCH
     C                   MOVEL     F0CNUM        NACNUM
     C                   EVAL      NACCY  = F0CCY
     C                   MOVEL     F0ACOD        NAACOD
     C                   MOVEL     F0ACSQ        NAACSQ
     C                   EVAL      NANATY = F0NATY
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

      ** Format the screen for insertion of a key
      *
     C                   EXSR      $IniScreen

      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks
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
