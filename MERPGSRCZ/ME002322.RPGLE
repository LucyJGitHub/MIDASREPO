     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network A/c MT94x Dtl Desc.- Detail 2 Scr')   *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002322 - Midas ME Network Account MT94x Details      *
      *                   Description Maintenance                     *
      *                   (Details 2 Screen Display - MT940 Details)  *
      *                                                               *
      *  Function:  This module handles the input and the validation  *
      *             of the second screen of fields of a Network       *
      *             Account MT94x Details.                            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CMG008             Date 20Feb20               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL146             Date 10Jul13               *
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
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL146 - MT940/MT950 Production in Input Cycle               *
      *           Added hooks: CGL146_001, CGL146_020,                *
      *                        CGL146_033, CGL146_039,                *
      *                        CGL146_040                             *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************

     F/COPY OFCPYSRCZ,CGL146_033                                                              CGL146
     FME002322DFCF   E             WORKSTN
      ** Midas ME Networks Account MT94x Details 2 Screen Display
      *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Display Conditioning Indicators                               *
      *                                                               *
      * 01 - Allow Use of the F10 Key                                 *
      * 02 - Display the warning mention '**DELETED**'                *
      * 36 - Protect Fields - Prohibit Refresh                        *
      *                                                               *
      * Error Indicators                                              *
      *                                                               *
      * 40 - General Error Indicator                                  *
      * 41 - Statement Frequency                                      *
      * 42 - Statement Day in Month                                   *
      * 43 - Next Statement Date                                      *
      * 44 - Demand of Statement Indicator                            *
      * 45 - Default MT940 Message Level Info. to Account Owner (1)   *
      * 46 - Default MT940 Message Level Info. to Account Owner (2)   *
      * 47 - Default MT940 Message Level Info. to Account Owner (3)   *
      * 48 - Default MT940 Message Level Info. to Account Owner (4)   *
      * 49 - Default MT940 Message Level Info. to Account Owner (5)   *
      * 50 - Default MT940 Message Level Info. to Account Owner (6)   *
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

      ** Data to be passed to the window controller
      *
      /COPY QWINDSRC,ME002322DT

     D NewFilRcd     E DS                  EXTNAME(GLNW94PD)
      ** New Network Account MT94x Details File Record (i.e. new state after amendments)
      *

     D ScrLayout     E DS                  EXTNAME(ME002322DF:ME002322F2)
      ** Details 2 Screen Layout
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
     D/COPY OFCPYSRCZ,CGL146_020                                                              CGL146

      ** Declared variables
      ** ------------------
      *

      ** Error Indicators Array
      *
     D IN40_TO_70      S              1    DIM(31)
     D/COPY OFCPYSRCZ,CGL146_001                                                              CGL146

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
     C                   WRITE     ME002322H0
     C                   WRITE     #MSGCTL
     C                   WRITE     ME002322F0
     C                   EXFMT     ME002322F2

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

      ** Demand of Statement indicator: default is 'N'
      *
     C                   IF        F20DSI = *Blank
     C                   EVAL      F20DSI = 'N'
     C                   ENDIF

      ** Information to the account owner: default are the corresponding
      ** values of the related network record
      *
     C                   IF        F20MI1 = *Blank AND F20MI2 = *Blanks AND
     C                             F20MI3 = *Blank AND F20MI4 = *Blanks AND
     C                             F20MI5 = *Blank AND F20MI6 = *Blanks
     C                   EVAL      F20MI1 = ED0MI1
     C                   EVAL      F20MI2 = ED0MI2
     C                   EVAL      F20MI3 = ED0MI3
     C                   EVAL      F20MI4 = ED0MI4
     C                   EVAL      F20MI5 = ED0MI5
     C                   EVAL      F20MI6 = ED0MI6
     C                   ENDIF
      *    ----------    ------
     C     @FldDflt      ENDSR

      *========================================================================*
      * $ValidatSc: Validate the screen                                        *
      *------------------------------------------------------------------------*
     C     $ValidatSc    BEGSR
      *    ----------    ------
      ** Call the details 2 screen validation module if Amend or Insert
      *
     C                   IF        ActionCode = 'I' OR ActionCode = 'A'
     C                   CALLB     'ME002342'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut        10
     C                   PARM                    ScrLayout
     C                   PARM                    IN40_TO_70
     C                   PARM                    NewFilRcd
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
      /COPY WNCPYSRC,ME002322MV

      ** Call the window manager
      *
     C                   CALL      'WN0010'
     C                   PARM      'ME002322'    WdwPgm           10
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
     C                   EVAL      F20SFR = N40SFR
     C                   EVAL      F20SDM = N40SDM
     C                   EVAL      F20DSI = N40DSI
     C                   EVAL      F20MI1 = N40MI1
     C                   EVAL      F20MI2 = N40MI2
     C                   EVAL      F20MI3 = N40MI3
     C                   EVAL      F20MI4 = N40MI4
     C                   EVAL      F20MI5 = N40MI5
     C                   EVAL      F20MI6 = N40MI6
     C                   EVAL      F20LSN = N40LSN
     C                   EVAL      F20LST = N40LST

 B1  C                   IF        N40NSD <> 0
     C                   MOVEL(P)  N40NSD        @IDate
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
     C                   EVAL      F20NSD = @ODate
 E2  C                   ENDIF
      *
 E1  C                   ENDIF

     C                   EXSR      $RtvCURR

     C                   CALLB     'ZSEDIT'
     C                   PARM      N40LCA        ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      *Blank        ZECODE            1
     C                   PARM                    ZOUT21           21
      *
     C                   EVAL      F20LCA = %Subst(ZOUT21:5:17) + ' '
      *
 B1  C                   IF        %Subst(ZOUT21:21:1) = '-'
     C                   MOVE      'CR'          F20LCA
 X1  C                   ELSE
     C                   MOVE      'DB'          F20LCA
 E1  C                   ENDIF

 B1  C                   IF        N40LSD <> 0
     C                   MOVEL(P)  N40LSD        @IDate
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
     C                   EVAL      F20LSD = @ODate
 E2  C                   ENDIF
      *
 E1  C                   ENDIF

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
     C/COPY OFCPYSRCZ,CGL146_039                                                              CGL146

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
     C                   EVAL      N40SFR = F20SFR
     C                   EVAL      N40SDM = F20SDM
     C                   EVAL      N40DSI = F20DSI
     C                   EVAL      N40MI1 = F20MI1
     C                   EVAL      N40MI2 = F20MI2
     C                   EVAL      N40MI3 = F20MI3
     C                   EVAL      N40MI4 = F20MI4
     C                   EVAL      N40MI5 = F20MI5
     C                   EVAL      N40MI6 = F20MI6
     C                   EVAL      N40NSD = 0

 B1  C                   IF        F20NSD <> *Blanks
     C                   MOVEL(P)  F20NSD        @IDate

     C                   CALLB     'ZDATCVT'
     C                   PARM                    @IDate
     C                   PARM      *IN98         @IDatTyp
     C                   PARM      *Blanks       @IFmt
     C                   PARM      '*MIDAS'      @OFmt
     C                   PARM      '*NONE'       @OSep
     C                   PARM                    @ODate
     C                   PARM                    @RtnCod

 B2  C                   IF        @RtnCod = '0'
     C                   MOVEL     @ODate        N40NSD
 E2  C                   ENDIF

 E1  C                   ENDIF
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
     C/COPY OFCPYSRCZ,CGL146_040                                                              CGL146

      ** Clear the screen format and the return code
      *
     C                   CLEAR                   ME002322F2
     C                   EVAL      RetCodeOut = *Blanks

      ** If the current destination doesn't generate MT940's, simply
      ** move the cleared screen fields to the file and exit
      *
     C                   IF        N4G940 <> 'Y'
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
