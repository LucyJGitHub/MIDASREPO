     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Rollover Instructions Browse')                *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELERIBRW - LE Rollover Instructions Browser                 *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of loans for selection,        *
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 AR702741           Date 02Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9737            Date 29Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP084             Date 09Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP076  *CREATE    Date 10Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9737- Must included in CLE106 delivery due to changes made*
      *           CLE036 in loans file.(Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP084 - Loan details from CLOANCL have not been set up      *
      *           before checking authorisation so branch is not set  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ***  Display file.
     FLELERIBDF CF   E             WORKSTN
     F                                     SFILE(LELERIS1:@@RRN)
     F                                     SFILE(LELERIS2:@@RRN)
      *
      ***  LE Live rollover details
     FLELOANL2  IF   E           K DISK    INFSR(*PSSR)
      *
      ***  LE Rollovers requiring authorisation details
      *
     FLELOANL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CloanckF:CloanCk3)
      ***  LE Live rollover details by Front Office Id.
     FLELERIL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CloanckF:CloanFO1)
      *
      ***  LE Rollovers requiring authorisation details by Front Office Id.
     FLELERIL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CloanckF:CloanFO2)
      *
      ***  Customer Loans file - by Loan Number.
     FLECLIPL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CloanclF:CloancWl)
     F                                     RENAME(CloanckF:CloancWk)
      *
      ***  Table of field numbers and names.
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
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
      ******True*******logical*=**on*(for*indcator*processing)*********                       CAP084
      ******False******logical*=**off*(for indcator*processing)********                       CAP084
      **    True       logical = *on (for indicator processing)                               CAP084
      **    False      logical = *off (for indicator processing)                              CAP084
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
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *                                                                                       CLE148
      ** Parameters for calling LELOANISO (Validate Loan Number)                              CLE148
      *                                                                                       CLE148
     D PLNRF           S              6A                                                      CLE148
     D PValid          S              6A                                                      CLE148
     D PChkDigit       S              1A                                                      CLE148
     D PData           S              2A                                                      CLE148
      *                                                                                       CLE148
     D @@LNRF          S              6A                                                      CLE148
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
      ***  Initialization.
      *
     C                   EXSR      INIT
      *
      ***  Build sub-file.
      *
     C     @BDSFL        IFEQ      'Y'
      *
      ***  If First time in or subfile by Midas loan number was previously
      ***  being run, then build subfile keyed on Midas loan number.
      ***  Stay in loop while F11 toggle key is used.
      *
     C     WLOAN         IFNE      'F'
     C     *INKK         DOUEQ     '0'
     C                   EXSR      BLDSFL
      *
      ***  If F11, switch to Front Office loan subfile.
      *
     C     *INKK         IFEQ      '1'
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
      ***  If F11, switch to Midas Loan Number subfile.
      *
     C     *INKK         IFEQ      '1'
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
      ***  Set indicator ans flag for Midas (back) office Loan number key used.
      *
     C                   MOVE      'B'           WLOAN
     C                   MOVE      '0'           *IN20
      *
      ***  Check for user authority to browse if not multi-branching.
      *
     C     BJSBRC        IFNE      *BLANKS
     C                   EXSR      CHAUTN
     C                   END
      *
      ***  Validate loan number (for pointer).
      *
     C                   EXSR      VALLNR
      *
      ***  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      ***  Clear subfile before refilling by writing control record
      ***  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     LELERIC1
     C                   MOVE      '0'           *IN97
      *
      ***  Write the select screen footer to the screen.
      *
     C                   WRITE     LELERIF1
      *
      ***  Set file pointer on key displayed on screen.
      *
     C     DDACTN        IFEQ      'X'
     C     @@LNRF        SETLL     LELOANL3
     C                   ELSE
     C     @@LNRF        SETLL     LELOANL2
     C                   END
      *
      ***  Read a valid loan.
      *
     C                   EXSR      RDLOAN
      *
      ***  If no records exist - set up an error message.
      ***  and terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'LEV1005'     @ERRMS
     C                   RETURN
     C                   END
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
      ***  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      ***  For each record read, write it to the subfile.
      ***  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      ***  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ***  Format loan fields for output.
      *
     C                   EXSR      FMTDEL
      *
      ***  Write the Loan to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     LELERIS1
      *
      ***  Read a valid loan.
      *
     C                   EXSR      RDLOAN
     C                   END
      *
      ***  Write the subfile control record to the screen to display
      ***  the subfile.
      *
     C                   WRITE     LELERIC1
      *
      ***  Read the subfile control record to determine whether records
      ***  have been selected or whether ROLLUP is required.
      *
     C                   READ      LELERIC1                               99
      *
      ***  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      ***  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           @INKL
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
      ***  Set indicator and flag for front office Id.
      *
     C                   MOVE      'F'           WLOAN             1
     C                   MOVE      '1'           *IN20
      *
      ***  Check for user authority to browse if not multi-branching.
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      ***  Validate loan number (for pointer).
      *
     C                   EXSR      VALLNR
      *
      ***  Get Front Office Id.
      *
     C     DDACTN        IFEQ      'X'
     C     @@LNRF        CHAIN     LELOANL3                           89
     C                   ELSE
     C     @@LNRF        CHAIN     LELOANL2                           89
     C                   END
     C                   MOVE      FRNT          @@FODL           20
     C     *IN89         IFEQ      '1'
     C                   MOVE      *BLANK        @@FODL
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
     C                   WRITE     LELERIC2
     C                   MOVE      '0'           *IN97
      *
      ***  Write the select screen footer to the screen.
      *
     C                   WRITE     LELERIF1
      *
      ***  Set file pointer on key displayed on screen.
      *
     C     @@FODL        SETLL     CloanFO1
     C     @@FODL        SETLL     CloanFO2
      *
      ***  Read a valid loan.
      *
     C                   EXSR      RDLOAN
      *
      ***  If no records exist - set up an error message
      ***  and terminate.
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'LEV1005'     @ERRMS
     C                   RETURN
     C                   END
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
      ***  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      ***  For each record read, write it to the subfile.
      ***  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      ***  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ***  Format Loan fields for output.
      *
     C                   EXSR      FMTDEL
      *
      ***  Write the Loan to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     LELERIS2
      *
      ***  Read a valid loan.
      *
     C                   EXSR      RDLOAN
     C                   END
      *
      ***  Write the subfile control record to the screen to display
      ***  the subfile.
      *
     C                   WRITE     LELERIC2
      *
      ***  Read the subfile control record to determine whether records
      ***  have been selected or whether ROLLUP is required.
      *
     C                   READ      LELERIC2                               99
      *
      ***  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      ***  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           @INKL
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
     C     WLOAN         IFNE      'F'
     C                   READC     LELERIS1                               99
     C                   ELSE
     C                   READC     LELERIS2                               99
     C                   END
     C                   END
      *
      ***  Return the selected Loan number and option.
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'X'
     C     DDOPT         OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   MOVE      DDOPT         @OPSEL
     C                   ELSE
     C                   MOVE      'E'           @OPSEL
     C                   END
      *
     C                   MOVE      DDLOAN        @DLSEL
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * FMTDEL - Format loan fields for output.                          *
      ********************************************************************
     C     FMTDEL        BEGSR
 
     C*****LNRF*         CHAIN     LECLIPL2                           85                      CAP084
      *
      **  Loan number and customer number.
      *
     C                   MOVE      LNRF          DDLOAN
     C     PTYP          IFEQ      64
     C     PTYP          OREQ      65
     C                   MOVE      OLNO          DDCNUM
     C                   ELSE
     C                   MOVE      CNUM          DDCNUM
     C                   END
      *
      ** Access the Customer Details file for Shortname
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      DDCNUM        PCUST            10
     C                   PARM                    PKYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   MOVE      *BLANKS       DDCSNM
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      BBCSSN        DDCSNM
     C                   ELSE
     C                   MOVE      'Unknown'     DDCSNM
     C                   ENDIF
      *
      * Front Office Deal number
      *
     C                   MOVEL     FRNT          DDFOTRANID
      *
      **  Rollover date.
      *
     C                   Z-ADD     RLDT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        DDSRDT
      *
      **  Next Rollover date.
      *
     C     NROD          IFNE      0
     C                   Z-ADD     NROD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        DDSNRD
      *
      ** If next rollover date field (NROD) has no value then
      ** recalculate next rollover date.
      *
     C                   ELSE
     C     RLDT          IFNE      *ZEROS
     C     RLFQ          ANDNE     *BLANK
     C                   Z-ADD     RLDT          ZDAYNO
     C                   MOVE      RLFQ          ZFREQ
     C                   Z-ADD     RLDY          ZMDAY
     C                   MOVE      CCY           ZCCY
     C                   EXSR      ZFREQB
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        DDSNRD
     C                   ELSE
     C                   MOVE      *BLANKS       DDSNRD
     C                   END
     C                   END
      *
      **  Rollover frequency and day number.
      *
     C                   MOVEL     RLFQ          DDSRFQ
     C     RLDY          IFNE      *ZEROS
     C                   MOVE      RLDY          DDSRDY
     C                   ELSE
     C                   MOVE      *BLANKS       DDSRDY
     C                   ENDIF
      *
      **  Rollover status.
      *
     C                   MOVE      RSTS          WRSTS             1
     C                   EXSR      SRSTAT
     C                   MOVEL     WSTAT         DDSRST
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDLOAN - Read a loan.                                            *
      ********************************************************************
     C     RDLOAN        BEGSR
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
     C*****LNRF          ORNE      *ZEROS                                                     CLE148
     C     LNRF          ORNE      *BLANKS                                                    CLE148
     C     CHTP          ANDNE     'D'
     C     @@ERR         ANDEQ     *ZERO
      *
      ***  Read the file.
      *
     C     WLOAN         IFEQ      'B'
     C     DDACTN        IFEQ      'X'
     C                   READ      LELOANL3                               96
     C                   ELSE
     C                   READ      LELOANL2                               96
     C                   END
     C                   ELSE
     C     DDACTN        IFEQ      'X'
     C                   READ      LELERIL2                               96
     C                   ELSE
     C                   READ      LELERIL1                               96
     C                   END
     C                   END
      *
      ***  End of File.
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
      *
      ***  If Loan read, check whether user can see it.
      *
     C     @@EOF         IFNE      'Y'
     C     LNRF          CHAIN     LECLIPL2                           85                      CAP084
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C     BKOBUV        IFEQ      'Y'
     C     @@ERR         ANDEQ     *ZERO
     C                   CALL      'ZVOBU'
     C                   PARM                    ORBR
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
     C                   MOVEL     'LEV0302'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * VALLNR - Validate loan number pointer.                           *
      ********************************************************************
     C     VALLNR        BEGSR
      *
      ***  Validate that the Loan number is numeric or blank.
      *
     C                   TESTN                   DDLNRF               98
     C                   MOVE      DDLNRF        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C*****DDLNRF        IFEQ      *BLANKS                                                    CLE148
     C******IN98         OREQ      '1'                                                        CLE148
     C******IN99         ANDEQ     '1'                                                        CLE148
     C**********         MOVE      DDLNRF        @@LNRF            6 0                        CLE148
      *
      *****Return*error*message.**************************************                        CLE148
      *
     C**********         ELSE                                                                 CLE148
     C**********         MOVEL     'LEV0038'     @ERRMS                                       CLE148
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
                                                                                              CLE148
     C                   CALL(E)   'LELOANISO'   P_LELOANISO                                  CLE148
      *                                                                                       CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   IF        DDLNRF = *BLANKS                                           CLE148
     C                              OR (wLoanAlpha = 'N' AND *IN98 = *ON                      CLE148
     C                              AND *IN99 = *ON) OR (wLoanAlpha = 'Y'                     CLE148
     C                              AND PValid = *BLANKS)                                     CLE148
     C                   MOVEL     DDLNRF        @@LNRF                                       CLE148
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
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * SRSTAT  -  Determine Rollover Status Narrative                *
      * Called by: SRSFLD - Format subfile fields                     *
      *            SRMOVP - Move test harness fields to screen fields *
      *            SRMOVR - Move rollover loan details to screen      *
      * Calls    : None                                               *
      *****************************************************************
     C     SRSTAT        BEGSR
      *
     C                   MOVE      *BLANKS       ZAMSID            7
     C                   SELECT
     C     WRSTS         WHENEQ    'C'
     C                   MOVEL     'LEV0003'     ZAMSID
     C     WRSTS         WHENEQ    'R'
     C                   MOVEL     'LEV0004'     ZAMSID
     C     WRSTS         WHENEQ    'A'
     C                   MOVEL     'LEV0005'     ZAMSID
     C     WRSTS         WHENEQ    'D'
     C                   MOVEL     'LEV0006'     ZAMSID
     C                   OTHER
     C                   MOVE      *BLANKS       WSTAT
     C                   ENDSL
     C     ZAMSID        IFNE      *BLANKS
     C                   EXSR      SRTEXT
     C                   MOVEL(P)  ZAMSTX        WSTAT            16
     C                   MOVE      *BLANKS       ZAMSID
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZFREQB - Calc day num of next pymnt frq from curr dayno       *
      *                                                               *
      *****************************************************************
     C     ZFREQB        BEGSR
 
     C                   CallB     'ZFREQB'
     C                   Parm      *blanks       RetCodeIn
     C                   Parm                    ZFREQ             1
     C                   Parm                    ZDAYNO            5 0
     C                   Parm                    ZCCY              3
     C                   Parm      *BLANKS       ZLOC              3                        AR702741
     C                   Parm                    ZMDAY             2 0
     C                   Parm                    BJDFIN
     C                   Parm      SDGELR        SDGELR
 
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * SRTEXT  -  Set up text from message file                      *
      * Called by: All subroutines setting of texts                   *
      * Calls    : None                                               *
      *****************************************************************
     C     SRTEXT        BEGSR
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM      'LERMSGF'     ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTX          132            Messge text
      *
     C                   ENDSR
      /EJECT
      /EJECT
      ********************************************************************
      * INIT - Initialization.                                           *
      ********************************************************************
     C     INIT          BEGSR
      *
      ***  Clear outputs.
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANKS       @ERRDTA                                      CLE148
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @DLSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
     C                   MOVE      '0'           *IN20
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
      ***  Return code.
     C                   PARM                    RetCodeIn
      *
      ***  Action code.
     C                   PARM                    DDACTN            1
      *
      ***  Loan number pointer.
     C                   PARM                    DDLNRF            6
      *
      ***  Build sub-file.
     C                   PARM                    @BDSFL            1
      *
      ***  Read sub-file record.
     C                   PARM                    @RDSFL            1
      *
      ***  OUTPUT parameters.
      *
      ***  Error message.
     C                   PARM                    wLoanAlpha                                   CLE148
     C                   PARM                    @ERRMS            7
     C                   PARM                    @ERRDTA                                      CLE148
      *
      ***  Option selected.
     C                   PARM                    @OPSEL            1
      *
      ***  Loan number selected.
     C                   PARM                    @DLSEL            6
      *
      ***  Command keys.
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ***  Initialize program name.
      *
     C                   MOVEL     'LELERIBRW'   DBPGM
      *
      ***  Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
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
     C                   MOVEL     '003'         DBASE                          * DBERR 003 *
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
     C                   MOVEL     '004'         DBASE                          * DBERR 004 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *                                                                                       CLE030
      ***  Determine if Release authorisation enhancement feature                             CLE030
      ***  is installed                                                                       CLE030
      *                                                                                       CLE030
     C                   MOVE      'N'           CLE030            1                          CLE030
     C                   CALLB     'AOSARDR0'                                                 CLE030
     C                   PARM      *BLANKS       @RTCD                                        CLE030
     C                   PARM      '*VERIFY'     @OPTN                                        CLE030
     C                   PARM      'CLE030'      @SARD             6                          CLE030
      *                                                                                       CLE030
     C     @RTCD         IFEQ      *BLANKS                                                    CLE030
     C                   MOVE      'Y'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
     C     @RTCD         IFEQ      '*NRF'                                                     CLE030
     C                   MOVE      'N'           CLE030                                       CLE030
     C                   ELSE                                                                 CLE030
      *                                                                                       CLE030
      * DATABASE ERROR                                                                        CLE030
      *                                                                                       CLE030
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE030
     C                   MOVEL     '005'         DBASE                          * DBERR 005 * CLE030
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE030
     C                   EXSR      *PSSR                                                      CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
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
