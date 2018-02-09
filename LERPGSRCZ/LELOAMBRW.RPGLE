     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan amendments browse')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELOAMBRW - Loan amendments browse                           *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One displays a list of loan amendments for        *
      *             selection, the other picks off the selection made.*
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
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 222729             Date 17Oct03               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP075  *CREATE    Date 09Aug02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager.(Recompiled)                   *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  222729 - Don't show 'Requires Release' if CLE030 is off      *
      *  CLE030 - Release authorisation processing                    *
      *  CAP075 - Lending API enhancements - loan amendments          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLELOAMBDF CF   E             WORKSTN
     F                                     SFILE(LELOAMS1:@@RRN)
     F                                     SFILE(LELOAMS3:@@RRN)
 
      * Loan amendments file - by loan/value date/seqn
     FLELOAML8  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LOAMSDKF:LELNRFL0)
 
      * Loan amendments file - by front office id
     FLELOAMLA  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LOAMSDKF:LEFOIDL0)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **-----------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
     D wLoanAlpha      S              1A                                                      CLE148
     D PLNRF           S              6A                                                      CLE148
     D PValid          S              6A                                                      CLE148
     D PChkDigit       S              1A                                                      CLE148
     D PData           S              2A                                                      CLE148
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D BackF11         C                   'F11=Toggle Front Office Id.'
     D FrontF11        C                   'F11=Toggle Loan reference'
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array for amendment type narratives
     D LATP            S             21    DIM(6) CTDATA PERRCD(1)
 
      ** External DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** DS for access programs, long DS
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** ¦ Note that this module uses logic-cycle processing; it will     ¦
      ** ¦ repeat the main processing until 'return' is specified.  It    ¦
      ** ¦ will also only execute the *INZSR once, on activation, not     ¦
      ** ¦ every time it is called.                                       ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Reset return parameters
     C                   EXSR      RESET
      *
      ** Build sub-file
     C     @BDSFL        DOWEQ     'Y'
      *
      **  Build subfile keyed on Midas loan number key / front office id
      **  as appropriate.
     C     WLOAN         IFEQ      'B'
     C                   EXSR      BLDSFL
     C                   ENDIF
      *
     C     WLOAN         IFEQ      'F'
     C     @BDSFL        ANDEQ     'Y'
     C                   EXSR      BLDSFL2
     C                   ENDIF
 
     C                   ENDDO
      *
      ** Read sub-file record - unless there are no transactions present
     C     @RDSFL        IFEQ      'Y'
     C     *IN80         ANDEQ     '0'
     C                   EXSR      RDSFLR
     C                   ENDIF
      *
      ** Clear message subfile
     C                   CALL      'ZA0250'
      *
      ** Set 'review from' to current value
     C                   EVAL      DDRLON = SLLOAN
      *
      ** Return
     C                   RETURN
      *
      *******************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - Build sub-file
      ********************************************************************
     C     BLDSFL        BEGSR
      *
      ** If errors detected, redisplay previous subfile with messages
     C                   If        *IN40 = '1'
      *
      ** Write the subfile record to the screen to display the invalid
      ** selection with highlighting. Use  saved subfile record number
      ** to position subfile.
     C     S#RECN        CHAIN     LELOAMS1
     C                   Z-ADD     S#RECN        S#SFRN
     C                   UPDATE    LELOAMS1
      *
      ** Reset end of file flag to enable display of subfile. Hide
      ** 'Roll up/down' message.
     C                   Eval      @@EOF = ' '
     C                   Eval      *IN81 = '0'
      *
      ** No errors detected, initialise subfile
     C                   Else
      *
      ** Set the F11 text to 'Toggle to FO'
     C                   EVAL      TGLTXT = BackF11
      *
      ** Check for user authority to browse if not multi-branching
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      ** Validate loan number / value date / sequence no. combination.
     C                   EXSR      VALKEY
      *
      ** If the 'review from' field is in error, redisplay subfile with
      ** message
     C     *IN31         IFEQ      '1'
     C                   EXSR      ERRMSG
     C                   ELSE
      *
      ** Initialise subfile relative record number.
     C                   Z-ADD     0             @@RRN             5 0
      *
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
     C                   MOVE      '1'           *IN97
     C                   WRITE     LELOAMS0
     C                   MOVE      '0'           *IN97
      *
      ** Set file pointer on key displayed on screen.
     C     @LNKEY        SETLL     LELNRFL0
      *
      ** Read a valid loan amendment
     C                   EXSR      RDLOAM
      *
      ** If no records exist - set up an error message.
     C     @@EOF         COMP      'Y'                                    80
     C     @@EOF         IFEQ      'Y'
 
      ** Write/read the no records screen, including footer
     C                   MOVE      '0'           *IN81
     C                   WRITE     LELOAMS4
     C                   WRITE     LELOAMF1
     C                   READ      LELOAMS4
 
      ** If any command keys pressed, need to process them.
     C                   IF        *INKC = '1' or
     C                             *INKE = '1' or
     C                             *INKI = '1' or
     C                             *INKK = '1' or
     C                             *INKL = '1' or
     C                             SLLOAN <> WRLON or
     C                             S#RAUT <> DDRAUT
     C                   EVAL      @@EOF = ' '
     C                   GOTO      ReadCmdKey
     C                   ENDIF
     C                   ENDIF
 
      ** End of error on 'Review from'
     C                   ENDIF
 
      ** End of 'no errors detected, initialise subfile'
     C                   ENDIF
      *
      ** Set on ROLLUP indicator to drive initial loop.
     C                   MOVE      '1'           *IN98
      *
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3/F11/F12 is input.
     C     @@EOF         DOWNE     'Y'
     C     WLOAN         ANDEQ     'B'
     C     *IN98         ANDEQ     '1'
      *
      ** If no errors detected, rebuild subfile
     C                   If        *IN40 = '0' and
     C                             *IN31 = '0'
      *
      ** Initialise count of records written to subfile page.
     C                   Z-ADD     0             @@CNT             3 0
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     13
      *
      ** Increment the subfile record no. and records written fields.
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format loan amendment fields for output
     C                   EXSR      FMTLOAM
      *
      ** Write the loan amendment to the subfile.
     C                   MOVE      *BLANK        S#OPT
     C                   Z-ADD     @@RRN         S#SFRN
     C                   Z-ADD     @@RRN         S#RECN
     C                   WRITE     LELOAMS1
      *
      ** Read a valid loan amendment
     C                   EXSR      RDLOAM
     C                   ENDDO
      *
      ** Retrieve time
     C                   TIME                    S#TIME
      *
      ** If roll is valid, display message
     C     @@CNT         IFEQ      13
     C     @@EOF         ANDNE     'Y'
     C                   Eval      MoreRec =  'Y'
     C                   ENDIF
     C     MoreRec       COMP      'Y'                                    81
      *
      ** End of bypass rebuild if error
     C                   ENDIF
      *
      ** Write message subfile and footer screen
     C                   WRITE     LELOAMM0
     C                   WRITE     LELOAMF1
      *
      ** Write the subfile control record to the screen to display
      ** the subfile.
     C                   WRITE     LELOAMS0
      *
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
     C                   READ      LELOAMS0                               99
      *
      ** If F3, bypass further processing.
     C     ReadCmdKey    TAG
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      ** If F5, refresh
     C     *INKE         IFEQ      '1'
     C                   EVAL      *INKE = '0'
     C                   EXSR      Refresh
     C                   GOTO      EndBLDSFL
     C                   ENDIF
      *
      ** If F9, go to insert mode
     C     *INKI         IFEQ      '1'
     C                   EVAL      *INKI = '0'
     C                   EVAL      @OPSel = 'I'
     C                   EVAL      @BDSFL = ' '
     C                   GOTO      EndBLDSFL
     C                   ENDIF
      *
      ** If F11, toggle to front office id. subfile
     C     *INKK         IFEQ      '1'
     C                   EVAL      *INKK = '0'
     C                   EVAL      WLOAN = 'F'
     C                   EXSR      Refresh
     C                   GOTO      EndBLDSFL
     C                   ENDIF
      *
      ** If F12, bypass further processing.
     C     *INKL         IFEQ      '1'
     C                   EVAL      *INKL = '0'
     C                   MOVE      '1'           @INKL
     C                   EVAL      @BDSFL = ' '
     C                   GOTO      EndBLDSFL
     C                   ENDIF
      *
      ** If 'Unauthorised Only?' has changed, rebuild subfile
     C     S#RAUT        IFNE      DDRAUT
     C     S#RAUT        ORNE      'Y'
     C     S#RAUT        ANDNE     'N'
      *
     C                   MOVEL     S#RAUT        WRAUT             1
     C                   EXSR      Refresh
     C                   Eval      S#RAUT = WRAUT
     C                   Eval      DDRAUT = WRAUT
      *
      ** 'Unauthorised Only?' field must be 'Y' or 'N' only
     C     S#RAUT        IFNE      'Y'
     C     S#RAUT        ANDNE     'N'
     C                   Eval      ZMSID = 'LEA1011'
     C                   Eval      *IN36 = '1'
     C                   EXSR      ERRMSG
     C                   ENDIF
     C                   GOTO      EndBLDSFL
     C                   ENDIF
      *
      ** If position to field has changed, rebuild subfile
     C                   IF        SLLOAN <> WRLON
     C                   MOVEL     SLLOAN        WRLON             6
     C                   EXSR      Refresh
     C                   MOVEL     WRLON         SLLOAN
     C                   MOVEL     *BLANKS       WRLON
     C                   GOTO      EndBLDSFL
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** If enter pressed, exit build loop and go to read
     C                   EVAL      @BDSFL = ' '
     C                   EVAL      @RDSFL = 'Y'
      *
     C     EndBLDSFL     ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL2 - Build sub-file (For Front Office ID)
      ********************************************************************
     C     BLDSFL2       BEGSR
      *
      ** If errors detected, redisplay previous subfile with messages
     C                   If        *IN40 = '1'
      *
      ** Write the subfile record to the screen to display the invalid
      ** selection with highlighting
     C     S#RECN        CHAIN     LELOAMS3
     C                   Z-ADD     S#RECN        S#SFRN
     C                   UPDATE    LELOAMS3
      *
      ** Reset end of file flag to enable display of subfile.  Use
      ** saved subfile record number to position subfile. Hide
      ** 'Roll up/down' message.
     C                   Eval      @@EOF = ' '
     C                   Eval      *IN81 = '0'
      *
      ** No errors detected, initialise subfile
     C                   Else
      *
      ** Set the F11 text to 'Toggle to loan ref'
     C                   EVAL      TGLTXT = FrontF11
      *
      ** Check for user authority to browse if not multi-branching
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      ** If position to front office id requested, use that; otherwise
      ** check for loan key details and get FO id that way
     C     SLFRNT        IFNE      *BLANK
     C     SLFRNT        ORNE      WFRNT
     C                   MOVEL     SLFRNT        @@FOID
     C                   MOVEL     SLFRNT        WFRNT
     C                   EndIf
      *
     C     @@FOID        IFEQ      *BLANK
      *
      ** Validate loan number / value date / sequence no. combination.
     C                   EXSR      VALKEY
      *
      ** Get Front Office Id
     C     @LNKEY        CHAIN     LELNRFL0                           89
 
     C     *IN89         IFEQ      '0'
     C                   MOVEL     FRNT          @@FOID           20
     C                   ENDIF
     C                   ENDIF
      *
      ** Initialise subfile relative record number.
     C                   Z-ADD     0             @@RRN             5 0
      *
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
     C                   MOVE      '1'           *IN97
     C                   WRITE     LELOAMS2
     C                   MOVE      '0'           *IN97
      *
      ** Set file pointer on key displayed on screen.
     C     @@FOID        SETLL     LEFOIDL0
      *
      ** Read a valid loan amendment
     C                   EXSR      RDLOAM
      *
      ** If no records exist - set up an error message.
     C     @@EOF         COMP      'Y'                                    80
     C     @@EOF         IFEQ      'Y'
      *
      ** Write/read the no records screen, including footer
     C                   MOVE      '0'           *IN81
     C                   WRITE     LELOAMS5
     C                   WRITE     LELOAMF1
     C                   READ      LELOAMS5
 
      ** If any command keys pressed, need to process them.
     C                   IF        *INKC = '1' or
     C                             *INKE = '1' or
     C                             *INKI = '1' or
     C                             *INKK = '1' or
     C                             *INKL = '1' or
     C                             SLFRNT <> WFRNT or
     C                             S#RAUT <> DDRAUT
     C                   EVAL      @@EOF = ' '
     C                   GOTO      ReadCmdKey2
     C                   ENDIF
     C                   ENDIF
      *
      ** End of 'No errors detected, initialise subfile'
     C                   ENDIF
      *
      ** Set on ROLLUP indicator to drive initial loop.
     C                   MOVE      '1'           *IN98
      *
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, or any key
      ** other than Rollup has been entered.
     C     @@EOF         DOWNE     'Y'
     C     WLOAN         ANDEQ     'F'
     C     *IN98         ANDEQ     '1'
      *
      ** If no errors detected, rebuild subfile
     C                   If        *IN40 = '0'
      *
      ** Initialise count of records written to subfile page.
     C                   Z-ADD     0             @@CNT             3 0
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     13
      *
      ** Increment the subfile record no. and records written fields.
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format loan amendment fields for output
     C                   EXSR      FMTLOAM
      *
      ** Write the loan amendment to the subfile.
     C                   MOVE      *BLANK        S#OPT
     C                   Z-ADD     @@RRN         S#SFRN
     C                   Z-ADD     @@RRN         S#RECN
     C                   WRITE     LELOAMS3
      *
      ** Read a valid loan amendment
     C                   EXSR      RDLOAM
     C                   ENDDO
      *
      ** Retrieve time
     C                   TIME                    S#TIME
      *
      ** If roll is valid, display message
     C     @@CNT         IFEQ      13
     C     @@EOF         ANDNE     'Y'
     C                   Eval      MoreRec =  'Y'
     C                   ENDIF
     C     MoreRec       COMP      'Y'                                    81
      *
      ** End of bypass rebuild if error
     C                   ENDIF
      *
      ** Write message subfile and footer screen
     C                   WRITE     LELOAMM0
     C                   WRITE     LELOAMF1
      *
      ** Write the subfile control record to the screen to display
      ** the subfile.
     C                   WRITE     LELOAMS2
      *
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
     C                   READ      LELOAMS2                               99
      *
      ** If F3, bypass further processing.
     C     ReadCmdKey2   TAG
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
      ** If F5, refresh
     C     *INKE         IFEQ      '1'
     C                   EVAL      *INKE = '0'
     C                   EXSR      Refresh
     C                   GOTO      EndBLDSFL2
     C                   ENDIF
      *
      ** If F9, go to insert mode
     C     *INKI         IFEQ      '1'
     C                   EVAL      *INKI = '0'
     C                   EVAL      @OPSel = 'I'
     C                   EVAL      @BDSFL = ' '
     C                   GOTO      EndBLDSFL2
     C                   ENDIF
      *
      ** If F11, toggle to loan reference subfile
     C     *INKK         IFEQ      '1'
     C                   EVAL      *INKK = '0'
     C                   EVAL      WLOAN = 'B'
     C                   EXSR      Refresh
     C                   GOTO      EndBLDSFL2
     C                   ENDIF
      *
      ** If F12, bypass further processing.
     C     *INKL         IFEQ      '1'
     C                   EVAL      *INKL = '0'
     C                   MOVEL     '1'           @INKL
     C                   EVAL      @BDSFL = ' '
     C                   GOTO      EndBLDSFL2
     C                   ENDIF
      *
      ** If 'Unauthorised Only?' has changed, rebuild subfile
     C     S#RAUT        IFNE      DDRAUT
     C     S#RAUT        ORNE      'Y'
     C     S#RAUT        ANDNE     'N'
      *
     C                   Eval      WRAUT = S#RAUT
     C                   EXSR      Refresh
     C                   Eval      S#RAUT = WRAUT
     C                   Eval      DDRAUT = WRAUT
      *
      ** 'Unauthorised Only?' field must be 'Y' or 'N' only
     C     S#RAUT        IFNE      'Y'
     C     S#RAUT        ANDNE     'N'
     C                   Eval      ZMSID = 'LEA1011'
     C                   Eval      *IN36 = '1'
     C                   EXSR      ERRMSG
     C                   ENDIF
     C                   GOTO      EndBLDSFL2
     C                   ENDIF
      *
      ** If position to field has changed, rebuild subfile
     C                   IF        SLFRNT <> WFRNT
     C                   MOVEL     SLFRNT        WFRNT            20
     C                   EXSR      Refresh
     C                   MOVEL     WFRNT         SLFRNT
     C                   MOVEL     *BLANKS       WFRNT
     C                   GOTO      EndBLDSFL2
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** If enter pressed, exit build loop and go to read
     C                   EVAL      @BDSFL = ' '
     C                   EVAL      @RDSFL = 'Y'
      *
     C     EndBLDSFL2    ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - Read sub-file record
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      ** Read the subfile for selected records
     C     WLOAN         IFEQ      'B'
      *
      ** Read until a selection found
     C                   DOU       S#OPT <> *BLANK or
     C                             *IN99 = '1'
     C                   READC     LELOAMS1                               99
      *
      **  If the previous read was successful (the record has changed),
      **  or if the option has been cleared, reset the selection to clear
      **  any error highlighting.  Also save & restore previous READC.
     C                   If        S#RECN <> P#RECN and
     C                             P#RECN > 0       and
     C                             *IN40 = '0'      or
     C                             S#OPT = *BLANK   and
     C                             *IN99 = '0'
      *
      ** Reset error indicator
     C                   Eval      *IN40 = '0'
     C                   Z-ADD     S#RECN        C#RECN            4 0
     C     P#RECN        CHAIN     LELOAMS1
     C                   MOVE      *BLANK        S#OPT
     C                   UPDATE    LELOAMS1
     C     C#RECN        CHAIN     LELOAMS1
     C                   Z-ADD     S#RECN        P#RECN
     C                   ENDIF
 
     C                   ENDDO
      *
      ** Front office mode
     C                   ELSE
      *
      ** Read until a selection found
     C                   DOU       S#OPT <> *BLANK or
     C                             *IN99 = '1'
     C                   READC     LELOAMS3                               99
      *
      **  If the previous read was successful (the record has changed),
      **  or if the option has been cleared, reset the previous selection
      **  to clear any error highlighting, then repostion to current READC.
     C                   If        S#RECN <> P#RECN and
     C                             P#RECN > 0       and
     C                             *IN40 = '0'      or
     C                             S#OPT = *BLANK   and
     C                             *IN99 = '0'
      *
      ** Reset error indicator
     C                   Eval      *IN40 = '0'
     C                   Z-ADD     S#RECN        C#RECN
     C     P#RECN        CHAIN     LELOAMS3
     C                   MOVE      *BLANK        S#OPT
     C                   UPDATE    LELOAMS3
     C     C#RECN        CHAIN     LELOAMS3
     C                   Z-ADD     S#RECN        P#RECN
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDIF
      *
      **  Return the selected option
     C     *IN99         IFNE      '1'
     C     S#OPT         ANDNE     *BLANK
      *
     C     S#OPT         IFEQ      'A'
     C     S#OPT         OREQ      'R'
     C     S#OPT         OREQ      'X'
     C     S#OPT         OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVE      S#OPT         @OPSEL
     C                   ELSE
     C                   MOVE      'E'           @OPSEL
     C                   ENDIF
      *
      **  Send details back
     C                   EVAL      @LNSel = S#LOAN
     C                   EVAL      @VDSel = S#VDAT
     C                   EVAL      @SQSel = S#SEQN
     C                   EVAL      @ATSel = S#ATYP
      *
      * Save the record number
     C                   Z-ADD     S#RECN        P#RECN            4 0
      *
      **  If no selection made, clear details
     C                   ELSE
     C                   EVAL      @OPSel = ' '
     C                   Z-ADD     0             P#RECN
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTLOAM - Format loan amendment fields for output
      ******************************************************************
     C     FMTLOAM       BEGSR
      *
      * Loan number
     C                   MOVEL     LNRF          S#LOAN
      *
      * Customer number / name
     C                   MOVEL     CNUM          S#CUST
     C                   MOVEL     CNUM          AOCUST
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       AORTCD            7
     C                   PARM      '*KEY   '     AOOPTN            7
     C                   PARM                    AOCUST           10
     C                   PARM      *BLANKS       AOKYST            7
     C     SDCUST        PARM                    DSSDY
      *
     C     AORTCD        IFEQ      *BLANKS
     C                   MOVEL(P)  BBCSSN        S#CSNM
     C                   ELSE
     C                   MOVE      *BLANKS       S#CSNM
     C                   ENDIF
      *
      * Value date
     C                   CALLB     'ZDATE2'
     C                   PARM      VDAT          ZDAYNO            5 0
     C                   PARM      BJDFIN        DateFmt           1
     C                   PARM                    ZDATEN            6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZDATEN        S#VDAT
     C                   MOVEL     ZADATE        S#VDTA
      *
      * Sequence
     C                   MOVEL     LASN          S#SEQN
      *
      * Loan amendment status
     C                   EXSR      SRSTAT
      *
      * Loan amendment narrative
     C                   SELECT
     C     AMTP          WHENEQ    'PI'
     C                   MOVEL     LATP(1)       S#ATXT
     C     AMTP          WHENEQ    'SC'
     C                   MOVEL     LATP(2)       S#ATXT
     C     AMTP          WHENEQ    'BC'
     C                   MOVEL     LATP(3)       S#ATXT
     C     AMTP          WHENEQ    'SA'
     C                   MOVEL     LATP(4)       S#ATXT
     C     AMTP          WHENEQ    'LS'
     C                   MOVEL     LATP(5)       S#ATXT
     C     AMTP          WHENEQ    'PD'
     C                   MOVEL     LATP(6)       S#ATXT
     C                   ENDSL
      *
      * Loan amendment type
     C                   EVAL      S#ATYP = AMTP
      *
      * Front Office Id
     C                   EVAL      S#FRNT = FRNT
      *
     C                   ENDSR
      ******************************************************************
      /EJECT
      *****************************************************************
      * RDLOAM - Read loan amendment
      *****************************************************************
     C     RDLOAM        BEGSR
      *
      ** Reset End of File / valid record read indicators
     C                   MOVE      *BLANK        @@EOF             1
     C                   MOVE      'N'           @Valid            1
     C                   MOVE      '0'           *IN96
      *
      ** Read until end of file or until a valid record read
     C                   DOw       @@EOF = *BLANK and
     C                             @Valid = 'N'
      *
      ** Read a file depending on mode
     C     WLOAN         IFEQ      'B'
      *
      ** Position to loan number / value date / sequence number
     C                   IF        SLLOAN <> *BLANKS and
     C                             SLLOAN <> WRLON
     C                   EVAL      WRLON = SLLOAN
     C**********         EVAL      @LOAN = 0                                                  CLE148
     C                   EVAL      @LOAN = *BLANKS                                            CLE148
     C                   EVAL      @VDAT = 0
     C                   EVAL      @SEQN = 0
 
      ***Test*whether*the*loan*number*is*numeric.**********************                       CLE148
     C**********         TESTN                   SLLOAN               98                      CLE148
     C******IN98         IFEQ      '1'                                                        CLE148
     C                   MOVEL     SLLOAN        @LOAN
     C**********         ENDIF                                                                CLE148
     C     @LNKEY        SETLL     LELNRFL0                           96
     C                   ENDIF
 
     C                   READ      LELNRFL0                               96
     C                   ELSE
      *
     C                   READ      LEFOIDL0                               96
     C                   ENDIF
      *
      ** End of File
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   ENDIF
      *
      ** Check for valid record - if reauthorisation required
     C                   MOVE      'Y'           @Valid
     C                   IF        DDRAUT = 'Y' and
     C                             RECI  <> 'R'
     C                   IF        ASTS  <> 'R' and
     C                             ASTS <> 'C'  and
     C                             ASTS <> 'Q'
     C                   MOVE      'N'           @Valid
     C                   EndIf
     C                   EndIf
      *
      ** Check for valid record - valid amendment type
     C                   IF        AMTP <> 'PI' and
     C                             AMTP <> 'SC' and
     C                             AMTP <> 'BC' and
     C                             AMTP <> 'SA' and
     C                             AMTP <> 'LS' and
     C                             AMTP <> 'PD'
     C                   MOVE      'N'           @Valid
     C                   EndIf
      *
      ** Check for valid record - should not be reversed
     C                   IF        ASTS = 'D'
     C                   MOVE      'N'           @Valid
     C                   EndIf
     C                   EndDo
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - Check for authority to browse if not multi-branching
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * Return error message
     C     @@ERR         IFEQ      1
     C                   MOVEL     'LEV9003'     RetCodeIn
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALKEY - Validate loan amendment key fields and position
      *          to requested amendment on file
      *****************************************************************
     C     VALKEY        BEGSR
 
      ** Test whether the 'position to' loan number is numeric.
     C                   MOVE      '0'           *IN31
     C     ' ':'0'       XLATE     SLLOAN        W#RLON            6
     C                   TESTN                   W#RLON               98
     C******IN98         IFEQ      '1'                                                        CLE148
     C*****SLLOAN        ANDNE     *BLANKS                                                    CLE148
     C**********         MOVEL     W#RLON        @LOAN                                        CLE148
     C**********         MOVEL     W#RLON        SLLOAN                                       CLE148
     C**********         MOVEL     W#RLON        WRLON                                        CLE148
     C**********         ELSE                                                                 CLE148
      *
      ***If*the*'position*to'*loan*number*is*neither*blank*nor*numeric,                       CLE148
      ***display*error*message*****************************************                       CLE148
     C*****SLLOAN        IFNE      *BLANKS                                                    CLE148
     C**********         MOVEL     'LEL0601'     ZMSID                                        CLE148
     C**********         MOVE      '1'           *IN31                                        CLE148
     C**********         GOTO      EndValKey                                                  CLE148
     C**********         ELSE                                                                 CLE148
      *
      ***If*the*'position*to'*loan*number*is*blank,*check*whether*the**                       CLE148
      ***input*loan*number*is*numeric*or*blank.************************                       CLE148
     C**********         TESTN                   DDLOAN               98                      CLE148
     C*****DDLOAN        IFEQ      *BLANKS                                                    CLE148
     C**********         Z-ADD     *LOVAL        @LOAN             6 0                        CLE148
     C**********         ELSE                                                                 CLE148
     C******IN98         IFEQ      '1'                                                        CLE148
     C**********         MOVE      DDLOAN        @LOAN             6 0                        CLE148
     C**********         MOVE      *BLANKS       DDLOAN                                       CLE148
      *
      **Return*error*message*******************************************                       CLE148
     C**********         ELSE                                                                 CLE148
     C**********         MOVEL     'LEL0601'     RetCodeIn                                    CLE148
     C**********         RETURN                                                               CLE148
     C**********         ENDIF                                                                CLE148
     C**********         ENDIF                                                                CLE148
     C**********         ENDIF                                                                CLE148
     C**********         ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        wLoanAlpha = 'Y'                                           CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   CALL(E)   'LELOANISO'                                                CLE148
     C                   PARM      W#RLON        PLNRF                                        CLE148
     C                   PARM      *BLANKS       PValid                                       CLE148
     C                   PARM      *BLANKS       PChkDigit                                    CLE148
     C                   PARM      *BLANKS       PData                                        CLE148
      *                                                                                       CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C     *IN98         IFEQ      '1'                                                        CLE148
     C     SLLOAN        ANDNE     *BLANKS                                                    CLE148
     C     wLoanAlpha    ANDEQ     'N'                                                        CLE148
     C     PValid        OREQ      *BLANKS                                                    CLE148
     C     SLLOAN        ANDNE     *BLANKS                                                    CLE148
     C     wLoanAlpha    ANDEQ     'Y'                                                        CLE148
     C                   MOVEL     W#RLON        @LOAN                                        CLE148
     C                   MOVEL     W#RLON        SLLOAN                                       CLE148
     C                   MOVEL     W#RLON        WRLON                                        CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
     C     SLLOAN        IFNE      *BLANKS                                                    CLE148
     C     wLoanAlpha    IFEQ      'N'                                                        CLE148
     C                   MOVEL     '5045550'     ZMSID                                        CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVEL     '5045548'     ZMSID                                        CLE148
     C                   MOVEL     PData         ZMSDA                                        CLE148
     C                   ENDIF                                                                CLE148
     C                   MOVE      '1'           *IN31                                        CLE148
     C                   GOTO      EndValKey                                                  CLE148
      *                                                                                       CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
     C                   IF        wLoanAlpha = 'Y'                                           CLE148
     C                   CALL      'LELOANISO'                                                CLE148
     C                   PARM      DDLOAN        PLNRF                                        CLE148
     C                   PARM      *BLANKS       PValid                                       CLE148
     C                   PARM      *BLANK        PChkDigit                                    CLE148
     C                   PARM      *BLANKS       PData                                        CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C     DDLOAN        IFEQ      *BLANKS                                                    CLE148
     C                   MOVEL     *LOVAL        @LOAN                                        CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
     C     *IN98         IFEQ      '1'                                                        CLE148
     C     wLoanAlpha    ANDEQ     'N'                                                        CLE148
     C     PValid        OREQ      *BLANKS                                                    CLE148
     C     wLoanAlpha    ANDEQ     'Y'                                                        CLE148
      *                                                                                       CLE148
     C                   MOVE      DDLOAN        @LOAN                                        CLE148
     C                   MOVE      *BLANKS       DDLOAN                                       CLE148
      *                                                                                       CLE148
     C                   ELSE                                                                 CLE148
                                                                                              CLE148
     C     wLoanAlpha    IFEQ      'N'                                                        CLE148
     C                   MOVEL     '5045550'     RetCodeIn                                    CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVEL     '5045548'     RetCodeIn                                    CLE148
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
     C                   RETURN                                                               CLE148
                                                                                              CLE148
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
     C                   ENDIF                                                                CLE148
      *
      ** Validate value date if entered
     C                   IF        DDVDAT <> *BLANKS
     C                   MOVEL     DDVDAT        NUM7              7 0
     C                   MOVEL     NUM7          ALF6              6
      *
     C     DDVDAT        IFEQ      ALF6
     C                   CALLB     'ZDATE1'
     C                   PARM      DDVDAT        ZDATEA            6
     C                   PARM                    ZDAYNO
     C                   PARM      BJDFIN        DateFmt
     C                   PARM      ' '           ErrorFlag         1
     C                   ENDIF
      *
     C                   IF        DDVDAT <> ALF6 OR ErrorFlag = 'Y'
     C                   MOVEL     'LEV0911'     RetCodeIn
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDVDAT = *BLANKS
     C                   Z-ADD     *LOVAL        @VDAT
     C                   ELSE
     C                   Z-ADD     ZDAYNO        @VDAT
     C                   MOVE      *BLANKS       DDVDAT
     C                   ENDIF
      *
      ** Sequence no. must be numeric if entered
     C     DDSEQN        IFNE      *BLANKS
      *
     C                   TESTN                   DDSEQN               98
     C                   MOVE      DDSEQN        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C                   ENDIF
      *
     C     DDSEQN        IFEQ      *BLANKS
      *
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
      *
     C     DDSEQN        IFEQ      *BLANKS
     C                   Z-ADD     *LOVAL        @SEQN
     C                   ELSE
     C                   MOVE      DDSEQN        @SEQN
     C                   MOVE      *BLANKS       DDSEQN
     C                   END
      *
     C                   ELSE
      *
     C                   MOVEL     'LEV0912'     RetCodeIn
     C                   RETURN
     C                   ENDIF
      *
      *  Clear the positioner fields
     C                   MOVE      *BLANK        DDLOAN
     C                   MOVE      *BLANK        DDVDAT
     C                   MOVE      *BLANK        DDSEQN
      *
     C     EndValKey     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSTAT  -  Determine loan amendment status narrative          *
      *****************************************************************
     C     SRSTAT        BEGSR
 
     C                   MOVE      *BLANKS       ZAMSID
 
     C                   SELECT
     C     ASTS          WHENEQ    'C'
     C                   MOVEL     'LEA0060'     ZAMSID
 
     C     ASTS          WHENEQ    'R'
     C                   MOVEL     'LEA0061'     ZAMSID
 
     C     ASTS          WHENEQ    'A'
     C                   MOVEL     'LEA0062'     ZAMSID
 
     C     ASTS          WHENEQ    'D'
     C                   MOVEL     'LEA0063'     ZAMSID
                                                                                              CLE030
     C     ASTS          WHENEQ    'Q'                                                        CLE030
     C                   MOVEL     'LEA0064'     ZAMSID                                       CLE030
 
     C                   OTHER
     C                   MOVE      *BLANKS       S#STAT
     C                   ENDSL
 
      * Set up text from message file.
     C     ZAMSID        IFNE      *BLANKS
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZAMSID            7
     C                   PARM      'LERMSGF '    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTX          132
     C                   MOVEL(P)  ZAMSTX        S#STAT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ERRMSG  - Output error messages without data                  *
      *****************************************************************
     C     ERRMSG        BEGSR
      *
      *  Display error message
     C                   CALL      'Y2SNMGC'
     C                   PARM      'LELOAMBRW'   ZAPGMQ           10
     C                   PARM                    ZAPGRL
     C                   PARM                    ZMSID             7
     C                   PARM                    ZMSGF
     C                   PARM                    ZMSDA           132
     C                   PARM                    ZMSTP             7
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * Refresh - Reset all fields/errors/indicators                 *
      *****************************************************************
     C     Refresh       BEGSR
      *
     C                   MOVEL     '0'           *IN31
     C                   MOVEL     '0'           *IN36
     C                   MOVEL     '0'           *IN40
     C                   MOVEL     '0'           *IN98
     C                   MOVEL     '0'           *IN40
     C                   Z-ADD     0             P#RECN
     C                   EVAL      S#RAUT = 'N'
     C                   Eval      DDRAUT = 'N'
     C                   EVAL      @OpSel = *BLANKS
     C                   EVAL      SLLOAN = *BLANKS
     C                   EVAL      SLFRNT = *BLANKS
     C                   EVAL      @@FOID = *BLANKS
     C                   EVAL      DDRLON = *BLANKS
     C                   EVAL      DDLOAN = *BLANKS
     C                   EVAL      DDVDAT = *BLANKS
     C                   EVAL      DDSEQN = *BLANKS
     C                   Eval      MoreRec =  ' '
     C                   Clear                   WFldNamArr
     C                   Clear                   WMsgIdArr
     C                   Clear                   WMsgDtaArr
     C                   Clear                   FldNameArr
     C                   Clear                   MsgIdArr
     C                   Clear                   MsgDtaArr
      *
      ** Clear message subfile
     C                   CALL      'ZA0250'
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * RESET - Initial processing
      * Note: Because this module uses logic cycle programming, the
      *       INZSR is only called the first time this module is called.
      *****************************************************************
     C     RESET         BEGSR
 
     C                   EVAL      P#RECN = 0
      *  Reset error indicator
     C                   Eval      *IN40 = '0'
 
      * If build sub-file is 'Y', set up error messages and screen defaults
     C     @BDSFL        IFEQ      'Y'
 
      * Reset record in error indicator/FO Id work field
     C                   EVAL      *IN40  = '0'
     C                   EVAL      @@FOID = *BLANKS
      *
      * Do while error messages found
      * Write error messages (with or without data) to subfile
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
     C                   Eval      *IN40 = '1'
     C                   EndIf
     C                   Eval      S#RAUT = DDRAUT
      *
      * Clear outputs
     C                   MOVE      *BLANK        @LNSel
     C                   MOVE      *BLANK        @VDSel
     C                   MOVE      *BLANK        @SQSel
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
      *
      *  Clear the more records flag
     C                   MOVE      *BLANK        MoreRec           1
      *
      *  If 'review from' requested, use it
     C                   If        DDRLON <> *BLANK
     C                   Eval      SLLOAN = DDRLON
     C                   EndIf
     C                   ENDIF
      *
      *  Reset the 'Unauthorised only?' error highlighting
     C                   Eval      *IN36 = '0'
      *
      * Ensure that 'Unauthorised only?' has a value
     C     DDRAUT        IFEQ      *BLANKS
     C                   EVAL      DDRAUT = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
     C     *ENTRY        PLIST
      *
      * Inputs
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Action code
     C                   PARM                    DDACTN            1
      *
      * Loan number / value date / sequence / type
     C                   PARM                    DDLOAN            6
     C                   PARM                    DDVDAT            6
     C                   PARM                    DDSEQN            3
     C                   PARM                    DDATYP            2
      *
      ** Review from loan number
     C                   PARM                    DDRLON            6
      *
      * Multi-branching/date format indicators / run date
     C                   PARM                    BJSBRC            1
     C                   PARM                    BJDFIN            1
     C                   PARM                    WRUNDT            7
      *
      * Authorisation required
     C                   PARM                    AutReq            1
      *
      * Build subfile
     C                   PARM                    @BDSFL            1
      *
      * Read subfile record
     C                   PARM                    @RDSFL            1
      *
      * Requiring authorisation (Y/N - input on key screen)
     C                   PARM                    DDRAUT            1
      *                                                                                       CLE030
      * Features                                                                              CLE030
     C                   PARM                    CLE030            1                          CLE030
     C                   PARM                    wLoanAlpha                                   CLE148
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
      * Output parameters :
      * Option selected
     C                   PARM                    @OPSEL            1
 
      * Loan number / value date / sequence / type selected
     C                   PARM                    @LNSel            6
     C                   PARM                    @VDSel            6
     C                   PARM                    @SQSel            3
     C                   PARM                    @ATSel            2
 
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ** LOAM key list
     C     @LNKEY        KLIST
     C**********         KFLD                    @LOAN             6 0                        CLE148
     C                   KFLD                    @LOAN             6                          CLE148
     C                   KFLD                    @VDAT             5 0
     C                   KFLD                    @SEQN             3 0
      *
      ** Move workstation details to screen fields.
     C                   MOVEL     PsJobName     S#WID
     C                   EVAL      S#USER = PsUser
     C                   MOVEL     WRUNDT        S#RUNA
      *
      ** Initialise program name
     C                   MOVEL     'LELOAMBRW'   DBPGM
      *
      * Set flag for Midas (back) office loan details key used
     C                   If        WLOAN = *BLANK
     C                   MOVE      'B'           WLOAN             1
     C                   ENDIF
      *
      ** Check if authorisation is required
     C     AutReq        COMP      'Y'                                    29
      *                                                                                       CLE030
      ** Check if release authorisation is installed                                          CLE030
     C*****AutReq        COMP      'Y'                                    28           CLE030 222729
     C     CLE030        COMP      'Y'                                    28                  222729
      *
      * Message subfile control
     C                   MOVEL     '*'           S#PGMQ
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     'LERMSGF'     ZMSGF            10
     C                   EVAL      *IN94 = *ON
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
** LATP ** Loan amendment type
Principal increase
Spread rate change
Base rate code chng
Stop/start accrual
Loan subtype
Past due item
