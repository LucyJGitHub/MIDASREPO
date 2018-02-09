     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans Browse')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIPBRW - LE Customer Loans Browser                        *
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
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3721            Date 09Aug04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE030             Date 29Aug02               *
      *                 CAP074  *CREATE    Date 27Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE030 - Release Authorisation processing                    *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ***  Display file.
     FLECLIPBDF CF   E             WORKSTN
     F                                     SFILE(LECLIPS1:@@RRN)
     F                                     SFILE(LECLIPS2:@@RRN)
      *
      ***  Customer Loans file - by Loan Number.
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:CLOANCLFC)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
      *
      ***  Customer Loans file - by Loan Number. "X"
     FLECLIPL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:CLOANCLF3)
     F                                     IGNORE(CLOANCKF)
      *
      ***  Customer Loans file - by Front Office Id.
     FLECLIPL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:CLOANCLF0)
     F                                     IGNORE(CLOANCKF)
      *
      ***  Customer Loans file - by Front Office Id. "X"
     FLECLIPL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:CLOANCLF1)
     F                                     IGNORE(CLOANCKF)
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
     C                   WRITE     LECLIPC1
     C                   MOVE      '0'           *IN97
      *
      ***  Write the select screen footer to the screen.
      *
     C                   WRITE     LECLIPF1
      *
      ***  Set file pointer on key displayed on screen.
      *
     C     DDOPT         IFEQ      'X'
     C     @@LNRF        SETLL     CLOANCLF3
     C                   ELSE
     C     @@LNRF        SETLL     CLOANCLFC
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
     C                   MOVEL     'LEL0600'     @ERRMS
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
     C                   WRITE     LECLIPS1
      *
      ***  Read a valid loan.
      *
     C                   EXSR      RDLOAN
     C                   END
      *
      ***  Write the subfile control record to the screen to display
      ***  the subfile.
      *
     C                   WRITE     LECLIPC1
      *
      ***  Read the subfile control record to determine whether records
      ***  have been selected or whether ROLLUP is required.
      *
     C                   READ      LECLIPC1                               99
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
     C     DDOPT         IFEQ      'X'
     C     @@LNRF        CHAIN     CLOANCLF3                          89
     C                   ELSE
     C     @@LNRF        CHAIN     CLOANCLFC                          89
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
     C                   WRITE     LECLIPC2
     C                   MOVE      '0'           *IN97
      *
      ***  Write the select screen footer to the screen.
      *
     C                   WRITE     LECLIPF1
      *
      ***  Set file pointer on key displayed on screen.
      *
     C     @@FODL        SETLL     CLOANCLF0
     C     @@FODL        SETLL     CLOANCLF1
      *
      ***  Read a valid loan.
      *
     C                   EXSR      RDLOAN
      *
      ***  If no records exist - set up an error message
      ***  and terminate.
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'LEL0600'     @ERRMS
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
     C                   WRITE     LECLIPS2
      *
      ***  Read a valid loan.
      *
     C                   EXSR      RDLOAN
     C                   END
      *
      ***  Write the subfile control record to the screen to display
      ***  the subfile.
      *
     C                   WRITE     LECLIPC2
      *
      ***  Read the subfile control record to determine whether records
      ***  have been selected or whether ROLLUP is required.
      *
     C                   READ      LECLIPC2                               99
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
     C                   READC     LECLIPS1                               99
     C                   ELSE
     C                   READC     LECLIPS2                               99
     C                   END
     C                   END
      *
      ***  Return the selected Loan number and option.
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'R'
     C     DDOPT         OREQ      'X'
     C     DDOPT         OREQ      '1'
     C     DDOPT         OREQ      '2'
     C     DDOPT         OREQ      '3'
     C     DDOPT         OREQ      '4'
     C                   MOVE      DDOPT         @OPSEL
     C                   ELSE
     C                   MOVE      'E'           @OPSEL
     C                   END
      *                                                                                       CLE030
      ** IF CLE030 is installed then check for Q ( Release) also.                             CLE030
      *                                                                                       CLE030
     C     CLE030        IFEQ      'Y'                                                        CLE030
     C     DDOPT         ANDEQ     'Q'                                                        CLE030
     C                   MOVE      DDOPT         @OPSEL                                       CLE030
     C                   ENDIF                                                                CLE030
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
      *
      ***  Loan number.
      *
     C                   MOVE      LNRF          DDLOAN
      *
      ***  Front Office Loan number.
      *
     C                   MOVEL     FRNT          DDFOTRANID
      *
      ***  Customer number.
      *
     C                   MOVE      CNUM          DDCNUM
      *
      ***  Customer shortname.
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCNUM        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCUSTPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     DDCNUM        DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Start date.
      *
     C                   MOVEL     *BLANKS       DDVDTE
     C     VDAT          IFNE      *ZERO
     C                   Z-ADD     VDAT          ZDAYNO            5 0
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZADATE        DDVDTE
     C                   ENDIF
      *
      ***  Maturity date.
      *
     C                   MOVEL     *BLANKS       DDMDTE
     C     MDAT          IFNE      *ZERO
     C                   Z-ADD     MDAT          ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        DDMDTE
     C                   ENDIF
      *
      ***  Loan amount.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      CCY           @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     *BLANK        ZFIELD           16
     C                   MOVE(P)   CPAM          ZFIELD
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC             1 0
      *
     C                   MOVE      ZFIELD        DDAMNT
      *
      ***  Loan currency.
      *
     C                   MOVE      CCY           DDLCCY
      *
      ***  Loan status
      *
     C                   MOVE      *OFF          *IN60
     C     RECI          IFEQ      'M'
     C     RECI          OREQ      'R'
     C                   MOVE      *ON           *IN60
     C                   ENDIF
 
     C                   SELECT
     C     RECI          WHENEQ    'M'
     C                   MOVEL     'LEL0496'     ZAMSID
     C     RECI          WHENEQ    'R'
     C                   MOVEL     'LEL0088'     ZAMSID
     C     LSTS          WHENEQ    'C'
     C                   MOVEL     'LEL0089'     ZAMSID
     C     LSTS          WHENEQ    'R'
     C                   MOVEL     'LEL0090'     ZAMSID
     C     LSTS          WHENEQ    'A'
     C                   MOVEL     'LEL0091'     ZAMSID
     C     LSTS          WHENEQ    'D'
     C                   MOVEL     'LEL0092'     ZAMSID
     C     LSTS          WHENEQ    'Q'
     C                   MOVEL     'LEL0124'     ZAMSID
     C                   ENDSL
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDSTAT
     C                   MOVE      *BLANKS       ZAMSID
      *
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
     C     @@FND         OREQ      'Y'
     C     @@ERR         ANDEQ     *ZERO
      *
     C                   MOVE      'N'           @@FND             1
      *
      ***  Read the file.
      *
     C     WLOAN         IFEQ      'B'
     C     DDOPT         IFEQ      'X'
     C                   READ      CLOANCLF3                              96
     C                   ELSE
     C                   READ      CLOANCLFC                              96
     C                   END
     C                   ELSE
     C     DDOPT         IFEQ      'X'
     C                   READ      CLOANCLF1                              96
     C                   ELSE
     C                   READ      CLOANCLF0                              96
     C                   END
     C                   END
      *
      ***  Loans displayed must correspond to loan type
      *
     C                   SELECT
     C     LoanType      WHENEQ    'LOAN'
     C     PTYP          IFEQ      61
     C     PTYP          OREQ      62
     C     PTYP          OREQ      63
     C     PTYP          OREQ      70
     C     PTYP          OREQ      80                                                        BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C                   MOVE      'Y'           @@FND
     C                   END
      *
     C     LoanType      WHENEQ    'PTPU'
     C     PTYP          IFEQ      64
     C     PTYP          OREQ      65
     C     PTYP          OREQ      68
     C     CLE005        ANDEQ     'Y'
     C     PTYP          OREQ      71
     C     CLE005        ANDEQ     'Y'
     C                   MOVE      'Y'           @@FND
     C                   END
      *
     C     LoanType      WHENEQ    'PTSO'
     C     PTYP          IFEQ      66
     C     PTYP          OREQ      67
     C     PTYP          OREQ      69
     C     CLE005        ANDEQ     'Y'
     C     PTYP          OREQ      72
     C     CLE005        ANDEQ     'Y'
     C                   MOVE      'Y'           @@FND
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
     C                   MOVEL     'LEL0602'     @ERRMS
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
      ***  Return error message.
      *
     C**********         ELSE                                                                 CLE148
     C**********         MOVEL     'LEL0602'     @ERRMS                                       CLE148
     C**********         RETURN                                                               CLE148
     C**********         END                                                                  CLE148
                                                                                              CLE148
     C                   IF        wLoanAlpha = 'Y'                                           CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   EVAL      PLNRF = DDLNRF                                             CLE148
     C                   EVAL      PValid = *BLANKS                                           CLE148
     C                   EVAL      PChkDigit = *BLANKS                                        CLE148
     C                   EVAL      PData = *BLANKS                                            CLE148
                                                                                              CLE148
     C                   CALL(E)   'LELOANISO'   P_LELOANISO                                  CLE148
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
     C                   IF        DDLNRF = *BLANK                                            CLE148
     C                              OR (wLoanAlpha = 'N' AND *IN98 = *ON                      CLE148
     C                              AND *IN99 = *ON) OR (wLoanAlpha = 'Y'                     CLE148
     C                              AND PValid = *BLANKS)                                     CLE148
     C                   MOVEL     DDLNRF        @@LNRF            6                          CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
     C                   IF        wLoanAlpha = 'N'                                           CLE148
     C                   MOVEL     '5045550'     @ERRMS                                       CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
     C                   MOVEL     '5045548'     @ERRMS                                       CLE148
     C                   MOVEL     PData         @ERRDTA                                      CLE148
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
     C                   RETURN                                                               CLE148
     C                   ENDIF                                                                CLE148
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
      ********************************************************************
      /EJECT
      ********************************************************************
      * INIT - Initialization.                                           *
      ********************************************************************
     C     INIT          BEGSR
      *
      ***  Clear outputs.
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @ERRDTA                                      CLE148
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @DLSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
     C                   MOVE      '0'           *IN20
      *
      ***  Check type of processing
      *
     C                   MOVE      '0'           *IN82
     C                   MOVE      '0'           *IN83
     C                   SELECT
     C     LoanType      WHENEQ    'PTPU'
     C                   MOVE      '1'           *IN82
     C     LoanType      WHENEQ    'PTSO'
     C                   MOVE      '1'           *IN83
     C                   ENDSL
 
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
     C                   PARM                    DDOPT             1
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
      ***  Calling type
      *
     C                   PARM                    LoanType          4
                                                                                             BUG3721
      ** Switchable Features                                                                 BUG3721
     C                   PARM                    CLE028            1                         BUG3721
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
     C                   MOVEL     'LECLIPBRW'   DBPGM
      *
      ***  Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
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
      *
      ***  Determine if Customer Lending Enhancements - Others
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   ENDIF
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
      *
     C                   EVAL      @RTCD = *BLANKS
      *                                                                                       CLE148
      ** Parameter list for calling LELOANISO                                                 CLE148
      *                                                                                       CLE148
     C     P_LELOANISO   PLIST                                                                CLE148
      ** Loan Number (Input)                                                                  CLE148
     C                   PARM                    PLNRF                                        CLE148
      ** Validity Flags (Output)                                                              CLE148
     C                   PARM                    PValid                                       CLE148
      ** Check Digit (Output)                                                                 CLE148
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
