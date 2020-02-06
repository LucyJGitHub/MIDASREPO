     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral details browser')                  *
/*OVR *  OVRDBF FILE(GLCOLLX1) TOFILE(GLCOLLL1) SHARE(*NO)            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLLBRW - Collateral Details Browser                       *
      *                                                               *
      *  Function: This module runs in two modes:                     *
      *            - will build and display a sub-file of valid       *
      *              collateral items which the user is authorised    *
      *              to view.                                         *
      *            - picks off the collateral items that the user     *
      *              has selected.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL018             Date 26Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL018 - Risk Weighted Assets                                *
      *           (New Action Code Allowed)                           *
      *  CGL011 - Collateral Processing for Midas (Phase 1)           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Collateral Details File by Front Office Id
     FGLCOLLL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Collateral Details File by Collateral Reference
     FGLCOLLX1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCOLLD0:GLCOLLD1)
      *
      ** Browse Details screen
     FGLCOLLBDF CF   E             WORKSTN SFILE(GLCOLLS1:@@RRN)
     F                                     SFILE(GLCOLLS2:@@RRN)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
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
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             96     96
      *
      ** Select Fields Error Inds
     D SelFldVald      DS
     D  REQR_Vald              1      1
     D  SENT_Vald              2      2
     D  SCMP_Vald              3      3
     D  SBRC_Vald              4      4
     D  SCOL_Vald              5      5
     D  SCNU_Vald              6      6
     D  SCCY_Vald              7      7
     D  SVAL_Vald              8      8
     D  SGNS_Vald              9      9
      *
      ** External DS For SAR Details                                                          CGL018
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL018
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Company Details
     D SDCOMP        E DS                  EXTNAME(SDCOMPPD)
      *
      ** Externally described DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** Externally described DS for Collateral Types Details
     D SDCOTP        E DS                  EXTNAME(SDCOTPPD)
      *
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  #DFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      *
      ** Externally described DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for Dealing Data
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      *
      ** DS for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Access Programs
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** Midas User Data Area
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Indicator Array
     DIndicatorP       S               *   INZ(%ADDR(*IN))
      *
      ** Parameters for ZALIGN and ZEDIT
     D ZAlignOk        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   EXSR      SRINIT
      *
      ** Build Sub-file
      *
     C     PBDSFL        IFEQ      'Y'
      *
      **  If First time in or subfile by Collateral Reference was previously
      **  being run, then build subfile keyed on Collateral Reference.
      **  Stay in loop while F11 toggle key is used.
      *
     C     @ORD          IFNE      'F'
      *
     C     *INKK         DOUEQ     False
     C                   EXSR      SRBLDSFL1
      *
      **  If F11, switch to Front Office Id subfile
     C     *INKK         IFEQ      True
     C                   EXSR      SRBLDSFL2
     C                   ENDIF
     C                   ENDDO
      *
     C                   ELSE
      *
      **  If the subfile by Front Office Identifier was previously
      **  being run, then build subfile keyed on Front Office ID.
      **  Stay in loop while F11 toggle key is used.
      *
     C     *INKK         DOUEQ     False
     C                   EXSR      SRBLDSFL2
      *
      **  If F11, switch to Collateral Reference subfile
     C     *INKK         IFEQ      True
     C                   EXSR      SRBLDSFL1
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read Subfile Record
      *
     C     PRDSFL        IFEQ      'Y'
     C                   EXSR      SRRDSFL
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation processing                           *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
     C                   MOVE      False         PINKC
     C                   MOVE      False         PINKI
     C                   MOVE      False         PINKL
     C                   MOVE      *BLANKS       PERRMS
     C                   MOVE      *BLANKS       POPSEL
     C                   MOVE      *BLANKS       PCOSEL
     C**********         Z-ADD     0             WFSCNU            6 0                        CSD027
     C                   MOVE      *BLANKS       WFSCNU            6                          CSD027
     C                   Z-ADD     0             WFSVAL           15 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBLDSFL1 - Build Sub-File by Collateral Reference Order     *
      *                                                               *
      *****************************************************************
     C     SRBLDSFL1     BEGSR
      *
      ** Set indicator ans flag for Midas (back) office trade number key used
      *
     C                   MOVE      'B'           @ORD              1
     C                   MOVE      *OFF          *IN20
      *
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SRCHKAUT
     C                   ENDIF
      *
      ** Validate Review collateral reference/select fields.
      *
     C                   EXSR      SRVALREF
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     GLCOLLC1
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     GLCOLLF1
      *
      **  Set file pointer on key displayed on screen.
      *
     C     DDREVF        SETLL     GLCOLLX1
      *
      ** Read a Valid Collateral
      *
     C                   EXSR      SRRDCOLL
      *
      **  If no records exist - set up an error message.
      **  and terminate
      *
     C     EndOfFile     IFEQ      True
     C                   MOVEL     'GLM0001'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     EndOfFile     DOWEQ     False
     C     *IN98         ANDEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     EndOfFile     DOWEQ     False
     C     @@CNT         ANDLT     14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format collateral fields for output
      *
     C                   EXSR      SRFMTDET
      *
      **  Write the collateral details to the subfile.
      *
     C                   MOVE      *BLANK        DDACTN
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     GLCOLLS1
      *
      ** Read a Valid Collateral
      *
     C                   EXSR      SRRDCOLL
      *
     C                   ENDDO
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   TIME                    DDTIME
     C                   WRITE     GLCOLLC1
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      GLCOLLC1                               99
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     True          PINKC
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
      **  If F9, bypass further processing.
      *
     C     *INKI         IFEQ      '1'
     C                   MOVEL     True          PINKI
     C                   RETURN
     C                   ENDIF
      *
      **  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     True          PINKL
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBLDSFL2 - Build Sub-File by Front Office Id Order          *
      *                                                               *
      *****************************************************************
     C     SRBLDSFL2     BEGSR
      *
      * Set indicator and flag for Midas (back) office collateral ref. key used
      *
     C                   MOVE      'F'           @ORD
     C                   MOVE      '1'           *IN20
      *
      ** Check for user Authority to Browse IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SRCHKAUT
     C                   ENDIF
      *
      * Validate review collateral reference/select fields.
      *
     C                   EXSR      SRVALREF
      *
      **  Get Front Office Collateral Ref.
      *
     C     DDREVF        CHAIN     GLCOLLX1                           89
     C                   MOVE      CDFRNT        REVFFOTID        20
     C     *IN89         IFEQ      '1'
     C                   MOVE      *BLANK        REVFFOTID
     C                   ENDIF
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     GLCOLLC2
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     GLCOLLF1
      *
      **  Set file pointer on key displayed on screen.
      *
     C     REVFFOTID     SETLL     GLCOLLL0
      *
      ** Read a Valid Collateral
      *
     C                   EXSR      SRRDCOLL
      *
      **  If no records exist - set up an error message.
      **  and terminate
      *
     C     EndOfFile     IFEQ      True
     C                   MOVEL     'GLM0001'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     EndOfFile     DOWEQ     False
     C     *IN98         ANDEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     EndOfFile     DOWEQ     False
     C     @@CNT         ANDLT     14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      ** Format collateral fields for output
      *
     C                   EXSR      SRFMTDET
      *
      **  Write the trade to the subfile.
      *
     C                   MOVE      *BLANK        DDACTN
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     GLCOLLS2
      *
      ** Read a Valid Collateral
      *
     C                   EXSR      SRRDCOLL
     C                   ENDDO
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   TIME                    DDTIME
     C                   WRITE     GLCOLLC2
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      GLCOLLC2                               99
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     True          PINKC
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
      **  If F9, bypass further processing.
      *
     C     *INKI         IFEQ      '1'
     C                   MOVEL     True          PINKI
     C                   RETURN
     C                   ENDIF
      *
      **  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     True          PINKL
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDSFL - Read Sub-File processing                           *
      *                                                               *
      *****************************************************************
     C     SRRDSFL       BEGSR
      *
      **  Read the subfile for selected records
      **  Only process those for which the action field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDACTN        ORNE      *BLANK
     C     @ORD          IFNE      'F'
     C                   READC     GLCOLLS1                               99
     C                   ELSE
     C                   READC     GLCOLLS2                               99
     C                   ENDIF
     C                   ENDDO
      *
      **  Return the selected collateral reference and action
      *
     C     *IN99         IFNE      '1'
     C     DDACTN        ANDNE     *BLANK
      *
     C     PENQ          IFEQ      'E'
     C                   MOVE      'E'           DDACTN
     C                   ENDIF
      *
     C                   MOVE      DDACTN        POPSEL
     C                   MOVE      DDCREF        PCOSEL
      *
     C     DDACTN        IFEQ      'X'
     C     CGL012        ANDNE     'Y'
     C                   MOVEL     'COL0002'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
      ** If Midas-Risk Weighted Assets Feature Is Switched On,                                CGL018
      ** New Action Code Is To Be Allowed.                                                    CGL018
      *                                                                                       CGL018
     C     CGL018        IFEQ      'Y'                                                        CGL018
     C                   IF        (DDACTN <> 'A') AND (DDACTN <> 'D') AND                    CGL018
     C                             (DDACTN <> 'E') AND (DDACTN <> 'G') AND                    CGL018
     C                             (DDACTN <> 'N') AND (DDACTN <> 'X') AND                    CGL018
     C                             (DDACTN <> 'Z')                                            CGL018
     C                   MOVEL     'COL0129'     PERRMS                                       CGL018
     C                   RETURN                                                               CGL018
     C                   ENDIF                                                                CGL018
     C                   ELSE                                                                 CGL018
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'G'
     C     DDACTN        ANDNE     'N'
     C     DDACTN        ANDNE     'X'
     C                   MOVEL     'COL0003'     PERRMS
     C                   RETURN
     C                   ENDIF
      *                                                                                       CGL018
     C                   ENDIF                                                                CGL018
      *
     C     DDACTN        IFNE      'E'
     C     DDAUTH        ANDEQ     'DELT'
     C                   MOVEL     'COL0008'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'G'
     C     DDGNSP        ANDNE     'G'
     C                   MOVEL     'COL0009'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'X'
     C     DDAUTH        IFEQ      'AUTH'
     C                   MOVEL     'COL0013'     PERRMS
     C                   RETURN
     C                   ENDIF
     C     DDIUSR        IFEQ      PSUser
     C     DDIUSR        OREQ      PSUser
     C                   MOVEL     'COL0014'     PERRMS
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFMTDET - Format Collateral Details for Output to Sub-File  *
      *                                                               *
      *****************************************************************
     C     SRFMTDET      BEGSR
      *
      ** Clear subfile fields first.
     C                   MOVEL     *Blanks       DDCREF
     C                   MOVEL     *Blanks       DDFRNT
     C                   MOVEL     *Blanks       DDENTY
     C                   MOVEL     *Blanks       DDCMPY
     C                   MOVEL     *Blanks       DDBRCA
     C                   MOVEL     *Blanks       DDCOLT
     C                   MOVEL     *Blanks       DDCUSN
     C                   MOVEL     *Blanks       DDSTAT
     C                   MOVEL     *Blanks       DDCCY
     C                   MOVEL     *Blanks       DDLAMT
     C                   MOVEL     *Blanks       DDGNSP
     C                   MOVEL     *Blanks       DDAUTH
     C                   MOVEL     *Blanks       DDIUSR
     C                   MOVEL     *Blanks       DDAUSR
     C                   MOVEL     *Blanks       DDRECS
      *
     C                   MOVEL     CDCREF        DDCREF
     C                   MOVEL     CDFRNT        DDFRNT
     C                   MOVEL     CDENTY        DDENTY
     C                   MOVEL     CDCMPY        DDCMPY
     C                   MOVEL     CDBRCA        DDBRCA
     C                   MOVEL     CDCOLT        DDCOLT
     C                   MOVEL     CDCNUM        DDCUSN
     C                   MOVEL     CDCCY         DDCCY
     C                   MOVEL     CDGNSP        DDGNSP
      *
     C     CDSTAT        IFEQ      'C'
     C                   MOVEL     'COM'         DDSTAT
     C                   ENDIF
      *
     C     CDSTAT        IFEQ      'E'
     C                   MOVEL     'EXP'         DDSTAT
     C                   ENDIF
      *
     C     CDSTAT        IFEQ      'I'
     C                   MOVEL     'INC'         DDSTAT
     C                   ENDIF
      *
     C     CDSTAT        IFEQ      'R'
     C                   MOVEL     'REQ'         DDSTAT
     C                   ENDIF
      *
     C     CDSTAT        IFEQ      'U'
     C                   MOVEL     'REV'         DDSTAT
     C                   ENDIF
      *
     C     CGL012        IFEQ      'Y'
     C                   MOVE      CDIUSR        DDIUSR
     C                   MOVE      CDAUSR        DDAUSR
     C     CDAUTH        IFEQ      'C'
     C                   MOVEL     'COMP'        DDAUTH
     C                   ENDIF
     C     CDAUTH        IFEQ      'R'
     C                   MOVEL     'REQR'        DDAUTH
     C                   ENDIF
     C     CDAUTH        IFEQ      'A'
     C                   MOVEL     'AUTH'        DDAUTH
     C                   ENDIF
     C                   ENDIF
      *
     C     CDRECI        IFEQ      'R'
     C                   MOVEL     'DELT'        DDAUTH
     C                   MOVEL     'D'           DDRECS
     C                   ENDIF
      *
     C     CDCCY         IFNE      SCYCD
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      CDCCY         PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Database error
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     CDCCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      CDCCY         SCYCD             3
     C                   Z-ADD     A6NBDP        SNBDP             1 0
      *
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      CDLAMT        ZFIELD
     C                   Z-ADD     SNBDP         ZADEC
     C                   EXSR      SRZEDIT
     C                   MOVE      ZFIELD        DDLAMT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZEDIT - Edit Unsigned Amount for Screen Output             *
      *                                                               *
      *****************************************************************
     C     SRZEDIT       BEGSR
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDCOLL - Read a Valid Collateral Record from file          *
      *                                                               *
      *****************************************************************
     C     SRRDCOLL      BEGSR
      *
      **  Reset End of File indicator and Valid Record processed
      *
     C                   MOVE      False         EndOfFile
     C                   MOVE      'N'           ValidRec          1
      *
      **  Read the file initially - if EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C     EndOfFile     DOUEQ     True
     C     ValidRec      OREQ      'Y'
      *
      **  Read the file.
      *
     C     @ORD          IFEQ      'B'
     C                   READ      GLCOLLX1                               96
     C                   ELSE
     C                   READ      GLCOLLL0                               96
     C                   ENDIF
      *
      ** If collateral read, check whether user can see it
      *
     C     EndOfFile     IFEQ      False
      *
     C     CDBRCA        IFEQ      *BLANKS
     C                   MOVEL     WWDBRN        ZBR
     C                   ELSE
     C                   MOVEL     CDBRCA        ZBR
     C                   ENDIF
      *
     C     BJSBRC        IFEQ      *BLANKS
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    ZBR               3
     C                   PARM      0             ERR
     C                   ENDIF
      *
     C                   MOVE      *ALL'Y'       SelFldVald
      *
     C     DDREQR        IFEQ      'Y'
     C     CDAUTH        ANDEQ     'A'
     C                   MOVE      'N'           REQR_Vald
     C                   ENDIF
      *
     C     DDSENT        IFNE      *BLANK
     C     DDSENT        ANDNE     CDENTY
     C                   MOVE      'N'           SENT_Vald
     C                   ENDIF
      *
     C     DDSCMP        IFNE      *BLANKS
     C     DDSCMP        ANDNE     CDCMPY
     C                   MOVE      'N'           SCMP_Vald
     C                   ENDIF
      *
     C     DDSBRC        IFNE      *BLANKS
     C     DDSBRC        ANDNE     CDBRCA
     C                   MOVE      'N'           SBRC_Vald
     C                   ENDIF
      *
     C     DDSCOL        IFNE      *BLANKS
     C     DDSCOL        ANDNE     CDCOLT
     C                   MOVE      'N'           SCOL_Vald
     C                   ENDIF
      *
     C*****WFSCNU        IFNE      0                                                          CSD027
     C     WFSCNU        IFNE      *BLANKS                                                    CSD027
     C     WFSCNU        ANDNE     CDCNUM
     C                   MOVE      'N'           SCNU_Vald
     C                   ENDIF
      *
     C     DDSCCY        IFNE      *BLANKS
     C     DDSCCY        ANDNE     CDCCY
     C                   MOVE      'N'           SCCY_Vald
     C                   ENDIF
      *
     C     WFSVAL        IFNE      0
     C     WFSVAL        ANDNE     CDLAMT
     C                   MOVE      'N'           SVAL_Vald
     C                   ENDIF
      *
     C     DDSGNS        IFNE      *BLANK
     C     DDSGNS        ANDNE     CDGNSP
     C                   MOVE      'N'           SGNS_Vald
     C                   ENDIF
      *
     C     SELFLDVALD    IFEQ      *ALL'Y'
     C     ERR           ANDEQ     *ZERO
     C                   MOVE      'Y'           ValidRec
     C                   ELSE
     C                   MOVE      'N'           ValidRec
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALREF - Review From/Select Field Validation process       *
      *                                                               *
      *****************************************************************
     C     SRVALREF      BEGSR
      *
      ** Validate Review From Collateral Reference
     C     DDREVF        IFNE      *BLANKS
      *
     C                   MOVEL     *Blanks       ZFIELD
     C                   MOVEL     DDREVF        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     10            ZADIG
     C                   EXSR      SRZALIGN
      *
     C     ZAlignOk      IFNE      'Y'
     C     ZFIELD        OREQ      *Zeros
     C                   MOVEL     'COL0015'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Requiring Authorisation
     C     DDREQR        IFNE      *Blank
     C     DDREQR        ANDNE     'Y'
     C                   MOVEL     'COL0016'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
      ** Validate Select Entity Level
     C     DDSENT        IFNE      *Blank
     C     DDSENT        ANDNE     'K'
     C     DDSENT        ANDNE     'C'
     C     DDSENT        ANDNE     'B'
     C                   MOVEL     'COL0017'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
      ** Validate Select Company
     C     DDSCMP        IFNE      *Blanks
     C     DDSENT        IFNE      'C'
      *
     C                   MOVEL     'COL0018'     PERRMS
     C                   RETURN
      *
     C                   ELSE
      *
     C                   CALL      'AOCOMPR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDSCMP        PCOMP             3
     C     SDCOMP        PARM      SDCOMP        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'COL0019'     PERRMS
     C                   RETURN
     C                   ELSE
     C                   MOVEL     APCMCD        DDSCMP
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Select Branch
     C     DDSBRC        IFNE      *Blanks
     C     DDSENT        IFNE      'B'
      *
     C                   MOVEL     'COL0020'     PERRMS
     C                   RETURN
      *
     C                   ELSE
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDSBRC        PBRCD             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'COL0021'     PERRMS
     C                   RETURN
     C                   ELSE
     C                   MOVEL     A8BRCD        DDSBRC
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Select Collateral Type
     C     DDSCOL        IFNE      *Blanks
      *
     C                   CALL      'AOCOTPR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDSCOL        PCOTP             5
     C     SDCOTP        PARM      SDCOTP        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'COL0022'     PERRMS
     C                   RETURN
     C                   ELSE
     C                   MOVEL     CTCOLT        DDSCOL
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Select Collateral Customer
     C     DDSCNU        IFNE      *Blanks
      *
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDSCNU        PKEY1            10
     C                   PARM      *Blanks       PKYST             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'COL0023'     PERRMS
     C                   RETURN
     C                   ELSE
     C                   MOVEL     *BLANKS       DDSCNU
     C                   MOVEL     BBCUST        DDSCNU
     C                   MOVE      BBCUST        WFSCNU
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Select Collateral Currency
     C     DDSCCY        IFNE      *Blanks
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDSCCY        PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'COL0024'     PERRMS
     C                   RETURN
     C                   ELSE
     C                   MOVEL     A6CYCD        DDSCCY
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Select Collateral Value
     C     DDSVAL        IFNE      *Blanks
      *
     C     DDSCCY        IFNE      *Blanks
     C                   Z-ADD     A6NBDP        ZADEC
     C                   ELSE
     C                   Z-ADD     2             ZADEC
     C                   ENDIF
      *
     C                   EVAL      ZADIG = 15 - ZADEC
     C                   MOVEL     *Blanks       ZFIELD
     C                   MOVEL     DDSVAL        ZFIELD
     C                   EXSR      SRZALIGN
      *
     C     ZAlignOk      IFNE      'Y'
     C     ZFIELD        OREQ      *Zeros
     C                   MOVEL     'COL0025'     PERRMS
     C                   RETURN
     C                   ELSE
     C                   MOVE      ZFIELD        WFSVAL
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Select General/Specific Indicator
     C     DDSGNS        IFNE      *Blank
     C     DDSGNS        ANDNE     'G'
     C     DDSGNS        ANDNE     'S'
     C                   MOVEL     'COL0026'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHKAUT - Authority Validation processing                   *
      *                                                               *
      *****************************************************************
     C     SRCHKAUT      BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM      0             ERR               1 0
      *
     C     ERR           IFEQ      1
     C                   MOVEL     'FXM0292'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZALIGN - Validate/Right allign numeric field               *
      *                                                               *
      *****************************************************************
     C     SRZALIGN      BEGSR
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZAlignOk
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChr2Num - Convert Select Customer and Select Collateral    *
      *              Value to numeric.                                *
      *                                                               *
      *****************************************************************
     C     SRChr2Num     BEGSR
      *
      ** Get currency number of decimal places
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDSCCY        PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     DDSCCY        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Dealing ICD
      *
     C**********         CallB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   Parm      *BLANKS       PRTCD
     C                   Parm      '*FIRST '     POPTN
     C*****SDDEAL        Parm      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   Z-ADD     004           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Convert amount to numeric
      *
      ** Set up parameter for ZA0840
      *
     C                   Z-ADD     A6NBDP        @@IDP             3 0
     C     15            SUB       @@IDP         @@IINT            3 0
     C                   MOVE      *Blanks       @@ALPH           16
     C                   MOVE      'N'           @@MTID            1
      *
      ** Convert Select Customer field from char to numeric
      *
     C                   Movel     DDSCNU        @@ALPH
      *
     C                   CALLB     'ZA0840'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD            1 0
     C                   PARM                    @@AMT            15 0
     C                   PARM                    BNDCSP
      *
      ** No error found on conversion
      *
     C     RETCODEOUT    IFEQ      *BLANKS
     C                   Z-ADD     @@AMT         WWNUM6            6 0
     C                   ELSE
     C                   MOVEL     DDSCNU        DBKEY
     C                   MOVEL     'ZA0840  '    DBFILE
     C                   Z-ADD     005           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Convert Select Collateral Value field from char to numeric
      *
     C                   MOVE      *Blanks       @@ALPH
     C                   MOVEL     DDSVAL        @@ALPH
 
     C                   CALLB     'ZA0840'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD            1 0
     C                   PARM                    @@AMT            15 0
     C                   PARM                    BNDCSP
      *
      ** No error found on conversion
      *
     C     RETCODEOUT    IFEQ      *BLANKS
     C                   Z-ADD     @@AMT         WWNUM15          15 0
     C                   ELSE
     C                   MOVEL     DDSVAL        DBKEY
     C                   MOVEL     'ZA0840  '    DBFILE
     C                   Z-ADD     006           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS:
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Initial screen fields
     C                   PARM                    DDREVF
     C                   PARM                    DDREQR
     C                   PARM                    DDSENT
     C                   PARM                    DDSCMP
     C                   PARM                    DDSBRC
     C                   PARM                    DDSCOL
     C                   PARM                    DDSCNU
     C                   PARM                    DDSCCY
     C                   PARM                    DDSVAL
     C                   PARM                    DDSGNS
      *
      ** Enquiry Mode
     C                   PARM                    PENQ              1
      *
     C                   PARM                    CGL012            1
      *
      ** Build subfile
     C                   PARM                    PBDSFL            1
      *
      ** Read subfile record
     C                   PARM                    PRDSFL            1
      *
      ** OUTPUT PARAMETERS:
      *
      ** Function key taken
     C                   PARM                    PINKC             1
     C                   PARM                    PINKI             1
     C                   PARM                    PINKL             1
      *
      ** Error message
      ** Display file action
      ** Collateral Reference selected
     C                   PARM                    PERRMS            7
     C                   PARM                    POPSEL            1
     C                   PARM                    PCOSEL           10
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLCOLLBRW  ' DBPGM
     C                   OUT       LDA
      *
      ** Lock in data area, ZMUSER, to access the default branch.
      *
     C     *LOCK         IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
      ** Save Default Branch
      *
     C                   MOVE      DBRN          WWDBRN            3
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PSUser        DDUSER
     C                   MOVEL     PSJobName     DDWSID
      *
      ** Access Bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set screen authorisation fields to display if CGL012 is present.
     C     CGL012        IFEQ      'Y'
     C                   MOVE      *ON           *IN70
     C                   ELSE
     C                   MOVE      *OFF          *IN70
     C                   ENDIF
      *
      ** Disable CMD11 processing.
      ** Note: *IN11 should be SET-ON when API processing for collateral
      ** is to be introduced.
      *
     C                   MOVE      *OFF          *IN11
      *
      ** Access SAR details file to determine if CGL018 is on.                                CGL018
      *                                                                                       CGL018
     C                   CALLB     'AOSARDR0'                                                 CGL018
     C                   PARM      *BLANKS       @RTCD                                        CGL018
     C                   PARM      '*VERIFY'     @OPTN                                        CGL018
     C                   PARM      'CGL018'      @SARD                                        CGL018
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL018
      *                                                                                       CGL018
      ** Database Error                                                                       CGL018
      *                                                                                       CGL018
     C     @RTCD         IFNE      *BLANKS                                                    CGL018
     C     @RTCD         ANDNE     '*NRF   '                                                  CGL018
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL018
     C                   Z-ADD     7             DBASE                                        CGL018
     C                   MOVEL     'CGL018'      DBKEY                                        CGL018
     C                   EXSR      *PSSR                                                      CGL018
     C                   END                                                                  CGL018
      *                                                                                       CGL018
     C     @RTCD         IFEQ      *BLANK                                                     CGL018
     C                   MOVE      'Y'           CGL018            1                          CGL018
     C                   ELSE                                                                 CGL018
     C                   MOVE      'N'           CGL018                                       CGL018
     C                   END                                                                  CGL018
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
