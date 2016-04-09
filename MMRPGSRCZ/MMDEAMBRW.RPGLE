     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal amendments browse')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMDEAMBRW - DEAL AMENDMENTS BROWSE                           *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of deal amendments for         *
      *             selection, the other picks off the selection made.*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 221673             Date 10Feb05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 166221             Date 24Nov99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 08Nov99               *
      *                 CAP051             Date 12Nov99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 26Aug98               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL033 - Included 221673 for this development.               *
      *  221673 - Display negative sign of negative SC amendment.     *
      *           Applied fixes 220497 and 221126.                    *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDEAMPP *
      *  166221 - Browse by Front Office ID not functioning correctly *
      *  CSE006 - Repos Enhancements                                  *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMDEAMPP               *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDEAMPP               *
      *  CAP004 - API's Phase 3.                                      *
      *           Allow browse by Front Office Id.                    *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMMDEAMBDF CF   E             WORKSTN
     F                                     SFILE(MMDEAMS1:@@RRN)
     F                                     SFILE(MMDEAMS3:@@RRN)                CAP004
     FMMCMPLLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(MMDENSP0)
     F                                     IGNORE(MMDENBP0)
     F                                     IGNORE(MMDELDP0)
     F                                     RENAME(MMDEAMP0:MMCMPLP0)
     FMMCARMLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDEAMP0:MMDEAMP1)
     FMMDEAML0  IF   E           K DISK    INFSR(*PSSR)                         CAP004
     F                                     RENAME(MMDEAMP0:MMFODLL0)            CAP004
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)                         CSE006
     FMMCMPLL1  IF   E           K DISK    INFSR(*PSSR)                                       166221
     F                                     IGNORE(MMDENSP0)                                   166221
     F                                     IGNORE(MMDENBP0)                                   166221
     F                                     IGNORE(MMDELDP0)                                   166221
     F                                     RENAME(MMDEAMP0:MMFODLL1)                          166221
     F/COPY WNCPYSRC,MMDEAMBF01
 
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
                                                                                CSE006
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CSE006
      ** EXTERNAL DS FOR SAR DETAILS                                            CSE006
 
     D                 DS
     D  @@YEAR                 1      4  0
     D  @@MNTH                 5      6  0
     D  @@DAY                  7      8  0
     D  @@DTIN                 1      8  0
 
     D                 DS
     D**  Data Structure to split value date used in key to deams file
     D  @KVALD                 1      8  0
     D  @VDYY                  1      4  0
     D  @VYEAR                 3      4  0
     D  @VDMM                  5      6  0
     D  @VDDD                  7      8  0
 
     D                 DS
     D**  Data Structure for screen value date
     D  @DMY                   1      6
     D  @DSPD                  1      2
     D  @DSPM                  3      4
     D  @DSPY                  5      6
 
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
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
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      * BUILD SUB-FILE
      *
     C     @BDSFL        IFEQ      'Y'
      *                                                                         CAP004
      **  If First time in or subfile by Midas deal number was previously       CAP004
      **  being run, then build subfile keyed on Midas deal number.             CAP004
      **  Stay in loop while F11 toggle key is used.                            CAP004
      *                                                                         CAP004
     C     WDEAL         IFNE      'F'                                          CAP004
     C     *INKK         DOUEQ     '0'                                          CAP004
     C                   EXSR      BLDSFL
      *                                                                         CAP004
      **  If F11, switch to Front Office Deal subfile                           CAP004
      *                                                                         CAP004
     C     *INKK         IFEQ      '1'                                          CAP004
     C                   EXSR      BLDSFL2                                      CAP004
     C                   END                                                    CAP004
     C                   END
      *
     C                   ELSE                                                   CAP004
      *
      **  If the subfile by Front Office Identifier was previously              CAP004
      **  being run, then build subfile keyed on Front Office ID.               CAP004
      **  Stay in loop while F11 toggle key is used.                            CAP004
      *
     C     *INKK         DOUEQ     '0'                                          CAP004
     C                   EXSR      BLDSFL2                                      CAP004
      *                                                                         CAP004
      **  If F11, switch to Midas Deal Number subfile                           CAP004
      *                                                                         CAP004
     C     *INKK         IFEQ      '1'                                          CAP004
     C                   EXSR      BLDSFL                                       CAP004
     C                   END                                                    CAP004
     C                   END                                                    CAP004
     C                   END                                                    CAP004
     C                   END
      *
      * READ SUBFILE RECORD
      *
     C     @RDSFL        IFEQ      'Y'
     C                   EXSR      RDSFLR
     C                   END
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - BUILD SUBFILE
      ********************************************************************
     C     BLDSFL        BEGSR
      *                                                                         CAP004
      * Set indicator and flag for Midas (back) office deal number key used     CAP004
      *                                                                         CAP004
     C                   MOVE      'B'           WDEAL                          CAP004
     C                   MOVE      '0'           *IN20                          CAP004
      *
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      ** Validate Deal Number / Value Date / Sequence No. combination.
      *
     C                   EXSR      VALDAF
     C/COPY WNCPYSRC,MMDEAMBC06
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     MMDEAMS0
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     MMDEAMF1
      *
      **  Set file pointer on key displayed on screen.
      *
     C     DDACTN        IFEQ      'X'
     C     @DMKEY        SETLL     MMCMPLP0
     C                   ELSE
     C     @DMKEY        SETLL     MMCARMLL
     C                   END
      *
      * READ A VALID DEAM
      *
     C                   EXSR      RDDEAM
      *
      **  If no records exist - set up an error message.
      **  and terminate
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'MMM1007'     @ERRMS
     C                   RETURN
     C                   END
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
     C     @@EOF         DOWNE     'Y'
     C     *IN98         ANDEQ     '1'
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     14
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      * Format Deal Amendment fields for output
      *
     C                   EXSR      FMTDEM
      *
      **  Write the deal amendment to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     MMDEAMS1
      *
      * READ A VALID DEAL AMENDMENT
      *
     C                   EXSR      RDDEAM
     C                   END
      *
      **  Retrieve time
      *
     C                   TIME                    DDTIME
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     MMDEAMS0
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      MMDEAMS0                               99
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      **  If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           @INKL
     C                   RETURN
     C                   END
      *
     C/COPY WNCPYSRC,MMDEAMBC07
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL2 - BUILD SUBFILE (For Front Office ID)                           CAP004
      ********************************************************************      CAP004
     C     BLDSFL2       BEGSR                                                  CAP004
      *                                                                         CAP004
      * Set indicator and flag for Midas (back) office deal number key used     CAP004
      *                                                                         CAP004
     C                   MOVE      'F'           WDEAL             1            CAP004
     C                   MOVE      '1'           *IN20                          CAP004
      *                                                                         CAP004
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING               CAP004
      *                                                                         CAP004
     C     BJSBRC        IFNE      *BLANK                                       CAP004
     C                   EXSR      CHAUTN                                       CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      ** Validate Deal Number / Value Date / Sequence No. combination.          CAP004
      *                                                                         CAP004
     C                   EXSR      VALDAF                                       CAP004
      *                                                                         CAP004
      **  Get Front Office Id                                                   CAP004
      *                                                                         CAP004
     C     DDACTN        IFEQ      'X'                                          CAP004
     C     @DMKEY        CHAIN     MMCMPLP0                           89        CAP004
     C                   ELSE                                                   CAP004
     C     @DMKEY        CHAIN     MMCARMLL                           89        CAP004
     C                   END                                                    CAP004
     C                   MOVE      HNFRNT        @@FODL           20            CAP004
     C     *IN89         IFEQ      '1'                                          CAP004
     C                   MOVE      *BLANK        @@FODL                         CAP004
     C                   END                                                    CAP004
     C/COPY WNCPYSRC,MMDEAMBC08
      *                                                                         CAP004
      **  Initialise subfile relative record number.                            CAP004
      *                                                                         CAP004
     C                   Z-ADD     0             @@RRN             5 0          CAP004
      *                                                                         CAP004
      **  Clear subfile before refilling by writing control record              CAP004
      **  with SFLCLR active.                                                   CAP004
      *                                                                         CAP004
     C                   MOVE      '1'           *IN97                          CAP004
     C                   WRITE     MMDEAMS2                                     CAP004
     C                   MOVE      '0'           *IN97                          CAP004
      *                                                                         CAP004
      **  Write the select screen footer to the screen.                         CAP004
      *                                                                         CAP004
     C                   WRITE     MMDEAMF1                                     CAP004
      *                                                                         CAP004
      **  Set file pointer on key displayed on screen.                          CAP004
      *                                                                         CAP004
     C     @@FODL        SETLL     MMFODLL0                                     CAP004
     C     @@FODL        SETLL     MMFODLL1                                                   166221
      *                                                                         CAP004
      * READ A VALID DEAM                                                       CAP004
      *                                                                         CAP004
     C                   EXSR      RDDEAM                                       CAP004
      *                                                                         CAP004
      **  If no records exist - set up an error message.                        CAP004
      **  and terminate                                                         CAP004
      *                                                                         CAP004
     C     @@EOF         IFEQ      'Y'                                          CAP004
     C                   MOVEL     'MMM1007'     @ERRMS                         CAP004
     C                   RETURN                                                 CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      **  Set on ROLLUP indicator to drive initial loop.                        CAP004
      *                                                                         CAP004
     C                   MOVE      '1'           *IN98                          CAP004
      *                                                                         CAP004
      **  Read records from the file into the subfile until a page has          CAP004
      **  been filled or there are no more records.                             CAP004
      **  Repeat the process until either the end of file, ROLLUP               CAP004
      **  has not been entered or F3 or F12 is input.                           CAP004
      *                                                                         CAP004
     C     @@EOF         DOWNE     'Y'                                          CAP004
     C     *IN98         ANDEQ     '1'                                          CAP004
      *                                                                         CAP004
      **  Initialise count of records written to subfile page.                  CAP004
      *                                                                         CAP004
     C                   Z-ADD     0             @@CNT             3 0          CAP004
      *                                                                         CAP004
      **  For each record read, write it to the subfile.                        CAP004
      **  Do this until end of file or the subfile page is full.                CAP004
      *                                                                         CAP004
     C     @@EOF         DOWNE     'Y'                                          CAP004
     C     @@CNT         ANDLT     14                                           CAP004
      *                                                                         CAP004
      **  Increment the subfile record no. and records written fields.          CAP004
      *                                                                         CAP004
     C                   ADD       1             @@RRN                          CAP004
     C                   ADD       1             @@CNT                          CAP004
      *                                                                         CAP004
      * Format Deal Amendment fields for output                                 CAP004
      *                                                                         CAP004
     C                   EXSR      FMTDEM                                       CAP004
      *                                                                         CAP004
      **  Write the deal amendment to the subfile.                              CAP004
      *                                                                         CAP004
     C                   MOVE      *BLANK        DDOPT                          CAP004
     C                   Z-ADD     @@RRN         DDSFRN                         CAP004
     C                   WRITE     MMDEAMS3                                     CAP004
      *                                                                         CAP004
      * READ A VALID DEAL AMENDMENT                                             CAP004
      *                                                                         CAP004
     C                   EXSR      RDDEAM                                       CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      **  Retrieve time                                                         CAP004
      *                                                                         CAP004
     C                   TIME                    DDTIME                         CAP004
      *                                                                         CAP004
      **  Write the subfile control record to the screen to display             CAP004
      **  the subfile.                                                          CAP004
      *                                                                         CAP004
     C                   WRITE     MMDEAMS2                                     CAP004
      *                                                                         CAP004
      **  Read the subfile control record to determine whether records          CAP004
      **  have been selected or whether ROLLUP is required.                     CAP004
      *                                                                         CAP004
     C                   READ      MMDEAMS2                               99    CAP004
      *                                                                         CAP004
      **  If F3, bypass further processing.                                     CAP004
      *                                                                         CAP004
     C     *INKC         IFEQ      '1'                                          CAP004
     C                   MOVEL     '1'           @INKC                          CAP004
     C                   SETON                                        LR        CAP004
     C                   RETURN                                                 CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      **  If F12, bypass further processing.                                    CAP004
      *                                                                         CAP004
     C     *INKL         IFEQ      '1'                                          CAP004
     C                   MOVEL     '1'           @INKL                          CAP004
     C                   RETURN                                                 CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
     C/COPY WNCPYSRC,MMDEAMBC09
     C                   END                                                    CAP004
      *                                                                         CAP004
     C                   ENDSR                                                  CAP004
      ********************************************************************      CAP004
      /EJECT                                                                    CAP004
      ********************************************************************      CAP004
      * RDSFLR - READ SUBFILE RECORD
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
     C     WDEAL         IFNE      'F'                                          CAP004
     C                   READC     MMDEAMS1                               99
     C                   ELSE                                                   CAP004
     C                   READC     MMDEAMS3                               99    CAP004
     C                   END                                                    CAP004
     C                   END
      *
      **  Return the selected deal number, value date, seq and option
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
     C                   MOVE      DDDEAL        @DLSEL
     C                   MOVE      DDVALD        @VDSEL
     C                   MOVE      DDSEQ         @SQSEL
      *
     C                   END
      *
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTDEM - FORMAT DEAL AMENDMENT FIELDS FOR OUTPUT
      ******************************************************************
     C     FMTDEM        BEGSR
      *
      * Deal number
      *
     C                   MOVE      HNDA38        DDDEAL
      *                                                                         CAP004
      * Front Office Deal number                                                CAP004
      *                                                                         CAP004
     C                   MOVE      HNFRNT        DDFODN                         CAP004
      *
      * Deal amendment type
      *
     C                   MOVE      HNMTYP        DDTYPE
      *
      * Deal currency.
      *
     C                   MOVE      HNCCY         DDCCY
      *
      * Value date
      *
     C                   Z-ADD     HNVDYY        @@YEAR
     C                   Z-ADD     HNVDMM        @@MNTH
     C                   Z-ADD     HNVDDD        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDVALD
     C                   ELSE
     C                   MOVE      *BLANKS       DDVALD
     C                   END
      *
      **  Account Sequnce Number.
      *
     C     HNDS38        IFEQ      0                                            B**3
     C                   MOVE      *BLANKS       DDSEQ                          ***3
     C                   ELSE                                                   X**3
     C                   MOVE      HNDS38        DDSEQ                          ***3
     C                   END                                                    E**3
     C*
     C**  Interest Rate/spread.
     C*
     C**  Interest Rate.
     C**  - Execute FMTAMT to format the rate, using 8 decimal places
     C**    and adjusting the file figure to have only implied decimal
     C**    places.
     C     HNINTR        IFEQ      0                                            B**3
     C                   MOVE      *BLANKS       DDINTR                         ***3
     C                   ELSE                                                   X**3
     C     HNINTR        MULT      10000000      @@AMTW                         ***3
     C                   Z-ADD     7             @@QECN                         ***3
     C*
     C****Reverse*sign*for*display*if*amount*-ve.**********************                       221673
     C*****@@AMTW        IFLT      0                                            B*2           221673
     C**********         Z-SUB     @@AMTW        @@AMTW                         **2           221673
     C**********         END                                                    E*2           221673
     C*
     C                   EXSR      FMTAMT                                       ***3
     C                   MOVE      @@AMTD        DDINTR                         ***3
     C                   END                                                    E**3
      *
      * Deal amendment amount.
      *
     C     HNAMNP        IFEQ      0
     C                   MOVE      *BLANKS       DDSAMN
     C                   ELSE
      *
     C     HNAMNP        IFLT      0
     C                   Z-SUB     HNAMNP        @@IAMT
     C                   ELSE
     C                   Z-ADD     HNAMNP        @@IAMT
     C                   END
     C                   Z-ADD     17            @@CRET
     C                   Z-ADD     HNCYDP        @@CDP
     C*
     C                   EXSR      FMTEAM
     C                   MOVE      @@ADSP        DDSAMN
      *
     C                   END
      *
      * Deal amendment status
      *
     C                   MOVE      HNDSTS        DDDSTS
      *
      **  If the deal amendment has been deleted then show this.
      *
     C     HNDDLT        IFEQ      'D'
     C                   MOVE      '1'           *IN95
     C                   MOVEL     'ZZGBMSGF'    MSGNM
     C                   MOVEL     'ZZM1614'     MSGDNB
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGDNB            7
     C                   PARM                    MSGNM            10
     C                   PARM                    MSGTXT           80
     C                   MOVEL     MSGTXT        DDTEXT
     C                   ELSE
     C                   MOVE      '0'           *IN95
     C                   MOVE      *BLANKS       DDTEXT
      *
     C                   END
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      *****************************************************************
      * RDDEAM - READ A DEAL AMENDMENT
      *****************************************************************
     C     RDDEAM        BEGSR
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  If switch only only process non repo deals                            CSE006
     C                   IF        CSE006 <> 'Y'                                CSE006
      *                                                                         CSE006
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C     @@EOF         DOUEQ     'Y'
     C     HNDLTF        OREQ      *BLANKS
     C     @@ERR         ANDEQ     *ZERO
     C/COPY WNCPYSRC,MMDEAMBC01
      *
      **  Read the file.
      *
     C     WDEAL         IFEQ      'B'                                          CAP004
     C     DDACTN        IFEQ      'X'
     C                   READ      MMCMPLP0                               96
     C                   ELSE
     C                   READ      MMCARMLL                               96
     C                   END
     C                   ELSE                                                   CAP004
     C     DDACTN        IFEQ      'X'                                                        166221
     C                   READ      MMFODLL1                               96                  166221
     C                   ELSE                                                                 166221
     C                   READ      MMFODLL0                               96    CAP004
     C/COPY WNCPYSRC,MMDEAMBC10
     C                   END                                                                  166221
     C/COPY WNCPYSRC,MMDEAMBC11
     C                   END                                                    CAP004
      *
      * End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
      *
      ** If deal amendment read, check whether user can see it
      *
     C     @@EOF         IFNE      'Y'
     C/COPY WNCPYSRC,MMDEAMBC02
     C     BJSBRC        IFEQ      *BLANK
     C/COPY WNCPYSRC,MMDEAMBC04
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    HNBRCA
     C                   PARM                    @@ERR
     C                   END
     C                   END
     C                   END
      *
     C                   ELSE                                                   CSE006
      *                                                                         CSE006
      **  Read the file initially - if @@EOF is set on then the end of          CSE006
      **  the file has been reached.  Read until a valid record is              CSE006
      **  found or until no more records exist.                                 CSE006
      *                                                                         CSE006
     C     @@EOF         DOUEQ     'Y'                                          CSE006
     C     HNDLTF        OREQ      *BLANKS                                      CSE006
     C     @@ERR         ANDEQ     *ZERO                                        CSE006
     C     HKDRID        ANDEQ     *BLANK                                       CSE006
      *                                                                         CSE006
      **  Read the file.                                                        CSE006
      *                                                                         CSE006
     C     WDEAL         IFEQ      'B'                                          CSE006
     C     DDACTN        IFEQ      'X'                                          CSE006
     C                   READ      MMCMPLP0                               96    CSE006
     C                   ELSE                                                   CSE006
     C                   READ      MMCARMLL                               96    CSE006
     C                   END                                                    CSE006
     C                   ELSE                                                   CSE006
     C     DDACTN        IFEQ      'X'                                                        166221
     C                   READ      MMFODLL1                               96                  166221
     C                   ELSE                                                                 166221
     C                   READ      MMFODLL0                               96    CSE006
     C                   END                                                                  166221
     C                   END                                                    CSE006
      *                                                                         CSE006
      * End of File                                                             CSE006
      *                                                                         CSE006
     C     *IN96         IFEQ      '1'                                          CSE006
     C                   MOVEL     'Y'           @@EOF                          CSE006
     C                   ELSE                                                   CSE006
      *                                                                         CSE006
      **  Chain to Deal file to check Repo Flag                                 CSE006
      *                                                                         CSE006
     C     WDEAL         IFEQ      'B'                                          CSE006
     C     DDACTN        IFEQ      'X'                                          CSE006
     C     HKDN38        CHAIN     MMDEALLL                           89        CSE006
     C                   ELSE                                                   CSE006
     C     HNDA38        CHAIN     MMDEALLL                           89        CSE006
     C                   END                                                    CSE006
     C                   ELSE                                                   CSE006
     C     HNDA38        CHAIN     MMDEALLL                           89        CSE006
     C                   END                                                    CSE006
     C                   END                                                    CSE006
      *                                                                         CSE006
      ** If deal amendment read, check whether user can see it                  CSE006
      *                                                                         CSE006
     C     @@EOF         IFNE      'Y'                                          CSE006
     C     BJSBRC        IFEQ      *BLANK                                       CSE006
     C/COPY WNCPYSRC,MMDEAMBC03
     C                   CALL      'ZVACTBU'                                    CSE006
     C                   PARM      'E'           ZACTN                          CSE006
     C                   PARM                    HNBRCA                         CSE006
     C                   PARM                    @@ERR                          CSE006
     C                   END                                                    CSE006
     C                   END                                                    CSE006
     C                   END                                                    CSE006
     C                   ENDIF                                                  CSE006
      *                                                                         CSE006
     C     ERDDEL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * RETURN ERROR MESSAGE
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALDAF - VALIDATE DEAL AMENDMENT POINTER FIELDS
      *****************************************************************
     C     VALDAF        BEGSR
      *
      **  Validate that the deal number is numeric or blank.
      *
     C                   TESTN                   DDDLNO               98
     C                   MOVE      DDDLNO        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     DDDLNO        IFEQ      *BLANKS
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C     DDDLNO        IFEQ      *BLANKS
     C                   Z-ADD     *LOVAL        @DLKEY            6 0
     C                   ELSE
     C                   MOVE      DDDLNO        @DLKEY            6 0
     C                   END
      *
      * RETURN ERROR MESSAGE
      *
     C                   ELSE
     C                   MOVEL     'MMM0162'     @ERRMS
     C                   RETURN
     C                   END
      *
      **  Validate that the value date is a valid date or blank.
      *
     C     DDVDAT        IFNE      *BLANKS
     C                   TESTN                   DDVDAT               98
     C                   MOVE      DDVDAT        @@TEST
     C                   TESTZ                   @@TEST                   99
     C     *IN98         IFEQ      '1'
     C     *IN99         ANDEQ     '1'
     C                   MOVEL     DDVDAT        @DAT
     C                   CALLB     'ZA0270'
     C                   PARM                    @DAT              6 0
     C                   PARM                    BJDFIN
     C                   PARM                    @RTCDE            1
     C                   PARM                    @VDYNO            5 0
     C                   END
     C                   END
      *
      **  If the return code is 1 then the input date is invalid or
      **  non-numeric.
      *
     C     @RTCDE        IFEQ      '1'
     C     DDVDAT        ANDNE     *BLANKS
     C*
     C     *IN99         OREQ      '0'
     C     DDVDAT        ANDNE     *BLANKS
     C*
     C     *IN98         OREQ      '0'
     C     DDVDAT        ANDNE     *BLANKS
     C*
     C                   MOVEL     'MMM0125'     @ERRMS
     C                   RETURN
     C*
     C                   ELSE
     C     DDVDAT        IFEQ      *BLANKS
     C                   Z-ADD     *LOVAL        @VDYY
     C                   Z-ADD     *LOVAL        @VDMM
     C                   Z-ADD     *LOVAL        @VDDD
     C                   ELSE
      *
      ** Load value date to numeric keyfield,in YYYYMMDD format
      *
     C                   MOVE      DDVDAT        @DMY
      *
     C                   Z-ADD     0             @KVALD
      *
     C                   MOVE      @DSPY         @VYEAR
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DSPD         @VDDD
     C                   ELSE
     C                   MOVE      @DSPD         @VDMM
     C                   END
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DSPM         @VDMM
     C                   ELSE
     C                   MOVE      @DSPM         @VDDD
     C                   END
      *
      ** Century
      *
     C     @VYEAR        IFGE      72
     C     @VDYY         ADD       1900          @VDYY
     C                   ELSE
     C     @VDYY         ADD       2000          @VDYY
     C                   END
     C                   END
     C                   END
      *
      ** Sequence no. must be numeric if entered
      *
     C     DDDS38        IFNE      *BLANKS
     C*
     C                   TESTN                   DDDS38               98
     C                   MOVE      DDDS38        @@TEST
     C                   TESTZ                   @@TEST                   99
     C                   END
     C*
     C     DDDS38        IFEQ      *BLANKS
     C*
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C*
     C     DDDS38        IFEQ      *BLANKS
     C                   Z-ADD     *LOVAL        @KSEQN
     C                   ELSE
     C                   MOVE      DDDS38        @KSEQN
     C                   END
     C*
     C                   ELSE
     C*
     C                   MOVEL     'MMM0196'     @ERRMS
     C                   RETURN
     C                   END
     C*
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM                    BNDCSP            1
     C                   PARM      *BLANK        @@AMTD           14
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTDAT - CONVERT DATE FROM YYYYMMDD TO DDMMYY (OR MMDDYY)     *
      *****************************************************************
     C     CVTDAT        BEGSR
      *
     C                   CALLB     'ZA0770'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@DTIN
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         @@DTOU            6 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTEAM - FORMAT EDITTED AMOUNT
      *****************************************************************
     C     FMTEAM        BEGSR
      *
     C                   CALLB     'ZA1020'
     C                   PARM                    @@IAMT           15 0
     C                   PARM                    @@CRET            2 0
     C                   PARM                    @@CDP             1 0
     C                   PARM                    BNDCSP
     C                   PARM                    BNTHSP
     C                   PARM      *BLANKS       @@ADSP           21
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @OPSEL
     C                   MOVE      *BLANK        @DLSEL
     C                   MOVE      *BLANK        @VDSEL
     C                   MOVE      *BLANK        @SQSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
     C                   MOVE      '0'           *IN20                          CAP004
      *
     C/COPY WNCPYSRC,MMDEAMBC12
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM                    RetCodeIn
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *
      * VALUE DATE POINTER
     C                   PARM                    DDVDAT            6
      *
      * SEQUENCE POINTER
     C                   PARM                    DDDS38            3
      *
      * BUILD SUB-FILE
     C                   PARM                    @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM                    @RDSFL            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM                    @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      *
      * DEAL NUMBER SELECTED
     C                   PARM                    @DLSEL            6
      *
      * VALUE DATE SELECTED
     C                   PARM                    @VDSEL            6
      *
      * SEQWUENCE SELECTED
     C                   PARM                    @SQSEL            3
      *
      * COMMAND KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ** Deam key fields
      *
     C     @DMKEY        KLIST
     C                   KFLD                    @DLKEY
     C                   KFLD                    @VDYY
     C                   KFLD                    @VDMM
     C                   KFLD                    @VDDD
     C                   KFLD                    @KSEQN            3 0
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMDEAMBRW'   DBPGM
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS DEALING DETAILS
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *                                                                         CSE006
      ** Access SAR details file to determine if CSE006 is on.                  CSE006
      ** (Repurchase Agreement enhancements)                                    CSE006
      *                                                                         CSE006
     C                   CALLB     'AOSARDR0'                                   CSE006
     C                   PARM      *BLANKS       @RTCD                          CSE006
     C                   PARM      '*VERIFY'     @OPTN                          CSE006
     C                   PARM      'CSE006'      @SARD                          CSE006
     C     @RTCD         IFNE      *BLANKS                                      CSE006
     C     @RTCD         ANDNE     '*NRF   '                                    CSE006
     C     *LOCK         IN        LDA                                          CSE006
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE006
     C                   MOVEL     '009'         DBASE                          CSE006
     C                   MOVEL     'CSE006'      DBKEY                          CSE006
     C                   OUT       LDA                                          CSE006
     C                   SETON                                        U7U8LR    CSE006
     C                   EXSR      *PSSR                                        CSE006
     C                   END                                                    CSE006
     C     @RTCD         IFEQ      *BLANK                                       CSE006
     C                   MOVEL     'Y'           CSE006            1            CSE006
     C                   END                                                    CSE006
      *
     C/COPY WNCPYSRC,MMDEAMBC05
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
(c) Misys International Banking Systems Ltd. 2001
