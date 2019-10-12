     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits rollover browse')              *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNIROB - LOANS/DEPOSITS & NAS ISSUED ROLLOVER BROWSE      *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of deals for selection,        *
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR701789           Date 26Sep16               *
      *                 CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR848507           Date 25Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22911           Date 17Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG17342           Date 31Mar08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 240747             Date 06Jun06               *
      *                 238592             Date 21Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 BUG5916            Date 16Feb05               *
      *                 CMM105             Date 22Jun04               *
      *                 BUG2804            Date 20May04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL010             Date 02Aug02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210304             Date 17Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 196380             Date 15May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 190752             Date 05Apr01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011             Date 17Feb00               *
      *                 CAP051             DATE 09Nov99               *
      *                 CDL007             DATE 05Oct99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 156950             Date 11Mar99               *
      *                 154477             Date 29Jan99               *
      *                 CAP004  *CREATE    Date 13Oct98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  AR701789 - Unable to reject a deal amendment. Add a new      *
      *             parameter to indicate reject transaction.         *
      *             Applied for MD041482                              *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR848507 - Actual Interest in rolled over deal defaults to   *
      *             the interest of the original                      *
      *  CRE073 - Interest Rate Rounding                              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17342 - A serious MidasPLus error in rollover to euro.    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  240747 - Warning messages returned from MMLDNIROV (maturity  *
      *           date) are not considered. As a result no warning    *
      *           is given for current deal but is output instead     *
      *           for following deal.                                 *
      *  238592 - Send CEU015 as parameter to MMLDNIROV.              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  BUG5916 - Default Rundate in Deal Date for the new           *
      *            (rollover) deal.                                   *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:MMLDNIHD02                       *
      *           Core hooks added:MMLDNIHC10                         *
      *  BUG2804- Parameter mismatch in MMLDNIRTV caused by CDL016    *
      *  CGL014 - Collaterals Processing (Recompile)                  *
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
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDELDPP *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  210304 - Unable to rollover deals via API Rollover Details   *
      *           Maintenance screen.  Amended program such that the  *
      *           input file is replaced by MMDELDL6 instead of       *
      *           MMDELDL1.  This would allow the user to utilise the *
      *           Rollover Maintenance screen for deals even if       *
      *           HKAURO is not "Y".  Applied fix 201816.             *
      *  196380 - Added parameter to MMLDNIRTV call.                  *
      *  CAP067 - Repurchase Agreements API.                          *
      *  190752 - Pass a new parameter down to MMLDNIROP  to          *
      *           indicate which menu option it has been called from. *
      *  CGL011 - Collateral Processing for Midas - new parameter     *
      *           on CALLB to MMLDNICVT.                              *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMDELDPP               *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *           Recompiled due to changes in MMDELDPP               *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDELDPP               *
      *  156950 - Deal number positioning and insert message.         *
      *  154477 - Recompile for change to MMDELDPP.                   *
      *  CAP004 - APIs phase 3.                                       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FMMLDNIODF CF   E             WORKSTN
     F                                     SFILE(MMLDNIS1:@@RRN)
     F***MMDELDL1**IF   E           K DISK    INFSR(*PSSR)                                    210304
     FMMDELDL6  IF   E           K DISK    INFSR(*PSSR)                                       210304
     FSDBRTDL1  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
 
     D DlFilFmt      E DS                  EXTNAME(MMDELDPP)
      * Deal in File Format
 
     D DlScnFmt      E DS                  EXTNAME(MMLDNIPD)
      * Deal in Screen Format
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS
 
     D/COPY WNCPYSRC,MMLDNIHD01
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D ZMUSER          DS            17
     D  BRC                   11     13
      ** USER DETAILS
 
     D                 DS
     D  @@YEAR                 1      4  0
     D  @@MNTH                 5      6  0
     D  @@DAY                  7      8  0
     D  @@DTIN                 1      8  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CRE073
     D CRE073          S              1A                                                      CRE073
     D ddCNSPOK        S              1A                                                      CRE073
     D ddRDMTOK        S              1A                                                      CRE073
     D ddRDFDOK        S              1A                                                      CRE073
 
     D/COPY WNCPYSRC,MMLDNIHD02
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
     C     @BDSFL        DOWEQ     'Y'
     C                   EXSR      BLDSFL
     C                   END
      *
      * READ SUBFILE RECORD (if any records present, else return)
      *
     C     @RDSFL        DOWEQ     'Y'
     C     DDSFRN        IFNE      *ZERO
     C                   EXSR      RDSFLR
     C                   ELSE
     C                   RETURN
     C                   END
     C                   END
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      * BLDSFL - BUILD SUBFILE
      ********************************************************************
     C     BLDSFL        BEGSR
      *                                                                         156950
      * DISPLAY MESSAGE: 'Deal nnnnnn added to the database'.                   156950
      *                                                                         156950
     C     @SIDN         IFNE      *BLANK                                       156950
     C                   MOVEL     'MMM0690'     @MSGID                         156950
     C                   MOVEL     @SIDN         @MSGDT           45            156950
     C                   EXSR      ZA0440                                       156950
     C                   MOVEL     *BLANK        @SIDN                          156950
     C                   END                                                    156950
      *                                                                         156950
      * SELECTION DEAL NUMBER                                                   156950
      *                                                                         156950
     C                   MOVEL     @PTDN         DDPTDN                         156950
      *
      * SELECTION BRANCH
      *
     C                   MOVEL     @BRCA         DDBRCA
      *
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   MOVEL     BJSBRC        DDBRCA
     C                   EXSR      CHAUTN
     C                   END
      *                                                                         156950
      * VALIDATE 'POSITION TO' DEAL NUMBER                                      156950
      *                                                                         156950
     C                   EXSR      VALPTDN                                      156950
      *
      * VALIDATE SELECTION BRANCH
      *
     C                   EXSR      VALBRC
      *
      ** Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
      *
     C                   SETOFF                                       9495
     C                   WRITE     MMLDNIS0
     C                   SETON                                        95
      *
      ** If entered branch is valid
      ** Set file pointer
      ** and read a valid deal
      *
     C     *IN10         IFEQ      '0'
     C     *IN11         ANDEQ     '0'                                          156950
     C     DDPTDN        IFNE      *BLANK                                       156950
     C*****MMDELDK       SETLL     MMDELDL1                                            156950 210304
     C     MMDELDK       SETLL     MMDELDL6                                                   210304
     C                   ELSE                                                   156950
     C******LOVAL        SETLL     MMDELDL1                                                   210304
     C     *LOVAL        SETLL     MMDELDL6                                                   210304
     C                   ENDIF                                                  156950
     C                   EXSR      RDDEAL
     C                   ENDIF
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until: either end of file; or ROLLUP has not
      **  been entered; or the branch has changed.
      *
     C     @@EOF         DOUEQ     'Y'
     C     *IN98         OREQ      '0'
     C     DDBRCA        ORNE      @BRCA
      *
      ** Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             @@CNT             3 0
      *
      ** If entered branch is valid
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
      *
     C     *IN10         DOWEQ     '0'
     C     *IN11         ANDEQ     '0'                                          156950
     C     @@EOF         ANDNE     'Y'
     C     @@CNT         ANDLT     12
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      * Format Deal fields for output
      *
     C                   EXSR      FMTDEL
      *
      **  Write the deal to the subfile.
      *
     C                   MOVE      *BLANK        DDRACT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     MMLDNIS1
      *
      * READ A VALID DEAL
      *
     C                   EXSR      RDDEAL
     C                   END
      *
      **  Retrieve time
      *
     C                   TIME                    DDTIME
      *
      **  Write the subfile control records to the screen to display
      **  the subfiles.
      *
     C     @@RRN         COMP      *ZERO                              94        *
     C                   WRITE     MMLDNIS0
     C                   WRITE     MMLDNIS2
      *
      ** Write the select screen footer to the screen.
      *
     C                   WRITE     MMLDNIF1
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      MMLDNIS0                               99
      *
      * Clear message subfile
      *
     C                   CALL      'ZA0250'
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
     C                   END
      *                                                                         156950
      ** Update selection deal number                                           156950
      *                                                                         156950
     C                   MOVEL     DDPTDN        @PTDN                          156950
      *
      ** Update selection branch
      *
     C                   MOVEL     DDBRCA        @BRCA
      *
      ** If branch is OK, return
      *
     C     *IN10         IFEQ      '0'
     C     *IN11         ANDEQ     '0'                                          156950
     C                   RETURN
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
      **  Only process those for which the action field is not blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDRACT        ORNE      *BLANK
     C                   READC     MMLDNIS1                               99
     C                   END
      *
      **  Process the selected deal number and action
      *
     C     *IN99         IFNE      '1'
     C     DDRACT        ANDNE     *BLANK
     C/COPY WNCPYSRC,MMLDNIHC05
      *
      ** Retrieve the deal to be rolled over
      *
     C                   EXSR      RTVDEL
      *
      ** Convert the deal to screen format
      *
     C                   EXSR      CVTDEL
      *
      ** Default the rollover details
      ** (maturity date, interest rate & settlement details)
      *
     C                   EXSR      DEFROL
     C/COPY WNCPYSRC,MMLDNIHC01
      *
      ** Display rollover prompt
      *
     C                   EXSR      DSPROLLPMT
      *
      ** Validate and display rollover details while not F12 and invalid
      *
     C                   Z-ADD     999           Idx
      *                                                                                       240747
      * Initialise Previous Maturity Date                                                     240747
     C                   MOVE      *BLANKS       P@DDMDAT          6                          240747
     C     @INKL         DOWEQ     '0'
     C     Idx           ANDNE     *ZERO
     C                   EXSR      VALROLLPMT
     C     Idx           IFNE      *ZERO
      *                                                                                       240747
      * Redisplay screen if Warning given and Maturity date not same as previous              240747
     C     WIdx          ORNE      *ZERO                                                      240747
     C     DDMDAT        ANDNE     P@DDMDAT                                                   240747
     C                   EXSR      DSPROLLPMT
     C                   MOVE      DDMDAT        P@DDMDAT                                     240747
     C                   ENDIF
     C                   ENDDO
      *
      ** If no request for exit (which means validation is OK)
      ** return with the selected deal number and action
      *
     C     @INKL         IFEQ      '0'
     C                   MOVE      DDRACT        @RASEL
     C                   MOVE      DDDEAL        @DLSEL
     C                   RETURN
     C                   END
      *
      * If no selected deal number and action
      * return
     C                   ELSE
     C                   RETURN
     C                   END
      *
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVDEL - RETRIEVE DEAL TO BE ROLLED OVER
      *****************************************************************
     C     RTVDEL        BEGSR
      *
      * RETRIEVE DEAL
      *
     C                   CALLB     'MMLDNIRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM      'E'           DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM      *BLANK        FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM      *BLANK        FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDEAL            6
      *                                                                                       196380
      * (Midas) Depot Movement Reference                                                      196380
     C                   PARM                    DDDDMR                                       196380
      *
      * (Midas) Associated Deal Number
     C                   PARM      *BLANK        DDASOC            6
      *
      * Booking branch
     C                   PARM                    DDBRCA            3
      *                                                                                       CAP067
      * REPO Flag                                                                             CAP067
     C                   PARM      'N'           RepoFlag          1                          CAP067
      *
      * OUTPUTS
      *
      * Deal in file format
     C                   PARM                    DlFilFmt
     C/COPY WNCPYSRC,MMLDNIHC07
      *                                                                                     AR701789
     C                   PARM                    ACTRJ             1                        AR701789
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN            1
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO            1
      *
      * OK - Booking branch
     C                   PARM      *BLANK        OKBRCA            1
      ** Blocked/Unblock Action                                                              BUG2804
     C                   PARM                    BUACT             1                         BUG2804
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx               3 0
                                                                                              CAS004
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
                                                                                              CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Array index (3P0) from/to caller                                                     CAS004
                                                                                              CAS004
     C                   PARM                    WIdx                                         CAS004
     C/COPY WNCPYSRC,MMLDNIHC10
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTDEL - CONVERT A DEAL FROM FILE TO SCREEN FORMAT
      *****************************************************************
     C     CVTDEL        BEGSR
      *
      * Call program to fill screen fields with data from MMDELDPP
      *
     C                   CALLB     'MMLDNICVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Deal in file format
     C                   PARM                    DlFilFmt
     C/COPY WNCPYSRC,MMLDNIHC08
      *
      * OUTPUTS
      *
      * Deal in screen format
     C                   PARM                    DlScnFmt
     C/COPY WNCPYSRC,MMLDNIHC09
      *
      * Deal Status
     C                   PARM                    DDSTS            24
      *                                                                         CGL011
      ** Collateral Status                                                      CGL011
     C                   PARM                    DDCSTS           10            CGL011
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DEFROL - DEFAULT ROLLOVER DETAILS
      ******************************************************************
     C     DEFROL        BEGSR
      *
     C                   CALLB     'MMLDNIROD'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM                    RetCodeOut
      *
      * ROLLOVER ACTION CODE
     C                   PARM                    DDRACT
      *
      * ROLLOVER DEAL DETAILS
     C                   PARM                    DlFilFmt
      *
      * ICD
      * Date format
      * Euro currency code
      * Currency decimal separator
      * Hong Kong tax rate
      * BRT installed
      * Euro rollover installed
      * Euro currency decimal places
      * Date Effective From
      * Previous basic rate tax
      * Basic rate tax
     C                   PARM                    BJDFIN            1
     C                   PARM                    BKEURO            3
     C                   PARM                    BNDCSP            1
     C                   PARM                    BNHKTR            5 2
     C                   PARM                    S01383            1
     C                   PARM                    CEU015            1
     C                   PARM                    EuroNBDP          1 0
     C                   PARM                    DEFF              5 0
     C                   PARM                    PBRTR             7 5
     C                   PARM                    BRTR              7 5
     C                   PARM                    CDL033                                       CDL033
      *
      * OUTPUT PARAMETERS
      *
      * Action code
      * Deal number
      * Rollover Deal Number
      * Value Date
      * Maturity Date
      * Currency
      * Rollover Amount
      * Base Rate Code
      * Spread/Rate
      * Interest Calc. Method
      * Base Currency Rate
      * Total interest
     C                   PARM                    DDACTN            1
     C                   PARM                    DDDLNO            6
     C                   PARM                    DDDADN            6
     C                   PARM                    DDVDAT            6
     C                   PARM                    DDMDAT            6
     C                   PARM                    DDCCY             3
     C                   PARM                    DDRAMN           14
     C                   PARM                    DDBSRC            2
     C                   PARM                    DDSPRT           12
     C                   PARM                    DDICMT            1
     C                   PARM                    DDBRAT           13
     C                   PARM                    DDTOTI           14
      *
      * Customer shortname
      * Principal amount
      * Old Maturity Date
     C                   PARM                    DDCSNM           10
     C                   PARM                    DDAMNP           14
     C                   PARM                    OldMatDate        5 0
      * New Deal Date                                                                        BUG5916
     C                   PARM                    DDDLDT            6                         BUG5916
      * New actual interest rate                                                            AR848507
     C                   PARM                    DDAIR            12                        AR848507
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DSPROLLPMT - DISPLAY ROLLOVER PROMPT
      ******************************************************************
     C     DSPROLLPMT    BEGSR
      *
     C                   CALLB     'MMLDNIROP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM                    RetCodeOut
      *
      * ROLLOVER DETAILS (IN SCREEN FORMAT)
      *
     C                   PARM                    DDRACT            1
     C                   PARM                    DDDADN            6
     C                   PARM                    DDDLNO            6
     C                   PARM                    DDRAMN           14
     C                   PARM                    DDMDAT            6
     C                   PARM                    DDBSRC            2
     C                   PARM                    DDSPRT           12
     C                   PARM                    DDICMT            1
      *
      * ASSOCIATED DETAILS
      *
     C                   PARM                    DDCSNM           10
     C                   PARM                    DDAMNP           14
      *
      * ROLLOVER DETAILS - FIELDS IN ERROR
     C                   PARM                    ddRACTok          1
     C                   PARM                    ddDADNok          1
     C                   PARM                    ddDLNOok          1
     C                   PARM                    ddRAMNok          1
     C                   PARM                    ddMDATok          1
     C                   PARM                    ddBSRCok          1
     C                   PARM                    ddSPRTok          1
     C                   PARM                    ddICMTok          1
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD            1
     C                   PARM      'Y'           @EDTFD            1
      *                                                                                       190752
      * Menu Option                                                                           190752
      *                                                                                       190752
     C                   PARM                    @MENU                                        190752
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      *
      **  If F3, bypass further processing.
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   END
      *
      *
      * RESET ERRORS
      *
     C                   MOVEL     'Y'           ddRACTok                       broker
     C                   MOVEL     'Y'           ddDADNok                       broker
     C                   MOVEL     'Y'           ddDLNOok                       broker
     C                   MOVEL     'Y'           ddRAMNok                       brokerage
     C                   MOVEL     'Y'           ddMDATok                       brokerage
     C                   MOVEL     'Y'           ddBSRCok                       brokerage
     C                   MOVEL     'Y'           ddSPRTok                       brokerage
     C                   MOVEL     'Y'           ddICMTok                       brokerage
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALROLLPMT - VALIDATE ROLLOVER PROMPT
      ******************************************************************
     C     VALROLLPMT    BEGSR
      *
     C                   CALLB     'MMLDNIROV'
      *
      * INPUTS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * Rollover action
      * Rollover deal number
      * Deal Number
      * Rollover amount
      * Maturity Date
      * Base Rate Code
      * Spread/Rate
      * Interest Calc. Method
     C                   PARM                    DDRACT            1
     C                   PARM                    DDDADN            6
     C                   PARM                    DDDLNO            6
     C                   PARM                    DDRAMN           14
     C                   PARM                    DDMDAT            6
     C                   PARM                    DDBSRC            2
     C                   PARM                    DDSPRT           12
     C                   PARM                    DDICMT            1
      *
      * Booking Branch
      * New Deal Currency
      * Principal Amount
      * Old Maturity Date
      * Old Deal Currency
      * Old Deal Currency Decimal Places
     C                   PARM                    DDBRCA            3
     C                   PARM                    DDCCY             3
     C                   PARM                    DDAMNP           14
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM                    OldMatDate        5 0
     C                   PARM                    HKCCY
     C                   PARM                    HKCYDP
      *
      * ICD
      * Date format
      * Euro currency code
      * Currency decimal separator
      * Euro currency decimal places
     C                   PARM                    BJDFIN            1
     C                   PARM                    BKEURO            3
     C                   PARM                    BNDCSP            1
     C                   PARM                    EuroNBDP          1 0
     C                   PARM                    CDL033                                       CDL033
      ** EMU Money Market Rollovers                                                           238592
     C                   PARM                    CEU015                                       238592
     C                   PARM                    CRE073                                       CRE073
      *
      * OUTPUTS
      *
      ** Rollover Action - OK
      ** Rollover Deal Number- OK
      ** Deal number - OK
      ** Principal Amount - OK
      ** Maturity Date - OK
      ** Base Rate Code - OK
      ** Spread/Rate - OK
      ** Int.Calc.Method - OK
      ** Euro Currency Code - OK                                                            BUG17342
     C                   PARM      'Y'           ddRACTok          1            broker
     C                   PARM      'Y'           ddDADNok          1            broker
     C                   PARM      'Y'           ddDLNOok          1            broker
     C                   PARM      'Y'           ddRAMNok          1            brokerage
     C                   PARM      'Y'           ddMDATok          1            brokerage
     C                   PARM      'Y'           ddBSRCok          1            brokerage
     C                   PARM      'Y'           ddSPRTok          1            brokerage
     C                   PARM      'Y'           ddICMTok          1            brokerage
     C                   PARM      'Y'           ddEUROok          1            brokerage   BUG17342
     C                   PARM                    ddCNSPOK                                     CRE073
     C                   PARM                    ddRDMTOK                                     CRE073
     C                   PARM                    ddRDFDOK                                     CRE073
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx               3 0
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        WFldNamArr
     C                   PARM      *BLANK        WMsgIDArr
     C                   PARM      *BLANK        WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         WIdx              3 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDDEAL - READ A DEAL
      *****************************************************************
     C     RDDEAL        BEGSR
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
     C     HKDDLT        OREQ      *BLANKS
     C     HKBRCA        ANDEQ     DDBRCA
     C     HKMTYP        ANDNE     'IL'
     C     HKMTYP        ANDNE     'ID'
     C     HKMTYP        ANDNE     'CD'
     C     HKMTYP        ANDNE     'CL'
     C     @@ERR         ANDEQ     *ZERO
      *
      **  Read the file.
      *
     C**********         READ      MMDELDL1                               96                  210304
     C                   READ      MMDELDL6                               96                  210304
      *
      * End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   ELSE
     C/COPY WNCPYSRC,MMLDNIHC03
      *
      ** If deal read, check whether user can see it
      *
     C     BJSBRC        IFEQ      *BLANK
     C     BKOBUV        ANDEQ     'Y'
     C                   CALL      'ZVOBU'
     C                   PARM                    HKORBR
     C                   PARM                    @@ERR
     C                   END
     C/COPY WNCPYSRC,MMLDNIHC04
     C                   END
 
     C                   END
      *
     C     ERDDEL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTDEL - FORMAT DEAL FIELDS FOR OUTPUT
      ******************************************************************
     C     FMTDEL        BEGSR
      *
      * Deal number
      *
     C                   MOVE      HKDN38        DDDEAL
      *
      * Deal currency.
      *
     C                   MOVE      HKCCY         DDCCY
      *
      ** Get the deal currency details
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      HKCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '101'         DBASE
     C                   MOVEL     HKCCY         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Store the deal currency 'in' currency indicator
      *
     C                   MOVEL     A6INCY        DDCCYINCY
      *
      * Deal amount.
      *
     C     HKAMNP        IFLT      0
     C                   Z-SUB     HKAMNP        @@IAMT
     C                   ELSE
     C                   Z-ADD     HKAMNP        @@IAMT
     C                   END
     C                   Z-ADD     17            @@CRET
     C                   Z-ADD     HKCYDP        @@CDP
     C                   EXSR      FMTEAM
     C                   MOVE      @@ADSP        DDSAMN
      *
      * Customer number and shortname
      *
     C                   MOVE      HKCNUM        DDCNUM
     C                   MOVE      HKCSNM        DDCSNM
      *
      * Maturity date.
      *
     C                   Z-ADD     HKMDYY        @@YEAR
     C                   Z-ADD     HKMDMM        @@MNTH
     C                   Z-ADD     HKMDDD        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDMDAT
     C                   ELSE
     C                   MOVE      *BLANKS       DDMDAT
     C                   END
      *
     C                   ENDSR
     C******************************************************************
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
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      * RETURN ERROR MESSAGE: 'ACTION CODE INVALID FOR USER'
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    156950
      *****************************************************************         156950
      * VALPTDN - VALIDATE 'POSITION TO' DEAL NUMBER                            156950
      *****************************************************************         156950
     C     VALPTDN       BEGSR                                                  156950
      *                                                                         156950
      ** Reset error indicator                                                  156950
      *                                                                         156950
     C                   MOVEL     *OFF          *IN11                          156950
      *                                                                         156950
     C     DDPTDN        IFNE      *BLANK                                       156950
     C                   MOVEL     DDPTDN        DDDEAL                         156950
     C                   EXSR      RTVDEL                                       156950
      *                                                                         156950
      * DISPLAY ERROR MESSAGE                                                   156950
      *                                                                         156950
     C     Idx           IFNE      *ZERO                                        156950
     C                   MOVEL     *ON           *IN11                          156950
     C                   MOVEL     MsgIdArr(1)   @MSGID                         156950
     C                   EXSR      ZA0240                                       156950
     C                   ELSE                                                   156950
     C                   MOVEL     HKBRCA        DDBRCA                         156950
     C                   ENDIF                                                  156950
     C                   ENDIF                                                  156950
      *                                                                         156950
     C                   ENDSR                                                  156950
      *****************************************************************         156950
      /EJECT
      *****************************************************************
      * VALBRC - VALIDATE SELECTION BRANCH
      *****************************************************************
     C     VALBRC        BEGSR
      *
      ** Reset error indicator
      *
     C                   MOVEL     *OFF          *IN10
      *
      ** Default user's branch if no branch present
      *
     C     DDBRCA        IFEQ      *BLANKS
     C                   MOVEL     BRC           DDBRCA
     C                   END
      *
      **  Validate that the branch exists
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDBRCA        @BR               3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      * DISPLAY ERROR MESSAGE 'A VALID BRANCH MUST BE INPUT'
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     *ON           *IN10
     C                   MOVEL     'MMM0115'     @MSGID            7
     C                   EXSR      ZA0240                                                      06615
     C                   ELSE
     C                   MOVEL     A8BRCD        DDBRCA
      *
      ** If multi-branching, check whether authorized to view branch
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    DDBRCA
     C                   PARM                    @@ERR
      *
      * DISPLAY ERROR MESSAGE: 'ACTION CODE INVALID FOR USER/BRANCH'
      *
     C     @@ERR         IFNE      *ZERO
     C                   MOVEL     *ON           *IN10
     C                   MOVEL     'FXM0291'     @MSGID
     C                   EXSR      ZA0240                                                      06615
     C                   END
     C                   END
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* ZA0240  - OUTPUT ERROR MESSAGES WITHOUT DATA                  *
     C*                                                               *
     C*****************************************************************
     C     ZA0240        BEGSR
     C*
     C*  Display error message
     C*
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     @MSGID        ZAMSID
     C                   CALL      'ZA0240'
     C                   PARM                    ZAMSID           10
     C*
     C                   ENDSR
     C********************************************************************
      /EJECT                                                                    156950
     C*****************************************************************         156950
     C*                                                               *         156950
     C* ZA0440  - OUTPUT ERROR MESSAGES WITH DATA                     *         156950
     C*                                                               *         156950
     C*****************************************************************         156950
     C     ZA0440        BEGSR                                                  156950
     C*                                                                         156950
     C*  Display error message                                                  156950
     C*                                                                         156950
     C                   MOVEL     *BLANK        ZAMSID                         156950
     C                   MOVEL     @MSGID        ZAMSID                         156950
     C                   CALL      'ZA0440'                                     156950
     C                   PARM                    ZAMSID           10            156950
     C                   PARM      @MSGDT        ZAMDTA           45            156950
     C*                                                                         156950
     C                   ENDSR                                                  156950
     C********************************************************************      156950
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   MOVE      *BLANK        @ERRMS
     C                   MOVE      *BLANK        @RASEL
     C                   MOVE      *BLANK        @DLSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
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
      *                                                                         156950
      * SELECTION DEAL NUMBER                                                   156950
     C                   PARM                    @PTDN             6            156950
      *
      * SELECTION BRANCH
     C                   PARM                    @BRCA             3
      *
      * BUILD SUB-FILE
     C                   PARM                    @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM                    @RDSFL            1
      *                                                                         156950
      * SUCCESFUL INSERT DEAL                                                   156950
     C                   PARM                    @SIDN             6            156950
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM                    @ERRMS            7
      *
      * ROLLOVER ACTION SELECTED
     C                   PARM                    @RASEL            1
      *
      * DEAL NUMBER SELECTED
     C                   PARM                    @DLSEL            6
      *
      * DEAL IN SCREEN FORMAT
     C                   PARM                    DlScnFmt
      *
      * COMMAND KEYS
     C                   PARM                    @INKC             1
      *                                                                                       190752
      * Menu Option                                                                           190752
     C                   PARM                    @MENU             4                          190752
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMLDNIROB'   DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSID
     C                   MOVEL     PsJobName     DDWSID
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
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
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
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SAR Details file to determine if BRT SAR is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @RTCD         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   END
      *
      ** If BRT SAR installed, access BRT installation control data
      *
     C     S01383        IFEQ      'Y'
     C                   MOVE      'D'           BRTKEY            1
     C     BRTKEY        CHAIN     SDBRTDD0                           99
      *
      * DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'SDBRTDPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   MOVEL     BRTKEY        DBKEY
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Access SAR details file to determine if CEU015 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CEU015'      @SARD             6
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   MOVEL     @RTCD         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU015            1
     C                   ENDIF
                                                                                              CDL033
      ** Verify if Floating Rate CDs Issued enhancement is on.                                CDL033
                                                                                              CDL033
     C                   CALLB     'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       @RTCD                                        CDL033
     C                   PARM      '*VERIFY'     @OPTN                                        CDL033
     C                   PARM      'CDL033'      @SARD                                        CDL033
     C                   SELECT                                                               CDL033
     C                   WHEN      @RTCD = *BLANKS                                            CDL033
     C                   MOVE      'Y'           CDL033            1                          CDL033
     C                   WHEN      @RTCD <> '*NRF   '                                         CDL033
     C     *LOCK         IN        LDA                                                        CDL033
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL033
     C                   EVAL      DBASE = 908                                                CDL033
     C                   EVAL      DBKEY = @SARD                                              CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   OTHER                                                                CDL033
     C                   MOVE      'N'           CDL033                                       CDL033
     C                   ENDSL                                                                CDL033
      *
      ** ACCESS EURO CURRENCY DECIMAL PLACES
      *
     C     CEU015        IFEQ      'Y'
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BKEURO        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '907'         DBASE
     C                   MOVEL     BKEURO        DBKEY
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     A6NBDP        EuroNBDP          1 0
     C                   END
     C/COPY WNCPYSRC,MMLDNIHC06
      *                                                                         156950
      * Key Lists                                                               156950
      *                                                                         156950
     C     MMDELDK       KLIST                                                  156950
     C                   KFLD                    HKMDYY                         156950
     C                   KFLD                    HKMDMM                         156950
     C                   KFLD                    HKMDDD                         156950
     C                   KFLD                    HKBRCA                         156950
     C                   KFLD                    HKDN38                         156950
      *
      ** ACCESS USER DETAILS
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      * Message subfile control
      *
     C                   MOVE      '1'           *IN92
     C                   MOVEL     '*'           DDPGMQ
     C/COPY WNCPYSRC,MMLDNIHC02
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
(c) Finastra International Limited 2001
