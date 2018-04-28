     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NA's Purchased Browse ')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASPBRW - NEGOTIABLE ASSETS PURCHASED BROWSE               *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of deals for selection,        *
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL010             Date 02Aug02               *
      *                 CDL011             Date 07Jul02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209953             Date 17Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 166221             Date 24Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 26Aug98               *
      *                 CAP002  *CREATE    Date 12Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
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
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDENBPP *
      *  CDL011 - Expansion of Customer Number on Dealing Transactions*
      *  209953 - Do not show Deleted deals on the Authorisation      *
      *           selection screen.                                   *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  166221 - Browse by Front Office ID not functioning correctly *
      *  CAP004 - API's Phase 3.                                      *
      *           Allow browse by Front Office Id.                    *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FMMNASPBDF CF   E             WORKSTN
     F                                     SFILE(MMNASPS1:@@RRN)
     F                                     SFILE(MMNASPS3:@@RRN)                CAP004
     F                                     SFILE(MMNASPS5:@@RRN)                CDL011
     FMMCMPLLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(MMDENSP0)
     F                                     IGNORE(MMDELDP0)
     F                                     IGNORE(MMDEAMP0)
     F                                     RENAME(MMDENBP0:MMCMPLP0)
     FMMCARDLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(MMDENSP0)
     F                                     IGNORE(MMDELDP0)
     F                                     RENAME(MMDENBP0:MMCARDP0)
     FMMDEALL0  IF   E           K DISK    INFSR(*PSSR)                         CAP004
     F                                     IGNORE(MMDELDP0)                     CAP004
     F                                     IGNORE(MMDENSP0)                     CAP004
     F                                     RENAME(MMDENBP0:MMFODLL0)            CAP004
     FMMCMPLL1  IF   E           K DISK    INFSR(*PSSR)                                       166221
     F                                     IGNORE(MMDENSP0)                                   166221
     F                                     IGNORE(MMDELDP0)                                   166221
     F                                     IGNORE(MMDEAMP0)                                   166221
     F                                     RENAME(MMDENBP0:MMFODLL1)                          166221
 
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
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D                 DS
     D  @@YEAR                 1      4  0
     D  @@MNTH                 5      6  0
     D  @@DAY                  7      8  0
     D  @@DTIN                 1      8  0
 
      ** Externam DS SC Switchable Features                                     CDL011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDL011
                                                                                CDL011
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for CDL011                                                  CDL011
     D CDL011          S              1A                                        CDL011
                                                                                CDL011
     D PRTCD           S              7A                                        CDL011
     D POPTN           S              7A                                        CDL011
     D PSARD           S              6A                                        CDL011
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
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
     C                   END                                                    CAP004
      *                                                                         CAP004
     C                   ELSE                                                   CAP004
      *                                                                         CAP004
      **  If the subfile by Front Office Identifier was previously              CAP004
      **  being run, then build subfile keyed on Front Office ID.               CAP004
      **  Stay in loop while F11 toggle key is used.                            CAP004
      *                                                                         CAP004
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
      * VALIDATE DEAL NUMBER (FOR POINTER)
      *
     C                   EXSR      VALDLN
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C     CDL011        IFEQ      'Y'                                          CDL011
     C                   WRITE     MMNASPS4                                     CDL011
     C                   ELSE                                                   CDL011
     C                   WRITE     MMNASPS0
     C                   ENDIF                                                  CDL011
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     MMNASPF1
      *
      **  Set file pointer on key displayed on screen.
      *
     C     DDACTN        IFEQ      'X'
     C     @@DLNO        SETLL     MMCMPLLL
     C                   ELSE
     C     @@DLNO        SETLL     MMCARDLL
     C                   END
      *
      * READ A VALID DEAL
      *
     C                   EXSR      RDDEAL
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
      * Format Deal fields for output
      *
     C                   EXSR      FMTDEL
      *
      **  Write the deal to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C     CDL011        IFEQ      'Y'                                          CDL011
     C                   WRITE     MMNASPS5                                     CDL011
     C                   ELSE                                                   CDL011
     C                   WRITE     MMNASPS1
     C                   ENDIF                                                  CDL011
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
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C     CDL011        IFEQ      'Y'                                          CDL011
     C                   WRITE     MMNASPS4                                     CDL011
     C                   ELSE                                                   CDL011
     C                   WRITE     MMNASPS0
     C                   ENDIF                                                  CDL011
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C     CDL011        IFEQ      'Y'                                          CDL011
     C                   READ      MMNASPS4                               99    CDL011
     C                   ELSE                                                   CDL011
     C                   READ      MMNASPS0                               99
     C                   ENDIF                                                  CDL011
      *
      **  If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           @INKC
     C                   MOVE      *ON           *INLR
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
      /EJECT                                                                    CAP004
      ********************************************************************      CAP004
      * BLDSFL2 - BUILD SUBFILE (For Front Office ID)                           CAP004
      ********************************************************************      CAP004
     C     BLDSFL2       BEGSR                                                  CAP004
      *                                                                         CAP004
      * Set indicator and flag for front office Id. key used                    CAP004
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
      * VALIDATE DEAL NUMBER (FOR POINTER)                                      CAP004
      *                                                                         CAP004
     C                   EXSR      VALDLN                                       CAP004
      *                                                                         CAP004
      **  Get Front Office Id                                                   CAP004
      *                                                                         CAP004
     C     DDACTN        IFEQ      'X'                                          CAP004
     C     @@DLNO        CHAIN     MMCMPLLL                           89        CAP004
     C                   ELSE                                                   CAP004
     C     @@DLNO        CHAIN     MMCARDLL                           89        CAP004
     C                   END                                                    CAP004
     C                   MOVE      HLFRNT        @@FODL           20            CAP004
     C     *IN89         IFEQ      '1'                                          CAP004
     C                   MOVE      *BLANK        @@FODL                         CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      **  Initialise subfile relative record number.                            CAP004
      *                                                                         CAP004
     C                   Z-ADD     0             @@RRN                          CAP004
      *                                                                         CAP004
      **  Clear subfile before refilling by writing control record              CAP004
      **  with SFLCLR active.                                                   CAP004
      *                                                                         CAP004
     C                   MOVE      '1'           *IN97                          CAP004
     C                   WRITE     MMNASPS2                                     CAP004
     C                   MOVE      '0'           *IN97                          CAP004
      *                                                                         CAP004
      **  Write the select screen footer to the screen.                         CAP004
      *                                                                         CAP004
     C                   WRITE     MMNASPF1                                     CAP004
      *                                                                         CAP004
      **  Set file pointer on key displayed on screen.                          CAP004
      *                                                                         CAP004
     C     @@FODL        SETLL     MMFODLL0                                     CAP004
     C     @@FODL        SETLL     MMFODLL1                                                   166221
      *                                                                         CAP004
      * READ A VALID DEAL                                                       CAP004
      *                                                                         CAP004
     C                   EXSR      RDDEAL                                       CAP004
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
     C                   Z-ADD     0             @@CNT                          CAP004
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
      * Format Deal fields for output                                           CAP004
      *                                                                         CAP004
     C                   EXSR      FMTDEL                                       CAP004
      *                                                                         CAP004
      **  Write the deal to the subfile.                                        CAP004
      *                                                                         CAP004
     C                   MOVE      *BLANK        DDOPT                          CAP004
     C                   Z-ADD     @@RRN         DDSFRN                         CAP004
     C                   WRITE     MMNASPS3                                     CAP004
      *                                                                         CAP004
      * READ A VALID DEAL                                                       CAP004
      *                                                                         CAP004
     C                   EXSR      RDDEAL                                       CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
      **  Retrieve time                                                         CAP004
      *                                                                         CAP004
     C                   TIME                    DDTIME                         CAP004
      *                                                                         CAP004
      **  Write the subfile control record to the screen to display             CAP004
      **  the subfile.                                                          CAP004
      *                                                                         CAP004
     C                   WRITE     MMNASPS2                                     CAP004
      *                                                                         CAP004
      **  Read the subfile control record to determine whether records          CAP004
      **  have been selected or whether ROLLUP is required.                     CAP004
      *                                                                         CAP004
     C                   READ      MMNASPS2                               99    CAP004
      *                                                                         CAP004
      **  If F3, bypass further processing.                                     CAP004
      *                                                                         CAP004
     C     *INKC         IFEQ      '1'                                          CAP004
     C                   MOVEL     '1'           @INKC                          CAP004
     C                   MOVE      *ON           *INLR                          CAP004
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
     C                   END                                                    CAP004
      *                                                                         CAP004
     C                   ENDSR                                                  CAP004
      ********************************************************************      CAP004
      /EJECT                                                                    CAP004
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
     C     WDEAL         IFNE      'F'                                          CAP004
     C     CDL011        IFEQ      'Y'                                          CDL011
     C                   READC     MMNASPS5                               99    CDL011
     C                   ELSE                                                   CDL011
     C                   READC     MMNASPS1                               99
     C                   ENDIF                                                  CDL011
     C                   ELSE                                                   CAP004
     C                   READC     MMNASPS3                               99    CAP004
     C                   END                                                    CAP004
     C                   END
      *
      **  Return the selected deal number and option
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
      *
     C                   END
      *
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTDEL - FORMAT DEAL FIELDS FOR OUTPUT
      ******************************************************************
     C     FMTDEL        BEGSR
      *
      * Deal number
      *
     C                   MOVE      HLDN38        DDDEAL
      *                                                                         CAP004
      * Front Office Deal number                                                CAP004
      *                                                                         CAP004
     C                   MOVE      HLFRNT        DDFODN                         CAP004
      *
      * Deal type
      *
     C                   MOVE      HLMTYP        DDTYPE
      *
      * Deal currency.
      *
     C                   MOVE      HLCCY         DDCCY
      *
      * Deal amount.
      *
     C     HLAMNP        IFLT      0
     C                   Z-SUB     HLAMNP        @@IAMT
     C                   ELSE
     C                   Z-ADD     HLAMNP        @@IAMT
     C                   END
     C                   Z-ADD     15            @@CRET
     C                   Z-ADD     HLCYDP        @@CDP
      *
     C                   EXSR      FMTEAM
      *
     C                   MOVE      @@ADSP        DDAMNP
      *
      * Deal status
      *
     C                   MOVE      HLDSTS        DDDSTS
      *
      * Customer number
      *
     C                   MOVE      HLCNUM        DDCNUM
      *                                                                         CDL011
      * Customer Short Name                                                     CDL011
      *                                                                         CDL011
     C     CDL011        IFEQ      'Y'                                          CDL011
     C                   MOVE      HLCSNM        DDCSNM                         CDL011
     C                   ENDIF                                                  CDL011
      *
      * Value date
      *
     C                   Z-ADD     HLVDYY        @@YEAR
     C                   Z-ADD     HLVDMM        @@MNTH
     C                   Z-ADD     HLVDDD        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDVDAT
     C                   ELSE
     C                   MOVE      *BLANKS       DDVDAT
     C                   END
      *
      * Maturity date.
      *
     C                   Z-ADD     HLMDYY        @@YEAR
     C                   Z-ADD     HLMDMM        @@MNTH
     C                   Z-ADD     HLMDDD        @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDMDAT
     C                   ELSE
     C                   MOVE      *BLANKS       DDMDAT
     C                   END
      *
      **  If the deal has been deleted then show this.
      *
     C     HLDDLT        IFEQ      'D'
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
     C                   END
      *
     C                   ENDSR
     C******************************************************************
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
     C     HLDLTF        OREQ      *BLANKS
     C     @@ERR         ANDEQ     *ZERO
      *
      **  Read the file.
      *
     C     WDEAL         IFEQ      'B'                                          CAP004
     C     DDACTN        IFEQ      'X'
     C                   READ      MMCMPLLL                               96
     C     HLDDLT        IFEQ      'D'                                                        209953
     C                   MOVE      'D'           HLDLTF                                       209953
     C                   ENDIF                                                                209953
     C                   ELSE
     C                   READ      MMCARDLL                               96
     C                   END
     C                   ELSE                                                   CAP004
     C     DDACTN        IFEQ      'X'                                                        166221
     C                   READ      MMFODLL1                               96                  166221
     C     HLDDLT        IFEQ      'D'                                                        209953
     C                   MOVE      'D'           HLDLTF                                       209953
     C                   ENDIF                                                                209953
     C                   ELSE                                                                 166221
     C                   READ      MMFODLL0                               96    CAP004
     C                   END                                                                  166221
     C                   END                                                    CAP004
      *
      * End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
      *
      ** If deal read, check whether user can see it
      *
     C     @@EOF         IFNE      'Y'
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    HLBRCA
     C                   PARM                    @@ERR
     C     BKOBUV        IFEQ      'Y'
     C     @@ERR         ANDEQ     *ZERO
     C                   CALL      'ZVOBU'
     C                   PARM                    HLORBR
     C                   PARM                    @@ERR
     C                   END
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
      * VALDLN - VALIDATE DEAL NUMBER POINTER
      *****************************************************************
     C     VALDLN        BEGSR
      *
      **  Validate that the deal number is numeric or blank.
      *
     C                   TESTN                   DDDLNO               98
     C                   MOVE      DDDLNO        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     DDDLNO        IFEQ      *BLANKS
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C                   MOVE      DDDLNO        @@DLNO            6 0
      *
      * RETURN ERROR MESSAGE
      *
     C                   ELSE
     C                   MOVEL     'MMM0162'     @ERRMS
     C                   RETURN
     C                   END
      *
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
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
     C                   MOVE      '0'           *IN20                          CAP004
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
      * COMMAND KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMNASPBRW'   DBPGM
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
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
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
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS SAR DETAILS FOR Expansion of Customer Number on Dealing         CDL011
      *                                                                         CDL011
     C                   EVAL      CDL011 = 'N'                                 CDL011
     C                   CALL      'AOSARDR0'                                   CDL011
     C                   PARM      *Blanks       PRTCD                          CDL011
     C                   PARM      '*VERIFY'     POPTN                          CDL011
     C                   PARM      'CDL011'      PSARD                          CDL011
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL011
                                                                                CDL011
     C                   IF        PRTCD = *Blanks                              CDL011
     C                   EVAL      CDL011 = 'Y'                                 CDL011
     C                   ENDIF                                                  CDL011
      *                                                                         CDL011
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
