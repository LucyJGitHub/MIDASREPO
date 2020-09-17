     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Invalid trades repair')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADRPR - INVALID SECURITY TRADES SCREEN INPUT             *
      *                                                               *
      *  Function:  This function allows invalid securities trades to *
      *             be 'repaired' and applied to the Midas database.  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR698195B          Date 20Jan11               *
      *                 CSW210             Date 04May10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22911           Date 17Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244240             Date 21Jul06               *
      *                 233881             Date 02Jun05               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 17Aug05               *
      *                 BUG9617            Date 14Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 229342             Date 02Sep04               *
      *                 206651             Date 18Jun02               *
      *                 BUG3145            Date 15Jun04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CSE045             Date 24Mar03               *
      *                 222373             Date 23Oct03               *
      *                 CSE039             Date 31Mar03               *
      *                 CSE037             Date 29Apr02               *
      *                 CAS006             Date 21Jan03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210517             Date 21Nov02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 211682             Date 07Nov02               *
      *                 200459             Date 22Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE034             Date 23Apr02               *
      *                 CPK015             Date 10Apr02               *
      *                 CSE031             Date 13Dec01               *
      *                 CSC011             Date 18Sep01               *
      *                 201429             Date 15Jan02               *
      *                 201233             Date 20Dec01               *
      *                 CAP067             Date 24Sep01               *
      *                 199797             Date 01Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CPK014             Date 02Oct01               *
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
      *                 174875             Date 02Mar00               *
      *                 166907             Date 27Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 16Nov99               *
      *                 CPB001             Date 01Jun99               *
      *                 CAP014             Date 29Nov99               *
      *                 CAP013             Date 07Sep99               *
      *                 CAP011             Date 07Sep99               *
      *                 168345             Date 14Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 15Mar99               *
      *                 154562             Date 01Feb99               *
      *                 154208             Date 27Jan99               *
      *                 CAP004             Date 01Sep98               *
      *                 140951             Date 27AUG98               *
      *                 CAP050             Date 28Jul98               *
      *                 CAP003  *CREATE    Date 29May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
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
      *  244240 - Apply same correction as 235547 to make parameter   *
      *           list match with SETRADSVAL parameter entry list.    *
      *           Apply 233881 correction.                            *
      *  233881 - EU Tax amount should be subtracted from the         *
      *           Countervalue.                                       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087  - Enable the use of SETRADVU to process Buy/Sell     *
      *            trades.                                            *
      *  BUG9617- Action 'N' updates the database file even with      *
      *           Errors                                              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation for Savings Income                         *
      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  229342 - Customer Report Name is not displayed.              *
      *  206651 - Security Report Name is not displayed during Insert *
      *  BUG3145 - Charges and Commission are being missed out of the *
      *            calculation of countervalue.                       *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *  222373 - Parameter Mismatches                                *
      *  CSE039 - Auto-settlement of Trades                           *
      *  CSE037 - Bond Pricing - 3 Decimal Places in Trades Input     *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  210517 - Missing TRADSDX2 record from the API                *
      *  211682 - SETRADRPR doesnt display the error message in       *
      *           SETRADEDSP screen                                   *
      *  200459 - Current factor not applied to countervalue for 'MP' *
      *           Securities.  Add checking to SEDEV for new current  *
      *           factor and if it exists, use it in calculating the  *
      *           countervalue.  Amended to be consistent with SE0050.*
      *  CSE034 - Standard Settlement Instruction improvements        *
      *  CPK015 - Renumbered duplicated hook SETRADR014 so that the   *
      *           CUP009 hook is now called SETRADR016.               *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSC011 - 24x7 Midas Availability                             *
      *  201429 - New validation needed for ISO15022 in               *
      *           extended settlement screen.                         *
      *  201233 - If message is unroutable, settlement of message     *
      *           request cannot be a 'Y'.                            *
      *  CAP067 - Repurchase Agreements API.                          *
      *  199797 - Additional changes and fixes for CSE028 (SSIs).     *
      *  CPK014 - Release 4 Packaging                                 *
      *         - Fix parameter mismatch                              *
      *  CSE028 - Standing Settlement Instructions Enhancement        *
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
      *           Override" missed at SWIFT 98 change. Compile only   *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *  174875 - Window processing                                   *
      *  166907 - Display 'Deal No. 999999 successfully inserted.'    *
      *           in the correct screen.                              *
      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *         - 'Private Banking' Module                            *
      *  CAP014 - Repair function enhancements                        *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  168345 - Prevent two users from accessing same transaction   *
      *           in repair screen at the same cycle, and converting  *
      *           it into two different Midas Deal No.s  .            *
      *           Second user should not be allowed to repair the tran-
      *           saction and convert it into a another Midas Deal.   *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *  154562 - Only 1 record is needed on TRADSDX1 if CSW003 is off*
      *  154208 - Errors in field defaulting                          *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *           Remove MSGTYPE field as not needed.                 *
      *  140951 - Addition of F14 key to access Ext. Settlements.     *
      *  CAP050 - Midas/ToF Interface                                 *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FSEITRADL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEITRADD0 : SEITRADX0)
     FSEITRADL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FSETRADL0  IF   E           K DISK    INFSR(*PSSR)                                       CAP067
     F                                                                                        CAP067
     FTRADSDX3  UF A E           K DISK    INFSR(*PSSR)                                       CSE039
     F                                     COMMIT                                             CSE039
      *
     FSECTY     IF   E           K DISK    INFSR(*PSSR)                                       206651
     F                                     PREFIX(SC_)                                        206651
 
      ** API Invalid Log File                                                                 CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
                                                                                              CSC011
     FSEITDLX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     RENAME(SEITDLXD6:RTVIDX1)                          CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SETRADR011
 
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
 
     D @EI             S              1    DIM(60)
 
      * Invalid Trade in Screen Format - SWIFT Details
     D InvTrSwftA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(A)
      * Invalid Trade in Screen Format - SWIFT Details
     D InvTrSwftB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(B)
 
 
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
     D NT2AFilFmt    E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
     D                                     PREFIX(A_)                                         CSE045
     D NT2BFilFmt    E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
     D                                     PREFIX(B_)                                         CSE045
 
 
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
 
     D NewTrExtA     E DS                  EXTNAME(SETESDPD)                                  CSE045
     D                                     PREFIX(A_)                                         CSE045
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
     D*SECTY****     E DS                  EXTNAME(SECTYD)                                    206651
     D SECTY2        E DS                  EXTNAME(SECTYD)                                    206651
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
 
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)                                  CAP067
      ** Book Details                                                                         CAP067
                                                                                              CAP067
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** EXTERNAL DS FOR API ICD                                                CAP011
                                                                                CAP011
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(SETDEXPD)                    CAP004
      * SE Trades Extra Data - File (D/B) format                                CAP004
                                                                                229342
     D DSLDY         E DS                  EXTNAME(DSLDY)                       229342
      ** FIRST DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                      229342
                                                                                229342
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    229342
      ** EXTERNAL DS FOR BANK DETAILS                                           229342
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SDSTAT data area                                                                     CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** TRADSDX2 record                                                                      210517
     D PTradeX2      E DS                  EXTNAME(TRADSDX2)                                  210517
     D                                     PREFIX(X2:2)                                       210517
                                                                                              210517
      ** Current Trade (invalid) in Screen Format                                             CER001
     D NwDlScnFmt    E DS                  EXTNAME(SETDRXPD)                                  CER001
      ** New Trade in File Format (#6LXCC)                                                    CER001
     D NwDlFilFmt    E DS                  EXTNAME(SEVTDLX1PD)                                CER001
      ** Current Trade in File Format (VL)                                                    CER001
     D CrDlFilFmt    E DS                  EXTNAME(SETRX1PD)                                  CER001
     D PMCWL           DS          9999                                                       CSD015
      ** Additional entry parameter for Midas Compliance Watch                                CSD015
                                                                                              CSD015
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
                                                                                              CSC022
     D/COPY QWINDSRC,SETRADGDTA                                                 174875
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('SETRADPD')
 
     D FieldP          S             10A   INZ('DDACTN')
     D FieldS          S             10A   INZ('DDSETC')
 
     D FieldNo         S              5P 0
 
     D FldOffsetP      S              5P 0
     D FldOffsetS      S              5P 0
      *                                                                         CSE023
      ** Country of treaty                                                      CSE023
     D PDRBW           S              2A                                        CSE023
      *                                                                         CSE023
      ** Withholding tax                                                        CSE023
     D DDWTAX          S             15A                                        CSE023
                                                                                              CSW201
      ** Swift 2001 flag                                                                      CSW201
     D CSW201          S              1A                                                      CSW201
                                                                                              CGL031
      ** CGL031 flag                                                                          CGL031
     D CGL031          S              1A                                                      CGL031
 
      ** End of fields for getting starting field number
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOffID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(ABTMESTMP)                                    CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                              CSC011
     D PMODE           S              3A                                                      210517
                                                                                              210517
     D CAS006          S              1                                                       CAS006
     D DDHACR          S             13                                                       CAS006
     D DDPRICN         S             17                                                       CAS006
     D WIdx_TVAL       S              3  0                                                    CAS006
                                                                                              CAS006
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
                                                                                              CSC022
     D CGL014          S              1A                                                     BUG3145
     D DATALUX         DS          1024                                                       CER001
     D  QPETDRF                1      6                                                       CER001
     D  QUTDBK                 7      8                                                       CER001
     D  QUVTCNR                9     14                                                       CER001
     D  #1TDVD                15     19  0                                                    CER001
     D  #1TDDT                20     24  0                                                    CER001
     D  #1ISSD                25     29  0                                                    CER001
     D  #1MATY                30     34  0                                                    CER001
     D  #1FOTR                35     54                                                       CER001
     D  #1TMST                55     80Z                                                      CER001
     D  #1DEXT                81     81                                                       CER001
                                                                                              CER001
      ** Variables used by change CER001                                                      CER001
     D ULX603          S              1A                                                      CER001
     D ULX008          S              1A                                                      CER001
     D P@RtnCode       S              1A                                                      CER001
                                                                                              CER001
     D WFIND           S              1                                                       CER001
     D ZDAYN           S              5P 0                                                    CER001
     D ZDATE           S              6P 0                                                    CER001
     D ZADATE          S              7                                                       CER001
     D PRV_SCRN        S              1                                                       CER001
     D K@TDRF          S                   LIKE(CCTDRF)                                       CER001
     D CallFromVU      S              1A   INZ(' ')                                           CAP087
      ** Front office id variable.                                                         AR698195B
     D DDFRNT          S             20A                                                   AR698195B
      ** -------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SETRADR012
 
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
      /COPY WNCPYSRC,SETRADR001
      *                                                                         140951
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
      /COPY WNCPYSRC,SETRADR002
      *
      * DO SCREEN: BROWSE INVALID DEALS
      *
     C     @SCRN         IFEQ      'I'
      *                                                                                       CAP067
      ** If trade is a buy-sell and action is either delete, authorise or                     CAP067
      ** approve, set flag that displays message that the other leg is also                   CAP067
      ** deleted, authorised or approved on the initial screen                                CAP067
      *                                                                                       CAP067
     C     BDBYSL        IFEQ      'Y'                                                        CAP067
     C     LKRF          ANDNE     *BLANKS                                                    CAP067
      *                                                                                       CAP067
     C     DDACTN        IFEQ      'D'                                                        CAP067
     C     DDACTN        OREQ      'P'                                                        CAP067
     C     DDACTN        OREQ      'Y'                                                        CAP067
     C                   EVAL      PDPYMS = 'Y'                                               CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
     C                   EXSR      SCRN@I
     C                   END
      *
      /COPY WNCPYSRC,SETRADR003
      *
      ** Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   MOVE      'N'           WKPASS            1                          CAP067
     C                   MOVE      'N'           WKDSPL            1                          CAP067
     C                   ENDIF
      *
      /COPY WNCPYSRC,SETRADR004
      *
      ** DO WHILE screen: Primary Details Screen
      *
     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
     C     @SCRN         DOWEQ     'P'
     C                   EXSR      Scrn@P
     C                   ENDDO
      *
      /COPY WNCPYSRC,SETRADR005
      *
      ** DO WHILE screen: Secondary Details Screen
      *
     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      Scrn@S
     C                   ENDDO
      *
                                                                                              CAS006
      /COPY WNCPYSRC,SETRADR017                                                               CAS006
                                                                                              CAS006
      ** DO WHILE screen: Third Details Screen                                                CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL      WIdx_TVAL = 0                                              CAS006
     C                   DOW       @SCRN = 'H'                                                CAS006
     C                   EXSR      Scrn@T                                                     CAS006
     C                   ENDDO                                                                CAS006
     C                   ENDIF                                                                CAS006
      /COPY WNCPYSRC,SETRADR006
      *
      ** DO WHILE screen: Other Details Screen
      *
     C                   Z-ADD     *ZERO         WIdx_OVAL         3 0
     C     @SCRN         DOWEQ     'O'
     C                   EXSR      Scrn@O
     C                   ENDDO
      *
      /COPY WNCPYSRC,SETRADR007
      *
      ** DO WHILE screen: Extension (SWIFT) Details Screen A
      *
     C                   Z-ADD     *ZERO         WIdx_EVALA        3 0
     C                   MOVE      'N'           WKSHOW            1                          CAP067
     C                   EVAL      PUYAT = 'N'                                                201429
     C     @SCRN         DOWEQ     'A'
     C                   EXSR      Scrn@E_A
     C                   ENDDO
      *
      /COPY WNCPYSRC,SETRADR008
      *
      ** DO WHILE screen: Extension (SWIFT) Details Screen B
      *
     C                   Z-ADD     *ZERO         WIdx_EVALB        3 0
     C                   EVAL      PUYAT = 'N'                                                201429
     C     @SCRN         DOWEQ     'B'
     C                   EXSR      Scrn@E_B
     C                   ENDDO
      *                                                                                       CER001
      ** Process extension record                                                             CER001
      *                                                                                       CER001
     C                   IF        @SCRN   = 'L'                                              CER001
     C                   EXSR      SRSETRAD2RP                                                CER001
     C                   ENDIF                                                                CER001
      *
      /COPY WNCPYSRC,SETRADR009
      *                                                                         174875
      ** Screen: Window                                                         174875
      *                                                                         174875
     C     @SCRN         IFEQ      'W'                                          174875
     C                   EXSR      WINDOW                                       174875
     C                   ENDIF                                                  174875
      *
      ** Do File updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
      *                                                                                       CAP067
      ** If Trade is a Buy-Sell, show other leg                                               CAP067
      *                                                                                       CAP067
     C     BDBYSL        IFEQ      'Y'                                                        CAP067
     C     @RTCD         ANDEQ     *BLANKS                                                    CAP067
     C     LKRF          ANDNE     *BLANKS                                                    CAP067
     C     WKPASS        ANDEQ     'N'                                                        CAP067
     C                   EXSR      SRRDNL                                                     CAP067
     C                   MOVE      'Y'           WKPASS                                       CAP067
     C                   MOVE      'Y'           WKDSPL                                       CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
     C                   ENDIF
      *
      /COPY WNCPYSRC,SETRADR010
      *
      ** Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      *****************************************************************         174875
      * WINDOW - CALL WINDOW MANAGER                                            174875
      *****************************************************************         174875
     C     WINDOW        BEGSR                                                  174875
                                                                                174875
      *                                                                         174875
      ** Reset Errors ....                                                      174875
      *                                                                         174875
     C                   MOVE      *ALL'Y'       OKTrSwft                       174875
     C                   MOVEL     *BLANK        FldNameArr                     174875
     C                   MOVEL     *BLANK        MsgIdArr                       174875
     C                   MOVEL     *BLANK        MsgDtaArr                      174875
     C                   MOVEL     *BLANK        WFldNamArr                     174875
     C                   MOVEL     *BLANK        WMsgIdArr                      174875
     C                   MOVEL     *BLANK        WMsgDtaArr                     174875
      *                                                                         174875
      **  If trade reference is not defined (On Insert),                        174875
      **  get next available trade reference                                    174875
      *                                                                         174875
     C     DDTDRF        IFEQ      *BLANK                                       174875
      *                                                                         174875
     C                   CALLB     'ZATRNRTV'                                   174875
     C                   PARM      *BLANKS       RetCodeOut                     174875
     C                   PARM      'SE'          MODU              2            174875
     C                   PARM      'T'           TRTY              1            174875
     C                   PARM                    DDTDRF                         174875
     C                   PARM      *ZERO         TDRF                           174875
      *                                                                         174875
      ** Database Error                                                         174875
      *                                                                         174875
     C     RetCodeOut    IFNE      *BLANK                                       174875
     C                   MOVEL     'ZATRNRTV'    DBFILE                         174875
     C                   MOVEL     '999'         DBASE                          174875
     C                   MOVEL     DDTDRF        DBKEY                          174875
     C                   EXSR      *PSSR                                        174875
     C                   ENDIF                                                  174875
     C                   ENDIF                                                  174875
                                                                                174875
     C/COPY QWINDSRC,SETRADMOV1                                                 174875
                                                                                174875
     C                   CALL      'WN0010'                                     174875
     C                   PARM      'SETRADRPR'   #PGM             10            174875
     C                   PARM                    FKEY              2            174875
     C                   PARM      DDACTN        ACTION            1            174875
     C                   PARM                    DATA                           174875
     C                   PARM      *BLANKS       #RTRN             7            174875
     C                   PARM                    SPAREW          256            174875
                                                                                174875
     C/COPY WNCPYSRC,SETRADRC02
      *                                                                         174875
      ** Process returned command keys                                          174875
      *                                                                         174875
     C     #RTRN         IFEQ      'Y2U9999'                                    174875
     C                   EXSR      ENDP                                         174875
     C                   ELSE                                                   174875
      *                                                                         174875
      *  If Cmd12 pressed, or in enquiry, return to initial screen;             174875
     C/COPY WNCPYSRC,SETRADRC06
      ** If Cmd12 pressed, or in enquiry, return to initial screen;             174875
      ** otherwise, go to settlements screen                                    174875
      *                                                                         174875
     C     #RTRN         IFEQ      'USR0790'                                    174875
     C     DDACTN        OREQ      'E'                                          174875
     C     @OPSEL        OREQ      'N'                                                       BUG9617
     C     @RDNB         IFEQ      'Y'                                          174875
     C                   EVAL      @SCRN = 'R'                                  174875
     C                   ELSE                                                   174875
     C                   EXSR      INITIAL                                      174875
     C                   ENDIF                                                  174875
     C                   ELSE                                                   174875
     C                   EVAL      @SCRN = 'U'                                  174875
     C                   ENDIF                                                  174875
     C/COPY WNCPYSRC,SETRADRC07
     C                   ENDIF                                                  174875
      *                                                                         174875
     C     WIND          ENDSR                                                  174875
      *****************************************************************         174875
      /EJECT                                                                    174875
      *****************************************************************         174875
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SETRADR013
 
      /EJECT
      *****************************************************************
      * SCRN@I - BROWSE INVALID TRADES
      *****************************************************************
     C     SCRN@I        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'SETRADRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
      *
      * Error in update of previous deal                                        CAP006
     C                   PARM                    @ERRUP            1            CAP006
      *                                                                                       CAP067
      * Display message for buy-sell transactions                                             CAP067
     C                   PARM                    PDPYMS            1                          CAP067
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM                    @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM                    @FOTRANSEL       20
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *                                                                         166907
      ** Successfully Inserted Deal Number                                      166907
      *                                                                         166907
     C                   PARM                    @SITR                          166907
      **********                                                                       CAP067 222373
      ***Successful insert Trade 2                                                     CAP067 222373
     C**********         PARM                    PSITR             6                   CAP067 222373
     C                   PARM                    CSC011                                       CSC011
      *
      * If error set on external switches
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVE      '1'           *INU6
     C                   END
      *
      * If CK/3 or CK/12 taken in browse, or error message
      * End program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@I
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@I       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * READ NEXT SUBFILE RECORD
      *
     C                   CALLB     'SETRADRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL            1
      *
      * Error in update of previous deal                                        CAP006
     C                   PARM                    @ERRUP            1            CAP006
      *                                                                                       CAP067
      * Display message for buy-sell transactions                                             CAP067
     C                   PARM                    PDPYMS            1                          CAP067
      *                                                                         CAP006
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM      *BLANK        @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM      *BLANK        @FOTRANSEL       20
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *                                                                         166907
      ** Successfully Inserted Deal Number                                      166907
      *                                                                         166907
     C                   PARM                    @SITR                          166907
      **********                                                                       CAP067 222373
      ***Successful insert Trade 2                                                     CAP067 222373
     C**********         PARM                    PSITR                                 CAP067 222373
     C                   PARM                    CSC011                                       CSC011
      *                                                                         CAP004
      * If CK/3 taken within invalid transaction deletion function,             CAP004
      * End program                                                             CAP004
      *                                                                         CAP004
     C     @INKC         IFEQ      '1'                                          CAP004
     C                   EXSR      ENDP                                         CAP004
     C                   GOTO      ERDNBRW                                      CAP004
     C                   END                                                    CAP004
      *
      * IF INVALID TRADE READ FROM SUBFILE
      *
     C     @OPSEL        IFNE      *BLANK
      *
      * BLANK THE SCREENS
      *
     C                   MOVEL     *BLANK        NewTrPrim
     C                   MOVEL     *BLANK        NewTrSeco
     C                   MOVEL     *BLANK        NewTrExch
     C                   MOVEL     *BLANK        NewTrSett
     C                   MOVEL     *BLANK        NewTrChcm
     C                   MOVEL     *BLANK        NewTrSwftA
     C                   MOVEL     *BLANK        NewTrSwftB
     C                   MOVEL     *BLANK        NewTrExtA                                    CSE045
     C                   MOVEL     *BLANK        NewTrExtB                                    CSE045
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
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVE      *ALL'Y'       OKTrSeco
     C                   MOVE      *ALL'Y'       OKTrExch
     C                   MOVE      *ALL'Y'       OKTrSett
     C                   MOVE      *ALL'Y'       OKTrChcm
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVE      *ALL'Y'       OKTrExts                                     CSE045
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Retrieve trade details
      *
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    FOTRID
     C*******************MOVEL     '*FRONT'      @@MODE                         CAP013
      *                                                                         CAP013
      * Make sure Invalid transaction's  details are passed to 'Retrieve'       CAP013
      * module for SPF checking .                                               CAP013
      *                                                                         CAP013
     C     ZATRNKX0      CHAIN     SEITRADX0                          99        CAP013
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     DDACTN        IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C     DDTDRF        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      @@MODE                         CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
      *                                                                                       CAP067
     C                   CALL      'AOBOOKR0'                                                 CAP067
     C                   PARM      *BLANK        @RTCD             7                          CAP067
     C                   PARM      '*KEY   '     @OPTN             7                          CAP067
     C                   PARM      DDBPBK        @BOOK             2                          CAP067
     C     SDBOOK        PARM      SDBOOK        DSFDY                                        CAP067
      *                                                                         CAP013
     C                   MOVE      'Y'           WKFLEG            1                          CAP067
     C                   EXSR      RTVTRD
      *                                                                                       CER001
      ** Retrieve record in extension file if switchable is on                                CER001
      *                                                                                       CER001
     C                   IF        ULX603  = 'Y'                                              CER001
     C                   EXSR      RTVTRDLUX                                                  CER001
     C                   ENDIF                                                                CER001
      *
      * If trade details were retrieved
      * Convert the trade to screen format.
      *
     C     C_TDRF        IFNE      *BLANK
     C     DDACTN        ANDNE     'I'
     C                   EXSR      CVTTRD
     C                   MOVEL     CrTrFilFmt    NwTrFilFmt
     C                   MOVEL     CT1AFilFmt    NT1AFilFmt
     C                   MOVEL     CT1BFilFmt    NT1BFilFmt
     C                   END
      *
      * Now overwite the fields on the main details screen with those
      * on the invalid trades file (except for the Midas trade
      * reference retrieved above using the front office transaction ID).
      * Access invalid deal with timestamp and front office transaction ID.
      *
     C                   MOVEL     DDTDRF        ##DDTDRF          6
     C     ZATRNKX0      CHAIN     SEITRADX0                          99
 
     C     C_TDRF        IFNE      *BLANK
     C     DDACTN        ANDNE     'I'
     C                   MOVEL     ##DDTDRF      DDTDRF
     C                   END
      *
      * Set up SWIFT 'A' and 'B' screens
      *
     C                   MOVEL     InvTrSwftA    NewTrSwftA
     C                   MOVEL     InvTrSwftB    NewTrSwftB
      *                                                                         CAP011
      * If trade details were retrieved and this is an amendment or change      CAP011
      * Do data substitution if the substitution character is present           CAP011
      *                                                                         CAP011
     C     C_TDRF        IFNE      *BLANK                                       CAP011
     C     DDACTN        ANDEQ     'A'                                          CAP011
     C     GHSUBS        ANDNE     *BLANK                                       CAP011
     C     C_TDRF        ORNE      *BLANK                                       CAP011
     C     DDACTN        ANDEQ     'C'                                          CAP011
     C     GHSUBS        ANDNE     *BLANK                                       CAP011
     C     GHSUBS        scan      NewTrPrim                              99    CAP011
     C  N99GHSUBS        scan      NewTrSeco                              99    CAP011
     C  N99GHSUBS        scan      NewTrExch                              99    CAP011
     C  N99GHSUBS        scan      NewTrSett                              99    CAP011
     C  N99GHSUBS        scan      NewTrChCm                              99    CAP011
     C  N99GHSUBS        scan      NewTrSwftA                             99    CAP011
     C  N99GHSUBS        scan      NewTrSwftB                             99    CAP011
     C     *IN99         IFEQ      *ON                                          CAP011
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   END                                                    CAP011
     C                   END                                                    CAP011
      *
      * If action code, or trade reference were NOT OK
      * blank out action code so that the input cannot proceed
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDTDRFOK      OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   END
      *
      * If Action code is blank (see above) or 'I'
      * (Action code can only be ' ', 'I', 'A', 'C', 'D', 'P' or 'Y')
      *
     C     DDACTN        IFEQ      ' '
     C     DDACTN        OREQ      'I'
      *
      * Send the trades error messages to the primary details screen
      * and GO TO PRIMARY DETAILS SCREEN
      *
     C                   EXSR      SNDM@P
     C                   MOVE      'P'           @SCRN
 
     C                   ELSE
      *
      * Send the trades error messages to the secondary details screen(s)
      * and GO TO SECONDARY DETAILS SCREEN
      *
     C                   EXSR      SNDM@P
     C                   EXSR      SNDM@S
     C                   MOVE      'S'           @SCRN
     C                   END
      *
      * ELSE IF NO INVALID TRADE READ FROM SUBFILE
      *
     C                   ELSE
      *
      * GO TO BROWSE SCREEN
      *
     C                   MOVE      'I'           @SCRN
     C                   END
      *
     C     ERDNBRW       ENDSR                                                  CAP004
     C*******************ENDSR                                                  CAP004
      *****************************************************************
      /EJECT                                                                                  CAP067
      *****************************************************************                       CAP067
      *                                                               *                       CAP067
      * SRRDNL - Reads/Displays next leg of a buy and sell trades     *                       CAP067
      *          transaction                                          *                       CAP067
      *                                                               *                       CAP067
      * Called by: Main                                               *                       CAP067
      *                                                               *                       CAP067
      * Calls: SR/RTVTRD                                              *                       CAP067
      *                                                               *                       CAP067
      *****************************************************************                       CAP067
     C     SRRDNL        BEGSR                                                                CAP067
      *                                                                                       CAP067
      * Blank the screens                                                                     CAP067
      *                                                                                       CAP067
     C                   MOVEL     *BLANK        NewTrPrim                                    CAP067
     C                   MOVEL     *BLANK        NewTrSeco                                    CAP067
     C                   MOVEL     *BLANK        NewTrExch                                    CAP067
     C                   MOVEL     *BLANK        NewTrSett                                    CAP067
     C                   MOVEL     *BLANK        NewTrChcm                                    CAP067
     C                   MOVEL     *BLANK        NewTrSwftA                                   CAP067
     C                   MOVEL     *BLANK        NewTrSwftB                                   CAP067
     C                   MOVEL     *BLANK        DDSTAT                                       CAP067
     C                   MOVEL     *BLANK        DDAUTH                                       CAP067
     C                   MOVEL     *BLANK        DDSRNME                                      CAP067
     C                   MOVEL     *BLANK        DDCRNM                                       CAP067
     C                   MOVEL     *BLANK        DDCFCT                                       CAP067
     C                   MOVEL     *BLANK        DDCPNR                                       CAP067
     C                   MOVEL     *BLANK        DDMAMT                                       CAP067
     C                   MOVEL     *BLANK        DDSPXR                                       CAP067
     C                   MOVEL     *BLANK        DDSPMD                                       CAP067
     C                   MOVEL     *BLANK        DDTCTR                                       CAP067
      *                                                                                       CAP067
      * Reset errors                                                                          CAP067
      *                                                                                       CAP067
     C                   MOVE      *ALL'Y'       OKTrPrim                                     CAP067
     C                   MOVE      *ALL'Y'       OKTrSeco                                     CAP067
     C                   MOVE      *ALL'Y'       OKTrExch                                     CAP067
     C                   MOVE      *ALL'Y'       OKTrSett                                     CAP067
     C                   MOVE      *ALL'Y'       OKTrChcm                                     CAP067
     C                   MOVE      *ALL'Y'       OKTrSwft                                     CAP067
     C                   MOVEL     *BLANK        FldNameArr                                   CAP067
     C                   MOVEL     *BLANK        MsgIdArr                                     CAP067
     C                   MOVEL     *BLANK        MsgDtaArr                                    CAP067
     C                   MOVEL     *BLANK        WFldNamArr                                   CAP067
     C                   MOVEL     *BLANK        WMsgIdArr                                    CAP067
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CAP067
      *                                                                                       CAP067
      * Retrieve trade details                                                                CAP067
      *                                                                                       CAP067
     C                   MOVEL     @ACSEL        DDACTN                                       CAP067
     C                   MOVEL     LKRF          DDTDRF                                       CAP067
      *                                                                                       CAP067
      * Set retrieve mode to blank                                                            CAP067
      *                                                                                       CAP067
     C                   MOVEL     '      '      @@MODE                                       CAP067
      *                                                                                       CAP067
     C                   EXSR      RTVTRD                                                     CAP067
     C                   MOVEL     C_FRNT        @FOTRANSEL                                   CAP067
      *                                                                                       CAP067
      * If trade details were retrieved                                                       CAP067
      * Convert the trade to screen format.                                                   CAP067
      *                                                                                       CAP067
     C     C_TDRF        IFNE      *BLANK                                                     CAP067
     C     DDACTN        ANDNE     'I'                                                        CAP067
     C                   EXSR      CVTTRD                                                     CAP067
     C                   MOVEL     CrTrFilFmt    NwTrFilFmt                                   CAP067
     C                   MOVEL     CT1AFilFmt    NT1AFilFmt                                   CAP067
     C                   MOVEL     CT1BFilFmt    NT1BFilFmt                                   CAP067
     C                   END                                                                  CAP067
      *                                                                                       CAP067
      * Now overwite the fields on the main details screen with those                         CAP067
      * on the invalid trades file (except for the Midas trade                                CAP067
      * reference retrieved above using the front office transaction ID).                     CAP067
      * Access invalid deal with timestamp and front office transaction ID.                   CAP067
      *                                                                                       CAP067
     C                   MOVEL     DDTDRF        ##DDTDRF          6                          CAP067
                                                                                              CAP067
     C     C_TDRF        IFNE      *BLANK                                                     CAP067
     C     DDACTN        ANDNE     'I'                                                        CAP067
     C                   MOVEL     ##DDTDRF      DDTDRF                                       CAP067
     C                   END                                                                  CAP067
      *                                                                                       CAP067
      * Set up SWIFT 'A' and 'B' screens                                                      CAP067
      *                                                                                       CAP067
     C                   MOVEL     InvTrSwftA    NewTrSwftA                                   CAP067
     C                   MOVEL     InvTrSwftB    NewTrSwftB                                   CAP067
      *                                                                                       CAP067
      * If trade details were retrieved and this is an amendment or change                    CAP067
      * Do data substitution if the substitution character is present                         CAP067
      *                                                                                       CAP067
     C     C_TDRF        IFNE      *BLANK                                                     CAP067
     C     DDACTN        ANDEQ     'A'                                                        CAP067
     C     GHSUBS        ANDNE     *BLANK                                                     CAP067
     C     C_TDRF        ORNE      *BLANK                                                     CAP067
     C     DDACTN        ANDEQ     'C'                                                        CAP067
     C     GHSUBS        ANDNE     *BLANK                                                     CAP067
     C     GHSUBS        scan      NewTrPrim                              99                  CAP067
     C  N99GHSUBS        scan      NewTrSeco                              99                  CAP067
     C  N99GHSUBS        scan      NewTrExch                              99                  CAP067
     C  N99GHSUBS        scan      NewTrSett                              99                  CAP067
     C  N99GHSUBS        scan      NewTrChCm                              99                  CAP067
     C  N99GHSUBS        scan      NewTrSwftA                             99                  CAP067
     C  N99GHSUBS        scan      NewTrSwftB                             99                  CAP067
     C     *IN99         IFEQ      *ON                                                        CAP067
     C                   EXSR      TDtDtaSubs                                                 CAP067
     C                   END                                                                  CAP067
     C                   END                                                                  CAP067
      *                                                                                       CAP067
      * If action code, or trade reference were NOT OK                                        CAP067
      * blank out action code so that the input cannot proceed                                CAP067
      *                                                                                       CAP067
     C     DDACTNOK      IFEQ      'N'                                                        CAP067
     C     DDTDRFOK      OREQ      'N'                                                        CAP067
     C                   MOVEL     *BLANK        DDACTN                                       CAP067
     C                   END                                                                  CAP067
      *                                                                                       CAP067
      * If Action code is blank (see above) or 'I'                                            CAP067
      * (Action code can only be ' ', 'I', 'A', 'C', 'D', 'P' or 'Y')                         CAP067
      *                                                                                       CAP067
     C     DDACTN        IFEQ      ' '                                                        CAP067
     C     DDACTN        OREQ      'I'                                                        CAP067
      *                                                                                       CAP067
      * Send the trades error messages to the primary details screen                          CAP067
      * and GO TO PRIMARY DETAILS SCREEN                                                      CAP067
      *                                                                                       CAP067
     C                   EXSR      SNDM@P                                                     CAP067
     C                   MOVE      'P'           @SCRN                                        CAP067
                                                                                              CAP067
     C                   ELSE                                                                 CAP067
      *                                                                                       CAP067
      * Send the trades error messages to the secondary details screen(s)                     CAP067
      * and GO TO SECONDARY DETAILS SCREEN                                                    CAP067
      *                                                                                       CAP067
     C     DDACTN        IFNE      'D'                                                        CAP067
     C     DDACTN        ANDNE     'P'                                                        CAP067
     C     DDACTN        ANDNE     'Y'                                                        CAP067
     C     WKDSPL        ANDNE     'Y'                                                        CAP067
     C                   MOVE      'S'           @SCRN                                        CAP067
     C                   EXSR      SNDM@P                                                     CAP067
     C                   EXSR      SNDM@S                                                     CAP067
     C                   ELSE                                                                 CAP067
     C                   IF        @OPSEL = 'N'                                              BUG9617
     C                   EVAL      @SCRN = 'R'                                               BUG9617
     C                   ELSE                                                                BUG9617
     C                   MOVE      'U'           @SCRN                                        CAP067
     C                   ENDIF                                                               BUG9617
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
     C                   ENDSR                                                                CAP067
      *****************************************************************                       CAP067
      /EJECT
      *****************************************************************
      * SNDM@P - SEND A MESSAGE TO PRIMARY DETAILS SCREEN
      *****************************************************************
     C     SNDM@P        BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDTDRFOK      OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKTrPrim      @EI
      *
      ** Read error messages for trade
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
 
     C     ABFIELDID     IFLT      FldOffsetS
     C     DDACTN        OREQ      ' '
     C     DDACTN        OREQ      'I'
     C     ULX603        ANDEQ     'N'                                                        CER001
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffsetP    F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   END
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   END
      *
     C                   MOVEA     @EI           OKTrPrim
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@S - SEND A MESSAGE TO SECONDARY DETAILS SCREEN
      *****************************************************************
     C     SNDM@S        BEGSR
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKTrSeco      @EI
      *
      ** Read error messages for trade
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
 
     C     ABFIELDID     IFGE      FldOffsetS
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffsetS    F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   END
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
     C                   END
      *
     C                   MOVEA     @EI           OKTrSeco
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@P - PROCESS SCREEN: PRIMARY DETAILS
      *****************************************************************
     C     SCRN@P        BEGSR
      *
      * Enable/disable detail fields on primary details screen
      * if changes to the data are allowed                                      CAP014
      * (key fields = action code & trade reference; detail fields = rest)
      * (Action code can only be 'I' or ' ' in this subroutine)
      *
     C     DDACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   END
 
      * Update 'previous' screen
 
     C                   MOVEL     NewTrPrim     PrvTrPrim
      *                                                                         206651
     C     DDSESN        CHAIN     SECTY                              99        206651
     C     *IN99         IFEQ      '0'                                          206651
     C                   MOVEL     SC_SRPN       DDSRNME                        206651
     C                   ENDIF                                                  206651
      *                                                                         229342
     C                   CALLB     'AOCUSTR1'                                   229342
     C                   PARM      '*MSG    '    @RTCD                          229342
     C                   PARM      '*KEY    '    @OPTN                          229342
     C                   PARM                    DDCNUM                         229342
     C                   PARM                    KEY7              7            229342
     C     SDCUST        PARM      SDCUST        DSLDY                          229342
      *                                                                         229342
      ** Customer is a Private Banking Customer: get default value if blank     229342
      *                                                                         229342
     C     @RTCD         IFEQ      *BLANKS                                      229342
     C                   MOVEL     BBCRNM        DDCRNM                         229342
     C                   ELSE                                                   229342
     C                   MOVEL     *BLANKS       DDCRNM                         229342
     C                   ENDIF                                                  229342
      *                                                                         229342
     C                   CALLB     'AOCUSTR1'                                   229342
     C                   PARM      '*MSG    '    @RTCD                          229342
     C                   PARM      '*KEY    '    @OPTN                          229342
     C                   PARM                    DDCNUM                         229342
     C                   PARM                    KEY7              7            229342
     C     SDCUST        PARM      SDCUST        DSLDY                          229342
      *                                                                         229342
      ** Customer is a Private Banking Customer: get default value if blank     229342
      *                                                                         229342
     C     @RTCD         IFEQ      *BLANKS                                      229342
     C                   MOVEL     BBCRNM        DDCRNM                         229342
     C                   ELSE                                                   229342
     C                   MOVEL     *BLANKS       DDCRNM                         229342
     C                   ENDIF                                                  229342
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
     C                   PARM      'N'           @EKYFD            1
     C                   PARM                    @EDTFD            1
      * Indicator if this program from SE0190                                                 CSE028
     C                   PARM      'N'           @FRPGM                                       CSE028
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KP = COMMAND KEY 15 = BROWSE
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKP            1
      * Successful insert Trade
     C                   PARM                    @SITR             6
      *
      * Protect book on second leg                                                            CPK014
     C                   PARM                    IN50              1                          CPK014
     C                   PARM                    TRDBK1            2                          CPK014
      *                                                                                       CPK014
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL             1                          CAP067
      *                                                                                       CAP067
      ** Successful insert Trade 2                                                            CAP067
     C**********         PARM                    PSITR                                 CAP067 222373
     C                   PARM                    PSITR             6                          222373
      *                                                                                       CAP067
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C**********         PARM      '0'           @INKW             1                   CSE039 222373
     C**********         PARM      'N'           @INKWDisp         1                   CSE039 222373
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
      * F12 - Cancel on Primary Screen
     C     @INKL         CASEQ     '1'           CANC@P
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
     C                   MOVEL     '      '      @@MODE
     C                   EXSR      RTVTRD
      *
      * If action code, or trade reference are NOT OK
      * Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDTDRFOK      OREQ      'N'
     C                   GOTO      EndVAL@P
     C                   END
      *
      * Prior to validation, initialize error indicators as 'OK'
      * and clear Trade in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   CLEAR                   NwTrFilFmt
     C                   CLEAR                   NT1AFilFmt
     C                   CLEAR                   NT1BFilFmt
     C                   EXSR      SRCLER                                                     CAP067
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
      *
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
      * OUTPUTS :
 
      ** Security Details
      ** Investment Type Details
     C*******************PARM                    SECTY                          206651
     C                   PARM                    SECTY2                         206651
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
     C/COPY WNCPYSRC,SETRADRC11
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM      'N'           Validate          1
      ** Security Details
      ** Investment Type Details
     C*******************PARM                    SECTY                                        206651
     C                   PARM                    SECTY2                                       206651
     C                   PARM                    INVTP
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *                                                                                       CPK014
      ** MT5xx SSI (Phase 2)                                                                  CPK014
     C                   PARM                    CSE028                                       CPK014
      * CGL031 Switchable Feature                                                             CGL031
     C                   PARM                    CGL031                                       CGL031
      ** Current File Trade Date                                                              244240
     C                   PARM                    C_TDVD                                       244240
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
      *****************************************************************                       CAP067
      /EJECT                                                                                  CAP067
      *****************************************************************                       CAP067
      *                                                               *                       CAP067
      * SRCLER - Clear numeric variables                                                      CAP067
      *                                                               *                       CAP067
      * Called by: SR/VAL@P                                           *                       CAP067
      *                                                               *                       CAP067
      * Calls: None                                                   *                       CAP067
      *                                                               *                       CAP067
      *****************************************************************                       CAP067
     C     SRCLER        BEGSR                                                                CAP067
      *                                                                                       CAP067
     C**********         Z-ADD     0             TCNR                                  CAP067 CSD027
     C                   EVAL      TCNR = *BLANKS                                             CSD027
     C                   Z-ADD     0             NOML                                         CAP067
     C                   Z-ADD     0             TNMD                                         CAP067
     C                   Z-ADD     0             TPDY                                         CAP067
     C                   Z-ADD     0             TDVD                                         CAP067
     C                   Z-ADD     0             TDDT                                         CAP067
     C                   Z-ADD     0             TCAP                                         CAP067
     C                   Z-ADD     0             DADJ                                         CAP067
     C                   Z-ADD     0             ITRA                                         CAP067
     C                   Z-ADD     0             TINA                                         CAP067
     C                   Z-ADD     0             TDCR                                         CAP067
     C                   Z-ADD     0             PRIC                                         CAP067
     C                   Z-ADD     0             RALL                                         CAP067
     C                   Z-ADD     0             TDER                                         CAP067
     C                   Z-ADD     0             TBCR                                         CAP067
     C                   Z-ADD     0             SMTH                                         CAP067
     C                   Z-ADD     0             ASNM                                         CAP067
     C**********         Z-ADD     0             DELT                                  CAP067 CSD027
     C**********         Z-ADD     0             DELF                                  CAP067 CSD027
     C                   EVAL      DELT = *BLANKS                                             CSD027
     C                   EVAL      DELF = *BLANKS                                             CSD027
     C                   Z-ADD     0             TBCA                                         CAP067
     C                   Z-ADD     0             TCCA                                         CAP067
     C                   Z-ADD     0             TCA1                                         CAP067
     C                   Z-ADD     0             TCA2                                         CAP067
     C                   Z-ADD     0             TCA3                                         CAP067
     C                   Z-ADD     0             TCA4                                         CAP067
     C                   Z-ADD     0             TCA5                                         CAP067
     C                   Z-ADD     0             TCA6                                         CAP067
     C                   Z-ADD     0             TCA7                                         CAP067
     C                   Z-ADD     0             TAXA                                         CAP067
     C                   Z-ADD     0             BCMR                                         CAP067
     C                   Z-ADD     0             CCMR                                         CAP067
     C                   Z-ADD     0             TXRB                                         CAP067
     C                   Z-ADD     0             TIME                                         CAP067
     C                   Z-ADD     0             TOSN                                         CAP067
     C                   Z-ADD     0             TNSN                                         CAP067
     C                   Z-ADD     0             TNSP                                         CAP067
     C                   Z-ADD     0             TOSV                                         CAP067
     C                   Z-ADD     0             TVSN                                         CAP067
     C                   Z-ADD     0             TVSP                                         CAP067
     C                   Z-ADD     0             TDSN                                         CAP067
     C                   Z-ADD     0             TDSP                                         CAP067
     C                   Z-ADD     0             TDFS                                         CAP067
     C                   Z-ADD     0             TSSQ                                         CAP067
     C                   Z-ADD     0             TCSR                                         CAP067
     C                   Z-ADD     0             TCTR                                         CAP067
     C                   Z-ADD     0             TDMC                                         CAP067
     C                   Z-ADD     0             TOED                                         CAP067
     C                   Z-ADD     0             LCD                                          CAP067
     C                   Z-ADD     0             TNLU                                         CAP067
     C                   Z-ADD     0             LSWS                                         CAP067
     C                   Z-ADD     0             TCFC                                         CAP067
     C                   Z-ADD     0             SPXR                                         CAP067
     C                   Z-ADD     0             FXMP                                         CAP067
     C                   Z-ADD     0             FXMR                                         CAP067
     C                   Z-ADD     0             MAMT                                         CAP067
     C                   Z-ADD     0             ORDE                                         CAP067
     C                   Z-ADD     0             WHTX                                         CAP067
     C                   Z-ADD     0             A_T1LSWS                                     CAP067
     C                   Z-ADD     0             A_T1LSSC                                     CAP067
     C                   Z-ADD     0             B_T1LSWS                                     CAP067
     C                   Z-ADD     0             B_T1LSSC                                     CAP067
      *                                                                                       CAP067
     C                   ENDSR                                                                CAP067
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - PROCESS SECOND SCREEN
      *****************************************************************
     C     SCRN@S        BEGSR
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
 
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewTrPrim     PrvTrPrim
     C                   MOVEL     NewTrSeco     PrvTrSeco
     C                   Z-ADD     WIdx_SVAL     PrvN_Warn         3 0
      *                                                                         206651
     C     DDSESN        CHAIN     SECTY                              99        206651
     C     *IN99         IFEQ      '0'                                          206651
     C                   MOVEL     SC_SRPN       DDSRNME                        206651
     C                   ENDIF                                                  206651
      *                                                                         229342
     C                   CALLB     'AOCUSTR1'                                   229342
     C                   PARM      '*MSG    '    @RTCD                          229342
     C                   PARM      '*KEY    '    @OPTN                          229342
     C                   PARM                    DDCNUM                         229342
     C                   PARM                    KEY7              7            229342
     C     SDCUST        PARM      SDCUST        DSLDY                          229342
      *                                                                         229342
      ** Customer is a Private Banking Customer: get default value if blank     229342
      *                                                                         229342
     C     @RTCD         IFEQ      *BLANKS                                      229342
     C                   MOVEL     BBCRNM        DDCRNM                         229342
     C                   ELSE                                                   229342
     C                   MOVEL     *BLANKS       DDCRNM                         229342
     C                   ENDIF                                                  229342
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
     C*******************PARM                    SECTY                                        206651
     C                   PARM                    SECTY2                                       206651
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
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM                    @EINKJ            1
     C                   PARM      'N'           @EINKP
      *                                                                                       CPK014
      * Protect book on second leg                                                            CPK014
     C                   PARM                    IN50              1                          CPK014
     C                   PARM                    TRDBK1            2                          CPK014
      * CGL031 Switchable Feature                                                             CGL031
     C                   PARM                    CGL031                                       CGL031
      *                                                                                       CAP067
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
     C                   PARM      '0'           @INKW             1                          222373
     C                   PARM      'N'           @INKWDisp         1                          222373
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
      * F12 - Cancel on Secondary Screen
     C     @INKL         CASEQ     '1'           CANC@S
      *
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
      * IF AUTHORIZE / APPROVE
      *
     C     DDACTN        IFEQ      'Y'
     C     DDACTN        OREQ      'P'
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
      *                                                                                       CAP067
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
      * OUTPUTS :
      ** Security Details
      ** Investment Type Details
     C*******************PARM                    SECTY                                        206651
     C                   PARM                    SECTY2                                       206651
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
     C/COPY WNCPYSRC,SETRADRC12
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM      'Y'           Validate          1
      ** Security Details
      ** Investment Type Details
     C*******************PARM                    SECTY                                        206651
     C                   PARM                    SECTY2                                       206651
     C                   PARM                    INVTP
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *                                                                                       CPK014
      ** MT5xx SSI (Phase 2)                                                                  CPK014
     C                   PARM                    CSE028                                       CPK014
      * CGL031 Switchable Feature                                                             CGL031
     C                   PARM                    CGL031                                       CGL031
      ** Current File Trade Date                                                              244240
     C                   PARM                    C_TDVD                                       244240
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
      *                                                                                       CAS006
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
     C**********         PARM                    SECTY                                 CAS006 206651
     C                   PARM                    SECTY2                                       206651
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
     C**********         PARM                    SECTY                                 CAS006 206651
     C                   PARM                    SECTY2                                       206651
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
                                                                                              CAS006
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
      ** If Authorize/Approve, go to Other details screen                                     CAS006
                                                                                              CAS006
     C                   IF        DDACTN = 'P'  OR  DDACTN = 'Y'                             CAS006
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
     C**********         PARM                    SECTY                                 CAS006 206651
     C                   PARM                    SECTY2                                       206651
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
     C                   PARM                    WIdx_TVAL                                    CAS006
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
      */C*PY*WNCPYSRC,SETRADR014************************************************       CUT009 CPK015
      /COPY WNCPYSRC,SETRADR016                                                               CPK015
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'C'
     C                   EXSR      DFLT@O
     C     BVACOP        IFEQ      'Y'
     C                   EXSR      CHCMCAL
     C                   END
     C/COPY WNCPYSRC,SETRADRC03
     C     CGL031        IFEQ      'Y'                                                        233881
     C                   EXSR      EUTXCAL                                                    233881
     C                   ENDIF                                                                233881
     C                   EXSR      CVALCAL
     C                   END
     C                   END
      *
      ** WRITE/READ DISPLAY - Other Details Screen
      /COPY WNCPYSRC,SETRADR015                                                               CUT009
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
      * And Private Banking customer (Y/N)                                      CPB001
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
                                                                                              CGL031
      ** Switchable Feature                                                                   CGL031
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
     C*******************PARM                    SECTY                                        206651
     C                   PARM                    SECTY2                                       206651
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
     C                   MOVEL     DDSETC        ##SETC            3
     C                   MOVEL     DDCNUM        ##CNUM           10
 
     C     EndDFLT@O     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@O  - VALIDATE INPUT TO OTHER DETAILS SCREEN
      *****************************************************************
     C     VAL@O         BEGSR
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
     C*******************PARM                    SECTY                                        206651
     C                   PARM                    SECTY2                                       206651
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
     C/COPY WNCPYSRC,SETRADRC04
     C     CGL031        IFEQ      'Y'                                                        233881
     C                   EXSR      EUTXCAL                                                    233881
     C                   ENDIF                                                                233881
     C                   EXSR      CVALCAL
     C/COPY WNCPYSRC,SETRADRC05
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
      *                                                                         CAP051
      * Setup Automatic Authorisation flag on the Valid file                    CAP051
     C     CAP051        IFEQ      'Y'                                          CAP051
     C                   EVAL      C_AUTH = DDAUTHA                             CAP051
     C                   ENDIF                                                  CAP051
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
      *
      * If MT5XX Message Generation not installed, Go To Updates
      * Else, Go to EXTENSION (SWIFT) screen A
      *
     C     S01401        IFNE      'Y'
     C                   IF        @OPSEL = 'N'                                              BUG9617
     C                   EVAL      @SCRN  = 'R'                                              BUG9617
     C                   ELSE                                                                BUG9617
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                               BUG9617
     C                   ELSE
     C                   MOVEL     'A'           @SCRN
     C                   END
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
      * INSTRUCTIONS NOT PRESENT AND                                            154208
      * IF FIRST TIME FOR TRADE REF, TYPE, METHOD, CLEAR TYPE, DEPOTS ..
      *
     C     DDACTN        IFEQ      'I'
     C     NewTrSwftA    ANDEQ     *BLANK                                       154208
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
      *
      * DO DEFAULTING FOR EXTENSION SCREEN A
      *
     C                   EXSR      DFLT@E_A
     C                   END
     C                   END
      *                                                                                       CAP067
      ** For buy-sell trade only, if no errors/warnings on the first leg and details B        CAP067
      ** is not to be displayed, display message that says this is one side of the buy-       CAP067
      ** sell, press enter to continue                                                        CAP067
      *                                                                                       CAP067
     C     WKSHOW        IFEQ      'Y'                                                        CAP067
     C     WKFLEG        ANDEQ     'Y'                                                        CAP067
     C     MsgIdArr(1)   ANDEQ     *BLANKS                                                    CAP067
     C     WMsgIdArr(1)  ANDEQ     *BLANKS                                                    CAP067
     C     Display_B     ANDEQ     'N'                                                        CAP067
     C                   ADD       1             E                                            CAP067
     C                   MOVEL     '*ANY'        FldNameArr(1)                                CAP067
     C                   MOVEL     'MMM0023'     MsgIdArr(1)                                  CAP067
     C                   MOVE      'N'           WKFLEG                                       CAP067
     C                   ENDIF                                                                CAP067
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
      ** ISO15022 indicator in file                                                           201429
     C                   PARM                    A_T1NEW                                      201429
      *                                                                                       210517
      ** Default SSI Flag                                                                     210517
     C                   PARM      'Y'           DftFlag           1                          210517
      *                                                                                       210517
      * Fields in error
     C                   PARM                    OKTrSwft
     C                   PARM                    OkTrExts                                     CSE045
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
     C                   PARM      'RPR'         PMODE                                        CSE045
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
     C                   PARM                    NT2AFilFmt                                   CSE045
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
      *                                                                                       CAP067
      ** If this is a buy-sell trade, and screen details B is not to be displayed,            CAP067
      *                                                                                       CAP067
     C     BDBYSL        IFEQ      'Y'                                                        CAP067
     C     LKRF          ANDNE     *BLANKS                                                    CAP067
     C     Display_B     ANDNE     'Y'                                                        CAP067
      *                                                                                       CAP067
      ** If action is Amend or Change, set flag that displays message before the              CAP067
      ** program shows the next leg                                                           CAP067
      *                                                                                       CAP067
     C     DDACTN        IFEQ      'A'                                                        CAP067
     C     DDACTN        OREQ      'C'                                                        CAP067
     C                   MOVE      'Y'           WKSHOW            1                          CAP067
     C                   ELSE                                                                 CAP067
     C                   MOVE      'N'           WKSHOW                                       CAP067
     C                   ENDIF                                                                CAP067
      *                                                                                       CAP067
     C                   ENDIF                                                                CAP067
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
     C                   IF        ULX603   = 'Y'                                             CER001
     C                   EVAL      PRV_SCRN = @SCRN                                           CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     Display_B     IFNE      'Y'
      *                                                                                       CER001
      ** If ULX603 switchable feature is ON                                                   CER001
      *                                                                                       CER001
     C                   IF        ULX603  = 'Y'                                              CER001
     C                   EVAL      @SCRN   = 'L'                                              CER001
     C                   ELSE                                                                 CER001
     C                   IF        @OPSEL  = 'N'                                             BUG9617
     C                   EVAL      @SCRN   = 'R'                                             BUG9617
     C                   ELSE                                                                BUG9617
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                               BUG9617
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
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
      * INSTRUCTIONS NOT PRESENT AND                                            154208
      * IF FIRST TIME FOR TRADE REF, TYPE, METHOD, CLEAR TYPE, DEPOTS ..
      *
     C     DDACTN        IFEQ      'I'
     C     NewTrSwftB    ANDEQ     *BLANK                                       154208
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
      *
      * DO DEFAULTING FOR EXTENSION SCREEN B
      *
     C                   EXSR      DFLT@E_B
     C                   END
     C                   END
      *                                                                                       CAP067
      ** For buy-sell trade only, if no errors/warnings on the first leg, display             CAP067
      ** message that says this is one side of the buy-sell, press enter to continue          CAP067
      *                                                                                       CAP067
     C     WKSHOW        IFEQ      'Y'                                                        CAP067
     C     MsgIdArr(1)   ANDEQ     *BLANKS                                                    CAP067
     C     WMsgIdArr(1)  ANDEQ     *BLANKS                                                    CAP067
     C                   ADD       1             E                                            CAP067
     C                   MOVEL     '*ANY'        FldNameArr(E)                                CAP067
     C                   MOVEL     'MMM0023'     MsgIdArr(E)                                  CAP067
     C                   ENDIF                                                                CAP067
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
      ** ISO15022 indicator in file                                                           201429
     C                   PARM                    B_T1NEW                                      201429
      *                                                                                       211682
      ** Default SSI Flag                                                                     211682
     C                   PARM      'Y'           DftFlag           1                          211682
      *                                                                                       211682
      * Fields in error
     C                   PARM                    OKTrSwft
     C                   PARM                    OkTrExts                                     CSE045
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
     C                   PARM      'RPR'         PMODE                                        CSE045
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
     C                   PARM                    NT2BFilFmt                                   CSE045
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
      * IF AUTHORIZE / APPROVE
      *
     C     DDACTN        IFEQ      'Y'
     C     DDACTN        OREQ      'P'
      *                                                                                       CER001
      ** If ULX603 switchable feature is ON                                                   CER001
      *                                                                                       CER001
     C                   IF        ULX603   = 'Y'                                             CER001
     C                   EVAL      PRV_SCRN = @SCRN                                           CER001
     C                   EVAL      @SCRN    = 'L'                                             CER001
     C                   ELSE                                                                 CER001
      *
      ** If windows processing on, call window routine else                     174875
      * Go to updates
      *
     C     BGWDPR        IFEQ      'Y'                                          174875
     C                   MOVEL     'W'           @SCRN                          174875
     C                   ELSE                                                   174875
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                  174875
     C                   ENDIF                                                                CER001
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
      *                                                                                       CAP067
      ** If the transaction is a buy-sell, and action is either Amend                         CAP067
      ** or Change, set flag that displays message before the program                         CAP067
      ** shows the next leg                                                                   CAP067
      *                                                                                       CAP067
     C     BDBYSL        IFEQ      'Y'                                                        CAP067
     C     LKRF          ANDNE     *BLANKS                                                    CAP067
     C     DDACTN        IFEQ      'A'                                                        CAP067
     C     DDACTN        OREQ      'C'                                                        CAP067
     C                   MOVE      'Y'           WKSHOW                                       CAP067
     C                   ELSE                                                                 CAP067
     C                   MOVE      'N'           WKSHOW                                       CAP067
     C                   ENDIF                                                                CAP067
     C                   ENDIF                                                                CAP067
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
      *                                                                                       CER001
      ** If ULX603 switchable feature is ON                                                   CER001
      *                                                                                       CER001
     C                   IF        ULX603   = 'Y'                                             CER001
     C                   EVAL      PRV_SCRN = @SCRN                                           CER001
     C                   EVAL      @SCRN    = 'L'                                             CER001
     C                   ELSE                                                                 CER001
      *
      ** If windows processing on, call window routine else                     174875
      * Go to updates
      *
     C     BGWDPR        IFEQ      'Y'                                          174875
     C                   MOVEL     'W'           @SCRN                          174875
     C                   ELSE                                                   174875
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                  174875
     C                   ENDIF                                                                CER001
      *
     C                   END
      *----------------------------------------------------------------
      *
     C     EndVAL@E_B    ENDSR
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
     C                   PARM                    @@MODE            6
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
     C/COPY WNCPYSRC,SETRADRC10
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
      * CGL031 Switchable Feature                                                             CGL031
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
     C*******************PARM                    SECTY                                       206651
     C                   PARM                    SECTY2                                      206651
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
      * CANC@P - CANCEL ON PRIMARY DETAILS SCREEN
      *****************************************************************
     C     CANC@P        BEGSR
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'I'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SECONDARY SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * IF ACTION CODE IS INSERT, GO TO PRIMARY SCREEN
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'P'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'I'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CAS006
      * CANC@T - CANCEL ON THIRD SCREEN                                                       CAS006
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
      * Return to Extension Screen A
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
     C                   MOVEL     DDTDRF        TDRF
      *
      * UPDATE VALID TRADE: CHANGE TYPE
      *
     C                   MOVEL     DDACTN        CHTP
      *
      * UPDATE VALID DEAL: FRONT OFFICE TRANSACTION ID
      *
     C                   MOVEL     @FOTRANSEL    FRNT
     C                   MOVEL     @FOTRANSEL    A_T1FRNT                       CAP013
     C                   MOVEL     @FOTRANSEL    B_T1FRNT                       CAP013
      *
      ** Write directly to the extension file.  The information held on                       CSE039
      *  the extension file is only used to update the Movement Status                        CSE039
      *  file and therefore it is not necessary to update data structure                      CSE039
     C     CSE039        IFEQ      'Y'                                                        CSE039
     C                   EVAL      T3TDRF = DDTDRF                                            CSE039
     C                   EVAL      T3INOR = DDINOR                                            CSE039
     C                   EVAL      T3MSGK = DDMSGK                                            CSE039
     C                   EVAL      T3NTMT = DDNTMT                                            CSE039
     C                   EVAL      T3FRNT = FRNT                                              CSE039
     C                   EVAL      T3AFRT = AFRT                                              CSE039
     C                   EVAL      T3TMST = TMST                                              CSE039
     C                   WRITE     TRADSDD3                                                   CSE039
     C                   ENDIF                                                                CSE039
     C                   IF        CSE045 = 'Y'                                               CSE045
     C                   MOVEL     @FOTRANSEL    A_T2FRNT                                     CSE045
     C                   MOVEL     @FOTRANSEL    B_T2FRNT                                     CSE045
     C                   ENDIF                                                                CSE045
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
      * CGL031 Switchable Feature                                                             CGL031
     C                   PARM                    CGL031                                       CGL031
     C                   PARM      'RPR'         PMODE                                        210517
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
     C                   PARM                    NT2AFilFmt                                   CSE045
     C                   PARM                    NT2BFilFmt                                   CSE045
     C                   IF        @RTCD   = *BLANKS AND ULX603 = 'Y'                         CER001
     C                   EVAL      #6LXCCTDRF = DDTDRF                                        CER001
     C                   CALLB     'SETRAD2UP'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM      *BLANK        @RTCD                                        CER001
     C                   PARM      'Y'           WFIND                                        CER001
     C                   PARM                    NwDlFilFmt                                   CER001
     C                   PARM                    CrDlFilFmt                                   CER001
     C                   ENDIF                                                                CER001
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM.
      * OTHERWISE DELETE THE INVALID TRADE ACTIONED & COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C*****@RTCD         ANDNE     '*RECUPD'                             CAP006 168345
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C     @RTCD         IFNE      '*RECUPD'                                    168345
     C                   EXSR      *PSSR
     C                   ENDIF                                                  168345
     C                                                                          CAP006
     C                   ELSE
     C     ZATRNKD0      CHAIN     SEITRADD0                          99
     C  N99              DELETE    SEITRADD0
     C                   IF        ULX603  = 'Y'                                              CER001
     C     K@KEY1        CHAIN     RTVIDX1                            99                      CER001
     C                   IF        %FOUND                                                     CER001
     C                   DELETE    RTVIDX1                                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
                                                                                              CSC011
     C                   EVAL      KMsgType = 'SETRAD'                                        CSC011
     C                   EVAL      KFrntOffID = @FOTRANSEL                                    CSC011
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGD0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C/COPY WNCPYSRC,SETRADRC09
      *                                                                                       CSC011
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   END
      *
      * If error occurred in updating last transaction set on flag to           CAP006
      * display message on 'browse' screen.                                     CAP006
     C     @RTCD         IFEQ      '*RECUPD'                                    CAP006
     C                   MOVE      'Y'           @ERRUP                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      'N'           @ERRUP                         CAP006
     C                   END                                                    CAP006
     C                                                                          CAP006
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'I'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End Program
      *****************************************************************
     C     ENDP          BEGSR
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
      * IF ACTION CODE IS INSERT, GO TO PRIMARY SCREEN
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'P'           @SCRN
     C                   ELSE
      *
      * ELSE, GO TO SECONDARY SCREEN
      *
     C                   MOVEL     'S'           @SCRN
     C                   END
      *
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
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHCMCAL - CHARGES AND COMMISSIONS CALCULATION
      *****************************************************************
     C     CHCMCAL       BEGSR
 
     C/COPY WNCPYSRC,SETRADRC01
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
     C*******************PARM                    SECTY                                        206651
     C                   PARM                    SECTY2                                       206651
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
      * EUTXCAL - EU TAX CALCULATION                                                          233881
      *****************************************************************                       233881
     C     EUTXCAL       BEGSR                                                                233881
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
     C                   PARM                    NwTrFilFmt                                   233881
      * Security Details                                                                      233881
     C                   PARM                    SECTY2                                       233881
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
     C/COPY WNCPYSRC,SETRADRC08
 
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
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     TDtDtaSubs    BEGSR                                                  CAP011
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
     C                   PARM      NewTrPrim     IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrPrim     CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewTrPrim                      CAP011
 
      * TRADE SECONDARY DETAILS
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewTrSeco     IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrSeco     CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewTrSeco                      CAP011
 
      * TRADE EXCHANGE RATES
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewTrExch     IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrExch     CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewTrExch                      CAP011
 
      * TRADE SETTLEMENT DETAILS
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewTrSett     IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrSett     CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewTrSett                      CAP011
 
      * TRADE CHARGE/COMMISSIONS
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewTrChCm     IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrChCm     CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewTrChCm                      CAP011
 
      * TRADE SWIFT A DETAILS
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewTrSwftA    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrSwftA    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewTrSwftA                     CAP011
 
      * TRADE SWIFT B DETAILS
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewTrSwftB    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurTrSwftB    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewTrSwftB                     CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADRPR'   DBPGM
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
     C                   MOVEL     '909'         DBASE                          CAP051
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
      ** Database Error                                                                       CSE028
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
      *
      ** Check if CSE039 feature is installed                                                 CSE039
      *                                                                                       CSE039
     C                   CALLB     'AOSARDR0'                                                 CSE039
     C                   PARM      *BLANKS       @RTCD                                        CSE039
     C                   PARM      '*VERIFY'     @OPTN                                        CSE039
     C                   PARM      'CSE039'      @SARD                                        CSE039
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE039
      *                                                                                       CSE039
      ** Database Error                                                                       CSE039
      *                                                                                       CSE039
     C     @RTCD         IFNE      *BLANKS                                                    CSE039
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE039
     C     *LOCK         IN        LDA                                                        CSE039
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE039
     C                   Z-ADD     913           DBASE                                        CSE039
     C                   MOVEL     'CSE039'      DBKEY                                        CSE039
     C                   OUT       LDA                                                        CSE039
     C                   EXSR      *PSSR                                                      CSE039
     C                   ENDIF                                                                CSE039
      *                                                                                       CSE039
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
      *                                                                                       CSE045
      ** Database Error                                                                       CSE045
      *                                                                                       CSE045
     C     @RTCD         IFNE      *BLANKS                                                    CSE045
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE045
     C     *LOCK         IN        LDA                                                        CSE045
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE045
     C                   Z-ADD     913           DBASE                                        CSE045
     C                   MOVEL     'CSE045'      DBKEY                                        CSE045
     C                   OUT       LDA                                                        CSE045
     C                   EXSR      *PSSR                                                      CSE045
     C                   ENDIF                                                                CSE045
      *                                                                                       CSE045
     C     @RTCD         IFEQ      *BLANK                                                     CSE045
     C                   MOVEL     'Y'           CSE045            1                          CSE045
     C                   ELSE                                                                 CSE045
     C                   MOVEL     'N'           CSE045                                       CSE045
     C                   ENDIF                                                                CSE045
      *
      ** Access API ICD Details                                                 CAP011
      *                                                                         CAP011
     C                   CALLB     'AOAPIR0'                                    CAP011
     C                   PARM      *BLANKS       @RTCD                          CAP011
     C                   PARM      '*FIRST '     @OPTN                          CAP011
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
      *                                                                         CAP011
      * DATABASE ERROR                                                          CAP011
      *                                                                         CAP011
     C     @RTCD         IFNE      *BLANKS                                      CAP011
     C                   MOVEL     'SDAPIPD '    DBFILE                         CAP011
     C                   MOVEL     '911'         DBASE                          CAP011
     C                   MOVEL     @OPTN         DBKEY                          CAP011
     C                   EXSR      *PSSR                                        CAP011
     C                   END                                                    CAP011
      *
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   OPEN      APILOGL0                                                   CSC011
     C                   IN        SC24X7                                                     CSC011
     C**********         IN        SDSTAT                                              CSC011 CSD015
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 912                                                CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CAS006
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
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSC011
      *                                                                                       CGL031
      ** Access SAR details file to determine if CGL031                                       CGL031
      ** (Taxation of Savings Income) is on.                                                  CGL031
      *                                                                                       CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       @RTCD                                        CGL031
     C                   PARM      '*VERIFY'     @OPTN                                        CGL031
     C                   PARM      'CGL031'      @SARD             6                          CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
      *                                                                                       CGL031
      * DATABASE ERROR                                                                        CGL031
      *                                                                                       CGL031
     C     @RTCD         IFNE      *BLANKS                                                    CGL031
     C     @RTCD         ANDNE     '*NRF   '                                                  CGL031
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL031
     C                   MOVEL     '914'         DBASE                                        CGL031
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
      * Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOffID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
                                                                                              CSC011
     C     K@KEY1        KLIST                                                                CER001
     C                   KFLD                    #1TMST                                       CER001
     C                   KFLD                    #1FOTR                                       CER001
      *                                                                                       CER001
      ** Setup key values using transaction data passed from caller                           CER001
      *                                                                                       CER001
     C                   EVAL      K@TDRF = DDTDRF                                            CER001
      *                                                                                       CER001
     C     K@KEY         KLIST                                                                CER001
     C                   KFLD                    K@TDRF                                       CER001
 
      ** Message Type
 
     C*******************MOVEL     'SETRAD'      @MSGTYPE          8            CAP004
 
      ** Get the field number for the action code field; the primary
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    FieldP
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetP = FieldNo - 1
     C                   ENDIF
 
      ** Get the field number for the settle ccy field; the secondary
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    FieldS
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetS = FieldNo - 1
     C                   ENDIF
      *
      * Start on Browse Screen
      *
     C                   MOVEL     'I'           @SCRN             1
     C                   MOVEL     'N'           @FRPGM            1                          CSE028
      *
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
      /COPY WNCPYSRC,SETRADR014
 
      *                                                                                       CER001
      ** Access SAR details file to determine if ULX603                                       CER001
      ** is installed.                                                                        CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX603'      @SARD             6                          CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
      ** Database Error                                                                       CER001
      *                                                                                       CER001
     C                   IF        @RTCD  <> *BLANKS AND @RTCD <> '*NRF   '                   CER001
     C                   EVAL      DBFILE  = 'SCSARDPD'                                       CER001
     C                   EVAL      DBASE   = 915                                              CER001
     C                   EVAL      DBKEY   = 'ULX603'                                         CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   IF        @RTCD   = *BLANK                                           CER001
     C                   EVAL      ULX603  = 'Y'                                              CER001
     C                   OPEN      SEITDLX1L0                                                 CER001
      *                                                                                       CER001
      ** Do not process lux extension details when Lux Return indicator is                    CER001
      ** not set to 'Y'                                                                       CER001
      *                                                                                       CER001
      *                                                                                       CER001
     C                   IF        BGLRIN <> 'Y'                                              CER001
     C                   EVAL      ULX603  = 'N'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ULX603  = 'N'                                              CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX008 - API Commissariat Aux Bourses (Funct. SEDPMV/SETRAD)                         CER001
      *                                                                                       CER001
     C                   EVAL      ULX008  = 'N'                                              CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX008'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD   = *BLANKS                                          CER001
     C                   EVAL      ULX008  = 'Y'                                              CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Database Error                                                                       CER001
      *                                                                                       CER001
     C                   IF        @RTCD  <> *BLANKS AND @RTCD <> '*NRF   '                   CER001
     C                   EVAL      DBFILE  = 'SCSARDPD'                                       CER001
     C                   EVAL      DBASE   = 916                                              CER001
     C                   EVAL      DBKEY   = 'ULX008'                                         CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
     C                   ENDSR
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  RTVTRDLUX - Retrieve LUX invalid records                     *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     RTVTRDLUX     BEGSR                                                                CER001
     C                   EVAL      #1FOTR  = DDFOTRANID                                       CER001
     C                   EVAL      #1TMST  = DDTMESTMP                                        CER001
     C                   EVAL      QPETDRF = DDTDRF                                           CER001
      *                                                                                       CER001
      ** Retrieve record in extension file                                                    CER001
      *                                                                                       CER001
     C     K@KEY1        CHAIN     RTVIDX1                            99                      CER001
     C                   IF        %FOUND                                                     CER001
     C                   EVAL      L6LXAGSD = #6LXAGSD                                        CER001
     C                   EVAL      L6LXTTIM = #6LXTTIM                                        CER001
     C                   EVAL      L6LXCABR = #6LXCABR                                        CER001
     C                   EVAL      L6LXMTRD = CCMTRD                                          CER001
     C                   EVAL      #1DEXT   = 'Y'                                             CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      L6LXAGSD = *BLANKS                                         CER001
     C                   EVAL      L6LXTTIM = *BLANKS                                         CER001
     C                   EVAL      L6LXCABR = *BLANKS                                         CER001
     C                   EVAL      L6LXMTRD = *BLANKS                                         CER001
     C                   ENDIF                                                                CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *  SRSETRAD2RP - Pocess extension record                        *                       CER001
      *****************************************************************                       CER001
     C     SRSETRAD2RP   BEGSR                                                                CER001
     C                   EVAL      #1TDVD  = TDVD                                             CER001
     C                   EVAL      #1TDDT  = TDDT                                             CER001
     C                   EVAL      #1ISSD  = ISSD                                             CER001
     C                   EVAL      #1MATY  = MATY                                             CER001
      *                                                                                       CER001
     C                   IF        @OPSEL  = 'N'                                              CER001
     C                   EVAL      ACTION  = 'E'                                              CER001
     C                   EVAL      #1DEXT  = 'Y'                                              CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      ACTION  = DDACTN                                           CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   CALL      'SETRAD2RP'                                                CER001
     C                   PARM      *BLANKS       P@RtnCode                                    CER001
     C                   PARM                    ACTION                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    #RTRN                                        CER001
     C                   PARM                    NwDlFilFmt                                   CER001
     C                   PARM                    NwDlScnFmt                                   CER001
     C                   EVAL      #1DEXT  = *BLANK                                           CER001
      *                                                                                       CER001
      ** Process returned command keys                                                        CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
     C                   WHEN      #RTRN   = 'Y2U9999'                                        CER001
     C                   EXSR      ENDP                                                       CER001
      *                                                                                       CER001
      ** If Cmd12 pressed, return to initial screen;                                          CER001
      ** otherwise, go to settlements screen                                                  CER001
      *                                                                                       CER001
     C                   WHEN      #RTRN   = 'USR0790'                                        CER001
     C                   IF        @RDNB   = 'Y'                                              CER001
     C                   EVAL      @SCRN   = PRV_SCRN                                         CER001
     C                   ELSE                                                                 CER001
     C                   EXSR      INITIAL                                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** In enquiry, return to initial screen;                                                CER001
      *                                                                                       CER001
     C                   WHEN      @OPSEL  = 'N'                                              CER001
     C                   EVAL      @SCRN   = 'R'                                              CER001
     C                   OTHER                                                                CER001
     C                   IF        BGWDPR = 'Y'                                               CER001
     C                   EVAL      @SCRN  = 'W'                                               CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      @SCRN  = 'U'                                               CER001
     C                   ENDIF                                                                CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
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
