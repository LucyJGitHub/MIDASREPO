     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Repo margin call browse')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMRPMCBRW - REPO MARGIN CALL BROWSE                          *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of Repo Amendements for        *
      *             selection, the other picks off the selection made.*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 15Feb17               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006  *CREATE    Date 28Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDEAMPP *
      *  CSE006 - Repurchase Agreement Enhancements                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMMDEAMBDF CF   E             WORKSTN
     F                                     SFILE(MMDEAMS1:@@RRN)
     F                                     SFILE(MMDEAMS3:@@RRN)
     FMMCMRPLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(MMDELDP0)
     F                                     RENAME(MMDEAMP0:MMCMPLP0)
     FMMCARMLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDEAMP0:MMDEAMP1)
     FMMDEAML0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDEAMP0:MMFODLL0)
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
 
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
      *
      **  If First time in or subfile by Midas deal number was previously
      **  being run, then build subfile keyed on Midas deal number.
      **  Stay in loop while F11 toggle key is used.
      *
     C     WDEAL         IFNE      'F'
     C     *INKK         DOUEQ     '0'
     C                   EXSR      BLDSFL
      *
      **  If F11, switch to Front Office Deal subfile
      *
     C     *INKK         IFEQ      '1'
     C                   EXSR      BLDSFL2
     C                   END
     C                   END
      *
     C                   ELSE
      *
      **  If the subfile by Front Office Identifier was previously
      **  being run, then build subfile keyed on Front Office ID.
      **  Stay in loop while F11 toggle key is used.
      *
     C     *INKK         DOUEQ     '0'
     C                   EXSR      BLDSFL2
      *
      **  If F11, switch to Midas Deal Number subfile
      *
     C     *INKK         IFEQ      '1'
     C                   EXSR      BLDSFL
     C                   END
     C                   END
     C                   END
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
      *
      * Set indicator and flag for Midas (back) office deal number key used
      *
     C                   MOVE      'B'           WDEAL
     C                   MOVE      '0'           *IN20
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
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL2 - BUILD SUBFILE (For Front Office ID)
      ********************************************************************
     C     BLDSFL2       BEGSR
      *
      * Set indicator and flag for Midas (back) office deal number key used
      *
     C                   MOVE      'F'           WDEAL             1
     C                   MOVE      '1'           *IN20
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
      *
      **  Get Front Office Id
      *
     C     DDACTN        IFEQ      'X'
     C     @DMKEY        CHAIN     MMCMPLP0                           89
     C                   ELSE
     C     @DMKEY        CHAIN     MMCARMLL                           89
     C                   END
     C                   MOVE      HNFRNT        @@FODL           20
     C     *IN89         IFEQ      '1'
     C                   MOVE      *BLANK        @@FODL
     C                   END
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C                   WRITE     MMDEAMS2
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     MMDEAMF1
      *
      **  Set file pointer on key displayed on screen.
      *
     C     @@FODL        SETLL     MMFODLL0
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
     C                   WRITE     MMDEAMS3
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
     C                   WRITE     MMDEAMS2
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      MMDEAMS2                               99
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
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      * RDSFLR - READ SUBFILE RECORD
      ********************************************************************
     C     RDSFLR        BEGSR
      *
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPT         ORNE      *BLANK
     C     WDEAL         IFNE      'F'
     C                   READC     MMDEAMS1                               99
     C                   ELSE
     C                   READC     MMDEAMS3                               99
     C                   END
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
      *
      * Front Office Deal number
      *
     C                   MOVE      HNFRNT        DDFODN
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
     C     HNDS38        IFEQ      0
     C                   MOVE      *BLANKS       DDSEQ
     C                   ELSE
     C                   MOVE      HNDS38        DDSEQ
     C                   END
     C*
     C**  Interest Rate/spread.
     C*
     C**  Interest Rate.
     C**  - Execute FMTAMT to format the rate, using 8 decimal places
     C**    and adjusting the file figure to have only implied decimal
     C**    places.
     C     HNINTR        IFEQ      0
     C                   MOVE      *BLANKS       DDINTR
     C                   ELSE
     C     HNINTR        MULT      10000000      @@AMTW
     C                   Z-ADD     7             @@QECN
     C*
     C**  Reverse sign for display if amount -ve.
     C     @@AMTW        IFLT      0
     C                   Z-SUB     @@AMTW        @@AMTW
     C                   END
     C*
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDINTR
     C                   END
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
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C     @@EOF         DOUEQ     'Y'
     C     HNDLTF        OREQ      *BLANKS
     C     @@ERR         ANDEQ     *ZERO
     C     HKDRID        ANDNE     *BLANK
      *
      **  Read the file.
      *
     C     WDEAL         IFEQ      'B'
     C     DDACTN        IFEQ      'X'
     C                   READ      MMCMPLP0                               96
     C                   ELSE
     C                   READ      MMCARMLL                               96
     C                   END
     C                   ELSE
     C                   READ      MMFODLL0                               96
     C                   END
      *
      * End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   ELSE
      *
      **  Chain to Deal file to check Repo Flag
      *
     C     WDEAL         IFEQ      'B'
     C     DDACTN        IFEQ      'X'
     C     HKDN38        CHAIN     MMDEALLL                           89
     C                   ELSE
     C     HNDA38        CHAIN     MMDEALLL                           89
     C                   END
     C                   ELSE
     C     HNDA38        CHAIN     MMDEALLL                           89
     C                   END
     C                   END
      *
      ** If deal amendment read, check whether user can see it
      *
     C     @@EOF         IFNE      'Y'
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    HNBRCA
     C                   PARM                    @@ERR
     C                   END
     C                   END
     C                   END
      *
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
     C                   MOVE      '0'           *IN20
      *
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
(c) Misys International Banking Systems Ltd. 2001
