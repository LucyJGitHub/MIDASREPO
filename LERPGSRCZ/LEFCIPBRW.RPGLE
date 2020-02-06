     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility browse')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFCIPBRW - LE Facility Browser                              *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of facility for selection,     *
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE064             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP073  *CREATE    Date 180302                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ***  Display file.
     FLEFCIPBDF CF   E             WORKSTN
     F                                     SFILE(LEFCIPS1:@@RRN)
     F                                     SFILE(LEFCIPS2:@@RRN)
      *
      ***  Facility file - by Facility ref.
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF:FCLTYZZF)
      *
      ***  Facility file - by Facility ref. 'X'
     FLEFCLTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFC1)
      *
      ***  Facility file - by Front office
     FLEFCIPL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFL0)
      *
      ***  Facility file - by Front office 'X'
     FLEFCIPL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:FCLTYFL1)
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
     D                 DS
     D  DDFACR                 1     11
     D  DDCNUMA                1      6
     D  DDFACTA                7      9
     D  DDFCNOA               10     11
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @@RCDT          S              1A   INZ('A')
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
      ***  If First time in or subfile by Midas Facility ref. was previously
      ***  being run, then build subfile keyed on Midas Fclty ref.
      ***  Stay in loop while F11 toggle key is used.
      *
     C     WFACR         IFNE      'F'
     C     *INKK         DOUEQ     '0'
     C                   EXSR      BLDSFL
      *
      ***  If F11, switch to Front Office Fclty subfile.
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
      ***  If F11, switch to Midas Facility ref. subfile.
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
      ***  Set indicator ans flag for Midas (back) office Facility ref. key used.
      *
     C                   MOVE      'B'           WFACR
     C                   MOVE      '0'           *IN20
      *
      ***  Check for user authority to browse if not multi-branching.
      *
     C     BJSBRC        IFNE      *BLANKS
     C                   EXSR      CHAUTN
     C                   END
      *
      ***  Validate Facility ref.(for pointer).
      *
     C                   EXSR      VALFAC
      *
      ***  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      ***  Clear subfile before refilling by writing control record
      ***  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     LEFCIPC1
     C                   MOVE      '0'           *IN97
      *
      ***  Write the select screen footer to the screen.
      *
     C                   WRITE     LEFCIPF1
      *
      ***  Set file pointer on key displayed on screen.
      *
     C     DDOPT         IFEQ      'X'
     C     @@FACR        SETLL     FCLTYFC1
     C                   ELSE
     C     @@FACR2       SETLL     FCLTYFMF
     C                   END
      *
      ***  Read a valid Facility ref.
      *
     C                   EXSR      RDFAC
      *
      ***  If no records exist - set up an error message.
      ***  and terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'LEF0428'     @ERRMS
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
      ***  Format Fclty fields for output.
      *
     C                   EXSR      FMTDEL
      *
      ***  Write the Fclty to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     LEFCIPS1
      *
      ***  Read a valid Fclty
      *
     C                   EXSR      RDFAC
     C                   END
      *
      ***  Write the subfile control record to the screen to display
      ***  the subfile.
      *
     C                   WRITE     LEFCIPC1
      *
      ***  Read the subfile control record to determine whether records
      ***  have been selected or whether ROLLUP is required.
      *
     C                   READ      LEFCIPC1                               99
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
     C                   MOVE      'F'           WFACR             1
     C                   MOVE      '1'           *IN20
      *
      ***  Check for user authority to browse if not multi-branching.
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      ***  Validate Facility ref (for pointer).
      *
     C                   EXSR      VALFAC
      *
      ***  Get Front Office Id.
      *
     C     DDOPT         IFEQ      'X'
     C     @@FACR        CHAIN     FCLTYFC1                           89
     C                   ELSE
     C     @@FACR2       CHAIN     FCLTYFMF                           89
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
     C                   WRITE     LEFCIPC2
     C                   MOVE      '0'           *IN97
      *
      ***  Write the select screen footer to the screen.
      *
     C                   WRITE     LEFCIPF1
      *
      ***  Set file pointer on key displayed on screen.
      *
     C     @@FODL        SETLL     FCLTYFL0
     C     @@FODL        SETLL     FCLTYFL1
      *
      ***  Read a valid Facility
      *
     C                   EXSR      RDFAC
      *
      ***  If no records exist - set up an error message
      ***  and terminate.
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'LEF0428'     @ERRMS
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
      ***  Format Facility fields for output.
      *
     C                   EXSR      FMTDEL
      *
      ***  Write the Facility to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     LEFCIPS2
      *
      ***  Read a valid Facility
      *
     C                   EXSR      RDFAC
     C                   END
      *
      ***  Write the subfile control record to the screen to display
      ***  the subfile.
      *
     C                   WRITE     LEFCIPC2
      *
      ***  Read the subfile control record to determine whether records
      ***  have been selected or whether ROLLUP is required.
      *
     C                   READ      LEFCIPC2                               99
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
     C     WFACR         IFNE      'F'
     C                   READC     LEFCIPS1                               99
     C                   ELSE
     C                   READC     LEFCIPS2                               99
     C                   END
     C                   END
      *
      ***  Return the selected Fclty number and option.
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'R'
     C     DDOPT         OREQ      'C'
     C     DDOPT         OREQ      'X'
     C                   MOVE      DDOPT         @OPSEL
     C                   ELSE
     C                   MOVE      'E'           @OPSEL
     C                   END
      *
     C                   MOVEL     DDCNUM        @CUSEL
     C                   MOVEL     DDFACT        @FASEL
     C                   MOVEL     DDFCNO        @FCSEL
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * FMTDEL - Format Fclty fields for output.                         *
      ********************************************************************
     C     FMTDEL        BEGSR
      *
      ***  Facility ref
      *
     C                   MOVEL     CNUM          DDCNUM
     C                   MOVEL     FACT          DDFACT
     C                   MOVEL     FCNO          DDFCNO
      *
      ***  Front Office Fclty ref
      *
     C                   MOVEL     FRNT          DDFOTRANID
      *
      ***  Customer shortname.
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
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
     C                   ELSE
     C                   MOVEL     BBCSSN        DDNAME
     C                   ENDIF
      *
      ***  Start date.
      *
     C                   MOVEL     *BLANKS       DDDTAP
     C     DTAP          IFNE      *ZERO
     C                   Z-ADD     DTAP          ZDAYNO            5 0
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZDATE         DDDTAP
     C                   ENDIF
      *
      ***  Expiry date.
      *
     C                   MOVEL     *BLANKS       DDDTEX
     C     DTEX          IFNE      *ZERO
     C                   Z-ADD     DTEX          ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZDATE         DDDTEX
     C                   ENDIF
      *
      ***  Fclty amount.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FCCY          @CYCD             3
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
     C                   MOVE(P)   FAMT          ZFIELD
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC             1 0
      *
     C                   MOVE      ZFIELD        DDFAMT
      *
      ***  Fclty currency.
      *
     C                   MOVE      FCCY          DDFCCY
      *
      ***  Fclty status
      *
     C                   MOVE      FSTS          DDSTAT
 
     C                   SELECT
     C     RECI          WHENEQ    'D'
     C     FSTS          ANDEQ     'C'
     C                   MOVEL     'LEF0118'     ZAMSID
     C     RECI          WHENEQ    'D'
     C     FSTS          ANDEQ     'A'
     C                   MOVEL     'LEF0119'     ZAMSID
     C     RECI          WHENEQ    'D'
     C     FSTS          ANDEQ     'R'
     C                   MOVEL     'LEF0120'     ZAMSID
     C     RECI          WHENEQ    'R'
     C     FSTS          ANDEQ     'A'
     C                   MOVEL     'LEF0121'     ZAMSID
     C     RECI          WHENEQ    'C'
     C     FSTS          ANDEQ     'A'
     C                   MOVEL     'LEF0122'     ZAMSID
     C     RECI          WHENEQ    'E'
     C                   MOVEL     'LEF0124'     ZAMSID
     C                   ENDSL
 
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDSTAT
     C                   MOVE      *BLANKS       ZAMSID
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDFAC  - Read a Fclty                                            *
      ********************************************************************
     C     RDFAC         BEGSR
      *
      ***  Reset End of File indicator.
      *
     C                   MOVEL     *BLANK        @@EOF             1
      *
      ***  Read the file initially - if @@EOF is set on then the end of
      ***  the file has been reached.  Read until a valid record is
      ***  found or until no more records exist.
      *
     C                   MOVEL     'N'           @@FND             1
     C     @@EOF         DOUEQ     'Y'
     C     @@FND         OREQ      'Y'
     C     @@ERR         ORNE      *ZERO
      *
      ***  Read the file.
      *
     C     WFACR         IFEQ      'B'
     C     DDOPT         IFEQ      'X'
     C                   READ      FCLTYFC1                               96
     C                   ELSE
     C                   READ      FCLTYFMF                               96
     C                   END
     C                   ELSE
     C     DDOPT         IFEQ      'X'
     C                   READ      FCLTYFL1                               96
     C                   ELSE
     C                   READ      FCLTYFL0                               96
     C                   END
     C                   END
      *
      ***  End of File.
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   ELSE
     C                   MOVEL     'Y'           @@FND
     C                   END
      *
      ***  If Fclty read, check whether user can see it.
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
     C                   MOVEL     'LEF0009'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * VALFAC - Validate Facility pointer.                              *
      ********************************************************************
     C     VALFAC        BEGSR
      *
      ***  Validate that the Facility is numeric or blank.
      *
      ***  Customer shortname.
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCSSN        @CNUM
     C                   PARM                    @CNST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL(P)  BBCUST        DDCNUM
     C                   ELSE
     C                   MOVEL     *BLANKS       DDCNUM
     C                   ENDIF
      *
     C                   MOVEL     DDCNUM        DDCNUMA
     C                   MOVEL     DDFACT        DDFACTA
     C                   MOVEL     DDFCNO        DDFCNOA
      *
      *
     C                   TESTN                   DDFACR               98
     C                   MOVE      DDFACR        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     DDFACR        IFEQ      *BLANKS
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C**********         MOVE      DDCNUM        @@CNUM            6 0                        CSD027
     C                   MOVE      DDCNUM        @@CNUM            6                          CSD027
     C                   MOVE      DDFACT        @@FACT            3 0
     C                   MOVE      DDFCNO        @@FCNO            2 0
      *
      ***  Return error message.
      *
     C                   ELSE
     C                   MOVEL     'LEF0009'     @ERRMS
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
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVEL     *BLANK        @CUSEL
     C                   MOVEL     *BLANK        @FASEL
     C                   MOVEL     *BLANK        @FCSEL
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
     C                   PARM                    DDOPT             1
      *
      ***  Facility pointer.
     C                   PARM                    DDCSSN           10
     C                   PARM                    DDFACT            3
     C                   PARM                    DDFCNO            2
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
     C                   PARM                    @ERRMS            7
      *
      ***  Option selected.
     C                   PARM                    @OPSEL            1
      *
      ***  Fclty selected.
     C                   PARM                    @CUSEL            6
     C                   PARM                    @FASEL            3
     C                   PARM                    @FCSEL            2
      *
      ***  Command keys.
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ***  Initialize program name.
      *
     C                   MOVEL     'LEFCIPBRW'   DBPGM
      *
      ***  Move workstation ID to screen field.
      *
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
     C**********         CALL      'AOGELRR0'                                          CGL029 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
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
      ***  Key list for Fclty file
      *
     C     @@FACR        KLIST
     C                   KFLD                    @@CNUM
     C                   KFLD                    @@FACT
     C                   KFLD                    @@FCNO
      *
     C     @@FACR2       KLIST
     C                   KFLD                    @@CNUM
     C                   KFLD                    @@FACT
     C                   KFLD                    @@FCNO
     C                   KFLD                    @@RCDT
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
