000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas SE Invalid trades repair')                       *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Securities Trading Module                            *
000900200529      *                                                               *
001000200529      *  SETRADRPR - INVALID SECURITY TRADES SCREEN INPUT             *
001100200529      *                                                               *
001200200529      *  Function:  This function allows invalid securities trades to *
001300200529      *             be 'repaired' and applied to the Midas database.  *
001400200529      *                                                               *
001500200529      *  (c) Finastra International Limited 2001                      *
001600200529      *                                                               *
001700200604      *  Last Amend No. 248683             Date 22May20               *
001800200529      *  Prev Amend No. MD046248           Date 27Oct17               *
001900200529      *                 CSF011A            Date 28Nov11               *
002000200529      *                 AR698195B          Date 20Jan11               *
002100200529      *                 CSW210             Date 04May10               *
002200200529      *                 CER059             Date 19Jul10               *
002300200529      *                 CER054             Date 07Apr09               *
002400200529      *                 BUG22911           Date 17Feb09               *
002500200529      *                 CER048             Date 19May08               *
002600200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
002700200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
002800200529      * Midas Plus 1.4 Base ------------------------------------------*
002900200529      *                 244240             Date 21Jul06               *
003000200529      *                 233881             Date 02Jun05               *
003100200529      * Midas Plus 1.3 ----------- Base ------------------------------*
003200200529      *                 CSD031             Date 10Apr06               *
003300200529      *                 CSD027             Date 09Dec05               *
003400200529      *                 CAP087             Date 17Aug05               *
003500200529      *                 BUG9617            Date 14Dec05               *
003600200529      *                 CER001             Date 25Apr05               *
003700200529      *                 CSE075             Date 17Nov05               *
003800200529      *                 CGL031             Date 05Jul04               *
003900200529      *                 CSE065             Date 08Nov04               *
004000200529      *                 CSE071             Date 19Jul05               *
004100200529      *                 229342             Date 02Sep04               *
004200200529      *                 206651             Date 18Jun02               *
004300200529      *                 BUG3145            Date 15Jun04               *
004400200529      *                 CSC022             Date 24Feb04               *
004500200529      *                 CGL029             Date 01Sep03               *
004600200529      *                 CSE045             Date 24Mar03               *
004700200529      *                 222373             Date 23Oct03               *
004800200529      *                 CSE039             Date 31Mar03               *
004900200529      *                 CSE037             Date 29Apr02               *
005000200529      *                 CAS006             Date 21Jan03               *
005100200529      *                 CSD015             Date 14Oct02               *
005200200529      * Midas Release 4.01.03 ----------------------------------------*
005300200529      *                 210517             Date 21Nov02               *
005400200529      * Midas Release 4.01.02 ----------------------------------------*
005500200529      *                 211682             Date 07Nov02               *
005600200529      *                 200459             Date 22Apr02               *
005700200529      * Midas Release 4.01 -------------------------------------------*
005800200529      *                 CSE034             Date 23Apr02               *
005900200529      *                 CPK015             Date 10Apr02               *
006000200529      *                 CSE031             Date 13Dec01               *
006100200529      *                 CSC011             Date 18Sep01               *
006200200529      *                 201429             Date 15Jan02               *
006300200529      *                 201233             Date 20Dec01               *
006400200529      *                 CAP067             Date 24Sep01               *
006500200529      *                 199797             Date 01Nov01               *
006600200529      * Midas Release 4 --------------- Base -------------------------*
006700200529      *                 CPK014             Date 02Oct01               *
006800200529      *                 CSE028             Date 06Jun01               *
006900200529      *                 CSW201             Date 02May01               *
007000200529      *                 CSE016             Date 10Jan01               *
007100200529      * Midas DBA 3.05 -----------------------------------------------*
007200200529      *                 193462             Date 25May01               *
007300200529      *                 CUT009             Date 22Mar01               *
007400200529      *                 CPB002             Date 28Mar01               *
007500200529      * Midas DBA 3.04 -----------------------------------------------*
007600200529      *                 CSE023             Date 12Jul00               *
007700200529      *                 175216             Date 12Sep00               *
007800200529      * Midas DBA 3.03 -----------------------------------------------*
007900200529      *                 CAP137             Date 07Feb00               *
008000200529      *                 174875             Date 02Mar00               *
008100200529      *                 166907             Date 27Dec99               *
008200200529      * Midas DBA 3.02 -----------------------------------------------*
008300200529      *                 CAP051             Date 16Nov99               *
008400200529      *                 CPB001             Date 01Jun99               *
008500200529      *                 CAP014             Date 29Nov99               *
008600200529      *                 CAP013             Date 07Sep99               *
008700200529      *                 CAP011             Date 07Sep99               *
008800200529      *                 168345             Date 14Oct99               *
008900200529      * Midas DBA 3.00 ---------------- Base -------------------------*
009000200529      *                 CPL002             Date 08Mar99               *
009100200529      *                 CAP006             Date 15Mar99               *
009200200529      *                 154562             Date 01Feb99               *
009300200529      *                 154208             Date 27Jan99               *
009400200529      *                 CAP004             Date 01Sep98               *
009500200529      *                 140951             Date 27AUG98               *
009600200529      *                 CAP050             Date 28Jul98               *
009700200529      *                 CAP003  *CREATE    Date 29May98               *
009800200529      *                                                               *
009900200529      *---------------------------------------------------------------*
010000200529      *                                                               *
010100200529      *  248683 - Initialize Data Area for SE1806 Flag.               *
010200200529      *  MD046248 - Finastra Rebranding                               *
010300200529      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
010400200529      *            (Recompile)                                        *
010500200529      *  AR698195B - Added Front Office field on the buffer for TRADS *
010600200529      *             (Child: AR698196)                                 *
010700200529      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
010800200529      *  CER059 - German Feature Upgrade to Delhi                     *
010900200529      *  CER054 - German Features - Church Tax (Recompile)            *
011000200529      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
011100200529      *  CER048 - German Features - Taxes (Recompile)                 *
011200200529      *  244240 - Apply same correction as 235547 to make parameter   *
011300200529      *           list match with SETRADSVAL parameter entry list.    *
011400200529      *           Apply 233881 correction.                            *
011500200529      *  233881 - EU Tax amount should be subtracted from the         *
011600200529      *           Countervalue.                                       *
011700200529      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
011800200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
011900200529      *  CAP087  - Enable the use of SETRADVU to process Buy/Sell     *
012000200529      *            trades.                                            *
012100200529      *  BUG9617- Action 'N' updates the database file even with      *
012200200529      *           Errors                                              *
012300200529      *  CER001 - LUX Upgrade to MidasPlus                            *
012400200529      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
012500200529      *           (Recompile)                                         *
012600200529      *  CGL031 - Taxation for Savings Income                         *
012700200529      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
012800200529      *           (Recompile)                                         *
012900200529      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
013000200529      *  229342 - Customer Report Name is not displayed.              *
013100200529      *  206651 - Security Report Name is not displayed during Insert *
013200200529      *  BUG3145 - Charges and Commission are being missed out of the *
013300200529      *            calculation of countervalue.                       *
013400200529      *  CSC022 - Commitment Control Changes for MidasPlus            *
013500200529      *  CGL029 - Increase Account Code to 10 digits                  *
013600200529      *  CSE045 - API for Extended Settlement for Trade Input and     *
013700200529      *           Depot Movement                                      *
013800200529      *  222373 - Parameter Mismatches                                *
013900200529      *  CSE039 - Auto-settlement of Trades                           *
014000200529      *  CSE037 - Bond Pricing - 3 Decimal Places in Trades Input     *
014100200529      *  CAS006 - Hedge Accounting Phase B                            *
014200200529      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
014300200529      *  210517 - Missing TRADSDX2 record from the API                *
014400200529      *  211682 - SETRADRPR doesnt display the error message in       *
014500200529      *           SETRADEDSP screen                                   *
014600200529      *  200459 - Current factor not applied to countervalue for 'MP' *
014700200529      *           Securities.  Add checking to SEDEV for new current  *
014800200529      *           factor and if it exists, use it in calculating the  *
014900200529      *           countervalue.  Amended to be consistent with SE0050.*
015000200529      *  CSE034 - Standard Settlement Instruction improvements        *
015100200529      *  CPK015 - Renumbered duplicated hook SETRADR014 so that the   *
015200200529      *           CUP009 hook is now called SETRADR016.               *
015300200529      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
015400200529      *           Recompiled due to changes in SECTYD.                *
015500200529      *  CSC011 - 24x7 Midas Availability                             *
015600200529      *  201429 - New validation needed for ISO15022 in               *
015700200529      *           extended settlement screen.                         *
015800200529      *  201233 - If message is unroutable, settlement of message     *
015900200529      *           request cannot be a 'Y'.                            *
016000200529      *  CAP067 - Repurchase Agreements API.                          *
016100200529      *  199797 - Additional changes and fixes for CSE028 (SSIs).     *
016200200529      *  CPK014 - Release 4 Packaging                                 *
016300200529      *         - Fix parameter mismatch                              *
016400200529      *  CSE028 - Standing Settlement Instructions Enhancement        *
016500200529      *  CSW201 - SWIFT 2001 Standards Update                         *
016600200529      *  CSE016 - Extended Security Descriptions                      *
016700200529      *  193462 - Protect Book code if Buy/sell indicator = 'Y'       *
016800200529      *  CUT009 - Core hooks added manually.                          *
016900200529      *  CPB002 - Counterparty for trades coming from Tof can be the  *
017000200529      *           internal customer number (Book transfer)            *
017100200529      *           In this case the PB Order Number is setted in Tof   *
017200200529      *           Add this parameter when calling SETRADPVAL to give  *
017300200529      *           the value to SEVTCUST                               *
017400200529      *  CSE023 - Treaty Withholding Tax.                             *
017500200529      *  175216 - Add additional field for "Standing Instructions     *
017600200529      *           Override" missed at SWIFT 98 change. Compile only   *
017700200529      *  CAP137 - Conversion of SE Security inputs into modular       *
017800200529      *           structure to use as APIs.                           *
017900200529      *  174875 - Window processing                                   *
018000200529      *  166907 - Display 'Deal No. 999999 successfully inserted.'    *
018100200529      *           in the correct screen.                              *
018200200529      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
018300200529      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
018400200529      *           Recompiled due to database changes                  *
018500200529      *         - 'Private Banking' Module                            *
018600200529      *  CAP014 - Repair function enhancements                        *
018700200529      *  CAP013 - Allow access by Midas transaction ID if not insert  *
018800200529      *  CAP011 - Substitution of Midas database flds for externl i/fs*
018900200529      *  168345 - Prevent two users from accessing same transaction   *
019000200529      *           in repair screen at the same cycle, and converting  *
019100200529      *           it into two different Midas Deal No.s  .            *
019200200529      *           Second user should not be allowed to repair the tran-
019300200529      *           saction and convert it into a another Midas Deal.   *
019400200529      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
019500200529      *  CAP006 - Check for deal being updated by another workstation *
019600200529      *  154562 - Only 1 record is needed on TRADSDX1 if CSW003 is off*
019700200529      *  154208 - Errors in field defaulting                          *
019800200529      *  CAP004 - API's Phase 3.                                      *
019900200529      *           Add extra parm for Extra Data                       *
020000200529      *           Remove MSGTYPE field as not needed.                 *
020100200529      *  140951 - Addition of F14 key to access Ext. Settlements.     *
020200200529      *  CAP050 - Midas/ToF Interface                                 *
020300200529      *  CAP003 - Conversion of SE inputs into modular structure to   *
020400200529      *           use as APIs.                                        *
020500200529      *                                                               *
020600200529      *****************************************************************
020700200529      ** +--------------------------------------+
020800200529      ** ¦ F-specs                              ¦
020900200529      ** ¦ =======                              ¦
021000200529      ** +--------------------------------------+
021100200529     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
021200200529
021300200529     FSEITRADL0 IF   E           K DISK    INFSR(*PSSR)
021400200529     F                                     RENAME(SEITRADD0 : SEITRADX0)
021500200529     FSEITRADL1 UF   E           K DISK    INFSR(*PSSR)
021600200529     F                                     COMMIT
021700200529     FSETRADL0  IF   E           K DISK    INFSR(*PSSR)                                       CAP067
021800200529     F                                                                                        CAP067
021900200529     FTRADSDX3  UF A E           K DISK    INFSR(*PSSR)                                       CSE039
022000200529     F                                     COMMIT                                             CSE039
022100200529      *
022200200529     FSECTY     IF   E           K DISK    INFSR(*PSSR)                                       206651
022300200529     F                                     PREFIX(SC_)                                        206651
022400200529
022500200529      ** API Invalid Log File                                                                 CSC011
022600200529     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
022700200529     F                                     COMMIT                                             CSC011
022800200529                                                                                              CSC011
022900200529     FSEITDLX1L0UF   E           K DISK    USROPN                                             CER001
023000200529     F                                     RENAME(SEITDLXD6:RTVIDX1)                          CER001
023100200529     F                                     INFSR(*PSSR)                                       CER001
023200200529     F                                     COMMIT                                             CER001
023300200529      * Hook to enable non-core files to be included
023400200529      /COPY WNCPYSRC,SETRADR011
023500200529
023600200529      *****************************************************************
023700200529      ** +--------------------------------------+
023800200529      ** ¦ Automatically included D-specs       ¦
023900200529      ** ¦ ==============================       ¦
024000200529      ** +--------------------------------------+
024100200529      **
024200200529      **--------------------------------------------------------------------------------------------
024300200529      ** The following /COPY line includes (among others) the LDA layout
024400200529      ** and the copyright array definition:
024500200529     D/COPY ZACPYSRC,STD_D_SPEC
024600200529      **--------------------------------------------------------------------------------------------
024700200529
024800200529      **--------------------------------------------------------------------------------------------
024900200529      ** The following /COPY includes the MM standard declares:
025000200529     D/COPY ZACPYSRC,STDDECLARE
025100200529      **--------------------------------------------------------------------------------------------
025200200529
025300200529      **--------------------------------------------------------------------------------------------
025400200529      ** The following /COPY line includes all the defined fields in the
025500200529      ** Program Status Data Structures.  They have meaningful
025600200529      ** names, prefixed by 'PS'.
025700200529     D/COPY ZACPYSRC,PSDS
025800200529      **--------------------------------------------------------------------------------------------
025900200529
026000200529      **--------------------------------------------------------------------------------------------
026100200529      ** The following /COPY line includes the definitions for error and
026200200529      ** warning message arrays.
026300200529     D/COPY ZACPYSRC,ERR_ARRAYS
026400200529      **--------------------------------------------------------------------------------------------
026500200529
026600200529      ** +--------------------------------------+
026700200529      ** ¦ End of automatically included D-specs¦
026800200529      ** ¦ =====================================¦
026900200529      ** +--------------------------------------+
027000200529
027100200529      *****************************************************************
027200200529      /EJECT
027300200529      *****************************************************************
027400200529
027500200529      ** +--------------------------------------+
027600200529      ** ¦ Manually included D-specs            ¦
027700200529      ** ¦ =========================            ¦
027800200529      ** +--------------------------------------+
027900200529
028000200529      ** +--------------------------------------+
028100200529      ** ¦ Named constants                      ¦
028200200529      ** ¦ ===============                      ¦
028300200529      ** +--------------------------------------+
028400200529
028500200529      ** +--------------------------------------+
028600200529      ** ¦ Arrays and Data Structures           ¦
028700200529      ** ¦ ==========================           ¦
028800200529      ** +--------------------------------------+
028900200529                                                                                              CSC022
029000200529     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
029100200529      ** Array for commitment job names                                                       CSC022
029200200529
029300200529     D @EI             S              1    DIM(60)
029400200529
029500200529      * Invalid Trade in Screen Format - SWIFT Details
029600200529     D InvTrSwftA    E DS                  EXTNAME(SETRSWPD)
029700200529     D                                     PREFIX(A)
029800200529      * Invalid Trade in Screen Format - SWIFT Details
029900200529     D InvTrSwftB    E DS                  EXTNAME(SETRSWPD)
030000200529     D                                     PREFIX(B)
030100200529
030200200529
030300200529      * Current Trade in File Format
030400200529     D CrTrFilFmt    E DS                  EXTNAME(TRADSD)
030500200529     D                                     PREFIX(C_)
030600200529      * Current Trade in File Format (Extension File)
030700200529     D CT1AFilFmt    E DS                  EXTNAME(TRADSDX1)
030800200529     D                                     PREFIX(CA_)
030900200529      * Current Trade in File Format (Extension File)
031000200529     D CT1BFilFmt    E DS                  EXTNAME(TRADSDX1)
031100200529     D                                     PREFIX(CB_)
031200200529
031300200529
031400200529      * (Current) Trade in Screen Format - Primary Details
031500200529     D CurTrPrim     E DS                  EXTNAME(SETRPRPD)
031600200529     D                                     PREFIX(@)
031700200529      * (Current) Trade in Screen Format - Secondary Details
031800200529     D CurTrSeco     E DS                  EXTNAME(SETRSEPD)
031900200529     D                                     PREFIX(@)
032000200529      ** (Current) Trade in Screen Format - Third screen details                              CAS006
032100200529     D CurTrThir     E DS                  EXTNAME(SETRTHPD)                                  CAS006
032200200529     D                                     PREFIX(@)                                          CAS006
032300200529      * (Current) Trade in Screen Format - Exchange Rates Details
032400200529     D CurTrExch     E DS                  EXTNAME(SETREXPD)
032500200529     D                                     PREFIX(@)
032600200529      * (Current) Trade in Screen Format - Settlement Instructions
032700200529     D CurTrSett     E DS                  EXTNAME(SETRSTPD)
032800200529     D                                     PREFIX(@)
032900200529     D @DDCLTY2      E                     EXTFLD(DDCLTY)
033000200529      * (Current) Trade in Screen Format - Charges/Commissions
033100200529     D CurTrChCm     E DS                  EXTNAME(SETRCCPD)
033200200529     D                                     PREFIX(@)
033300200529      * (Current) Trade in Screen Format - SWIFT Details
033400200529     D CurTrSwftA    E DS                  EXTNAME(SETRSWPD)
033500200529     D                                     PREFIX(@A)
033600200529      * (Current) Trade in Screen Format - SWIFT Details
033700200529     D CurTrSwftB    E DS                  EXTNAME(SETRSWPD)
033800200529     D                                     PREFIX(@B)
033900200529
034000200529
034100200529     D NwTrFilFmt    E DS                  EXTNAME(SEVTRADPD)
034200200529      * New Trade in File Format
034300200529     D NT1AFilFmt    E DS                  EXTNAME(SEVTRX1PD)
034400200529     D                                     PREFIX(A_)
034500200529      * New Trade in File Format (Extension File)
034600200529     D NT1BFilFmt    E DS                  EXTNAME(SEVTRX1PD)
034700200529     D                                     PREFIX(B_)
034800200529      * New Trade in File Format (Extension File)
034900200529     D NT2AFilFmt    E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
035000200529     D                                     PREFIX(A_)                                         CSE045
035100200529     D NT2BFilFmt    E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
035200200529     D                                     PREFIX(B_)                                         CSE045
035300200529
035400200529
035500200529      * New Trade in Screen Format - Primary Details
035600200529     D NewTrPrim     E DS                  EXTNAME(SETRPRPD)
035700200529      * New Trade in Screen Format - Secondary Details
035800200529     D NewTrSeco     E DS                  EXTNAME(SETRSEPD)
035900200529      ** New Trade in Screen Format - Third Screen Details                                    CAS006
036000200529     D NewTrThir     E DS                  EXTNAME(SETRTHPD)                                  CAS006
036100200529      * New Trade in Screen Format - Exchange Rate Details
036200200529     D NewTrExch     E DS                  EXTNAME(SETREXPD)
036300200529      * New Trade in Screen Format - Settlement Details
036400200529     D NewTrSett     E DS                  EXTNAME(SETRSTPD)
036500200529     D DDCLTY2       E                     EXTFLD(DDCLTY)
036600200529      * New Trade in Screen Format - Charge & Commission Details
036700200529     D NewTrChCm     E DS                  EXTNAME(SETRCCPD)
036800200529      * New Trade in Screen Format - SWIFT Details
036900200529     D NewTrSwftA    E DS                  EXTNAME(SETRSWPD)
037000200529     D                                     PREFIX(A_)
037100200529      * New Trade in Screen Format - SWIFT Details
037200200529     D NewTrSwftB    E DS                  EXTNAME(SETRSWPD)
037300200529     D                                     PREFIX(B_)
037400200529
037500200529     D NewTrExtA     E DS                  EXTNAME(SETESDPD)                                  CSE045
037600200529     D                                     PREFIX(A_)                                         CSE045
037700200529     D NewTrExtB     E DS                  EXTNAME(SETESDPD)                                  CSE045
037800200529     D                                     PREFIX(B_)                                         CSE045
037900200529
038000200529      * Previous Trade in Screen Format - Primary Details
038100200529     D PrvTrPrim     E DS                  EXTNAME(SETRPRPD)
038200200529     D                                     PREFIX(@P)
038300200529      * Previous Trade in Screen Format - Secondary Details
038400200529     D PrvTrSeco     E DS                  EXTNAME(SETRSEPD)
038500200529     D                                     PREFIX(@P)
038600200529      ** Previous Trade in Screen Format - Third Screen Details                               CAS006
038700200529     D PrvTrThir     E DS                  EXTNAME(SETRTHPD)                                  CAS006
038800200529     D                                     PREFIX(@P)                                         CAS006
038900200529      * Previous Trade in Screen Format - Exchange Rate Details
039000200529     D PrvTrExch     E DS                  EXTNAME(SETREXPD)
039100200529     D                                     PREFIX(@P)
039200200529      * Previous Trade in Screen Format - Settlement Details
039300200529     D PrvTrSett     E DS                  EXTNAME(SETRSTPD)
039400200529     D                                     PREFIX(@P)
039500200529     D @PDDCLTY2     E                     EXTFLD(DDCLTY)
039600200529      * Previous Trade in Screen Format - Charge & Commission Details
039700200529     D PrvTrChCm     E DS                  EXTNAME(SETRCCPD)
039800200529     D                                     PREFIX(@P)
039900200529      * Previous Trade in Screen Format - SWIFT Details
040000200529     D PrvTrSwft     E DS                  EXTNAME(SETRSWPD)
040100200529     D                                     PREFIX(@P)
040200200529
040300200529
040400200529      * Error indicators
040500200529     D OKTrPrim      E DS                  EXTNAME(SEETRPRPD)
040600200529     D OKTrSeco      E DS                  EXTNAME(SEETRSEPD)
040700200529     D OKTrThir      E DS                  EXTNAME(SEETRTHPD)                                 CAS006
040800200529     D OKTrExch      E DS                  EXTNAME(SEETREXPD)
040900200529     D OKTrSett      E DS                  EXTNAME(SEETRSTPD)
041000200529     D DDCLTY2OK     E                     EXTFLD(DDCLTYOK)
041100200529     D OKTrChcm      E DS                  EXTNAME(SEETRCCPD)
041200200529     D OKTrSwft      E DS                  EXTNAME(SEETRSWPD)
041300200529     D OKTrExts      E DS                  EXTNAME(SEETESPD)                                  CSE045
041400200529
041500200529
041600200529      ** Security Details
041700200529     D*SECTY****     E DS                  EXTNAME(SECTYD)                                    206651
041800200529     D SECTY2        E DS                  EXTNAME(SECTYD)                                    206651
041900200529     D SEC_RECI      E                     EXTFLD(RECI)
042000200529     D SEC_ZZ005     E                     EXTFLD(ZZ005)
042100200529     D SEC_LCD       E                     EXTFLD(LCD)
042200200529     D SEC_CHTP      E                     EXTFLD(CHTP)
042300200529     D SEC_TNLU      E                     EXTFLD(TNLU)
042400200529     D SEC_REPI      E                     EXTFLD(REPI)                         CPB001
042500200529     D SEC_FRNT      E                     EXTFLD(FRNT)                                       CAP137
042600200529     D SEC_REPA      E                     EXTFLD(REPA)                                       CAP137
042700200529     D SEC_TMST      E                     EXTFLD(TMST)                                       CAP137
042800200529     D SEC_NDEC      E                     EXTFLD(NDEC)                                       CSE037
042900200529
043000200529      ** Investment Type Details
043100200529     D INVTP         E DS                  EXTNAME(INVTPD)
043200200529     D INV_RECI      E                     EXTFLD(RECI)
043300200529     D INV_LCD       E                     EXTFLD(LCD)
043400200529     D INV_CHTP      E                     EXTFLD(CHTP)
043500200529     D INV_TNLU      E                     EXTFLD(TNLU)
043600200529     D INV_NDEC      E                     EXTFLD(NDEC)                                       CSE037
043700200529
043800200529      ** The following /COPY includes the customer details data structure
043900200529     D/COPY SECPYSRC,SE_CUSTDT
044000200529      ** The following /COPY includes the currency details data structures
044100200529     D/COPY SECPYSRC,SE_CCYDT
044200200529
044300200529     D                 DS
044400200529      **  Data structure for date in, to change format.
044500200529     D  DateIn                 1      8  0
044600200529     D  @@YY                   1      4  0
044700200529     D  @@MM                   5      6  0
044800200529     D  @@DD                   7      8  0
044900200529
045000200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
045100200529      ** EXTERNAL DS FOR BANK DETAILS
045200200529
045300200529     D SDGELR        E DS                  EXTNAME(SDGELRPD)
045400200529      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
045500200529
045600200529     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
045700200529      ** EXTERNAL DS FOR SECURITIES TRADING DETAILS
045800200529
045900200529     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
046000200529      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
046100200529
046200200529     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)                                  CAP067
046300200529      ** Book Details                                                                         CAP067
046400200529                                                                                              CAP067
046500200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)
046600200529     D SCA_LCD       E                     EXTFLD(LCD)
046700200529      ** EXTERNAL DS FOR SAR DETAILS
046800200529
046900200529     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
047000200529      ** EXTERNAL DS FOR API ICD                                                CAP011
047100200529                                                                                CAP011
047200200529     D DSFDY         E DS                  EXTNAME(DSFDY)
047300200529      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
047400200529
047500200529     D DSSDY         E DS                  EXTNAME(DSSDY)
047600200529      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
047700200529                                                                                CAP004
047800200529     D ExtData       E DS                  EXTNAME(SETDEXPD)                    CAP004
047900200529      * SE Trades Extra Data - File (D/B) format                                CAP004
048000200529                                                                                229342
048100200529     D DSLDY         E DS                  EXTNAME(DSLDY)                       229342
048200200529      ** FIRST DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                      229342
048300200529                                                                                229342
048400200529     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    229342
048500200529      ** EXTERNAL DS FOR BANK DETAILS                                           229342
048600200529
048700200529      ** 24X7 status data area                                                                CSC011
048800200529     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
048900200529                                                                                              CSC011
049000200529      ** SDSTAT data area                                                                     CSC011
049100200529     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
049200200529                                                                                              CSC011
049300200529      ** TRADSDX2 record                                                                      210517
049400200529     D PTradeX2      E DS                  EXTNAME(TRADSDX2)                                  210517
049500200529     D                                     PREFIX(X2:2)                                       210517
049600200529                                                                                              210517
049700200529      ** Current Trade (invalid) in Screen Format                                             CER001
049800200529     D NwDlScnFmt    E DS                  EXTNAME(SETDRXPD)                                  CER001
049900200529      ** New Trade in File Format (#6LXCC)                                                    CER001
050000200529     D NwDlFilFmt    E DS                  EXTNAME(SEVTDLX1PD)                                CER001
050100200529      ** Current Trade in File Format (VL)                                                    CER001
050200200529     D CrDlFilFmt    E DS                  EXTNAME(SETRX1PD)                                  CER001
050300200529     D PMCWL           DS          9999                                                       CSD015
050400200529      ** Additional entry parameter for Midas Compliance Watch                                CSD015
050500200529                                                                                              CSD015
050600200529     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
050700200529     D  ComitJob               4    103                                                       CSC022
050800200529      ** Midas SC Jobs handling commitment control data area                                  CSC022
050900200529                                                                                              CSC022
051000200529     D/COPY QWINDSRC,SETRADGDTA                                                 174875
051100200529      ** +--------------------------------------+
051200200529      ** ¦ Declared variables                   ¦
051300200529      ** ¦ ==================                   ¦
051400200529      ** +--------------------------------------+
051500200529
051600200529      **   Timestamp selected
051700200529     D @TMESTPSEL      S             26Z
051800200529
051900200529      ** Response Mode, passed as a constant parameter to the VAL module
052000200529      ** This is always 'S' for Synchronous
052100200529     D RespMode        S              1A   INZ('S')
052200200529
052300200529      ** -------------------------------------------------------------------
052400200529      ** Fields for getting the starting field number from file (parameters
052500200529      ** to ZACGTFLDNO, plus the offset to the requested field).
052600200529     D Format          S             10A   INZ('SETRADPD')
052700200529
052800200529     D FieldP          S             10A   INZ('DDACTN')
052900200529     D FieldS          S             10A   INZ('DDSETC')
053000200529
053100200529     D FieldNo         S              5P 0
053200200529
053300200529     D FldOffsetP      S              5P 0
053400200529     D FldOffsetS      S              5P 0
053500200529      *                                                                         CSE023
053600200529      ** Country of treaty                                                      CSE023
053700200529     D PDRBW           S              2A                                        CSE023
053800200529      *                                                                         CSE023
053900200529      ** Withholding tax                                                        CSE023
054000200529     D DDWTAX          S             15A                                        CSE023
054100200529                                                                                              CSW201
054200200529      ** Swift 2001 flag                                                                      CSW201
054300200529     D CSW201          S              1A                                                      CSW201
054400200529                                                                                              CGL031
054500200529      ** CGL031 flag                                                                          CGL031
054600200529     D CGL031          S              1A                                                      CGL031
054700200529
054800200529      ** End of fields for getting starting field number
054900200529                                                                                              CSC011
055000200529     D CSC011          S              1A                                                      CSC011
055100200529     D KMsgType        S              8A                                                      CSC011
055200200529     D KFrntOffID      S             20A                                                      CSC011
055300200529     D KTimeStamp      S                   LIKE(ABTMESTMP)                                    CSC011
055400200529     D PRTCD           S              7A                                                      CSC011
055500200529     D POPTN           S              7A                                                      CSC011
055600200529     D PSARD           S              6A                                                      CSC011
055700200529                                                                                              CSC011
055800200529     D PMODE           S              3A                                                      210517
055900200529                                                                                              210517
056000200529     D CAS006          S              1                                                       CAS006
056100200529     D DDHACR          S             13                                                       CAS006
056200200529     D DDPRICN         S             17                                                       CAS006
056300200529     D WIdx_TVAL       S              3  0                                                    CAS006
056400200529                                                                                              CAS006
056500200529     D CSC022          S              1A                                                      CSC022
056600200529                                                                                              CSC022
056700200529     D WCommitSkip     S              1A                                                      CSC022
056800200529      ** Commitment Skip Field                                                                CSC022
056900200529                                                                                              CSC022
057000200529     D CGL014          S              1A                                                     BUG3145
057100200529     D DATALUX         DS          1024                                                       CER001
057200200529     D  QPETDRF                1      6                                                       CER001
057300200529     D  QUTDBK                 7      8                                                       CER001
057400200529     D  QUVTCNR                9     14                                                       CER001
057500200529     D  #1TDVD                15     19  0                                                    CER001
057600200529     D  #1TDDT                20     24  0                                                    CER001
057700200529     D  #1ISSD                25     29  0                                                    CER001
057800200529     D  #1MATY                30     34  0                                                    CER001
057900200529     D  #1FOTR                35     54                                                       CER001
058000200529     D  #1TMST                55     80Z                                                      CER001
058100200529     D  #1DEXT                81     81                                                       CER001
058200200529                                                                                              CER001
058300200529      ** Variables used by change CER001                                                      CER001
058400200529     D ULX603          S              1A                                                      CER001
058500200529     D ULX008          S              1A                                                      CER001
058600200529     D P@RtnCode       S              1A                                                      CER001
058700200529                                                                                              CER001
058800200529     D WFIND           S              1                                                       CER001
058900200529     D ZDAYN           S              5P 0                                                    CER001
059000200529     D ZDATE           S              6P 0                                                    CER001
059100200529     D ZADATE          S              7                                                       CER001
059200200529     D PRV_SCRN        S              1                                                       CER001
059300200529     D K@TDRF          S                   LIKE(CCTDRF)                                       CER001
059400200529     D CallFromVU      S              1A   INZ(' ')                                           CAP087
059500200529      ** Front office id variable.                                                         AR698195B
059600200529     D DDFRNT          S             20A                                                   AR698195B
059700200529      ** -------------------------------------------------------------------
059800200529
059900200529      ** +--------------------------------------+
060000200529      ** ¦ End of D-specs                       ¦
060100200529      ** ¦ ==============                       ¦
060200200529      ** +--------------------------------------+
060300200529
060400200529      ** +----------------------------------------+
060500200529      ** ¦ Hook for non-core D-specs (all types)  ¦
060600200529      ** ¦ also any I-specs (if necessary)        ¦
060700200529      ** ¦ =====================================  ¦
060800200529      ** +----------------------------------------+
060900200529      /COPY WNCPYSRC,SETRADR012
061000200529
061100200529      *****************************************************************
061200200529      /EJECT
061300200529      *****************************************************************
061400200529     C
061500200529      ** +--- Start of Main processing -----------------------------------+
061600200529      ** ¦                                                                ¦
061700200529      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
061800200529      ** ¦ executed at program activation.                                ¦
061900200529      ** ¦                                                                ¦
062000200529      ** +----------------------------------------------------------------+
062100200529      *                                                                         140951
062200200529      /COPY WNCPYSRC,SETRADR001
062300200529      *                                                                         140951
062400200529      * Issue rollback to clear any possible updates in window functions        140951
062500200529      *                                                                         140951
062600200529     C     @INKE         IFEQ      '1'                                          140951
062700200529     C     @INKL         OREQ      '1'                                          140951
062800200529     C                   If        (CSC022 <> 'Y')                                            CSC022
062900200529     C                   ROLBK                                                  140951
063000200529     C                   Else                                                                 CSC022
063100200529     C                   If        (WCommitSkip <> 'Y')                                       CSC022
063200200529     C                   ROLBK                                                                CSC022
063300200529     C                   Else                                                                 CSC022
063400200529     C                   Seton                                        U7U8                    CSC022
063500200529     C                   EndIf                                                                CSC022
063600200529     C                   EndIf                                                                CSC022
063700200529     C                   END                                                    140951
063800200529      *
063900200529      /COPY WNCPYSRC,SETRADR002
064000200529      *
064100200529      * DO SCREEN: BROWSE INVALID DEALS
064200200529      *
064300200529     C     @SCRN         IFEQ      'I'
064400200529      *                                                                                       CAP067
064500200529      ** If trade is a buy-sell and action is either delete, authorise or                     CAP067
064600200529      ** approve, set flag that displays message that the other leg is also                   CAP067
064700200529      ** deleted, authorised or approved on the initial screen                                CAP067
064800200529      *                                                                                       CAP067
064900200529     C     BDBYSL        IFEQ      'Y'                                                        CAP067
065000200529     C     LKRF          ANDNE     *BLANKS                                                    CAP067
065100200529      *                                                                                       CAP067
065200200529     C     DDACTN        IFEQ      'D'                                                        CAP067
065300200529     C     DDACTN        OREQ      'P'                                                        CAP067
065400200529     C     DDACTN        OREQ      'Y'                                                        CAP067
065500200529     C                   EVAL      PDPYMS = 'Y'                                               CAP067
065600200529     C                   ENDIF                                                                CAP067
065700200529      *                                                                                       CAP067
065800200529     C                   ENDIF                                                                CAP067
065900200529      *                                                                                       CAP067
066000200529     C                   EXSR      SCRN@I
066100200529     C                   END
066200200529      *
066300200529      /COPY WNCPYSRC,SETRADR003
066400200529      *
066500200529      ** Read next browse subfile record
066600200529      *
066700200529     C     @SCRN         IFEQ      'R'
066800200529     C                   EXSR      RDNBRW
066900200529     C                   MOVE      'N'           WKPASS            1                          CAP067
067000200529     C                   MOVE      'N'           WKDSPL            1                          CAP067
067100200529     C                   ENDIF
067200200529      *
067300200529      /COPY WNCPYSRC,SETRADR004
067400200529      *
067500200529      ** DO WHILE screen: Primary Details Screen
067600200529      *
067700200529     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
067800200529     C     @SCRN         DOWEQ     'P'
067900200529     C                   EXSR      Scrn@P
068000200529     C                   ENDDO
068100200529      *
068200200529      /COPY WNCPYSRC,SETRADR005
068300200529      *
068400200529      ** DO WHILE screen: Secondary Details Screen
068500200529      *
068600200529     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
068700200529     C     @SCRN         DOWEQ     'S'
068800200529     C                   EXSR      Scrn@S
068900200529     C                   ENDDO
069000200529      *
069100200529                                                                                              CAS006
069200200529      /COPY WNCPYSRC,SETRADR017                                                               CAS006
069300200529                                                                                              CAS006
069400200529      ** DO WHILE screen: Third Details Screen                                                CAS006
069500200529                                                                                              CAS006
069600200529     C                   IF        CAS006 = 'Y'                                               CAS006
069700200529     C                   EVAL      WIdx_TVAL = 0                                              CAS006
069800200529     C                   DOW       @SCRN = 'H'                                                CAS006
069900200529     C                   EXSR      Scrn@T                                                     CAS006
070000200529     C                   ENDDO                                                                CAS006
070100200529     C                   ENDIF                                                                CAS006
070200200529      /COPY WNCPYSRC,SETRADR006
070300200529      *
070400200529      ** DO WHILE screen: Other Details Screen
070500200529      *
070600200529     C                   Z-ADD     *ZERO         WIdx_OVAL         3 0
070700200529     C     @SCRN         DOWEQ     'O'
070800200529     C                   EXSR      Scrn@O
070900200529     C                   ENDDO
071000200529      *
071100200529      /COPY WNCPYSRC,SETRADR007
071200200529      *
071300200529      ** DO WHILE screen: Extension (SWIFT) Details Screen A
071400200529      *
071500200529     C                   Z-ADD     *ZERO         WIdx_EVALA        3 0
071600200529     C                   MOVE      'N'           WKSHOW            1                          CAP067
071700200529     C                   EVAL      PUYAT = 'N'                                                201429
071800200529     C     @SCRN         DOWEQ     'A'
071900200529     C                   EXSR      Scrn@E_A
072000200529     C                   ENDDO
072100200529      *
072200200529      /COPY WNCPYSRC,SETRADR008
072300200529      *
072400200529      ** DO WHILE screen: Extension (SWIFT) Details Screen B
072500200529      *
072600200529     C                   Z-ADD     *ZERO         WIdx_EVALB        3 0
072700200529     C                   EVAL      PUYAT = 'N'                                                201429
072800200529     C     @SCRN         DOWEQ     'B'
072900200529     C                   EXSR      Scrn@E_B
073000200529     C                   ENDDO
073100200529      *                                                                                       CER001
073200200529      ** Process extension record                                                             CER001
073300200529      *                                                                                       CER001
073400200529     C                   IF        @SCRN   = 'L'                                              CER001
073500200529     C                   EXSR      SRSETRAD2RP                                                CER001
073600200529     C                   ENDIF                                                                CER001
073700200529      *
073800200529      /COPY WNCPYSRC,SETRADR009
073900200529      *                                                                         174875
074000200529      ** Screen: Window                                                         174875
074100200529      *                                                                         174875
074200200529     C     @SCRN         IFEQ      'W'                                          174875
074300200529     C                   EXSR      WINDOW                                       174875
074400200529     C                   ENDIF                                                  174875
074500200529      *
074600200529      ** Do File updates
074700200529      *
074800200529     C     @SCRN         IFEQ      'U'
074900200529     C                   EXSR      UPDATS
075000200529      *                                                                                       CAP067
075100200529      ** If Trade is a Buy-Sell, show other leg                                               CAP067
075200200529      *                                                                                       CAP067
075300200529     C     BDBYSL        IFEQ      'Y'                                                        CAP067
075400200529     C     @RTCD         ANDEQ     *BLANKS                                                    CAP067
075500200529     C     LKRF          ANDNE     *BLANKS                                                    CAP067
075600200529     C     WKPASS        ANDEQ     'N'                                                        CAP067
075700200529     C                   EXSR      SRRDNL                                                     CAP067
075800200529     C                   MOVE      'Y'           WKPASS                                       CAP067
075900200529     C                   MOVE      'Y'           WKDSPL                                       CAP067
076000200529     C                   ENDIF                                                                CAP067
076100200529      *                                                                                       CAP067
076200200529     C                   ENDIF
076300200529      *
076400200529      /COPY WNCPYSRC,SETRADR010
076500200529      *
076600200529      ** Terminate program
076700200529      *
076800200529     C     @SCRN         IFEQ      'T'
076900200529     C                   MOVE      *ON           *INLR
077000200529     C                   ENDIF
077100200529      *
077200200529      *****************************************************************         174875
077300200529      * WINDOW - CALL WINDOW MANAGER                                            174875
077400200529      *****************************************************************         174875
077500200529     C     WINDOW        BEGSR                                                  174875
077600200529                                                                                174875
077700200529      *                                                                         174875
077800200529      ** Reset Errors ....                                                      174875
077900200529      *                                                                         174875
078000200529     C                   MOVE      *ALL'Y'       OKTrSwft                       174875
078100200529     C                   MOVEL     *BLANK        FldNameArr                     174875
078200200529     C                   MOVEL     *BLANK        MsgIdArr                       174875
078300200529     C                   MOVEL     *BLANK        MsgDtaArr                      174875
078400200529     C                   MOVEL     *BLANK        WFldNamArr                     174875
078500200529     C                   MOVEL     *BLANK        WMsgIdArr                      174875
078600200529     C                   MOVEL     *BLANK        WMsgDtaArr                     174875
078700200529      *                                                                         174875
078800200529      **  If trade reference is not defined (On Insert),                        174875
078900200529      **  get next available trade reference                                    174875
079000200529      *                                                                         174875
079100200529     C     DDTDRF        IFEQ      *BLANK                                       174875
079200200529      *                                                                         174875
079300200529     C                   CALLB     'ZATRNRTV'                                   174875
079400200529     C                   PARM      *BLANKS       RetCodeOut                     174875
079500200529     C                   PARM      'SE'          MODU              2            174875
079600200529     C                   PARM      'T'           TRTY              1            174875
079700200529     C                   PARM                    DDTDRF                         174875
079800200529     C                   PARM      *ZERO         TDRF                           174875
079900200529      *                                                                         174875
080000200529      ** Database Error                                                         174875
080100200529      *                                                                         174875
080200200529     C     RetCodeOut    IFNE      *BLANK                                       174875
080300200529     C                   MOVEL     'ZATRNRTV'    DBFILE                         174875
080400200529     C                   MOVEL     '999'         DBASE                          174875
080500200529     C                   MOVEL     DDTDRF        DBKEY                          174875
080600200529     C                   EXSR      *PSSR                                        174875
080700200529     C                   ENDIF                                                  174875
080800200529     C                   ENDIF                                                  174875
080900200529                                                                                174875
081000200529     C/COPY QWINDSRC,SETRADMOV1                                                 174875
081100200529                                                                                174875
081200200529     C                   CALL      'WN0010'                                     174875
081300200529     C                   PARM      'SETRADRPR'   #PGM             10            174875
081400200529     C                   PARM                    FKEY              2            174875
081500200529     C                   PARM      DDACTN        ACTION            1            174875
081600200529     C                   PARM                    DATA                           174875
081700200529     C                   PARM      *BLANKS       #RTRN             7            174875
081800200529     C                   PARM                    SPAREW          256            174875
081900200529                                                                                174875
082000200529     C/COPY WNCPYSRC,SETRADRC02
082100200529      *                                                                         174875
082200200529      ** Process returned command keys                                          174875
082300200529      *                                                                         174875
082400200529     C     #RTRN         IFEQ      'Y2U9999'                                    174875
082500200529     C                   EXSR      ENDP                                         174875
082600200529     C                   ELSE                                                   174875
082700200529      *                                                                         174875
082800200529      *  If Cmd12 pressed, or in enquiry, return to initial screen;             174875
082900200529     C/COPY WNCPYSRC,SETRADRC06
083000200529      ** If Cmd12 pressed, or in enquiry, return to initial screen;             174875
083100200529      ** otherwise, go to settlements screen                                    174875
083200200529      *                                                                         174875
083300200529     C     #RTRN         IFEQ      'USR0790'                                    174875
083400200529     C     DDACTN        OREQ      'E'                                          174875
083500200529     C     @OPSEL        OREQ      'N'                                                       BUG9617
083600200529     C     @RDNB         IFEQ      'Y'                                          174875
083700200529     C                   EVAL      @SCRN = 'R'                                  174875
083800200529     C                   ELSE                                                   174875
083900200529     C                   EXSR      INITIAL                                      174875
084000200529     C                   ENDIF                                                  174875
084100200529     C                   ELSE                                                   174875
084200200529     C                   EVAL      @SCRN = 'U'                                  174875
084300200529     C                   ENDIF                                                  174875
084400200529     C/COPY WNCPYSRC,SETRADRC07
084500200529     C                   ENDIF                                                  174875
084600200529      *                                                                         174875
084700200529     C     WIND          ENDSR                                                  174875
084800200529      *****************************************************************         174875
084900200529      /EJECT                                                                    174875
085000200529      *****************************************************************         174875
085100200529      *****************************************************************
085200200529
085300200529      * Hook to enable non-core subroutines to be included
085400200529      /COPY WNCPYSRC,SETRADR013
085500200529
085600200529      /EJECT
085700200529      *****************************************************************
085800200529      * SCRN@I - BROWSE INVALID TRADES
085900200529      *****************************************************************
086000200529     C     SCRN@I        BEGSR
086100200529      *
086200200529      * RESET READ NEXT BROWSE SUBFILE RECORD
086300200529      *
086400200529     C                   MOVEL     *BLANK        @RDNB             1
086500200529      *
086600200529      * BUILD BROWSE SUBFILE
086700200529      *
086800200529     C                   CALLB     'SETRADRPB'
086900200529      *
087000200529      * INPUT PARAMETERS
087100200529      *
087200200529      * RETURN CODE
087300200529     C                   PARM      *BLANK        RetCodeOut
087400200529      *
087500200529      * BUILD SUB-FILE
087600200529     C                   PARM      'Y'           @BDSFL            1
087700200529      *
087800200529      * READ SUBFILE RECORD
087900200529     C                   PARM      *BLANK        @RDSFL            1
088000200529      *
088100200529      * Error in update of previous deal                                        CAP006
088200200529     C                   PARM                    @ERRUP            1            CAP006
088300200529      *                                                                                       CAP067
088400200529      * Display message for buy-sell transactions                                             CAP067
088500200529     C                   PARM                    PDPYMS            1                          CAP067
088600200529      *
088700200529      * OUTPUT PARAMETERS
088800200529      *
088900200529      * ERROR MESSAGE
089000200529     C                   PARM      *BLANK        @ERRMS            7
089100200529      *
089200200529      * OPTION SELECTED
089300200529     C                   PARM                    @OPSEL            1
089400200529      *
089500200529      * ACTION SELECTED
089600200529     C                   PARM                    @ACSEL            1
089700200529      *
089800200529      * FO TRANSACTION ID SELECTED
089900200529     C                   PARM                    @FOTRANSEL       20
090000200529      *
090100200529      * TIMESTAMP OF TRANSACTION SELECTED
090200200529     C                   PARM                    @TMESTPSEL
090300200529      *
090400200529      * COMMAND KEYS
090500200529     C                   PARM      '0'           @INKC             1
090600200529     C                   PARM      '0'           @INKL             1
090700200529      *                                                                         166907
090800200529      ** Successfully Inserted Deal Number                                      166907
090900200529      *                                                                         166907
091000200529     C                   PARM                    @SITR                          166907
091100200529      **********                                                                       CAP067 222373
091200200529      ***Successful insert Trade 2                                                     CAP067 222373
091300200529     C**********         PARM                    PSITR             6                   CAP067 222373
091400200529     C                   PARM                    CSC011                                       CSC011
091500200529      *
091600200529      * If error set on external switches
091700200529      *
091800200529     C     @ERRMS        IFNE      *BLANK
091900200529     C                   MOVE      '1'           *INU6
092000200529     C                   END
092100200529      *
092200200529      * If CK/3 or CK/12 taken in browse, or error message
092300200529      * End program
092400200529      *
092500200529     C     @INKC         IFEQ      '1'
092600200529     C     @INKL         OREQ      '1'
092700200529     C     @ERRMS        ORNE      *BLANK
092800200529     C                   EXSR      ENDP
092900200529     C                   GOTO      ESCRN@I
093000200529     C                   END
093100200529      *
093200200529      * Read next browse subfile record
093300200529      *
093400200529     C                   MOVE      'Y'           @RDNB
093500200529     C                   MOVE      'R'           @SCRN
093600200529      *
093700200529     C     ESCRN@I       ENDSR
093800200529      *****************************************************************
093900200529      /EJECT
094000200529      *****************************************************************
094100200529      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
094200200529      *****************************************************************
094300200529     C     RDNBRW        BEGSR
094400200529      *
094500200529      * READ NEXT SUBFILE RECORD
094600200529      *
094700200529     C                   CALLB     'SETRADRPB'
094800200529      *
094900200529      * INPUT PARAMETERS
095000200529      *
095100200529      * RETURN CODE
095200200529     C                   PARM      *BLANK        RetCodeOut
095300200529      *
095400200529      * BUILD SUB-FILE
095500200529     C                   PARM      *BLANK        @BDSFL            1
095600200529      *
095700200529      * READ SUBFILE RECORD
095800200529     C                   PARM      'Y'           @RDSFL            1
095900200529      *
096000200529      * Error in update of previous deal                                        CAP006
096100200529     C                   PARM                    @ERRUP            1            CAP006
096200200529      *                                                                                       CAP067
096300200529      * Display message for buy-sell transactions                                             CAP067
096400200529     C                   PARM                    PDPYMS            1                          CAP067
096500200529      *                                                                         CAP006
096600200529      * OUTPUT PARAMETERS
096700200529      *
096800200529      * ERROR MESSAGE
096900200529     C                   PARM      *BLANK        @ERRMS            7
097000200529      *
097100200529      * OPTION SELECTED
097200200529     C                   PARM      *BLANK        @OPSEL            1
097300200529      *
097400200529      * ACTION SELECTED
097500200529     C                   PARM      *BLANK        @ACSEL            1
097600200529      *
097700200529      * FO TRANSACTION ID SELECTED
097800200529     C                   PARM      *BLANK        @FOTRANSEL       20
097900200529      *
098000200529      * TIMESTAMP OF TRANSACTION SELECTED
098100200529     C                   PARM                    @TMESTPSEL
098200200529      *
098300200529      * COMMAND KEYS
098400200529     C                   PARM      '0'           @INKC             1
098500200529     C                   PARM      '0'           @INKL             1
098600200529      *                                                                         166907
098700200529      ** Successfully Inserted Deal Number                                      166907
098800200529      *                                                                         166907
098900200529     C                   PARM                    @SITR                          166907
099000200529      **********                                                                       CAP067 222373
099100200529      ***Successful insert Trade 2                                                     CAP067 222373
099200200529     C**********         PARM                    PSITR                                 CAP067 222373
099300200529     C                   PARM                    CSC011                                       CSC011
099400200529      *                                                                         CAP004
099500200529      * If CK/3 taken within invalid transaction deletion function,             CAP004
099600200529      * End program                                                             CAP004
099700200529      *                                                                         CAP004
099800200529     C     @INKC         IFEQ      '1'                                          CAP004
099900200529     C                   EXSR      ENDP                                         CAP004
100000200529     C                   GOTO      ERDNBRW                                      CAP004
100100200529     C                   END                                                    CAP004
100200200529      *
100300200529      * IF INVALID TRADE READ FROM SUBFILE
100400200529      *
100500200529     C     @OPSEL        IFNE      *BLANK
100600200529      *
100700200529      * BLANK THE SCREENS
100800200529      *
100900200529     C                   MOVEL     *BLANK        NewTrPrim
101000200529     C                   MOVEL     *BLANK        NewTrSeco
101100200529     C                   MOVEL     *BLANK        NewTrExch
101200200529     C                   MOVEL     *BLANK        NewTrSett
101300200529     C                   MOVEL     *BLANK        NewTrChcm
101400200529     C                   MOVEL     *BLANK        NewTrSwftA
101500200529     C                   MOVEL     *BLANK        NewTrSwftB
101600200529     C                   MOVEL     *BLANK        NewTrExtA                                    CSE045
101700200529     C                   MOVEL     *BLANK        NewTrExtB                                    CSE045
101800200529     C                   MOVEL     *BLANK        DDSTAT
101900200529     C                   MOVEL     *BLANK        DDAUTH
102000200529     C**********         MOVEL     *BLANK        DDSRPN                                       CSE016
102100200529     C                   MOVEL     *BLANK        DDSRNME                                      CSE016
102200200529     C                   MOVEL     *BLANK        DDCRNM
102300200529     C                   MOVEL     *BLANK        DDCFCT
102400200529     C                   MOVEL     *BLANK        DDCPNR
102500200529     C                   MOVEL     *BLANK        DDMAMT
102600200529     C                   MOVEL     *BLANK        DDSPXR
102700200529     C                   MOVEL     *BLANK        DDSPMD
102800200529     C                   MOVEL     *BLANK        DDTCTR
102900200529      *
103000200529      * RESET ERRORS
103100200529      *
103200200529     C                   MOVE      *ALL'Y'       OKTrPrim
103300200529     C                   MOVE      *ALL'Y'       OKTrSeco
103400200529     C                   MOVE      *ALL'Y'       OKTrExch
103500200529     C                   MOVE      *ALL'Y'       OKTrSett
103600200529     C                   MOVE      *ALL'Y'       OKTrChcm
103700200529     C                   MOVE      *ALL'Y'       OKTrSwft
103800200529     C                   MOVE      *ALL'Y'       OKTrExts                                     CSE045
103900200529     C                   MOVEL     *BLANK        FldNameArr
104000200529     C                   MOVEL     *BLANK        MsgIdArr
104100200529     C                   MOVEL     *BLANK        MsgDtaArr
104200200529     C                   MOVEL     *BLANK        WFldNamArr
104300200529     C                   MOVEL     *BLANK        WMsgIdArr
104400200529     C                   MOVEL     *BLANK        WMsgDtaArr
104500200529      *
104600200529      * Retrieve trade details
104700200529      *
104800200529     C                   MOVEL     @ACSEL        DDACTN
104900200529     C                   MOVEL     @FOTRANSEL    FOTRID
105000200529     C*******************MOVEL     '*FRONT'      @@MODE                         CAP013
105100200529      *                                                                         CAP013
105200200529      * Make sure Invalid transaction's  details are passed to 'Retrieve'       CAP013
105300200529      * module for SPF checking .                                               CAP013
105400200529      *                                                                         CAP013
105500200529     C     ZATRNKX0      CHAIN     SEITRADX0                          99        CAP013
105600200529      *                                                                         CAP013
105700200529      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
105800200529      *  if insert                                                              CAP013
105900200529      *  if not insert and Midas transaction ID is not present                  CAP013
106000200529      * Otherwise                                                               CAP013
106100200529      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
106200200529      *                                                                         CAP013
106300200529     C     DDACTN        IFEQ      'I'                                          CAP013
106400200529     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
106500200529     C                   ELSE                                                   CAP013
106600200529     C     DDTDRF        IFEQ      *BLANK                                       CAP013
106700200529     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
106800200529     C                   ELSE                                                   CAP013
106900200529     C                   MOVEL     '      '      @@MODE                         CAP013
107000200529     C                   ENDIF                                                  CAP013
107100200529     C                   ENDIF                                                  CAP013
107200200529      *                                                                                       CAP067
107300200529     C                   CALL      'AOBOOKR0'                                                 CAP067
107400200529     C                   PARM      *BLANK        @RTCD             7                          CAP067
107500200529     C                   PARM      '*KEY   '     @OPTN             7                          CAP067
107600200529     C                   PARM      DDBPBK        @BOOK             2                          CAP067
107700200529     C     SDBOOK        PARM      SDBOOK        DSFDY                                        CAP067
107800200529      *                                                                         CAP013
107900200529     C                   MOVE      'Y'           WKFLEG            1                          CAP067
108000200529     C                   EXSR      RTVTRD
108100200529      *                                                                                       CER001
108200200529      ** Retrieve record in extension file if switchable is on                                CER001
108300200529      *                                                                                       CER001
108400200529     C                   IF        ULX603  = 'Y'                                              CER001
108500200529     C                   EXSR      RTVTRDLUX                                                  CER001
108600200529     C                   ENDIF                                                                CER001
108700200529      *
108800200529      * If trade details were retrieved
108900200529      * Convert the trade to screen format.
109000200529      *
109100200529     C     C_TDRF        IFNE      *BLANK
109200200529     C     DDACTN        ANDNE     'I'
109300200529     C                   EXSR      CVTTRD
109400200529     C                   MOVEL     CrTrFilFmt    NwTrFilFmt
109500200529     C                   MOVEL     CT1AFilFmt    NT1AFilFmt
109600200529     C                   MOVEL     CT1BFilFmt    NT1BFilFmt
109700200529     C                   END
109800200529      *
109900200529      * Now overwite the fields on the main details screen with those
110000200529      * on the invalid trades file (except for the Midas trade
110100200529      * reference retrieved above using the front office transaction ID).
110200200529      * Access invalid deal with timestamp and front office transaction ID.
110300200529      *
110400200529     C                   MOVEL     DDTDRF        ##DDTDRF          6
110500200529     C     ZATRNKX0      CHAIN     SEITRADX0                          99
110600200529
110700200529     C     C_TDRF        IFNE      *BLANK
110800200529     C     DDACTN        ANDNE     'I'
110900200529     C                   MOVEL     ##DDTDRF      DDTDRF
111000200529     C                   END
111100200529      *
111200200529      * Set up SWIFT 'A' and 'B' screens
111300200529      *
111400200529     C                   MOVEL     InvTrSwftA    NewTrSwftA
111500200529     C                   MOVEL     InvTrSwftB    NewTrSwftB
111600200529      *                                                                         CAP011
111700200529      * If trade details were retrieved and this is an amendment or change      CAP011
111800200529      * Do data substitution if the substitution character is present           CAP011
111900200529      *                                                                         CAP011
112000200529     C     C_TDRF        IFNE      *BLANK                                       CAP011
112100200529     C     DDACTN        ANDEQ     'A'                                          CAP011
112200200529     C     GHSUBS        ANDNE     *BLANK                                       CAP011
112300200529     C     C_TDRF        ORNE      *BLANK                                       CAP011
112400200529     C     DDACTN        ANDEQ     'C'                                          CAP011
112500200529     C     GHSUBS        ANDNE     *BLANK                                       CAP011
112600200529     C     GHSUBS        scan      NewTrPrim                              99    CAP011
112700200529     C  N99GHSUBS        scan      NewTrSeco                              99    CAP011
112800200529     C  N99GHSUBS        scan      NewTrExch                              99    CAP011
112900200529     C  N99GHSUBS        scan      NewTrSett                              99    CAP011
113000200529     C  N99GHSUBS        scan      NewTrChCm                              99    CAP011
113100200529     C  N99GHSUBS        scan      NewTrSwftA                             99    CAP011
113200200529     C  N99GHSUBS        scan      NewTrSwftB                             99    CAP011
113300200529     C     *IN99         IFEQ      *ON                                          CAP011
113400200529     C                   EXSR      TDtDtaSubs                                   CAP011
113500200529     C                   END                                                    CAP011
113600200529     C                   END                                                    CAP011
113700200529      *
113800200529      * If action code, or trade reference were NOT OK
113900200529      * blank out action code so that the input cannot proceed
114000200529      *
114100200529     C     DDACTNOK      IFEQ      'N'
114200200529     C     DDTDRFOK      OREQ      'N'
114300200529     C                   MOVEL     *BLANK        DDACTN
114400200529     C                   END
114500200529      *
114600200529      * If Action code is blank (see above) or 'I'
114700200529      * (Action code can only be ' ', 'I', 'A', 'C', 'D', 'P' or 'Y')
114800200529      *
114900200529     C     DDACTN        IFEQ      ' '
115000200529     C     DDACTN        OREQ      'I'
115100200529      *
115200200529      * Send the trades error messages to the primary details screen
115300200529      * and GO TO PRIMARY DETAILS SCREEN
115400200529      *
115500200529     C                   EXSR      SNDM@P
115600200529     C                   MOVE      'P'           @SCRN
115700200529
115800200529     C                   ELSE
115900200529      *
116000200529      * Send the trades error messages to the secondary details screen(s)
116100200529      * and GO TO SECONDARY DETAILS SCREEN
116200200529      *
116300200529     C                   EXSR      SNDM@P
116400200529     C                   EXSR      SNDM@S
116500200529     C                   MOVE      'S'           @SCRN
116600200529     C                   END
116700200529      *
116800200529      * ELSE IF NO INVALID TRADE READ FROM SUBFILE
116900200529      *
117000200529     C                   ELSE
117100200529      *
117200200529      * GO TO BROWSE SCREEN
117300200529      *
117400200529     C                   MOVE      'I'           @SCRN
117500200529     C                   END
117600200529      *
117700200529     C     ERDNBRW       ENDSR                                                  CAP004
117800200529     C*******************ENDSR                                                  CAP004
117900200529      *****************************************************************
118000200529      /EJECT                                                                                  CAP067
118100200529      *****************************************************************                       CAP067
118200200529      *                                                               *                       CAP067
118300200529      * SRRDNL - Reads/Displays next leg of a buy and sell trades     *                       CAP067
118400200529      *          transaction                                          *                       CAP067
118500200529      *                                                               *                       CAP067
118600200529      * Called by: Main                                               *                       CAP067
118700200529      *                                                               *                       CAP067
118800200529      * Calls: SR/RTVTRD                                              *                       CAP067
118900200529      *                                                               *                       CAP067
119000200529      *****************************************************************                       CAP067
119100200529     C     SRRDNL        BEGSR                                                                CAP067
119200200529      *                                                                                       CAP067
119300200529      * Blank the screens                                                                     CAP067
119400200529      *                                                                                       CAP067
119500200529     C                   MOVEL     *BLANK        NewTrPrim                                    CAP067
119600200529     C                   MOVEL     *BLANK        NewTrSeco                                    CAP067
119700200529     C                   MOVEL     *BLANK        NewTrExch                                    CAP067
119800200529     C                   MOVEL     *BLANK        NewTrSett                                    CAP067
119900200529     C                   MOVEL     *BLANK        NewTrChcm                                    CAP067
120000200529     C                   MOVEL     *BLANK        NewTrSwftA                                   CAP067
120100200529     C                   MOVEL     *BLANK        NewTrSwftB                                   CAP067
120200200529     C                   MOVEL     *BLANK        DDSTAT                                       CAP067
120300200529     C                   MOVEL     *BLANK        DDAUTH                                       CAP067
120400200529     C                   MOVEL     *BLANK        DDSRNME                                      CAP067
120500200529     C                   MOVEL     *BLANK        DDCRNM                                       CAP067
120600200529     C                   MOVEL     *BLANK        DDCFCT                                       CAP067
120700200529     C                   MOVEL     *BLANK        DDCPNR                                       CAP067
120800200529     C                   MOVEL     *BLANK        DDMAMT                                       CAP067
120900200529     C                   MOVEL     *BLANK        DDSPXR                                       CAP067
121000200529     C                   MOVEL     *BLANK        DDSPMD                                       CAP067
121100200529     C                   MOVEL     *BLANK        DDTCTR                                       CAP067
121200200529      *                                                                                       CAP067
121300200529      * Reset errors                                                                          CAP067
121400200529      *                                                                                       CAP067
121500200529     C                   MOVE      *ALL'Y'       OKTrPrim                                     CAP067
121600200529     C                   MOVE      *ALL'Y'       OKTrSeco                                     CAP067
121700200529     C                   MOVE      *ALL'Y'       OKTrExch                                     CAP067
121800200529     C                   MOVE      *ALL'Y'       OKTrSett                                     CAP067
121900200529     C                   MOVE      *ALL'Y'       OKTrChcm                                     CAP067
122000200529     C                   MOVE      *ALL'Y'       OKTrSwft                                     CAP067
122100200529     C                   MOVEL     *BLANK        FldNameArr                                   CAP067
122200200529     C                   MOVEL     *BLANK        MsgIdArr                                     CAP067
122300200529     C                   MOVEL     *BLANK        MsgDtaArr                                    CAP067
122400200529     C                   MOVEL     *BLANK        WFldNamArr                                   CAP067
122500200529     C                   MOVEL     *BLANK        WMsgIdArr                                    CAP067
122600200529     C                   MOVEL     *BLANK        WMsgDtaArr                                   CAP067
122700200529      *                                                                                       CAP067
122800200529      * Retrieve trade details                                                                CAP067
122900200529      *                                                                                       CAP067
123000200529     C                   MOVEL     @ACSEL        DDACTN                                       CAP067
123100200529     C                   MOVEL     LKRF          DDTDRF                                       CAP067
123200200529      *                                                                                       CAP067
123300200529      * Set retrieve mode to blank                                                            CAP067
123400200529      *                                                                                       CAP067
123500200529     C                   MOVEL     '      '      @@MODE                                       CAP067
123600200529      *                                                                                       CAP067
123700200529     C                   EXSR      RTVTRD                                                     CAP067
123800200529     C                   MOVEL     C_FRNT        @FOTRANSEL                                   CAP067
123900200529      *                                                                                       CAP067
124000200529      * If trade details were retrieved                                                       CAP067
124100200529      * Convert the trade to screen format.                                                   CAP067
124200200529      *                                                                                       CAP067
124300200529     C     C_TDRF        IFNE      *BLANK                                                     CAP067
124400200529     C     DDACTN        ANDNE     'I'                                                        CAP067
124500200529     C                   EXSR      CVTTRD                                                     CAP067
124600200529     C                   MOVEL     CrTrFilFmt    NwTrFilFmt                                   CAP067
124700200529     C                   MOVEL     CT1AFilFmt    NT1AFilFmt                                   CAP067
124800200529     C                   MOVEL     CT1BFilFmt    NT1BFilFmt                                   CAP067
124900200529     C                   END                                                                  CAP067
125000200529      *                                                                                       CAP067
125100200529      * Now overwite the fields on the main details screen with those                         CAP067
125200200529      * on the invalid trades file (except for the Midas trade                                CAP067
125300200529      * reference retrieved above using the front office transaction ID).                     CAP067
125400200529      * Access invalid deal with timestamp and front office transaction ID.                   CAP067
125500200529      *                                                                                       CAP067
125600200529     C                   MOVEL     DDTDRF        ##DDTDRF          6                          CAP067
125700200529                                                                                              CAP067
125800200529     C     C_TDRF        IFNE      *BLANK                                                     CAP067
125900200529     C     DDACTN        ANDNE     'I'                                                        CAP067
126000200529     C                   MOVEL     ##DDTDRF      DDTDRF                                       CAP067
126100200529     C                   END                                                                  CAP067
126200200529      *                                                                                       CAP067
126300200529      * Set up SWIFT 'A' and 'B' screens                                                      CAP067
126400200529      *                                                                                       CAP067
126500200529     C                   MOVEL     InvTrSwftA    NewTrSwftA                                   CAP067
126600200529     C                   MOVEL     InvTrSwftB    NewTrSwftB                                   CAP067
126700200529      *                                                                                       CAP067
126800200529      * If trade details were retrieved and this is an amendment or change                    CAP067
126900200529      * Do data substitution if the substitution character is present                         CAP067
127000200529      *                                                                                       CAP067
127100200529     C     C_TDRF        IFNE      *BLANK                                                     CAP067
127200200529     C     DDACTN        ANDEQ     'A'                                                        CAP067
127300200529     C     GHSUBS        ANDNE     *BLANK                                                     CAP067
127400200529     C     C_TDRF        ORNE      *BLANK                                                     CAP067
127500200529     C     DDACTN        ANDEQ     'C'                                                        CAP067
127600200529     C     GHSUBS        ANDNE     *BLANK                                                     CAP067
127700200529     C     GHSUBS        scan      NewTrPrim                              99                  CAP067
127800200529     C  N99GHSUBS        scan      NewTrSeco                              99                  CAP067
127900200529     C  N99GHSUBS        scan      NewTrExch                              99                  CAP067
128000200529     C  N99GHSUBS        scan      NewTrSett                              99                  CAP067
128100200529     C  N99GHSUBS        scan      NewTrChCm                              99                  CAP067
128200200529     C  N99GHSUBS        scan      NewTrSwftA                             99                  CAP067
128300200529     C  N99GHSUBS        scan      NewTrSwftB                             99                  CAP067
128400200529     C     *IN99         IFEQ      *ON                                                        CAP067
128500200529     C                   EXSR      TDtDtaSubs                                                 CAP067
128600200529     C                   END                                                                  CAP067
128700200529     C                   END                                                                  CAP067
128800200529      *                                                                                       CAP067
128900200529      * If action code, or trade reference were NOT OK                                        CAP067
129000200529      * blank out action code so that the input cannot proceed                                CAP067
129100200529      *                                                                                       CAP067
129200200529     C     DDACTNOK      IFEQ      'N'                                                        CAP067
129300200529     C     DDTDRFOK      OREQ      'N'                                                        CAP067
129400200529     C                   MOVEL     *BLANK        DDACTN                                       CAP067
129500200529     C                   END                                                                  CAP067
129600200529      *                                                                                       CAP067
129700200529      * If Action code is blank (see above) or 'I'                                            CAP067
129800200529      * (Action code can only be ' ', 'I', 'A', 'C', 'D', 'P' or 'Y')                         CAP067
129900200529      *                                                                                       CAP067
130000200529     C     DDACTN        IFEQ      ' '                                                        CAP067
130100200529     C     DDACTN        OREQ      'I'                                                        CAP067
130200200529      *                                                                                       CAP067
130300200529      * Send the trades error messages to the primary details screen                          CAP067
130400200529      * and GO TO PRIMARY DETAILS SCREEN                                                      CAP067
130500200529      *                                                                                       CAP067
130600200529     C                   EXSR      SNDM@P                                                     CAP067
130700200529     C                   MOVE      'P'           @SCRN                                        CAP067
130800200529                                                                                              CAP067
130900200529     C                   ELSE                                                                 CAP067
131000200529      *                                                                                       CAP067
131100200529      * Send the trades error messages to the secondary details screen(s)                     CAP067
131200200529      * and GO TO SECONDARY DETAILS SCREEN                                                    CAP067
131300200529      *                                                                                       CAP067
131400200529     C     DDACTN        IFNE      'D'                                                        CAP067
131500200529     C     DDACTN        ANDNE     'P'                                                        CAP067
131600200529     C     DDACTN        ANDNE     'Y'                                                        CAP067
131700200529     C     WKDSPL        ANDNE     'Y'                                                        CAP067
131800200529     C                   MOVE      'S'           @SCRN                                        CAP067
131900200529     C                   EXSR      SNDM@P                                                     CAP067
132000200529     C                   EXSR      SNDM@S                                                     CAP067
132100200529     C                   ELSE                                                                 CAP067
132200200529     C                   IF        @OPSEL = 'N'                                              BUG9617
132300200529     C                   EVAL      @SCRN = 'R'                                               BUG9617
132400200529     C                   ELSE                                                                BUG9617
132500200529     C                   MOVE      'U'           @SCRN                                        CAP067
132600200529     C                   ENDIF                                                               BUG9617
132700200529     C                   ENDIF                                                                CAP067
132800200529      *                                                                                       CAP067
132900200529     C                   ENDIF                                                                CAP067
133000200529      *                                                                                       CAP067
133100200529     C                   ENDSR                                                                CAP067
133200200529      *****************************************************************                       CAP067
133300200529      /EJECT
133400200529      *****************************************************************
133500200529      * SNDM@P - SEND A MESSAGE TO PRIMARY DETAILS SCREEN
133600200529      *****************************************************************
133700200529     C     SNDM@P        BEGSR
133800200529
133900200529     C                   Z-ADD     Idx           E                 3 0
134000200529      *
134100200529      ** If there are fundamental errors in this transaction
134200200529      ** Identify this fact.
134300200529      *
134400200529     C     DDACTNOK      IFEQ      'N'
134500200529     C     DDTDRFOK      OREQ      'N'
134600200529     C                   ADD       1             E
134700200529     C                   MOVEL     '*ANY'        FldNameArr(E)
134800200529     C                   MOVEL     'APM0110'     MsgIdArr(E)
134900200529     C                   ENDIF
135000200529      *
135100200529      ** Initialize error indicators
135200200529      *
135300200529     C                   MOVEA     OKTrPrim      @EI
135400200529      *
135500200529      ** Read error messages for trade
135600200529      *
135700200529     C     ZATRNKD0      SETLL     ZATRNERRD0
135800200529     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
135900200529      *
136000200529      ** Add error message to array passed to detail screen
136100200529      ** and set OK flag for field to 'N'
136200200529      *
136300200529     C     *IN99         DOWEQ     '0'
136400200529
136500200529     C     ABFIELDID     IFLT      FldOffsetS
136600200529     C     DDACTN        OREQ      ' '
136700200529     C     DDACTN        OREQ      'I'
136800200529     C     ULX603        ANDEQ     'N'                                                        CER001
136900200529     C                   ADD       1             E
137000200529     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
137100200529     C                   MOVEL     ABMSGID       MsgIdArr(E)
137200200529     C                   Z-ADD     ABFIELDID     F                 3 0
137300200529     C                   SUB       FldOffsetP    F
137400200529     C     F             IFLT      1
137500200529     C     F             ORGT      60
137600200529     C                   Z-ADD     1             F
137700200529     C                   END
137800200529     C                   MOVE      'N'           @EI(F)
137900200529     C                   END
138000200529
138100200529     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
138200200529     C                   END
138300200529      *
138400200529     C                   MOVEA     @EI           OKTrPrim
138500200529      *
138600200529     C                   ENDSR
138700200529      *****************************************************************
138800200529      /EJECT
138900200529      *****************************************************************
139000200529      * SNDM@S - SEND A MESSAGE TO SECONDARY DETAILS SCREEN
139100200529      *****************************************************************
139200200529     C     SNDM@S        BEGSR
139300200529      *
139400200529      ** Initialize error indicators
139500200529      *
139600200529     C                   MOVEA     OKTrSeco      @EI
139700200529      *
139800200529      ** Read error messages for trade
139900200529      *
140000200529     C     ZATRNKD0      SETLL     ZATRNERRD0
140100200529     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
140200200529      *
140300200529      ** Add error message to array passed to detail screen
140400200529      ** and set OK flag for field to 'N'
140500200529      *
140600200529     C     *IN99         DOWEQ     '0'
140700200529
140800200529     C     ABFIELDID     IFGE      FldOffsetS
140900200529     C                   ADD       1             E
141000200529     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
141100200529     C                   MOVEL     ABMSGID       MsgIdArr(E)
141200200529     C                   Z-ADD     ABFIELDID     F                 3 0
141300200529     C                   SUB       FldOffsetS    F
141400200529     C     F             IFLT      1
141500200529     C     F             ORGT      60
141600200529     C                   Z-ADD     1             F
141700200529     C                   END
141800200529     C                   MOVE      'N'           @EI(F)
141900200529     C                   END
142000200529
142100200529     C     ZATRNKD0      READE     ZATRNERRD0                             99    *
142200200529     C                   END
142300200529      *
142400200529     C                   MOVEA     @EI           OKTrSeco
142500200529      *
142600200529     C                   ENDSR
142700200529      *****************************************************************
142800200529      /EJECT
142900200529      *****************************************************************
143000200529      * SCRN@P - PROCESS SCREEN: PRIMARY DETAILS
143100200529      *****************************************************************
143200200529     C     SCRN@P        BEGSR
143300200529      *
143400200529      * Enable/disable detail fields on primary details screen
143500200529      * if changes to the data are allowed                                      CAP014
143600200529      * (key fields = action code & trade reference; detail fields = rest)
143700200529      * (Action code can only be 'I' or ' ' in this subroutine)
143800200529      *
143900200529     C     DDACTN        IFEQ      'I'
144000200529     C     @OPSEL        ANDEQ     'U'                                          CAP014
144100200529     C                   MOVEL     'Y'           @EDTFD
144200200529     C                   ELSE
144300200529     C                   MOVEL     'N'           @EDTFD
144400200529     C                   END
144500200529
144600200529      * Update 'previous' screen
144700200529
144800200529     C                   MOVEL     NewTrPrim     PrvTrPrim
144900200529      *                                                                         206651
145000200529     C     DDSESN        CHAIN     SECTY                              99        206651
145100200529     C     *IN99         IFEQ      '0'                                          206651
145200200529     C                   MOVEL     SC_SRPN       DDSRNME                        206651
145300200529     C                   ENDIF                                                  206651
145400200529      *                                                                         229342
145500200529     C                   CALLB     'AOCUSTR1'                                   229342
145600200529     C                   PARM      '*MSG    '    @RTCD                          229342
145700200529     C                   PARM      '*KEY    '    @OPTN                          229342
145800200529     C                   PARM                    DDCNUM                         229342
145900200529     C                   PARM                    KEY7              7            229342
146000200529     C     SDCUST        PARM      SDCUST        DSLDY                          229342
146100200529      *                                                                         229342
146200200529      ** Customer is a Private Banking Customer: get default value if blank     229342
146300200529      *                                                                         229342
146400200529     C     @RTCD         IFEQ      *BLANKS                                      229342
146500200529     C                   MOVEL     BBCRNM        DDCRNM                         229342
146600200529     C                   ELSE                                                   229342
146700200529     C                   MOVEL     *BLANKS       DDCRNM                         229342
146800200529     C                   ENDIF                                                  229342
146900200529      *                                                                         229342
147000200529     C                   CALLB     'AOCUSTR1'                                   229342
147100200529     C                   PARM      '*MSG    '    @RTCD                          229342
147200200529     C                   PARM      '*KEY    '    @OPTN                          229342
147300200529     C                   PARM                    DDCNUM                         229342
147400200529     C                   PARM                    KEY7              7            229342
147500200529     C     SDCUST        PARM      SDCUST        DSLDY                          229342
147600200529      *                                                                         229342
147700200529      ** Customer is a Private Banking Customer: get default value if blank     229342
147800200529      *                                                                         229342
147900200529     C     @RTCD         IFEQ      *BLANKS                                      229342
148000200529     C                   MOVEL     BBCRNM        DDCRNM                         229342
148100200529     C                   ELSE                                                   229342
148200200529     C                   MOVEL     *BLANKS       DDCRNM                         229342
148300200529     C                   ENDIF                                                  229342
148400200529      *
148500200529      ** WRITE/READ DISPLAY SCREEN - Primary Details
148600200529      *
148700200529     C                   CALLB     'SETRADPDSP'
148800200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
148900200529      * INPUT PARAMETERS :
149000200529      * Return code
149100200529     C                   PARM      *BLANK        RetCodeOut
149200200529      *
149300200529      * Trade (IN SCREEN FORMAT - Primary)
149400200529     C                   PARM                    NewTrPrim
149500200529      * Trade Status
149600200529      * Trade Authorized/Not Authorized
149700200529     C                   PARM                    DDSTAT            9
149800200529     C                   PARM                    DDAUTH           14
149900200529      * Security report name
150000200529      * Customer report name
150100200529     C**********         PARM                    DDSRPN           20                          CSE016
150200200529     C                   PARM                    DDSRNME          41                          CSE016
150300200529     C                   PARM                    DDCRNM           20
150400200529      *
150500200529      * Fields in error
150600200529     C                   PARM                    OKTrPrim
150700200529      *
150800200529      * ERRORS
150900200529     C                   PARM                    FldNameArr
151000200529     C                   PARM                    MsgIdArr
151100200529     C                   PARM                    MsgDtaArr
151200200529      *
151300200529      * WARNINGS
151400200529     C                   PARM                    WFldNamArr
151500200529     C                   PARM                    WMsgIdArr
151600200529     C                   PARM                    WMsgDtaArr
151700200529      * ENABLED KEY FIELDS
151800200529      * ENABLED DETAIL FIELDS
151900200529     C                   PARM      'N'           @EKYFD            1
152000200529     C                   PARM                    @EDTFD            1
152100200529      * Indicator if this program from SE0190                                                 CSE028
152200200529     C                   PARM      'N'           @FRPGM                                       CSE028
152300200529      * ENABLED FUNCTION KEYS
152400200529      * KG = COMMAND KEY 07 = READ PREVIOUS
152500200529      * KH = COMMAND KEY 08 = READ NEXT
152600200529      * KP = COMMAND KEY 15 = BROWSE
152700200529     C                   PARM      'N'           @EINKG            1
152800200529     C                   PARM      'N'           @EINKH            1
152900200529     C                   PARM      'N'           @EINKP            1
153000200529      * Successful insert Trade
153100200529     C                   PARM                    @SITR             6
153200200529      *
153300200529      * Protect book on second leg                                                            CPK014
153400200529     C                   PARM                    IN50              1                          CPK014
153500200529     C                   PARM                    TRDBK1            2                          CPK014
153600200529      *                                                                                       CPK014
153700200529      ** Buy-sell back                                                                        CAP067
153800200529     C                   PARM      'N'           PBYSL             1                          CAP067
153900200529      *                                                                                       CAP067
154000200529      ** Successful insert Trade 2                                                            CAP067
154100200529     C**********         PARM                    PSITR                                 CAP067 222373
154200200529     C                   PARM                    PSITR             6                          222373
154300200529      *                                                                                       CAP067
154400200529      * OUTPUT PARAMETERS :
154500200529      * Function Keys
154600200529     C                   PARM      '0'           @INKC             1
154700200529     C                   PARM      '0'           @INKG             1
154800200529     C                   PARM      '0'           @INKH             1
154900200529     C                   PARM      '0'           @INKL             1
155000200529     C                   PARM      '0'           @INKP             1
155100200529     C**********         PARM      '0'           @INKW             1                   CSE039 222373
155200200529     C**********         PARM      'N'           @INKWDisp         1                   CSE039 222373
155300200529      * Write screen with no read indicator
155400200529     C                   PARM      'N'           WriteOnly         1
155500200529      *
155600200529      * RESET ERRORS ....
155700200529      *
155800200529     C                   MOVE      *ALL'Y'       OKTrPrim
155900200529     C                   MOVEL     *BLANK        FldNameArr
156000200529     C                   MOVEL     *BLANK        MsgIdArr
156100200529     C                   MOVEL     *BLANK        MsgDtaArr
156200200529     C                   MOVEL     *BLANK        WFldNamArr
156300200529     C                   MOVEL     *BLANK        WMsgIdArr
156400200529     C                   MOVEL     *BLANK        WMsgDtaArr
156500200529      *
156600200529      * F3 - End Program
156700200529     C     @INKC         CASEQ     '1'           ENDP
156800200529      *
156900200529      * F12 - Cancel on Primary Screen
157000200529     C     @INKL         CASEQ     '1'           CANC@P
157100200529      *
157200200529      * Validate input to Primary screen
157300200529     C                   CAS                     VAL@P
157400200529     C                   ENDCS
157500200529      *
157600200529     C                   ENDSR
157700200529      *****************************************************************
157800200529      /EJECT
157900200529      *****************************************************************
158000200529      * VAL@P  - VALIDATE INPUT TO PRIMARY DETAILS SCREEN
158100200529      *****************************************************************
158200200529     C     VAL@P         BEGSR
158300200529      *
158400200529      * Retrieve Trade details
158500200529      *
158600200529     C                   MOVEL     '      '      @@MODE
158700200529     C                   EXSR      RTVTRD
158800200529      *
158900200529      * If action code, or trade reference are NOT OK
159000200529      * Re-output screen with error messages on it
159100200529      *
159200200529     C     DDACTNOK      IFEQ      'N'
159300200529     C     DDTDRFOK      OREQ      'N'
159400200529     C                   GOTO      EndVAL@P
159500200529     C                   END
159600200529      *
159700200529      * Prior to validation, initialize error indicators as 'OK'
159800200529      * and clear Trade in File Format
159900200529      *
160000200529     C                   Z-ADD     *ZERO         Idx               3 0
160100200529     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
160200200529     C                   MOVE      *ALL'Y'       OKTrPrim
160300200529     C                   CLEAR                   NwTrFilFmt
160400200529     C                   CLEAR                   NT1AFilFmt
160500200529     C                   CLEAR                   NT1BFilFmt
160600200529     C                   EXSR      SRCLER                                                     CAP067
160700200529      *
160800200529      * Validate Primary trade details
160900200529      *
161000200529     C                   CALLB     'SETRADPVAL'
161100200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
161200200529      * INPUTS :
161300200529
161400200529      * Response mode
161500200529     C                   PARM                    RespMode
161600200529
161700200529      ** Trade Primary Details
161800200529     C                   PARM                    NewTrPrim
161900200529
162000200529      * Custom Extra Data file data                                             CAP004
162100200529     C                   PARM                    ExtData                        CAP004
162200200529      ** Trade settlement currency
162300200529     C                   PARM                    DDSETC
162400200529      *
162500200529      ** Default & Validate (Y or N)
162600200529     C                   PARM      'Y'           Default           1
162700200529     C                   PARM      'Y'           Validate          1
162800200529
162900200529      * Output details of original book.                                                      193462
163000200529     C                   PARM                    OLDBK1                                       193462
163100200529TAS  C                   PARM                    WARNIND                                      193462
163200200529      *                                                                                       193462
163300200529      ** First Buy-sell back indicator                                                        CAP067
163400200529     C                   PARM                    PFBYSL            1                          CAP067
163500200529      *                                                                                       CAP067
163600200529      ** First Buy-sell book code                                                             CAP067
163700200529     C                   PARM                    PFBPBK            2                          CAP067
163800200529      *                                                                                       CAP067
163900200529      ** First Buy-sell counterparty                                                          CAP067
164000200529     C**********         PARM                    PFTCNR            6 0                 CAP067 CSD027
164100200529     C                   PARM                    PFTCNR            6                          CSD027
164200200529      *                                                                                       CAP067
164300200529      ** First Buy-sell trade type                                                            CAP067
164400200529     C                   PARM                    PFTDTP            2                          CAP067
164500200529      *                                                                                       CAP067
164600200529      ** First Buy-sell Value Date                                                            CAP067
164700200529     C                   PARM                    PFTDVD            5 0                        CAP067
164800200529      *                                                                                       CAP067
164900200529      ** First Buy-sell Security Shortname                                                    CAP067
165000200529     C                   PARM                    PFSESN           10                          CAP067
165100200529     C                   PARM                    CallFromVU                                   CAP087
165200200529      * OUTPUTS :
165300200529
165400200529      ** Security Details
165500200529      ** Investment Type Details
165600200529     C*******************PARM                    SECTY                          206651
165700200529     C                   PARM                    SECTY2                         206651
165800200529     C                   PARM                    INVTP
165900200529      * Coupon Rate
166000200529      * Current Factor
166100200529     C                   PARM                    DDCPNR
166200200529     C                   PARM                    DDCFCT
166300200529      ** Nominal Currency Details
166400200529     C                   PARM                    NomCcyDts
166500200529      ** Customer (Counterparty) Details
166600200529     C                   PARM                    CustDts
166700200529      ** Portfolio Details
166800200529     C                   PARM                    PortDts
166900200529      ** Default basket for backup withholding                                  CSE023
167000200529     C                   PARM                    PDRBW                          CSE023
167100200529      ** Trade Primary Details OK inds
167200200529     C                   PARM                    OKTrPrim
167300200529      * Error fields/message IDs/message data (arrays) from/to caller
167400200529     C                   PARM                    FldNameArr
167500200529     C                   PARM                    MsgIDArr
167600200529     C                   PARM                    MsgDtaArr
167700200529      * Array index (3P0) from/to caller
167800200529     C                   PARM                    Idx
167900200529      * Warning fields/message IDs/message data (arrays) from/to caller
168000200529     C                   PARM                    WFldNamArr
168100200529     C                   PARM                    WMsgIDArr
168200200529     C                   PARM                    WMsgDtaArr
168300200529      * Array index (3P0) from/to caller
168400200529     C                   PARM                    WIdx_PVAL
168500200529      * Valid Trade layout (DS) from/to caller
168600200529     C                   PARM                    NwTrFilFmt
168700200529      * PB Order Number                                                                       CPB002
168800200529     C                   PARM                    DDORDE                                       CPB002
168900200529      *
169000200529      * If errors returned
169100200529     C     Idx           IFNE      0
169200200529     C                   GOTO      EndVAL@P
169300200529     C                   END
169400200529      *
169500200529      * Default Secondary Screen details
169600200529      *
169700200529     C                   CALLB     'SETRADSVAL'
169800200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
169900200529      * INPUTS :
170000200529      * Response mode
170100200529     C                   PARM                    RespMode
170200200529      ** Trade Primary Details
170300200529     C                   PARM                    NewTrPrim
170400200529     C                   PARM                    NewTrSeco
170500200529      * Custom Extra Data file data                                             CAP004
170600200529     C                   PARM                    ExtData                        CAP004
170700200529     C/COPY WNCPYSRC,SETRADRC11
170800200529      ** Default & Validate (Y or N)
170900200529     C                   PARM      'Y'           Default           1
171000200529     C                   PARM      'N'           Validate          1
171100200529      ** Security Details
171200200529      ** Investment Type Details
171300200529     C*******************PARM                    SECTY                                        206651
171400200529     C                   PARM                    SECTY2                                       206651
171500200529     C                   PARM                    INVTP
171600200529      ** Nominal Currency Details
171700200529     C                   PARM                    NomCcyDts
171800200529      ** Customer (Counterparty) Details
171900200529     C                   PARM                    CustDts
172000200529      *                                                                                       CPK014
172100200529      ** MT5xx SSI (Phase 2)                                                                  CPK014
172200200529     C                   PARM                    CSE028                                       CPK014
172300200529      * CGL031 Switchable Feature                                                             CGL031
172400200529     C                   PARM                    CGL031                                       CGL031
172500200529      ** Current File Trade Date                                                              244240
172600200529     C                   PARM                    C_TDVD                                       244240
172700200529      * OUTPUTS :
172800200529      ** Settlement Currency Details
172900200529     C                   PARM                    SetCcyDts
173000200529      ** Trade Primary Details OK inds
173100200529     C                   PARM                    OKTrSeco
173200200529      * Error fields/message IDs/message data (arrays) from/to caller
173300200529     C                   PARM                    FldNameArr
173400200529     C                   PARM                    MsgIDArr
173500200529     C                   PARM                    MsgDtaArr
173600200529      * Array index (3P0) from/to caller
173700200529     C                   PARM                    Idx
173800200529      * Warning fields/message IDs/message data (arrays) from/to caller
173900200529     C                   PARM                    WFldNamArr
174000200529     C                   PARM                    WMsgIDArr
174100200529     C                   PARM                    WMsgDtaArr
174200200529      * Array index (3P0) from/to caller
174300200529     C                   PARM                    WIdx_PVAL
174400200529      * Valid Trade layout (DS) from/to caller
174500200529     C                   PARM                    NwTrFilFmt
174600200529      *
174700200529      * Clear any warning messages
174800200529      *
174900200529     C                   MOVE      *ALL'Y'       OKTrPrim
175000200529     C                   MOVE      *ALL'Y'       OKTrSeco
175100200529     C                   MOVEL     *BLANK        WFldNamArr
175200200529     C                   MOVEL     *BLANK        WMsgIdArr
175300200529     C                   MOVEL     *BLANK        WMsgDtaArr
175400200529      *
175500200529      * Go to Secondary details screen
175600200529      *
175700200529     C                   MOVEL     'S'           @SCRN
175800200529      *
175900200529     C     EndVAL@P      ENDSR
176000200529      *****************************************************************                       CAP067
176100200529      /EJECT                                                                                  CAP067
176200200529      *****************************************************************                       CAP067
176300200529      *                                                               *                       CAP067
176400200529      * SRCLER - Clear numeric variables                                                      CAP067
176500200529      *                                                               *                       CAP067
176600200529      * Called by: SR/VAL@P                                           *                       CAP067
176700200529      *                                                               *                       CAP067
176800200529      * Calls: None                                                   *                       CAP067
176900200529      *                                                               *                       CAP067
177000200529      *****************************************************************                       CAP067
177100200529     C     SRCLER        BEGSR                                                                CAP067
177200200529      *                                                                                       CAP067
177300200529     C**********         Z-ADD     0             TCNR                                  CAP067 CSD027
177400200529     C                   EVAL      TCNR = *BLANKS                                             CSD027
177500200529     C                   Z-ADD     0             NOML                                         CAP067
177600200529     C                   Z-ADD     0             TNMD                                         CAP067
177700200529     C                   Z-ADD     0             TPDY                                         CAP067
177800200529     C                   Z-ADD     0             TDVD                                         CAP067
177900200529     C                   Z-ADD     0             TDDT                                         CAP067
178000200529     C                   Z-ADD     0             TCAP                                         CAP067
178100200529     C                   Z-ADD     0             DADJ                                         CAP067
178200200529     C                   Z-ADD     0             ITRA                                         CAP067
178300200529     C                   Z-ADD     0             TINA                                         CAP067
178400200529     C                   Z-ADD     0             TDCR                                         CAP067
178500200529     C                   Z-ADD     0             PRIC                                         CAP067
178600200529     C                   Z-ADD     0             RALL                                         CAP067
178700200529     C                   Z-ADD     0             TDER                                         CAP067
178800200529     C                   Z-ADD     0             TBCR                                         CAP067
178900200529     C                   Z-ADD     0             SMTH                                         CAP067
179000200529     C                   Z-ADD     0             ASNM                                         CAP067
179100200529     C**********         Z-ADD     0             DELT                                  CAP067 CSD027
179200200529     C**********         Z-ADD     0             DELF                                  CAP067 CSD027
179300200529     C                   EVAL      DELT = *BLANKS                                             CSD027
179400200529     C                   EVAL      DELF = *BLANKS                                             CSD027
179500200529     C                   Z-ADD     0             TBCA                                         CAP067
179600200529     C                   Z-ADD     0             TCCA                                         CAP067
179700200529     C                   Z-ADD     0             TCA1                                         CAP067
179800200529     C                   Z-ADD     0             TCA2                                         CAP067
179900200529     C                   Z-ADD     0             TCA3                                         CAP067
180000200529     C                   Z-ADD     0             TCA4                                         CAP067
180100200529     C                   Z-ADD     0             TCA5                                         CAP067
180200200529     C                   Z-ADD     0             TCA6                                         CAP067
180300200529     C                   Z-ADD     0             TCA7                                         CAP067
180400200529     C                   Z-ADD     0             TAXA                                         CAP067
180500200529     C                   Z-ADD     0             BCMR                                         CAP067
180600200529     C                   Z-ADD     0             CCMR                                         CAP067
180700200529     C                   Z-ADD     0             TXRB                                         CAP067
180800200529     C                   Z-ADD     0             TIME                                         CAP067
180900200529     C                   Z-ADD     0             TOSN                                         CAP067
181000200529     C                   Z-ADD     0             TNSN                                         CAP067
181100200529     C                   Z-ADD     0             TNSP                                         CAP067
181200200529     C                   Z-ADD     0             TOSV                                         CAP067
181300200529     C                   Z-ADD     0             TVSN                                         CAP067
181400200529     C                   Z-ADD     0             TVSP                                         CAP067
181500200529     C                   Z-ADD     0             TDSN                                         CAP067
181600200529     C                   Z-ADD     0             TDSP                                         CAP067
181700200529     C                   Z-ADD     0             TDFS                                         CAP067
181800200529     C                   Z-ADD     0             TSSQ                                         CAP067
181900200529     C                   Z-ADD     0             TCSR                                         CAP067
182000200529     C                   Z-ADD     0             TCTR                                         CAP067
182100200529     C                   Z-ADD     0             TDMC                                         CAP067
182200200529     C                   Z-ADD     0             TOED                                         CAP067
182300200529     C                   Z-ADD     0             LCD                                          CAP067
182400200529     C                   Z-ADD     0             TNLU                                         CAP067
182500200529     C                   Z-ADD     0             LSWS                                         CAP067
182600200529     C                   Z-ADD     0             TCFC                                         CAP067
182700200529     C                   Z-ADD     0             SPXR                                         CAP067
182800200529     C                   Z-ADD     0             FXMP                                         CAP067
182900200529     C                   Z-ADD     0             FXMR                                         CAP067
183000200529     C                   Z-ADD     0             MAMT                                         CAP067
183100200529     C                   Z-ADD     0             ORDE                                         CAP067
183200200529     C                   Z-ADD     0             WHTX                                         CAP067
183300200529     C                   Z-ADD     0             A_T1LSWS                                     CAP067
183400200529     C                   Z-ADD     0             A_T1LSSC                                     CAP067
183500200529     C                   Z-ADD     0             B_T1LSWS                                     CAP067
183600200529     C                   Z-ADD     0             B_T1LSSC                                     CAP067
183700200529      *                                                                                       CAP067
183800200529     C                   ENDSR                                                                CAP067
183900200529      *****************************************************************
184000200529      /EJECT
184100200529      *****************************************************************
184200200529      * SCRN@S - PROCESS SECOND SCREEN
184300200529      *****************************************************************
184400200529     C     SCRN@S        BEGSR
184500200529      *
184600200529      * KJ = COMMAND KEY 10 = CONFIRM DELETE
184700200529      *
184800200529     C     DDACTN        IFEQ      'D'
184900200529     C                   MOVEL     'Y'           @EINKJ
185000200529     C                   ELSE
185100200529     C                   MOVEL     'N'           @EINKJ
185200200529     C                   END
185300200529
185400200529      * Update 'previous' screens and previous number of warnings
185500200529
185600200529     C                   MOVEL     NewTrPrim     PrvTrPrim
185700200529     C                   MOVEL     NewTrSeco     PrvTrSeco
185800200529     C                   Z-ADD     WIdx_SVAL     PrvN_Warn         3 0
185900200529      *                                                                         206651
186000200529     C     DDSESN        CHAIN     SECTY                              99        206651
186100200529     C     *IN99         IFEQ      '0'                                          206651
186200200529     C                   MOVEL     SC_SRPN       DDSRNME                        206651
186300200529     C                   ENDIF                                                  206651
186400200529      *                                                                         229342
186500200529     C                   CALLB     'AOCUSTR1'                                   229342
186600200529     C                   PARM      '*MSG    '    @RTCD                          229342
186700200529     C                   PARM      '*KEY    '    @OPTN                          229342
186800200529     C                   PARM                    DDCNUM                         229342
186900200529     C                   PARM                    KEY7              7            229342
187000200529     C     SDCUST        PARM      SDCUST        DSLDY                          229342
187100200529      *                                                                         229342
187200200529      ** Customer is a Private Banking Customer: get default value if blank     229342
187300200529      *                                                                         229342
187400200529     C     @RTCD         IFEQ      *BLANKS                                      229342
187500200529     C                   MOVEL     BBCRNM        DDCRNM                         229342
187600200529     C                   ELSE                                                   229342
187700200529     C                   MOVEL     *BLANKS       DDCRNM                         229342
187800200529     C                   ENDIF                                                  229342
187900200529      *
188000200529      ** WRITE/READ DISPLAY SCREEN - Secondary Details
188100200529      *
188200200529     C                   CALLB     'SETRADSDSP'
188300200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
188400200529      * INPUT PARAMETERS :
188500200529      * Return code
188600200529     C                   PARM      *BLANK        RetCodeOut
188700200529      *
188800200529      * Trade (IN SCREEN FORMAT - Primary / Secondary)
188900200529     C                   PARM                    NewTrPrim
189000200529     C                   PARM                    NewTrSeco
189100200529      * Trade Status
189200200529      * Trade Authorized/Not Authorized
189300200529     C                   PARM                    DDSTAT            9
189400200529     C                   PARM                    DDAUTH           14
189500200529      * Security report name
189600200529      * Customer report name
189700200529     C**********         PARM                    DDSRPN           20                          CSE016
189800200529     C                   PARM                    DDSRNME                                      CSE016
189900200529     C                   PARM                    DDCRNM           20
190000200529      * Current Factor
190100200529      * Coupon Rate
190200200529     C                   PARM                    DDCFCT           12
190300200529     C                   PARM                    DDCPNR           13
190400200529      *
190500200529      * Trade incomplete ind
190600200529     C                   PARM                    C_TINC
190700200529      *
190800200529      * Fields in error
190900200529     C                   PARM                    OKTrPrim
191000200529     C                   PARM                    OKTrSeco
191100200529      *
191200200529      ** Customer classification
191300200529     C                   PARM                    CustClass
191400200529      ** Security Details
191500200529      ** Investment Type Details
191600200529     C*******************PARM                    SECTY                                        206651
191700200529     C                   PARM                    SECTY2                                       206651
191800200529     C                   PARM                    INVTP
191900200529      * Errors
192000200529     C                   PARM                    FldNameArr
192100200529     C                   PARM                    MsgIdArr
192200200529     C                   PARM                    MsgDtaArr
192300200529      * Warnings
192400200529     C                   PARM                    WFldNamArr
192500200529     C                   PARM                    WMsgIdArr
192600200529     C                   PARM                    WMsgDtaArr
192700200529      * ENABLED Function Keys
192800200529      * KG = COMMAND KEY 07 = READ PREVIOUS
192900200529      * KH = COMMAND KEY 08 = READ NEXT
193000200529      * KJ = COMMAND KEY 10 = CONFIRM DELETE
193100200529      * KP = COMMAND KEY 15 = BROWSE
193200200529     C                   PARM      'N'           @EINKG
193300200529     C                   PARM      'N'           @EINKH
193400200529     C                   PARM                    @EINKJ            1
193500200529     C                   PARM      'N'           @EINKP
193600200529      *                                                                                       CPK014
193700200529      * Protect book on second leg                                                            CPK014
193800200529     C                   PARM                    IN50              1                          CPK014
193900200529     C                   PARM                    TRDBK1            2                          CPK014
194000200529      * CGL031 Switchable Feature                                                             CGL031
194100200529     C                   PARM                    CGL031                                       CGL031
194200200529      *                                                                                       CAP067
194300200529      ** Buy-sell back                                                                        CAP067
194400200529     C                   PARM      'N'           PBYSL                                        CAP067
194500200529      *
194600200529      * OUTPUT PARAMETERS :
194700200529      * FUNCTION KEYS
194800200529     C                   PARM      '0'           @INKC             1
194900200529     C                   PARM      '0'           @INKE             1
195000200529     C                   PARM      '0'           @INKG             1
195100200529     C                   PARM      '0'           @INKH             1
195200200529     C                   PARM      '0'           @INKJ             1
195300200529     C                   PARM      '0'           @INKL             1
195400200529     C                   PARM      '0'           @INKP             1
195500200529     C                   PARM      '0'           @INKW             1                          222373
195600200529     C                   PARM      'N'           @INKWDisp         1                          222373
195700200529      * Write screen with no read indicator
195800200529     C                   PARM      'N'           WriteOnly         1
195900200529      *
196000200529      * RESET ERRORS ....
196100200529      *
196200200529     C                   MOVE      *ALL'Y'       OKTrPrim
196300200529     C                   MOVE      *ALL'Y'       OKTrSeco
196400200529     C                   MOVEL     *BLANK        FldNameArr
196500200529     C                   MOVEL     *BLANK        MsgIdArr
196600200529     C                   MOVEL     *BLANK        MsgDtaArr
196700200529     C                   MOVEL     *BLANK        WFldNamArr
196800200529     C                   MOVEL     *BLANK        WMsgIdArr
196900200529     C                   MOVEL     *BLANK        WMsgDtaArr
197000200529      *
197100200529      * F3 - End Program
197200200529     C     @INKC         CASEQ     '1'           ENDP
197300200529      *
197400200529      * F5 - Go to Initial Screen
197500200529     C     @INKE         CASEQ     '1'           INITIAL
197600200529      *
197700200529      * F12 - Cancel on Secondary Screen
197800200529     C     @INKL         CASEQ     '1'           CANC@S
197900200529      *
198000200529      * Validate Input to Secondary Screen
198100200529     C                   CAS                     VAL@S
198200200529      *
198300200529     C                   ENDCS
198400200529      *
198500200529     C                   ENDSR
198600200529      *****************************************************************
198700200529      /EJECT
198800200529      *****************************************************************
198900200529      * VAL@S  - VALIDATE INPUT TO SECONDARY SCREEN
199000200529      *****************************************************************
199100200529     C     VAL@S         BEGSR
199200200529      *
199300200529      *----------------------------------------------------------------
199400200529      * IF DELETE
199500200529      *
199600200529     C     DDACTN        IFEQ      'D'
199700200529      *
199800200529      * IF F10 TAKEN, GO ON TO UPDATES
199900200529      *
200000200529     C     @INKJ         IFEQ      '1'
200100200529     C                   MOVEL     'U'           @SCRN
200200200529     C                   END
200300200529     C                   GOTO      EndVAL@S
200400200529     C                   END
200500200529      *
200600200529      *----------------------------------------------------------------
200700200529      * IF AUTHORIZE / APPROVE
200800200529      *
200900200529     C     DDACTN        IFEQ      'Y'
201000200529     C     DDACTN        OREQ      'P'
201100200529      *
201200200529      * Go to Other details screen
201300200529      *
201400200529     C                   IF        CAS006 = 'Y'                                               CAS006
201500200529     C                   MOVEL     'H'           @SCRN                                        CAS006
201600200529     C                   ELSE                                                                 CAS006
201700200529     C                   MOVEL     'O'           @SCRN
201800200529     C                   ENDIF                                                                CAS006
201900200529      *
202000200529     C                   GOTO      EndVAL@S
202100200529     C                   END
202200200529      *
202300200529      *----------------------------------------------------------------
202400200529      * IF INSERT OR AMEND / CHANGE
202500200529      *
202600200529     C     DDACTN        IFEQ      'I'
202700200529     C     DDACTN        OREQ      'A'
202800200529     C     DDACTN        OREQ      'C'
202900200529      *
203000200529      * FORCE INTEREST & PRICE RECALCULATION
203100200529      *
203200200529     C                   EXSR      INTRCAL
203300200529     C                   EXSR      PRCRCAL
203400200529      *
203500200529      * Prior to validation, initialize error indicators as 'OK'
203600200529      *
203700200529     C                   Z-ADD     *ZERO         Idx               3 0
203800200529     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
203900200529     C                   MOVE      *ALL'Y'       OKTrPrim
204000200529     C                   MOVE      *ALL'Y'       OKTrSeco
204100200529      *
204200200529      * Validate Primary trade details
204300200529      *
204400200529     C                   CALLB     'SETRADPVAL'
204500200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
204600200529      * INPUTS :
204700200529      * Response mode
204800200529     C                   PARM                    RespMode
204900200529      ** Trade Primary Details
205000200529     C                   PARM                    NewTrPrim
205100200529      * Custom Extra Data file data                                             CAP004
205200200529     C                   PARM                    ExtData                        CAP004
205300200529      ** Trade settlement currency
205400200529     C                   PARM                    DDSETC
205500200529      ** Default & Validate (Y or N)
205600200529     C                   PARM      'Y'           Default           1
205700200529     C                   PARM      'Y'           Validate          1
205800200529      * Output details of original book.                                                      193462
205900200529     C                   PARM                    OLDBK1                                       193462
206000200529TAS  C                   PARM                    WARNIND                                      193462
206100200529      *                                                                                       CAP067
206200200529      ** First Buy-sell back indicator                                                        CAP067
206300200529     C                   PARM                    PFBYSL            1                          CAP067
206400200529      *                                                                                       CAP067
206500200529      ** First Buy-sell book code                                                             CAP067
206600200529     C                   PARM                    PFBPBK            2                          CAP067
206700200529      *                                                                                       CAP067
206800200529      ** First Buy-sell counterparty                                                          CAP067
206900200529     C**********         PARM                    PFTCNR            6 0                 CAP067 CSD027
207000200529     C                   PARM                    PFTCNR            6                          CSD027
207100200529      *                                                                                       CAP067
207200200529      ** First Buy-sell trade type                                                            CAP067
207300200529     C                   PARM                    PFTDTP            2                          CAP067
207400200529      *                                                                                       CAP067
207500200529      ** First Buy-sell Value Date                                                            CAP067
207600200529     C                   PARM                    PFTDVD            5 0                        CAP067
207700200529      *                                                                                       CAP067
207800200529      ** First Buy-sell Security Shortname                                                    CAP067
207900200529     C                   PARM                    PFSESN           10                          CAP067
208000200529     C                   PARM                    CallFromVU                                   CAP087
208100200529      * OUTPUTS :
208200200529      ** Security Details
208300200529      ** Investment Type Details
208400200529     C*******************PARM                    SECTY                                        206651
208500200529     C                   PARM                    SECTY2                                       206651
208600200529     C                   PARM                    INVTP
208700200529      * Coupon Rate
208800200529      * Current Factor
208900200529     C                   PARM                    DDCPNR
209000200529     C                   PARM                    DDCFCT
209100200529      ** Nominal Currency Details
209200200529     C                   PARM                    NomCcyDts
209300200529      ** Customer (Counterparty) Details
209400200529     C                   PARM                    CustDts
209500200529      ** Portfolio Details
209600200529     C                   PARM                    PortDts
209700200529      ** Default basket for backup withholding                                  CSE023
209800200529     C                   PARM                    PDRBW                          CSE023
209900200529      ** Trade Primary Details OK inds
210000200529     C                   PARM                    OKTrPrim
210100200529      * Error fields/message IDs/message data (arrays) from/to caller
210200200529     C                   PARM                    FldNameArr
210300200529     C                   PARM                    MsgIDArr
210400200529     C                   PARM                    MsgDtaArr
210500200529      * Array index (3P0) from/to caller
210600200529     C                   PARM                    Idx
210700200529      * Warning fields/message IDs/message data (arrays) from/to caller
210800200529     C                   PARM                    WFldNamArr
210900200529     C                   PARM                    WMsgIDArr
211000200529     C                   PARM                    WMsgDtaArr
211100200529      * Array index (3P0) from/to caller
211200200529     C                   PARM                    WIdx_SVAL
211300200529      * Valid Trade layout (DS) from/to caller
211400200529     C                   PARM                    NwTrFilFmt
211500200529      * PB Order Number                                                                       CPB002
211600200529     C                   PARM                    DDORDE                                       CPB002
211700200529      *
211800200529      * Validate Secondary Screen details
211900200529      *
212000200529     C                   CALLB     'SETRADSVAL'
212100200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
212200200529      * INPUTS :
212300200529      * Response mode
212400200529     C                   PARM                    RespMode
212500200529      ** Trade Primary Details
212600200529     C                   PARM                    NewTrPrim
212700200529     C                   PARM                    NewTrSeco
212800200529      * Custom Extra Data file data                                             CAP004
212900200529     C                   PARM                    ExtData                        CAP004
213000200529     C/COPY WNCPYSRC,SETRADRC12
213100200529      ** Default & Validate (Y or N)
213200200529     C                   PARM      'Y'           Default           1
213300200529     C                   PARM      'Y'           Validate          1
213400200529      ** Security Details
213500200529      ** Investment Type Details
213600200529     C*******************PARM                    SECTY                                        206651
213700200529     C                   PARM                    SECTY2                                       206651
213800200529     C                   PARM                    INVTP
213900200529      ** Nominal Currency Details
214000200529     C                   PARM                    NomCcyDts
214100200529      ** Customer (Counterparty) Details
214200200529     C                   PARM                    CustDts
214300200529      *                                                                                       CPK014
214400200529      ** MT5xx SSI (Phase 2)                                                                  CPK014
214500200529     C                   PARM                    CSE028                                       CPK014
214600200529      * CGL031 Switchable Feature                                                             CGL031
214700200529     C                   PARM                    CGL031                                       CGL031
214800200529      ** Current File Trade Date                                                              244240
214900200529     C                   PARM                    C_TDVD                                       244240
215000200529      * OUTPUTS :
215100200529      ** Settlement Currency Details
215200200529     C                   PARM                    SetCcyDts
215300200529      ** Trade Primary Details OK inds
215400200529     C                   PARM                    OKTrSeco
215500200529      * Error fields/message IDs/message data (arrays) from/to caller
215600200529     C                   PARM                    FldNameArr
215700200529     C                   PARM                    MsgIDArr
215800200529     C                   PARM                    MsgDtaArr
215900200529      * Array index (3P0) from/to caller
216000200529     C                   PARM                    Idx
216100200529      * Warning fields/message IDs/message data (arrays) from/to caller
216200200529     C                   PARM                    WFldNamArr
216300200529     C                   PARM                    WMsgIDArr
216400200529     C                   PARM                    WMsgDtaArr
216500200529      * Array index (3P0) from/to caller
216600200529     C                   PARM                    WIdx_SVAL
216700200529      * Valid Trade layout (DS) from/to caller
216800200529     C                   PARM                    NwTrFilFmt
216900200529      *
217000200529      * If errors returned
217100200529      *
217200200529     C     Idx           IFNE      0
217300200529     C                   GOTO      EndVAL@S
217400200529     C                   END
217500200529      *
217600200529      * If the screen has changed in the course of the validation
217700200529      * or if there are warnings which have not been displayed
217800200529      *   re-output the screen
217900200529      *
218000200529     C     NewTrPrim     IFNE      PrvTrPrim
218100200529     C     NewTrSeco     ORNE      PrvTrSeco
218200200529     C     WIdx_SVAL     ORNE      PrvN_Warn
218300200529     C                   GOTO      EndVAL@S
218400200529     C                   END
218500200529      *
218600200529      * Clear any warning messages
218700200529      *
218800200529     C                   MOVE      *ALL'Y'       OKTrPrim
218900200529     C                   MOVE      *ALL'Y'       OKTrSeco
219000200529     C                   MOVEL     *BLANK        WFldNamArr
219100200529     C                   MOVEL     *BLANK        WMsgIdArr
219200200529     C                   MOVEL     *BLANK        WMsgDtaArr
219300200529      *
219400200529      * Go to Other details screen
219500200529      *
219600200529     C                   IF        CAS006 = 'Y'                                               CAS006
219700200529     C                   MOVEL     'H'           @SCRN                                        CAS006
219800200529     C                   ELSE                                                                 CAS006
219900200529     C                   MOVEL     'O'           @SCRN
220000200529     C                   ENDIF                                                                CAS006
220100200529      *                                                                                       CAS006
220200200529     C                   END
220300200529      *----------------------------------------------------------------
220400200529      *
220500200529     C     EndVAL@S      ENDSR
220600200529      *****************************************************************
220700200529      /EJECT
220800200529      *****************************************************************                       CAS006
220900200529      *                                                               *                       CAS006
221000200529      *  SCRN@T - Process third details screen                        *                       CAS006
221100200529      *                                                               *                       CAS006
221200200529      *****************************************************************                       CAS006
221300200529                                                                                              CAS006
221400200529     C     SCRN@T        BEGSR                                                                CAS006
221500200529                                                                                              CAS006
221600200529      ** Call validation module for defaulting purposes only                                  CAS006
221700200529                                                                                              CAS006
221800200529     C                   CALLB     'SETRADTVAL'                                               CAS006
221900200529                                                                                              CAS006
222000200529      ** INPUTS                                                                               CAS006
222100200529                                                                                              CAS006
222200200529     C                   PARM                    RespMode                                     CAS006
222300200529     C                   PARM                    NewTrPrim                                    CAS006
222400200529     C                   PARM                    NewTrSeco                                    CAS006
222500200529     C                   PARM                    NewTrThir                                    CAS006
222600200529     C                   PARM                    ExtData                                      CAS006
222700200529     C                   PARM      'Y'           Default                                      CAS006
222800200529     C                   PARM      'N'           Validate                                     CAS006
222900200529     C**********         PARM                    SECTY                                 CAS006 206651
223000200529     C                   PARM                    SECTY2                                       206651
223100200529     C                   PARM                    INVTP                                        CAS006
223200200529     C                   PARM                    DDHACR                                       CAS006
223300200529     C                   PARM                    DDPRICN                                      CAS006
223400200529     C                   PARM                    CustDts                                      CAS006
223500200529     C                   PARM                    PortDts                                      CAS006
223600200529     C                   PARM                    NomCcyDts                                    CAS006
223700200529     C                   PARM                    SetCcyDts                                    CAS006
223800200529                                                                                              CAS006
223900200529      ** OUTPUTS                                                                              CAS006
224000200529                                                                                              CAS006
224100200529     C                   PARM                    OKTrThir                                     CAS006
224200200529     C                   PARM                    FldNameArr                                   CAS006
224300200529     C                   PARM                    MsgIDArr                                     CAS006
224400200529     C                   PARM                    MsgDtaArr                                    CAS006
224500200529     C                   PARM                    Idx                                          CAS006
224600200529     C                   PARM                    WFldNamArr                                   CAS006
224700200529     C                   PARM                    WMsgIDArr                                    CAS006
224800200529     C                   PARM                    WMsgDtaArr                                   CAS006
224900200529     C                   PARM                    WIdx_TVAL                                    CAS006
225000200529     C                   PARM                    NwTrFilFmt                                   CAS006
225100200529                                                                                              CAS006
225200200529      ** Update 'previous' screens and previous number of warnings                            CAS006
225300200529                                                                                              CAS006
225400200529     C                   MOVEL     NewTrThir     PrvTrThir                                    CAS006
225500200529     C                   Z-ADD     WIdx_TVAL     PrvN_Warn                                    CAS006
225600200529                                                                                              CAS006
225700200529      ** Write/Read display screen - Third Details screen                                     CAS006
225800200529                                                                                              CAS006
225900200529     C                   CALLB     'SETRADTDSP'                                               CAS006
226000200529                                                                                              CAS006
226100200529      ** INPUTS                                                                               CAS006
226200200529      ** Return code                                                                          CAS006
226300200529                                                                                              CAS006
226400200529     C                   PARM      *BLANKS       RetCodeOut                                   CAS006
226500200529                                                                                              CAS006
226600200529      ** Trade in screen format                                                               CAS006
226700200529                                                                                              CAS006
226800200529     C                   PARM                    NewTrPrim                                    CAS006
226900200529     C                   PARM                    NewTrThir                                    CAS006
227000200529                                                                                              CAS006
227100200529      ** Trade status                                                                         CAS006
227200200529      ** Security report name                                                                 CAS006
227300200529      ** Coupon Rate using Net Treasury Rate                                                  CAS006
227400200529      ** Net Treasury Price                                                                   CAS006
227500200529                                                                                              CAS006
227600200529     C                   PARM                    DDSTAT                                       CAS006
227700200529     C                   PARM                    DDSRNME                                      CAS006
227800200529     C                   PARM                    DDHACR                                       CAS006
227900200529     C                   PARM                    DDPRICN                                      CAS006
228000200529                                                                                              CAS006
228100200529      ** Trade incomplete ind                                                                 CAS006
228200200529                                                                                              CAS006
228300200529     C                   PARM                    C_TINC                                       CAS006
228400200529                                                                                              CAS006
228500200529      ** Security Details                                                                     CAS006
228600200529      ** Investment Type Details                                                              CAS006
228700200529                                                                                              CAS006
228800200529     C**********         PARM                    SECTY                                 CAS006 206651
228900200529     C                   PARM                    SECTY2                                       206651
229000200529     C                   PARM                    INVTP                                        CAS006
229100200529                                                                                              CAS006
229200200529      ** Buy-sell back                                                                        CAS006
229300200529                                                                                              CAS006
229400200529     C                   PARM      'N'           PBYSL                                        CAS006
229500200529                                                                                              CAS006
229600200529      ** Fields in error                                                                      CAS006
229700200529                                                                                              CAS006
229800200529     C                   PARM                    OKTrThir                                     CAS006
229900200529                                                                                              CAS006
230000200529      ** Errors                                                                               CAS006
230100200529                                                                                              CAS006
230200200529     C                   PARM                    FldNameArr                                   CAS006
230300200529     C                   PARM                    MsgIdArr                                     CAS006
230400200529     C                   PARM                    MsgDtaArr                                    CAS006
230500200529                                                                                              CAS006
230600200529      ** Warnings                                                                             CAS006
230700200529                                                                                              CAS006
230800200529     C                   PARM                    WFldNamArr                                   CAS006
230900200529     C                   PARM                    WMsgIdArr                                    CAS006
231000200529     C                   PARM                    WMsgDtaArr                                   CAS006
231100200529                                                                                              CAS006
231200200529      ** OUTPUTS                                                                              CAS006
231300200529      ** Function keys                                                                        CAS006
231400200529                                                                                              CAS006
231500200529     C                   PARM      '0'           @INKC                                        CAS006
231600200529     C                   PARM      '0'           @INKE                                        CAS006
231700200529     C                   PARM      '0'           @INKL                                        CAS006
231800200529                                                                                              CAS006
231900200529      ** Write screen with no read indicator                                                  CAS006
232000200529                                                                                              CAS006
232100200529     C                   PARM      'N'           WriteOnly                                    CAS006
232200200529                                                                                              CAS006
232300200529      ** Reset errors                                                                         CAS006
232400200529                                                                                              CAS006
232500200529     C                   MOVE      *ALL'Y'       OKTrThir                                     CAS006
232600200529     C                   MOVEL     *BLANK        FldNameArr                                   CAS006
232700200529     C                   MOVEL     *BLANK        MsgIdArr                                     CAS006
232800200529     C                   MOVEL     *BLANK        MsgDtaArr                                    CAS006
232900200529     C                   MOVEL     *BLANK        WFldNamArr                                   CAS006
233000200529     C                   MOVEL     *BLANK        WMsgIdArr                                    CAS006
233100200529     C                   MOVEL     *BLANK        WMsgDtaArr                                   CAS006
233200200529                                                                                              CAS006
233300200529      ** F3 - End Program                                                                     CAS006
233400200529                                                                                              CAS006
233500200529     C     @INKC         CASEQ     '1'           ENDP                                         CAS006
233600200529                                                                                              CAS006
233700200529      ** F5 - Go to Initial Screen                                                            CAS006
233800200529                                                                                              CAS006
233900200529     C     @INKE         CASEQ     '1'           INITIAL                                      CAS006
234000200529                                                                                              CAS006
234100200529      ** F12 - Cancel on Secondary Screen                                                     CAS006
234200200529                                                                                              CAS006
234300200529     C     @INKL         CASEQ     '1'           CANC@T                                       CAS006
234400200529                                                                                              CAS006
234500200529      ** Validate Input to Third screen                                                       CAS006
234600200529                                                                                              CAS006
234700200529     C                   CAS                     VAL@T                                        CAS006
234800200529                                                                                              CAS006
234900200529     C                   ENDCS                                                                CAS006
235000200529                                                                                              CAS006
235100200529     C                   ENDSR                                                                CAS006
235200200529                                                                                              CAS006
235300200529      *****************************************************************                       CAS006
235400200529      /EJECT                                                                                  CAS006
235500200529      *****************************************************************                       CAS006
235600200529      *                                                               *                       CAS006
235700200529      *  VAL@T - Validate input to third screen                       *                       CAS006
235800200529      *                                                               *                       CAS006
235900200529      *****************************************************************                       CAS006
236000200529                                                                                              CAS006
236100200529     C     VAL@T         BEGSR                                                                CAS006
236200200529                                                                                              CAS006
236300200529      ** If Authorize/Approve, go to Other details screen                                     CAS006
236400200529                                                                                              CAS006
236500200529     C                   IF        DDACTN = 'P'  OR  DDACTN = 'Y'                             CAS006
236600200529     C                   EVAL      @SCRN = 'O'                                                CAS006
236700200529     C                   GOTO      EndVAL@T                                                   CAS006
236800200529     C                   ENDIF                                                                CAS006
236900200529                                                                                              CAS006
237000200529      ** Insert, Amend, Change                                                                CAS006
237100200529                                                                                              CAS006
237200200529     C     DDACTN        IFEQ      'I'                                                        CAS006
237300200529     C     DDACTN        OREQ      'A'                                                        CAS006
237400200529     C     DDACTN        OREQ      'C'                                                        CAS006
237500200529                                                                                              CAS006
237600200529      ** Prior to validation, initialize error indicators as 'OK'                             CAS006
237700200529                                                                                              CAS006
237800200529     C                   Z-ADD     *ZERO         Idx                                          CAS006
237900200529     C                   Z-ADD     *ZERO         WIdx_TVAL                                    CAS006
238000200529     C                   MOVE      *ALL'Y'       OKTrThir                                     CAS006
238100200529                                                                                              CAS006
238200200529      ** Validate Third Screen details                                                        CAS006
238300200529                                                                                              CAS006
238400200529     C                   CALLB     'SETRADTVAL'                                               CAS006
238500200529                                                                                              CAS006
238600200529      ** INPUTS                                                                               CAS006
238700200529      ** Response mode                                                                        CAS006
238800200529                                                                                              CAS006
238900200529     C                   PARM                    RespMode                                     CAS006
239000200529                                                                                              CAS006
239100200529      ** Trade Primary Details                                                                CAS006
239200200529      ** Trade Secondary Details                                                              CAS006
239300200529      ** Trade Third Screen Details                                                           CAS006
239400200529                                                                                              CAS006
239500200529     C                   PARM                    NewTrPrim                                    CAS006
239600200529     C                   PARM                    NewTrSeco                                    CAS006
239700200529     C                   PARM                    NewTrThir                                    CAS006
239800200529                                                                                              CAS006
239900200529      ** Custom Extra Data file data                                                          CAS006
240000200529                                                                                              CAS006
240100200529     C                   PARM                    ExtData                                      CAS006
240200200529                                                                                              CAS006
240300200529      ** Default & Validate (Y or N)                                                          CAS006
240400200529                                                                                              CAS006
240500200529     C                   PARM      'Y'           Default                                      CAS006
240600200529     C                   PARM      'Y'           Validate                                     CAS006
240700200529                                                                                              CAS006
240800200529      ** Security Details                                                                     CAS006
240900200529      ** Investment Type Details                                                              CAS006
241000200529                                                                                              CAS006
241100200529     C**********         PARM                    SECTY                                 CAS006 206651
241200200529     C                   PARM                    SECTY2                                       206651
241300200529     C                   PARM                    INVTP                                        CAS006
241400200529                                                                                              CAS006
241500200529      ** Coupon rate using NTR                                                                CAS006
241600200529      ** Net Treasury Price                                                                   CAS006
241700200529                                                                                              CAS006
241800200529     C                   PARM                    DDHACR                                       CAS006
241900200529     C                   PARM                    DDPRICN                                      CAS006
242000200529                                                                                              CAS006
242100200529      ** Customer (Counterparty) Details                                                      CAS006
242200200529      ** Portfolio Details                                                                    CAS006
242300200529      ** Nominal Currency Details                                                             CAS006
242400200529      ** Settlement Currency Details                                                          CAS006
242500200529                                                                                              CAS006
242600200529     C                   PARM                    CustDts                                      CAS006
242700200529     C                   PARM                    PortDts                                      CAS006
242800200529     C                   PARM                    NomCcyDts                                    CAS006
242900200529     C                   PARM                    SetCcyDts                                    CAS006
243000200529                                                                                              CAS006
243100200529      ** Trade Exchange Rates OK inds                                                         CAS006
243200200529                                                                                              CAS006
243300200529     C                   PARM                    OKTrThir                                     CAS006
243400200529                                                                                              CAS006
243500200529      ** Error fields/message IDs/message data (arrays) from/to caller                        CAS006
243600200529                                                                                              CAS006
243700200529     C                   PARM                    FldNameArr                                   CAS006
243800200529     C                   PARM                    MsgIDArr                                     CAS006
243900200529     C                   PARM                    MsgDtaArr                                    CAS006
244000200529                                                                                              CAS006
244100200529      ** Array index (3P0) from/to caller                                                     CAS006
244200200529                                                                                              CAS006
244300200529     C                   PARM                    Idx                                          CAS006
244400200529                                                                                              CAS006
244500200529      ** Warning fields/message IDs/message data (arrays) from/to caller                      CAS006
244600200529                                                                                              CAS006
244700200529     C                   PARM                    WFldNamArr                                   CAS006
244800200529     C                   PARM                    WMsgIDArr                                    CAS006
244900200529     C                   PARM                    WMsgDtaArr                                   CAS006
245000200529                                                                                              CAS006
245100200529      ** Array index (3P0) from/to caller                                                     CAS006
245200200529                                                                                              CAS006
245300200529     C                   PARM                    WIdx_TVAL                                    CAS006
245400200529                                                                                              CAS006
245500200529      ** Valid Trade layout (DS) from/to caller                                               CAS006
245600200529                                                                                              CAS006
245700200529     C                   PARM                    NwTrFilFmt                                   CAS006
245800200529                                                                                              CAS006
245900200529      ** Errors returned                                                                      CAS006
246000200529                                                                                              CAS006
246100200529     C                   IF        Idx <> 0                                                   CAS006
246200200529     C                   GOTO      EndVAL@T                                                   CAS006
246300200529     C                   ENDIF                                                                CAS006
246400200529                                                                                              CAS006
246500200529      ** If the screen has changed in the course of the validation                            CAS006
246600200529      ** or if there are warnings which have not been displayed                               CAS006
246700200529      ** re-output the screen                                                                 CAS006
246800200529                                                                                              CAS006
246900200529     C                   IF        NewTrThir <> PrvTrThir  OR                                 CAS006
247000200529     C                             WIdx_TVAL <> PrvN_Warn                                     CAS006
247100200529     C                   GOTO      EndVAL@T                                                   CAS006
247200200529     C                   ENDIF                                                                CAS006
247300200529                                                                                              CAS006
247400200529      ** Clear any warning messages                                                           CAS006
247500200529                                                                                              CAS006
247600200529     C                   MOVE      *ALL'Y'       OKTrThir                                     CAS006
247700200529     C                   MOVEL     *BLANK        WFldNamArr                                   CAS006
247800200529     C                   MOVEL     *BLANK        WMsgIdArr                                    CAS006
247900200529     C                   MOVEL     *BLANK        WMsgDtaArr                                   CAS006
248000200529                                                                                              CAS006
248100200529      ** Go to Other details screen                                                           CAS006
248200200529                                                                                              CAS006
248300200529     C                   MOVEL     'O'           @SCRN                                        CAS006
248400200529     C                   ENDIF                                                                CAS006
248500200529                                                                                              CAS006
248600200529     C     EndVAL@T      ENDSR                                                                CAS006
248700200529                                                                                              CAS006
248800200529      *****************************************************************                       CAS006
248900200529      /EJECT                                                                                  CAS006
249000200529      *****************************************************************
249100200529      * SCRN@O - PROCESS OTHER DETAILS SCREEN
249200200529      *****************************************************************
249300200529     C     SCRN@O        BEGSR
249400200529
249500200529      * Update 'previous' screens and previous number of warnings
249600200529
249700200529     C                   MOVEL     NewTrExch     PrvTrExch
249800200529     C                   MOVEL     NewTrSett     PrvTrSett
249900200529     C                   MOVEL     NewTrChCm     PrvTrChCm
250000200529     C                   Z-ADD     WIdx_OVAL     PrvN_Warn         3 0
250100200529
250200200529      * Pass clearance type from primary to other details screen
250300200529
250400200529     C                   MOVEL     DDCLTY        DDCLTY2
250500200529      *
250600200529      * IF FIRST TIME FOR ACTION CODE, TRADE REF, CURRENCY OR CUSTOMER
250700200529      * OR IF NO DETAILS PRESENT                                                154208
250800200529      *
250900200529     C     DDACTN        IFNE      ##ACTN
251000200529     C     DDTDRF        ORNE      ##TDRF
251100200529     C     DDSETC        ORNE      ##SETC
251200200529     C     DDCNUM        ORNE      ##CNUM
251300200529     C     PrvTrExch     OREQ      *BLANK                                       154208
251400200529     C     PrvTrSett     ANDEQ     *BLANK                                       154208
251500200529     C     PrvTrChCm     ANDEQ     *BLANK                                       154208
251600200529      *
251700200529      * IF INSERT, AMEND OR CHANGE
251800200529      * DO DEFAULTING FOR OTHER DETAILS SCREEN
251900200529      * DO CHARGES AND COMMISSIONS CALCULATION
252000200529      * DO COUNTERVALUE CALCULATION
252100200529      */C*PY*WNCPYSRC,SETRADR014************************************************       CUT009 CPK015
252200200529      /COPY WNCPYSRC,SETRADR016                                                               CPK015
252300200529      *
252400200529     C     DDACTN        IFEQ      'I'
252500200529     C     DDACTN        OREQ      'A'
252600200529     C     DDACTN        OREQ      'C'
252700200529     C                   EXSR      DFLT@O
252800200529     C     BVACOP        IFEQ      'Y'
252900200529     C                   EXSR      CHCMCAL
253000200529     C                   END
253100200529     C/COPY WNCPYSRC,SETRADRC03
253200200529     C     CGL031        IFEQ      'Y'                                                        233881
253300200529     C                   EXSR      EUTXCAL                                                    233881
253400200529     C                   ENDIF                                                                233881
253500200529     C                   EXSR      CVALCAL
253600200529     C                   END
253700200529     C                   END
253800200529      *
253900200529      ** WRITE/READ DISPLAY - Other Details Screen
254000200529      /COPY WNCPYSRC,SETRADR015                                                               CUT009
254100200529      *
254200200529     C                   CALLB     'SETRADODSP'
254300200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
254400200529      * INPUT PARAMETERS:
254500200529      * Return Code
254600200529     C                   PARM      *BLANK        RetCodeOut
254700200529      * Trade (IN SCREEN FORMAT) - Primary/Secondary/Other Details
254800200529     C                   PARM                    NewTrPrim
254900200529     C                   PARM                    NewTrSeco
255000200529     C                   PARM                    NewTrExch
255100200529     C                   PARM                    NewTrSett
255200200529     C                   PARM                    NewTrChCm
255300200529      *
255400200529      * Current trade incomplete ind and date made complete
255500200529     C                   PARM                    C_TINC
255600200529     C                   PARM                    C_TDMC
255700200529      *
255800200529      * Customer classification, Customer PM (Y/N) and nominal currency
255900200529      * And Private Banking customer (Y/N)                                      CPB001
256000200529     C                   PARM                    CustClass         1
256100200529     C                   PARM                    CustPM            1
256200200529     C                   PARM                    NMCY              3
256300200529     C                   PARM                    CustPB            1            CPB001
256400200529      *                                                                         CSE023
256500200529      ** Withholding tax                                                        CSE023
256600200529      *                                                                         CSE023
256700200529     C                   PARM                    DDWTAX                         CSE023
256800200529      * Fields in error
256900200529     C                   PARM                    OKTrExch
257000200529     C                   PARM                    OKTrSett
257100200529     C                   PARM                    OKTrChcm
257200200529      * Security report name
257300200529      * Countervalue
257400200529      ** FX Margin Amount
257500200529      ** Portfolio exchange rate & M/D ind screen format
257600200529     C**********         PARM                    DDSRPN                                       CSE016
257700200529     C                   PARM                    DDSRNME                                      CSE016
257800200529     C                   PARM                    DDTCTR
257900200529     C                   PARM                    DDMAMT           18
258000200529     C                   PARM                    DDSPXR           14
258100200529     C                   PARM                    DDSPMD            1
258200200529      * Errors
258300200529     C                   PARM                    FldNameArr
258400200529     C                   PARM                    MsgIdArr
258500200529     C                   PARM                    MsgDtaArr
258600200529      * Warnings
258700200529     C                   PARM                    WFldNamArr
258800200529     C                   PARM                    WMsgIdArr
258900200529     C                   PARM                    WMsgDtaArr
259000200529                                                                                              CGL031
259100200529      ** Switchable Feature                                                                   CGL031
259200200529     C                   PARM                    CGL031                                       CGL031
259300200529      *                                                                                       CAP067
259400200529      ** Buy-sell back                                                                        CAP067
259500200529     C                   PARM      'N'           PBYSL                                        CAP067
259600200529      *
259700200529      ** OUTPUT PARAMETERS :
259800200529      * Function Keys
259900200529     C                   PARM      '0'           @INKC             1
260000200529     C                   PARM      '0'           @INKE             1
260100200529     C                   PARM      '0'           @INKL             1
260200200529      * Write screen with no read indicator
260300200529     C                   PARM      'N'           WriteOnly         1
260400200529      *
260500200529      * RESET ERRORS ....
260600200529      *
260700200529     C                   MOVE      *ALL'Y'       OKTrExch
260800200529     C                   MOVE      *ALL'Y'       OKTrSett
260900200529     C                   MOVE      *ALL'Y'       OKTrChcm
261000200529     C                   MOVEL     *BLANK        FldNameArr
261100200529     C                   MOVEL     *BLANK        MsgIdArr
261200200529     C                   MOVEL     *BLANK        MsgDtaArr
261300200529     C                   MOVEL     *BLANK        WFldNamArr
261400200529     C                   MOVEL     *BLANK        WMsgIdArr
261500200529     C                   MOVEL     *BLANK        WMsgDtaArr
261600200529      *
261700200529      ** Pass clearance type from other details to primary screen
261800200529      *
261900200529     C                   MOVEL     DDCLTY2       DDCLTY
262000200529      *
262100200529      * F3 - End Program
262200200529     C     @INKC         CASEQ     '1'           ENDP
262300200529      *
262400200529      * F5 - Go To Initial Screen
262500200529     C     @INKE         CASEQ     '1'           INITIAL
262600200529      *
262700200529      * F12 - Cancel on Other Details Screen
262800200529     C     @INKL         CASEQ     '1'           CANC@O
262900200529      *
263000200529      * Validate Input to Other Details Screen
263100200529     C                   CAS                     VAL@O
263200200529      *
263300200529     C                   ENDCS
263400200529      *
263500200529     C                   ENDSR
263600200529      *****************************************************************
263700200529      /EJECT
263800200529      *****************************************************************
263900200529      * DFLT@O  - DO DEFAULTING FOR OTHER DETAILS SCREEN
264000200529      *****************************************************************
264100200529     C     DFLT@O        BEGSR
264200200529
264300200529      ** EXCHANGE RATE DEFAULTING
264400200529
264500200529     C     DDACTN        IFEQ      'I'
264600200529     C     DDACTN        OREQ      'C'
264700200529     C     DDSETC        ANDNE     C_SETC
264800200529
264900200529     C                   CALLB     'SETEXCHDFT'
265000200529
265100200529      * INPUTS
265200200529      *
265300200529      ** Nominal Currency
265400200529      ** Settlement Currency
265500200529     C                   PARM                    NMCY              3
265600200529     C                   PARM                    DDSETC            3
265700200529
265800200529      ** Nominal Currency Details
265900200529      ** Settlement Currency Details
266000200529     C                   PARM                    NomCcyDts
266100200529     C                   PARM                    SetCcyDts
266200200529      ** ICD
266300200529      ** Euro Currency
266400200529      ** EMU SE Settlement Ccy Conv.
266500200529     C                   PARM                    BKEURO            3
266600200529     C                   PARM                    CEU005            1            CAP050
266700200529
266800200529      * OUTPUTS
266900200529
267000200529      ** Trade Exchange Rate screen fields
267100200529
267200200529     C                   PARM                    NewTrExch
267300200529
267400200529      ** Trade Exchange Rate file fields
267500200529
267600200529     C                   PARM                    TDER             13 8
267700200529     C                   PARM                    TMDI              1
267800200529     C                   PARM                    TBCR             13 8
267900200529
268000200529     C                   END
268100200529
268200200529      ** SETTLEMENT INSTRUCTION DEFAULTING
268300200529
268400200529     C     DDACTN        IFEQ      'I'
268500200529
268600200529     C                   CALLB     'SETSETIDFT'
268700200529
268800200529      * INPUTS
268900200529
269000200529      ** Booking branch
269100200529      ** Incomplete Ind
269200200529      ** Trade Type
269300200529      ** Settlement Currency
269400200529      ** Market Ind.
269500200529      ** Book Code.                                                                           CSE028
269600200529     C                   PARM                    DDBRCD            3
269700200529     C                   PARM                    DDINCS            1
269800200529     C                   PARM                    DDTDTP            2
269900200529     C                   PARM                    DDSETC            3
270000200529     C                   PARM                    DDTDMI            1
270100200529     C                   PARM                    DDBPBK                                       CSE028
270200200529     C                   PARM                    DDMRKT                                       CSE034
270300200529
270400200529      ** Investment type (SECTYD)
270500200529
270600200529     C                   PARM                    SITP              3
270700200529
270800200529      ** Nominal Currency Details
270900200529      ** Settlement Currency Details
271000200529     C                   PARM                    NomCcyDts
271100200529     C                   PARM                    SetCcyDts
271200200529
271300200529      ** Customer (Counterparty) Details
271400200529      ** ( Note: Customer Participant/Non-participant Indicator 1 and
271500200529      **  Customer Participant/Non-participant Indicator 2 are also outputs)
271600200529     C                   PARM                    CustDts
271700200529
271800200529
271900200529      ** ICD
272000200529      ** Depot 1 (Eurclear)
272100200529      ** Depot 2 (Cedel)
272200200529     C                   PARM                    BVDR1             6
272300200529     C                   PARM                    BVDR2             6
272400200529      *                                                                                       CSE028
272500200529      ** MT5xx SSI (Phase 2)                                                                  CSE028
272600200529     C                   PARM                    CSE028                                       CSE028
272700200529
272800200529      * OUTPUTS
272900200529
273000200529      ** Trade Settlement Instructions
273100200529
273200200529     C                   PARM                    NewTrSett
273300200529
273400200529     C                   END
273500200529
273600200529      ** CHARGE/COMMISSION DEFAULTING
273700200529
273800200529     C     DDACTN        IFEQ      'I'
273900200529     C     DDACTN        OREQ      'A'
274000200529     C     DDACTN        OREQ      'C'
274100200529
274200200529     C                   CALLB     'SETCHCMDFT'
274300200529
274400200529      * INPUTS
274500200529
274600200529      ** Bulk reference
274700200529      ** Incomplete Ind.
274800200529      ** Market Centre
274900200529     C                   PARM                    DDBLKR            6
275000200529     C                   PARM                    DDINCS            1
275100200529     C                   PARM                    DDMRKT            2
275200200529      *
275300200529      ** Trade Counterparty
275400200529     C                   PARM                    TCNR
275500200529      *
275600200529      ** Security details
275700200529     C*******************PARM                    SECTY                                        206651
275800200529     C                   PARM                    SECTY2                                       206651
275900200529      *
276000200529      ** Nominal Currency Details
276100200529     C                   PARM                    NomCcyDts
276200200529      *
276300200529      ** Customer (Counterparty) Details
276400200529     C                   PARM                    CustDts
276500200529      *
276600200529      ** Portfolio Details
276700200529     C                   PARM                    PortDts
276800200529      *
276900200529      ** ICD
277000200529      ** PM installed
277100200529      ** Bank Portfolios installed
277200200529      ** Ref applied to 9997 portfolio
277300200529      ** Autocharge Option
277400200529      ** Adjust Commission Same Day T
277500200529      ** Priority of Cust Grp Dft
277600200529      ** Priority of Invst typ Dft
277700200529      ** Priority of Market Dft
277800200529      ** Priority of Cust Chrg Dft
277900200529      ** Midas/TOF I/F installed
278000200529     C                   PARM                    BGPFMG            1
278100200529     C                   PARM                    FCPORS            1
278200200529     C                   PARM                    FCR997            4
278300200529     C                   PARM                    BVACOP            1
278400200529     C                   PARM                    BVACSD            1
278500200529     C                   PARM                    BVPCSD            1
278600200529     C                   PARM                    BVPIDF            1
278700200529     C                   PARM                    BVPMDF            1
278800200529     C                   PARM                    BVPOCD            1
278900200529     C                   PARM                    S01496            1
279000200529     C****************** PARM                    CAP050            1     CAP050 CPB001
279100200529     C                   PARM                    BGN4ST            1            CPB001
279200200529
279300200529      * OUTPUTS
279400200529
279500200529      ** Commission Rebate %
279600200529     C                   PARM                    CMRP              5 3
279700200529
279800200529      ** Trade Charges & Commissions screen fields
279900200529
280000200529     C                   PARM                    NewTrChCm
280100200529
280200200529      ** Trade Charges & Commissions file fields
280300200529
280400200529     C                   PARM                    TBCC              2
280500200529     C                   PARM                    TCCC              2
280600200529     C                   PARM                    TCC1              2
280700200529     C                   PARM                    TCC2              2
280800200529
280900200529     C                   END
281000200529
281100200529      ** UPDATE CHECK FIELDS
281200200529
281300200529     C                   MOVEL     DDACTN        ##ACTN            1
281400200529     C                   MOVEL     DDTDRF        ##TDRF            6
281500200529     C                   MOVEL     DDSETC        ##SETC            3
281600200529     C                   MOVEL     DDCNUM        ##CNUM           10
281700200529
281800200529     C     EndDFLT@O     ENDSR
281900200529      *****************************************************************
282000200529      /EJECT
282100200529      *****************************************************************
282200200529      * VAL@O  - VALIDATE INPUT TO OTHER DETAILS SCREEN
282300200529      *****************************************************************
282400200529     C     VAL@O         BEGSR
282500200529      *
282600200529      *----------------------------------------------------------------
282700200529      * IF AUTHORIZE / APPROVE
282800200529      *
282900200529     C     DDACTN        IFEQ      'Y'
283000200529     C     DDACTN        OREQ      'P'
283100200529      *
283200200529      * If MT5XX Message Generation not installed, Go To Updates
283300200529      * Else, Go to EXTENSION (SWIFT) screen A
283400200529      *
283500200529     C     S01401        IFNE      'Y'
283600200529     C                   MOVEL     'U'           @SCRN
283700200529     C                   ELSE
283800200529     C                   MOVEL     'A'           @SCRN
283900200529     C                   END
284000200529      *
284100200529     C                   GOTO      EndVAL@O
284200200529     C                   END
284300200529      *
284400200529      *----------------------------------------------------------------
284500200529      * IF INSERT OR AMEND / CHANGE
284600200529      *
284700200529     C     DDACTN        IFEQ      'I'
284800200529     C     DDACTN        OREQ      'A'
284900200529     C     DDACTN        OREQ      'C'
285000200529      *
285100200529      * CHARGES AND COMMISSIONS CALCULATION
285200200529      *
285300200529     C     BVACOP        IFEQ      'Y'
285400200529     C                   EXSR      CHCMCAL
285500200529     C                   END
285600200529      *
285700200529      * Prior to validation, initialize error indicators as 'OK'
285800200529      *
285900200529     C                   Z-ADD     *ZERO         Idx               3 0
286000200529     C                   Z-ADD     *ZERO         WIdx_OVAL         3 0
286100200529     C                   MOVE      *ALL'Y'       OKTrExch
286200200529     C                   MOVE      *ALL'Y'       OKTrSett
286300200529     C                   MOVE      *ALL'Y'       OKTrChcm
286400200529      *
286500200529      * Validate "Other Details" Screen
286600200529      *
286700200529     C                   CALLB     'SETRADOVAL'
286800200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
286900200529      * INPUTS :
287000200529      * Response mode
287100200529     C                   PARM                    RespMode
287200200529      ** Trade Primary Details
287300200529      ** Trade Secondary Details
287400200529      ** Trade Exchange Rates
287500200529      ** Trade Settlement Instructions
287600200529      ** Trade Charge & Commissions
287700200529     C                   PARM                    NewTrPrim
287800200529     C                   PARM                    NewTrSeco
287900200529     C                   PARM                    NewTrExch
288000200529     C                   PARM                    NewTrSett
288100200529     C                   PARM                    NewTrChCm
288200200529      * Custom Extra Data file data                                             CAP004
288300200529     C                   PARM                    ExtData                        CAP004
288400200529
288500200529      ** Security Details
288600200529      ** Investment Type Details
288700200529     C*******************PARM                    SECTY                                        206651
288800200529     C                   PARM                    SECTY2                                       206651
288900200529     C                   PARM                    INVTP
289000200529      *
289100200529      ** Customer (Counterparty) Details
289200200529     C                   PARM                    CustDts
289300200529
289400200529      ** Portfolio Details
289500200529     C                   PARM                    PortDts
289600200529
289700200529      ** Nominal Currency Details
289800200529      ** Settlement Currency Details
289900200529     C                   PARM                    NomCcyDts
290000200529     C                   PARM                    SetCcyDts
290100200529                                                                                              CGL031
290200200529      ** Taxation of Savings Income                                                           CGL031
290300200529     C                   PARM                    CGL031                                       CGL031
290400200529      *
290500200529      * OUTPUTS :
290600200529      ** FX Margin Amount
290700200529      ** Portfolio exchange rate & M/D ind screen format
290800200529     C                   PARM                    DDMAMT           18
290900200529     C                   PARM                    DDSPXR           14
291000200529     C                   PARM                    DDSPMD            1
291100200529
291200200529      ** Trade Exchange Rates OK inds
291300200529      ** Trade Settlement Instructions OK
291400200529      ** Trade Charge & Commissions OK inds
291500200529     C                   PARM                    OKTrExch
291600200529     C                   PARM                    OKTrSett
291700200529     C                   PARM                    OKTrChcm
291800200529
291900200529      * Error fields/message IDs/message data (arrays) from/to caller
292000200529     C                   PARM                    FldNameArr
292100200529     C                   PARM                    MsgIDArr
292200200529     C                   PARM                    MsgDtaArr
292300200529      * Array index (3P0) from/to caller
292400200529     C                   PARM                    Idx
292500200529
292600200529      * Warning fields/message IDs/message data (arrays) from/to caller
292700200529     C                   PARM                    WFldNamArr
292800200529     C                   PARM                    WMsgIDArr
292900200529     C                   PARM                    WMsgDtaArr
293000200529      * Array index (3P0) from/to caller
293100200529     C                   PARM                    WIdx_OVAL
293200200529
293300200529      * Valid Trade layout (DS) from/to caller
293400200529     C                   PARM                    NwTrFilFmt
293500200529      *
293600200529      * DO COUNTERVALUE CALCULATION
293700200529      *
293800200529     C/COPY WNCPYSRC,SETRADRC04
293900200529     C     CGL031        IFEQ      'Y'                                                        233881
294000200529     C                   EXSR      EUTXCAL                                                    233881
294100200529     C                   ENDIF                                                                233881
294200200529     C                   EXSR      CVALCAL
294300200529     C/COPY WNCPYSRC,SETRADRC05
294400200529                                                                                             BUG3145
294500200529      ** Additional validations                                                              BUG3145
294600200529      ** (Pay To Account)                                                                    BUG3145
294700200529                                                                                             BUG3145
294800200529     C                   IF        CGL014 = 'Y'  AND  PAYT <> *BLANKS                        BUG3145
294900200529     C                             AND  DDPAYTOK <> 'N'                                      BUG3145
295000200529                                                                                             BUG3145
295100200529     C                   CALLB     'SETRADAVAL'                                              BUG3145
295200200529                                                                                             BUG3145
295300200529      ** INPUTS                                                                              BUG3145
295400200529                                                                                             BUG3145
295500200529      ** Action Code                                                                         BUG3145
295600200529      ** Nominal Currency                                                                    BUG3145
295700200529     C                   PARM                    DDACTN                                      BUG3145
295800200529     C                   PARM                    NMCY                                        BUG3145
295900200529                                                                                             BUG3145
296000200529      ** Valid Trade layout (DS) from/to caller                                              BUG3145
296100200529     C                   PARM                    NwTrFilFmt                                  BUG3145
296200200529                                                                                             BUG3145
296300200529      ** OUTPUTS                                                                             BUG3145
296400200529                                                                                             BUG3145
296500200529      ** Trade Settlement Instructions OK                                                    BUG3145
296600200529     C                   PARM                    OKTrSett                                    BUG3145
296700200529                                                                                             BUG3145
296800200529      ** Error fields/message IDs/message data (arrays) from/to caller                       BUG3145
296900200529     C                   PARM                    FldNameArr                                  BUG3145
297000200529     C                   PARM                    MsgIDArr                                    BUG3145
297100200529     C                   PARM                    MsgDtaArr                                   BUG3145
297200200529                                                                                             BUG3145
297300200529      ** Array index (3P0) from/to caller                                                    BUG3145
297400200529     C                   PARM                    Idx                                         BUG3145
297500200529                                                                                             BUG3145
297600200529      ** Warning fields/message IDs/message data (arrays) from/to caller                     BUG3145
297700200529     C                   PARM                    WFldNamArr                                  BUG3145
297800200529     C                   PARM                    WMsgIDArr                                   BUG3145
297900200529     C                   PARM                    WMsgDtaArr                                  BUG3145
298000200529                                                                                             BUG3145
298100200529      ** Array index (3P0) from/to caller                                                    BUG3145
298200200529     C                   PARM                    WIdx_OVAL                                   BUG3145
298300200529     C                   ENDIF                                                               BUG3145
298400200529      *
298500200529      * If errors returned
298600200529      *
298700200529     C     Idx           IFNE      0
298800200529     C                   GOTO      EndVAL@O
298900200529     C                   END
299000200529      *                                                                         CAP051
299100200529      * Setup Automatic Authorisation flag on the Valid file                    CAP051
299200200529     C     CAP051        IFEQ      'Y'                                          CAP051
299300200529     C                   EVAL      C_AUTH = DDAUTHA                             CAP051
299400200529     C                   ENDIF                                                  CAP051
299500200529      *
299600200529      * If the screen has changed in the course of the validation
299700200529      * or if there are warnings which have not been displayed
299800200529      *   re-output the screen
299900200529      *
300000200529     C     NewTrExch     IFNE      PrvTrExch
300100200529     C     NewTrSett     ORNE      PrvTrSett
300200200529     C     NewTrChCm     ORNE      PrvTrChCm
300300200529     C     WIdx_OVAL     ORNE      PrvN_Warn
300400200529     C                   GOTO      EndVAL@O
300500200529     C                   END
300600200529      *
300700200529      * Clear any warning messages
300800200529      *
300900200529     C                   MOVE      *ALL'Y'       OKTrExch
301000200529     C                   MOVE      *ALL'Y'       OKTrSett
301100200529     C                   MOVE      *ALL'Y'       OKTrChcm
301200200529     C                   MOVEL     *BLANK        WFldNamArr
301300200529     C                   MOVEL     *BLANK        WMsgIdArr
301400200529     C                   MOVEL     *BLANK        WMsgDtaArr
301500200529      *
301600200529      * If MT5XX Message Generation not installed, Go To Updates
301700200529      * Else, Go to EXTENSION (SWIFT) screen A
301800200529      *
301900200529     C     S01401        IFNE      'Y'
302000200529     C                   IF        @OPSEL = 'N'                                              BUG9617
302100200529     C                   EVAL      @SCRN  = 'R'                                              BUG9617
302200200529     C                   ELSE                                                                BUG9617
302300200529     C                   MOVEL     'U'           @SCRN
302400200529     C                   ENDIF                                                               BUG9617
302500200529     C                   ELSE
302600200529     C                   MOVEL     'A'           @SCRN
302700200529     C                   END
302800200529      *
302900200529     C                   END
303000200529      *----------------------------------------------------------------
303100200529      *
303200200529     C     EndVAL@O      ENDSR
303300200529      *****************************************************************
303400200529      /EJECT
303500200529      *****************************************************************
303600200529      * SCRN@E_A - PROCESS EXTENSION (SWIFT) SCREEN A
303700200529      *****************************************************************
303800200529     C     SCRN@E_A      BEGSR
303900200529      *
304000200529      ** Check whether screen B is required
304100200529      *
304200200529     C                   MOVE      'N'           Display_B         1
304300200529     C     CSW003        IFEQ      'Y'
304400200529     C     CustClass     IFEQ      'S'
304500200529     C     DELT          ANDNE     DELF
304600200529     C     CustClass     OREQ      'D'
304700200529     C     DELT          ANDNE     DELF
304800200529     C                   MOVE      'Y'           Display_B
304900200529     C                   END
305000200529     C                   END
305100200529
305200200529      * Update 'previous' screens and previous number of warnings
305300200529
305400200529     C**********         MOVEL     NewTrSwftA    PrvTrSwft                                    201429
305500200529     C**********         Z-ADD     WIdx_EVALA    PrvN_Warn         3 0                        201429
305600200529      *
305700200529      * IF INSERTION AND
305800200529      * INSTRUCTIONS NOT PRESENT AND                                            154208
305900200529      * IF FIRST TIME FOR TRADE REF, TYPE, METHOD, CLEAR TYPE, DEPOTS ..
306000200529      *
306100200529     C     DDACTN        IFEQ      'I'
306200200529     C     NewTrSwftA    ANDEQ     *BLANK                                       154208
306300200529     C     DDTDRF        IFNE      A_##TDRF
306400200529     C     DDTDRF        ANDNE     *BLANKS                                                    201429
306500200529     C     A_##TDRF      ANDNE     *BLANKS                                                    201429
306600200529     C     DDTDTP        ORNE      A_##TDTP
306700200529     C     DDSMTH        ORNE      A_##SMTH
306800200529     C     DDCLTY        ORNE      A_##CLTY
306900200529     C     DDPCOD        ORNE      A_##PCOD
307000200529     C     DDPRYC        ORNE      A_##PRYC
307100200529     C     DDCNUM        ORNE      A_##CNUM
307200200529     C     DDDELF        ORNE      A_##DELF
307300200529     C     DDDELT        ORNE      A_##DELT
307400200529      *
307500200529      * DO DEFAULTING FOR EXTENSION SCREEN A
307600200529      *
307700200529     C                   EXSR      DFLT@E_A
307800200529     C                   END
307900200529     C                   END
308000200529      *                                                                                       CAP067
308100200529      ** For buy-sell trade only, if no errors/warnings on the first leg and details B        CAP067
308200200529      ** is not to be displayed, display message that says this is one side of the buy-       CAP067
308300200529      ** sell, press enter to continue                                                        CAP067
308400200529      *                                                                                       CAP067
308500200529     C     WKSHOW        IFEQ      'Y'                                                        CAP067
308600200529     C     WKFLEG        ANDEQ     'Y'                                                        CAP067
308700200529     C     MsgIdArr(1)   ANDEQ     *BLANKS                                                    CAP067
308800200529     C     WMsgIdArr(1)  ANDEQ     *BLANKS                                                    CAP067
308900200529     C     Display_B     ANDEQ     'N'                                                        CAP067
309000200529     C                   ADD       1             E                                            CAP067
309100200529     C                   MOVEL     '*ANY'        FldNameArr(1)                                CAP067
309200200529     C                   MOVEL     'MMM0023'     MsgIdArr(1)                                  CAP067
309300200529     C                   MOVE      'N'           WKFLEG                                       CAP067
309400200529     C                   ENDIF                                                                CAP067
309500200529      *                                                                                       201429
309600200529     C                   MOVEL     NewTrSwftA    PrvTrSwft                                    201429
309700200529     C                   Z-ADD     WIdx_EVALA    PrvN_Warn         3 0                        201429
309800200529      *
309900200529      ** WRITE/READ DISPLAY - Extension Screen
310000200529      *
310100200529     C                   CALLB     'SETRADEDSP'
310200200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
310300200529      ** INPUT PARAMETERS :
310400200529      * Return Code
310500200529     C                   PARM      *BLANK        RetCodeOut
310600200529      *
310700200529      * Screen A/B
310800200529     C                   PARM      'A'           Screen
310900200529      *
311000200529      * Trade (IN SCREEN FORMAT) - Primary/Settlements/SWIFT
311100200529     C                   PARM                    NewTrPrim
311200200529     C                   PARM                    NewTrSeco                      140951
311300200529     C                   PARM                    NewTrSett
311400200529     C                   PARM                    NewTrSwftA
311500200529     C                   PARM                    NewTrExtA                                    CSE045
311600200529      *
311700200529      * Trade (file fields)
311800200529     C                   PARM                    TCNR
311900200529     C                   PARM                    TNMC                           140951
312000200529     C                   PARM                    NOML                           140951
312100200529     C                   PARM                    TDVD                           140951
312200200529     C                   PARM                    DELF
312300200529     C                   PARM                    DELT
312400200529      *                                                                                       201429
312500200529      ** Process SE1806 flag                                                                  201429
312600200529     C                   PARM                    PUYAT             1                          201429
312700200529      *                                                                                       201429
312800200529      ** ISO15022 indicator in file                                                           201429
312900200529     C                   PARM                    A_T1NEW                                      201429
313000200529      *                                                                                       210517
313100200529      ** Default SSI Flag                                                                     210517
313200200529     C                   PARM      'Y'           DftFlag           1                          210517
313300200529      *                                                                                       210517
313400200529      * Fields in error
313500200529     C                   PARM                    OKTrSwft
313600200529     C                   PARM                    OkTrExts                                     CSE045
313700200529      * Errors
313800200529     C                   PARM                    FldNameArr
313900200529     C                   PARM                    MsgIdArr
314000200529     C                   PARM                    MsgDtaArr
314100200529      * Warnings
314200200529     C                   PARM                    WFldNamArr
314300200529     C                   PARM                    WMsgIdArr
314400200529     C                   PARM                    WMsgDtaArr
314500200529      * Destination of Settlement Text fields
314600200529     C                   PARM                    A_DDROUS          6
314700200529     C                   PARM                    A_DDROTS         12
314800200529      * Destination of Confirmation Text fields
314900200529     C                   PARM                    A_DDROUC          6
315000200529     C                   PARM                    A_DDROTC         12
315100200529      * Security report name
315200200529     C**********         PARM                    DDSRPN                                       CSE016
315300200529     C                   PARM                    DDSRNME                                      CSE016
315400200529      * Swift 2001 flag                                                                       CSW201
315500200529     C                   PARM                    CSW201                                       CSW201
315600200529     C                   PARM      'RPR'         PMODE                                        CSE045
315700200529      *                                                                                       CAP067
315800200529      ** Buy-sell back                                                                        CAP067
315900200529     C                   PARM      'N'           PBYSL                                        CAP067
316000200529      *
316100200529      ** OUTPUT PARAMETERS :
316200200529      * Function Keys
316300200529     C                   PARM      '0'           @INKC             1
316400200529     C                   PARM      '0'           @INKE             1
316500200529     C                   PARM      '0'           @INKL             1
316600200529     C                   PARM      '0'           @INKN             1            140951
316700200529      * Write screen with no read indicator
316800200529     C                   PARM      'N'           WriteOnly         1
316900200529      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
317000200529      **  Watch Enhancement.                                                                  CSD015
317100200529     C                   PARM                    PMCWL                                        CSD015
317200200529     C                   PARM                    NT2AFilFmt                                   CSE045
317300200529      *
317400200529      * RESET ERRORS ....
317500200529      *
317600200529     C                   MOVE      *ALL'Y'       OKTrSwft
317700200529     C                   MOVEL     *BLANK        FldNameArr
317800200529     C                   MOVEL     *BLANK        MsgIdArr
317900200529     C                   MOVEL     *BLANK        MsgDtaArr
318000200529     C                   MOVEL     *BLANK        WFldNamArr
318100200529     C                   MOVEL     *BLANK        WMsgIdArr
318200200529     C                   MOVEL     *BLANK        WMsgDtaArr
318300200529      *
318400200529      * F3 - End Program
318500200529     C     @INKC         CASEQ     '1'           ENDP
318600200529      *
318700200529      * F5 - Go To Initial Screen
318800200529     C     @INKE         CASEQ     '1'           INITIAL
318900200529      *
319000200529      * F12 - Cancel on Extension Screen
319100200529     C     @INKL         CASEQ     '1'           CANC@E_A
319200200529      *                                                                         140951
319300200529      * F14 - Return from F14 Ext. Settlements                                  140951
319400200529     C     @INKN         CASEQ     '1'           ExtSettA                       140951
319500200529      *
319600200529      * Validate Input to Extension Screen
319700200529     C                   CAS                     VAL@E_A
319800200529      *
319900200529     C                   ENDCS
320000200529      *
320100200529     C                   ENDSR
320200200529      *****************************************************************
320300200529      /EJECT
320400200529      *****************************************************************
320500200529      * DFLT@E_A  - DO DEFAULTING FOR EXTENSION SCREEN A
320600200529      *****************************************************************
320700200529     C     DFLT@E_A      BEGSR
320800200529      *
320900200529      ** SWIFT (SCREEN) FIELD DEFAULTING
321000200529      *
321100200529     C                   CALLB     'SETSWFTDFT'
321200200529      *
321300200529      ** INPUT PARAMETERS :
321400200529      *
321500200529      * Screen A/B
321600200529     C                   PARM      'A'           Screen            1
321700200529      *
321800200529      * Trade Details (screen)
321900200529      *
322000200529     C                   PARM                    DDACTN            1
322100200529     C                   PARM                    DDTDTP            2
322200200529     C                   PARM                    DDSMTH            2
322300200529     C                   PARM                    DDCLTY            1
322400200529     C                   PARM                    DDPCOD            1
322500200529     C                   PARM                    DDPRYC            1
322600200529     C                   PARM                    DDBRCD                                       CSE028
322700200529     C                   PARM                    DDBPBK                                       CSE028
322800200529     C                   PARM                    DDSETC                                       CSE028
322900200529     C                   PARM                    DDMRKT                                       CSE034
323000200529      *
323100200529      * Trade Details (file)
323200200529     C                   PARM                    TDVD
323300200529     C                   PARM                    TCNR
323400200529     C                   PARM                    DELF
323500200529     C                   PARM                    DELT
323600200529     C                   PARM                    INVT                                         199797
323700200529      *
323800200529      * (CSW003) MT5XX - Phase 2 Message Generation
323900200529     C                   PARM                    CSW003            1
324000200529      *
324100200529      ** OUTPUT PARAMETERS :
324200200529      *
324300200529      * Screen A details
324400200529     C                   PARM                    NewTrSwftA
324500200529     C                   PARM                    A_DDROUS          6
324600200529     C                   PARM                    A_DDROTS         12
324700200529     C                   PARM                    A_DDROUC          6
324800200529     C                   PARM                    A_DDROTC         12
324900200529      *
325000200529      * Screen B details
325100200529     C                   PARM                    NewTrSwftB
325200200529     C                   PARM                    B_DDROUS          6
325300200529     C                   PARM                    B_DDROTS         12
325400200529     C                   PARM                    B_DDROUC          6
325500200529     C                   PARM                    B_DDROTC         12
325600200529
325700200529     C                   MOVEL     DDTDRF        A_##TDRF          6
325800200529     C                   MOVEL     DDTDTP        A_##TDTP          2
325900200529     C                   MOVEL     DDSMTH        A_##SMTH          2
326000200529     C                   MOVEL     DDCLTY        A_##CLTY          1
326100200529     C                   MOVEL     DDPCOD        A_##PCOD          1
326200200529     C                   MOVEL     DDPRYC        A_##PRYC          1
326300200529     C                   MOVEL     DDCNUM        A_##CNUM         10
326400200529     C                   MOVEL     DDDELF        A_##DELF         10
326500200529     C                   MOVEL     DDDELT        A_##DELT         10
326600200529
326700200529     C                   ENDSR
326800200529      *****************************************************************
326900200529      /EJECT
327000200529      *****************************************************************
327100200529      * VAL@E_A - VALIDATE INPUT TO EXTENSION SCREEN A
327200200529      *****************************************************************
327300200529     C     VAL@E_A       BEGSR
327400200529      *
327500200529      *----------------------------------------------------------------
327600200529      * IF AUTHORIZE / APPROVE
327700200529      *
327800200529     C     DDACTN        IFEQ      'Y'
327900200529     C     DDACTN        OREQ      'P'
328000200529      *
328100200529      * If screen B can't be displayed
328200200529      *    Go to updates
328300200529      * Else, Go to EXTENSION (SWIFT) screen B
328400200529      *
328500200529     C     Display_B     IFNE      'Y'
328600200529     C                   MOVEL     'U'           @SCRN
328700200529     C                   ELSE
328800200529     C                   MOVEL     'B'           @SCRN
328900200529     C                   END
329000200529      *
329100200529     C                   GOTO      EndVAL@E_A
329200200529     C                   END
329300200529      *
329400200529      *----------------------------------------------------------------
329500200529      * IF INSERT OR AMEND / CHANGE
329600200529      *
329700200529     C     DDACTN        IFEQ      'I'
329800200529     C     DDACTN        OREQ      'A'
329900200529     C     DDACTN        OREQ      'C'
330000200529      *
330100200529      * Prior to validation, initialize error indicators as 'OK'
330200200529      *
330300200529     C                   Z-ADD     *ZERO         Idx               3 0
330400200529     C                   Z-ADD     *ZERO         WIdx_EVALA        3 0
330500200529     C                   MOVE      *ALL'Y'       OKTrSwft
330600200529      *
330700200529      * Validate Extension Screen
330800200529      *
330900200529     C                   CALLB     'SETRADEVAL'
331000200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
331100200529      ** INPUTS
331200200529      *
331300200529      * Response mode
331400200529     C                   PARM                    RespMode          1
331500200529      *
331600200529      * Screen (A or B)
331700200529     C                   PARM      'A'           Screen            1
331800200529      *
331900200529      ** Trade Primary Details
332000200529      ** Trade Secondary Details
332100200529      ** Trade Exchange Rates
332200200529      ** Trade Settlement Details
332300200529     C                   PARM                    NewTrPrim
332400200529     C                   PARM                    NewTrSeco
332500200529     C                   PARM                    NewTrExch
332600200529     C                   PARM                    NewTrSett
332700200529      *
332800200529      ** Trade Extension File details
332900200529     C                   PARM                    NewTrSwftA
333000200529      * Custom Extra Data file data                                             CAP004
333100200529     C                   PARM                    ExtData                        CAP004
333200200529      *
333300200529      ** Previous inds
333400200529     C                   PARM                    @ADDGMES
333500200529     C                   PARM                    @ADDGMEC
333600200529     C                   PARM                    @ADDCCID
333700200529     C                   PARM                    CA_T1CONG
333800200529      *
333900200529      ** Processing type
334000200529     C                   PARM                    PROT              1
334100200529      *
334200200529      ** Override errors
334300200529     C                   PARM                    OVRErrors         1
334400200529      *
334500200529      ** Valid Trade layout (DS) from/to caller
334600200529     C                   PARM                    NwTrFilFmt
334700200529      * Swift 2001 flag                                                                       CSW201
334800200529     C                   PARM                    CSW201                                       CSW201
334900200529      *                                                                                       201233
335000200529      ** Destination of settlement                                                            201233
335100200529     C                   PARM                    A_DDROTS                                     201233
335200200529      *                                                                                       201429
335300200529      ** Process SE1806 flag                                                                  201429
335400200529     C                   PARM                    PUYAT                                        201429
335500200529                                                                                              210517
335600200529      ** Tradsdx2 data                                                                        210517
335700200529                                                                                              210517
335800200529     C                   PARM      *BLANKS       PTradeX2                                     210517
335900200529      *
336000200529      ** OUTPUTS
336100200529      *
336200200529      * OK Flags
336300200529     C                   PARM                    OKTrSwft
336400200529      * Error fields/message IDs/message data (arrays) from/to caller
336500200529     C                   PARM                    FldNameArr
336600200529     C                   PARM                    MsgIDArr
336700200529     C                   PARM                    MsgDtaArr
336800200529      * Array index (3P0) from/to caller
336900200529     C                   PARM                    Idx
337000200529      * Warning fields/message IDs/message data (arrays) from/to caller
337100200529     C                   PARM                    WFldNamArr
337200200529     C                   PARM                    WMsgIDArr
337300200529     C                   PARM                    WMsgDtaArr
337400200529      * Array index (3P0) from/to caller
337500200529     C                   PARM                    WIdx_EVALA
337600200529      *
337700200529      * Valid Trade layout (DS) (Extension file) from/to caller
337800200529     C                   PARM                    NT1AFilFmt
337900200529      *                                                                                       CAP067
338000200529      ** If this is a buy-sell trade, and screen details B is not to be displayed,            CAP067
338100200529      *                                                                                       CAP067
338200200529     C     BDBYSL        IFEQ      'Y'                                                        CAP067
338300200529     C     LKRF          ANDNE     *BLANKS                                                    CAP067
338400200529     C     Display_B     ANDNE     'Y'                                                        CAP067
338500200529      *                                                                                       CAP067
338600200529      ** If action is Amend or Change, set flag that displays message before the              CAP067
338700200529      ** program shows the next leg                                                           CAP067
338800200529      *                                                                                       CAP067
338900200529     C     DDACTN        IFEQ      'A'                                                        CAP067
339000200529     C     DDACTN        OREQ      'C'                                                        CAP067
339100200529     C                   MOVE      'Y'           WKSHOW            1                          CAP067
339200200529     C                   ELSE                                                                 CAP067
339300200529     C                   MOVE      'N'           WKSHOW                                       CAP067
339400200529     C                   ENDIF                                                                CAP067
339500200529      *                                                                                       CAP067
339600200529     C                   ENDIF                                                                CAP067
339700200529      *
339800200529      * If errors returned
339900200529      *
340000200529     C     Idx           IFNE      0
340100200529     C                   GOTO      EndVAL@E_A
340200200529     C                   END
340300200529      *
340400200529      * If the screen has changed in the course of the validation
340500200529      * or if there are warnings which have not been displayed
340600200529      *   re-output the screen
340700200529      *
340800200529     C     NewTrSwftA    IFNE      PrvTrSwft
340900200529     C     WIdx_EVALA    ORNE      PrvN_Warn
341000200529     C     PUYAT         OREQ      'N'                                                        201429
341100200529     C     PUYAT         IFEQ      'N'                                                        201429
341200200529     C                   EVAL      PUYAT = 'Y'                                                201429
341300200529     C                   ENDIF                                                                201429
341400200529     C                   GOTO      EndVAL@E_A
341500200529     C                   END
341600200529      *
341700200529      * Clear any warning messages
341800200529      *
341900200529     C                   MOVE      *ALL'Y'       OKTrSwft
342000200529     C                   MOVEL     *BLANK        WFldNamArr
342100200529     C                   MOVEL     *BLANK        WMsgIdArr
342200200529     C                   MOVEL     *BLANK        WMsgDtaArr
342300200529      *
342400200529      * If screen B can't be displayed
342500200529      *    Go to updates
342600200529      * Else, Go to EXTENSION (SWIFT) screen B
342700200529      *
342800200529     C                   IF        ULX603   = 'Y'                                             CER001
342900200529     C                   EVAL      PRV_SCRN = @SCRN                                           CER001
343000200529     C                   ENDIF                                                                CER001
343100200529      *                                                                                       CER001
343200200529     C     Display_B     IFNE      'Y'
343300200529      *                                                                                       CER001
343400200529      ** If ULX603 switchable feature is ON                                                   CER001
343500200529      *                                                                                       CER001
343600200529     C                   IF        ULX603  = 'Y'                                              CER001
343700200529     C                   EVAL      @SCRN   = 'L'                                              CER001
343800200529     C                   ELSE                                                                 CER001
343900200529     C                   IF        @OPSEL  = 'N'                                             BUG9617
344000200529     C                   EVAL      @SCRN   = 'R'                                             BUG9617
344100200529     C                   ELSE                                                                BUG9617
344200200529     C                   MOVEL     'U'           @SCRN
344300200529     C                   ENDIF                                                               BUG9617
344400200529     C                   ENDIF                                                                CER001
344500200529      *                                                                                       CER001
344600200529     C                   ELSE
344700200529     C                   MOVEL     'B'           @SCRN
344800200529     C                   END
344900200529      *
345000200529     C                   END
345100200529      *----------------------------------------------------------------
345200200529      *
345300200529     C     EndVAL@E_A    ENDSR
345400200529      *****************************************************************
345500200529      /EJECT
345600200529      *****************************************************************
345700200529      * SCRN@E_B - PROCESS EXTENSION (SWIFT) SCREEN B
345800200529      *****************************************************************
345900200529     C     SCRN@E_B      BEGSR
346000200529
346100200529      * Update 'previous' screens and previous number of warnings
346200200529
346300200529     C*********          MOVEL     NewTrSwftB    PrvTrSwft                                    201429
346400200529     C*********          Z-ADD     WIdx_EVALB    PrvN_Warn         3 0                        201429
346500200529      *
346600200529      * IF INSERTION AND
346700200529      * INSTRUCTIONS NOT PRESENT AND                                            154208
346800200529      * IF FIRST TIME FOR TRADE REF, TYPE, METHOD, CLEAR TYPE, DEPOTS ..
346900200529      *
347000200529     C     DDACTN        IFEQ      'I'
347100200529     C     NewTrSwftB    ANDEQ     *BLANK                                       154208
347200200529     C     DDTDRF        IFNE      B_##TDRF
347300200529     C     DDTDRF        ANDNE     *BLANKS                                                    201429
347400200529     C     B_##TDRF      ANDNE     *BLANKS                                                    201429
347500200529     C     DDTDTP        ORNE      B_##TDTP
347600200529     C     DDSMTH        ORNE      B_##SMTH
347700200529     C     DDCLTY        ORNE      B_##CLTY
347800200529     C     DDPCOD        ORNE      B_##PCOD
347900200529     C     DDPRYC        ORNE      B_##PRYC
348000200529     C     DDCNUM        ORNE      B_##CNUM
348100200529     C     DDDELF        ORNE      B_##DELF
348200200529     C     DDDELT        ORNE      B_##DELT
348300200529      *
348400200529      * DO DEFAULTING FOR EXTENSION SCREEN B
348500200529      *
348600200529     C                   EXSR      DFLT@E_B
348700200529     C                   END
348800200529     C                   END
348900200529      *                                                                                       CAP067
349000200529      ** For buy-sell trade only, if no errors/warnings on the first leg, display             CAP067
349100200529      ** message that says this is one side of the buy-sell, press enter to continue          CAP067
349200200529      *                                                                                       CAP067
349300200529     C     WKSHOW        IFEQ      'Y'                                                        CAP067
349400200529     C     MsgIdArr(1)   ANDEQ     *BLANKS                                                    CAP067
349500200529     C     WMsgIdArr(1)  ANDEQ     *BLANKS                                                    CAP067
349600200529     C                   ADD       1             E                                            CAP067
349700200529     C                   MOVEL     '*ANY'        FldNameArr(E)                                CAP067
349800200529     C                   MOVEL     'MMM0023'     MsgIdArr(E)                                  CAP067
349900200529     C                   ENDIF                                                                CAP067
350000200529      *                                                                                       201429
350100200529     C                   MOVEL     NewTrSwftB    PrvTrSwft                                    201429
350200200529     C                   Z-ADD     WIdx_EVALB    PrvN_Warn         3 0                        201429
350300200529      *
350400200529      ** WRITE/READ DISPLAY - Extension Screen
350500200529      *
350600200529     C                   CALLB     'SETRADEDSP'
350700200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
350800200529      ** INPUT PARAMETERS :
350900200529      * Return Code
351000200529     C                   PARM      *BLANK        RetCodeOut
351100200529      *
351200200529      * Screen A/B
351300200529     C                   PARM      'B'           Screen
351400200529      *
351500200529      * Trade (IN SCREEN FORMAT) - Primary/Settlements/SWIFT
351600200529     C                   PARM                    NewTrPrim
351700200529     C                   PARM                    NewTrSeco                      140951
351800200529     C                   PARM                    NewTrSett
351900200529     C                   PARM                    NewTrSwftB
352000200529     C                   PARM                    NewTrExtB                                    CSE045
352100200529      *
352200200529      * Trade (file fields)
352300200529     C                   PARM                    TCNR
352400200529     C                   PARM                    TNMC                           140951
352500200529     C                   PARM                    NOML                           140951
352600200529     C                   PARM                    TDVD                           140951
352700200529     C                   PARM                    DELF
352800200529     C                   PARM                    DELT
352900200529      *                                                                                       201429
353000200529      ** Process SE1806 flag                                                                  201429
353100200529     C                   PARM                    PUYAT             1                          201429
353200200529      *                                                                                       201429
353300200529      ** ISO15022 indicator in file                                                           201429
353400200529     C                   PARM                    B_T1NEW                                      201429
353500200529      *                                                                                       211682
353600200529      ** Default SSI Flag                                                                     211682
353700200529     C                   PARM      'Y'           DftFlag           1                          211682
353800200529      *                                                                                       211682
353900200529      * Fields in error
354000200529     C                   PARM                    OKTrSwft
354100200529     C                   PARM                    OkTrExts                                     CSE045
354200200529      * Errors
354300200529     C                   PARM                    FldNameArr
354400200529     C                   PARM                    MsgIdArr
354500200529     C                   PARM                    MsgDtaArr
354600200529      * Warnings
354700200529     C                   PARM                    WFldNamArr
354800200529     C                   PARM                    WMsgIdArr
354900200529     C                   PARM                    WMsgDtaArr
355000200529      * Destination of Settlement Text fields
355100200529     C                   PARM                    B_DDROUS          6
355200200529     C                   PARM                    B_DDROTS         12
355300200529      * Destination of Confirmation Text fields
355400200529     C                   PARM                    B_DDROUC          6
355500200529     C                   PARM                    B_DDROTC         12
355600200529      * Security report name
355700200529     C**********         PARM                    DDSRPN                                       CSE016
355800200529     C                   PARM                    DDSRNME                                      CSE016
355900200529      * Swift 2001 flag                                                                       CSW201
356000200529     C                   PARM                    CSW201                                       CSW201
356100200529     C                   PARM      'RPR'         PMODE                                        CSE045
356200200529      *                                                                                       CAP067
356300200529      ** Buy-sell back                                                                        CAP067
356400200529     C                   PARM      'N'           PBYSL                                        CAP067
356500200529      *
356600200529      ** OUTPUT PARAMETERS :
356700200529      * Function Keys
356800200529     C                   PARM      '0'           @INKC             1
356900200529     C                   PARM      '0'           @INKE             1
357000200529     C                   PARM      '0'           @INKL             1
357100200529     C                   PARM      '0'           @INKN             1            140951
357200200529      * Write screen with no read indicator
357300200529     C                   PARM      'N'           WriteOnly         1
357400200529      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
357500200529      **  Watch Enhancement.                                                                  CSD015
357600200529     C                   PARM                    PMCWL                                        CSD015
357700200529     C                   PARM                    NT2BFilFmt                                   CSE045
357800200529      *
357900200529      * RESET ERRORS ....
358000200529      *
358100200529     C                   MOVE      *ALL'Y'       OKTrSwft
358200200529     C                   MOVEL     *BLANK        FldNameArr
358300200529     C                   MOVEL     *BLANK        MsgIdArr
358400200529     C                   MOVEL     *BLANK        MsgDtaArr
358500200529     C                   MOVEL     *BLANK        WFldNamArr
358600200529     C                   MOVEL     *BLANK        WMsgIdArr
358700200529     C                   MOVEL     *BLANK        WMsgDtaArr
358800200529      *
358900200529      * F3 - End Program
359000200529     C     @INKC         CASEQ     '1'           ENDP
359100200529      *
359200200529      * F5 - Go To Initial Screen
359300200529     C     @INKE         CASEQ     '1'           INITIAL
359400200529      *
359500200529      * F12 - Cancel on Extension Screen
359600200529     C     @INKL         CASEQ     '1'           CANC@E_B
359700200529      *                                                                         140951
359800200529      * F14 - Return from F14 Ext. Settlements                                  140951
359900200529     C     @INKN         CASEQ     '1'           ExtSettB                       140951
360000200529      *
360100200529      * Validate Input to Extension Screen
360200200529     C                   CAS                     VAL@E_B
360300200529      *
360400200529     C                   ENDCS
360500200529      *
360600200529     C                   ENDSR
360700200529      *****************************************************************
360800200529      /EJECT
360900200529      *****************************************************************
361000200529      * DFLT@E_B  - DO DEFAULTING FOR EXTENSION SCREEN B
361100200529      *****************************************************************
361200200529     C     DFLT@E_B      BEGSR
361300200529      *
361400200529      ** SWIFT (SCREEN) FIELD DEFAULTING
361500200529      *
361600200529     C                   CALLB     'SETSWFTDFT'
361700200529      *
361800200529      ** INPUT PARAMETERS :
361900200529      *
362000200529      * Screen A/B
362100200529     C                   PARM      'B'           Screen            1
362200200529      *
362300200529      * Trade Details (screen)
362400200529      *
362500200529     C                   PARM                    DDACTN            1
362600200529     C                   PARM                    DDTDTP            2
362700200529     C                   PARM                    DDSMTH            2
362800200529     C                   PARM                    DDCLTY            1
362900200529     C                   PARM                    DDPCOD            1
363000200529     C                   PARM                    DDPRYC            1
363100200529     C                   PARM                    DDBRCD                                       CSE028
363200200529     C                   PARM                    DDBPBK                                       CSE028
363300200529     C                   PARM                    DDSETC                                       CSE028
363400200529     C                   PARM                    DDMRKT                                       CSE034
363500200529      *
363600200529      * Trade Details (file)
363700200529     C                   PARM                    TDVD
363800200529     C                   PARM                    TCNR
363900200529     C                   PARM                    DELF
364000200529     C                   PARM                    DELT
364100200529     C                   PARM                    INVT                                         199797
364200200529      *
364300200529      * (CSW003) MT5XX - Phase 2 Message Generation
364400200529     C                   PARM                    CSW003            1
364500200529      *
364600200529      ** OUTPUT PARAMETERS :
364700200529      *
364800200529      * Screen A details
364900200529     C                   PARM                    NewTrSwftA
365000200529     C                   PARM                    A_DDROUS          6
365100200529     C                   PARM                    A_DDROTS         12
365200200529     C                   PARM                    A_DDROUC          6
365300200529     C                   PARM                    A_DDROTC         12
365400200529      *
365500200529      * Screen B details
365600200529     C                   PARM                    NewTrSwftB
365700200529     C                   PARM                    B_DDROUS          6
365800200529     C                   PARM                    B_DDROTS         12
365900200529     C                   PARM                    B_DDROUC          6
366000200529     C                   PARM                    B_DDROTC         12
366100200529
366200200529     C                   MOVEL     DDTDRF        B_##TDRF          6
366300200529     C                   MOVEL     DDTDTP        B_##TDTP          2
366400200529     C                   MOVEL     DDSMTH        B_##SMTH          2
366500200529     C                   MOVEL     DDCLTY        B_##CLTY          1
366600200529     C                   MOVEL     DDPCOD        B_##PCOD          1
366700200529     C                   MOVEL     DDPRYC        B_##PRYC          1
366800200529     C                   MOVEL     DDCNUM        B_##CNUM         10
366900200529     C                   MOVEL     DDDELF        B_##DELF         10
367000200529     C                   MOVEL     DDDELT        B_##DELT         10
367100200529
367200200529     C                   ENDSR
367300200529      *****************************************************************
367400200529      /EJECT
367500200529      *****************************************************************
367600200529      * VAL@E_B - VALIDATE INPUT TO EXTENSION SCREEN B
367700200529      *****************************************************************
367800200529     C     VAL@E_B       BEGSR
367900200529      *
368000200529      *----------------------------------------------------------------
368100200529      * IF AUTHORIZE / APPROVE
368200200529      *
368300200529     C     DDACTN        IFEQ      'Y'
368400200529     C     DDACTN        OREQ      'P'
368500200529      *                                                                                       CER001
368600200529      ** If ULX603 switchable feature is ON                                                   CER001
368700200529      *                                                                                       CER001
368800200529     C                   IF        ULX603   = 'Y'                                             CER001
368900200529     C                   EVAL      PRV_SCRN = @SCRN                                           CER001
369000200529     C                   EVAL      @SCRN    = 'L'                                             CER001
369100200529     C                   ELSE                                                                 CER001
369200200529      *
369300200529      ** If windows processing on, call window routine else                     174875
369400200529      * Go to updates
369500200529      *
369600200529     C     BGWDPR        IFEQ      'Y'                                          174875
369700200529     C                   MOVEL     'W'           @SCRN                          174875
369800200529     C                   ELSE                                                   174875
369900200529     C                   MOVEL     'U'           @SCRN
370000200529     C                   ENDIF                                                  174875
370100200529     C                   ENDIF                                                                CER001
370200200529      *
370300200529     C                   GOTO      EndVAL@E_B
370400200529     C                   END
370500200529      *
370600200529      *----------------------------------------------------------------
370700200529      * IF INSERT OR AMEND / CHANGE
370800200529      *
370900200529     C     DDACTN        IFEQ      'I'
371000200529     C     DDACTN        OREQ      'A'
371100200529     C     DDACTN        OREQ      'C'
371200200529      *
371300200529      * Prior to validation, initialize error indicators as 'OK'
371400200529      *
371500200529     C                   Z-ADD     *ZERO         Idx               3 0
371600200529     C                   Z-ADD     *ZERO         WIdx_EVALB        3 0
371700200529     C                   MOVE      *ALL'Y'       OKTrSwft
371800200529      *
371900200529      * Validate Extension Screen
372000200529      *
372100200529     C                   CALLB     'SETRADEVAL'
372200200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
372300200529      ** INPUTS
372400200529      *
372500200529      * Response mode
372600200529     C                   PARM                    RespMode          1
372700200529      *
372800200529      * Screen (A or B)
372900200529     C                   PARM      'B'           Screen            1
373000200529      *
373100200529      ** Trade Primary Details
373200200529      ** Trade Secondary Details
373300200529      ** Trade Exchange Rates
373400200529      ** Trade Settlement Details
373500200529     C                   PARM                    NewTrPrim
373600200529     C                   PARM                    NewTrSeco
373700200529     C                   PARM                    NewTrExch
373800200529     C                   PARM                    NewTrSett
373900200529      *
374000200529      ** Trade Extension File details
374100200529     C                   PARM                    NewTrSwftB
374200200529      * Custom Extra Data file data                                             CAP004
374300200529     C                   PARM                    ExtData                        CAP004
374400200529      *
374500200529      ** Previous inds
374600200529     C                   PARM                    @BDDGMES
374700200529     C                   PARM                    @BDDGMEC
374800200529     C                   PARM                    @BDDCCID
374900200529     C                   PARM                    CB_T1CONG
375000200529      *
375100200529      ** Processing type
375200200529     C                   PARM                    PROT              1
375300200529      *
375400200529      ** Override errors
375500200529     C                   PARM                    OVRErrors         1
375600200529      *
375700200529      ** Valid Trade layout (DS) from/to caller
375800200529     C                   PARM                    NwTrFilFmt
375900200529      * Swift 2001 flag                                                                       CSW201
376000200529     C                   PARM                    CSW201                                       CSW201
376100200529      *                                                                                       201233
376200200529      ** Destination of settlement                                                            201233
376300200529     C                   PARM                    B_DDROTS                                     201233
376400200529      *                                                                                       201429
376500200529      ** Process SE1806 flag                                                                  201429
376600200529     C                   PARM                    PUYAT                                        201429
376700200529                                                                                              210517
376800200529      ** Tradsdx2 data                                                                        210517
376900200529                                                                                              210517
377000200529     C                   PARM      *BLANKS       PTradeX2                                     210517
377100200529      *
377200200529      ** OUTPUTS
377300200529      *
377400200529      * OK Flags
377500200529     C                   PARM                    OKTrSwft
377600200529      * Error fields/message IDs/message data (arrays) from/to caller
377700200529     C                   PARM                    FldNameArr
377800200529     C                   PARM                    MsgIDArr
377900200529     C                   PARM                    MsgDtaArr
378000200529      * Array index (3P0) from/to caller
378100200529     C                   PARM                    Idx
378200200529      * Warning fields/message IDs/message data (arrays) from/to caller
378300200529     C                   PARM                    WFldNamArr
378400200529     C                   PARM                    WMsgIDArr
378500200529     C                   PARM                    WMsgDtaArr
378600200529      * Array index (3P0) from/to caller
378700200529     C                   PARM                    WIdx_EVALB
378800200529      *
378900200529      * Valid Trade layout (DS) (Extension file) from/to caller
379000200529     C                   PARM                    NT1BFilFmt
379100200529      *                                                                                       CAP067
379200200529      ** If the transaction is a buy-sell, and action is either Amend                         CAP067
379300200529      ** or Change, set flag that displays message before the program                         CAP067
379400200529      ** shows the next leg                                                                   CAP067
379500200529      *                                                                                       CAP067
379600200529     C     BDBYSL        IFEQ      'Y'                                                        CAP067
379700200529     C     LKRF          ANDNE     *BLANKS                                                    CAP067
379800200529     C     DDACTN        IFEQ      'A'                                                        CAP067
379900200529     C     DDACTN        OREQ      'C'                                                        CAP067
380000200529     C                   MOVE      'Y'           WKSHOW                                       CAP067
380100200529     C                   ELSE                                                                 CAP067
380200200529     C                   MOVE      'N'           WKSHOW                                       CAP067
380300200529     C                   ENDIF                                                                CAP067
380400200529     C                   ENDIF                                                                CAP067
380500200529      *
380600200529      * If errors returned
380700200529      *
380800200529     C     Idx           IFNE      0
380900200529     C                   GOTO      EndVAL@E_B
381000200529     C                   END
381100200529      *
381200200529      * If the screen has changed in the course of the validation
381300200529      * or if there are warnings which have not been displayed
381400200529      *   re-output the screen
381500200529      *
381600200529     C     NewTrSwftB    IFNE      PrvTrSwft
381700200529     C     WIdx_EVALB    ORNE      PrvN_Warn
381800200529     C     PUYAT         OREQ      'N'                                                        201429
381900200529     C     PUYAT         IFEQ      'N'                                                        201429
382000200529     C                   EVAL      PUYAT = 'Y'                                                201429
382100200529     C                   ENDIF                                                                201429
382200200529     C                   GOTO      EndVAL@E_B
382300200529     C                   END
382400200529      *
382500200529      * Clear any warning messages
382600200529      *
382700200529     C                   MOVE      *ALL'Y'       OKTrSwft
382800200529     C                   MOVEL     *BLANK        WFldNamArr
382900200529     C                   MOVEL     *BLANK        WMsgIdArr
383000200529     C                   MOVEL     *BLANK        WMsgDtaArr
383100200529      *                                                                                       CER001
383200200529      ** If ULX603 switchable feature is ON                                                   CER001
383300200529      *                                                                                       CER001
383400200529     C                   IF        ULX603   = 'Y'                                             CER001
383500200529     C                   EVAL      PRV_SCRN = @SCRN                                           CER001
383600200529     C                   EVAL      @SCRN    = 'L'                                             CER001
383700200529     C                   ELSE                                                                 CER001
383800200529      *
383900200529      ** If windows processing on, call window routine else                     174875
384000200529      * Go to updates
384100200529      *
384200200529     C     BGWDPR        IFEQ      'Y'                                          174875
384300200529     C                   MOVEL     'W'           @SCRN                          174875
384400200529     C                   ELSE                                                   174875
384500200529     C                   MOVEL     'U'           @SCRN
384600200529     C                   ENDIF                                                  174875
384700200529     C                   ENDIF                                                                CER001
384800200529      *
384900200529     C                   END
385000200529      *----------------------------------------------------------------
385100200529      *
385200200529     C     EndVAL@E_B    ENDSR
385300200529      *****************************************************************
385400200529      /EJECT
385500200529      *****************************************************************
385600200529      * RTVTRD - RETRIEVE TRADE
385700200529      *****************************************************************
385800200529     C     RTVTRD        BEGSR
385900200529      *
386000200529      * RETRIEVE TRADE
386100200529      *
386200200529     C                   CALLB     'SETRADRTV'
386300200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
386400200529      * INPUTS :
386500200529      * Return code
386600200529     C                   PARM      *BLANK        RetCodeOut
386700200529      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
386800200529      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
386900200529     C                   PARM                    @@MODE            6
387000200529      * Response mode
387100200529     C                   PARM      'S'           @@RSMD            1
387200200529      * Action Code
387300200529     C                   PARM                    DDACTN
387400200529      * Front Office Transaction ID
387500200529     C                   PARM                    FOTRID           20
387600200529      * (Midas) Trade Reference
387700200529     C                   PARM                    DDTDRF
387800200529      * MT5XX - Phase 2 Message Generation is on.                               154562
387900200529     C                   PARM                    CSW003                         154562
388000200529      *                                                                                       CAP067
388100200529      * Buy-sell back                                                                         CAP067
388200200529     C                   PARM                    PFBYSL            1                          CAP067
388300200529      *                                                                                       CAP067
388400200529      * Trade Reference                                                                       CAP067
388500200529     C                   PARM                    PFTDRF            6                          CAP067
388600200529      * OUTPUTS :
388700200529      * (Current) TRADE in file format
388800200529     C                   PARM                    CrTrFilFmt
388900200529     C                   PARM                    CT1AFilFmt
389000200529     C                   PARM                    CT1BFilFmt
389100200529      * OK - Action code
389200200529     C                   PARM      *BLANK        DDACTNOK
389300200529      * OK - Trade Reference
389400200529     C                   PARM      *BLANK        DDTDRFOK
389500200529      * Error fields/message IDs/message data (arrays) from/to caller
389600200529     C                   PARM                    FldNameArr
389700200529     C                   PARM                    MsgIdArr
389800200529     C                   PARM                    MsgDtaArr
389900200529      * Array index (3P0) from/to caller
390000200529     C                   PARM      *ZERO         Idx
390100200529      *                                                                                       193462
390200200529      **   Move book from file to work field for later checking.                              193462
390300200529      *                                                                                       193462
390400200529     C                   MOVE      C_TDBK        OLDBK1            2                          193462
390500200529     C                   MOVE      *BLANK        WARNIND           1                          193462
390600200529      *
390700200529     C/COPY WNCPYSRC,SETRADRC10
390800200529     C     EndRTVTRD     ENDSR
390900200529      *****************************************************************
391000200529      /EJECT
391100200529      *****************************************************************
391200200529      * CVTTRD - PUT A TRADE ON THE SECONDARY SCREEN
391300200529      *****************************************************************
391400200529     C     CVTTRD        BEGSR
391500200529      *
391600200529      * Call program to fill screen fields with data from TRADSD
391700200529      *
391800200529     C                   CALLB     'SETRADCVT'
391900200529      *
392000200529      * INPUTS :
392100200529      * Return Code
392200200529      * TRADE in file format
392300200529     C                   PARM      *BLANK        RetCodeOut
392400200529     C                   PARM                    CrTrFilFmt
392500200529     C                   PARM                    CT1AFilFmt
392600200529     C                   PARM                    CT1BFilFmt
392700200529                                                                                              CAS006
392800200529      ** Hedge Accounting Phase B                                                             CAS006
392900200529                                                                                              CAS006
393000200529     C                   PARM                    CAS006                                       CAS006
393100200529      * CGL031 Switchable Feature                                                             CGL031
393200200529     C                   PARM                    CGL031                                       CGL031
393300200529      * OUTPUTS
393400200529      * Trade - screen formats
393500200529     C                   PARM                    NewTrPrim
393600200529     C                   PARM                    NewTrSeco
393700200529     C                   PARM                    NewTrThir                                    CAS006
393800200529     C                   PARM                    NewTrExch
393900200529     C                   PARM                    NewTrSett
394000200529     C                   PARM                    NewTrChCm
394100200529     C                   PARM                    NewTrSwftA
394200200529     C                   PARM                    NewTrSwftB
394300200529
394400200529      ** Security Details
394500200529      ** Investment Type Details
394600200529     C*******************PARM                    SECTY                                       206651
394700200529     C                   PARM                    SECTY2                                      206651
394800200529     C                   PARM                    INVTP
394900200529
395000200529      ** Nominal Currency Details
395100200529     C                   PARM                    NomCcyDts
395200200529
395300200529      ** Settlement Currency Details
395400200529     C                   PARM                    SetCcyDts
395500200529      *
395600200529      ** Customer (Counterparty) Details
395700200529     C                   PARM                    CustDts
395800200529      * Trade Status
395900200529      * Trade Authorized/Not Authorized
396000200529     C                   PARM                    DDSTAT            9
396100200529     C                   PARM                    DDAUTH           14
396200200529      * Security report name
396300200529      * Customer report name
396400200529     C**********         PARM                    DDSRPN           20                          CSE016
396500200529     C                   PARM                    DDSRNME                                      CSE016
396600200529     C                   PARM                    DDCRNM           20
396700200529      * Coupon Rate
396800200529      * Current Factor
396900200529      * Margin Amount
397000200529      * Portfolio Exchange Rate
397100200529      * Portfolio M/D Ind
397200200529      * Trade Countervalue
397300200529     C                   PARM                    DDCPNR           13
397400200529     C                   PARM                    DDCFCT           12
397500200529     C                   PARM                    DDMAMT           18
397600200529     C                   PARM                    DDSPXR           14
397700200529     C                   PARM                    DDSPMD            1
397800200529     C                   PARM                    DDTCTR           21
397900200529     C                   PARM                    DDWTAX                         CSE023
398000200529     C                   PARM                    DDPRICN                                      CAS006
398100200529      * SCREEN A
398200200529      * Destination of Settlement
398300200529      * Destination of Confirmation
398400200529     C                   PARM                    A_DDROUS          6
398500200529     C                   PARM                    A_DDROTS         12
398600200529     C                   PARM                    A_DDROUC          6
398700200529     C                   PARM                    A_DDROTC         12
398800200529      * SCREEN B
398900200529      * Destination of Settlement
399000200529      * Destination of Confirmation
399100200529     C                   PARM                    B_DDROUS          6
399200200529     C                   PARM                    B_DDROTS         12
399300200529     C                   PARM                    B_DDROUC          6
399400200529     C                   PARM                    B_DDROTC         12
399500200529     C                   PARM                    DDFRNT                                    AR698195B
399600200529      *
399700200529      * Update 'Current' TRADE with TRADE in Screen Format
399800200529      *
399900200529     C                   MOVEL     NewTrPrim     CurTrPrim
400000200529     C                   MOVEL     NewTrSeco     CurTrSeco
400100200529     C                   MOVEL     NewTrThir     CurTrThir                                    CAS006
400200200529     C                   MOVEL     NewTrExch     CurTrExch
400300200529     C                   MOVEL     NewTrSett     CurTrSett
400400200529     C                   MOVEL     NewTrChcm     CurTrChcm
400500200529     C                   MOVEL     NewTrSwftA    CurTrSwftA
400600200529     C                   MOVEL     NewTrSwftB    CurTrSwftB
400700200529      *
400800200529     C                   ENDSR
400900200529      *****************************************************************
401000200529      /EJECT
401100200529      *****************************************************************
401200200529      * CANC@P - CANCEL ON PRIMARY DETAILS SCREEN
401300200529      *****************************************************************
401400200529     C     CANC@P        BEGSR
401500200529      *
401600200529      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
401700200529      *
401800200529     C     @RDNB         IFEQ      'Y'
401900200529     C                   MOVEL     'R'           @SCRN
402000200529     C                   ELSE
402100200529      *
402200200529      * ELSE, RETURN TO THE BROWSE SCREEN
402300200529      *
402400200529     C                   MOVEL     'I'           @SCRN
402500200529     C                   END
402600200529      *
402700200529     C                   ENDSR
402800200529      *****************************************************************
402900200529      /EJECT
403000200529      *****************************************************************
403100200529      * CANC@S - CANCEL ON SECONDARY SCREEN
403200200529      *****************************************************************
403300200529     C     CANC@S        BEGSR
403400200529      *
403500200529      * IF ACTION CODE IS INSERT, GO TO PRIMARY SCREEN
403600200529      *
403700200529     C     DDACTN        IFEQ      'I'
403800200529     C                   MOVEL     'P'           @SCRN
403900200529     C                   ELSE
404000200529      *
404100200529      * ELSE, RETURN TO THE BROWSE SCREEN
404200200529      *
404300200529     C                   MOVEL     'I'           @SCRN
404400200529     C                   END
404500200529      *
404600200529     C                   ENDSR
404700200529      *****************************************************************
404800200529      /EJECT
404900200529      *****************************************************************                       CAS006
405000200529      * CANC@T - CANCEL ON THIRD SCREEN                                                       CAS006
405100200529      *****************************************************************                       CAS006
405200200529                                                                                              CAS006
405300200529     C     CANC@T        BEGSR                                                                CAS006
405400200529                                                                                              CAS006
405500200529      ** Return to second screen                                                              CAS006
405600200529                                                                                              CAS006
405700200529     C                   MOVEL     'S'           @SCRN                                        CAS006
405800200529                                                                                              CAS006
405900200529     C                   ENDSR                                                                CAS006
406000200529                                                                                              CAS006
406100200529      *****************************************************************                       CAS006
406200200529      /EJECT                                                                                  CAS006
406300200529      *****************************************************************
406400200529      * CANC@O - CANCEL ON OTHER DETAILS SCREEN
406500200529      *****************************************************************
406600200529     C     CANC@O        BEGSR
406700200529      *
406800200529      * Return to Secondary Screen
406900200529      *
407000200529     C                   IF        CAS006 = 'Y'                                               CAS006
407100200529     C                   MOVEL     'H'           @SCRN                                        CAS006
407200200529     C                   ELSE                                                                 CAS006
407300200529     C                   MOVEL     'S'           @SCRN
407400200529     C                   ENDIF                                                                CAS006
407500200529      *
407600200529     C                   ENDSR
407700200529      *****************************************************************
407800200529      /EJECT
407900200529      *****************************************************************
408000200529      * CANC@E_A - CANCEL ON EXTENSION SCREEN A
408100200529      *****************************************************************
408200200529     C     CANC@E_A      BEGSR
408300200529      *
408400200529      * Return to Other Details Screen
408500200529      *
408600200529     C                   MOVEL     'O'           @SCRN
408700200529      *
408800200529     C                   ENDSR
408900200529      *****************************************************************
409000200529      /EJECT
409100200529      *****************************************************************
409200200529      * CANC@E_B - CANCEL ON EXTENSION SCREEN B
409300200529      *****************************************************************
409400200529     C     CANC@E_B      BEGSR
409500200529      *
409600200529      * Return to Extension Screen A
409700200529      *
409800200529     C                   MOVEL     'A'           @SCRN
409900200529      *
410000200529     C                   ENDSR
410100200529      *****************************************************************
410200200529      /EJECT                                                                    140951
410300200529      *****************************************************************         140951
410400200529      * ExtSettA - Return from Ext. Settlements Screen                          140951
410500200529      *****************************************************************         140951
410600200529     C     ExtSettA      BEGSR                                                  140951
410700200529      *                                                                         140951
410800200529      * Return to SWIFT Details Screen A                                        140951
410900200529      *                                                                         140951
411000200529     C                   MOVEL     'A'           @SCRN                          140951
411100200529      *                                                                         140951
411200200529     C                   ENDSR                                                  140951
411300200529      *****************************************************************         140951
411400200529      /EJECT                                                                    140951
411500200529      *****************************************************************         140951
411600200529      * ExtSettB - Return from Ext. Settlements Screen                          140951
411700200529      *****************************************************************         140951
411800200529     C     ExtSettB      BEGSR                                                  140951
411900200529      *                                                                         140951
412000200529      * Return to SWIFT Details Screen B                                        140951
412100200529      *                                                                         140951
412200200529     C                   MOVEL     'B'           @SCRN                          140951
412300200529      *                                                                         140951
412400200529     C                   ENDSR                                                  140951
412500200529      *****************************************************************         140951
412600200529      /EJECT
412700200529      *****************************************************************
412800200529      * UPDATS - UPDATES
412900200529      *****************************************************************
413000200529     C     UPDATS        BEGSR
413100200529      *
413200200529      * IF TRADE REFERENCE NOT DEFINED (ON INSERT),
413300200529      * GET NEXT AVAILABLE TRADE REFERENCE
413400200529      *
413500200529     C     DDTDRF        IFEQ      *BLANK
413600200529      *
413700200529     C                   CALLB     'ZATRNRTV'
413800200529     C                   PARM      *BLANKS       RetCodeOut
413900200529     C                   PARM      'SE'          MODU              2
414000200529     C                   PARM      'T'           TRTY              1
414100200529     C                   PARM                    DDTDRF
414200200529     C                   PARM      *ZERO         TDRF
414300200529      *
414400200529      * DATABASE ERROR
414500200529      *
414600200529     C     RetCodeOut    IFNE      *BLANK
414700200529     C                   MOVEL     'ZATRNRTV'    DBFILE
414800200529     C                   MOVEL     '100'         DBASE
414900200529     C                   MOVEL     DDTDRF        DBKEY
415000200529     C                   EXSR      *PSSR
415100200529     C                   END
415200200529
415300200529     C                   MOVEL     DDTDRF        @SITR
415400200529
415500200529     C                   END
415600200529      *
415700200529      * UPDATE VALID TRADE: TRADE REFERENCE
415800200529      *
415900200529     C                   MOVEL     DDTDRF        TDRF
416000200529      *
416100200529      * UPDATE VALID TRADE: CHANGE TYPE
416200200529      *
416300200529     C                   MOVEL     DDACTN        CHTP
416400200529      *
416500200529      * UPDATE VALID DEAL: FRONT OFFICE TRANSACTION ID
416600200529      *
416700200529     C                   MOVEL     @FOTRANSEL    FRNT
416800200529     C                   MOVEL     @FOTRANSEL    A_T1FRNT                       CAP013
416900200529     C                   MOVEL     @FOTRANSEL    B_T1FRNT                       CAP013
417000200529      *
417100200529      ** Write directly to the extension file.  The information held on                       CSE039
417200200529      *  the extension file is only used to update the Movement Status                        CSE039
417300200529      *  file and therefore it is not necessary to update data structure                      CSE039
417400200529     C     CSE039        IFEQ      'Y'                                                        CSE039
417500200529     C                   EVAL      T3TDRF = DDTDRF                                            CSE039
417600200529     C                   EVAL      T3INOR = DDINOR                                            CSE039
417700200529     C                   EVAL      T3MSGK = DDMSGK                                            CSE039
417800200529     C                   EVAL      T3NTMT = DDNTMT                                            CSE039
417900200529     C                   EVAL      T3FRNT = FRNT                                              CSE039
418000200529     C                   EVAL      T3AFRT = AFRT                                              CSE039
418100200529     C                   EVAL      T3TMST = TMST                                              CSE039
418200200529     C                   WRITE     TRADSDD3                                                   CSE039
418300200529     C                   ENDIF                                                                CSE039
418400200529     C                   IF        CSE045 = 'Y'                                               CSE045
418500200529     C                   MOVEL     @FOTRANSEL    A_T2FRNT                                     CSE045
418600200529     C                   MOVEL     @FOTRANSEL    B_T2FRNT                                     CSE045
418700200529     C                   ENDIF                                                                CSE045
418800200529      *
418900200529      * TRADES UPDATES
419000200529      *
419100200529     C                   CALLB     'SETRADUPD'
419200200529     C                   PARM      *BLANKS       @RTCD
419300200529     C                   PARM                    NwTrFilFmt
419400200529     C                   PARM                    NT1AFilFmt
419500200529     C                   PARM                    NT1BFilFmt
419600200529     C                   PARM                    S01401
419700200529     C                   PARM                    CSW003                         154562
419800200529     C                   PARM                    CAP051                         CAP051
419900200529     C                   PARM                    CAS006                                       CAS006
420000200529      * CGL031 Switchable Feature                                                             CGL031
420100200529     C                   PARM                    CGL031                                       CGL031
420200200529     C                   PARM      'RPR'         PMODE                                        210517
420300200529      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
420400200529      **  Watch Enhancement.                                                                  CSD015
420500200529     C                   PARM                    PMCWL                                        CSD015
420600200529     C                   PARM                    NT2AFilFmt                                   CSE045
420700200529     C                   PARM                    NT2BFilFmt                                   CSE045
420800200529     C                   IF        @RTCD   = *BLANKS AND ULX603 = 'Y'                         CER001
420900200529     C                   EVAL      #6LXCCTDRF = DDTDRF                                        CER001
421000200529     C                   CALLB     'SETRAD2UP'                                                CER001
421100200529     C                   PARM                    DDACTN                                       CER001
421200200529     C                   PARM      *BLANK        @RTCD                                        CER001
421300200529     C                   PARM      'Y'           WFIND                                        CER001
421400200529     C                   PARM                    NwDlFilFmt                                   CER001
421500200529     C                   PARM                    CrDlFilFmt                                   CER001
421600200529     C                   ENDIF                                                                CER001
421700200529      *
421800200529      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
421900200529      * UPDATES AND END THIS PROGRAM.
422000200529      * OTHERWISE DELETE THE INVALID TRADE ACTIONED & COMMIT THE UPDATES
422100200529      *
422200200529     C     @RTCD         IFNE      *BLANK
422300200529     C*****@RTCD         ANDNE     '*RECUPD'                             CAP006 168345
422400200529     C                   If        (CSC022 <> 'Y')                                            CSC022
422500200529     C                   ROLBK
422600200529     C                   Else                                                                 CSC022
422700200529     C                   If        (WCommitSkip <> 'Y')                                       CSC022
422800200529     C                   ROLBK                                                                CSC022
422900200529     C                   Else                                                                 CSC022
423000200529     C                   Seton                                        U7U8                    CSC022
423100200529     C                   EndIf                                                                CSC022
423200200529     C                   EndIf                                                                CSC022
423300200529     C     @RTCD         IFNE      '*RECUPD'                                    168345
423400200529     C                   EXSR      *PSSR
423500200529     C                   ENDIF                                                  168345
423600200529     C                                                                          CAP006
423700200529     C                   ELSE
423800200529     C     ZATRNKD0      CHAIN     SEITRADD0                          99
423900200529     C  N99              DELETE    SEITRADD0
424000200529     C                   IF        ULX603  = 'Y'                                              CER001
424100200529     C     K@KEY1        CHAIN     RTVIDX1                            99                      CER001
424200200529     C                   IF        %FOUND                                                     CER001
424300200529     C                   DELETE    RTVIDX1                                                    CER001
424400200529     C                   ENDIF                                                                CER001
424500200529     C                   ENDIF                                                                CER001
424600200529                                                                                              CSC011
424700200529      ** Delete invalid record from the log file.                                             CSC011
424800200529                                                                                              CSC011
424900200529     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
425000200529                                                                                              CSC011
425100200529     C                   EVAL      KMsgType = 'SETRAD'                                        CSC011
425200200529     C                   EVAL      KFrntOffID = @FOTRANSEL                                    CSC011
425300200529     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
425400200529                                                                                              CSC011
425500200529     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
425600200529     C                   IF        *IN99 = *OFF                                               CSC011
425700200529     C                   DELETE    APILOGD0                                                   CSC011
425800200529     C                   ENDIF                                                                CSC011
425900200529     C                   ENDIF                                                                CSC011
426000200529                                                                                              CSC011
426100200529     C/COPY WNCPYSRC,SETRADRC09
426200200529      *                                                                                       CSC011
426300200529     C                   If        (CSC022 <> 'Y')                                            CSC022
426400200529     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
426500200529     C                   COMMIT
426600200529     C                   EndIf                                                                CSC022
426700200529     C                   END
426800200529      *
426900200529      * If error occurred in updating last transaction set on flag to           CAP006
427000200529      * display message on 'browse' screen.                                     CAP006
427100200529     C     @RTCD         IFEQ      '*RECUPD'                                    CAP006
427200200529     C                   MOVE      'Y'           @ERRUP                         CAP006
427300200529     C                   ELSE                                                   CAP006
427400200529     C                   MOVE      'N'           @ERRUP                         CAP006
427500200529     C                   END                                                    CAP006
427600200529     C                                                                          CAP006
427700200529      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
427800200529      *
427900200529     C     @RDNB         IFEQ      'Y'
428000200529     C                   MOVEL     'R'           @SCRN
428100200529     C                   ELSE
428200200529      *
428300200529      * ELSE, RETURN TO THE BROWSE SCREEN
428400200529      *
428500200529     C                   MOVEL     'I'           @SCRN
428600200529     C                   END
428700200529      *
428800200529     C                   ENDSR
428900200529      *****************************************************************
429000200529      /EJECT
429100200529      *****************************************************************
429200200529      * ENDP - End Program
429300200529      *****************************************************************
429400200529     C     ENDP          BEGSR
429500200529      *
429600200529     C                   MOVEL     'T'           @SCRN
429700200529      *
429800200529     C                   ENDSR
429900200529      *****************************************************************
430000200529      /EJECT
430100200529      *****************************************************************
430200200529      * INITIAL Go To Initial Screen
430300200529      *****************************************************************
430400200529     C     INITIAL       BEGSR
430500200529      *
430600200529      * IF ACTION CODE IS INSERT, GO TO PRIMARY SCREEN
430700200529      *
430800200529     C     DDACTN        IFEQ      'I'
430900200529     C                   MOVEL     'P'           @SCRN
431000200529     C                   ELSE
431100200529      *
431200200529      * ELSE, GO TO SECONDARY SCREEN
431300200529      *
431400200529     C                   MOVEL     'S'           @SCRN
431500200529     C                   END
431600200529      *
431700200529     C                   ENDSR
431800200529      *****************************************************************
431900200529      /EJECT
432000200529      *****************************************************************
432100200529      * INTRCAL - FORCE INTEREST RECALCULATION
432200200529      *****************************************************************
432300200529     C     INTRCAL       BEGSR
432400200529      *
432500200529      * If any of the following have changed, cause interest recalculation
432600200529      * (by blanking out interest amount) - but only if interest hasn't
432700200529      * been changed: nominal, value date, accrued indicator, days
432800200529      * adjustment, and actual/difference ind.
432900200529      *
433000200529     C     DDNOML        IFNE      @PDDNOML
433100200529     C     DDTDVD        ORNE      @PDDTDVD
433200200529     C     DDACIN        ORNE      @PDDACIN
433300200529     C     DDDADJ        ORNE      @PDDDADJ
433400200529     C     DDACTD        ORNE      @PDDACTD
433500200529     C     DDITRA        IFEQ      @PDDITRA
433600200529     C                   MOVEL     *BLANK        DDITRA
433700200529     C                   END
433800200529     C                   END
433900200529
434000200529     C                   ENDSR
434100200529      *****************************************************************
434200200529      /EJECT
434300200529      *****************************************************************
434400200529      * PRCRCAL - FORCE (%) PRICE RECALCULATION
434500200529      *****************************************************************
434600200529     C     PRCRCAL       BEGSR
434700200529      *
434800200529      * If any of the following have changed, cause price recalculation
434900200529      * (by blanking out % price) - but only if price hasn't been
435000200529      * changed: nominal, price/discount/yield, value date,
435100200529      * accrued indicator, and interest
435200200529      *
435300200529     C     DDNOML        IFNE      @PDDNOML
435400200529     C     DDTPDY        ORNE      @PDDTPDY
435500200529     C     DDTDVD        ORNE      @PDDTDVD
435600200529     C     DDACIN        ORNE      @PDDACIN
435700200529     C     DDITRA        ORNE      @PDDITRA
435800200529     C     DDPRIC        IFEQ      @PDDPRIC
435900200529     C                   MOVEL     *BLANK        DDPRIC
436000200529     C                   END
436100200529     C                   END
436200200529
436300200529     C                   ENDSR
436400200529      *****************************************************************
436500200529      /EJECT
436600200529      *****************************************************************
436700200529      * CHCMCAL - CHARGES AND COMMISSIONS CALCULATION
436800200529      *****************************************************************
436900200529     C     CHCMCAL       BEGSR
437000200529
437100200529     C/COPY WNCPYSRC,SETRADRC01
437200200529     C                   CALLB     'SETCHCMCAL'
437300200529
437400200529      * INPUTS
437500200529
437600200529      ** Trade reference
437700200529      ** Security
437800200529      ** Trade Type
437900200529     C                   PARM                    DDTDRF            6
438000200529     C                   PARM                    DDSESN           10
438100200529     C                   PARM                    DDTDTP            2
438200200529      *
438300200529      ** Trade Counterparty
438400200529      ** Trade Nominal
438500200529      ** Trade % price
438600200529      ** Trade Date
438700200529      ** Trade Purchased Interest
438800200529      ** Trade Current Factor
438900200529     C                   PARM                    TCNR
439000200529     C                   PARM                    NOML             11 0
439100200529     C                   PARM                    PRIC             15 8
439200200529     C                   PARM                    TDDT              5 0
439300200529     C                   PARM                    ITRA             13 0
439400200529     C                   PARM                    TCFC             10 9
439500200529      *
439600200529      ** Security & Investment Type details
439700200529     C*******************PARM                    SECTY                                        206651
439800200529     C                   PARM                    SECTY2                                       206651
439900200529     C                   PARM                    PROT              1
440000200529      *
440100200529      ** Nominal Currency Details
440200200529     C                   PARM                    NomCcyDts
440300200529      *
440400200529      ** Customer (Counterparty) Details
440500200529     C                   PARM                    CustDts
440600200529      *
440700200529      ** Commission Rebate %
440800200529     C                   PARM                    CMRP              5 3
440900200529      *
441000200529      ** Previous Trade Charges & Commissions
441100200529     C                   PARM                    PrvTrChCm
441200200529      *
441300200529      ** Trade Charges & Commissions OK inds
441400200529     C                   PARM                    OKTrChCm
441500200529      *
441600200529      ** ICD
441700200529      ** Autocharge Option
441800200529      ** Securities Charges Currency
441900200529      ** Adjust Commission Same Day T
442000200529     C                   PARM                    BVACOP            1
442100200529     C                   PARM                    BVCHRC            3
442200200529     C                   PARM                    BVACSD            1
442300200529     C                   PARM                    S01446            1
442400200529
442500200529      * INPUTS & OUTPUTS
442600200529
442700200529      ** Trade Charges & commissions screen fields
442800200529
442900200529     C                   PARM                    NewTrChCm
443000200529
443100200529      ** Trade details
443200200529     C                   PARM                    TBCA             13 0
443300200529     C                   PARM                    TCCA             13 0
443400200529     C                   PARM                    TCA1             13 0
443500200529     C                   PARM                    TCA2             13 0
443600200529     C                   PARM                    TCA3             13 0
443700200529     C                   PARM                    TCA4             13 0
443800200529     C                   PARM                    TCA5             13 0
443900200529     C                   PARM                    TCA6             13 0
444000200529     C                   PARM                    TCA7             13 0
444100200529     C                   PARM                    TAXA             13 0
444200200529     C                   PARM                    BCMR             13 0
444300200529     C                   PARM                    CCMR             13 0
444400200529     C                   PARM                    TXRB             13 0
444500200529
444600200529     C                   ENDSR
444700200529      *****************************************************************                       233881
444800200529      * EUTXCAL - EU TAX CALCULATION                                                          233881
444900200529      *****************************************************************                       233881
445000200529     C     EUTXCAL       BEGSR                                                                233881
445100200529                                                                                              233881
445200200529      ** CALCULATE EU TAX                                                                     233881
445300200529                                                                                              233881
445400200529     C                   CALLB     'SEVTRADTAX'                                               233881
445500200529                                                                                              233881
445600200529      * INPUTS                                                                                233881
445700200529                                                                                              233881
445800200529      * Response Mode                                                                         233881
445900200529     C                   PARM                    RespMode                                     233881
446000200529      * Valid Trade Details                                                                   233881
446100200529     C                   PARM                    NwTrFilFmt                                   233881
446200200529      * Security Details                                                                      233881
446300200529     C                   PARM                    SECTY2                                       233881
446400200529      * Process Flag                                                                          233881
446500200529     C                   PARM      'E'           ProcFlag          1                          233881
446600200529                                                                                              233881
446700200529      * OUTPUTS                                                                               233881
446800200529                                                                                              233881
446900200529      * EU Tax Screen Format                                                                  233881
447000200529      * EU Tax in Nominal Currency File Format                                                233881
447100200529      * EU Tax in Settlement Currency File Format                                             233881
447200200529     C                   PARM                    DDEUTX                                       233881
447300200529     C                   PARM                    EUTX                                         233881
447400200529     C                   PARM                    EUTS                                         233881
447500200529                                                                                              233881
447600200529     C                   ENDSR                                                                233881
447700200529      *****************************************************************
447800200529      /EJECT
447900200529      *****************************************************************
448000200529      * CVALCAL - COUNTERVALUE CALCULATION
448100200529      *****************************************************************
448200200529     C     CVALCAL       BEGSR
448300200529     C/COPY WNCPYSRC,SETRADRC08
448400200529
448500200529      ** CALCULATE COUNTERVALUE
448600200529
448700200529     C                   CALLB     'SETCVALCAL'
448800200529
448900200529      * INPUTS
449000200529
449100200529      ** Trade details
449200200529     C                   PARM                    TDTP              2
449300200529     C                   PARM                    NOML             11 0
449400200529     C                   PARM                    PRIC             15 8
449500200529     C                   PARM                    RALL              9 5
449600200529     C                   PARM                    ITRA             13 0
449700200529     C                   PARM                    TBCA             13 0
449800200529     C                   PARM                    TCCA             13 0
449900200529     C                   PARM                    TCA1             13 0
450000200529     C                   PARM                    TCA2             13 0
450100200529     C                   PARM                    TCA3             13 0
450200200529     C                   PARM                    TCA4             13 0
450300200529     C                   PARM                    TCA5             13 0
450400200529     C                   PARM                    TCA6             13 0
450500200529     C                   PARM                    TCA7             13 0
450600200529     C                   PARM                    TAXA             13 0
450700200529     C                   PARM                    TDER             13 8
450800200529     C                   PARM                    TMDI              1
450900200529     C                   PARM                    SETC              3
451000200529     C                   PARM                    TDVD              5 0                        200459
451100200529
451200200529      ** Security details
451300200529     C                   PARM                    PROT              1
451400200529     C                   PARM                    SPBS              1
451500200529     C                   PARM                    CFCT             10 9
451600200529     C                   PARM                    NMCY              3
451700200529     C                   PARM                    NMDP              1 0
451800200529     C                   PARM                    SESN             10                          200459
451900200529
452000200529      ** Nominal Currency Details
452100200529      ** Settlement Currency Details
452200200529     C                   PARM                    NomCcyDts
452300200529     C                   PARM                    SetCcyDts
452400200529
452500200529      ** Customer classification
452600200529     C                   PARM                    CustClass         1
452700200529                                                                                CSE023
452800200529      ** Country of treaty from PF/SECTYD                                       CSE023
452900200529     C                   PARM                    CRTT                           CSE023
453000200529                                                                                CSE023
453100200529      ** Default basket for backup withholding                                  CSE023
453200200529     C                   PARM                    PDRBW                          CSE023
453300200529                                                                                CSE023
453400200529      ** Value date                                                             CSE023
453500200529     C                   PARM                    TDVD                           CSE023
453600200529                                                                                              233881
453700200529      ** EU Tax                                                                               233881
453800200529     C                   PARM                    EUTX                                         233881
453900200529
454000200529      * OUTPUTS
454100200529
454200200529      * Trade consideration in nominal currency
454300200529      * Trade countervalue in nominal currency
454400200529      * Withholding tax                                                         CSE023
454500200529      * Trade countervalue in settlement currency in screen format
454600200529      * Withholding tax in screen format                                        CSE023
454700200529     C                   PARM                    TCSR             15 0
454800200529     C                   PARM                    TCTR             15 0
454900200529     C                   PARM                    WHTX                           CSE023
455000200529     C                   PARM                    DDTCTR           21
455100200529     C                   PARM                    DDWTAX                         CSE023
455200200529
455300200529     C                   ENDSR
455400200529      *****************************************************************
455500200529      /EJECT                                                                    CAP011
455600200529      *****************************************************************         CAP011
455700200529      *                                                               *         CAP011
455800200529      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
455900200529      *                                                               *         CAP011
456000200529      *****************************************************************         CAP011
456100200529                                                                                CAP011
456200200529     C     TDtDtaSubs    BEGSR                                                  CAP011
456300200529                                                                                CAP011
456400200529     C                   RESET                   ReturnCode                     CAP011
456500200529
456600200529      * TRADE PRIMARY DETAILS
456700200529     C                   CALLB     'APDTASUBS'                                  CAP011
456800200529                                                                                CAP011
456900200529      * Return Code                                                             CAP011
457000200529     C                   PARM                    ReturnCode       10            CAP011
457100200529      * Substitution character                                                  CAP011
457200200529     C                   PARM      GHSUBS        SubsChar          1            CAP011
457300200529      * Incoming Data                                                           CAP011
457400200529     C                   PARM      NewTrPrim     IncDATA        2000            CAP011
457500200529      * Current Data                                                            CAP011
457600200529     C                   PARM      CurTrPrim     CurDATA        2000            CAP011
457700200529                                                                                CAP011
457800200529     C                   MOVEL     IncDATA       NewTrPrim                      CAP011
457900200529
458000200529      * TRADE SECONDARY DETAILS
458100200529     C                   CALLB     'APDTASUBS'                                  CAP011
458200200529                                                                                CAP011
458300200529      * Return Code                                                             CAP011
458400200529     C                   PARM                    ReturnCode       10            CAP011
458500200529      * Substitution character                                                  CAP011
458600200529     C                   PARM      GHSUBS        SubsChar          1            CAP011
458700200529      * Incoming Data                                                           CAP011
458800200529     C                   PARM      NewTrSeco     IncDATA        2000            CAP011
458900200529      * Current Data                                                            CAP011
459000200529     C                   PARM      CurTrSeco     CurDATA        2000            CAP011
459100200529                                                                                CAP011
459200200529     C                   MOVEL     IncDATA       NewTrSeco                      CAP011
459300200529
459400200529      * TRADE EXCHANGE RATES
459500200529     C                   CALLB     'APDTASUBS'                                  CAP011
459600200529                                                                                CAP011
459700200529      * Return Code                                                             CAP011
459800200529     C                   PARM                    ReturnCode       10            CAP011
459900200529      * Substitution character                                                  CAP011
460000200529     C                   PARM      GHSUBS        SubsChar          1            CAP011
460100200529      * Incoming Data                                                           CAP011
460200200529     C                   PARM      NewTrExch     IncDATA        2000            CAP011
460300200529      * Current Data                                                            CAP011
460400200529     C                   PARM      CurTrExch     CurDATA        2000            CAP011
460500200529                                                                                CAP011
460600200529     C                   MOVEL     IncDATA       NewTrExch                      CAP011
460700200529
460800200529      * TRADE SETTLEMENT DETAILS
460900200529     C                   CALLB     'APDTASUBS'                                  CAP011
461000200529                                                                                CAP011
461100200529      * Return Code                                                             CAP011
461200200529     C                   PARM                    ReturnCode       10            CAP011
461300200529      * Substitution character                                                  CAP011
461400200529     C                   PARM      GHSUBS        SubsChar          1            CAP011
461500200529      * Incoming Data                                                           CAP011
461600200529     C                   PARM      NewTrSett     IncDATA        2000            CAP011
461700200529      * Current Data                                                            CAP011
461800200529     C                   PARM      CurTrSett     CurDATA        2000            CAP011
461900200529                                                                                CAP011
462000200529     C                   MOVEL     IncDATA       NewTrSett                      CAP011
462100200529
462200200529      * TRADE CHARGE/COMMISSIONS
462300200529     C                   CALLB     'APDTASUBS'                                  CAP011
462400200529                                                                                CAP011
462500200529      * Return Code                                                             CAP011
462600200529     C                   PARM                    ReturnCode       10            CAP011
462700200529      * Substitution character                                                  CAP011
462800200529     C                   PARM      GHSUBS        SubsChar          1            CAP011
462900200529      * Incoming Data                                                           CAP011
463000200529     C                   PARM      NewTrChCm     IncDATA        2000            CAP011
463100200529      * Current Data                                                            CAP011
463200200529     C                   PARM      CurTrChCm     CurDATA        2000            CAP011
463300200529                                                                                CAP011
463400200529     C                   MOVEL     IncDATA       NewTrChCm                      CAP011
463500200529
463600200529      * TRADE SWIFT A DETAILS
463700200529     C                   CALLB     'APDTASUBS'                                  CAP011
463800200529                                                                                CAP011
463900200529      * Return Code                                                             CAP011
464000200529     C                   PARM                    ReturnCode       10            CAP011
464100200529      * Substitution character                                                  CAP011
464200200529     C                   PARM      GHSUBS        SubsChar          1            CAP011
464300200529      * Incoming Data                                                           CAP011
464400200529     C                   PARM      NewTrSwftA    IncDATA        2000            CAP011
464500200529      * Current Data                                                            CAP011
464600200529     C                   PARM      CurTrSwftA    CurDATA        2000            CAP011
464700200529                                                                                CAP011
464800200529     C                   MOVEL     IncDATA       NewTrSwftA                     CAP011
464900200529
465000200529      * TRADE SWIFT B DETAILS
465100200529     C                   CALLB     'APDTASUBS'                                  CAP011
465200200529                                                                                CAP011
465300200529      * Return Code                                                             CAP011
465400200529     C                   PARM                    ReturnCode       10            CAP011
465500200529      * Substitution character                                                  CAP011
465600200529     C                   PARM      GHSUBS        SubsChar          1            CAP011
465700200529      * Incoming Data                                                           CAP011
465800200529     C                   PARM      NewTrSwftB    IncDATA        2000            CAP011
465900200529      * Current Data                                                            CAP011
466000200529     C                   PARM      CurTrSwftB    CurDATA        2000            CAP011
466100200529                                                                                CAP011
466200200529     C                   MOVEL     IncDATA       NewTrSwftB                     CAP011
466300200529                                                                                CAP011
466400200529     C                   ENDSR                                                  CAP011
466500200529      *****************************************************************         CAP011
466600200529      /EJECT
466700200529      *****************************************************************
466800200529      * *INZSR - INITIAL PROCESSING
466900200529      *****************************************************************
467000200529     C     *INZSR        BEGSR
467100200529      *
467200200529      ** Initialize program name
467300200529      *
467400200529     C                   MOVEL     'SETRADRPR'   DBPGM
467500200529      *                                                                                       248683
467600200529      ** Initialize Data Area for SE1806 Flag                                                 248683
467700200529      *                                                                                       248683
467800200529     C                   CALL      'SECDTARA'                                                 248683
467900200529     C                   PARM      'SETRADRPR'   PGMNAM           10                          248683
468000200529     C                   PARM      *BLANKS       WRTFLG            1                          248683
468100200529      *
468200200529      ** ACCESS BANK DETAILS
468300200529      *
468400200529     C                   CALL      'AOBANKR0'
468500200529     C                   PARM      *BLANKS       @RTCD             7
468600200529     C                   PARM      '*FIRST '     @OPTN             7
468700200529     C     SDBANK        PARM      SDBANK        DSFDY
468800200529      *
468900200529      * DATABASE ERROR
469000200529      *
469100200529     C     @RTCD         IFNE      *BLANKS
469200200529     C                   MOVEL     'SDBANKPD'    DBFILE
469300200529     C                   MOVEL     '901'         DBASE
469400200529     C                   MOVEL     @OPTN         DBKEY
469500200529     C                   EXSR      *PSSR
469600200529     C                   END
469700200529      *
469800200529      ** ACCESS GENERAL LEDGER DETAILS
469900200529      *
470000200529     C**********         CALL      'AOGELRR0'                                                 CGL029
470100200529     C                   CALL      'AOGELRR1'                                                 CGL029
470200200529     C                   PARM      *BLANKS       @RTCD             7
470300200529     C                   PARM      '*FIRST '     @OPTN             7
470400200529     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
470500200529     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
470600200529      *
470700200529      * DATABASE ERROR
470800200529      *
470900200529     C     @RTCD         IFNE      *BLANKS
471000200529     C                   MOVEL     'SDGELRPD'    DBFILE
471100200529     C                   MOVEL     '902'         DBASE
471200200529     C                   MOVEL     @OPTN         DBKEY
471300200529     C                   EXSR      *PSSR
471400200529     C                   END
471500200529      *
471600200529      ** ACCESS SECURITIES TRADING DETAILS
471700200529      *
471800200529     C                   CALL      'AOSTRDR0'
471900200529     C                   PARM      *BLANKS       @RTCD             7
472000200529     C                   PARM      '*FIRST  '    @OPTN             7
472100200529     C     SDSTRD        PARM      SDSTRD        DSSDY
472200200529      *
472300200529      * DATABASE ERROR
472400200529      *
472500200529     C     @RTCD         IFNE      *BLANK
472600200529     C                   MOVEL     @OPTN         DBKEY
472700200529     C                   MOVEL     'SDSTRDPD'    DBFILE
472800200529     C                   MOVEL     '903'         DBASE
472900200529     C                   EXSR      *PSSR
473000200529     C                   END
473100200529      *
473200200529      ** Access Module Details
473300200529      *
473400200529     C                   CALL      'AOMMODR0'
473500200529     C                   PARM      *BLANKS       @RTCD
473600200529     C                   PARM      '*FIRST '     @OPTN
473700200529     C     SDMMOD        PARM      SDMMOD        DSFDY
473800200529      *
473900200529      * DATABASE ERROR
474000200529      *
474100200529     C     @RTCD         IFNE      *BLANKS
474200200529     C                   MOVEL     'SDMMODPD'    DBFILE
474300200529     C                   MOVEL     '904'         DBASE
474400200529     C                   MOVEL     @OPTN         DBKEY
474500200529     C                   EXSR      *PSSR
474600200529     C                   END
474700200529      *
474800200529      ** Access SAR details file to determine if S01401
474900200529      ** (MT5XX Message Generation) is on.
475000200529      *
475100200529     C                   CALLB     'AOSARDR0'
475200200529     C                   PARM      *BLANKS       @RTCD
475300200529     C                   PARM      '*VERIFY'     @OPTN
475400200529     C                   PARM      'S01401'      @SARD             6
475500200529     C     SCSARD        PARM      SCSARD        DSFDY
475600200529      *
475700200529      * DATABASE ERROR
475800200529      *
475900200529     C     @RTCD         IFNE      *BLANKS
476000200529     C     @RTCD         ANDNE     '*NRF   '
476100200529     C                   MOVEL     'SCSARDPD'    DBFILE
476200200529     C                   MOVEL     '905'         DBASE
476300200529     C                   MOVEL     'S01401'      DBKEY
476400200529     C                   EXSR      *PSSR
476500200529     C                   END
476600200529      *
476700200529     C     @RTCD         IFEQ      *BLANK
476800200529     C                   MOVEL     'Y'           S01401            1
476900200529     C                   ELSE
477000200529     C                   MOVEL     'N'           S01401
477100200529     C                   END
477200200529      *
477300200529      ** Access SAR details file to determine if S01446
477400200529      ** (Customer commission switchable feature) is on.
477500200529      *
477600200529     C                   CALLB     'AOSARDR0'
477700200529     C                   PARM      *BLANKS       @RTCD
477800200529     C                   PARM      '*VERIFY'     @OPTN
477900200529     C                   PARM      'S01446'      @SARD             6
478000200529     C     SCSARD        PARM      SCSARD        DSFDY
478100200529      *
478200200529      * DATABASE ERROR
478300200529      *
478400200529     C     @RTCD         IFNE      *BLANKS
478500200529     C     @RTCD         ANDNE     '*NRF   '
478600200529     C                   MOVEL     'SCSARDPD'    DBFILE
478700200529     C                   MOVEL     '906'         DBASE
478800200529     C                   MOVEL     'S01446'      DBKEY
478900200529     C                   EXSR      *PSSR
479000200529     C                   END
479100200529      *
479200200529     C     @RTCD         IFEQ      *BLANK
479300200529     C                   MOVEL     'Y'           S01446            1
479400200529     C                   ELSE
479500200529     C                   MOVEL     'N'           S01446
479600200529     C                   END
479700200529      *
479800200529      ** Access SAR details file to determine if S01496
479900200529      ** (Private Banking SE enhancements) is on.
480000200529      *
480100200529     C                   CALLB     'AOSARDR0'
480200200529     C                   PARM      *BLANKS       @RTCD
480300200529     C                   PARM      '*VERIFY'     @OPTN
480400200529     C                   PARM      'S01496'      @SARD             6
480500200529     C     SCSARD        PARM      SCSARD        DSFDY
480600200529      *
480700200529      * DATABASE ERROR
480800200529      *
480900200529     C     @RTCD         IFNE      *BLANKS
481000200529     C     @RTCD         ANDNE     '*NRF   '
481100200529     C                   MOVEL     'SCSARDPD'    DBFILE
481200200529     C                   MOVEL     '907'         DBASE
481300200529     C                   MOVEL     'S01496'      DBKEY
481400200529     C                   EXSR      *PSSR
481500200529     C                   END
481600200529      *
481700200529     C     @RTCD         IFEQ      *BLANK
481800200529     C                   MOVEL     'Y'           S01496            1
481900200529     C                   ELSE
482000200529     C                   MOVEL     'N'           S01496
482100200529     C                   END
482200200529      *
482300200529      ** Access SAR details file to determine if CSW003
482400200529      ** (MT5XX - Phase 2 message generation) is on.
482500200529      *
482600200529     C                   CALLB     'AOSARDR0'
482700200529     C                   PARM      *BLANKS       @RTCD
482800200529     C                   PARM      '*VERIFY'     @OPTN
482900200529     C                   PARM      'CSW003'      @SARD             6
483000200529     C     SCSARD        PARM      SCSARD        DSFDY
483100200529      *
483200200529      * DATABASE ERROR
483300200529      *
483400200529     C     @RTCD         IFNE      *BLANKS
483500200529     C     @RTCD         ANDNE     '*NRF   '
483600200529     C                   MOVEL     'SCSARDPD'    DBFILE
483700200529     C                   MOVEL     '908'         DBASE
483800200529     C                   MOVEL     'CSW003'      DBKEY
483900200529     C                   EXSR      *PSSR
484000200529     C                   END
484100200529      *
484200200529     C     @RTCD         IFEQ      *BLANK
484300200529     C                   MOVEL     'Y'           CSW003            1
484400200529     C                   ELSE
484500200529     C                   MOVEL     'N'           CSW003
484600200529     C                   END
484700200529      *                                                                         CAP050
484800200529      ** Access SAR details file to determine if CAP050                         CAP050
484900200529      ** (Midas/ToF Interface) is on.                                           CAP050
485000200529      *                                                                         CAP050
485100200529     C                   CALLB     'AOSARDR0'                                   CAP050
485200200529     C                   PARM      *BLANKS       @RTCD                          CAP050
485300200529     C                   PARM      '*VERIFY'     @OPTN                          CAP050
485400200529     C                   PARM      'CAP050'      @SARD                          CAP050
485500200529     C     SCSARD        PARM      SCSARD        DSFDY                          CAP050
485600200529      *                                                                         CAP050
485700200529      * Database Error                                                          CAP050
485800200529      *                                                                         CAP050
485900200529     C     @RTCD         IFNE      *BLANKS                                      CAP050
486000200529     C     @RTCD         ANDNE     '*NRF   '                                    CAP050
486100200529     C                   MOVEL     'SCSARDPD'    DBFILE                         CAP050
486200200529     C                   MOVEL     '909'         DBASE                          CAP050
486300200529     C                   MOVEL     'CAP050'      DBKEY                          CAP050
486400200529     C                   EXSR      *PSSR                                        CAP050
486500200529     C                   END                                                    CAP050
486600200529      *                                                                         CAP050
486700200529     C     @RTCD         IFEQ      *BLANK                                       CAP050
486800200529     C                   MOVEL     'Y'           CAP050            1            CAP050
486900200529     C                   ELSE                                                   CAP050
487000200529     C                   MOVEL     'N'           CAP050                         CAP050
487100200529     C                   END                                                    CAP050
487200200529      *                                                                         CAP051
487300200529      ** Access SAR details file to determine if CAP051 is on.                  CAP051
487400200529      ** (Automatic Authorisation (SE Trades Part))                             CAP051
487500200529      *                                                                         CAP051
487600200529     C                   CALLB     'AOSARDR0'                                   CAP051
487700200529     C                   PARM      *BLANKS       @RTCD                          CAP051
487800200529     C                   PARM      '*VERIFY'     @OPTN                          CAP051
487900200529     C                   PARM      'CAP051'      @SARD                          CAP051
488000200529     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
488100200529      *                                                                         CAP051
488200200529      * Database Error                                                          CAP051
488300200529      *                                                                         CAP051
488400200529     C     @RTCD         IFNE      *BLANKS                                      CAP051
488500200529     C     @RTCD         ANDNE     '*NRF   '                                    CAP051
488600200529     C                   MOVEL     'SCSARDPD'    DBFILE                         CAP051
488700200529     C                   MOVEL     '909'         DBASE                          CAP051
488800200529     C                   MOVEL     'CAP051'      DBKEY                          CAP051
488900200529     C                   EXSR      *PSSR                                        CAP051
489000200529     C                   END                                                    CAP051
489100200529      *                                                                         CAP051
489200200529     C     @RTCD         IFEQ      *BLANK                                       CAP051
489300200529     C                   MOVEL     'Y'           CAP051            1            CAP051
489400200529     C                   ELSE                                                   CAP051
489500200529     C                   MOVEL     'N'           CAP051                         CAP051
489600200529     C                   END                                                    CAP051
489700200529      *
489800200529      ** Access SAR details file to determine if CEU005
489900200529      ** (EMU SE Settlement Currency Conversion) is on.
490000200529      *
490100200529     C                   CALLB     'AOSARDR0'
490200200529     C                   PARM      *BLANKS       @RTCD
490300200529     C                   PARM      '*VERIFY'     @OPTN
490400200529     C                   PARM      'CEU005'      @SARD
490500200529     C     SCSARD        PARM      SCSARD        DSFDY
490600200529      *
490700200529      * Database Error
490800200529      *
490900200529     C     @RTCD         IFNE      *BLANKS
491000200529     C     @RTCD         ANDNE     '*NRF   '
491100200529     C                   MOVEL     'SCSARDPD'    DBFILE
491200200529     C                   MOVEL     '910'         DBASE
491300200529     C                   MOVEL     'CEU005'      DBKEY
491400200529     C                   EXSR      *PSSR
491500200529     C                   END
491600200529      *
491700200529     C     @RTCD         IFEQ      *BLANK
491800200529     C                   MOVEL     'Y'           CEU005            1
491900200529     C                   ELSE
492000200529     C                   MOVEL     'N'           CEU005
492100200529     C                   END
492200200529                                                                                              CSW201
492300200529      ** Check if CSW201 - Swift 2001 Standards Update is installed                           CSW201
492400200529                                                                                              CSW201
492500200529     C                   CALL      'SWIF2001'                           9090                  CSW201
492600200529     C                   PARM      *BLANKS       @RTCD                                        CSW201
492700200529                                                                                              CSW201
492800200529     C                   IF        *IN90 = *ON                                                CSW201
492900200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSW201
493000200529     C                   EVAL      DBASE = 912                                                CSW201
493100200529     C                   EVAL      DBKEY = 'CSW201'                                           CSW201
493200200529     C                   EXSR      *PSSR                                                      CSW201
493300200529                                                                                              CSW201
493400200529     C                   ELSE                                                                 CSW201
493500200529     C                   IF        @RTCD = 'CSW2001'                                          CSW201
493600200529     C                   EVAL      CSW201 = 'Y'                                               CSW201
493700200529     C                   ELSE                                                                 CSW201
493800200529     C                   EVAL      CSW201 = 'N'                                               CSW201
493900200529     C                   ENDIF                                                                CSW201
494000200529     C                   ENDIF                                                                CSW201
494100200529      *                                                                                       CSE028
494200200529      ** Check if CSE028 feature is installed                                                 CSE028
494300200529      *                                                                                       CSE028
494400200529     C                   CALLB     'AOSARDR0'                                                 CSE028
494500200529     C                   PARM      *BLANKS       @RTCD                                        CSE028
494600200529     C                   PARM      '*VERIFY'     @OPTN                                        CSE028
494700200529     C                   PARM      'CSE028'      @SARD                                        CSE028
494800200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE028
494900200529      *                                                                                       CSE028
495000200529      ** Database Error                                                                       CSE028
495100200529      *                                                                                       CSE028
495200200529     C     @RTCD         IFNE      *BLANKS                                                    CSE028
495300200529     C     @RTCD         ANDNE     '*NRF   '                                                  CSE028
495400200529     C     *LOCK         IN        LDA                                                        CSE028
495500200529     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE028
495600200529     C                   Z-ADD     912           DBASE                                        CSE028
495700200529     C                   MOVEL     'CSE028'      DBKEY                                        CSE028
495800200529     C                   OUT       LDA                                                        CSE028
495900200529     C                   EXSR      *PSSR                                                      CSE028
496000200529     C                   ENDIF                                                                CSE028
496100200529      *                                                                                       CSE028
496200200529     C     @RTCD         IFEQ      *BLANK                                                     CSE028
496300200529     C                   MOVEL     'Y'           CSE028            1                          CSE028
496400200529     C                   ELSE                                                                 CSE028
496500200529     C                   MOVEL     'N'           CSE028                                       CSE028
496600200529     C                   ENDIF                                                                CSE028
496700200529      *
496800200529      ** Check if CSE039 feature is installed                                                 CSE039
496900200529      *                                                                                       CSE039
497000200529     C                   CALLB     'AOSARDR0'                                                 CSE039
497100200529     C                   PARM      *BLANKS       @RTCD                                        CSE039
497200200529     C                   PARM      '*VERIFY'     @OPTN                                        CSE039
497300200529     C                   PARM      'CSE039'      @SARD                                        CSE039
497400200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE039
497500200529      *                                                                                       CSE039
497600200529      ** Database Error                                                                       CSE039
497700200529      *                                                                                       CSE039
497800200529     C     @RTCD         IFNE      *BLANKS                                                    CSE039
497900200529     C     @RTCD         ANDNE     '*NRF   '                                                  CSE039
498000200529     C     *LOCK         IN        LDA                                                        CSE039
498100200529     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE039
498200200529     C                   Z-ADD     913           DBASE                                        CSE039
498300200529     C                   MOVEL     'CSE039'      DBKEY                                        CSE039
498400200529     C                   OUT       LDA                                                        CSE039
498500200529     C                   EXSR      *PSSR                                                      CSE039
498600200529     C                   ENDIF                                                                CSE039
498700200529      *                                                                                       CSE039
498800200529     C     @RTCD         IFEQ      *BLANK                                                     CSE039
498900200529     C                   MOVEL     'Y'           CSE039            1                          CSE039
499000200529     C                   ELSE                                                                 CSE039
499100200529     C                   MOVEL     'N'           CSE039                                       CSE039
499200200529     C                   ENDIF                                                                CSE039
499300200529      *                                                                                       CSE045
499400200529      ** Check if CSE045 feature is installed                                                 CSE045
499500200529      *                                                                                       CSE045
499600200529     C                   CALLB     'AOSARDR0'                                                 CSE045
499700200529     C                   PARM      *BLANKS       @RTCD                                        CSE045
499800200529     C                   PARM      '*VERIFY'     @OPTN                                        CSE045
499900200529     C                   PARM      'CSE045'      @SARD                                        CSE045
500000200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE045
500100200529      *                                                                                       CSE045
500200200529      ** Database Error                                                                       CSE045
500300200529      *                                                                                       CSE045
500400200529     C     @RTCD         IFNE      *BLANKS                                                    CSE045
500500200529     C     @RTCD         ANDNE     '*NRF   '                                                  CSE045
500600200529     C     *LOCK         IN        LDA                                                        CSE045
500700200529     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE045
500800200529     C                   Z-ADD     913           DBASE                                        CSE045
500900200529     C                   MOVEL     'CSE045'      DBKEY                                        CSE045
501000200529     C                   OUT       LDA                                                        CSE045
501100200529     C                   EXSR      *PSSR                                                      CSE045
501200200529     C                   ENDIF                                                                CSE045
501300200529      *                                                                                       CSE045
501400200529     C     @RTCD         IFEQ      *BLANK                                                     CSE045
501500200529     C                   MOVEL     'Y'           CSE045            1                          CSE045
501600200529     C                   ELSE                                                                 CSE045
501700200529     C                   MOVEL     'N'           CSE045                                       CSE045
501800200529     C                   ENDIF                                                                CSE045
501900200529      *
502000200529      ** Access API ICD Details                                                 CAP011
502100200529      *                                                                         CAP011
502200200529     C                   CALLB     'AOAPIR0'                                    CAP011
502300200529     C                   PARM      *BLANKS       @RTCD                          CAP011
502400200529     C                   PARM      '*FIRST '     @OPTN                          CAP011
502500200529     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
502600200529      *                                                                         CAP011
502700200529      * DATABASE ERROR                                                          CAP011
502800200529      *                                                                         CAP011
502900200529     C     @RTCD         IFNE      *BLANKS                                      CAP011
503000200529     C                   MOVEL     'SDAPIPD '    DBFILE                         CAP011
503100200529     C                   MOVEL     '911'         DBASE                          CAP011
503200200529     C                   MOVEL     @OPTN         DBKEY                          CAP011
503300200529     C                   EXSR      *PSSR                                        CAP011
503400200529     C                   END                                                    CAP011
503500200529      *
503600200529      ** Check if CSC011 is installed                                                         CSC011
503700200529                                                                                              CSC011
503800200529     C                   CALLB     'AOSARDR0'                                                 CSC011
503900200529     C                   PARM      *BLANKS       PRTCD                                        CSC011
504000200529     C                   PARM      '*VERIFY'     POPTN                                        CSC011
504100200529     C                   PARM      'CSC011'      PSARD                                        CSC011
504200200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
504300200529                                                                                              CSC011
504400200529     C                   IF        PRTCD = *Blanks                                            CSC011
504500200529     C                   EVAL      CSC011 = 'Y'                                               CSC011
504600200529     C                   OPEN      APILOGL0                                                   CSC011
504700200529     C                   IN        SC24X7                                                     CSC011
504800200529     C**********         IN        SDSTAT                                              CSC011 CSD015
504900200529                                                                                              CSC011
505000200529     C                   ELSE                                                                 CSC011
505100200529     C                   EVAL      CSC011 = 'N'                                               CSC011
505200200529     C                   IF        PRTCD <> '*NRF'                                            CSC011
505300200529     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
505400200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
505500200529     C                   EVAL      DBASE = 912                                                CSC011
505600200529     C                   EXSR      *PSSR                                                      CSC011
505700200529     C                   ENDIF                                                                CSC011
505800200529                                                                                              CSC011
505900200529     C                   ENDIF                                                                CSC011
506000200529                                                                                              CAS006
506100200529      ** Check if enhancement CAS006 (Hedge Accounting Phase B) is installed                  CAS006
506200200529                                                                                              CAS006
506300200529     C                   CALLB     'AOSARDR0'                                                 CAS006
506400200529     C                   PARM      *BLANKS       PRTCD                                        CAS006
506500200529     C                   PARM      '*VERIFY'     POPTN                                        CAS006
506600200529     C                   PARM      'CAS006'      PSARD                                        CAS006
506700200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
506800200529                                                                                              CAS006
506900200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CAS006
507000200529     C     *LOCK         IN        LDA                                                        CAS006
507100200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
507200200529     C                   EVAL      DBKEY  = 'CAS006'                                          CAS006
507300200529     C                   EVAL      DBASE  = 913                                               CAS006
507400200529     C                   OUT       LDA                                                        CAS006
507500200529     C                   EXSR      *PSSR                                                      CAS006
507600200529     C                   ENDIF                                                                CAS006
507700200529                                                                                              CAS006
507800200529     C                   IF        PRTCD = *BLANKS                                            CAS006
507900200529     C                   EVAL      CAS006 = 'Y'                                               CAS006
508000200529     C                   ELSE                                                                 CAS006
508100200529     C                   EVAL      CAS006 = 'N'                                               CAS006
508200200529     C                   ENDIF                                                                CAS006
508300200529                                                                                              CSD015
508400200529     C                   IN        SDSTAT                                                     CSD015
508500200529                                                                                              CSC011
508600200529      *                                                                                       CGL031
508700200529      ** Access SAR details file to determine if CGL031                                       CGL031
508800200529      ** (Taxation of Savings Income) is on.                                                  CGL031
508900200529      *                                                                                       CGL031
509000200529     C                   CALLB     'AOSARDR0'                                                 CGL031
509100200529     C                   PARM      *BLANKS       @RTCD                                        CGL031
509200200529     C                   PARM      '*VERIFY'     @OPTN                                        CGL031
509300200529     C                   PARM      'CGL031'      @SARD             6                          CGL031
509400200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
509500200529      *                                                                                       CGL031
509600200529      * DATABASE ERROR                                                                        CGL031
509700200529      *                                                                                       CGL031
509800200529     C     @RTCD         IFNE      *BLANKS                                                    CGL031
509900200529     C     @RTCD         ANDNE     '*NRF   '                                                  CGL031
510000200529     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL031
510100200529     C                   MOVEL     '914'         DBASE                                        CGL031
510200200529     C                   MOVEL     'CGL031'      DBKEY                                        CGL031
510300200529     C                   EXSR      *PSSR                                                      CGL031
510400200529     C                   ENDIF                                                                CGL031
510500200529      *                                                                                       CGL031
510600200529     C     @RTCD         IFEQ      *BLANK                                                     CGL031
510700200529     C                   MOVEL     'Y'           CGL031                                       CGL031
510800200529     C                   ELSE                                                                 CGL031
510900200529     C                   MOVEL     'N'           CGL031                                       CGL031
511000200529     C                   ENDIF                                                                CGL031
511100200529      *                                                                                       CGL031
511200200529      * Key Lists
511300200529      *
511400200529     C     ZATRNKD0      KLIST
511500200529     C                   KFLD                    @FOTRANSEL
511600200529     C                   KFLD                    @TMESTPSEL
511700200529     C     ZATRNKX0      KLIST
511800200529     C                   KFLD                    @TMESTPSEL
511900200529     C                   KFLD                    @FOTRANSEL
512000200529     C     KAPILOGL0     KLIST                                                                CSC011
512100200529     C                   KFLD                    KMsgType                                     CSC011
512200200529     C                   KFLD                    KFrntOffID                                   CSC011
512300200529     C                   KFLD                    KTimeStamp                                   CSC011
512400200529                                                                                              CSC011
512500200529     C     K@KEY1        KLIST                                                                CER001
512600200529     C                   KFLD                    #1TMST                                       CER001
512700200529     C                   KFLD                    #1FOTR                                       CER001
512800200529      *                                                                                       CER001
512900200529      ** Setup key values using transaction data passed from caller                           CER001
513000200529      *                                                                                       CER001
513100200529     C                   EVAL      K@TDRF = DDTDRF                                            CER001
513200200529      *                                                                                       CER001
513300200529     C     K@KEY         KLIST                                                                CER001
513400200529     C                   KFLD                    K@TDRF                                       CER001
513500200529
513600200529      ** Message Type
513700200529
513800200529     C*******************MOVEL     'SETRAD'      @MSGTYPE          8            CAP004
513900200529
514000200529      ** Get the field number for the action code field; the primary
514100200529      ** screen fields start from that number.  Subtract one from it to
514200200529      ** give the value to subtract from each field's number.
514300200529     C                   CALLB     'ZACGTFLDNO'
514400200529     C                   PARM                    ReturnCode
514500200529     C                   PARM                    Format
514600200529     C                   PARM                    FieldP
514700200529     C                   PARM                    FieldNo
514800200529
514900200529     C                   IF        ReturnCode = *blank
515000200529     C                   EVAL      FldOffsetP = FieldNo - 1
515100200529     C                   ENDIF
515200200529
515300200529      ** Get the field number for the settle ccy field; the secondary
515400200529      ** screen fields start from that number.  Subtract one from it to
515500200529      ** give the value to subtract from each field's number.
515600200529     C                   CALLB     'ZACGTFLDNO'
515700200529     C                   PARM                    ReturnCode
515800200529     C                   PARM                    Format
515900200529     C                   PARM                    FieldS
516000200529     C                   PARM                    FieldNo
516100200529
516200200529     C                   IF        ReturnCode = *blank
516300200529     C                   EVAL      FldOffsetS = FieldNo - 1
516400200529     C                   ENDIF
516500200529      *
516600200529      * Start on Browse Screen
516700200529      *
516800200529     C                   MOVEL     'I'           @SCRN             1
516900200529     C                   MOVEL     'N'           @FRPGM            1                          CSE028
517000200529      *
517100200529      ** Access Switchable Features File, for CSC022                                          CSC022
517200200529      *                                                                                       CSC022
517300200529     C                   Eval      CSC022 = 'N'                                               CSC022
517400200529     C                   CallB     'AOSARDR0'                                                 CSC022
517500200529     C                   Parm      *BLANKS       PRTCD                                        CSC022
517600200529     C                   Parm      '*VERIFY'     POPTN                                        CSC022
517700200529     C                   Parm      'CSC022'      PSARD                                        CSC022
517800200529     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
517900200529      *                                                                                       CSC022
518000200529     C                   If        PRTCD = *Blanks                                            CSC022
518100200529     C                   Eval      CSC022 = 'Y'                                               CSC022
518200200529     C                   Eval      WCommitSkip = 'N'                                          CSC022
518300200529      *                                                                                       CSC022
518400200529     C                   In        SCCMTJOB                                                   CSC022
518500200529     C                   If        ComitNum > 0                                               CSC022
518600200529     C                   MoveA     ComitJob      WCmtJobArr                                   CSC022
518700200529      *                                                                                       CSC022
518800200529     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                  CSC022
518900200529     C                   If        *IN87 = *ON                                                CSC022
519000200529     C                   Eval      WCommitSkip = 'Y'                                          CSC022
519100200529     C                   EndIf                                                                CSC022
519200200529     C                   EndIf                                                                CSC022
519300200529      *                                                                                       CSC022
519400200529     C                   Else                                                                 CSC022
519500200529      *                                                                                       CSC022
519600200529      ** If return code <> *NRF, call program exception error routine                         CSC022
519700200529      *                                                                                       CSC022
519800200529     C                   If        PRTCD <> '*NRF'                                            CSC022
519900200529     C     *LOCK         IN        LDA                                                        CSC022
520000200529     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
520100200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
520200200529     C                   EVAL      DBASE = 914                                                CSC022
520300200529     C                   OUT       LDA                                                        CSC022
520400200529     C                   Exsr      *PSSR                                                      CSC022
520500200529     C                   EndIf                                                                CSC022
520600200529     C                   EndIf                                                                CSC022
520700200529      *                                                                                       CSC022
520800200529      ** Check if enhancement CGL014 (Collaterals Processing) is on                          BUG3145
520900200529                                                                                             BUG3145
521000200529     C                   CALLB     'AOSARDR0'                                                BUG3145
521100200529     C                   PARM      *BLANKS       PRTCD                                       BUG3145
521200200529     C                   PARM      '*VERIFY'     POPTN                                       BUG3145
521300200529     C                   PARM      'CGL014'      PSARD                                       BUG3145
521400200529     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3145
521500200529                                                                                             BUG3145
521600200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                 BUG3145
521700200529     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3145
521800200529     C                   EVAL      DBKEY  = 'CGL014'                                         BUG3145
521900200529     C                   EVAL      DBASE  = 912                                              BUG3145
522000200529     C                   EXSR      *PSSR                                                     BUG3145
522100200529     C                   ENDIF                                                               BUG3145
522200200529                                                                                             BUG3145
522300200529     C                   IF        PRTCD = *BLANKS                                           BUG3145
522400200529     C                   EVAL      CGL014 = 'Y'                                              BUG3145
522500200529     C                   ELSE                                                                BUG3145
522600200529     C                   EVAL      CGL014 = 'N'                                              BUG3145
522700200529     C                   ENDIF                                                               BUG3145
522800200529                                                                                             BUG3145
522900200529
523000200529      *  Hook to enable non-core initial processing to be included
523100200529      /COPY WNCPYSRC,SETRADR014
523200200529
523300200529      *                                                                                       CER001
523400200529      ** Access SAR details file to determine if ULX603                                       CER001
523500200529      ** is installed.                                                                        CER001
523600200529      *                                                                                       CER001
523700200529     C                   CALLB     'AOSARDR0'                                                 CER001
523800200529     C                   PARM      *BLANKS       @RTCD                                        CER001
523900200529     C                   PARM      '*VERIFY'     @OPTN                                        CER001
524000200529     C                   PARM      'ULX603'      @SARD             6                          CER001
524100200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
524200200529      *                                                                                       CER001
524300200529      ** Database Error                                                                       CER001
524400200529      *                                                                                       CER001
524500200529     C                   IF        @RTCD  <> *BLANKS AND @RTCD <> '*NRF   '                   CER001
524600200529     C                   EVAL      DBFILE  = 'SCSARDPD'                                       CER001
524700200529     C                   EVAL      DBASE   = 915                                              CER001
524800200529     C                   EVAL      DBKEY   = 'ULX603'                                         CER001
524900200529     C                   EXSR      *PSSR                                                      CER001
525000200529     C                   ENDIF                                                                CER001
525100200529     C                   IF        @RTCD   = *BLANK                                           CER001
525200200529     C                   EVAL      ULX603  = 'Y'                                              CER001
525300200529     C                   OPEN      SEITDLX1L0                                                 CER001
525400200529      *                                                                                       CER001
525500200529      ** Do not process lux extension details when Lux Return indicator is                    CER001
525600200529      ** not set to 'Y'                                                                       CER001
525700200529      *                                                                                       CER001
525800200529      *                                                                                       CER001
525900200529     C                   IF        BGLRIN <> 'Y'                                              CER001
526000200529     C                   EVAL      ULX603  = 'N'                                              CER001
526100200529     C                   ENDIF                                                                CER001
526200200529     C                   ELSE                                                                 CER001
526300200529     C                   EVAL      ULX603  = 'N'                                              CER001
526400200529     C                   ENDIF                                                                CER001
526500200529      *                                                                                       CER001
526600200529      ** ULX008 - API Commissariat Aux Bourses (Funct. SEDPMV/SETRAD)                         CER001
526700200529      *                                                                                       CER001
526800200529     C                   EVAL      ULX008  = 'N'                                              CER001
526900200529     C                   CALL      'AOSARDR0'                                                 CER001
527000200529     C                   PARM      *BLANKS       @RTCD                                        CER001
527100200529     C                   PARM      '*VERIFY'     @OPTN                                        CER001
527200200529     C                   PARM      'ULX008'      @SARD                                        CER001
527300200529      *                                                                                       CER001
527400200529     C                   IF        @RTCD   = *BLANKS                                          CER001
527500200529     C                   EVAL      ULX008  = 'Y'                                              CER001
527600200529     C                   ENDIF                                                                CER001
527700200529      *                                                                                       CER001
527800200529      ** Database Error                                                                       CER001
527900200529      *                                                                                       CER001
528000200529     C                   IF        @RTCD  <> *BLANKS AND @RTCD <> '*NRF   '                   CER001
528100200529     C                   EVAL      DBFILE  = 'SCSARDPD'                                       CER001
528200200529     C                   EVAL      DBASE   = 916                                              CER001
528300200529     C                   EVAL      DBKEY   = 'ULX008'                                         CER001
528400200529     C                   EXSR      *PSSR                                                      CER001
528500200529     C                   ENDIF                                                                CER001
528600200529     C                   ENDSR
528700200529      *****************************************************************                       CER001
528800200529      /EJECT                                                                                  CER001
528900200529      *****************************************************************                       CER001
529000200529      *                                                               *                       CER001
529100200529      *  RTVTRDLUX - Retrieve LUX invalid records                     *                       CER001
529200200529      *                                                               *                       CER001
529300200529      *****************************************************************                       CER001
529400200529     C     RTVTRDLUX     BEGSR                                                                CER001
529500200529     C                   EVAL      #1FOTR  = DDFOTRANID                                       CER001
529600200529     C                   EVAL      #1TMST  = DDTMESTMP                                        CER001
529700200529     C                   EVAL      QPETDRF = DDTDRF                                           CER001
529800200529      *                                                                                       CER001
529900200529      ** Retrieve record in extension file                                                    CER001
530000200529      *                                                                                       CER001
530100200529     C     K@KEY1        CHAIN     RTVIDX1                            99                      CER001
530200200529     C                   IF        %FOUND                                                     CER001
530300200529     C                   EVAL      L6LXAGSD = #6LXAGSD                                        CER001
530400200529     C                   EVAL      L6LXTTIM = #6LXTTIM                                        CER001
530500200529     C                   EVAL      L6LXCABR = #6LXCABR                                        CER001
530600200529     C                   EVAL      L6LXMTRD = CCMTRD                                          CER001
530700200529     C                   EVAL      #1DEXT   = 'Y'                                             CER001
530800200529     C                   ELSE                                                                 CER001
530900200529     C                   EVAL      L6LXAGSD = *BLANKS                                         CER001
531000200529     C                   EVAL      L6LXTTIM = *BLANKS                                         CER001
531100200529     C                   EVAL      L6LXCABR = *BLANKS                                         CER001
531200200529     C                   EVAL      L6LXMTRD = *BLANKS                                         CER001
531300200529     C                   ENDIF                                                                CER001
531400200529     C                   ENDSR                                                                CER001
531500200529      *****************************************************************                       CER001
531600200529      /EJECT                                                                                  CER001
531700200529      *****************************************************************                       CER001
531800200529      *  SRSETRAD2RP - Pocess extension record                        *                       CER001
531900200529      *****************************************************************                       CER001
532000200529     C     SRSETRAD2RP   BEGSR                                                                CER001
532100200529     C                   EVAL      #1TDVD  = TDVD                                             CER001
532200200529     C                   EVAL      #1TDDT  = TDDT                                             CER001
532300200529     C                   EVAL      #1ISSD  = ISSD                                             CER001
532400200529     C                   EVAL      #1MATY  = MATY                                             CER001
532500200529      *                                                                                       CER001
532600200529     C                   IF        @OPSEL  = 'N'                                              CER001
532700200529     C                   EVAL      ACTION  = 'E'                                              CER001
532800200529     C                   EVAL      #1DEXT  = 'Y'                                              CER001
532900200529     C                   ELSE                                                                 CER001
533000200529     C                   EVAL      ACTION  = DDACTN                                           CER001
533100200529     C                   ENDIF                                                                CER001
533200200529      *                                                                                       CER001
533300200529     C                   CALL      'SETRAD2RP'                                                CER001
533400200529     C                   PARM      *BLANKS       P@RtnCode                                    CER001
533500200529     C                   PARM                    ACTION                                       CER001
533600200529     C                   PARM                    DATALUX                                      CER001
533700200529     C                   PARM                    #RTRN                                        CER001
533800200529     C                   PARM                    NwDlFilFmt                                   CER001
533900200529     C                   PARM                    NwDlScnFmt                                   CER001
534000200529     C                   EVAL      #1DEXT  = *BLANK                                           CER001
534100200529      *                                                                                       CER001
534200200529      ** Process returned command keys                                                        CER001
534300200529      *                                                                                       CER001
534400200529     C                   SELECT                                                               CER001
534500200529     C                   WHEN      #RTRN   = 'Y2U9999'                                        CER001
534600200529     C                   EXSR      ENDP                                                       CER001
534700200529      *                                                                                       CER001
534800200529      ** If Cmd12 pressed, return to initial screen;                                          CER001
534900200529      ** otherwise, go to settlements screen                                                  CER001
535000200529      *                                                                                       CER001
535100200529     C                   WHEN      #RTRN   = 'USR0790'                                        CER001
535200200529     C                   IF        @RDNB   = 'Y'                                              CER001
535300200529     C                   EVAL      @SCRN   = PRV_SCRN                                         CER001
535400200529     C                   ELSE                                                                 CER001
535500200529     C                   EXSR      INITIAL                                                    CER001
535600200529     C                   ENDIF                                                                CER001
535700200529      *                                                                                       CER001
535800200529      ** In enquiry, return to initial screen;                                                CER001
535900200529      *                                                                                       CER001
536000200529     C                   WHEN      @OPSEL  = 'N'                                              CER001
536100200529     C                   EVAL      @SCRN   = 'R'                                              CER001
536200200529     C                   OTHER                                                                CER001
536300200529     C                   IF        BGWDPR = 'Y'                                               CER001
536400200529     C                   EVAL      @SCRN  = 'W'                                               CER001
536500200529     C                   ELSE                                                                 CER001
536600200529     C                   EVAL      @SCRN  = 'U'                                               CER001
536700200529     C                   ENDIF                                                                CER001
536800200529     C                   ENDSL                                                                CER001
536900200529      *                                                                                       CER001
537000200529     C                   ENDSR                                                                CER001
537100200529      *****************************************************************
537200200529      /EJECT
537300200529      *****************************************************************
537400200529      ** Program, module and procedure names for database error processing.
537500200529      ** =================================================================
537600200529      ** The following /COPY sets these values, and also defines LDA as
537700200529      ** an external data area
537800200529      ********************************************************************
537900200529     C/COPY ZACPYSRC,PSSR_ILE
538000200529      ********************************************************************
538100200529**  CPY@
538200200529(c) Finastra International Limited 2001
