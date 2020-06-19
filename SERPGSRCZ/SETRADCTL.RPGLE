000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas SE Trade interface controller - commit!')        *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Securities Trading Module                            *
000900200529      *                                                               *
001000200529      *  SETRADCTL - SE Trades Interface Controller                   *
001100200529      *                                                               *
001200200529      *  Function: This Program Validates SE Trades for Input into    *
001300200529      *            the Midas database.                                *
001400200529      *            Processes executed controlled by input Action Code *
001500200529      *            - For I (=Insert)                                  *
001600200529      *              - If ALL of the settlement fields are blank, set *
001700200529      *                them up from standard settlement instructions  *
001800200529      *            - For I (=Insert) or A (=Amend)                    *
001900200529      *              - Validate the trade fields                      *
002000200529      *              - Validate the settlement fields                 *
002100200529      *            - For A (=Amend) if it is valid, call a separate   *
002200200529      *              function to check whether it is a valid amendment*
002300200529      *            - For X (=Authorise) call a separate function to   *
002400200529      *              process this trade and bypass the rest of the    *
002500200529      *              validation                                       *
002600200529      *            - For D (=Delete) call a separate function to      *
002700200529      *              process this trade and bypass the rest of the    *
002800200529      *              validation                                       *
002900200529      *            For all action codes, the decision to as to        *
003000200529      *            whether to write to the Valid or Invalid file and  *
003100200529      *            the call to the Message Handler will take place    *
003200200529      *            in this module                                     *
003300200529      *                                                               *
003400200529      *  (c) Finastra International Limited 2001                      *
003500200529      *                                                               *
003600200604      *  Last Amend No. 258901             Date 22May20               *
003700200529      *  Prev Amend No. CSD102             Date 08Jan19               *
003800200529      *                 MD046248           Date 27Oct17               *
003900200529      *                 CLE134             Date 01Aug12               *
004000200529      *                 CSF011A            Date 28Nov11               *
004100200529      *                 AR698195B          Date 20Jan11               *
004200200529      *                 CSW210             Date 04May10               *
004300200529      *                 CER059             Date 19Jul10               *
004400200529      *                 CER054             Date 07Apr09               *
004500200529      *                 BUG22911           Date 17Feb09               *
004600200529      *                 CER048             Date 19May08               *
004700200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
004800200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
004900200529      *                 256564             Date 17Sep08               *
005000200529      *                 247873             Date 15Jun07               *
005100200529      * Midas Plus 1.4 Base ------------------------------------------*
005200200529      *                 243776A            Date 11Dec06               *
005300200529      *                 243776             Date 21Jul06               *
005400200529      *                 234858             Date 18Jul05               *
005500200529      *                 233881             Date 02Jun05               *
005600200529      *                 244115             Date 06Oct06               *
005700200529      *                 243119A            Date 15Nov06               *
005800200529      *                 243604             Date 17Nov06               *
005900200529      * Midas Plus 1.3 ----------- Base ------------------------------*
006000200529      *                 CSW206E            Date 24Aug06               *
006100200529      *                 CSD031             Date 10Apr06               *
006200200529      *                 CSD027             Date 09Dec05               *
006300200529      *                 CAP087             Date 17Aug05               *
006400200529      *                 BUG9107            Date 19Jul05               *
006500200529      *                 CER001             Date 25Apr05               *
006600200529      *                 CSE075             Date 17Nov05               *
006700200529      *                 CGL031             Date 05Jul04               *
006800200529      *                 CSE065             Date 08Nov04               *
006900200529      *                 CSE071             Date 19Jul05               *
007000200529      *                 BUG2274            Date 19Aug04               *
007100200529      *                 BUG3122            Date 17Jul04               *
007200200529      *                 BUG3145            Date 15Jun04               *
007300200529      *                 CSC022             Date 24Feb04               *
007400200529      *                 CGL029             Date 01Sep03               *
007500200529      *                 CSE045             Date 24Mar03               *
007600200529      *                 CSE037             Date 29Apr02               *
007700200529      *                 CSE039             Date 21Jan03               *
007800200529      *                 CAS006             Date 21Jan03               *
007900200529      * Midas Release 4.01.03 ----------------------------------------*
008000200529      *                 210517             Date 21Nov02               *
008100200529      * Midas Release 4.01.02 ----------------------------------------*
008200200529      *                 200299             Date 05Jul02               *
008300200529      *                 200459             Date 22Apr02               *
008400200529      * Midas Release 4.01 -------------------------------------------*
008500200529      *                 CSE034             Date 23Apr02               *
008600200529      *                 CSE031             Date 13Dec01               *
008700200529      *                 CSC011             Date 18Sep01               *
008800200529      *                 201429             Date 24Dec01               *
008900200529      *                 201233             Date 20Dec01               *
009000200529      *                 CAP067             Date 24Sep01               *
009100200529      *                 199797             Date 01Nov01               *
009200200529      * Midas Release 4 --------------- Base -------------------------*
009300200529      *                 CSE028             Date 06Jun01               *
009400200529      *                 CSW201             Date 02May01               *
009500200529      *                 CSE016             Date 10Jan01               *
009600200529      * Midas DBA 3.05 -----------------------------------------------*
009700200529      *                 193462             Date 25May01               *
009800200529      *                 CUT009             Date 22Mar01               *
009900200529      *                 CPB002             Date 28Mar01               *
010000200529      * Midas DBA 3.04 -----------------------------------------------*
010100200529      *                 CSE023             Date 12Jul00               *
010200200529      *                 175216             Date 12Sep00               *
010300200529      * Midas DBA 3.03 -----------------------------------------------*
010400200529      *                 CAP137             Date 07Feb00               *
010500200529      * Midas DBA 3.02 -----------------------------------------------*
010600200529      *                 CAP051             Date 16Nov99               *
010700200529      *                 CPB001             Date 31Aug99               *
010800200529      *                 CAP013             Date 07Sep99               *
010900200529      *                 CAP011             Date 07Sep99               *
011000200529      * Midas DBA 3.00 ---------------- Base -------------------------*
011100200529      *                 CPL002             Date 08Mar99               *
011200200529      *                 154562             Date 01Feb99               *
011300200529      *                 CAP004             Date 07Sep98               *
011400200529      *                 CAP002  *CREATE    Date 06OCT97               *
011500200529      *                                                               *
011600200529      *---------------------------------------------------------------*
011700200529      *  258901 - Error in tax amount for charges and commissions.    *
011800200529      *  CSD102 - Password Length Extension (Recompile)               *
011900200529      *  MD046248 - Finastra Rebranding                               *
012000200529      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
012100200529      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
012200200529      *  AR698195B - Added Front Office field on the buffer for TRADS *
012300200529      *             (Child: AR698196)                                 *
012400200529      *  CSW210 - SWIFT 2010 Changes                                  *
012500200529      *  CER059 - German Feature Upgrade to Delhi                     *
012600200529      *  CER054 - German Features - Church Tax (Recompile)            *
012700200529      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
012800200529      *  CER048 - German Features - Taxes (Recompile)                 *
012900200529      *  256564 - Recompile due to PF changes done by fix 256330      *
013000200529      *  247873 - Make sure that DfltTrSwfA is executed during Insert *
013100200529      *           mode.                                               *
013200200529      *  243776A- Use value date from TRADSD as parameter.            *
013300200529      *  243776 - Apply same correction as 235547 to make parameter   *
013400200529      *           list match with SETRADSVAL parameter entry list.    *
013500200529      *           Apply 233881 and 234858 corrections.                *
013600200529      *  234858 - EU Tax amount should be put into valid trade field  *
013700200529      *  233881 - EU Tax amount should be subtracted from the         *
013800200529      *           Countervalue.                                       *
013900200529      *  244115 - To properly set clearance type within invalid file. *
014000200529      *  243119A - Safekeeping A/C defaulting problem when trade comes*
014100200529      *            from an interface. Additional fixes to do defaults *
014200200529      *            when CSE045 is switched off and when CUST# is zero.*
014300200529      *  243604  - Access correct branch in AOBRCHR1.                 *
014400200529      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
014500200529      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
014600200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
014700200529      *  CAP087  - Enable the use of SETRADVU to process Buy/Sell     *
014800200529      *            trades.                                            *
014900200529      *  BUG9107 - Correct error caused by commitment definition      *
015000200529      *  CER001 - LUX Upgrade to MidasPlus                            *
015100200529      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
015200200529      *           (Recompile)                                         *
015300200529      *  CGL031 - Taxation for Savings Income                         *
015400200529      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
015500200529      *           (Recompile)                                         *
015600200529      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
015700200529      *  BUG2274 - Unable to access SSI information because market    *
015800200529      *            not being passed in.                               *
015900200529      *  BUG3122 - Renamed the field SEZONE in SDSECS data structure  *
016000200529      *            to avoid compilation error.                        *
016100200529      *  BUG3145 - Charges and Commission are being missed out of the *
016200200529      *            calculation of countervalue.                       *
016300200529      *  CSC022 - Commitment Control Changes for MidasPlus            *
016400200529      *  CGL029 - Increase Account Code to 10 digits                  *
016500200529      *  CSE045 - API for Extended Settlement for Trade Input and     *
016600200529      *           Depot Movement                                      *
016700200529      *  CSE037 - Bond Pricing - 3 Decimal Places in Trades Input     *
016800200529      *  CSE039 - Auto-settlement of trades.                          *
016900200529      *  CAS006 - Hedge Accounting Phase B                            *
017000200529      *  210517 - Missing TRADSDX2 record from the API                *
017100200529      *  200299 - Recompile due to change in SETRIFPD                 *
017200200529      *  200459 - Current factor not applied to countervalue for 'MP' *
017300200529      *           Securities.  Add checking to SEDEV for new current  *
017400200529      *           factor and if it exists, use it in calculating the  *
017500200529      *           countervalue.  Amended to be consistent with SE0050.*
017600200529      *  CSE034 - Standard Settlement Instruction improvements        *
017700200529      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
017800200529      *           Recompiled due to changes in SECTYD.                *
017900200529      *  CSC011 - 24x7 Midas Availability                             *
018000200529      *  201429 - New validation needed for ISO15022 in               *
018100200529      *           extended settlement screen.                         *
018200200529      *  201233 - If message is unroutable, settlement of message     *
018300200529      *           request cannot be a 'Y'.                            *
018400200529      *  CAP067 - Repurchase Agreements API.                          *
018500200529      *  199797 - Additional changes and fixes for CSE028 (SSIs).     *
018600200529      *  CSE028 - Standing Settlement Instructions Enhancement.       *
018700200529      *  CSW201 - SWIFT 2001 Standards Update                         *
018800200529      *  CSE016 - Extended Security Descriptions                      *
018900200529      *  193462 - Protect Book code if Buy/sell indicator = 'Y'       *
019000200529      *  CUT009 - Core hooks added manually.                          *
019100200529      *  CPB002 - Counterparty for trades coming from Tof can be the  *
019200200529      *           internal customer number (Book transfer)            *
019300200529      *           In this case the PB Order Number is setted in Tof   *
019400200529      *           Add this parameter when calling SETRADPVAL to give  *
019500200529      *           the value to SEVTCUST                               *
019600200529      *  CSE023 - Treaty Withholding Tax.                             *
019700200529      *  175216 - Add additional field for "Standing Instructions     *
019800200529      *           Override" missed at SWIFT 98 change.                *
019900200529      *           Correct core problem relating to rename REPI.       *
020000200529      *  CAP137 - Conversion of SE Security inputs into modular       *
020100200529      *           structure to use as APIs (SECTYD)                   *
020200200529      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
020300200529      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
020400200529      *           Recompiled due to database changes                  *
020500200529      *         - 'Private Banking' Module                            *
020600200529      *           /COPY SE_CUSTDT changed                             *
020700200529      *  CAP013 - Allow access by Midas transaction ID if not insert  *
020800200529      *  CAP011 - Substitution of Midas database flds for externl i/fs*
020900200529      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
021000200529      *  154562 - Only 1 record is needed on TRADSDX1 if CSW003 is off*
021100200529      *  CAP004 - API's Phase 3.                                      *
021200200529      *           Add extra parm for Extra Data                       *
021300200529      *  CAP002 - Conversion of Midas inputs to modular API structure *
021400200529      *                                                               *
021500200529      *****************************************************************
021600200529      ** +--------------------------------------+
021700200529      ** ¦ F-specs                              ¦
021800200529      ** ¦ =======                              ¦
021900200529      ** +--------------------------------------+
022000200529      *****************************************************************
022100200529
022200200529      * Valid Trades
022300200529     FSEVTRADPD UF A E             DISK    INFSR(*pssr)
022400200529     F                                     PREFIX(V_)
022500200529     F                                     COMMIT
022600200529      * Valid Trades - Extension file
022700200529     FSEVTRX1PD UF A E             DISK    INFSR(*pssr)
022800200529     F                                     PREFIX(V_)
022900200529     F                                     COMMIT
023000200529      * Valid Trades - Extension file                                                         CSE045
023100200529     FSEVTRX2PD UF A E             DISK    INFSR(*pssr)                                       CSE045
023200200529     F                                     PREFIX(V_)                                         CSE045
023300200529     F                                     COMMIT                                             CSE045
023400200529      * Trades Extended Settlements                                                           CSE045
023500200529     F***TRADSDY2  IF   E           K DISK    COMMIT                                  CSE045 BUG9107
023600200529     FTRADSDY2  IF   E           K DISK    INFSR(*pssr)                                      BUG9107
023700200529      * Invalid Trades
023800200529     FSEITRADPD UF A E             DISK    INFSR(*pssr)
023900200529     F                                     COMMIT
024000200529
024100200529     FSEVTRADL0 IF   E           K DISK    RENAME(SEVTRADD0:SEVTRADCHK)
024200200529     F                                     INFSR(*pssr)                         CAP013
024300200529     FSEVTRADL1 IF   E           K DISK    RENAME(SEVTRADD0:SEVTRADCK1)         CAP013
024400200529     F                                     INFSR(*pssr)                         CAP013
024500200529
024600200529     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
024700200529      * Trade Extension File 3                                                                CSE039
024800200529     FTRADSDX3  UF A E             DISK    INFSR(*pssr)                                       CSE039
024900200529     F                                     COMMIT                                             CSE039
025000200529
025100200529      * Hook to enable non-core files to be included
025200200529      /COPY WNCPYSRC,SETRADC016
025300200529                                                                                              CER001
025400200529      *                                                                                       CER001
025500200529      ** Midas SE TRAD - Valid File                                                           CER001
025600200529      *                                                                                       CER001
025700200529     FSEVTDLX1PDUF A E             DISK    USROPN                                             CER001
025800200529     F                                     INFSR(*pssr)                                       CER001
025900200529     F                                     COMMIT                                             CER001
026000200529                                                                                              CER001
026100200529      *                                                                                       CER001
026200200529      ** Midas SE TRAD - Invalid File                                                         CER001
026300200529      *                                                                                       CER001
026400200529     FSEITDLX1PDUF A E             DISK    USROPN                                             CER001
026500200529     F                                     INFSR(*pssr)                                       CER001
026600200529     F                                     COMMIT                                             CER001
026700200529
026800200529      *****************************************************************
026900200529      ** +--------------------------------------+
027000200529      ** ¦ Automatically included D-specs       ¦
027100200529      ** ¦ ==============================       ¦
027200200529      ** +--------------------------------------+
027300200529      **
027400200529      ** Standard D-specs
027500200529      ** ================
027600200529      **
027700200529      ** The following /COPY line includes the LDA layout,
027800200529      ** the copyright array definition,
027900200529      ** and the following named constants:
028000200529      **    True       logical = *on (for indcator processing)
028100200529      **    False      logical = *off (for indcator processing)
028200200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
028300200529      **                                    handler)
028400200529      ** and the following variables:
028500200529      **    RunBefore  1A (for the PSSR)
028600200529
028700200529     D/COPY ZACPYSRC,STD_D_SPEC
028800200529
028900200529      ** Program Status Data Structure
029000200529      ** =============================
029100200529      ** The following /COPY line includes all the defined fields in the
029200200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
029300200529
029400200529     D/COPY ZACPYSRC,PSDS
029500200529      ** The following /COPY line includes definitions for the above fields
029600200529      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
029700200529      ** corresponding fields in the PSDS /COPY member, so that member
029800200529      ** must be included where this one is used.
029900200529
030000200529     D/COPY ZACPYSRC,PROCPARMS
030100200529
030200200529      **--------------------------------------------------------------------------------------------
030300200529      ** The following /COPY line includes the definitions for error and
030400200529      ** warning message arrays.
030500200529     D/COPY ZACPYSRC,ERR_ARRAYS
030600200529      **--------------------------------------------------------------------------------------------
030700200529
030800200529      **--------------------------------------------------------------------------------------------
030900200529      ** The following /COPY line includes the definitions for arrays
031000200529      ** specific to API *CTL modules.
031100200529     D/COPY ZACPYSRC,APICTLARR
031200200529      **--------------------------------------------------------------------------------------------
031300200529
031400200529      **--------------------------------------------------------------------------------------------
031500200529      ** The following /COPY line includes the definitions for fields
031600200529      ** used in checking whether there are messages on the data queue.
031700200529     D/COPY ZACPYSRC,DTAQCHKDCL
031800200529      **--------------------------------------------------------------------------------------------
031900200529
032000200529      ** +--------------------------------------+
032100200529      ** ¦ End of automatically included D-specs¦
032200200529      ** ¦ =====================================¦
032300200529      ** +--------------------------------------+
032400200529
032500200529      *****************************************************************
032600200529      /EJECT
032700200529      *****************************************************************
032800200529
032900200529      ** +--------------------------------------+
033000200529      ** ¦ Manually included D-specs            ¦
033100200529      ** ¦ =========================            ¦
033200200529      ** +--------------------------------------+
033300200529
033400200529      ** +--------------------------------------+
033500200529      ** ¦ Named constants                      ¦
033600200529      ** ¦ ===============                      ¦
033700200529      ** +--------------------------------------+
033800200529
033900200529      ** String for error messages to the operator
034000200529     D ProcErr         C                   CONST('Error in module')
034100200529
034200200529      ** +--------------------------------------+
034300200529      ** ¦ Arrays and Data Structures           ¦
034400200529      ** ¦ ==========================           ¦
034500200529      ** +--------------------------------------+
034600200529                                                                                              CSC022
034700200529     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
034800200529      ** Array for commitment job names                                                       CSC022
034900200529
035000200529      * Incoming Header
035100200529     D HeadIn        E DS                  EXTNAME(APHEADPD)
035200200529
035300200529      * Incoming Transaction
035400200529     D TranInPrim    E DS                  EXTNAME(SETRPRPD)
035500200529     D TranInSeco    E DS                  EXTNAME(SETRSEPD)
035600200529     D TranInThir    E DS                  EXTNAME(SETRTHPD)                                  CAS006
035700200529     D TranInExch    E DS                  EXTNAME(SETREXPD)
035800200529     D TranInSett    E DS                  EXTNAME(SETRSTPD)
035900200529     D DDCLTY2       E                     EXTFLD(DDCLTY)
036000200529     D TranInChCm    E DS                  EXTNAME(SETRCCPD)
036100200529     D TranInSwfA    E DS                  EXTNAME(SETRSWPD)
036200200529     D                                     PREFIX(A)
036300200529     D TranInSwfB    E DS                  EXTNAME(SETRSWPD)
036400200529     D                                     PREFIX(B)
036500200529     D TranInSwfI    E DS                  EXTNAME(SETRSWPD)                                  247873
036600200529     D                                     PREFIX(I)                                          247873
036700200529     D TranInSwfO    E DS                  EXTNAME(SETRSWPD)                                  247873
036800200529     D                                     PREFIX(O)                                          247873
036900200529
037000200529      *                                                                                       CSE045
037100200529      ** Securities retrieved from file - file format                                         CSE045
037200200529     D CrSEFilFmt    E DS                  EXTNAME(TRADSDX2)                                  CSE045
037300200529                                                                                              CSE045
037400200529     D***OthDdata        DS          3116                                             CSE045 CSF011A
037500200529     D***TranInExt1             1   1558                                              CSE045 CSF011A
037600200529     D***TranInExt2          1559   3116                                              CSE045 CSF011A
037700200529     D OthDdata        DS          4878                                                      CSF011A
037800200529     D  TranInExt1             1   2439                                                      CSF011A
037900200529     D  TranInExt2          2440   4878                                                      CSF011A
038000200529      *                                                                                       CSE045
038100200529     D  TranInExtA   E DS                  EXTNAME(SETESDPD)                                  CSE045
038200200529     D                                     PREFIX(A)                                          CSE045
038300200529     D  TranInExtB   E DS                  EXTNAME(SETESDPD)                                  CSE045
038400200529     D                                     PREFIX(B)                                          CSE045
038500200529      *                                                                                       CSE045
038600200529      ** Securities screen 1 details retrieved from file - screen format                      CSE045
038700200529     D NwSE1ScnFmt   E DS                  EXTNAME(SETESDPD)                                  CSE045
038800200529      *                                                                                       CSE045
038900200529      ** Securities screen error indicators                                                   CSE045
039000200529     D SEETES        E DS                  EXTNAME(SEETESPD)                                  CSE045
039100200529
039200200529     D ValidTrad     E DS                  EXTNAME(SEVTRADPD)
039300200529     D                                     PREFIX(V_)
039400200529     D ValidTrX1     E DS                  EXTNAME(SEVTRX1PD)
039500200529     D                                     PREFIX(V_)
039600200529     D ValidTX1A     E DS                  EXTNAME(SEVTRX1PD)
039700200529     D                                     PREFIX(VA_)
039800200529     D ValidTX1B     E DS                  EXTNAME(SEVTRX1PD)
039900200529     D                                     PREFIX(VB_)
040000200529
040100200529     D ValidTrX2     E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
040200200529     D                                     PREFIX(V_)                                         CSE045
040300200529     D ValidTX2A     E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
040400200529     D                                     PREFIX(VA_)                                        CSE045
040500200529     D ValidTX2B     E DS                  EXTNAME(SEVTRX2PD)                                 CSE045
040600200529     D                                     PREFIX(VB_)                                        CSE045
040700200529
040800200529     D TradFilFmt    E DS                  EXTNAME(TRADSD)
040900200529     D TX1AFilFmt    E DS                  EXTNAME(TRADSDX1)
041000200529     D                                     PREFIX(A_)
041100200529     D TX1BFilFmt    E DS                  EXTNAME(TRADSDX1)
041200200529     D                                     PREFIX(B_)
041300200529
041400200529
041500200529      * (Current) Trade in Screen Format - Primary Details
041600200529     D CurTrPrim     E DS                  EXTNAME(SETRPRPD)
041700200529     D                                     PREFIX(@)
041800200529      * (Current) Trade in Screen Format - Secondary Details
041900200529     D CurTrSeco     E DS                  EXTNAME(SETRSEPD)
042000200529     D                                     PREFIX(@)
042100200529      ** (Current) Trade in Screen Format - Third screen details                              CAS006
042200200529     D CurTrThir     E DS                  EXTNAME(SETRTHPD)                                  CAS006
042300200529     D                                     PREFIX(@)                                          CAS006
042400200529      * (Current) Trade in Screen Format - Exchange Rates Details
042500200529     D CurTrExch     E DS                  EXTNAME(SETREXPD)
042600200529     D                                     PREFIX(@)
042700200529      * (Current) Trade in Screen Format - Settlement Instructions
042800200529     D CurTrSett     E DS                  EXTNAME(SETRSTPD)
042900200529     D                                     PREFIX(@)
043000200529     D @DDCLTY2      E                     EXTFLD(DDCLTY)
043100200529      * (Current) Trade in Screen Format - Charges/Commissions
043200200529     D CurTrChCm     E DS                  EXTNAME(SETRCCPD)
043300200529     D                                     PREFIX(@)
043400200529      * (Current) Trade in Screen Format - SWIFT 'A' Details
043500200529     D CurTrSwftA    E DS                  EXTNAME(SETRSWPD)
043600200529     D                                     PREFIX(@A)
043700200529      * (Current) Trade in Screen Format - SWIFT 'B' Details
043800200529     D CurTrSwftB    E DS                  EXTNAME(SETRSWPD)
043900200529     D                                     PREFIX(@B)
044000200529
044100200529
044200200529      * Error indicators
044300200529     D OKTrPrim      E DS                  EXTNAME(SEETRPRPD)
044400200529     D OKTrSeco      E DS                  EXTNAME(SEETRSEPD)
044500200529     D OKTrThir      E DS                  EXTNAME(SEETRTHPD)                                 CAS006
044600200529     D OKTrExch      E DS                  EXTNAME(SEETREXPD)
044700200529     D OKTrSett      E DS                  EXTNAME(SEETRSTPD)
044800200529     D DDCLTY2OK     E                     EXTFLD(DDCLTYOK)
044900200529     D OKTrChcm      E DS                  EXTNAME(SEETRCCPD)
045000200529     D OKTrSwft      E DS                  EXTNAME(SEETRSWPD)
045100200529
045200200529
045300200529      ** Security Details
045400200529     D SECTY         E DS                  EXTNAME(SECTYD)
045500200529     D SEC_RECI      E                     EXTFLD(RECI)
045600200529     D SEC_ZZ005     E                     EXTFLD(ZZ005)
045700200529     D SEC_LCD       E                     EXTFLD(LCD)
045800200529     D SEC_CHTP      E                     EXTFLD(CHTP)
045900200529     D SEC_TNLU      E                     EXTFLD(TNLU)
046000200529     D SEC_REPI      E                     EXTFLD(REPI)                         CPB001
046100200529     D SEC_FRNT      E                     EXTFLD(FRNT)                                       CAP137
046200200529     D SEC_REPA      E                     EXTFLD(REPA)                                       CAP137
046300200529     D SEC_TMST      E                     EXTFLD(TMST)                                       CAP137
046400200529     D SEC_NDEC      E                     EXTFLD(NDEC)                                       CSE037
046500200529
046600200529      ** Investment Type Details
046700200529     D INVTP         E DS                  EXTNAME(INVTPD)
046800200529     D INV_RECI      E                     EXTFLD(RECI)
046900200529     D INV_LCD       E                     EXTFLD(LCD)
047000200529     D INV_CHTP      E                     EXTFLD(CHTP)
047100200529     D INV_TNLU      E                     EXTFLD(TNLU)
047200200529     D INV_NDEC      E                     EXTFLD(NDEC)                                       CSE037
047300200529
047400200529
047500200529      ** The following /COPY includes the customer details data structure
047600200529     D/COPY SECPYSRC,SE_CUSTDT
047700200529      ** The following /COPY includes the currency details data structures
047800200529     D/COPY SECPYSRC,SE_CCYDT
047900200529
048000200529
048100200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
048200200529      ** External DS for Bank Details
048300200529     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  CSE045
048400200529      ** External DS for Branch Details                                                       CSE045
048500200529     D SDSECS        E DS                  EXTNAME(SDSECSPD)                                  CSE045
048600200529     D BFZONE        E                     EXTFLD(SEZONE)                                    BUG3122
048700200529      ** External DS for Security Customer Details                                            CSE045
048800200529     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
048900200529      ** External DS for API ICD                                                CAP011
049000200529     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
049100200529      ** External DS for Securities Trading Details
049200200529     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
049300200529      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
049400200529     D SDPORT        E DS                  EXTNAME(SDPORTPD)
049500200529      **  Data structure for Portfolio Management ICD File
049600200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)
049700200529     D SCA_LCD       E                     EXTFLD(LCD)
049800200529      ** EXTERNAL DS FOR SAR DETAILS
049900200529                                                                                CAP051
050000200529     D InfData       E DS                  EXTNAME(SETRIFPD)                    CAP051
050100200529      * SE Extra Data - Classe 1 Data - File (D/B) format                       CAP051
050200200529                                                                                CAP004
050300200529     D ExtData       E DS                  EXTNAME(SETDEXPD)                    CAP004
050400200529      * SE Trades Extra Data - File (D/B) format                                CAP004
050500200529      *                                                                                       CER001
050600200529     D RegData       E DS                  EXTNAME(SETDRXPD)                                  CER001
050700200529      *                                                                                       CER001
050800200529     D DSFDY         E DS                  EXTNAME(DSFDY)
050900200529      * First DS for Access programs - short data structure
051000200529     D DSSDY         E DS                  EXTNAME(DSSDY)
051100200529      * Second DS for Access programs - long data structure
051200200529
051300200529     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
051400200529      ** 24X7 status data area                                                                CSC011
051500200529                                                                                              CSC011
051600200529     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
051700200529      ** SDSTAT data area                                                                     CSC011
051800200529                                                                                              CSC011
051900200529     D TradSwX2A     E DS                  EXTNAME(TRADSDX2)                                  210517
052000200529     D                                     PREFIX(A_)                                         210517
052100200529                                                                                              210517
052200200529     D TradSwX2B     E DS                  EXTNAME(TRADSDX2)                                  210517
052300200529     D                                     PREFIX(B_)                                         210517
052400200529                                                                                              210517
052500200529     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
052600200529     D  ComitJob               4    103                                                       CSC022
052700200529      ** Midas SC Jobs handling commitment control data area                                  CSC022
052800200529      *                                                                                       CSC022
052900200529      ** +--------------------------------------+
053000200529      ** ¦ Declared variables                   ¦
053100200529      ** ¦ ==================                   ¦
053200200529      ** +--------------------------------------+
053300200529
053400200529      ** Error message field(s)
053500200529     D     Msg1        S                   LIKE(#MsgID)
053600200529
053700200529      ** Index for arrays of error message ids etc
053800200529     D Idx             S              3P 0
053900200529
054000200529      ** Index for arrays of warning message ids etc
054100200529     D WIdx            S              3P 0
054200200529
054300200529      ** Fields (500A) to receive the incoming transaction
054400200529     D Trans5001       S            500A
054500200529     D Trans5002       S            500A
054600200529     D Trans5003       S            500A
054700200529     D Trans5004       S            500A
054800200529     D Trans5005       S            500A
054900200529     D Trans5006       S            500A
055000200529     D Trans5007       S            500A
055100200529     D Trans5008       S            500A
055200200529                                                                                CAP051
055300200529      ** Field (500A) to receive the incoming Extra Data                        CAP051
055400200529     D InfData500      S            500A                                        CAP051
055500200529                                                                                CAP004
055600200529      ** Field (500A) to receive the incoming Extra Data                        CAP004
055700200529     D ExtData500      S            500A                                        CAP004
055800200529      *                                                                                       CER001
055900200529      ** Field (500A) to receive the incoming Extra Data                                      CER001
056000200529      *                                                                                       CER001
056100200529     D RegData500      S            500A                                                      CER001
056200200529      *                                                                                       CER001
056300200529      ** Field (4755A) to receive the incoming Extra Data                                     CSE045
056400200529     D***OthDData4755    S           4755A                                            CSE045 CSF011A
056500200529     D OthrData        S           4878A                                                     CSF011A
056600200529
056700200529      ** Index for arrays of error message ids etc in Amend validation
056800200529     D AmIdx           S              3P 0
056900200529
057000200529      ** Indicies for arrays used to set up corresponding sequence numbers
057100200529      **  for the fields that are in error
057200200529     D Ix              S              3P 0
057300200529     D Iy              S              3P 0
057400200529
057500200529
057600200529
057700200529      ** Overall Transaction status, to be passed to the Message Handler
057800200529     D TranStatus      S              1A
057900200529
058000200529      ** Module ID, to be passed to the Message Handler
058100200529     D ModuleID        S              2A
058200200529
058300200529      ** Timestamp for the transaction
058400200529     D TimeStamp       S               Z
058500200529
058600200529     D Object          S             10A   INZ('SETRADUPC')
058700200529     D Lib             S             10A   INZ('*LIBL')
058800200529     D ObjType         S              7A
058900200529     D LockState       S              7A   INZ('*SHRRD')
059000200529     D Member          S             10A
059100200529     D WaitTime        S              6A   INZ('0     ')
059200200529     D Dlcobj          S              1A   INZ('Y')
059300200529     D Return          S              7A
059400200529
059500200529      ** Dummy message ID and message file fields for use on the calls to
059600200529      ** ZAMSGTOOPR
059700200529     D DummyMsgID      S                   LIKE(#MsgID)
059800200529     D DummyMsgF       S             10A
059900200529
060000200529     D CSC011          S              1A                                                      CSC011
060100200529     D TRANSDTL        S           5800A                                                      CSC011
060200200529     D*PDealNo**       S             18A                                               CSC011 CGL029
060300200529     D*PADealNo*       S             18A                                               CSC011 CGL029
060400200529     D PDealNo         S             24A                                                      CGL029
060500200529     D PADealNo        S             24A                                                      CGL029
060600200529     D PRTCD           S              7A                                                      CSC011
060700200529     D POPTN           S              7A                                                      CSC011
060800200529     D PSARD           S              6A                                                      CSC011
060900200529                                                                                              CSC011
061000200529      ** Whether or not to clear the program message queue (this is not
061100200529      ** actually used, but is required by the message handler's parameter
061200200529      ** list.
061300200529     D ClrPgmMsgQ      S              1A   INZ('Y')
061400200529      *                                                                         CSE023
061500200529      ** Country of treaty                                                      CSE023
061600200529     D PDRBW           S              2A                                        CSE023
061700200529      *                                                                         CSE023
061800200529      ** Withholding tax                                                        CSE023
061900200529     D DDWTAX          S             15A                                        CSE023
062000200529
062100200529      ** Swift 2001 flag                                                                      CSW201
062200200529     D CSW201          S              1A                                                      CSW201
062300200529                                                                                              CSW201
062400200529     D CSW206          S              1A                                                     CSW206E
062500200529     D CSW210          S              1A                                                      CSW210
062600200529     D CFT004          S              1A                                                      CSW210
062700200529     D CAS006          S              1                                                       CAS006
062800200529     D DDHACR          S             13                                                       CAS006
062900200529     D DDPRICN         S             17                                                       CAS006
063000200529                                                                                              CAS006
063100200529     D CallFromVU      S              1A   INZ(' ')                                           CAP087
063200200529     D CSE022          S              1A                                                      CSE045
063300200529     D CSW014          S              1A                                                      CSE045
063400200529     D SWRTN           S              7A                                                      CSE045
063500200529     D WTDTP           S              2A                                                      CSE045
063600200529     D WWCLTY          S              2A                                                      CSE045
063700200529     D PGMNAM          S              9A                                                      CSE045
063800200529     D PWHEN           S              1A                                                      CSE045
063900200529     D PMKCT           S              2A                                                      CSE045
064000200529     D DFTFLG          S              1A                                                      CSE045
064100200529      *                                                                                       CSE045
064200200529      ** Data structure to receive parameters from SE1805 for MT5xxs                          CSE045
064300200529     D PDATA         E DS                  EXTNAME(SE50DT)                                    CSE045
064400200529      *                                                                                       CSE045
064500200529      ** Mode = '*FRONT' (front office transaction interface)                                 CSE045
064600200529      ** Mode = '      ' (not front office transaction interface)                             CSE045
064700200529      ** Mode = '*RPR  ' (repair function)                                                    CSE045
064800200529      ** Mode = '*SIN  ' (screen input function)                                              CSE045
064900200529     D PMode           S              6A   INZ('*SIN  ')                                      CSE045
065000200529     D PINKS           S              1A                                                      CSE045
065100200529     D PINKT           S              1A                                                      CSE045
065200200529     D PCUST           S              6A                                                      CSE045
065300200529     D WCTPCN          S              6A                                                      CSE045
065400200529     D PDEPO           S              6A                                                      CSE045
065500200529     D PDEPO2          S              6A                                                      CSE045
065600200529     D PRETC           S             10A                                                      CSE045
065700200529     D PSKAL           S             20A                                                      CSE045
065800200529     D CSC022          S              1A                                                      CSC022
065900200529                                                                                              CSC022
066000200529     D WCommitSkip     S              1A                                                      CSC022
066100200529      ** Commitment Skip Field                                                                CSC022
066200200529                                                                                              CSC022
066300200529     D CGL014          S              1A                                                     BUG3145
066400200529      ** CGL031 flag                                                                          CGL031
066500200529     D CGL031          S              1A                                                      CGL031
066600200529      ** Front office id variable.                                                         AR698195B
066700200529     D DDFRNT          S             20A                                                   AR698195B
066800200529                                                                                              CGL031
066900200529     D*C_TDVD**********S*******************LIKE(TDVD)******************               243776 243776A
067000200529                                                                                              243776
067100200529      ** +--------------------------------------+
067200200529      ** ¦ End of D-specs                       ¦
067300200529      ** ¦ ==============                       ¦
067400200529      ** +--------------------------------------+
067500200529
067600200529      ** +----------------------------------------+
067700200529      ** ¦ Hook for non-core D-specs (all types)  ¦
067800200529      ** ¦ also any I-specs (if necessary)        ¦
067900200529      ** ¦ =====================================  ¦
068000200529      ** +----------------------------------------+
068100200529      /COPY WNCPYSRC,SETRADC017
068200200529
068300200529      *                                                                                       CER001
068400200529      ** Valid Extended trade in File Format                                                  CER001
068500200529      *                                                                                       CER001
068600200529     D ValidFilExt   E DS                  EXTNAME(SEVTDLX1PD)                                CER001
068700200529                                                                                              CER001
068800200529      *                                                                                       CER001
068900200529      ** Errors Indicators Extended Fields                                                    CER001
069000200529      *                                                                                       CER001
069100200529     D OkFlagsExt    E DS                  EXTNAME(SEETDLX1PD)                                CER001
069200200529      *                                                                                       CER001
069300200529                                                                                              CER001
069400200529     D DATALUX         DS          1024                                                       CER001
069500200529     D  PETDRF                 1      6                                                       CER001
069600200529     D  UTDBK                  7      8                                                       CER001
069700200529     D  UVTCNR                 9     14                                                       CER001
069800200529     D  #1TDVD                15     19  0                                                    CER001
069900200529     D  #1TDDT                20     24  0                                                    CER001
070000200529     D  #1ISSD                25     29  0                                                    CER001
070100200529     D  #1MATY                30     34  0                                                    CER001
070200200529     D  #1FOTR                35     54                                                       CER001
070300200529     D  #1TMST                55     80Z                                                      CER001
070400200529      *                                                                                       CER001
070500200529      ** Variables used by CER001 modifications                                               CER001
070600200529      *                                                                                       CER001
070700200529     D ULX603          S              1A                                                      CER001
070800200529     D ULX008          S              1A                                                      CER001
070900200529      *****************************************************************
071000200529      /EJECT
071100200529      *****************************************************************
071200200529      ** +--- Start of Main processing -----------------------------------+
071300200529      ** ¦                                                                ¦
071400200529      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
071500200529      ** ¦ executed at program activation.                                ¦
071600200529      ** ¦                                                                ¦
071700200529      ** +----------------------------------------------------------------+
071800200529
071900200529      /COPY WNCPYSRC,SETRADC001
072000200529
072100200529      * Incoming transaction is broken into 500A fields, so that a common CL
072200200529      * can be used between this module and the one that read the MQ queue.
072300200529      * This module needs to break these 500A fields by loading them into
072400200529      * the appropriate (externally described) data structure.
072500200529     C                   MOVEL     Trans5001     TranInPrim
072600200529     C                   MOVEL     Trans5002     TranInSeco
072700200529     C                   MOVEL     Trans5003     TranInExch
072800200529     C                   MOVEL     Trans5004     TranInSett
072900200529     C                   MOVEL     Trans5005     TranInChCm
073000200529     C                   MOVEL     Trans5006     TranInSwfA
073100200529     C                   MOVEL     Trans5007     TranInSwfB
073200200529     C                   MOVEL     Trans5008     TranInThir                                   CAS006
073300200529     C                   MOVEL     Infdata500    Infdata                        CAP051
073400200529     C                   MOVEL     Extdata500    Extdata                        CAP004
073500200529     C                   MOVEL     RegData500    RegData                                      CER001
073600200529     C**********         MOVEL     OthDData4755  OthDData                             CSE045 CSF011A
073700200529     C                   MOVEL     OthrData      OthDData                                    CSF011A
073800200529     C                   MOVEL     TranInExt1    TranInExtA                                   CSE045
073900200529     C                   MOVEL     TranInExt2    TranInExtB                                   CSE045
074000200529
074100200529      ** Generate a timestamp for this transaction
074200200529
074300200529     C                   CALLB     'ZAGENTMSTM'
074400200529     C                   PARM                    TimeStamp
074500200529
074600200529      * Reset variables gradually updated
074700200529
074800200529     C                   EXSR      RESETCYCLE
074900200529
075000200529      /COPY WNCPYSRC,SETRADC002
075100200529
075200200529      *  Check if valid trade exists for Front Office ID
075300200529
075400200529     C                   EXSR      ChkValTrad
075500200529      *
075600200529      *  If valid trade does exist (even after delay), fail this input
075700200529      *
075800200529     C     Idx           IFNE      0
075900200529     C                   GOTO      INVALID
076000200529     C                   END
076100200529                                                                                CAP013
076200200529      *  Check if valid trade exists for Midas Trade Ref                        CAP013
076300200529                                                                                CAP013
076400200529     C                   EXSR      ChkValMiTR                                   CAP013
076500200529      *                                                                         CAP013
076600200529      *  If valid trade does exist (even after delay), fail this input          CAP013
076700200529      *                                                                         CAP013
076800200529     C     Idx           IFNE      0                                            CAP013
076900200529     C                   GOTO      INVALID                                      CAP013
077000200529     C                   END                                                    CAP013
077100200529
077200200529      * Reset variables again in case the details have been corrupted
077300200529      * by previous chain to valid trades file.
077400200529
077500200529     C                   EXSR      RESETCYCLE
077600200529
077700200529      /COPY WNCPYSRC,SETRADC003
077800200529
077900200529      *  Validate Action Code
078000200529
078100200529     C                   EXSR      ValidateAc
078200200529      *
078300200529      /COPY WNCPYSRC,SETRADC004
078400200529
078500200529      *  If error in validation of action code, fail this input
078600200529      *
078700200529     C     Idx           IFNE      0
078800200529     C                   GOTO      INVALID
078900200529     C                   END
079000200529
079100200529      *  Processing depends upon Action Code
079200200529
079300200529     C                   SELECT
079400200529
079500200529     C                   WHEN         DDACTN = 'I'
079600200529      *  Processing for Inserts
079700200529      /COPY WNCPYSRC,SETRADC005
079800200529     C                   EXSR      ValidateTr
079900200529      /COPY WNCPYSRC,SETRADC006
080000200529
080100200529     C                   WHEN         DDACTN = 'A'
080200200529     C                             OR DDACTN = 'C'
080300200529      *  Processing for Amends or Changes
080400200529      /COPY WNCPYSRC,SETRADC007
080500200529     C     GHSUBS        ifne      *blank                                       CAP011
080600200529     C     GHSUBS        scan      TranInPrim                             99    CAP011
080700200529     C  N99GHSUBS        scan      TranInSeco                             99    CAP011
080800200529     C  N99GHSUBS        scan      TranInThir                             99                  CAS006
080900200529     C  N99GHSUBS        scan      TranInExch                             99    CAP011
081000200529     C  N99GHSUBS        scan      TranInSett                             99    CAP011
081100200529     C  N99GHSUBS        scan      TranInChCm                             99    CAP011
081200200529     C  N99GHSUBS        scan      TranInSwfA                             99    CAP011
081300200529     C  N99GHSUBS        scan      TranInSwfB                             99    CAP011
081400200529     C     *in99         ifeq      *on                                          CAP011
081500200529     C                   EXSR      TDtDtaSubs                                   CAP011
081600200529     C                   endif                                                  CAP011
081700200529     C                   endif                                                  CAP011
081800200529     C                   EXSR      SetupAmd
081900200529      /COPY WNCPYSRC,SETRADC008
082000200529     C                   EXSR      ValidateTr
082100200529      /COPY WNCPYSRC,SETRADC009
082200200529     C                   EXSR      ValdateAmd
082300200529      /COPY WNCPYSRC,SETRADC010
082400200529
082500200529     C                   ENDSL
082600200529      *
082700200529     C     INVALID       TAG
082800200529
082900200529      *  Check for exception error from any program lower in the stack
083000200529      *  If error detected, send message to system operator and
083100200529      *  return to calling program without updating database or
083200200529      *  prompting the database update program
083300200529     C                   IN        APDUMP
083400200529      /COPY WNCPYSRC,SETRADC011
083500200529
083600200529     C     ARERRMOD      IFNE      *BLANK
083700200529     C                   EVAL      MQErrlong  = *blank
083800200529     C                   MOVEL     ProcErr       MQError
083900200529     C                   MOVE      ARERRMOD      MQError          28
084000200529     C                   MOVEL     MQError       MQErrlong
084100200529
084200200529     C                   CALLB     'ZAMSGTOOPR'
084300200529     C                   PARM                    MQReturn         10
084400200529     C                   PARM                    MQErrlong       132
084500200529     C                   PARM                    DummyMsgID
084600200529     C                   PARM                    DummyMsgF
084700200529
084800200529     C                   MOVEL     ARERRMOD      APRETCODE
084900200529     C     *LOCK         IN        APDUMP
085000200529     C                   EVAL      ARERRMOD = *BLANK
085100200529     C                   OUT       APDUMP
085200200529     C                   RETURN
085300200529
085400200529     C                   ELSE
085500200529
085600200529      *  Processing for Error checking/write to database
085700200529      /COPY WNCPYSRC,SETRADC012
085800200529      *                                                                                       CER001
085900200529     C                   IF        ULX603 = 'Y'                                               CER001
086000200529      *                                                                                       CER001
086100200529     C                   MOVE      *ALL'Y'       OkFlagsExt                                   CER001
086200200529      *                                                                                       CER001
086300200529      ** Validate the extension transaction details                                           CER001
086400200529      *                                                                                       CER001
086500200529     C                   Z-ADD     V_TDVD        #1TDVD                                       CER001
086600200529     C                   Z-ADD     V_TDDT        #1TDDT                                       CER001
086700200529     C                   Z-ADD     0             #1ISSD                                       CER001
086800200529     C                   Z-ADD     0             #1MATY                                       CER001
086900200529     C                   IF        Idx = *ZERO                                                CER001
087000200529     C                   Z-ADD     ISSD          #1ISSD                                       CER001
087100200529     C                   Z-ADD     MATY          #1MATY                                       CER001
087200200529     C                   ENDIF                                                                CER001
087300200529      *                                                                                       CER001
087400200529     C                   CALLB     'SETRAD2VL'                                                CER001
087500200529     C                   PARM                    DDACTN                                       CER001
087600200529     C                   PARM                    DATALUX                                      CER001
087700200529     C                   PARM                    RegData                                      CER001
087800200529     C                   PARM                    OkFlagsExt                                   CER001
087900200529     C                   PARM                    FldNameArr                                   CER001
088000200529     C                   PARM                    MsgIdArr                                     CER001
088100200529     C                   PARM                    MsgDtaArr                                    CER001
088200200529     C                   PARM                    Idx                                          CER001
088300200529     C                   PARM                    WFldNamArr                                   CER001
088400200529     C                   PARM                    WMsgIdArr                                    CER001
088500200529     C                   PARM                    WMsgDtaArr                                   CER001
088600200529     C                   PARM                    WIdx                                         CER001
088700200529     C                   PARM                    ValidFilExt                                  CER001
088800200529     C                   PARM                    ULX008                                       CER001
088900200529      *                                                                                       CER001
089000200529      *                                                                                       CER001
089100200529      ** No Errors, write in valid file                                                       CER001
089200200529      *                                                                                       CER001
089300200529     C                   IF        Idx = 0                                                    CER001
089400200529      *                                                                                       CER001
089500200529     C                   IF        DDACTN = 'I'                                               CER001
089600200529     C                   EXSR      SETUPTRADR                                                 CER001
089700200529     C                   ENDIF                                                                CER001
089800200529      *                                                                                       CER001
089900200529     C                   EVAL      #6LXCCTDRF = V_TDRF                                        CER001
090000200529     C                   EVAL      #6LXCCFOTR = APFOTranID                                    CER001
090100200529     C                   EVAL      #6LXCCTMES = Timestamp                                     CER001
090200200529     C                   WRITE     SEVTDLXD6                                                  CER001
090300200529      *                                                                                       CER001
090400200529     C                   ENDIF                                                                CER001
090500200529      *                                                                                       CER001
090600200529      ** Errors, write in invalid file                                                        CER001
090700200529      ** Only write to invalid files if repair in back office                                 CER001
090800200529      *                                                                                       CER001
090900200529     C                   IF        Idx > 0                                                    CER001
091000200529     C                             AND APRprLocn =  'B'                                       CER001
091100200529     C                   EVAL      #6LXFOTR = APFOTranID                                      CER001
091200200529     C                   EVAL      #6LXTIME = TimeStamp                                       CER001
091300200529     C                   WRITE     SEITDLXD6                                                  CER001
091400200529     C                   ENDIF                                                                CER001
091500200529     C                   ENDIF                                                                CER001
091600200529     C                   EXSR      CheckWrite
091700200529      /COPY WNCPYSRC,SETRADC013
091800200529
091900200529      *  If valid, send data queue entry to prompt DB update program
092000200529     C     Idx           IFEQ      0
092100200529     C                   EVAL      ObjType = '*DTAARA'
092200200529      *  Check if update program active using Allocate Object API
092300200529      *  No prompting necessary if program is running
092400200529     C                   CALLB     'APCALCOBJ'
092500200529     C                   PARM                    Object
092600200529     C                   PARM                    Lib
092700200529     C                   PARM                    ObjType
092800200529     C                   PARM                    LockState
092900200529     C                   PARM                    Member
093000200529     C                   PARM                    WaitTime
093100200529     C                   PARM                    Dlcobj
093200200529     C                   PARM      *BLANK        Return
093300200529
093400200529     C     Return        IFEQ      *BLANK
093500200529
093600200529      **--------------------------------------------------------------------------------------------
093700200529      ** The following /COPY line includes a check for whether there
093800200529      ** are messages on the server/updater data queue, and sends a 'GO'.
093900200529      ** message to the data queue if there are not.
094000200529     D/COPY ZACPYSRC,DTAQCHK
094100200529      **--------------------------------------------------------------------------------------------
094200200529
094300200529     C                   ENDIF
094400200529     C                   ENDIF
094500200529     C                   ENDIF
094600200529
094700200529     C                   RETURN
094800200529
094900200529      * Hook to enable non-core subroutines to be included
095000200529      /COPY WNCPYSRC,SETRADC018
095100200529
095200200529      *****************************************************************
095300200529      /EJECT
095400200529      *****************************************************************
095500200529      *                                                               *
095600200529      * ChkValTrad - Routine to check if valid trade exists           *
095700200529      * for Front Office ID                                           *
095800200529      *                                                               *
095900200529      *****************************************************************
096000200529     C     ChkValTrad    BEGSR
096100200529
096200200529      * Check for trade on Valid file
096300200529     C     APFOTranID    CHAIN     SEVTRADL0                          99
096400200529
096500200529      * If record found...
096600200529     C     *IN99         IFEQ      '0'
096700200529
096800200529      * ..delay, then repeat check
096900200529     C                   CALLB     'ZACDELAY'
097000200529
097100200529     C     APFOTranID    CHAIN     SEVTRADL0                          99
097200200529
097300200529      * Error if still present
097400200529     C     *IN99         IFEQ      '0'
097500200529     C                   ADD       1             Idx
097600200529     C                   EVAL      FldNameArr(Idx) = 'DDTDRF'
097700200529     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
097800200529     C                   ENDIF
097900200529     C                   ENDIF
098000200529
098100200529     C                   ENDSR
098200200529      *****************************************************************
098300200529      /EJECT                                                                    CAP013
098400200529      *****************************************************************         CAP013
098500200529      *                                                               *         CAP013
098600200529      * ChkValMiTR - Routine to check if valid trade exists for       *         CAP013
098700200529      *    Midas Trade Reference                                      *         CAP013
098800200529      *                                                               *         CAP013
098900200529      *****************************************************************         CAP013
099000200529                                                                                CAP013
099100200529     C     ChkValMiTR    BEGSR                                                  CAP013
099200200529                                                                                CAP013
099300200529      * If (numeric) Midas Trade Reference supplied                             CAP013
099400200529                                                                                CAP013
099500200529     C                   TESTN                   DDTDRF               9898      CAP013
099600200529                                                                                CAP013
099700200529     C     DDTDRF        IFNE      *BLANKS                                      CAP013
099800200529     C     *IN98         ANDEQ     '1'                                          CAP013
099900200529                                                                                CAP013
100000200529      * Check for trade on Valid file                                           CAP013
100100200529     C                   MOVEL     DDTDRF        TDRF                           CAP013
100200200529     C     TDRF          CHAIN     SEVTRADL1                          99        CAP013
100300200529                                                                                CAP013
100400200529      * If record found...                                                      CAP013
100500200529     C     *IN99         IFEQ      '0'                                          CAP013
100600200529                                                                                CAP013
100700200529      * ..delay, then repeat check                                              CAP013
100800200529     C                   CALLB     'ZACDELAY'                                   CAP013
100900200529                                                                                CAP013
101000200529     C     TDRF          CHAIN     SEVTRADL1                          99        CAP013
101100200529                                                                                CAP013
101200200529      * Error if still present                                                  CAP013
101300200529     C     *IN99         IFEQ      '0'                                          CAP013
101400200529     C                   ADD       1             Idx                            CAP013
101500200529     C                   EVAL      FldNameArr(Idx) = 'DDTDRF'                   CAP013
101600200529     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
101700200529     C                   ENDIF                                                  CAP013
101800200529     C                   ENDIF                                                  CAP013
101900200529                                                                                CAP013
102000200529     C                   ENDIF                                                  CAP013
102100200529      *                                                                         CAP013
102200200529     C                   ENDSR                                                  CAP013
102300200529      *****************************************************************         CAP013
102400200529      /EJECT
102500200529      *****************************************************************
102600200529      *                                                               *
102700200529      * ValidateAc - Routine to validate action code versus the       *
102800200529      *    transaction IDs supplied                                   *
102900200529      *                                                               *
103000200529      *****************************************************************
103100200529     C     ValidateAc    BEGSR
103200200529      *                                                                         CAP013
103300200529      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
103400200529      *  if insert                                                              CAP013
103500200529      *  if not insert and Midas transaction ID is not present                  CAP013
103600200529      * Otherwise                                                               CAP013
103700200529      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
103800200529      *                                                                         CAP013
103900200529     C     DDACTN        IFEQ      'I'                                          CAP013
104000200529     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
104100200529     C                   ELSE                                                   CAP013
104200200529     C     DDTDRF        IFEQ      *BLANK                                       CAP013
104300200529     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
104400200529     C                   ELSE                                                   CAP013
104500200529     C                   MOVEL     '      '      ModeofOp                       CAP013
104600200529     C                   ENDIF                                                  CAP013
104700200529     C                   ENDIF                                                  CAP013
104800200529
104900200529      * Validate action code versus transaction IDs supplied
105000200529      * This function will set the Midas trade reference
105100200529      * The trade in file format from the SE database is retrieved as well.
105200200529
105300200529     C                   RESET                   ReturnCode
105400200529     C                   CALLB     'SETRADRTV'
105500200529      *
105600200529      * INPUTS
105700200529      *
105800200529      * Return code
105900200529     C                   PARM                    ReturnCode
106000200529      *
106100200529      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
106200200529      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
106300200529      *
106400200529     C*******************PARM      '*FRONT'      ModeofOp          6            CAP013
106500200529     C                   PARM                    ModeofOp          6            CAP013
106600200529      *
106700200529      * Response mode
106800200529     C                   PARM                    APRESPMODE
106900200529      *
107000200529      * Action Code
107100200529     C                   PARM                    DDACTN            1
107200200529      *
107300200529      * Front Office Transaction ID
107400200529     C                   PARM                    APFOTranID
107500200529      *
107600200529      * (Midas) Trade Reference
107700200529     C                   PARM                    DDTDRF            6
107800200529      *                                                                         154562
107900200529      * MT5XX - Phase 2 Message Generation is on.                               154562
108000200529     C                   PARM                    CSW003            1            154562
108100200529      *                                                                                       CAP067
108200200529      * Buy-sell back                                                                         CAP067
108300200529     C                   PARM                    PFBYSL            1                          CAP067
108400200529      *                                                                                       CAP067
108500200529      * Trade Reference                                                                       CAP067
108600200529     C                   PARM                    PFTDRF            6                          CAP067
108700200529      *
108800200529      * OUTPUTS
108900200529      *
109000200529      * (Current) trade in file format
109100200529      * (Current) trade extension in file format
109200200529     C                   PARM                    TradFilFmt
109300200529     C                   PARM                    TX1AFilFmt
109400200529     C                   PARM                    TX1BFilFmt
109500200529      *
109600200529      * OK - Action code
109700200529     C                   PARM                    DDActnOK          1
109800200529      *
109900200529      * OK - Trade Reference
110000200529     C                   PARM                    DDTdrfOK          1
110100200529      *
110200200529      * Error fields/message IDs/message data (arrays) from/to caller
110300200529     C                   PARM                    FldNameArr
110400200529     C                   PARM                    MsgIdArr
110500200529     C                   PARM                    MsgDtaArr
110600200529      *
110700200529      * Array index (3P0) from/to caller
110800200529     C                   PARM                    Idx
110900200529
111000200529      **   Move book from file to work field for later checking.                              193462
111100200529      *                                                                                       193462
111200200529     C                   MOVE      V_TDBK        OLDBK1            2                          193462
111300200529     C                   MOVE      *BLANK        WARNIND           1                          193462
111400200529      *                                                                                       193462
111500200529     C                   ENDSR
111600200529      *****************************************************************
111700200529      /EJECT
111800200529      *****************************************************************
111900200529      *                                                               *
112000200529      * SETUPAMD - Set up fields that are needed in the validation    *
112100200529      *    of amendments and changes.                                 *
112200200529      *                                                               *
112300200529      *****************************************************************
112400200529     C     SetupAmd      BEGSR
112500200529
112600200529      * For Amends, put the complete (pre-existing) trade into the Valid
112700200529      *  file record - fields in this will be updated during processing
112800200529
112900200529     C                   MOVE      TradFilFmt    ValidTrad
113000200529     C                   MOVE      TX1AFilFmt    ValidTX1A
113100200529     C                   MOVE      TX1BFilFmt    ValidTX1B
113200200529
113300200529      * For Amends, convert the trade to screen format
113400200529
113500200529     C                   CALLB     'SETRADCVT'
113600200529      *
113700200529      * INPUTS
113800200529      *
113900200529      * Return Code
114000200529     C                   PARM                    RetCodeIn
114100200529      *
114200200529      * Trade - file formats
114300200529     C                   PARM                    ValidTrad
114400200529     C                   PARM                    ValidTX1A
114500200529     C                   PARM                    ValidTX1B
114600200529                                                                                              CAS006
114700200529      ** Hedge Accounting Phase B                                                             CAS006
114800200529                                                                                              CAS006
114900200529     C                   PARM                    CAS006                                       CAS006
115000200529      * CGL031 Switchable Feature                                                             CGL031
115100200529     C                   PARM                    CGL031                                       CGL031
115200200529      *
115300200529      * Output parameters
115400200529      *
115500200529      * Trade - screen formats
115600200529     C                   PARM                    CurTrPrim
115700200529     C                   PARM                    CurTrSeco
115800200529     C                   PARM                    CurTrThir                                    CAS006
115900200529     C                   PARM                    CurTrExch
116000200529     C                   PARM                    CurTrSett
116100200529     C                   PARM                    CurTrChCm
116200200529     C                   PARM                    CurTrSwftA
116300200529     C                   PARM                    CurTrSwftB
116400200529
116500200529      ** Security Details
116600200529      ** Investment Type Details
116700200529     C                   PARM                    SECTY
116800200529     C                   PARM                    INVTP
116900200529
117000200529      ** Nominal Currency Details
117100200529     C                   PARM                    NomCcyDts
117200200529
117300200529      ** Settlement Currency Details
117400200529     C                   PARM                    SetCcyDts
117500200529      *
117600200529      ** Customer (Counterparty) Details
117700200529     C                   PARM                    CustDts
117800200529      *
117900200529      * Trade Status
118000200529      * Trade Authorized/Not Authorized
118100200529     C                   PARM                    DDSTAT            9
118200200529     C                   PARM                    DDAUTH           14                           S0126
118300200529      * Security report name
118400200529      * Customer report name
118500200529     C**********         PARM                    DDSRPN           20                          CSE016
118600200529     C                   PARM                    DDSRNME          41                          CSE016
118700200529     C                   PARM                    DDCRNM           20
118800200529
118900200529      * Coupon Rate
119000200529      * Current Factor
119100200529      * Margin Amount
119200200529      * Portfolio Exchange Rate
119300200529      * Portfolio M/D Ind
119400200529      * Trade Countervalue
119500200529     C                   PARM                    DDCPNR           13
119600200529     C                   PARM                    DDCFCT           12
119700200529     C                   PARM                    DDMAMT           18
119800200529     C                   PARM                    DDSPXR           14
119900200529     C                   PARM                    DDSPMD            1
120000200529     C                   PARM                    DDTCTR           21
120100200529     C                   PARM                    DDWTAX                         CSE023
120200200529     C                   PARM                    DDPRICN                                      CAS006
120300200529
120400200529      * SCREEN A
120500200529      * Destination of Settlement
120600200529      * Destination of Confirmation
120700200529     C                   PARM                    A_DDROUS          6
120800200529     C                   PARM                    A_DDROTS         12
120900200529     C                   PARM                    A_DDROUC          6
121000200529     C                   PARM                    A_DDROTC         12
121100200529
121200200529      * SCREEN B
121300200529      * Destination of Settlement
121400200529      * Destination of Confirmation
121500200529     C                   PARM                    B_DDROUS          6
121600200529     C                   PARM                    B_DDROTS         12
121700200529     C                   PARM                    B_DDROUC          6
121800200529     C                   PARM                    B_DDROTC         12
121900200529     C                   PARM                    DDFRNT                                    AR698195B
122000200529
122100200529      *  Certain groups of fields on the trade may not be supplied for an
122200200529      *  amendment. If none of the fields in each group were supplied
122300200529      *  (i.e. all are blank), default the existing database values ...
122400200529
122500200529     C                   IF            (TranInExch = *blank)
122600200529     C                   EVAL      TranInExch = CurTrExch
122700200529     C                   ENDIF
122800200529
122900200529     C                   IF            (TranInSett = *blank)
123000200529     C                   EVAL      TranInSett = CurTrSett
123100200529     C                   ENDIF
123200200529
123300200529     C                   IF            (TranInChCm = *blank)
123400200529     C                   EVAL      TranInChCm = CurTrChCm
123500200529     C                   ENDIF
123600200529
123700200529     C                   IF            (TranInSwfA = *blank)
123800200529     C                   EVAL      TranInSwfA = CurTrSwftA
123900200529     C                   ENDIF
124000200529
124100200529     C                   IF            (TranInSwfB = *blank)
124200200529     C                   EVAL      TranInSwfB = CurTrSwftB
124300200529     C                   ENDIF
124400200529
124500200529
124600200529     C                   ENDSR
124700200529      *****************************************************************
124800200529      /EJECT
124900200529      *****************************************************************
125000200529      *                                                               *
125100200529      * ValidateTr - Routine to validate the main tranaction details  *
125200200529      *                                                               *
125300200529      *****************************************************************
125400200529     C     ValidateTr    BEGSR
125500200529
125600200529      * Validate Trade Primary details
125700200529
125800200529     C                   EXSR      ValdTrPrim
125900200529      *
126000200529      *  If error in validation, fail this input
126100200529      *
126200200529     C     Idx           IFNE      0
126300200529     C                   GOTO      EValidTr
126400200529     C                   END
126500200529
126600200529      * Validate Trade Secondary details
126700200529
126800200529     C                   EXSR      ValdTrSeco
126900200529      *
127000200529      *  If error in validation, fail this input
127100200529      *
127200200529     C     Idx           IFNE      0
127300200529     C                   GOTO      EValidTr
127400200529     C                   END
127500200529                                                                                              CAS006
127600200529      ** Validate more Trade details (third screen)                                           CAS006
127700200529                                                                                              CAS006
127800200529     C                   IF        CAS006 = 'Y'                                               CAS006
127900200529     C                   EXSR      ValdTrThir                                                 CAS006
128000200529                                                                                              CAS006
128100200529      ** If error in validation, fail this input                                              CAS006
128200200529                                                                                              CAS006
128300200529     C     Idx           IFNE      0                                                          CAS006
128400200529     C                   GOTO      EValidTr                                                   CAS006
128500200529     C                   ENDIF                                                                CAS006
128600200529     C                   ENDIF                                                                CAS006
128700200529
128800200529      * Default Trade Other details
128900200529      * (Exchange Rate, Settlement, Charges and Commissions)
129000200529      /COPY WNCPYSRC,SETRADC020                                                               CUT009
129100200529
129200200529     C                   EXSR      DfltTrOTH
129300200529
129400200529      /COPY WNCPYSRC,SETRADC021                                                               CUT009
129500200529      **CalcTrCHCM*-*Calculate*Trade*Charges/Commissions***************                       258901
129600200529      **********                                                                              258901
129700200529     C**********         EXSR      CalcTrCHCM                                                 258901
129800200529
129900200529
130000200529      * Validate Trade Other details
130100200529      * (Exchange Rate, Settlement, Charges and Commissions)
130200200529
130300200529     C                   EXSR      ValdTrOTH
130400200529                                                                                              258901
130500200529      * CalcTrCHCM - Calculate Trade Charges/Commissions                                      258901
130600200529                                                                                              258901
130700200529     C                   EXSR      CalcTrCHCM                                                 258901
130800200529      ** CalcTrEuTx - Calculate EU Tax                                                        233881
130900200529                                                                                              233881
131000200529     C     CGL031        IFEQ      'Y'                                                        233881
131100200529     C                   EXSR      CalcTrEUTX                                                 233881
131200200529     C                   ENDIF                                                                233881
131300200529
131400200529      * CalcTrCVAL - Calculate Trade Countervalue
131500200529
131600200529     C                   EXSR      CalcTrCVAL
131700200529                                                                                             BUG3145
131800200529      ** Additional validations                                                              BUG3145
131900200529      ** (Pay To Account)                                                                    BUG3145
132000200529                                                                                             BUG3145
132100200529     C                   IF        CGL014 = 'Y'  AND  V_PAYT <> *BLANKS                      BUG3145
132200200529     C                             AND  DDPAYTOK <> 'N'                                      BUG3145
132300200529     C                   EXSR      ValdTrAddl                                                BUG3145
132400200529     C                   ENDIF                                                               BUG3145
132500200529      *
132600200529      *  If error in validation, fail this input
132700200529      *
132800200529     C     Idx           IFNE      0
132900200529     C                   GOTO      EValidTr
133000200529     C                   END
133100200529      *
133200200529      * If MT5XX Message Generation are installed,
133300200529      *
133400200529     C     S01401        IFEQ      'Y'
133500200529
133600200529      * Default Trade Extension (SWIFT) 'A' details
133700200529
133800200529     C     TranInSwfA    IFEQ      *BLANK
133900200529     C     DDACTN        OREQ      'I'                                                        247873
134000200529      *                                                                                       247873
134100200529      ** Keep data-structure values if non-blank                                              247873
134200200529      *                                                                                       247873
134300200529     C                   IF        TranInSwfA <> *Blanks                                      247873
134400200529     C                   EVAL      TranInSwfI = TranInSwfA                                    247873
134500200529     C                   ENDIF                                                                247873
134600200529      *                                                                                       247873
134700200529     C                   EXSR      DfltTrSwfA
134800200529      *                                                                                       247873
134900200529      ** Restore values for non-blank fields                                                  247873
135000200529      *                                                                                       247873
135100200529     C                   IF        TranInSwfI <> *Blanks                                      247873
135200200529     C                   EVAL      TranInSwfO = TranInSwfA                                    247873
135300200529     C                   EXSR      RstrTrSwf1                                                 247873
135400200529     C                   EVAL      TranInSwfA = TranInSwfO                                    247873
135500200529      *                                                                                       247873
135600200529     C                   CLEAR                   TranInSwfI                                   247873
135700200529     C                   CLEAR                   TranInSwfO                                   247873
135800200529     C                   ENDIF                                                                247873
135900200529      *                                                                                       247873
136000200529     C                   END
136100200529                                                                                              CSE045
136200200529     C                   IF        CSE045 = 'N'                                               CSE045
136300200529                                                                                              210517
136400200529      ** Default fields for the TRADSDX2 file                                                 210517
136500200529                                                                                              210517
136600200529     C                   EXSR      SRDfltTrX2A                                                210517
136700200529     C                   ENDIF                                                                CSE045
136800200529
136900200529      * Validate Trade Extension (SWIFT) 'A' details
137000200529
137100200529     C                   EXSR      ValdTrSwfA
137200200529                                                                                              CSE045
137300200529     C                   IF        CSE045 = 'Y'                                               CSE045
137400200529      *                                                                                       CSE045
137500200529      ** Set up PDATA array fields for passing to SETSESVAL                                   CSE045
137600200529      *                                                                                       CSE045
137700200529     C                   EXSR      SetPDATA                                                   CSE045
137800200529      *                                                                                       CSE045
137900200529      ** Validate Trade Extended Settlements Details A                                        CSE045
138000200529      *                                                                                       CSE045
138100200529     C                   EVAL      PWHEN = 'A'                                                CSE045
138200200529     C                   IF        (DDACTN = 'I') and (TranInExtA = *BLANKS)                  CSE045
138300200529     C                   EVAL      DFTFLG = 'Y'                                               CSE045
138400200529     C                   ELSE                                                                 CSE045
138500200529     C                   EVAL      DFTFLG = 'N'                                               CSE045
138600200529     C                   ENDIF                                                                CSE045
138700200529     C                   EXSR      SRDefScn                                                   CSE045
138800200529     C                   IF        TranInExtA = *BLANKS                                       CSE045
138900200529     C                   EVAL      TranInExtA = NwSE1ScnFmt                                   CSE045
139000200529     C                   ENDIF                                                                CSE045
139100200529     C                   EXSR      ValdTrExSetA                                               CSE045
139200200529     C                   ENDIF                                                                CSE045
139300200529      *
139400200529      *  If error in validation, fail this input
139500200529      *
139600200529     C     Idx           IFNE      0
139700200529     C                   GOTO      EValidTr
139800200529     C                   END
139900200529      *
140000200529      ** If screen B is required
140100200529      *
140200200529     C     CSW003        IFEQ      'Y'
140300200529     C     CustClass     IFEQ      'S'
140400200529     C     V_DELT        ANDNE     V_DELF
140500200529     C     CustClass     OREQ      'D'
140600200529     C     V_DELT        ANDNE     V_DELF
140700200529
140800200529      * Default Trade Extension (SWIFT) 'B' details
140900200529
141000200529     C     TranInSwfB    IFEQ      *BLANK
141100200529     C     DDACTN        OREQ      'I'                                                        247873
141200200529      *                                                                                       247873
141300200529      ** Keep data-structure values if non-blank                                              247873
141400200529      *                                                                                       247873
141500200529     C                   IF        TranInSwfB <> *Blanks                                      247873
141600200529     C                   EVAL      TranInSwfI = TranInSwfB                                    247873
141700200529     C                   ENDIF                                                                247873
141800200529      *                                                                                       247873
141900200529     C                   EXSR      DfltTrSwfB
142000200529      *                                                                                       247873
142100200529      ** Restore values for non-blank fields                                                  247873
142200200529      *                                                                                       247873
142300200529     C                   IF        TranInSwfI <> *Blanks                                      247873
142400200529     C                   EVAL      TranInSwfO = TranInSwfB                                    247873
142500200529     C                   EXSR      RstrTrSwf1                                                 247873
142600200529     C                   EVAL      TranInSwfB = TranInSwfO                                    247873
142700200529      *                                                                                       247873
142800200529     C                   CLEAR                   TranInSwfI                                   247873
142900200529     C                   CLEAR                   TranInSwfO                                   247873
143000200529     C                   ENDIF                                                                247873
143100200529      *                                                                                       247873
143200200529     C                   END
143300200529                                                                                              CSE045
143400200529     C                   IF        CSE045 = 'N'                                               CSE045
143500200529                                                                                              210517
143600200529      ** Default fields for the TRADSDX2 file                                                 210517
143700200529                                                                                              210517
143800200529     C**********         EXSR      SRDfltTrX2A                                        210517 243119A
143900200529     C                   EXSR      SRDfltTrX2B                                               243119A
144000200529     C                   ENDIF                                                                CSE045
144100200529
144200200529      * Validate Trade Extension (SWIFT) 'B' details
144300200529
144400200529     C                   EXSR      ValdTrSwfB
144500200529     C                   IF        CSE045 = 'Y'                                               CSE045
144600200529     C                   EXSR      SETPDATA                                                   CSE045
144700200529     C                   EVAL      PWHEN = 'B'                                                CSE045
144800200529     C                   IF        (DDACTN = 'I') and (TranInExtB = *BLANKS)                  CSE045
144900200529     C                   EVAL      DFTFLG = 'Y'                                               CSE045
145000200529     C                   ELSE                                                                 CSE045
145100200529     C                   EVAL      DFTFLG = 'N'                                               CSE045
145200200529     C                   ENDIF                                                                CSE045
145300200529     C                   EXSR      SRDefScn                                                   CSE045
145400200529     C                   IF        TranInExtB = *BLANKS                                       CSE045
145500200529     C                   EVAL      TranInExtB = NwSE1ScnFmt                                   CSE045
145600200529     C                   ENDIF                                                                CSE045
145700200529     C                   EXSR      ValdTrExSetB                                               CSE045
145800200529     C                   ENDIF                                                                CSE045
145900200529      *
146000200529      *  If error in validation, fail this input
146100200529      *
146200200529     C     Idx           IFNE      0
146300200529     C                   GOTO      EValidTr
146400200529     C                   END
146500200529
146600200529     C                   END
146700200529     C                   END
146800200529
146900200529     C                   END
147000200529
147100200529     C     EValidTr      ENDSR
147200200529      *****************************************************************
147300200529      /EJECT
147400200529      *****************************************************************
147500200529      *                                                               *
147600200529      * ValdTrPrim - Validate Trade Primary details                   *
147700200529      *                                                               *
147800200529      *****************************************************************
147900200529     C     ValdTrPrim    BEGSR
148000200529
148100200529     C                   CALLB     'SETRADPVAL'
148200200529
148300200529      * INPUTS
148400200529
148500200529      * Response mode
148600200529     C                   PARM                    RespMode          1
148700200529
148800200529      ** Trade Primary Details
148900200529     C                   PARM                    TranInPrim
149000200529      * Custom Extra Data file data                                             CAP004
149100200529     C                   PARM                    ExtData                        CAP004
149200200529
149300200529      ** Trade settlement currency
149400200529     C                   PARM                    DDSETC            3
149500200529      *
149600200529      ** Default & Validate (Y or N)
149700200529     C                   PARM      'Y'           Default           1
149800200529     C                   PARM      'Y'           Validate          1
149900200529
150000200529      * Output details of original book.                                                      193462
150100200529     C                   PARM                    OLDBK1                                       193462
150200200529     C                   PARM                    WARNIND                                      193462
150300200529      *                                                                                       193462
150400200529      ** First Buy-sell back indicator                                                        CAP067
150500200529     C                   PARM                    PFBYSL            1                          CAP067
150600200529      *                                                                                       CAP067
150700200529      ** First Buy-sell book code                                                             CAP067
150800200529     C                   PARM                    PFBPBK            2                          CAP067
150900200529      *                                                                                       CAP067
151000200529      ** First Buy-sell counterparty                                                          CAP067
151100200529     C**********         PARM      *ZEROS        PFTCNR            6 0                 CAP067 CSD027
151200200529     C                   PARM      *BLANKS       PFTCNR            6                          CSD027
151300200529      *                                                                                       CAP067
151400200529      ** First Buy-sell trade type                                                            CAP067
151500200529     C                   PARM                    PFTDTP            2                          CAP067
151600200529      *                                                                                       CAP067
151700200529      ** First Buy-sell Value Date                                                            CAP067
151800200529     C                   PARM      *ZEROS        PFTDVD            5 0                        CAP067
151900200529      *                                                                                       CAP067
152000200529      ** First Buy-sell Security Shortname                                                    CAP067
152100200529     C                   PARM                    PFSESN           10                          CAP067
152200200529     C                   PARM                    CallFromVU                                   CAP087
152300200529      * OUTPUTS
152400200529
152500200529      ** Security Details
152600200529      ** Investment Type Details
152700200529     C                   PARM                    SECTY
152800200529     C                   PARM                    INVTP
152900200529
153000200529      * Coupon Rate
153100200529      * Current Factor
153200200529     C                   PARM                    DDCPNR           13
153300200529     C                   PARM                    DDCFCT           12
153400200529
153500200529      ** Nominal Currency Details
153600200529     C                   PARM                    NomCcyDts
153700200529      *
153800200529      ** Customer (Counterparty) Details
153900200529     C                   PARM                    CustDts
154000200529      *
154100200529      ** Portfolio Details
154200200529     C                   PARM                    PortDts
154300200529      ** Default basket for backup withholding                                  CSE023
154400200529     C                   PARM                    PDRBW                          CSE023
154500200529
154600200529      ** Trade Primary Details OK inds
154700200529     C                   PARM                    OKTrPrim
154800200529
154900200529      * Error fields/message IDs/message data (arrays) from/to caller
155000200529     C                   PARM                    FldNameArr
155100200529     C                   PARM                    MsgIDArr
155200200529     C                   PARM                    MsgDtaArr
155300200529      * Array index (3P0) from/to caller
155400200529     C                   PARM                    Idx
155500200529
155600200529      * Warning fields/message IDs/message data (arrays) from/to caller
155700200529     C                   PARM                    WFldNamArr
155800200529     C                   PARM                    WMsgIDArr
155900200529     C                   PARM                    WMsgDtaArr
156000200529      * Array index (3P0) from/to caller
156100200529     C                   PARM                    WIdx
156200200529
156300200529      * Valid Trade layout (DS) from/to caller
156400200529     C                   PARM                    ValidTrad
156500200529                                                                                              CPB002
156600200529      * PB Order Number                                                                       CPB002
156700200529     C                   PARM                    DDORDE                                       CPB002
156800200529
156900200529     C                   ENDSR
157000200529      *****************************************************************
157100200529      /EJECT
157200200529      *****************************************************************
157300200529      *                                                               *
157400200529      * ValdTrSeco - Validate Trade Secondary details                 *
157500200529      *                                                               *
157600200529      *****************************************************************
157700200529     C     ValdTrSeco    BEGSR
157800200529
157900200529     C                   CALLB     'SETRADSVAL'
158000200529
158100200529      * INPUTS
158200200529
158300200529      * Response mode
158400200529     C                   PARM                    RespMode          1
158500200529
158600200529      ** Trade Primary Details
158700200529      ** Trade Secondary Details
158800200529     C                   PARM                    TranInPrim
158900200529     C                   PARM                    TranInSeco
159000200529      * Custom Extra Data file data                                             CAP004
159100200529     C                   PARM                    ExtData                        CAP004
159200200529     C/COPY WNCPYSRC,SETRADCC01
159300200529      *
159400200529      ** Default & Validate (Y or N)
159500200529     C                   PARM      'Y'           Default
159600200529     C                   PARM      'Y'           Validate
159700200529
159800200529      ** Security Details
159900200529      ** Investment Type Details
160000200529     C                   PARM                    SECTY
160100200529     C                   PARM                    INVTP
160200200529
160300200529      ** Nominal Currency Details
160400200529     C                   PARM                    NomCcyDts
160500200529      *
160600200529      ** Customer (Counterparty) Details
160700200529     C                   PARM                    CustDts
160800200529      *                                                                                       CSE028
160900200529      ** MT5xx SSI (Phase 2)                                                                  CSE028
161000200529     C                   PARM                    CSE028                                       CSE028
161100200529      * CGL031 Switchable Feature                                                             CGL031
161200200529     C                   PARM                    CGL031                                       CGL031
161300200529      ** Current File Trade Date                                                              243776
161400200529     C**********         PARM                    C_TDVD                               243776 243776A
161500200529     C                   PARM                    TDVD                                        243776A
161600200529      *
161700200529      * OUTPUTS
161800200529      *
161900200529      ** Settlement Currency Details
162000200529     C                   PARM                    SetCcyDts
162100200529
162200200529      ** Trade Secondary Details OK inds
162300200529     C                   PARM                    OKTrSeco
162400200529
162500200529      * Error fields/message IDs/message data (arrays) from/to caller
162600200529     C                   PARM                    FldNameArr
162700200529     C                   PARM                    MsgIDArr
162800200529     C                   PARM                    MsgDtaArr
162900200529      * Array index (3P0) from/to caller
163000200529     C                   PARM                    Idx
163100200529
163200200529      * Warning fields/message IDs/message data (arrays) from/to caller
163300200529     C                   PARM                    WFldNamArr
163400200529     C                   PARM                    WMsgIDArr
163500200529     C                   PARM                    WMsgDtaArr
163600200529      * Array index (3P0) from/to caller
163700200529     C                   PARM                    WIdx
163800200529
163900200529      * Valid Trade layout (DS) from/to caller
164000200529     C                   PARM                    ValidTrad
164100200529
164200200529     C                   ENDSR
164300200529      *****************************************************************
164400200529      /EJECT
164500200529      *****************************************************************                       CAS006
164600200529      *                                                               *                       CAS006
164700200529      *  ValdTrThir - Validate Trade third screen details             *                       CAS006
164800200529      *                                                               *                       CAS006
164900200529      *****************************************************************                       CAS006
165000200529                                                                                              CAS006
165100200529     C     ValdTrThir    BEGSR                                                                CAS006
165200200529                                                                                              CAS006
165300200529     C                   CALLB     'SETRADTVAL'                                               CAS006
165400200529                                                                                              CAS006
165500200529      ** INPUTS                                                                               CAS006
165600200529      ** Response mode                                                                        CAS006
165700200529                                                                                              CAS006
165800200529     C                   PARM                    RespMode                                     CAS006
165900200529                                                                                              CAS006
166000200529      ** Trade Primary Details                                                                CAS006
166100200529      ** Trade Secondary Details                                                              CAS006
166200200529      ** Trade Third screen details                                                           CAS006
166300200529                                                                                              CAS006
166400200529     C                   PARM                    TranInPrim                                   CAS006
166500200529     C                   PARM                    TranInSeco                                   CAS006
166600200529     C                   PARM                    TranInThir                                   CAS006
166700200529                                                                                              CAS006
166800200529      ** Custom Extra Data file data                                                          CAS006
166900200529                                                                                              CAS006
167000200529     C                   PARM                    ExtData                                      CAS006
167100200529                                                                                              CAS006
167200200529      ** Default & Validate (Y or N)                                                          CAS006
167300200529                                                                                              CAS006
167400200529     C                   PARM      'Y'           Default                                      CAS006
167500200529     C                   PARM      'Y'           Validate                                     CAS006
167600200529                                                                                              CAS006
167700200529      ** Security Details                                                                     CAS006
167800200529      ** Investment Type Details                                                              CAS006
167900200529                                                                                              CAS006
168000200529     C                   PARM                    SECTY                                        CAS006
168100200529     C                   PARM                    INVTP                                        CAS006
168200200529                                                                                              CAS006
168300200529      ** Coupon Rate using NTR                                                                CAS006
168400200529      ** Net Treasury Price                                                                   CAS006
168500200529                                                                                              CAS006
168600200529     C                   PARM                    DDHACR                                       CAS006
168700200529     C                   PARM                    DDPRICN                                      CAS006
168800200529                                                                                              CAS006
168900200529      ** Customer (Counterparty) Details                                                      CAS006
169000200529      ** Portfolio Details                                                                    CAS006
169100200529      ** Nominal Currency Details                                                             CAS006
169200200529      ** Settlement Currency Details                                                          CAS006
169300200529                                                                                              CAS006
169400200529     C                   PARM                    CustDts                                      CAS006
169500200529     C                   PARM                    PortDts                                      CAS006
169600200529     C                   PARM                    NomCcyDts                                    CAS006
169700200529     C                   PARM                    SetCcyDts                                    CAS006
169800200529                                                                                              CAS006
169900200529      ** OUTPUTS                                                                              CAS006
170000200529                                                                                              CAS006
170100200529      ** Trade Third screen details OK inds                                                   CAS006
170200200529                                                                                              CAS006
170300200529     C                   PARM                    OKTrThir                                     CAS006
170400200529                                                                                              CAS006
170500200529      ** Error fields/message IDs/message data (arrays) from/to caller                        CAS006
170600200529                                                                                              CAS006
170700200529     C                   PARM                    FldNameArr                                   CAS006
170800200529     C                   PARM                    MsgIDArr                                     CAS006
170900200529     C                   PARM                    MsgDtaArr                                    CAS006
171000200529                                                                                              CAS006
171100200529      ** Array index (3P0) from/to caller                                                     CAS006
171200200529                                                                                              CAS006
171300200529     C                   PARM                    Idx                                          CAS006
171400200529                                                                                              CAS006
171500200529      ** Warning fields/message IDs/message data (arrays) from/to caller                      CAS006
171600200529                                                                                              CAS006
171700200529     C                   PARM                    WFldNamArr                                   CAS006
171800200529     C                   PARM                    WMsgIDArr                                    CAS006
171900200529     C                   PARM                    WMsgDtaArr                                   CAS006
172000200529                                                                                              CAS006
172100200529      ** Array index (3P0) from/to caller                                                     CAS006
172200200529                                                                                              CAS006
172300200529     C                   PARM                    WIdx                                         CAS006
172400200529                                                                                              CAS006
172500200529      ** Valid Trade layout (DS) from/to caller                                               CAS006
172600200529                                                                                              CAS006
172700200529     C                   PARM                    ValidTrad                                    CAS006
172800200529                                                                                              CAS006
172900200529     C                   ENDSR                                                                CAS006
173000200529                                                                                              CAS006
173100200529      *****************************************************************                       CAS006
173200200529      /EJECT                                                                                  CAS006
173300200529      *****************************************************************
173400200529      *                                                               *
173500200529      * DfltTrOTH - Default Trade Other details                       *
173600200529      *                                                               *
173700200529      *****************************************************************
173800200529     C     DfltTrOTH     BEGSR
173900200529
174000200529      ** EXCHANGE RATE DEFAULTING
174100200529
174200200529     C     DDACTN        IFEQ      'I'
174300200529     C     DDACTN        OREQ      'C'
174400200529     C     DDSETC        ANDNE     SETC
174500200529
174600200529     C                   CALLB     'SETEXCHDFT'
174700200529
174800200529      * INPUTS
174900200529      *
175000200529      ** Nominal Currency
175100200529      ** Settlement Currency
175200200529     C                   PARM                    NMCY              3
175300200529     C                   PARM                    DDSETC            3
175400200529
175500200529      ** Nominal Currency Details
175600200529      ** Settlement Currency Details
175700200529     C                   PARM                    NomCcyDts
175800200529     C                   PARM                    SetCcyDts
175900200529      ** ICD
176000200529      ** Euro Currency
176100200529      ** EMU SE Settlement Ccy Conv.
176200200529     C                   PARM                    BKEURO            3
176300200529     C                   PARM                    CEU005            1
176400200529
176500200529      * OUTPUTS
176600200529
176700200529      ** Trade Exchange Rate screen fields
176800200529
176900200529     C                   PARM                    TranInExch
177000200529
177100200529      ** Trade Exchange Rate file fields
177200200529
177300200529     C                   PARM                    V_TDER           13 8
177400200529     C                   PARM                    V_TMDI            1
177500200529     C                   PARM                    V_TBCR           13 8
177600200529
177700200529     C                   END
177800200529
177900200529      ** SETTLEMENT INSTRUCTION DEFAULTING
178000200529
178100200529     C     DDACTN        IFEQ      'I'
178200200529
178300200529     C                   CALLB     'SETSETIDFT'
178400200529
178500200529      * INPUTS
178600200529
178700200529      ** Booking branch
178800200529      ** Incomplete Ind
178900200529      ** Trade Type
179000200529      ** Settlement Currency
179100200529      ** Market Ind.
179200200529      ** Book Code.                                                                           CSE028
179300200529      ** Market Centre                                                                        CSE034
179400200529     C                   PARM                    DDBRCD            3
179500200529     C                   PARM                    DDINCS            1
179600200529     C                   PARM                    DDTDTP            2
179700200529     C                   PARM                    DDSETC            3
179800200529     C                   PARM                    DDTDMI            1
179900200529     C                   PARM                    DDBPBK                                       CSE028
180000200529     C                   PARM                    DDMRKT                                       CSE034
180100200529
180200200529      ** Investment type (SECTYD)
180300200529
180400200529     C                   PARM                    SITP              3
180500200529
180600200529      ** Nominal Currency Details
180700200529      ** Settlement Currency Details
180800200529     C                   PARM                    NomCcyDts
180900200529     C                   PARM                    SetCcyDts
181000200529
181100200529      ** Customer (Counterparty) Details
181200200529      ** ( Note: Customer Participant/Non-participant Indicator 1 and
181300200529      **  Customer Participant/Non-participant Indicator 2 are also outputs)
181400200529     C                   PARM                    CustDts
181500200529
181600200529
181700200529      ** ICD
181800200529      ** Depot 1 (Eurclear)
181900200529      ** Depot 2 (Cedel)
182000200529     C                   PARM                    BVDR1             6
182100200529     C                   PARM                    BVDR2             6
182200200529      *                                                                                       CSE028
182300200529      ** MT5xx SSI (Phase 2)                                                                  CSE028
182400200529     C                   PARM                    CSE028                                       CSE028
182500200529
182600200529      * OUTPUTS
182700200529
182800200529      ** Trade Settlement Instructions
182900200529
183000200529     C                   PARM                    TranInSett
183100200529                                                                                              244115
183200200529      ** Set clearance type field from invalid file.                                          244115
183300200529     C                   EVAL      DDCLTY = DDCLTY2                                           244115
183400200529
183500200529     C                   END
183600200529
183700200529      ** CHARGE/COMMISSION DEFAULTING
183800200529
183900200529     C     DDACTN        IFEQ      'I'
184000200529     C     DDACTN        OREQ      'A'
184100200529     C     DDACTN        OREQ      'C'
184200200529
184300200529     C                   CALLB     'SETCHCMDFT'
184400200529
184500200529      * INPUTS
184600200529
184700200529      ** Bulk reference
184800200529      ** Incomplete Ind.
184900200529      ** Market Centre
185000200529     C                   PARM                    DDBLKR            6
185100200529     C                   PARM                    DDINCS            1
185200200529     C                   PARM                    DDMRKT            2
185300200529      *
185400200529      ** Trade Counterparty
185500200529     C                   PARM                    TCNR
185600200529      *
185700200529      ** Security details
185800200529     C                   PARM                    SECTY
185900200529      *
186000200529      ** Nominal Currency Details
186100200529     C                   PARM                    NomCcyDts
186200200529      *
186300200529      ** Customer (Counterparty) Details
186400200529     C                   PARM                    CustDts
186500200529      *
186600200529      ** Portfolio Details
186700200529     C                   PARM                    PortDts
186800200529      *
186900200529      ** ICD
187000200529      ** PM installed
187100200529      ** Bank Portfolios installed
187200200529      ** Ref applied to 9997 portfolio
187300200529      ** Autocharge Option
187400200529      ** Adjust Commission Same Day T
187500200529      ** Priority of Cust Grp Dft
187600200529      ** Priority of Invst typ Dft
187700200529      ** Priority of Market Dft
187800200529      ** Priority of Cust Chrg Dft
187900200529      ** Midas/TOF I/F installed
188000200529     C                   PARM                    BGPFMG            1
188100200529     C                   PARM                    FCPORS            1
188200200529     C                   PARM                    FCR997            4
188300200529     C                   PARM                    BVACOP            1
188400200529     C                   PARM                    BVACSD            1
188500200529     C                   PARM                    BVPCSD            1
188600200529     C                   PARM                    BVPIDF            1
188700200529     C                   PARM                    BVPMDF            1
188800200529     C                   PARM                    BVPOCD            1
188900200529     C                   PARM                    S01496            1
189000200529     C****************** PARM                    CAP050            1            CPB001
189100200529     C                   PARM                    BGN4ST            1            CPB001
189200200529
189300200529      * OUTPUTS
189400200529
189500200529      ** Commission Rebate %
189600200529     C                   PARM                    CMRP              5 3
189700200529
189800200529      ** Trade Charges & Commissions screen fields
189900200529
190000200529     C                   PARM                    TranInChcm
190100200529
190200200529      ** Trade Charges & Commissions file fields
190300200529
190400200529     C                   PARM                    V_TBCC            2
190500200529     C                   PARM                    V_TCCC            2
190600200529     C                   PARM                    V_TCC1            2
190700200529     C                   PARM                    V_TCC2            2
190800200529
190900200529     C                   END
191000200529
191100200529     C                   ENDSR
191200200529      *****************************************************************
191300200529      /EJECT
191400200529      *****************************************************************
191500200529      *                                                               *
191600200529      * ValdTrOTH - Validate Trade Other details                      *
191700200529      *                                                               *
191800200529      *****************************************************************
191900200529     C     ValdTrOTH     BEGSR
192000200529
192100200529     C                   CALLB     'SETRADOVAL'
192200200529
192300200529      * INPUTS
192400200529
192500200529      * Response mode
192600200529     C                   PARM                    RespMode          1
192700200529
192800200529      ** Trade Primary Details
192900200529      ** Trade Secondary Details
193000200529      ** Trade Exchange Rates
193100200529      ** Trade Settlement Instructions
193200200529      ** Trade Charge & Commissions
193300200529     C                   PARM                    TranInPrim
193400200529     C                   PARM                    TranInSeco
193500200529     C                   PARM                    TranInExch
193600200529     C                   PARM                    TranInSett
193700200529     C                   PARM                    TranInChcm
193800200529      * Custom Extra Data file data                                             CAP004
193900200529     C                   PARM                    ExtData                        CAP004
194000200529
194100200529      ** Security Details
194200200529      ** Investment Type Details
194300200529     C                   PARM                    SECTY
194400200529     C                   PARM                    INVTP
194500200529      *
194600200529      ** Customer (Counterparty) Details
194700200529     C                   PARM                    CustDts
194800200529
194900200529      ** Portfolio Details
195000200529     C                   PARM                    PortDts
195100200529
195200200529      ** Nominal Currency Details
195300200529      ** Settlement Currency Details
195400200529     C                   PARM                    NomCcyDts
195500200529     C                   PARM                    SetCcyDts
195600200529                                                                                              CGL031
195700200529      ** Taxation of Savings Income                                                           CGL031
195800200529     C                   PARM                    CGL031                                       CGL031
195900200529      *
196000200529      * OUTPUTS
196100200529      *
196200200529      ** FX Margin Amount
196300200529      ** Portfolio exchange rate & M/D ind screen format
196400200529     C                   PARM                    DDMAMT           18
196500200529     C                   PARM                    DDSPXR           14
196600200529     C                   PARM                    DDSPMD            1
196700200529
196800200529      ** Trade Exchange Rates OK inds
196900200529      ** Trade Settlement Instructions OK
197000200529      ** Trade Charge & Commissions OK inds
197100200529     C                   PARM                    OKTrExch
197200200529     C                   PARM                    OKTrSett
197300200529     C                   PARM                    OKTrChcm
197400200529
197500200529      * Error fields/message IDs/message data (arrays) from/to caller
197600200529     C                   PARM                    FldNameArr
197700200529     C                   PARM                    MsgIDArr
197800200529     C                   PARM                    MsgDtaArr
197900200529      * Array index (3P0) from/to caller
198000200529     C                   PARM                    Idx
198100200529
198200200529      * Warning fields/message IDs/message data (arrays) from/to caller
198300200529     C                   PARM                    WFldNamArr
198400200529     C                   PARM                    WMsgIDArr
198500200529     C                   PARM                    WMsgDtaArr
198600200529      * Array index (3P0) from/to caller
198700200529     C                   PARM                    WIdx
198800200529
198900200529      * Valid Trade layout (DS) from/to caller
199000200529     C                   PARM                    ValidTrad
199100200529
199200200529     C                   ENDSR
199300200529      *****************************************************************
199400200529      /EJECT
199500200529      *****************************************************************                      BUG3145
199600200529      *                                                               *                      BUG3145
199700200529      * ValdTrAddl - Additional validations                           *                      BUG3145
199800200529      *                                                               *                      BUG3145
199900200529      *****************************************************************                      BUG3145
200000200529     C     ValdTrAddl    BEGSR                                                               BUG3145
200100200529                                                                                             BUG3145
200200200529     C                   CALLB     'SETRADAVAL'                                              BUG3145
200300200529                                                                                             BUG3145
200400200529      ** INPUTS                                                                              BUG3145
200500200529                                                                                             BUG3145
200600200529      ** Action Code                                                                         BUG3145
200700200529      ** Nominal Currency                                                                    BUG3145
200800200529     C                   PARM                    DDACTN                                      BUG3145
200900200529     C                   PARM                    NMCY                                        BUG3145
201000200529                                                                                             BUG3145
201100200529      ** Valid Trade layout (DS) from/to caller                                              BUG3145
201200200529     C                   PARM                    ValidTrad                                   BUG3145
201300200529                                                                                             BUG3145
201400200529      ** OUTPUTS                                                                             BUG3145
201500200529                                                                                             BUG3145
201600200529      ** Trade Settlement Instructions OK                                                    BUG3145
201700200529     C                   PARM                    OKTrSett                                    BUG3145
201800200529                                                                                             BUG3145
201900200529      ** Error fields/message IDs/message data (arrays) from/to caller                       BUG3145
202000200529     C                   PARM                    FldNameArr                                  BUG3145
202100200529     C                   PARM                    MsgIDArr                                    BUG3145
202200200529     C                   PARM                    MsgDtaArr                                   BUG3145
202300200529                                                                                             BUG3145
202400200529      ** Array index (3P0) from/to caller                                                    BUG3145
202500200529     C                   PARM                    Idx                                         BUG3145
202600200529                                                                                             BUG3145
202700200529      ** Warning fields/message IDs/message data (arrays) from/to caller                     BUG3145
202800200529     C                   PARM                    WFldNamArr                                  BUG3145
202900200529     C                   PARM                    WMsgIDArr                                   BUG3145
203000200529     C                   PARM                    WMsgDtaArr                                  BUG3145
203100200529                                                                                             BUG3145
203200200529      ** Array index (3P0) from/to caller                                                    BUG3145
203300200529     C                   PARM                    WIdx                                        BUG3145
203400200529                                                                                             BUG3145
203500200529     C                   ENDSR                                                               BUG3145
203600200529      *****************************************************************                      BUG3145
203700200529      /EJECT                                                                                 BUG3145
203800200529      *****************************************************************
203900200529      *                                                               *
204000200529      * DfltTrSwfA - Default Trade Extension (SWIFT) 'A' details      *
204100200529      *                                                               *
204200200529      *****************************************************************
204300200529     C     DfltTrSwfA    BEGSR
204400200529
204500200529     C                   CALLB     'SETSWFTDFT'
204600200529      *
204700200529      ** INPUT PARAMETERS :
204800200529      *
204900200529      * Screen (A or B)
205000200529     C                   PARM      'A'           Screen            1
205100200529      *
205200200529      * Trade Details (screen)
205300200529      *
205400200529     C                   PARM                    DDACTN            1
205500200529     C                   PARM                    DDTDTP            2
205600200529     C                   PARM                    DDSETP            2
205700200529     C                   PARM                    DDCLTY2           1
205800200529     C                   PARM                    DDPCOD            1
205900200529     C                   PARM                    DDPRYC            1
206000200529     C                   PARM                    DDBRCD                                       CSE028
206100200529     C                   PARM                    DDBPBK                                       CSE028
206200200529     C                   PARM                    DDSETC                                       CSE028
206300200529     C                   PARM                    DDMRKT                                       CSE034
206400200529      *
206500200529      * Trade Details (file)
206600200529     C                   PARM                    V_TDVD
206700200529     C                   PARM                    V_TCNR
206800200529     C                   PARM                    V_DELF
206900200529     C                   PARM                    V_DELT
207000200529     C                   PARM                    INVT                                         199797
207100200529      *
207200200529      * (CSW003) MT5XX - Phase 2 Message Generation
207300200529     C                   PARM                    CSW003            1
207400200529      *
207500200529      ** OUTPUT PARAMETERS :
207600200529      *
207700200529      * Screen A details
207800200529     C                   PARM                    TranInSwfA
207900200529     C                   PARM                    A_DDROUS          6
208000200529     C                   PARM                    A_DDROTS         12
208100200529     C                   PARM                    A_DDROUC          6
208200200529     C                   PARM                    A_DDROTC         12
208300200529      *
208400200529      * Screen B details
208500200529     C                   PARM                    TranInSwfB
208600200529     C                   PARM                    B_DDROUS          6
208700200529     C                   PARM                    B_DDROTS         12
208800200529     C                   PARM                    B_DDROUC          6
208900200529     C                   PARM                    B_DDROTC         12
209000200529
209100200529     C                   ENDSR
209200200529      *****************************************************************
209300200529      /EJECT
209400200529      *****************************************************************
209500200529      *                                                               *
209600200529      * ValdTrSwfA - Validate Trade Extension (SWIFT) 'A' details     *
209700200529      *                                                               *
209800200529      *****************************************************************
209900200529     C     ValdTrSwfA    BEGSR
210000200529
210100200529     C                   CALLB     'SETRADEVAL'
210200200529      *
210300200529      ** INPUTS
210400200529      *
210500200529      * Response mode
210600200529     C                   PARM                    RespMode          1
210700200529      *
210800200529      * Screen (A or B)
210900200529     C                   PARM      'A'           Screen            1
211000200529      *
211100200529      ** Trade Primary Details
211200200529      ** Trade Secondary Details
211300200529      ** Trade Exchange Rates
211400200529      ** Trade Settlement Details
211500200529     C                   PARM                    TranInPrim
211600200529     C                   PARM                    TranInSeco
211700200529     C                   PARM                    TranInExch
211800200529     C                   PARM                    TranInSett
211900200529      *
212000200529      ** Trade Extension File details
212100200529     C                   PARM                    TranInSwfA
212200200529      * Custom Extra Data file data                                             CAP004
212300200529     C                   PARM                    ExtData                        CAP004
212400200529      *
212500200529      ** Previous inds
212600200529     C                   PARM                    @ADDGMES
212700200529     C                   PARM                    @ADDGMEC
212800200529     C                   PARM                    @ADDCCID
212900200529     C                   PARM                    A_T1CONG
213000200529      *
213100200529      ** Processing type
213200200529     C                   PARM                    PROT
213300200529      *
213400200529      ** Override errors
213500200529     C                   PARM                    OVRErrors
213600200529      *
213700200529      * Valid Trade layout (DS) from/to caller
213800200529     C                   PARM                    ValidTrad
213900200529      * Swift 2001 flag                                                                       CSW201
214000200529     C                   PARM                    CSW201                                       CSW201
214100200529      *                                                                                       201233
214200200529      ** Destination of settlement                                                            201233
214300200529     C                   PARM                    A_DDROTS                                     201233
214400200529      *                                                                                       201429
214500200529      ** Process SE1806 flag                                                                  201429
214600200529     C                   PARM                    PUYAT             1                          201429
214700200529                                                                                              210517
214800200529     C                   PARM                    TradSwX2A                                    210517
214900200529      *
215000200529      ** OUTPUTS
215100200529      *
215200200529      * OK Flags
215300200529     C                   PARM                    OKTrSwft
215400200529      * Error fields/message IDs/message data (arrays) from/to caller
215500200529     C                   PARM                    FldNameArr
215600200529     C                   PARM                    MsgIDArr
215700200529     C                   PARM                    MsgDtaArr
215800200529      * Array index (3P0) from/to caller
215900200529     C                   PARM                    Idx
216000200529      * Warning fields/message IDs/message data (arrays) from/to caller
216100200529     C                   PARM                    WFldNamArr
216200200529     C                   PARM                    WMsgIDArr
216300200529     C                   PARM                    WMsgDtaArr
216400200529      * Array index (3P0) from/to caller
216500200529     C                   PARM                    WIdx
216600200529      *
216700200529      * Valid Trade layout (DS) (Extension file) from/to caller
216800200529     C                   PARM                    ValidTX1A
216900200529
217000200529     C                   ENDSR
217100200529      *****************************************************************
217200200529      /EJECT
217300200529      *****************************************************************
217400200529      *                                                               *
217500200529      * DfltTrSwfB - Default Trade Extension (SWIFT) 'B' details      *
217600200529      *                                                               *
217700200529      *****************************************************************
217800200529     C     DfltTrSwfB    BEGSR
217900200529
218000200529     C                   CALLB     'SETSWFTDFT'
218100200529      *
218200200529      ** INPUT PARAMETERS :
218300200529      *
218400200529      * Screen (A or B)
218500200529     C                   PARM      'B'           Screen            1
218600200529      *
218700200529      * Trade Details (screen)
218800200529      *
218900200529     C                   PARM                    DDACTN            1
219000200529     C                   PARM                    DDTDTP            2
219100200529     C                   PARM                    DDSETP            2
219200200529     C                   PARM                    DDCLTY2           1
219300200529     C                   PARM                    DDPCOD            1
219400200529     C                   PARM                    DDPRYC            1
219500200529     C                   PARM                    DDBRCD                                       CSE028
219600200529     C                   PARM                    DDBPBK                                       CSE028
219700200529     C                   PARM                    DDSETC                                       CSE028
219800200529     C                   PARM                    DDMRKT                                       CSE034
219900200529      *
220000200529      * Trade Details (file)
220100200529     C                   PARM                    V_TDVD
220200200529     C                   PARM                    V_TCNR
220300200529     C                   PARM                    V_DELF
220400200529     C                   PARM                    V_DELT
220500200529     C                   PARM                    INVT                                         199797
220600200529      *
220700200529      * (CSW003) MT5XX - Phase 2 Message Generation
220800200529     C                   PARM                    CSW003            1
220900200529      *
221000200529      ** OUTPUT PARAMETERS :
221100200529      *
221200200529      * Screen A details
221300200529     C                   PARM                    TranInSwfA
221400200529     C                   PARM                    A_DDROUS          6
221500200529     C                   PARM                    A_DDROTS         12
221600200529     C                   PARM                    A_DDROUC          6
221700200529     C                   PARM                    A_DDROTC         12
221800200529      *
221900200529      * Screen B details
222000200529     C                   PARM                    TranInSwfB
222100200529     C                   PARM                    B_DDROUS          6
222200200529     C                   PARM                    B_DDROTS         12
222300200529     C                   PARM                    B_DDROUC          6
222400200529     C                   PARM                    B_DDROTC         12
222500200529
222600200529     C                   ENDSR
222700200529      *****************************************************************
222800200529      /EJECT
222900200529      *****************************************************************
223000200529      *                                                               *
223100200529      * ValdTrSwfB - Validate Trade Extension (SWIFT) 'B' details     *
223200200529      *                                                               *
223300200529      *****************************************************************
223400200529     C     ValdTrSwfB    BEGSR
223500200529
223600200529     C                   CALLB     'SETRADEVAL'
223700200529      *
223800200529      ** INPUTS
223900200529      *
224000200529      * Response mode
224100200529     C                   PARM                    RespMode          1
224200200529      *
224300200529      * Screen (A or B)
224400200529     C                   PARM      'B'           Screen            1
224500200529      *
224600200529      ** Trade Primary Details
224700200529      ** Trade Secondary Details
224800200529      ** Trade Exchange Rates
224900200529      ** Trade Settlement Details
225000200529     C                   PARM                    TranInPrim
225100200529     C                   PARM                    TranInSeco
225200200529     C                   PARM                    TranInExch
225300200529     C                   PARM                    TranInSett
225400200529      *
225500200529      ** Trade Extension File details
225600200529     C                   PARM                    TranInSwfB
225700200529      * Custom Extra Data file data                                             CAP004
225800200529     C                   PARM                    ExtData                        CAP004
225900200529      *
226000200529      ** Previous inds
226100200529     C                   PARM                    @BDDGMES
226200200529     C                   PARM                    @BDDGMEC
226300200529     C                   PARM                    @BDDCCID
226400200529     C                   PARM                    B_T1CONG
226500200529      *
226600200529      ** Processing type
226700200529     C                   PARM                    PROT
226800200529      *
226900200529      ** Override errors
227000200529     C                   PARM                    OVRErrors         1
227100200529      *
227200200529      * Valid Trade layout (DS) from/to caller
227300200529     C                   PARM                    ValidTrad
227400200529      * Swift 2001 flag                                                                       CSW201
227500200529     C                   PARM                    CSW201                                       CSW201
227600200529      *                                                                                       201233
227700200529      ** Destination of settlement                                                            201233
227800200529     C                   PARM                    B_DDROTS                                     201233
227900200529      *                                                                                       201429
228000200529      ** Process SE1806 flag                                                                  201429
228100200529     C                   PARM                    PUYAT             1                          201429
228200200529                                                                                              210517
228300200529     C                   PARM                    TradSwX2B                                    210517
228400200529      *
228500200529      ** OUTPUTS
228600200529      *
228700200529      * OK Flags
228800200529     C                   PARM                    OKTrSwft
228900200529      * Error fields/message IDs/message data (arrays) from/to caller
229000200529     C                   PARM                    FldNameArr
229100200529     C                   PARM                    MsgIDArr
229200200529     C                   PARM                    MsgDtaArr
229300200529      * Array index (3P0) from/to caller
229400200529     C                   PARM                    Idx
229500200529      * Warning fields/message IDs/message data (arrays) from/to caller
229600200529     C                   PARM                    WFldNamArr
229700200529     C                   PARM                    WMsgIDArr
229800200529     C                   PARM                    WMsgDtaArr
229900200529      * Array index (3P0) from/to caller
230000200529     C                   PARM                    WIdx
230100200529      *
230200200529      * Valid Trade layout (DS) (Extension file) from/to caller
230300200529     C                   PARM                    ValidTX1B
230400200529
230500200529     C                   ENDSR
230600200529      *****************************************************************
230700200529      /EJECT                                                                                  247873
230800200529      *****************************************************************                       247873
230900200529      *                                                               *                       247873
231000200529      * RstrTrSwf1 - Restore non-blank fields                         *                       247873
231100200529      *                                                               *                       247873
231200200529      *****************************************************************                       247873
231300200529                                                                                              247873
231400200529     C     RstrTrSwf1    BEGSR                                                                247873
231500200529      *                                                                                       247873
231600200529     C                   IF        IDDGMES <> *Blanks                                         247873
231700200529     C                   EVAL      ODDGMES = IDDGMES                                          247873
231800200529     C                   ENDIF                                                                247873
231900200529      *                                                                                       247873
232000200529     C                   IF        IDDTRTT <> *Blanks                                         247873
232100200529     C                   EVAL      ODDTRTT = IDDTRTT                                          247873
232200200529     C                   ENDIF                                                                247873
232300200529      *                                                                                       247873
232400200529     C                   IF        IDDINST <> *Blanks                                         247873
232500200529     C                   EVAL      ODDINST = IDDINST                                          247873
232600200529     C                   ENDIF                                                                247873
232700200529      *                                                                                       247873
232800200529     C                   IF        IDDINSS <> *Blanks                                         247873
232900200529     C                   EVAL      ODDINSS = IDDINSS                                          247873
233000200529     C                   ENDIF                                                                247873
233100200529      *                                                                                       247873
233200200529     C                   IF        IDDEUCL <> *Blanks                                         247873
233300200529     C                   EVAL      ODDEUCL = IDDEUCL                                          247873
233400200529     C                   ENDIF                                                                247873
233500200529      *                                                                                       247873
233600200529     C                   IF        IDDSAFA <> *Blanks                                         247873
233700200529     C                   EVAL      ODDSAFA = IDDSAFA                                          247873
233800200529     C                   ENDIF                                                                247873
233900200529      *                                                                                       247873
234000200529     C                   IF        IDDRPTY <> *Blanks                                         247873
234100200529     C                   EVAL      ODDRPTY = IDDRPTY                                          247873
234200200529     C                   ENDIF                                                                247873
234300200529      *                                                                                       247873
234400200529     C                   IF        IDDGDEL <> *Blanks                                         247873
234500200529     C                   EVAL      ODDGDEL = IDDGDEL                                          247873
234600200529     C                   ENDIF                                                                247873
234700200529      *                                                                                       247873
234800200529     C                   IF        IDDSROL <> *Blanks                                         247873
234900200529     C                   EVAL      ODDSROL = IDDSROL                                          247873
235000200529     C                   ENDIF                                                                247873
235100200529      *                                                                                       247873
235200200529     C                   IF        IDDFCOD <> *Blanks                                         247873
235300200529     C                   EVAL      ODDFCOD = IDDFCOD                                          247873
235400200529     C                   ENDIF                                                                247873
235500200529      *                                                                                       247873
235600200529     C                   IF        IDDFTID <> *Blanks                                         247873
235700200529     C                   EVAL      ODDFTID = IDDFTID                                          247873
235800200529     C                   ENDIF                                                                247873
235900200529      *                                                                                       247873
236000200529     C                   IF        IDDGMEC <> *Blanks                                         247873
236100200529     C                   EVAL      ODDGMEC = IDDGMEC                                          247873
236200200529     C                   ENDIF                                                                247873
236300200529      *                                                                                       247873
236400200529     C                   IF        IDDCCID <> *Blanks                                         247873
236500200529     C                   EVAL      ODDCCID = IDDCCID                                          247873
236600200529     C                   ENDIF                                                                247873
236700200529      *                                                                                       247873
236800200529     C                   IF        IDDFID1 <> *Blanks                                         247873
236900200529     C                   EVAL      ODDFID1 = IDDFID1                                          247873
237000200529     C                   ENDIF                                                                247873
237100200529      *                                                                                       247873
237200200529     C                   IF        IDDIORA <> *Blanks                                         247873
237300200529     C                   EVAL      ODDIORA = IDDIORA                                          247873
237400200529     C                   ENDIF                                                                247873
237500200529      *                                                                                       247873
237600200529     C                   IF        IDDSNEW <> *Blanks                                         247873
237700200529     C                   EVAL      ODDSNEW = IDDSNEW                                          247873
237800200529     C                   ENDIF                                                                247873
237900200529      *                                                                                       247873
238000200529     C                   IF        IDDSTMP <> *Blanks                                         247873
238100200529     C                   EVAL      ODDSTMP = IDDSTMP                                          247873
238200200529     C                   ENDIF                                                                247873
238300200529      *                                                                                       247873
238400200529     C                   IF        IDDCHID <> *Blanks                                         247873
238500200529     C                   EVAL      ODDCHID = IDDCHID                                          247873
238600200529     C                   ENDIF                                                                247873
238700200529      *                                                                                       247873
238800200529     C                   IF        IDDTRRM <> *Blanks                                         247873
238900200529     C                   EVAL      ODDTRRM = IDDTRRM                                          247873
239000200529     C                   ENDIF                                                                247873
239100200529      *                                                                                       247873
239200200529     C                   ENDSR                                                                247873
239300200529      *****************************************************************                       247873
239400200529      /EJECT                                                                    CAP011
239500200529      *****************************************************************         CAP011
239600200529      *                                                               *         CAP011
239700200529      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
239800200529      *                                                               *         CAP011
239900200529      *****************************************************************         CAP011
240000200529                                                                                CAP011
240100200529     C     TDtDtaSubs    BEGSR                                                  CAP011
240200200529                                                                                CAP011
240300200529      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT                             CAP011
240400200529                                                                                CAP011
240500200529     C                   RESET                   RetCodeIn                      CAP011
240600200529     C                   CALLB     'SETRADCVT'                                  CAP011
240700200529      *                                                                         CAP011
240800200529      * INPUTS                                                                  CAP011
240900200529      *                                                                         CAP011
241000200529      * Return Code                                                             CAP011
241100200529     C                   PARM                    RetCodeIn                      CAP011
241200200529      *                                                                         CAP011
241300200529      * Trade - file formats                                                    CAP011
241400200529     C                   PARM                    TradFilFmt                     CAP011
241500200529     C                   PARM                    TX1AFilFmt                     CAP011
241600200529     C                   PARM                    TX1BFilFmt                     CAP011
241700200529                                                                                              CAS006
241800200529      ** Hedge Accounting Phase B                                                             CAS006
241900200529                                                                                              CAS006
242000200529     C                   PARM                    CAS006                                       CAS006
242100200529      * CGL031 Switchable Feature                                                             CGL031
242200200529     C                   PARM                    CGL031                                       CGL031
242300200529      *                                                                         CAP011
242400200529      * Output parameters                                                       CAP011
242500200529      *                                                                         CAP011
242600200529      * Trade - screen formats                                                  CAP011
242700200529     C                   PARM                    CurTrPrim                      CAP011
242800200529     C                   PARM                    CurTrSeco                      CAP011
242900200529     C                   PARM                    CurTrThir                                    CAS006
243000200529     C                   PARM                    CurTrExch                      CAP011
243100200529     C                   PARM                    CurTrSett                      CAP011
243200200529     C                   PARM                    CurTrChCm                      CAP011
243300200529     C                   PARM                    CurTrSwftA                     CAP011
243400200529     C                   PARM                    CurTrSwftB                     CAP011
243500200529                                                                                CAP011
243600200529      ** Security Details                                                       CAP011
243700200529      ** Investment Type Details                                                CAP011
243800200529     C                   PARM                    SECTY                          CAP011
243900200529     C                   PARM                    INVTP                          CAP011
244000200529                                                                                CAP011
244100200529      ** Nominal Currency Details                                               CAP011
244200200529     C                   PARM                    NomCcyDts                      CAP011
244300200529                                                                                CAP011
244400200529      ** Settlement Currency Details                                            CAP011
244500200529     C                   PARM                    SetCcyDts                      CAP011
244600200529      *                                                                         CAP011
244700200529      ** Customer (Counterparty) Details                                        CAP011
244800200529     C                   PARM                    CustDts                        CAP011
244900200529      *                                                                         CAP011
245000200529      * Trade Status                                                            CAP011
245100200529      * Trade Authorized/Not Authorized                                         CAP011
245200200529     C                   PARM                    DDSTAT            9            CAP011
245300200529     C                   PARM                    DDAUTH           14            CAP011
245400200529      * Security report name                                                    CAP011
245500200529      * Customer report name                                                    CAP011
245600200529     C**********         PARM                    DDSRPN           20                   CAP011 CSE016
245700200529     C                   PARM                    DDSRNME          41                          CSE016
245800200529     C                   PARM                    DDCRNM           20            CAP011
245900200529                                                                                CAP011
246000200529      * Coupon Rate                                                             CAP011
246100200529      * Current Factor                                                          CAP011
246200200529      * Margin Amount                                                           CAP011
246300200529      * Portfolio Exchange Rate                                                 CAP011
246400200529      * Portfolio M/D Ind                                                       CAP011
246500200529      * Trade Countervalue                                                      CAP011
246600200529     C                   PARM                    DDCPNR           13            CAP011
246700200529     C                   PARM                    DDCFCT           12            CAP011
246800200529     C                   PARM                    DDMAMT           18            CAP011
246900200529     C                   PARM                    DDSPXR           14            CAP011
247000200529     C                   PARM                    DDSPMD            1            CAP011
247100200529     C                   PARM                    DDTCTR           21            CAP011
247200200529     C                   PARM                    DDWTAX                         CSE023
247300200529     C                   PARM                    DDPRICN                                      CAS006
247400200529                                                                                CAP011
247500200529      * SCREEN A                                                                CAP011
247600200529      * Destination of Settlement                                               CAP011
247700200529      * Destination of Confirmation                                             CAP011
247800200529     C                   PARM                    A_DDROUS          6            CAP011
247900200529     C                   PARM                    A_DDROTS         12            CAP011
248000200529     C                   PARM                    A_DDROUC          6            CAP011
248100200529     C                   PARM                    A_DDROTC         12            CAP011
248200200529                                                                                CAP011
248300200529      * SCREEN B                                                                CAP011
248400200529      * Destination of Settlement                                               CAP011
248500200529      * Destination of Confirmation                                             CAP011
248600200529     C                   PARM                    B_DDROUS          6            CAP011
248700200529     C                   PARM                    B_DDROTS         12            CAP011
248800200529     C                   PARM                    B_DDROUC          6            CAP011
248900200529     C                   PARM                    B_DDROTC         12            CAP011
249000200529                                                                                CAP011
249100200529      ** DATA SUBSTITUTION                                                      CAP011
249200200529                                                                                CAP011
249300200529     C                   RESET                   ReturnCode                     CAP011
249400200529
249500200529      * TRADE PRIMARY DETAILS
249600200529     C                   CALLB     'APDTASUBS'                                  CAP011
249700200529                                                                                CAP011
249800200529      * Return Code                                                             CAP011
249900200529     C                   PARM                    ReturnCode       10            CAP011
250000200529      * Substitution character                                                  CAP011
250100200529     C                   PARM      GHSUBS        SubsChar          1            CAP011
250200200529      * Incoming Data                                                           CAP011
250300200529     C                   PARM      TranInPrim    IncDATA        2000            CAP011
250400200529      * Current Data                                                            CAP011
250500200529     C                   PARM      CurTrPrim     CurDATA        2000            CAP011
250600200529                                                                                CAP011
250700200529     C                   MOVEL     IncDATA       TranInPrim                     CAP011
250800200529
250900200529      * TRADE SECONDARY DETAILS
251000200529     C                   CALLB     'APDTASUBS'                                  CAP011
251100200529                                                                                CAP011
251200200529      * Return Code                                                             CAP011
251300200529     C                   PARM                    ReturnCode       10            CAP011
251400200529      * Substitution character                                                  CAP011
251500200529     C                   PARM      GHSUBS        SubsChar          1            CAP011
251600200529      * Incoming Data                                                           CAP011
251700200529     C                   PARM      TranInSeco    IncDATA        2000            CAP011
251800200529      * Current Data                                                            CAP011
251900200529     C                   PARM      CurTrSeco     CurDATA        2000            CAP011
252000200529                                                                                CAP011
252100200529     C                   MOVEL     IncDATA       TranInSeco                     CAP011
252200200529                                                                                              CAS006
252300200529      ** Trade Third screen details                                                           CAS006
252400200529                                                                                              CAS006
252500200529     C                   IF        CAS006 = 'Y'                                               CAS006
252600200529     C                   CALLB     'APDTASUBS'                                                CAS006
252700200529                                                                                              CAS006
252800200529      ** Return Code                                                                          CAS006
252900200529                                                                                              CAS006
253000200529     C                   PARM                    ReturnCode                                   CAS006
253100200529                                                                                              CAS006
253200200529      ** Substitution character                                                               CAS006
253300200529      ** Incoming Data                                                                        CAS006
253400200529      ** Current Data                                                                         CAS006
253500200529                                                                                              CAS006
253600200529     C                   PARM      GHSUBS        SubsChar                                     CAS006
253700200529     C                   PARM      TranInThir    IncDATA                                      CAS006
253800200529     C                   PARM      CurTrThir     CurDATA                                      CAS006
253900200529                                                                                              CAS006
254000200529     C                   MOVEL     IncDATA       TranInThir                                   CAS006
254100200529     C                   ENDIF                                                                CAS006
254200200529
254300200529      * TRADE EXCHANGE RATES
254400200529     C                   CALLB     'APDTASUBS'                                  CAP011
254500200529                                                                                CAP011
254600200529      * Return Code                                                             CAP011
254700200529     C                   PARM                    ReturnCode       10            CAP011
254800200529      * Substitution character                                                  CAP011
254900200529     C                   PARM      GHSUBS        SubsChar          1            CAP011
255000200529      * Incoming Data                                                           CAP011
255100200529     C                   PARM      TranInExch    IncDATA        2000            CAP011
255200200529      * Current Data                                                            CAP011
255300200529     C                   PARM      CurTrExch     CurDATA        2000            CAP011
255400200529                                                                                CAP011
255500200529     C                   MOVEL     IncDATA       TranInExch                     CAP011
255600200529
255700200529      * TRADE SETTLEMENT DETAILS
255800200529     C                   CALLB     'APDTASUBS'                                  CAP011
255900200529                                                                                CAP011
256000200529      * Return Code                                                             CAP011
256100200529     C                   PARM                    ReturnCode       10            CAP011
256200200529      * Substitution character                                                  CAP011
256300200529     C                   PARM      GHSUBS        SubsChar          1            CAP011
256400200529      * Incoming Data                                                           CAP011
256500200529     C                   PARM      TranInSett    IncDATA        2000            CAP011
256600200529      * Current Data                                                            CAP011
256700200529     C                   PARM      CurTrSett     CurDATA        2000            CAP011
256800200529                                                                                CAP011
256900200529     C                   MOVEL     IncDATA       TranInSett                     CAP011
257000200529
257100200529      * TRADE CHARGE/COMMISSIONS
257200200529     C                   CALLB     'APDTASUBS'                                  CAP011
257300200529                                                                                CAP011
257400200529      * Return Code                                                             CAP011
257500200529     C                   PARM                    ReturnCode       10            CAP011
257600200529      * Substitution character                                                  CAP011
257700200529     C                   PARM      GHSUBS        SubsChar          1            CAP011
257800200529      * Incoming Data                                                           CAP011
257900200529     C                   PARM      TranInChCm    IncDATA        2000            CAP011
258000200529      * Current Data                                                            CAP011
258100200529     C                   PARM      CurTrChCm     CurDATA        2000            CAP011
258200200529                                                                                CAP011
258300200529     C                   MOVEL     IncDATA       TranInChCm                     CAP011
258400200529
258500200529      * TRADE SWIFT A DETAILS
258600200529     C                   CALLB     'APDTASUBS'                                  CAP011
258700200529                                                                                CAP011
258800200529      * Return Code                                                             CAP011
258900200529     C                   PARM                    ReturnCode       10            CAP011
259000200529      * Substitution character                                                  CAP011
259100200529     C                   PARM      GHSUBS        SubsChar          1            CAP011
259200200529      * Incoming Data                                                           CAP011
259300200529     C                   PARM      TranInSwfA    IncDATA        2000            CAP011
259400200529      * Current Data                                                            CAP011
259500200529     C                   PARM      CurTrSwftA    CurDATA        2000            CAP011
259600200529                                                                                CAP011
259700200529     C                   MOVEL     IncDATA       TranInSwfA                     CAP011
259800200529
259900200529      * TRADE SWIFT B DETAILS
260000200529     C                   CALLB     'APDTASUBS'                                  CAP011
260100200529                                                                                CAP011
260200200529      * Return Code                                                             CAP011
260300200529     C                   PARM                    ReturnCode       10            CAP011
260400200529      * Substitution character                                                  CAP011
260500200529     C                   PARM      GHSUBS        SubsChar          1            CAP011
260600200529      * Incoming Data                                                           CAP011
260700200529     C                   PARM      TranInSwfB    IncDATA        2000            CAP011
260800200529      * Current Data                                                            CAP011
260900200529     C                   PARM      CurTrSwftB    CurDATA        2000            CAP011
261000200529                                                                                CAP011
261100200529     C                   MOVEL     IncDATA       TranInSwfB                     CAP011
261200200529                                                                                CAP011
261300200529     C                   ENDSR                                                  CAP011
261400200529      *****************************************************************         CAP011
261500200529      /EJECT
261600200529      *****************************************************************
261700200529      *                                                               *
261800200529      * CalcTrCHCM - Calculate Trade Charges/Commissions              *
261900200529      *                                                               *
262000200529      *****************************************************************
262100200529     C     CalcTrCHCM    BEGSR
262200200529
262300200529     C                   CALLB     'SETCHCMCAL'
262400200529
262500200529      * INPUTS
262600200529
262700200529      ** Trade reference
262800200529      ** Security
262900200529      ** Trade Type
263000200529     C                   PARM                    DDTDRF            6
263100200529     C                   PARM                    DDSESN           10
263200200529     C                   PARM                    DDTDTP            2
263300200529      *
263400200529      ** Trade Counterparty
263500200529      ** Trade Nominal
263600200529      ** Trade % price
263700200529      ** Trade Date
263800200529      ** Trade Purchased Interest
263900200529      ** Trade Current Factor
264000200529     C                   PARM                    V_TCNR
264100200529     C                   PARM                    V_NOML           11 0
264200200529     C                   PARM                    V_PRIC           15 8
264300200529     C                   PARM                    V_TDDT            5 0
264400200529     C                   PARM                    V_ITRA           13 0
264500200529     C                   PARM                    V_TCFC           10 9
264600200529      *
264700200529      ** Security & Investment Type details
264800200529     C                   PARM                    SECTY
264900200529     C                   PARM                    PROT              1
265000200529      *
265100200529      ** Nominal Currency Details
265200200529     C                   PARM                    NomCcyDts
265300200529      *
265400200529      ** Customer (Counterparty) Details
265500200529     C                   PARM                    CustDts
265600200529      *
265700200529      ** Commission Rebate %
265800200529     C                   PARM                    CMRP              5 3
265900200529      *
266000200529      ** Previous Trade Charges & Commissions
266100200529     C                   PARM                    CurTrChCm
266200200529      *
266300200529      ** Trade Charges & Commissions OK inds
266400200529     C                   PARM                    OKTrChCm
266500200529      *
266600200529      ** ICD
266700200529      ** Autocharge Option
266800200529      ** Securities Charges Currency
266900200529      ** Adjust Commission Same Day T
267000200529     C                   PARM                    BVACOP            1
267100200529     C                   PARM                    BVCHRC            3
267200200529     C                   PARM                    BVACSD            1
267300200529     C                   PARM                    S01446            1
267400200529
267500200529      * INPUTS & OUTPUTS
267600200529
267700200529      ** Trade Charges & commissions screen fields
267800200529
267900200529     C                   PARM                    TranInChcm
268000200529
268100200529      ** Trade details
268200200529     C                   PARM                    V_TBCA           13 0
268300200529     C                   PARM                    V_TCCA           13 0
268400200529     C                   PARM                    V_TCA1           13 0
268500200529     C                   PARM                    V_TCA2           13 0
268600200529     C                   PARM                    V_TCA3           13 0
268700200529     C                   PARM                    V_TCA4           13 0
268800200529     C                   PARM                    V_TCA5           13 0
268900200529     C                   PARM                    V_TCA6           13 0
269000200529     C                   PARM                    V_TCA7           13 0
269100200529     C                   PARM                    V_TAXA           13 0
269200200529     C                   PARM                    V_BCMR           13 0
269300200529     C                   PARM                    V_CCMR           13 0
269400200529     C                   PARM                    V_TXRB           13 0
269500200529
269600200529     C                   ENDSR
269700200529      *****************************************************************                       233881
269800200529      /EJECT                                                                                  233881
269900200529      *****************************************************************                       233881
270000200529      *                                                               *                       233881
270100200529      * CalcTrEuTx - Calculate EU Tax                                 *                       233881
270200200529      *                                                               *                       233881
270300200529      *****************************************************************                       233881
270400200529     C     CalcTrEuTx    BEGSR                                                                233881
270500200529                                                                                              233881
270600200529      ** CALCULATE EU TAX                                                                     233881
270700200529                                                                                              233881
270800200529     C                   CALLB     'SEVTRADTAX'                                               233881
270900200529                                                                                              233881
271000200529      * INPUTS                                                                                233881
271100200529                                                                                              233881
271200200529      * Response Mode                                                                         233881
271300200529     C                   PARM                    RespMode                                     233881
271400200529      * Valid Trade Details                                                                   233881
271500200529     C                   PARM                    ValidTrad                                    233881
271600200529      * Security Details                                                                      233881
271700200529     C                   PARM                    SECTY                                        233881
271800200529      * Process Flag                                                                          233881
271900200529     C                   PARM      'E'           ProcFlag          1                          233881
272000200529                                                                                              233881
272100200529      * OUTPUTS                                                                               233881
272200200529                                                                                              233881
272300200529      * EU Tax Screen Format                                                                  233881
272400200529      * EU Tax in Nominal Currency File Format                                                233881
272500200529      * EU Tax in Settlement Currency File Format                                             233881
272600200529     C                   PARM                    DDEUTX                                       233881
272700200529     C************       PARM                    EUTX                                   233881234858
272800200529     C************       PARM                    EUTS                                   233881234858
272900200529     C                   PARM                    V_EUTX                                       234858
273000200529     C                   PARM                    V_EUTS                                       234858
273100200529                                                                                              233881
273200200529     C                   ENDSR                                                                233881
273300200529      *****************************************************************
273400200529      /EJECT
273500200529      *****************************************************************
273600200529      *                                                               *
273700200529      * CalcTrCVAL - Calculate Trade Countervalue                     *
273800200529      *                                                               *
273900200529      *****************************************************************
274000200529     C     CalcTrCVAL    BEGSR
274100200529
274200200529      ** CALCULATE COUNTERVALUE
274300200529
274400200529     C                   CALLB     'SETCVALCAL'
274500200529
274600200529      * INPUTS
274700200529
274800200529      ** Trade details
274900200529     C                   PARM                    V_TDTP            2
275000200529     C                   PARM                    V_NOML           11 0
275100200529     C                   PARM                    V_PRIC           15 8
275200200529     C                   PARM                    V_RALL            9 5
275300200529     C                   PARM                    V_ITRA           13 0
275400200529     C                   PARM                    V_TBCA           13 0
275500200529     C                   PARM                    V_TCCA           13 0
275600200529     C                   PARM                    V_TCA1           13 0
275700200529     C                   PARM                    V_TCA2           13 0
275800200529     C                   PARM                    V_TCA3           13 0
275900200529     C                   PARM                    V_TCA4           13 0
276000200529     C                   PARM                    V_TCA5           13 0
276100200529     C                   PARM                    V_TCA6           13 0
276200200529     C                   PARM                    V_TCA7           13 0
276300200529     C                   PARM                    V_TAXA           13 0
276400200529     C                   PARM                    V_TDER           13 8
276500200529     C                   PARM                    V_TMDI            1
276600200529     C                   PARM                    V_SETC            3
276700200529     C                   PARM                    V_TDVD            5 0                        200459
276800200529
276900200529      ** Security details
277000200529     C                   PARM                    PROT              1
277100200529     C                   PARM                    SPBS              1
277200200529     C                   PARM                    CFCT             10 9
277300200529     C                   PARM                    NMCY              3
277400200529     C                   PARM                    NMDP              1 0
277500200529     C                   PARM                    SESN             10                          200459
277600200529
277700200529      ** Nominal Currency Details
277800200529      ** Settlement Currency Details
277900200529     C                   PARM                    NomCcyDts
278000200529     C                   PARM                    SetCcyDts
278100200529
278200200529      ** Customer classification
278300200529     C                   PARM                    CustClass         1
278400200529                                                                                CSE023
278500200529      ** Country of treaty from PF/SECTYD                                       CSE023
278600200529     C                   PARM                    CRTT                           CSE023
278700200529                                                                                CSE023
278800200529      ** Default basket for backup withholding                                  CSE023
278900200529     C                   PARM                    PDRBW                          CSE023
279000200529                                                                                CSE023
279100200529      ** Value date                                                             CSE023
279200200529     C                   PARM                    TDVD                           CSE023
279300200529                                                                                              233881
279400200529      ** EU Tax                                                                               233881
279500200529     C*************      PARM                    EUTX                                   233881234858
279600200529     C                   PARM                    V_EUTX                                       234858
279700200529
279800200529      * OUTPUTS
279900200529
280000200529      * Trade consideration in nominal currency
280100200529      * Trade countervalue in nominal currency
280200200529      * Withholding tax                                                         CSE023
280300200529      * Trade countervalue in settlement currency in screen format
280400200529      * Withholding tax in screen format                                        CSE023
280500200529     C                   PARM                    V_TCSR           15 0
280600200529     C                   PARM                    V_TCTR           15 0
280700200529     C                   PARM                    WHTX                           CSE023
280800200529     C                   PARM                    DDTCTR           21
280900200529     C                   PARM                    DDWTAX                         CSE023
281000200529
281100200529     C                   ENDSR
281200200529      *****************************************************************                       CSE045
281300200529      /EJECT                                                                                  CSE045
281400200529      *****************************************************************                       CSE045
281500200529      * SetPDATA - Set up data structure for call to SE1806                                   CSE045
281600200529      *****************************************************************                       CSE045
281700200529     C     SetPDATA      BEGSR                                                                CSE045
281800200529                                                                                              CSE045
281900200529     C                   MOVEL     DDACTN        PACTN                                        CSE045
282000200529     C     DDACTN        IFEQ      'C'                                                        CSE045
282100200529     C                   MOVEL     'A'           PACTN                                        CSE045
282200200529     C                   END                                                                  CSE045
282300200529     C                   MOVEL     DDTDRF        PTDRF                                        CSE045
282400200529     C                   MOVEL     DDSETC        PTNMC                                        CSE045
282500200529     C                   MOVEL     DDSESN        PSESN                                        CSE045
282600200529     C                   MOVEL     DDBLKR        PBLKR                                        CSE045
282700200529     C                   MOVEL     DDCNUM        PTCNR                                        CSE045
282800200529     C                   MOVEL     DDBRCD        PTDBR                                        CSE045
282900200529     C                   MOVEL     DDTDTP        PTDTP                                        CSE045
283000200529     C                   MOVEL     V_NOML        PNOML                                        CSE045
283100200529     C                   MOVEL     DDTDMI        PTDMI                                        CSE045
283200200529     C                   MOVEL     DDAIIP        PAIIP                                        CSE045
283300200529     C                   MOVEL     DDINCS        PINCS                                        CSE045
283400200529     C                   MOVEL     BVDR1         PDC01                                        CSE045
283500200529     C                   MOVEL     BVDR2         PDC02                                        CSE045
283600200529     C                   MOVEL     DDCLTY        PCLTY                                        CSE045
283700200529     C                   MOVEL     DDPCOD        PPCOD                                        CSE045
283800200529     C                   MOVEL     V_DELT        PDELT                                        CSE045
283900200529     C                   MOVEL     V_DELF        PDELF                                        CSE045
284000200529     C                   MOVEL     DDTDSI        PTDSI                                        CSE045
284100200529     C                   MOVEL     DDSMTH        PSMTH                                        CSE045
284200200529     C                   MOVEL     BFDRF1        PC101                                        CSE045
284300200529     C                   MOVEL     BFDRF2        PC102                                        CSE045
284400200529     C                   MOVEL     DDPRYC        PPRYC                                        CSE045
284500200529     C                   Z-ADD     V_TDVD        PTDVD                                        CSE045
284600200529                                                                                              CSE045
284700200529     C     CSE028        IFEQ      'Y'                                                        CSE045
284800200529     C                   MOVEL     DDBPBK        PPBKC                                        CSE045
284900200529     C                   MOVEL     DDMRKT        PMKCT                                        CSE045
285000200529     C                   ENDIF                                                                CSE045
285100200529                                                                                              CSE045
285200200529     C                   ENDSR                                                                CSE045
285300200529      *****************************************************************                       CSE045
285400200529      /EJECT                                                                                  CSE045
285500200529      *****************************************************************                       CSE045
285600200529      *                                                               *                       CSE045
285700200529      *  SRDefScn - Default fields in screen                          *                       CSE045
285800200529      *                                                               *                       CSE045
285900200529      *****************************************************************                       CSE045
286000200529                                                                                              CSE045
286100200529     C     SRDefScn      BEGSR                                                                CSE045
286200200529                                                                                              CSE045
286300200529     C     KEY001        KLIST                                                                CSE045
286400200529     C                   KFLD                    PTDRF                                        CSE045
286500200529     C                   KFLD                    PWHEN                                        CSE045
286600200529                                                                                              CSE045
286700200529     C                   IF        PWHEN = 'A'                                                CSE045
286800200529     C                   MOVEL     ADDGMES       PGMES                                        CSE045
286900200529     C                   MOVEL     ADDGMEC       PGMEC                                        CSE045
287000200529     C                   MOVEL     ADDCCID       PCCID                                        CSE045
287100200529     C                   MOVEL     ADDSNEW       PSNEW                                        CSE045
287200200529     C                   ELSE                                                                 CSE045
287300200529     C                   MOVEL     BDDGMES       PGMES                                        CSE045
287400200529     C                   MOVEL     BDDGMEC       PGMEC                                        CSE045
287500200529     C                   MOVEL     BDDCCID       PCCID                                        CSE045
287600200529     C                   MOVEL     BDDSNEW       PSNEW                                        CSE045
287700200529     C                   ENDIF                                                                CSE045
287800200529      *                                                                                       CSE045
287900200529      ** Access Branch details via access program                                             CSE045
288000200529      *  (database error handling done in access program)                                     CSE045
288100200529     C                   MOVE      PTDBR         WDSNB                                        CSE045
288200200529     C**********         CALLB     'AOBRCHR0'                                          CSE045 CGL029
288300200529     C                   CALL      'AOBRCHR1'                                                 CGL029
288400200529     C                   PARM      '*DBERR '     @RTCD                                        CSE045
288500200529     C**********         PARM      '*FIRST '     @OPTN                                 CSE045 243604
288600200529     C                   PARM      '*KEY   '     @OPTN                                        243604
288700200529     C                   PARM                    WDSNB             3                          CSE045
288800200529     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 CSE045 CGL029
288900200529     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
289000200529                                                                                              CSE045
289100200529     C                   MOVE      A8BICN        WWBICN                                       CSE045
289200200529                                                                                              CSE045
289300200529     C                   EVAL      CrSEFilFmt = *Blanks                                       CSE045
289400200529     C     KEY001        CHAIN     TRADSDD2                           99                      CSE045
289500200529                                                                                              CSE045
289600200529     C                   CALLB     'SETSESDFT'                                                CSE045
289700200529      *                             =========                                                 CSE045
289800200529      *                                                                                       CSE045
289900200529      ** INPUT                                                                                CSE045
290000200529      ** =====                                                                                CSE045
290100200529      *                                                                                       CSE045
290200200529      ** Securities retrieved from file - file format                                         CSE045
290300200529     C                   PARM                    CrSEFilFmt                                   CSE045
290400200529                                                                                              CSE045
290500200529     C                   PARM                    PDATA                                        CSE045
290600200529                                                                                              CSE045
290700200529     C                   PARM                    CSE022                                       CSE045
290800200529                                                                                              CSE045
290900200529     C                   PARM                    CSE028                                       CSE045
291000200529                                                                                              CSE045
291100200529     C                   PARM                    SWRTN                                        CSE045
291200200529                                                                                              CSE045
291300200529     C                   PARM                    DFTFLG                                       CSE045
291400200529                                                                                              CSE045
291500200529     C**********         PARM                    WWBICN            6 0                 CSE045 CSD027
291600200529     C                   PARM                    WWBICN            6                          CSD027
291700200529                                                                                              CSE045
291800200529     C                   PARM                    PGMNAM                                       CSE045
291900200529     C                   PARM                    DDMRKT                                      BUG2274
292000200529     C                   PARM                    CSW206                                      CSW206E
292100200529      ** SWIFT 2010                                                                           CSW210
292200200529     C                   PARM                    CSW210                                       CSW210
292300200529      *                                                                                       CSE045
292400200529      ** OUTPUT                                                                               CSE045
292500200529      ** ======                                                                               CSE045
292600200529      *                                                                                       CSE045
292700200529      ** Securities screen 1 details retrieved from file - screen format                      CSE045
292800200529     C                   PARM                    NwSE1ScnFmt                                  CSE045
292900200529      *                                                                                       CSE045
293000200529      ** Initialise Clearance Type (1 to 4 is MT580 for Settlements)                          CSE045
293100200529      *                                                                                       CSE045
293200200529     C     PWHEN         IFNE      'B'                                                        CSE045
293300200529     C     PCLTY         OREQ      '1'                                                        CSE045
293400200529     C     PCLTY         OREQ      '3'                                                        CSE045
293500200529                                                                                              CSE045
293600200529     C     PCLTY         IFEQ      '1'                                                        CSE045
293700200529     C     PCLTY         OREQ      '2'                                                        CSE045
293800200529     C     PCLTY         OREQ      '3'                                                        CSE045
293900200529     C     PCLTY         OREQ      '4'                                                        CSE045
294000200529     C                   MOVE      '14'          WWCLTY                                       CSE045
294100200529     C                   ENDIF                                                                CSE045
294200200529                                                                                              CSE045
294300200529     C                   ELSE                                                                 CSE045
294400200529     C     PTDTP         IFEQ      'TP'                                                       CSE045
294500200529     C                   MOVE      PDELF         WCUST                                        CSE045
294600200529     C                   ELSE                                                                 CSE045
294700200529     C                   MOVE      PDELT         WCUST                                        CSE045
294800200529     C                   END                                                                  CSE045
294900200529                                                                                              CSE045
295000200529     C                   CALL      'AOSECSR0'                                                 CSE045
295100200529     C                   PARM      '*DBERR '     @RTCD                                        CSE045
295200200529     C                   PARM      '*KEY   '     @OPTN                                        CSE045
295300200529     C                   PARM                    WCUST             6                          CSE045
295400200529     C     SDSECS        PARM      SDSECS        DSSDY                                        CSE045
295500200529                                                                                              CSE045
295600200529     C     BFCLAS        IFEQ      'E'                                                        CSE045
295700200529     C     PCLTY         ANDEQ     '4'                                                        CSE045
295800200529     C     BFCLAS        OREQ      'E'                                                        CSE045
295900200529     C     PCLTY         ANDEQ     '5'                                                        CSE045
296000200529     C     BFCLAS        OREQ      'C'                                                        CSE045
296100200529     C     PCLTY         ANDEQ     '2'                                                        CSE045
296200200529     C     BFCLAS        OREQ      'C'                                                        CSE045
296300200529     C     PCLTY         ANDEQ     '5'                                                        CSE045
296400200529     C                   MOVE      '14'          WWCLTY                                       CSE045
296500200529     C                   ENDIF                                                                CSE045
296600200529                                                                                              CSE045
296700200529     C                   ENDIF                                                                CSE045
296800200529      *                                                                                       CSE045
296900200529      ** Set up trade type as opposite, if second record                                      CSE045
297000200529      *                                                                                       CSE045
297100200529     C     PWHEN         IFEQ      'B'                                                        CSE045
297200200529     C     PTDTP         IFEQ      'TP'                                                       CSE045
297300200529     C                   MOVE      'TS'          WTDTP                                        CSE045
297400200529     C                   ELSE                                                                 CSE045
297500200529     C                   MOVE      'TP'          WTDTP                                        CSE045
297600200529     C                   ENDIF                                                                CSE045
297700200529                                                                                              CSE045
297800200529     C                   ELSE                                                                 CSE045
297900200529     C                   MOVE      PTDTP         WTDTP                                        CSE045
298000200529     C                   ENDIF                                                                CSE045
298100200529                                                                                              CSE045
298200200529     C     ESRDefScn1    ENDSR                                                                CSE045
298300200529      *****************************************************************                       CSE045
298400200529      /EJECT                                                                                  CSE045
298500200529      *****************************************************************                       CSE045
298600200529      *                                                               *                       CSE045
298700200529      * ValdTrExSetA - Routine to validate Extended Settlements.      *                       CSE045
298800200529      *                                                               *                       CSE045
298900200529      *****************************************************************                       CSE045
299000200529     C     ValdTrExSetA  BEGSR                                                                CSE045
299100200529                                                                                              CSE045
299200200529      *                                                                                       CSE045
299300200529      ** Access Branch details via access program                                             CSE045
299400200529      *  (database error handling done in access program)                                     CSE045
299500200529     C                   MOVE      PTDBR         WDSNB                                        CSE045
299600200529     C**********         CALLB     'AOBRCHR0'                                          CSE045 CGL029
299700200529     C                   CALL      'AOBRCHR1'                                                 CGL029
299800200529     C                   PARM      '*DBERR '     @RTCD                                        CSE045
299900200529     C**********         PARM      '*FIRST '     @OPTN                                 CSE045 243604
300000200529     C                   PARM      '*KEY   '     @OPTN                                        243604
300100200529     C                   PARM                    WDSNB             3                          CSE045
300200200529     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 CSE045 CGL029
300300200529     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
300400200529                                                                                              CSE045
300500200529     C                   MOVE      A8BICN        WWBICN                                       CSE045
300600200529                                                                                              CSE045
300700200529     C                   MOVEL     DDCNUM        WCTPCN                                       CSE045
300800200529      *                                                                                       CSE045
300900200529      ** Retrieve classification of counterparty                                              CSE045
301000200529      *                                                                                       CSE045
301100200529     C                   CALL      'AOSECSR0'                                                 CSE045
301200200529     C                   PARM      '*DBERR '     @Rtcd                                        CSE045
301300200529     C                   PARM      '*KEY   '     @Optn                                        CSE045
301400200529     C                   PARM      WCTPCN        WCust                                        CSE045
301500200529     C     SDSECS        PARM      SDSECS        DSSDY                                        CSE045
301600200529      *                                                                                       CSE045
301700200529      ** Setup parameters to call module SEDORFRTV                                            CSE045
301800200529      *                                                                                       CSE045
301900200529     C     PTDTP         IFEQ      'TP'                                                       CSE045
302000200529      *                                                                                       CSE045
302100200529     C     BFCLAS        IFEQ      'M'                                                        CSE045
302200200529     C                   MOVEL     PDELT         PDEPO                                        CSE045
302300200529     C                   MOVEL     WWBICN        PCUST                                        CSE045
302400200529     C                   MOVEL     PDELT         PDEPO2                                       CSE045
302500200529     C                   ELSE                                                                 CSE045
302600200529     C                   MOVEL     PDELT         PDEPO                                        CSE045
302700200529     C                   MOVEL     DDCNUM        PCUST                                        CSE045
302800200529     C                   MOVEL     PDELT         PDEPO2                                       CSE045
302900200529     C                   ENDIF                                                                CSE045
303000200529                                                                                              CSE045
303100200529     C                   ELSE                                                                 CSE045
303200200529                                                                                              CSE045
303300200529     C     BFCLAS        IFEQ      'M'                                                        CSE045
303400200529     C                   MOVEL     PDELF         PDEPO                                        CSE045
303500200529     C                   MOVEL     WWBICN        PCUST                                        CSE045
303600200529     C                   MOVEL     PDELT         PDEPO2                                       CSE045
303700200529     C                   ELSE                                                                 CSE045
303800200529     C                   MOVEL     PDELF         PDEPO                                        CSE045
303900200529     C                   MOVEL     DDCNUM        PCUST                                        CSE045
304000200529     C                   MOVEL     PDELT         PDEPO2                                       CSE045
304100200529     C                   ENDIF                                                                CSE045
304200200529                                                                                              CSE045
304300200529     C                   ENDIF                                                                CSE045
304400200529      ** If CSE022 is installed then setup Safekeeping A/C Line by using module SEDORFRTV     CSE045
304500200529      *                                                                                       CSE045
304600200529     C     CSE022        IFEQ      'Y'                                                        CSE045
304700200529      *                                                                                       CSE045
304800200529     C                   CALL      PGMNAM                                                     CSE045
304900200529     C                   PARM      *BLANKS       PRETC                                        CSE045
305000200529     C                   PARM                    PDEPO                                        CSE045
305100200529     C                   PARM                    PCUST                                        CSE045
305200200529     C                   PARM      *BLANKS       PSKAL                                        CSE045
305300200529                                                                                              CSE045
305400200529     C     AESSKAN       IFEQ      *BLANKS                                                    CSE045
305500200529     C     AESSKAN       OREQ      '000000'                                                  243119A
305600200529     C     AESSKAN       OREQ      '0'                                                       243119A
305700200529     C                   MOVEL     PDEPO         AESSKAN                                      CSE045
305800200529     C                   END                                                                  CSE045
305900200529     C     AESSKAL       IFEQ      *BLANKS                                                    CSE045
306000200529     C                   MOVEL     PSKAL         AESSKAL                                      CSE045
306100200529     C                   END                                                                  CSE045
306200200529                                                                                              CSE045
306300200529     C                   CALL      PGMNAM                                                     CSE045
306400200529     C                   PARM      *BLANKS       PRETC                                        CSE045
306500200529     C                   PARM                    PDEPO2                                       CSE045
306600200529     C                   PARM                    PTCNR                                        CSE045
306700200529     C                   PARM      *BLANKS       PSKAL                                        CSE045
306800200529                                                                                              CSE045
306900200529     C     AESSA1N       IFEQ      *BLANKS                                                    CSE045
307000200529     C     AESSA1N       OREQ      '000000'                                                  243119A
307100200529     C     AESSA1N       OREQ      '0'                                                       243119A
307200200529     C                   MOVEL     PDEPO2        AESSA1N                                      CSE045
307300200529     C                   END                                                                  CSE045
307400200529     C     AESSA1L       IFEQ      *BLANKS                                                    CSE045
307500200529     C                   MOVEL     PSKAL         AESSA1L                                      CSE045
307600200529     C                   END                                                                  CSE045
307700200529                                                                                              CSE045
307800200529     C                   ENDIF                                                                CSE045
307900200529                                                                                              CSE045
308000200529     C     BFCLAS        IFNE      'S'                                                        CSE045
308100200529     C     BFCLAS        ANDNE     'D'                                                        CSE045
308200200529     C     BFCLAS        ANDNE     'I'                                                        CSE045
308300200529     C                   CALLB     'SETSESVAL'                                                CSE045
308400200529      *                             =========                                                 CSE045
308500200529      *                                                                                       CSE045
308600200529      ** Mode = '*FRONT' (front office transaction interface)                                 CSE045
308700200529      ** Mode = '      ' (not front office transaction interface)                             CSE045
308800200529      ** Mode = '*RPR  ' (repair function)                                                    CSE045
308900200529      ** Mode = '*SIN  ' (screen input function)                                              CSE045
309000200529     C                   PARM                    PMode                                        CSE045
309100200529      *                                                                                       CSE045
309200200529      ** Response mode                                                                        CSE045
309300200529     C                   PARM                    APRespMode                                   CSE045
309400200529      *                                                                                       CSE045
309500200529      ** Security API Trades Extended Settlement details from incoming transaction            CSE045
309600200529      ** - screen format                                                                      CSE045
309700200529     C                   PARM                    TranInExtA                                   CSE045
309800200529      *                                                                                       CSE045
309900200529      ** SWITCHABLE FEATURES                                                                  CSE045
310000200529      ** ===================                                                                  CSE045
310100200529      *                                                                                       CSE045
310200200529      ** MT5xx SSI Enhancements                                                               CSE045
310300200529     C                   PARM                    CSE028                                       CSE045
310400200529      *                                                                                       CSE045
310500200529      ** ERI Information for non-EMU users                                                    CSE045
310600200529     C                   PARM                    CSW014                                       CSE045
310700200529      *                                                                                       CSE045
310800200529      ** SWIFT 2001                                                                           CSE045
310900200529     C                   PARM                    CSW201                                       CSE045
311000200529      *                                                                                       CSE045
311100200529      ** CSW098                                                                               CSE045
311200200529     C                   PARM                    SWRTN                                        CSE045
311300200529      ** SWIFT 2006                                                                          CSW206E
311400200529     C                   PARM                    CSW206                                      CSW206E
311500200529      ** SWIFT 2010                                                                           CSW210
311600200529     C                   PARM                    CSW210                                       CSW210
311700200529      ** CFT004 - IBAN Numbers                                                                CSW210
311800200529     C                   PARM                    CFT004                                       CSW210
311900200529      *                                                                                       CSE045
312000200529      ** Other Parameters                                                                     CSE045
312100200529     C                   PARM                    PDATA                                        CSE045
312200200529                                                                                              CSE045
312300200529     C                   PARM                    WTDTP                                        CSE045
312400200529                                                                                              CSE045
312500200529     C                   PARM                    WWCLTY                                       CSE045
312600200529                                                                                              CSE045
312700200529     C                   PARM                    @ADDSAFA                                     CSE045
312800200529      *                                                                                       CSE045
312900200529      ** Function Keys                                                                        CSE045
313000200529     C                   PARM                    PINKS                                        CSE045
313100200529                                                                                              CSE045
313200200529     C                   PARM                    PINKT                                        CSE045
313300200529      *                                                                                       CSE045
313400200529      ** OUTPUT                                                                               CSE045
313500200529      ** ======                                                                               CSE045
313600200529      *                                                                                       CSE045
313700200529      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE045
313800200529     C                   PARM                    FldNameArr                                   CSE045
313900200529     C                   PARM                    MsgIdArr                                     CSE045
314000200529     C                   PARM                    MsgDtaArr                                    CSE045
314100200529      *                                                                                       CSE045
314200200529      ** Array index (3P0) from/to caller                                                     CSE045
314300200529     C                   PARM                    IdX                                          CSE045
314400200529      *                                                                                       CSE045
314500200529      ** Warning flds/message IDs/message data (arrays) from/to caller                        CSE045
314600200529     C                   PARM                    WFldNamArr                                   CSE045
314700200529     C                   PARM                    WMsgIdArr                                    CSE045
314800200529     C                   PARM                    WMsgDtaArr                                   CSE045
314900200529      *                                                                                       CSE045
315000200529      ** Array index (3P0) from/to caller                                                     CSE045
315100200529     C                   PARM                    WIdX                                         CSE045
315200200529      *                                                                                       CSE045
315300200529      ** Security API Trades Extended Settlements Error Indicators                            CSE045
315400200529     C                   PARM                    SEETES                                       CSE045
315500200529      *                                                                                       CSE045
315600200529      ** Security API Trades Extended Settlements Valid File                                  CSE045
315700200529     C                   PARM                    ValidTX2A                                    CSE045
315800200529     C                   END                                                                  CSE045
315900200529                                                                                              CSE045
316000200529     C                   ENDSR                                                                CSE045
316100200529      *****************************************************************                       CSE045
316200200529      /EJECT                                                                                  CSE045
316300200529      *****************************************************************                       CSE045
316400200529      *                                                               *                       CSE045
316500200529      * ValdTrExSetB - Routine to validate Extended Settlements.      *                       CSE045
316600200529      *                                                               *                       CSE045
316700200529      *****************************************************************                       CSE045
316800200529     C     ValdTrExSetB  BEGSR                                                                CSE045
316900200529                                                                                              CSE045
317000200529     C                   CALLB     'SETSESVAL'                                                CSE045
317100200529      *                             =========                                                 CSE045
317200200529      *                                                                                       CSE045
317300200529      ** Mode = '*FRONT' (front office transaction interface)                                 CSE045
317400200529      ** Mode = '      ' (not front office transaction interface)                             CSE045
317500200529      ** Mode = '*RPR  ' (repair function)                                                    CSE045
317600200529      ** Mode = '*SIN  ' (screen input function)                                              CSE045
317700200529     C                   PARM                    PMode                                        CSE045
317800200529      *                                                                                       CSE045
317900200529      ** Response mode                                                                        CSE045
318000200529     C                   PARM                    APRespMode                                   CSE045
318100200529      *                                                                                       CSE045
318200200529      ** Security API Trades Extended Settlement details from incoming transaction            CSE045
318300200529      ** - screen format                                                                      CSE045
318400200529     C                   PARM                    TranInExtB                                   CSE045
318500200529      *                                                                                       CSE045
318600200529      ** SWITCHABLE FEATURES                                                                  CSE045
318700200529      ** ===================                                                                  CSE045
318800200529      *                                                                                       CSE045
318900200529      ** MT5xx SSI Enhancements                                                               CSE045
319000200529     C                   PARM                    CSE028                                       CSE045
319100200529      *                                                                                       CSE045
319200200529      ** ERI Information for non-EMU users                                                    CSE045
319300200529     C                   PARM                    CSW014                                       CSE045
319400200529      *                                                                                       CSE045
319500200529      ** SWIFT 2001                                                                           CSE045
319600200529     C                   PARM                    CSW201                                       CSE045
319700200529      *                                                                                       CSE045
319800200529      ** CSW098                                                                               CSE045
319900200529     C                   PARM                    SWRTN                                        CSE045
320000200529      ** SWIFT 2006                                                                          CSW206E
320100200529     C                   PARM                    CSW206                                      CSW206E
320200200529      ** SWIFT 2010                                                                           CSW210
320300200529     C                   PARM                    CSW210                                       CSW210
320400200529      ** CFT004 - IBAN Numbers                                                                CSW210
320500200529     C                   PARM                    CFT004                                       CSW210
320600200529      *                                                                                       CSE045
320700200529      ** Other Parameters                                                                     CSE045
320800200529     C                   PARM                    PDATA                                        CSE045
320900200529                                                                                              CSE045
321000200529     C                   PARM                    WTDTP                                        CSE045
321100200529                                                                                              CSE045
321200200529     C                   PARM                    WWCLTY                                       CSE045
321300200529                                                                                              CSE045
321400200529     C                   PARM                    @BDDSAFA                                     CSE045
321500200529      *                                                                                       CSE045
321600200529      ** Function Keys                                                                        CSE045
321700200529     C                   PARM                    PINKS                                        CSE045
321800200529                                                                                              CSE045
321900200529     C                   PARM                    PINKT                                        CSE045
322000200529      *                                                                                       CSE045
322100200529      ** OUTPUT                                                                               CSE045
322200200529      ** ======                                                                               CSE045
322300200529      *                                                                                       CSE045
322400200529      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE045
322500200529     C                   PARM                    FldNameArr                                   CSE045
322600200529     C                   PARM                    MsgIdArr                                     CSE045
322700200529     C                   PARM                    MsgDtaArr                                    CSE045
322800200529      *                                                                                       CSE045
322900200529      ** Array index (3P0) from/to caller                                                     CSE045
323000200529     C                   PARM                    IdX                                          CSE045
323100200529      *                                                                                       CSE045
323200200529      ** Warning flds/message IDs/message data (arrays) from/to caller                        CSE045
323300200529     C                   PARM                    WFldNamArr                                   CSE045
323400200529     C                   PARM                    WMsgIdArr                                    CSE045
323500200529     C                   PARM                    WMsgDtaArr                                   CSE045
323600200529      *                                                                                       CSE045
323700200529      ** Array index (3P0) from/to caller                                                     CSE045
323800200529     C                   PARM                    WIdX                                         CSE045
323900200529      *                                                                                       CSE045
324000200529      ** Security API Trades Extended Settlements Error Indicators                            CSE045
324100200529     C                   PARM                    SEETES                                       CSE045
324200200529      *                                                                                       CSE045
324300200529      ** Security API Trades Extended Settlements Valid File                                  CSE045
324400200529     C                   PARM                    ValidTX2B                                    CSE045
324500200529                                                                                              CSE045
324600200529     C                   ENDSR                                                                CSE045
324700200529      *****************************************************************
324800200529      /EJECT
324900200529      *****************************************************************
325000200529      *                                                               *
325100200529      * ValdateAmd - Routine to check whether the fields amended      *
325200200529      *    are amendable.                                             *
325300200529      *                                                               *
325400200529      *****************************************************************
325500200529     C     ValdateAmd    BEGSR
325600200529      *
325700200529      ** This subroutine calls a procedure which checks whether it
325800200529      ** was valid to Amend or Change any of the fields which have been
325900200529      ** altered.  Some are never amendable and some are amendable depending
326000200529      ** on the Action Code - "A" for Amend, "C" for Change.
326100200529
326200200529      ** To determine what fields have changed, the current fields
326300200529      ** on file must be converted to a 'screen' format.
326400200529
326500200529      ** These fields are then compared with the fields on the input
326600200529      ** transaction.
326700200529
326800200529      ** Any errors detected by the called procedure take precedence
326900200529      ** over any errors found during the validation of the complete
327000200529      ** transaction.  The errors from the called procedure are kept
327100200529      ** separately and, if any are found, these errors will REPLACE
327200200529      ** the normal validation errors.
327300200529
327400200529     C                   CALLB     'SETRADAMD'
327500200529      *
327600200529      * INPUTS
327700200529      *
327800200529      * Return Code
327900200529     C                   PARM                    RetCodeIn
328000200529      *
328100200529      * Incoming Trade in Screen Format :
328200200529 Form * - Primary Details
328300200529      * - Secondary Details
328400200529      * - Third Screen Details                                                                CAS006
328500200529      * - Exchange Rate Details
328600200529      * - Settlement Details
328700200529      * - Charge & Commission Details
328800200529      * - SWIFT Details A
328900200529      * - SWIFT Details B
329000200529     C                   PARM                    TraninPrim
329100200529     C                   PARM                    TraninSeco
329200200529     C                   PARM                    TraninThir                                   CAS006
329300200529     C                   PARM                    TraninExch
329400200529     C                   PARM                    TraninSett
329500200529     C                   PARM                    TraninChCm
329600200529     C                   PARM                    TraninSwfA
329700200529     C                   PARM                    TraninSwfB
329800200529      *
329900200529      * (Current) Trade in Screen Format :
330000200529 Form * - Primary Details
330100200529      * - Secondary Details
330200200529      * - Third Screen Details                                                                CAS006
330300200529      * - Exchange Rates Details
330400200529      * - Settlement Instructions
330500200529      * - Charges/Commissions
330600200529      * - SWIFT Details A
330700200529      * - SWIFT Details B
330800200529     C                   PARM                    CurTrPrim
330900200529     C                   PARM                    CurTrSeco
331000200529     C                   PARM                    CurTrThir                                    CAS006
331100200529     C                   PARM                    CurTrExch
331200200529     C                   PARM                    CurTrSett
331300200529     C                   PARM                    CurTrChCm
331400200529     C                   PARM                    CurTrSwftA
331500200529     C                   PARM                    CurTrSwftB
331600200529      *
331700200529      * Customer classification
331800200529      * Trade incomplete ind
331900200529      * Trade Date Made Complete
332000200529     C                   PARM                    CustClass
332100200529     C                   PARM                    TINC
332200200529     C                   PARM                    TDMC
332300200529                                                                                              CAS006
332400200529      ** Settlement Currency Decimal Places                                                   CAS006
332500200529                                                                                              CAS006
332600200529     C                   PARM                    SetCcyDec                                    CAS006
332700200529                                                                                              CAS006
332800200529      ** Hedge Accounting Phase B                                                             CAS006
332900200529                                                                                              CAS006
333000200529     C                   PARM                    CAS006                                       CAS006
333100200529      *
333200200529      * OUTPUTS
333300200529      *
333400200529      * Error Indicators
333500200529     C                   PARM                    OKTrPrim
333600200529     C                   PARM                    OKTrSeco
333700200529     C                   PARM                    OKTrThir                                     CAS006
333800200529     C                   PARM                    OKTrExch
333900200529     C                   PARM                    OKTrSett
334000200529     C                   PARM                    OKTrChCm
334100200529     C                   PARM                    OKTrSwft
334200200529      *
334300200529      * Error fields/message IDs/message data (arrays) from/to caller
334400200529     C                   PARM                    AmFldNamAr
334500200529     C                   PARM                    AmMsgIdArr
334600200529     C                   PARM                    AmMsgDtaAr
334700200529      *
334800200529      * Array index (3P0) from/to caller
334900200529     C                   PARM                    AmIdx
335000200529      *
335100200529      * Amendments OK
335200200529     C                   PARM                    AmendOk           1
335300200529      *
335400200529      * Reset of Fields in Error Required (Y/N)
335500200529     C                   PARM      'Y'           ResetErrs         1
335600200529
335700200529      ** If any errors overwrite previous error information
335800200529
335900200529     C                   IF        AmIdx <> 0
336000200529     C                   MOVEA     AmMsgIdArr    MsgidArr
336100200529     C                   MOVEA     AmFldNamAr    FldNameArr
336200200529     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
336300200529     C                   Z-ADD     AmIdx         Idx
336400200529     C                   ENDIF
336500200529
336600200529     C                   ENDSR
336700200529      *****************************************************************
336800200529      /EJECT
336900200529      *****************************************************************
337000200529      *                                                               *
337100200529      * Check/Write - Routine to control checking of error status and *
337200200529      *    sending of messgaes/writing to the database                *
337300200529      *                                                               *
337400200529      *****************************************************************
337500200529     C     CheckWrite    BEGSR
337600200529
337700200529      *  If no errors were found:
337800200529      *  - If Action Code is Insert and Trade Reference is not supplied
337900200529      *     - set up the trade reference
338000200529      *  - If there are still no errors
338100200529      *     - set up additional data
338200200529      *     - write a record to the Valid file
338300200529      *     - use std message handler to report trade status
338400200529      *  If any errors were found:
338500200529      *  - write a record to the Invalid file
338600200529      *  - call the message handler to pass the errors back
338700200529      *  - use std message handler to report trade status
338800200529      *  The index to the error arrays is checked for presence/absence of
338900200529      *   errors
339000200529     
339100200529      ** +--- Note for a later release -------------------------------+
339200200529      ** |                                                            |
339300200529      ** | At a later date this routine will have to cater for        |
339400200529      ** | warning messages.  The following logic will have to be     |
339500200529      ** | inserted before "If no errors were found", in the          |
339600200529      ** | above comments (and the code):                             |
339700200529      ** |                                                            |
339800200529      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
339900200529      ** | any warning messages were returned (WIdx <> 0)             |
340000200529      ** |                                                            |
340100200529      ** | -   If errors exist                                        |
340200200529      ** |     -     Add the warning array index to the error array   |
340300200529      ** |           index                                            |
340400200529      ** |     -     Append the contents of the warning arrays to the |
340500200529      ** |           end of the error arrays                          |
340600200529      ** | -   Else                                                   |
340700200529      ** |     -     Set the error array index equal to the warning   |
340800200529      ** |           array index                                      |
340900200529      ** |     -     Copy the contents of the warning arrays to the   |
341000200529      ** |           error arrays                                     |
341100200529      ** | -   Endif                                                  |
341200200529      ** |                                                            |
341300200529      ** | Endif                                                      |
341400200529      ** |                                                            |
341500200529      ** | Note that the "If errors exist ... Else ... " block above  |
341600200529      ** | can probably be implemented unconditionally (ie the same   |
341700200529      ** | logic will apply whether errors exist as well as warnings  |
341800200529      ** | or not).  It is shown in the above form for clarity.       |
341900200529      ** |                                                            |
342000200529      ** +------------------------------------------------------------+
342100200529
342200200529     C     Idx           IFEQ      0
342300200529
342400200529     C                   IF        DDACTN = 'I'
342500200529     C                   EXSR      SETUPTRADR
342600200529     C                   ENDIF
342700200529
342800200529     C     Idx           IFEQ      0
342900200529     C                   EXSR      SETUPVALID
343000200529     C                   WRITE     SEVTRADD0
343100200529     C     S01401        IFEQ      'Y'
343200200529     C                   MOVE      ValidTX1A     ValidTrX1
343300200529     C                   EVAL      V_T1TDRF = V_TDRF
343400200529     C                   EVAL      V_T1FRNT = APFOTranID
343500200529     C                   EVAL      V_T1AFRT = APFOAsocID
343600200529     C                   EVAL      V_T1TMES = TimeStamp
343700200529     C                   WRITE     SEVTRX1PD0
343800200529     C                   MOVE      ValidTX1B     ValidTrX1
343900200529     C                   EVAL      V_T1TDRF = V_TDRF
344000200529     C                   EVAL      V_T1FRNT = APFOTranID
344100200529     C                   EVAL      V_T1AFRT = APFOAsocID
344200200529     C                   EVAL      V_T1TMES = TimeStamp
344300200529     C     V_T1WHEN      IFEQ      'B'
344400200529     C                   WRITE     SEVTRX1PD0
344500200529     C                   END
344600200529      *
344700200529      ** Write directly to the extension file.  The information held on                       CSE039
344800200529      *  the extension file is only used to update the Movement Status                        CSE039
344900200529      *  file and therefore it is not necessary to write to a valid file                      CSE039
345000200529     C     CSE039        IFEQ      'Y'                                                        CSE039
345100200529     C                   EVAL      T3TDRF = V_TDRF                                            CSE039
345200200529     C                   EVAL      T3INOR = DDINOR                                            CSE039
345300200529     C                   EVAL      T3MSGK = DDMSGK                                            CSE039
345400200529     C                   EVAL      T3NTMT = DDNTMT                                            CSE039
345500200529     C                   EVAL      T3FRNT = APFOTranID                                        CSE039
345600200529     C                   EVAL      T3AFRT = APFOAsocID                                        CSE039
345700200529     C                   EVAL      T3TMST = TimeStamp                                         CSE039
345800200529     C                   WRITE     TRADSDD3                                                   CSE039
345900200529     C                   ENDIF                                                                CSE039
346000200529      *
346100200529     C                   END
346200200529      *                                                                                       CSE045
346300200529      ** Write Valid Extended Settlements when Enhancement is available                       CSE045
346400200529      *                                                                                       CSE045
346500200529     C                   IF        CSE045 = 'Y'                                               CSE045
346600200529     C                   MOVE      ValidTX2A     ValidTrX2                                    CSE045
346700200529     C                   EVAL      V_T2TDRF = V_TDRF                                          CSE045
346800200529     C                   EVAL      V_T2FRNT = APFOTranID                                      CSE045
346900200529     C                   EVAL      V_T2AFRT = APFOAsocID                                      CSE045
347000200529     C                   EVAL      V_T2TMST = TimeStamp                                       CSE045
347100200529     C                   EVAL      V_T2WHEN = 'A'                                             CSE045
347200200529     C                   WRITE     SEVTRX2D0                                                  CSE045
347300200529     C                   MOVE      ValidTX2B     ValidTrX2                                    CSE045
347400200529     C                   EVAL      V_T2TDRF = V_TDRF                                          CSE045
347500200529     C                   EVAL      V_T2FRNT = APFOTranID                                      CSE045
347600200529     C                   EVAL      V_T2AFRT = APFOAsocID                                      CSE045
347700200529     C                   EVAL      V_T2TMST = TimeStamp                                       CSE045
347800200529     C     V_T2WHEN      IFEQ      'B'                                                        CSE045
347900200529     C                   WRITE     SEVTRX2D0                                                  CSE045
348000200529     C                   ENDIF                                                                CSE045
348100200529     C                   ENDIF                                                                CSE045
348200200529                                                                                              CSE045
348300200529     C                   EXSR      CallMsgHdl
348400200529     C                   ENDIF
348500200529
348600200529     C                   ENDIF
348700200529
348800200529     C     Idx           IFGT      0
348900200529     C                   EXSR      SETUPINVAL
349000200529      *                                                                         CAP004
349100200529      * Only write to invalid files if repair in back office                    CAP004
349200200529      *                                                                         CAP004
349300200529     C     APRprLocn     IFEQ      'B'                                          CAP004
349400200529     C                   WRITE     SEITRADD0
349500200529                                                                                              CSC011
349600200529      ** If 24x7 Midas Availability is installed                                              CSC011
349700200529      ** and Support System is active                                                         CSC011
349800200529                                                                                              CSC011
349900200529     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
350000200529                                                                                              CSC011
350100200529     C                   EVAL      TRANSDTL = TranInPrim                                      CSC011
350200200529     C                                        + TranInSeco                                    CSC011
350300200529     C                                        + TranInExch                                    CSC011
350400200529     C                                        + TranInSett                                    CSC011
350500200529     C                                        + TranInChCm                                    CSC011
350600200529     C                                        + TranInSwfA                                    CSC011
350700200529     C                                        + TranInSwfB                                    CSC011
350800200529     C                                        + TranInThir                                    CAS006
350900200529     C                                        + InfData                                       CSC011
351000200529     C                                        + RegData                                       CER001
351100200529     C                                        + ExtData                                       CSC011
351200200529     C                   EVAL      APTGTTYPE = 'SETRAD'                                       CSC011
351300200529     C                   MOVEL     TDRF          PDealNo                                      CSC011
351400200529                                                                                              CSC011
351500200529      ** If there is no error, write the log file                                             CSC011
351600200529                                                                                              CSC011
351700200529     C                   CALLB     'APLOGTRAN'                                                CSC011
351800200529     C                   Parm      *Blanks       RetCodeOut                                   CSC011
351900200529     C                   Parm                    HeadIn                                       CSC011
352000200529     C                   Parm                    TRANSDTL                                     CSC011
352100200529     C                   Parm                    Timestamp                                    CSC011
352200200529     C                   Parm                    PDealNo                                      CSC011
352300200529     C                   Parm      *BLANKS       PADealNo                                     CSC011
352400200529                                                                                              CSC011
352500200529      ** If there is an error in either log file, end program                                 CSC011
352600200529                                                                                              CSC011
352700200529     C                   IF        RetCodeOut <> *Blanks                                      CSC011
352800200529     C     *LOCK         IN        LDA                                                        CSC011
352900200529     C                   MOVE      PDealNo       DBKEY                                        CSC011
353000200529     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
353100200529     C                   EVAL      DBASE = 2                                                  CSC011
353200200529     C                   OUT       LDA                                                        CSC011
353300200529     C                   EXSR      *PSSR                                                      CSC011
353400200529     C                   ENDIF                                                                CSC011
353500200529                                                                                              CSC011
353600200529     C                   ENDIF                                                                CSC011
353700200529                                                                                              CSC011
353800200529     C                   ENDIF                                                  CAP004
353900200529     C                   EXSR      CallMsgHdl
354000200529     C                   ENDIF
354100200529
354200200529     C                   If        (CSC022 <> 'Y')                                            CSC022
354300200529     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
354400200529     C                   COMMIT
354500200529     C                   EndIf                                                                CSC022
354600200529
354700200529     C                   ENDSR
354800200529      *****************************************************************
354900200529      /EJECT
355000200529      *****************************************************************
355100200529      *                                                               *
355200200529      * RESETCYCLE- Reset error information that is gradually         *
355300200529      *    updated during each run of this program                    *
355400200529      *                                                               *
355500200529      *****************************************************************
355600200529     C     RESETCYCLE    BEGSR
355700200529
355800200529     C                   RESET                   FldNameArr
355900200529     C                   RESET                   MsgIDArr
356000200529     C                   RESET                   MsgDtaArr
356100200529     C                   RESET                   Idx
356200200529
356300200529     C                   RESET                   WFldNamArr
356400200529     C                   RESET                   WMsgIDArr
356500200529     C                   RESET                   WMsgDtaArr
356600200529     C                   RESET                   WIdx
356700200529
356800200529     C                   RESET                   AmFldNamAr
356900200529     C                   RESET                   AmMsgIDArr
357000200529     C                   RESET                   AmMsgDtaAr
357100200529     C                   RESET                   AmIdx
357200200529
357300200529     C                   RESET                   FldNoArr
357400200529
357500200529     C                   CLEAR                   CurTrPrim
357600200529     C                   CLEAR                   CurTrSeco
357700200529     C                   CLEAR                   CurTrThir                                    CAS006
357800200529     C                   CLEAR                   CurTrExch
357900200529     C                   CLEAR                   CurTrSett
358000200529     C                   CLEAR                   CurTrChcm
358100200529     C                   CLEAR                   CurTrSwftA
358200200529     C                   CLEAR                   CurTrSwftB
358300200529
358400200529     C                   MOVE      *ALL'Y'       OKTrPrim
358500200529     C                   MOVE      *ALL'Y'       OKTrSeco
358600200529     C                   MOVE      *ALL'Y'       OKTrThir                                     CAS006
358700200529     C                   MOVE      *ALL'Y'       OKTrExch
358800200529     C                   MOVE      *ALL'Y'       OKTrSett
358900200529     C                   MOVE      *ALL'Y'       OKTrChcm
359000200529     C                   MOVE      *ALL'Y'       OKTrSwft
359100200529
359200200529     C                   CLEAR                   ValidTrad
359300200529     C                   CLEAR                   ValidTX1A
359400200529     C                   CLEAR                   ValidTX1B
359500200529     C                   CLEAR                   ValidTX2A                                    CSE045
359600200529     C                   CLEAR                   ValidTX2B                                    CSE045
359700200529      *                                                                                       CAP067
359800200529      ** Also clear numeric variables                                                         CAP067
359900200529      *                                                                                       CAP067
360000200529     C                   EXSR      SRCLER                                                     CAP067
360100200529
360200200529     C                   ENDSR
360300200529      *****************************************************************
360400200529      /EJECT                                                                                  CAP067
360500200529      *****************************************************************                       CAP067
360600200529      *                                                               *                       CAP067
360700200529      * SRCLER - Clear numeric variables                              *                       CAP067
360800200529      *                                                               *                       CAP067
360900200529      *****************************************************************                       CAP067
361000200529     C     SRCLER        BEGSR                                                                CAP067
361100200529                                                                                              CAP067
361200200529     C**********         Z-ADD     0             V_TCNR                                CAP067 CSD027
361300200529     C                   EVAL      V_TCNR = *BLANKS                                           CSD027
361400200529     C                   Z-ADD     0             V_NOML                                       CAP067
361500200529     C                   Z-ADD     0             V_TNMD                                       CAP067
361600200529     C                   Z-ADD     0             V_TPDY                                       CAP067
361700200529     C                   Z-ADD     0             V_TDVD                                       CAP067
361800200529     C                   Z-ADD     0             V_TDDT                                       CAP067
361900200529     C                   Z-ADD     0             V_TCAP                                       CAP067
362000200529     C                   Z-ADD     0             V_DADJ                                       CAP067
362100200529     C                   Z-ADD     0             V_ITRA                                       CAP067
362200200529     C                   Z-ADD     0             V_TINA                                       CAP067
362300200529     C                   Z-ADD     0             V_TDCR                                       CAP067
362400200529     C                   Z-ADD     0             V_PRIC                                       CAP067
362500200529     C                   Z-ADD     0             V_RALL                                       CAP067
362600200529     C                   Z-ADD     0             V_TDER                                       CAP067
362700200529     C                   Z-ADD     0             V_TBCR                                       CAP067
362800200529     C                   Z-ADD     0             V_SMTH                                       CAP067
362900200529     C                   Z-ADD     0             V_ASNM                                       CAP067
363000200529     C**********         Z-ADD     0             V_DELT                                CAP067 CSD027
363100200529     C**********         Z-ADD     0             V_DELF                                CAP067 CSD027
363200200529     C                   EVAL      V_DELT = *BLANKS                                           CSD027
363300200529     C                   EVAL      V_DELF = *BLANKS                                           CSD027
363400200529     C                   Z-ADD     0             V_TBCA                                       CAP067
363500200529     C                   Z-ADD     0             V_TCCA                                       CAP067
363600200529     C                   Z-ADD     0             V_TCA1                                       CAP067
363700200529     C                   Z-ADD     0             V_TCA2                                       CAP067
363800200529     C                   Z-ADD     0             V_TCA3                                       CAP067
363900200529     C                   Z-ADD     0             V_TCA4                                       CAP067
364000200529     C                   Z-ADD     0             V_TCA5                                       CAP067
364100200529     C                   Z-ADD     0             V_TCA6                                       CAP067
364200200529     C                   Z-ADD     0             V_TCA7                                       CAP067
364300200529     C                   Z-ADD     0             V_TAXA                                       CAP067
364400200529     C                   Z-ADD     0             V_BCMR                                       CAP067
364500200529     C                   Z-ADD     0             V_CCMR                                       CAP067
364600200529     C                   Z-ADD     0             V_TXRB                                       CAP067
364700200529     C                   Z-ADD     0             V_TIME                                       CAP067
364800200529     C                   Z-ADD     0             V_TOSN                                       CAP067
364900200529     C                   Z-ADD     0             V_TNSN                                       CAP067
365000200529     C                   Z-ADD     0             V_TNSP                                       CAP067
365100200529     C                   Z-ADD     0             V_TOSV                                       CAP067
365200200529     C                   Z-ADD     0             V_TVSN                                       CAP067
365300200529     C                   Z-ADD     0             V_TVSP                                       CAP067
365400200529     C                   Z-ADD     0             V_TDSN                                       CAP067
365500200529     C                   Z-ADD     0             V_TDSP                                       CAP067
365600200529     C                   Z-ADD     0             V_TDFS                                       CAP067
365700200529     C                   Z-ADD     0             V_TSSQ                                       CAP067
365800200529     C                   Z-ADD     0             V_TCSR                                       CAP067
365900200529     C                   Z-ADD     0             V_TCTR                                       CAP067
366000200529     C                   Z-ADD     0             V_TDMC                                       CAP067
366100200529     C                   Z-ADD     0             V_TOED                                       CAP067
366200200529     C                   Z-ADD     0             V_LCD                                        CAP067
366300200529     C                   Z-ADD     0             V_TNLU                                       CAP067
366400200529     C                   Z-ADD     0             V_LSWS                                       CAP067
366500200529     C                   Z-ADD     0             V_TCFC                                       CAP067
366600200529     C                   Z-ADD     0             V_SPXR                                       CAP067
366700200529     C                   Z-ADD     0             V_FXMP                                       CAP067
366800200529     C                   Z-ADD     0             V_FXMR                                       CAP067
366900200529     C                   Z-ADD     0             V_MAMT                                       CAP067
367000200529     C                   Z-ADD     0             V_ORDE                                       CAP067
367100200529     C                   Z-ADD     0             V_WHTX                                       CAP067
367200200529     C                   Z-ADD     0             V_ITRN                                       CAS006
367300200529     C                   Z-ADD     0             V_TINN                                       CAS006
367400200529     C                   Z-ADD     0             V_PRICN                                      CAS006
367500200529     C                   Z-ADD     0             VA_T1LSWS                                    CAP067
367600200529     C                   Z-ADD     0             VA_T1LSSC                                    CAP067
367700200529     C                   Z-ADD     0             VB_T1LSWS                                    CAP067
367800200529     C                   Z-ADD     0             VB_T1LSSC                                    CAP067
367900200529                                                                                              CAP067
368000200529     C                   ENDSR                                                                CAP067
368100200529      *****************************************************************                       CAP067
368200200529      /EJECT
368300200529      *****************************************************************
368400200529      *                                                               *
368500200529      * SETUPINVAL - Set up additional fields that are needed on the  *
368600200529      *        Valid file record.                                     *
368700200529      *                                                               *
368800200529      *****************************************************************
368900200529     C     SETUPINVAL    BEGSR
369000200529
369100200529      * Include Header fields that need to be o/p to the Invalid files
369200200529     C                   EVAL      DDFOtranID = APFOTranID
369300200529     C                   EVAL      DDFOAsocID = APFOAsocID
369400200529     C                   EVAL      DDRprLocn  = APRprLocn
369500200529     C                   EVAL      DDTMESTMP = TimeStamp
369600200529                                                                                CAP051
369700200529      * Setup the Automatic Autorisation Flag                                   CAP051
369800200529     C                   IF        CAP051 = 'Y'                                 CAP051
369900200529     C                   EVAL      DDAUTHA    = AUTHA                           CAP051
370000200529     C                   ENDIF                                                  CAP051
370100200529
370200200529     C                   EVAL      TranStatus = 'F'
370300200529
370400200529      /COPY WNCPYSRC,SETRADC014
370500200529     C                   ENDSR
370600200529      *****************************************************************
370700200529      /EJECT
370800200529      *****************************************************************
370900200529      *                                                               *
371000200529      * SETUPTRADR - Set up Trade Reference for Inserts               *
371100200529      *                                                               *
371200200529      *****************************************************************
371300200529     C     SETUPTRADR    BEGSR
371400200529
371500200529     C                   IF           DDTDRF = *blanks
371600200529     C                             OR DDTDRF = *zeros
371700200529
371800200529     C                   RESET                   ReturnCode
371900200529     C                   CALLB     'ZATRNRTV'
372000200529     C                   PARM      *BLANKS       ReturnCode
372100200529     C                   PARM      'SE'          MODU              2
372200200529     C                   PARM      'T'           TRTY              1
372300200529     C                   PARM                    DDTDRF
372400200529     C                   PARM      *ZERO         V_TDRF
372500200529
372600200529     C     ReturnCode    IFNE      *BLANK
372700200529     C                   ADD       1             Idx
372800200529     C                   EVAL      FldNameArr(Idx) = 'DDTDRF'
372900200529     C                   EVAL      MsgIDArr(Idx) = 'ZATRNRTV'
373000200529     C                   ENDIF
373100200529
373200200529      ** If trade reference was entered, put it in the file field
373300200529     C                   ELSE
373400200529     C                   MOVE      DDTDRF        V_TDRF
373500200529
373600200529     C                   ENDIF
373700200529
373800200529     C                   ENDSR
373900200529      *****************************************************************
374000200529      /EJECT                                                                                  210517
374100200529      *****************************************************************                       210517
374200200529      *                                                               *                       210517
374300200529      *  SRDfltTrX2A - Set up the default for TRADSDX2 for screen A   *                       210517
374400200529      *                                                               *                       210517
374500200529      *****************************************************************                       210517
374600200529     C     SRDfltTrX2A   BEGSR                                                                210517
374700200529                                                                                              210517
374800200529     C                   CALLB     'SETSWX2DFT'                                               210517
374900200529                                                                                              210517
375000200529      ** Screen (A or B)                                                                      210517
375100200529                                                                                              210517
375200200529     C                   PARM      'A'           Screen                                       210517
375300200529                                                                                              210517
375400200529      ** Trade Details (screen)                                                               210517
375500200529                                                                                              210517
375600200529     C                   PARM                    DDTDRF                                       210517
375700200529     C                   PARM                    DDTDTP                                       210517
375800200529     C                   PARM                    DDCNUM                                       210517
375900200529     C                   PARM                    DDSESN                                       210517
376000200529     C                   PARM                    DDBRCD                                       210517
376100200529     C                   PARM                    DDDELF                                       210517
376200200529     C                   PARM                    DDDELT                                       210517
376300200529     C                   PARM                    DDBPBK                                       210517
376400200529     C                   PARM                    DDSETC                                       210517
376500200529     C                   PARM                    DDMRKT                                       210517
376600200529                                                                                              210517
376700200529      ** OUTPUT PARAMETERS :                                                                  210517
376800200529      ** Screen A details                                                                     210517
376900200529                                                                                              210517
377000200529     C                   PARM                    TradSwX2A                                    210517
377100200529                                                                                              210517
377200200529      ** Screen B details                                                                     210517
377300200529                                                                                              210517
377400200529     C                   PARM                    TradSwX2B                                    210517
377500200529                                                                                              210517
377600200529     C                   ENDSR                                                                210517
377700200529      *****************************************************************                       210517
377800200529      /EJECT                                                                                  210517
377900200529      *****************************************************************                       210517
378000200529      *                                                               *                       210517
378100200529      *  SRDfltTrX2B - Set up the default for TRADSDX2 for screen B   *                       210517
378200200529      *                                                               *                       210517
378300200529      *****************************************************************                       210517
378400200529     C     SRDfltTrX2B   BEGSR                                                                210517
378500200529                                                                                              210517
378600200529     C                   CALLB     'SETSWX2DFT'                                               210517
378700200529                                                                                              210517
378800200529      ** Screen (A or B)                                                                      210517
378900200529                                                                                              210517
379000200529     C                   PARM      'B'           Screen                                       210517
379100200529                                                                                              210517
379200200529      ** Trade Details (screen)                                                               210517
379300200529                                                                                              210517
379400200529     C                   PARM                    DDTDRF                                       210517
379500200529     C                   PARM                    DDTDTP                                       210517
379600200529     C                   PARM                    DDCNUM                                       210517
379700200529     C                   PARM                    DDSESN                                       210517
379800200529     C                   PARM                    DDBRCD                                       210517
379900200529     C                   PARM                    DDDELF                                       210517
380000200529     C                   PARM                    DDDELT                                       210517
380100200529     C                   PARM                    DDBPBK                                       210517
380200200529     C                   PARM                    DDSETC                                       210517
380300200529     C                   PARM                    DDMRKT                                       210517
380400200529                                                                                              210517
380500200529      ** OUTPUT PARAMETERS :                                                                  210517
380600200529      ** Screen A details                                                                     210517
380700200529                                                                                              210517
380800200529     C                   PARM                    TradSwX2A                                    210517
380900200529                                                                                              210517
381000200529      ** Screen B details                                                                     210517
381100200529                                                                                              210517
381200200529     C                   PARM                    TradSwX2B                                    210517
381300200529                                                                                              210517
381400200529     C                   ENDSR                                                                210517
381500200529      *****************************************************************                       210517
381600200529      /EJECT
381700200529      *****************************************************************
381800200529      *                                                               *
381900200529      * SETUPVALID - Set up additional fields that are needed on the  *
382000200529      *    Valid file record.                                         *
382100200529      *                                                               *
382200200529      *****************************************************************
382300200529     C     SETUPVALID    BEGSR
382400200529
382500200529      * For Deletes & Authorises, put the complete (pre-existing) trade
382600200529      *  into the Valid file record
382700200529     C                   IF           DDACTN = 'D'
382800200529     C                             OR DDACTN = 'P'
382900200529     C                             OR DDACTN = 'Y'
383000200529     C                   MOVE      TradFilFmt    ValidTrad
383100200529     C                   MOVE      TX1AFilFmt    ValidTX1A
383200200529     C                   MOVE      TX1BFilFmt    ValidTX1B
383300200529     C                   ENDIF
383400200529
383500200529      * Set Valid file field(s) that are needed for all Action Codes
383600200529     C                   EVAL      V_CHTP = DDACTN
383700200529
383800200529      * Include Header fields that need to be o/p to the Valid file
383900200529     C                   EVAL      V_FRNT = APFOTranID
384000200529     C                   EVAL      V_AFRT = APFOAsocID
384100200529     C                   EVAL      V_REPA = APRprLocn
384200200529     C                   EVAL      V_TMST = TimeStamp
384300200529                                                                                CAP051
384400200529      * Automatic Authorisation flag                                            CAP051
384500200529     C                   IF        CAP051 = 'Y'                                 CAP051
384600200529     C                   EVAL      V_AUTH = AUTHA                               CAP051
384700200529     C                   ENDIF                                                  CAP051
384800200529
384900200529     C                   EVAL      TranStatus = 'S'
385000200529
385100200529      /COPY WNCPYSRC,SETRADC015
385200200529     C                   ENDSR
385300200529      *****************************************************************
385400200529      /EJECT
385500200529      *****************************************************************
385600200529      *                                                               *
385700200529      * CallMsgHdl - Call the Message Handling module                 *
385800200529      *                                                               *
385900200529      *****************************************************************
386000200529     C     CallMsgHdl    BEGSR
386100200529
386200200529      ** Set up an array of sequence numbers that correspond to the fields
386300200529      **  with errors
386400200529
386500200529     C                   Z-ADD     1             Ix
386600200529     C                   DO        ArrayMax
386700200529
386800200529     C     FldNameArr(Ix)IFNE      *BLANKS
386900200529
387000200529     C                   Z-ADD     1             Iy
387100200529     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
387200200529     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
387300200529
387400200529     C                   ELSE
387500200529
387600200529     C                   LEAVE
387700200529
387800200529     C                   ENDIF
387900200529
388000200529     C                   ADD       1             Ix
388100200529     C                   ENDDO
388200200529
388300200529     C                   RESET                   ReturnCode
388400200529
388500200529     C                   CALLB     'ZAMSGHNDLE'
388600200529      ** Return code (10A, returned to this procedure)
388700200529     C                   PARM                    ReturnCode
388800200529      ** Deal repair location (1A, from caller)
388900200529     C                   PARM                    APRprLocn
389000200529      ** Confirm validity to front office (1A, from caller)
389100200529     C                   PARM                    APCnfValFO
389200200529      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
389300200529     C                   PARM                    MsgIDArr
389400200529      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
389500200529     C                   PARM                    FldNoArr
389600200529      ** List of field names (Array of <ArrayMax>x10A names - from caller)
389700200529     C                   PARM                    FldNameArr
389800200529      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
389900200529     C                   PARM                    MsgDtaArr
390000200529      ** Front office transaction identifier (20A, from caller)
390100200529     C                   PARM                    APFOTranID
390200200529      ** Midas module ID (2A)
390300200529     C                   Parm                    ModuleID
390400200529      ** Midas transaction ID (6A, from caller)
390500200529     C                   PARM                    DDTDRF
390600200529      ** Message file (10A, from caller)
390700200529     C                   PARM                    #MsgFile
390800200529      ** Action code of transaction (1A, from transaction)
390900200529     C                   PARM                    DDACTN
391000200529      ** Status of transaction (1A, F=Failure, S=Success)
391100200529     C                   PARM                    TranStatus
391200200529      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
391300200529     C                   PARM                    APRespMode
391400200529      ** The following three parameters are needed when messages are to
391500200529      ** be displayed on a screen
391600200529      ** Screen-handling program (10A, from caller)
391700200529     C                   PARM                    #ProcPgm
391800200529      ** Screen-handling module (10A, from caller)
391900200529     C                   PARM                    #ProcMod
392000200529      ** Screen-handling procedure (10A, from caller)
392100200529     C                   PARM                    #ProcName
392200200529      ** The MQSeries queue to send replies to
392300200529     C                   PARM                    APRpyQueue
392400200529      ** The transaction's timestamp
392500200529     C                   PARM                    TimeStamp
392600200529      ** Additional message files to check (Array of <MsgFArrMax> x 10)
392700200529     C                   PARM                    MsgFArray
392800200529      ** Whether or not to clear the program message queue (1A)
392900200529     C                   PARM                    ClrPgmMsgQ
393000200529
393100200529     C                   ENDSR
393200200529      *****************************************************************
393300200529      /EJECT
393400200529     C/COPY ZACPYSRC,PSSR_ILE
393500200529      ********************************************************************
393600200529      /EJECT
393700200529      *****************************************************************
393800200529      *                                                               *
393900200529      * *INZSR - Program Initialisation routine                       *
394000200529      *                                                               *
394100200529      *****************************************************************
394200200529     C     *INZSR        BEGSR
394300200529
394400200529     C     *ENTRY        PLIST
394500200529      * Common header information (DS) from source system
394600200529     C                   PARM                    HeadIn
394700200529      * Transaction information
394800200529     C                   PARM                    Trans5001
394900200529     C                   PARM                    Trans5002
395000200529     C                   PARM                    Trans5003
395100200529     C                   PARM                    Trans5004
395200200529     C                   PARM                    Trans5005
395300200529     C                   PARM                    Trans5006
395400200529     C                   PARM                    Trans5007
395500200529     C****************** PARM                    Trans5008                      CAP051
395600200529     C                   PARM                    Trans5008                                    CAS006
395700200529     C                   PARM                    OthrData                                    CSF011A
395800200529     C                   PARM                    InfData500                     CAP051
395900200529     C                   PARM                    RegData500                                   CER001
396000200529     C                   PARM                    ExtData500                     CAP004
396100200529     C**********         PARM                    OthDData4755                         CSE045 CSF011A
396200200529      ** Ultimate calling Program/Module/Procedure
396300200529     C                   PARM                    #ProcPgm
396400200529     C                   PARM                    #ProcMod
396500200529     C                   PARM                    #ProcName
396600200529
396700200529      *  Set up the name of the MSGF from which the message handler will
396800200529      *   get the messages
396900200529     C                   EVAL      #MsgFile = 'DRSMM'
397000200529
397100200529      ** Set up the name of the primary and secomdary message files from
397200200529      ** which the message handler will get the messages
397300200529     C                   EVAL      #MsgFile     = 'SEUSRMSG'
397400200529     C                   EVAL      MsgFArray(1) = 'DRSMM'
397500200529
397600200529      *  Set up the Module ID, used to make the Transaction number unique
397700200529     C                   EVAL      ModuleID = 'SE'
397800200529
397900200529      *
398000200529      ** Access Bank details via access program
398100200529      *  (database error handling done in access program)
398200200529     C                   CALLB     'AOBANKR0'
398300200529     C                   PARM      '*DBERR '     @RTCD             7
398400200529     C                   PARM      '*FIRST '     @OPTN             7
398500200529     C     SDBANK        PARM      SDBANK        DSFDY
398600200529                                                                                CAP011
398700200529      ** Access API ICD via access program                                      CAP011
398800200529      *  (database error handling done in access program)                       CAP011
398900200529     C                   CALLB     'AOAPIR0'                                    CAP011
399000200529     C                   PARM      '*DBERR '     @RTCD                          CAP011
399100200529     C                   PARM      '*FIRST '     @OPTN                          CAP011
399200200529     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
399300200529      *
399400200529      ** Access Securities Trading details via access program
399500200529      *  (database error handling done in access program)
399600200529     C                   CALL      'AOSTRDR0'
399700200529     C                   PARM      '*DBERR '     @RTCD             7
399800200529     C                   PARM      '*FIRST  '    @OPTN             7
399900200529     C     SDSTRD        PARM      SDSTRD        DSSDY
400000200529      *
400100200529      ** Access MIDAS Modules details via access program
400200200529      *  (database error handling done in access program)
400300200529     C                   CALLB     'AOMMODR0'
400400200529     C                   PARM      '*DBERR '     @RTCD             7
400500200529     C                   PARM      '*FIRST '     @OPTN             7
400600200529     C     SDMMOD        PARM      SDMMOD        DSFDY
400700200529      *
400800200529      ** Access Portfolio Management details via access program
400900200529      *  (database error handling done in access program)
401000200529     C     BGPFMG        IFEQ      'Y'
401100200529     C                   CALLB     'AOPORTR0'
401200200529     C                   PARM      '*DBERR '     @RTCD
401300200529     C                   PARM      '*FIRST'      @OPTN
401400200529     C     SDPORT        PARM      SDPORT        DSFDY
401500200529     C                   ENDIF
401600200529      *
401700200529      ** Access SAR details file to determine if MT5XX Message
401800200529      ** Generation enhancement is switched on
401900200529      *
402000200529     C                   CALLB     'AOSARDR0'
402100200529     C                   PARM      *BLANKS       @RTCD
402200200529     C                   PARM      '*VERIFY'     @OPTN
402300200529     C                   PARM      'S01401'      @SARD             6
402400200529     C     SCSARD        PARM      SCSARD        DSFDY
402500200529     C     @RTCD         IFEQ      *BLANK
402600200529     C                   MOVEL     'Y'           S01401            1
402700200529     C                   ELSE
402800200529     C                   MOVEL     'N'           S01401
402900200529     C                   END
403000200529      *
403100200529      ** Access SAR details file to determine if Customer Commissions
403200200529      ** (courtage) enhancement is switched on
403300200529      *
403400200529     C                   CALLB     'AOSARDR0'
403500200529     C                   PARM      *BLANKS       @RTCD
403600200529     C                   PARM      '*VERIFY'     @OPTN
403700200529     C                   PARM      'S01446'      @SARD             6
403800200529     C     SCSARD        PARM      SCSARD        DSFDY
403900200529     C     @RTCD         IFEQ      *BLANK
404000200529     C                   MOVEL     'Y'           S01446            1
404100200529     C                   ELSE
404200200529     C                   MOVEL     'N'           S01446
404300200529     C                   END
404400200529      *
404500200529      ** Access SAR details file to determine if Private Banking
404600200529      ** securities enhancements is switched on
404700200529      *
404800200529     C                   CALLB     'AOSARDR0'
404900200529     C                   PARM      *BLANKS       @RTCD
405000200529     C                   PARM      '*VERIFY'     @OPTN
405100200529     C                   PARM      'S01496'      @SARD             6
405200200529     C     SCSARD        PARM      SCSARD        DSFDY
405300200529     C     @RTCD         IFEQ      *BLANK
405400200529     C                   MOVEL     'Y'           S01496            1
405500200529     C                   ELSE
405600200529     C                   MOVEL     'N'           S01496
405700200529     C                   END
405800200529      *
405900200529      ** Access SAR details file to determine if MT5XX Message
406000200529      ** Generation enhancement phase 2 is switched on
406100200529      *
406200200529     C                   CALLB     'AOSARDR0'
406300200529     C                   PARM      *BLANKS       @RTCD
406400200529     C                   PARM      '*VERIFY'     @OPTN
406500200529     C                   PARM      'CSW003'      @SARD             6
406600200529     C     SCSARD        PARM      SCSARD        DSFDY
406700200529     C     @RTCD         IFEQ      *BLANK
406800200529     C                   MOVEL     'Y'           CSW003            1
406900200529     C                   ELSE
407000200529     C                   MOVEL     'N'           CSW003
407100200529     C                   END
407200200529      *
407300200529      ** Access SAR details file to determine if TOF/Midas
407400200529      ** Interface is switched on
407500200529      *
407600200529     C                   CALLB     'AOSARDR0'
407700200529     C                   PARM      *BLANKS       @RTCD
407800200529     C                   PARM      '*VERIFY'     @OPTN
407900200529     C                   PARM      'CAP050'      @SARD             6
408000200529     C     SCSARD        PARM      SCSARD        DSFDY
408100200529     C     @RTCD         IFEQ      *BLANK
408200200529     C                   MOVEL     'Y'           CAP050            1
408300200529     C                   ELSE
408400200529     C                   MOVEL     'N'           CAP050
408500200529     C                   END
408600200529      *
408700200529      ** Access SAR details file to determine if EMU SE
408800200529      ** Settlement Currency Conversion is switched on
408900200529      *
409000200529     C                   CALLB     'AOSARDR0'
409100200529     C                   PARM      *BLANKS       @RTCD
409200200529     C                   PARM      '*VERIFY'     @OPTN
409300200529     C                   PARM      'CEU005'      @SARD             6
409400200529     C     SCSARD        PARM      SCSARD        DSFDY
409500200529     C     @RTCD         IFEQ      *BLANK
409600200529     C                   MOVEL     'Y'           CEU005            1
409700200529     C                   ELSE
409800200529     C                   MOVEL     'N'           CEU005
409900200529     C                   END
410000200529      *                                                                         CAP051
410100200529      ** Access SAR details file to determine if                                CAP051
410200200529      ** Automatic Authorisation (SE Part) is installed                         CAP051
410300200529      *                                                                         CAP051
410400200529     C                   MOVEL     'N'           CAP051            1            CAP051
410500200529     C                   CALL      'AOSARDR0'                                   CAP051
410600200529     C                   PARM      *BLANKS       @RTCD                          CAP051
410700200529     C                   PARM      '*VERIFY'     @OPTN                          CAP051
410800200529     C                   PARM      'CAP051'      @SARD                          CAP051
410900200529     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
411000200529      *                                                                         CAP051
411100200529     C     @RTCD         IFEQ      *BLANK                                       CAP051
411200200529     C                   MOVEL     'Y'           CAP051                         CAP051
411300200529     C                   ENDIF                                                  CAP051
411400200529                                                                                              CSW201
411500200529      ** Check if CSW201 - Swift 2001 Standards Update is installed                           CSW201
411600200529                                                                                              CSW201
411700200529     C                   CALL      'SWIF2001'                           9090                  CSW201
411800200529     C                   PARM      *BLANKS       @RTCD                                        CSW201
411900200529                                                                                              CSW201
412000200529     C                   IF        *IN90 = *OFF AND @RTCD = 'CSW2001'                         CSW201
412100200529     C                   EVAL      CSW201 = 'Y'                                               CSW201
412200200529     C                   ELSE                                                                 CSW201
412300200529     C                   EVAL      CSW201 = 'N'                                               CSW201
412400200529     C                   ENDIF                                                                CSW201
412500200529                                                                                             CSW206E
412600200529     C                   CALL      'SWIF2006'                                                CSW206E
412700200529     C                   PARM      *BLANKS       PRTCD                                       CSW206E
412800200529                                                                                             CSW206E
412900200529     C                   IF        PRTCD = 'CSW2006'                                         CSW206E
413000200529     C                   EVAL      CSW206 = 'Y'                                              CSW206E
413100200529     C                   ELSE                                                                CSW206E
413200200529     C                   EVAL      CSW206 = 'N'                                              CSW206E
413300200529     C                   ENDIF                                                               CSW206E
413400200529      *                                                                                       CSE028
413500200529      ** Check if CSE028 feature is installed                                                 CSE028
413600200529      *                                                                                       CSE028
413700200529     C                   CALLB     'AOSARDR0'                                                 CSE028
413800200529     C                   PARM      *BLANKS       @RTCD                                        CSE028
413900200529     C                   PARM      '*VERIFY'     @OPTN                                        CSE028
414000200529     C                   PARM      'CSE028'      @SARD                                        CSE028
414100200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE028
414200200529     C     @RTCD         IFEQ      *BLANK                                                     CSE028
414300200529     C                   MOVEL     'Y'           CSE028            1                          CSE028
414400200529     C                   ELSE                                                                 CSE028
414500200529     C                   MOVEL     'N'           CSE028                                       CSE028
414600200529     C                   ENDIF                                                                CSE028
414700200529      ** Check if CSE039 feature is installed                                                 CSE039
414800200529      *                                                                                       CSE039
414900200529     C                   CALLB     'AOSARDR0'                                                 CSE039
415000200529     C                   PARM      *BLANKS       @RTCD                                        CSE039
415100200529     C                   PARM      '*VERIFY'     @OPTN                                        CSE039
415200200529     C                   PARM      'CSE039'      @SARD                                        CSE039
415300200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE039
415400200529     C     @RTCD         IFEQ      *BLANK                                                     CSE039
415500200529     C                   MOVEL     'Y'           CSE039            1                          CSE039
415600200529     C                   ELSE                                                                 CSE039
415700200529     C                   MOVEL     'N'           CSE039                                       CSE039
415800200529     C                   ENDIF                                                                CSE039
415900200529      *                                                                                       CSE045
416000200529      ** Check if CSE045 feature is installed                                                 CSE045
416100200529      *                                                                                       CSE045
416200200529     C                   CALLB     'AOSARDR0'                                                 CSE045
416300200529     C                   PARM      *BLANKS       @RTCD                                        CSE045
416400200529     C                   PARM      '*VERIFY'     @OPTN                                        CSE045
416500200529     C                   PARM      'CSE045'      @SARD                                        CSE045
416600200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE045
416700200529     C     @RTCD         IFEQ      *BLANK                                                     CSE045
416800200529     C                   MOVEL     'Y'           CSE045            1                          CSE045
416900200529     C                   ELSE                                                                 CSE045
417000200529     C                   MOVEL     'N'           CSE045                                       CSE045
417100200529     C                   ENDIF                                                                CSE045
417200200529      *                                                                                       CSE045
417300200529      ** Access SAR file to determine if CSE022 is installed                                  CSE045
417400200529      *                                                                                       CSE045
417500200529     C                   CALLB     'AOSARDR0'                                                 CSE045
417600200529     C                   PARM      *BLANKS       @RTCD                                        CSE045
417700200529     C                   PARM      '*VERIFY'     @OPTN                                        CSE045
417800200529     C                   PARM      'CSE022'      @SARD                                        CSE045
417900200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE045
418000200529                                                                                              CSE045
418100200529     C                   IF        @RTCD = *BLANK                                             CSE045
418200200529     C                   EVAL      CSE022 = 'Y'                                               CSE045
418300200529     C                   EVAL      PGMNAM = 'SEDORFRTV'                                       CSE045
418400200529     C                   ELSE                                                                 CSE045
418500200529     C                   EVAL      CSE022 = 'N'                                               CSE045
418600200529     C                   ENDIF                                                                CSE045
418700200529      *                                                                                       CSE045
418800200529      ** Access SAR file to determine if CSW014 is installed                                  CSE045
418900200529      *                                                                                       CSE045
419000200529     C                   CALLB     'AOSARDR0'                                                 CSE045
419100200529     C                   PARM      *BLANKS       @RTCD                                        CSE045
419200200529     C                   PARM      '*VERIFY'     @OPTN                                        CSE045
419300200529     C                   PARM      'CSW014'      @SARD                                        CSE045
419400200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE045
419500200529                                                                                              CSE045
419600200529     C                   IF        @RTCD = *BLANK                                             CSE045
419700200529     C                   EVAL      CSW014 = 'Y'                                               CSE045
419800200529     C                   ELSE                                                                 CSE045
419900200529     C                   EVAL      CSW014 = 'N'                                               CSE045
420000200529     C                   ENDIF                                                                CSE045
420100200529      *                                                                                       CSE045
420200200529      ** Check to see if switchable feature CSW098 is on or if date is                        CSE045
420300200529      ** greater than 16 October 1998.                                                        CSE045
420400200529      *                                                                                       CSE045
420500200529     C                   CALL      'SWIFT98'                            99                    CSE045
420600200529     C                   PARM                    SWRTN                                        CSE045
420700200529                                                                                              CSE045
420800200529
420900200529      ** Check if CSC011 is installed                                                         CSC011
421000200529                                                                                              CSC011
421100200529     C                   CALLB     'AOSARDR0'                                                 CSC011
421200200529     C                   PARM      *BLANKS       PRTCD                                        CSC011
421300200529     C                   PARM      '*VERIFY'     POPTN                                        CSC011
421400200529     C                   PARM      'CSC011'      PSARD                                        CSC011
421500200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
421600200529                                                                                              CSC011
421700200529     C                   IF        PRTCD = *BLANKS                                            CSC011
421800200529     C                   EVAL      CSC011 = 'Y'                                               CSC011
421900200529     C                   IN        SC24X7                                                     CSC011
422000200529     C                   IN        SDSTAT                                                     CSC011
422100200529                                                                                              CSC011
422200200529     C                   ELSE                                                                 CSC011
422300200529     C                   EVAL      CSC011 = 'N'                                               CSC011
422400200529     C                   IF        PRTCD <> '*NRF'                                            CSC011
422500200529     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
422600200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
422700200529     C                   EVAL      DBASE = 1                                                  CSC011
422800200529     C                   EXSR      *PSSR                                                      CSC011
422900200529     C                   ENDIF                                                                CSC011
423000200529                                                                                              CSC011
423100200529     C                   ENDIF                                                                CSC011
423200200529                                                                                              CSC011
423300200529      ** Check if enhancement CAS006 (Hedge Accounting Phase B) is installed                  CAS006
423400200529                                                                                              CAS006
423500200529     C                   CALLB     'AOSARDR0'                                                 CAS006
423600200529     C                   PARM      *BLANKS       PRTCD                                        CAS006
423700200529     C                   PARM      '*VERIFY'     POPTN                                        CAS006
423800200529     C                   PARM      'CAS006'      PSARD                                        CAS006
423900200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
424000200529                                                                                              CAS006
424100200529     C                   IF        PRTCD = *BLANKS                                            CAS006
424200200529     C                   EVAL      CAS006 = 'Y'                                               CAS006
424300200529     C                   ELSE                                                                 CAS006
424400200529     C                   EVAL      CAS006 = 'N'                                               CAS006
424500200529     C                   ENDIF                                                                CAS006
424600200529                                                                                              CAS006
424700200529      ** Set up the name of the server/database updater data queue.
424800200529     C                   EVAL      DtaQName = 'APTRADDTQ'
424900200529
425000200529      *                                                                                       CSC022
425100200529      ** Access Switchable Features File, for CSC022                                          CSC022
425200200529      *                                                                                       CSC022
425300200529     C                   Eval      CSC022 = 'N'                                               CSC022
425400200529     C                   CallB     'AOSARDR0'                                                 CSC022
425500200529     C                   Parm      *BLANKS       PRTCD                                        CSC022
425600200529     C                   Parm      '*VERIFY'     POPTN                                        CSC022
425700200529     C                   Parm      'CSC022'      PSARD                                        CSC022
425800200529     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
425900200529      *                                                                                       CSC022
426000200529     C                   If        PRTCD = *Blanks                                            CSC022
426100200529     C                   Eval      CSC022 = 'Y'                                               CSC022
426200200529     C                   Eval      WCommitSkip = 'N'                                          CSC022
426300200529      *                                                                                       CSC022
426400200529     C                   In        SCCMTJOB                                                   CSC022
426500200529     C                   If        ComitNum > 0                                               CSC022
426600200529     C                   MoveA     ComitJob      WCmtJobArr                                   CSC022
426700200529      *                                                                                       CSC022
426800200529     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                  CSC022
426900200529     C                   If        *IN87 = *ON                                                CSC022
427000200529     C                   Eval      WCommitSkip = 'Y'                                          CSC022
427100200529     C                   EndIf                                                                CSC022
427200200529     C                   EndIf                                                                CSC022
427300200529      *                                                                                       CSC022
427400200529     C                   Else                                                                 CSC022
427500200529      *                                                                                       CSC022
427600200529      ** If return code <> *NRF, call program exception error routine                         CSC022
427700200529      *                                                                                       CSC022
427800200529     C                   If        PRTCD <> '*NRF'                                            CSC022
427900200529     C     *LOCK         IN        LDA                                                        CSC022
428000200529     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
428100200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
428200200529     C                   EVAL      DBASE = 3                                                  CSC022
428300200529     C                   OUT       LDA                                                        CSC022
428400200529     C                   Exsr      *PSSR                                                      CSC022
428500200529     C                   EndIf                                                                CSC022
428600200529     C                   EndIf                                                                CSC022
428700200529      *                                                                                       CSC022
428800200529      *                                                                                       CGL031
428900200529      ** Access SAR details file to determine if CGL031                                       CGL031
429000200529      ** (Taxation of Savings Income) is on.                                                  CGL031
429100200529      *                                                                                       CGL031
429200200529     C                   CALLB     'AOSARDR0'                                                 CGL031
429300200529     C                   PARM      *BLANKS       @RTCD                                        CGL031
429400200529     C                   PARM      '*VERIFY'     @OPTN                                        CGL031
429500200529     C                   PARM      'CGL031'      @SARD             6                          CGL031
429600200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
429700200529     C     @RTCD         IFNE      *BLANKS                                                    CGL031
429800200529     C     @RTCD         ANDNE     '*NRF   '                                                  CGL031
429900200529     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL031
430000200529     C                   MOVEL     '901'         DBASE                                        CGL031
430100200529     C                   MOVEL     'CGL031'      DBKEY                                        CGL031
430200200529     C                   EXSR      *PSSR                                                      CGL031
430300200529     C                   ENDIF                                                                CGL031
430400200529      *                                                                                       CGL031
430500200529     C     @RTCD         IFEQ      *BLANK                                                     CGL031
430600200529     C                   MOVEL     'Y'           CGL031                                       CGL031
430700200529     C                   ELSE                                                                 CGL031
430800200529     C                   MOVEL     'N'           CGL031                                       CGL031
430900200529     C                   ENDIF                                                                CGL031
431000200529      *                                                                                       CGL031
431100200529      ** Check if enhancement CGL014 (Collaterals Processing) is on                          BUG3145
431200200529                                                                                             BUG3145
431300200529     C                   CALLB     'AOSARDR0'                                                BUG3145
431400200529     C                   PARM      *BLANKS       PRTCD                                       BUG3145
431500200529     C                   PARM      '*VERIFY'     POPTN                                       BUG3145
431600200529     C                   PARM      'CGL014'      PSARD                                       BUG3145
431700200529     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3145
431800200529                                                                                             BUG3145
431900200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                 BUG3145
432000200529     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3145
432100200529     C                   EVAL      DBKEY  = 'CGL014'                                         BUG3145
432200200529     C                   EVAL      DBASE  = 912                                              BUG3145
432300200529     C                   EXSR      *PSSR                                                     BUG3145
432400200529     C                   ENDIF                                                               BUG3145
432500200529                                                                                             BUG3145
432600200529     C                   IF        PRTCD = *BLANKS                                           BUG3145
432700200529     C                   EVAL      CGL014 = 'Y'                                              BUG3145
432800200529     C                   ELSE                                                                BUG3145
432900200529     C                   EVAL      CGL014 = 'N'                                              BUG3145
433000200529     C                   ENDIF                                                               BUG3145
433100200529                                                                                             BUG3145
433200200529      *  Hook to enable non-core initial processing to be included
433300200529      /COPY WNCPYSRC,SETRADC019
433400200529      *                                                                                       CER001
433500200529      ** ULX603 - API Luxembourg - Function SETRAD                                            CER001
433600200529      *                                                                                       CER001
433700200529     C                   EVAL      ULX603 = 'N'                                               CER001
433800200529     C                   CALL      'AOSARDR0'                                                 CER001
433900200529     C                   PARM      *BLANKS       @RTCD                                        CER001
434000200529     C                   PARM      '*VERIFY'     @OPTN                                        CER001
434100200529     C                   PARM      'ULX603'      @SARD                                        CER001
434200200529      *                                                                                       CER001
434300200529     C                   IF        @RTCD=*BLANKS                                              CER001
434400200529     C                             AND BGLRIN = 'Y'                                           CER001
434500200529     C                   EVAL      ULX603 = 'Y'                                               CER001
434600200529     C                   OPEN      SEVTDLX1PD                                                 CER001
434700200529     C                   OPEN      SEITDLX1PD                                                 CER001
434800200529     C                   ENDIF                                                                CER001
434900200529      *                                                                                       CER001
435000200529      ** ULX008 - API Commissariat Aux Bourses (Funct. SEDPMV/SETRAD)                         CER001
435100200529      *                                                                                       CER001
435200200529     C                   EVAL      ULX008 = 'N'                                               CER001
435300200529     C                   CALL      'AOSARDR0'                                                 CER001
435400200529     C                   PARM      *BLANKS       @RTCD                                        CER001
435500200529     C                   PARM      '*VERIFY'     @OPTN                                        CER001
435600200529     C                   PARM      'ULX008'      @SARD                                        CER001
435700200529      *                                                                                       CER001
435800200529     C                   IF        @RTCD = *BLANKS                                            CER001
435900200529     C                   EVAL      ULX008 = 'Y'                                               CER001
436000200529     C                   ENDIF                                                                CER001
436100200529
436200200529      *                                                                                       CSW210
436300200529      ** Check to see if switchable feature CSW210 is on or if date is                        CSW210
436400200529      ** equal or greater than 20 November 2010.                                              CSW210
436500200529      *                                                                                       CSW210
436600200529     C                   CALL      'SWIF2010'                                                 CSW210
436700200529     C                   PARM      *BLANKS       PRTCD                                        CSW210
436800200529                                                                                              CSW210
436900200529     C                   IF        PRTCD = 'CSW2010'                                          CSW210
437000200529     C                   EVAL      CSW210 = 'Y'                                               CSW210
437100200529     C                   ELSE                                                                 CSW210
437200200529     C                   EVAL      CSW210 = 'N'                                               CSW210
437300200529     C                   ENDIF                                                                CSW210
437400200529      *                                                                                       CSW210
437500200529      ** Check to see if switchable feature CFT004 in on.                                     CSW210
437600200529      *                                                                                       CSW210
437700200529     C                   CALLB     'AOSARDR0'                                                 CSW210
437800200529     C                   PARM      *BLANKS       PRtCd                                        CSW210
437900200529     C                   PARM      '*VERIFY'     POptn                                        CSW210
438000200529     C                   PARM      'CFT004'      PSARD                                        CSW210
438100200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW210
438200200529                                                                                              CSW210
438300200529     C                   EVAL      CFT004 = 'N'                                               CSW210
438400200529                                                                                              CSW210
438500200529     C                   IF        PRtCd = *BLANKS                                            CSW210
438600200529     C                   EVAL      CFT004 = 'Y'                                               CSW210
438700200529     C                   ELSE                                                                 CSW210
438800200529                                                                                              CSW210
438900200529     C                   IF        PRtCd <> '*NRF   '                                         CSW210
439000200529     C     *LOCK         IN        LDA                                                        CSW210
439100200529     C                   EVAL      DBFile = 'SCSARDPD'                                        CSW210
439200200529     C                   EVAL      DBKey = PSARD                                              CSW210
439300200529     C                   EVAL      DBase = 913                                                CSW210
439400200529     C                   OUT       LDA                                                        CSW210
439500200529     C                   EXSR      *PSSR                                                      CSW210
439600200529     C                   ENDIF                                                                CSW210
439700200529                                                                                              CSW210
439800200529     C                   ENDIF                                                                CSW210
439900200529     C                   ENDSR
440000200529      *****************************************************************
440100200529**  CPY@
440200200529(c) Finastra International Limited 2001
