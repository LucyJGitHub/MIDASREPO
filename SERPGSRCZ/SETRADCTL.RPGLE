     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade interface controller - commit!')        *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADCTL - SE Trades Interface Controller                   *
      *                                                               *
      *  Function: This Program Validates SE Trades for Input into    *
      *            the Midas database.                                *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert)                                  *
      *              - If ALL of the settlement fields are blank, set *
      *                them up from standard settlement instructions  *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the trade fields                      *
      *              - Validate the settlement fields                 *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For X (=Authorise) call a separate function to   *
      *              process this trade and bypass the rest of the    *
      *              validation                                       *
      *            - For D (=Delete) call a separate function to      *
      *              process this trade and bypass the rest of the    *
      *              validation                                       *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 AR698195B          Date 20Jan11               *
      *                 CSW210             Date 04May10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22911           Date 17Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247873             Date 15Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243776A            Date 11Dec06               *
      *                 243776             Date 21Jul06               *
      *                 234858             Date 18Jul05               *
      *                 233881             Date 02Jun05               *
      *                 244115             Date 06Oct06               *
      *                 243119A            Date 15Nov06               *
      *                 243604             Date 17Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206E            Date 24Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 17Aug05               *
      *                 BUG9107            Date 19Jul05               *
      *                 CER001             Date 25Apr05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG2274            Date 19Aug04               *
      *                 BUG3122            Date 17Jul04               *
      *                 BUG3145            Date 15Jun04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CSE045             Date 24Mar03               *
      *                 CSE037             Date 29Apr02               *
      *                 CSE039             Date 21Jan03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210517             Date 21Nov02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 200299             Date 05Jul02               *
      *                 200459             Date 22Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE034             Date 23Apr02               *
      *                 CSE031             Date 13Dec01               *
      *                 CSC011             Date 18Sep01               *
      *                 201429             Date 24Dec01               *
      *                 201233             Date 20Dec01               *
      *                 CAP067             Date 24Sep01               *
      *                 199797             Date 01Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      *                 CSW201             Date 02May01               *
      *                 CSE016             Date 10Jan01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 193462             Date 25May01               *
      *                 CUT009             Date 22Mar01               *
      *                 CPB002             Date 28Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      *                 175216             Date 12Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 16Nov99               *
      *                 CPB001             Date 31Aug99               *
      *                 CAP013             Date 07Sep99               *
      *                 CAP011             Date 07Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 154562             Date 01Feb99               *
      *                 CAP004             Date 07Sep98               *
      *                 CAP002  *CREATE    Date 06OCT97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  AR698195B - Added Front Office field on the buffer for TRADS *
      *             (Child: AR698196)                                 *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247873 - Make sure that DfltTrSwfA is executed during Insert *
      *           mode.                                               *
      *  243776A- Use value date from TRADSD as parameter.            *
      *  243776 - Apply same correction as 235547 to make parameter   *
      *           list match with SETRADSVAL parameter entry list.    *
      *           Apply 233881 and 234858 corrections.                *
      *  234858 - EU Tax amount should be put into valid trade field  *
      *  233881 - EU Tax amount should be subtracted from the         *
      *           Countervalue.                                       *
      *  244115 - To properly set clearance type within invalid file. *
      *  243119A - Safekeeping A/C defaulting problem when trade comes*
      *            from an interface. Additional fixes to do defaults *
      *            when CSE045 is switched off and when CUST# is zero.*
      *  243604  - Access correct branch in AOBRCHR1.                 *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087  - Enable the use of SETRADVU to process Buy/Sell     *
      *            trades.                                            *
      *  BUG9107 - Correct error caused by commitment definition      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation for Savings Income                         *
      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG2274 - Unable to access SSI information because market    *
      *            not being passed in.                               *
      *  BUG3122 - Renamed the field SEZONE in SDSECS data structure  *
      *            to avoid compilation error.                        *
      *  BUG3145 - Charges and Commission are being missed out of the *
      *            calculation of countervalue.                       *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *  CSE037 - Bond Pricing - 3 Decimal Places in Trades Input     *
      *  CSE039 - Auto-settlement of trades.                          *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  210517 - Missing TRADSDX2 record from the API                *
      *  200299 - Recompile due to change in SETRIFPD                 *
      *  200459 - Current factor not applied to countervalue for 'MP' *
      *           Securities.  Add checking to SEDEV for new current  *
      *           factor and if it exists, use it in calculating the  *
      *           countervalue.  Amended to be consistent with SE0050.*
      *  CSE034 - Standard Settlement Instruction improvements        *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSC011 - 24x7 Midas Availability                             *
      *  201429 - New validation needed for ISO15022 in               *
      *           extended settlement screen.                         *
      *  201233 - If message is unroutable, settlement of message     *
      *           request cannot be a 'Y'.                            *
      *  CAP067 - Repurchase Agreements API.                          *
      *  199797 - Additional changes and fixes for CSE028 (SSIs).     *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  CSE016 - Extended Security Descriptions                      *
      *  193462 - Protect Book code if Buy/sell indicator = 'Y'       *
      *  CUT009 - Core hooks added manually.                          *
      *  CPB002 - Counterparty for trades coming from Tof can be the  *
      *           internal customer number (Book transfer)            *
      *           In this case the PB Order Number is setted in Tof   *
      *           Add this parameter when calling SETRADPVAL to give  *
      *           the value to SEVTCUST                               *
      *  CSE023 - Treaty Withholding Tax.                             *
      *  175216 - Add additional field for "Standing Instructions     *
      *           Override" missed at SWIFT 98 change.                *
      *           Correct core problem relating to rename REPI.       *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *         - 'Private Banking' Module                            *
      *           /COPY SE_CUSTDT changed                             *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  154562 - Only 1 record is needed on TRADSDX1 if CSW003 is off*
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      * Valid Trades
     FSEVTRADPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Valid Trades - Extension file
     FSEVTRX1PD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Valid Trades - Extension file                                                         CSE045
     FSEVTRX2PD UF A E             DISK    INFSR(*pssr)                                       CSE045
     F                                     PREFIX(V_)                                         CSE045
     F                                     COMMIT                                             CSE045
      * Trades Extended Settlements                                                           CSE045
     F***TRADSDY2  IF   E           K DISK    COMMIT                                  CSE045 BUG9107
     FTRADSDY2  IF   E           K DISK    INFSR(*pssr)                                      BUG9107
      * Invalid Trades
     FSEITRADPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FSEVTRADL0 IF   E           K DISK    RENAME(SEVTRADD0:SEVTRADCHK)
     F                                     INFSR(*pssr)                         CAP013
     FSEVTRADL1 IF   E           K DISK    RENAME(SEVTRADD0:SEVTRADCK1)         CAP013
     F                                     INFSR(*pssr)                         CAP013
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      * Trade Extension File 3                                                                CSE039
     FTRADSDX3  UF A E             DISK    INFSR(*pssr)                                       CSE039
     F                                     COMMIT                                             CSE039
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SETRADC016
                                                                                              CER001
      *                                                                                       CER001
      ** Midas SE TRAD - Valid File                                                           CER001
      *                                                                                       CER001
     FSEVTDLX1PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
      *                                                                                       CER001
      ** Midas SE TRAD - Invalid File                                                         CER001
      *                                                                                       CER001
     FSEITDLX1PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
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
 
      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
                                                                                              CSC022
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022
 
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(SETRPRPD)
     D TranInSeco    E DS                  EXTNAME(SETRSEPD)
     D TranInThir    E DS                  EXTNAME(SETRTHPD)                                  CAS006
     D TranInExch    E DS                  EXTNAME(SETREXPD)
     D TranInSett    E DS                  EXTNAME(SETRSTPD)
     D DDCLTY2       E                     EXTFLD(DDCLTY)
     D TranInChCm    E DS                  EXTNAME(SETRCCPD)
     D TranInSwfA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(A)
     D TranInSwfB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(B)
     D TranInSwfI    E DS                  EXTNAME(SETRSWPD)                                  247873
     D                                     PREFIX(I)                                          247873
     D TranInSwfO    E DS                  EXTNAME(SETRSWPD)                                  247873
     D                                     PREFIX(O)                                          247873
 
      *                                                                                       CSE045
      ** Securities retrieved from file - file format                                         CSE045
     D CrSEFilFmt    E DS                  EXTNAME(TRADSDX2)                                  CSE045
                                                                                              CSE045
     D***OthDdata        DS          3116                                             CSE045 CSF011A
     D***TranInExt1             1   1558                                              CSE045 CSF011A
     D***TranInExt2          1559   3116                                              CSE045 CSF011A
     D OthDdata        DS          4878                                                      CSF011A
     D  TranInExt1             1   2439                                                      CSF011A
     D  TranInExt2          2440   4878                                                      CSF011A
      *                                                                                       CSE045
     D  TranInExtA   E DS                  EXTNAME(SETESDPD)                                  CSE045
     D                                     PREFIX(A)                                          CSE045
     D  TranInExtB   E DS                  EXTNAME(SETESDPD)                                  CSE045
     D                                     PREFIX(B)                                          CSE045
      *                                                                                       CSE045
      ** Securities screen 1 details retrieved from file - screen format                      CSE045
     D NwSE1ScnFmt   E DS                  EXTNAME(SETESDPD)                                  CSE045
      *                                                                                       CSE045
      ** Securities screen error indicators                                                   CSE045
     D SEETES        E DS                  EXTNAME(SEETESPD)                                  CSE045
 
     D ValidTrad     E DS                  EXTNAME(SEVTRADPD)
     D                                     PREFIX(V_)
     D ValidTrX1     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(V_)
     D ValidTX1A     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(VA_)
     D ValidTX1B     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(VB_)
 
     D ValidTrX2     E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
     D                                     PREFIX(V_)                                         CSE045
     D ValidTX2A     E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
     D                                     PREFIX(VA_)                                        CSE045
     D ValidTX2B     E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
     D                                     PREFIX(VB_)                                        CSE045
 
     D TradFilFmt    E DS                  EXTNAME(TRADSD)
     D TX1AFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(A_)
     D TX1BFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(B_)
 
 
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
      * (Current) Trade in Screen Format - SWIFT 'A' Details
     D CurTrSwftA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@A)
      * (Current) Trade in Screen Format - SWIFT 'B' Details
     D CurTrSwftB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@B)
 
 
      * Error indicators
     D OKTrPrim      E DS                  EXTNAME(SEETRPRPD)
     D OKTrSeco      E DS                  EXTNAME(SEETRSEPD)
     D OKTrThir      E DS                  EXTNAME(SEETRTHPD)                                 CAS006
     D OKTrExch      E DS                  EXTNAME(SEETREXPD)
     D OKTrSett      E DS                  EXTNAME(SEETRSTPD)
     D DDCLTY2OK     E                     EXTFLD(DDCLTYOK)
     D OKTrChcm      E DS                  EXTNAME(SEETRCCPD)
     D OKTrSwft      E DS                  EXTNAME(SEETRSWPD)
 
 
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
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  CSE045
      ** External DS for Branch Details                                                       CSE045
     D SDSECS        E DS                  EXTNAME(SDSECSPD)                                  CSE045
     D BFZONE        E                     EXTFLD(SEZONE)                                    BUG3122
      ** External DS for Security Customer Details                                            CSE045
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** External DS for API ICD                                                CAP011
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for Securities Trading Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      **  Data structure for Portfolio Management ICD File
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
                                                                                CAP051
     D InfData       E DS                  EXTNAME(SETRIFPD)                    CAP051
      * SE Extra Data - Classe 1 Data - File (D/B) format                       CAP051
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(SETDEXPD)                    CAP004
      * SE Trades Extra Data - File (D/B) format                                CAP004
      *                                                                                       CER001
     D RegData       E DS                  EXTNAME(SETDRXPD)                                  CER001
      *                                                                                       CER001
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SDSTAT data area                                                                     CSC011
                                                                                              CSC011
     D TradSwX2A     E DS                  EXTNAME(TRADSDX2)                                  210517
     D                                     PREFIX(A_)                                         210517
                                                                                              210517
     D TradSwX2B     E DS                  EXTNAME(TRADSDX2)                                  210517
     D                                     PREFIX(B_)                                         210517
                                                                                              210517
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
      *                                                                                       CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A
     D Trans5003       S            500A
     D Trans5004       S            500A
     D Trans5005       S            500A
     D Trans5006       S            500A
     D Trans5007       S            500A
     D Trans5008       S            500A
                                                                                CAP051
      ** Field (500A) to receive the incoming Extra Data                        CAP051
     D InfData500      S            500A                                        CAP051
                                                                                CAP004
      ** Field (500A) to receive the incoming Extra Data                        CAP004
     D ExtData500      S            500A                                        CAP004
      *                                                                                       CER001
      ** Field (500A) to receive the incoming Extra Data                                      CER001
      *                                                                                       CER001
     D RegData500      S            500A                                                      CER001
      *                                                                                       CER001
      ** Field (4755A) to receive the incoming Extra Data                                     CSE045
     D***OthDData4755    S           4755A                                            CSE045 CSF011A
     D OthrData        S           4878A                                                     CSF011A
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
 
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   INZ('SETRADUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D*PDealNo**       S             18A                                               CSC011 CGL029
     D*PADealNo*       S             18A                                               CSC011 CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                              CSC011
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
      *                                                                         CSE023
      ** Country of treaty                                                      CSE023
     D PDRBW           S              2A                                        CSE023
      *                                                                         CSE023
      ** Withholding tax                                                        CSE023
     D DDWTAX          S             15A                                        CSE023
 
      ** Swift 2001 flag                                                                      CSW201
     D CSW201          S              1A                                                      CSW201
                                                                                              CSW201
     D CSW206          S              1A                                                     CSW206E
     D CSW210          S              1A                                                      CSW210
     D CFT004          S              1A                                                      CSW210
     D CAS006          S              1                                                       CAS006
     D DDHACR          S             13                                                       CAS006
     D DDPRICN         S             17                                                       CAS006
                                                                                              CAS006
     D CallFromVU      S              1A   INZ(' ')                                           CAP087
     D CSE022          S              1A                                                      CSE045
     D CSW014          S              1A                                                      CSE045
     D SWRTN           S              7A                                                      CSE045
     D WTDTP           S              2A                                                      CSE045
     D WWCLTY          S              2A                                                      CSE045
     D PGMNAM          S              9A                                                      CSE045
     D PWHEN           S              1A                                                      CSE045
     D PMKCT           S              2A                                                      CSE045
     D DFTFLG          S              1A                                                      CSE045
      *                                                                                       CSE045
      ** Data structure to receive parameters from SE1805 for MT5xxs                          CSE045
     D PDATA         E DS                  EXTNAME(SE50DT)                                    CSE045
      *                                                                                       CSE045
      ** Mode = '*FRONT' (front office transaction interface)                                 CSE045
      ** Mode = '      ' (not front office transaction interface)                             CSE045
      ** Mode = '*RPR  ' (repair function)                                                    CSE045
      ** Mode = '*SIN  ' (screen input function)                                              CSE045
     D PMode           S              6A   INZ('*SIN  ')                                      CSE045
     D PINKS           S              1A                                                      CSE045
     D PINKT           S              1A                                                      CSE045
     D PCUST           S              6A                                                      CSE045
     D WCTPCN          S              6A                                                      CSE045
     D PDEPO           S              6A                                                      CSE045
     D PDEPO2          S              6A                                                      CSE045
     D PRETC           S             10A                                                      CSE045
     D PSKAL           S             20A                                                      CSE045
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
                                                                                              CSC022
     D CGL014          S              1A                                                     BUG3145
      ** CGL031 flag                                                                          CGL031
     D CGL031          S              1A                                                      CGL031
      ** Front office id variable.                                                         AR698195B
     D DDFRNT          S             20A                                                   AR698195B
                                                                                              CGL031
     D*C_TDVD**********S*******************LIKE(TDVD)******************               243776 243776A
                                                                                              243776
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SETRADC017
 
      *                                                                                       CER001
      ** Valid Extended trade in File Format                                                  CER001
      *                                                                                       CER001
     D ValidFilExt   E DS                  EXTNAME(SEVTDLX1PD)                                CER001
                                                                                              CER001
      *                                                                                       CER001
      ** Errors Indicators Extended Fields                                                    CER001
      *                                                                                       CER001
     D OkFlagsExt    E DS                  EXTNAME(SEETDLX1PD)                                CER001
      *                                                                                       CER001
                                                                                              CER001
     D DATALUX         DS          1024                                                       CER001
     D  PETDRF                 1      6                                                       CER001
     D  UTDBK                  7      8                                                       CER001
     D  UVTCNR                 9     14                                                       CER001
     D  #1TDVD                15     19  0                                                    CER001
     D  #1TDDT                20     24  0                                                    CER001
     D  #1ISSD                25     29  0                                                    CER001
     D  #1MATY                30     34  0                                                    CER001
     D  #1FOTR                35     54                                                       CER001
     D  #1TMST                55     80Z                                                      CER001
      *                                                                                       CER001
      ** Variables used by CER001 modifications                                               CER001
      *                                                                                       CER001
     D ULX603          S              1A                                                      CER001
     D ULX008          S              1A                                                      CER001
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SETRADC001
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInPrim
     C                   MOVEL     Trans5002     TranInSeco
     C                   MOVEL     Trans5003     TranInExch
     C                   MOVEL     Trans5004     TranInSett
     C                   MOVEL     Trans5005     TranInChCm
     C                   MOVEL     Trans5006     TranInSwfA
     C                   MOVEL     Trans5007     TranInSwfB
     C                   MOVEL     Trans5008     TranInThir                                   CAS006
     C                   MOVEL     Infdata500    Infdata                        CAP051
     C                   MOVEL     Extdata500    Extdata                        CAP004
     C                   MOVEL     RegData500    RegData                                      CER001
     C**********         MOVEL     OthDData4755  OthDData                             CSE045 CSF011A
     C                   MOVEL     OthrData      OthDData                                    CSF011A
     C                   MOVEL     TranInExt1    TranInExtA                                   CSE045
     C                   MOVEL     TranInExt2    TranInExtB                                   CSE045
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,SETRADC002
 
      *  Check if valid trade exists for Front Office ID
 
     C                   EXSR      ChkValTrad
      *
      *  If valid trade does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
                                                                                CAP013
      *  Check if valid trade exists for Midas Trade Ref                        CAP013
                                                                                CAP013
     C                   EXSR      ChkValMiTR                                   CAP013
      *                                                                         CAP013
      *  If valid trade does exist (even after delay), fail this input          CAP013
      *                                                                         CAP013
     C     Idx           IFNE      0                                            CAP013
     C                   GOTO      INVALID                                      CAP013
     C                   END                                                    CAP013
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid trades file.
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,SETRADC003
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
      *
      /COPY WNCPYSRC,SETRADC004
 
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN         DDACTN = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,SETRADC005
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,SETRADC006
 
     C                   WHEN         DDACTN = 'A'
     C                             OR DDACTN = 'C'
      *  Processing for Amends or Changes
      /COPY WNCPYSRC,SETRADC007
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        scan      TranInPrim                             99    CAP011
     C  N99GHSUBS        scan      TranInSeco                             99    CAP011
     C  N99GHSUBS        scan      TranInThir                             99                  CAS006
     C  N99GHSUBS        scan      TranInExch                             99    CAP011
     C  N99GHSUBS        scan      TranInSett                             99    CAP011
     C  N99GHSUBS        scan      TranInChCm                             99    CAP011
     C  N99GHSUBS        scan      TranInSwfA                             99    CAP011
     C  N99GHSUBS        scan      TranInSwfB                             99    CAP011
     C     *in99         ifeq      *on                                          CAP011
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   endif                                                  CAP011
     C                   endif                                                  CAP011
     C                   EXSR      SetupAmd
      /COPY WNCPYSRC,SETRADC008
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,SETRADC009
     C                   EXSR      ValdateAmd
      /COPY WNCPYSRC,SETRADC010
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
      /COPY WNCPYSRC,SETRADC011
 
     C     ARERRMOD      IFNE      *BLANK
     C                   EVAL      MQErrlong  = *blank
     C                   MOVEL     ProcErr       MQError
     C                   MOVE      ARERRMOD      MQError          28
     C                   MOVEL     MQError       MQErrlong
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn         10
     C                   PARM                    MQErrlong       132
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
 
     C                   ELSE
 
      *  Processing for Error checking/write to database
      /COPY WNCPYSRC,SETRADC012
      *                                                                                       CER001
     C                   IF        ULX603 = 'Y'                                               CER001
      *                                                                                       CER001
     C                   MOVE      *ALL'Y'       OkFlagsExt                                   CER001
      *                                                                                       CER001
      ** Validate the extension transaction details                                           CER001
      *                                                                                       CER001
     C                   Z-ADD     V_TDVD        #1TDVD                                       CER001
     C                   Z-ADD     V_TDDT        #1TDDT                                       CER001
     C                   Z-ADD     0             #1ISSD                                       CER001
     C                   Z-ADD     0             #1MATY                                       CER001
     C                   IF        Idx = *ZERO                                                CER001
     C                   Z-ADD     ISSD          #1ISSD                                       CER001
     C                   Z-ADD     MATY          #1MATY                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'SETRAD2VL'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OkFlagsExt                                   CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidFilExt                                  CER001
     C                   PARM                    ULX008                                       CER001
      *                                                                                       CER001
      *                                                                                       CER001
      ** No Errors, write in valid file                                                       CER001
      *                                                                                       CER001
     C                   IF        Idx = 0                                                    CER001
      *                                                                                       CER001
     C                   IF        DDACTN = 'I'                                               CER001
     C                   EXSR      SETUPTRADR                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   EVAL      #6LXCCTDRF = V_TDRF                                        CER001
     C                   EVAL      #6LXCCFOTR = APFOTranID                                    CER001
     C                   EVAL      #6LXCCTMES = Timestamp                                     CER001
     C                   WRITE     SEVTDLXD6                                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Errors, write in invalid file                                                        CER001
      ** Only write to invalid files if repair in back office                                 CER001
      *                                                                                       CER001
     C                   IF        Idx > 0                                                    CER001
     C                             AND APRprLocn =  'B'                                       CER001
     C                   EVAL      #6LXFOTR = APFOTranID                                      CER001
     C                   EVAL      #6LXTIME = TimeStamp                                       CER001
     C                   WRITE     SEITDLXD6                                                  CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,SETRADC013
 
      *  If valid, send data queue entry to prompt DB update program
     C     Idx           IFEQ      0
     C                   EVAL      ObjType = '*DTAARA'
      *  Check if update program active using Allocate Object API
      *  No prompting necessary if program is running
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANK        Return
 
     C     Return        IFEQ      *BLANK
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SETRADC018
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValTrad - Routine to check if valid trade exists           *
      * for Front Office ID                                           *
      *                                                               *
      *****************************************************************
     C     ChkValTrad    BEGSR
 
      * Check for trade on Valid file
     C     APFOTranID    CHAIN     SEVTRADL0                          99
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'
 
     C     APFOTranID    CHAIN     SEVTRADL0                          99
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTDRF'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP013
      *****************************************************************         CAP013
      *                                                               *         CAP013
      * ChkValMiTR - Routine to check if valid trade exists for       *         CAP013
      *    Midas Trade Reference                                      *         CAP013
      *                                                               *         CAP013
      *****************************************************************         CAP013
                                                                                CAP013
     C     ChkValMiTR    BEGSR                                                  CAP013
                                                                                CAP013
      * If (numeric) Midas Trade Reference supplied                             CAP013
                                                                                CAP013
     C                   TESTN                   DDTDRF               9898      CAP013
                                                                                CAP013
     C     DDTDRF        IFNE      *BLANKS                                      CAP013
     C     *IN98         ANDEQ     '1'                                          CAP013
                                                                                CAP013
      * Check for trade on Valid file                                           CAP013
     C                   MOVEL     DDTDRF        TDRF                           CAP013
     C     TDRF          CHAIN     SEVTRADL1                          99        CAP013
                                                                                CAP013
      * If record found...                                                      CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
                                                                                CAP013
      * ..delay, then repeat check                                              CAP013
     C                   CALLB     'ZACDELAY'                                   CAP013
                                                                                CAP013
     C     TDRF          CHAIN     SEVTRADL1                          99        CAP013
                                                                                CAP013
      * Error if still present                                                  CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
     C                   ADD       1             Idx                            CAP013
     C                   EVAL      FldNameArr(Idx) = 'DDTDRF'                   CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   ENDSR                                                  CAP013
      *****************************************************************         CAP013
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    transaction IDs supplied                                   *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     DDACTN        IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C     DDTDRF        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      ModeofOp                       CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
 
      * Validate action code versus transaction IDs supplied
      * This function will set the Midas trade reference
      * The trade in file format from the SE database is retrieved as well.
 
     C                   RESET                   ReturnCode
     C                   CALLB     'SETRADRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C*******************PARM      '*FRONT'      ModeofOp          6            CAP013
     C                   PARM                    ModeofOp          6            CAP013
      *
      * Response mode
     C                   PARM                    APRESPMODE
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID
      *
      * (Midas) Trade Reference
     C                   PARM                    DDTDRF            6
      *                                                                         154562
      * MT5XX - Phase 2 Message Generation is on.                               154562
     C                   PARM                    CSW003            1            154562
      *                                                                                       CAP067
      * Buy-sell back                                                                         CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      * Trade Reference                                                                       CAP067
     C                   PARM                    PFTDRF            6                          CAP067
      *
      * OUTPUTS
      *
      * (Current) trade in file format
      * (Current) trade extension in file format
     C                   PARM                    TradFilFmt
     C                   PARM                    TX1AFilFmt
     C                   PARM                    TX1BFilFmt
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Trade Reference
     C                   PARM                    DDTdrfOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      **   Move book from file to work field for later checking.                              193462
      *                                                                                       193462
     C                   MOVE      V_TDBK        OLDBK1            2                          193462
     C                   MOVE      *BLANK        WARNIND           1                          193462
      *                                                                                       193462
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments and changes.                                 *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
      * For Amends, put the complete (pre-existing) trade into the Valid
      *  file record - fields in this will be updated during processing
 
     C                   MOVE      TradFilFmt    ValidTrad
     C                   MOVE      TX1AFilFmt    ValidTX1A
     C                   MOVE      TX1BFilFmt    ValidTX1B
 
      * For Amends, convert the trade to screen format
 
     C                   CALLB     'SETRADCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Trade - file formats
     C                   PARM                    ValidTrad
     C                   PARM                    ValidTX1A
     C                   PARM                    ValidTX1B
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
                                                                                              CAS006
     C                   PARM                    CAS006                                       CAS006
      * CGL031 Switchable Feature                                                             CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * Output parameters
      *
      * Trade - screen formats
     C                   PARM                    CurTrPrim
     C                   PARM                    CurTrSeco
     C                   PARM                    CurTrThir                                    CAS006
     C                   PARM                    CurTrExch
     C                   PARM                    CurTrSett
     C                   PARM                    CurTrChCm
     C                   PARM                    CurTrSwftA
     C                   PARM                    CurTrSwftB
 
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
      *
      * Trade Status
      * Trade Authorized/Not Authorized
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14                           S0126
      * Security report name
      * Customer report name
     C**********         PARM                    DDSRPN           20                          CSE016
     C                   PARM                    DDSRNME          41                          CSE016
     C                   PARM                    DDCRNM           20
 
      * Coupon Rate
      * Current Factor
      * Margin Amount
      * Portfolio Exchange Rate
      * Portfolio M/D Ind
      * Trade Countervalue
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
 
      *  Certain groups of fields on the trade may not be supplied for an
      *  amendment. If none of the fields in each group were supplied
      *  (i.e. all are blank), default the existing database values ...
 
     C                   IF            (TranInExch = *blank)
     C                   EVAL      TranInExch = CurTrExch
     C                   ENDIF
 
     C                   IF            (TranInSett = *blank)
     C                   EVAL      TranInSett = CurTrSett
     C                   ENDIF
 
     C                   IF            (TranInChCm = *blank)
     C                   EVAL      TranInChCm = CurTrChCm
     C                   ENDIF
 
     C                   IF            (TranInSwfA = *blank)
     C                   EVAL      TranInSwfA = CurTrSwftA
     C                   ENDIF
 
     C                   IF            (TranInSwfB = *blank)
     C                   EVAL      TranInSwfB = CurTrSwftB
     C                   ENDIF
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateTr - Routine to validate the main tranaction details  *
      *                                                               *
      *****************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Trade Primary details
 
     C                   EXSR      ValdTrPrim
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
      * Validate Trade Secondary details
 
     C                   EXSR      ValdTrSeco
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
                                                                                              CAS006
      ** Validate more Trade details (third screen)                                           CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EXSR      ValdTrThir                                                 CAS006
                                                                                              CAS006
      ** If error in validation, fail this input                                              CAS006
                                                                                              CAS006
     C     Idx           IFNE      0                                                          CAS006
     C                   GOTO      EValidTr                                                   CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
 
      * Default Trade Other details
      * (Exchange Rate, Settlement, Charges and Commissions)
      /COPY WNCPYSRC,SETRADC020                                                               CUT009
 
     C                   EXSR      DfltTrOTH
 
      /COPY WNCPYSRC,SETRADC021                                                               CUT009
      * CalcTrCHCM - Calculate Trade Charges/Commissions
 
     C                   EXSR      CalcTrCHCM
 
      * Validate Trade Other details
      * (Exchange Rate, Settlement, Charges and Commissions)
 
     C                   EXSR      ValdTrOTH
                                                                                              233881
      ** CalcTrEuTx - Calculate EU Tax                                                        233881
                                                                                              233881
     C     CGL031        IFEQ      'Y'                                                        233881
     C                   EXSR      CalcTrEUTX                                                 233881
     C                   ENDIF                                                                233881
 
      * CalcTrCVAL - Calculate Trade Countervalue
 
     C                   EXSR      CalcTrCVAL
                                                                                             BUG3145
      ** Additional validations                                                              BUG3145
      ** (Pay To Account)                                                                    BUG3145
                                                                                             BUG3145
     C                   IF        CGL014 = 'Y'  AND  V_PAYT <> *BLANKS                      BUG3145
     C                             AND  DDPAYTOK <> 'N'                                      BUG3145
     C                   EXSR      ValdTrAddl                                                BUG3145
     C                   ENDIF                                                               BUG3145
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
      *
      * If MT5XX Message Generation are installed,
      *
     C     S01401        IFEQ      'Y'
 
      * Default Trade Extension (SWIFT) 'A' details
 
     C     TranInSwfA    IFEQ      *BLANK
     C     DDACTN        OREQ      'I'                                                        247873
      *                                                                                       247873
      ** Keep data-structure values if non-blank                                              247873
      *                                                                                       247873
     C                   IF        TranInSwfA <> *Blanks                                      247873
     C                   EVAL      TranInSwfI = TranInSwfA                                    247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   EXSR      DfltTrSwfA
      *                                                                                       247873
      ** Restore values for non-blank fields                                                  247873
      *                                                                                       247873
     C                   IF        TranInSwfI <> *Blanks                                      247873
     C                   EVAL      TranInSwfO = TranInSwfA                                    247873
     C                   EXSR      RstrTrSwf1                                                 247873
     C                   EVAL      TranInSwfA = TranInSwfO                                    247873
      *                                                                                       247873
     C                   CLEAR                   TranInSwfI                                   247873
     C                   CLEAR                   TranInSwfO                                   247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   END
                                                                                              CSE045
     C                   IF        CSE045 = 'N'                                               CSE045
                                                                                              210517
      ** Default fields for the TRADSDX2 file                                                 210517
                                                                                              210517
     C                   EXSR      SRDfltTrX2A                                                210517
     C                   ENDIF                                                                CSE045
 
      * Validate Trade Extension (SWIFT) 'A' details
 
     C                   EXSR      ValdTrSwfA
                                                                                              CSE045
     C                   IF        CSE045 = 'Y'                                               CSE045
      *                                                                                       CSE045
      ** Set up PDATA array fields for passing to SETSESVAL                                   CSE045
      *                                                                                       CSE045
     C                   EXSR      SetPDATA                                                   CSE045
      *                                                                                       CSE045
      ** Validate Trade Extended Settlements Details A                                        CSE045
      *                                                                                       CSE045
     C                   EVAL      PWHEN = 'A'                                                CSE045
     C                   IF        (DDACTN = 'I') and (TranInExtA = *BLANKS)                  CSE045
     C                   EVAL      DFTFLG = 'Y'                                               CSE045
     C                   ELSE                                                                 CSE045
     C                   EVAL      DFTFLG = 'N'                                               CSE045
     C                   ENDIF                                                                CSE045
     C                   EXSR      SRDefScn                                                   CSE045
     C                   IF        TranInExtA = *BLANKS                                       CSE045
     C                   EVAL      TranInExtA = NwSE1ScnFmt                                   CSE045
     C                   ENDIF                                                                CSE045
     C                   EXSR      ValdTrExSetA                                               CSE045
     C                   ENDIF                                                                CSE045
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
      *
      ** If screen B is required
      *
     C     CSW003        IFEQ      'Y'
     C     CustClass     IFEQ      'S'
     C     V_DELT        ANDNE     V_DELF
     C     CustClass     OREQ      'D'
     C     V_DELT        ANDNE     V_DELF
 
      * Default Trade Extension (SWIFT) 'B' details
 
     C     TranInSwfB    IFEQ      *BLANK
     C     DDACTN        OREQ      'I'                                                        247873
      *                                                                                       247873
      ** Keep data-structure values if non-blank                                              247873
      *                                                                                       247873
     C                   IF        TranInSwfB <> *Blanks                                      247873
     C                   EVAL      TranInSwfI = TranInSwfB                                    247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   EXSR      DfltTrSwfB
      *                                                                                       247873
      ** Restore values for non-blank fields                                                  247873
      *                                                                                       247873
     C                   IF        TranInSwfI <> *Blanks                                      247873
     C                   EVAL      TranInSwfO = TranInSwfB                                    247873
     C                   EXSR      RstrTrSwf1                                                 247873
     C                   EVAL      TranInSwfB = TranInSwfO                                    247873
      *                                                                                       247873
     C                   CLEAR                   TranInSwfI                                   247873
     C                   CLEAR                   TranInSwfO                                   247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   END
                                                                                              CSE045
     C                   IF        CSE045 = 'N'                                               CSE045
                                                                                              210517
      ** Default fields for the TRADSDX2 file                                                 210517
                                                                                              210517
     C**********         EXSR      SRDfltTrX2A                                        210517 243119A
     C                   EXSR      SRDfltTrX2B                                               243119A
     C                   ENDIF                                                                CSE045
 
      * Validate Trade Extension (SWIFT) 'B' details
 
     C                   EXSR      ValdTrSwfB
     C                   IF        CSE045 = 'Y'                                               CSE045
     C                   EXSR      SETPDATA                                                   CSE045
     C                   EVAL      PWHEN = 'B'                                                CSE045
     C                   IF        (DDACTN = 'I') and (TranInExtB = *BLANKS)                  CSE045
     C                   EVAL      DFTFLG = 'Y'                                               CSE045
     C                   ELSE                                                                 CSE045
     C                   EVAL      DFTFLG = 'N'                                               CSE045
     C                   ENDIF                                                                CSE045
     C                   EXSR      SRDefScn                                                   CSE045
     C                   IF        TranInExtB = *BLANKS                                       CSE045
     C                   EVAL      TranInExtB = NwSE1ScnFmt                                   CSE045
     C                   ENDIF                                                                CSE045
     C                   EXSR      ValdTrExSetB                                               CSE045
     C                   ENDIF                                                                CSE045
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
     C                   END
     C                   END
 
     C                   END
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrPrim - Validate Trade Primary details                   *
      *                                                               *
      *****************************************************************
     C     ValdTrPrim    BEGSR
 
     C                   CALLB     'SETRADPVAL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** Trade Primary Details
     C                   PARM                    TranInPrim
      * Custom Extra Data file data                                             CAP004
     C                   PARM                    ExtData                        CAP004
 
      ** Trade settlement currency
     C                   PARM                    DDSETC            3
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
     C                   PARM                    WIdx
 
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
                                                                                              CPB002
      * PB Order Number                                                                       CPB002
     C                   PARM                    DDORDE                                       CPB002
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrSeco - Validate Trade Secondary details                 *
      *                                                               *
      *****************************************************************
     C     ValdTrSeco    BEGSR
 
     C                   CALLB     'SETRADSVAL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** Trade Primary Details
      ** Trade Secondary Details
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
      * Custom Extra Data file data                                             CAP004
     C                   PARM                    ExtData                        CAP004
     C/COPY WNCPYSRC,SETRADCC01
      *
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default
     C                   PARM      'Y'           Validate
 
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
 
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *                                                                                       CSE028
      ** MT5xx SSI (Phase 2)                                                                  CSE028
     C                   PARM                    CSE028                                       CSE028
      * CGL031 Switchable Feature                                                             CGL031
     C                   PARM                    CGL031                                       CGL031
      ** Current File Trade Date                                                              243776
     C**********         PARM                    C_TDVD                               243776 243776A
     C                   PARM                    TDVD                                        243776A
      *
      * OUTPUTS
      *
      ** Settlement Currency Details
     C                   PARM                    SetCcyDts
 
      ** Trade Secondary Details OK inds
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
     C                   PARM                    WIdx
 
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  ValdTrThir - Validate Trade third screen details             *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     ValdTrThir    BEGSR                                                                CAS006
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
      ** Trade Third screen details                                                           CAS006
                                                                                              CAS006
     C                   PARM                    TranInPrim                                   CAS006
     C                   PARM                    TranInSeco                                   CAS006
     C                   PARM                    TranInThir                                   CAS006
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
      ** Coupon Rate using NTR                                                                CAS006
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
      ** OUTPUTS                                                                              CAS006
                                                                                              CAS006
      ** Trade Third screen details OK inds                                                   CAS006
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
     C                   PARM                    WIdx                                         CAS006
                                                                                              CAS006
      ** Valid Trade layout (DS) from/to caller                                               CAS006
                                                                                              CAS006
     C                   PARM                    ValidTrad                                    CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************
      *                                                               *
      * DfltTrOTH - Default Trade Other details                       *
      *                                                               *
      *****************************************************************
     C     DfltTrOTH     BEGSR
 
      ** EXCHANGE RATE DEFAULTING
 
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'C'
     C     DDSETC        ANDNE     SETC
 
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
     C                   PARM                    CEU005            1
 
      * OUTPUTS
 
      ** Trade Exchange Rate screen fields
 
     C                   PARM                    TranInExch
 
      ** Trade Exchange Rate file fields
 
     C                   PARM                    V_TDER           13 8
     C                   PARM                    V_TMDI            1
     C                   PARM                    V_TBCR           13 8
 
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
 
     C                   PARM                    TranInSett
                                                                                              244115
      ** Set clearance type field from invalid file.                                          244115
     C                   EVAL      DDCLTY = DDCLTY2                                           244115
 
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
     C****************** PARM                    CAP050            1            CPB001
     C                   PARM                    BGN4ST            1            CPB001
 
      * OUTPUTS
 
      ** Commission Rebate %
     C                   PARM                    CMRP              5 3
 
      ** Trade Charges & Commissions screen fields
 
     C                   PARM                    TranInChcm
 
      ** Trade Charges & Commissions file fields
 
     C                   PARM                    V_TBCC            2
     C                   PARM                    V_TCCC            2
     C                   PARM                    V_TCC1            2
     C                   PARM                    V_TCC2            2
 
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrOTH - Validate Trade Other details                      *
      *                                                               *
      *****************************************************************
     C     ValdTrOTH     BEGSR
 
     C                   CALLB     'SETRADOVAL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** Trade Primary Details
      ** Trade Secondary Details
      ** Trade Exchange Rates
      ** Trade Settlement Instructions
      ** Trade Charge & Commissions
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
     C                   PARM                    TranInExch
     C                   PARM                    TranInSett
     C                   PARM                    TranInChcm
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
                                                                                              CGL031
      ** Taxation of Savings Income                                                           CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * OUTPUTS
      *
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
     C                   PARM                    WIdx
 
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                      BUG3145
      *                                                               *                      BUG3145
      * ValdTrAddl - Additional validations                           *                      BUG3145
      *                                                               *                      BUG3145
      *****************************************************************                      BUG3145
     C     ValdTrAddl    BEGSR                                                               BUG3145
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
     C                   PARM                    ValidTrad                                   BUG3145
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
     C                   PARM                    WIdx                                        BUG3145
                                                                                             BUG3145
     C                   ENDSR                                                               BUG3145
      *****************************************************************                      BUG3145
      /EJECT                                                                                 BUG3145
      *****************************************************************
      *                                                               *
      * DfltTrSwfA - Default Trade Extension (SWIFT) 'A' details      *
      *                                                               *
      *****************************************************************
     C     DfltTrSwfA    BEGSR
 
     C                   CALLB     'SETSWFTDFT'
      *
      ** INPUT PARAMETERS :
      *
      * Screen (A or B)
     C                   PARM      'A'           Screen            1
      *
      * Trade Details (screen)
      *
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSETP            2
     C                   PARM                    DDCLTY2           1
     C                   PARM                    DDPCOD            1
     C                   PARM                    DDPRYC            1
     C                   PARM                    DDBRCD                                       CSE028
     C                   PARM                    DDBPBK                                       CSE028
     C                   PARM                    DDSETC                                       CSE028
     C                   PARM                    DDMRKT                                       CSE034
      *
      * Trade Details (file)
     C                   PARM                    V_TDVD
     C                   PARM                    V_TCNR
     C                   PARM                    V_DELF
     C                   PARM                    V_DELT
     C                   PARM                    INVT                                         199797
      *
      * (CSW003) MT5XX - Phase 2 Message Generation
     C                   PARM                    CSW003            1
      *
      ** OUTPUT PARAMETERS :
      *
      * Screen A details
     C                   PARM                    TranInSwfA
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      *
      * Screen B details
     C                   PARM                    TranInSwfB
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrSwfA - Validate Trade Extension (SWIFT) 'A' details     *
      *                                                               *
      *****************************************************************
     C     ValdTrSwfA    BEGSR
 
     C                   CALLB     'SETRADEVAL'
      *
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
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
     C                   PARM                    TranInExch
     C                   PARM                    TranInSett
      *
      ** Trade Extension File details
     C                   PARM                    TranInSwfA
      * Custom Extra Data file data                                             CAP004
     C                   PARM                    ExtData                        CAP004
      *
      ** Previous inds
     C                   PARM                    @ADDGMES
     C                   PARM                    @ADDGMEC
     C                   PARM                    @ADDCCID
     C                   PARM                    A_T1CONG
      *
      ** Processing type
     C                   PARM                    PROT
      *
      ** Override errors
     C                   PARM                    OVRErrors
      *
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
      * Swift 2001 flag                                                                       CSW201
     C                   PARM                    CSW201                                       CSW201
      *                                                                                       201233
      ** Destination of settlement                                                            201233
     C                   PARM                    A_DDROTS                                     201233
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM                    PUYAT             1                          201429
                                                                                              210517
     C                   PARM                    TradSwX2A                                    210517
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
     C                   PARM                    WIdx
      *
      * Valid Trade layout (DS) (Extension file) from/to caller
     C                   PARM                    ValidTX1A
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DfltTrSwfB - Default Trade Extension (SWIFT) 'B' details      *
      *                                                               *
      *****************************************************************
     C     DfltTrSwfB    BEGSR
 
     C                   CALLB     'SETSWFTDFT'
      *
      ** INPUT PARAMETERS :
      *
      * Screen (A or B)
     C                   PARM      'B'           Screen            1
      *
      * Trade Details (screen)
      *
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSETP            2
     C                   PARM                    DDCLTY2           1
     C                   PARM                    DDPCOD            1
     C                   PARM                    DDPRYC            1
     C                   PARM                    DDBRCD                                       CSE028
     C                   PARM                    DDBPBK                                       CSE028
     C                   PARM                    DDSETC                                       CSE028
     C                   PARM                    DDMRKT                                       CSE034
      *
      * Trade Details (file)
     C                   PARM                    V_TDVD
     C                   PARM                    V_TCNR
     C                   PARM                    V_DELF
     C                   PARM                    V_DELT
     C                   PARM                    INVT                                         199797
      *
      * (CSW003) MT5XX - Phase 2 Message Generation
     C                   PARM                    CSW003            1
      *
      ** OUTPUT PARAMETERS :
      *
      * Screen A details
     C                   PARM                    TranInSwfA
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      *
      * Screen B details
     C                   PARM                    TranInSwfB
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrSwfB - Validate Trade Extension (SWIFT) 'B' details     *
      *                                                               *
      *****************************************************************
     C     ValdTrSwfB    BEGSR
 
     C                   CALLB     'SETRADEVAL'
      *
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
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
     C                   PARM                    TranInExch
     C                   PARM                    TranInSett
      *
      ** Trade Extension File details
     C                   PARM                    TranInSwfB
      * Custom Extra Data file data                                             CAP004
     C                   PARM                    ExtData                        CAP004
      *
      ** Previous inds
     C                   PARM                    @BDDGMES
     C                   PARM                    @BDDGMEC
     C                   PARM                    @BDDCCID
     C                   PARM                    B_T1CONG
      *
      ** Processing type
     C                   PARM                    PROT
      *
      ** Override errors
     C                   PARM                    OVRErrors         1
      *
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
      * Swift 2001 flag                                                                       CSW201
     C                   PARM                    CSW201                                       CSW201
      *                                                                                       201233
      ** Destination of settlement                                                            201233
     C                   PARM                    B_DDROTS                                     201233
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM                    PUYAT             1                          201429
                                                                                              210517
     C                   PARM                    TradSwX2B                                    210517
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
     C                   PARM                    WIdx
      *
      * Valid Trade layout (DS) (Extension file) from/to caller
     C                   PARM                    ValidTX1B
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  247873
      *****************************************************************                       247873
      *                                                               *                       247873
      * RstrTrSwf1 - Restore non-blank fields                         *                       247873
      *                                                               *                       247873
      *****************************************************************                       247873
                                                                                              247873
     C     RstrTrSwf1    BEGSR                                                                247873
      *                                                                                       247873
     C                   IF        IDDGMES <> *Blanks                                         247873
     C                   EVAL      ODDGMES = IDDGMES                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDTRTT <> *Blanks                                         247873
     C                   EVAL      ODDTRTT = IDDTRTT                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDINST <> *Blanks                                         247873
     C                   EVAL      ODDINST = IDDINST                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDINSS <> *Blanks                                         247873
     C                   EVAL      ODDINSS = IDDINSS                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDEUCL <> *Blanks                                         247873
     C                   EVAL      ODDEUCL = IDDEUCL                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDSAFA <> *Blanks                                         247873
     C                   EVAL      ODDSAFA = IDDSAFA                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDRPTY <> *Blanks                                         247873
     C                   EVAL      ODDRPTY = IDDRPTY                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDGDEL <> *Blanks                                         247873
     C                   EVAL      ODDGDEL = IDDGDEL                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDSROL <> *Blanks                                         247873
     C                   EVAL      ODDSROL = IDDSROL                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDFCOD <> *Blanks                                         247873
     C                   EVAL      ODDFCOD = IDDFCOD                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDFTID <> *Blanks                                         247873
     C                   EVAL      ODDFTID = IDDFTID                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDGMEC <> *Blanks                                         247873
     C                   EVAL      ODDGMEC = IDDGMEC                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDCCID <> *Blanks                                         247873
     C                   EVAL      ODDCCID = IDDCCID                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDFID1 <> *Blanks                                         247873
     C                   EVAL      ODDFID1 = IDDFID1                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDIORA <> *Blanks                                         247873
     C                   EVAL      ODDIORA = IDDIORA                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDSNEW <> *Blanks                                         247873
     C                   EVAL      ODDSNEW = IDDSNEW                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDSTMP <> *Blanks                                         247873
     C                   EVAL      ODDSTMP = IDDSTMP                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDCHID <> *Blanks                                         247873
     C                   EVAL      ODDCHID = IDDCHID                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   IF        IDDTRRM <> *Blanks                                         247873
     C                   EVAL      ODDTRRM = IDDTRRM                                          247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   ENDSR                                                                247873
      *****************************************************************                       247873
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     TDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT                             CAP011
                                                                                CAP011
     C                   RESET                   RetCodeIn                      CAP011
     C                   CALLB     'SETRADCVT'                                  CAP011
      *                                                                         CAP011
      * INPUTS                                                                  CAP011
      *                                                                         CAP011
      * Return Code                                                             CAP011
     C                   PARM                    RetCodeIn                      CAP011
      *                                                                         CAP011
      * Trade - file formats                                                    CAP011
     C                   PARM                    TradFilFmt                     CAP011
     C                   PARM                    TX1AFilFmt                     CAP011
     C                   PARM                    TX1BFilFmt                     CAP011
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
                                                                                              CAS006
     C                   PARM                    CAS006                                       CAS006
      * CGL031 Switchable Feature                                                             CGL031
     C                   PARM                    CGL031                                       CGL031
      *                                                                         CAP011
      * Output parameters                                                       CAP011
      *                                                                         CAP011
      * Trade - screen formats                                                  CAP011
     C                   PARM                    CurTrPrim                      CAP011
     C                   PARM                    CurTrSeco                      CAP011
     C                   PARM                    CurTrThir                                    CAS006
     C                   PARM                    CurTrExch                      CAP011
     C                   PARM                    CurTrSett                      CAP011
     C                   PARM                    CurTrChCm                      CAP011
     C                   PARM                    CurTrSwftA                     CAP011
     C                   PARM                    CurTrSwftB                     CAP011
                                                                                CAP011
      ** Security Details                                                       CAP011
      ** Investment Type Details                                                CAP011
     C                   PARM                    SECTY                          CAP011
     C                   PARM                    INVTP                          CAP011
                                                                                CAP011
      ** Nominal Currency Details                                               CAP011
     C                   PARM                    NomCcyDts                      CAP011
                                                                                CAP011
      ** Settlement Currency Details                                            CAP011
     C                   PARM                    SetCcyDts                      CAP011
      *                                                                         CAP011
      ** Customer (Counterparty) Details                                        CAP011
     C                   PARM                    CustDts                        CAP011
      *                                                                         CAP011
      * Trade Status                                                            CAP011
      * Trade Authorized/Not Authorized                                         CAP011
     C                   PARM                    DDSTAT            9            CAP011
     C                   PARM                    DDAUTH           14            CAP011
      * Security report name                                                    CAP011
      * Customer report name                                                    CAP011
     C**********         PARM                    DDSRPN           20                   CAP011 CSE016
     C                   PARM                    DDSRNME          41                          CSE016
     C                   PARM                    DDCRNM           20            CAP011
                                                                                CAP011
      * Coupon Rate                                                             CAP011
      * Current Factor                                                          CAP011
      * Margin Amount                                                           CAP011
      * Portfolio Exchange Rate                                                 CAP011
      * Portfolio M/D Ind                                                       CAP011
      * Trade Countervalue                                                      CAP011
     C                   PARM                    DDCPNR           13            CAP011
     C                   PARM                    DDCFCT           12            CAP011
     C                   PARM                    DDMAMT           18            CAP011
     C                   PARM                    DDSPXR           14            CAP011
     C                   PARM                    DDSPMD            1            CAP011
     C                   PARM                    DDTCTR           21            CAP011
     C                   PARM                    DDWTAX                         CSE023
     C                   PARM                    DDPRICN                                      CAS006
                                                                                CAP011
      * SCREEN A                                                                CAP011
      * Destination of Settlement                                               CAP011
      * Destination of Confirmation                                             CAP011
     C                   PARM                    A_DDROUS          6            CAP011
     C                   PARM                    A_DDROTS         12            CAP011
     C                   PARM                    A_DDROUC          6            CAP011
     C                   PARM                    A_DDROTC         12            CAP011
                                                                                CAP011
      * SCREEN B                                                                CAP011
      * Destination of Settlement                                               CAP011
      * Destination of Confirmation                                             CAP011
     C                   PARM                    B_DDROUS          6            CAP011
     C                   PARM                    B_DDROTS         12            CAP011
     C                   PARM                    B_DDROUC          6            CAP011
     C                   PARM                    B_DDROTC         12            CAP011
                                                                                CAP011
      ** DATA SUBSTITUTION                                                      CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
 
      * TRADE PRIMARY DETAILS
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      TranInPrim    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrPrim     CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       TranInPrim                     CAP011
 
      * TRADE SECONDARY DETAILS
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      TranInSeco    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrSeco     CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       TranInSeco                     CAP011
                                                                                              CAS006
      ** Trade Third screen details                                                           CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   CALLB     'APDTASUBS'                                                CAS006
                                                                                              CAS006
      ** Return Code                                                                          CAS006
                                                                                              CAS006
     C                   PARM                    ReturnCode                                   CAS006
                                                                                              CAS006
      ** Substitution character                                                               CAS006
      ** Incoming Data                                                                        CAS006
      ** Current Data                                                                         CAS006
                                                                                              CAS006
     C                   PARM      GHSUBS        SubsChar                                     CAS006
     C                   PARM      TranInThir    IncDATA                                      CAS006
     C                   PARM      CurTrThir     CurDATA                                      CAS006
                                                                                              CAS006
     C                   MOVEL     IncDATA       TranInThir                                   CAS006
     C                   ENDIF                                                                CAS006
 
      * TRADE EXCHANGE RATES
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      TranInExch    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrExch     CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       TranInExch                     CAP011
 
      * TRADE SETTLEMENT DETAILS
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      TranInSett    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrSett     CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       TranInSett                     CAP011
 
      * TRADE CHARGE/COMMISSIONS
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      TranInChCm    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrChCm     CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       TranInChCm                     CAP011
 
      * TRADE SWIFT A DETAILS
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      TranInSwfA    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrSwftA    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       TranInSwfA                     CAP011
 
      * TRADE SWIFT B DETAILS
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      TranInSwfB    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrSwftB    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       TranInSwfB                     CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT
      *****************************************************************
      *                                                               *
      * CalcTrCHCM - Calculate Trade Charges/Commissions              *
      *                                                               *
      *****************************************************************
     C     CalcTrCHCM    BEGSR
 
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
     C                   PARM                    V_TCNR
     C                   PARM                    V_NOML           11 0
     C                   PARM                    V_PRIC           15 8
     C                   PARM                    V_TDDT            5 0
     C                   PARM                    V_ITRA           13 0
     C                   PARM                    V_TCFC           10 9
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
     C                   PARM                    CurTrChCm
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
 
     C                   PARM                    TranInChcm
 
      ** Trade details
     C                   PARM                    V_TBCA           13 0
     C                   PARM                    V_TCCA           13 0
     C                   PARM                    V_TCA1           13 0
     C                   PARM                    V_TCA2           13 0
     C                   PARM                    V_TCA3           13 0
     C                   PARM                    V_TCA4           13 0
     C                   PARM                    V_TCA5           13 0
     C                   PARM                    V_TCA6           13 0
     C                   PARM                    V_TCA7           13 0
     C                   PARM                    V_TAXA           13 0
     C                   PARM                    V_BCMR           13 0
     C                   PARM                    V_CCMR           13 0
     C                   PARM                    V_TXRB           13 0
 
     C                   ENDSR
      *****************************************************************                       233881
      /EJECT                                                                                  233881
      *****************************************************************                       233881
      *                                                               *                       233881
      * CalcTrEuTx - Calculate EU Tax                                 *                       233881
      *                                                               *                       233881
      *****************************************************************                       233881
     C     CalcTrEuTx    BEGSR                                                                233881
                                                                                              233881
      ** CALCULATE EU TAX                                                                     233881
                                                                                              233881
     C                   CALLB     'SEVTRADTAX'                                               233881
                                                                                              233881
      * INPUTS                                                                                233881
                                                                                              233881
      * Response Mode                                                                         233881
     C                   PARM                    RespMode                                     233881
      * Valid Trade Details                                                                   233881
     C                   PARM                    ValidTrad                                    233881
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
     C************       PARM                    EUTX                                   233881234858
     C************       PARM                    EUTS                                   233881234858
     C                   PARM                    V_EUTX                                       234858
     C                   PARM                    V_EUTS                                       234858
                                                                                              233881
     C                   ENDSR                                                                233881
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CalcTrCVAL - Calculate Trade Countervalue                     *
      *                                                               *
      *****************************************************************
     C     CalcTrCVAL    BEGSR
 
      ** CALCULATE COUNTERVALUE
 
     C                   CALLB     'SETCVALCAL'
 
      * INPUTS
 
      ** Trade details
     C                   PARM                    V_TDTP            2
     C                   PARM                    V_NOML           11 0
     C                   PARM                    V_PRIC           15 8
     C                   PARM                    V_RALL            9 5
     C                   PARM                    V_ITRA           13 0
     C                   PARM                    V_TBCA           13 0
     C                   PARM                    V_TCCA           13 0
     C                   PARM                    V_TCA1           13 0
     C                   PARM                    V_TCA2           13 0
     C                   PARM                    V_TCA3           13 0
     C                   PARM                    V_TCA4           13 0
     C                   PARM                    V_TCA5           13 0
     C                   PARM                    V_TCA6           13 0
     C                   PARM                    V_TCA7           13 0
     C                   PARM                    V_TAXA           13 0
     C                   PARM                    V_TDER           13 8
     C                   PARM                    V_TMDI            1
     C                   PARM                    V_SETC            3
     C                   PARM                    V_TDVD            5 0                        200459
 
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
     C*************      PARM                    EUTX                                   233881234858
     C                   PARM                    V_EUTX                                       234858
 
      * OUTPUTS
 
      * Trade consideration in nominal currency
      * Trade countervalue in nominal currency
      * Withholding tax                                                         CSE023
      * Trade countervalue in settlement currency in screen format
      * Withholding tax in screen format                                        CSE023
     C                   PARM                    V_TCSR           15 0
     C                   PARM                    V_TCTR           15 0
     C                   PARM                    WHTX                           CSE023
     C                   PARM                    DDTCTR           21
     C                   PARM                    DDWTAX                         CSE023
 
     C                   ENDSR
      *****************************************************************                       CSE045
      /EJECT                                                                                  CSE045
      *****************************************************************                       CSE045
      * SetPDATA - Set up data structure for call to SE1806                                   CSE045
      *****************************************************************                       CSE045
     C     SetPDATA      BEGSR                                                                CSE045
                                                                                              CSE045
     C                   MOVEL     DDACTN        PACTN                                        CSE045
     C     DDACTN        IFEQ      'C'                                                        CSE045
     C                   MOVEL     'A'           PACTN                                        CSE045
     C                   END                                                                  CSE045
     C                   MOVEL     DDTDRF        PTDRF                                        CSE045
     C                   MOVEL     DDSETC        PTNMC                                        CSE045
     C                   MOVEL     DDSESN        PSESN                                        CSE045
     C                   MOVEL     DDBLKR        PBLKR                                        CSE045
     C                   MOVEL     DDCNUM        PTCNR                                        CSE045
     C                   MOVEL     DDBRCD        PTDBR                                        CSE045
     C                   MOVEL     DDTDTP        PTDTP                                        CSE045
     C                   MOVEL     V_NOML        PNOML                                        CSE045
     C                   MOVEL     DDTDMI        PTDMI                                        CSE045
     C                   MOVEL     DDAIIP        PAIIP                                        CSE045
     C                   MOVEL     DDINCS        PINCS                                        CSE045
     C                   MOVEL     BVDR1         PDC01                                        CSE045
     C                   MOVEL     BVDR2         PDC02                                        CSE045
     C                   MOVEL     DDCLTY        PCLTY                                        CSE045
     C                   MOVEL     DDPCOD        PPCOD                                        CSE045
     C                   MOVEL     V_DELT        PDELT                                        CSE045
     C                   MOVEL     V_DELF        PDELF                                        CSE045
     C                   MOVEL     DDTDSI        PTDSI                                        CSE045
     C                   MOVEL     DDSMTH        PSMTH                                        CSE045
     C                   MOVEL     BFDRF1        PC101                                        CSE045
     C                   MOVEL     BFDRF2        PC102                                        CSE045
     C                   MOVEL     DDPRYC        PPRYC                                        CSE045
     C                   Z-ADD     V_TDVD        PTDVD                                        CSE045
                                                                                              CSE045
     C     CSE028        IFEQ      'Y'                                                        CSE045
     C                   MOVEL     DDBPBK        PPBKC                                        CSE045
     C                   MOVEL     DDMRKT        PMKCT                                        CSE045
     C                   ENDIF                                                                CSE045
                                                                                              CSE045
     C                   ENDSR                                                                CSE045
      *****************************************************************                       CSE045
      /EJECT                                                                                  CSE045
      *****************************************************************                       CSE045
      *                                                               *                       CSE045
      *  SRDefScn - Default fields in screen                          *                       CSE045
      *                                                               *                       CSE045
      *****************************************************************                       CSE045
                                                                                              CSE045
     C     SRDefScn      BEGSR                                                                CSE045
                                                                                              CSE045
     C     KEY001        KLIST                                                                CSE045
     C                   KFLD                    PTDRF                                        CSE045
     C                   KFLD                    PWHEN                                        CSE045
                                                                                              CSE045
     C                   IF        PWHEN = 'A'                                                CSE045
     C                   MOVEL     ADDGMES       PGMES                                        CSE045
     C                   MOVEL     ADDGMEC       PGMEC                                        CSE045
     C                   MOVEL     ADDCCID       PCCID                                        CSE045
     C                   MOVEL     ADDSNEW       PSNEW                                        CSE045
     C                   ELSE                                                                 CSE045
     C                   MOVEL     BDDGMES       PGMES                                        CSE045
     C                   MOVEL     BDDGMEC       PGMEC                                        CSE045
     C                   MOVEL     BDDCCID       PCCID                                        CSE045
     C                   MOVEL     BDDSNEW       PSNEW                                        CSE045
     C                   ENDIF                                                                CSE045
      *                                                                                       CSE045
      ** Access Branch details via access program                                             CSE045
      *  (database error handling done in access program)                                     CSE045
     C                   MOVE      PTDBR         WDSNB                                        CSE045
     C**********         CALLB     'AOBRCHR0'                                          CSE045 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD                                        CSE045
     C**********         PARM      '*FIRST '     @OPTN                                 CSE045 243604
     C                   PARM      '*KEY   '     @OPTN                                        243604
     C                   PARM                    WDSNB             3                          CSE045
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 CSE045 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
                                                                                              CSE045
     C                   MOVE      A8BICN        WWBICN                                       CSE045
                                                                                              CSE045
     C                   EVAL      CrSEFilFmt = *Blanks                                       CSE045
     C     KEY001        CHAIN     TRADSDD2                           99                      CSE045
                                                                                              CSE045
     C                   CALLB     'SETSESDFT'                                                CSE045
      *                             =========                                                 CSE045
      *                                                                                       CSE045
      ** INPUT                                                                                CSE045
      ** =====                                                                                CSE045
      *                                                                                       CSE045
      ** Securities retrieved from file - file format                                         CSE045
     C                   PARM                    CrSEFilFmt                                   CSE045
                                                                                              CSE045
     C                   PARM                    PDATA                                        CSE045
                                                                                              CSE045
     C                   PARM                    CSE022                                       CSE045
                                                                                              CSE045
     C                   PARM                    CSE028                                       CSE045
                                                                                              CSE045
     C                   PARM                    SWRTN                                        CSE045
                                                                                              CSE045
     C                   PARM                    DFTFLG                                       CSE045
                                                                                              CSE045
     C**********         PARM                    WWBICN            6 0                 CSE045 CSD027
     C                   PARM                    WWBICN            6                          CSD027
                                                                                              CSE045
     C                   PARM                    PGMNAM                                       CSE045
     C                   PARM                    DDMRKT                                      BUG2274
     C                   PARM                    CSW206                                      CSW206E
      ** SWIFT 2010                                                                           CSW210
     C                   PARM                    CSW210                                       CSW210
      *                                                                                       CSE045
      ** OUTPUT                                                                               CSE045
      ** ======                                                                               CSE045
      *                                                                                       CSE045
      ** Securities screen 1 details retrieved from file - screen format                      CSE045
     C                   PARM                    NwSE1ScnFmt                                  CSE045
      *                                                                                       CSE045
      ** Initialise Clearance Type (1 to 4 is MT580 for Settlements)                          CSE045
      *                                                                                       CSE045
     C     PWHEN         IFNE      'B'                                                        CSE045
     C     PCLTY         OREQ      '1'                                                        CSE045
     C     PCLTY         OREQ      '3'                                                        CSE045
                                                                                              CSE045
     C     PCLTY         IFEQ      '1'                                                        CSE045
     C     PCLTY         OREQ      '2'                                                        CSE045
     C     PCLTY         OREQ      '3'                                                        CSE045
     C     PCLTY         OREQ      '4'                                                        CSE045
     C                   MOVE      '14'          WWCLTY                                       CSE045
     C                   ENDIF                                                                CSE045
                                                                                              CSE045
     C                   ELSE                                                                 CSE045
     C     PTDTP         IFEQ      'TP'                                                       CSE045
     C                   MOVE      PDELF         WCUST                                        CSE045
     C                   ELSE                                                                 CSE045
     C                   MOVE      PDELT         WCUST                                        CSE045
     C                   END                                                                  CSE045
                                                                                              CSE045
     C                   CALL      'AOSECSR0'                                                 CSE045
     C                   PARM      '*DBERR '     @RTCD                                        CSE045
     C                   PARM      '*KEY   '     @OPTN                                        CSE045
     C                   PARM                    WCUST             6                          CSE045
     C     SDSECS        PARM      SDSECS        DSSDY                                        CSE045
                                                                                              CSE045
     C     BFCLAS        IFEQ      'E'                                                        CSE045
     C     PCLTY         ANDEQ     '4'                                                        CSE045
     C     BFCLAS        OREQ      'E'                                                        CSE045
     C     PCLTY         ANDEQ     '5'                                                        CSE045
     C     BFCLAS        OREQ      'C'                                                        CSE045
     C     PCLTY         ANDEQ     '2'                                                        CSE045
     C     BFCLAS        OREQ      'C'                                                        CSE045
     C     PCLTY         ANDEQ     '5'                                                        CSE045
     C                   MOVE      '14'          WWCLTY                                       CSE045
     C                   ENDIF                                                                CSE045
                                                                                              CSE045
     C                   ENDIF                                                                CSE045
      *                                                                                       CSE045
      ** Set up trade type as opposite, if second record                                      CSE045
      *                                                                                       CSE045
     C     PWHEN         IFEQ      'B'                                                        CSE045
     C     PTDTP         IFEQ      'TP'                                                       CSE045
     C                   MOVE      'TS'          WTDTP                                        CSE045
     C                   ELSE                                                                 CSE045
     C                   MOVE      'TP'          WTDTP                                        CSE045
     C                   ENDIF                                                                CSE045
                                                                                              CSE045
     C                   ELSE                                                                 CSE045
     C                   MOVE      PTDTP         WTDTP                                        CSE045
     C                   ENDIF                                                                CSE045
                                                                                              CSE045
     C     ESRDefScn1    ENDSR                                                                CSE045
      *****************************************************************                       CSE045
      /EJECT                                                                                  CSE045
      *****************************************************************                       CSE045
      *                                                               *                       CSE045
      * ValdTrExSetA - Routine to validate Extended Settlements.      *                       CSE045
      *                                                               *                       CSE045
      *****************************************************************                       CSE045
     C     ValdTrExSetA  BEGSR                                                                CSE045
                                                                                              CSE045
      *                                                                                       CSE045
      ** Access Branch details via access program                                             CSE045
      *  (database error handling done in access program)                                     CSE045
     C                   MOVE      PTDBR         WDSNB                                        CSE045
     C**********         CALLB     'AOBRCHR0'                                          CSE045 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD                                        CSE045
     C**********         PARM      '*FIRST '     @OPTN                                 CSE045 243604
     C                   PARM      '*KEY   '     @OPTN                                        243604
     C                   PARM                    WDSNB             3                          CSE045
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 CSE045 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
                                                                                              CSE045
     C                   MOVE      A8BICN        WWBICN                                       CSE045
                                                                                              CSE045
     C                   MOVEL     DDCNUM        WCTPCN                                       CSE045
      *                                                                                       CSE045
      ** Retrieve classification of counterparty                                              CSE045
      *                                                                                       CSE045
     C                   CALL      'AOSECSR0'                                                 CSE045
     C                   PARM      '*DBERR '     @Rtcd                                        CSE045
     C                   PARM      '*KEY   '     @Optn                                        CSE045
     C                   PARM      WCTPCN        WCust                                        CSE045
     C     SDSECS        PARM      SDSECS        DSSDY                                        CSE045
      *                                                                                       CSE045
      ** Setup parameters to call module SEDORFRTV                                            CSE045
      *                                                                                       CSE045
     C     PTDTP         IFEQ      'TP'                                                       CSE045
      *                                                                                       CSE045
     C     BFCLAS        IFEQ      'M'                                                        CSE045
     C                   MOVEL     PDELT         PDEPO                                        CSE045
     C                   MOVEL     WWBICN        PCUST                                        CSE045
     C                   MOVEL     PDELT         PDEPO2                                       CSE045
     C                   ELSE                                                                 CSE045
     C                   MOVEL     PDELT         PDEPO                                        CSE045
     C                   MOVEL     DDCNUM        PCUST                                        CSE045
     C                   MOVEL     PDELT         PDEPO2                                       CSE045
     C                   ENDIF                                                                CSE045
                                                                                              CSE045
     C                   ELSE                                                                 CSE045
                                                                                              CSE045
     C     BFCLAS        IFEQ      'M'                                                        CSE045
     C                   MOVEL     PDELF         PDEPO                                        CSE045
     C                   MOVEL     WWBICN        PCUST                                        CSE045
     C                   MOVEL     PDELT         PDEPO2                                       CSE045
     C                   ELSE                                                                 CSE045
     C                   MOVEL     PDELF         PDEPO                                        CSE045
     C                   MOVEL     DDCNUM        PCUST                                        CSE045
     C                   MOVEL     PDELT         PDEPO2                                       CSE045
     C                   ENDIF                                                                CSE045
                                                                                              CSE045
     C                   ENDIF                                                                CSE045
      ** If CSE022 is installed then setup Safekeeping A/C Line by using module SEDORFRTV     CSE045
      *                                                                                       CSE045
     C     CSE022        IFEQ      'Y'                                                        CSE045
      *                                                                                       CSE045
     C                   CALL      PGMNAM                                                     CSE045
     C                   PARM      *BLANKS       PRETC                                        CSE045
     C                   PARM                    PDEPO                                        CSE045
     C                   PARM                    PCUST                                        CSE045
     C                   PARM      *BLANKS       PSKAL                                        CSE045
                                                                                              CSE045
     C     AESSKAN       IFEQ      *BLANKS                                                    CSE045
     C     AESSKAN       OREQ      '000000'                                                  243119A
     C     AESSKAN       OREQ      '0'                                                       243119A
     C                   MOVEL     PDEPO         AESSKAN                                      CSE045
     C                   END                                                                  CSE045
     C     AESSKAL       IFEQ      *BLANKS                                                    CSE045
     C                   MOVEL     PSKAL         AESSKAL                                      CSE045
     C                   END                                                                  CSE045
                                                                                              CSE045
     C                   CALL      PGMNAM                                                     CSE045
     C                   PARM      *BLANKS       PRETC                                        CSE045
     C                   PARM                    PDEPO2                                       CSE045
     C                   PARM                    PTCNR                                        CSE045
     C                   PARM      *BLANKS       PSKAL                                        CSE045
                                                                                              CSE045
     C     AESSA1N       IFEQ      *BLANKS                                                    CSE045
     C     AESSA1N       OREQ      '000000'                                                  243119A
     C     AESSA1N       OREQ      '0'                                                       243119A
     C                   MOVEL     PDEPO2        AESSA1N                                      CSE045
     C                   END                                                                  CSE045
     C     AESSA1L       IFEQ      *BLANKS                                                    CSE045
     C                   MOVEL     PSKAL         AESSA1L                                      CSE045
     C                   END                                                                  CSE045
                                                                                              CSE045
     C                   ENDIF                                                                CSE045
                                                                                              CSE045
     C     BFCLAS        IFNE      'S'                                                        CSE045
     C     BFCLAS        ANDNE     'D'                                                        CSE045
     C     BFCLAS        ANDNE     'I'                                                        CSE045
     C                   CALLB     'SETSESVAL'                                                CSE045
      *                             =========                                                 CSE045
      *                                                                                       CSE045
      ** Mode = '*FRONT' (front office transaction interface)                                 CSE045
      ** Mode = '      ' (not front office transaction interface)                             CSE045
      ** Mode = '*RPR  ' (repair function)                                                    CSE045
      ** Mode = '*SIN  ' (screen input function)                                              CSE045
     C                   PARM                    PMode                                        CSE045
      *                                                                                       CSE045
      ** Response mode                                                                        CSE045
     C                   PARM                    APRespMode                                   CSE045
      *                                                                                       CSE045
      ** Security API Trades Extended Settlement details from incoming transaction            CSE045
      ** - screen format                                                                      CSE045
     C                   PARM                    TranInExtA                                   CSE045
      *                                                                                       CSE045
      ** SWITCHABLE FEATURES                                                                  CSE045
      ** ===================                                                                  CSE045
      *                                                                                       CSE045
      ** MT5xx SSI Enhancements                                                               CSE045
     C                   PARM                    CSE028                                       CSE045
      *                                                                                       CSE045
      ** ERI Information for non-EMU users                                                    CSE045
     C                   PARM                    CSW014                                       CSE045
      *                                                                                       CSE045
      ** SWIFT 2001                                                                           CSE045
     C                   PARM                    CSW201                                       CSE045
      *                                                                                       CSE045
      ** CSW098                                                                               CSE045
     C                   PARM                    SWRTN                                        CSE045
      ** SWIFT 2006                                                                          CSW206E
     C                   PARM                    CSW206                                      CSW206E
      ** SWIFT 2010                                                                           CSW210
     C                   PARM                    CSW210                                       CSW210
      ** CFT004 - IBAN Numbers                                                                CSW210
     C                   PARM                    CFT004                                       CSW210
      *                                                                                       CSE045
      ** Other Parameters                                                                     CSE045
     C                   PARM                    PDATA                                        CSE045
                                                                                              CSE045
     C                   PARM                    WTDTP                                        CSE045
                                                                                              CSE045
     C                   PARM                    WWCLTY                                       CSE045
                                                                                              CSE045
     C                   PARM                    @ADDSAFA                                     CSE045
      *                                                                                       CSE045
      ** Function Keys                                                                        CSE045
     C                   PARM                    PINKS                                        CSE045
                                                                                              CSE045
     C                   PARM                    PINKT                                        CSE045
      *                                                                                       CSE045
      ** OUTPUT                                                                               CSE045
      ** ======                                                                               CSE045
      *                                                                                       CSE045
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE045
     C                   PARM                    FldNameArr                                   CSE045
     C                   PARM                    MsgIdArr                                     CSE045
     C                   PARM                    MsgDtaArr                                    CSE045
      *                                                                                       CSE045
      ** Array index (3P0) from/to caller                                                     CSE045
     C                   PARM                    IdX                                          CSE045
      *                                                                                       CSE045
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CSE045
     C                   PARM                    WFldNamArr                                   CSE045
     C                   PARM                    WMsgIdArr                                    CSE045
     C                   PARM                    WMsgDtaArr                                   CSE045
      *                                                                                       CSE045
      ** Array index (3P0) from/to caller                                                     CSE045
     C                   PARM                    WIdX                                         CSE045
      *                                                                                       CSE045
      ** Security API Trades Extended Settlements Error Indicators                            CSE045
     C                   PARM                    SEETES                                       CSE045
      *                                                                                       CSE045
      ** Security API Trades Extended Settlements Valid File                                  CSE045
     C                   PARM                    ValidTX2A                                    CSE045
     C                   END                                                                  CSE045
                                                                                              CSE045
     C                   ENDSR                                                                CSE045
      *****************************************************************                       CSE045
      /EJECT                                                                                  CSE045
      *****************************************************************                       CSE045
      *                                                               *                       CSE045
      * ValdTrExSetB - Routine to validate Extended Settlements.      *                       CSE045
      *                                                               *                       CSE045
      *****************************************************************                       CSE045
     C     ValdTrExSetB  BEGSR                                                                CSE045
                                                                                              CSE045
     C                   CALLB     'SETSESVAL'                                                CSE045
      *                             =========                                                 CSE045
      *                                                                                       CSE045
      ** Mode = '*FRONT' (front office transaction interface)                                 CSE045
      ** Mode = '      ' (not front office transaction interface)                             CSE045
      ** Mode = '*RPR  ' (repair function)                                                    CSE045
      ** Mode = '*SIN  ' (screen input function)                                              CSE045
     C                   PARM                    PMode                                        CSE045
      *                                                                                       CSE045
      ** Response mode                                                                        CSE045
     C                   PARM                    APRespMode                                   CSE045
      *                                                                                       CSE045
      ** Security API Trades Extended Settlement details from incoming transaction            CSE045
      ** - screen format                                                                      CSE045
     C                   PARM                    TranInExtB                                   CSE045
      *                                                                                       CSE045
      ** SWITCHABLE FEATURES                                                                  CSE045
      ** ===================                                                                  CSE045
      *                                                                                       CSE045
      ** MT5xx SSI Enhancements                                                               CSE045
     C                   PARM                    CSE028                                       CSE045
      *                                                                                       CSE045
      ** ERI Information for non-EMU users                                                    CSE045
     C                   PARM                    CSW014                                       CSE045
      *                                                                                       CSE045
      ** SWIFT 2001                                                                           CSE045
     C                   PARM                    CSW201                                       CSE045
      *                                                                                       CSE045
      ** CSW098                                                                               CSE045
     C                   PARM                    SWRTN                                        CSE045
      ** SWIFT 2006                                                                          CSW206E
     C                   PARM                    CSW206                                      CSW206E
      ** SWIFT 2010                                                                           CSW210
     C                   PARM                    CSW210                                       CSW210
      ** CFT004 - IBAN Numbers                                                                CSW210
     C                   PARM                    CFT004                                       CSW210
      *                                                                                       CSE045
      ** Other Parameters                                                                     CSE045
     C                   PARM                    PDATA                                        CSE045
                                                                                              CSE045
     C                   PARM                    WTDTP                                        CSE045
                                                                                              CSE045
     C                   PARM                    WWCLTY                                       CSE045
                                                                                              CSE045
     C                   PARM                    @BDDSAFA                                     CSE045
      *                                                                                       CSE045
      ** Function Keys                                                                        CSE045
     C                   PARM                    PINKS                                        CSE045
                                                                                              CSE045
     C                   PARM                    PINKT                                        CSE045
      *                                                                                       CSE045
      ** OUTPUT                                                                               CSE045
      ** ======                                                                               CSE045
      *                                                                                       CSE045
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE045
     C                   PARM                    FldNameArr                                   CSE045
     C                   PARM                    MsgIdArr                                     CSE045
     C                   PARM                    MsgDtaArr                                    CSE045
      *                                                                                       CSE045
      ** Array index (3P0) from/to caller                                                     CSE045
     C                   PARM                    IdX                                          CSE045
      *                                                                                       CSE045
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CSE045
     C                   PARM                    WFldNamArr                                   CSE045
     C                   PARM                    WMsgIdArr                                    CSE045
     C                   PARM                    WMsgDtaArr                                   CSE045
      *                                                                                       CSE045
      ** Array index (3P0) from/to caller                                                     CSE045
     C                   PARM                    WIdX                                         CSE045
      *                                                                                       CSE045
      ** Security API Trades Extended Settlements Error Indicators                            CSE045
     C                   PARM                    SEETES                                       CSE045
      *                                                                                       CSE045
      ** Security API Trades Extended Settlements Valid File                                  CSE045
     C                   PARM                    ValidTX2B                                    CSE045
                                                                                              CSE045
     C                   ENDSR                                                                CSE045
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************
     C     ValdateAmd    BEGSR
      *
      ** This subroutine calls a procedure which checks whether it
      ** was valid to Amend or Change any of the fields which have been
      ** altered.  Some are never amendable and some are amendable depending
      ** on the Action Code - "A" for Amend, "C" for Change.
 
      ** To determine what fields have changed, the current fields
      ** on file must be converted to a 'screen' format.
 
      ** These fields are then compared with the fields on the input
      ** transaction.
 
      ** Any errors detected by the called procedure take precedence
      ** over any errors found during the validation of the complete
      ** transaction.  The errors from the called procedure are kept
      ** separately and, if any are found, these errors will REPLACE
      ** the normal validation errors.
 
     C                   CALLB     'SETRADAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Incoming Trade in Screen Format :
 Form * - Primary Details
      * - Secondary Details
      * - Third Screen Details                                                                CAS006
      * - Exchange Rate Details
      * - Settlement Details
      * - Charge & Commission Details
      * - SWIFT Details A
      * - SWIFT Details B
     C                   PARM                    TraninPrim
     C                   PARM                    TraninSeco
     C                   PARM                    TraninThir                                   CAS006
     C                   PARM                    TraninExch
     C                   PARM                    TraninSett
     C                   PARM                    TraninChCm
     C                   PARM                    TraninSwfA
     C                   PARM                    TraninSwfB
      *
      * (Current) Trade in Screen Format :
 Form * - Primary Details
      * - Secondary Details
      * - Third Screen Details                                                                CAS006
      * - Exchange Rates Details
      * - Settlement Instructions
      * - Charges/Commissions
      * - SWIFT Details A
      * - SWIFT Details B
     C                   PARM                    CurTrPrim
     C                   PARM                    CurTrSeco
     C                   PARM                    CurTrThir                                    CAS006
     C                   PARM                    CurTrExch
     C                   PARM                    CurTrSett
     C                   PARM                    CurTrChCm
     C                   PARM                    CurTrSwftA
     C                   PARM                    CurTrSwftB
      *
      * Customer classification
      * Trade incomplete ind
      * Trade Date Made Complete
     C                   PARM                    CustClass
     C                   PARM                    TINC
     C                   PARM                    TDMC
                                                                                              CAS006
      ** Settlement Currency Decimal Places                                                   CAS006
                                                                                              CAS006
     C                   PARM                    SetCcyDec                                    CAS006
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
                                                                                              CAS006
     C                   PARM                    CAS006                                       CAS006
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKTrPrim
     C                   PARM                    OKTrSeco
     C                   PARM                    OKTrThir                                     CAS006
     C                   PARM                    OKTrExch
     C                   PARM                    OKTrSett
     C                   PARM                    OKTrChCm
     C                   PARM                    OKTrSwft
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
 
      ** If any errors overwrite previous error information
 
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Check/Write - Routine to control checking of error status and *
      *    sending of messgaes/writing to the database                *
      *                                                               *
      *****************************************************************
     C     CheckWrite    BEGSR
 
      *  If no errors were found:
      *  - If Action Code is Insert and Trade Reference is not supplied
      *     - set up the trade reference
      *  - If there are still no errors
      *     - set up additional data
      *     - write a record to the Valid file
      *     - use std message handler to report trade status
      *  If any errors were found:
      *  - write a record to the Invalid file
      *  - call the message handler to pass the errors back
      *  - use std message handler to report trade status
      *  The index to the error arrays is checked for presence/absence of
      *   errors
     
      ** +--- Note for a later release -------------------------------+
      ** |                                                            |
      ** | At a later date this routine will have to cater for        |
      ** | warning messages.  The following logic will have to be     |
      ** | inserted before "If no errors were found", in the          |
      ** | above comments (and the code):                             |
      ** |                                                            |
      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
      ** | any warning messages were returned (WIdx <> 0)             |
      ** |                                                            |
      ** | -   If errors exist                                        |
      ** |     -     Add the warning array index to the error array   |
      ** |           index                                            |
      ** |     -     Append the contents of the warning arrays to the |
      ** |           end of the error arrays                          |
      ** | -   Else                                                   |
      ** |     -     Set the error array index equal to the warning   |
      ** |           array index                                      |
      ** |     -     Copy the contents of the warning arrays to the   |
      ** |           error arrays                                     |
      ** | -   Endif                                                  |
      ** |                                                            |
      ** | Endif                                                      |
      ** |                                                            |
      ** | Note that the "If errors exist ... Else ... " block above  |
      ** | can probably be implemented unconditionally (ie the same   |
      ** | logic will apply whether errors exist as well as warnings  |
      ** | or not).  It is shown in the above form for clarity.       |
      ** |                                                            |
      ** +------------------------------------------------------------+
 
     C     Idx           IFEQ      0
 
     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUPTRADR
     C                   ENDIF
 
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   WRITE     SEVTRADD0
     C     S01401        IFEQ      'Y'
     C                   MOVE      ValidTX1A     ValidTrX1
     C                   EVAL      V_T1TDRF = V_TDRF
     C                   EVAL      V_T1FRNT = APFOTranID
     C                   EVAL      V_T1AFRT = APFOAsocID
     C                   EVAL      V_T1TMES = TimeStamp
     C                   WRITE     SEVTRX1PD0
     C                   MOVE      ValidTX1B     ValidTrX1
     C                   EVAL      V_T1TDRF = V_TDRF
     C                   EVAL      V_T1FRNT = APFOTranID
     C                   EVAL      V_T1AFRT = APFOAsocID
     C                   EVAL      V_T1TMES = TimeStamp
     C     V_T1WHEN      IFEQ      'B'
     C                   WRITE     SEVTRX1PD0
     C                   END
      *
      ** Write directly to the extension file.  The information held on                       CSE039
      *  the extension file is only used to update the Movement Status                        CSE039
      *  file and therefore it is not necessary to write to a valid file                      CSE039
     C     CSE039        IFEQ      'Y'                                                        CSE039
     C                   EVAL      T3TDRF = V_TDRF                                            CSE039
     C                   EVAL      T3INOR = DDINOR                                            CSE039
     C                   EVAL      T3MSGK = DDMSGK                                            CSE039
     C                   EVAL      T3NTMT = DDNTMT                                            CSE039
     C                   EVAL      T3FRNT = APFOTranID                                        CSE039
     C                   EVAL      T3AFRT = APFOAsocID                                        CSE039
     C                   EVAL      T3TMST = TimeStamp                                         CSE039
     C                   WRITE     TRADSDD3                                                   CSE039
     C                   ENDIF                                                                CSE039
      *
     C                   END
      *                                                                                       CSE045
      ** Write Valid Extended Settlements when Enhancement is available                       CSE045
      *                                                                                       CSE045
     C                   IF        CSE045 = 'Y'                                               CSE045
     C                   MOVE      ValidTX2A     ValidTrX2                                    CSE045
     C                   EVAL      V_T2TDRF = V_TDRF                                          CSE045
     C                   EVAL      V_T2FRNT = APFOTranID                                      CSE045
     C                   EVAL      V_T2AFRT = APFOAsocID                                      CSE045
     C                   EVAL      V_T2TMST = TimeStamp                                       CSE045
     C                   EVAL      V_T2WHEN = 'A'                                             CSE045
     C                   WRITE     SEVTRX2D0                                                  CSE045
     C                   MOVE      ValidTX2B     ValidTrX2                                    CSE045
     C                   EVAL      V_T2TDRF = V_TDRF                                          CSE045
     C                   EVAL      V_T2FRNT = APFOTranID                                      CSE045
     C                   EVAL      V_T2AFRT = APFOAsocID                                      CSE045
     C                   EVAL      V_T2TMST = TimeStamp                                       CSE045
     C     V_T2WHEN      IFEQ      'B'                                                        CSE045
     C                   WRITE     SEVTRX2D0                                                  CSE045
     C                   ENDIF                                                                CSE045
     C                   ENDIF                                                                CSE045
                                                                                              CSE045
     C                   EXSR      CallMsgHdl
     C                   ENDIF
 
     C                   ENDIF
 
     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *                                                                         CAP004
      * Only write to invalid files if repair in back office                    CAP004
      *                                                                         CAP004
     C     APRprLocn     IFEQ      'B'                                          CAP004
     C                   WRITE     SEITRADD0
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed                                              CSC011
      ** and Support System is active                                                         CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TranInPrim                                      CSC011
     C                                        + TranInSeco                                    CSC011
     C                                        + TranInExch                                    CSC011
     C                                        + TranInSett                                    CSC011
     C                                        + TranInChCm                                    CSC011
     C                                        + TranInSwfA                                    CSC011
     C                                        + TranInSwfB                                    CSC011
     C                                        + TranInThir                                    CAS006
     C                                        + InfData                                       CSC011
     C                                        + RegData                                       CER001
     C                                        + ExtData                                       CSC011
     C                   EVAL      APTGTTYPE = 'SETRAD'                                       CSC011
     C                   MOVEL     TDRF          PDealNo                                      CSC011
                                                                                              CSC011
      ** If there is no error, write the log file                                             CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   Parm      *Blanks       RetCodeOut                                   CSC011
     C                   Parm                    HeadIn                                       CSC011
     C                   Parm                    TRANSDTL                                     CSC011
     C                   Parm                    Timestamp                                    CSC011
     C                   Parm                    PDealNo                                      CSC011
     C                   Parm      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
      ** If there is an error in either log file, end program                                 CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   MOVE      PDealNo       DBKEY                                        CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBASE = 2                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                  CAP004
     C                   EXSR      CallMsgHdl
     C                   ENDIF
 
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
 
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx
 
     C                   RESET                   FldNoArr
 
     C                   CLEAR                   CurTrPrim
     C                   CLEAR                   CurTrSeco
     C                   CLEAR                   CurTrThir                                    CAS006
     C                   CLEAR                   CurTrExch
     C                   CLEAR                   CurTrSett
     C                   CLEAR                   CurTrChcm
     C                   CLEAR                   CurTrSwftA
     C                   CLEAR                   CurTrSwftB
 
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVE      *ALL'Y'       OKTrSeco
     C                   MOVE      *ALL'Y'       OKTrThir                                     CAS006
     C                   MOVE      *ALL'Y'       OKTrExch
     C                   MOVE      *ALL'Y'       OKTrSett
     C                   MOVE      *ALL'Y'       OKTrChcm
     C                   MOVE      *ALL'Y'       OKTrSwft
 
     C                   CLEAR                   ValidTrad
     C                   CLEAR                   ValidTX1A
     C                   CLEAR                   ValidTX1B
     C                   CLEAR                   ValidTX2A                                    CSE045
     C                   CLEAR                   ValidTX2B                                    CSE045
      *                                                                                       CAP067
      ** Also clear numeric variables                                                         CAP067
      *                                                                                       CAP067
     C                   EXSR      SRCLER                                                     CAP067
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CAP067
      *****************************************************************                       CAP067
      *                                                               *                       CAP067
      * SRCLER - Clear numeric variables                              *                       CAP067
      *                                                               *                       CAP067
      *****************************************************************                       CAP067
     C     SRCLER        BEGSR                                                                CAP067
                                                                                              CAP067
     C**********         Z-ADD     0             V_TCNR                                CAP067 CSD027
     C                   EVAL      V_TCNR = *BLANKS                                           CSD027
     C                   Z-ADD     0             V_NOML                                       CAP067
     C                   Z-ADD     0             V_TNMD                                       CAP067
     C                   Z-ADD     0             V_TPDY                                       CAP067
     C                   Z-ADD     0             V_TDVD                                       CAP067
     C                   Z-ADD     0             V_TDDT                                       CAP067
     C                   Z-ADD     0             V_TCAP                                       CAP067
     C                   Z-ADD     0             V_DADJ                                       CAP067
     C                   Z-ADD     0             V_ITRA                                       CAP067
     C                   Z-ADD     0             V_TINA                                       CAP067
     C                   Z-ADD     0             V_TDCR                                       CAP067
     C                   Z-ADD     0             V_PRIC                                       CAP067
     C                   Z-ADD     0             V_RALL                                       CAP067
     C                   Z-ADD     0             V_TDER                                       CAP067
     C                   Z-ADD     0             V_TBCR                                       CAP067
     C                   Z-ADD     0             V_SMTH                                       CAP067
     C                   Z-ADD     0             V_ASNM                                       CAP067
     C**********         Z-ADD     0             V_DELT                                CAP067 CSD027
     C**********         Z-ADD     0             V_DELF                                CAP067 CSD027
     C                   EVAL      V_DELT = *BLANKS                                           CSD027
     C                   EVAL      V_DELF = *BLANKS                                           CSD027
     C                   Z-ADD     0             V_TBCA                                       CAP067
     C                   Z-ADD     0             V_TCCA                                       CAP067
     C                   Z-ADD     0             V_TCA1                                       CAP067
     C                   Z-ADD     0             V_TCA2                                       CAP067
     C                   Z-ADD     0             V_TCA3                                       CAP067
     C                   Z-ADD     0             V_TCA4                                       CAP067
     C                   Z-ADD     0             V_TCA5                                       CAP067
     C                   Z-ADD     0             V_TCA6                                       CAP067
     C                   Z-ADD     0             V_TCA7                                       CAP067
     C                   Z-ADD     0             V_TAXA                                       CAP067
     C                   Z-ADD     0             V_BCMR                                       CAP067
     C                   Z-ADD     0             V_CCMR                                       CAP067
     C                   Z-ADD     0             V_TXRB                                       CAP067
     C                   Z-ADD     0             V_TIME                                       CAP067
     C                   Z-ADD     0             V_TOSN                                       CAP067
     C                   Z-ADD     0             V_TNSN                                       CAP067
     C                   Z-ADD     0             V_TNSP                                       CAP067
     C                   Z-ADD     0             V_TOSV                                       CAP067
     C                   Z-ADD     0             V_TVSN                                       CAP067
     C                   Z-ADD     0             V_TVSP                                       CAP067
     C                   Z-ADD     0             V_TDSN                                       CAP067
     C                   Z-ADD     0             V_TDSP                                       CAP067
     C                   Z-ADD     0             V_TDFS                                       CAP067
     C                   Z-ADD     0             V_TSSQ                                       CAP067
     C                   Z-ADD     0             V_TCSR                                       CAP067
     C                   Z-ADD     0             V_TCTR                                       CAP067
     C                   Z-ADD     0             V_TDMC                                       CAP067
     C                   Z-ADD     0             V_TOED                                       CAP067
     C                   Z-ADD     0             V_LCD                                        CAP067
     C                   Z-ADD     0             V_TNLU                                       CAP067
     C                   Z-ADD     0             V_LSWS                                       CAP067
     C                   Z-ADD     0             V_TCFC                                       CAP067
     C                   Z-ADD     0             V_SPXR                                       CAP067
     C                   Z-ADD     0             V_FXMP                                       CAP067
     C                   Z-ADD     0             V_FXMR                                       CAP067
     C                   Z-ADD     0             V_MAMT                                       CAP067
     C                   Z-ADD     0             V_ORDE                                       CAP067
     C                   Z-ADD     0             V_WHTX                                       CAP067
     C                   Z-ADD     0             V_ITRN                                       CAS006
     C                   Z-ADD     0             V_TINN                                       CAS006
     C                   Z-ADD     0             V_PRICN                                      CAS006
     C                   Z-ADD     0             VA_T1LSWS                                    CAP067
     C                   Z-ADD     0             VA_T1LSSC                                    CAP067
     C                   Z-ADD     0             VB_T1LSWS                                    CAP067
     C                   Z-ADD     0             VB_T1LSSC                                    CAP067
                                                                                              CAP067
     C                   ENDSR                                                                CAP067
      *****************************************************************                       CAP067
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPINVAL - Set up additional fields that are needed on the  *
      *        Valid file record.                                     *
      *                                                               *
      *****************************************************************
     C     SETUPINVAL    BEGSR
 
      * Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DDFOtranID = APFOTranID
     C                   EVAL      DDFOAsocID = APFOAsocID
     C                   EVAL      DDRprLocn  = APRprLocn
     C                   EVAL      DDTMESTMP = TimeStamp
                                                                                CAP051
      * Setup the Automatic Autorisation Flag                                   CAP051
     C                   IF        CAP051 = 'Y'                                 CAP051
     C                   EVAL      DDAUTHA    = AUTHA                           CAP051
     C                   ENDIF                                                  CAP051
 
     C                   EVAL      TranStatus = 'F'
 
      /COPY WNCPYSRC,SETRADC014
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPTRADR - Set up Trade Reference for Inserts               *
      *                                                               *
      *****************************************************************
     C     SETUPTRADR    BEGSR
 
     C                   IF           DDTDRF = *blanks
     C                             OR DDTDRF = *zeros
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZATRNRTV'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      'SE'          MODU              2
     C                   PARM      'T'           TRTY              1
     C                   PARM                    DDTDRF
     C                   PARM      *ZERO         V_TDRF
 
     C     ReturnCode    IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTDRF'
     C                   EVAL      MsgIDArr(Idx) = 'ZATRNRTV'
     C                   ENDIF
 
      ** If trade reference was entered, put it in the file field
     C                   ELSE
     C                   MOVE      DDTDRF        V_TDRF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  210517
      *****************************************************************                       210517
      *                                                               *                       210517
      *  SRDfltTrX2A - Set up the default for TRADSDX2 for screen A   *                       210517
      *                                                               *                       210517
      *****************************************************************                       210517
     C     SRDfltTrX2A   BEGSR                                                                210517
                                                                                              210517
     C                   CALLB     'SETSWX2DFT'                                               210517
                                                                                              210517
      ** Screen (A or B)                                                                      210517
                                                                                              210517
     C                   PARM      'A'           Screen                                       210517
                                                                                              210517
      ** Trade Details (screen)                                                               210517
                                                                                              210517
     C                   PARM                    DDTDRF                                       210517
     C                   PARM                    DDTDTP                                       210517
     C                   PARM                    DDCNUM                                       210517
     C                   PARM                    DDSESN                                       210517
     C                   PARM                    DDBRCD                                       210517
     C                   PARM                    DDDELF                                       210517
     C                   PARM                    DDDELT                                       210517
     C                   PARM                    DDBPBK                                       210517
     C                   PARM                    DDSETC                                       210517
     C                   PARM                    DDMRKT                                       210517
                                                                                              210517
      ** OUTPUT PARAMETERS :                                                                  210517
      ** Screen A details                                                                     210517
                                                                                              210517
     C                   PARM                    TradSwX2A                                    210517
                                                                                              210517
      ** Screen B details                                                                     210517
                                                                                              210517
     C                   PARM                    TradSwX2B                                    210517
                                                                                              210517
     C                   ENDSR                                                                210517
      *****************************************************************                       210517
      /EJECT                                                                                  210517
      *****************************************************************                       210517
      *                                                               *                       210517
      *  SRDfltTrX2B - Set up the default for TRADSDX2 for screen B   *                       210517
      *                                                               *                       210517
      *****************************************************************                       210517
     C     SRDfltTrX2B   BEGSR                                                                210517
                                                                                              210517
     C                   CALLB     'SETSWX2DFT'                                               210517
                                                                                              210517
      ** Screen (A or B)                                                                      210517
                                                                                              210517
     C                   PARM      'B'           Screen                                       210517
                                                                                              210517
      ** Trade Details (screen)                                                               210517
                                                                                              210517
     C                   PARM                    DDTDRF                                       210517
     C                   PARM                    DDTDTP                                       210517
     C                   PARM                    DDCNUM                                       210517
     C                   PARM                    DDSESN                                       210517
     C                   PARM                    DDBRCD                                       210517
     C                   PARM                    DDDELF                                       210517
     C                   PARM                    DDDELT                                       210517
     C                   PARM                    DDBPBK                                       210517
     C                   PARM                    DDSETC                                       210517
     C                   PARM                    DDMRKT                                       210517
                                                                                              210517
      ** OUTPUT PARAMETERS :                                                                  210517
      ** Screen A details                                                                     210517
                                                                                              210517
     C                   PARM                    TradSwX2A                                    210517
                                                                                              210517
      ** Screen B details                                                                     210517
                                                                                              210517
     C                   PARM                    TradSwX2B                                    210517
                                                                                              210517
     C                   ENDSR                                                                210517
      *****************************************************************                       210517
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
     C     SETUPVALID    BEGSR
 
      * For Deletes & Authorises, put the complete (pre-existing) trade
      *  into the Valid file record
     C                   IF           DDACTN = 'D'
     C                             OR DDACTN = 'P'
     C                             OR DDACTN = 'Y'
     C                   MOVE      TradFilFmt    ValidTrad
     C                   MOVE      TX1AFilFmt    ValidTX1A
     C                   MOVE      TX1BFilFmt    ValidTX1B
     C                   ENDIF
 
      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      V_CHTP = DDACTN
 
      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      V_FRNT = APFOTranID
     C                   EVAL      V_AFRT = APFOAsocID
     C                   EVAL      V_REPA = APRprLocn
     C                   EVAL      V_TMST = TimeStamp
                                                                                CAP051
      * Automatic Authorisation flag                                            CAP051
     C                   IF        CAP051 = 'Y'                                 CAP051
     C                   EVAL      V_AUTH = AUTHA                               CAP051
     C                   ENDIF                                                  CAP051
 
     C                   EVAL      TranStatus = 'S'
 
      /COPY WNCPYSRC,SETRADC015
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CallMsgHdl - Call the Message Handling module                 *
      *                                                               *
      *****************************************************************
     C     CallMsgHdl    BEGSR
 
      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors
 
     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax
 
     C     FldNameArr(Ix)IFNE      *BLANKS
 
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
 
     C                   ELSE
 
     C                   LEAVE
 
     C                   ENDIF
 
     C                   ADD       1             Ix
     C                   ENDDO
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Deal repair location (1A, from caller)
     C                   PARM                    APRprLocn
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCnfValFO
      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      ** Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTranID
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ** Midas transaction ID (6A, from caller)
     C                   PARM                    DDTDRF
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRespMode
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      ** The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
      ** The transaction's timestamp
     C                   PARM                    TimeStamp
      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      ** Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002
     C                   PARM                    Trans5003
     C                   PARM                    Trans5004
     C                   PARM                    Trans5005
     C                   PARM                    Trans5006
     C                   PARM                    Trans5007
     C****************** PARM                    Trans5008                      CAP051
     C                   PARM                    Trans5008                                    CAS006
     C                   PARM                    OthrData                                    CSF011A
     C                   PARM                    InfData500                     CAP051
     C                   PARM                    RegData500                                   CER001
     C                   PARM                    ExtData500                     CAP004
     C**********         PARM                    OthDData4755                         CSE045 CSF011A
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
 
      ** Set up the name of the primary and secomdary message files from
      ** which the message handler will get the messages
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
 
      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'SE'
 
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
                                                                                CAP011
      ** Access API ICD via access program                                      CAP011
      *  (database error handling done in access program)                       CAP011
     C                   CALLB     'AOAPIR0'                                    CAP011
     C                   PARM      '*DBERR '     @RTCD                          CAP011
     C                   PARM      '*FIRST '     @OPTN                          CAP011
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
      *
      ** Access Securities Trading details via access program
      *  (database error handling done in access program)
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access Portfolio Management details via access program
      *  (database error handling done in access program)
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   ENDIF
      *
      ** Access SAR details file to determine if MT5XX Message
      ** Generation enhancement is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01401'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01401            1
     C                   ELSE
     C                   MOVEL     'N'           S01401
     C                   END
      *
      ** Access SAR details file to determine if Customer Commissions
      ** (courtage) enhancement is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01446'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01446            1
     C                   ELSE
     C                   MOVEL     'N'           S01446
     C                   END
      *
      ** Access SAR details file to determine if Private Banking
      ** securities enhancements is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01496'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01496            1
     C                   ELSE
     C                   MOVEL     'N'           S01496
     C                   END
      *
      ** Access SAR details file to determine if MT5XX Message
      ** Generation enhancement phase 2 is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW003'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSW003            1
     C                   ELSE
     C                   MOVEL     'N'           CSW003
     C                   END
      *
      ** Access SAR details file to determine if TOF/Midas
      ** Interface is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP050'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP050            1
     C                   ELSE
     C                   MOVEL     'N'           CAP050
     C                   END
      *
      ** Access SAR details file to determine if EMU SE
      ** Settlement Currency Conversion is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU005'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU005            1
     C                   ELSE
     C                   MOVEL     'N'           CEU005
     C                   END
      *                                                                         CAP051
      ** Access SAR details file to determine if                                CAP051
      ** Automatic Authorisation (SE Part) is installed                         CAP051
      *                                                                         CAP051
     C                   MOVEL     'N'           CAP051            1            CAP051
     C                   CALL      'AOSARDR0'                                   CAP051
     C                   PARM      *BLANKS       @RTCD                          CAP051
     C                   PARM      '*VERIFY'     @OPTN                          CAP051
     C                   PARM      'CAP051'      @SARD                          CAP051
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
      *                                                                         CAP051
     C     @RTCD         IFEQ      *BLANK                                       CAP051
     C                   MOVEL     'Y'           CAP051                         CAP051
     C                   ENDIF                                                  CAP051
                                                                                              CSW201
      ** Check if CSW201 - Swift 2001 Standards Update is installed                           CSW201
                                                                                              CSW201
     C                   CALL      'SWIF2001'                           9090                  CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
                                                                                              CSW201
     C                   IF        *IN90 = *OFF AND @RTCD = 'CSW2001'                         CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
                                                                                             CSW206E
     C                   CALL      'SWIF2006'                                                CSW206E
     C                   PARM      *BLANKS       PRTCD                                       CSW206E
                                                                                             CSW206E
     C                   IF        PRTCD = 'CSW2006'                                         CSW206E
     C                   EVAL      CSW206 = 'Y'                                              CSW206E
     C                   ELSE                                                                CSW206E
     C                   EVAL      CSW206 = 'N'                                              CSW206E
     C                   ENDIF                                                               CSW206E
      *                                                                                       CSE028
      ** Check if CSE028 feature is installed                                                 CSE028
      *                                                                                       CSE028
     C                   CALLB     'AOSARDR0'                                                 CSE028
     C                   PARM      *BLANKS       @RTCD                                        CSE028
     C                   PARM      '*VERIFY'     @OPTN                                        CSE028
     C                   PARM      'CSE028'      @SARD                                        CSE028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE028
     C     @RTCD         IFEQ      *BLANK                                                     CSE028
     C                   MOVEL     'Y'           CSE028            1                          CSE028
     C                   ELSE                                                                 CSE028
     C                   MOVEL     'N'           CSE028                                       CSE028
     C                   ENDIF                                                                CSE028
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
      *                                                                                       CSE045
      ** Check if CSE045 feature is installed                                                 CSE045
      *                                                                                       CSE045
     C                   CALLB     'AOSARDR0'                                                 CSE045
     C                   PARM      *BLANKS       @RTCD                                        CSE045
     C                   PARM      '*VERIFY'     @OPTN                                        CSE045
     C                   PARM      'CSE045'      @SARD                                        CSE045
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE045
     C     @RTCD         IFEQ      *BLANK                                                     CSE045
     C                   MOVEL     'Y'           CSE045            1                          CSE045
     C                   ELSE                                                                 CSE045
     C                   MOVEL     'N'           CSE045                                       CSE045
     C                   ENDIF                                                                CSE045
      *                                                                                       CSE045
      ** Access SAR file to determine if CSE022 is installed                                  CSE045
      *                                                                                       CSE045
     C                   CALLB     'AOSARDR0'                                                 CSE045
     C                   PARM      *BLANKS       @RTCD                                        CSE045
     C                   PARM      '*VERIFY'     @OPTN                                        CSE045
     C                   PARM      'CSE022'      @SARD                                        CSE045
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE045
                                                                                              CSE045
     C                   IF        @RTCD = *BLANK                                             CSE045
     C                   EVAL      CSE022 = 'Y'                                               CSE045
     C                   EVAL      PGMNAM = 'SEDORFRTV'                                       CSE045
     C                   ELSE                                                                 CSE045
     C                   EVAL      CSE022 = 'N'                                               CSE045
     C                   ENDIF                                                                CSE045
      *                                                                                       CSE045
      ** Access SAR file to determine if CSW014 is installed                                  CSE045
      *                                                                                       CSE045
     C                   CALLB     'AOSARDR0'                                                 CSE045
     C                   PARM      *BLANKS       @RTCD                                        CSE045
     C                   PARM      '*VERIFY'     @OPTN                                        CSE045
     C                   PARM      'CSW014'      @SARD                                        CSE045
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE045
                                                                                              CSE045
     C                   IF        @RTCD = *BLANK                                             CSE045
     C                   EVAL      CSW014 = 'Y'                                               CSE045
     C                   ELSE                                                                 CSE045
     C                   EVAL      CSW014 = 'N'                                               CSE045
     C                   ENDIF                                                                CSE045
      *                                                                                       CSE045
      ** Check to see if switchable feature CSW098 is on or if date is                        CSE045
      ** greater than 16 October 1998.                                                        CSE045
      *                                                                                       CSE045
     C                   CALL      'SWIFT98'                            99                    CSE045
     C                   PARM                    SWRTN                                        CSE045
                                                                                              CSE045
 
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 1                                                  CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Check if enhancement CAS006 (Hedge Accounting Phase B) is installed                  CAS006
                                                                                              CAS006
     C                   CALLB     'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRTCD                                        CAS006
     C                   PARM      '*VERIFY'     POPTN                                        CAS006
     C                   PARM      'CAS006'      PSARD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRTCD = *BLANKS                                            CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APTRADDTQ'
 
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
     C                   EVAL      DBASE = 3                                                  CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
      *                                                                                       CGL031
      ** Access SAR details file to determine if CGL031                                       CGL031
      ** (Taxation of Savings Income) is on.                                                  CGL031
      *                                                                                       CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       @RTCD                                        CGL031
     C                   PARM      '*VERIFY'     @OPTN                                        CGL031
     C                   PARM      'CGL031'      @SARD             6                          CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
     C     @RTCD         IFNE      *BLANKS                                                    CGL031
     C     @RTCD         ANDNE     '*NRF   '                                                  CGL031
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL031
     C                   MOVEL     '901'         DBASE                                        CGL031
     C                   MOVEL     'CGL031'      DBKEY                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
      *                                                                                       CGL031
     C     @RTCD         IFEQ      *BLANK                                                     CGL031
     C                   MOVEL     'Y'           CGL031                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVEL     'N'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
      *                                                                                       CGL031
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
      /COPY WNCPYSRC,SETRADC019
      *                                                                                       CER001
      ** ULX603 - API Luxembourg - Function SETRAD                                            CER001
      *                                                                                       CER001
     C                   EVAL      ULX603 = 'N'                                               CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX603'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD=*BLANKS                                              CER001
     C                             AND BGLRIN = 'Y'                                           CER001
     C                   EVAL      ULX603 = 'Y'                                               CER001
     C                   OPEN      SEVTDLX1PD                                                 CER001
     C                   OPEN      SEITDLX1PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX008 - API Commissariat Aux Bourses (Funct. SEDPMV/SETRAD)                         CER001
      *                                                                                       CER001
     C                   EVAL      ULX008 = 'N'                                               CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX008'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   EVAL      ULX008 = 'Y'                                               CER001
     C                   ENDIF                                                                CER001
 
      *                                                                                       CSW210
      ** Check to see if switchable feature CSW210 is on or if date is                        CSW210
      ** equal or greater than 20 November 2010.                                              CSW210
      *                                                                                       CSW210
     C                   CALL      'SWIF2010'                                                 CSW210
     C                   PARM      *BLANKS       PRTCD                                        CSW210
                                                                                              CSW210
     C                   IF        PRTCD = 'CSW2010'                                          CSW210
     C                   EVAL      CSW210 = 'Y'                                               CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      CSW210 = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** Check to see if switchable feature CFT004 in on.                                     CSW210
      *                                                                                       CSW210
     C                   CALLB     'AOSARDR0'                                                 CSW210
     C                   PARM      *BLANKS       PRtCd                                        CSW210
     C                   PARM      '*VERIFY'     POptn                                        CSW210
     C                   PARM      'CFT004'      PSARD                                        CSW210
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW210
                                                                                              CSW210
     C                   EVAL      CFT004 = 'N'                                               CSW210
                                                                                              CSW210
     C                   IF        PRtCd = *BLANKS                                            CSW210
     C                   EVAL      CFT004 = 'Y'                                               CSW210
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
     C                   IF        PRtCd <> '*NRF   '                                         CSW210
     C     *LOCK         IN        LDA                                                        CSW210
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSW210
     C                   EVAL      DBKey = PSARD                                              CSW210
     C                   EVAL      DBase = 913                                                CSW210
     C                   OUT       LDA                                                        CSW210
     C                   EXSR      *PSSR                                                      CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
