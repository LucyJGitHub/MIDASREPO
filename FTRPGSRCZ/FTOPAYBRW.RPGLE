     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments browse')                    *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAYBRW - OUTGOING PAYMENTS BROWSE                         *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of payments for selection,     *
      *             the other picks off the selection made.           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 260903             Date 25Apr14               *
      *                 CFT151             Date 20Mar14               *
      *                 MD019877           Date 10Apr13               *
      *                 260045             Date 20Dec12               *
      *                 CFT120             Date 28Sep12               *
      *                 AR787620           Date 10Jun11               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 228101             Date 09Oct06               *
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 197792             Date 30Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 15Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
/*    *                 179994             Date 14Aug00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 22May00               *
      *                 156689             Date 16Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 23Aug99               *
      *                 CAP031  *CREATE    Date 20May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  260903 - Remove the error validation for reversed account.   *
      *           Changed DBERR hard coded Return Code for AOCUSTR0.  *
      *         - Applied for MD-23839.                               *
      *  CFT151 - FT IN/OP Alphanumeric sequence                      *
      *  MD019877 - Retest of 260045. FT-Outgoing Payments Enquiry    *
      *             Screen is Missing                                 *
      *  260045 - Remove capability to use any character for enquire. *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,FTH00047                                 *
      *             WNCPYSRC,FTH00048                                 *
      *             WNCPYSRC,FTH00049                                 *
      *             WNCPYSRC,FTH00050                                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  228101 - Transactions should be sorted by reference, with    *
      *           the latest ones first. The F15 function key in OPN1 *
      *           must show all outgoing payments. Applied 217202.    *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  197792 - Assign a decimal separator taken from SDDEALPD.     *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
/*    *  179994 - Access FT ICD and not FO ICD                        *
      *  175479 - FONTIS : dealer's reference field                   *
      *  156689 - Insert missing parameter, decimal separator         *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTOPAYBDF CF   E             WORKSTN
     F                                     SFILE(FTOPAYS1:@@RRN)
     F                                     SFILE(FTOPAYS3:@@RRN)
     F/COPY WNCPYSRC,FTH00618
     F***OTPAY*****IF   E           K DISK    INFSR(*PSSR)                                    228101
     FOTPAYL4   IF   E           K DISK    INFSR(*PSSR)                                       228101
     F                                     RENAME(OTPAYDDF:BackOff)
     F***FTOPAYL0**IF   E           K DISK    INFSR(*PSSR)                                    228101
     FFTOPAYL1  IF   E           K DISK    INFSR(*PSSR)                                       228101
     F                                     RENAME(OTPAYDDF:FrontOff)
     F/COPY WNCPYSRC,FTH00619
 
     FACNUMA    IF   E           K DISK
 
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
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  197792
      ** External DS for Dealing Details                                                      197792
                                                                                              197792
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D*SDFODA*****   E DS                  EXTNAME(SDFODAPD)                    179994
      ***EXTERNAL*DS*FOR*FUNDS*TRANSFER*ICD*DETAILS***************************  179994
 
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)                    179994
      * External DS for Funds Transfer details                                  179994
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR NOSTRO DETAILS
 
     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                   CFT032
     D   IFCNUM      E                     EXTFLD(CNUM)                                       CFT032
                                                                                              CFT032
      ** EXTERNAL DS FOR ACCOUNT/IBAN DETAILS                                                 CFT032
                                                                                              CFT032
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D/COPY WNCPYSRC,FTH00047
      *                                                                                       CFT151
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT151
     D SLCD          E                     EXTFLD(LCD)                                        CFT151
      *                                                                                       CFT151
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D                 DS
      ** Data structure for date conversion
     D  @@YEAR                 1      4  0
     D  @@YR12                 1      2  0
     D  @@YR34                 3      4  0
     D  @@MNTH                 5      6  0
     D  @@DAY                  7      8  0
     D  @@DTIN                 1      8  0
 
     D/COPY WNCPYSRC,FTH00326
     D                 DS
      ** Data structure for date conversion
     D  @1YEAR                 1      2  0
     D  @1MNTH                 3      4  0
     D  @1DAY                  5      6  0
     D  @1DTIN                 1      6  0
 
     D                 DS
     D*     DATA STRUCTURE REDEFINING ACCNT KEY FIELD
     D**CNUM****               1      6  0                                                    CSD027
     D  CNUM                   1      6                                                       CSD027
     D  CNUMA                  1      6
     D*
     D                 DS
     D*     REDEFINE DDPREF FOR VALIDATION
     D  IPREF                  1     15
     D  P                      1      1
     D  Rundate                2      7
     D  PaymtRef               8     11
     D  PmntType              12     13
     D  StmtType              14     15
                                                                                              CGL029
      ** Working Variables                                                                    CGL029
     D*@FLD15***       S             21A                                               CGL029 CFT032
     D @FLD34          S             34A                                                      CFT032
     D @OUT            S             21A                                                      CGL029
     D @ACCD           S             10A                                                      CGL029
     D*
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D P@IBAN          S             34A                                                   CFT032
     D/COPY WNCPYSRC,FTH00620
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
      **  If First time in or subfile by Midas payment ref was previously
      **  being run, then build subfile keyed on Midas payment ref.
      **  Stay in loop while F11 toggle key is used.
      *
     C     WTRAN         IFNE      'F'
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
      **  If F11, switch to Midas Payment ref subfile
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
     C/COPY WNCPYSRC,FTH00663
      *
      * Set indicator ans flag for Midas (back) office payment ref key used
      *
     C                   MOVE      'B'           WTRAN
     C                   MOVE      '0'           *IN20
      *
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      * VALIDATE PAYMENT REF (FOR POINTER)
      *
     C                   EXSR      VALPRF
      *
      **  Initialise subfile relative record number
      *
     C                   Z-ADD     0             @@RRN             5 0
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      '1'           *IN97
     C/COPY WNCPYSRC,FTH00621
     C                   WRITE     FTOPAYS0
     C/COPY WNCPYSRC,FTH00622
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     FTOPAYF1
      *
      **  Set file pointer on key displayed on screen.
      *
     C     DDPREF        IFEQ      *BLANKS                                                    228101
     C                   EVAL      @@PREF = '999999999999999'                                 228101
     C                   ENDIF                                                                228101
     C*****@@PREF********SETLL     Backoff                                                    228101
     C/COPY WNCPYSRC,FTH00623
     C     @@PREF        SETGT     Backoff                                                    228101
     C/COPY WNCPYSRC,FTH00624
      *
      * READ A VALID PAYMENT
      *
     C                   EXSR      RDPMNT
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
      * Format Payment fields for output
      *
     C                   EXSR      FMTPMT
      *
      **  Write the payment to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C/COPY WNCPYSRC,FTH00625
     C                   WRITE     FTOPAYS1
     C/COPY WNCPYSRC,FTH00626
      *
      * READ A VALID PAYMENT
      *
     C                   EXSR      RDPMNT
     C                   END
      *
      **  Retrieve time
      *
     C                   TIME                    DDTIME
     C/COPY WNCPYSRC,FTH00627
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     FTOPAYS0
     C/COPY WNCPYSRC,FTH00628
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      FTOPAYS0                               99
     C/COPY WNCPYSRC,FTH00629
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
     C                   MOVEL     *BLANKS       DDPREF
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
      * Set indicator and flag for front office Id. key used
      *
     C                   MOVE      'F'           WTRAN             1
     C                   MOVE      '1'           *IN20
      *
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   END
      *
      * VALIDATE PAYMENT REF (FOR POINTER)
      *
     C                   EXSR      VALPRF
      *
      **  Get Front Office Id
      *
     C     @@PREF        CHAIN     Backoff                            89
     C
     C                   MOVE      FRNT          @@FODL           20
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
     C                   WRITE     FTOPAYS2
     C                   MOVE      '0'           *IN97
      *
      **  Write the select screen footer to the screen.
      *
     C                   WRITE     FTOPAYF1
      *
      **  Set file pointer on key displayed on screen.
      *
     C     @@FODL        IFEQ      *BLANKS                                                    228101
     C                   EVAL      @@FODL = '999999999999999'                                 228101
     C                   ENDIF                                                                228101
     C*****@@FODL********SETLL     Frontoff                                                   228101
     C     @@FODL        SETGT     Frontoff                                                   228101
      *
      * READ A VALID PAYMENT
      *
     C                   EXSR      RDPMNT
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
      * Format Payment fields for output
      *
     C                   EXSR      FMTPMT
      *
      **  Write the payment to the subfile.
      *
     C                   MOVE      *BLANK        DDOPT
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     FTOPAYS3
      *
      * READ A VALID PAYMENT
      *
     C                   EXSR      RDPMNT
     C                   END
      *
      **  Retrieve time
      *
     C                   TIME                    DDTIME
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     FTOPAYS2
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      FTOPAYS2                               99
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
     C                   MOVEL     *BLANKS       DDPREF
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
     C     WTRAN         IFNE      'F'
     C/COPY WNCPYSRC,FTH00630
     C                   READC     FTOPAYS1                               99
     C/COPY WNCPYSRC,FTH00631
     C                   ELSE
     C                   READC     FTOPAYS3                               99
     C                   END
     C                   END
      *
      **  Return the selected payment ref and option
      *
     C     *IN99         IFNE      '1'
     C     DDOPT         ANDNE     *BLANK
      *
     C     DDOPT         IFEQ      'A'
     C     DDOPT         OREQ      'D'
     C/COPY WNCPYSRC,FTH00632
     C*****DDOPT         OREQ      'I'                                                        260045
     C     DDOPT         OREQ      '1'                                                        260045
     C     DDOPT         OREQ      'E'                                                        260045
     C/COPY WNCPYSRC,FTH00633
     C*****@Level        ANDEQ     '2'                                                      MD019877
     C                   MOVE      DDOPT         @OPSEL
     C                   ELSE
     C/COPY WNCPYSRC,FTH00634
     C*******            MOVE      'E'           @OPSEL                                       260045
     C                   MOVE      ' '           @OPSEL                                       260045
     C/COPY WNCPYSRC,FTH00635
     C                   END
     C/COPY WNCPYSRC,FTH00636
      *
     C                   MOVE      DDPREF        @PRSEL
      *
     C                   END
      *
     C     EBLDSF        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTPMT - FORMAT PAYMENT FIELDS FOR OUTPUT
      ******************************************************************
     C     FMTPMT        BEGSR
      *
      * Payment Reference
      *
     C                   MOVE      PREF          DDPREF
      *
      * Front Office Transaction number
      *
     C                   MOVE      FRNT          DDFODN
      *
      * Destination
      *
     C                   MOVEL     DST1          DDDEST
      *
      * Pay Value date
      *
     C                   Z-ADD     PVDTD3        @1DTIN
      *
     C                   Z-ADD     PVDTD2        @@YR12
     C                   Z-ADD     @1YEAR        @@YR34
     C                   Z-ADD     @1MNTH        @@MNTH
     C                   Z-ADD     @1DAY         @@DAY
     C     @@DTIN        IFNE      *ZEROS
     C                   EXSR      CVTDAT
     C                   MOVE      @@DTOU        DDVALD
     C                   ELSE
     C                   MOVE      *BLANKS       DDVALD
     C                   END
      *
      * Currency.
      *
     C                   MOVE      PCCY          DDCCY
     C/COPY WNCPYSRC,FTH00637
      *
      * Pay amount.
      *
     C     PYAM          IFLT      0
     C                   Z-SUB     PYAM          @@InputAmt
     C                   ELSE
     C                   Z-ADD     PYAM          @@InputAmt
     C                   END
      *
      * Get ccy decimal places.
     C                   CALL      'AOCURRR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      PCCY          @CURR             3
     C     SDCURR        Parm      SDCURR        DSSDY
      *
     C                   Z-ADD     A6NBDP        @@CcyDPlc
     C                   EXSR      FMTEAM
     C                   MOVE      @@EdtAmt      DDAMNT
      *
      * Ordering Bank/Customer
      *
     C     ORBT          IFEQ      'N'
     C                   MOVEL     ORBK          @FLD2             2
     C                   MOVEL     SMCY          @FLD5
     C                   MOVE      @FLD2         @FLD5
     C                   END
     C     ORBT          IFEQ      'C'
     C     ORBT          OREQ      'G'
     C     ORBT          OREQ      'P'
     C     ORBT          OREQ      'R'
     C     ORBT          OREQ      'N'
     C     ORBT          OREQ      'F'
     C                   MOVE      ORBT          @TYPE             1
     C**********         MOVE      *BLANKS       @FLD15                                       CFT032
     C                   MOVE      *BLANKS       @FLD34                                       CFT032
     C     ORBT          IFEQ      'N'
     C**********         MOVEL     @FLD5         @FLD15           15                          CGL029
     C**********         MOVEL     @FLD5         @FLD15                                CGL029 CFT032
     C                   MOVEL     @FLD5         @FLD34                                       CFT032
     C                   ELSE
     C**********         MOVEL     ORBK          @FLD15           15                          CGL029
     C**********         MOVEL     ORBK          @FLD15                                CGL029 CFT032
     C                   MOVEL     ORBK          @FLD34                                       CFT032
     C                   END
     C                   ELSE
     C     ORCT          IFEQ      'N'
     C                   MOVEL     ORC1          @FLD2
     C                   MOVEL     SMCY          @FLD5
     C                   MOVE      @FLD2         @FLD5
     C                   MOVEL     @FLD5         ORC1
     C                   END
     C                   MOVE      ORCT          @TYPE
     C**********         MOVE      *BLANKS       @FLD15                                       CFT032
     C                   MOVE      *BLANKS       @FLD34                                       CFT032
     C**********         MOVEL     ORC1          @FLD15                                       CFT032
     C                   IF        %SUBST(ORC1:1:1) = '/'                                     CFT032
     C                   IF        ORCT = 'A' OR                                              CFT032
     C                             ORCT = 'S' OR                                              CFT032
     C                             ORCT = 'C'                                                 CFT032
     C                   EVAL      @FLD34 = ORC2                                              CFT032
     C                   ELSE                                                                 CFT032
     C                   EVAL      @FLD34 = %SUBST(ORC1:2)                                    CFT032
     C                   ENDIF                                                                CFT032
     C                   ELSE                                                                 CFT032
     C                   MOVEL     ORC1          @FLD34                                       CFT032
     C                   ENDIF                                                                CFT032
     C                   END
     C                   EXSR      CONVRT
     C                   MOVEL     @OUT          DDORBC
     C
      *
      * Settlement Method
      *
     C                   MOVE      STMT          DDSETL
      *
      *
     C                   ENDSR
     C******************************************************************
      /EJECT
      *****************************************************************
      * RDPMNT - READ A PAYMENT
      *****************************************************************
     C     RDPMNT        BEGSR
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
     C*****RECI          OREQ      'D'                                                        228101
     C*****AUIN          ANDNE     'Y'                                                        228101
     C*****@@ERR         ANDEQ     *ZERO                                                      228101
     C     @@ERR         OREQ      *ZERO                                                      228101
      *
      **  Read the file.
      *
     C     WTRAN         IFEQ      'B'
     C/COPY WNCPYSRC,FTH00638
     C                   READ      Backoff                                96
     C/COPY WNCPYSRC,FTH00639
     C                   ELSE
     C                   READ      Frontoff                               96
     C                   END
      *
      * End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           @@EOF
     C                   END
      *
      ** If payment read, check whether user can see it
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
     C/COPY WNCPYSRC,FTH00640
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
      * VALPRF - VALIDATE PAYMENT REFERENCE POINTER
      *****************************************************************
     C     VALPRF        BEGSR
      *
      **  Validate that the Payment ref is correct format or blank.
      *
     C     DDPREF        IFNE      *BLANKS
     C/COPY WNCPYSRC,FTH00327
      *
     C                   MOVE      DDPREF        IPREF
      *
     C/COPY WNCPYSRC,FTH00048
     C     CFT151        IFEQ      'N'                                                        CFT151
     C                   TESTN                   Rundate              96
     C                   TESTN                   PaymtRef             97
     C                   TESTN                   StmtType             98
      *
     C     P             IFNE      'P'
     C     PmntType      ORNE      'OP'
     C     PmntType      ANDNE     'RP'
     C     *IN96         ORNE      '1'
     C     *IN97         ORNE      '1'
     C     *IN98         ORNE      '1'
      *
     C                   MOVEL     'MMA1066'     @ERRMS
     C                   RETURN
     C                   END
      *                                                                                       CFT151
     C                   ELSE                                                                 CFT151
     C                   TESTN                   Rundate              96                      CFT151
     C                   TESTN                   StmtType             98                      CFT151
      *                                                                                       CFT151
     C     P             IFNE      'P'                                                        CFT151
     C     PmntType      ORNE      'OP'                                                       CFT151
     C     PmntType      ANDNE     'RP'                                                       CFT151
     C     *IN96         ORNE      '1'                                                        CFT151
     C     *IN98         ORNE      '1'                                                        CFT151
      *                                                                                       CFT151
     C                   MOVEL     'MMA1066'     @ERRMS                                       CFT151
     C                   RETURN                                                               CFT151
     C                   END                                                                  CFT151
     C                   END                                                                  CFT151
      *
     C/COPY WNCPYSRC,FTH00049
     C                   END
     C/COPY WNCPYSRC,FTH00328
      *
     C                   ENDSR
     C********************************************************************
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
      *******************************************************************
      *  CONVRT - To translate type into destination for ord bnk/cus    *
      *******************************************************************
     C     CONVRT        BEGSR
      *
     C                   IF        @TYPE = 'I'                                                CFT032
     C                   CALL      'AOIBANR2'                                                 CFT032
     C                   PARM      *Blanks       @RTCD                                        CFT032
     C                   PARM      @FLD34        P@IBAN                                       CFT032
     C     ACCNT         PARM      ACCNT         DSSDY                                        CFT032
     C                   IF        @RTCD = *Blanks                                            CFT032
     C                   EVAL      CNUMA = IFCNUM                                             CFT032
     C                   ENDIF                                                                CFT032
     C                   ENDIF                                                                CFT032
                                                                                              CFT032
     C     @TYPE         IFEQ      'C'
     C     @TYPE         OREQ      'G'
     C     @TYPE         OREQ      'P'
     C*
     C** In multibranching , rightmost character of FLD15 can
     C** contain negative value if moved to numeric field.Therefore
     C** move to CNUMA instead of CNUM.
     C*
     C**********         MOVEL     @FLD15        CNUMA                                        CFT032
     C                   MOVEL     @FLD34        CNUMA                                        CFT032
     C                   END
      *
     C     @TYPE         IFEQ      'R'
     C**********         MOVEL     @FLD15        @ACNUM           10 0                        CFT032
     C                   MOVEL     @FLD34        @ACNUM           10 0                        CFT032
     C     @ACNUM        CHAIN     ACNUMA                             05
     C******IN05         IFEQ      '1'                                                        260903
     C*****RECI*         OREQ      '*'                                                        260903
     C**********         Z-ADD     6             DBASE                          **************260903
     C**********         MOVEL     'ACNUMA'      DBFILE                         * DB ERROR 06 260903
     C**********         MOVEL     @ACNUM        DBKEY                          **************260903
     C**********         EXSR      *pssr                                                      260903
     C**********         END                                                                  260903
     C                   END
      *
     C     @TYPE         IFEQ      'N'
     C     @TYPE         OREQ      'F'
     C**********         MOVEL     @FLD15        @NCCY             3                          CFT032
     C                   MOVEL     @FLD34        @NCCY             3                          CFT032
     C**********         MOVEL     @FLD15        @FLD5             5                          CFT032
     C                   MOVEL     @FLD34        @FLD5             5                          CFT032
     C                   MOVE      @FLD5         @NOSN             2
     C                   CALL      'AONOSTR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @CUST             6
     C                   PARM      @NCCY         @CYCD             3
     C**********         PARM      *BLANKS       @ACCD             4                          CGL029
     C                   PARM      *BLANKS       @ACCD                                        CGL029
     C                   PARM      *BLANKS       @ACSN             2
     C                   PARM      @NOSN         @NONB             2
     C                   PARM      *BLANKS       @BRCD             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
     C                   MOVE      A7CUST        CNUM
     C                   END
      *
     C     @TYPE         IFEQ      'A'
     C     @TYPE         OREQ      'S'
     C**********         MOVEL     @FLD15        @OUT             15                          CGL029
     C**********         MOVEL     @FLD15        @OUT                                  CGL029 CFT032
     C                   MOVEL     @FLD34        @OUT                                         CFT032
     C                   ELSE
     C                   CALL      'AOCUSTR0'
     C**********         PARM      '*DBERR'      @RTCD             7                          260903
     C                   PARM      *BLANKS       @RTCD             7                          260903
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CNUMA         @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   MOVEL     BBCRNM        @OUT
     C*
     C                   END
      *
     C                   ENDSR                                                  CONVRT ends
      /EJECT
      *****************************************************************
      * FMTEAM - FORMAT EDITTED AMOUNT
      *****************************************************************
     C     FMTEAM        BEGSR
      *
     C                   CALLB     'ZA0921'
     C                   PARM                    RetCodeOut
     C                   PARM                    @@InputAmt       15 0
     C                   PARM                    @@CcyDPlc         1 0
     C                   PARM                    @@DCSP            1            156689
     C                   PARM      *BLANKS       @@EdtAmt         16
     C                   PARM      *BLANKS       @@EdtAmtSn       17
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
     C                   MOVE      *BLANK        @PRSEL
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKL
     C                   MOVE      '0'           *IN20
     C/COPY WNCPYSRC,FTH00641
      *
      * Clear workfields
     C                   MOVE      DDPREF        @@PREF           15
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
     C                   PARM                    DDPREF           15
      *
      * BUILD SUB-FILE
     C                   PARM                    @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM                    @RDSFL            1
      *
      * Level 1/2 indicator
     C                   PARM                    @Level            1
 
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM                    @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      *
      * DEAL NUMBER SELECTED
     C                   PARM                    @PRSEL           15
      *
      * COMMAND KEYS
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *
      ** Initialize program name
      *
     C                   MOVEL     'FTOPAYBRW'   DBPGM
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
      ** ACCESS FUNDS TRANSFER DETAILS
      *
     C*******************CALL      'AOFODAR0'                                   179994
     C*******************PARM      '*DBERR '     @RTCD             7            179994
     C*******************PARM      '*FIRST '     @OPTN             7            179994
     C*****SDFODA********PARM      SDFODA        DSFDY                          179994
      *
      * Access Funds Transfer details via access program                        179994
      *  (database error handling done in access program)                       179994
     C                   CALL      'AOFTFRR0'                                   179994
     C                   Parm      '*DBERR'      @RTCD                          179994
     C                   Parm      '*FIRST'      @OPTN                          179994
     C     SDFTFR        Parm      SDFTFR        DSFDY                          179994
      *                                                                         179994
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C*******************MOVEL     'SDFODAPD'    DBFILE                         179994
     C                   MOVEL     'SDFTFRPD'    DBFILE                         179994
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** Get Dealing ICD to obtain the decimal separator                                      197792
      *                                                                                       197792
     C**********         CALLB     'AODEALR0'                                          197792 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7                          197792
     C                   PARM      '*FIRST '     @OPTN             7                          197792
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                 197792 CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *                                                                                       197792
      * Database Error                                                                        197792
      *                                                                                       197792
     C     @RTCD         IFNE      *BLANKS                                                    197792
     C                   MOVEL     'SDDEALPD'    DBFILE                                       197792
     C                   MOVEL     '904'         DBASE                                        197792
     C                   MOVEL     @OPTN         DBKEY                                        197792
     C                   EXSR      *PSSR                                                      197792
     C                   END                                                                  197792
                                                                                              197792
     C                   MOVEL     BNDCSP        @@DCSP                                       197792
      *                                                                                       197792
      * Clear workfields
     C                   MOVE      *BLANKS       WTRAN
     C/COPY WNCPYSRC,FTH00050
                                                                                              CFT151
     C                   CALLB     'AOSARDR0'                                                 CFT151
     C                   PARM      *BLANKS       @RTCD                                        CFT151
     C                   PARM      '*VERIFY'     @OPTN                                        CFT151
     C                   PARM      'CFT151'      @SARD             6                          CFT151
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT151
      *                                                                                       CFT151
     C     @RTCD         IFEQ      *BLANKS                                                    CFT151
     C                   MOVE      'Y'           CFT151            1                          CFT151
     C                   ELSE                                                                 CFT151
     C                   MOVE      'N'           CFT151                                       CFT151
     C                   ENDIF                                                                CFT151
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
