     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual Repayment input - Browse')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEMAPYBRW - LE Manual Repayment - Browser                    *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of loans for selection,        *
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3114            Date 02Aug04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP077  *CREATE    Date 17Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager. (Recompiled)                  *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP077 - Lending API enhancements - Manual Repayments        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FLEMAPYBDF CF   E             WORKSTN
      ***  Display file.
     F                                     SFILE(LEMAPYS1:@@RRN)
     F                                     SFILE(LEMAPYS2:@@RRN)
      *
     FLELOAML0  IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Live loan amendment details
     F                                     RENAME(LOAMSDKF:LELOAMF0)
      *
     FLELOAML1  IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Loan amendments requiring authorisation
     F                                     RENAME(LOAMSDKF:LELOAMF1)
      *
     FLEMAPYL0  IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Manual Repayment by front office id
     F                                     RENAME(LOAMSDKF:LEMAPYF0)
      *
     FLEMAPYL1  IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Manual Repayment by front office id
     F                                     RENAME(LOAMSDKF:LEMAPYFF1)
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Manual Repayment by front office id
     F                                     Include(CLOANCLF)
     F                                     Prefix(CL_)
      *
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      ***  Table of field numbers and names.
      *
      ********************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
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
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      **-----------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D BackF11         C                   'F11=Toggle Front Office Id.'
     D FrontF11        C                   'F11=Toggle Loan reference'
     D RollMsg         C                   'Roll up/down for further records'
     D NoDataMsg       C                   'No data to display'
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details.
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ***  External DS for General Ledger details.
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ***  External DS for customer details.
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details.
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, SHORT data structure.
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  First DS for access programs, LONG data structure.
 
      ** DS to catch current subfile record
     D CRSfile         DS
     D CROPT                               LIKE(DDOPT)
     D CRLNRF                              LIKE(DDLNRF)
     D CRCUST                              LIKE(DDCUST)
     D CRCSNM                              LIKE(DDCSNM)
     D CRVDAT                              LIKE(DDVDAT)
     D CRSEQN                              LIKE(DDSEQN)
     D CRSAMT                              LIKE(DDSAMT)
     D CRCURR                              LIKE(DDCURR)
     D CRSTAT                              LIKE(DDSTAT)
     D CRRECN                              LIKE(DDRECN)
 
      ** DS to save previous subfile record
     D PRSfile         DS            67
 
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D  ZOUT22         DS            22
     D  ZOUT20                 1     20
      *                                                                                       CLE148
      ** Parameters for calling LELOANISO (Validate Loan Number)                              CLE148
      *                                                                                       CLE148
     D PLNRF           S              6A                                                      CLE148
     D PValid          S              6A                                                      CLE148
     D PChkDigit       S              1A                                                      CLE148
     D PData           S              2A                                                      CLE148
      *                                                                                       CLE148
     D wLoanAlpha      S              1A                                                      CLE148
     D @ERRDTA         S              2A                                                      CLE148
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ***  Initialisation.
      *
     C                   EXSR      INIT
      *
      ***  Build sub-file.
      *
     C     @BDSFL        IFEQ      'Y'
      *
      ***  If First time in or subfile by Midas Manual Repayment was previously
      ***  being run, then build subfile keyed on Midas Manual Repayment
      ***  Stay in loop while F11 toggle key is used.
      *
     C     WFROM         IFNE      'F'
     C     *INKK         DOUEQ     '0'
     C                   EXSR      BLDSFL
      *
      ***  If F11, switch to Front Office subfile.
      *
     C     *INKK         IFEQ      '1'
      *
 
      ** Reset current and previous record number
     C                   EVAL      CRRECN = 0
     C                   EVAL      PRRECN = 0
      *
      ** Reset error record number
     C                   EVAL      WSFRN = 0
      *
      ** Reset error indicator
     C                   Eval      *IN40 = '0'
      *
      ** Clear message subfile
     C                   CALL      'ZA0250'
      *
      **  Re-write msg sfl
     C                   WRITE     LEMAPYM0
     C                   EXSR      BLDSFL2
     C                   END
     C                   END
      *
     C                   ELSE
      *
      ***  If the subfile by Front Office Identifier was previously
      ***  being run, then build subfile keyed on Front Office ID.
      ***  Stay in loop while F11 toggle key is used.
      *
     C     *INKK         DOUEQ     '0'
     C                   EXSR      BLDSFL2
      *
      ***  If F11, switch to Midas Manual Repayment subfile.
      *
     C     *INKK         IFEQ      '1'
      *
      ** Reset error record number
     C                   EVAL      WSFRN = 0
      *
      ** Reset error indicator
     C                   Eval      *IN40 = '0'
      *
      ** Clear message subfile
     C                   CALL      'ZA0250'
      *
      **  Re-write msg sfl
     C                   WRITE     LEMAPYM0
     C                   EXSR      BLDSFL
     C                   END
     C                   END
     C                   END
     C                   END
      *
      ***  Read subfile record.
      *
     C     @RDSFL        IFEQ      'Y'
     C                   EXSR      RDSFLR
     C                   END
      *
      ** Clear message subfile
     C                   CALL      'Y2CLMSC'
     C                   PARM      S#PGMQ        ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      ***  Return
      *
     C                   RETURN
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - Build sub-file                                          *
      ********************************************************************
     C     BLDSFL        BEGSR
      *
      ** If errors detected, redisplay previous subfile with messages
     C                   If        WSFRN > 0
      *
      ** Write the subfile record to the screen to display the invalid
      ** selection with highlighting
     C     WSFRN         CHAIN     LEMAPYS1
     C                   Z-ADD     WSFRN         DDSFRN
     C                   MOVE      *ON           *IN40
     C                   UPDATE    LEMAPYS1
     C                   Z-ADD     SAVRRN        DDRECN
     C                   Z-ADD     SAVRRN        @@RRN
     C                   MOVE      *OFF          *IN40
      *
      ** Reset end of file flag to enable display of subfile.  Use
      ** saved subfile record number to position subfile. Hide
      ** 'Roll up/down' message.
     C                   Eval      @@EOF = ' '
      *
      ** No errors detected, initialise subfile
     C                   Else
      *
      ** Set the F11 text to 'Toggle to FO'
     C                   EVAL      TGLTXT = BackF11
      *
      ***  Set indicator ans flag for Midas (back) office
      ***  Manual Repayment key used.
      *
     C                   MOVE      'B'           WFROM
     C                   MOVE      '0'           *IN20
      *
      ***  Check for user authority to browse if not multi-branching.
      *
     C     BJSBRC        IFNE      *BLANKS
     C                   EXSR      CHAUTN
     C                   END
      *
      ***  Validate Manual Repayment (for pointer).
      *
     C                   EXSR      VALMAPY
      *
      ***  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      ***  Clear subfile before refilling by writing control record
      ***  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     LEMAPYC1
     C                   MOVE      '0'           *IN97
      *
      ***  Write the select screen footer to the screen.
      *
      *
      ***  Set file pointer on key displayed on screen.
      *
     C     DDOPT         IFEQ      'X'
     C     K@LOAM        SETLL     LELOAMF1
     C                   ELSE
     C     K@LOAM        SETLL     LELOAMF0
     C                   END
      *
      ***  Read a valid Manual Repayment
      *
     C                   EXSR      RDMAPY
      *
      ***  If no records exist - set up an error message.
      ***  and terminate
      *
      *
      ***  If no records exist put out no records screen
      *
     C     @@EOF         IFEQ      'Y'
     C                   EVAL      *INKK = *OFF
     C                   EVAL      *INKI = *OFF
     C                   EVAL      TGLTXT2 = NoDataMsg
      *
      ** Do until CMD key pressed
     C     *INKC         DOWNE     *ON
     C     *INKE         ANDNE     *ON
     C     *INKI         ANDNE     *ON
     C     *INKK         ANDNE     *ON
     C     *INKL         ANDNE     *ON
 
      ** Write/read the no records screen, including footer
     C                   WRITE     LEMAPYS3
     C                   WRITE     LEMAPYF1
     C                   READ      LEMAPYS3
     C                   ENDDO
 
      ** If any command keys pressed, need to process them.
     C                   IF        *INKC = '1' or
     C                             *INKE = '1' or
     C                             *INKI = '1' or
     C                             *INKK = '1' or
     C                             *INKL = '1'
     C                   EVAL      @@EOF = ' '
     C                   EVAL      TGLTXT2 = RollMsg
      ** Process F5 as F12 for empty sfl
     C                   IF        *INKE = *ON
     C                   EVAL      *INKL = *ON
     C                   EVAL      *INKE = *OFF
     C                   ENDIF
     C                   GOTO      ReadCmdKey
     C                   ENDIF
     C                   ELSE
     C                   EVAL      TGLTXT2 = RollMsg
     C                   ENDIF
     C                   WRITE     LEMAPYF1
 
      ** End of 'no errors detected, initialise subfile'
     C                   ENDIF
      *
      ***  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      ***  Read records from the file into the subfile until a page has
      ***  been filled or there are no more records.
      ***  Repeat the process until either the end of file, ROLLUP
      ***  has not been entered or F3 or F12 is input.
      *
     C     @@EOF         DOWNE     'Y'
     C     *IN98         ANDEQ     '1'
      *
      ***  If no errors detected, rebuild subfile.
      *
     C                   If        ENTER = *BLANKS
      *
      ***  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      ***  For each record read, write it to the subfile.
      ***  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     13
      *
      ***  Access loan details
      *
     C     k@LOAN        CHAIN     CLOAN                              99
      *
      ***  treat depending Processing type (CLE005)
      *
     C                   If        CLE005 = 'Y' or                              no retriction
     C                             CLE005 <> 'Y' and
     C                             CL_PTYP <> 68 and CL_PTYP <> 69 and
     C                             CL_PTYP <> 71 and CL_PTYP <> 72
     C                             and CL_PTYP <> 80 or                                      BUG3114
     C                             CLE028 = 'Y' and CL_PTYP = 80                             BUG3114
      *
      ***  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ***  Format Manual Repayment fields for output.
      *
     C                   EXSR      FMTFLD
      *
      ***  Write the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   Z-ADD     @@RRN         DDRECN
     C                   WRITE     LEMAPYS1
     C                   endif
      *
      ***  Read next record
      *
     C                   EXSR      RDMAPY
     C                   END
      *
      ***  End of if no errors rebuild sfl.
      *
     C                   Endif
     C                   MOVE      ' '           ENTER
     C                   Z-ADD     @@RRN         SAVRRN
      *
      ***  Write message sfl to screen
      *
     C                   WRITE     LEMAPYM0
      *
      ***  Write the subfile control record to the screen to display
      ***  the subfile.
      *
     C                   Time                    DDTIME
     C                   WRITE     LEMAPYC1
      *
      ***  Read the subfile control record to determine whether records
      ***  have been selected or whether ROLLUP is required.
      *
     C                   READ      LEMAPYC1                               99
      *
     C     ReadCmdKey    TAG
     C     *INKK         IFEQ      '1'
     C                   MOVEL     *BLANKS       DDLNRF
     C                   MOVEL     *BLANKS       DDVDAT
     C                   MOVEL     *BLANKS       DDSEQN
     C                   END
      *
      ***  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F5, refresh
     C     *INKE         IFEQ      '1'
     C                   EVAL      @BDSFL = 'Y'
     C                   EVAL      @RDSFL = ' '
     C                   EVAL      @OPSel = ' '
     C                   EVAL      @INKE = '1'
     C                   ENDIF
      *
      **  If F9, go to insert mode
     C     *INKI         IFEQ      '1'
     C                   EVAL      @OPSel = 'I'
     C                   EVAL      @BDSFL = ' '
     C                   EVAL      @INKI  = '1'
     C                   ENDIF
      *
      ***  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           @INKL
     C                   EVAL      *INKL = *OFF
     C                   EVAL      DDOPT  = *BLANKS
     C                   EVAL      DDLNRF = *BLANKS
     C                   EVAL      DDCUST = *BLANKS
     C                   EVAL      DDCSNM = *BLANKS
     C                   EVAL      DDVDAT = *BLANKS
     C                   EVAL      DDSEQN = *BLANKS
     C                   EVAL      DDSAMT = *BLANKS
     C                   EVAL      DDCURR = *BLANKS
     C                   EVAL      DDSTAT = *BLANKS
     C                   EVAL      PRRECN = 0
     C                   RETURN
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL2 - Build sub-file (For Front Office ID)                   *
      ********************************************************************
     C     BLDSFL2       BEGSR
      *
      ** If errors detected, redisplay previous subfile with messages
     C                   If        WSFRN > 0
      *
      ** Write the subfile record to the screen to display the invalid
      ** selection with highlighting
     C     WSFRN         CHAIN     LEMAPYS2
     C                   Z-ADD     WSFRN         DDSFRN
     C                   MOVE      *ON           *IN40
     C                   UPDATE    LEMAPYS2
     C                   Z-ADD     SAVRRN        DDRECN
     C                   Z-ADD     SAVRRN        @@RRN
     C                   MOVE      *OFF          *IN40
      *
      ** Reset end of file flag to enable display of subfile.  Use
      ** saved subfile record number to position subfile. Hide
      ** 'Roll up/down' message.
     C                   Eval      @@EOF = ' '
      *
      ** No errors detected, initialise subfile
     C                   Else
      *
      * Set the F11 text to 'Toggle to loan ref'
     C                   EVAL      TGLTXT = FrontF11
      *
      ***  Set indicator and flag for front office Id.
      *
     C                   MOVE      'F'           WFROM             1
     C                   MOVE      '1'           *IN20
      *
      ***  Check for user authority to browse if not multi-branching.
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      ***  Validate Manual Repayment (for pointer).
      *
     C                   EXSR      VALMAPY
      *
      ***  Get Front Office Id.
      *
     C     DDOPT         IFEQ      'X'
     C     K@LOAM        CHAIN     LELOAMF1                           89
     C                   ELSE
     C     K@LOAM        CHAIN     LELOAMF0                           89
     C                   END
     C                   MOVE      FRNT          K@FOID           20
     C     *IN89         IFEQ      '1'
     C                   MOVE      *BLANK        K@FOID
     C                   END
      *
      ***  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      ***  Clear subfile before refilling by writing control record
      ***  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     LEMAPYC2
     C                   MOVE      '0'           *IN97
      *
      ***  Write the select screen footer to the screen.
      *
      *
      ***  Set file pointer on key displayed on screen.
      *
     C     DDOPT         IFEQ      'X'
     C     K@FOID        SETLL     LEMAPYFF1
     C                   ELSE
     C     K@FOID        SETLL     LEMAPYF0
     C                   END
      *
      ***  Read a next record
      *
     C                   EXSR      RDMAPY
      *
      ***  If no records exist - set up an error message
      ***  and terminate.
      *
      *
      ***  If no records exist for sfl
      *
     C     @@EOF         IFEQ      'Y'
     C                   EVAL      *INKK = *OFF
     C                   EVAL      *INKI = *OFF
     C                   EVAL      TGLTXT2 = NoDataMsg
      *
      ** Do until CMD key pressed
     C     *INKC         DOWNE     *ON
     C     *INKE         ANDNE     *ON
     C     *INKI         ANDNE     *ON
     C     *INKK         ANDNE     *ON
     C     *INKL         ANDNE     *ON
 
      ** Write/read the no records screen, including footer
     C                   WRITE     LEMAPYS4
     C                   WRITE     LEMAPYF1
     C                   READ      LEMAPYS4
     C                   ENDDO
 
      ** If any command keys pressed, need to process them.
     C                   IF        *INKC = '1' or
     C                             *INKE = '1' or
     C                             *INKI = '1' or
     C                             *INKK = '1' or
     C                             *INKL = '1'
     C                   EVAL      @@EOF = ' '
     C                   EVAL      TGLTXT2 = RollMsg
      ** Process F5 as F12 for empty sfl
     C                   IF        *INKE = *ON
     C                   EVAL      *INKL = *ON
     C                   EVAL      *INKE = *OFF
     C                   ENDIF
     C                   GOTO      ReadCmdKey2
     C                   ENDIF
     C                   ELSE
     C                   EVAL      TGLTXT2 = RollMsg
     C                   ENDIF
     C                   WRITE     LEMAPYF1
 
      ** End of 'no errors detected, initialise subfile'
     C                   ENDIF
      *
      ***  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      ***  Read records from the file into the subfile until a page has
      ***  been filled or there are no more records.
      ***  Repeat the process until either the end of file, ROLLUP
      ***  has not been entered or F3 or F12 is input.
      *
     C     @@EOF         DOWNE     'Y'
     C     *IN98         ANDEQ     '1'
      *
      ***  If no errors detected, rebuild subfile.
      *
     C                   If        ENTER = *BLANKS
      *
      ***  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      ***  For each record read, write it to the subfile.
      ***  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     13
      *
      ***  Access loan details
      *
     C     k@LOAN        CHAIN     CLOAN                              99
      *
      ***  treat depending Processing type (CLE005)
      *
     C                   If        CLE005 = 'Y' or                              no retriction
     C                             CLE005 <> 'Y' and
     C                             CL_PTYP <> 68 and CL_PTYP <> 69 and
     C                             CL_PTYP <> 71 and CL_PTYP <> 72
     C                             and CL_PTYP <> 80 or                                      BUG3114
     C                             CLE028 = 'Y' and CL_PTYP = 80                             BUG3114
      *
      ***  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ***  Format fields for output.
      *
     C                   EXSR      FMTFLD
      *
      ***  Write the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   Z-ADD     @@RRN         DDRECN
     C                   WRITE     LEMAPYS2
     C                   endif
      *
      ***  Read a next record
      *
     C                   EXSR      RDMAPY
      *
      ***  If no records exist for sfl
     C                   END
      *
      ***  End of if no errors rebuild sfl.
      *
     C                   Endif
     C                   MOVE      ' '           ENTER
     C                   Z-ADD     @@RRN         SAVRRN            4 0
      *
      ***  Write message sfl to screen
      *
     C                   WRITE     LEMAPYM0
      *
      ***  Write the subfile control record to the screen to display
      ***  the subfile.
      *
     C                   WRITE     LEMAPYC2
      *
      ***  Read the subfile control record to determine whether records
      ***  have been selected or whether ROLLUP is required.
      *
     C                   READ      LEMAPYC2                               99
      *
     C     ReadCmdKey2   TAG
     C     *INKK         IFEQ      '1'
     C                   MOVEL     *BLANKS       DDLNRF
     C                   MOVEL     *BLANKS       DDVDAT
     C                   MOVEL     *BLANKS       DDSEQN
     C                   END
      *
      ***  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F5, refresh
     C     *INKE         IFEQ      '1'
     C                   EVAL      @BDSFL = 'Y'
     C                   EVAL      @RDSFL = ' '
     C                   EVAL      @OPSel = ' '
     C                   EVAL      @INKE = '1'
     C                   ENDIF
      *
      **  If F9, go to insert mode
     C     *INKI         IFEQ      '1'
     C                   EVAL      @OPSel = 'I'
     C                   EVAL      @BDSFL = ' '
     C                   EVAL      @INKI  = '1'
     C                   ENDIF
      *
      ***  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           @INKL
     C                   EVAL      *INKL = *OFF
     C                   EVAL      DDOPT      = *BLANKS
     C                   EVAL      DDFOTRANID = *BLANKS
     C                   EVAL      DDLNRF     = *BLANKS
     C                   EVAL      DDCUST     = *BLANKS
     C                   EVAL      DDVDAT     = *BLANKS
     C                   EVAL      DDSEQN     = *BLANKS
     C                   EVAL      DDSAMT     = *BLANKS
     C                   EVAL      DDCURR     = *BLANKS
     C                   EVAL      PRRECN     = 0
     C                   RETURN
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - Read sub-file record.                                   *
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      ***  Read the subfile for selected records.
      ***  Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
     C     WFROM         IFNE      'F'
     C                   READC     LEMAPYS1                               99
      **  If the previous read was successful (the record has changed),
      **  or if the option has been cleared, reset the selection to clear
      **  any error highlighting.  Also save & restore previous READC.
     C                   If        DDRECN <> PRRECN and
     C                             PRRECN > 0       or
     C                             DDOPT = *BLANK   and
     C                             *IN99 = '0'
     C                   EXSR      SavCurSfl
     C                   MOVEL     CRSfile       PRSfile
     C     PRRECN        CHAIN     LEMAPYS1
     C                   MOVE      *BLANK        DDOPT
     C                   UPDATE    LEMAPYS1
     C     CRRECN        CHAIN     LEMAPYS1
     C                   MOVEL     PRSfile       CRSfile
     C                   MOVE      CROPT         DDOPT
     C                   Z-ADD     CRRECN        PRRECN
     C                   ENDIF
     C                   ELSE
     C                   READC     LEMAPYS2                               99
      **  If the previous read was successful (the record has changed),
      **  or if the option has been cleared, reset the selection to clear
      **  any error highlighting.  Also save & restore previous READC.
     C                   If        DDRECN <> PRRECN and
     C                             PRRECN > 0       or
     C                             DDOPT = *BLANK   and
     C                             *IN99 = '0'
     C                   EXSR      SavCurSfl
     C                   MOVEL     CRSfile       PRSfile
     C     PRRECN        CHAIN     LEMAPYS2
     C                   MOVE      *BLANK        DDOPT
     C                   UPDATE    LEMAPYS2
     C     CRRECN        CHAIN     LEMAPYS2
     C                   MOVEL     PRSfile       CRSfile
     C                   MOVE      CROPT         DDOPT
     C                   Z-ADD     CRRECN        PRRECN
     C                   ENDIF
     C                   END
     C                   END
      *
      ***  Return the selected Manual Repayment and option.
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'R'
     C     DDOPT         OREQ      'X'
     C                   MOVE      DDOPT         @OPSEL
     C                   ELSE
     C                   MOVE      'E'           @OPSEL
     C                   END
      *
     C                   MOVE      DDLNRF        @LNSEL
     C                   MOVE      DDSEQN        @SQSEL
     C                   MOVE      DDVDAT        @VDSEL
      *
      * Save the record number
     C                   Z-ADD     DDRECN        PRRECN            4 0
     C                   EXSR      SavCurSfl
      *
      **  If no selection made, clear details
     C                   ELSE
     C                   EVAL      @OPSel = ' '
     C                   Z-ADD     0             PRRECN
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * SavCurSfl - Save current sfl record details.                     *
      ********************************************************************
     C     SavCurSfl     BEGSR
      *
 
     C                   EVAL      CROPT  = DDOPT
     C                   EVAL      CRLNRF = DDLNRF
     C                   EVAL      CRCUST = DDCUST
     C                   EVAL      CRCSNM = DDCSNM
     C                   EVAL      CRVDAT = DDVDAT
     C                   EVAL      CRSEQN = DDSEQN
     C                   EVAL      CRSAMT = DDSAMT
     C                   EVAL      CRCURR = DDCURR
     C                   EVAL      CRSTAT = DDSTAT
     C                   EVAL      CRRECN = DDRECN
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * FMTFLD - Format fields for output.                               *
      ********************************************************************
     C     FMTFLD        BEGSR
      *
      ***  Front Office Loan number.
      *
     C                   MOVEL     FRNT          DDFOTRANID
      *
      ***  Loan number.
      *
     C                   MOVE      LNRF          DDLNRF
      *
      ***  Value date
      *
     C                   MOVEL     *BLANKS       DDVDAT
     C     VDAT          IFNE      *ZERO
     C                   Z-ADD     VDAT          ZDAYNO            5 0
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZDATE         DDVDAT
     C                   ENDIF
      *
      ***  Sequence
      *
     C                   MOVE      LASN          DDSEQN
      *
      ***  Customer number.
      *
     C                   If        CL_PTYP = 64 or CL_PTYP = 65
     C                   MOVE      CL_OLNO       DDCUST
     C                   Else
     C                   MOVE      CNUM          DDCUST
     C                   endif
      *
      ***  Customer shortname.
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCUST        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'UNKNOWN'     DDCSNM
     C                   ELSE
     C                   MOVEL     BBCSSN        DDCSNM
     C                   ENDIF
     C
      ***  Currency
      *
     C                   MOVEL     CL_CCY        DDCURR                         Loan Currency
      *
      ***  Amount
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      CL_CCY        @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     CL_CPAM       ZFLD15           15 0          Loan Curr. Princ
      *
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM      'J'           ZECODE            1
     C                   PARM      *BLANKS       ZOUT22           22
     C                   PARM      *BLANKS       ZOUT25           25
      *
     C                   MOVE      Zout20        DDSAMT
      *
      ***  Loan Amendment status
      *
     C                   SELECT
     C     ASTS          WHENEQ    'C'
     C                   MOVEL     'LEM0060'     ZAMSID
     C     ASTS          WHENEQ    'A'
     C                   MOVEL     'LEM0062'     ZAMSID
     C     ASTS          WHENEQ    'R'
     C                   MOVEL     'LEM0061'     ZAMSID
     C     ASTS          WHENEQ    'D'
     C                   MOVEL     'LEM0063'     ZAMSID
     C                   ENDSL
      *
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDSTAT
     C                   MOVE      *BLANKS       ZAMSID
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDMAPY - Read a repayment shedule                                *
      ********************************************************************
     C     RDMAPY        BEGSR
      *
      ***  Reset End of File indicator.
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      ***  Read the file initially - if @@EOF is set on then the end of
      ***  the file has been reached.  Read until a valid record is
      ***  found or until no more records exist.
      *
     C     @@EOF         DOUEQ     'Y'
     C     ASTS          ORNE      'D'
     C     AMTP          ANDEQ     'MR'
     C     @@ERR         ANDEQ     *ZERO
      *
      ***  Read the file.
      *
     C     WFROM         IFEQ      'B'
     C     DDOPT         IFEQ      'X'
     C                   READ      LELOAMF1                               96
     C                   ELSE
     C                   READ      LELOAMF0                               96
     C                   END
     C                   ELSE
     C     DDOPT         IFEQ      'X'
     C                   READ      LEMAPYFF1                              96
     C                   ELSE
     C                   READ      LEMAPYF0                               96
     C                   END
     C                   END
      *
      ***  End of File.
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
      *
      ***  If Manual Repayment read, check whether user can see it.
      *
     C     @@EOF         IFNE      'Y'
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C     BKOBUV        IFEQ      'Y'
     C     @@ERR         ANDEQ     *ZERO
     C                   CALL      'ZVOBU'
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C                   END
     C                   END
     C                   END
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * CHAUTN - Check for user authority if not multi-branching.        *
      ********************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ***  Return error message.
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'LES0607'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * VALMAPY- Validate loan number pointer.                           *
      ********************************************************************
     C     VALMAPY       BEGSR
      *
      ***  Validate that the loan number is numeric or blank.
      *
     C                   TESTN                   DDLNRF               98
     C                   MOVE      DDLNRF        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C*****DDLNRF        IFEQ      *BLANKS                                                    CLE148
     C******IN98         OREQ      '1'                                                        CLE148
     C******IN99         ANDEQ     '1'                                                        CLE148
     C**********         MOVE      DDLNRF        K@LNRF            6 0                        CLE148
      *
      *****Return*error*message****************************************                       CLE148
      *
     C**********         ELSE                                                                 CLE148
     C**********         MOVEL     'LES0608'     @ERRMS                                       CLE148
     C**********         RETURN                                                               CLE148
     C**********         END                                                                  CLE148
      *                                                                                       CLE148
     C                   IF        wLoanAlpha = 'Y'                                           CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   EVAL      PLNRF = DDLNRF                                             CLE148
     C                   EVAL      PValid = *BLANKS                                           CLE148
     C                   EVAL      PChkDigit = *BLANK                                         CLE148
     C                   EVAL      PData = *BLANKS                                            CLE148
     C                   CALL(E)   'LELOANISO'   P_LELOANISO                                  CLE148
      *                                                                                       CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        DDLNRF = *BLANKS                                           CLE148
     C                              OR (wLoanAlpha = 'N' AND *IN98 = *ON                      CLE148
     C                              AND *IN99 = *ON) OR (wLoanAlpha = 'Y'                     CLE148
     C                              AND PValid = *BLANKS)                                     CLE148
     C                   MOVEL     DDLNRF        K@LNRF                                       CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
     C                   IF        wLoanAlpha = 'N'                                           CLE148
     C                   MOVEL     '5045550'     @ERRMS                                       CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
     C                   MOVEL     '5045548'     @ERRMS                                       CLE148
     C                   MOVEL     PData         @ERRDTA                                      CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   RETURN                                                               CLE148
     C                   ENDIF                                                                CLE148
      *
      ***  Validate that the sequence is numeric or blank.
      *
     C                   TESTN                   DDSEQN               98
     C                   MOVE      DDSEQN        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     DDSEQN        IFEQ      *BLANKS
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C                   MOVE      DDSEQN        K@SEQN            3 0
      *
      ***  Return error message
      *
     C                   ELSE
     C                   MOVEL     'LES0609'     @ERRMS
     C                   RETURN
     C                   END
      *
      ***  Validate that the value date is valid or blank.
      *
     C                   MOVE      DDVDAT        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
      *
     C     ZERR          IFEQ      *BLANKS
     C     DDVDAT        OREQ      *BLANKS
     C                   MOVE      ZDAYNO        K@VDAT            5 0
      *
      ***  Return error message
      *
     C                   ELSE
     C                   MOVEL     'LES0610'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * SRTEXT  -  Set up text from message file.                        *
      ********************************************************************
     C     SRTEXT        BEGSR
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM      'LERMSGF '    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP          132            Messge text
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ERRMSG  - Output error messages without data                  *
      *                                                               *
      *****************************************************************
     C     ERRMSG        BEGSR
      *
      *  Display error message
     C                   CALL      'Y2SNMGC'
     C                   PARM      'LEMAPYBRW'   ZAPGMQ           10
     C                   PARM                    ZAPGRL
     C                   PARM                    ZMSID             7
     C                   PARM                    ZMSGF            10
     C                   PARM                    ZMSDA           132
     C                   PARM                    ZMSTP             7
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * INIT - Initialisation.                                           *
      ********************************************************************
     C     INIT          BEGSR
 
      *  Reset error indicator
     C                   Eval      *IN40 = '0'
 
      *  If build sub-file is 'Y', set up error messages and screen defaults
     C     @BDSFL        IFEQ      'Y'
 
      *  Reset record in error details/F11 toggle key
     C                   Z-ADD     0             WSFRN             4 0
     C                   MOVE      '0'           *INKK
      *
      *  Do while error messages found
      *  Write error messages (with or without data) to subfile
     C                   Z-ADD     1             C                 2 0
      *
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C     MsgIdArr(C)   IFNE      *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZMSID             7
     C                   MOVEL     MsgDtaArr(C)  ZMSDA
     C                   EXSR      ERRMSG
     C                   ENDIF
     C                   ADD       1             C
     C                   ENDDO
      *
      *  Do while warning messages found
      *  Write warning messages (with or without data) to subfile
     C                   Z-ADD     1             C
      *
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  ZMSID             7
     C                   MOVEL     WMsgDtaArr(C) ZMSDA
     C                   EXSR      ERRMSG
     C                   ADD       1             C
     C                   ENDDO
      *
      * If errors / warnings returned, redisplay subfile
     C                   If        FldNameArr(1) <> *BLANKS or
     C                             WFldNamArr(1) <> *BLANKS
     C                   Z-ADD     DDRECN        WSFRN
     C                   MOVE      'Y'           ENTER             1
     C                   ELSE
     C                   MOVE      ' '           ENTER
     C                   EndIf
      *
      ***  Clear outputs.
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @ERRDTA                                      CLE148
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @LNSEL
     C                   MOVE      *BLANK        @VDSEL
     C                   MOVE      *BLANK        @SQSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
     C                   MOVE      '0'           *IN20
      *
      ***  Clear previous sfl record number work field
      *
     C                   EVAL      PRRECN = 0
     C                   EndIf
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * *INZSR - Initial processing.                                     *
      ********************************************************************
     C     *INZSR        BEGSR
      *
      ***  Parameters.
      *
     C     *ENTRY        PLIST
      *
      ***  INPUT parameters.
      *
     C                   PARM                    RetCodeIn                      Return code.
     C                   PARM                    DDOPT                          Action code.
     C                   PARM                    DDLNRF                         Loan number pointer.
     C                   PARM                    DDVDAT                         Value date pointer.
     C                   PARM                    DDSEQN                         Sequence pointer.
     C                   PARM                    @BDSFL            1            Build sub-file.
     C                   PARM                    @RDSFL            1            Read sub-file record
      *
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  OUTPUT parameters.
      *
     C                   PARM                    wLoanAlpha                                   CLE148
     C                   PARM                    @ERRMS            7            Error message.
     C                   PARM                    @ERRDTA                                      CLE148
     C                   PARM                    @OPSEL            1            Option selected.
     C                   PARM                    @LNSEL            6            Loan number selected
     C                   PARM                    @VDSEL            6            Value date selected.
     C                   PARM                    @SQSEL            3            Sequence selected.
     C                   PARM                    @INKC             1            Command keys.
     C                   PARM                    @INKE             1            Command keys.
     C                   PARM                    @INKI             1            Command keys.
     C                   PARM                    @INKL             1
     C                   PARM                    CLE005            1            Feature CLE005
      *
      ***  Initialise program name.
      *
     C                   MOVEL     'LEMAPYBRW'   DBPGM
      *
      ***  Move workstation ID to screen field.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
      * Message subfile control
     C                   MOVEL     '*'           S#PGMQ
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     'LERMSGF'     ZMSGF            10
     C                   EVAL      *IN94 = *ON
      *
      ***  Access bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Access general Ledger details.
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '003'         DBASE                          * DBERR 003 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *                                                                                      BUG3114
      ** Access Switchable SAR details for the existence of CLE028                           BUG3114
      *                                                                                      BUG3114
     C                   CALLB     'AOSARDR0'                                                BUG3114
     C                   PARM      *BLANK        @RTCD                                       BUG3114
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3114
     C                   PARM      'CLE028'      @SARD                                       BUG3114
      *                                                                                      BUG3114
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3114
     C                   MOVE      'Y'           CLE028            1                         BUG3114
     C                   ELSE                                                                BUG3114
     C                   MOVE      'N'           CLE028                                      BUG3114
     C                   ENDIF                                                               BUG3114
      *
      *** KLIST for LOAMSDK and LEMAPYPD access
      *
     C     K@LOAM        KLIST
     C**********         KFLD                    K@LNRF            6 0                        CLE148
     C                   KFLD                    K@LNRF            6                          CLE148
     C                   KFLD                    K@VDAT            5 0
     C                   KFLD                    K@SEQN            3 0
      *
      *** KLIST for CLOAN
      *
     C     K@LOAN        KLIST
     C                   KFLD                    LNRF                           Loan ref of LOAM
      *                                                                                       CLE148
      ** Parameter list for calling LELOANISO                                                 CLE148
      *                                                                                       CLE148
     C     P_LELOANISO   PLIST                                                                CLE148
      *                                                                                       CLE148
      ** Loan Number (Input)                                                                  CLE148
      *                                                                                       CLE148
     C                   PARM                    PLNRF                                        CLE148
      *                                                                                       CLE148
      ** Validity Flags (Output)                                                              CLE148
      *                                                                                       CLE148
     C                   PARM                    PValid                                       CLE148
      *                                                                                       CLE148
      ** Check Digit (Output)                                                                 CLE148
      *                                                                                       CLE148
     C                   PARM                    PChkDigit                                    CLE148
     C                   PARM                    PData                                        CLE148
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
