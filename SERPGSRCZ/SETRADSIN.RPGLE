     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade input')                                 *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADSIN - SECURITY TRADES SCREEN INPUT                     *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Securities/trades.                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 AR698195B          Date 20Jan11               *
      *                 CSW210             Date 04May10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22911           Date 17Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 17Aug05               *
      *                 CSE075             Date 17Nov05               *
      *                 235844             Date 05Sep05               *
      *                 235547             Date 11Aug05               *
      *                 234440             Date 22Jun05               *
      *                 233881             Date 02Jun05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 206651             Date 17Jun02               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3145            Date 15Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 23Oct03               *
      *                 CSE045             Date 24Mar03               *
      *                 CAS006             Date 21Jan03               *
      *                 216338             Date 21Jan03               *
      *                 CSE037             Date 29Apr02               *
      *                 CSE039             Date 21Jan03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 212734             Date 29Nov02               *
      *                 210517             Date 21Nov02               *
      *                 209867             Date 10Jan03               *
      *                 210962             Date 07Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 212939             Date 06Dec02               *
      *                 210466             Date 18Oct02               *
      *                 200459             Date 22Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE034             Date 23Apr02               *
      *                 CSE031             Date 13Dec01               *
      *                 201429             Date 15Jan02               *
      *                 201233             Date 20Dec01               *
      *                 CAP067             Date 24Sep01               *
      *                 199797             Date 01Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      *                 CSW201             Date 02May01               *
      *                 195716             Date 18Jul01               *
      *                 194229             Date 14Jun01               *
      *                 CSE016             Date 10Jan01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 193462             Date 25May01               *
      *                 186566             Date 30Apr01               *
      *                 186948             Date 05Apr01               *
      *                 CUT009             Date 22Mar01               *
      *                 189082             Date 19Mar01               *
      *                 CPB002             Date 28Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      *                 175216             Date 12Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      *                 CSE019             Date 04Apr00               *
      *                 174876             Date 01Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 13Sep99               *
      *                 CAP051             Date 16Nov99               *
      *                 CPB001             Date 30Aug99               *
      *                 CGL011             Date 20Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 161507             Date 21Jun99               *
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             DATE 17Mar99               *
      *                 154562             Date 01Feb99               *
      *                 154208             Date 27Jan99               *
      *                 CAP004             Date 07Sep98               *
      *                 140951             Date 25AUG98               *
      *                 CAP050             Date 28Jul98               *
      *                 CAP003  *CREATE    Date 29May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR698195B - Added Front Office field on the buffer for TRADS *
      *             (Child: AR698196)                                 *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087  - Enable the use of SETRADVU to process Buy/Sell     *
      *            trades.                                            *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  235844 - Parameter missing when call SETRADUPD.              *
      *  235547 - Defaulting incorrect first time into program        *
      *  234440 - Position Management (Access ETCPOSND)               *
      *  233881 - EU Tax amount should be subtracted from the         *
      *           Countervalue.                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  206651 - Security Report Name is not displayed during Insert *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3145 - Charges and Commission are being missed out of the *
      *            calculation of countervalue.                       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  216338 - Add parameters on second call to SETRADUPD          *
      *  CSE037 - Bond Pricing - 3 Decimal Places in Trades Input     *
      *  CSE039 - Auto-settlement of trades                           *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  212734 - Time of trade should only be defaulted once         *
      *  210517 - Missing TRADSDX2 record from the API                *
      *  209867 - No rollback when F3 pressed. Msg ENDCMTCTL not      *
      *           allowed at signoff due to updates in window pgm.    *
      *  210962 - Save the value of DDACTN such that correct          *
      *           parameter will be pass to program SETRADPDSP so as  *
      *           correct narrative is displayed for delete.          *
      *  212939 - The accrued indicator is not re-defaulted if the    *
      *           value date of the trade is changed during input.    *
      *  210466 - Input in TRDN, time is not filled in by the system  *
      *  200459 - Current factor not applied to countervalue for 'MP' *
      *           Securities.  Add checking to SEDEV for new current  *
      *           factor and if it exists, use it in calculating the  *
      *           countervalue.  Amended to be consistent with SE0050.*
      *  CSE034 - Standard Settlement Instruction improvements        *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  201429 - New validation needed for ISO15022 in               *
      *           extended settlement screen.                         *
      *  201233 - If message is unroutable, settlement of message     *
      *           request cannot be a 'Y'.                            *
      *  CAP067 - Repurchase Agreements API.                          *
      *  199797 - Additional changes and fixes for CSE028 (SSIs).     *
      *  CSE028 - Standing Settlement Instructions Enhancement        *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  195716 - Recompiled program due to changes in SETRADEVAL     *
      *  194229 - If Buy Sell on 1st leg is one book make sure 2nd    *
      *           leg has same book. Field protect book on 2nd leg.   *
      *  CSE016 - Extended Security Descriptions                      *
      *  193462 - Protect Book code if Buy/sell indicator = 'Y'       *
      *  186566 - Validation not done when action is not Insert/      *
      *           Enquire.  Amended program to ensure that validation *
      *           is done.                                            *
      *  186948 - Validate Nominal for trade with action code = 'Y'.  *
      *  CUT009 - Core hooks added manually.                          *
      *  189082 - Full name of Security and customer report name      *
      *           were not displayed.                                 *
      *  CPB002 - Counterparty for trades coming from Tof can be the  *
      *           internal customer number (Book transfer)            *
      *           In this case the PB Order Number is setted in Tof   *
      *           Add this parameter when calling SETRADPVAL to give  *
      *           the value to SEVTCUST                               *
      *  CSE023 - Treaty Withholding Tax.                             *
      *  175216 - Add additional field for "Standing Instructions     *
      *           Override" missed at SWIFT 98 change. Compile only.  *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *  CSE019 - SE Trades Selections Enhancements                   *
      *  174876 - Complete window processing in addition to 161507.   *
      *  CSE006 - Repurchase Agreements (REPOs) enhancement           *
      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *         - 'Private Banking' Module                            *
      *  CGL011 - Collateral Processing for Midas. Recompile.         *
      *  161507 - Addition of window processing.                      *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *  154562 - Only 1 record is needed on TRADSDX1 if CSW003 is off*
      *  154208 - Errors in field defaulting                          *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *  140951 - Addition of F14 key to access Ext. Settlements.     *
      *  CAP050 - Midas/ToF Interface                                 *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
                                                                                              CSC022
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022
 
      * Current Trade in File Format
     D CrTrFilFmt    E DS                  EXTNAME(TRADSD)
     D                                     PREFIX(C_)
      * Current Trade in File Format (Extension File)
     D CT1AFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(CA_)
      * Current Trade in File Format (Extension File)
     D CT1BFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(CB_)
 
 
      * (Current) Trade in Screen Format - Primary Details
     D CurTrPrim     E DS                  EXTNAME(SETRPRPD)
     D                                     PREFIX(@)
      * (Current) Trade in Screen Format - Secondary Details
     D CurTrSeco     E DS                  EXTNAME(SETRSEPD)
     D                                     PREFIX(@)
      ** (Current) Trade in Screen Format - Third screen details                              CAS006
     D CurTrThir     E DS                  EXTNAME(SETRTHPD)                                  CAS006
     D                                     PREFIX(@)                                          CAS006
      * (Current) Trade in Screen Format - Exchange Rates Details
     D CurTrExch     E DS                  EXTNAME(SETREXPD)
     D                                     PREFIX(@)
      * (Current) Trade in Screen Format - Settlement Instructions
     D CurTrSett     E DS                  EXTNAME(SETRSTPD)
     D                                     PREFIX(@)
     D @DDCLTY2      E                     EXTFLD(DDCLTY)
      * (Current) Trade in Screen Format - Charges/Commissions
     D CurTrChCm     E DS                  EXTNAME(SETRCCPD)
     D                                     PREFIX(@)
      * (Current) Trade in Screen Format - SWIFT Details
     D CurTrSwftA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@A)
      * (Current) Trade in Screen Format - SWIFT Details
     D CurTrSwftB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@B)
 
 
     D NwTrFilFmt    E DS                  EXTNAME(SEVTRADPD)
      * New Trade in File Format
     D NT1AFilFmt    E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(A_)
      * New Trade in File Format (Extension File)
     D NT1BFilFmt    E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(B_)
      * New Trade in File Format (Extension File)
     D SEVTRX2A      E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
     D                                     PREFIX(A_)                                         CSE045
      * Valid Trades File Format Extended Settlement (Extension File)                         CSE045
     D SEVTRX2B      E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
     D                                     PREFIX(B_)                                         CSE045
      * Valid Trades File Format Extended Settlement (Extension File)                         CSE045
 
      ** TRADSDX2 record                                                                      210517
     D PTradeX2      E DS                  EXTNAME(TRADSDX2)                                  210517
     D                                     PREFIX(X2:2)                                       210517
 
      * New Trade in Screen Format - Primary Details
     D NewTrPrim     E DS                  EXTNAME(SETRPRPD)
      * New Trade in Screen Format - Secondary Details
     D NewTrSeco     E DS                  EXTNAME(SETRSEPD)
      ** New Trade in Screen Format - Third Screen Details                                    CAS006
     D NewTrThir     E DS                  EXTNAME(SETRTHPD)                                  CAS006
      * New Trade in Screen Format - Exchange Rate Details
     D NewTrExch     E DS                  EXTNAME(SETREXPD)
      * New Trade in Screen Format - Settlement Details
     D NewTrSett     E DS                  EXTNAME(SETRSTPD)
     D DDCLTY2       E                     EXTFLD(DDCLTY)
      * New Trade in Screen Format - Charge & Commission Details
     D NewTrChCm     E DS                  EXTNAME(SETRCCPD)
      * New Trade in Screen Format - SWIFT Details
     D NewTrSwftA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(A_)
      * New Trade in Screen Format - SWIFT Details
     D NewTrSwftB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(B_)
      * New Trade in Screen Format - Extended Settlement                                      CSE045
     D NewTrExtA     E DS                  EXTNAME(SETESDPD)                                  CSE045
     D                                     PREFIX(A_)                                         CSE045
      * New Trade in Screen Format - Extended Settlement                                      CSE045
     D NewTrExtB     E DS                  EXTNAME(SETESDPD)                                  CSE045
     D                                     PREFIX(B_)                                         CSE045
 
 
      * Previous Trade in Screen Format - Primary Details
     D PrvTrPrim     E DS                  EXTNAME(SETRPRPD)
     D                                     PREFIX(@P)
      * Previous Trade in Screen Format - Secondary Details
     D PrvTrSeco     E DS                  EXTNAME(SETRSEPD)
     D                                     PREFIX(@P)
      ** Previous Trade in Screen Format - Third Screen Details                               CAS006
     D PrvTrThir     E DS                  EXTNAME(SETRTHPD)                                  CAS006
     D                                     PREFIX(@P)                                         CAS006
      * Previous Trade in Screen Format - Exchange Rate Details
     D PrvTrExch     E DS                  EXTNAME(SETREXPD)
     D                                     PREFIX(@P)
      * Previous Trade in Screen Format - Settlement Details
     D PrvTrSett     E DS                  EXTNAME(SETRSTPD)
     D                                     PREFIX(@P)
     D @PDDCLTY2     E                     EXTFLD(DDCLTY)
      * Previous Trade in Screen Format - Charge & Commission Details
     D PrvTrChCm     E DS                  EXTNAME(SETRCCPD)
     D                                     PREFIX(@P)
      * Previous Trade in Screen Format - SWIFT Details
     D PrvTrSwft     E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@P)
 
     D PMCWL           DS          9999                                                       CSD015
      ** Additional entry parameter for Midas Compliance Watch                                CSD015
 
      * Error indicators
     D OKTrPrim      E DS                  EXTNAME(SEETRPRPD)
     D OKTrSeco      E DS                  EXTNAME(SEETRSEPD)
     D OKTrThir      E DS                  EXTNAME(SEETRTHPD)                                 CAS006
     D OKTrExch      E DS                  EXTNAME(SEETREXPD)
     D OKTrSett      E DS                  EXTNAME(SEETRSTPD)
     D DDCLTY2OK     E                     EXTFLD(DDCLTYOK)
     D OKTrChcm      E DS                  EXTNAME(SEETRCCPD)
     D OKTrSwft      E DS                  EXTNAME(SEETRSWPD)
     D OKTrExts      E DS                  EXTNAME(SEETESPD)                                  CSE045
 
 
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
     D SEC_NDEC      E                     EXTFLD(NDEC)                                       CSE037
     D SEC_SETX      E                     EXTFLD(SETX)                                       233881
 
      ** Temporary working defined fields                                       CSE006
     D WWACTN          S              2                                         CSE006
     D WWTDRF          S              6                                         CSE006
 
      ** Investment Type Details
     D INVTP         E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)                                       CSE037
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
     D                 DS
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** EXTERNAL DS FOR SECURITIES TRADING DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(SETDEXPD)                    CAP004
      * SE Trades Extra Data - File (D/B) format                                CAP004
                                                                                CSE006
      ** Book details                                                           CSE006
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)                    CSE006
 
      ** Customer Details                                                                     189082
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  189082
                                                                                              189082
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
                                                                                              CSC022
     D/COPY QWINDSRC,SETRADGDTA                                                             161507
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
      *                                                                         CSE023
      ** Country of treaty                                                      CSE023
     D PDRBW           S              2A                                        CSE023
      *                                                                         CSE023
      ** Withholding tax                                                        CSE023
     D DDWTAX          S             15A                                        CSE023
 
      *                                                                         CSE006
     D Indicators      DS                  Based(IndicatorP)                    CSE006
     D BySlBk_AEC             25     25                                         CSE006
     D BySlBk_DPY             26     26                                         CSE006
     D IndicatorP      S               *   Inz(%Addr(*IN))                      CSE006
                                                                                CSE006
      ** Swift 2001 flag                                                                      CSW201
     D CSW201          S              1A                                                      CSW201
                                                                                              CSW201
     D WWTime          S              6  0                                                    210466
                                                                                              210466
     D PMODE           S              3A                                                      210517
                                                                                              210517
     D CAS006          S              1                                                       CAS006
     D PRTCD           S              7                                                       CAS006
     D POPTN           S              7                                                       CAS006
     D PSARD           S              6                                                       CAS006
     D DDHACR          S             13                                                       CAS006
     D DDPRICN         S             17                                                       CAS006
     D WIdx_TVAL       S              3  0                                                    CAS006
                                                                                              CAS006
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
                                                                                             BUG3145
     D CGL014          S              1A                                                     BUG3145
     D CGL031          S              1A                                                      CGL031
     D CallFromVU      S              1A   INZ(' ')                                           CAP087
      ** Front office id variable.                                                         AR698195B
     D DDFRNT          S             20A                                                   AR698195B
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SETRADS010
 
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
      *                                                                         140951
      /COPY WNCPYSRC,SETRADS001
      * Issue rollback to clear any possible updates in window functions        140951
      *                                                                         140951
     C     @INKE         IFEQ      '1'                                          140951
     C     @INKL         OREQ      '1'                                          140951
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK                                                  140951
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   END                                                    140951
      *
      /COPY WNCPYSRC,SETRADS002
      *
      ** Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,SETRADS003
      *
      ** DO WHILE screen: Primary Details Screen
      *
     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
     C     @SCRN         DOWEQ     'P'
     C                   EXSR      Scrn@P
     C                   ENDDO
      *
      /COPY WNCPYSRC,SETRADS004
      *
      ** DO WHILE screen: Secondary Details Screen
      *
     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      Scrn@S
     C                   ENDDO
                                                                                              CAS006
      /COPY WNCPYSRC,SETRADS015                                                               CAS006
                                                                                              CAS006
      ** DO WHILE screen: Third Details Screen                                                CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL      WIdx_TVAL = 0                                              CAS006
     C                   DOW       @SCRN = 'H'                                                CAS006
     C                   EXSR      Scrn@T                                                     CAS006
     C                   ENDDO                                                                CAS006
     C                   ENDIF                                                                CAS006
      *
      /COPY WNCPYSRC,SETRADS005
      *
      ** DO WHILE screen: Other Details Screen
      *
     C                   Z-ADD     *ZERO         WIdx_OVAL         3 0
     C     @SCRN         DOWEQ     'O'
     C                   EXSR      Scrn@O
     C                   ENDDO
      *
      /COPY WNCPYSRC,SETRADS006
      *
      ** DO WHILE screen: Extension (SWIFT) Details Screen A
      *
     C                   Z-ADD     *ZERO         WIdx_EVALA        3 0
     C                   EVAL      PUYAT = 'N'                                                201429
     C     @SCRN         DOWEQ     'A'
     C                   EXSR      Scrn@E_A
     C                   ENDDO
      *
      /COPY WNCPYSRC,SETRADS007
      *
      ** DO WHILE screen: Extension (SWIFT) Details Screen B
      *
     C                   Z-ADD     *ZERO         WIdx_EVALB        3 0
     C                   EVAL      PUYAT = 'N'                                                201429
     C     @SCRN         DOWEQ     'B'
     C                   EXSR      Scrn@E_B
     C                   ENDDO
      *
      /COPY WNCPYSRC,SETRADS008
      *                                                                         174876
      ** Screen: Window                                                         174876
      *                                                                         174876
     C     @SCRN         IFEQ      'W'                                          174876
     C                   EXSR      WINDOW                                       174876
     C                   ENDIF                                                  174876
      *
      ** Do File updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,SETRADS009
      *
      ** Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      *****************************************************************
 
      *****************************************************************                       161507
      * WINDOW - CALL WINDOW MANAGER                                                          161507
      *****************************************************************                       161507
     C     WINDOW        BEGSR                                                                161507
                                                                                              161507
      *                                                                         174876
      ** Reset Errors ....                                                      174876
      *                                                                         174876
     C                   MOVE      *ALL'Y'       OKTrSwft                       174876
     C                   MOVEL     *BLANK        FldNameArr                     174876
     C                   MOVEL     *BLANK        MsgIdArr                       174876
     C                   MOVEL     *BLANK        MsgDtaArr                      174876
     C                   MOVEL     *BLANK        WFldNamArr                     174876
     C                   MOVEL     *BLANK        WMsgIdArr                      174876
     C                   MOVEL     *BLANK        WMsgDtaArr                     174876
      *                                                                         174876
      **  If trade reference is not defined (On Insert),                        174876
      **  get next available trade reference                                    174876
      *                                                                         174876
     C     DDTDRF        IFEQ      *BLANK                                       174876
      *                                                                         174876
     C                   CALLB     'ZATRNRTV'                                   174876
     C                   PARM      *BLANKS       RetCodeOut                     174876
     C                   PARM      'SE'          MODU              2            174876
     C                   PARM      'T'           TRTY              1            174876
     C                   PARM                    DDTDRF                         174876
     C                   PARM      *ZERO         TDRF                           174876
      *                                                                         174876
      ** Database Error                                                         174876
      *                                                                         174876
     C     RetCodeOut    IFNE      *BLANK                                       174876
     C                   MOVEL     'ZATRNRTV'    DBFILE                         174876
     C                   MOVEL     '999'         DBASE                          174876
     C                   MOVEL     DDTDRF        DBKEY                          174876
     C                   EXSR      *PSSR                                        174876
     C                   ENDIF                                                  174876
     C                   ENDIF                                                  174876
                                                                                174876
     C/COPY QWINDSRC,SETRADMOV1                                                               161507
                                                                                              161507
     C                   CALL      'WN0010'                                                   161507
     C/COPY WNCPYSRC,SETRADSC13
     C                   PARM      'SETRADSIN'   #PGM             10                          161507
     C/COPY WNCPYSRC,SETRADSC14
     C                   PARM                    FKEY              2                          161507
     C                   PARM      DDACTN        ACTION            1                          161507
     C                   PARM                    DATA                                         161507
     C                   PARM      *BLANKS       #RTRN             7                          161507
     C                   PARM                    SPAREW          256                          161507
                                                                                              161507
     C/COPY WNCPYSRC,SETRADSC12
      *                                                                         174876
      ** Process returned command keys                                          174876
      *                                                                         174876
     C     #RTRN         IFEQ      'Y2U9999'                                    174876
     C                   EXSR      ENDP                                         174876
     C                   ELSE                                                   174876
      *                                                                         174876
      *  If Cmd12 pressed, or in enquiry, return to initial screen;             174876
      ** otherwise, go to settlements screen                                    174876
      *                                                                         174876
     C     #RTRN         IFEQ      'USR0790'                                    174876
     C     DDACTN        OREQ      'E'                                          174876
     C     @RDNB         IFEQ      'Y'                                          174876
     C                   EVAL      @SCRN = 'R'                                  174876
     C                   ELSE                                                   174876
     C/COPY WNCPYSRC,SETRADSC15
     C                   EXSR      INITIAL                                      174876
     C/COPY WNCPYSRC,SETRADSC16
     C                   ENDIF                                                  174876
     C                   ELSE                                                   174876
     C/COPY WNCPYSRC,SETRADSC17
     C                   EVAL      @SCRN = 'U'                                  174876
     C/COPY WNCPYSRC,SETRADSC18
     C                   ENDIF                                                  174876
     C                   ENDIF                                                  174876
      *                                                                         174876
     C/COPY WNCPYSRC,SETRADSC24
     C     WIND          ENDSR                                                                161507
      *****************************************************************                       161507
      /EJECT                                                                                  161507
      *****************************************************************                       161507
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SETRADS011
 
      /EJECT
      *****************************************************************
      * SCRN@P - PROCESS SCREEN: PRIMARY DETAILS
      *****************************************************************
     C     SCRN@P        BEGSR
 
      * Update 'previous' screen
 
     C                   MOVEL     NewTrPrim     PrvTrPrim
      *                                                                                       206651
     C     DDACTN        IFEQ      'I'                                                        206651
     C                   MOVEL     SRPN          DDSRNME                                      206651
     C                   ENDIF                                                                206651
      *
      ** WRITE/READ DISPLAY SCREEN - Primary Details
      *
     C                   CALLB     'SETRADPDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Trade (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewTrPrim
      * Trade Status
      * Trade Authorized/Not Authorized
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14
      * Security report name
      * Customer report name
     C**********         PARM                    DDSRPN           20                          CSE016
     C                   PARM                    DDSRNME          41                          CSE016
     C                   PARM                    DDCRNM           20
      *
      * Fields in error
     C                   PARM                    OKTrPrim
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
      * ENABLED KEY FIELDS
      * ENABLED DETAIL FIELDS
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      * Indicator if this program from SE0190                                                 CSE028
     C                   PARM                    @FRPGM            1                          CSE028
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KP = COMMAND KEY 15 = BROWSE
     C                   PARM      'Y'           @EINKG            1
     C                   PARM      'Y'           @EINKH            1
     C                   PARM      'Y'           @EINKP            1
      * Successful insert Trade
     C                   PARM                    @SITR             6
      * Protect book on second leg                                                            194229
     C                   PARM                    IN50              1                          194229
     C                   PARM                    TRDBK1            2                          194229
      *                                                                                       194229
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL             1                          CAP067
      *                                                                                       CAP067
      ** Successful insert Trade 2                                                            CAP067
     C                   PARM                    PSITR             6                          CAP067
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F7 - Roll Backwards
     C     @INKG         CASEQ     '1'           ROLL
      *
      * F8 - Roll Forwards
     C     @INKH         CASEQ     '1'           ROLL
      *
      * F12 - Cancel on Primary Screen
     C     @INKL         CASEQ     '1'           CANC@P
      *
      * F15 - Build Browse
     C     @INKP         CASEQ     '1'           BLDBRW
      *
      * Validate input to Primary screen
     C                   CAS                     VAL@P
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@P  - VALIDATE INPUT TO PRIMARY DETAILS SCREEN
      *****************************************************************
     C     VAL@P         BEGSR
      *
      * Retrieve Trade details
      *
     C                   EXSR      RTVTRD
      *
      * If primary fields are NOT OK
      * Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDTDRFOK      OREQ      'N'
     C                   GOTO      EndVAL@P
     C                   END
      *
      * Set field status on PRIMARY screen
      * (according to action code)
      *
     C                   EXSR      SFDS@P
      *
      * If action code is not insert
      *  .. Convert the trade to screen format
      *  .. Update the trade in file format
      *  .. Go to Secondary details screen
      *
     C     DDACTN        IFNE      'I'
     C                   EXSR      CVTTRD
     C                   MOVEL     CrTrFilFmt    NwTrFilFmt
     C                   MOVEL     CT1AFilFmt    NT1AFilFmt
     C                   MOVEL     CT1BFilFmt    NT1BFilFmt
     C/COPY WNCPYSRC,SETRADSC02
     C     DDACTN        IFEQ      'E'                                                        186566
     C                   MOVEL     'S'           @SCRN
     C                   GOTO      EndVAL@P
     C                   END
      *                                                                                       CPB002
      * If action code is insert                                                              CPB002
      *  .. Reset order number to blanks. It will be used in SEVTCUST                         CPB002
      * Only set to blanks if CSE039 is not on.                                               CSE039
      *                                                                                       CPB002
     C     DDACTN        IFEQ      'I'                                                        CPB002
     C     CSE039        ANDNE     'Y'                                                        CSE039
     C                   MOVEL     *BLANKS       DDORDE                                       CPB002
     C                   END                                                                  CPB002
     C                   END                                                                  186566
      *
      * Prior to validation, initialize error indicators as 'OK'
      * clear Trade in File Format, blank the following screens
      *
     C     DDACTN        IFEQ      'I'                                                        186566
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   CLEAR                   NwTrFilFmt
     C                   CLEAR                   NT1AFilFmt
     C                   CLEAR                   NT1BFilFmt
     C                   MOVEL     *BLANK        NewTrSeco
     C                   MOVEL     *BLANK        NewTrThir                                    CAS006
     C                   MOVEL     *BLANK        NewTrExch
     C                   MOVEL     *BLANK        NewTrSett
     C                   MOVEL     *BLANK        NewTrChcm
     C                   MOVEL     *BLANK        NewTrSwftA
     C                   MOVEL     *BLANK        NewTrSwftB
     C                   END                                                                  186566
      *
      * Validate Primary trade details
      *
     C                   CALLB     'SETRADPVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
 
      * Response mode
     C                   PARM                    RespMode
 
      ** Trade Primary Details
     C                   PARM                    NewTrPrim
      * Custom Extra Data file data                                             CAP004
     C                   PARM                    ExtData                        CAP004
 
      ** Trade settlement currency
     C                   PARM      *BLANK        DDSETC
      *
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM      'Y'           Validate          1
 
      * Output details of original book.                                                      193462
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
     C**********         PARM      *ZEROS        PFTCNR            6 0                 CAP067 CSD027
     C                   PARM      *BLANKS       PFTCNR            6                          CSD027
      *                                                                                       CAP067
      ** First Buy-sell trade type                                                            CAP067
     C                   PARM                    PFTDTP            2                          CAP067
      *                                                                                       CAP067
      ** First Buy-sell Value Date                                                            CAP067
     C                   PARM      *ZEROS        PFTDVD            5 0                        CAP067
      *                                                                                       CAP067
      ** First Buy-sell Security Shortname                                                    CAP067
     C                   PARM                    PFSESN           10                          CAP067
     C                   PARM                    CallFromVU                                   CAP087
      * OUTPUTS :
 
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      * Coupon Rate
      * Current Factor
     C                   PARM                    DDCPNR
     C                   PARM                    DDCFCT
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      ** Portfolio Details
     C                   PARM                    PortDts
      ** Default basket for backup withholding                                  CSE023
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
     C                   PARM                    WIdx_PVAL
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
      * PB Order Number                                                                       CPB002
     C                   PARM                    DDORDE                                       CPB002
      *
      * If errors returned
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@P
     C                   END
      * Security Report Name.                                                                 189082
     C**********         MOVEL     SRPN          DDSRPN                                189082 CSE016
     C                   MOVEL     SRPN          DDSRNME                                      CSE016
      * Get the Customer Report name.                                                         189082
     C                   EXSR      CUSTRPT                                                    189082
     C/COPY WNCPYSRC,SETRADSC03
      *
      * Default Secondary Screen details
      *
     C                   CALLB     'SETRADSVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      ** Trade Primary Details
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
      * Custom Extra Data file data                                             CAP004
     C                   PARM                    ExtData                        CAP004
     C/COPY WNCPYSRC,SETRADSC26
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM      'N'           Validate          1
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *                                                                                       CSE028
      ** MT5xx SSI (Phase 2)                                                                  CSE028
     C                   PARM                    CSE028                                       CSE028
      * CGL031 Switchable Feature                                                             CGL031
     C                   PARM                    CGL031                                       CGL031
      ** Current File Trade Date                                                              235547
     C                   PARM                    C_TDVD                                       235547
      * OUTPUTS :
      ** Settlement Currency Details
     C                   PARM                    SetCcyDts
      ** Trade Primary Details OK inds
     C                   PARM                    OKTrSeco
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
     C                   PARM                    WIdx_PVAL
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVE      *ALL'Y'       OKTrSeco
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Go to Secondary details screen
      *
     C                   MOVEL     'S'           @SCRN
      *
     C     EndVAL@P      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - PROCESS SECOND SCREEN
      *****************************************************************
     C     SCRN@S        BEGSR
 
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewTrPrim     PrvTrPrim
     C                   MOVEL     NewTrSeco     PrvTrSeco
     C                   Z-ADD     WIdx_SVAL     PrvN_Warn         3 0
      *
      * Set function key status on SECONDARY screen
      *
     C                   EXSR      SFKS@S
      *
      ** WRITE/READ DISPLAY SCREEN - Secondary Details
      *
     C                   CALLB     'SETRADSDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Trade (IN SCREEN FORMAT - Primary / Secondary)
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
      * Trade Status
      * Trade Authorized/Not Authorized
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14
      * Security report name
      * Customer report name
     C**********         PARM                    DDSRPN           20                          CSE016
     C                   PARM                    DDSRNME                                      CSE016
     C                   PARM                    DDCRNM           20
      * Current Factor
      * Coupon Rate
     C                   PARM                    DDCFCT           12
     C                   PARM                    DDCPNR           13
      *
      * Trade incomplete ind
     C                   PARM                    C_TINC
      *
      * Fields in error
     C                   PARM                    OKTrPrim
     C                   PARM                    OKTrSeco
      *
      ** Customer classification
     C                   PARM                    CustClass
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * ENABLED Function Keys
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KP = COMMAND KEY 15 = BROWSE
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKP
      * Protect book on second leg                                                            194229
     C                   PARM                    IN50                                         194229
     C                   PARM                    TRDBK1                                       194229
      ** CGL031 Switchable Feature                                                            CGL031
     C                   PARM                    CGL031                                       CGL031
      *                                                                                       194229
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL                                        CAP067
      *
      * OUTPUT PARAMETERS :
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKW             1                          CSE039
     C                   PARM      'Y'           @INKWDisp         1                          CSE039
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVE      *ALL'Y'       OKTrSeco
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F5 - Go to Initial Screen
     C     @INKE         CASEQ     '1'           INITIAL
      *
      * F7 - Roll Backwards
     C     @INKG         CASEQ     '1'           ROLL
      *
      * F8 - Roll Forwards
     C     @INKH         CASEQ     '1'           ROLL
      *
      * F12 - Cancel on Secondary Screen
     C     @INKL         CASEQ     '1'           CANC@S
      *
      * F15 - Build Browse
     C     @INKP         CASEQ     '1'           BLDBRW
      *
      * F22 - Build Browse                                                                    CSE039
     C     @INKW         CASEQ     '1'           DSPMOV                                       CSE039
      *                                                                                       CSE039
      * Validate Input to Secondary Screen
     C                   CAS                     VAL@S
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@S  - VALIDATE INPUT TO SECONDARY SCREEN
      *****************************************************************
     C     VAL@S         BEGSR
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     DDACTN        IFEQ      'D'
      *
      * IF F10 TAKEN, GO ON TO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EndVAL@S
     C                   END
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      * Go to Other details screen
      *
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   MOVEL     'H'           @SCRN                                        CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVEL     'O'           @SCRN
     C                   ENDIF                                                                CAS006
      *
     C                   GOTO      EndVAL@S
     C                   END
      *
      *----------------------------------------------------------------
      * IF AUTHORIZE / APPROVE
      *
     C*****DDACTN        IFEQ      'Y'                                                        186948
     C*****DDACTN        OREQ      'P'                                                        186948
     C     DDACTN        IFEQ      'P'                                                        186948
      *
      * Go to Other details screen
      *
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   MOVEL     'H'           @SCRN                                        CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVEL     'O'           @SCRN
     C                   ENDIF                                                                CAS006
      *
     C                   GOTO      EndVAL@S
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND / CHANGE
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'C'
     C     DDACTN        OREQ      'Y'                                                        186948
      *
      * FORCE INTEREST & PRICE RECALCULATION
      *
     C                   EXSR      INTRCAL
     C                   EXSR      PRCRCAL
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVE      *ALL'Y'       OKTrSeco
      *
      * Validate Primary trade details
      *
     C                   CALLB     'SETRADPVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      ** Trade Primary Details
     C                   PARM                    NewTrPrim
      * Custom Extra Data file data                                             CAP004
     C                   PARM                    ExtData                        CAP004
      ** Trade settlement currency
     C                   PARM                    DDSETC
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM      'Y'           Validate          1
      * Output details of original book.                                                      193462
     C                   PARM                    OLDBK1                                       193462
