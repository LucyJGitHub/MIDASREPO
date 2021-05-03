     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network Account Desc.- Details 1 Screen')     *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002221 - Midas ME Network Account Description Maint. *
      *                   (Details 1 Screen Display - MT950 Details)  *
      *                                                               *
      *  Function:  This module handles the input and the validation  *
      *             of the first screen of fields of a Network        *
      *             Account record.                                   *
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
      *                        CGL146_033, CGL146_038,                *
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
     FME002221DFCF   E             WORKSTN
      ** Midas ME Networks Account Details 1 Screen Display
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
      * 41 - MT950 Generation Indicator                               *
      * 42 - Statement Frequency                                      *
      * 43 - Statement Day in Month                                   *
      * 44 - Next Statement Date                                      *
      * 45 - Demand of Statement Indicator                            *
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
      /COPY QWINDSRC,ME002221DT

     D NewFilRcd     E DS                  EXTNAME(GLNWACPD)
      ** New Network Account File Record (i.e. new state after amendments)
      *

     D ScrLayout     E DS                  EXTNAME(ME002221DF:ME002221F1)
      ** Details 1 Screen Layout
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
      **    - Only the key fields format if MT950 generation isn't allowed
      **      by the network (the processing can only reach this point in
      **      this case if the action code is "D" - see *INZSR -)
      **    - The information screen format is only displayed if the
      **      current network account generates MT950
      *
     C                   WRITE     ME002221H0
     C                   WRITE     #MSGCTL

     C                   IF        F1G950 = 'Y'
     C                   WRITE     ME002221FI
     C                   ENDIF

     C                   IF        EDM950 <> 'Y'
     C                   EXFMT     ME002221F0
     C                   ELSE
     C                   WRITE     ME002221F0
     C                   EXFMT     ME002221F1
     C                   ENDIF

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
 B2  C                   IF        NOT *IN40 AND EDM950 = 'Y'
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

      ** Generates MT950: default is 'N'
      *
     C                   IF        F1G950 = *Blank
     C                   EVAL      F1G950 = 'N'
     C                   ENDIF

      ** Demand of Statement indicator: default is 'N' if "Generates MT950" is 'Y'
      *
     C                   IF        F15DSI = *Blank AND F1G950 = 'Y'
     C                   EVAL      F15DSI = 'N'
     C                   ENDIF
      *    ----------    ------
     C     @FldDflt      ENDSR

      *========================================================================*
      * $ValidatSc: Validate the screen                                        *
      *------------------------------------------------------------------------*
     C     $ValidatSc    BEGSR
      *    ----------    ------
      ** Call the details 1 screen validation module if Amend or Insert
      *
     C                   IF        ActionCode = 'I' OR ActionCode = 'A'
     C                   CALLB     'ME002241'
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
      /COPY WNCPYSRC,ME002221MV

      ** Call the window manager
      *
     C                   CALL      'WN0010'
     C                   PARM      'ME002221'    WdwPgm           10
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
     C                   EVAL      F0NWRK = NANWRK
     C                   EVAL      F0BRCH = NABRCH
     C                   EVAL      F0CNUM = NACNUM
     C                   EVAL      F0CCY  = NACCY
     C                   EVAL      F0ACOD = NAACOD
     C                   EVAL      F0ACSQ = NAACSQ
     C                   EVAL      F0NATY = NANATY

     C                   EXSR      $RtvACCNT

     C                   IF        AC_ACNO <> 0
     C                   MOVEL     AC_ACNO       F0ACNO
     C                   ENDIF
     C                   EVAL      F0ANAM = AC_ANAM
      *------------------
     C                   EVAL      F1G950 = NAG950
     C                   EVAL      F15SFQ = NA5SFQ
     C                   EVAL      F15SDY = NA5SDY
     C                   EVAL      F15DSI = NA5DSI
     C                   EVAL      F15NSD = *Blanks

 B1  C                   IF        NA5NSD <> 0
     C                   MOVEL(P)  NA5NSD        @IDate

     C   98              EVAL      @OFmt = '*MDY'
     C  N98              EVAL      @OFmt = '*DMY'

     C                   CALLB     'ZDATCVT'
     C                   PARM                    @IDate           10
     C                   PARM      *IN98         @IDatTyp          1
     C                   PARM      '*MIDAS'      @IFmt             7
     C                   PARM                    @OFmt             7
     C                   PARM      '*NONE'       @OSep             5
     C                   PARM                    @ODate           10
     C                   PARM                    @RtnCod           1

 B2  C                   IF        @RtnCod = '0'
     C                   EVAL      F15NSD = @ODate
 E2  C                   ENDIF

 E1  C                   ENDIF
      *------------------
     C                   EVAL      FI5LSN = NA5LSN
     C                   EVAL      FI5LST = NA5LST
     C                   EVAL      FI5LCB = *Blanks
     C                   EVAL      FI5LSD = *Blanks

     C                   EXSR      $RtvCURR

     C                   CALLB     'ZSEDIT'
     C                   PARM      NA5LCB        ZFLD15           15 0
     C                   PARM      A6NBDP        ZDECS             1 0
     C                   PARM      *Blank        ZECODE            1
     C                   PARM                    ZOUT21           21
      *
     C                   EVAL      FI5LCB = %Subst(ZOUT21:5:17) + ' '
      *
 B1  C                   IF        %Subst(ZOUT21:21:1) = '-'
     C                   MOVE      'CR'          FI5LCB
 X1  C                   ELSE
     C                   MOVE      'DB'          FI5LCB
 E1  C                   ENDIF

 B1  C                   IF        NA5LSD <> 0
     C                   MOVEL(P)  NA5LSD        @IDate
      *
     C   98              EVAL      @OFmt = '*MDY'
     C  N98              EVAL      @OFmt = '*DMY'
      *
     C                   CALLB     'ZDATCVT'
     C                   PARM                    @IDate
     C                   PARM      *IN98         @IDatTyp
     C                   PARM      '*MIDAS'      @IFmt
     C                   PARM                    @OFmt
     C                   PARM      '*NONE'       @OSep
     C                   PARM                    @ODate
     C                   PARM                    @RtnCod
      *
 B2  C                   IF        @RtnCod = '0'
     C                   EVAL      FI5LSD = @ODate
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
     C/COPY OFCPYSRCZ,CGL146_038                                                              CGL146

      ** Allow F10 key
      *                                                               >><<==
     C     ActionCode    COMP      'D'                                    01

      ** Display the warning mention '**DELETED**'
      *                                                               >><<==
     C     NARECI        COMP      '*'                                    02
      *    ----------    ------
     C     @IniScreen    ENDSR

      *========================================================================*
      * $RtvACCNT : Retrieve an account record                                 *
      *------------------------------------------------------------------------*
     C     $RtvACCNT     BEGSR
      *    ----------    ------
     C                   MOVEL     F0CNUM        @CNUM
     C                   MOVEL     F0ACOD        @ACCD
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
     C                   PARM      F0BRCH        @BRCA             3
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
     C                   EVAL      NAG950 = F1G950
     C                   EVAL      NA5SFQ = F15SFQ
     C                   EVAL      NA5SDY = F15SDY
     C                   EVAL      NA5DSI = F15DSI
     C                   EVAL      NA5NSD = 0

 B1  C                   IF        F15NSD <> *Blanks
     C                   MOVEL(P)  F15NSD        @IDate

     C                   CALLB     'ZDATCVT'
     C                   PARM                    @IDate
     C                   PARM      *IN98         @IDatTyp
     C                   PARM      *Blanks       @IFmt
     C                   PARM      '*MIDAS'      @OFmt
     C                   PARM      '*NONE'       @OSep
     C                   PARM                    @ODate
     C                   PARM                    @RtnCod

 B2  C                   IF        @RtnCod = '0'
     C                   MOVEL     @ODate        NA5NSD
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

      ** Format the screen according to the received action code
      *
     C                   EXSR      $IniScreen

      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks

      ** Retrieve the associated network record
      *
     C                   CALLB     'AONWRKR1'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      F0NWRK        @NWRK             6
     C     DsNWRK        PARM                    DSLDY

     C                   IF        @RtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDNWRKPD'                          *=======*
     C                   EVAL      DBKey  = F0NWRK                              *       *
     C                   EVAL      DBPgm  = ZAPGM                               * Error *
     C                   EVAL      DBase  = 001                                 *       *
     C                   EVAL      DBMod  = PSProcMod                           *  001  *
     C                   EVAL      DBProc = PSProcName                          *       *
     C                   OUT       LDA                                          *=======*
     C                   EXSR      *PSSR
     C                   ENDIF

      ** If the MT950 generation is not allowed by the current network, simply
      ** clear the screen, move the screen fields to the file and exit if the
      ** action code isn't "Delete" (in this later case, the screen must be
      ** displayed - key fields format only - to allow the user to press F10)
      *
     C                   IF        EDM950 <> 'Y'
     C                   CLEAR                   ME002221F1
     C                   MOVE      'N'           F1G950

     C                   IF        ActionCode <> 'D'
     C                   EXSR      $ExitMod
     C                   ENDIF

     C                   ENDIF

      ** Do not display the MT950 detail in enquiry mode if the network account does
      ** not generate MT950.
      *
     C                   IF        ActionCode = 'E'
     C                             AND NAG950 = 'N'
     C                   EXSR      $ExitMod
     C                   ENDIF

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
