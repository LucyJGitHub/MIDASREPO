     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME MT941/2 Generation Schedules-Key+Details')    *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002420 - Midas ME Generation Schedules Description   *
      *                   Maintenance (Keys and Details Screen        *
      *                   Display)                                    *
      *                                                               *
      *  Function:  This module handles the input and the validation  *
      *             of the fields of a Generation Schedule.           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD051648           Date 11Sep20               *
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
      *  MD051648 - Network AC MT942 Schedules Maint. -wrong formatted*
      *             start and end time.                               *
      *             Convert time attribute from numeric to alpha-     *
      *             numeric. Also, validate the time field and display*
      *             the error in this program.                        *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************

     FME002420DFCF   E             WORKSTN
      ** Midas ME Generation Schedule Keys and Details Screen Display
      *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Display Conditioning Indicators                               *
      *                                                               *
      * 01 - Allow Use of the F10 Key                                 *
      * 36 - Protect Fields - Prohibit Refresh                        *
      * 98 - Date input format prompt                                 *
      *                                                               *
      * Error Indicators                                              *
      *                                                               *
      * 40 - General Error Indicator                                  *
      * 41 - Start Date                                               *
      * 42 - End Date                                                 *
      * 43 - Period                                                   *
      * 44 - Start Time                                               *
      * 45 - End Time                                                 *
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
      /COPY QWINDSRC,ME002420DT

     D NewFilRcd     E DS                  EXTNAME(GLGS94PD)
      ** New Generation Schedule File Record (i.e. new state after amendments)
      *

     D ScrLayout     E DS                  EXTNAME(ME002420DF:ME002420F1)
      ** Keys and Details Screen Layout
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
     D                 DS                                                                   MD051648
     D  DSHH                   1      2S 0                                                  MD051648
     D  DSCHAR3                3      3A                                                    MD051648
     D  DSMN                   4      5S 0                                                  MD051648
     D  DSHHMN                 1      5A                                                    MD051648
      *                                                                                     MD051648
      ** Data structure for time format 'HH:MN'                                             MD051648
      *                                                                                     MD051648
     D DSTIME          DS                                                                   MD051648
     D  DSTIMEHH               1      2S 0                                                  MD051648
     D  DSTIMEMN               3      4S 0                                                  MD051648
      *                                                                                     MD051648
      ** Data structure for time format 'HHMN'                                              MD051648
      *                                                                                     MD051648

      ** Declared variables
      ** ------------------
      *
     D WValidTime      S              1A                                                    MD051648
     D WX              S              1S 0                                                  MD051648
     D WY              S              1S 0                                                  MD051648
     D WZ              S              1S 0                                                  MD051648
     D WSPOS           S              1S 0                                                  MD051648
     D WEPOS           S              1S 0                                                  MD051648

      ** Error Indicators Array
      *
     D IN40_TO_70      S              1    DIM(31)
     D AHHMN           S              1    DIM(5)                                           MD051648
     D AHHMN2          S              1    DIM(5)                                           MD051648
     D DIGITS          S              1    DIM(10) CTDATA PERRCD(10)                        MD051648

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
     C                   WRITE     ME002420H0
     C                   WRITE     #MSGCTL
     C                   WRITE     ME002420F0
     C                   EXFMT     ME002420F1

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
      ** No defaulting if Delete
      *
     C                   IF        ActionCode = 'D'
     C                   GOTO      @FldDflt
     C                   ENDIF

      ** Start Date: default is the current run date
      *
 B1  C                   IF        F1SDTE = 0
     C                   MOVEL(P)  AGRDNB        @IDate
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
     C                   MOVEL     @ODate        F1SDTE
 E2  C                   ENDIF

 E1  C                   ENDIF

      ** Start Time: default is the current system time
      *
     C**********         IF        F1STIM = 0                                               MD051648
     C                   IF        F1STIM = *BLANKS                                         MD051648
     C                             OR F1STIM = '00:00'                                      MD051648
     C                   TIME                    WFld6N0           6 0
     C**********         MOVEL     WFld6N0       F1STIM                                     MD051648
     C                   MOVEL     WFld6N0       DSTIME                                     MD051648
     C                   EVAL      DSCHAR3 = ':'                                            MD051648
     C                   EXSR      HHMN_HHCMN                                               MD051648
     C                   EVAL      F1STIM = DSHHMN                                          MD051648
     C                   ENDIF
      *                                                                                     MD051648
      ** Initialize to 00:00                                                                MD051648
      *                                                                                     MD051648
     C                   IF        F1ETIM = *BLANKS                                         MD051648
     C                   EVAL      F1ETIM = '00:00'                                         MD051648
     C                   ENDIF                                                              MD051648
      *    ----------    ------
     C     @FldDflt      ENDSR

      *========================================================================*
      * $ValidatSc: Validate the screen                                        *
      *------------------------------------------------------------------------*
     C     $ValidatSc    BEGSR
      *    ----------    ------
      ** Call the keys and details screen validation module if Insert
      *
     C                   IF        ActionCode = 'I'
     C                   EVAL      DSHHMN = F1STIM                                          MD051648
     C                   EXSR      ValidateTime                                             MD051648
     C                   IF        WValidTime = 'Y'                                         MD051648
     C                   IF        AHHMN(3) <> *BLANK                                       MD051648
     C                   MOVEA     AHHMN         F1STIM                                     MD051648
     C                   ENDIF                                                              MD051648
     C                   EVAL      DSHHMN = F1ETIM                                          MD051648
     C                   EXSR      ValidateTime                                             MD051648
     C                   IF        WValidTime = 'Y'                                         MD051648
     C                   IF        AHHMN(3) <> *BLANK                                       MD051648
     C                   MOVEA     AHHMN         F1ETIM                                     MD051648
     C                   ENDIF                                                              MD051648
     C                   CALLB     'ME002440'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut        10
     C                   PARM                    ScrLayout
     C                   PARM                    IN40_TO_70
     C                   PARM                    NewFilRcd
     C                   ELSE                                                               MD051648
      *                                                                                     MD051648
      ** Set on reverse image and cursor position for end time                              MD051648
      *                                                                                     MD051648
     C                   EVAL      IN40_TO_70(6) = '1'                                      MD051648
     C                   ENDIF                                                              MD051648
     C                   ELSE                                                               MD051648
      *                                                                                     MD051648
      ** Set on reverse image and cursor position for start time                            MD051648
      *                                                                                     MD051648
     C                   EVAL      IN40_TO_70(5) = '1'                                      MD051648
     C                   ENDIF                                                              MD051648
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
      /COPY WNCPYSRC,ME002420MV

      ** Call the window manager
      *
     C                   CALL      'WN0010'
     C                   PARM      'ME002420'    WdwPgm           10
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
     C                   EVAL      H0MGTP = 'MT' + GSMTPY
      *------------------
     C                   EVAL      F0NWRK = GSNWRK
     C                   EVAL      F0BRCA = GSBRCA
     C                   EVAL      F0CNUM = GSCNUM
     C                   EVAL      F0CCY  = GSCCY
     C                   EVAL      F0ACCD = GSACCD
     C                   EVAL      F0ACSQ = GSACSQ
     C                   EVAL      F0NATY = GSNATY
     C                   EVAL      F0DSTN = GSDSTN

     C                   EXSR      $RtvACCNT

     C                   IF        AC_ACNO <> 0
     C                   MOVEL     AC_ACNO       F0ACNO
     C                   ENDIF
     C                   EVAL      F0ANAM = AC_ANAM
      *------------------
     C                   EVAL      F1SPRD = GSSPRD
     C**********         EVAL      F1STIM = GSSTIM                                          MD051648
     C**********         EVAL      F1ETIM = GSETIM                                          MD051648
      *                                                                                     MD051648
      ** Convert from HHMN to HH:MN                                                         MD051648
      *                                                                                     MD051648
     C                   EVAL      DSCHAR3 = ':'                                            MD051648
     C                   MOVE      GSSTIM        DSTIME                                     MD051648
     C                   EXSR      HHMN_HHCMN                                               MD051648
     C                   EVAL      F1STIM = DSHHMN                                          MD051648
      **                                                                                    MD051648
     C                   MOVE      GSETIM        DSTIME                                     MD051648
     C                   EXSR      HHMN_HHCMN                                               MD051648
     C                   EVAL      F1ETIM = DSHHMN                                          MD051648

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
     C                   MOVEL     @ODate        F1SDTE
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
     C                   MOVEL     @ODate        F1EDTE
 E2  C                   ENDIF
      *
 E1  C                   ENDIF

      ** Fields defaulting
      *
     C                   EXSR      $FldDflt

      ** Protect fields or not
      *
     C                   IF        ActionCode = 'I'
     C                   EVAL      *IN36 = *Off
     C                   ELSE
     C                   EVAL      *IN36 = *On
     C                   ENDIF

      ** Allow F10 key
      *                                                               >><<==
     C     ActionCode    COMP      'D'                                    01
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
     C                             (ActionCode = 'I')
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
     C                   EVAL      GSSDTE = 0
     C**********         EVAL      GSSTIM = F1STIM                                          MD051648
      *                                                                                     MD051648
      ** Convert from HH:MM to HHMN                                                         MD051648
      *                                                                                     MD051648
     C                   EVAL      DSHHMN = F1STIM                                          MD051648
     C                   EXSR      HHCMN_HHMN                                               MD051648
     C                   MOVE      DSTIME        GSSTIM                                     MD051648
      *                                                                                     MD051648
     C                   EVAL      GSSPRD = F1SPRD
     C                   EVAL      GSEDTE = 0
     C***********        EVAL      GSETIM = F1ETIM                                          MD051648
      *                                                                                     MD051648
      ** Convert from HH:MM to HHMN                                                         MD051648
      *                                                                                     MD051648
     C                   EVAL      DSHHMN = F1ETIM                                          MD051648
     C                   EXSR      HHCMN_HHMN                                               MD051648
     C                   MOVE      DSTIME        GSETIM                                     MD051648

 B1  C                   IF        F1SDTE <> 0
     C                   MOVEL(P)  F1SDTE        @IDate

     C                   CALLB     'ZDATCVT'
     C                   PARM                    @IDate
     C                   PARM      *IN98         @IDatTyp
     C                   PARM      *Blanks       @IFmt
     C                   PARM      '*MIDAS'      @OFmt
     C                   PARM      '*NONE'       @OSep
     C                   PARM                    @ODate
     C                   PARM                    @RtnCod

 B2  C                   IF        @RtnCod = '0'
     C                   MOVEL     @ODate        GSSDTE
 E2  C                   ENDIF

 E1  C                   ENDIF

 B1  C                   IF        F1EDTE <> 0
     C                   MOVEL(P)  F1EDTE        @IDate

     C                   CALLB     'ZDATCVT'
     C                   PARM                    @IDate
     C                   PARM      *IN98         @IDatTyp
     C                   PARM      *Blanks       @IFmt
     C                   PARM      '*MIDAS'      @OFmt
     C                   PARM      '*NONE'       @OSep
     C                   PARM                    @ODate
     C                   PARM                    @RtnCod

 B2  C                   IF        @RtnCod = '0'
     C                   MOVEL     @ODate        GSEDTE
 E2  C                   ENDIF

 E1  C                   ENDIF
      *    ----------    ------
     C     @ScrToFile    ENDSR
                                                                                            MD051648
      *========================================================================*            MD051648
      * HHMN_HHCMN : Convert from HHMN to HH:MN                                *            MD051648
      *========================================================================*            MD051648
     C     HHMN_HHCMN    BEGSR                                                              MD051648
      *    ----------    ------                                                             MD051648
     C                   EVAL      DSHH = DSTIMEHH                                          MD051648
     C                   EVAL      DSMN = DSTIMEMN                                          MD051648
      *    ----------    ------                                                             MD051648
     C                   ENDSR                                                              MD051648
                                                                                            MD051648
      *========================================================================*            MD051648
      * HHCMN_HHMN : Convert from HH:MN to HHMN                                *            MD051648
      *========================================================================*            MD051648
     C     HHCMN_HHMN    BEGSR                                                              MD051648
      *    ----------    ------                                                             MD051648
     C                   EVAL      DSTIMEHH = DSHH                                          MD051648
     C                   EVAL      DSTIMEMN = DSMN                                          MD051648
      *    ----------    ------                                                             MD051648
     C                   ENDSR                                                              MD051648
                                                                                            MD051648
      *========================================================================*            MD051648
      * ValidateTime : Validate Time Inputs                                    *            MD051648
      *========================================================================*            MD051648
     C     ValidateTime  BEGSR                                                              MD051648
      *    ----------    ------                                                             MD051648
     C                   EVAL      WValidTime = 'Y'                                         MD051648
     C                   MOVEA     DSHHMN        AHHMN                                      MD051648
     C                   EVAL      AHHMN2 = *BLANKS                                         MD051648
      *                                                                                     MD051648
      ** Check position 1, 3 and 5, this is invalid 'N---N'                                 MD051648
      *                                                                                     MD051648
     C                   EVAL      WX = 1                                                   MD051648
     C     AHHMN(1)      LOOKUP    DIGITS                                 86                MD051648
     C                   EVAL      WY = 1                                                   MD051648
     C     ':'           LOOKUP    AHHMN(WY)                              87                MD051648
     C                   EVAL      WY = 1                                                   MD051648
     C     ' '           LOOKUP    AHHMN(WY)                              87                MD051648
     C                   EVAL      WZ = 5                                                   MD051648
     C     AHHMN(5)      LOOKUP    DIGITS                                 88                MD051648
      *                                                                                     MD051648
      ** Check 5 position and get start and end position                                    MD051648
      ** sample time entered '--25-'                                                        MD051648
      *                                                                                     MD051648
     C                   EVAL      WSPOS = 1                                                MD051648
     C                   IF        AHHMN(5) = ' '                                           MD051648
     C                   EVAL      WSPOS = 1                                                MD051648
     C                   ELSE                                                               MD051648
     C                   IF        AHHMN(1) = ' '                                           MD051648
     C                   EVAL      WSPOS = 2                                                MD051648
     C                   ELSE                                                               MD051648
     C                   IF        AHHMN(3) <> ':'                                          MD051648
     C                   EVAL      WValidTime = 'N'                                         MD051648
     C                   EVAL      ZAMSID = 'ME00088'                                       MD051648
     C                   EXSR      ZaSndMsg                                                 MD051648
     C                   EVAL      IN40_TO_70(1) = '1'                                      MD051648
     C                   ENDIF                                                              MD051648
     C                   ENDIF                                                              MD051648
     C                   ENDIF                                                              MD051648
      *                                                                                     MD051648
      ** Replace blanks by '0' of time entered if 'NN:NN'                                   MD051648
      *                                                                                     MD051648
     C                   IF        AHHMN(3) = ':'                                           MD051648
     C                   EVAL      WX = 0                                                   MD051648
     C                   DOW       WX < 5                                                   MD051648
     C                   EVAL      WX+=1                                                    MD051648
      *                                                                                     MD051648
     C                   IF        AHHMN(WX) = ' '                                          MD051648
     C                   EVAL      AHHMN(WX) = '0'                                          MD051648
     C                   ENDIF                                                              MD051648
     C                   ENDDO                                                              MD051648
      *                                                                                     MD051648
     C                   ELSE                                                               MD051648
      *                                                                                     MD051648
      ** move 'bHHNN', 'HHNN' to 'HH:MN'                                                    MD056148
      *                                                                                     MD051648
     C                   EVAL      WX = 0                                                   MD051648
     C                   EVAL      WY = WSPOS                                               MD051648
     C                   EVAL      WZ = WEPOS                                               MD051648
     C                   DOW       WX < 5                                                   MD051648
     C                   EVAL      WX+=1                                                    MD051648
      *                                                                                     MD051648
     C                   IF        WX <> 3                                                  MD051648
     C                   IF        AHHMN(WSPOS) = ' '                                       MD051648
     C                   EVAL      AHHMN2(WX) = '0'                                         MD051648
     C                   ELSE                                                               MD051648
     C                   EVAL      AHHMN2(WX) = AHHMN(WSPOS)                                MD051648
     C                   ENDIF                                                              MD051648
     C                   EVAL      WSPOS+=1                                                 MD051648
     C                   ELSE                                                               MD051648
     C                   EVAL      AHHMN2(WX) = ':'                                         MD051648
     C                   ENDIF                                                              MD051648
     C                   ENDDO                                                              MD051648
     C                   EVAL      AHHMN = AHHMN2                                           MD051648
      *                                                                                     MD051648
     C                   ENDIF                                                              MD051648
      *                                                                                     MD051648
      ** Replace blanks by '0' of time entered                                              MD051648
      *                                                                                     MD051648
      ** another validation if time entered is valid                                        MD051648
      *                                                                                     MD051648
     C                   EVAL      WX = 0                                                   MD051648
     C                   DOW       WX < 5                                                   MD051648
     C                   EVAL      WX+=1                                                    MD051648
      *                                                                                     MD051648
      ** Check entered time (valid 0-9), positions 1, 2,4 and 5                             MD051648
      *                                                                                     MD051648
     C                   IF        WX <> 3                                                  MD051648
     C     AHHMN(WX)     LOOKUP    DIGITS                                 89                MD051648
     C                   IF        *IN89 = '0'                                              MD051648
     C                   EVAL      WValidTime = 'N'                                         MD051648
     C                   EVAL      ZAMSID = 'ME00088'                                       MD051648
     C                   EXSR      ZaSndMsg                                                 MD051648
     C                   EVAL      IN40_TO_70(1) = '1'                                      MD051648
     C                   LEAVE                                                              MD051648
     C                   ENDIF                                                              MD051648
     C                   ELSE                                                               MD051648
      *                                                                                     MD051648
      ** Check 3rd position of time entered                                                 MD051648
      *                                                                                     MD051648
     C                   IF        AHHMN(WX) <> ':'                                         MD051648
     C                             AND AHHMN(WX) <> ' '                                     MD051648
     C                   EVAL      WValidTime = 'N'                                         MD051648
     C                   EVAL      ZAMSID = 'ME00088'                                       MD051648
     C                   EXSR      ZaSndMsg                                                 MD051648
     C                   EVAL      IN40_TO_70(1) = '1'                                      MD051648
     C                   LEAVE                                                              MD051648
     C                   ENDIF                                                              MD051648
      *                                                                                     MD051648
      ** Check 3rd position of time entered                                                 MD051648
      *                                                                                     MD051648
     C                   ENDIF                                                              MD051648
     C                   ENDDO                                                              MD051648
      *    ----------    ------                                                             MD051648
     C                   ENDSR                                                              MD051648
      *                                                                                     MD051648
      *========================================================================*            MD051648
      * ZaSndMsg : Send message to the program message queue                   *            MD051648
      *------------------------------------------------------------------------*            MD051648
     C     ZaSndMsg      BEGSR                                                              MD051648
      *    ----------    ------                                                             MD051648
                                                                                            MD051648
     C                   CALL      'Y2SNMGC'                                                MD051648
     C                   PARM                    ZAPGM                                      MD051648
     C                   PARM                    ZAPGRL                                     MD051648
     C                   PARM                    ZAMSID                                     MD051648
     C                   PARM                    ZAMSGF                                     MD051648
     C                   PARM                    ZAMSDA                                     MD051648
     C                   PARM                    ZAMSTP                                     MD051648
      *    ----------    ------                                                             MD051648
     C                   ENDSR                                                              MD051648

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
     C                   MOVEL     'MEMSG'       ZAMSGF           10                        MD051648
     C                   MOVEL     *Blanks       ZAMSID            7                        MD051648
     C                   MOVEL     *Blanks       ZAMSDA          132                        MD051648
     C                   MOVEL     *Blanks       ZAMSTP            7                        MD051648

      ** Retrieve RUNDAT
      *
     C                   IN        RUNDAT
     C     AGDFF         COMP      'M'                                    98

      ** Clear the screen format and the return code
      *
     C                   CLEAR                   ME002420F1
     C                   EVAL      RetCodeOut = *Blanks

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
**   DIGITS                                                                                 MD051648
0123456789