TAS  C                   PARM                    WARNIND                                      193462
      *                                                                                       193462
      ** First Buy-sell back indicator                                                        CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      ** First Buy-sell book code                                                             CAP067
     C                   PARM                    PFBPBK            2                          CAP067
      *                                                                                       CAP067
      ** First Buy-sell counterparty                                                          CAP067
     C**********         PARM      *ZEROS        PFTCNR            6 0                 CAP067 CSD027
     C                   PARM      *BLANKS       PFTCNR            6                          CSD027
      *                                                                                       CAP067
      ** First Buy-sell trade type                                                            CAP067
     C                   PARM                    PFTDTP            2                          CAP067
      *                                                                                       CAP067
      ** First Buy-sell Value Date                                                            CAP067
     C                   PARM      *ZEROS        PFTDVD            5 0                        CAP067
      *                                                                                       CAP067
      ** First Buy-sell Security Shortname                                                    CAP067
     C                   PARM                    PFSESN           10                          CAP067
     C                   PARM                    CallFromVU                                   CAP087
      * OUTPUTS :
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      * Coupon Rate
      * Current Factor
     C                   PARM                    DDCPNR
     C                   PARM                    DDCFCT
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      ** Portfolio Details
     C                   PARM                    PortDts
      ** Default basket for backup withholding                                  CSE023
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
     C                   PARM                    WIdx_SVAL
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
      * PB Order Number                                                                       CPB002
     C                   PARM                    DDORDE                                       CPB002
      *
      * Validate Secondary Screen details
      *
     C                   CALLB     'SETRADSVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      ** Trade Primary Details
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
      * Custom Extra Data file data                                             CAP004
     C                   PARM                    ExtData                        CAP004
     C/COPY WNCPYSRC,SETRADSC27
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM      'Y'           Validate          1
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *                                                                                       CSE028
      ** MT5xx SSI (Phase 2)                                                                  CSE028
     C                   PARM                    CSE028                                       CSE028
      ** CGL031 Switchable Feature                                                            CGL031
     C                   PARM                    CGL031                                       CGL031
      ** Current File Trade Date                                                              235547
     C                   PARM                    C_TDVD                                       235547
      * OUTPUTS :
      ** Settlement Currency Details
     C                   PARM                    SetCcyDts
      ** Trade Primary Details OK inds
     C                   PARM                    OKTrSeco
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
     C                   PARM                    WIdx_SVAL
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@S
     C                   END
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      *   re-output the screen
      *
     C     NewTrPrim     IFNE      PrvTrPrim
     C     NewTrSeco     ORNE      PrvTrSeco
     C     WIdx_SVAL     ORNE      PrvN_Warn
     C                   GOTO      EndVAL@S
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVE      *ALL'Y'       OKTrSeco
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Go to Other details screen
      *
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   MOVEL     'H'           @SCRN                                        CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVEL     'O'           @SCRN
     C                   ENDIF                                                                CAS006
     C                   END
      *----------------------------------------------------------------
      *
     C     EndVAL@S      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SCRN@T - Process third details screen                        *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SCRN@T        BEGSR                                                                CAS006
                                                                                              CAS006
      ** Call validation module for defaulting purposes only                                  CAS006
                                                                                              CAS006
     C                   CALLB     'SETRADTVAL'                                               CAS006
                                                                                              CAS006
      ** INPUTS                                                                               CAS006
                                                                                              CAS006
     C                   PARM                    RespMode                                     CAS006
     C                   PARM                    NewTrPrim                                    CAS006
     C                   PARM                    NewTrSeco                                    CAS006
     C                   PARM                    NewTrThir                                    CAS006
     C                   PARM                    ExtData                                      CAS006
     C                   PARM      'Y'           Default                                      CAS006
     C                   PARM      'N'           Validate                                     CAS006
     C                   PARM                    SECTY                                        CAS006
     C                   PARM                    INVTP                                        CAS006
     C                   PARM                    DDHACR                                       CAS006
     C                   PARM                    DDPRICN                                      CAS006
     C                   PARM                    CustDts                                      CAS006
     C                   PARM                    PortDts                                      CAS006
     C                   PARM                    NomCcyDts                                    CAS006
     C                   PARM                    SetCcyDts                                    CAS006
                                                                                              CAS006
      ** OUTPUTS                                                                              CAS006
                                                                                              CAS006
     C                   PARM                    OKTrThir                                     CAS006
     C                   PARM                    FldNameArr                                   CAS006
     C                   PARM                    MsgIDArr                                     CAS006
     C                   PARM                    MsgDtaArr                                    CAS006
     C                   PARM                    Idx                                          CAS006
     C                   PARM                    WFldNamArr                                   CAS006
     C                   PARM                    WMsgIDArr                                    CAS006
     C                   PARM                    WMsgDtaArr                                   CAS006
     C                   PARM                    WIdx_TVAL                                    CAS006
     C                   PARM                    NwTrFilFmt                                   CAS006
                                                                                              CAS006
      ** Update 'previous' screens and previous number of warnings                            CAS006
                                                                                              CAS006
     C                   MOVEL     NewTrThir     PrvTrThir                                    CAS006
     C                   Z-ADD     WIdx_TVAL     PrvN_Warn                                    CAS006
                                                                                              CAS006
      ** Write/Read display screen - Third Details screen                                     CAS006
                                                                                              CAS006
     C                   CALLB     'SETRADTDSP'                                               CAS006
                                                                                              CAS006
      ** INPUTS                                                                               CAS006
      ** Return code                                                                          CAS006
                                                                                              CAS006
     C                   PARM      *BLANKS       RetCodeOut                                   CAS006
                                                                                              CAS006
      ** Trade in screen format                                                               CAS006
                                                                                              CAS006
     C                   PARM                    NewTrPrim                                    CAS006
     C                   PARM                    NewTrThir                                    CAS006
                                                                                              CAS006
      ** Trade status                                                                         CAS006
      ** Security report name                                                                 CAS006
      ** Coupon Rate using Net Treasury Rate                                                  CAS006
      ** Net Treasury Price                                                                   CAS006
                                                                                              CAS006
     C                   PARM                    DDSTAT                                       CAS006
     C                   PARM                    DDSRNME                                      CAS006
     C                   PARM                    DDHACR                                       CAS006
     C                   PARM                    DDPRICN                                      CAS006
                                                                                              CAS006
      ** Trade incomplete ind                                                                 CAS006
                                                                                              CAS006
     C                   PARM                    C_TINC                                       CAS006
                                                                                              CAS006
      ** Security Details                                                                     CAS006
      ** Investment Type Details                                                              CAS006
                                                                                              CAS006
     C                   PARM                    SECTY                                        CAS006
     C                   PARM                    INVTP                                        CAS006
                                                                                              CAS006
      ** Buy-sell back                                                                        CAS006
                                                                                              CAS006
     C                   PARM      'N'           PBYSL                                        CAS006
                                                                                              CAS006
      ** Fields in error                                                                      CAS006
                                                                                              CAS006
     C                   PARM                    OKTrThir                                     CAS006
                                                                                              CAS006
      ** Errors                                                                               CAS006
                                                                                              CAS006
     C                   PARM                    FldNameArr                                   CAS006
     C                   PARM                    MsgIdArr                                     CAS006
     C                   PARM                    MsgDtaArr                                    CAS006
                                                                                              CAS006
      ** Warnings                                                                             CAS006
                                                                                              CAS006
     C                   PARM                    WFldNamArr                                   CAS006
     C                   PARM                    WMsgIdArr                                    CAS006
     C                   PARM                    WMsgDtaArr                                   CAS006
                                                                                              CAS006
      ** OUTPUTS                                                                              CAS006
      ** Function keys                                                                        CAS006
                                                                                              CAS006
     C                   PARM      '0'           @INKC                                        CAS006
     C                   PARM      '0'           @INKE                                        CAS006
     C                   PARM      '0'           @INKL                                        CAS006
                                                                                              CAS006
      ** Write screen with no read indicator                                                  CAS006
                                                                                              CAS006
     C                   PARM      'N'           WriteOnly                                    CAS006
                                                                                              CAS006
      ** Reset errors                                                                         CAS006
                                                                                              CAS006
     C                   MOVE      *ALL'Y'       OKTrThir                                     CAS006
     C                   MOVEL     *BLANK        FldNameArr                                   CAS006
     C                   MOVEL     *BLANK        MsgIdArr                                     CAS006
     C                   MOVEL     *BLANK        MsgDtaArr                                    CAS006
     C                   MOVEL     *BLANK        WFldNamArr                                   CAS006
     C                   MOVEL     *BLANK        WMsgIdArr                                    CAS006
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CAS006
                                                                                              CAS006
      ** F3 - End Program                                                                     CAS006
                                                                                              CAS006
     C     @INKC         CASEQ     '1'           ENDP                                         CAS006
                                                                                              CAS006
      ** F5 - Go to Initial Screen                                                            CAS006
                                                                                              CAS006
     C     @INKE         CASEQ     '1'           INITIAL                                      CAS006
                                                                                              CAS006
      ** F12 - Cancel on Secondary Screen                                                     CAS006
                                                                                              CAS006
     C     @INKL         CASEQ     '1'           CANC@T                                       CAS006
                                                                                              CAS006
      ** Validate Input to Third screen                                                       CAS006
                                                                                              CAS006
     C                   CAS                     VAL@T                                        CAS006
                                                                                              CAS006
     C                   ENDCS                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  VAL@T - Validate input to third screen                       *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     VAL@T         BEGSR                                                                CAS006
                                                                                              CAS006
      ** If enquire, authorize/approve, go to Other details screen                            CAS006
                                                                                              CAS006
     C                   IF        DDACTN = 'E'  OR  DDACTN = 'P'  OR                         CAS006
     C                             DDACTN = 'Y'                                               CAS006
     C                   EVAL      @SCRN = 'O'                                                CAS006
     C                   GOTO      EndVAL@T                                                   CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Insert, Amend, Change                                                                CAS006
                                                                                              CAS006
     C     DDACTN        IFEQ      'I'                                                        CAS006
     C     DDACTN        OREQ      'A'                                                        CAS006
     C     DDACTN        OREQ      'C'                                                        CAS006
                                                                                              CAS006
      ** Prior to validation, initialize error indicators as 'OK'                             CAS006
                                                                                              CAS006
     C                   Z-ADD     *ZERO         Idx                                          CAS006
     C                   Z-ADD     *ZERO         WIdx_TVAL                                    CAS006
     C                   MOVE      *ALL'Y'       OKTrThir                                     CAS006
                                                                                              CAS006
      ** Validate Third Screen details                                                        CAS006
                                                                                              CAS006
     C                   CALLB     'SETRADTVAL'                                               CAS006
                                                                                              CAS006
      ** INPUTS                                                                               CAS006
      ** Response mode                                                                        CAS006
                                                                                              CAS006
     C                   PARM                    RespMode                                     CAS006
                                                                                              CAS006
      ** Trade Primary Details                                                                CAS006
      ** Trade Secondary Details                                                              CAS006
      ** Trade Third Screen Details                                                           CAS006
                                                                                              CAS006
     C                   PARM                    NewTrPrim                                    CAS006
     C                   PARM                    NewTrSeco                                    CAS006
     C                   PARM                    NewTrThir                                    CAS006
                                                                                              CAS006
      ** Custom Extra Data file data                                                          CAS006
                                                                                              CAS006
     C                   PARM                    ExtData                                      CAS006
                                                                                              CAS006
      ** Default & Validate (Y or N)                                                          CAS006
                                                                                              CAS006
     C                   PARM      'Y'           Default                                      CAS006
     C                   PARM      'Y'           Validate                                     CAS006
                                                                                              CAS006
      ** Security Details                                                                     CAS006
      ** Investment Type Details                                                              CAS006
                                                                                              CAS006
     C                   PARM                    SECTY                                        CAS006
     C                   PARM                    INVTP                                        CAS006
                                                                                              CAS006
      ** Coupon rate using NTR                                                                CAS006
      ** Net Treasury Price                                                                   CAS006
                                                                                              CAS006
     C                   PARM                    DDHACR                                       CAS006
     C                   PARM                    DDPRICN                                      CAS006
                                                                                              CAS006
      ** Customer (Counterparty) Details                                                      CAS006
      ** Portfolio Details                                                                    CAS006
      ** Nominal Currency Details                                                             CAS006
      ** Settlement Currency Details                                                          CAS006
                                                                                              CAS006
     C                   PARM                    CustDts                                      CAS006
     C                   PARM                    PortDts                                      CAS006
     C                   PARM                    NomCcyDts                                    CAS006
     C                   PARM                    SetCcyDts                                    CAS006
                                                                                              CAS006
      ** Trade Exchange Rates OK inds                                                         CAS006
                                                                                              CAS006
     C                   PARM                    OKTrThir                                     CAS006
                                                                                              CAS006
      ** Error fields/message IDs/message data (arrays) from/to caller                        CAS006
                                                                                              CAS006
     C                   PARM                    FldNameArr                                   CAS006
     C                   PARM                    MsgIDArr                                     CAS006
     C                   PARM                    MsgDtaArr                                    CAS006
                                                                                              CAS006
      ** Array index (3P0) from/to caller                                                     CAS006
                                                                                              CAS006
     C                   PARM                    Idx                                          CAS006
                                                                                              CAS006
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CAS006
                                                                                              CAS006
     C                   PARM                    WFldNamArr                                   CAS006
     C                   PARM                    WMsgIDArr                                    CAS006
     C                   PARM                    WMsgDtaArr                                   CAS006
                                                                                              CAS006
      ** Array index (3P0) from/to caller                                                     CAS006
                                                                                              CAS006
     C                   PARM                    WIdx_OVAL                                    CAS006
                                                                                              CAS006
      ** Valid Trade layout (DS) from/to caller                                               CAS006
                                                                                              CAS006
     C                   PARM                    NwTrFilFmt                                   CAS006
                                                                                              CAS006
      ** Errors returned                                                                      CAS006
                                                                                              CAS006
     C                   IF        Idx <> 0                                                   CAS006
     C                   GOTO      EndVAL@T                                                   CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** If the screen has changed in the course of the validation                            CAS006
      ** or if there are warnings which have not been displayed                               CAS006
      ** re-output the screen                                                                 CAS006
                                                                                              CAS006
     C                   IF        NewTrThir <> PrvTrThir  OR                                 CAS006
     C                             WIdx_TVAL <> PrvN_Warn                                     CAS006
     C                   GOTO      EndVAL@T                                                   CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Clear any warning messages                                                           CAS006
                                                                                              CAS006
     C                   MOVE      *ALL'Y'       OKTrThir                                     CAS006
     C                   MOVEL     *BLANK        WFldNamArr                                   CAS006
     C                   MOVEL     *BLANK        WMsgIdArr                                    CAS006
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CAS006
                                                                                              CAS006
      ** Go to Other details screen                                                           CAS006
                                                                                              CAS006
     C                   MOVEL     'O'           @SCRN                                        CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C     EndVAL@T      ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************
      * SCRN@O - PROCESS OTHER DETAILS SCREEN
      *****************************************************************
     C     SCRN@O        BEGSR
 
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewTrExch     PrvTrExch
     C                   MOVEL     NewTrSett     PrvTrSett
     C                   MOVEL     NewTrChCm     PrvTrChCm
     C                   Z-ADD     WIdx_OVAL     PrvN_Warn         3 0
 
      * Pass clearance type from primary to other details screen
 
     C                   MOVEL     DDCLTY        DDCLTY2
      *
      * IF FIRST TIME FOR ACTION CODE, TRADE REF, CURRENCY OR CUSTOMER
      * OR IF NO DETAILS PRESENT                                                154208
      *
     C     DDACTN        IFNE      ##ACTN
     C     DDTDRF        ORNE      ##TDRF
     C     DDTDTP        ORNE      ##TDTP                                                     234440
     C     DDNOML        ORNE      ##NOML                                                     234440
     C     DDTPDY        ORNE      ##TPDY                                                     234440
     C     DDTDVD        ORNE      ##TDVD                                                     234440
     C     DDFSPR        ORNE      ##FSPR                                                     234440
     C     DDITRA        ORNE      ##ITRA                                                     234440
     C     DDSETC        ORNE      ##SETC
     C     DDCNUM        ORNE      ##CNUM
     C     PrvTrExch     OREQ      *BLANK                                       154208
     C     PrvTrSett     ANDEQ     *BLANK                                       154208
     C     PrvTrChCm     ANDEQ     *BLANK                                       154208
      *
      * IF INSERT, AMEND OR CHANGE
      * DO DEFAULTING FOR OTHER DETAILS SCREEN
      * DO CHARGES AND COMMISSIONS CALCULATION
      * DO COUNTERVALUE CALCULATION
      /COPY WNCPYSRC,SETRADS013                                                               CUT009
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'C'
     C                   EXSR      DFLT@O
     C     BVACOP        IFEQ      'Y'
     C                   EXSR      CHCMCAL
     C                   END
     C/COPY WNCPYSRC,SETRADSC09
     C     CGL031        IFEQ      'Y'                                                        233881
     C                   EXSR      EUTXCAL                                                    233881
     C                   ENDIF                                                                233881
     C                   EXSR      CVALCAL
     C                   END
     C                   END
      *
      ** WRITE/READ DISPLAY - Other Details Screen
      /COPY WNCPYSRC,SETRADS014                                                               CUT009
      *
     C                   CALLB     'SETRADODSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS:
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      * Trade (IN SCREEN FORMAT) - Primary/Secondary/Other Details
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrChCm
      *
      * Current trade incomplete ind and date made complete
     C                   PARM                    C_TINC
     C                   PARM                    C_TDMC
      *
      * Customer classification, Customer PM (Y/N) and nominal currency
      * And Private Banking Customer (Y/N)                                      CPB001
     C                   PARM                    CustClass         1
     C                   PARM                    CustPM            1
     C                   PARM                    NMCY              3
     C                   PARM                    CustPB            1            CPB001
      *                                                                         CSE023
      ** Withholding tax                                                        CSE023
      *                                                                         CSE023
     C                   PARM                    DDWTAX                         CSE023
      * Fields in error
     C                   PARM                    OKTrExch
     C                   PARM                    OKTrSett
     C                   PARM                    OKTrChcm
      * Security report name
      * Countervalue
      ** FX Margin Amount
      ** Portfolio exchange rate & M/D ind screen format
     C**********         PARM                    DDSRPN                                       CSE016
     C                   PARM                    DDSRNME                                      CSE016
     C                   PARM                    DDTCTR
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ** CGL031 Switchable Feature                                                            CGL031
     C                   PARM                    CGL031                                       CGL031
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL                                        CAP067
      *
      ** OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKL             1
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKTrExch
     C                   MOVE      *ALL'Y'       OKTrSett
     C                   MOVE      *ALL'Y'       OKTrChcm
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** Pass clearance type from other details to primary screen
      *
     C                   MOVEL     DDCLTY2       DDCLTY
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F5 - Go To Initial Screen
     C     @INKE         CASEQ     '1'           INITIAL
      *
      * F12 - Cancel on Other Details Screen
     C     @INKL         CASEQ     '1'           CANC@O
      *
      * Validate Input to Other Details Screen
     C                   CAS                     VAL@O
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DFLT@O  - DO DEFAULTING FOR OTHER DETAILS SCREEN
      *****************************************************************
     C     DFLT@O        BEGSR
 
      ** EXCHANGE RATE DEFAULTING
 
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'C'
     C     DDSETC        ANDNE     C_SETC
 
     C                   CALLB     'SETEXCHDFT'
 
      * INPUTS
      *
      ** Nominal Currency
      ** Settlement Currency
     C                   PARM                    NMCY              3
     C                   PARM                    DDSETC            3
 
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
      ** ICD
      ** Euro Currency
      ** EMU SE Settlement Ccy Conv.
     C                   PARM                    BKEURO            3
     C                   PARM                    CEU005            1            CAP050
 
      * OUTPUTS
 
      ** Trade Exchange Rate screen fields
 
     C                   PARM                    NewTrExch
 
      ** Trade Exchange Rate file fields
 
     C                   PARM                    TDER             13 8
     C                   PARM                    TMDI              1
     C                   PARM                    TBCR             13 8
 
     C                   END
 
      ** SETTLEMENT INSTRUCTION DEFAULTING
 
     C     DDACTN        IFEQ      'I'
 
     C                   CALLB     'SETSETIDFT'
 
      * INPUTS
 
      ** Booking branch
      ** Incomplete Ind
      ** Trade Type
      ** Settlement Currency
      ** Market Ind.
      ** Book Code.                                                                           CSE028
      ** Market Centre                                                                        CSE034
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDINCS            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSETC            3
     C                   PARM                    DDTDMI            1
     C                   PARM                    DDBPBK                                       CSE028
     C                   PARM                    DDMRKT                                       CSE034
 
      ** Investment type (SECTYD)
 
     C                   PARM                    SITP              3
 
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
 
      ** Customer (Counterparty) Details
      ** ( Note: Customer Participant/Non-participant Indicator 1 and
      **  Customer Participant/Non-participant Indicator 2 are also outputs)
     C                   PARM                    CustDts
 
 
      ** ICD
      ** Depot 1 (Eurclear)
      ** Depot 2 (Cedel)
     C                   PARM                    BVDR1             6
     C                   PARM                    BVDR2             6
      *                                                                                       CSE028
      ** MT5xx SSI (Phase 2)                                                                  CSE028
     C                   PARM                    CSE028                                       CSE028
 
      * OUTPUTS
 
      ** Trade Settlement Instructions
 
     C                   PARM                    NewTrSett
 
     C                   END
 
      ** CHARGE/COMMISSION DEFAULTING
 
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'C'
 
     C                   CALLB     'SETCHCMDFT'
 
      * INPUTS
 
      ** Bulk reference
      ** Incomplete Ind.
      ** Market Centre
     C                   PARM                    DDBLKR            6
     C                   PARM                    DDINCS            1
     C                   PARM                    DDMRKT            2
      *
      ** Trade Counterparty
     C                   PARM                    TCNR
      *
      ** Security details
     C                   PARM                    SECTY
      *
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      ** Portfolio Details
     C                   PARM                    PortDts
      *
      ** ICD
      ** PM installed
      ** Bank Portfolios installed
      ** Ref applied to 9997 portfolio
      ** Autocharge Option
      ** Adjust Commission Same Day T
      ** Priority of Cust Grp Dft
      ** Priority of Invst typ Dft
      ** Priority of Market Dft
      ** Priority of Cust Chrg Dft
      ** Midas/TOF I/F installed
     C                   PARM                    BGPFMG            1
     C                   PARM                    FCPORS            1
     C                   PARM                    FCR997            4
     C                   PARM                    BVACOP            1
     C                   PARM                    BVACSD            1
     C                   PARM                    BVPCSD            1
     C                   PARM                    BVPIDF            1
     C                   PARM                    BVPMDF            1
     C                   PARM                    BVPOCD            1
     C                   PARM                    S01496            1
     C****************** PARM                    CAP050            1     CAP050 CPB001
     C                   PARM                    BGN4ST            1            CPB001
 
      * OUTPUTS
 
      ** Commission Rebate %
     C                   PARM                    CMRP              5 3
 
      ** Trade Charges & Commissions screen fields
 
     C                   PARM                    NewTrChCm
 
      ** Trade Charges & Commissions file fields
 
     C                   PARM                    TBCC              2
     C                   PARM                    TCCC              2
     C                   PARM                    TCC1              2
     C                   PARM                    TCC2              2
 
     C                   END
 
      ** UPDATE CHECK FIELDS
 
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     DDTDRF        ##TDRF            6
     C                   MOVEL     DDTDTP        ##TDTP            2                          234440
     C                   MOVEL     DDNOML        ##NOML           12                          234440
     C                   MOVEL     DDTPDY        ##TPDY           16                          234440
     C                   MOVEL     DDTDVD        ##TDVD            7                          234440
     C                   MOVEL     DDFSPR        ##FSPR           16                          234440
     C                   MOVEL     DDITRA        ##ITRA           15                          234440
     C                   MOVEL     DDSETC        ##SETC            3
     C                   MOVEL     DDCNUM        ##CNUM           10
     C                   MOVEL     DDDELF        PrvDELF          10                          CSE034
     C                   MOVEL     DDDELT        PrvDELT          10                          CSE034
 
     C     EndDFLT@O     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@O  - VALIDATE INPUT TO OTHER DETAILS SCREEN
      *****************************************************************
     C     VAL@O         BEGSR
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      * If MT5XX Message Generation not installed,
      *     If Browse outstanding, read next Browse Subfile record
      *     Else, Go To Initial screen
      * Else, Go to EXTENSION (SWIFT) screen A
      *
     C     S01401        IFNE      'Y'
      *                                                                         CSE006
      * If this is a Buy-Sell Back, ensure other trade is displayed             CSE006
      * next (i.e. use the Link Ref as the new Trade Ref).                      CSE006
     C                   IF        CSE006 = 'Y'  and  DDLKRF <> *Blanks         CSE006
      *                                                                         CSE006
     C                   IF        COUNT > *Zeros                               CSE006
     C                   EVAL      COUNT = *Zeros                               CSE006
     C                   EXSR      INITIAL                                      CSE006
     C                   GOTO      EndVAL@O                                     CSE006
     C                   ENDIF                                                  CSE006
      *                                                                         CSE006
     C                   EVAL      FldNameArr(1) = '*ANY'                       CSE006
     C                   EVAL      MsgIdArr(1) = 'MMM0023'                      CSE006
     C                   ADD       1             COUNT                          CSE006
     C                   EVAL      WWACTN = DDACTN                              CSE006
     C                   EVAL      WWTDRF = DDLKRF                              CSE006
     C                   EXSR      INITIAL                                      CSE006
     C                   EVAL      DDACTN = WWACTN                              CSE006
     C                   EVAL      DDTDRF = WWTDRF                              CSE006
     C                   GOTO      EndVAL@O                                     CSE006
     C                   ENDIF                                                  CSE006
      *
     C/COPY WNCPYSRC,SETRADSC19
   ??C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
     C                   EXSR      INITIAL
     C                   END
     C/COPY WNCPYSRC,SETRADSC20
      *
     C                   ELSE
     C/COPY WNCPYSRC,SETRADSC21
     C                   MOVEL     'A'           @SCRN
     C/COPY WNCPYSRC,SETRADSC22
     C                   END
      *
     C                   GOTO      EndVAL@O
     C                   END
      *
      *----------------------------------------------------------------
      * IF AUTHORIZE / APPROVE
      *
     C     DDACTN        IFEQ      'Y'
     C     DDACTN        OREQ      'P'
      *
      * If MT5XX Message Generation not installed, Go To Updates
      * Else, Go to EXTENSION (SWIFT) screen A
      *
     C     S01401        IFNE      'Y'
     C                   MOVEL     'U'           @SCRN
     C                   ELSE
     C                   MOVEL     'A'           @SCRN
     C                   END
      *
     C/COPY WNCPYSRC,SETRADSC23
     C                   GOTO      EndVAL@O
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND / CHANGE
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'C'
      *
      * CHARGES AND COMMISSIONS CALCULATION
      *
     C     BVACOP        IFEQ      'Y'
     C                   EXSR      CHCMCAL
     C                   END
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx_OVAL         3 0
     C                   MOVE      *ALL'Y'       OKTrExch
     C                   MOVE      *ALL'Y'       OKTrSett
     C                   MOVE      *ALL'Y'       OKTrChcm
      *
      * Validate "Other Details" Screen
      *
     C                   CALLB     'SETRADOVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      ** Trade Primary Details
      ** Trade Secondary Details
      ** Trade Exchange Rates
      ** Trade Settlement Instructions
      ** Trade Charge & Commissions
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrChCm
      * Custom Extra Data file data                                             CAP004
     C                   PARM                    ExtData                        CAP004
 
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
 
      ** Portfolio Details
     C                   PARM                    PortDts
 
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
      ** CGL031 Switchable Feature                                                            CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * OUTPUTS :
      ** FX Margin Amount
      ** Portfolio exchange rate & M/D ind screen format
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
 
      ** Trade Exchange Rates OK inds
      ** Trade Settlement Instructions OK
      ** Trade Charge & Commissions OK inds
     C                   PARM                    OKTrExch
     C                   PARM                    OKTrSett
     C                   PARM                    OKTrChcm
 
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
     C                   PARM                    WIdx_OVAL
 
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
      *
      * DO COUNTERVALUE CALCULATION
      *
     C/COPY WNCPYSRC,SETRADSC10
     C     CGL031        IFEQ      'Y'                                                        233881
     C                   EXSR      EUTXCAL                                                    233881
     C                   ENDIF                                                                233881
     C                   EXSR      CVALCAL
     C/COPY WNCPYSRC,SETRADSC11
                                                                                             BUG3145
      ** Additional validations                                                              BUG3145
      ** (Pay To Account)                                                                    BUG3145
                                                                                             BUG3145
     C                   IF        CGL014 = 'Y'  AND  PAYT <> *BLANKS                        BUG3145
     C                             AND  DDPAYTOK <> 'N'                                      BUG3145
                                                                                             BUG3145
     C                   CALLB     'SETRADAVAL'                                              BUG3145
                                                                                             BUG3145
      ** INPUTS                                                                              BUG3145
                                                                                             BUG3145
      ** Action Code                                                                         BUG3145
      ** Nominal Currency                                                                    BUG3145
     C                   PARM                    DDACTN                                      BUG3145
     C                   PARM                    NMCY                                        BUG3145
                                                                                             BUG3145
      ** Valid Trade layout (DS) from/to caller                                              BUG3145
     C                   PARM                    NwTrFilFmt                                  BUG3145
                                                                                             BUG3145
      ** OUTPUTS                                                                             BUG3145
                                                                                             BUG3145
      ** Trade Settlement Instructions OK                                                    BUG3145
     C                   PARM                    OKTrSett                                    BUG3145
                                                                                             BUG3145
      ** Error fields/message IDs/message data (arrays) from/to caller                       BUG3145
     C                   PARM                    FldNameArr                                  BUG3145
     C                   PARM                    MsgIDArr                                    BUG3145
     C                   PARM                    MsgDtaArr                                   BUG3145
                                                                                             BUG3145
      ** Array index (3P0) from/to caller                                                    BUG3145
     C                   PARM                    Idx                                         BUG3145
                                                                                             BUG3145
      ** Warning fields/message IDs/message data (arrays) from/to caller                     BUG3145
     C                   PARM                    WFldNamArr                                  BUG3145
     C                   PARM                    WMsgIDArr                                   BUG3145
     C                   PARM                    WMsgDtaArr                                  BUG3145
                                                                                             BUG3145
      ** Array index (3P0) from/to caller                                                    BUG3145
     C                   PARM                    WIdx_OVAL                                   BUG3145
     C                   ENDIF                                                               BUG3145
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@O
     C                   END
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      *   re-output the screen
      *
     C     NewTrExch     IFNE      PrvTrExch
     C     NewTrSett     ORNE      PrvTrSett
     C     NewTrChCm     ORNE      PrvTrChCm
     C     WIdx_OVAL     ORNE      PrvN_Warn
     C                   GOTO      EndVAL@O
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKTrExch
     C                   MOVE      *ALL'Y'       OKTrSett
     C                   MOVE      *ALL'Y'       OKTrChcm
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C/COPY WNCPYSRC,SETRADSC04
      *
      * If MT5XX Message Generation not installed, Go To Updates
      * Else, Go to EXTENSION (SWIFT) screen A
      *
     C     S01401        IFNE      'Y'
     C                   MOVEL     'U'           @SCRN
     C                   ELSE
     C                   MOVEL     'A'           @SCRN
     C                   END
     C/COPY WNCPYSRC,SETRADSC05
      *
     C                   END
      *----------------------------------------------------------------
      *
     C     EndVAL@O      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@E_A - PROCESS EXTENSION (SWIFT) SCREEN A
      *****************************************************************
     C     SCRN@E_A      BEGSR
      *
      ** Check whether screen B is required
      *
     C                   MOVE      'N'           Display_B         1
     C     CSW003        IFEQ      'Y'
     C     CustClass     IFEQ      'S'
     C     DELT          ANDNE     DELF
     C     CustClass     OREQ      'D'
     C     DELT          ANDNE     DELF
     C                   MOVE      'Y'           Display_B
     C                   END
     C                   END
 
      * Update 'previous' screens and previous number of warnings
 
     C**********         MOVEL     NewTrSwftA    PrvTrSwft                                    201429
     C**********         Z-ADD     WIdx_EVALA    PrvN_Warn         3 0                        201429
      *
      * IF INSERTION AND
      * IF FIRST TIME FOR TRADE REF, TYPE, METHOD, CLEAR TYPE, DEPOTS ..
      *
     C     DDACTN        IFEQ      'I'
     C     DDTDRF        IFNE      A_##TDRF
     C     DDTDRF        ANDNE     *BLANKS                                                    201429
     C     A_##TDRF      ANDNE     *BLANKS                                                    201429
     C     DDTDTP        ORNE      A_##TDTP
     C     DDSMTH        ORNE      A_##SMTH
     C     DDCLTY        ORNE      A_##CLTY
     C     DDPCOD        ORNE      A_##PCOD
     C     DDPRYC        ORNE      A_##PRYC
     C     DDCNUM        ORNE      A_##CNUM
     C     DDDELF        ORNE      A_##DELF
     C     DDDELT        ORNE      A_##DELT
     C     NewTrSwftA    OREQ      *BLANK                                       154208
     C                   IF        DDDELF = PrvDELF AND                                       CSE034
     C                             DDDELT = PrvDELT                                           CSE034
      *
      * DO DEFAULTING FOR EXTENSION SCREEN A
      *
     C                   EXSR      DFLT@E_A
     C                   MOVE      'Y'           DftFlag           1                          CSE034
     C                   ELSE                                                                 CSE034
     C                   Eval      DftFlag = 'N'                                              CSE034
                                                                                              210466
      ** Default the Time                                                                     210466
                                                                                              210466
     C                   TIME                    WWTime                                       210466
     C                   MOVEL     WWTIME        A_DDTRTT                                     210466
                                                                                              212734
     C                   MOVEL     DDTDRF        A_##TDRF                                     212734
     C                   MOVEL     DDTDTP        A_##TDTP                                     212734
     C                   MOVEL     DDSMTH        A_##SMTH                                     212734
     C                   MOVEL     DDCLTY        A_##CLTY                                     212734
     C                   MOVEL     DDPCOD        A_##PCOD                                     212734
     C                   MOVEL     DDPRYC        A_##PRYC                                     212734
     C                   MOVEL     DDCNUM        A_##CNUM                                     212734
     C                   MOVEL     DDDELF        A_##DELF                                     212734
     C                   MOVEL     DDDELT        A_##DELT                                     212734
                                                                                              210466
     C                   ENDIF                                                                CSE034
     C                   END
     C                   END
      *                                                                                       201429
     C                   MOVEL     NewTrSwftA    PrvTrSwft                                    201429
     C                   Z-ADD     WIdx_EVALA    PrvN_Warn         3 0                        201429
      *
      ** WRITE/READ DISPLAY - Extension Screen
      *
     C                   CALLB     'SETRADEDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUT PARAMETERS :
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Screen A/B
     C                   PARM      'A'           Screen
      *
      * Trade (IN SCREEN FORMAT) - Primary/Settlements/SWIFT
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco                      140951
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrSwftA
     C                   PARM                    NewTrExtA                                    CSE045
      *
      * Trade (file fields)
     C                   PARM                    TCNR
     C                   PARM                    TNMC                           140951
     C                   PARM                    NOML                           140951
     C                   PARM                    TDVD                           140951
     C                   PARM                    DELF
     C                   PARM                    DELT
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM                    PUYAT             1                          201429
      *                                                                                       201429
      ** ISO15022 indicator - file field                                                      201429
     C                   PARM                    CA_T1NEW                                     201429
      *                                                                                       CSE034
      ** Default SSI Flag                                                                     CSE034
     C                   PARM                    DftFlag                                      CSE034
      * Fields in error
     C                   PARM                    OKTrSwft
     C                   PARM                    OKTrExts                                     CSE045
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * Destination of Settlement Text fields
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
      * Destination of Confirmation Text fields
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      * Security report name
     C**********         PARM                    DDSRPN                                       CSE016
     C                   PARM                    DDSRNME                                      CSE016
      * Swift 2001 flag                                                                       CSW201
     C                   PARM                    CSW201                                       CSW201
     C                   PARM      'SIN'         PMODE                                        CSE045
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL                                        CAP067
      *
      ** OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1            140951
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
     C                   PARM                    SEVTRX2A                                     CSE045
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F5 - Go To Initial Screen
     C     @INKE         CASEQ     '1'           INITIAL
      *
      * F12 - Cancel on Extension Screen
     C     @INKL         CASEQ     '1'           CANC@E_A
      *                                                                         140951
      * F14 - Return from F14 Ext. Settlements                                  140951
     C     @INKN         CASEQ     '1'           ExtSettA                       140951
      *
      * Validate Input to Extension Screen
     C                   CAS                     VAL@E_A
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DFLT@E_A  - DO DEFAULTING FOR EXTENSION SCREEN A
      *****************************************************************
     C     DFLT@E_A      BEGSR
      *
      ** SWIFT (SCREEN) FIELD DEFAULTING
      *
     C                   CALLB     'SETSWFTDFT'
      *
      ** INPUT PARAMETERS :
      *
      * Screen A/B
     C                   PARM      'A'           Screen            1
      *
      * Trade Details (screen)
      *
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSMTH            2
     C                   PARM                    DDCLTY            1
     C                   PARM                    DDPCOD            1
     C                   PARM                    DDPRYC            1
     C                   PARM                    DDBRCD                                       CSE028
     C                   PARM                    DDBPBK                                       CSE028
     C                   PARM                    DDSETC                                       CSE028
     C                   PARM                    DDMRKT                                       CSE034
      *
      * Trade Details (file)
     C                   PARM                    TDVD
     C                   PARM                    TCNR
     C                   PARM                    DELF
     C                   PARM                    DELT
     C                   PARM                    INVT                                         199797
      *
      * (CSW003) MT5XX - Phase 2 Message Generation
     C                   PARM                    CSW003            1
      *
      ** OUTPUT PARAMETERS :
      *
      * Screen A details
     C                   PARM                    NewTrSwftA
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      *
      * Screen B details
     C                   PARM                    NewTrSwftB
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
 
     C                   MOVEL     DDTDRF        A_##TDRF          6
     C                   MOVEL     DDTDTP        A_##TDTP          2
     C                   MOVEL     DDSMTH        A_##SMTH          2
     C                   MOVEL     DDCLTY        A_##CLTY          1
     C                   MOVEL     DDPCOD        A_##PCOD          1
     C                   MOVEL     DDPRYC        A_##PRYC          1
     C                   MOVEL     DDCNUM        A_##CNUM         10
     C                   MOVEL     DDDELF        A_##DELF         10
     C                   MOVEL     DDDELT        A_##DELT         10
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@E_A - VALIDATE INPUT TO EXTENSION SCREEN A
      *****************************************************************
     C     VAL@E_A       BEGSR
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      * If screen B can't be displayed
      *    If Browse outstanding, read next Browse Subfile record
      *    Else, Go To Initial screen
      * Else, Go to EXTENSION (SWIFT) screen B
      *
     C     Display_B     IFNE      'Y'
 
   ??C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *                                                                         CSE006
      *** If the book is not a buy-sell book then no new processing is          CSE006
      *** required, otherwise both sides of trade must be entered.              CSE006
      *                                                                         CSE006
     C                   IF        CSE006 = 'Y'                                 CSE006
      *                                                                         CSE006
     C                   CALLB     'AOBOOKR0'                                   CSE006
     C                   PARM      *BLANKS       @RTCD             7            CSE006
     C                   PARM      '*KEY   '     @OPTN             7            CSE006
     C                   PARM      DDBPBK        @BOOK             2            CSE006
     C     SDBOOK        PARM      SDBOOK        DSFDY                          CSE006
      *                                                                         CSE006
     C                   IF        BDBYSL = 'Y' AND                             CSE006
     C                             COUNT < 1                                    CSE006
     C                   EVAL      BySlBk_AEC = *ON                             CSE006
     C                   EVAL      FldNameArr(1) = '*ANY'                       CSE006
     C                   EVAL      MsgIdArr(1) = 'MMM0023'                      CSE006
     C                   ADD       1             COUNT                          CSE006
     C                   EVAL      WWACTN = DDACTN                              CSE006
     C                   EVAL      WWTDRF = DDLKRF                              CSE006
      *                                                                         CSE006
      *** Using the same action code, use the link reference from the           CSE006
      *** previous record as the new trade reference.                           CSE006
      *                                                                         CSE006
     C                   EXSR      INITIAL                                      CSE006
     C                   EVAL      DDACTN = WWACTN                              CSE006
     C                   EVAL      DDTDRF = WWTDRF                              CSE006
     C                   ELSE                                                   CSE006
     C                   Z-ADD     0             COUNT                          CSE006
     C                   EXSR      INITIAL
     C                   ENDIF                                                  CSE006
     C                   ELSE                                                   CSE006
     C                   EXSR      INITIAL                                      CSE006
     C                   ENDIF                                                  CSE006
     C                   END
 
     C                   ELSE
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C                   GOTO      EndVAL@E_A
     C                   END
      *
      *----------------------------------------------------------------
      * IF AUTHORIZE / APPROVE
      *
     C     DDACTN        IFEQ      'Y'
     C     DDACTN        OREQ      'P'
      *
      * If screen B can't be displayed
      *    Go to updates
      * Else, Go to EXTENSION (SWIFT) screen B
      *
     C     Display_B     IFNE      'Y'
     C                   MOVEL     'U'           @SCRN
     C                   ELSE
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C                   GOTO      EndVAL@E_A
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND / CHANGE
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'C'
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx_EVALA        3 0
     C                   MOVE      *ALL'Y'       OKTrSwft
      *
      * Validate Extension Screen
      *
     C                   CALLB     'SETRADEVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Screen (A or B)
     C                   PARM      'A'           Screen            1
      *
      ** Trade Primary Details
      ** Trade Secondary Details
      ** Trade Exchange Rates
      ** Trade Settlement Details
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
      *
      ** Trade Extension File details
     C                   PARM                    NewTrSwftA
      * Custom Extra Data file data                                             CAP004
     C                   PARM                    ExtData                        CAP004
      *
      ** Previous inds
     C                   PARM                    @ADDGMES
     C                   PARM                    @ADDGMEC
     C                   PARM                    @ADDCCID
     C                   PARM                    CA_T1CONG
      *
      ** Processing type
     C                   PARM                    PROT              1
      *
      ** Override errors
     C                   PARM                    OVRErrors         1
      *
      ** Valid Trade layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
      * Swift 2001 flag                                                                       CSW201
     C                   PARM                    CSW201                                       CSW201
      *                                                                                       201233
      ** Destination of settlement                                                            201233
     C                   PARM                    A_DDROTS                                     201233
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM                    PUYAT                                        201429
                                                                                              210517
      ** Tradsdx2 data                                                                        210517
                                                                                              210517
     C                   PARM      *BLANKS       PTradeX2                                     210517
      *
      ** OUTPUTS
      *
      * OK Flags
     C                   PARM                    OKTrSwft
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
     C                   PARM                    WIdx_EVALA
      *
      * Valid Trade layout (DS) (Extension file) from/to caller
     C                   PARM                    NT1AFilFmt
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@E_A
     C                   END
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      *   re-output the screen
      *
     C     NewTrSwftA    IFNE      PrvTrSwft
     C     WIdx_EVALA    ORNE      PrvN_Warn
     C     PUYAT         OREQ      'N'                                                        201429
     C     PUYAT         IFEQ      'N'                                                        201429
     C                   EVAL      PUYAT = 'Y'                                                201429
     C                   ENDIF                                                                201429
     C                   GOTO      EndVAL@E_A
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * If screen B can't be displayed
      *    Go to updates
      * Else, Go to EXTENSION (SWIFT) screen B
      *
     C     Display_B     IFNE      'Y'
     C                   MOVEL     'U'           @SCRN
     C                   ELSE
     C                   MOVEL     'B'           @SCRN
     C                   END
      *
     C                   END
      *----------------------------------------------------------------
      *
     C     EndVAL@E_A    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@E_B - PROCESS EXTENSION (SWIFT) SCREEN B
      *****************************************************************
     C     SCRN@E_B      BEGSR
 
      * Update 'previous' screens and previous number of warnings
 
     C*********          MOVEL     NewTrSwftB    PrvTrSwft                                    201429
     C*********          Z-ADD     WIdx_EVALB    PrvN_Warn         3 0                        201429
      *
      * IF INSERTION AND
      * IF FIRST TIME FOR TRADE REF, TYPE, METHOD, CLEAR TYPE, DEPOTS ..
      *
     C     DDACTN        IFEQ      'I'
     C     DDTDRF        IFNE      B_##TDRF
     C     DDTDRF        ANDNE     *BLANKS                                                    201429
     C     B_##TDRF      ANDNE     *BLANKS                                                    201429
     C     DDTDTP        ORNE      B_##TDTP
     C     DDSMTH        ORNE      B_##SMTH
     C     DDCLTY        ORNE      B_##CLTY
     C     DDPCOD        ORNE      B_##PCOD
     C     DDPRYC        ORNE      B_##PRYC
     C     DDCNUM        ORNE      B_##CNUM
     C     DDDELF        ORNE      B_##DELF
     C     DDDELT        ORNE      B_##DELT
     C     NewTrSwftB    OREQ      *BLANK                                       154208
      *
      * DO DEFAULTING FOR EXTENSION SCREEN B
      *
     C                   EXSR      DFLT@E_B
     C                   END
     C                   END
      *                                                                                       201429
     C                   MOVEL     NewTrSwftB    PrvTrSwft                                    201429
     C                   Z-ADD     WIdx_EVALB    PrvN_Warn         3 0                        201429
      *
      ** WRITE/READ DISPLAY - Extension Screen
      *
     C                   CALLB     'SETRADEDSP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUT PARAMETERS :
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Screen A/B
     C                   PARM      'B'           Screen
      *
      * Trade (IN SCREEN FORMAT) - Primary/Settlements/SWIFT
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco                      140951
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrSwftB
     C                   PARM                    NewTrExtB                                    CSE045
      *
      * Trade (file fields)
     C                   PARM                    TCNR
     C                   PARM                    TNMC                           140951
     C                   PARM                    NOML                           140951
     C                   PARM                    TDVD                           140951
     C                   PARM                    DELF
     C                   PARM                    DELT
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM                    PUYAT             1                          201429
      *                                                                                       201429
      ** ISO15022 indicator - file field                                                      201429
     C                   PARM                    CB_T1NEW                                     201429
      *                                                                                       222373
      ** Default SSI Flag                                                                     222373
     C                   PARM                    DftFlag                                      222373
      * Fields in error
     C                   PARM                    OKTrSwft
     C                   PARM                    OKTrExts                                     CSE045
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * Destination of Settlement Text fields
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
      * Destination of Confirmation Text fields
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
      * Security report name
     C**********         PARM                    DDSRPN                                       CSE016
     C                   PARM                    DDSRNME                                      CSE016
      * Swift 2001 flag                                                                       CSW201
     C                   PARM                    CSW201                                       CSW201
     C                   PARM      'SIN'         PMODE                                        CSE045
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL                                        CAP067
      *
      ** OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1            140951
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
     C                   PARM                    SEVTRX2B                                     CSE045
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *
      * F5 - Go To Initial Screen
     C     @INKE         CASEQ     '1'           INITIAL
      *
      * F12 - Cancel on Extension Screen
     C     @INKL         CASEQ     '1'           CANC@E_B
      *                                                                         140951
      * F14 - Return from F14 Ext. Settlements                                  140951
     C     @INKN         CASEQ     '1'           ExtSettB                       140951
      *
      * Validate Input to Extension Screen
     C                   CAS                     VAL@E_B
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DFLT@E_B  - DO DEFAULTING FOR EXTENSION SCREEN B
      *****************************************************************
     C     DFLT@E_B      BEGSR
      *
      ** SWIFT (SCREEN) FIELD DEFAULTING
      *
     C                   CALLB     'SETSWFTDFT'
      *
      ** INPUT PARAMETERS :
      *
      * Screen A/B
     C                   PARM      'B'           Screen            1
      *
      * Trade Details (screen)
      *
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSMTH            2
     C                   PARM                    DDCLTY            1
     C                   PARM                    DDPCOD            1
     C                   PARM                    DDPRYC            1
     C                   PARM                    DDBRCD                                       CSE028
     C                   PARM                    DDBPBK                                       CSE028
     C                   PARM                    DDSETC                                       CSE028
     C                   PARM                    DDMRKT                                       CSE034
      *
      * Trade Details (file)
     C                   PARM                    TDVD
     C                   PARM                    TCNR
     C                   PARM                    DELF
     C                   PARM                    DELT
     C                   PARM                    INVT                                         199797
      *
      * (CSW003) MT5XX - Phase 2 Message Generation
     C                   PARM                    CSW003            1
      *
      ** OUTPUT PARAMETERS :
      *
      * Screen A details
     C                   PARM                    NewTrSwftA
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      *
      * Screen B details
     C                   PARM                    NewTrSwftB
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
 
     C                   MOVEL     DDTDRF        B_##TDRF          6
     C                   MOVEL     DDTDTP        B_##TDTP          2
     C                   MOVEL     DDSMTH        B_##SMTH          2
     C                   MOVEL     DDCLTY        B_##CLTY          1
     C                   MOVEL     DDPCOD        B_##PCOD          1
     C                   MOVEL     DDPRYC        B_##PRYC          1
     C                   MOVEL     DDCNUM        B_##CNUM         10
     C                   MOVEL     DDDELF        B_##DELF         10
     C                   MOVEL     DDDELT        B_##DELT         10
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@E_B - VALIDATE INPUT TO EXTENSION SCREEN B
      *****************************************************************
     C     VAL@E_B       BEGSR
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     DDACTN        IFEQ      'E'
      *
      * If Browse outstanding, read next Browse Subfile record
      * Else, Go To Initial screen
      *
     C     BGWDPR        IFEQ      'Y'                                          174876
     C                   MOVEL     'W'           @SCRN                          174876
     C                   ELSE                                                   174876
   ??C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *                                                                         CSE006
      *** If the book is not a buy-sell book then no new processing is          CSE006
      *** required, otherwise both sides of trade must be entered.              CSE006
      *                                                                         CSE006
     C                   IF        CSE006 = 'Y'                                 CSE006
      *                                                                         CSE006
     C                   CALLB     'AOBOOKR0'                                   CSE006
     C                   PARM      *BLANKS       @RTCD             7            CSE006
     C                   PARM      '*KEY   '     @OPTN             7            CSE006
     C                   PARM      DDBPBK        @BOOK             2            CSE006
     C     SDBOOK        PARM      SDBOOK        DSFDY                          CSE006
      *                                                                         CSE006
     C                   IF        BDBYSL = 'Y' AND                             CSE006
     C                             COUNT < 1                                    CSE006
     C                   EVAL      BySlBk_AEC = *ON                             CSE006
     C                   EVAL      FldNameArr(1) = '*ANY'                       CSE006
     C                   EVAL      MsgIdArr(1) = 'MMM0023'                      CSE006
     C                   ADD       1             COUNT                          CSE006
     C                   EVAL      WWACTN = DDACTN                              CSE006
     C                   EVAL      WWTDRF = DDLKRF                              CSE006
      *                                                                         CSE006
      *** Using the same action code, use the link reference from the           CSE006
      *** previous record as the new trade reference.                           CSE006
      *                                                                         CSE006
     C                   EXSR      INITIAL                                      CSE006
     C                   EVAL      DDACTN = WWACTN                              CSE006
     C                   EVAL      DDTDRF = WWTDRF                              CSE006
     C                   ELSE                                                   CSE006
     C                   Z-ADD     0             COUNT                          CSE006
     C                   EXSR      INITIAL
     C                   ENDIF                                                  CSE006
     C                   ELSE                                                   CSE006
     C                   EXSR      INITIAL                                      CSE006
     C                   ENDIF                                                  CSE006
     C                   END
     C                   ENDIF                                                  174876
      *
     C                   GOTO      EndVAL@E_B
     C                   END
      *
      *----------------------------------------------------------------
      * IF AUTHORIZE / APPROVE
      *
     C     DDACTN        IFEQ      'Y'
     C     DDACTN        OREQ      'P'
      *
      ** If windows processing on, call window routine else                     174876
      * Go to updates
      *
     C     BGWDPR        IFEQ      'Y'                                          174876
     C                   MOVEL     'W'           @SCRN                          174876
     C                   ELSE                                                   174876
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                  174876
      *
     C                   GOTO      EndVAL@E_B
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND / CHANGE
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'C'
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx_EVALB        3 0
     C                   MOVE      *ALL'Y'       OKTrSwft
      *
      * Validate Extension Screen
      *
     C                   CALLB     'SETRADEVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** INPUTS
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Screen (A or B)
     C                   PARM      'B'           Screen            1
      *
      ** Trade Primary Details
      ** Trade Secondary Details
      ** Trade Exchange Rates
      ** Trade Settlement Details
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
      *
      ** Trade Extension File details
     C                   PARM                    NewTrSwftB
      * Custom Extra Data file data                                             CAP004
     C                   PARM                    ExtData                        CAP004
      *
      ** Previous inds
     C                   PARM                    @BDDGMES
     C                   PARM                    @BDDGMEC
     C                   PARM                    @BDDCCID
     C                   PARM                    CB_T1CONG
      *
      ** Processing type
     C                   PARM                    PROT              1
      *
      ** Override errors
     C                   PARM                    OVRErrors         1
      *
      ** Valid Trade layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
      * Swift 2001 flag                                                                       CSW201
     C                   PARM                    CSW201                                       CSW201
      *                                                                                       201233
      ** Destination of settlement                                                            201233
     C                   PARM                    B_DDROTS                                     201233
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM                    PUYAT                                        201429
                                                                                              210517
      ** Tradsdx2 data                                                                        210517
                                                                                              210517
     C                   PARM      *BLANKS       PTradeX2                                     210517
      *
      ** OUTPUTS
      *
      * OK Flags
     C                   PARM                    OKTrSwft
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
     C                   PARM                    WIdx_EVALB
      *
      * Valid Trade layout (DS) (Extension file) from/to caller
     C                   PARM                    NT1BFilFmt
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@E_B
     C                   END
      *
      * If the screen has changed in the course of the validation
      * or if there are warnings which have not been displayed
      *   re-output the screen
      *
     C     NewTrSwftB    IFNE      PrvTrSwft
     C     WIdx_EVALB    ORNE      PrvN_Warn
     C     PUYAT         OREQ      'N'                                                        201429
     C     PUYAT         IFEQ      'N'                                                        201429
     C                   EVAL      PUYAT = 'Y'                                                201429
     C                   ENDIF                                                                201429
     C                   GOTO      EndVAL@E_B
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** If windows processing on, call window routine else                     174876
      * Go to updates
      *
     C     BGWDPR        IFEQ      'Y'                                          174876
     C                   MOVEL     'W'           @SCRN                          174876
     C                   ELSE                                                   174876
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                  174876
      *
     C                   END
      *----------------------------------------------------------------
      *
     C     EndVAL@E_B    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH TRADES FILE
      *****************************************************************
     C     ROLL          BEGSR
      *
      * Default action code to enquiry if not valid
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'C'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'Y'
     C     DDACTN        ANDNE     'P'
     C                   MOVE      'E'           DDACTN
     C                   END
      *
      * READ NEXT OR PREVIOUS RECORD ON TRADES FILE
      * ACCORDING TO COMMAND KEY TAKEN (F7{=INKG} OR F8)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   END
      *
     C                   CALLB     'SETRADRED'
      *
      * INPUT PARAMETERS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *                                                                         CSE019
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CSE019
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CSE019
      *                                                                         CSE019
     C                   PARM      '      '      @@MODE            6            CSE019
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * TRADE REF. POINTER
     C                   PARM                    DDTDRF            6
      *                                                                         CSE019
      * Front Office ID                                                         CSE019
     C                   PARM                    DDFRTN           20            CSE019
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      * TRADE REF. READ
     C                   PARM      *BLANK        @TRRED            6
      *                                                                         CSE019
      * Front Office ID READ                                                    CSE019
     C                   PARM      *BLANK        @FTRED           20            CSE019
      *
      * If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EROLL
     C                   END
      *
      * If TRADE read
      *
     C     @TRRED        IFNE      *BLANK
      *
      * Retrieve TRADE details
      *
     C                   MOVEL     @TRRED        DDTDRF
     C                   EXSR      RTVTRD
      *
      * Convert Trade
     C                   EXSR      CVTTRD
     C                   MOVEL     CrTrFilFmt    NwTrFilFmt
     C                   MOVEL     CT1AFilFmt    NT1AFilFmt
     C                   MOVEL     CT1BFilFmt    NT1BFilFmt
      *
      * Put the trade on the SECONDARY screen if valid
      * else put it on the PRIMARY screen
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C                   MOVEL     'P'           @SCRN
     C                   END
      *
     C                   ENDIF
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      * Reset Read next browse subfile record
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * Build Browse subfile
     C                   CALLB     'SETRADBRW'
      *
      * INPUT PARAMETERS :
      * Return Code
      * Action Code
      * Trade Ref. Pointer
      * Build subfile
      * Read subfile record
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDRF            6
     C                   PARM      'Y'           @BDSFL            1
     C                   PARM      *BLANK        @RDSFL            1
      *
      * OUTPUT PARAMETERS :
      * Error message
      * Option Selected
      * Trade Reference Selected
      * Command Keys
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @OPSEL            1
     C                   PARM      *BLANK        @TRSEL            6
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      * If F3 taken in browse, End Program
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EndBLDBRW
     C                   END
      *
      * If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EndBLDBRW
     C                   END
      *
      * If F12 not taken in browse
      * Read next browse subfile record
      *
     C     @INKL         IFNE      '1'
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
     C                   GOTO      EndBLDBRW
     C                   END
      *
     C     EndBLDBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * Read Next Subfile Record
      *
     C                   CALLB     'SETRADBRW'
      * INPUT PARAMETERS :
      * Return code
      * Action code
      * Trade Ref. pointer
      * Build Sub-file
      * Read Sub-file record
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDRF            6
     C                   PARM      *BLANK        @BDSFL            1
     C                   PARM      'Y'           @RDSFL            1
      * OUTPUT PARAMETERS :
      * Error Message
      * Option Selected
      * Trade Ref. selected
      * Function keys
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @OPSEL            1
     C                   PARM      *BLANK        @TRSEL            6
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      * If Trade read from subfile
     C     @TRSEL        IFNE      *BLANK
      *
      * Retrieve Trade details
      *
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     @TRSEL        DDTDRF
     C                   EXSR      RTVTRD
      *
      * Convert Trade
     C                   EXSR      CVTTRD
     C                   MOVEL     CrTrFilFmt    NwTrFilFmt
     C                   MOVEL     CT1AFilFmt    NT1AFilFmt
     C                   MOVEL     CT1BFilFmt    NT1BFilFmt
      *
      * Put the trade on the SECONDARY screen if valid
      * else put it on the PRIMARY screen
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C                   MOVEL     'P'           @SCRN
     C                   END
      *
      * Else, go to initial screen
      *
     C                   ELSE
     C                   EXSR      INITIAL
     C                   END
      *
     C     EndRDNBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVTRD - RETRIEVE TRADE
      *****************************************************************
     C     RTVTRD        BEGSR
      *
      * RETRIEVE TRADE
      *
     C                   CALLB     'SETRADRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      '      '      @@MODE            6
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      * Action Code
     C                   PARM                    DDACTN
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * (Midas) Trade Reference
     C                   PARM                    DDTDRF
      * MT5XX - Phase 2 Message Generation is on.                               154562
     C                   PARM                    CSW003                         154562
      *                                                                                       CAP067
      * Buy-sell back                                                                         CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      * Trade Reference                                                                       CAP067
     C                   PARM                    PFTDRF            6                          CAP067
      * OUTPUTS :
      * (Current) TRADE in file format
     C                   PARM                    CrTrFilFmt
     C                   PARM                    CT1AFilFmt
     C                   PARM                    CT1BFilFmt
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      * OK - Trade Reference
     C                   PARM      *BLANK        DDTDRFOK
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *                                                                                       193462
      **   Move book from file to work field for later checking.                              193462
      *                                                                                       193462
     C                   MOVE      C_TDBK        OLDBK1            2                          193462
     C                   MOVE      *BLANK        WARNIND           1                          193462
      *
     C/COPY WNCPYSRC,SETRADSC25
     C     EndRTVTRD     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTTRD - PUT A TRADE ON THE SECONDARY SCREEN
      *****************************************************************
     C     CVTTRD        BEGSR
      *
      * Call program to fill screen fields with data from TRADSD
      *
     C                   CALLB     'SETRADCVT'
      *
      * INPUTS :
      * Return Code
      * TRADE in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrTrFilFmt
     C                   PARM                    CT1AFilFmt
     C                   PARM                    CT1BFilFmt
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
                                                                                              CAS006
     C                   PARM                    CAS006                                       CAS006
      *                                                                                       CGL031
      ** CGL031 Switchable Feature                                                            CGL031
     C                   PARM                    CGL031                                       CGL031
      * OUTPUTS
      * Trade - screen formats
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrThir                                    CAS006
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrChCm
     C                   PARM                    NewTrSwftA
     C                   PARM                    NewTrSwftB
 
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
 
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
 
      ** Settlement Currency Details
     C                   PARM                    SetCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      * Trade Status
      * Trade Authorized/Not Authorized
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14
      * Security report name
      * Customer report name
     C**********         PARM                    DDSRPN           20                          CSE016
     C                   PARM                    DDSRNME                                      CSE016
     C                   PARM                    DDCRNM           20
      * Coupon Rate
      * Current Factor
      * Margin Amount
      * Portfolio Exchange Rate
      * Portfolio M/D Ind
      * Trade Countervalue
      * Withholding Tax                                                         CSE023
      * Net Treasury Price                                                                    CAS006
     C                   PARM                    DDCPNR           13
     C                   PARM                    DDCFCT           12
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    DDTCTR           21
     C                   PARM                    DDWTAX                         CSE023
     C                   PARM                    DDPRICN                                      CAS006
      * SCREEN A
      * Destination of Settlement
      * Destination of Confirmation
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      * SCREEN B
      * Destination of Settlement
      * Destination of Confirmation
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
     C                   PARM                    DDFRNT                                    AR698195B
      *
      * Update 'Current' TRADE with TRADE in Screen Format
      *
     C                   MOVEL     NewTrPrim     CurTrPrim
     C                   MOVEL     NewTrSeco     CurTrSeco
     C                   MOVEL     NewTrThir     CurTrThir                                    CAS006
     C                   MOVEL     NewTrExch     CurTrExch
     C                   MOVEL     NewTrSett     CurTrSett
     C                   MOVEL     NewTrChcm     CurTrChcm
     C                   MOVEL     NewTrSwftA    CurTrSwftA
     C                   MOVEL     NewTrSwftB    CurTrSwftB
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFDS@P - SET FIELD STATUS ON PRIMARY SCREEN
      *****************************************************************
     C     SFDS@P        BEGSR
      *
      * Enable/disable fields on primary screen
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'C'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKS@S - SET FUNCTION KEY STATUS ON SECONDARY SCREEN
      *****************************************************************
     C     SFKS@S        BEGSR
      *
      * Enable/disable function keys
      *
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      *
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      * KP = COMMAND KEY 15 = BROWSE
      *
     C                   MOVEL     'Y'           @EINKP
      *                                                                                       CSE028
      * If from PGM SE0190, disable function keys                                             CSE028
      *                                                                                       CSE028
     C     @FRPGM        IFEQ      'Y'                                                        CSE028
     C                   MOVE      'N'           @EINKG                                       CSE028
     C                   MOVE      'N'           @EINKH                                       CSE028
     C                   MOVE      'N'           @EINKP                                       CSE028
     C                   ENDIF                                                                CSE028
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFDS@P - INITIALIZE FIELD STATUS ON PRIMARY SCREEN
      *****************************************************************
     C     IFDS@P        BEGSR
      *
      * ENABLE KEY FIELDS ON PRIMARY SCREEN
      *
     C                   MOVEL     'Y'           @EDTFD
     C                   MOVEL     'Y'           @EKYFD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@P - SEND A MESSAGE TO PRIMARY DETAILS SCREEN
      *****************************************************************
     C     SNDM@P        BEGSR
      *
      * If single branching, user can't browse file
      *
     C     @ERRMS        IFEQ      'FXM0292'
     C                   MOVE      'N'           DDACTNOK
     C                   END
      *
      ** Trade reference on screen must be blank or numeric for pointer
      *
     C     @ERRMS        IFEQ      'MMM0162'
     C                   MOVE      'N'           DDTDRFOK
     C                   END
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C     EndSNDM@P     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@P - CANCEL ON PRIMARY DETAILS SCREEN
      *****************************************************************
     C     CANC@P        BEGSR
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
      *
      * If input fields are enabled
      * Blank the screens
      *
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C                   MOVEL     *BLANK        NewTrPrim
     C                   MOVEL     *BLANK        NewTrSeco
     C                   MOVEL     *BLANK        NewTrThir                                    CAS006
     C                   MOVEL     *BLANK        NewTrExch
     C                   MOVEL     *BLANK        NewTrSett
     C                   MOVEL     *BLANK        NewTrChcm
     C                   MOVEL     *BLANK        NewTrSwftA
     C                   MOVEL     *BLANK        NewTrSwftB
     C                   MOVEL     *BLANK        DDSTAT
     C                   MOVEL     *BLANK        DDAUTH
     C**********         MOVEL     *BLANK        DDSRPN                                       CSE016
     C                   MOVEL     *BLANK        DDSRNME                                      CSE016
     C                   MOVEL     *BLANK        DDCRNM
     C                   MOVEL     *BLANK        DDCFCT
     C                   MOVEL     *BLANK        DDCPNR
     C                   MOVEL     *BLANK        DDMAMT
     C                   MOVEL     *BLANK        DDSPXR
     C                   MOVEL     *BLANK        DDSPMD
     C                   MOVEL     *BLANK        DDTCTR
     C                   END
      *
      * Initialize field status on Primary Screen
      *
     C                   EXSR      IFDS@P
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SECONDARY SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * Return to Primary Screen
      *
     C                   MOVEL     'P'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  CANC@T - Cancel on third screen                              *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     CANC@T        BEGSR                                                                CAS006
                                                                                              CAS006
      ** Return to second screen                                                              CAS006
                                                                                              CAS006
     C                   MOVEL     'S'           @SCRN                                        CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************
      * CANC@O - CANCEL ON OTHER DETAILS SCREEN
      *****************************************************************
     C     CANC@O        BEGSR
      *
      * Return to Secondary Screen
      *
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   MOVEL     'H'           @SCRN                                        CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVEL     'S'           @SCRN
     C                   ENDIF                                                                CAS006
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@E_A - CANCEL ON EXTENSION SCREEN A
      *****************************************************************
     C     CANC@E_A      BEGSR
      *
      * Return to Other Details Screen
      *
     C                   MOVEL     'O'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@E_B - CANCEL ON EXTENSION SCREEN B
      *****************************************************************
     C     CANC@E_B      BEGSR
      *
      * Return to Other Details Screen
      *
     C                   MOVEL     'A'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    140951
      *****************************************************************         140951
      * ExtSettA - Return from Ext. Settlements Screen                          140951
      *****************************************************************         140951
     C     ExtSettA      BEGSR                                                  140951
      *                                                                         140951
      * Return to SWIFT Details Screen A                                        140951
      *                                                                         140951
     C                   MOVEL     'A'           @SCRN                          140951
      *                                                                         140951
     C                   ENDSR                                                  140951
      *****************************************************************         140951
      /EJECT                                                                    140951
      *****************************************************************         140951
      * ExtSettB - Return from Ext. Settlements Screen                          140951
      *****************************************************************         140951
     C     ExtSettB      BEGSR                                                  140951
      *                                                                         140951
      * Return to SWIFT Details Screen B                                        140951
      *                                                                         140951
     C                   MOVEL     'B'           @SCRN                          140951
      *                                                                         140951
     C                   ENDSR                                                  140951
      *****************************************************************         140951
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
      * IF TRADE REFERENCE NOT DEFINED (ON INSERT),
      * GET NEXT AVAILABLE TRADE REFERENCE
      *
      *                                                                         CSE006
      *** Intialise indicators for Buy-Sell book for action codes               CSE006
      *                                                                         CSE006
     C                   EVAL      BySlBK_AEC = *OFF                            CSE006
     C                   EVAL      BySlBK_DPY = *OFF                            CSE006
      *                                                                         CSE006
      *** If the book is not a buy-sell book then no new processing is          CSE006
      *** required, otherwise both sides of trade must be entered.              CSE006
      *                                                                         CSE006
     C                   IF        CSE006 = 'Y'                                 CSE006
      *                                                                         CSE006
     C                   CALLB     'AOBOOKR0'                                   CSE006
     C                   PARM      *BLANKS       @RTCD             7            CSE006
     C                   PARM      '*KEY   '     @OPTN             7            CSE006
     C                   PARM      DDBPBK        @BOOK             2            CSE006
     C     SDBOOK        PARM      SDBOOK        DSFDY                          CSE006
      *                                                                         CSE006
     C                   IF        BDBYSL = 'Y'                                 CSE006
     C                   SELECT                                                 CSE006
     C                   WHEN      DDACTN = 'A' OR                              CSE006
     C                             DDACTN = 'E' OR                              CSE006
     C                             DDACTN = 'C'                                 CSE006
     C                   EVAL      BySlBk_AEC = *ON                             CSE006
     C                   WHEN      DDACTN = 'D' OR                              CSE006
     C                             DDACTN = 'P' OR                              CSE006
     C                             DDACTN = 'Y'                                 CSE006
     C                   EVAL      BySlBk_DPY= *ON                              CSE006
     C                   ENDSL                                                  CSE006
     C                   ENDIF                                                  CSE006
      *                                                                         CSE006
     C                   ENDIF                                                  CSE006
      *                                                                         CSE006
     C     DDTDRF        IFEQ      *BLANK
      *
     C                   CALLB     'ZATRNRTV'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      'SE'          MODU              2
     C                   PARM      'T'           TRTY              1
     C                   PARM                    DDTDRF
     C                   PARM      *ZERO         TDRF
      *
      * DATABASE ERROR
      *
     C     RetCodeOut    IFNE      *BLANK
     C                   MOVEL     'ZATRNRTV'    DBFILE
     C                   MOVEL     '100'         DBASE
     C                   MOVEL     DDTDRF        DBKEY
     C                   EXSR      *PSSR
     C                   END
 
     C                   MOVEL     DDTDRF        @SITR
 
     C                   END
      *
      * UPDATE VALID TRADE: TRADE REFERENCE
      *
     C                   MOVEL     DDTDRF        @SITR                                        199797
     C                   MOVEL     DDTDRF        TDRF
      *
      * UPDATE VALID TRADE: CHANGE TYPE
      *
     C                   MOVEL     DDACTN        CHTP
      *                                                                         CSE006
      *** Move trade ref and link ref into temp fields for Buy-Sell Books       CSE006
      *                                                                         CSE006
     C                   IF        CSE006 = 'Y' AND                             CSE006
     C                             BDBYSL = 'Y'                                 CSE006
     C                   EVAL      WWACTN = DDACTN                              CSE006
     C                   EVAL      WWTDRF = DDLKRF                              CSE006
     C                   ENDIF                                                  CSE006
      *
      * TRADES UPDATES
      *
     C                   CALLB     'SETRADUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    NwTrFilFmt
     C                   PARM                    NT1AFilFmt
     C                   PARM                    NT1BFilFmt
     C                   PARM                    S01401
     C                   PARM                    CSW003                         154562
     C                   PARM                    CAP051                         CAP051
     C                   PARM                    CAS006                                       CAS006
      ** CGL031 Switchable Feature                                                            CGL031
     C                   PARM                    CGL031                                       CGL031
     C                   PARM      'SIN'         PMODE                                        210517
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
     C                   PARM                    SEVTRX2A                                     CSE045
     C                   PARM                    SEVTRX2B                                     CSE045
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'                                    CAP006
     C                   IF        (CSC022 <> 'Y')                                            CSC022
     C                             OR (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   ROLBK
     C                   ENDIF                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   END
      *
     C** If update not done due to record being updated by another              CAP006
     C** workstation send message to screen.                                    CAP006
     C                                                                          CAP006
     C     @RTCD         IFEQ      '*RECUPD'                                    CAP006
     C                                                                          CAP006
     C                   MOVEL     '*ANY'        FldNameArr(1)                  CAP006
     C                   MOVEL     'MMM1067'     MsgIdArr(1)                    CAP006
     C                                                                          CAP006
     C                   END                                                    CAP006
      *                                                                         CSE006
      *** Further check (before read of more records) and msg warning           CSE006
      *** for Buy-sell book trades                                              CSE006
      *                                                                         CSE006
     C                   IF        CSE006 = 'Y' AND BDBYSL = 'Y'                CSE006
     C     COUNT         IFGE      1                                            CSE006
     C                   Z-ADD     0             COUNT                          CSE006
     C                   EXSR      INITIAL                                      CSE006
     C                   GOTO      EndUPDATS                                    CSE006
     C                   ENDIF                                                  CSE006
      *                                                                         CSE006
     C                   SELECT                                                 CSE006
     C                   WHEN      DDACTN = 'A' OR                              CSE006
     C                             DDACTN = 'E' OR                              CSE006
     C                             DDACTN = 'C' AND                             CSE006
     C                             BySlBk_AEC = *ON                             CSE006
     C                   EVAL      FldNameArr(1) = '*ANY'                       CSE006
     C                   EVAL      MsgIdArr(1) = 'MMM0023'                      CSE006
     C                   ADD       1             COUNT                          CSE006
      *                                                                         CSE006
      *** Using the same action code, use the link reference from the           CSE006
      *** previous record as the new trade reference.                           CSE006
      *                                                                         CSE006
     C                   EXSR      INITIAL                                      CSE006
     C                   EVAL      DDACTN = WWACTN                              CSE006
     C                   EVAL      DDTDRF = WWTDRF                              CSE006
     C                   GOTO      EndUPDATS                                    CSE006
      *                                                                         CSE006
     C                   WHEN      DDACTN = 'D' OR                              CSE006
     C                             DDACTN = 'P' OR                              CSE006
     C                             DDACTN = 'Y' AND                             CSE006
     C                             BySlBk_DPY = *ON                             CSE006
     C                   EVAL      FldNameArr(1) = '*ANY'                       CSE006
     C                   EVAL      MsgIdArr(1) = 'MMM0024'                      CSE006
      *                                                                         CSE006
     C                   EXSR      INITIAL                                      CSE006
     C                   EVAL      DDACTN = WWACTN                              CSE006
     C                   EVAL      DDTDRF = WWTDRF                              CSE006
      *                                                                         CSE006
     C                   EXSR      RTVTRD                                       CSE006
     C                   EXSR      CVTTRD                                       CSE006
     C                   MOVEL     CrTrFilFmt    NwTrFilFmt                     CSE006
     C                   MOVEL     CT1AFilFmt    NT1AFilFmt                     CSE006
     C                   MOVEL     CT1BFilFmt    NT1BFilFmt                     CSE006
      *                                                                         CSE006
      * Update valid trade: Trade Reference                                     CSE006
      *                                                                         CSE006
     C                   MOVEL     DDTDRF        TDRF                           CSE006
      *                                                                         CSE006
      * Update Valid Trade: Change Type                                         CSE006
      *                                                                         CSE006
     C                   MOVEL     DDACTN        CHTP                           CSE006
      *                                                                         CSE006
      * Update the second part of the linked Buy-sell trade                     CSE006
      *                                                                         CSE006
     C                   CALLB     'SETRADUPD'                                  CSE006
     C                   PARM      *BLANKS       @RTCD                          CSE006
     C                   PARM                    NwTrFilFmt                     CSE006
     C                   PARM                    NT1AFilFmt                     CSE006
     C                   PARM                    NT1BFilFmt                     CSE006
     C                   PARM                    S01401                         CSE006
     C                   PARM                    CSW003                         CSE006
     C                   PARM                    CAP051                                       CSD015
     C                   PARM                    CAS006                                       CAS006
     C                   PARM                    CGL031                                       235844
     C                   PARM      'SIN'         PMODE                                        216338
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
     C                   PARM                    SEVTRX2A                                     CSE045
     C                   PARM                    SEVTRX2B                                     CSE045
      *                                                                         CSE006
      * If there were any errors in the update functions, rollback any          CSE006
      * updats and end this program. Otherwise comit the updates.               CSE006
      *                                                                         CSE006
     C     @RTCD         IFNE      *BLANK                                       CSE006
     C     @RTCD         ANDNE     '*RECUPD'                                    CSE006
     C                   IF        (CSC022 <> 'Y')                                            CSC022
     C                             OR (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   ROLBK                                                  CSE006
     C                   ENDIF                                                                CSC022
     C                   EXSR      *PSSR                                        CSE006
     C                   ELSE                                                   CSE006
     C                   IF        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT                                                 CSE006
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                  CSE006
      *                                                                         CSE006
     C                   ENDSL                                                  CSE006
      *                                                                         CSE006
     C                   ENDIF                                                  CSE006
      *                                                                         CSE006
     C                                                                          CAP006
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
                                                                                              CSE028
      ** ELSE, EXIT IF FROM LINK PROCESSING                                                   CSE028
                                                                                              CSE028
     C                   IF        @FRPGM = 'Y'                                               CSE028
     C                   EXSR      ENDP                                                       CSE028
     C                   ELSE                                                                 CSE028
      *
      * ELSE, GO TO INITIAL SCREEN
      *
     C                   EXSR      INITIAL
     C                   ENDIF                                                                CSE028
      *                                                                                       CSE028
     C                   END
      *
     C**********         ENDSR                                                  CSE006
     C     EndUPDATS     ENDSR                                                  CSE006
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End Program
      *****************************************************************
     C     ENDP          BEGSR
      *                                                                                       209867
      **Issue rollback to clear any possible updates in window function                       209867
      *                                                                                       209867
     C     BGWDPR        IFEQ      'Y'                                                        209867
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK                                                                209867
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   END                                                                  209867
      *
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
      *
      * Blank the screens
      *
     C                   MOVEL     DDACTN        W#ACTN            1                          210962
     C                   MOVEL     *BLANK        NewTrPrim
     C                   MOVEL     W#ACTN        DDACTN                                       210962
     C                   MOVEL     *BLANK        NewTrSeco
     C                   MOVEL     *BLANK        NewTrThir                                    CAS006
     C                   MOVEL     *BLANK        NewTrExch
     C                   MOVEL     *BLANK        NewTrSett
     C                   MOVEL     *BLANK        NewTrChcm
     C                   MOVEL     *BLANK        NewTrSwftA
     C                   MOVEL     *BLANK        NewTrSwftB
     C                   MOVEL     *BLANK        DDSTAT
     C                   MOVEL     *BLANK        DDAUTH
     C**********         MOVEL     *BLANK        DDSRPN                                       CSE016
     C                   MOVEL     *BLANK        DDSRNME                                      CSE016
     C                   MOVEL     *BLANK        DDCRNM
     C                   MOVEL     *BLANK        DDCFCT
     C                   MOVEL     *BLANK        DDCPNR
     C                   MOVEL     *BLANK        DDMAMT
     C                   MOVEL     *BLANK        DDSPXR
     C                   MOVEL     *BLANK        DDSPMD
     C                   MOVEL     *BLANK        DDTCTR
      *                                                                                       210962
     C     DDACTN        IFEQ      'E'                                                        210962
     C                   MOVEL     *BLANK        NewTrPrim                                    210962
     C                   ENDIF                                                                210962
      *
      * Primary Details Screen
      *
     C                   MOVEL     'P'           @SCRN             1
      *
      * Initialize field status on Primary Screen
      *
     C                   EXSR      IFDS@P
      *
      *                                                                                       194229
      **  Reset IN50 before checking if first leg trade.                                      194229
      *                                                                                       194229
     C                   MOVE      'N'           IN50                                         194229
      *                                                                                       194229
     C                   IF        BDBYSL = 'Y' AND                                           194229
     C                             COUNT = 1                                                  194229
      *                                                                                       194229
      **  Field protect Book field on second trade, set up Indicator 50                       194229
      *                                                                                       194229
     C                   EVAL      IN50 = 'Y'                                                 194229
     C                   EVAL      TRDBK1 = @PDDBPBK                                          194229
      *                                                                                       194229
     C                   END                                                                  194229
      *                                                                                       194229
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INTRCAL - FORCE INTEREST RECALCULATION
      *****************************************************************
     C     INTRCAL       BEGSR
      *
      * If any of the following have changed, cause interest recalculation
      * (by blanking out interest amount) - but only if interest hasn't
      * been changed: nominal, value date, accrued indicator, days
      * adjustment, and actual/difference ind.
      *
     C     DDNOML        IFNE      @PDDNOML
     C     DDTDVD        ORNE      @PDDTDVD
     C     DDACIN        ORNE      @PDDACIN
     C     DDDADJ        ORNE      @PDDDADJ
     C     DDACTD        ORNE      @PDDACTD
     C     DDITRA        IFEQ      @PDDITRA
     C                   MOVEL     *BLANK        DDITRA
     C                   END
      *                                                                                       212939
      ** If the value date changed, accrued indicator must be                                 212939
      ** re-defaulted to be accurate.                                                         212939
      *                                                                                       212939
     C     DDTDVD        IFNE      @PDDTDVD                                                   212939
     C                   MOVEL     *BLANK        DDACIN                                       212939
     C                   ENDIF                                                                212939
                                                                                              212939
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PRCRCAL - FORCE (%) PRICE RECALCULATION
      *****************************************************************
     C     PRCRCAL       BEGSR
      *
      * If any of the following have changed, cause price recalculation
      * (by blanking out % price) - but only if price hasn't been
      * changed: nominal, price/discount/yield, value date,
      * accrued indicator, and interest
      *
     C     DDNOML        IFNE      @PDDNOML
     C     DDTPDY        ORNE      @PDDTPDY
     C     DDTDVD        ORNE      @PDDTDVD
     C     DDACIN        ORNE      @PDDACIN
     C     DDITRA        ORNE      @PDDITRA
     C     DDPRIC        IFEQ      @PDDPRIC
     C                   MOVEL     *BLANK        DDPRIC
     C/COPY WNCPYSRC,SETRADSC06
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHCMCAL - CHARGES AND COMMISSIONS CALCULATION
      *****************************************************************
     C     CHCMCAL       BEGSR
 
     C/COPY WNCPYSRC,SETRADSC01
     C                   CALLB     'SETCHCMCAL'
 
      * INPUTS
 
      ** Trade reference
      ** Security
      ** Trade Type
     C                   PARM                    DDTDRF            6
     C                   PARM                    DDSESN           10
     C                   PARM                    DDTDTP            2
      *
      ** Trade Counterparty
      ** Trade Nominal
      ** Trade % price
      ** Trade Date
      ** Trade Purchased Interest
      ** Trade Current Factor
     C                   PARM                    TCNR
     C                   PARM                    NOML             11 0
     C                   PARM                    PRIC             15 8
     C                   PARM                    TDDT              5 0
     C                   PARM                    ITRA             13 0
     C                   PARM                    TCFC             10 9
      *
      ** Security & Investment Type details
     C                   PARM                    SECTY
     C                   PARM                    PROT              1
      *
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      ** Commission Rebate %
     C                   PARM                    CMRP              5 3
      *
      ** Previous Trade Charges & Commissions
     C                   PARM                    PrvTrChCm
      *
      ** Trade Charges & Commissions OK inds
     C                   PARM                    OKTrChCm
      *
      ** ICD
      ** Autocharge Option
      ** Securities Charges Currency
      ** Adjust Commission Same Day T
     C                   PARM                    BVACOP            1
     C                   PARM                    BVCHRC            3
     C                   PARM                    BVACSD            1
     C                   PARM                    S01446            1
 
      * INPUTS & OUTPUTS
 
      ** Trade Charges & commissions screen fields
 
     C                   PARM                    NewTrChCm
 
      ** Trade details
     C                   PARM                    TBCA             13 0
     C                   PARM                    TCCA             13 0
     C                   PARM                    TCA1             13 0
     C                   PARM                    TCA2             13 0
     C                   PARM                    TCA3             13 0
     C                   PARM                    TCA4             13 0
     C                   PARM                    TCA5             13 0
     C                   PARM                    TCA6             13 0
     C                   PARM                    TCA7             13 0
     C                   PARM                    TAXA             13 0
     C                   PARM                    BCMR             13 0
     C                   PARM                    CCMR             13 0
     C                   PARM                    TXRB             13 0
 
     C                   ENDSR
      *****************************************************************                       233881
      /EJECT                                                                                  233881
      *****************************************************************                       233881
      * EUTXCAL - EU TAX CALCULATION                                                          233881
      *****************************************************************                       233881
     C     EUTXCAL       BEGSR                                                                233881
                                                                                              233881
     C                   IF        DDPTFR <> *BLANKS AND PTFR = *BLANKS                       234440
     C                   EVAL      PTFR = DDPTFR                                              234440
     C                   END                                                                  234440
                                                                                              234440
      ** CALCULATE EU TAX                                                                     233881
                                                                                              233881
     C                   CALLB     'SEVTRADTAX'                                               233881
                                                                                              233881
      * INPUTS                                                                                233881
                                                                                              233881
      * Response Mode                                                                         233881
     C                   PARM                    RespMode                                     233881
      * Valid Trade Details                                                                   233881
     C                   PARM                    NwTrFilFmt                                   233881
      * Security Details                                                                      233881
     C                   PARM                    SECTY                                        233881
      * Process Flag                                                                          233881
     C                   PARM      'E'           ProcFlag          1                          233881
                                                                                              233881
      * OUTPUTS                                                                               233881
                                                                                              233881
      * EU Tax Screen Format                                                                  233881
      * EU Tax in Nominal Currency File Format                                                233881
      * EU Tax in Settlement Currency File Format                                             233881
     C                   PARM                    DDEUTX                                       233881
     C                   PARM                    EUTX                                         233881
     C                   PARM                    EUTS                                         233881
                                                                                              233881
     C                   ENDSR                                                                233881
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVALCAL - COUNTERVALUE CALCULATION
      *****************************************************************
     C     CVALCAL       BEGSR
 
     C/COPY WNCPYSRC,SETRADSC07
      ** CALCULATE COUNTERVALUE
 
     C                   CALLB     'SETCVALCAL'
 
      * INPUTS
 
      ** Trade details
     C                   PARM                    TDTP              2
     C                   PARM                    NOML             11 0
     C                   PARM                    PRIC             15 8
     C                   PARM                    RALL              9 5
     C                   PARM                    ITRA             13 0
     C                   PARM                    TBCA             13 0
     C                   PARM                    TCCA             13 0
     C                   PARM                    TCA1             13 0
     C                   PARM                    TCA2             13 0
     C                   PARM                    TCA3             13 0
     C                   PARM                    TCA4             13 0
     C                   PARM                    TCA5             13 0
     C                   PARM                    TCA6             13 0
     C                   PARM                    TCA7             13 0
     C                   PARM                    TAXA             13 0
     C                   PARM                    TDER             13 8
     C                   PARM                    TMDI              1
     C                   PARM                    SETC              3
     C                   PARM                    TDVD              5 0                        200459
 
      ** Security details
     C                   PARM                    PROT              1
     C                   PARM                    SPBS              1
     C                   PARM                    CFCT             10 9
     C                   PARM                    NMCY              3
     C                   PARM                    NMDP              1 0
     C                   PARM                    SESN             10                          200459
 
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
 
      ** Customer classification
     C                   PARM                    CustClass         1
                                                                                CSE023
      ** Country of treaty from PF/SECTYD                                       CSE023
     C                   PARM                    CRTT                           CSE023
                                                                                CSE023
      ** Default basket for backup withholding                                  CSE023
     C                   PARM                    PDRBW                          CSE023
                                                                                CSE023
      ** Value date                                                             CSE023
     C                   PARM                    TDVD                           CSE023
                                                                                              233881
      ** EU Tax                                                                               233881
     C                   PARM                    EUTX                                         233881
 
      * OUTPUTS
 
      * Trade consideration in nominal currency
      * Trade countervalue in nominal currency
      * Withholding tax                                                         CSE023
      * Trade countervalue in settlement currency in screen format
      * Withholding tax in screen format                                        CSE023
     C                   PARM                    TCSR             15 0
     C                   PARM                    TCTR             15 0
     C                   PARM                    WHTX                           CSE023
     C                   PARM                    DDTCTR           21
     C                   PARM                    DDWTAX                         CSE023
 
     C/COPY WNCPYSRC,SETRADSC08
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CUSTRPT - Get the Customer Report Name.                                               189082
      *****************************************************************                       189082
     C     CUSTRPT       BEGSR                                                                189082
                                                                                              189082
     C                   MOVEL     DDCNUM        @CUST1           10                          189082
                                                                                              189082
     C                   CALLB     'AOCUSTR0'                                                 189082
     C                   PARM      *BLANKS       @RTCD                                        189082
     C                   PARM      '*KEY   '     @OPTN                                        189082
     C                   PARM                    @CUST1                                       189082
     C                   PARM      *BLANKS       @KYST             7                          189082
     C     SDCUST        PARM      SDCUST        DSSDY                                        189082
                                                                                              189082
     C     @RTCD         IFEQ      *BLANKS                                                    189082
     C                   MOVEL     BBCRNM        DDCRNM                                       189082
     C                   END                                                                  189082
                                                                                              189082
     C                   ENDSR                                                                189082
      *****************************************************************                       189082
      /EJECT                                                                                  189082
      *****************************************************************                       CSE039
      * DSPMOV  - Show movements for Trade                                                    CSE039
      *****************************************************************                       CSE039
     C     DSPMOV        BEGSR                                                                CSE039
                                                                                              CSE039
     C     DDACTN        IFEQ      'E'                                                        CSE039
     C                   MOVE      'E'           @MODE                                        CSE039
     C                   ENDIF                                                                CSE039
     C     DDACTN        IFEQ      'A'                                                        CSE039
     C     DDACTN        OREQ      'C'                                                        CSE039
     C                   MOVE      'M'           @MODE                                        CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
     C                   CALL      'SEC025'                                                   CSE039
     C                   PARM      'SEMVTSSIN'   @PGM             10                          CSE039
     C                   PARM                    DDTDRF                                       CSE039
     C                   PARM      'T'           @TYPR             1                          CSE039
     C                   PARM                    @MODE             1                          CSE039
     C                   PARM                    @endF3            1                          CSE039
     C                   PARM                    @endF12           1                          CSE039
                                                                                              CSE039
     C     @endF3        IfEq      '1'                                                        CSE039
     C                   SETON                                        LR                      CSE039
     C                   RETURN                                                               CSE039
     C                   ENDIF                                                                CSE039
                                                                                              CSE039
     C                   ENDSR                                                                CSE039
      *****************************************************************                       CSE039
      /EJECT                                                                                  CSE039
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *                                                                                       CSE028
     C     *ENTRY        PLIST                                                                CSE028
     C                   PARM                    ACTCDE            1                          CSE028
     C                   PARM                    TRADRF            6                          CSE028
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADSIN'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
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
     C                   PARM      *BLANKS       @RTCD             7
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
      ** ACCESS SECURITIES TRADING DETAILS
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SAR details file to determine if S01401
      ** (MT5XX Message Generation) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01401'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   MOVEL     'S01401'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01401            1
     C                   ELSE
     C                   MOVEL     'N'           S01401
     C                   END
      *
      ** Access SAR details file to determine if S01446
      ** (Customer commission switchable feature) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01446'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   MOVEL     'S01446'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01446            1
     C                   ELSE
     C                   MOVEL     'N'           S01446
     C                   END
      *
      ** Access SAR details file to determine if S01496
      ** (Private Banking SE enhancements) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01496'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '907'         DBASE
     C                   MOVEL     'S01496'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01496            1
     C                   ELSE
     C                   MOVEL     'N'           S01496
     C                   END
      *
      ** Access SAR details file to determine if CSW003
      ** (MT5XX - Phase 2 message generation) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW003'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '908'         DBASE
     C                   MOVEL     'CSW003'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSW003            1
     C                   ELSE
     C                   MOVEL     'N'           CSW003
     C                   END
      *                                                                         CAP050
      ** Access SAR details file to determine if CAP050                         CAP050
      ** (Midas/ToF Interface) is on.                                           CAP050
      *                                                                         CAP050
     C                   CALLB     'AOSARDR0'                                   CAP050
     C                   PARM      *BLANKS       @RTCD                          CAP050
     C                   PARM      '*VERIFY'     @OPTN                          CAP050
     C                   PARM      'CAP050'      @SARD                          CAP050
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP050
      *                                                                         CAP050
      * Database Error                                                          CAP050
      *                                                                         CAP050
     C     @RTCD         IFNE      *BLANKS                                      CAP050
     C     @RTCD         ANDNE     '*NRF   '                                    CAP050
     C                   MOVEL     'SCSARDPD'    DBFILE                         CAP050
     C                   MOVEL     '909'         DBASE                          CAP050
     C                   MOVEL     'CAP050'      DBKEY                          CAP050
     C                   EXSR      *PSSR                                        CAP050
     C                   END                                                    CAP050
      *                                                                         CAP050
     C     @RTCD         IFEQ      *BLANK                                       CAP050
     C                   MOVEL     'Y'           CAP050            1            CAP050
     C                   ELSE                                                   CAP050
     C                   MOVEL     'N'           CAP050                         CAP050
     C                   END                                                    CAP050
      *                                                                         CAP051
      ** Access SAR details file to determine if CAP051 is on.                  CAP051
      ** (Automatic Authorisation (SE Trades Part))                             CAP051
      *                                                                         CAP051
     C                   CALLB     'AOSARDR0'                                   CAP051
     C                   PARM      *BLANKS       @RTCD                          CAP051
     C                   PARM      '*VERIFY'     @OPTN                          CAP051
     C                   PARM      'CAP051'      @SARD                          CAP051
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
      *                                                                         CAP051
      * Database Error                                                          CAP051
      *                                                                         CAP051
     C     @RTCD         IFNE      *BLANKS                                      CAP051
     C     @RTCD         ANDNE     '*NRF   '                                    CAP051
     C                   MOVEL     'SCSARDPD'    DBFILE                         CAP051
     C                   MOVEL     '911'         DBASE                          CAP051
     C                   MOVEL     'CAP051'      DBKEY                          CAP051
     C                   EXSR      *PSSR                                        CAP051
     C                   END                                                    CAP051
      *                                                                         CAP051
     C     @RTCD         IFEQ      *BLANK                                       CAP051
     C                   MOVEL     'Y'           CAP051            1            CAP051
     C                   ELSE                                                   CAP051
     C                   MOVEL     'N'           CAP051                         CAP051
     C                   END                                                    CAP051
      *
      ** Access SAR details file to determine if CEU005
      ** (EMU SE Settlement Currency Conversion) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '910'         DBASE
     C                   MOVEL     'CEU005'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU005            1
     C                   ELSE
     C                   MOVEL     'N'           CEU005
     C                   END
      *                                                                         CSE006
      ** Access SAR details file to determine if CSE006                         CSE006
      ** (REPOS enhancement switchable feature) is on.                          CSE006
      *                                                                         CSE006
     C                   CALLB     'AOSARDR0'                                   CSE006
     C                   PARM      *BLANKS       @RTCD                          CSE006
     C                   PARM      '*VERIFY'     @OPTN                          CSE006
     C                   PARM      'CSE006'      @SARD             6            CSE006
     C     SCSARD        PARM      SCSARD        DSFDY                          CSE006
      *                                                                         CSE006
      * DATABASE ERROR                                                          CSE006
      *                                                                         CSE006
     C     @RTCD         IFNE      *BLANKS                                      CSE006
     C     @RTCD         ANDNE     '*NRF   '                                    CSE006
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE006
     C                   MOVEL     '911'         DBASE                          CSE006
     C                   MOVEL     'CSE006'      DBKEY                          CSE006
     C                   EXSR      *PSSR                                        CSE006
     C                   ENDIF                                                  CSE006
      *                                                                         CSE006
     C     @RTCD         IFEQ      *BLANK                                       CSE006
     C                   MOVEL     'Y'           CSE006            1            CSE006
     C                   ELSE                                                   CSE006
     C                   MOVEL     'N'           CSE006                         CSE006
     C                   ENDIF                                                  CSE006
      *                                                                         CSE006
     C                   Z-ADD     0             COUNT             2 0          CSE006
                                                                                              CSW201
      ** Check if CSW201 - Swift 2001 Standards Update is installed                           CSW201
                                                                                              CSW201
     C                   CALL      'SWIF2001'                           9090                  CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
                                                                                              CSW201
     C                   IF        *IN90 = *ON                                                CSW201
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSW201
     C                   EVAL      DBASE = 912                                                CSW201
     C                   EVAL      DBKEY = 'CSW201'                                           CSW201
     C                   EXSR      *PSSR                                                      CSW201
                                                                                              CSW201
     C                   ELSE                                                                 CSW201
     C                   IF        @RTCD = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSE028
      ** Check if CSE028 feature is installed                                                 CSE028
      *                                                                                       CSE028
     C                   CALLB     'AOSARDR0'                                                 CSE028
     C                   PARM      *BLANKS       @RTCD                                        CSE028
     C                   PARM      '*VERIFY'     @OPTN                                        CSE028
     C                   PARM      'CSE028'      @SARD                                        CSE028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE028
      *                                                                                       CSE028
      ** DATABASE ERROR                                                                       CSE028
      *                                                                                       CSE028
     C     @RTCD         IFNE      *BLANKS                                                    CSE028
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE028
     C     *LOCK         IN        LDA                                                        CSE028
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE028
     C                   Z-ADD     912           DBASE                                        CSE028
     C                   MOVEL     'CSE028'      DBKEY                                        CSE028
     C                   OUT       LDA                                                        CSE028
     C                   EXSR      *PSSR                                                      CSE028
     C                   ENDIF                                                                CSE028
      *                                                                                       CSE028
     C     @RTCD         IFEQ      *BLANK                                                     CSE028
     C                   MOVEL     'Y'           CSE028            1                          CSE028
     C                   ELSE                                                                 CSE028
     C                   MOVEL     'N'           CSE028                                       CSE028
     C                   ENDIF                                                                CSE028
                                                                                              CAS006
      ** Check if CSE039 feature is installed                                                 CSE039
      *                                                                                       CSE039
     C                   CALLB     'AOSARDR0'                                                 CSE039
     C                   PARM      *BLANKS       @RTCD                                        CSE039
     C                   PARM      '*VERIFY'     @OPTN                                        CSE039
     C                   PARM      'CSE039'      @SARD                                        CSE039
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE039
     C     @RTCD         IFEQ      *BLANK                                                     CSE039
     C                   MOVEL     'Y'           CSE039            1                          CSE039
     C                   ELSE                                                                 CSE039
     C                   MOVEL     'N'           CSE039                                       CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
      ** Check if enhancement CAS006 (Hedge Accounting Phase B) is installed                  CAS006
                                                                                              CAS006
     C                   CALLB     'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRTCD                                        CAS006
     C                   PARM      '*VERIFY'     POPTN                                        CAS006
     C                   PARM      'CAS006'      PSARD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBKEY  = 'CAS006'                                          CAS006
     C                   EVAL      DBASE  = 913                                               CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        PRTCD = *BLANKS                                            CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   ENDIF                                                                CAS006
      *                                                                                       CGL031
      ** Access SAR details file to determine if CGL031                                       CGL031
      ** (Taxation of Savings Income) is on.                                                  CGL031
      *                                                                                       CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRTCD                                        CGL031
     C                   PARM      '*VERIFY'     POPTN                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
     C     PRTCD         IFNE      *BLANKS                                                    CGL031
     C     PRTCD         ANDNE     '*NRF   '                                                  CGL031
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL031
     C                   MOVEL     '914'         DBASE                                        CGL031
     C                   MOVEL     'CGL031'      DBKEY                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
      *                                                                                       CGL031
     C     PRTCD         IFEQ      *BLANK                                                     CGL031
     C                   MOVEL     'Y'           CGL031                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVEL     'N'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
      *
      * GO TO INITIAL SCREEN
      *
     C                   EXSR      INITIAL
      *
     C     ACTCDE        IFNE      *BLANKS                                                    CSE028
     C     TRADRF        ANDNE     *BLANKS                                                    CSE028
     C                   MOVE      ACTCDE        DDACTN                                       CSE028
     C                   MOVE      TRADRF        DDTDRF                                       CSE028
     C                   MOVE      'N'           @EKYFD                                       CSE028
     C                   MOVE      'Y'           @FRPGM                                       CSE028
     C                   ELSE                                                                 CSE028
     C                   MOVE      'N'           @FRPGM                                       CSE028
     C                   ENDIF                                                                CSE028
 
      *                                                                                       CSC022
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       PRTCD                                        CSC022
     C                   Parm      '*VERIFY'     POPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C                   If        PRTCD = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   Eval      WCommitSkip = 'N'                                          CSC022
      *                                                                                       CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
     C                   MoveA     ComitJob      WCmtJobArr                                   CSC022
      *                                                                                       CSC022
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                  CSC022
     C                   If        *IN87 = *ON                                                CSC022
     C                   Eval      WCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** If return code <> *NRF, call program exception error routine                         CSC022
      *                                                                                       CSC022
     C                   If        PRTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 914                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
      ** Check if enhancement CGL014 (Collaterals Processing) is on                          BUG3145
                                                                                             BUG3145
     C                   CALLB     'AOSARDR0'                                                BUG3145
     C                   PARM      *BLANKS       PRTCD                                       BUG3145
     C                   PARM      '*VERIFY'     POPTN                                       BUG3145
     C                   PARM      'CGL014'      PSARD                                       BUG3145
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3145
                                                                                             BUG3145
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                 BUG3145
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3145
     C                   EVAL      DBKEY  = 'CGL014'                                         BUG3145
     C                   EVAL      DBASE  = 912                                              BUG3145
     C                   EXSR      *PSSR                                                     BUG3145
     C                   ENDIF                                                               BUG3145
                                                                                             BUG3145
     C                   IF        PRTCD = *BLANKS                                           BUG3145
     C                   EVAL      CGL014 = 'Y'                                              BUG3145
     C                   ELSE                                                                BUG3145
     C                   EVAL      CGL014 = 'N'                                              BUG3145
     C                   ENDIF                                                               BUG3145
                                                                                             BUG3145
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SETRADS012
 
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
