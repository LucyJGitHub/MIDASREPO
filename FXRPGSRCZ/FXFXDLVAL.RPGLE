000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas FX Deal validation')                             *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - Foreign Exchange Dealing Module                      *
000900200528      *                                                               *
001000200528      *  FXFXDLVAL - FX Deal Validation                               *
001100200528      *                                                               *
001200200528      *  Function: This Program Validates FX Deals for Input into     *
001300200528      *            the Midas database.                                *
001400200528      *                                                               *
001500200528      *  (c) Finastra International Limited 2001                      *
001600200528      *                                                               *
001700200604      *  Last Amend No. 250228             Date 22May20               *
001800200528      *  Prev Amend No. MD052014           Date 05Oct18               *
001900200528      *                 MD046248           Date 27Oct17               *
002000200528      *                 CDL099             Date 06Oct17               *
002100200528      *                 MD039203           Date 14Jun16               *
002200200528      *                 CDL094             Date 01Sep14               *
002300200528      *                 AR720772           Date 19Aug14               *
002400200528      *                 CDL091             Date 12Dec12               *
002500200528      *                 CSW212             Date 03May12               *
002600200528      *                 207288             Date 10Jun03               *
002700200528      *                 CSF011A            Date 28Nov11               *
002800200528      *                 CER059             Date 19Jul10               *
002900200528      *                 BUG25240B          Date 13Aug09               *
003000200528      *                 BUG23668           Date 01Apr09               *
003100200528      *                 BUG23050A          Date 20Mar09               *
003200200528      *                 CER043             Date 19May08               *
003300200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
003400200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
003500200528      *                 256564             Date 17Sep08               *
003600200528      *                 248269             Date 25Jun07               *
003700200528      *                 246386             Date 20Mar07               *
003800200528      * Midas Plus 1.4 Base ------------------------------------------*
003900200528      *                 245101             Date 31Jan07               *
004000200528      * Midas Plus 1.3 ----------- Base ------------------------------*
004100200528      *                 242477             Date 27Sep06               *
004200200528      *                 CSD031             Date 10Apr06               *
004300200528      *                 CDL049             Date 07Jul06               *
004400200528      *                 CGL058             Date 30Jun06               *
004500200528      *                 CSD027             Date 09Dec05               *
004600200528      *                 BUG10704           Date 13Mar06               *
004700200528      *                 BUG9717            Date 29Dec05               *
004800200528      *                 CDL038             Date 10May05               *
004900200528      *                 CDL029A            Date 09May05               *
005000200528      *                 CSW037A            Date 02May05               *
005100200528      *                 BUG6251            Date 17Mar05               *
005200200528      *                 CAS008             Date 16Jun04               *
005300200528      *                 BUG5517            Date 19Jan05               *
005400200528      *                 BUG6124            Date 03Mar05               *
005500200528      *                 CDL035             Date 28Feb05               *
005600200528      *                 BUG5578            Date 21Feb05               *
005700200528      *                 CSD025             Date 11Jan05               *
005800200528      *                 CSW037             Date 15Dec04               *
005900200528      *                 CSW036             Date 15Dec04               *
006000200528      *                 CDL029             Date 23Nov04               *
006100200528      *                 CFX114             Date 15Jun04               *
006200200528      *                 CLE025             Date 20Oct03               *
006300200528      *                 CGL029             Date 01Sep03               *
006400200528      *                 CAS005             Date 16Dec02               *
006500200528      *                 CDL010             Date 02Aug02               *
006600200528      *                 CDL011             Date 07Jul02               *
006700200528      *                 214936             Date 27Feb03               *
006800200528      * Midas Release 4.01.03 ----------------------------------------*
006900200528      *                 213799             Date 09Jan03               *
007000200528      * Midas Release 4.01.02 ----------------------------------------*
007100200528      *                 196952             Date 06May02               *
007200200528      *                 202132             Date 03Apr02               *
007300200528      *                 183759             Date 11Mar02               *
007400200528      * Midas Release 4.01 -------------------------------------------*
007500200528      *                 CSC011             Date 18Sep01               *
007600200528      *                 CAS001             Date 23Nov01               *
007700200528      *                 195763             Date 07Jan02               *
007800200528      * Midas Release 4 --------------- Base -------------------------*
007900200528      * Midas DBA 3.05 -----------------------------------------------*
008000200528      *                 184685             Date 19Jan01               *
008100200528      *                 CPB002             Date 08Aug00               *
008200200528      * Midas DBA 3.04 -----------------------------------------------*
008300200528      *                 CDL008             Date 02May00               *
008400200528      * Midas DBA 3.02 -----------------------------------------------*
008500200528      *                 CAP051             Date 11Nov99               *
008600200528      *                 CPB001             Date 01Sep99               *
008700200528      * Midas DBA 3.00 ---------------- Base -------------------------*
008800200528      *                 CAP004             Date 07Sep98               *
008900200528      *                 141077             Date 21Aug98               *
009000200528      *                 CAP002  *CREATE    Date 06OCT97               *
009100200528      *                                                               *
009200200528      *---------------------------------------------------------------*
009300200528      *                                                               *
009400200528      *  251863 - Applied fix 238023.                                 *
009500200528      *  238023 - Added parameter F3MGBS upon calling FXVEXCHVAM.     *
009600200528      *  MD052014 - Sale Value Date not defaulting correctly for Swap *
009700200528      *             Deals. Should be defaulted with the Core Value    *
009800200528      *             Date entered (CDL099).                            *
009900200528      *  MD046248 - Finastra Rebranding                               *
010000200528      *  CDL099 - Split Value Date                                    *
010100200528      *  MD039203 - When creating an FX Deal, the value of Forward    *
010200200528      *             points and sign were not save upon completion of  *
010300200528      *             the transaction                                   *
010400200528      *  CDL094 - Enhance  Receive Settlement Instructions            *
010500200528      *            (Recompile)                                        *
010600200528      *  AR720772 - Reverse fix BUG5578 to accept OT deal exchange    *
010700200528      *             rate not equal to related OP deal.                *
010800200528      *             (Child: AR720773)                                 *
010900200528      *  CDL091 - FX Auto Calculation (GIB016)                        *
011000200528      *         - Added hook :                                        *
011100200528      *             CDL091_012                                        *
011200200528      *             CDL091_013                                        *
011300200528      *             CDL091_014                                        *
011400200528      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
011500200528      *  207288 - Check spot indicator for deal type/subtype          *
011600200528      *           combination and issue warning message when needed.  *
011700200528      *           Applied for AR999664 (Child: AR999668)              *
011800200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
011900200528      *            (Recompile)                                        *
012000200528      *  CER059 - German Feature Upgrade to Delhi                     *
012100200528      *  BUG25240B - Reciprocal Rate Indicator Function (Recompile).  *
012200200528      *  BUG23668 - Defaulting of Reciprocal rate indicator when spot *
012300200528      *             rate is close to 1.                               *
012400200528      *  BUG23050A -Reciprocal rate indicator not defaulting.         *
012500200528      *             Defaulting of Reciprocal Rate indicator(FGE002).  *
012600200528      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
012700200528      *  256564 - Recompile due to PF changes done by fix 256330      *
012800200528      *  248269 - Use original spot rate in validating the exchange   *
012900200528      *           rate of an Option takedown deal.                    *
013000200528      *  246386 - Reset Their/Sell Yield Curve OK flag before call    *
013100200528      *           to ZAVYLDC01.                                       *
013200200528      *  245101 - Applied fix 231410.                                 *
013300200528      *  231410 - Divide by zero error when trying to amend an FX     *
013400200528      *           deal.  Execute SR/C_MGAM during insert mode.        *
013500200528      *  242477 - Applied fix 200709.  Incorrect deals update due to  *
013600200528      *           authorisation of 2nd leg of swap before authorising *
013700200528      *           the 1st leg.  Prevent authorisation of the 2nd leg  *
013800200528      *           if 1st leg is not yet authorised.                   *
013900200528      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
014000200528      *  CDL049 - Addition of a Reference Rate field                  *
014100200528      *  CGL058 - Default Branch Code                                 *
014200200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
014300200528      *  BUG10704 - If entered transaction customer is not valid      *
014400200528      *             or does not exist in file, validation of          *
014500200528      *             customer VS branch must not be carried out.       *
014600200528      *  BUG9717- Defaulting of class should be done when CDL038      *
014700200528      *           feature is currently ON.                            *
014800200528      *  CDL038 - Extended Deal Sub Type                              *
014900200528      *  CDL029A- Adding new field                                    *
015000200528      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
015100200528      *  BUG6251- Added parameter 'deal type' for use in defaulting   *
015200200528      *           of NBUY and NSEL indicators.                        *
015300200528      *  CAS008 - IAS 39 Enhancements                                 *
015400200528      *  BUG5517- Authorisation Error on FXDL.  Retrieve contents of  *
015500200528      *           DTAARA/ZMUSER moved out of INZSR                    *
015600200528      *  BUG6124 - Branch code error when CDL029 is set on.           *
015700200528      *  CDL035 - Validate Trade input date against CLS Cust Eff Date *
015800200528      *  BUG5578- Default and validate exchange rate for OT deals.    *
015900200528      *  CSD025 - Customer De-Activation                              *
016000200528      *  CSW037 - Additional Field Data on MT300/MT320                *
016100200528      *  CSW036 - Dual SWIFT BIC held on Client Details               *
016200200528      *  CDL029 - Midas SD Authorised Booking Branches for Customers  *
016300200528      *  CFX114 - Core changes for GBO014                             *
016400200528      *         - Perform Override when Exchange Rate Tolerance is    *
016500200528      *           exceeded.                                           *
016600200528      *         - Upgrade to Midasplus                                *
016700200528      *           Core hooks amended:FXFXDLVC02,FXFXDLV031,FXFXDLV027,*
016800200528      *                              FXFXDLV030,FXFXDLV032            *
016900200528      *           Core hooks added:FXFXDLVX01                         *
017000200528      *  CLE025 - Credit Lines (Recompile)                            *
017100200528      *  CGL029 - Increase Account Code to 10 digits                  *
017200200528      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
017300200528      *  CDL010 - Prevent last user that actioned the trade from      *
017400200528      *           authorising it.                                     *
017500200528      *  CDL011 - Expansion of Customer Number on Dealing Transactions*
017600200528      *  214936 - Exchange rate versus amount validation is being     *
017700200528      *           done during amendment even if the fields involved   *
017800200528      *           are not amendable.  This validation should be       *
017900200528      *           perform only during insertion.                      *
018000200528      *  213799 - Customer Selection screen issued twice with '?'     *
018100200528      *  196952 - Ensure rate has 5 digits before decimal separator   *
018200200528      *           and 8 digits after. Use DDRAT1 instead of DDRATE.   *
018300200528      *  202132 - Error while selecting customer number using '?' in  *
018400200528      *           the customer field.  User have to select a customer *
018500200528      *           twice before it gets accepted.                      *
018600200528      *  183759 - Allow insert/authorise FX deal even if Base Curr    *
018700200528      *           Equivalent exceeds to 20% tolerance range since     *
018800200528      *           error msg FXX0421 is only a warning message.        *
018900200528      *  CSC011   24x7 Midas Availability                             *
019000200528      *  CAS001 - Net Present Value (NPV) Accounting                  *
019100200528      *  195763 - Recompiled due to changes in FXVEXCHVAM.            *
019200200528      *  184685 - Recompiled due to changes in FXVCUSTBK.             *
019300200528      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
019400200528      *  CDL008 - Continuous Linked Settlement                        *
019500200528      *  CAP051 - Automatic Authorisation (FX Part)                   *
019600200528      *  CPB001 - 'Private Banking' Module                            *
019700200528      *  CAP004 - API's Phase 3.                                      *
019800200528      *           Add extra parm for Extra Data                       *
019900200528      *  141077 - Holiday validation of value date & option to date   *
020000200528      *  CAP002 - Conversion of Midas inputs to modular API structure *
020100200528      *                                                               *
020200200528      *****************************************************************
020300200528      ** +--------------------------------------+
020400200528      ** ¦ F-specs                              ¦
020500200528      ** ¦ =======                              ¦
020600200528      ** +--------------------------------------+
020700200528      *****************************************************************
020800200528
020900200528     FFXCDAFLL  IF   E             DISK    INFSR(*PSSR)
021000200528
021100200528     FSDABBCL0  IF   E           K DISK    INFSR(*PSSR)                                       CDL029
021200200528      ** Midas SD Authorised Booking Branches for Customers)                                  CDL029
021300200528                                                                                              CDL029
021400200528      * Hook to enable non-core files to be included
021500200528      /COPY WNCPYSRC,FXFXDLV030
021600200528
021700200528      *****************************************************************
021800200528      ** +--------------------------------------+
021900200528      ** ¦ Automatically included D-specs       ¦
022000200528      ** ¦ ==============================       ¦
022100200528      ** +--------------------------------------+
022200200528      **
022300200528      ** Standard D-specs
022400200528      ** ================
022500200528      **
022600200528      ** The following /COPY line includes the LDA layout,
022700200528      ** the copyright array definition,
022800200528      ** and the following named constants:
022900200528      **    True       logical = *on (for indcator processing)
023000200528      **    False      logical = *off (for indcator processing)
023100200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
023200200528      **                                    handler)
023300200528      ** and the following variables:
023400200528      **    RunBefore  1A (for the PSSR)
023500200528
023600200528     D/COPY ZACPYSRC,STD_D_SPEC
023700200528
023800200528      ** Program Status Data Structure
023900200528      ** =============================
024000200528      ** The following /COPY line includes all the defined fields in the
024100200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
024200200528
024300200528     D/COPY ZACPYSRC,PSDS
024400200528      ** The following /COPY line includes definitions for the above fields
024500200528      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
024600200528      ** corresponding fields in the PSDS /COPY member, so that member
024700200528      ** must be included where this one is used.
024800200528
024900200528     D/COPY ZACPYSRC,PROCPARMS
025000200528
025100200528      **--------------------------------------------------------------------------------------------
025200200528      ** The following /COPY line includes the definitions for error and
025300200528      ** warning message arrays.
025400200528     D/COPY ZACPYSRC,ERR_ARRAYS
025500200528      **--------------------------------------------------------------------------------------------
025600200528
025700200528      ** +--------------------------------------+
025800200528      ** ¦ End of automatically included D-specs¦
025900200528      ** ¦ =====================================¦
026000200528      ** +--------------------------------------+
026100200528
026200200528      *****************************************************************
026300200528      /EJECT
026400200528      *****************************************************************
026500200528
026600200528      ** +--------------------------------------+
026700200528      ** ¦ Manually included D-specs            ¦
026800200528      ** ¦ =========================            ¦
026900200528      ** +--------------------------------------+
027000200528
027100200528      ** +--------------------------------------+
027200200528      ** ¦ Named constants                      ¦
027300200528      ** ¦ ===============                      ¦
027400200528      ** +--------------------------------------+
027500200528
027600200528      ** The maximum size of the appended error arrays
027700200528     D XArrayMax       C                   CONST(20)
027800200528
027900200528      ** +--------------------------------------+
028000200528      ** ¦ Arrays and Data Structures           ¦
028100200528      ** ¦ ==========================           ¦
028200200528      ** +--------------------------------------+
028300200528
028400200528     D @SF             S             10  0 DIM(10) CTDATA PERRCD(1)
028500200528
028600200528
028700200528      ** Array of Fields in error.
028800200528     D FldNamXAr       S             10A   DIM(XArrayMax)
028900200528
029000200528      ** Array of error message IDs
029100200528     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
029200200528
029300200528      ** Array of error message data.
029400200528     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
029500200528
029600200528      ** Array of Fields with warnings.
029700200528     D WFldNmXAr       S             10A   DIM(XArrayMax)
029800200528
029900200528      ** Array of warning message IDs
030000200528     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
030100200528
030200200528      ** Array of warning message data.
030300200528     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
030400200528
030500200528     D RelDealDts      DS
030600200528      ** Related Deal Details (when deal is option takedown or swap.
030700200528      ** Thus related deal will be other leg of swap or option).
030800200528     D  RelDBRC                1      3
030900200528     D  RelCCY1                4      6
031000200528     D  RelCCY2                7      9
031100200528     D  RelDAM1               10     24  0
031200200528     D  RelDAM2               25     39  0
031300200528     D**RelDCNO*              40     45  0                                                    CSD027
031400200528     D  RelDCNO               40     45                                                       CSD027
031500200528     D  RelDCSN               46     55
031600200528     D  RelDDYY               56     59  0                                      deal date - year
031700200528     D  RelDDMM               60     61  0                                      deal date - mnth
031800200528     D  RelDDDD               62     63  0                                      deal date - day
031900200528     D  RelVDYY               64     67  0                                      val date - year
032000200528     D  RelVDMM               68     69  0                                      val date - mnth
032100200528     D  RelVDDD               70     71  0                                      val date - day
032200200528     D  RelDOEY               72     75  0                                      opt date - year
032300200528     D  RelDOEM               76     77  0                                      opt date - mnth
032400200528     D  RelDOED               78     79  0                                      opt date - day
032500200528     D  RelMGPT               80     86  2                                      opt date - day
032600200528     D  RelMGBS               87     87                                         opt date - day
032700200528     D  RelDXRT               88    100  8                                      opt date - day
032800200528     D  RelOSRT              101    113  8                                                    248269
032900200528
033000200528
033100200528
033200200528
033300200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
033400200528      ** EXTERNAL DS FOR BANK DETAILS
033500200528
033600200528     D SDGELR        E DS                  EXTNAME(SDGELRPD)
033700200528      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
033800200528
033900200528     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
034000200528     D SDDEALACCD    E                     EXTFLD(QQACCD)                                     CGL029
034100200528      ** EXTERNAL DS FOR DEALING DETAILS
034200200528
034300200528     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
034400200528     D SDTRADACCD    E                     EXTFLD(QQACCD)                                     CGL029
034500200528      ** EXTERNAL DS FOR Trading Data
034600200528
034700200528     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
034800200528      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
034900200528
035000200528     D SDTRMA        E DS                  EXTNAME(SDTRMAPD)                    S01319
035100200528      ** EXTERNAL DS FOR Treasury Management DETAILS
035200200528
035300200528     D SDPORT        E DS                  EXTNAME(SDPORTPD)
035400200528      ** EXTERNAL DS FOR Portfolio Management DETAILS
035500200528
035600200528     D SDRETL        E DS                  EXTNAME(SDRETLPD)
035700200528     D  SDRETLACCD   E                     EXTFLD(QQACCD)                                     CGL029
035800200528      ** EXTERNAL DS FOR RETAIL DETAILS
035900200528
036000200528     D SDCURR        E DS                  EXTNAME(SDCURRPD)
036100200528      ** EXTERNAL DS FOR CURRENCY DETAILS
036200200528
036300200528     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CPB002
036400200528      ** EXTERNAL DS FOR CUSTOMER DETAILS                                       CPB002
036500200528                                                                                CPB002
036600200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)
036700200528      ** EXTERNAL DS FOR SAR DETAILS
036800200528
036900200528     D DSFDY         E DS                  EXTNAME(DSFDY)
037000200528      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
037100200528
037200200528     D DSSDY         E DS                  EXTNAME(DSSDY)
037300200528      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
037400200528
037500200528     D DSLDY         E DS                  EXTNAME(DSLDY)                       CPB002
037600200528      * THIRD DS FOR ACCESS PROGRAMS, VERY LONG DATA STRUCTURE                  CPB002
037700200528
037800200528     D ValidDeal     E DS                  EXTNAME(FXVFXDLPD)
037900200528      * Valid Deals layout
038000200528                                                                                              CSC011
038100200528     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
038200200528      ** 24X7 status data area                                                                CSC011
038300200528                                                                                              CSC011
038400200528     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
038500200528      ** SD data area                                                                         CSC011
038600200528                                                                                              CDL099
038700200528     D InCDL099      E DS                  EXTNAME(FXDLEXPD)                                  CDL099
038800200528      * FX Deal Extra Data Layout Definition (input)                                          CDL099
038900200528                                                                                              CDL099
039000200528     D ZMUSER          DS            17
039100200528     D  ZUSER                  1     10                                                       CDL010
039200200528     D  BRC                   11     13
039300200528     D  DEPT                  14     16
039400200528
039500200528     D TranIn        E DS                  EXTNAME(FXFXDLPD)
039600200528      * Incoming Transaction
039700200528                                                                                CAP051
039800200528     D InfData       E DS                  EXTNAME(FXFXIFPD)                    CAP051
039900200528     D                                     PREFIX(IF_)                          CAP051
040000200528      * FX (FXDL) Extra Data - File (D/B) format                                CAP051
040100200528                                                                                CAP004
040200200528     D ExtData       E DS                  EXTNAME(FXFXEXPD)                    CAP004
040300200528      * FX Extra Data - File (D/B) format                                       CAP004
040400200528     D/COPY WNCPYSRC,FXH00128
040500200528                                                                                CPB002
040600200528      **  Front Office (2 First characters determine System Front Office)       CPB002
040700200528     D FrontOffice     DS            20                                         CPB002
040800200528     D  W_System               1      2                                         CPB002
040900200528
041000200528      ** +--------------------------------------+
041100200528      ** ¦ Declared variables                   ¦
041200200528      ** ¦ ==================                   ¦
041300200528      ** +--------------------------------------+
041400200528
041500200528      ** DEFINE FIELDS FOR ZDATE9
041600200528     D @DAYN           S              5P 0
041700200528     D @YMD            S              8S 0
041800200528     D @RETN           S              1A
041900200528
042000200528
042100200528      **   First scaling exponent
042200200528     D     @@SXP1      S              1S 0
042300200528      **   Second scaling exponent
042400200528     D     @@SXP2      S                   LIKE(@@SXP1)
042500200528      **   Base currency scaling exponent
042600200528     D     @@BCSP      S                   LIKE(@@SXP1)
042700200528
042800200528
042900200528      ** Index for arrays of of error message ids etc
043000200528     D Idx             S              3P 0
043100200528
043200200528      ** Index for arrays of of warning message ids etc
043300200528     D WIdx            S              3P 0
043400200528
043500200528      ** Index for arrays of of error message ids for CDL029                                  CDL029
043600200528     D P               S              3P 0                                                    CDL029
043700200528                                                                                              CDL029
043800200528      ** Flags to indicate whether transaction fields are valid
043900200528     D OKFlagsDS       DS
044000200528     D  DDActnOK                      1A
044100200528     D  DDDlnoOK                      1A
044200200528     D  DDDltpOK                      1A
044300200528     D  DDDlstOK                      1A
044400200528     D  DDFedfOK                      1A
044500200528     D  DDDldtOK                      1A
044600200528     D  DDBrsnOK                      1A
044700200528     D  DDBrkrOK                      1A
044800200528     D  DDBkrgOK                      1A
044900200528     D  DDSdnoOK                      1A
045000200528     D  DDCustOK                      1A
045100200528     D  DDVdatOK                      1A
045200200528     D  DDOdatOK                      1A
045300200528     D  DDBokcOK                      1A
045400200528     D  DDLnknOK                      1A
045500200528     D  DDPtfrOK                      1A
045600200528     D  DDBccyOK                      1A
045700200528     D  DDBamtOK                      1A
045800200528     D  DDNbuyOK                      1A
045900200528     D  DDRateOK                      1A
046000200528     D  DDFpntOK                      1A
046100200528     D  DDSignOK                      1A
046200200528     D  DDMginOK                      1A
046300200528     D  DDMbsiOK                      1A
046400200528     D  DDSccyOK                      1A
046500200528     D  DDSamtOK                      1A
046600200528     D  DDPrfcOK                      1A
046700200528     D  DDNselOK                      1A
046800200528     D  DDBceOK                       1A
046900200528     D  DDOrbrOK                      1A
047000200528     D  DDDbsrOK                      1A
047100200528     D  DDBbfpOK                      1A
047200200528     D  DDBbfsOK                      1A
047300200528     D  DDSbfpOK                      1A
047400200528     D  DDSbfsOK                      1A
047500200528     D  DDMtchOK                      1A
047600200528     D  DDCLSSOK                      1A                                        CDL008
047700200528     D  DDOylcOK                      1A                                                      CAS001
047800200528     D  DDTylcOK                      1A                                                      CAS001
047900200528     D  DDClasOK                      1A                                                      CDL038
048000200528     D  DDReinOK                      1A                                                      CER043
048100200528     D/COPY WNCPYSRC,FXH00060
048200200528
048300200528
048400200528      ** Receive / Pay Settlement Currency, Method & Nostro
048500200528     D RecSetCcy       S              3A
048600200528     D RecSetMeth      S              2S 0
048700200528     D RecNostro       S             18A                                                      CDL038
048800200528     D*RecNostro*******S             12A                                                      CDL038
048900200528     D PaySetCcy       S              3A
049000200528     D PaySetMeth      S              2S 0
049100200528     D PayNostro       S             18A                                                      CDL038
049200200528     D*PayNostro*******S             12A                                                      CDL038
049300200528
049400200528
049500200528      ** A code to indicate the calling function to the lower level modules
049600200528     D FXDL            S              4A   INZ('FXDL')
049700200528
049800200528      ** Response Mode, received as a parameter from the common header
049900200528     D RespMode        S              1A
050000200528                                                                                              CAS001
050100200528      ** Define fields used in CAS001                                                         CAS001
050200200528     D CAS001          S              1A                                                      CAS001
050300200528     D PYCFN           S              6A                                                      CAS001
050400200528     D PERTP           S              1A                                                      CAS001
050500200528     D PFwRv           S              1A                                                      CAS005
050600200528     D PFwYC           S              5A                                                      CAS005
050700200528     D PFCRv           S              1A                                                      CAS008
050800200528
050900200528      ** Fields defined for Enhancement CSC011                                                CSC011
051000200528     D CSC011          S              1A                                                      CSC011
051100200528     D PRtCd           S              7A                                                      CSC011
051200200528     D POptn           S              7A                                                      CSC011
051300200528     D PSard           S              6A                                                      CSC011
051400200528     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
051500200528                                                                                              CSC011
051600200528      ** Fields defined for Enhancement CDL010                                                CDL010
051700200528     D CDL010          S              1A                                                      CDL010
051800200528                                                                                              CDL010
051900200528      ** Fields defined for Enhancement CDL029                                                CDL029
052000200528     D CDL029          S              1A                                                      CDL029
052100200528                                                                                              CDL029
052200200528     D CDL038          S              1A                                                     BUG9717
052300200528     D CDL049          S              1A                                                      CDL049
052400200528      *                                                                                       CGL058
052500200528      ** CGL058 - Default Branch Code                                                         CGL058
052600200528      *                                                                                       CGL058
052700200528     D CGL058          S              1A   INZ('N')                                           CGL058
052800200528     D/COPY WNCPYSRC,FXH00018
052900200528     D CER043          S              1A                                                      CER043
053000200528     D CDL099          S              1A                                                      CDL099
053100200528     D
053200200528     D/COPY OFCPYSRCZ,CDL091_012                                                              CDL091
053300200528     D @YYYYMMDD       DS                                                                     CDL099
053400200528     D @YYYY                          4S 0                                                    CDL099
053500200528     D @MM                            2S 0                                                    CDL099
053600200528     D @DD                            2S 0                                                    CDL099
053700200528      *                                                                                       CDL099
053800200528      ** +--------------------------------------+
053900200528      ** ¦ End of D-specs                       ¦
054000200528      ** ¦ ==============                       ¦
054100200528      ** +--------------------------------------+
054200200528
054300200528      ** +----------------------------------------+
054400200528      ** ¦ Hook for non-core D-specs (all types)  ¦
054500200528      ** ¦ also any I-specs (if necessary)        ¦
054600200528      ** ¦ =====================================  ¦
054700200528      ** +----------------------------------------+
054800200528      /COPY WNCPYSRC,FXFXDLV031
054900200528
055000200528      *****************************************************************
055100200528      /EJECT
055200200528      ** +--- Start of Main processing -----------------------------------+
055300200528      ** ¦                                                                ¦
055400200528      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
055500200528      ** ¦ executed at program activation.                                ¦
055600200528      ** ¦                                                                ¦
055700200528      ** +----------------------------------------------------------------+
055800200528
055900200528      /COPY WNCPYSRC,FXFXDLV001
056000200528      *                                                                                      BUG5517
056100200528      **  Get default branch and user from ZMUSER                                            BUG5517
056200200528     C     *DTAARA       DEFINE                  ZMUSER                                      BUG5517
056300200528     C                   IN        ZMUSER                                                    BUG5517
056400200528     C                   UNLOCK    ZMUSER                                                    BUG5517
056500200528
056600200528      * Call Validation Modules in Sequence
056700200528
056800200528      *
056900200528      ** Validate Swap/Option Deal Number
057000200528      *
057100200528      /COPY WNCPYSRC,FXFXDLV002
057200200528
057300200528     C                   EXSR      VSODLNO
057400200528      *
057500200528      /COPY WNCPYSRC,FXFXDLV003
057600200528
057700200528      ***Validate*Deal*Type/Sub*Type*&*Fed*Funds*Ind                            CDL038
057800200528      **********************************************                            CDL038
057900200528      /COPY WNCPYSRC,FXFXDLV004
058000200528                                                                                CPB002
058100200528      * Defautl Deal Type/Sub type if necessary                                 CPB002
058200200528      *                                                                         CPB002
058300200528     C*****'?'**         SCAN      DDCUST                                 01           202132 213799
058400200528     C**********         IF        *IN01 <> *On                                        202132 213799
058500200528      *****************************************************************                202132 213799
058600200528     C                   Eval      P_Cust = *Blanks                             CPB002
058700200528     C                   Callb     'AOCUSTR1'                                   CPB002
058800200528     C                   Parm      *Blanks       @RTCD                          CPB002
058900200528     C                   Parm      '*KEY   '     @OPTN                          CPB002
059000200528     C                   Parm      DDCUST        @CUST            10            CPB002
059100200528     C                   Parm                    @KEY7             7            CPB002
059200200528     C     SDCUST        Parm      SDCUST        DSLDY                          CPB002
059300200528                                                                                              213799
059400200528     C                   SELECT                                                               213799
059500200528     C     @RTCD         WHENEQ    *BLANKS                                                    213799
059600200528     C                   MOVEL(P)  BBCUST        DDCUST                                       213799
059700200528     C     @RTCD         WHENEQ    '*NOSEL '                                                  213799
059800200528     C                   MOVEL     *BLANKS       DDCUST                                       213799
059900200528     C                   ENDSL                                                                213799
060000200528      *                                                                         CPB002
060100200528     C     BBPRBA        Ifeq      'Y'                                          CPB002
060200200528     C     @RTCD         Andeq     *Blanks                                      CPB002
060300200528     C                   Movel     BBCUST        P_Cust                         CPB002
060400200528     C                   Call      'PBDFST'                                     CPB002
060500200528     C                   Parm                    P_Cust            6            CPB002
060600200528     C                   Parm      DDDLTP        P_DType           2            CPB002
060700200528     C                   Parm      DDDLST        P_DSType          2            CPB002
060800200528     C                   Parm      DDACTN        P_Action          1            CPB002
060900200528                                                                                CPB002
061000200528      * Defautl Deal Type                                                       CPB002
061100200528     C     P_DType       Ifne      *Blanks                                      CPB002
061200200528     C                   Eval      DDDLTP = P_DType                             CPB002
061300200528     C                   Endif                                                  CPB002
061400200528                                                                                CPB002
061500200528      * Defautl Deal Sub Type                                                   CPB002
061600200528     C     P_DSType      Ifne      *Blanks                                      CPB002
061700200528     C                   Eval      DDDLST = P_DSType                            CPB002
061800200528     C                   Endif                                                  CPB002
061900200528     C                   Endif                                                  CPB002
062000200528
062100200528     C**********         ENDIF                                                         202132 213799
062200200528      **********                                                                       202132 213799
062300200528                                                                                CDL038
062400200528      ** Default Sub Type and Class                                             CDL038
062500200528      *                                                                         CDL038
062600200528     C                   IF        CDL038 = 'Y'                                              BUG9717
062700200528     C                   EXSR      DSUBTCLAS                                    CDL038
062800200528     C                   ENDIF                                                               BUG9717
062900200528                                                                                CDL038
063000200528      ** Validate Deal Type/Sub Type & Fed Funds Ind                            CDL038
063100200528      *                                                                         CDL038
063200200528     C                   EXSR      VDEALTPS
063300200528      *
063400200528      /COPY WNCPYSRC,FXFXDLV005
063500200528
063600200528      ** Validate Booking and Originating Branch
063700200528      *
063800200528      /COPY WNCPYSRC,FXFXDLV006
063900200528
064000200528     C                   IF        CGL058 <> 'Y'                                              CGL058
064100200528      *                                                                                       CGL058
064200200528     C                   EXSR      VBRANCHS
064300200528      *                                                                                       CGL058
064400200528     C                   ENDIF                                                                CGL058
064500200528      *
064600200528      /COPY WNCPYSRC,FXFXDLV007
064700200528
064800200528      ** Validate Deal Date, Value Date, Option To Date
064900200528      *
065000200528      /COPY WNCPYSRC,FXFXDLV008
065100200528
065200200528     C                   EXSR      VDATES
065300200528      *
065400200528      /COPY WNCPYSRC,FXFXDLV009
065500200528
065600200528      ** Validate Broker Code & Brokerage
065700200528      *
065800200528      /COPY WNCPYSRC,FXFXDLV010
065900200528
066000200528     C                   EXSR      VBROKRGE
066100200528      *
066200200528      /COPY WNCPYSRC,FXFXDLV011
066300200528
066400200528      ** Validate Customer, Book, Portfolio & Profit Centre
066500200528      *
066600200528      /COPY WNCPYSRC,FXFXDLV012
066700200528
066800200528     C                   EXSR      VCUSTBK
066900200528      *
067000200528      /COPY WNCPYSRC,FXFXDLV013
067100200528      *                                                                                       CGL058
067200200528     C                   IF        CGL058 = 'Y'                                               CGL058
067300200528     C                   EXSR      VBBBRCD                                                    CGL058
067400200528     C                   EXSR      VBRANCHS                                                   CGL058
067500200528     C                   ENDIF                                                                CGL058
067600200528
067700200528      ** Validate Linked Reference Number
067800200528      *
067900200528      /COPY WNCPYSRC,FXFXDLV014
068000200528
068100200528     C                   EXSR      VLNKN
068200200528      *
068300200528      /COPY WNCPYSRC,FXFXDLV015
068400200528      *                                                                                       CER043
068500200528      ** Validate Reciprocal Rate Indicator                                                   CER043
068600200528      *                                                                                       CER043
068700200528     C                   IF        CER043 = 'Y'                                               CER043
068800200528     C                   EXSR      SRVREIN                                                    CER043
068900200528     C                   ENDIF                                                                CER043
069000200528
069100200528      ** Validate Buy and Sell Currencies and Amounts
069200200528      *
069300200528      /COPY WNCPYSRC,FXFXDLV016
069400200528
069500200528     C                   EXSR      VBSAMTS
069600200528      *
069700200528      /COPY WNCPYSRC,FXFXDLV017
069800200528
069900200528      ** Validate Exchange Rate, Fwd Points & Sign
070000200528      *
070100200528      /COPY WNCPYSRC,FXFXDLV018
070200200528
070300200528     C                   EXSR      VEXCHRAT
070400200528      *
070500200528      /COPY WNCPYSRC,FXFXDLV019
070600200528
070700200528      ** Validate Margin & Other Forward Points
070800200528      ** only if S01453 is installed
070900200528      *
071000200528      /COPY WNCPYSRC,FXFXDLV020
071100200528
071200200528     C     S01453        IFEQ      'Y'
071300200528     C                   EXSR      VMARGIN
071400200528     C                   END
071500200528      *
071600200528      /COPY WNCPYSRC,FXFXDLV021
071700200528
071800200528      ** Validate Exchange Rate versus Amounts
071900200528      *
072000200528      /COPY WNCPYSRC,FXFXDLV022
072100200528
072200200528     C     DDRateOK      IFNE      'N'
072300200528     C     DDFpntOK      ANDNE     'N'
072400200528     C     DDSignOK      ANDNE     'N'
072500200528     C     DDMginOK      ANDNE     'N'
072600200528     C     DDMbsiOK      ANDNE     'N'
072700200528     C     DDBccyOK      ANDNE     'N'
072800200528     C     DDBAmtOK      ANDNE     'N'
072900200528     C     DDSccyOK      ANDNE     'N'
073000200528     C     DDSAmtOK      ANDNE     'N'
073100200528     C     DDACTN        ANDEQ     'I'                                                        214936
073200200528     C                   EXSR      DETRAT@FP
073300200528     C/COPY WNCPYSRC,FXH00021
073400200528     C                   EXSR      VEXCHVAM
073500200528     C                   END
073600200528      *
073700200528      /COPY WNCPYSRC,FXFXDLV023
073800200528
073900200528      ** Validate Base Currency Equivalent
074000200528      *
074100200528      /COPY WNCPYSRC,FXFXDLV024
074200200528
074300200528     C                   EXSR      VBSECYAE
074400200528      *
074500200528      /COPY WNCPYSRC,FXFXDLV025
074600200528
074700200528      ** Validate FX Netting fields
074800200528      ** only if CDL002 is installed and Customer and Value Date valid
074900200528      *
075000200528      /COPY WNCPYSRC,FXFXDLV026
075100200528
075200200528     C     CDL002        IFEQ      'Y'
075300200528     C     DDCustOK      ANDNE     'N'
075400200528     C     DDVdatOK      ANDNE     'N'
075500200528     C                   EXSR      VFXNETS
075600200528     C                   END
075700200528      *                                                                         CDL008
075800200528      ** Validate continous link settlement only if CDL008 is installed.        CDL008
075900200528     C                   IF        CDL008 = 'Y'                                 CDL008
076000200528     C                   EXSR      VFXCLSS                                      CDL008
076100200528     C                   ENDIF                                                  CDL008
076200200528                                                                                              CAS001
076300200528      ***Validate*Yield*Curves*if*CAS001*is*on*and*Deal*Type/Subtype                   CAS001 CDL038
076400200528      ** Validate Yield Curves if CAS001 is on and Deal Type/Subtype/Class                    CDL038
076500200528      ** have no error                                                                        CAS001
076600200528                                                                                              CAS001
076700200528     C                   IF        CAS001 = 'Y' AND                                           CAS001
076800200528     C                             DDDltpOK = 'Y' AND                                         CAS001
076900200528     C                             DDDlstOK = 'Y' AND                                         CDL038
077000200528     C                             DDClasOK = 'Y'                                             CDL038
077100200528     C*****************************DDDlstOK = 'Y'                                      CAS001 CDL038
077200200528     C/COPY WNCPYSRC,FXH00240
077300200528     C                   EXSR      SRVOYLC                                                    CAS001
077400200528     C                   EXSR      SRVTYLC                                                    CAS001
077500200528     C                   ENDIF                                                                CAS001
077600200528      *                                                                                       CDL049
077700200528      * Validate Reference Rate field                                                         CDL049
077800200528     C                   IF        CDL049 = 'Y'                                               CDL049
077900200528     C                   EXSR      VRRAT                                                      CDL049
078000200528     C                   ENDIF                                                                CDL049
078100200528      *                                                                                       CDL099
078200200528     C                   IF        CDL099 ='Y'                                                CDL099
078300200528      *                                                                                       CDL099
078400200528     C                   MOVE      *BLANKS       SVSVDT            6                        MD052014
078500200528      *                                                                                     MD052014
078600200528     C                   EXSR      RESETERRS                                                  CDL099
078700200528      *                                                                                       CDL099
078800200528      ** Call New Split Value Date Validation Module                                          CDL099
078900200528     C                   CALLB     'FXVSPVDT'                                                 CDL099
079000200528     C                   Parm                    RetCodeOut                                   CDL099
079100200528     C                   Parm                    DDSDAT                                       CDL099
079200200528     C                   Parm                    DDVDAT                                       CDL099
079300200528     C                   Parm                    DDSCCY                                       CDL099
079400200528     C                   Parm                    BJDFIN                                       CDL099
079500200528     C                   Parm                    FldNamXAr                                    CDL099
079600200528     C                   Parm                    MsgIDXAr                                     CDL099
079700200528     C                   Parm                    MsgDtaXAr                                    CDL099
079800200528     C                   Parm                    WFldNmXAr                                    CDL099
079900200528     C                   Parm                    WMsgIDXAr                                    CDL099
080000200528     C                   Parm                    WMsgDtXAr                                    CDL099
080100200528     C                   Parm                    OK#SVDT           1                          CDL099
080200200528     C**********         Parm                    SVSVDT            6                 CDL099 MD052014
080300200528     C                   Parm                    SVSVDT                                     MD052014
080400200528      *                                                                                       CDL099
080500200528      ** Update Valid File Parameters if Sell Value Date is valid                             CDL099
080600200528     C                   IF        OK#SVDT <> 'N'                                             CDL099
080700200528      *                                                                                       CDL099
080800200528     C                   EVAL      DDSDAT = SVSVDT                                            CDL099
080900200528      *                                                                                     MD052014
081000200528     C                   MOVE      *BLANKS       @@DATE            6                        MD052014
081100200528     C                   Z-ADD     *ZEROS        ValuDtDN          5 0                      MD052014
081200200528      *                                                                                       CDL099
081300200528      ** Convert to Midas Number                                                              CDL099
081400200528     C                   CALLB     'ZAVDATE'                                                  CDL099
081500200528     C                   PARM      *BLANK        RetCodeOut                                   CDL099
081600200528     C**********         PARM      DDSDAT        @@DATE            6                 CDL099 MD052014
081700200528     C                   PARM      DDSDAT        @@DATE                                     MD052014
081800200528     C                   PARM                    BJDFIN                                       CDL099
081900200528     C**********         PARM                    ValuDtDN          5 0               CDL099 MD052014
082000200528     C                   PARM                    ValuDtDN                                   MD052014
082100200528      *                                                                                       CDL099
082200200528      ** Convert to YYYYMMDD format                                                           CDL099
082300200528     C                   CALLB     'ZDATE9'                                                   CDL099
082400200528     C                   PARM      ValuDtDN      @DAYN                                        CDL099
082500200528     C                   PARM                    @YMD                                         CDL099
082600200528     C                   PARM                    @RETN                                        CDL099
082700200528      *                                                                                       CDL099
082800200528     C                   EVAL      @YYYYMMDD = %CHAR(@YMD)                                    CDL099
082900200528     C                   EVAL      F3VS2Y = @YYYY                                             CDL099
083000200528     C                   EVAL      F3VS2M = @MM                                               CDL099
083100200528     C                   EVAL      F3VS2D = @DD                                               CDL099
083200200528      *                                                                                       CDL099
083300200528     C                   EVAL      F3S2DN = ValuDtDN                                          CDL099
083400200528     C                   EVAL      F3S1DN = 0                                                 CDL099
083500200528     C                   ENDIF                                                                CDL099
083600200528      *                                                                                       CDL099
083700200528     C                   EXSR      UPDATERRS                                                  CDL099
083800200528      *                                                                                       CDL099
083900200528     C                   ENDIF                                                                CDL099
084000200528
084100200528      /COPY WNCPYSRC,FXFXDLV027
084200200528
084300200528      *  *-------------------------------------------------------*
084400200528      *  * If no errors set up outstanding fields for valid file *
084500200528      *  *-------------------------------------------------------*
084600200528
084700200528      /COPY WNCPYSRC,FXFXDLV028
084800200528
084900200528     C                   IF        Idx = 0
085000200528     C                   EXSR      SetupValid
085100200528     C                   ENDIF
085200200528      *
085300200528      /COPY WNCPYSRC,FXFXDLV029
085400200528
085500200528      * RETURN
085600200528      *
085700200528     C                   RETURN
085800200528      *****************************************************************
085900200528     C/EJECT
086000200528
086100200528      * Hook to enable non-core subroutines to be included
086200200528      /COPY WNCPYSRC,FXFXDLV032
086300200528
086400200528      *****************************************************************                       CGL058
086500200528      ** VBBBRCD  - Validate branch                                                           CGL058
086600200528      *****************************************************************                       CGL058
086700200528     C     VBBBRCD       BEGSR                                                                CGL058
086800200528      *                                                                                       CGL058
086900200528      ** Validate Booking and Originating Branch                                              CGL058
087000200528      *                                                                                       CGL058
087100200528     C                   CALLB     'FXVBBBRCD'                                                CGL058
087200200528      *                                                                                       CGL058
087300200528      ** Inputs                                                                               CGL058
087400200528      *                                                                                       CGL058
087500200528      ** Return Code                                                                          CGL058
087600200528      *                                                                                       CGL058
087700200528     C                   PARM                    DDACTN            1            Action        CGL058
087800200528     C                   PARM                    BJSBRC            3            Single        CGL058
087900200528     C                   PARM                    DDCUST           10            Counter       CGL058
088000200528     C                   PARM                    DDBRSN            3            Booking       CGL058
088100200528     C                   PARM                    DDORBR            3            Origin.       CGL058
088200200528                                                                                              CGL058
088300200528     C                   ENDSR                                                                CGL058
088400200528      *****************************************************************
088500200528      ** VSODLNO - Validate Swap/Option Deal Number
088600200528      *****************************************************************
088700200528     C     VSODLNO       BEGSR
088800200528
088900200528      * Reset variables updated by each module
089000200528
089100200528     C                   EXSR      RESETERRS
089200200528      *
089300200528      ** Validate Swap/Option Deal Number
089400200528      *
089500200528     C                   CALLB     'FXVSODLNO'
089600200528      *
089700200528      * INPUTS
089800200528      *
089900200528      ** Return Code
090000200528     C                   PARM                    RetCodeOut
090100200528      *
090200200528      ** Deal Screen fields
090300200528     C                   PARM                    DDACTN            1            action code
090400200528     C                   PARM                    DDDLNO            6            action code
090500200528     C                   PARM                    DDDLTP            2            action code
090600200528     C                   PARM                    DDBRKR            4            action code
090700200528     C                   PARM                    DDSDNO            6            SW/OP deal no
090800200528      *
090900200528      * ICD
091000200528     C**********         PARM                    BJRDNB            5 0                        CSC011
091100200528     C                   PARM                    WRunDay                                      CSC011
091200200528      *
091300200528      * OUTPUTS
091400200528      * Error fields/message IDs/message data (arrays) from/to caller
091500200528     C                   PARM                    FldNamXAr
091600200528     C                   PARM                    MsgIDXAr
091700200528     C                   PARM                    MsgDtaXAr
091800200528      *
091900200528      ** Swap/option deal no - OK
092000200528     C                   PARM                    DDSdnoOK          1              SW/OP deal no
092100200528      *
092200200528      ** Related deal details
092300200528     C                   PARM                    RelDealDts                       SW/OP deal no
092400200528     C                   PARM                    DDDTYP                                       242477
092500200528
092600200528      * Update error info with that returned from the validation module
092700200528
092800200528     C                   EXSR      UPDATERRS
092900200528      *
093000200528     C                   ENDSR
093100200528      *****************************************************************
093200200528     C/EJECT
093300200528      *****************************************************************
093400200528      ** VDEALTPS - Validate Deal Type/Sub Type & Fed Funds Ind
093500200528      *****************************************************************
093600200528     C     VDEALTPS      BEGSR
093700200528
093800200528      * Reset variables updated by each module
093900200528
094000200528     C                   EXSR      RESETERRS
094100200528      *
094200200528      ** Validate Deal Type/Sub Type & Fed Funds Ind
094300200528      *
094400200528     C                   CALLB     'FXVDEALTPS'
094500200528      *
094600200528      * INPUTS
094700200528      *
094800200528      ** Return Code
094900200528     C                   PARM                    RetCodeOut
095000200528      *
095100200528      ** Deal Screen fields
095200200528     C                   PARM                    DDDLTP            2            deal type
095300200528     C                   PARM                    DDDLST            2            deal sub type
095400200528     C                   PARM                    DDCLAS            4            class         CDL038
095500200528     C                   PARM                    DDFEDF            1            fed funds ind
095600200528     C                   PARM                    DDBCCY            3            buy ccy
095700200528     C                   PARM                    DDSCCY            3            sell ccy
095800200528      *
095900200528      * ICD
096000200528     C                   PARM                    BLUSCY            3
096100200528      *
096200200528      * OUTPUTS
096300200528      *
096400200528      * Error fields/message IDs/message data (arrays) from/to caller
096500200528     C                   PARM                    FldNamXAr
096600200528     C                   PARM                    MsgIDXAr
096700200528     C                   PARM                    MsgDtaXAr
096800200528      *
096900200528      ** Deal Type - OK
097000200528      ** Deal Sub-Type - OK
097100200528      ** Class         - OK                                                                   CDL038
097200200528      ** Federal Funds - OK
097300200528     C                   PARM                    DDDltpOK          1            deal type
097400200528     C                   PARM                    DDDlstOK          1            deal sub type
097500200528     C                   PARM                    DDClasOK          1            class         CDL038
097600200528     C                   PARM                    DDFedfOK          1            fed funds ind
097700200528
097800200528      * Update error info with that returned from the validation module
097900200528
098000200528     C                   EXSR      UPDATERRS
098100200528      *
098200200528     C                   ENDSR
098300200528      *****************************************************************
098400200528     C/EJECT
098500200528      *****************************************************************
098600200528      ** VBRANCHS - Validate Booking and Originating Branch
098700200528      *****************************************************************
098800200528     C     VBRANCHS      BEGSR
098900200528
099000200528      * Reset variables updated by each module
099100200528
099200200528     C                   EXSR      RESETERRS
099300200528      *
099400200528      *  Validate Booking and Originating Branch                                             `
099500200528      *
099600200528     C                   CALLB     'FXVBRANCHS'
099700200528      *
099800200528      * INPUTS
099900200528      *
100000200528      ** Return Code
100100200528     C                   PARM                    RetCodeOut
100200200528      *
100300200528      ** Deal Screen fields
100400200528     C                   PARM                    DDACTN            1            action code
100500200528     C                   PARM                    DDDLTP            2            deal type
100600200528     C                   PARM                    DDBRSN            3            booking branch
100700200528     C                   PARM                    DDORBR            3            origin. branch
100800200528      *
100900200528      ** Swap/Opt Deal no OK
101000200528     C                   PARM                    ddSDNOok          1              SW/OP deal no.
101100200528      *
101200200528      ** Related deal details
101300200528     C                   PARM                    RelDealDts                     SW/OP branch
101400200528      *
101500200528      ** ICD
101600200528     C                   PARM                    BJSBRC            3
101700200528     C                   PARM                    BKOBRU            1
101800200528     C                   PARM                    BKOBUV            1
101900200528      *
102000200528      ** Response mode (from caller (A=Asynchronous, S=Synchronous))
102100200528     C                   PARM                    RespMode          1
102200200528      *
102300200528      ** Default branch code from ZMUSER
102400200528     C                   PARM                    BRC               3
102500200528      *
102600200528      * OUTPUTS
102700200528      *
102800200528      * Error fields/message IDs/message data (arrays) from/to caller
102900200528     C                   PARM                    FldNamXAr
103000200528     C                   PARM                    MsgIDXAr
103100200528     C                   PARM                    MsgDtaXAr
103200200528      *
103300200528      ** Action code - OK
103400200528      ** Booking branch - OK
103500200528      ** Originating branch - OK
103600200528     C                   PARM                    DDActnOK          1              action code
103700200528     C                   PARM                    DDBrsnOK          1              booking branch
103800200528     C                   PARM                    DDOrbrOK          1              origin. branch
103900200528      *
104000200528      ** Deal Booking Branch & Originating Branch
104100200528     C                   PARM                    F3DBRC            3            booking branch
104200200528     C                   PARM                    F3ORBR            3            origin. branch
104300200528
104400200528      * Update error info with that returned from the validation module
104500200528
104600200528     C                   EXSR      UPDATERRS
104700200528      *
104800200528     C**********         IF        CDL029 ='Y'                                        CDL029 BUG6124
104900200528      **********                                                                      CDL029 BUG6124
105000200528     C*****KBRANCHAUTH   CHAIN     SDABBCL0                           91              CDL029 BUG6124
105100200528     C**********         IF        *IN91 = '1'                                        CDL029 BUG6124
105200200528     C**********         MOVE      'N'           DDBrsnOK                             CDL029 BUG6124
105300200528     C*****Idx**         ADD       1             P                                    CDL029 BUG6124
105400200528     C**********         MOVEL     'DDBRSN'      FldNameArr(P)                        CDL029 BUG6124
105500200528     C**********         MOVEL     'DDBRSN'      FldNamXAr(P)                         CDL029 BUG6124
105600200528     C**********         MOVEL     'FXM7001'     MsgIdArr(P)                          CDL029 BUG6124
105700200528     C**********         MOVEL     'FXM7001'     MsgIDXAr(P)                          CDL029 BUG6124
105800200528     C**********         END                                                          CDL029 BUG6124
105900200528      **********                                                                      CDL029 BUG6124
106000200528     C**********         END                                                          CDL029 BUG6124
106100200528      *                                                                                       CDL029
106200200528     C                   ENDSR
106300200528      *****************************************************************
106400200528     C/EJECT
106500200528      *****************************************************************
106600200528      ** VDATES - Validate Deal Date, Value Date, Option To Date
106700200528      *****************************************************************
106800200528     C     VDATES        BEGSR
106900200528
107000200528      * Reset variables updated by each module
107100200528
107200200528     C                   EXSR      RESETERRS
107300200528      *
107400200528      ** Validate Deal Date, Value Date, Option To Date
107500200528      *
107600200528     C/COPY WNCPYSRC,FXH00063
107700200528     C                   CALLB     'FXVDATES'
107800200528      *
107900200528      * INPUTS
108000200528      *
108100200528      ** Return Code
108200200528     C                   PARM                    RetCodeOut
108300200528      *
108400200528      ** Deal Screen fields
108500200528     C                   PARM                    DDACTN            1            action code
108600200528     C                   PARM                    DDDLTP            2            deal type
108700200528     C                   PARM                    DDDLST            2                          207288
108800200528     C                   PARM                    DDBRSN            3            booking branch
108900200528     C                   PARM                    DDDLDT            6            deal date
109000200528     C                   PARM                    DDVDAT            6            value date
109100200528     C                   PARM                    DDODAT            6            option to date
109200200528     C                   PARM                    DDBRKR            4            broker
109300200528     C                   PARM                    DDSDNO            6            SW/OP deal no.
109400200528     C                   PARM                    DDBCCY            3            141077
109500200528     C                   PARM                    DDSCCY            3            141077
109600200528      *
109700200528      ** Deal settlement instruction fields
109800200528     C                   PARM                    RecSetCcy
109900200528     C                   PARM                    RecSetMeth                     rec settle meth
110000200528     C                   PARM                    RecNostro
110100200528     C                   PARM                    PaySetCcy
110200200528     C                   PARM                    PaySetMeth                     pay settle meth
110300200528     C                   PARM                    PayNostro
110400200528      *
110500200528      ** Booking branch OK
110600200528      ** Swap/Opt Deal no OK
110700200528     C                   PARM                    DDBrsnOK          1            booking branch
110800200528     C                   PARM                    DDSdnoOK          1            SW/OP deal no.
110900200528     C                   PARM                    DDDltpOK          1                          207288
111000200528     C                   PARM                    DDDlstOK          1                          207288
111100200528      *
111200200528      ** Related deal details
111300200528     C                   PARM                    RelDealDts                     SW/OP branch
111400200528      *
111500200528      * Booking branch loc
111600200528     C                   PARM                    BkBrnLoc          3            book. branch loc
111700200528      *
111800200528      * ICD
111900200528      *
112000200528     C**********         PARM                    BJRDNB            5 0                        CSC011
112100200528     C                   PARM                    WRunDay                                      CSC011
112200200528     C                   PARM                    BJDFIN            1
112300200528     C                   PARM                    BJSBRC            3
112400200528     C                   PARM                    BJLCCY            3
112500200528     C                   PARM                    BJSLCD            3
112600200528     C                   PARM                    BJHOCY            3
112700200528      *
112800200528      * OUTPUTS
112900200528      *
113000200528      * Error fields/message IDs/message data (arrays) from/to caller
113100200528     C                   PARM                    FldNamXAr
113200200528     C                   PARM                    MsgIDXAr
113300200528     C                   PARM                    MsgDtaXAr
113400200528     C                   PARM                    WFldNmXAr                      141077
113500200528     C                   PARM                    WMsgIDXAr                      141077
113600200528     C                   PARM                    WMsgDtXAr                      141077
113700200528      *
113800200528      ** Date date - OK
113900200528      ** Value date - OK
114000200528      ** Option to date - OK
114100200528     C                   PARM                    DDDldtOK          1            deal date
114200200528     C                   PARM                    DDVdatOK          1            value date
114300200528     C                   PARM                    DDOdatOK          1            option to date
114400200528      *
114500200528      ** Deal deal date, value date, option to date
114600200528      *
114700200528     C                   PARM                    F3DDDN            5 0          deal date
114800200528     C                   PARM                    F3VDDN            5 0          deal date
114900200528     C                   PARM                    F3OTDN            5 0          deal date
115000200528
115100200528     C/COPY WNCPYSRC,FXH00064
115200200528      * Update error info with that returned from the validation module
115300200528
115400200528     C                   EXSR      UPDATERRS
115500200528      *
115600200528     C                   ENDSR
115700200528     C/COPY WNCPYSRC,FXH00129
115800200528      *****************************************************************
115900200528     C/EJECT
116000200528      *****************************************************************
116100200528      ** VBROKRGE - Validate Broker Code & Brokerage
116200200528      *****************************************************************
116300200528     C     VBROKRGE      BEGSR
116400200528
116500200528      * Reset variables updated by each module
116600200528
116700200528     C                   EXSR      RESETERRS
116800200528      *
116900200528      ** Validate Broker Code & Brokerage
117000200528      *
117100200528     C                   CALLB     'FXVBROKRGE'
117200200528      *
117300200528      * INPUTS
117400200528      *
117500200528      ** Return Code
117600200528     C                   PARM                    RetCodeOut
117700200528      *
117800200528      ** Deal Screen fields
117900200528     C                   PARM                    DDDLTP            2            deal type
118000200528     C                   PARM                    DDBRKR            4            broker
118100200528     C                   PARM                    DDBKRG           16            brokerage
118200200528      *
118300200528      * ICD
118400200528     C                   PARM                    BNDCSP            1            new dl status
118500200528      *
118600200528      * OUTPUTS
118700200528      *
118800200528      * Error fields/message IDs/message data (arrays) from/to caller
118900200528     C                   PARM                    FldNamXAr
119000200528     C                   PARM                    MsgIDXAr
119100200528     C                   PARM                    MsgDtaXAr
119200200528      *
119300200528      ** Broker - OK
119400200528      ** Brokerage - OK
119500200528     C                   PARM                    DDBrkrOK          1            broker
119600200528     C                   PARM                    DDBkrgOK          1            brokerage
119700200528      *
119800200528      ** Deal Broker, Brokerage and Broker ccy
119900200528      *
120000200528     C                   PARM                    F3BROK            4            broker
120100200528     C                   PARM                    F3BRKG           15 0          brokerage
120200200528     C                   PARM                    F3BKCY            3            broker ccy
120300200528
120400200528      * Update error info with that returned from the validation module
120500200528
120600200528     C                   EXSR      UPDATERRS
120700200528      *
120800200528     C                   ENDSR
120900200528      *****************************************************************
121000200528     C/EJECT
121100200528      *****************************************************************
121200200528      ** VCUSTBK - Validate Customer, Book, Portfolio & Profit Centre
121300200528      *****************************************************************
121400200528     C     VCUSTBK       BEGSR
121500200528
121600200528      * Reset variables updated by each module
121700200528
121800200528     C                   EXSR      RESETERRS
121900200528      *
122000200528      ** Validate Customer, Book, Portfolio & Profit Centre
122100200528      *
122200200528     C                   CALLB     'FXVCUSTBK'
122300200528      *
122400200528      * INPUTS
122500200528      *
122600200528      ** Return Code
122700200528     C                   PARM                    RetCodeOut
122800200528      *
122900200528      ** Deal Screen fields
123000200528     C                   PARM                    DDACTN            1            action code
123100200528     C                   PARM                    DDDLTP            2            deal type
123200200528     C                   PARM                    DDDLST            2            deal sub type
123300200528     C                   PARM                    DDBRSN            3            booking branch
123400200528      *
123500200528     C                   PARM                    DDCUST           10            customer
123600200528     C                   PARM                    DDBOKC            2            book
123700200528     C                   PARM                    DDPTFR            4            portfolio
123800200528     C                   PARM                    DDPRFC            4            profit centre
123900200528     C                   PARM                    DDNBUY            1            profit centre
124000200528     C                   PARM                    DDNSEL            1            profit centre
124100200528     C/COPY WNCPYSRC,FXH00130
124200200528      *
124300200528      ** Related deal details
124400200528     C                   PARM                    RelDealDts                     SW/OP branch
124500200528      *
124600200528      ** Swap/Opt Deal no OK
124700200528      ** Booking branch OK
124800200528     C                   PARM                    DDBrsnOK          1            booking branch
124900200528     C                   PARM                    DDSdnoOK          1            SW/OP deal no.
125000200528      *
125100200528      * ICD
125200200528     C                   PARM                    BNBCOP            1            new dl status
125300200528     C                   PARM                    BNBKCD            2            new dl status
125400200528     C                   PARM                    BGPFMG            1
125500200528     C                   PARM                    BGUDRS            1
125600200528     C                   PARM                    BKPRCU            1
125700200528     C                   PARM                    BKPCDU            1
125800200528     C                   PARM                    FCR997            4
125900200528     C                   PARM                    FCPORS            1
126000200528     C                   PARM                    BGN0ST            1
126100200528     C                   PARM                    CDL002            1
126200200528     C                   PARM                    BGN4ST            1            CPB001
126300200528      * Dept from ZMUSER
126400200528     C                   PARM                    DEPT              3
126500200528      * customer format
126600200528      * N = customer number, else customer shortname
126700200528     C                   PARM                    CustFormat        1
126800200528      *
126900200528      * OUTPUTS
127000200528      *
127100200528      * Error fields/message IDs/message data (arrays) from/to caller
127200200528     C                   PARM                    FldNamXAr
127300200528     C                   PARM                    MsgIDXAr
127400200528     C                   PARM                    MsgDtaXAr
127500200528      *
127600200528      ** Customer - OK
127700200528      ** Book - OK
127800200528      ** Portfolio - OK
127900200528      ** Profit Centre - OK
128000200528      ** Deal Type - OK
128100200528      ** Net Buy Ind - OK
128200200528      ** Net Sell Ind - OK
128300200528     C                   PARM                    DDCustOK          1            customer
128400200528     C                   PARM                    DDBokcOK          1            book
128500200528     C                   PARM                    DDPtfrOK          1            portfolio
128600200528     C                   PARM                    DDPrfcOK          1            profit centre
128700200528     C                   PARM                    DDDltpOK          1            profit centre
128800200528     C                   PARM                    DDNbuyOK          1            profit centre
128900200528     C                   PARM                    DDNselOK          1            profit centre
129000200528      *
129100200528      ** Deal Customer number/shortname, book, portfolio, profit centre
129200200528      *
129300200528     C                   PARM                    F3DCNO                         customer no
129400200528     C                   PARM                    F3DCSN           10            customer shtname
129500200528     C                   PARM                    F3BOKC            2            book
129600200528     C                   PARM                    F3PTFR            4            portfolio
129700200528     C                   PARM                    F3PRFC            4            profit centre
129800200528
129900200528      * Update error info with that returned from the validation module
130000200528
130100200528     C                   EXSR      UPDATERRS
130200200528      *
130300200528     C                   IF        CDL029 ='Y'                                               BUG6124
130400200528     C                             AND DDCustOK = 'Y'                                       BUG10704
130500200528      *                                                                                      BUG6124
130600200528     C                   MOVEL     *BLANKS       W0BRCD                                      CDL029A
130700200528     C                   MOVEL     BBCUST        W0CUST                                      CDL029A
130800200528      *                                                                                      CDL029A
130900200528     C     KBRANCHAUTH   CHAIN     SDABBCL0                           91                     CDL029A
131000200528      *                                                                                      CDL029A
131100200528     C                   IF        *IN91 = '1'                                               CDL029A
131200200528      *                                                                                      CDL029A
131300200528     C                   MOVEL     BBBRCD        W0BRCD                                      CDL029A
131400200528     C                   MOVEL     *BLANKS       W0CUST                                      CDL029A
131500200528      *                                                                                      CDL029A
131600200528     C     KBRANCHAUTH   CHAIN     SDABBCL0                           91                     BUG6124
131700200528      *                                                                                      CDL029A
131800200528     C                   ENDIF                                                               CDL029A
131900200528      *                                                                                      CDL029A
132000200528     C                   IF        *IN91 = '1'                                               BUG6124
132100200528     C                   MOVE      'N'           DDBrsnOK                                    BUG6124
132200200528     C     Idx           ADD       1             P                                           BUG6124
132300200528     C                   MOVEL     'DDBRSN'      FldNameArr(P)                               BUG6124
132400200528     C                   MOVEL     'DDBRSN'      FldNamXAr(P)                                BUG6124
132500200528     C                   MOVEL     'FXM7001'     MsgIdArr(P)                                 BUG6124
132600200528     C                   MOVEL     'FXM7001'     MsgIDXAr(P)                                 BUG6124
132700200528     C                   END                                                                 BUG6124
132800200528      *                                                                                      BUG6124
132900200528     C                   END                                                                 BUG6124
133000200528      *                                                                                      BUG6124
133100200528     C                   ENDSR
133200200528      *****************************************************************
133300200528     C/EJECT
133400200528      *****************************************************************
133500200528      ** VLNKN - Validate Linked Reference Number
133600200528      *****************************************************************
133700200528     C     VLNKN         BEGSR
133800200528
133900200528      * Reset variables updated by each module
134000200528
134100200528     C                   EXSR      RESETERRS
134200200528      *
134300200528      ** Validate Linked Reference Number
134400200528      *
134500200528     C                   CALLB     'FXVLNKN'
134600200528      *
134700200528      * INPUTS
134800200528      *
134900200528      ** Return Code
135000200528     C                   PARM                    RetCodeOut
135100200528      *
135200200528      ** Deal Screen fields
135300200528     C                   PARM                    DDLNKN
135400200528      *
135500200528      * ICD
135600200528     C                   PARM                    BNDCSP            1            new dl status
135700200528      *
135800200528      * OUTPUTS
135900200528      * Error fields/message IDs/message data (arrays) from/to caller
136000200528     C                   PARM                    FldNamXAr
136100200528     C                   PARM                    MsgIDXAr
136200200528     C                   PARM                    MsgDtaXAr
136300200528      *
136400200528      ** Linked reference no - OK
136500200528     C                   PARM                    DDLNKNOK
136600200528      *
136700200528      ** Deal Linked Reference No.
136800200528     C                   PARM                    F3LNKN
136900200528
137000200528      * Update error info with that returned from the validation module
137100200528
137200200528     C                   EXSR      UPDATERRS
137300200528      *
137400200528     C                   ENDSR
137500200528      *****************************************************************
137600200528     C/EJECT
137700200528      *****************************************************************
137800200528      ** VBSAMTS - Validate Buy and Sell Currencies and Amounts
137900200528      *****************************************************************
138000200528     C     VBSAMTS       BEGSR
138100200528
138200200528      * Reset variables updated by each module
138300200528
138400200528     C                   EXSR      RESETERRS
138500200528      *
138600200528      ** Validate Buy and Sell Currencies and Amounts
138700200528      *
138800200528     C                   CALLB     'FXVBSAMTS'
138900200528      *
139000200528      * INPUTS
139100200528      *
139200200528      ** Return Code
139300200528     C                   PARM                    RetCodeOut
139400200528      *
139500200528      ** Deal Screen fields
139600200528     C                   PARM                    DDACTN            1            action code
139700200528     C                   PARM                    DDDLTP            2            deal type
139800200528     C                   PARM                    DDBRKR            4            broker
139900200528      *
140000200528     C                   PARM                    DDBCCY            3            buy ccy
140100200528     C                   PARM                    DDSCCY            3            sell ccy
140200200528     C                   PARM                    DDBAMT           14            buy amount
140300200528     C                   PARM                    DDSAMT           14            sell amount
140400200528      *
140500200528      ** Related deal details
140600200528     C                   PARM                    RelDealDts                     SW/OP branch
140700200528      *
140800200528      ** Swap/Opt Deal no OK
140900200528     C                   PARM                    DDSdnoOK          1            SW/OP deal no
141000200528      *
141100200528      * ICD
141200200528     C                   PARM                    BJCYCD                         new dl status
141300200528     C                   PARM                    BNCYDL                         new dl status
141400200528     C                   PARM                    BGTRMG                         new dl status
141500200528     C                   PARM                    BNDCSP                         new dl status
141600200528      *
141700200528      * OUTPUTS
141800200528      *
141900200528      * Error fields/message IDs/message data (arrays) from/to caller
142000200528     C                   PARM                    FldNamXAr
142100200528     C                   PARM                    MsgIDXAr
142200200528     C                   PARM                    MsgDtaXAr
142300200528      *
142400200528      * Ccy 1 details
142500200528     C                   PARM                    @SPOT1           13 8          spot rate
142600200528     C                   PARM                    @CDP1             1 0          no of dec places
142700200528     C                   PARM                    @RDCY1            1            round down
142800200528     C                   PARM                    @@NDP1            1 0          norm quot decs
142900200528     C                   PARM                    @@SXP1                         scaling exponent
143000200528     C                   PARM                    @@MDF1            1            mult/div ind
143100200528     C                   PARM                    @@MDX1            1            mult/div ind,exch
143200200528     C                   PARM                    @@LSP1           13 8          low spot rate
143300200528     C                   PARM                    @@HSP1           13 8          high spot rate
143400200528     C                   PARM                    @@SPD1            8 0          FX spot date
143500200528     C                   PARM                    @NEXRT1                                      CER043
143600200528      *
143700200528      * Ccy 2 details
143800200528     C                   PARM                    @SPOT2           13 8          spot rate
143900200528     C                   PARM                    @CDP2             1 0          no of dec places
144000200528     C                   PARM                    @RDCY2            1            round down
144100200528     C                   PARM                    @@NDP2            1 0          norm quot decs
144200200528     C                   PARM                    @@SXP2                         scaling exponent
144300200528     C                   PARM                    @@MDF2            1            mult/div ind
144400200528     C                   PARM                    @@MDX2            1            mult/div ind,exch
144500200528     C                   PARM                    @@LSP2           13 8          low spot rate
144600200528     C                   PARM                    @@HSP2           13 8          high spot rate
144700200528     C                   PARM                    @@SPD2            8 0          FX spot date
144800200528     C                   PARM                    @NEXRT2                                      CER043
144900200528      *
145000200528      ** Buy ccy - OK
145100200528      ** Sell ccy - OK
145200200528      ** Buy amt - OK
145300200528      ** Sell amt - OK
145400200528     C                   PARM                    DDBccyOK          1            Buy ccy error
145500200528     C                   PARM                    DDSccyOK          1            Sell ccy error
145600200528     C                   PARM                    DDBamtOK          1            Buy amt error
145700200528     C                   PARM                    DDSamtOK          1            Sell amt error
145800200528     C                   PARM                    DDRateOK          1                          CER043
145900200528      *
146000200528      ** Deal Buy ccy, sell ccy, buy amt, sell amt
146100200528      *
146200200528     C                   PARM                    F3CCY1            3            buy ccy
146300200528     C                   PARM                    F3CCY2            3            sell ccy
146400200528     C                   PARM                    F3DAM1           15 0          buy amount
146500200528     C                   PARM                    F3DAM2           15 0          sell amount
146600200528
146700200528      * Update error info with that returned from the validation module
146800200528
146900200528     C                   EXSR      UPDATERRS
147000200528      *
147100200528     C                   ENDSR
147200200528      *****************************************************************
147300200528     C/COPY WNCPYSRC,FXH00022
147400200528     C/EJECT
147500200528      *****************************************************************
147600200528      ** VEXCHRAT - Validate Exchange Rate, Fwd Points & Sign
147700200528      *****************************************************************
147800200528     C     VEXCHRAT      BEGSR
147900200528
148000200528      * Reset variables updated by each module
148100200528
148200200528     C                   EXSR      RESETERRS
148300200528      *
148400200528      ** Validate Exchange Rate, Fwd Points & Sign
148500200528      *
148600200528     C                   CALLB     'FXVEXCHRAT'
148700200528      *
148800200528      * INPUTS
148900200528      *
149000200528      ** Return Code
149100200528     C                   PARM                    RetCodeOut
149200200528      *
149300200528      ** Deal Screen fields
149400200528     C                   PARM                    DDBCCY            3            buy ccy
149500200528     C                   PARM                    DDSCCY            3            sell ccy
149600200528     C**********         PARM                    DDDLTP            2   deal type    BUG5578 AR720772
149700200528     C                   PARM                    DDDLTP            2                        MD039203
149800200528      *
149900200528     C**********         PARM                    DDRATE           13            exch rate     196952
150000200528     C                   PARM                    DDRAT1           14            exch rate     196952
150100200528     C                   PARM                    DDREIN                                       CER043
150200200528     C                   PARM                    @SPOT1           13 8                        CER043
150300200528     C                   PARM                    @@MDF1            1                          CER043
150400200528     C                   PARM                    @NEXRT1           5 2                        CER043
150500200528     C                   PARM                    @SPOT2           13 8                        CER043
150600200528     C                   PARM                    @@MDF2            1                          CER043
150700200528     C                   PARM                    @NEXRT2           5 2                        CER043
150800200528     C**********         PARM                    RelDXRT          13 8 OT deal rate BUG5578 AR720772
150900200528     C                   PARM                    RelOSRT          13 8                        248269
151000200528     C                   PARM                    S01453            1                          248269
151100200528     C                   PARM                    DDFPNT            8            fwd pts
151200200528     C                   PARM                    DDSIGN            1            fwd pts sgn
151300200528      *
151400200528      * Scaling Exponent 1 & 2
151500200528     C                   PARM                    @@SXP1                         scaling exponent
151600200528     C                   PARM                    @@SXP2                         scaling exponent
151700200528      *
151800200528      ** Buy ccy Ok
151900200528      ** Sell ccy OK
152000200528     C                   PARM                    DDBccyOK          1            Buy ccy error
152100200528     C                   PARM                    DDSccyOK          1            Sell ccy error
152200200528      *
152300200528      * ICD
152400200528     C                   PARM                    BNCYDL            3
152500200528     C                   PARM                    BNDCSP            1            new dl status
152600200528      *
152700200528      * OUTPUTS
152800200528      *
152900200528      * Error fields/message IDs/message data (arrays) from/to caller
153000200528     C                   PARM                    FldNamXAr
153100200528     C                   PARM                    MsgIDXAr
153200200528     C                   PARM                    MsgDtaXAr
153300200528     C                   PARM                    WFldNmXAr                                    CER043
153400200528     C                   PARM                    WMsgIDXAr                                    CER043
153500200528     C                   PARM                    WMsgDtXAr                                    CER043
153600200528      *
153700200528      ** Exchange Rate - OK
153800200528      ** Forward Points - OK
153900200528      ** Forward Points Sign - OK
154000200528     C                   PARM                    DDRateOK          1            err-exch rate
154100200528     C                   PARM                    DDFpntOK          1            err-fwd pts
154200200528     C                   PARM                    DDSignOK          1            err-fwd pts sgn
154300200528      *
154400200528      ** Input rate
154500200528      ** forward points
154600200528     C                   PARM      *ZEROS        W@INRT           13 8          rate (unscaled)
154700200528     C                   PARM                    F3FWPP            7 2          fwd pts
154800200528
154900200528      * Update error info with that returned from the validation module
155000200528
155100200528     C                   EXSR      UPDATERRS
155200200528      *
155300200528     C                   ENDSR
155400200528      *****************************************************************
155500200528     C/EJECT
155600200528      *****************************************************************
155700200528      ** VMARGIN - Validate Margin & Other Forward Points
155800200528      *****************************************************************
155900200528     C     VMARGIN       BEGSR
156000200528
156100200528      * Reset variables updated by each module
156200200528
156300200528     C                   EXSR      RESETERRS
156400200528      *
156500200528      ** Validate Margin & Other Forward Points
156600200528      *
156700200528     C                   CALLB     'FXVMARGIN'
156800200528      *
156900200528      * INPUTS
157000200528      *
157100200528      ** Return Code
157200200528     C                   PARM                    RetCodeOut
157300200528      *
157400200528      ** Deal Screen fields
157500200528     C                   PARM                    DDACTN            1            Action Code
157600200528     C                   PARM                    DDDLTP            2            Deal Type
157700200528     C                   PARM                    DDBCCY            3            Buy CCy
157800200528     C                   PARM                    DDSCCY            3            Sell Ccy
157900200528      *
158000200528     C                   PARM                    DDMGIN            8            Margin Pts
158100200528     C                   PARM                    DDMBSI            1            Margin B/S
158200200528     C                   PARM                    DDDBSR           13            Dealt Base Rate
158300200528     C                   PARM                    DDBBFP            8            Buy Fwd Pts
158400200528     C                   PARM                    DDBBFS            1            Buy Fwd Pts sign
158500200528     C                   PARM                    DDSBFP            8            Sell Fwd Pts
158600200528     C                   PARM                    DDSBFS            1            Sell Fwd Pts sign
158700200528      *
158800200528      ** Related deal details
158900200528     C                   PARM                    RelDealDts                     SW/OP branch
159000200528      *
159100200528      ** Buy & Sell Ccy OK
159200200528     C                   PARM                    DDBccyOK          1            Buy CCy
159300200528     C                   PARM                    DDSccyOK          1            Sell Ccy
159400200528      *
159500200528      * ICD
159600200528     C                   PARM                    BNCYDL            3
159700200528     C                   PARM                    BNDCSP            1
159800200528      *
159900200528      * OUTPUTS
160000200528      * Error fields/message IDs/message data (arrays) from/to caller
160100200528     C                   PARM                    FldNamXAr
160200200528     C                   PARM                    MsgIDXAr
160300200528     C                   PARM                    MsgDtaXAr
160400200528     C                   PARM                    WFldNmXAr
160500200528     C                   PARM                    WMsgIDXAr
160600200528     C                   PARM                    WMsgDtXAr
160700200528      *
160800200528      ** Margin - OK
160900200528      ** Margin Buy/sell ind - OK
161000200528      ** Deal Base Spot rate - OK
161100200528      ** Buy DL Base Fwd points - OK
161200200528      ** Buy DL Base Fwd points sign - OK
161300200528      ** Sell DL Base Fwd points - OK
161400200528      ** Sell DL Base Fwd points sign - OK
161500200528      *
161600200528     C                   PARM                    DDMginOK          1            Margin Pts
161700200528     C                   PARM                    DDMbsiOK          1            Margin B/S
161800200528     C                   PARM                    DDDbsrOK          1            Dealt Base Rate
161900200528     C                   PARM                    DDBbfpOK          1            Buy Fwd Pts
162000200528     C                   PARM                    DDBbfsOK          1            Buy Fwd Pts sign
162100200528     C                   PARM                    DDSbfpOK          1            Sell Fwd Pts
162200200528     C                   PARM                    DDSbfsOK          1            Sell Fwd Pts sign
162300200528      *
162400200528      ** Margin
162500200528      ** Margin Buy/sell ind
162600200528      ** Deal Base Spot rate
162700200528      ** Buy DL Base Fwd points
162800200528      ** Sell DL Base Fwd points
162900200528      *
163000200528     C                   PARM                    F3MGPT            7 2          Margin Pts
163100200528     C                   PARM                    F3MGBS            1            Margin B/S
163200200528     C                   PARM                    F3BDBS           13 8          Dealt Base Rate
163300200528     C                   PARM                    F3BDBF            7 2          Buy Fwd Pts
163400200528     C                   PARM                    F3SDBF            7 2          Sell Fwd Pts
163500200528
163600200528      * Update error info with that returned from the validation module
163700200528
163800200528     C                   EXSR      UPDATERRS
163900200528      *
164000200528     C                   ENDSR
164100200528      *****************************************************************
164200200528      /EJECT
164300200528      *****************************************************************
164400200528      * DETRAT@FP - Determine Rate + Forward Points                   *
164500200528      *****************************************************************
164600200528     C     DETRAT@FP     BEGSR
164700200528      *
164800200528      **  Unscale the input rate
164900200528      *
165000200528     C     @@SXP1        IFNE      0
165100200528     C     @@SXP1        ADD       1             @@SFAC            1 0
165200200528     C                   MOVE      'M'           @@DMD1
165300200528     C                   ELSE
165400200528     C     @@SXP2        ADD       1             @@SFAC
165500200528     C                   MOVE      'D'           @@DMD1
165600200528     C                   END
165700200528      *
165800200528     C     W@INRT        DIV(H)    @SF(@@SFAC)   F3OSRT
165900200528      *
166000200528      ** Add input rate and forward points together
166100200528      *
166200200528     C                   CALLB     'ZA0780'
166300200528      *
166400200528      * INPUTS
166500200528      *
166600200528     C                   PARM                    DDBCCY            3            buy ccy
166700200528     C                   PARM                    DDSCCY            3            sell ccy
166800200528      *
166900200528      * ICD
167000200528     C                   PARM                    BNCYDL            3            sell ccy
167100200528      *
167200200528     C                   PARM      F3OSRT        @@IRAT           13 8          exchange rate
167300200528     C                   PARM                    @@DMD1            1            1st ccy ml/dv ind
167400200528     C                   PARM      F3FWPP        @@FPNT            7 2          forward points
167500200528      *
167600200528     C                   PARM      'N'           @@SCAL            1            scale rate?
167700200528      *
167800200528     C                   PARM                    @@NDP1            1 0          norm quot decs
167900200528     C                   PARM                    @@SXP1                         scaling exponent
168000200528      *
168100200528     C                   PARM                    @@NDP2            1 0          norm quot decs
168200200528     C                   PARM                    @@SXP2                         scaling exponent
168300200528      *
168400200528      * OUTPUTS
168500200528      *
168600200528     C                   PARM      *ZEROS        @@GSRT           13 8          gross scaled rate
168700200528     C                   PARM      *ZEROS        @@GURT           13 8          gross unscld rate
168800200528      *
168900200528      ** Take scaled gross rate
169000200528      *
169100200528     C                   Z-ADD     @@GSRT        @@INRT
169200200528      *
169300200528     C**********         IF        CER043 = 'Y'                                   BUG23050A BUG23668
169400200528      **********                                                                  BUG23050A BUG23668
169500200528      ***Get*scaled gross rate for reciprocal exchange rate                       BUG23050A BUG23668
169600200528      **********                                                                  BUG23050A BUG23668
169700200528     C*****1****         DIV(H)    F3OSRT        @@EXRTR          13 8            BUG23050A BUG23668
169800200528      **********                                                                  BUG23050A BUG23668
169900200528      ***Add*input rate and forward points together                               BUG23050A BUG23668
170000200528      **********                                                                  BUG23050A BUG23668
170100200528     C**********         CALLB     'ZA0780'                                       BUG23050A BUG23668
170200200528      **********                                                                  BUG23050A BUG23668
170300200528      **INPUTS**                                                                  BUG23050A BUG23668
170400200528      **********                                                                  BUG23050A BUG23668
170500200528     C**********         PARM                    DDBCCY                           BUG23050A BUG23668
170600200528     C**********         PARM                    DDSCCY                           BUG23050A BUG23668
170700200528      **********                                                                  BUG23050A BUG23668
170800200528      **ICD*****                                                                  BUG23050A BUG23668
170900200528     C**********         PARM                    BNCYDL                           BUG23050A BUG23668
171000200528      **********                                                                  BUG23050A BUG23668
171100200528     C**********         PARM                    @@EXRTR                          BUG23050A BUG23668
171200200528     C**********         PARM                    @@DMD1                           BUG23050A BUG23668
171300200528     C**********         PARM      F3FWPP        @@FPNT                           BUG23050A BUG23668
171400200528      **********                                                                  BUG23050A BUG23668
171500200528     C**********         PARM      'N'           @@SCAL                           BUG23050A BUG23668
171600200528      **********                                                                  BUG23050A BUG23668
171700200528     C**********         PARM                    @@NDP1                           BUG23050A BUG23668
171800200528     C**********         PARM                    @@SXP1                           BUG23050A BUG23668
171900200528      **********                                                                  BUG23050A BUG23668
172000200528     C**********         PARM                    @@NDP2                           BUG23050A BUG23668
172100200528     C**********         PARM                    @@SXP2                           BUG23050A BUG23668
172200200528      **********                                                                  BUG23050A BUG23668
172300200528      **OUTPUTS*                                                                  BUG23050A BUG23668
172400200528      **********                                                                  BUG23050A BUG23668
172500200528     C**********         PARM      *ZEROS        @@GSRTR          13 8            BUG23050A BUG23668
172600200528     C**********         PARM      *ZEROS        @@GURTR          13 8            BUG23050A BUG23668
172700200528      **********                                                                  BUG23050A BUG23668
172800200528      ***Take*scaled gross rate  for reciprocal exchange rate                     BUG23050A BUG23668
172900200528      **********                                                                  BUG23050A BUG23668
173000200528     C**********         Z-ADD     @@GSRTR       @@INRTR                          BUG23050A BUG23668
173100200528     C**********         ENDIF                                                    BUG23050A BUG23668
173200200528      **********                                                                  BUG23050A BUG23668
173300200528     C                   ENDSR
173400200528      *****************************************************************
173500200528     C/EJECT
173600200528      *****************************************************************
173700200528      ** VEXCHVAM - Validate Exchange Rate versus Amounts
173800200528      *****************************************************************
173900200528     C     VEXCHVAM      BEGSR
174000200528
174100200528      * Reset variables updated by each module
174200200528
174300200528     C                   EXSR      RESETERRS
174400200528      *
174500200528      ** Validate Exchange Rate versus Amounts
174600200528      *
174700200528     C                   CALLB     'FXVEXCHVAM'
174800200528      *
174900200528      * INPUTS
175000200528      *
175100200528      ** Return Code
175200200528     C                   PARM                    RetCodeOut
175300200528      *
175400200528      ** Deal Screen fields
175500200528     C                   PARM                    DDACTN            1            action code   CER043
175600200528     C                   PARM                    DDDLTP            2            deal type     CER043
175700200528     C                   PARM                    DDBAMT           14            buy amount    CER043
175800200528     C                   PARM                    DDSAMT           14            sell amount   CER043
175900200528     C                   PARM                    DDBCCY            3            buy ccy
176000200528     C                   PARM                    DDSCCY            3            sell ccy
176100200528      *                                                                                       CER043
176200200528      ** Related deal details                                                                 CER043
176300200528     C                   PARM                    RelDealDts                     SW/OP branch  CER043
176400200528      *
176500200528     C                   PARM                    W@INRT           13 8          scaled exch rate
176600200528     C                   PARM                    @@INRT           13 8          rate + fwd pts
176700200528     C**********         PARM                    @@INRTR          13 8            BUG23050A BUG23668
176800200528     C                   PARM      F3FWPP        @@FPNT            7 2          forward points
176900200528     C                   PARM      F3MGPT        @@MGPT            7 2          margin points
177000200528      *
177100200528     C                   PARM                    F3DAM1           15 0          amount
177200200528      *
177300200528     C                   PARM                    @SPOT1           13 8          spot rate
177400200528     C                   PARM                    @CDP1             1 0          no of dec places
177500200528     C                   PARM                    @RDCY1            1            round down
177600200528     C                   PARM                    @@NDP1            1 0          norm quot decs
177700200528     C                   PARM                    @@SXP1                         scaling exponent
177800200528     C                   PARM                    @@MDF1            1            mult/div ind
177900200528     C                   PARM                    @NEXRT1           5 2                     BUG23050A
178000200528      *
178100200528     C                   PARM                    F3DAM2           15 0          amount
178200200528      *
178300200528     C                   PARM                    @SPOT2           13 8          spot rate
178400200528     C                   PARM                    @CDP2             1 0          no of dec places
178500200528     C                   PARM                    @RDCY2            1            round down
178600200528     C                   PARM                    @@NDP2            1 0          norm quot decs
178700200528     C                   PARM                    @@SXP2                         scaling exponent
178800200528     C                   PARM                    @@MDF2            1            mult/div ind
178900200528     C                   PARM                    @NEXRT2           5 2                     BUG23050A
179000200528      *                                                                                       238023
179100200528     C                   PARM                    F3MGBS            1            marg ind      238023
179200200528      *                                                                                       CER043
179300200528      ** Reciprocal rate indicator, exchange rate                                             CER043
179400200528      *                                                                                       CER043
179500200528     C                   PARM                    DDREIN                                       CER043
179600200528      *
179700200528      ** ICD
179800200528     C                   PARM                    BJCYCD
179900200528     C                   PARM                    BNCYDL
180000200528     C                   PARM                    BNEXRT
180100200528     C                   PARM                    BNDCSP
180200200528     C                   PARM                    S01391
180300200528     C                   PARM                    S01453
180400200528      *
180500200528      * OUTPUTS
180600200528      *
180700200528      * Error fields/message IDs/message data (arrays) from/to caller
180800200528     C                   PARM                    FldNamXAr
180900200528     C                   PARM                    MsgIDXAr
181000200528     C                   PARM                    MsgDtaXAr
181100200528     C                   PARM                    WFldNmXAr
181200200528     C                   PARM                    WMsgIDXAr
181300200528     C                   PARM                    WMsgDtXAr
181400200528      *
181500200528      ** Buy Amount - OK
181600200528      ** Sell Amount - OK
181700200528      ** Rate - OK
181800200528     C                   PARM                    DDBamtOK          1
181900200528     C                   PARM                    DDSamtOK          1
182000200528     C                   PARM                    DDRateOK          1
182100200528      *
182200200528      ** Multiply/Div Ind, Exchange Rate
182300200528      ** Descaled Exchange Rate, Rate+Mgn+Fwd Pts, Rate+Fwd Pts
182400200528      *
182500200528     C                   PARM                    F3DMD1            1            mult/div ind
182600200528     C                   PARM                    F3DXRT           13 8          exch rate
182700200528     C                   PARM      *ZEROS        @SRATE           13 8          Descaled exch rt
182800200528     C                   PARM      *ZEROS        @RRATE           13 8          Rate+mgn+fwd pts
182900200528     C                   PARM      *ZEROS        @XRATE           13 8          Rate+fwd pts
183000200528     C**********         PARM                    F3OSRT                           BUG23050A BUG23668
183100200528     C/COPY OFCPYSRCZ,CDL091_013                                                              CDL091
183200200528     C/COPY WNCPYSRC,FXFXDLVC03
183300200528
183400200528      * Update error info with that returned from the validation module
183500200528
183600200528     C                   EXSR      UPDATERRS
183700200528      *
183800200528     C                   ENDSR
183900200528      *****************************************************************
184000200528     C/EJECT
184100200528      *****************************************************************
184200200528      ** VBSECYAE - Validate Base Currency Equivalent
184300200528      *****************************************************************
184400200528     C     VBSECYAE      BEGSR
184500200528
184600200528      * Reset variables updated by each module
184700200528
184800200528     C                   EXSR      RESETERRS
184900200528      *
185000200528      ** Validate Base Currency Equivalent
185100200528      *
185200200528     C                   CALLB     'FXVBSECYAE'
185300200528      *
185400200528      * INPUTS
185500200528      *
185600200528      ** Return Code
185700200528     C                   PARM                    RetCodeOut
185800200528      *
185900200528      ** Deal Screen fields
186000200528     C                   PARM                    DDBCE            14            base ccy equiv
186100200528      *
186200200528     C                   PARM                    DDACTN            1            action code
186300200528     C                   PARM                    DDBCCY            3            buy ccy
186400200528     C                   PARM                    DDSCCY            3            sell ccy
186500200528     C                   PARM                    DDBAMT           14            buy amount
186600200528     C                   PARM                    DDSAMT           14            sell amount
186700200528      *
186800200528      ** OK indicators
186900200528     C                   PARM                    DDBccyOK          1            Buy ccy error
187000200528     C                   PARM                    DDSccyOK          1            Sell ccy error
187100200528     C                   PARM                    DDBAmtOK          1            Buy amt error
187200200528     C                   PARM                    DDSAmtOK          1            Sell amt error
187300200528      *
187400200528      ** Buy/sell amts
187500200528     C                   PARM                    F3DAM1           15 0          buy amount
187600200528     C                   PARM                    F3DAM2           15 0          sell amount
187700200528      *
187800200528      * Ccy 1 details
187900200528     C                   PARM                    @SPOT1           13 8          spot rate
188000200528     C                   PARM                    @CDP1             1 0          no of dec places
188100200528     C                   PARM                    @@MDF1            1            mult/div ind
188200200528      *
188300200528      * Ccy 2 details
188400200528     C                   PARM                    @SPOT2           13 8          spot rate
188500200528     C                   PARM                    @CDP2             1 0          no of dec places
188600200528     C                   PARM                    @@MDF2            1            mult/div ind
188700200528      *
188800200528      * ICD
188900200528     C                   PARM                    BJCYCD            3
189000200528     C                   PARM                    BNDCSP            1
189100200528      *
189200200528      * OUTPUTS
189300200528      *
189400200528      * Error fields/message IDs/message data (arrays) from/to caller
189500200528     C                   PARM                    FldNamXAr
189600200528     C                   PARM                    MsgIDXAr
189700200528     C                   PARM                    MsgDtaXAr
189800200528     C                   PARM                    WFldNmXAr                                    183759
189900200528     C                   PARM                    WMsgIDXAr                                    183759
190000200528     C                   PARM                    WMsgDtXAr                                    183759
190100200528      *
190200200528      ** Base ccy equivalent - OK
190300200528     C                   PARM                    DDBceOK           1            base ccy equiv
190400200528      *
190500200528      ** Deal Base ccy equivalent
190600200528     C                   PARM                    F3BCAE           15 0          base ccy equiv
190700200528
190800200528      * Update error info with that returned from the validation module
190900200528
191000200528     C                   EXSR      UPDATERRS
191100200528      *
191200200528     C                   ENDSR
191300200528      *****************************************************************
191400200528     C/EJECT
191500200528      *****************************************************************
191600200528      ** VFXNETS - Validate FX Netting fields
191700200528      *****************************************************************
191800200528     C     VFXNETS       BEGSR
191900200528
192000200528      * Reset variables updated by each module
192100200528
192200200528     C                   EXSR      RESETERRS
192300200528      *
192400200528      ** Validate FX Netting fields
192500200528      *
192600200528     C                   CALLB     'FXVFXNETS'
192700200528      *
192800200528      * INPUTS
192900200528      *
193000200528      ** Return Code
193100200528     C                   PARM                    RetCodeOut
193200200528      *
193300200528      ** Deal Screen fields
193400200528     C                   PARM                    DDACTN
193500200528     C                   PARM                    DDVDAT
193600200528     C                   PARM                    DDCUST
193700200528     C                   PARM                    DDBCCY
193800200528     C                   PARM                    DDNBUY
193900200528     C                   PARM                    DDSCCY
194000200528     C                   PARM                    DDNSEL
194100200528     C                   PARM                    DDMTCH
194200200528     C                   PARM                    DDNBRF
194300200528     C                   PARM                    DDNSRF
194400200528     C                   PARM                    DDDLTP                                      BUG6251
194500200528      *
194600200528      ** Value Date
194700200528     C                   PARM                    F3VDDN                         customer no
194800200528     C/COPY WNCPYSRC,FXH00131
194900200528      *
195000200528      * OUTPUTS
195100200528      *
195200200528      * Error fields/message IDs/message data (arrays) from/to caller
195300200528     C                   PARM                    FldNamXAr
195400200528     C                   PARM                    MsgIDXAr
195500200528     C                   PARM                    MsgDtaXAr
195600200528     C                   PARM                    WFldNmXAr
195700200528     C                   PARM                    WMsgIDXAr
195800200528     C                   PARM                    WMsgDtXAr
195900200528      *
196000200528      ** Net Buy Ind - OK
196100200528      ** Net Sell Ind - OK
196200200528      ** Match indicator - OK
196300200528     C                   PARM                    DDNbuyOK          1            base ccy equiv
196400200528     C                   PARM                    DDNselOK          1            base ccy equiv
196500200528     C                   PARM                    DDMtchOK          1            base ccy equiv
196600200528      *
196700200528      ** Buy/Sell Indicators and Matched Deal Indicator
196800200528      ** and Net Buy/Sell References
196900200528     C                   PARM                    F3NBUY                         customer no
197000200528     C                   PARM                    F3NSEL                         customer shtname
197100200528     C                   PARM                    F3MTCH                         book
197200200528     C                   PARM                    F3NBRF
197300200528     C                   PARM                    F3NSRF
197400200528
197500200528      * Update error info with that returned from the validation module
197600200528
197700200528     C                   EXSR      UPDATERRS
197800200528      *
197900200528     C                   ENDSR
198000200528      *****************************************************************
198100200528      /EJECT                                                                    CDL008
198200200528      *****************************************************************         CDL008
198300200528      *                                                               *         CDL008
198400200528      *  VFXCLSS - Validate CLS settlement                            *         CDL008
198500200528      *                                                               *         CDL008
198600200528      *****************************************************************         CDL008
198700200528     C     VFXCLSS       BEGSR                                                  CDL008
198800200528      *                                                                         CDL008
198900200528      ** Reset variables updated by each module                                 CDL008
199000200528     C                   EXSR      RESETERRS                                    CDL008
199100200528                                                                                CDL008
199200200528     C                   CALLB     'FXVCLSSETL'                                 CDL008
199300200528      *                                                                         CDL008
199400200528      ** INPUTS                                                                 CDL008
199500200528      ** ======                                                                 CDL008
199600200528      *                                                                         CDL008
199700200528      ** Return Code                                                            CDL008
199800200528     C                   PARM                    RetCodeOut                     CDL008
199900200528     C                   PARM                    DDCLSS                         CDL008
200000200528     C                   PARM                    DDBRSN                         CDL008
200100200528     C                   PARM                    DDCUST                         CDL008
200200200528     C                   PARM                    DDBCCY                         CDL008
200300200528     C                   PARM                    DDSCCY                         CDL008
200400200528     C                   PARM                    F3VDDN                         CDL008
200500200528     C                   PARM                    DDNBUY                         CDL008
200600200528     C                   PARM                    DDNSEL                         CDL008
200700200528     C                   PARM                    F3DDDN                                       CDL035
200800200528      *                                                                         CDL008
200900200528      ** STANDING DATA                                                          CDL008
201000200528      ** =============                                                          CDL008
201100200528     C**********         PARM                    BJRDNB                                CDL008 CSC011
201200200528     C                   PARM                    WRunDay                                      CSC011
201300200528     C                   PARM                    BJLCCY                         CDL008
201400200528     C                   PARM                    BJSLCD                         CDL008
201500200528      *                                                                         CDL008
201600200528      ** OUTPUTS                                                                CDL008
201700200528      ** =======                                                                CDL008
201800200528      *                                                                         CDL008
201900200528      ** Error fields/message IDs/message data (arrays) from/to caller          CDL008
202000200528     C                   PARM                    FldNamXAr                      CDL008
202100200528     C                   PARM                    MsgIDXAr                       CDL008
202200200528     C                   PARM                    MsgDtaXAr                      CDL008
202300200528      *                                                                         CDL008
202400200528      ** Warning fields/message IDs/message data (arrays) from/to caller        CDL008
202500200528     C                   PARM                    WFldNmXAr                      CDL008
202600200528     C                   PARM                    WMsgIDxAr                      CDL008
202700200528     C                   PARM                    WMsgDtXAr                      CDL008
202800200528                                                                                CDL008
202900200528     C                   PARM                    F3CLSS                         CDL008
203000200528                                                                                CDL008
203100200528     C                   PARM                    DDCLSSOK                       CDL008
203200200528      *                                                                         CDL008
203300200528      ** Update error info with that returned from the validation module        CDL008
203400200528     C                   EXSR      UPDATERRS                                    CDL008
203500200528                                                                                CDL008
203600200528     C                   ENDSR                                                  CDL008
203700200528                                                                                              CAS001
203800200528      *****************************************************************                       CAS001
203900200528      /EJECT                                                                                  CAS001
204000200528      *****************************************************************                       CAS001
204100200528      *                                                               *                       CAS001
204200200528      *  SRVOYLC - Validate Buy/Our Yield Curve                       *                       CAS001
204300200528      *                                                               *                       CAS001
204400200528      *  Called by: Main                                              *                       CAS001
204500200528      *                                                               *                       CAS001
204600200528      *  Calls: RESETERRS UPDATERRS                                   *                       CAS001
204700200528      *                                                               *                       CAS001
204800200528      *****************************************************************                       CAS001
204900200528                                                                                              CAS001
205000200528     C     SRVOYLC       BEGSR                                                                CAS001
205100200528                                                                                              CAS001
205200200528      ** Reset variables updated by each module                                               CAS001
205300200528                                                                                              CAS001
205400200528     C                   EXSR      RESETERRS                                                  CAS001
205500200528                                                                                              CAS001
205600200528      ** Validate Buy/Our Yield Curve                                                         CAS001
205700200528                                                                                              CAS001
205800200528     C                   CALLB     'ZAVYLDC01'                                                CAS001
205900200528                                                                                              CAS001
206000200528      ** INPUTS                                                                               CAS001
206100200528      ** ------                                                                               CAS001
206200200528                                                                                              CAS001
206300200528      ** Return Code                                                                          CAS001
206400200528
206500200528     C                   PARM                    RetCodeOut                                   CAS001
206600200528
206700200528      ** Deal Screen fields                                                                   CAS001
206800200528
206900200528     C                   PARM                    DDDLTP                                       CAS001
207000200528     C                   PARM                    DDDLST                                       CAS001
207100200528     C                   PARM                    DDCLAS                                       CDL038
207200200528     C                   PARM                    DDOYLC                                       CAS001
207300200528
207400200528      ** Field name                                                                           CAS001
207500200528
207600200528     C                   PARM      'DDOYLC'      PYCFN                                        CAS001
207700200528                                                                                              CAS005
207800200528      ** Forward/Revaluation Flag                                                             CAS005
207900200528                                                                                              CAS005
208000200528     C                   PARM      *BLANKS       PFwRv                                        CAS005
208100200528                                                                                              CAS005
208200200528      ** Forward Yield Curve, to be checked if validating Reval Yield Curve                   CAS005
208300200528                                                                                              CAS005
208400200528     C                   PARM      *BLANKS       PFwYC                                        CAS005
208500200528                                                                                              CAS008
208600200528      ** Forward Commitment/Revaluation Flag                                                  CAS008
208700200528                                                                                              CAS008
208800200528     C                   PARM      *BLANKS       PFCRv                                        CAS008
208900200528                                                                                              CAS001
209000200528      ** OUTPUTS                                                                              CAS001
209100200528      ** -------                                                                              CAS001
209200200528                                                                                              CAS001
209300200528      ** Buy/Our Yield Curve - OK                                                             CAS001
209400200528
209500200528     C                   PARM                    DDOylcOK                                     CAS001
209600200528
209700200528      ** Error Type                                                                           CAS001
209800200528
209900200528     C                   PARM      *BLANKS       PERTP                                        CAS001
210000200528
210100200528      ** Buy/Our Yield Curve                                                                  CAS001
210200200528
210300200528     C                   PARM                    F3OYLC                                       CAS001
210400200528                                                                                              CAS001
210500200528     C                   IF        RetCodeOut <> *Blanks                                      CAS001
210600200528     C                   Z-ADD     1             Idx                                          CAS001
210700200528     C                   EVAL      FldNamXAr(Idx) = 'DDOYLC'                                  CAS001
210800200528     C                   IF        PERTP = '1'                                                CAS001
210900200528     C                   EVAL      MsgIDXAr(Idx) = 'FXM5055'                                  CAS001
211000200528     C                   ELSE                                                                 CAS001
211100200528     C                   EVAL      MsgIDXAr(Idx) = 'FXM5057'                                  CAS001
211200200528     C                   ENDIF                                                                CAS001
211300200528     C                   ENDIF                                                                CAS001
211400200528                                                                                              CAS001
211500200528      ** Update error info with that returned from the validation module                      CAS001
211600200528                                                                                              CAS001
211700200528     C                   EXSR      UPDATERRS                                                  CAS001
211800200528                                                                                              CAS001
211900200528     C                   ENDSR                                                                CAS001
212000200528                                                                                              CAS001
212100200528      *****************************************************************                       CAS001
212200200528      /EJECT                                                                                  CAS001
212300200528      *****************************************************************                       CAS001
212400200528      *                                                               *                       CAS001
212500200528      *  SRVTYLC - Validate Sell/Their Yield Curve                    *                       CAS001
212600200528      *                                                               *                       CAS001
212700200528      *  Called by: Main                                              *                       CAS001
212800200528      *                                                               *                       CAS001
212900200528      *  Calls: RESETERRS UPDATERRS                                   *                       CAS001
213000200528      *                                                               *                       CAS001
213100200528      *****************************************************************                       CAS001
213200200528                                                                                              CAS001
213300200528     C     SRVTYLC       BEGSR                                                                CAS001
213400200528                                                                                              CAS001
213500200528      ** Reset variables updated by each module                                               CAS001
213600200528                                                                                              CAS001
213700200528     C                   EXSR      RESETERRS                                                  CAS001
213800200528                                                                                              246386
213900200528      ** Reset Sell/Their Yield Curve OK flag                                                 246386
214000200528     C                   EVAl      DDTylcOK = *Blanks                                         246386
214100200528                                                                                              CAS001
214200200528      ** Validate Their/Sell Yield Curve                                                      CAS001
214300200528                                                                                              CAS001
214400200528     C                   CALLB     'ZAVYLDC01'                                                CAS001
214500200528                                                                                              CAS001
214600200528      ** INPUTS                                                                               CAS001
214700200528      ** ------                                                                               CAS001
214800200528                                                                                              CAS001
214900200528      ** Return Code                                                                          CAS001
215000200528                                                                                              CAS001
215100200528     C                   PARM                    RetCodeOut                                   CAS001
215200200528                                                                                              CAS001
215300200528      ** Deal Screen fields                                                                   CAS001
215400200528                                                                                              CAS001
215500200528     C                   PARM                    DDDLTP                                       CAS001
215600200528     C                   PARM                    DDDLST                                       CAS001
215700200528     C                   PARM                    DDCLAS                                       CDL038
215800200528     C                   PARM                    DDTYLC                                       CAS001
215900200528                                                                                              CAS001
216000200528      ** Field name                                                                           CAS001
216100200528                                                                                              CAS001
216200200528     C                   PARM      'DDTYLC'      PYCFN                                        CAS001
216300200528                                                                                              CAS005
216400200528      ** Forward/Revaluation Flag                                                             CAS005
216500200528                                                                                              CAS005
216600200528     C                   PARM      *BLANKS       PFwRv                                        CAS005
216700200528                                                                                              CAS005
216800200528      ** Forward Yield Curve, to be checked if validating Reval Yield Curve                   CAS005
216900200528                                                                                              CAS005
217000200528     C                   PARM      *BLANKS       PFwYC                                        CAS005
217100200528                                                                                              CAS008
217200200528      ** Forward Commitment/Revaluation Flag                                                  CAS008
217300200528                                                                                              CAS008
217400200528     C                   PARM      *BLANKS       PFCRv                                        CAS008
217500200528                                                                                              CAS001
217600200528      ** OUTPUTS                                                                              CAS001
217700200528      ** -------                                                                              CAS001
217800200528                                                                                              CAS001
217900200528      ** Their/Sell Yield Curve - OK                                                          CAS001
218000200528                                                                                              CAS001
218100200528     C                   PARM                    DDTylcOK                                     CAS001
218200200528                                                                                              CAS001
218300200528      ** Error Type                                                                           CAS001
218400200528                                                                                              CAS001
218500200528     C                   PARM      *BLANKS       PERTP                                        CAS001
218600200528                                                                                              CAS001
218700200528      ** Their/Sell Yield Curve                                                               CAS001
218800200528                                                                                              CAS001
218900200528     C                   PARM                    F3TYLC                                       CAS001
219000200528                                                                                              CAS001
219100200528     C                   IF        RetCodeOut <> *Blanks                                      CAS001
219200200528     C                   Z-ADD     1             Idx                                          CAS001
219300200528     C                   EVAL      FldNamXAr(Idx) = 'DDTYLC'                                  CAS001
219400200528     C                   IF        PERTP = '1'                                                CAS001
219500200528     C                   EVAL      MsgIDXAr(Idx) = 'FXM5056'                                  CAS001
219600200528     C                   ELSE                                                                 CAS001
219700200528     C                   EVAL      MsgIDXAr(Idx) = 'FXM5058'                                  CAS001
219800200528     C                   ENDIF                                                                CAS001
219900200528     C                   ENDIF                                                                CAS001
220000200528                                                                                              CAS001
220100200528      ** Update error info with that returned from the validation module                      CAS001
220200200528                                                                                              CAS001
220300200528     C                   EXSR      UPDATERRS                                                  CAS001
220400200528                                                                                              CAS001
220500200528     C                   ENDSR                                                                CAS001
220600200528     C/COPY WNCPYSRC,FXH00061
220700200528      *                                                                         CDL008
220800200528      *****************************************************************         CDL008
220900200528      /EJECT                                                                                  CDL049
221000200528      *****************************************************************                       CDL049
221100200528      *                                                               *                       CDL049
221200200528      *  VRRAT     - Validate Reference Rate field                    *                       CDL049
221300200528      *                                                               *                       CDL049
221400200528      *  Called By: Main Processing                                   *                       CDL049
221500200528      *                                                               *                       CDL049
221600200528      *  Calls:                                                       *                       CDL049
221700200528      *  RESETERRS - Resets variables updated by each modules         *                       CDL049
221800200528      *  MMVFXRRAT - Reference Rate field Validation Module           *                       CDL049
221900200528      *  UPDATERRS - Update error information with that received back *                       CDL049
222000200528      *              from each validation module.                     *                       CDL049
222100200528      *                                                               *                       CDL049
222200200528      *****************************************************************                       CDL049
222300200528                                                                                              CDL049
222400200528     C     VRRAT         BEGSR                                                                CDL049
222500200528                                                                                              CDL049
222600200528      ** Reset variables updated by other modules                                             CDL049
222700200528                                                                                              CDL049
222800200528     C                   EXSR      RESETERRS                                                  CDL049
222900200528      *                                                                                       CDL049
223000200528      ** Validate Reference Rate field                                                        CDL049
223100200528      *                                                                                       CDL049
223200200528     C                   CALLB     'FXVDLRRAT'                                                CDL049
223300200528     C                   PARM                    RETCODEOUT                                   CDL049
223400200528     C                   PARM                    TRANIN                                       CDL049
223500200528     C                   PARM                    FLDNAMXAR                                    CDL049
223600200528     C                   PARM                    MSGIDXAR                                     CDL049
223700200528     C                   PARM                    MSGDTAXAR                                    CDL049
223800200528     C                   PARM                    WFLDNMXAR                                    CDL049
223900200528     C                   PARM                    WMSGIDXAR                                    CDL049
224000200528     C                   PARM                    WMSGDTXAR                                    CDL049
224100200528     C                   PARM                    F3DXRT                                       CDL049
224200200528     C                   PARM                    F3RRAT                                       CDL049
224300200528      *                                                                                       CDL049
224400200528     C                   EXSR      UPDATERRS                                                  CDL049
224500200528                                                                                              CDL049
224600200528     C                   ENDSR                                                                CDL049
224700200528      *****************************************************************                       CDL049
224800200528      /EJECT                                                                                  CDL038
224900200528      *****************************************************************                       CDL038
225000200528      * Default Sub Type and Class                                                            CDL038
225100200528      *****************************************************************                       CDL038
225200200528     C     DSUBTCLAS     BEGSR                                                                CDL038
225300200528      *                                                                                       CDL038
225400200528     C                   CALL      'DL002000'                                                 CDL038
225500200528      * Inputs                                                                                CDL038
225600200528     C                   PARM                    DDACTN                                       CDL038
225700200528     C                   PARM                    DDDLTP                                       CDL038
225800200528     C                   PARM                    DDCUST                                       CDL038
225900200528     C                   PARM                    DDVDAT                                       CDL038
226000200528     C                   PARM                    DDODAT                                       CDL038
226100200528     C                   PARM                    DDBOKC                                       CDL038
226200200528     C                   PARM                    DDPRFC                                       CDL038
226300200528     C                   PARM                    DDBCCY                                       CDL038
226400200528     C                   PARM                    DDSCCY                                       CDL038
226500200528     C                   PARM      *BLANK        @RelatedDeal      6                          CDL038
226600200528      * Inputs/Outputs                                                                        CDL038
226700200528     C                   PARM                    DDDLST                                       CDL038
226800200528     C                   PARM                    DDCLAS                                       CDL038
226900200528      *                                                                                       CDL038
227000200528     C                   ENDSR                                                                CDL038
227100200528      *****************************************************************                       CDL038
227200200528      /EJECT
227300200528      *****************************************************************
227400200528      *                                                               *
227500200528      * SETUPVALID - Set up additional fields that are needed on the  *
227600200528      *    Valid file record.                                         *
227700200528      *                                                               *
227800200528      *****************************************************************
227900200528
228000200528     C     SETUPVALID    BEGSR
228100200528
228200200528      * Other F3xxxx fields are set up during the individual date
228300200528      *  validation, such as the ones where the input & database formats
228400200528      *  are different, e.g. dates, amounts.
228500200528      * This SR sets up the fields with the same (or compatible) attributes
228600200528
228700200528     C                   MOVE      DDSDNO        F3DADN
228800200528     C                   MOVE      DDBRSN        F3MBCA
228900200528     C                   MOVE      DDDLTP        F3TYPE
229000200528     C                   MOVE      DDDLST        F3STYP
229100200528     C                   MOVE      DDFEDF        F3FEDF
229200200528     C                   MOVE      DDCLAS        F3CLAS                                       CDL038
229300200528     C                   MOVE      DDREIN        F3REIN                                       CER043
229400200528      *
229500200528      ** Calculate Base Currency Equivalent - Dealing
229600200528      ** if Treasury Management is present
229700200528      *
229800200528     C     BGTRMG        IFEQ      'Y'
229900200528     C                   EXSR      CALBED
230000200528     C                   END
230100200528      *
230200200528      ** Set up other fields
230300200528      ** only if S01453 is installed
230400200528      *
230500200528     C     S01453        IFEQ      'Y'
230600200528     C                   EXSR      SETUP_OTH
230700200528     C                   END
230800200528      *
230900200528      ** Set up The user field from ZMUSER which is the front office                          CDL010
231000200528      ** user if sent . Only if CDL010 is installed                                           CDL010
231100200528      *                                                                                       CDL010
231200200528     C     CDL010        IFEQ      'Y'                                                        CDL010
231300200528     C                   MOVE      ZUSER         F3USER                                       CDL010
231400200528     C                   END                                                                  CDL010
231500200528      *                                                                                       CDL010
231600200528     C                   ENDSR
231700200528      *****************************************************************
231800200528      /EJECT
231900200528      *****************************************************************
232000200528      * CALBED - Calculate Base Currency Equivalent - Dealing
232100200528      *****************************************************************
232200200528     C     CALBED        BEGSR
232300200528      *
232400200528      ** Pass value date to ZACALBED
232500200528      ** (Unless option deal and options on value date flag is 'N')
232600200528      *
232700200528     C     DDDLTP        IFEQ      'OP'                                         B**3
232800200528     C     EROVDI        ANDEQ     'N'                                          B**3           S0131
232900200528     C                   Z-ADD     F3OTDN        @DAYN
233000200528     C                   ELSE                                                   X**3
233100200528     C                   Z-ADD     F3VDDN        @DAYN
233200200528     C                   END                                                    E**3
233300200528     C                   CALLB     'ZDATE9'
233400200528     C                   PARM                    @DAYN
233500200528     C                   PARM                    @YMD
233600200528     C                   PARM                    @RETN
233700200528      *
233800200528     C                   CALLB     'ZACALBED'
233900200528      *
234000200528      * INPUTS
234100200528      *
234200200528      * Buy  & Sell currencies
234300200528     C                   PARM                    DDBCCY                         buy ccy
234400200528     C                   PARM                    DDSCCY                         sell ccy
234500200528      *
234600200528      * Date effective, exchange rate, forward points
234700200528      *
234800200528     C                   PARM      @YMD          @@VDT             8 0          value date
234900200528     C                   PARM      @SRATE        @@DXR            13 8          exch rate
235000200528     C                   PARM      F3FWPP        @@DFP             7 2          forward pts
235100200528      *
235200200528      * Buy amount and Sell amount
235300200528      *
235400200528     C                   PARM      F3DAM1        @@DAM1           15 0          amount
235500200528     C                   PARM      F3DAM2        @@DAM2           15 0          amount
235600200528      *
235700200528      * buy: spot rate, ccy dec places, round down, norm quot decs
235800200528      *      scaling exponent, mult/div ind, mult/div ind-exch,
235900200528      *      low spot rate, high spot rate, FX spot date
236000200528      *
236100200528     C                   PARM                    @SPOT1           13 8          spot rate
236200200528     C                   PARM                    @CDP1             1 0          no of dec places
236300200528     C                   PARM                    @RDCY1            1            round down
236400200528     C                   PARM                    @@NDP1            1 0          norm quot decs
236500200528     C                   PARM                    @@SXP1                         scaling exponent
236600200528     C                   PARM                    @@MDF1            1            mult/div ind
236700200528     C                   PARM                    @@MDX1            1            mult/div ind,exch
236800200528     C                   PARM                    @@LSP1           13 8          low spot rate
236900200528     C                   PARM                    @@HSP1           13 8          high spot rate
237000200528     C                   PARM                    @@SPD1            8 0          FX spot date
237100200528      *
237200200528      * sell: spot rate, ccy dec places, round down, norm quot decs
237300200528      *       scaling exponent, mult/div ind, mult/div ind-exch,
237400200528      *       low spot rate, high spot rate, FX spot date
237500200528      *
237600200528     C                   PARM                    @SPOT2           13 8          spot rate
237700200528     C                   PARM                    @CDP2             1 0          no of dec places
237800200528     C                   PARM                    @RDCY2            1            round down
237900200528     C                   PARM                    @@NDP2            1 0          norm quot decs
238000200528     C                   PARM                    @@SXP2                         scaling exponent
238100200528     C                   PARM                    @@MDF2            1            mult/div ind
238200200528     C                   PARM                    @@MDX2            1            mult/div ind,exch
238300200528     C                   PARM                    @@LSP2           13 8          low spot rate
238400200528     C                   PARM                    @@HSP2           13 8          high spot rate
238500200528     C                   PARM                    @@SPD2            8 0          FX spot date
238600200528      *
238700200528      * ICD
238800200528     C                   PARM                    BNCYDL            3            mult/div ind
238900200528      *
239000200528      * OUTPUTS
239100200528      *
239200200528      * Base ccy dealing and dealt spot base
239300200528      *
239400200528     C                   PARM      *ZERO         @@DBCE           15 0          base ccy dealing
239500200528     C                   PARM      *ZERO         @@DSBC           15 0          dealt spot base
239600200528      *
239700200528      ** Update file fields
239800200528      *
239900200528     C                   Z-ADD     @@DBCE        F3BCDE                         **2
240000200528     C                   Z-ADD     @@DSBC        F3DSBE                         **2
240100200528      *
240200200528     C                   ENDSR
240300200528      *****************************************************************
240400200528      /EJECT
240500200528      *****************************************************************
240600200528      * SETUP_OTH - Set Up Other Fields
240700200528      *****************************************************************
240800200528     C     SETUP_OTH     BEGSR
240900200528      *
241000200528      * BUY AND SELL CURRENCY AMOUNTS
241100200528      * (make sell amount positive)
241200200528      *
241300200528     C                   Z-ADD     F3DAM1        @@BCYA           13 0
241400200528     C                   Z-SUB     F3DAM2        @@SCYA           13 0
241500200528      *
241600200528      ** Margin amount & currency
241700200528      *
241800200528     C     F3MGPT        IFNE      *ZEROS
241900200528     C     DDACTN        ANDEQ     'I'                                                        231410
242000200528     C                   EXSR      C_MGAM
242100200528     C                   END
242200200528      *
242300200528      ** Buy and Sell Forward points amounts
242400200528      *
242500200528     C                   EXSR      C_BSFPA
242600200528      *
242700200528      ** CALCULATE BUY DL BASE FORWARD RATE FROM FORWARD POINTS
242800200528      *
242900200528     C                   Z-ADD     *ZEROS        @@BRAT           13 8
243000200528     C     F3BDBF        IFNE      *ZEROS
243100200528     C                   EXSR      C_BDBR
243200200528     C                   END
243300200528      *
243400200528      ** CALCULATE SELL DL BASE FORWARD RATE FROM FORWARD POINTS
243500200528      *
243600200528     C                   Z-ADD     *ZEROS        @@SRAT           13 8
243700200528     C     F3SDBF        IFNE      *ZEROS
243800200528     C                   EXSR      C_SDBR
243900200528     C                   END
244000200528      *
244100200528      ** Other Currency DL Base Spot Rate
244200200528      *
244300200528     C     F3BDBS        IFNE      *ZEROS
244400200528     C*
244500200528     C                   Z-ADD     F3BDBS        F3SDBS
244600200528      *
244700200528      ** Other Spot rate should not include DL Base points in calcs.
244800200528      *
244900200528      ** Other Spot rate must allow for Multiply/divide rates &
245000200528      ** whether buy/sell is fixed. Margin excluded from calcs.
245100200528      *
245200200528     C     F3DMD1        IFEQ      'D'
245300200528     C     F3MGBS        ANDEQ     'B'
245400200528     C     F3DMD1        OREQ      'M'
245500200528     C     F3MGBS        ANDEQ     'S'
245600200528     C     1             MULT      F3OSRT        @@SDBS           13 8
245700200528     C                   ELSE
245800200528     C     1             DIV(H)    F3OSRT        @@SDBS
245900200528     C                   END
246000200528     C*
246100200528     C     F3MGBS        IFEQ      'B'
246200200528     C*
246300200528     C     @@MDF1        IFEQ      'M'
246400200528     C                   MULT      @@SDBS        F3SDBS
246500200528     C                   ELSE
246600200528     C                   DIV       @@SDBS        F3SDBS
246700200528     C                   END
246800200528     C*
246900200528     C                   ELSE
247000200528     C*
247100200528     C     @@MDF2        IFEQ      'M'
247200200528     C                   MULT      @@SDBS        F3SDBS
247300200528     C                   ELSE
247400200528     C                   DIV       @@SDBS        F3SDBS
247500200528     C                   END
247600200528     C*
247700200528     C                   END
247800200528      *
247900200528      ** Other Spot rate should not include DL Base points in calcs.
248000200528      *
248100200528     C                   Z-ADD     F3SDBS        @@SDBS
248200200528     C                   END
248300200528      *
248400200528      ** Other Currency DL Base Spot Rate Equivalent
248500200528      *
248600200528     C     F3BDBS        IFNE      *ZEROS
248700200528     C*
248800200528     C     F3MGBS        IFEQ      'S'
248900200528     C*
249000200528     C     @@MDF1        IFEQ      'M'
249100200528     C     @@BCYA        MULT      @@SDBS        @@SDBE           13 0
249200200528     C                   ELSE
249300200528     C     @@BCYA        DIV       @@SDBS        @@SDBE
249400200528     C                   END
249500200528     C*
249600200528     C                   ELSE
249700200528     C*
249800200528     C     @@MDF2        IFEQ      'M'
249900200528     C     @@SCYA        MULT      @@SDBS        @@SDBE
250000200528     C                   ELSE
250100200528     C     @@SCYA        DIV       @@SDBS        @@SDBE
250200200528     C                   END
250300200528     C*
250400200528     C                   END
250500200528     C*
250600200528     C                   Z-ADD     @@SDBE        F3SDBE
250700200528     C*
250800200528     C                   END
250900200528      *
251000200528      ** Buy DL Base Forward Amount
251100200528      ** Buy points amount is Buy ccy amount adjusted by DL pts rate
251200200528      *
251300200528     C     F3BDBF        IFNE      *ZEROS
251400200528     C     @@MDF1        IFEQ      'M'
251500200528     C     @@BCYA        MULT      @@BRAT        F3BDFA
251600200528     C                   ELSE
251700200528     C     @@BCYA        DIV       @@BRAT        F3BDFA
251800200528     C                   END
251900200528     C                   END
252000200528      *
252100200528      ** Sell DL Base Forward Amount
252200200528      ** Sell points amount is Sell ccy amount adjusted by DL pts rate
252300200528      *
252400200528     C     F3SDBF        IFNE      *ZEROS
252500200528     C     @@MDF2        IFEQ      'M'
252600200528     C     @@SCYA        MULT      @@SRAT        F3SDFA
252700200528     C                   ELSE
252800200528     C     @@SCYA        DIV       @@SRAT        F3SDFA
252900200528     C                   END
253000200528     C                   END
253100200528
253200200528     C                   ENDSR
253300200528     C*******************************************************************
253400200528      /EJECT
253500200528     C*******************************************************************
253600200528     C* C_MGAM - CALCULATE MARGIN AMOUNT & CURRENCY
253700200528     C*******************************************************************
253800200528     C     C_MGAM        BEGSR
253900200528      *
254000200528      ** Convert Margin Points into Margin Rate
254100200528      ** (@RRATE = RATE+MGN+FWD PTS)
254200200528      ** (@XRATE = RATE+FWD PTS)
254300200528      *
254400200528     C     @RRATE        SUB       @XRATE        @@MRAT           13 8
254500200528     C     @@MRAT        IFLT      0
254600200528     C                   Z-SUB     @@MRAT        @@MRAT
254700200528     C                   END
254800200528      *
254900200528      ** Set up factoring to adjust for decimal places
255000200528      *
255100200528     C     F3MGBS        IFEQ      'B'
255200200528     C     @CDP2         SUB       @CDP1         @DIFDP            1 0
255300200528     C                   ELSE
255400200528     C     @CDP1         SUB       @CDP2         @DIFDP
255500200528     C                   END
255600200528     C*
255700200528     C                   Z-ADD     1             @FACT             7 3
255800200528     C     @DIFDP        DOWGT     0
255900200528     C                   MULT      10            @FACT
256000200528     C                   SUB       1             @DIFDP
256100200528     C                   END
256200200528     C*
256300200528     C     @DIFDP        DOWLT     0
256400200528     C                   DIV       10            @FACT
256500200528     C                   ADD       1             @DIFDP
256600200528     C                   END
256700200528     C*
256800200528     C     @CDP1         ADD       1             CD                2 0
256900200528     C     @@BCYA        DIV       @SF(CD)       BCYAMT           15 0
257000200528     C     @CDP2         ADD       1             CD
257100200528     C     @@SCYA        DIV       @SF(CD)       SCYAMT           15 0
257200200528      *
257300200528      * DETERMINE MARGIN SIGN
257400200528      * BASED ON INPUT RATE AND ADJUSTED BUY AND SELL AMOUNTS
257500200528      *
257600200528     C     @@INRT        IFGT      1
257700200528     C     BCYAMT        IFLT      SCYAMT
257800200528     C                   MOVE      '-'           @MGSGN            1
257900200528     C                   ELSE
258000200528     C                   MOVE      '+'           @MGSGN
258100200528     C                   END
258200200528     C                   ELSE
258300200528     C     BCYAMT        IFLT      SCYAMT
258400200528     C                   MOVE      '+'           @MGSGN
258500200528     C                   ELSE
258600200528     C                   MOVE      '-'           @MGSGN
258700200528     C                   END
258800200528     C                   END
258900200528      *
259000200528      * CALCULATE MARGIN AMOUNT AND CURRENCY IF MARGI IN BUY CURRENCY
259100200528      *
259200200528     C     F3MGBS        IFEQ      'B'
259300200528     C*
259400200528     C     @MGSGN        IFEQ      '-'
259500200528     C     @@BCYA        MULT      @@MRAT        F3MGAM
259600200528     C                   MULT      @FACT         F3MGAM
259700200528     C                   ELSE
259800200528     C     @@SCYA        MULT      @@MRAT        @MGAM            13 0
259900200528     C     @MGAM         DIV(H)    @XRATE        F3MGAM
260000200528     C                   END
260100200528     C*
260200200528     C                   MOVE      DDSCCY        F3MGCY
260300200528     C*
260400200528     C                   ELSE
260500200528      *
260600200528      * CALCULATE MARGIN AMOUNT AND CURRENCY IF MARGIN IN SELL CURRENCY
260700200528      *
260800200528     C     @MGSGN        IFEQ      '+'
260900200528     C     @@SCYA        MULT      @@MRAT        F3MGAM
261000200528     C                   MULT      @FACT         F3MGAM
261100200528     C                   ELSE
261200200528     C     @@BCYA        MULT      @@MRAT        @MGAM
261300200528     C     @MGAM         DIV(H)    @XRATE        F3MGAM
261400200528     C                   END
261500200528     C*
261600200528     C                   MOVE      DDBCCY        F3MGCY
261700200528     C*
261800200528     C                   END
261900200528     C*
262000200528     C                   ENDSR
262100200528     C*******************************************************************
262200200528      /EJECT
262300200528     C*******************************************************************
262400200528     C* C_BSFPA - CALCULATE BUY AND SELL FORWARD POINTS AMOUNTS
262500200528     C*******************************************************************
262600200528     C     C_BSFPA       BEGSR
262700200528      *
262800200528      * FORWARD POINTS = GROSS UNSCALED RATE - UNSCALED INPUT RATE
262900200528      *
263000200528     C     @@GURT        SUB       F3OSRT        @@FWDP           13 8
263100200528     C*
263200200528     C** Buy forward points amount
263300200528     C*
263400200528     C     @@MDF1        IFEQ      'M'
263500200528     C     @@BCYA        MULT      @@FWDP        F3BFPA
263600200528     C                   ELSE
263700200528     C     @@FWDP        IFNE      0
263800200528     C     @@BCYA        DIV       @@FWDP        F3BFPA
263900200528     C                   ELSE
264000200528     C                   Z-ADD     0             F3BFPA
264100200528     C                   END
264200200528     C                   END
264300200528     C*
264400200528     C** Sell forward points amount
264500200528     C*
264600200528     C     @@MDF2        IFEQ      'M'
264700200528     C     @@SCYA        MULT      @@FWDP        F3SFPA
264800200528     C                   ELSE
264900200528     C     @@FWDP        IFNE      0
265000200528     C     @@SCYA        DIV       @@FWDP        F3SFPA
265100200528     C                   ELSE
265200200528     C                   Z-ADD     0             F3SFPA
265300200528     C                   END
265400200528     C                   END
265500200528     C*
265600200528     C                   ENDSR
265700200528     C*******************************************************************
265800200528      /EJECT
265900200528     C*******************************************************************
266000200528     C* C_BDBR -  CALCULATE BUY DL BASE FORWARD RATE FROM FORWARD POINTS
266100200528     C*******************************************************************
266200200528     C     C_BDBR        BEGSR
266300200528      *
266400200528      ** Calculate new rate
266500200528      *
266600200528     C                   CALLB     'ZA0780'
266700200528      *
266800200528      * INPUTS
266900200528      *
267000200528     C                   PARM                    DDBCCY            3            buy ccy
267100200528     C                   PARM                    @@BCCY            3            sell ccy
267200200528      *
267300200528      * ICD
267400200528     C                   PARM                    BNCYDL            3            sell ccy
267500200528      *
267600200528     C                   PARM      1             @@IRAT           13 8          exchange rate
267700200528     C                   PARM                    @@DMD1            1            1st ccy ml/dv ind
267800200528     C                   PARM      F3BDBF        @@FPNT            7 2          forward points
267900200528      *
268000200528     C                   PARM      'N'           @@SCAL            1            scale rate?
268100200528      *
268200200528     C                   PARM                    @@NDP1            1 0          norm quot decs
268300200528     C                   PARM                    @@SXP1                         scaling exponent
268400200528      *
268500200528     C                   PARM                    @@BCDP            1 0          norm quot decs
268600200528     C                   PARM                    @@BCSP                         scaling exponent
268700200528      *
268800200528      * OUTPUTS
268900200528      *
269000200528     C                   PARM      *ZEROS        @@GSRT           13 8          gross scaled rate
269100200528     C                   PARM      *ZEROS        @@GURT           13 8          gross unscld rate
269200200528      *
269300200528      ** Store Buy DL Base Forward Rate
269400200528      *
269500200528     C     @@GURT        SUB       @@IRAT        @@BRAT
269600200528     C*
269700200528     C                   ENDSR
269800200528     C*******************************************************************
269900200528      /EJECT
270000200528     C*******************************************************************
270100200528     C* C_SDBR -  CALCULATE SELL DL BASE FORWARD RATE FROM FORWARD POINTS
270200200528     C*******************************************************************
270300200528     C     C_SDBR        BEGSR
270400200528      *
270500200528      ** Calculate new rate
270600200528      *
270700200528     C                   CALLB     'ZA0780'
270800200528      *
270900200528      * INPUTS
271000200528      *
271100200528     C                   PARM                    @@BCCY            3            buy ccy
271200200528     C                   PARM                    DDSCCY            3            sell ccy
271300200528      *
271400200528      * ICD
271500200528     C                   PARM                    BNCYDL            3            sell ccy
271600200528      *
271700200528     C                   PARM      1             @@IRAT           13 8          exchange rate
271800200528     C                   PARM                    @@DMD1            1            1st ccy ml/dv ind
271900200528     C                   PARM      F3SDBF        @@FPNT            7 2          forward points
272000200528      *
272100200528     C                   PARM      'N'           @@SCAL            1            scale rate?
272200200528      *
272300200528     C                   PARM                    @@BCDP            1 0          norm quot decs
272400200528     C                   PARM                    @@BCSP                         scaling exponent
272500200528      *
272600200528     C                   PARM                    @@NDP2            1 0          norm quot decs
272700200528     C                   PARM                    @@SXP2                         scaling exponent
272800200528      *
272900200528      * OUTPUTS
273000200528      *
273100200528     C                   PARM      *ZEROS        @@GSRT           13 8          gross scaled rate
273200200528     C                   PARM      *ZEROS        @@GURT           13 8          gross unscld rate
273300200528      *
273400200528      ** Store Buy DL Base Forward Rate
273500200528      *
273600200528     C     @@GURT        SUB       @@IRAT        @@SRAT
273700200528      *
273800200528     C                   ENDSR
273900200528      *****************************************************************
274000200528      /EJECT
274100200528      *                                                                                       CER043
274200200528      *****************************************************************                       CER043
274300200528      *                                                               *                       CER043
274400200528      ** SRVREIN - Validate Reciprocal Rate Indicator                 *                       CER043
274500200528      *                                                               *                       CER043
274600200528      *  Called by: Main Processing                                   *                       CER043
274700200528      *                                                               *                       CER043
274800200528      *  Calls: Reseterrs, Updaterrs                                  *                       CER043
274900200528      *                                                               *                       CER043
275000200528      *****************************************************************                       CER043
275100200528      *                                                                                       CER043
275200200528     C     SRVREIN       BEGSR                                                                CER043
275300200528      *                                                                                       CER043
275400200528      ** Reset variables updated by each module                                               CER043
275500200528      *                                                                                       CER043
275600200528     C                   EXSR      RESETERRS                                                  CER043
275700200528                                                                                              CER043
275800200528     C                   CALLB     'FXVREIN'                                                  CER043
275900200528     C                   PARM                    RetCodeOut                                   CER043
276000200528     C                   PARM                    DDREIN                                       CER043
276100200528     C                   PARM                    FldNamXAr                                    CER043
276200200528     C                   PARM                    MsgIDXAr                                     CER043
276300200528     C                   PARM                    MsgDtaXAr                                    CER043
276400200528     C                   PARM                    WFldNmXAr                                    CER043
276500200528     C                   PARM                    WMsgIDXAr                                    CER043
276600200528     C                   PARM                    WMsgDtXAr                                    CER043
276700200528     C                   PARM                    DDReinOK                                     CER043
276800200528      *                                                                                       CER043
276900200528      ** Update error info with that returned from validation module                          CER043
277000200528      *                                                                                       CER043
277100200528     C                   EXSR      UPDATERRS                                                  CER043
277200200528                                                                                              CER043
277300200528     C                   ENDSR                                                                CER043
277400200528      *****************************************************************                       CER043
277500200528     C/COPY WNCPYSRC,FXH00065
277600200528      /EJECT                                                                                  CER043
277700200528      *****************************************************************
277800200528      * *INZSR - Program Initialisation routine                       *
277900200528      *****************************************************************
278000200528
278100200528     C     *INZSR        BEGSR
278200200528
278300200528     C     *ENTRY        PLIST
278400200528      * Response mode (1A), from source system common header
278500200528     C                   PARM                    RespMode
278600200528      * Transaction information (DS) from source system
278700200528     C                   PARM                    TranIn
278800200528     C                   PARM                    InfData                        CAP051
278900200528      * Receive Settlement Ccy, Method & Nostro and  Pay Settlement Ccy,
279000200528      * Method & Nostro, from default or valid deal
279100200528     C                   PARM                    RecSetCcy
279200200528     C                   PARM                    RecSetMeth
279300200528     C                   PARM                    RecNostro
279400200528     C                   PARM                    PaySetCcy
279500200528     C                   PARM                    PaySetMeth
279600200528     C                   PARM                    PayNostro
279700200528     C                   PARM                    FrontOffice                    CPB002
279800200528     C                   PARM                    ExtData                        CAP004
279900200528      *
280000200528     C/COPY WNCPYSRC,FXFXDLVC01
280100200528      * NET BUY/SELL REFERENCE
280200200528     C                   PARM                    DDNBRF           19
280300200528     C                   PARM                    DDNSRF           19
280400200528      * Field OK flags (DS) from/to caller
280500200528     C                   PARM                    OKFlagsDS
280600200528      * Error fields/message IDs/message data (arrays) from/to caller
280700200528     C                   PARM                    FldNameArr
280800200528     C                   PARM                    MsgIDArr
280900200528     C                   PARM                    MsgDtaArr
281000200528      * Array index (3P0) from/to caller
281100200528     C                   PARM                    Idx
281200200528      * Warning fields/message IDs/message data (arrays) from/to caller
281300200528     C                   PARM                    WFldNamArr
281400200528     C                   PARM                    WMsgIDArr
281500200528     C                   PARM                    WMsgDtaArr
281600200528      * Array index (3P0) from/to caller
281700200528     C                   PARM                    WIdx
281800200528      * Valid Deals layout (DS) from/to caller
281900200528     C                   PARM                    ValidDeal
282000200528     C                   PARM                    DDDTYP            1                          242477
282100200528     C                   PARM                    InCDL099                                     CDL099
282200200528     C/COPY WNCPYSRC,FXFXDLVC02
282300200528                                                                                              CDL029
282400200528     C     KBRANCHAUTH   KLIST                                                                CDL029
282500200528     C******             KFLD                    BBBRCD                                CDL029CDL029A
282600200528     C                   KFLD                    W0BRCD            3                         CDL029A
282700200528     C                   KFLD                    W0CUST            6                         CDL029A
282800200528     C                   KFLD                    DDBRSN                                       CDL029
282900200528      ************                                                                           BUG5517
283000200528      ****GET*ZMUSER to access default branch.                                               BUG5517
283100200528      ************                                                                           BUG5517
283200200528     C******DTAARA       DEFINE                  ZMUSER                                      BUG5517
283300200528     C************       IN        ZMUSER                                                    BUG5517
283400200528     C************       UNLOCK    ZMUSER                                                    BUG5517
283500200528      *
283600200528      **  Move program name into *LDA field.
283700200528      *
283800200528     C     *LOCK         IN        LDA
283900200528     C                   MOVEL     'FXFXDLVAL'   DBPGM
284000200528     C                   OUT       LDA
284100200528      *
284200200528      ** Access Bank details via access program
284300200528      *  (database error handling done in access program)
284400200528     C                   CALLB     'AOBANKR0'
284500200528     C                   PARM      '*DBERR '     @RTCD             7
284600200528     C                   PARM      '*FIRST '     @OPTN             7
284700200528     C     SDBANK        PARM      SDBANK        DSFDY
284800200528      *
284900200528      ** Access General Ledger details via access program
285000200528      *  (database error handling done in access program)
285100200528     C**********         CALLB     'AOGELRR0'                                                 CGL029
285200200528     C                   CALLB     'AOGELRR1'                                                 CGL029
285300200528     C                   PARM      '*DBERR '     @RTCD             7
285400200528     C                   PARM      '*FIRST '     @OPTN             7
285500200528     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
285600200528     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
285700200528      *
285800200528      ** Access Dealing details via access program
285900200528      *  (database error handling done in access program)
286000200528     C**********         CALLB     'AODEALR0'                                                 CGL029
286100200528     C                   CALLB     'AODEALR1'                                                 CGL029
286200200528     C                   PARM      '*DBERR '     @RTCD             7
286300200528     C                   PARM      '*FIRST '     @OPTN             7
286400200528     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
286500200528     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
286600200528      *
286700200528      ** Access Trading data via access program
286800200528      *  (database error handling done in access program)
286900200528     C                   CALLB     'AOTRADR0'
287000200528     C                   PARM      '*DBERR '     @RTCD             7
287100200528     C                   PARM      '*FIRST '     @OPTN             7
287200200528     C     SDTRAD        PARM      SDTRAD        DSFDY
287300200528      *
287400200528      ** Access MIDAS Modules details via access program
287500200528      *  (database error handling done in access program)
287600200528     C                   CALLB     'AOMMODR0'
287700200528     C                   PARM      '*DBERR '     @RTCD             7
287800200528     C                   PARM      '*FIRST '     @OPTN             7
287900200528     C     SDMMOD        PARM      SDMMOD        DSFDY
288000200528      *
288100200528      ** Access Treasury Management details via access program
288200200528      *  (database error handling done in access program)
288300200528      *
288400200528     C     BGTRMG        IFEQ      'Y'
288500200528     C                   CALLB     'AOTRMAR0'
288600200528     C                   PARM      '*DBERR '     @RTCD
288700200528     C                   PARM      '*FIRST '     @OPTN
288800200528     C     SDTRMA        PARM      SDTRMA        DSFDY
288900200528     C                   ENDIF
289000200528      *
289100200528      ** Access Portfolio Management details via access program
289200200528      *  (database error handling done in access program)
289300200528     C     BGPFMG        IFEQ      'Y'
289400200528     C                   CALLB     'AOPORTR0'
289500200528     C                   PARM      '*DBERR '     @RTCD
289600200528     C                   PARM      '*FIRST'      @OPTN
289700200528     C     SDPORT        PARM      SDPORT        DSFDY
289800200528     C                   ENDIF
289900200528      *
290000200528      ** Access Retail details via access program
290100200528      *  (database error handling done in access program)
290200200528     C     BGRTBN        IFEQ      'Y'
290300200528     C     BGIOAC        OREQ      'Y'
290400200528     C                   CALLB     'AORETLR0'
290500200528     C                   PARM      '*DBERR '     @RTCD
290600200528     C                   PARM      '*FIRST '     @OPTN
290700200528     C     SDRETL        PARM      SDRETL        DSFDY
290800200528     C                   ENDIF
290900200528      **
291000200528      ** Access Currencies file via access program
291100200528      ** for Base Currency for Dealing details
291200200528      **
291300200528     C                   CALLB     'AOCURRR0'
291400200528     C                   PARM      '*DBERR '     @RTCD             7
291500200528     C                   PARM      '*KEY   '     @OPTN             7
291600200528     C                   PARM      BNCYDL        @AJCD             3
291700200528     C     SDCURR        PARM      SDCURR        DSSDY
291800200528      *
291900200528     C                   MOVE      A6CYCD        @@BCCY            3
292000200528     C                   Z-ADD     A6NBDP        @@BCDP            1 0
292100200528     C                   Z-ADD     A6SCEX        @@BCSP
292200200528      *
292300200528      * Get FX complete deal amendable fields details
292400200528      *
292500200528     C     1             SETLL     FXCDAFLL
292600200528     C     *IN99         DOUEQ     '1'
292700200528     C     FDDLTF        OREQ      *BLANKS
292800200528     C                   READ      FXCDAFLL                               99
292900200528     C                   END
293000200528     C     *IN99         IFEQ      '1'
293100200528     C     *LOCK         IN        LDA
293200200528     C                   MOVEL     'FXCDAFLL'    DBFILE                         ************
293300200528     C                   MOVEL     '001'         DBASE
293400200528     C                   MOVEL     *BLANK        DBKEY
293500200528     C                   OUT       LDA
293600200528     C                   SETON                                        U7U8LR
293700200528     C                   EXSR      #TERM
293800200528     C                   END
293900200528      *
294000200528      ** Access SAR details file to determine if S01391
294100200528      ** (Japanese Sub Module) is on.
294200200528      *
294300200528     C                   CALLB     'AOSARDR0'
294400200528     C                   PARM      *BLANKS       @RTCD
294500200528     C                   PARM      '*VERIFY'     @OPTN
294600200528     C                   PARM      'S01391'      @SARD
294700200528     C     SCSARD        PARM      SCSARD        DSFDY
294800200528     C     @RTCD         IFNE      *BLANKS
294900200528     C     @RTCD         ANDNE     '*NRF   '
295000200528     C     *LOCK         IN        LDA
295100200528     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
295200200528     C                   MOVEL     '002'         DBASE
295300200528     C                   MOVEL     'S01391'      DBKEY
295400200528     C                   OUT       LDA
295500200528     C                   SETON                                        U7U8LR
295600200528     C                   EXSR      #TERM
295700200528     C                   END
295800200528     C     @RTCD         IFEQ      *BLANK
295900200528     C                   MOVEL     'Y'           S01391            1
296000200528     C                   ELSE
296100200528     C                   MOVEL     'N'           S01391
296200200528     C                   END
296300200528      *
296400200528      ** Access SAR details file to determine if S01453
296500200528      ** (Margin and FX Points in Base Currency) is on.
296600200528      *
296700200528     C                   CALLB     'AOSARDR0'
296800200528     C                   PARM      *BLANKS       @RTCD
296900200528     C                   PARM      '*VERIFY'     @OPTN
297000200528     C                   PARM      'S01453'      @SARD
297100200528     C     SCSARD        PARM      SCSARD        DSFDY
297200200528     C     @RTCD         IFNE      *BLANKS
297300200528     C     @RTCD         ANDNE     '*NRF   '
297400200528     C     *LOCK         IN        LDA
297500200528     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
297600200528     C                   MOVEL     '003'         DBASE
297700200528     C                   MOVEL     'S01453'      DBKEY
297800200528     C                   OUT       LDA
297900200528     C                   SETON                                        U7U8LR
298000200528     C                   EXSR      #TERM
298100200528     C                   END
298200200528     C     @RTCD         IFEQ      *BLANK
298300200528     C                   MOVEL     'Y'           S01453            1
298400200528     C                   ELSE
298500200528     C                   MOVEL     'N'           S01453
298600200528     C                   END
298700200528      *
298800200528      ** Access SAR details file to determine if CDL005 is on.
298900200528      ** (Customer format in input functions is shortname)
299000200528      *
299100200528     C                   CALLB     'AOSARDR0'
299200200528     C                   PARM      *BLANKS       @RTCD
299300200528     C                   PARM      '*VERIFY'     @OPTN
299400200528     C                   PARM      'CDL005'      @SARD
299500200528     C     SCSARD        PARM      SCSARD        DSFDY
299600200528     C     @RTCD         IFNE      *BLANKS
299700200528     C     @RTCD         ANDNE     '*NRF   '
299800200528     C     *LOCK         IN        LDA
299900200528     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
300000200528     C                   MOVEL     '004'         DBASE
300100200528     C                   MOVEL     'CDL005'      DBKEY
300200200528     C                   OUT       LDA
300300200528     C                   SETON                                        U7U8LR
300400200528     C                   EXSR      #TERM
300500200528     C                   END
300600200528     C     @RTCD         IFEQ      *BLANK
300700200528     C                   MOVEL     'S'           CustFormat
300800200528     C                   ELSE
300900200528     C                   MOVEL     'N'           CustFormat
301000200528     C                   END
301100200528      *                                                                         CDL011
301200200528      ** Access SAR details to determine if CDL011 is on.                       CDL011
301300200528      ** (Expansion of Customer Number on Dealing Transactions)                 CDL011
301400200528      *                                                                         CDL011
301500200528     C                   CALLB     'AOSARDR0'                                   CDL011
301600200528     C                   PARM      *BLANKS       @RTCD                          CDL011
301700200528     C                   PARM      '*VERIFY'     @OPTN                          CDL011
301800200528     C                   PARM      'CDL011'      @SARD                          CDL011
301900200528     C     SCSARD        PARM      SCSARD        DSFDY                          CDL011
302000200528     C     @RTCD         IFNE      *BLANKS                                      CDL011
302100200528     C     @RTCD         ANDNE     '*NRF   '                                    CDL011
302200200528     C     *LOCK         IN        LDA                                          CDL011
302300200528     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL011
302400200528     C                   MOVEL     '009'         DBASE                          CDL011
302500200528     C                   MOVEL     'CDL011'      DBKEY                          CDL011
302600200528     C                   OUT       LDA                                          CDL011
302700200528     C                   SETON                                        U7U8LR    CDL011
302800200528     C                   EXSR      #TERM                                        CDL011
302900200528     C                   END                                                    CDL011
303000200528     C     @RTCD         IFEQ      *BLANK                                       CDL011
303100200528     C                   MOVEL     'S'           CustFormat                     CDL011
303200200528     C                   END                                                    CDL011
303300200528      *
303400200528      ** Access SAR details file to determine if CDL002 is on.
303500200528      ** (FX Netting)
303600200528      *
303700200528     C                   CALLB     'AOSARDR0'
303800200528     C                   PARM      *BLANKS       @RTCD
303900200528     C                   PARM      '*VERIFY'     @OPTN
304000200528     C                   PARM      'CDL002'      @SARD
304100200528     C     SCSARD        PARM      SCSARD        DSFDY
304200200528     C     @RTCD         IFNE      *BLANKS
304300200528     C     @RTCD         ANDNE     '*NRF   '
304400200528     C     *LOCK         IN        LDA
304500200528     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
304600200528     C                   MOVEL     '005'         DBASE
304700200528     C                   MOVEL     'CDL002'      DBKEY
304800200528     C                   OUT       LDA
304900200528     C                   SETON                                        U7U8LR
305000200528     C                   EXSR      #TERM
305100200528     C                   END
305200200528     C     @RTCD         IFEQ      *BLANK
305300200528     C                   MOVEL     'Y'           CDL002            1
305400200528     C                   ELSE
305500200528     C                   MOVEL     'N'           CDL002
305600200528     C                   END
305700200528      *                                                                         CDL008
305800200528      ** Access SAR details file to determine if CDL008 is on.                  CDL008
305900200528      ** (Continuous Linked Settlement)                                         CDL008
306000200528      *                                                                         CDL008
306100200528     C                   CALLB     'AOSARDR0'                                   CDL008
306200200528     C                   PARM      *BLANKS       @RTCD                          CDL008
306300200528     C                   PARM      '*VERIFY'     @OPTN                          CDL008
306400200528     C                   PARM      'CDL008'      @SARD                          CDL008
306500200528     C     SCSARD        PARM      SCSARD        DSFDY                          CDL008
306600200528     C     @RTCD         IFNE      *BLANKS                                      CDL008
306700200528     C     @RTCD         ANDNE     '*NRF   '                                    CDL008
306800200528     C     *LOCK         IN        LDA                                          CDL008
306900200528     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL008
307000200528     C                   MOVEL     '006'         DBASE                          CDL008
307100200528     C                   MOVEL     'CDL008'      DBKEY                          CDL008
307200200528     C                   OUT       LDA                                          CDL008
307300200528     C                   SETON                                        U7U8LR    CDL008
307400200528     C                   EXSR      #TERM                                        CDL008
307500200528     C                   ENDIF                                                  CDL008
307600200528     C     @RTCD         IFEQ      *BLANKS                                      CDL008
307700200528     C                   MOVEL     'Y'           CDL008            1            CDL008
307800200528     C                   ELSE                                                   CDL008
307900200528     C                   MOVEL     'N'           CDL008                         CDL008
308000200528     C                   ENDIF                                                  CDL008
308100200528                                                                                              CAS001
308200200528      ** Access SAR details file to determine if CAS001 is on.                                CAS001
308300200528      ** (Net Present Value Accounting)                                                       CAS001
308400200528                                                                                              CAS001
308500200528     C                   CALLB     'AOSARDR0'                                                 CAS001
308600200528     C                   PARM      *BLANKS       PRTCD                                        CAS001
308700200528     C                   PARM      '*VERIFY'     POPTN                                        CAS001
308800200528     C                   PARM      'CAS001'      PSARD                                        CAS001
308900200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
309000200528     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
309100200528     C                             PRTCD <> '*NRF   '                                         CAS001
309200200528     C     *LOCK         IN        LDA                                                        CAS001
309300200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS001
309400200528     C                   EVAL      DBASE = 007                                                CAS001
309500200528     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
309600200528     C                   OUT       LDA                                                        CAS001
309700200528     C                   EVAL      *INU7 = *ON                                                CAS001
309800200528     C                   EVAL      *INU8 = *ON                                                CAS001
309900200528     C                   EVAL      *INLR = *ON                                                CAS001
310000200528     C                   EXSR      #TERM                                                      CAS001
310100200528     C                   ENDIF                                                                CAS001
310200200528     C                   IF        PRTCD = *BLANKS                                            CAS001
310300200528     C                   EVAL      CAS001 = 'Y'                                               CAS001
310400200528     C                   ELSE                                                                 CAS001
310500200528     C                   EVAL      CAS001 = 'N'                                               CAS001
310600200528     C                   ENDIF                                                                CAS001
310700200528     C/COPY WNCPYSRC,FXH00241
310800200528                                                                                              CSC011
310900200528      ** Check if CSC011 is installed                                                         CSC011
311000200528                                                                                              CSC011
311100200528     C                   EVAL      WRunDay = BJRDNB                                           CSC011
311200200528                                                                                              CSC011
311300200528     C                   CALLB     'AOSARDR0'                                                 CSC011
311400200528     C                   PARM      *BLANKS       PRtCd                                        CSC011
311500200528     C                   PARM      '*VERIFY'     POptn                                        CSC011
311600200528     C                   PARM      'CSC011'      PSard                                        CSC011
311700200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
311800200528                                                                                              CSC011
311900200528     C                   IF        PRtCd = *Blanks                                            CSC011
312000200528     C                   EVAL      CSC011 = 'Y'                                               CSC011
312100200528     C                   IN        SC24X7                                                     CSC011
312200200528     C                   IN        SDSTAT                                                     CSC011
312300200528     C                   IF        LIBR = S1SUPP                                              CSC011
312400200528     C                   EVAL      WRunDay = S1DATE                                           CSC011
312500200528     C                   ENDIF                                                                CSC011
312600200528                                                                                              CSC011
312700200528     C                   ELSE                                                                 CSC011
312800200528     C                   EVAL      CSC011 = 'N'                                               CSC011
312900200528     C                   IF        (PRtCd <> '*NRF') and                                      CSC011
313000200528     C                             (PRtCd <> *Blanks)                                         CSC011
313100200528     C     *LOCK         IN        LDA                                                        CSC011
313200200528     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
313300200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
313400200528     C                   EVAL      DBASE = 7                                                  CSC011
313500200528     C                   OUT       LDA                                                        CSC011
313600200528     C                   EXSR      *PSSR                                                      CSC011
313700200528     C                   ENDIF                                                                CSC011
313800200528                                                                                              CSC011
313900200528     C                   ENDIF                                                                CSC011
314000200528     C/COPY WNCPYSRC,FXH00062
314100200528                                                                                              CDL010
314200200528      ** Access SAR details file to determine if CDL010 is on.                                CDL010
314300200528      ** (Dealing Transaction Authorisation)                                                  CDL010
314400200528                                                                                              CDL010
314500200528     C                   CALLB     'AOSARDR0'                                                 CDL010
314600200528     C                   PARM      *BLANKS       PRTCD                                        CDL010
314700200528     C                   PARM      '*VERIFY'     POPTN                                        CDL010
314800200528     C                   PARM      'CDL010'      PSARD                                        CDL010
314900200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL010
315000200528     C                   IF        PRTCD <> *BLANKS AND                                       CDL010
315100200528     C                             PRTCD <> '*NRF   '                                         CDL010
315200200528     C     *LOCK         IN        LDA                                                        CDL010
315300200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL010
315400200528     C                   EVAL      DBASE = 008                                                CDL010
315500200528     C                   EVAL      DBKEY = 'CDL010'                                           CDL010
315600200528     C                   OUT       LDA                                                        CDL010
315700200528     C                   EVAL      *INU7 = *ON                                                CDL010
315800200528     C                   EVAL      *INU8 = *ON                                                CDL010
315900200528     C                   EVAL      *INLR = *ON                                                CDL010
316000200528     C                   EXSR      #TERM                                                      CDL010
316100200528     C                   ENDIF                                                                CDL010
316200200528     C                   IF        PRTCD = *BLANKS                                            CDL010
316300200528     C                   EVAL      CDL010 = 'Y'                                               CDL010
316400200528     C                   ELSE                                                                 CDL010
316500200528     C                   EVAL      CDL010 = 'N'                                               CDL010
316600200528     C                   ENDIF                                                                CDL010
316700200528     C*                                                                                       CDL029
316800200528     C                   CALLB     'AOSARDR0'                                                 CDL029
316900200528     C                   PARM      *BLANKS       PRTCD                                        CDL029
317000200528     C                   PARM      '*VERIFY'     POPTN                                        CDL029
317100200528     C                   PARM      'CDL029'      PSARD                                        CDL029
317200200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL029
317300200528     C                   IF        PRTCD <> *BLANKS AND                                       CDL029
317400200528     C                             PRTCD <> '*NRF   '                                         CDL029
317500200528     C     *LOCK         IN        LDA                                                        CDL029
317600200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL029
317700200528     C                   EVAL      DBASE = 028                                                CDL029
317800200528     C                   EVAL      DBKEY = 'CDL029'                                           CDL029
317900200528     C                   OUT       LDA                                                        CDL029
318000200528     C                   EVAL      *INU7 = *ON                                                CDL029
318100200528     C                   EVAL      *INU8 = *ON                                                CDL029
318200200528     C                   EVAL      *INLR = *ON                                                CDL029
318300200528     C                   EXSR      #TERM                                                      CDL029
318400200528     C                   ENDIF                                                                CDL029
318500200528     C                   IF        PRTCD = *BLANKS                                            CDL029
318600200528     C                   EVAL      CDL029 = 'Y'                                               CDL029
318700200528     C                   ELSE                                                                 CDL029
318800200528     C                   EVAL      CDL029 = 'N'                                               CDL029
318900200528     C                   ENDIF                                                                CDL029
319000200528                                                                                              CDL029
319100200528      ** Access SAR details file to determine if CDL038 is switched on                       BUG9717
319200200528                                                                                             BUG9717
319300200528     C                   CALLB     'AOSARDR0'                                                BUG9717
319400200528     C                   PARM      *BLANKS       PRTCD                                       BUG9717
319500200528     C                   PARM      '*VERIFY'     POPTN                                       BUG9717
319600200528     C                   PARM      'CDL038'      PSARD                                       BUG9717
319700200528     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9717
319800200528                                                                                             BUG9717
319900200528     C                   IF        PRTCD <> *BLANKS AND                                      BUG9717
320000200528     C                             PRTCD <> '*NRF   '                                        BUG9717
320100200528     C     *LOCK         IN        LDA                                                       BUG9717
320200200528     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG9717
320300200528     C                   EVAL      DBASE = 908                                               BUG9717
320400200528     C                   EVAL      DBKEY = 'CDL038'                                          BUG9717
320500200528     C                   OUT       LDA                                                       BUG9717
320600200528     C                   EXSR      *PSSR                                                     BUG9717
320700200528     C                   ENDIF                                                               BUG9717
320800200528                                                                                             BUG9717
320900200528     C                   IF        PRTCD = *BLANKS                                           BUG9717
321000200528     C                   EVAL      CDL038 = 'Y'                                              BUG9717
321100200528     C                   ELSE                                                                BUG9717
321200200528     C                   EVAL      CDL038 = 'N'                                              BUG9717
321300200528     C                   ENDIF                                                               BUG9717
321400200528                                                                                             BUG9717
321500200528     C                   CALLB     'AOSARDR0'                                                 CGL058
321600200528     C                   PARM      *BLANKS       @RTCD                                        CGL058
321700200528     C                   PARM      '*VERIFY'     @OPTN                                        CGL058
321800200528     C                   PARM      'CGL058'      @SARD                                        CGL058
321900200528     C                   IF        @RTCD = *BLANKS                                            CGL058
322000200528     C                   MOVE      'Y'           CGL058                                       CGL058
322100200528     C                   ENDIF                                                                CGL058
322200200528      ** Access SAR details file to determine if CDL049 is switched on                       CDL049
322300200528                                                                                             CDL049
322400200528     C                   CALLB     'AOSARDR0'                                                CDL049
322500200528     C                   PARM      *BLANKS       PRTCD                                       CDL049
322600200528     C                   PARM      '*VERIFY'     POPTN                                       CDL049
322700200528     C                   PARM      'CDL049'      PSARD                                       CDL049
322800200528     C     SCSARD        PARM      SCSARD        DSFDY                                       CDL049
322900200528      *                                                                                      CDL049
323000200528     C                   IF        PRTCD = *BLANKS                                           CDL049
323100200528     C                   EVAL      CDL049 = 'Y'                                              CDL049
323200200528     C                   ELSE                                                                CDL049
323300200528     C                   EVAL      CDL049 = 'N'                                              CDL049
323400200528     C                   ENDIF                                                               CDL049
323500200528      *                                                                                       CER043
323600200528      ** Call AOSARDR0 to check if CER043 is switched on                                      CER043
323700200528      *                                                                                       CER043
323800200528     C                   EVAL      CER043 = 'N'                                               CER043
323900200528     C                   CALLB     'AOSARDR0'                                                 CER043
324000200528     C                   PARM      *BLANKS       PRTCD                                        CER043
324100200528     C                   PARM      '*VERIFY'     POPTN                                        CER043
324200200528     C                   PARM      'CER043'      PSARD                                        CER043
324300200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
324400200528                                                                                              CER043
324500200528     C                   IF        PRTCD <> *BLANKS AND                                       CER043
324600200528     C                             PRTCD <> '*NRF   '                                         CER043
324700200528     C     *LOCK         IN        LDA                                                        CER043
324800200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
324900200528     C                   EVAL      DBASE = 909                                                CER043
325000200528     C                   EVAL      DBKEY = 'CER043'                                           CER043
325100200528     C                   OUT       LDA                                                        CER043
325200200528     C                   EXSR      *PSSR                                                      CER043
325300200528     C                   ENDIF                                                                CER043
325400200528                                                                                              CER043
325500200528     C                   IF        PRTCD = *BLANKS                                            CER043
325600200528     C                   EVAL      CER043 = 'Y'                                               CER043
325700200528     C                   ENDIF                                                                CER043
325800200528      *                                                                                       CER043
325900200528      ** Call AOSARDR0 to check if CDL099 is switched on                                      CDL099
326000200528      *                                                                                       CDL099
326100200528     C                   EVAL      CDL099 = 'N'                                               CDL099
326200200528     C                   CALLB     'AOSARDR0'                                                 CDL099
326300200528     C                   PARM      *BLANKS       PRTCD                                        CDL099
326400200528     C                   PARM      '*VERIFY'     POPTN                                        CDL099
326500200528     C                   PARM      'CDL099'      PSARD                                        CDL099
326600200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL099
326700200528                                                                                              CDL099
326800200528     C                   IF        PRTCD <> *BLANKS AND                                       CDL099
326900200528     C                             PRTCD <> '*NRF   '                                         CDL099
327000200528     C     *LOCK         IN        LDA                                                        CDL099
327100200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL099
327200200528     C                   EVAL      DBASE = 910                                                CDL099
327300200528     C                   EVAL      DBKEY = 'CDL099'                                           CDL099
327400200528     C                   OUT       LDA                                                        CDL099
327500200528     C                   EXSR      *PSSR                                                      CDL099
327600200528     C                   ENDIF                                                                CDL099
327700200528                                                                                              CDL099
327800200528     C                   IF        PRTCD = *BLANKS                                            CDL099
327900200528     C                   EVAL      CDL099 = 'Y'                                               CDL099
328000200528     C                   ENDIF                                                                CDL099
328100200528     C/COPY OFCPYSRCZ,CDL091_014                                                              CDL091
328200200528      *
328300200528     C/COPY WNCPYSRC,FXH00019
328400200528      *  Set up the name of the MSGF from which the message handler will
328500200528      *   get the messages
328600200528     C                   EVAL      #MsgFile = 'DRSMM'
328700200528
328800200528      ** Program, module and procedure names for database error processing.
328900200528      ** =================================================================
329000200528      ** The following /COPY sets these values, and also defines LDA as
329100200528      ** an external data area
329200200528
329300200528      *  Hook to enable non-core initial processing to be included
329400200528      /COPY WNCPYSRC,FXFXDLV033
329500200528
329600200528     C                   ENDSR
329700200528      *****************************************************************
329800200528      /EJECT
329900200528      *****************************************************************
330000200528      * RESETERRS - Reset error information that is received back     *
330100200528      *    from each validation module.                               *
330200200528      *****************************************************************
330300200528
330400200528     C     RESETERRS     BEGSR
330500200528
330600200528     C                   EVAL      RetCodeOut = *Blanks
330700200528      *
330800200528      * Reset error & warning fields/message IDs/message data (arrays)
330900200528     C                   MOVEL     *BLANK        FldNamXAr
331000200528     C                   MOVEL     *BLANK        MsgIDXAr
331100200528     C                   MOVEL     *BLANK        MsgDtaXAr
331200200528     C                   MOVEL     *BLANK        WFldNmXAr
331300200528     C                   MOVEL     *BLANK        WMsgIDXAr
331400200528     C                   MOVEL     *BLANK        WMsgDtXAr
331500200528
331600200528     C                   ENDSR
331700200528      *****************************************************************
331800200528      /EJECT
331900200528      *****************************************************************
332000200528      * UPDATERRS - Update error information with that received back  *
332100200528      *    from each validation module.                               *
332200200528      *****************************************************************
332300200528
332400200528     C     UPDATERRS     BEGSR
332500200528      *
332600200528      * Update error fields/message IDs/message data (arrays)
332700200528      *
332800200528     C                   Z-ADD     1             I                 3 0
332900200528     C     *BLANK        LOOKUP    FldNameArr(I)                          99
333000200528     C     *IN99         IFEQ      '1'
333100200528     C                   MOVEA     FldNamXAr     FlDNameArr(I)
333200200528     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
333300200528     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
333400200528     C                   END
333500200528      *
333600200528      * Set Error Index
333700200528     C                   Z-ADD     1             I
333800200528     C     *BLANK        LOOKUP    FldNameArr(I)                          99
333900200528     C     I             SUB       1             Idx
334000200528      *
334100200528      * Update warning fields/message IDs/message data (arrays)
334200200528      *
334300200528     C                   Z-ADD     1             I
334400200528     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
334500200528     C     *IN99         IFEQ      '1'
334600200528     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
334700200528     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
334800200528     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
334900200528     C                   END
335000200528      *
335100200528      * Set Warning Index
335200200528     C                   Z-ADD     1             I
335300200528     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
335400200528     C     I             SUB       1             WIdx
335500200528      *
335600200528     C                   ENDSR
335700200528      *****************************************************************
335800200528      /EJECT
335900200528      *****************************************************************
336000200528      * #TERM - Termination processing.
336100200528      *****************************************************************
336200200528     C     #TERM         BEGSR
336300200528      *
336400200528      **  Terminate program
336500200528      *
336600200528     C                   MOVE      '1'           *INLR
336700200528      *
336800200528     C     *INU7         IFEQ      '1'
336900200528     C                   DUMP
337000200528     C                   END
337100200528      *
337200200528     C                   RETURN
337300200528      *
337400200528     C                   ENDSR
337500200528      *****************************************************************
337600200528      /EJECT
337700200528      ********************************************************************
337800200528     C/COPY ZACPYSRC,PSSR_ILE
337900200528      ********************************************************************
338000200528      /EJECT
338100200528**  CPY@
338200200528(c) Finastra International Limited 2001
338300200528** Scaling factors array - @SF
3384002005280000000001
3385002005280000000010
3386002005280000000100
3387002005280000001000
3388002005280000010000
3389002005280000100000
3390002005280001000000
3391002005280010000000
3392002005280100000000
3393002005281000000000
339400200528     X/COPY WNCPYSRC,FXFXDLVX01
