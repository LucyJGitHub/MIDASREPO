     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Fee Browse')                                  *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFEEMBRW - LE Fee Browser                                   *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of Fee for selection,          *
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP078  *CREATE    Date 31Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager (Recompile)                    *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP078 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee input Transaction Details          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ***  Display file.
     FLEFEEMBDF CF   E             WORKSTN
     F                                     SFILE(LEFEEMS1:@@RRN)
     F                                     SFILE(LEFEEMS2:@@RRN)
      *
      ***  Fee file - by Front office
     FLEFEEML0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEDF:LEFEEM0)
      *
      ***  Fee file - by Fee reference
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEDF:LEFEEDF1)
      *
      ***  Fee file - by Front office 'X'
     FLEFEEML1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEDF:LEFEEM1)
      *
      ***  Fee file - by Fee reference 'X'
     FLEFEEDL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEDF:LEFEEDF3)
      *
      ***  Table of field numbers and names.
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
     F/COPY WNCPYSRC,LEFEEMBF01
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
     D  DDFEER                 1     19
     D  DDCNUMA                1      6
     D  DDFACTA                7      9
     D  DDFCNOA               10     11
     D**DDLNRFA*              12     17                                                       CLE148
     D**DDFSEQA*              18     19                                                       CLE148
     D  DDFSEQA               12     13                                                       CLE148
 
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
      ***  If First time in or subfile by Midas Fee ref. was previously
      ***  being run, then build subfile keyed on Midas Fee ref.
      ***  Stay in loop while F11 toggle key is used.
      *
     C     WFEER         IFNE      'F'
     C     *INKK         DOUEQ     '0'
     C                   EXSR      BLDSFL
      *
      ***  If F11, switch to Front Office Fee subfile.
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
      ***  If F11, switch to Midas Fee ref. subfile.
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
      ***  Set indicator and flag for Midas (back) office Fee ref. key used.
      *
     C                   MOVE      'B'           WFEER
     C                   MOVE      '0'           *IN20
     C                   MOVE      *BLANK        WDOPT             1
      *
      ***  Check for user authority to browse if not multi-branching.
      *
     C     BJSBRC        IFNE      *BLANKS
     C                   EXSR      CHAUTN
     C                   END
      *
      ***  Validate Fee ref.(for pointer).
      *
     C                   EXSR      VALFEE
     C/COPY WNCPYSRC,LEFEEMBC01
      *
      ***  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      ***  Clear subfile before refilling by writing control record
      ***  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     LEFEEMC1
     C                   MOVE      '0'           *IN97
      *
      ***  Write the select screen footer to the screen.
      *
     C                   WRITE     LEFEEMF1
      *
      ***  Set file pointer on key displayed on screen.
      *
     C/COPY WNCPYSRC,LEFEEMBC02
     C                   MOVE      DDOPT         WDOPT
     C     WDOPT         IFEQ      'X'
     C     @@FEER        SETLL     LEFEEDF3
     C                   ELSE
     C     @@FEER        SETLL     LEFEEDF1
     C                   END
     C/COPY WNCPYSRC,LEFEEMBC03
      *
      ***  Read a valid Fee ref.
      *
     C                   EXSR      RDFEE
      *
      ***  If no records exist - set up an error message.
      ***  and terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'LER0170'     @ERRMS
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
      ***  Format Fee fields for output.
      *
     C                   EXSR      FMTDEL
      *
      ***  Write the Fee to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     LEFEEMS1
      *
      ***  Read a valid Fee
      *
     C                   EXSR      RDFEE
     C                   END
      *
      ***  Write the subfile control record to the screen to display
      ***  the subfile.
      *
     C                   WRITE     LEFEEMC1
      *
      ***  Read the subfile control record to determine whether records
      ***  have been selected or whether ROLLUP is required.
      *
     C                   READ      LEFEEMC1                               99
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
     C/COPY WNCPYSRC,LEFEEMBC04
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
     C                   MOVE      'F'           WFEER             1
     C                   MOVE      '1'           *IN20
     C                   MOVE      *BLANK        WDOPT             1
      *
      ***  Check for user authority to browse if not multi-branching.
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      ***  Validate Fee ref (for pointer).
      *
     C                   EXSR      VALFEE
      *
      ***  Get Front Office Id.
      *
     C                   MOVE      DDOPT         WDOPT
     C     WDOPT         IFEQ      'X'
     C     @@FEER        CHAIN     LEFEEDF3                           89
     C                   ELSE
     C     @@FEER        CHAIN     LEFEEDF1                           89
     C                   END
     C                   MOVE      FRNT          @@FODL           20
     C     *IN89         IFEQ      '1'
     C                   MOVE      *BLANK        @@FODL
     C                   END
     C/COPY WNCPYSRC,LEFEEMBC05
      *
      ***  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      ***  Clear subfile before refilling by writing control record
      ***  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     LEFEEMC2
     C                   MOVE      '0'           *IN97
      *
      ***  Write the select screen footer to the screen.
      *
     C                   WRITE     LEFEEMF1
      *
      ***  Set file pointer on key displayed on screen.
      *
     C     @@FODL        SETLL     LEFEEM0
     C     @@FODL        SETLL     LEFEEM1
      *
      ***  Read a valid Fee
      *
     C                   EXSR      RDFEE
      *
      ***  If no records exist - set up an error message
      ***  and terminate.
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'LER0170'     @ERRMS
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
      ***  Format Fee fields for output.
      *
     C                   EXSR      FMTDEL
      *
      ***  Write the Fee to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     LEFEEMS2
      *
      ***  Read a valid Fee
      *
     C                   EXSR      RDFEE
     C                   END
      *
      ***  Write the subfile control record to the screen to display
      ***  the subfile.
      *
     C                   WRITE     LEFEEMC2
      *
      ***  Read the subfile control record to determine whether records
      ***  have been selected or whether ROLLUP is required.
      *
     C                   READ      LEFEEMC2                               99
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
     C/COPY WNCPYSRC,LEFEEMBC06
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
     C     WFEER         IFNE      'F'
     C                   READC     LEFEEMS1                               99
     C                   ELSE
     C                   READC     LEFEEMS2                               99
     C                   END
     C                   END
      *
      ***  Return the selected Fee number and option.
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'D'
     C     DDOPT         OREQ      'X'
     C                   MOVE      DDOPT         @OPSEL
     C                   ELSE
     C                   MOVE      'E'           @OPSEL
     C                   END
      *
     C                   MOVEL     DDCNUM        @CUSEL
     C     DDFACT        IFNE      *Zero
     C                   MOVEL     DDFACT        @FASEL
     C                   MOVEL     DDFCNO        @FCSEL
     C                   END
 
     C*****DDLNRF        IFNE      *Zero                                                      CLE148
     C     DDLNRF        IFNE      *BLANKS                                                    CLE148
     C                   MOVEL     DDLNRF        @LNSEL
     C                   END
 
     C                   MOVEL     DDFSEQ        @FSSEL
      *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * FMTDEL - Format Fee fields for output.                         *
      ********************************************************************
     C     FMTDEL        BEGSR
      *
      ***  Fee ref
      *
     C                   MOVEL     FECNUM        DDCNUM
     C                   MOVEL     FECNUM        DDCSSN
 
     C     FEFACL        IFNE      *ZERO
     C                   MOVEL     FEFACL        DDFACT
     C                   MOVE      FEFACL        DDFCNO
     C                   ELSE
     C                   MOVEL     *BLANKS       DDFACT
     C                   MOVE      *BLANKS       DDFCNO
     C                   END
 
     C*****FELOAN        IFNE      *ZERO                                                      CLE148
     C     FELOAN        IFNE      *BLANKS                                                    CLE148
     C                   MOVEL     FELOAN        DDLNRF
     C                   ELSE
     C                   MOVEL     *BLANKS       DDLNRF
     C                   END
 
     C                   MOVEL     FEFSEQ        DDFSEQ
      *
      ***  Front Office Fee ref
      *
     C                   MOVEL     FRNT          DDFOTRANID
      *
      ***  Fee code
      *
     C                   MOVEL     FEFCOD        DDECOD
      *
      ***  Fee currency.
      *
     C                   MOVE      FEFCCY        DDECUR
      *
      ***  Fee amount.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FEFCCY        @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     *BLANK        ZFIELD           15 0
     C                   MOVE(P)   FEFAMT        ZFIELD
      *
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM                    ZOUT21           21
      *
     C                   MOVE      ZOUT21        DDEAMT
      *
      ***  Start date.
      *
     C                   MOVEL     *BLANKS       DDEPSD
     C     FEPSTD        IFNE      *ZERO
     C                   Z-ADD     FEPSTD        ZDAYNO            5 0
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZDATE         DDEPSD
     C                   ENDIF
      *
      ***  End date.
      *
     C                   MOVEL     *BLANKS       DDEPED
     C     FEPEND        IFNE      *ZERO
     C                   Z-ADD     FEPEND        ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZDATE         DDEPED
     C                   ENDIF
      *
      ***  Fee status
      *
     C                   MOVEL     *BLANKS       DDSTAT
     C                   MOVE      FSTS          DDSTAT
 
     C     FERECI        IFNE      'M'
     C     FERECI        ANDNE     'R'
     C     FERECI        ANDNE     '*'                                                       BUG3729
     C                   SELECT
     C     FSTS          WHENEQ    'C'
     C                   MOVEL     'LER0194'     ZAMSID
     C     FSTS          WHENEQ    'R'
     C                   MOVEL     'LER0195'     ZAMSID
     C     FSTS          WHENEQ    'A'
     C                   MOVEL     'LER0196'     ZAMSID
     C     FSTS          WHENEQ    'D'
     C                   MOVEL     'LER0197'     ZAMSID
     C                   ENDSL
      *
     C                   ELSE
      *
     C     FERECI        IFEQ      'R'
     C     FSTS          ANDEQ     'A'
     C     FERECI        OREQ      '*'                                                       BUG3729
     C     FSTS          ANDEQ     'A'                                                       BUG3729
     C                   MOVEL     'LER0197'     ZAMSID
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      SRTEXT
     C                   MOVEL     ZAMSTP        DDSTAT
     C                   MOVE      *BLANKS       ZAMSID
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDFEE  - Read a Fee                                              *
      ********************************************************************
     C     RDFEE         BEGSR
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
     C     WFEER         IFEQ      'B'
     C/COPY WNCPYSRC,LEFEEMBC07
     C     WDOPT         IFEQ      'X'
     C                   READ      LEFEEDF3                               96
     C                   ELSE
     C                   READ      LEFEEDF1                               96
     C                   END
     C/COPY WNCPYSRC,LEFEEMBC08
     C                   ELSE
     C     WDOPT         IFEQ      'X'
     C                   READ      LEFEEM1                                96
     C                   ELSE
     C                   READ      LEFEEM0                                96
     C                   END
     C/COPY WNCPYSRC,LEFEEMBC09
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
      ***  If Fee read, check whether user can see it.
      *
     C     @@EOF         IFNE      'Y'
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    FEBRCA
     C                   PARM                    @@ERR
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
     C                   MOVEL     'LER0123'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * VALFEE - Validate Fee pointer.                                   *
      ********************************************************************
     C     VALFEE        BEGSR
      *
      ** Clear fee reference data-structure:
     C                   MOVE      *BLANKS       DDFEER
      *
      ***  Validate that the Fee is numeric or blank.
      *
      ***  Customer shortname.
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCSSN        @CNUM            10
     C                   PARM                    @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL(P)  BBCUST        DDCNUM
     C                   ELSE
     C                   MOVEL     *BLANKS       DDCNUM
     C                   ENDIF
      *
     C                   MOVEL     DDCNUM        DDCNUMA
 
      * Facility ref or Loan reference is filled, zeroise blank fields
     C     DDFACT        IFNE      *Blank
     C                   MOVEL     DDFACT        DDFACTA
     C                   MOVEL     DDFCNO        DDFCNOA
     C**********         MOVEL     *All'0'       DDLNRFA                                      CLE148
     C                   MOVEL     *BLANKS       DDLNRFA           7                          CLE148
     C                   ELSE
 
      * If both blank, DDFEER must be blank
     C     DDLNRF        IFNE      *Blank
     C                   MOVEL     DDLNRF        DDLNRFA
     C                   MOVEL     *All'0'       DDFACTA
     C                   MOVEL     *All'0'       DDFCNOA
     C                   ENDIF
     C                   ENDIF
      *
     C     DDFEER        IFNE      *BLANKS
     C     DDFSEQ        ANDEQ     *BLANKS
     C                   MOVEL     *ZERO         DDFSEQA
     C                   ELSE
     C                   MOVEL     DDFSEQ        DDFSEQA
     C                   END
      *
     C                   TESTN                   DDFEER               98
     C     DDFEER        IFEQ      *BLANKS
     C     *IN98         OREQ      '1'
     C**********         MOVE      DDCNUM        @@CNUM            6 0                        CSD027
     C                   MOVE      DDCNUM        @@CNUM            6                          CSD027
     C     DDFACT        IFNE      *Blank
     C                   MOVEL     DDFACT        @@FACL            5 0
     C                   MOVE      DDFCNO        @@FACL
     C**********         Z-ADD     0             @@LNRF            6 0                        CLE148
     C                   MOVEL     *BLANK        @@LNRF            6                          CLE148
     C                   ELSE
     C                   Z-ADD     0             @@FACL
     C                   MOVE      DDLNRF        @@LNRF
     C                   END
 
     C                   MOVE      DDFSEQ        @@FSEQ            2 0
      *
      ***  Return error message.
      *
     C                   ELSE
     C                   MOVEL     'LER0415'     @ERRMS
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
     C                   MOVEL     *BLANK        @LNSEL
     C                   MOVEL     *BLANK        @FSSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
     C                   MOVE      '0'           *IN20
     C/COPY WNCPYSRC,LEFEEMBC10
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
      ***  Fee pointer.
     C                   PARM                    DDCSSN           10
     C                   PARM                    DDFACT            3
     C                   PARM                    DDFCNO            2
     C                   PARM                    DDLNRF            6
     C                   PARM                    DDFSEQ            2
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
      ***  Fee selected.
     C                   PARM                    @CUSEL            6
     C                   PARM                    @FASEL            3
     C                   PARM                    @FCSEL            2
     C                   PARM                    @LNSEL            6
     C                   PARM                    @FSSEL            2
      *
      ***  Command keys.
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ***  Initialize program name.
      *
     C                   MOVEL     'LEFEEMBRW'   DBPGM
      *
      ***  Move workstation ID to screen field.
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
      ***  Key list for Fee file
      *
     C     @@FEER        KLIST
     C                   KFLD                    @@CNUM
     C                   KFLD                    @@FACL
     C                   KFLD                    @@LNRF
     C                   KFLD                    @@FSEQ
      *
     C/COPY WNCPYSRC,LEFEEMBC11
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
(c) Misys International Banking Systems Ltd. 2002
