     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network Description - Details 1 Screen')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200121 - Midas SD Network Description Maintenance    *
      *                   (Details 1 Screen Display - Network)        *
      *                                                               *
      *  Function:  This module handles the input and the validation  *
      *             of the first screen of fields of a Network record.*
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. EML104             Date 05Feb20               *
      *  Prev Amend No. CMG008             Date 20Feb20               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL152             Date 02Dec13               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26393           Date 12Oct09               *
      *                 BUG25800A          Date 16Sep09               *
      *                 BUG25800           Date 03Sep09               *
      *                 BUG22805           Date 10Feb09               *
      *                 BUG22253           Date 16Jan09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL013  *CREATE    Date 25Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML104 - Upgrade EML010 to FB Midas 2.1 SP21                 *
      *           Structured field :86:                               *
      *           Add EML104_023, EML104_024, EML104_025, EML104_026  *
      *  CMG008 - SWIFT Character Translation Table                   *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL152 - Include Transaction Type Identification Code on     *
      *           MT940/MT950 (Recompile)                             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26393 - Account Number Format should still be available   *
      *             when CER030 is OFF (Recompile)                    *
      *  BUG25800A - Input field is visible in MidasPlus (Recompile)  *
      *  BUG25800 - Missing subfield 4 - field 61 of MT940            *
      *             at regression test (Recompile)                    *
      *  BUG22805 - Invalid Transaction type code for SWIFT           *
      *  BUG22253 - Redisplay the correct Transaction Type Length     *
      *  CER030 - Multicash German Feature                            *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************

     FSD200121DFCF   E             WORKSTN
      ** Midas SD Networks Details 1 Screen Display
      *

      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Display Conditioning Indicators                                        *
      *                                                                        *
      * 01 - Allow Use of the F10 Key                                          *
      * 02 - Display the warning mention '**DELETED**'                         *
      * 36 - Protect Fields - Prohibit Refresh                                 *
      *                                                                        *
      * Error Indicators                                                       *
      *                                                                        *
      * 40 - General Error Indicator                                           *
      * 41 - Network Description                                               *
      * 42 - Protocol Type                                                     *
      * 43 - Allow MT940 Generation                                            *
      * 44 - Allow MT941 Generation                                            *
      * 45 - Allow MT942 Generation                                            *
      * 46 - Allow MT950 Generation                                            *
      * 48 - Allow Multiple Destinations for MT94x                             *
      * 49 - Allow Extended Narrative                                          *
      * 50 - Retention Period for Schedule Request                             *
      * 51 - Prevent Automatic Submission at Start of Business                 *
      * 52 - Prevent Automatic Submission if Non-Working Day                   *
      * (The DS IN40_TO_70 is used to cover the whole set of reserved error    *
      *  indicators)                                                           *
      *                                                                        *
      * Subfile Management Indicators                                          *
      *                                                                        *
      * 23 - SFLEND (Messages Subfile)                                         *
      *                                                                        *
      * Action key Indicators                                                  *
      *                                                                        *
      * KC - Exit Program                                                      *
      * KE - Refresh Screen                                                    *
      * KJ - Confirm Deletion                                                  *
      * KL - Previous Screen                                                   *
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

      ** Data to be passed to the window controller
      *
      /COPY QWINDSRC,SD200121DT

     D NewFilRcd     E DS                  EXTNAME(SDNWRKPD)
      ** New Network File Record (i.e. new state after amendments)
      *

     D ScrLayout     E DS                  EXTNAME(SD200121DF:SD200121F1)
      ** Details 1 Screen Layout
      *

     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *

      ** Declared variables
      ** ------------------
      *

      ** Error Indicators Array
      *
     D IN40_TO_70      S              1    DIM(31)
      *                                                                                       CER030
      ** Fields added for CER030                                                              CER030
      *                                                                                       CER030
     D PRtcd           S              7A                                                      CER030
     D POptn           S              7A                                                      CER030
     D PSard           S              6A                                                      CER030
     D WNwrk           S              6A                                                      CER030
     D CER030          S              1A                                                      CER030
     D KNwrk           S              6A                                                      CER030
     D KTrCd           S             10A                                                      CER030
     D PNwrk           S              6A                                                      CER030
     D PBasNw          S              6A                                                      CER030
     D PCopy           S              1A                                                      CER030
     D W1trtp          S              2A                                                    BUG22253
     D CMG008          S              1A                                                      CMG008
      *                                                                                       CER030
      ** External DS for SAR Details                                                          CER030
      *                                                                                       CER030
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER030
      *                                                                                       CER030
      ** Short data structure                                                                 CER030
      *                                                                                       CER030
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER030

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
     C                   WRITE     SD200121H0
     C                   WRITE     #MSGCTL
     C                   WRITE     SD200121F0
     C                   EXFMT     SD200121F1

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
      *                                                                                       CER030
      ** For Multicash call the program to copy the GVC codes to the                          CER030
      ** valid file from the deliverable file                                                 CER030
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' AND *IN40 = *OFF AND                          CER030
     C                             ActionCode <> 'D' AND                                      CER030
     C                             ActionCode <> 'E' AND                                      CER030
     C                             D1MCNW <> EDMCNW                                           CER030
     C                             AND F0NWRK <> 'SWIFT'                                    BUG22805
      *                                                                                       CER030
     C                   EVAL      PBasNw = 'MTCASH'                                          CER030
     C                   EVAL      PNwrk = F0NWRK                                             CER030
     C                   EVAL      PCopy = D1MCNW                                             CER030
      *                                                                                       CER030
     C/COPY WNCPYSRC,EML104_023                                                               EML104
     C                   CALL      'SD200099'                                                 CER030
     C                   PARM                    PBasNw                                       CER030
     C                   PARM                    PNwrk                                        CER030
     C                   PARM                    PCopy                                        CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030

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

      ** Allow MT940 generation: 'Y' if protocol *SWIFT, otherwise 'N'
      *
     C                   IF        F1M940 = *Blank AND F1PROT <> *Blanks

     C                   IF        F1PROT = '*SWIFT'
     C                   EVAL      F1M940 = 'Y'
     C                   ELSE
     C                   EVAL      F1M940 = 'N'
     C                   ENDIF

     C                   ENDIF

      ** Allow MT941 generation: 'Y' if protocol *SWIFT, otherwise 'N'
      *
     C                   IF        F1M941 = *Blank AND F1PROT <> *Blanks

     C                   IF        F1PROT = '*SWIFT'
     C                   EVAL      F1M941 = 'Y'
     C                   ELSE
     C                   EVAL      F1M941 = 'N'
     C                   ENDIF

     C                   ENDIF

      ** Allow MT942 generation: 'Y' if protocol *SWIFT, otherwise 'N'
      *
     C                   IF        F1M942 = *Blank AND F1PROT <> *Blanks

     C                   IF        F1PROT = '*SWIFT'
     C                   EVAL      F1M942 = 'Y'
     C                   ELSE
     C                   EVAL      F1M942 = 'N'
     C                   ENDIF

     C                   ENDIF

      ** Allow MT950 generation: 'Y' if protocol *SWIFT, otherwise 'N'
      *
     C                   IF        F1M950 = *Blank AND F1PROT <> *Blanks

     C                   IF        F1PROT = '*SWIFT'
     C                   EVAL      F1M950 = 'Y'
     C                   ELSE
     C                   EVAL      F1M950 = 'N'
     C                   ENDIF

     C                   ENDIF


      ** Allow multiple destinations for MT94x: default is 'N'
      *
     C                   IF        F1AMDS = *Blank
     C                   EVAL      F1AMDS = 'N'
     C                   ENDIF

      ** Allow extended narrative: default is 'N'
      *
     C                   IF        F1ENRA = *Blank
     C                   EVAL      F1ENRA = 'N'
     C                   ENDIF

      ** Prevent automatic submission at start of business: default is 'N'
      *
     C                   IF        F1PASS = *Blank
     C                   EVAL      F1PASS = 'N'
     C                   ENDIF

      ** Prevent automatic submission if non-working day: default is 'Y'
      *
     C                   IF        F1PASN = *Blank
     C                   EVAL      F1PASN = 'Y'
     C                   ENDIF
     C/COPY WNCPYSRC,EML104_024                                                               EML104
      *                                                                                       CER030
      ** Length of alternate Transaction type: Default is 3 (Multicash                        CER030
      ** and SWIFT)                                                                           CER030
      *                                                                                       CER030
     C                   IF        (D1TRTP = *ZEROS OR D1TRTP = *BLANKS) AND                  CER030
     C                             (EDNWRK = 'SWIFT' OR D1MCNW =  'Y')                        CER030
     C                   EVAL      D1TRTP = '03'                                              CER030
     C                   ENDIF                                                                CER030
      ** Allow Non-SWIFT Character Conversion: default is 'N'
      *
     C                   IF        D1CONV = *Blank
     C                   EVAL      D1CONV = 'N'
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
     C                   CALLB     'SD200141'
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
      /COPY WNCPYSRC,SD200121MV

      ** Call the window manager
      *
     C                   CALL      'WN0010'
     C                   PARM      'SD200121'    WdwPgm           10
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
     C/COPY WNCPYSRC,EML104_025                                                               EML104

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
     C                   EVAL      F0NWRK = EDNWRK

     C                   EVAL      F1NETD = EDNETD
     C                   EVAL      F1PROT = EDPROT
     C                   EVAL      F1M940 = EDM940
     C                   EVAL      F1M941 = EDM941
     C                   EVAL      F1M942 = EDM942
     C                   EVAL      F1M950 = EDM950
     C                   EVAL      F1AMDS = EDAMDS
     C                   EVAL      F1ENRA = EDENRA
     C                   EVAL      F1RPSR = EDRPSR
     C                   EVAL      F1PASS = EDPASS
     C                   EVAL      F1PASN = EDPASN
     C                   MOVEL     EDTRTP        D1TRTP                                       CER030
     C                   EVAL      D1ACNF = EDACNF                                            CER030
     C                   EVAL      D1MCNW = EDMCNW                                            CER030
     C                   EVAL      D1CONV = EDCONV                                            CMG008

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

      ** Allow F10 key
      *                                                               >><<==
     C     ActionCode    COMP      'D'                                    01

      ** Display the warning mention '**DELETED**'
      *                                                               >><<==
     C     EDTYLC        COMP      'D'                                    02
      *    ----------    ------
     C     @IniScreen    ENDSR

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
     C                   EVAL      EDNETD = F1NETD
     C                   EVAL      EDPROT = F1PROT
     C                   EVAL      EDM940 = F1M940
     C                   EVAL      EDM941 = F1M941
     C                   EVAL      EDM942 = F1M942
     C                   EVAL      EDM950 = F1M950
     C                   EVAL      EDAMDS = F1AMDS
     C                   EVAL      EDENRA = F1ENRA
     C                   EVAL      EDRPSR = F1RPSR
     C                   EVAL      EDPASS = F1PASS
     C                   EVAL      EDPASN = F1PASN
     C**********         MOVE      D1TRTP        EDTRTP                              CER030 BUG22253
     C                   EVALR     W1trtp = %TRIMR(D1TRTP)                                  BUG22253
     C                   MOVE      W1trtp        EDTRTP                                     BUG22253
     C                   EVAL      EDACNF = D1ACNF                                            CER030
     C                   EVAL      EDMCNW = D1MCNW                                            CER030
     C                   EVAL      EDCONV = D1CONV                                            CMG008
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

      ** Format the screen according to the received action code
      *
     C                   EXSR      $IniScreen

      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks
      *                                                                                       CER030
     C                   EVAL      CER030 = 'N'                                               CER030
     C                   EVAL      *IN88 = *OFF                                               CER030
      *                                                                                       CER030
      ** Check the switchable feature CER030 with the corresponding                           CER030
      ** parameters.                                                                          CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** Database error (return code other than *NRF and blanks)                              CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF' AND                                        CER030
     C                             PRtcd <> *BLANKS                                           CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 1                                                  CER030
     C                   EVAL      DBKEY = PSard                                              CER030
     C                   OUT       LDA                                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   EVAL      *IN88 = *ON                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** KList for SDNTCDL0                                                                   CER030
      *                                                                                       CER030
     C     KNtCd         KLIST                                                                CER030
     C                   KFLD                    KNwrk                                        CER030
     C                   KFLD                    KTrCd                                        CER030
      *                                                                                       CER030
                                                                                              CMG008
      ** Check if feature CMG008 is installed                                                 CMG008
                                                                                              CMG008
     C                   EVAL      CMG008 = 'N'                                               CMG008
     C                   EVAL      *IN89 = *OFF                                               CMG008
                                                                                              CMG008
     C                   CALL      'AOSARDR0'                                                 CMG008
     C                   PARM      *BLANKS       PRtcd                          Return Code   CMG008
     C                   PARM      '*VERIFY'     POptn                          Option        CMG008
     C                   PARM      'CMG008 '     PSard                          Feature Ref   CMG008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CMG008
                                                                                              CMG008
     C                   IF        PRtcd = *BLANKS                                            CMG008
     C                   EVAL      CMG008 = 'Y'                                               CMG008
     C                   EVAL      *IN89 = *ON                                                CMG008
     C                   ENDIF                                                                CMG008
     C/COPY WNCPYSRC,EML104_026                                                               EML104
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

     C                   CALLB     'DBERRCTL'

     C                   MOVEL(P)  '*ERROR'      RetCodeOut
     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR

      *========================================================================*
**  CPY@
(c) Finastra International Limited 2002
