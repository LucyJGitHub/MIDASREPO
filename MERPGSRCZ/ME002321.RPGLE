     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network A/c MT94x Dtl Desc.- Detail 1 Scr')   *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002321 - Midas ME Network Account MT94x Details      *
      *                   Description Maintenance (Details 1 Screen   *
      *                   Display - Destination)                      *
      *                                                               *
      *  Function:  This module handles the input and the validation  *
      *             of the first screen of fields of a Network        *
      *             Account MT94x Details.                            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22481           Date 02Feb09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22481 - Field 86 Structure validation field not available *
      *             during Enquire and Amend                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
 
     FME002321DFCF   E             WORKSTN
      ** Midas ME Networks Account MT94x Details Details 1 Screen
      *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Display Conditioning Indicators                               *
      *                                                               *
      * 01 - Allow Use of the F10 Key                                 *
      * 02 - Display the warning mention '**DELETED**'                *
      * 03 - Protect "Generates MT940"                                *
      * 04 - Protect "Generates MT941"                                *
      * 05 - Protect "Generates MT942"                                *
      * 36 - Protect Fields - Prohibit Refresh                        *
      *                                                               *
      * Error Indicators                                              *
      *                                                               *
      * 40 - General Error Indicator                                  *
      * 41 - Destination Description                                  *
      * 42 - Generates MT940                                          *
      * 43 - Generates MT941                                          *
      * 44 - Generates MT942                                          *
      * 45 - Default for Field 86 Structure Validation                *                     BUG22481
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
      /COPY QWINDSRC,ME002321DT
 
     D NewFilRcd     E DS                  EXTNAME(GLNW94PD)
      ** New Network Account MT94x Details File Record (i.e. new state after amendments)
      *
 
     D ScrLayout     E DS                  EXTNAME(ME002321DF:ME002321F1)
      ** Details 1 Screen Layout
      *
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      ** Rundat DS
      *
 
     D DsNWRK        E DS                  EXTNAME(SDNWRKPD)
      ** Network details record format data structure
      *
 
     D DsCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Midas SD Customer Details record layout
      *
 
     D DsCNST        E DS                  EXTNAME(SDCNSTPD)
      ** Midas SD Counterparty Nostro Details record layout
      *
 
     D DsBICD        E DS                  EXTNAME(MEBICDPD)
      ** Midas BIC Directory Details record layout
      *
 
     D DsACCNT       E DS                  EXTNAME(ACCNTAB) PREFIX(AC_)
      ** Account details record format data structure
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
 
      ** Define an array for the non generated messages number
      ** contained in the DsCUST data structure
      *
     D  BBNGEN         S              3A   DIM(15)
     D                                     BASED(Pointer1)
     D  Pointer1       S               *   INZ(%Addr(BBNG01))
 
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
     C                   WRITE     ME002321H0
     C                   WRITE     #MSGCTL
     C                   WRITE     ME002321F0
     C                   EXFMT     ME002321F1
 
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
 
      ** Destination Description: default is the institution name from the
      **                          BIC directory or the customer report name
      *
 B1  C                   IF        F1DSTD = *Blanks
     C                   EVAL      F1DSTD = BDINS1
 
 B2  C                   IF        @ICUST = 'Y'
     C                   EVAL      F1DSTD = BBCRNM
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
      ** Generates MT940: default is 'N'
      *
     C                   IF        F1G940 = *Blank
     C                   EVAL      F1G940 = 'N'
     C                   ENDIF
 
      ** Generates MT941: default is 'N'
      *
     C                   IF        F1G941 = *Blank
     C                   EVAL      F1G941 = 'N'
     C                   ENDIF
 
      ** Generates MT942: default is 'N'
      *
     C                   IF        F1G942 = *Blank
     C                   EVAL      F1G942 = 'N'
     C                   ENDIF
 
      ** Generates MT940: The field may be forced to 'N' and locked if:
      **                  - the network doesn't allow MT940
      **                  - the customer (linked to the destination) doesn't allow MT940
      *
     C     '940'         LOOKUP    BBNGEN                                 99
 
     C                   IF        EDM940 = 'N' OR *IN99
     C                   EVAL      F1G940 = 'N'
     C                   EVAL      *IN03 = *On
     C                   ENDIF
 
      ** Generates MT941: The field may be forced to 'N' and locked if:
      **                  - the network doesn't allow MT941
      **                  - the customer (linked to the destination) doesn't allow MT941
      **                  - the account isn't a Retail or Nostro one
      *
     C     '941'         LOOKUP    BBNGEN                                 99
 
     C                   IF        EDM941 = 'N' OR *IN99 OR
     C                             (AC_ATYP <> 'N' AND AC_ATYP <> 'R')
     C                   EVAL      F1G941 = 'N'
     C                   EVAL      *IN04 = *On
     C                   ENDIF
 
      ** Generates MT942: The field may be forced to 'N' and locked if:
      **                  - the network doesn't allow MT942
      **                  - the customer (linked to the destination) doesn't allow MT942
      **                  - the account isn't a Retail or Nostro one
      *
     C     '942'         LOOKUP    BBNGEN                                 99
 
     C                   IF        EDM942 = 'N' OR *IN99 OR
     C                             (AC_ATYP <> 'N' AND AC_ATYP <> 'R')
     C                   EVAL      F1G942 = 'N'
     C                   EVAL      *IN05 = *On
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
     C                   CALLB     'ME002341'
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
      /COPY WNCPYSRC,ME002321MV
 
      ** Call the window manager
      *
     C                   CALL      'WN0010'
     C                   PARM      'ME002321'    WdwPgm           10
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
     C                   EVAL      F1DSTD = N4DSTD
     C                   EVAL      F1SV86 = N4SV86                                          BUG22481
     C                   EVAL      F1G940 = N4G940
     C                   EVAL      F1G941 = N4G941
     C                   EVAL      F1G942 = N4G942
 
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
     C                   EVAL      N4DSTD = F1DSTD
     C                   EVAL      N4SV86 = F1SV86                                          BUG22481
     C                   EVAL      N4G940 = F1G940
     C                   EVAL      N4G941 = F1G941
     C                   EVAL      N4G942 = F1G942
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
 
      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks
 
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
 
      ** Retrieve the eventual associated customer record
      ** (it may be a BIC Code not linked to a customer)
      *
     C                   MOVEL     N4DSTN        @BICC
     C                   MOVE      N4DSTN        @BICB
 
     C                   CALL      'ME1400'
     C                   PARM      *Blanks       @RtCd                          I:Return code
     C                   PARM                    @BICC             8            I:Bic Code
     C                   PARM                    @BICB             3            I:Bic Branch
     C                   PARM      *Blanks       DsCUST                         O:Customer Detail
     C                   PARM      *Blanks       DsCNST                         O:Counterparty Dtl
     C                   PARM      *Blanks       DsBICD                         O:Bic Directory Dtl
     C                   PARM      *Blanks       @ICUST            1            O:Customer found
     C                   PARM      *Blanks       @ICNST            1            O:Counterparty fd
     C                   PARM      *Blanks       @IBICD            1            O:Bic found
 
     C                   IF        @ICUST <> 'Y'
     C                   CLEAR                   DsCUST
     C                   ENDIF
 
     C                   IF        @IBICD <> 'Y'
     C                   CLEAR                   DsBICD
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
