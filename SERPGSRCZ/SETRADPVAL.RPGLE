     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade primary details validation')            *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SETRADPVAL - Trade Primary Details Validation                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14806A          Date 14Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10388           Date 05Feb06               *
      *                 CAP087             Date 17Aug05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 BUG8550            Date 07Oct05               *
      *                 BUG8039            Date 02Aug05               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 207378             Date 17Sep02               *
      *                 BUG3950            Date 10Aug04               *
      *                 CAP084             Date 07Jul03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      *                 CSC011             Date 18Sep01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 193462             Date 25May01               *
      *                 186566             Date 30Apr01               *
      *                 CPB002             Date 28Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 07Jun99               *
      *                 CAP051             Date 16Nov99               *
      *                 CPB001             Date 01Jun99               *
      *                 167225             Date 20Sep99               *
      *                 CGL011             Date 20Sep99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CSE010             Date 21Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP004             Date 09Sep98               *
      *                 CAP003 *CREATE     Date 25Mar98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  BUG14806A - Recompile Program due to Decimal Error           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10388 - Validation of average life date should be after   *
      *             the book code has been validated.                 *
      *  CAP087  - Enable the use of SETRADVU to process Buy/Sell     *
      *            trades.                                            *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  BUG8039 - Recompiled due to changes in SEVTCUST              *
      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  207378 - If PB on, market customer and incomplete indicator  *
      *           is ' ', default it following the Tof ICD            *
      *           Field 'Automatic complete market trades'            *
      *  BUG3950 - Stop validation if there is error on Security      *
      *            and counterparty.                                  *
      *  CAP084 - Synchronous calling of APIs                         *
      *           Ensure all fields are being check at the same time. *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  193462 - Protect Book code if Buy/sell indicator = 'Y'       *
      *  186566 - Validation not done when action is not Insert/      *
      *           Enquire.  Amended program to ensure that validation *
      *           is done.                                            *
      *  CPB002 - Counterparty for trades coming from Tof can be the  *
      *           internal customer number (Book transfer)            *
      *           In this case the PB Order Number is setted in Tof   *
      *           Add this parameter when calling SEVTCUST            *
      *  CSE023 - Treaty Withholding Tax.                             *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CSE006 - Repurchase Agreements (REPOs) enhancement           *
      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
      *           Recompiled due to database changes                  *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *         - 'Private Banking' Module                            *
      *           /COPY SE_CUSTDT Changed                             *
      *  167225 - Correct check on Bulk Input Option field            *
      *  CGL011 - Collateral Processing for Midas                     *
      *  CSE010 - SE Transactions Enhancements.                       *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SETRDPV024
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** Trade Primary Details in screen format
     D TrPrim        E DS                  EXTNAME(SETRPRPD)
 
      ** Trade Primary Details OK indicators
     D OKTrPrim      E DS                  EXTNAME(SEETRPRPD)
 
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D SEC_RECI      E                     EXTFLD(RECI)
     D SEC_ZZ005     E                     EXTFLD(ZZ005)
     D SEC_LCD       E                     EXTFLD(LCD)
     D SEC_CHTP      E                     EXTFLD(CHTP)
     D SEC_TNLU      E                     EXTFLD(TNLU)
     D SEC_REPI      E                     EXTFLD(REPI)                         CPB001
     D SEC_FRNT      E                     EXTFLD(FRNT)                                       CAP137
     D SEC_REPA      E                     EXTFLD(REPA)                                       CAP137
     D SEC_TMST      E                     EXTFLD(TMST)                                       CAP137
 
      ** Investment Type Details
     D INVTP         E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)                                       CAS006
 
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Securities Trading ICD
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      ** Portfolio ICD
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
 
      ** External DS for Midas Book details                                                   CSE065
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)                                  CSE065
                                                                                              CSE065
      ** Private Banking ICD                                                                  207378
     D SDTOF         E DS                  EXTNAME(SDTOFPD)                                   207378
                                                                                              207378
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SDSTAT data area                                                                     CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** External DS for SAR Details                                                          CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
     D  SCA_LCD      E                     EXTFLD(LCD)                                        CSC011
                                                                                              CSC011
      ** Data structure for MULTIBRANCH Indicator using rundat.
     D RUNDAT          DS
     D  @MBIN                 13     13
 
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
 
     D ValidTrad     E DS                  EXTNAME(SEVTRADPD)
      * Valid Trade layout
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(SETDEXPD)                    CAP004
      * SE Trades Extra Data - File (D/B) format                                CAP004
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
      *                                                                         CSE023
      ** Country of treaty                                                      CSE023
     D PDRBW           S              2A                                        CSE023
 
     D CallFromVU      S              1A                                                      CAP087
     D CSC011          S              1A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                              CSC011
     D CSE065          S              1A                                                      CSE065
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SETRDPV025
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *                                                                                      BUG8550
      **  GET ZMUSER to access default branch.                                               BUG8550
      *                                                                                      BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
      *                                                                                      BUG8550
 
      /COPY WNCPYSRC,SETRDPV001
 
      * Call Validation Modules in Sequence
 
      *
      ** Validate Bulk Reference
      **  If Bulk Reference entered.........
      *
 
      /COPY WNCPYSRC,SETRDPV002
     C*****BVBIOP        IFEQ      '1'                                          167225
     C     BVBIOP        IFEQ      'Y'                                          167225
     C     DDBLKR        ANDNE     *BLANKS
     C     CSE006        ANDNE     'Y'                                          CSE006
     C                   EXSR      VTBULKR
     C                   END
      /COPY WNCPYSRC,SETRDPV003
      *
      ** Validate Security Shortname
      *
      /COPY WNCPYSRC,SETRDPV004
      *
     C                   EXSR      VTSECUR
      *                                                                                       186566
      **  If action code is 'D', no more validation                                           186566
      *                                                                                       186566
     C     DDACTN        CABEQ     'D'           ENDVAL                                       186566
      *
      /COPY WNCPYSRC,SETRDPV005
      *
      **If*security*in*error*then*no*more*validation****                                      CAP084
      **************************************************                                      CAP084
     C*****ddSESNok      CABEQ     'N'           ENDVAL                                       CAP084
      * If security in error then no more validation                                         BUG3950
                                                                                             BUG3950
     C     ddSESNok      CABEQ     'N'           ENDVAL                                      BUG3950
      *
      ** Validate Booking Branch
      /COPY WNCPYSRC,SETRDPV006
      *
     C                   EXSR      VTBKGBR
      *
      /COPY WNCPYSRC,SETRDPV007
      *
      ** Validate Customer
      *
      /COPY WNCPYSRC,SETRDPV008
      *
     C                   EXSR      VTCUST
     C/COPY WNCPYSRC,SETRADPVC1
      *                                                                         CSE023
      ** If enhancement (CSE023) Treaty withholding tax exist, validate         CSE023
      ** withholding tax customer details.                                      CSE023
      *                                                                         CSE023
     C                   IF        CSE023 = 'Y' AND CRTT <> *BLANKS             CSE023
                                                                                CSE023
     C                   IF        CustClass = 'S' or CustClass = 'D'           CSE023
     C                   EVAL      PDRBW = *BLANKS                              CSE023
     C                   EXSR      VWHTCUST                                     CSE023
     C                   ENDIF                                                  CSE023
                                                                                CSE023
     C                   ENDIF                                                  CSE023
      *
      /COPY WNCPYSRC,SETRDPV009
      ** If market customer, PB on and Incomplete trade = ' ', default it       207378
      ** following the PB ICD                                                   207378
      *                                                                         207378
     C                   IF        DDINCS = ' ' AND BGN4ST = 'Y'                207378
     C                             AND  CustClass <> 'D'                        207378
     C                             AND  CustClass <> 'S'                        207378
     C                   IF        TQACMT = 'Y'                                 207378
     C                   EVAL      DDINCS  = 'C'                                207378
     C                   ELSE                                                   207378
     C                   EVAL      DDINCS  = 'I'                                207378
     C                   ENDIF                                                  207378
                                                                                207378
     C                   ENDIF                                                  207378
      *
      ** Validate Incomplete Ind.
      *
      /COPY WNCPYSRC,SETRDPV010
      *
     C                   EXSR      VTINCOM
      *
      /COPY WNCPYSRC,SETRDPV011
      *
      ** Validate Trade Type
      *
      /COPY WNCPYSRC,SETRDPV012
      *
     C                   EXSR      VTTRDTP
      *
      /COPY WNCPYSRC,SETRDPV013
      *
      ** Validate Nominal
      *
      /COPY WNCPYSRC,SETRDPV014
      *
     C                   EXSR      VTNOMNL
      *
      /COPY WNCPYSRC,SETRDPV015
      *
      ** Validate Value Date
      *
      /COPY WNCPYSRC,SETRDPV016
     C                   EXSR      VTVALDT
                                                                                              CSE065
      ***Validate*Value*date*against*Average*Life*date*****************              CSE065 BUG10388
                                                                                              CSE065
     C**********         IF        CSE065 = 'Y'                                      CSE065 BUG10388
     C**********         EXSR      VTVALDT2                                          CSE065 BUG10388
     C**********         ENDIF                                                       CSE065 BUG10388
      /COPY WNCPYSRC,SETRDPV017
      *
      ** Validate Price/Discount/Yield
      *
      /COPY WNCPYSRC,SETRDPV018
     C                   EXSR      VTPRCDY
      /COPY WNCPYSRC,SETRDPV019
      *
      ** Validate Book
      *
      /COPY WNCPYSRC,SETRDPV020
      *
     C                   EXSR      VTBOOK
      *                                                                                     BUG10388
      ** Validate Value date against Average Life date                                      BUG10388
      *                                                                                     BUG10388
     C                   IF        CSE065 = 'Y'                                             BUG10388
     C                   EXSR      VTVALDT2                                                 BUG10388
     C                   ENDIF                                                              BUG10388
      *
      /COPY WNCPYSRC,SETRDPV021
      *
      ** Validate Clearance Type
      *
      /COPY WNCPYSRC,SETRDPV022
      *
     C                   EXSR      VTCLEAR
      *
      /COPY WNCPYSRC,SETRDPV023
 
      *
     C     ENDVAL        TAG
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SETRDPV026
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTBULKR - Validate Bulk Reference
      *****************************************************************
     C     VTBULKR       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Bulk Reference
      *
     C                   CALLB     'SEVTBULKR'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Bulk Reference
     C                   PARM                    DDBLKR
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Bulk Reference - OK
     C                   PARM                    DDBLKROK
      *
      ** Trade Bulk Reference
      *
     C                   PARM                    BLKR
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTSECUR - Validate Security Shortname
      *****************************************************************
     C     VTSECUR       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Security Shortname
      *
     C                   CALLB     'SEVTSECUR'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Security Shortname
     C                   PARM                    DDSESN
      *
      ** ICD
     C                   PARM                    CSE003
     C                   PARM                    S01511
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
      *                                                                                       CSE010
      ** SE Transactions Enhancements                                                         CSE010
      *                                                                                       CSE010
     C                   PARM                    CSE010                                       CSE010
      *                                                                                       CSE010
      ** Action Code                                                                          CSE010
      *                                                                                       CSE010
     C                   PARM                    DDACTN                                       CSE010
      *                                                                                       CAP067
      ** First Buy-sell back indicator                                                        CAP067
     C                   PARM                    PFBYSL                                       CAP067
      *                                                                                       CAP067
      ** First Buy-sell security shortname                                                    CAP067
     C                   PARM                    PFSESN                                       CAP067
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Shortname - OK
     C                   PARM                    DDSESNOK
      *
      ** Trade Security Shortname
      *
     C                   PARM                    TDSS
      *
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTBKGBR - Validate Booking Branch
      *****************************************************************
     C     VTBKGBR       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Booking Branch
      *
     C                   CALLB     'SEVTBKGBR'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      ** Booking Branch
     C                   PARM                    DDBRCD
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      * ICD
     C                   PARM                    @MBIN
     C                   PARM                    USRBCH
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Booking branch - OK
     C                   PARM                    DDBrcdOK
      *
      ** Trade Booking Branch
      *
     C                   PARM                    TDBA
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTCUST - Validate Customer
      *****************************************************************
     C     VTCUST        BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Customer
      *
     C                   CALLB     'SEVTCUST'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDCNUM
     C                   PARM                    DDACTN
     C                   PARM                    DDINCS
      *                                                                                       CAP067
      ** First Buy-sell back indicator                                                        CAP067
     C                   PARM                    PFBYSL                                       CAP067
      *                                                                                       CAP067
      ** First Buy-sell counterparty                                                          CAP067
     C                   PARM                    PFTCNR                                       CAP067
      *
      ** ICD
     C                   PARM                    BGPFMG            1
     C                   PARM                    FCPORS            1
     C                   PARM                    FCR997            4
     C                   PARM                    BGN4ST            1            CPB001
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Customer - OK
     C                   PARM                    DDCNUMOK
      *
      ** Trade Counterparty
      *
     C                   PARM                    TCNR
      *
      ** Trade Counterparty details
     C                   PARM                    CustDts
      *                                                                                       CPB002
      ** PB Order Number                                                                      CPB002
     C                   PARM                    DDORDE                                       CPB002
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      /EJECT                                                                    CSE023
      *****************************************************************         CSE023
      ** VWHTCUST - Validate withholding tax customer details.                  CSE023
      *****************************************************************         CSE023
     C     VWHTCUST      BEGSR                                                  CSE023
      *                                                                         CSE023
      ** Reset variables updated by each module                                 CSE023
      *                                                                         CSE023
     C                   EXSR      RESETERRS                                    CSE023
      *                                                                         CSE023
      ** Validate Customer                                                      CSE023
      *                                                                         CSE023
     C                   CALLB     'SEVWHTCDET'                                 CSE023
      *                                                                         CSE023
      ** INPUTS                                                                 CSE023
      *                                                                         CSE023
      ** Return Code                                                            CSE023
      *                                                                         CSE023
     C                   PARM                    RetCodeOut                     CSE023
      *                                                                         CSE023
      ** Trade type                                                             CSE023
      *                                                                         CSE023
     C                   PARM                    DDTDTP                         CSE023
      *                                                                         CSE023
      ** Security shortname                                                     CSE023
      *                                                                         CSE023
     C                   PARM                    DDSESN                         CSE023
      *                                                                         CSE023
      ** Customer number                                                        CSE023
      *                                                                         CSE023
     C                   PARM                    CustNum                        CSE023
      *                                                                         CSE023
      ** Investment type from PF/SECTYD                                         CSE023
      *                                                                         CSE023
     C                   PARM                    SITP                           CSE023
      *                                                                         CSE023
      ** Country of location from PF/SDCUSTPD                                   CSE023
      *                                                                         CSE023
     C                   PARM                    CustCOLC                       CSE023
      *                                                                         CSE023
      ** Country of treaty from PF/SECTYD                                       CSE023
      *                                                                         CSE023
     C                   PARM                    CRTT                           CSE023
      *                                                                         CSE023
      ** OUTPUTS                                                                CSE023
      *                                                                         CSE023
      ** Error fields/message IDs/message data (arrays) from/to caller          CSE023
      *                                                                         CSE023
     C                   PARM                    WFldNmXAr                      CSE023
     C                   PARM                    WMsgIDXAr                      CSE023
     C                   PARM                    WMsgDtXAr                      CSE023
      *                                                                         CSE023
      ** Default basket for backup withholding                                  CSE023
      *                                                                         CSE023
     C                   PARM                    PDRBW                          CSE023
      *                                                                         CSE023
      ** Update error info with that returned from the validation module        CSE023
      *                                                                         CSE023
     C                   EXSR      UPDATERRS                                    CSE023
      *                                                                         CSE023
     C                   ENDSR                                                  CSE023
      *****************************************************************         CSE023
      ** VTINCOM - Validate Incomplete Ind.
      *****************************************************************
     C     VTINCOM       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Incomplete Ind.
      *
     C                   CALLB     'SEVTINCOM'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDINCS
      *
      ** Security Details
      *
     C                   PARM                    SECTY
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incomplete indicator - OK
     C                   PARM                    DDINCSOK
      *
      ** Trade Incomplete Indicator
      *
     C                   PARM                    TINC
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTTRDTP - Validate Trade Type
      *****************************************************************
     C     VTTRDTP       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Type
      *
     C                   CALLB     'SEVTTRDTP'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDTDTP
      *                                                                                       CAP067
      ** First Buy-sell back indicator                                                        CAP067
     C                   PARM                    PFBYSL                                       CAP067
      *                                                                                       CAP067
      ** First Buy-sell trade type                                                            CAP067
     C                   PARM                    PFTDTP                                       CAP067
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Trade Type - OK
     C                   PARM                    DDTDTPOK
      *
      ** Trade Type
      *
     C                   PARM                    TDTP
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTNOMNL - Validate Nominal
      *****************************************************************
     C     VTNOMNL       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Nominal
      *
     C                   CALLB     'SEVTNOMNL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
      ** Nominal (12A)
      ** Branch (3A)
      ** Trade Type (2A)
     C                   PARM                    DDNOML
     C                   PARM                    DDBRCD
     C                   PARM                    DDTDTP
 
      ** Trade Details:
      ** Customer (6S 0)
      ** Customer Details
     C                   PARM                    TCNR
     C                   PARM                    CustDts                                       S0111
 
      ** Security Details
      ** Nominal Currency Decimal Places (1P 0)
 
     C                   PARM                    SECTY
     C                   PARM                    NomCcyDec
 
      ** System Input
 
      ** Portfolio Mgmt Indicator (1A)
      ** Run Date (5P 0)
      ** S01496 Indicator (PB SE enhancements)
      ** CSE007 Indicator (Corporate Actions)
      ** CEU017 Indicator (SE Rednomination Euro changes)
      ** Private Banking Module indicator (1A)                                  CPB001
 
     C                   PARM                    BGPFMG
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    S01496
     C                   PARM                    CSE007
     C                   PARM                    CEU017
     C                   PARM                    BGN4ST                         CPB001
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Nominal Ok Indicator  (1A)
      ** Nominal Amount  (11P 0)
     C                   PARM                    DDNomlOK
     C                   PARM                    NOML
     C                   PARM                    CGL011                                       CGL011
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTVALDT - Validate Value Date
      *****************************************************************
     C     VTVALDT       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Value Date
      *
     C                   CALLB     'SEVTVALDT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDTDVD
     C                   PARM                    DDCLTY
     C                   PARM                    DDSETC
      *
      ** Security Details
      *
     C                   PARM                    SECTY
     C                   PARM                    PROT
      *
      ** ICD
     C                   PARM                    S01509
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BJDFIN
     C                   PARM                    BVBVP
     C                   PARM                    BVEUCY
     C                   PARM                    BVCCCY
      *                                                                                       CAP067
      ** First Buy-sell back indicator                                                        CAP067
     C                   PARM                    PFBYSL                                       CAP067
      *                                                                                       CAP067
      ** First Buy-sell trade type                                                            CAP067
     C                   PARM                    PFTDVD                                       CAP067
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Trade Value Date - OK
     C                   PARM                    DDTDVDOK
      *
      ** Trade Value Date
     C                   PARM                    TDVD
      *
      ** Trade Coupon Rate
      ** Trade Current Factor
     C                   PARM                    TDCR
     C                   PARM                    TCFC
 
      ** Trade Coupon Rate    - screen format
      ** Trade Current Factor - screen format
     C                   PARM                    DDCPNR
     C                   PARM                    DDCFCT
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************                       CSE065
      ** VTVALDT2 - Validate Value Date against Average Life Date     *                       CSE065
      *****************************************************************                       CSE065
     C     VTVALDT2      BEGSR                                                                CSE065
                                                                                              CSE065
      ** Reset variables updated by each module                                               CSE065
                                                                                              CSE065
     C                   EXSR      RESETERRS                                                  CSE065
                                                                                              CSE065
      ** Access Book Details                                                                  CSE065
                                                                                              CSE065
     C                   CALL      'AOBOOKR0'                                                 CSE065
     C                   PARM      *BLANKS       PRTCD                                        CSE065
     C                   PARM      '*KEY   '     POPTN                                        CSE065
     C                   PARM      DDBPBK        DBKEY                                        CSE065
     C     SDBOOK        PARM      SDBOOK        DSFDY                                        CSE065
                                                                                              CSE065
     C                   IF        PRTCD <> *BLANKS                                           CSE065
     C     *LOCK         IN        LDA                                                        CSE065
     C                   MOVEL     '*FIRST '     DBKEY                                        CSE065
     C                   MOVEL     'SDBOOK'      DBFILE                                       CSE065
     C                   MOVEL     '914'         DBASE                                        CSE065
     C                   OUT       LDA                                                        CSE065
     C                   EXSR      SRERR                                                      CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
     C                   IF        BDSTRM = 'Y' AND (BDSTAM = 'C' OR                          CSE065
     C                             BDSTAM = 'Y') AND (PROT <> '2' AND                         CSE065
     C                             PROT <> '4' AND PROT <> '7') AND                           CSE065
     C                             DDTDTP = 'TP'                                              CSE065
     C                   IF        TDVD > ALDT                                                CSE065
     C                   EVAL      WIdx = WIdx + 1                                            CSE065
     C                   EVAL      WFldNmXAr(1) = 'DDTDVD'                                    CSE065
     C                   EVAL      WMsgIDXAr(1) = 'SEA0564'                                   CSE065
     C                   EVAL      DDTDVDOK  = 'N'                                            CSE065
     C                   ENDIF                                                                CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
      ** Update error info w/  that returned from the validation module                       CSE065
                                                                                              CSE065
     C                   EXSR      UPDATERRS                                                  CSE065
                                                                                              CSE065
     C                   ENDSR                                                                CSE065
      *****************************************************************                       CSE065
     C/EJECT                                                                                  CSE065
      *****************************************************************
      ** VTPRCDY - Validate Price/Discount/Yield
      *****************************************************************
     C     VTPRCDY       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Price/Discount/Yield
      *
     C                   CALLB     'SEVTPRCDY'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
      ** Price/Discount/Yield
      ** Complete/Incomplete Indicator
     C                   PARM                    DDTPDY
     C                   PARM                    DDINCS
      *
      ** Trade Details
      ** -------------
      ** Value Date
     C                   PARM                    TDVD
      *
      ** Security Details
      ** Investment Type Price Tolerance
     C                   PARM                    SECTY
     C                   PARM                    PRTO
      *
      ** System Info
      ** -----------
      ** System Run date
      ** SAR S01496 Indicator
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    S01496
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Price/Discount/Yield Indicator
     C                   PARM                    DDTPDYok
      *
      ** Price/Discount/Yield
     C                   PARM                    TPDY
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTBOOK - Validate Book
      *****************************************************************
     C     VTBOOK        BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Book
      *** If CSE006 is on then call new validation module SEVBSBK01             CSE006
      *** else call SEVTBOOK (same parameters are passed)                       CSE006
      *                                                                         CSE006
     C                   IF        CSE006 = 'Y'                                 CSE006
     C                   CALLB     'SEVBSBK01'                                  CSE006
      *                                                                         CSE006
      * INPUTS                                                                  CSE006
      *                                                                         CSE006
      ** Return Code                                                            CSE006
     C                   PARM                    RetCodeOut                     CSE006
      *                                                                         CSE006
      ** Default & Validate (Y or N)                                            CSE006
     C                   PARM                    Default           1            CSE006
     C                   PARM                    Validate          1            CSE006
      *                                                                         CSE006
      ** Trade Screen fields                                                    CSE006
     C                   PARM                    DDBPBK                         CSE006
     C                   PARM                    DDACTN                         CSE006
     C                   PARM                    DDBLKR                         CSE006
     C                   PARM                    DDBRCD                         CSE006
      *                                                                         CSE006
      ** Trade details                                                          CSE006
     C                   PARM                    TCNR                           CSE006
     C                   PARM                    CustClass                      CSE006
      *                                                                         CSE006
      ** Security Day Basis                                                     CSE006
     C                   PARM                    DYBS                           CSE006
      *                                                                                       CAP067
      ** First Buy-sell back indicator                                                        CAP067
     C                   PARM                    PFBYSL                                       CAP067
      *                                                                                       CAP067
      ** First Buy-sell book code                                                             CAP067
     C                   PARM                    PFBPBK                                       CAP067
      *                                                                         CSE006
      ** ICD                                                                    CSE006
     C                   PARM                    BGPFMG                         CSE006
     C                   PARM                    FCPORS                         CSE006
     C                   PARM                    FCR997                         CSE006
     C                   PARM                    BVATBK                         CSE006
     C                   PARM                    BVDMBC                         CSE006
     C                   PARM                    BVDPBC                         CSE006
      *                                                                         CSE006
      * Details of original book.                                                             193462
     C                   PARM                    OLDBK1            2                          193462
     C                   PARM                    WARNIND           1                          193462
     C                   PARM                    CallFromVU                                   CAP087
      *                                                                                       193462
      * OUTPUTS                                                                 CSE006
      *                                                                         CSE006
      * Error fields/message IDs/message data (arrays) from/to caller           CSE006
     C                   PARM                    FldNamXAr                      CSE006
     C                   PARM                    MsgIDXAr                       CSE006
     C                   PARM                    MsgDtaXAr                      CSE006
      *                                                                         CSE006
      ** Book portfolio details                                                 CSE006
     C                   PARM                    PortCust                       CSE006
     C                   PARM                    PortRef                        CSE006
     C                   PARM                    PortCcy                        CSE006
     C                   PARM                    PortDecp                       CSE006
      *                                                                         CSE006
      ** Book - OK                                                              CSE006
     C                   PARM                    DDBPBKOK                       CSE006
      *                                                                         CSE006
      ** Trade Book                                                             CSE006
      *                                                                         CSE006
     C                   PARM                    TDBK                           CSE006
      *                                                                         CSE006
     C                   ELSE                                                   CSE006
     C                   CALLB     'SEVTBOOK'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDBPBK
     C                   PARM                    DDACTN
     C                   PARM                    DDBLKR
     C                   PARM                    DDBRCD
      *
      ** Trade details
     C                   PARM                    TCNR
     C                   PARM                    CustClass
      *
      ** Security Day Basis
     C                   PARM                    DYBS
      *
      ** ICD
     C                   PARM                    BGPFMG
     C                   PARM                    FCPORS
     C                   PARM                    FCR997
     C                   PARM                    BVATBK
     C                   PARM                    BVDMBC
     C                   PARM                    BVDPBC
     C                   PARM                    BGN4ST                         CPB001
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Book portfolio details
     C                   PARM                    PortCust
     C                   PARM                    PortRef
     C                   PARM                    PortCcy
     C                   PARM                    PortDecp
      *
      ** Book - OK
     C                   PARM                    DDBPBKOK
      *
      ** Trade Book
      *
     C                   PARM                    TDBK
      *                                                                         CSE006
     C                   ENDIF                                                  CSE006
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTCLEAR - Validate Clearance Type
      *****************************************************************
     C     VTCLEAR       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Clearance Type
      *
     C                   CALLB     'SEVTCLEAR'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDCLTY
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Clearance Type - OK
     C                   PARM                    DDCLTYOK
      *
      ** Trade Clearance Type
      *
     C                   PARM                    CLTY
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** Trade Primary Details
     C                   PARM                    TrPrim
     C                   PARM                    ExtData                        CAP004
 
      ** Trade settlement currency
     C                   PARM                    DDSETC            3
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default
     C                   PARM                    Validate
 
      *  Details of original book.                                                            193462
     C                   PARM                    OLDBK1                                       193462
     C                   PARM                    WARNIND                                      193462
      *                                                                                       193462
      ** First Buy-sell back indicator                                                        CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      ** First Buy-sell book code                                                             CAP067
     C                   PARM                    PFBPBK            2                          CAP067
      *                                                                                       CAP067
      ** First Buy-sell counterparty                                                          CAP067
     C**********         PARM                    PFTCNR            6 0                 CAP067 CSD027
     C                   PARM                    PFTCNR            6                          CSD027
      *                                                                                       CAP067
      ** First Buy-sell trade type                                                            CAP067
     C                   PARM                    PFTDTP            2                          CAP067
      *                                                                                       CAP067
      ** First Buy-sell Value Date                                                            CAP067
     C                   PARM                    PFTDVD            5 0                        CAP067
      *                                                                                       CAP067
      ** First Buy-sell Security Shortname                                                    CAP067
     C                   PARM                    PFSESN           10                          CAP067
     C                   PARM                    CallFromVU                                   CAP087
      * OUTPUTS
 
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
 
      * Coupon Rate
      * Current Factor
     C                   PARM                    DDCPNR           13
     C                   PARM                    DDCFCT           12
 
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      ** Portfolio Details
     C                   PARM                    PortDts
      *                                                                         CSE023
      ** Default basket for backup withholding                                  CSE023
      *                                                                         CSE023
     C                   PARM                    PDRBW                          CSE023
 
      ** Trade Primary Details OK inds
     C                   PARM                    OKTrPrim
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
                                                                                              CPB002
      * PB Order Number                                                                       CPB002
     C                   PARM                    DDORDE            6                          CPB002
      *
      **  GET ZMUSER to access default branch.
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SETRADPVAL'  DBPGM
     C                   OUT       LDA
      *
      **  Read data area - RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Get Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** GET MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** Securities Trading
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** Portfolio Management
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   EXSR      SRERR
     C                   END
     C                   END
      *                                                                                       207378
      ** Private Banking                                                                      207378
      *                                                                                       207378
     C     BGN4ST        IFEQ      'Y'                                                        207378
     C                   CALL      'AOTOFR0'                                                  207378
     C                   PARM      '*DBERR '     @RTCD                                        207378
     C                   PARM      '*FIRST '     @OPTN                                        207378
     C     SDTOF         PARM      SDTOF         DSFDY                                        207378
      *                                                                                       207378
      ** DATABASE ERROR                                                                       207378
      *                                                                                       207378
     C     @RTCD         IFNE      *BLANKS                                                    207378
     C                   MOVEL     '*FIRST '     DBKEY                                        207378
     C                   MOVEL     'SDTOFPD'     DBFILE                                       207378
     C                   MOVEL     '903'         DBASE                                        207378
     C                   EXSR      SRERR                                                      207378
     C                   END                                                                  207378
     C                   END                                                                  207378
      *
      ** Check if switchable feature S01496 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01496'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01496'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01496            1
     C                   ELSE
     C                   MOVE      'N'           S01496
     C                   END
      *
      ** Check if switchable feature S01509 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01509'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01509'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01509
     C                   ELSE
     C                   MOVE      'N'           S01509            1
     C                   END
      *
      ** Check if switchable feature S01511 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01511'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01511'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01511
     C                   ELSE
     C                   MOVE      'N'           S01511            1
     C                   END
      *
      ** Check if switchable feature CSE003 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE003'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSE003'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '907'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSE003
     C                   ELSE
     C                   MOVE      'N'           CSE003            1
     C                   END
      *
      ** Check if switchable feature CSE007 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE007'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSE007'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '908'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSE007
     C                   ELSE
     C                   MOVE      'N'           CSE007            1
     C                   END
      *
      ** Check if switchable feature CEU017 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU017'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU017'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '909'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU017
     C                   ELSE
     C                   MOVE      'N'           CEU017            1
     C                   END
      *                                                                                       CSE010
      ** Check if SE Transactions Enhancements switchable feature is ON.                      CSE010
      *                                                                                       CSE010
     C                   CALL      'AOSARDR0'                                                 CSE010
     C                   PARM      *BLANKS       @RTCD                                        CSE010
     C                   PARM      '*VERIFY'     @OPTN                                        CSE010
     C                   PARM      'CSE010'      @SARD                                        CSE010
      *                                                                                       CSE010
      ** DATABASE ERROR                                                                       CSE010
      *                                                                                       CSE010
     C     @RTCD         IFNE      *BLANKS                                                    CSE010
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE010
     C                   MOVEL     'CSE010'      DBKEY                                        CSE010
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE010
     C                   MOVEL     '910'         DBASE                                        CSE010
     C                   EXSR      SRERR                                                      CSE010
     C                   ENDIF                                                                CSE010
     C     @RTCD         IFEQ      *BLANK                                                     CSE010
     C                   MOVE      'Y'           CSE010                                       CSE010
     C                   ELSE                                                                 CSE010
     C                   MOVE      'N'           CSE010            1                          CSE010
     C                   ENDIF                                                                CSE010
      *                                                                         CSE006
      ** Check if switchable feature CSE006 is switched on.                     CSE006
      *                                                                         CSE006
     C                   CALL      'AOSARDR0'                                   CSE006
     C                   PARM      *BLANKS       @RTCD                          CSE006
     C                   PARM      '*VERIFY'     @OPTN                          CSE006
     C                   PARM      'CSE006'      @SARD                          CSE006
      *                                                                         CSE006
      ** Check for Database error                                               CSE006
      *                                                                         CSE006
     C     @RTCD         IFNE      *BLANKS                                      CSE006
     C     @RTCD         ANDNE     '*NRF   '                                    CSE006
     C                   MOVEL     'CSE006'      DBKEY                          CSE006
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE006
     C                   MOVEL     '910'         DBASE                          CSE006
     C                   EXSR      SRERR                                        CSE006
     C                   END                                                    CSE006
      *                                                                         CSE006
     C     @RTCD         IFEQ      *BLANK                                       CSE006
     C                   MOVE      'Y'           CSE006            1            CSE006
     C                   ELSE                                                   CSE006
     C                   MOVE      'N'           CSE006                         CSE006
     C                   ENDIF                                                  CSE006
      *                                                                                       CGL011
      ** Access Switchable Features file to check if CGL011                                   CGL011
      ** is installed.                                                                        CGL011
      *                                                                                       CGL011
     C                   Move      'N'           CGL011            1                          CGL011
      *                                                                                       CGL011
     C                   CallB     'AOSARDR0'                                                 CGL011
     C                   Parm      *BLANKS       @RTCD                                        CGL011
     C                   Parm      '*VERIFY'     @OPTN                                        CGL011
     C                   Parm      'CGL011'      @SARD                                        CGL011
      *                                                                                       CGL011
     C     @RTCD         IfNe      *BLANKS                                                    CGL011
     C     @RTCD         AndNe     '*NRF   '                                                  CGL011
     C                   MoveL     '911'         DBASE                                        CGL011
     C                   MoveL     'SCSARDPD'    DBFILE                                       CGL011
     C                   MoveL     'CGL011'      DBKEY                                        CGL011
     C                   Exsr      *PSSR                                                      CGL011
     C                   EndIf                                                                CGL011
      *                                                                                       CGL011
     C     @RTCD         IfEq      *BLANKS                                                    CGL011
     C                   Move      'Y'           CGL011                                       CGL011
     C                   EndIf                                                                CGL011
      *                                                                         CSE023
      ** Check if enhancement 'Treaty withholding tax' is on.                   CSE023
      *                                                                         CSE023
     C                   CALLB     'AOSARDR0'                                   CSE023
     C                   PARM      *BLANKS       @RTCD                          CSE023
     C                   PARM      '*VERIFY'     @OPTN                          CSE023
     C                   PARM      'CSE023'      @SARD                          CSE023
      *                                                                         CSE023
      ** Check for Database error                                               CSE023
      *                                                                         CSE023
     C     @RTCD         IFNE      *BLANKS                                      CSE023
     C     @RTCD         ANDNE     '*NRF   '                                    CSE023
     C                   MOVEL     'CSE023'      DBKEY                          CSE023
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE023
     C                   MOVEL     '912'         DBASE                          CSE023
     C                   EXSR      SRERR                                        CSE023
     C                   ENDIF                                                  CSE023
      *                                                                         CSE023
     C     @RTCD         IFEQ      *BLANK                                       CSE023
     C                   MOVE      'Y'           CSE023            1            CSE023
     C                   ELSE                                                   CSE023
     C                   MOVE      'N'           CSE023                         CSE023
     C                   ENDIF                                                  CSE023
 
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        LIBR = S1SUPP                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 913                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSE065
      ** Check if switchable feature CSE065 is switched on.                                   CSE065
                                                                                              CSE065
     C                   CALL      'AOSARDR0'                                                 CSE065
     C                   PARM      *BLANKS       PRTCD                                        CSE065
     C                   PARM      '*VERIFY'     POPTN                                        CSE065
     C                   PARM      'CSE065'      PSARD                                        CSE065
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE065
                                                                                              CSE065
      ** Check for Database error                                                             CSE065
                                                                                              CSE065
     C                   IF        PRTCD <> *BLANKS   AND                                     CSE065
     C                             PRTCD <> '*NRF   '                                         CSE065
     C     *LOCK         IN        LDA                                                        CSE065
     C                   EVAL      DBKEY = 'CSE065'                                           CSE065
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSE065
     C                   EVAL      DBASE = 915                                                CSE065
     C                   OUT       LDA                                                        CSE065
     C                   EXSR      SRERR                                                      CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
     C     PRTCD         IFEQ      *BLANK                                                     CSE065
     C                   MOVE      'Y'           CSE065                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   MOVE      'N'           CSE065                                       CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSC011
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SETRDPV027
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SETRADPVAL'  DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminte the program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
