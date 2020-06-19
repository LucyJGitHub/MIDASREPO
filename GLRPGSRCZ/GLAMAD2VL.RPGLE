000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas GL Debit interest/overdraft dtls validation')    *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - General Ledger Module                                *
000900200528      *                                                               *
001000200528      *  GLAMAD2VL -  Debit Interest/Overdraft Details Validation     *
001100200528      *                                                               *
001200200528      *  (c) Finastra International Limited 2001                      *
001300200528      *                                                               *
001400200604      *  Last Amend No. 250822             Date 22May20               **
001500200604      *  Prev Amend No. 252664             Date 22May20               *
001600200604      *                 CER050             Date 16Jun19               *
001700200528      *                 MD053611           Date 19Aug19               *
001800200528      *                 MD046248           Date 27Oct17               *
001900200528      *                 MD047680           Date 08Sep17               *
002000200528      *                 MD046635           Date 10Aug17               *
002100200528      *                 MD020938           Date 19Jun13               *
002200200528      *                 CGL165             Date 17Feb15               *
002300200528      *                 MD029023           Date 21Nov14               *
002400200528      *                 CRE090             Date 14Feb14               *
002500200528      *                 MD024398           Date 11May14               *
002600200528      *                 MD000091           Date 07May13               *
002700200528      *                 AR947093A          Date 04May12               *
002800200528      *                 AR947093           Date 26Apr12               *
002900200528      *                 AR944106           Date 30Mar12               *
003000200528      *                 AR847249           Date 28Jan12               *
003100200528      *                 AR854615           Date 19Jan12               *
003200200528      *                 CSF011A            Date 28Nov11               *
003300200528      *                 CRE073             Date 06Dec10               *
003400200528      *                 CER055             Date 06Dec10               *
003500200528      *                 CRE075             Date 06Dec10               *
003600200528      *                 AR702741           Date 02Feb11               *
003700200528      *                 CER059             Date 19Jul10               *
003800200528      *                 BUG24157           Date 04Jun09               *
003900200528      *                 CER047             Date 19May08               *
004000200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
004100200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
004200200528      * Midas Plus 1.4 Base ------------------------------------------*
004300200528      * Midas Plus 1.3 ----------- Base ------------------------------*
004400200528      *                 CSD031             Date 10Apr06               *
004500200528      *                 CSD027             Date 09Dec05               *
004600200528      *                 BUG8550            Date 05Oct05               *
004700200528      *                 CAP086             Date 08Jun05               *
004800200528      *                 CSW037A            Date 02May05               *
004900200528      *                 CSD025             Date 11Jan05               *
005000200528      *                 CSW037             Date 15Dec04               *
005100200528      *                 CSW036             Date 15Dec04               *
005200200528      *                 CLE025             Date 20Oct03               *
005300200528      *                 CGL029             Date 01Sep03               *
005400200528      *                 208221             Date 11Dec02               *
005500200528      * Midas Release 4.01 -------------------------------------------*
005600200528      *                 CSC011             Date 18Sep01               *
005700200528      * Midas Release 4 --------------- Base -------------------------*
005800200528      *                 CDE002             Date 14Feb99               *
005900200528      * Midas DBA 3.05 -----------------------------------------------*
006000200528      *                 180721             Date 03May00               *
006100200528      *                 CUT009             Date 19Feb01               *
006200200528      * Midas DBA 3.02 -----------------------------------------------*
006300200528      *                 CFT004             Date 12Nov99               *
006400200528      *                 CPB001             Date 23Aug99               *
006500200528      *                 CAP035  *CREATE    Date 19Mar99               *
006600200528      *                                                               *
006700200528      *---------------------------------------------------------------*
006800200528      *                                                               *
006900200528      *  250822 - Used the day number from ToF and ensure that        *
007000200528      *           ZFREQB2 is called. Patterned fix after 210058.      *
007100200528      *  252664 - Do not set to blanks field DDNCID                   *
007200200528      *  CER050 - Annualised Percentage Rate (Recompile)              *
007300200528      *  MD053611 - Add validation when changing the interest         *
007400200528      *             calculation type.                                 *
007500200528      *  MD046248 - Finastra Rebranding                               *
007600200528      *  MD047680 - Prevent validation of authority to the account    *
007700200528      *             branch if branch value is blank                   *
007800200528      *  MD046635 - User permissions are not verified on account      *
007900200528      *             input via AMAD API. Change the validation so that *
008000200528      *             the user inserting an account is always validated *
008100200528      *             to have authority to the branch of the account.   *
008200200528      *  MD020938 - Create new system values to check the branch/user *
008300200528      *             authority.                                        *
008400200528      *  CGL165 - Dual Withholding Tax (Recompile)                    *
008500200528      *  MD029023 - Need to pass debit rate spread for validation of  *
008600200528      *             Additional O/D Rate                               *
008700200528      *  CRE090 - Delay Capitalisation of Interest                    *
008800200528      *  MD024398 - API Performance Optimisation                      *
008900200528      *  MD000091 - Event Codes Substitution                          *
009000200528      *  AR947093A - Base Rate amendment resulted to 0 interest rate  *
009100200528      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
009200200528      *  AR944106 - Incorrect spread as calculated by the system      *
009300200528      *  AR847249 - Negative interest is shown in the main list and   *
009400200528      *             Loan Details enquiry screen                       *
009500200528      *  AR854615 - Contractual spread indicator is always +          *
009600200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
009700200528      *            (Recompile)                                        *
009800200528      *  CRE073 - Interest Rate Rounding                              *
009900200528      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
010000200528      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
010100200528      *  AR702741 - Include location as parameter in ZFREQB to        *
010200200528      *             determine the next settlement date                *
010300200528      *             (Child: AR702742)                                 *
010400200528      *  CER059 - German Feature Upgrade to Delhi                     *
010500200528      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
010600200528      *             when field is set to Y (Recompile)                *
010700200528      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
010800200528      *           (Recompile)                                         *
010900200528      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
011000200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
011100200528      *  BUG8550 - Reposition capture of ZMUSER data area             *
011200200528      *  CAP086 - Introduce Auto Authorisation to the API's           *
011300200528      *           without it. (Recompile)                             *
011400200528      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
011500200528      *  CSD025 - Customer De-Activation                              *
011600200528      *  CSW037 - Additional Field Data on MT300/MT320                *
011700200528      *  CSW036 - Dual SWIFT BIC held on Client Details               *
011800200528      *  CLE025 - Credit Lines (Recompile)                            *
011900200528      *  CGL029 - Increase Account Code to 10 digits                  *
012000200528      *  208221 - Default Margin from Rate/Spread changes             *
012100200528      *  CSC011 - 24x7 Midas Availability                             *
012200200528      *  CDE002 - CCRM Revenue Analysis - Recompile only              *
012300200528      *  180721 - Default "Next Statement Date" when opening          *
012400200528      *           Account coming from interface                       *
012500200528      *         - Retail Account Number must be calculated            *
012600200528      *  CUT009 - Manual addition of core hooks.                      *
012700200528      *  CFT004 - Straight Through Processing Phase 2                 *
012800200528      *         - International Bank Account Numbers(Recompile Only)  *
012900200528      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
013000200528      *           Recompiled due to database changes                  *
013100200528      *  CAP035 - Midas/ToF Interface                                 *
013200200528      *                                                               *
013300200528      *****************************************************************
013400200528      ** +--------------------------------------+
013500200528      ** ¦ F-specs                              ¦
013600200528      ** ¦ =======                              ¦
013700200528      ** +--------------------------------------+
013800200528      *****************************************************************
013900200528     F/COPY WNCPYSRC,GLAMA2VF01
014000200528
014100200528      *****************************************************************
014200200528      ** +--------------------------------------+
014300200528      ** ¦ Automatically included D-specs       ¦
014400200528      ** ¦ ==============================       ¦
014500200528      ** +--------------------------------------+
014600200528      **
014700200528      ** Standard D-specs
014800200528      ** ================
014900200528      **
015000200528      ** The following /COPY line includes the LDA layout,
015100200528      ** the copyright array definition,
015200200528      ** and the following named constants:
015300200528      **    True       logical = *on (for indcator processing)
015400200528      **    False      logical = *off (for indcator processing)
015500200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
015600200528      **                                    handler)
015700200528      ** and the following variables:
015800200528      **    RunBefore  1A (for the PSSR)
015900200528
016000200528     D/COPY ZACPYSRC,STD_D_SPEC
016100200528
016200200528      ** Program Status Data Structure
016300200528      ** =============================
016400200528      ** The following /COPY line includes all the defined fields in the
016500200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
016600200528
016700200528     D/COPY ZACPYSRC,PSDS
016800200528      ** The following /COPY line includes definitions for the above fields
016900200528      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
017000200528      ** corresponding fields in the PSDS /COPY member, so that member
017100200528      ** must be included where this one is used.
017200200528
017300200528     D/COPY ZACPYSRC,PROCPARMS
017400200528
017500200528      **--------------------------------------------------------------------------------------------
017600200528      ** The following /COPY line includes the definitions for error and
017700200528      ** warning message arrays.
017800200528     D/COPY ZACPYSRC,ERR_ARRAYS
017900200528      **--------------------------------------------------------------------------------------------
018000200528
018100200528      ** +--------------------------------------+
018200200528      ** ¦ End of automatically included D-specs¦
018300200528      ** ¦ =====================================¦
018400200528      ** +--------------------------------------+
018500200528
018600200528      *****************************************************************
018700200528      /EJECT
018800200528      *****************************************************************
018900200528
019000200528      ** +--------------------------------------+
019100200528      ** ¦ Manually included D-specs            ¦
019200200528      ** ¦ =========================            ¦
019300200528      ** +--------------------------------------+
019400200528
019500200528      ** +--------------------------------------+
019600200528      ** ¦ Named constants                      ¦
019700200528      ** ¦ ===============                      ¦
019800200528      ** +--------------------------------------+
019900200528
020000200528      ** The maximum size of the appended error arrays
020100200528     D XArrayMax       C                   CONST(20)
020200200528
020300200528      ** +--------------------------------------+
020400200528      ** ¦ Arrays and Data Structures           ¦
020500200528      ** ¦ ==========================           ¦
020600200528      ** +--------------------------------------+
020700200528
020800200528      ** Array of Fields in error.
020900200528     D FldNamXAr       S             10A   DIM(XArrayMax)
021000200528
021100200528      ** Array of error message IDs
021200200528     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
021300200528
021400200528      ** Array of error message data.
021500200528     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
021600200528
021700200528      ** Array of Fields with warnings.                                                       CER055
021800200528     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     CER055
021900200528                                                                                              CER055
022000200528      ** Array of warning message IDs                                                         CER055
022100200528     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        CER055
022200200528                                                                                              CER055
022300200528      ** Array of warning message data.                                                       CER055
022400200528     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                      CER055
022500200528                                                                                              CER055
022600200528      ** Flags to indicate whether transaction fields are valid
022700200528     D OKFlagsDS       DS
022800200528     D  DDDRIBOK                      1A
022900200528     D  DDDRISOK                      1A
023000200528     D  DDDSIGOK                      1A
023100200528     D  DDDICTOK                      1A
023200200528     D  DDDCSTOK                      1A
023300200528     D  DDDRCDOK                      1A
023400200528     D  DDDRICOK                      1A
023500200528     D  DDNDIDOK                      1A
023600200528     D  DDDRIFOK                      1A
023700200528     D  DDDNCDOK                      1A
023800200528     D  DDDRBROK                      1A
023900200528     D  DDDACPOK                      1A
024000200528     D  DDODLNOK                      1A
024100200528     D  DDODSCOK                      1A
024200200528     D  DDITRDOK                      1A
024300200528     D  DDOLVDOK                      1A
024400200528     D  DDODEDOK                      1A
024500200528     D  DDAODROK                      1A
024600200528     D  DDAODRXOK                     1A
024700200528     D  DDORTCOK                      1A
024800200528     D  DDDCSPOK                      1A                                                      CRE073
024900200528     D  DDDCSGOK                      1A                                                      CRE073
025000200528     D  DDDRMTOK                      1A                                                      CRE073
025100200528     D  DDDRFDOK                      1A                                                      CRE073
025200200528
025300200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
025400200528      ** EXTERNAL DS FOR BANK DETAILS
025500200528                                                                                180721
025600200528     D SDGELR        E DS                  EXTNAME(SDGELRPD)                    180721
025700200528      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS                                 180721
025800200528
025900200528     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
026000200528      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
026100200528
026200200528     D SDRETL        E DS                  EXTNAME(SDRETLPD)
026300200528     D SDRETLACCD    E                     EXTFLD(QQACCD)                                     CGL029
026400200528      ** EXTERNAL DS FOR RETAIL DETAILS
026500200528
026600200528     D SDCURR        E DS                  EXTNAME(SDCURRPD)
026700200528      ** EXTERNAL DS FOR CURRENCY DETAILS
026800200528
026900200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)
027000200528      ** EXTERNAL DS FOR SAR DETAILS
027100200528                                                                                180721
027200200528     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    180721
027300200528      ** EXTERNAL DS FOR CUSTOMER DETAILS                                       180721
027400200528
027500200528     D DSFDY         E DS                  EXTNAME(DSFDY)
027600200528      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
027700200528
027800200528     D DSSDY         E DS                  EXTNAME(DSSDY)
027900200528      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
028000200528                                                                                180721
028100200528     DDSLDY          E DS                  EXTNAME(DSLDY)                       180721
028200200528      ** THIRD DS FOR ACCESS PROGRAMS, VERY LONG DATA STRUCTURE                 180721
028300200528
028400200528     D ValidAccn     E DS                  EXTNAME(GLVAMADPD)
028500200528      * Valid Account layout -> ACCNTAB
028600200528
028700200528     D ValidExBX     E DS                  EXTNAME(GLVAMBXPD)
028800200528     D GLBXACOD      E                     EXTFLD(QQACOD)                                     CGL029
028900200528      * Valid Extn. Account layout -> ACCNTBXC
029000200528
029100200528     D ValidExRI     E DS                  EXTNAME(GLVAMRIPD)
029200200528     D GLRIACOD      E                     EXTFLD(QQACOD)                                     CGL029
029300200528      * Valid Extn. Account layout -> REIACD
029400200528                                                                                              208221
029500200528     D TranIn4       E DS                  EXTNAME(GLAMCOPD)                                  208221
029600200528      * Incoming Transaction (screen 4)                                                       208221
029700200528
029800200528     D TranIn2       E DS                  EXTNAME(GLAMDIPD)
029900200528      * Incoming Transaction (screen 2)
030000200528
030100200528     D TranIn1       E DS                  EXTNAME(GLAMADPD)
030200200528      * Incoming Transaction (screen 1)
030300200528
030400200528     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
030500200528      ** 24X7 status data area                                                                CSC011
030600200528                                                                                              CSC011
030700200528     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
030800200528      ** SD data area                                                                         CSC011
030900200528                                                                                              CSC011
031000200528     D ZMUSER          DS            17
031100200528      * ZMUSER data layout
031200200528     D  DBRN                  11     13
031300200528
031400200528      ** +--------------------------------------+
031500200528      ** ¦ Declared variables                   ¦
031600200528      ** ¦ ==================                   ¦
031700200528      ** +--------------------------------------+
031800200528
031900200528      **                                                                                    MD000091
032000200528     D BChar           DS                                                                   MD000091
032100200528     D   BLen                  1      2B 0                                                  MD000091
032200200528     D   LenStr                1      2                                                     MD000091
032300200528     D   MsgDtaTmp                   99                                                     MD000091
032400200528                                                                                            MD000091
032500200528      ** Index for arrays of of error message ids etc
032600200528     D Idx             S              3P 0
032700200528     D WIx             S              3P 0                                                    CER055
032800200528     D Indx            S              3P 0                                                    CRE073
032900200528
033000200528      ** Fields defined for Enhancement CSC011                                                CSC011
033100200528     D CSC011          S              1A                                                      CSC011
033200200528     D PRtCd           S              7A                                                      CSC011
033300200528     D POptn           S              7A                                                      CSC011
033400200528     D PSard           S              6A                                                      CSC011
033500200528     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
033600200528                                                                                              CSC011
033700200528      ** CER055 Overdraft Processing Flag                                                     CER055
033800200528     D CER055          S              1A                                                      CER055
033900200528                                                                                              CER055
034000200528     D CRE073          S              1A   INZ('N')                                           CRE073
034100200528     D TMCNSP          S             11P 7                                                    CRE073
034200200528     D NEWSRT          S             11P 7                                                    CRE073
034300200528     D WSPREAD         S             11P 7                                                    CRE073
034400200528     D NEWFRT          S             11P 7                                                  AR847249
034500200528     D PModule         S              6A                                                      CRE073
034600200528     D PCurset         S              2P 0                                                    CRE073
034700200528     D CRE090          S              1A   INZ('N')                                           CRE090
034800200528      ** Constant paramater for AOSVALR0                                                    MD020938
034900200528     D BRCUSR          C                   CONST('CheckBrchUserAuthori')                    MD020938
035000200528     D CurSysVal       DS           200                                                     MD020938
035100200528     D CurVal                  1      1                                                     MD020938
035200200528      ** +--------------------------------------+
035300200528      ** ¦ End of D-specs                       ¦
035400200528      ** ¦ ==============                       ¦
035500200528      ** +--------------------------------------+
035600200528
035700200528      ** +----------------------------------------+
035800200528      ** ¦ Hook for non-core D-specs (all types)  ¦
035900200528      ** ¦ also any I-specs (if necessary)        ¦
036000200528      ** ¦ =====================================  ¦
036100200528      ** +----------------------------------------+
036200200528
036300200528      *****************************************************************
036400200528      /EJECT
036500200528      ** +--- Start of Main processing -----------------------------------+
036600200528      ** ¦                                                                ¦
036700200528      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
036800200528      ** ¦ executed at program activation.                                ¦
036900200528      ** ¦                                                                ¦
037000200528      ** +----------------------------------------------------------------+
037100200528                                                                                             BUG8550
037200200528      **  GET ZMUSER to access default branch.                                               BUG8550
037300200528                                                                                             BUG8550
037400200528     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
037500200528     C                   IN        ZMUSER                                                    BUG8550
037600200528     C                   UNLOCK    ZMUSER                                                    BUG8550
037700200528
037800200528     C                   Z-Add     0             WWDBRT           11 7
037900200528     C                   Z-ADD     0             WWBRTT           11 7                      AR944106
038000200528     C                   Move      DDDRCD        WWDRCD            6
038100200528      *
038200200528     C                   Move      *Off          WIN44             1
038300200528     C     RINOALT       IfGT      0
038400200528     C                   Move      *On           WIN44
038500200528     C                   Endif
038600200528      *
038700200528      ** Access Currency details via access program
038800200528      *  (database error handling done in access program)
038900200528     C                   CALLB     'AOCURRR0'
039000200528     C                   PARM      '*DBERR '     @RTCD
039100200528     C                   PARM      '*KEY   '     @OPTN
039200200528     C                   PARM      DDCCY         @CCY              3
039300200528     C     SDCURR        PARM      SDCURR        DSSDY
039400200528
039500200528      * Call Validation Modules in Sequence
039600200528
039700200528      ** Validate Base Rate Type
039800200528      /COPY WNCPYSRC,GLAMAD2V01                                                               CUT009
039900200528     C                   EXSR      VBRATE
040000200528      *                                                                                       CRE073
040100200528     C                   IF        CRE073 = 'Y'                                               CRE073
040200200528                                                                                              CRE073
040300200528     C                   EVAL      PModule = 'AMADDr'                                         CRE073
040400200528                                                                                              CRE073
040500200528      ** Validate Contractual Spread/Sign                                                     CRE073
040600200528                                                                                              CRE073
040700200528     C                   EXSR      SRSPSG                                                     CRE073
040800200528                                                                                              CRE073
040900200528      ** Validate Rounding Method                                                             CRE073
041000200528                                                                                              CRE073
041100200528     C                   IF        DDDCSPOK <> 'N'                                            CRE073
041200200528     C                   EXSR      SRRNDM                                                     CRE073
041300200528                                                                                              CRE073
041400200528      ** Validate Rounding Fraction/Decimal                                                   CRE073
041500200528                                                                                              CRE073
041600200528     C                   EXSR      SRRNDF                                                     CRE073
041700200528                                                                                              CRE073
041800200528      ** If all interest rate rounding related fields are valid                               CRE073
041900200528      ** compute for the new spread rate                                                      CRE073
042000200528                                                                                              CRE073
042100200528     C                   IF        DDDCSPOK <> 'N' AND                                        CRE073
042200200528     C                             DDDCSGOK <> 'N' AND                                        CRE073
042300200528     C                             DDDRMTOK <> 'N' AND                                        CRE073
042400200528     C                             DDDRFDOK <> 'N'                                            CRE073
042500200528     C                   EXSR      SRSPRT                                                     CRE073
042600200528                                                                                              CRE073
042700200528     C                   ENDIF                                                                CRE073
042800200528     C                   ENDIF                                                                CRE073
042900200528      *                                                                                       CRE073
043000200528      /COPY WNCPYSRC,GLAMAD2V02                                                               CUT009
043100200528      ** Validate Rate/Spread & Sign
043200200528      /COPY WNCPYSRC,GLAMAD2V03                                                               CUT009
043300200528     C                   ELSE                                                                 CRE073
043400200528     C                   EXSR      VSRATE
043500200528     C                   ENDIF                                                                CRE073
043600200528      *                                                                                       CRE073
043700200528      /COPY WNCPYSRC,GLAMAD2V04                                                               CUT009
043800200528      ** Validate Interest Calc. Type/Subtype
043900200528      /COPY WNCPYSRC,GLAMAD2V05                                                               CUT009
044000200528     C                   EXSR      VICALC
044100200528      /COPY WNCPYSRC,GLAMAD2V06                                                               CUT009
044200200528      ** Validate This Change Value Date
044300200528      /COPY WNCPYSRC,GLAMAD2V07                                                               CUT009
044400200528     C**********         IF        CRE015 = 'N' OR                                AR947093 AR947093A
044500200528     C**********                   X5ATTY <>'P'                                   AR947093 AR947093A
044600200528     C                   EXSR      VCVDAT
044700200528     C**********         ENDIF                                                    AR947093 AR947093A
044800200528      /COPY WNCPYSRC,GLAMAD2V08                                                               CUT009
044900200528      ** Validate Calculation Basis
045000200528      /COPY WNCPYSRC,GLAMAD2V09                                                               CUT009
045100200528     C                   EXSR      VICALB
045200200528      /COPY WNCPYSRC,GLAMAD2V10                                                               CUT009
045300200528      ** Validate Next Capitalisation Date, Frequency & Day no.
045400200528      /COPY WNCPYSRC,GLAMAD2V11                                                               CUT009
045500200528     C                   EXSR      VNXCAP
045600200528      /COPY WNCPYSRC,GLAMAD2V12                                                               CUT009
045700200528      ** Validate Alternate A/C Dr. Interest Branch and Account
045800200528      /COPY WNCPYSRC,GLAMAD2V13                                                               CUT009
045900200528     C                   EXSR      VBRACP
046000200528      /COPY WNCPYSRC,GLAMAD2V14                                                               CUT009
046100200528      ** Validate Overdraft
046200200528      /COPY WNCPYSRC,GLAMAD2V15                                                               CUT009
046300200528     C                   EXSR      VOVRDRFT
046400200528      /COPY WNCPYSRC,GLAMAD2V16                                                               CUT009
046500200528      *
046600200528      *
046700200528      *  *-------------------------------------------------------*
046800200528      *  * If no errors set up outstanding fields for valid file *
046900200528      *  *-------------------------------------------------------*
047000200528
047100200528     C                   IF        Idx = 0
047200200528     C                   EXSR      SetupValid
047300200528     C                   Else
047400200528     C                   Move      WWDRCD        DDDRCD
047500200528     C                   ENDIF
047600200528      *
047700200528      * RETURN
047800200528      *
047900200528     C                   RETURN
048000200528      *****************************************************************
048100200528     C/EJECT
048200200528      *****************************************************************
048300200528      ** VBRATE - Validate Base Rate Type
048400200528      *****************************************************************
048500200528     C     VBRATE        BEGSR
048600200528
048700200528      * Reset variables updated by each module
048800200528
048900200528     C                   EXSR      RESETERRS
049000200528      *
049100200528     C                   CALLB     'GLVDBBS'
049200200528      *
049300200528      * INPUTS
049400200528      *
049500200528      ** Return Code
049600200528     C                   PARM                    RetCodeOut
049700200528      *
049800200528      ** Account Screen fields
049900200528     C                   Parm                    DDDRIB
050000200528     C                   Parm                    DDCCY
050100200528     C                   Parm                    DDDACO
050200200528     C                   Parm                    DDDICT
050300200528     C                   Parm                    DDDCST
050400200528     C                   Parm                    DDDRIS                         180721
050500200528      *
050600200528      ** ICD
050700200528     C                   Parm                    BJDFIN
050800200528      *                                                                         180721
050900200528      ** Supplemental Validation for PB Customer (Y/N)                          180721
051000200528     C                   Parm                    WValforPB                      180721
051100200528      *
051200200528      * OUTPUTS
051300200528      *
051400200528      * Error fields/message IDs/message data (arrays) from/to caller
051500200528     C                   PARM                    FldNamXAr
051600200528     C                   PARM                    MsgIDXAr
051700200528     C                   PARM                    MsgDtaXAr
051800200528      *
051900200528     C                   Parm                    WWVDRC            5 0
052000200528     C                   Parm                    WWDBRT
052100200528     C                   PARM                    WWBRTT                                     AR944106
052200200528      *
052300200528      ** Base Rate Type - OK
052400200528     C                   Parm                    DDDRIBOk
052500200528
052600200528      * Update error info with that returned from the validation module
052700200528
052800200528     C                   EXSR      UPDATERRS
052900200528      *
053000200528     C                   ENDSR
053100200528      *****************************************************************
053200200528     C/EJECT
053300200528      *****************************************************************
053400200528      *  VSRATE - Validate Rate/Spread & Sign
053500200528      *****************************************************************
053600200528     C     VSRATE        BEGSR
053700200528
053800200528      * Reset variables updated by each module
053900200528
054000200528     C                   EXSR      RESETERRS
054100200528      *
054200200528     C                   CALLB     'GLVDBRT'
054300200528      *
054400200528      * INPUTS
054500200528      *
054600200528      ** Return Code
054700200528     C                   PARM                    RetCodeOut
054800200528      *
054900200528      ** Account Screen fields
055000200528     C                   Parm                    DDDRIS
055100200528     C                   Parm                    DDDSIG
055200200528     C                   Parm                    DDDICT
055300200528     C                   Parm                    DDDCST
055400200528      *
055500200528      * OUTPUTS
055600200528      *
055700200528      * Error fields/message IDs/message data (arrays) from/to caller
055800200528     C                   PARM                    FldNamXAr
055900200528     C                   PARM                    MsgIDXAr
056000200528     C                   PARM                    MsgDtaXAr
056100200528      *
056200200528     C                   Parm      *ZERO         WNDRIS           11 7
056300200528      *
056400200528      ** Rate/Spread - OK
056500200528      ** Rate/Spread Sign - OK
056600200528     C                   Parm                    DDDRISOk
056700200528     C                   Parm                    DDDSIGOk
056800200528
056900200528      * Update error info with that returned from the validation module
057000200528
057100200528     C                   EXSR      UPDATERRS
057200200528      *
057300200528     C                   ENDSR
057400200528      *****************************************************************
057500200528     C/EJECT
057600200528      *****************************************************************
057700200528      ** VICALC - Validate Interest Calc. Type/Subtype
057800200528      *****************************************************************
057900200528     C     VICALC        BEGSR
058000200528
058100200528      * Reset variables updated by each module
058200200528
058300200528     C                   EXSR      RESETERRS
058400200528      *
058500200528     C                   CALLB     'GLVDBIT02'
058600200528      *
058700200528      * INPUTS
058800200528      *
058900200528      ** Return Code
059000200528     C                   PARM                    RetCodeOut
059100200528      *
059200200528      ** Account Screen fields
059300200528     C                   Parm                    DDDICT
059400200528     C                   Parm                    DDDCST
059500200528     C                   Parm                    DDDRIB
059600200528     C                   Parm                    DDDRIS
059700200528     C                   Parm                    DDDSIG
059800200528     C                   Parm                    DDCCY
059900200528     C                   PARM                    DDCUSN                                     MD053611
060000200528     C                   PARM                    DDACOD                                     MD053611
060100200528     C                   PARM                    DDBRCA                                     MD053611
060200200528     C                   PARM                    DDACSQ                                     MD053611
060300200528      *
060400200528     C                   Parm                    WWVDRC
060500200528     C                   Parm                    WWDBRT
060600200528      *
060700200528      * OUTPUTS
060800200528      *
060900200528      * Error fields/message IDs/message data (arrays) from/to caller
061000200528     C                   PARM                    FldNamXAr
061100200528     C                   PARM                    MsgIDXAr
061200200528     C                   PARM                    MsgDtaXAr
061300200528      * Warning fields/message IDs/message data (arrays) from/to caller                     MD053611
061400200528     C                   PARM                    WFldNmXAr                                  MD053611
061500200528     C                   PARM                    WMsgIDXAr                                  MD053611
061600200528     C                   PARM                    WMsgDtXAr                                  MD053611
061700200528      *
061800200528      ** Interest Calc. Type - Ok
061900200528      ** Interest Calc. Subtype - Ok
062000200528     C                   Parm                    DDDICTOk
062100200528     C                   Parm                    DDDCSTOk
062200200528      *
062300200528
062400200528      * Update error info with that returned from the validation module
062500200528
062600200528     C                   EXSR      UPDATERRS
062700200528      *
062800200528     C                   ENDSR
062900200528      *****************************************************************
063000200528     C/EJECT
063100200528      *****************************************************************
063200200528      *  VCVDAT - Validate This Change Value Date
063300200528      *****************************************************************
063400200528     C     VCVDAT        BEGSR
063500200528
063600200528      * Reset variables updated by each module
063700200528
063800200528     C                   EXSR      RESETERRS
063900200528                                                                                180721
064000200528     C     WValforPB     Ifeq      'Y'                                          180721
064100200528     C     DDDRCD        Andeq     *Blanks                                      180721
064200200528     C     DDACTN        Andeq     'I'                                          180721
064300200528     C     WWID          Andeq     'TO'                                         180721
0644002005283676  *                                                                         180721
0645002005283677  **   Convert Day Number to Date                                           180721
0646002005283678 C                   Callb     'ZDATE2'                                     180721
064700200528     C**********         parm      BJRDNB        ZDAYNO                                180721 CSC011
064800200528     C                   PARM      WRunDay       ZDAYNO                                       CSC011
064900200528     C                   parm                    BJDFIN                         180721
065000200528     C                   parm                    ZNDATE            6 0          180721
065100200528     C                   parm                    ZADATE            7            180721
065200200528                                                                                180721
065300200528     C                   movel     ZNDATE        DDDRCD                         180721
065400200528     C                   Endif                                                  180721
065500200528      *
065600200528     C                   CALLB     'GLVDBDT'
065700200528      *
065800200528      * INPUTS
065900200528      *
066000200528      ** Return Code
066100200528     C                   PARM                    RetCodeOut
066200200528      *
066300200528      ** Account Screen fields
066400200528     C                   Parm                    DDDRCD
066500200528     C                   Parm                    DDACTN
066600200528     C                   Parm                    DDDRIB
066700200528     C                   Parm                    WNDRIS
066800200528     C                   Parm                    DDDICT
066900200528     C                   Parm                    DDDCST
067000200528     C                   Parm                    DDDACO
067100200528      *
067200200528     C                   Parm                    WWVDRC
067300200528      *
067400200528     C                   Parm                    AMDRIB
067500200528     C                   Parm                    AMDRIS
067600200528     C                   Parm                    AMOLDR
067700200528     C                   Parm                    RIDICT
067800200528     C                   Parm                    RIDCST
067900200528      *
068000200528      ** ICD
068100200528     C**********         Parm                    BJRDNB                                       CSC011
068200200528     C                   PARM                    WRunDay                                      CSC011
068300200528     C                   Parm                    BJDFIN
068400200528     C                   Parm                    WWBKVD
068500200528      * Front Office ID                                                         180721
068600200528     C**********         PARM                    APFOTranID                            180721 CGL029
068700200528     C                   PARM                    APFOTran40                                   CGL029
068800200528      *
068900200528      * OUTPUTS
069000200528      *
069100200528      * Error fields/message IDs/message data (arrays) from/to caller
069200200528     C                   PARM                    FldNamXAr
069300200528     C                   PARM                    MsgIDXAr
069400200528     C                   PARM                    MsgDtaXAr
069500200528      *
069600200528     C                   Parm      *ZERO         WNDRCD            5 0
069700200528      *
069800200528      ** This Change Value Date - Ok
069900200528     C                   Parm                    DDDRCDOk
070000200528
070100200528      * Update error info with that returned from the validation module
070200200528
070300200528     C                   EXSR      UPDATERRS
070400200528      *
070500200528     C                   ENDSR
070600200528      *****************************************************************
070700200528     C/EJECT
070800200528      *****************************************************************
070900200528      ** VICALB - Validate Calculation Basis
071000200528      *****************************************************************
071100200528     C     VICALB        BEGSR
071200200528
071300200528      * Reset variables updated by each module
071400200528
071500200528     C                   EXSR      RESETERRS
071600200528      *
071700200528     C                   CALLB     'GLVDBCC'
071800200528      *
071900200528      * INPUTS
072000200528      *
072100200528      ** Return Code
072200200528     C                   Parm                    RetCodeOut
072300200528      *
072400200528      ** Account Screen fields
072500200528     C                   Parm                    DDDRIC
072600200528     C                   Parm                    DDDRIB
072700200528     C                   Parm                    DDDRIS
072800200528     C                   Parm                    DDDSIG
072900200528     C                   Parm                    DDDICT
073000200528     C                   Parm                    DDDCST
073100200528      *
073200200528      ** Standing Data
073300200528     C                   PARM                    A6DICB
073400200528      *
073500200528      * OUTPUTS
073600200528      *
073700200528      * Error fields/message IDs/message data (arrays) from/to caller
073800200528     C                   PARM                    FldNamXAr
073900200528     C                   PARM                    MsgIDXAr
074000200528     C                   PARM                    MsgDtaXAr
074100200528      *
074200200528      ** Calculation Basis - OK
074300200528     C                   Parm                    DDDRICOk
074400200528
074500200528      * Update error info with that returned from the validation module
074600200528
074700200528     C                   EXSR      UPDATERRS
074800200528      *
074900200528     C                   ENDSR
075000200528      *****************************************************************
075100200528     C/EJECT
075200200528      *****************************************************************
075300200528      ** VNXCAP - Validate Next Capital. Date, Frequency & Day no
075400200528      *****************************************************************
075500200528     C     VNXCAP        BEGSR
075600200528     C**********         Eval      DDNDID = *blank                                     250822 252664
075700200528
075800200528      * Reset variables updated by each module
075900200528
076000200528     C                   EXSR      RESETERRS
076100200528                                                                                180721
076200200528     C     WValforPB     Ifeq      'Y'                                          180721
076300200528     C     DDNDID        Andeq     *Blanks                                      180721
076400200528                                                                                180721
076500200528     C*****DDDRIF        Ifeq      'D'                                                 180721 250822
076600200528     C     DDDRIF        Ifne      'D'                                                        250822
076700200528     C                   Movel     DDDNCD        ZMDAY                          180721
076800200528     C                   Else                                                   180721
076900200528     C                   Z-add     *zeros        ZMDAY                          180721
077000200528     C                   Endif                                                  180721
077100200528                                                                                180721
077200200528     C**********         CallB     'ZFREQB'                                            180721 250822
077300200528     C                   CallB     'ZFREQB2'                                                  250822
077400200528     C                   Parm      *blanks       RetCodeIn                      180721
077500200528     C                   Parm      DDDRIF        ZFREQ             1            180721
077600200528     C**********         Parm      BJRDNB        ZDAYNO            5 0                 180721 CSC011
077700200528     C                   PARM      WRunDay       ZDAYNO            5 0                        CSC011
077800200528     C                   Parm      DDCcy         ZCCY              3            180721
077900200528     C                   Parm      *BLANKS       ZLOC              3                        AR702741
078000200528     C                   Parm                    ZMDAY             2 0          180721
078100200528     C                   Parm                    BJDFIN                         180721
078200200528     C                   Parm      SDGELR        SDGELR                         180721
078300200528                                                                                180721
078400200528     C     RetCodeIn     Ifeq      *blanks                                      180721
078500200528     C     ZdayNo        Andne     *zeros                                       180721
0786002005283676  *                                                                         180721
0787002005283677  **   Convert Day Number to Date                                           180721
0788002005283678 C                   Callb     'ZDATE2'                                     180721
078900200528     C                   parm                    ZDAYNO                         180721
079000200528     C                   parm                    BJDFIN                         180721
079100200528     C                   parm                    ZNDATE            6 0          180721
079200200528     C                   parm                    ZADATE            7            180721
079300200528                                                                                180721
079400200528     C                   movel     ZNDATE        DDNDID                         180721
079500200528     C                   Endif                                                  180721
079600200528                                                                                180721
079700200528     C                   Move      *blanks       RetCodeIn                      180721
079800200528     C                   Endif                                                  180721
079900200528      *
080000200528     C                   CALLB     'GLVDBFQ'
080100200528      *
080200200528      * INPUTS
080300200528      *
080400200528      ** Return Code
080500200528     C                   Parm                    RetCodeOut
080600200528      *
080700200528      ** Account Screen fields
080800200528     C                   Parm                    DDNDID
080900200528     C                   Parm                    DDDRIF
081000200528     C                   Parm                    DDDNCD
081100200528     C                   Parm                    DDDRIB
081200200528     C                   Parm                    DDDRIS
081300200528     C                   Parm                    DDDSIG
081400200528     C                   Parm                    DDDICT
081500200528     C                   Parm                    DDDCST
081600200528     C                   Parm                    DDDACO
081700200528      *
081800200528      ** ICD
081900200528     C**********         Parm                    BJRDNB                                       CSC011
082000200528     C                   PARM                    WRunDay                                      CSC011
082100200528     C                   Parm                    BJDFIN
082200200528     C                   Parm                    BMLDAI
082300200528     C                   PARM                    CRE090                                       CRE090
082400200528     C/COPY WNCPYSRC,GLAMA2VC01
082500200528      *
082600200528      * OUTPUTS
082700200528      *
082800200528      * Error fields/message IDs/message data (arrays) from/to caller
082900200528     C                   PARM                    FldNamXAr
083000200528     C                   PARM                    MsgIDXAr
083100200528     C                   PARM                    MsgDtaXAr
083200200528      *
083300200528     C                   Parm      *ZERO         WNNDID            5 0
083400200528     C                   Parm      *ZERO         WNDRDY            2 0
083500200528      *
083600200528      ** Next Capitalisation Date - Ok
083700200528      ** Next Capitalisation Freq - Ok
083800200528      ** Next Capitalisation Day  - Ok
083900200528     C                   Parm                    DDNDIDOk
084000200528     C                   Parm                    DDDRIFOk
084100200528     C                   Parm                    DDDNCDOk
084200200528     C/COPY WNCPYSRC,GLAMA2VC02
084300200528
084400200528      * Update error info with that returned from the validation module
084500200528
084600200528     C                   EXSR      UPDATERRS
084700200528      *
084800200528     C                   ENDSR
084900200528      *****************************************************************
085000200528     C/EJECT
085100200528      *****************************************************************
085200200528      ** VBRACP - Validate Alternate A/C Dr. Interest Branch
085300200528      *****************************************************************
085400200528     C     VBRACP        BEGSR
085500200528
085600200528      * Reset variables updated by each module
085700200528
085800200528     C                   EXSR      RESETERRS
085900200528      *
086000200528     C                   CALLB     'GLVDBAL'
086100200528      *
086200200528      * INPUTS
086300200528      *
086400200528      ** Return Code
086500200528     C                   Parm                    RetCodeOut
086600200528      *
086700200528      ** Account Screen fields
086800200528     C                   Parm                    DDDRBR
086900200528     C                   Parm                    DDDACP
087000200528     C                   Parm                    DDDRIB
087100200528     C                   Parm                    DDDSIG
087200200528     C                   Parm                    DDACNO
087300200528     C                   Parm                    DDBRCA
087400200528     C                   Parm                    DDACTN
087500200528     C                   Parm                    DDCUSN
087600200528     C                   Parm                    DDCCY
087700200528     C                   Parm                    DDACOD
087800200528     C                   Parm                    DDACSQ
087900200528      *
088000200528     C                   Parm                    WIN44
088100200528      *
088200200528      ** ICD
088300200528     C                   Parm                    DBRN
088400200528      *
088500200528      * OUTPUTS
088600200528      *
088700200528      * Error fields/message IDs/message data (arrays) from/to caller
088800200528     C                   PARM                    FldNamXAr
088900200528     C                   PARM                    MsgIDXAr
089000200528     C                   PARM                    MsgDtaXAr
089100200528      *
089200200528      ** Alternate Account Branch - Ok
089300200528      ** Alternate Account - Ok
089400200528      ** Rate Spread Sign - Ok
089500200528     C                   Parm                    DDDRBROk
089600200528     C                   Parm                    DDDACPOk
089700200528     C                   Parm                    DDDSIGOk
089800200528
089900200528      * Update error info with that returned from the validation module
090000200528
090100200528     C                   EXSR      UPDATERRS
090200200528                                                                                            MD046635
090300200528     C                   IF        DDDRBROk = 'Y' AND                                       MD046635
090400200528     C                             DDDACPOk = 'Y' AND                                       MD046635
090500200528     C                             DDDSIGOk = 'Y' AND                                       MD046635
090600200528     C**********                   CurVal   = 'Y'                                  MD046635 MD047680
090700200528     C                             CurVal   = 'Y' AND                                       MD047680
090800200528     C                             DDDRBR <> *BLANKS                                        MD047680
090900200528                                                                                            MD046635
091000200528     C                   EXSR      RESETERRS                                                MD046635
091100200528                                                                                            MD046635
091200200528     C                   MOVE      DDACTN        ZACTN                                      MD046635
091300200528     C                   CALL      'ZVACTBU'                                                MD046635
091400200528     C                   PARM                    ZACTN             1                        MD046635
091500200528     C                   PARM      DDDRBR        ZBR               3                        MD046635
091600200528     C                   PARM                    ERR               1 0                      MD046635
091700200528      *                                                                                     MD046635
091800200528      **   If action invalid for user                                                       MD046635
091900200528      *                                                                                     MD046635
092000200528     C     ERR           IFEQ      1                                                        MD046635
092100200528     C                   Z-ADD     1             I                                          MD046635
092200200528     C                   MOVEL     'DDDRBR'      FldNamXAr(I)                               MD046635
092300200528     C                   MOVEL     'RE71070'     MsgIDXAr(I)                                MD046635
092400200528     C                   ENDIF                                                              MD046635
092500200528      *                                                                                     MD046635
092600200528     C     ERR           IFEQ      2                                                        MD046635
092700200528     C                   Z-ADD     1             I                                          MD046635
092800200528     C     DDACTN        IFEQ      'I'                                                      MD046635
092900200528     C                   MOVEL     'DDDRBR'      FldNamXAr(I)                               MD046635
093000200528     C                   MOVEL     'RE7102B'     MsgIDXAr(I)                                MD046635
093100200528     C                   ENDIF                                                              MD046635
093200200528     C     DDACTN        IFEQ      'A'                                                      MD046635
093300200528     C                   MOVEL     'DDDRBR'      FldNamXAr(I)                               MD046635
093400200528     C                   MOVEL     'RE7103B'     MsgIDXAr(I)                                MD046635
093500200528     C                   ENDIF                                                              MD046635
093600200528     C     DDACTN        IFEQ      'D'                                                      MD046635
093700200528     C                   MOVEL     'DDDRBR'      FldNamXAr(I)                               MD046635
093800200528     C                   MOVEL     'RE7104B'     MsgIDXAr(I)                                MD046635
093900200528     C                   ENDIF                                                              MD046635
094000200528     C                   ENDIF                                                              MD046635
094100200528      *                                                                                     MD046635
094200200528     C     ERR           IFEQ      1                                                        MD046635
094300200528     C     ERR           OREQ      2                                                        MD046635
094400200528     C                   MOVE      'N'           DDDRBROk                                   MD046635
094500200528     C                   ENDIF                                                              MD046635
094600200528     C                   ENDIF                                                              MD046635
094700200528      *                                                                                     MD046635
094800200528     C                   EXSR      UPDATERRS                                                MD046635
094900200528      *                                                                                     MD020938
095000200528     C*****DDDRBR        IFEQ      *Blanks                                         MD020938 MD046635
095100200528     C*****BRIND         ANDEQ     'Y'                                             MD020938 MD046635
095200200528     C**********         MOVE      *BLANKS       BRIND                             MD020938 MD046635
095300200528     C**********         Move      ZBR           DDDRBR                            MD020938 MD046635
095400200528     C**********         ENDIF                                                     MD020938 MD046635
095500200528      *
095600200528     C                   ENDSR
095700200528      *****************************************************************
095800200528     C/EJECT
095900200528      *****************************************************************
096000200528      *  VOVRDRFT - Validate Overdraft Details
096100200528      *****************************************************************
096200200528     C     VOVRDRFT      BEGSR
096300200528
096400200528      * Reset variables updated by each module
096500200528
096600200528     C                   EXSR      RESETERRS
096700200528      *
096800200528     C                   CALLB     'GLVODDE'
096900200528      *
097000200528      * INPUTS
097100200528      *
097200200528      ** Return Code
097300200528     C                   Parm                    RetCodeOut
097400200528      *
097500200528      ** Account Screen fields
097600200528     C                   Parm                    DDODLN
097700200528     C                   Parm                    DDODSC
097800200528     C                   Parm                    DDITRD
097900200528     C                   Parm                    DDOLVD
098000200528     C                   Parm                    DDODED
098100200528     C                   Parm                    DDAODR
098200200528     C                   Parm                    DDAODRX
098300200528     C                   Parm                    DDORTC
098400200528     C                   Parm                    DDDICT
098500200528     C                   Parm                    DDDCST
098600200528     C                   Parm                    DDDACO
098700200528     C                   Parm                    DDACTN
098800200528     C                   Parm                    DDDRIB
098900200528     C                   Parm                    DDDRIS
099000200528     C                   Parm                    DDDSIG                                     MD029023
099100200528     C                   Parm                    WNDRCD
099200200528      *
099300200528     C                   Parm                    AMOLDR
099400200528     C                   Parm                    AMDRIB
099500200528     C                   Parm                    AMDRIS
099600200528     C                   Parm                    AMODED
099700200528     C                   Parm                    AMODLN
099800200528     C                   Parm                    BXOLVD
099900200528     C                   Parm                    BXORTC
100000200528     C                   Parm                    BXPOLC
100100200528     C                   Parm                    BXAODR
100200200528      *
100300200528      ** ICD
100400200528     C                   Parm                    CRE001
100500200528     C                   Parm                    CER055                                       CER055
100600200528     C                   Parm                    BJDFIN
100700200528     C**********         Parm                    BJRDNB                                       CSC011
100800200528     C                   PARM                    WRunDay                                      CSC011
100900200528     C                   Parm                    WWBKVD
101000200528     C                   Parm                    WWFWVD
101100200528      *
101200200528      * OUTPUTS
101300200528      *
101400200528      * Error fields/message IDs/message data (arrays) from/to caller
101500200528     C                   PARM                    FldNamXAr
101600200528     C                   PARM                    MsgIDXAr
101700200528     C                   PARM                    MsgDtaXAr
101800200528     C                   PARM                    WFldNmXAr                                    CER055
101900200528     C                   PARM                    WMsgIDXAr                                    CER055
102000200528     C                   PARM                    WMsgDtXAr                                    CER055
102100200528      *
102200200528     C                   PARM      *ZERO         WNAODR           11 7
102300200528     C                   Parm      *ZERO         WNODLN           11 0
102400200528     C                   Parm                    AMDLIM
102500200528      *
102600200528      ** Overdraft Line - OK
102700200528      ** Overdraft Secured - OK
102800200528      ** Rev. Date (Line or Rate) - OK
102900200528      ** OD Line Charge Value Date - OK
103000200528      ** OD Line Expiry Date - OK
103100200528      ** Additional Overdraft Rate - OK
103200200528      ** Additional OD Rate Sign - OK
103300200528      ** Chg. Val. Date, OD Rate - OK
103400200528     C                   Parm                    DDODLNOK
103500200528     C                   Parm                    DDODSCOK
103600200528     C                   Parm                    DDITRDOK
103700200528     C                   Parm                    DDOLVDOK
103800200528     C                   Parm                    DDODEDOK
103900200528     C                   Parm                    DDAODROK
104000200528     C                   Parm                    DDAODRXOK
104100200528     C                   Parm                    DDORTCOK
104200200528
104300200528      * Update error info with that returned from the validation module
104400200528
104500200528     C                   EXSR      UPDATERRS
104600200528      *
104700200528     C                   ENDSR
104800200528      *****************************************************************                       CRE073
104900200528      /EJECT                                                                                  CRE073
105000200528      *****************************************************************                       CRE073
105100200528      *                                                               *                       CRE073
105200200528      *  SRSPSG - Validate Contractual Spread/Sign                    *                       CRE073
105300200528      *                                                               *                       CRE073
105400200528      *****************************************************************                       CRE073
105500200528     C     SRSPSG        BEGSR                                                                CRE073
105600200528                                                                                              CRE073
105700200528     C                   EXSR      RESETERRS                                                  CRE073
105800200528                                                                                              CRE073
105900200528     C                   CALL      'ZAVCSPSG'                                                 CRE073
106000200528     C                   PARM      *BLANKS       PRTCD                                        CRE073
106100200528     C                   PARM      *BLANKS       DDBASR           12                          CRE073
106200200528     C                   PARM      *BLANKS       DDBRTT            2                          CRE073
106300200528     C                   PARM      *BLANKS       DDFXRT           12                          CRE073
106400200528     C                   PARM                    DDDCSP                                       CRE073
106500200528     C                   PARM                    DDDCSG                                       CRE073
106600200528     C                   PARM      *ZEROS        TMCNSP                                       CRE073
106700200528     C                   PARM                    PModule                                      CRE073
106800200528     C                   PARM      *ZEROS        PCurset                                      CRE073
106900200528     C                   PARM                    FldNamXAr                                    CRE073
107000200528     C                   PARM                    MsgIDXAr                                     CRE073
107100200528     C                   PARM                    MsgDtaXAr                                    CRE073
107200200528     C                   PARM      *ZEROS        Indx                                         CRE073
107300200528     C                   PARM                    DDDCSPOK                                     CRE073
107400200528     C                   PARM                    DDDCSGOK                                     CRE073
107500200528                                                                                              CRE073
107600200528     C                   EXSR      UPDATERRS                                                  CRE073
107700200528                                                                                              CRE073
107800200528     C                   ENDSR                                                                CRE073
107900200528      *****************************************************************                       CRE073
108000200528      /EJECT                                                                                  CRE073
108100200528      *****************************************************************                       CRE073
108200200528      *                                                               *                       CRE073
108300200528      *  SRRNDM - Validate Rounding Method                            *                       CRE073
108400200528      *                                                               *                       CRE073
108500200528      *****************************************************************                       CRE073
108600200528     C     SRRNDM        BEGSR                                                                CRE073
108700200528                                                                                              CRE073
108800200528     C                   EXSR      RESETERRS                                                  CRE073
108900200528                                                                                              CRE073
109000200528     C                   CALL      'ZAVRNDMT'                                                 CRE073
109100200528     C                   PARM      *BLANKS       PRTCD                                        CRE073
109200200528     C                   PARM                    DDDRMT                                       CRE073
109300200528     C                   PARM                    DDDCSP                                       CRE073
109400200528     C                   PARM                    DDDRFD                                       CRE073
109500200528     C                   PARM                    PModule                                      CRE073
109600200528     C                   PARM                    PCurset                                      CRE073
109700200528     C                   PARM                    FldNamXAr                                    CRE073
109800200528     C                   PARM                    MsgIDXAr                                     CRE073
109900200528     C                   PARM                    MsgDtaXAr                                    CRE073
110000200528     C                   PARM      *ZEROS        Indx                                         CRE073
110100200528     C                   PARM                    DDDRMTOK                                     CRE073
110200200528                                                                                              CRE073
110300200528     C                   EXSR      UPDATERRS                                                  CRE073
110400200528                                                                                              CRE073
110500200528     C                   ENDSR                                                                CRE073
110600200528      *****************************************************************                       CRE073
110700200528      /EJECT                                                                                  CRE073
110800200528      *****************************************************************                       CRE073
110900200528      *                                                               *                       CRE073
111000200528      *  SRRNDF - Validate Fraction/Decimal                           *                       CRE073
111100200528      *                                                               *                       CRE073
111200200528      *****************************************************************                       CRE073
111300200528     C     SRRNDF        BEGSR                                                                CRE073
111400200528                                                                                              CRE073
111500200528     C                   EXSR      RESETERRS                                                  CRE073
111600200528                                                                                              CRE073
111700200528     C                   CALL      'ZAVRNDFD'                                                 CRE073
111800200528     C                   PARM      *BLANKS       PRTCD                                        CRE073
111900200528     C                   PARM                    DDDRFD                                       CRE073
112000200528     C                   PARM                    DDDCSP                                       CRE073
112100200528     C                   PARM                    DDDRMT                                       CRE073
112200200528     C                   PARM                    PModule                                      CRE073
112300200528     C                   PARM      *ZEROS        PCurset                                      CRE073
112400200528     C                   PARM                    FldNamXAr                                    CRE073
112500200528     C                   PARM                    MsgIDXAr                                     CRE073
112600200528     C                   PARM                    MsgDtaXAr                                    CRE073
112700200528     C                   PARM      *ZEROS        Indx                                         CRE073
112800200528     C                   PARM                    DDDRFDOK                                     CRE073
112900200528                                                                                              CRE073
113000200528     C                   EXSR      UPDATERRS                                                  CRE073
113100200528                                                                                              CRE073
113200200528     C                   ENDSR                                                                CRE073
113300200528      *****************************************************************                       CRE073
113400200528      /EJECT                                                                                  CRE073
113500200528      *****************************************************************                       CRE073
113600200528      *                                                               *                       CRE073
113700200528      *  SRSPRT - Compute for the new spread rate based on the        *                       CRE073
113800200528      *           rounding rules                                      *                       CRE073
113900200528      *                                                               *                       CRE073
114000200528      *****************************************************************                       CRE073
114100200528     C     SRSPRT        BEGSR                                                                CRE073
114200200528                                                                                              CRE073
114300200528     C                   IF        CRE015  = 'Y'  AND                                       AR947093
114400200528     C                             X5ATTY = 'P'                                             AR947093
114500200528     C**********         MOVE      AMDRIS        NEWSRT                           AR947093 AR947093A
114600200528     C**********         MOVE      AMDRIS        WNDRIS                           AR947093 AR947093A
114700200528     C                   CallB     'ZALIGN'                                                AR947093A
114800200528     C                   Parm                    ZAlignOk          1                       AR947093A
114900200528     C                   Parm      DDDRIS        ZField           16                       AR947093A
115000200528     C                   Parm      7             ZADec                                     AR947093A
115100200528     C                   Parm      4             ZADig             2 0                     AR947093A
115200200528     C                   IF        ZAlignOk = 'Y'                                          AR947093A
115300200528     C                   Move      ZField        NEWSRT                                    AR947093A
115400200528     C                   IF        DDDSIG  = '-'                                           AR947093A
115500200528     C                   MULT      -1            NEWSRT                                    AR947093A
115600200528     C                   ENDIF                                                             AR947093A
115700200528     C                   Z-ADD     NEWSRT        WNDRIS                                    AR947093A
115800200528     C                   ENDIF                                                             AR947093A
115900200528     C                                                                                     AR947093A
116000200528     C                   ELSE                                                               AR947093
116100200528     C                   CALL      'ZACALCSPRT'                                               CRE073
116200200528     C                   PARM      *BLANKS       PRTCD                                        CRE073
116300200528     C**********         PARM                    WWDBRT                              CRE073 AR944106
116400200528     C                   PARM                    WWBRTT                                     AR944106
116500200528     C                   PARM                    TMCNSP                                       CRE073
116600200528     C                   PARM                    DDDCSG                                       CRE073
116700200528     C                   PARM                    DDDRMT                                       CRE073
116800200528     C                   PARM                    DDDRFD                                       CRE073
116900200528     C                   PARM      *ZEROS        NEWSRT                                       CRE073
117000200528     C                   PARM      *ZEROS        NEWFRT                                     AR847249
117100200528                                                                                              CRE073
117200200528     C                   IF        PRTCD <> *BLANKS                                           CRE073
117300200528     C                   EXSR      *PSSR                                                      CRE073
117400200528     C                   ENDIF                                                                CRE073
117500200528                                                                                              CRE073
117600200528     C**********         IF        NEWFRT <= *ZEROS AND                            AR847249 AR947093
117700200528     C**********                   DDDRMT <> *BLANKS                               AR847249 AR947093
117800200528     C**********         EVAL      DDDRMTOK = 'N'                                  AR847249 AR947093
117900200528     C**********         EVAL      FldNamXAr(1) = 'DDDRMT'                         AR847249 AR947093
118000200528     C**********         EVAL      MsgIDXAr(1)  = 'USS0015'                        AR847249 AR947093
118100200528      **********                                                                   AR847249 AR947093
118200200528     C**********         EVAL      MsgDtaXAr(1) = %EDITC(NEWFRT:'J')               AR847249 AR947093
118300200528     C**********         EXSR      UPDATERRS                                       AR847249 AR947093
118400200528     C**********         ELSE                                                      AR847249 AR947093
118500200528     C                   IF        NEWSRT = *ZERO                                             CRE073
118600200528     C                   EVAL      DDDRIS = *BLANKS                                           CRE073
118700200528     C                   EVAL      DDDSIG = *BLANKS                                           CRE073
118800200528     C                   ELSE                                                                 CRE073
118900200528     C                   Z-ADD     *ZEROS        WSPREAD                                      CRE073
119000200528     C                   IF        NEWSRT < *ZERO                                             CRE073
119100200528                                                                                            AR847249
119200200528     C                   EVAL      DDDRISOK = 'W'                                           AR847249
119300200528     C                   EVAL      WFldNmXAr(1) = 'DDDRIS'                                  AR847249
119400200528     C                   EVAL      WMsgIDXAr(1) = 'USS0016'                                 AR847249
119500200528     C**********         EVAL      WMsgDtXAr(1) = %EDITC(NEWSRT:'J')               AR847249 MD000091
119600200528     C                   EVAL      MsgDtaTmp = %EDITC(NEWSRT:'J')                           MD000091
119700200528     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
119800200528     C                   EVAL      WMsgDtXAr(1) = LenStr +%TRIM(MsgDtaTmp)                  MD000091
119900200528     C                   EXSR      UPDATERRS                                                AR847249
120000200528     C**********         MOVE      '-'           DDDSIG                              CRE073 AR854615
120100200528     C**********         MOVE      '+'           DDDSIG                            AR854615 AR847249
120200200528     C                   IF        DDDCSG = '+'                                             AR847249
120300200528     C                   MOVE      '-'           DDDSIG                                     AR847249
120400200528     C                   ELSEIF    DDDCSG = '-'                                             AR847249
120500200528     C                   MOVE      '+'           DDDSIG                                     AR847249
120600200528     C                   ENDIF                                                              AR847249
120700200528     C                   EVAL      WSPREAD = %ABS(NEWSRT)                                     CRE073
120800200528     C                   ELSE                                                                 CRE073
120900200528     C**********         MOVE      '+'           DDDSIG                              CRE073 AR854615
121000200528     C                   MOVE      DDDCSG        DDDSIG                                     AR854615
121100200528     C                   Z-ADD     NEWSRT        WSPREAD                                      CRE073
121200200528     C                   ENDIF                                                                CRE073
121300200528     C                   MOVE      *BLANKS       ZFIELD                                       CRE073
121400200528     C                   MOVE(P)   WSPREAD       ZFIELD                                       CRE073
121500200528     C                   Z-ADD     7             ZADEC                                        CRE073
121600200528     C                   CALLB     'ZEDIT'                                                    CRE073
121700200528     C                   PARM                    ZFIELD           16                          CRE073
121800200528     C                   PARM                    ZADEC             1 0                        CRE073
121900200528     C                   MOVE      ZFIELD        DDDRIS                                       CRE073
122000200528     C                   ENDIF                                                                CRE073
122100200528     C                   IF        DDDCSG = '-'                                             AR854615
122200200528     C**********                   AND NEWSRT > 0                                 AR854615 AR947093A
122300200528      ** Convert to positive for Negative spread rate                                       AR854615
122400200528     C**********                   OR  NEWSRT < 0                                 AR854615 AR947093A
122500200528     C                   MULT      -1            NEWSRT                                     AR854615
122600200528     C                   ENDIF                                                              AR854615
122700200528     C                   Z-ADD     NEWSRT        WNDRIS                                       CRE073
122800200528     C                   ENDIF                                                              AR847249
122900200528                                                                                              CRE073
123000200528     C                   ENDSR                                                                CRE073
123100200528      *****************************************************************
123200200528     C/EJECT
123300200528      /COPY WNCPYSRC,GLAMAD2V17                                                               CUT009
123400200528      *****************************************************************
123500200528     C/EJECT
123600200528      *****************************************************************
123700200528      *                                                               *
123800200528      * SETUPVALID - Set up additional fields that are needed on the  *
123900200528      *    Valid file record.                                         *
124000200528      *                                                               *
124100200528      *****************************************************************
124200200528
124300200528     C     SETUPVALID    BEGSR
124400200528      *
124500200528     C     DDACTN        IFEQ      'I'
124600200528     C                   Move      DDCUSN        RICNUM
124700200528     C                   Move      DDCCY         RICCY
124800200528     C                   Move      DDACOD        RIACOD
124900200528     C                   Move      DDACSQ        RIACSQ
125000200528     C                   Move      DDBRCA        RIBRCA
125100200528     C                   ENDIF
125200200528     C                   MOVE      DDDRIB        AMDRIB
125300200528      *                                                                                       CRE073
125400200528     C                   IF        CRE073 = 'Y'                                               CRE073
125500200528     C                   Z-ADD     TMCNSP        AMDCSP                                       CRE073
125600200528     C                   MOVEL     DDDCSG        AMDCSG                                       CRE073
125700200528     C                   MOVEL     DDDRMT        AMDRMT                                       CRE073
125800200528     C                   MOVEL     DDDRFD        AMDRFD                                       CRE073
125900200528     C                   Z-ADD     NEWSRT        AMDRIS                                       CRE073
126000200528      *                                                                                       CRE073
126100200528     C                   ELSE                                                                 CRE073
126200200528     C                   Z-ADD     WNDRIS        AMDRIS
126300200528     C                   ENDIF                                                                CRE073
126400200528     C                   Z-ADD     WNDRCD        AMDRCD
126500200528     C                   Move      DDDICT        RIDICT
126600200528     C                   Move      DDDCST        RIDCST
126700200528     C                   Move      DDDRIC        AMDRIC
126800200528     C                   Z-ADD     WNNDID        AMNDID
126900200528     C                   MOVE      DDDRIF        AMDRIF
127000200528     C                   Z-ADD     WNDRDY        AMDRDY
127100200528     C                   Move      DDDRBR        RIDRBR
127200200528     C                   Move      DDDACP        RIDACP
127300200528     C                   Move      DDODSC        AMODSC
127400200528     C                   Z-ADD     WNAODR        BXAODR
127500200528     C     CER055        IFEQ      'Y'                                                        CER055
127600200528     C     WNODLN        ANDNE     AMODLN                                                     CER055
127700200528     C                   Z-ADD     AMODLN        BXPOLA                                       CER055
127800200528     C                   ENDIF                                                                CER055
127900200528     C                   Z-Add     WNODLN        AMODLN
128000200528      *
128100200528     C                   CallB     'ZDATE1'
128200200528     C                   Parm      DDITRD        DateIn            6
128300200528     C                   Parm      *Zero         DaynoOut          5 0
128400200528     C                   Parm                    BJDFIN
128500200528     C                   Parm                    ErrorFlag         1
128600200528     C                   Z-Add     DaynoOut      BXITRD
128700200528      *
128800200528     C                   CallB     'ZDATE1'
128900200528     C                   Parm      DDOLVD        DateIn
129000200528     C                   Parm      *Zero         DaynoOut
129100200528     C                   Parm                    BJDFIN
129200200528     C                   Parm                    ErrorFlag
129300200528      *                                                                                       CER055
129400200528     C                   Z-Add     DaynoOut      WWOLVD            5 0                        CER055
129500200528     C     CER055        IFEQ      'Y'                                                        CER055
129600200528     C     WWOLVD        ANDNE     BXOLVD                                                     CER055
129700200528     C                   Z-ADD     BXOLVD        BXPOLC                                       CER055
129800200528     C                   ENDIF                                                                CER055
129900200528     C                   Z-Add     DaynoOut      BXOLVD
130000200528      *
130100200528     C                   CallB     'ZDATE1'
130200200528     C                   Parm      DDODED        DateIn
130300200528     C                   Parm      *Zero         DaynoOut
130400200528     C                   Parm                    BJDFIN
130500200528     C                   Parm                    ErrorFlag
130600200528      *                                                                                       CER055
130700200528     C                   Z-Add     DaynoOut      WWODED            5 0                        CER055
130800200528     C     CER055        IFEQ      'Y'                                                        CER055
130900200528     C     WWODED        ANDNE     AMODED                                                     CER055
131000200528     C                   Z-ADD     AMODED        BXPOLE                                       CER055
131100200528     C                   ENDIF                                                                CER055
131200200528     C                   Z-Add     DaynoOut      AMODED
131300200528      *
131400200528     C                   CallB     'ZDATE1'
131500200528     C                   Parm      DDORTC        DateIn
131600200528     C                   Parm      *Zero         DaynoOut
131700200528     C                   Parm                    BJDFIN
131800200528     C                   Parm                    ErrorFlag
131900200528     C                   Z-Add     DaynoOut      BXORTC
132000200528     C*                                                                                       208221
132100200528     C** Check if Revenue Analysis (CDE002) is present                                        208221
132200200528     C*                                                                                       208221
132300200528     C     CDE002        IFEQ      'Y'                                                        208221
132400200528     C*                                                                                       208221
132500200528     C** Only default on Insert. Note if the rate/spread is zero,                             208221
132600200528     C** the margin will default to zero                                                      208221
132700200528     C*                                                                                       208221
132800200528     C     DDACTN        IFEQ      'I'                                                        208221
132900200528     C     DDDRIB        IFNE      *BLANKS                                                    208221
133000200528     C                   MOVE      *ZEROS        ZFLD15                                       CRE073
133100200528     C                   Z-ADD     WNDRIS        BXDRMG                                       208221
133200200528     C                   MOVEL     'Y'           BXOVRD                                       208221
133300200528     C                   MOVEL     'Y'           DDOVRD                                       208221
133400200528     C                   MOVE      BXDRMG        ZFLD15                                       208221
133500200528     C                   EVAL      ZDECS= 7                                                   208221
133600200528     C                   CALLB     'ZSEDIT'                                                   208221
133700200528     C                   PARM                    ZFLD15           15 0                        208221
133800200528     C                   PARM                    ZDECS             1 0                        208221
133900200528     C                   PARM      *BLANKS       ZECODE            1                          208221
134000200528     C                   PARM                    ZOUT21           21                          208221
134100200528     C                   EVAL      DDDRMG= %SUBST(ZOUT21:10:12)                               208221
134200200528     C                   ELSE                                                                 208221
134300200528     C                   MOVEL     *BLANKS       BXDRMG                                       208221
134400200528     C                   MOVEL     *BLANKS       BXOVRD                                       208221
134500200528     C                   MOVEL     *BLANKS       DDDRMG                                       208221
134600200528     C                   MOVEL     *BLANKS       DDOVRD                                       208221
134700200528     C                   ENDIF                                                                208221
134800200528     C                   ENDIF                                                                208221
134900200528     C                   ENDIF                                                                208221
135000200528     C*                                                                                       208221
135100200528
135200200528     C                   ENDSR
135300200528      *****************************************************************
135400200528      /EJECT
135500200528      *****************************************************************
135600200528      * *INZSR - Program Initialisation routine                       *
135700200528      *****************************************************************
135800200528
135900200528     C     *INZSR        BEGSR
136000200528
136100200528     C     *ENTRY        PLIST
136200200528      * Transaction information (DS) from source system
136300200528     C                   PARM                    TranIn1
136400200528     C                   PARM                    TranIn2
136500200528     C                   PARM                    TranIn4                                      208221
136600200528      * Front Office ID                                                         180721
136700200528     C**********         PARM                    APFOTranID       20                   180721 CGL029
136800200528     C                   PARM                    APFOTran40       40                          CGL029
136900200528      * Field OK flags (DS) from/to caller
137000200528     C                   PARM                    OKFlagsDS
137100200528      * Error fields/message IDs/message data (arrays) from/to caller
137200200528     C                   PARM                    FldNameArr
137300200528     C                   PARM                    MsgIDArr
137400200528     C                   PARM                    MsgDtaArr
137500200528      * Array index (3P0) from/to caller
137600200528     C                   PARM                    Idx
137700200528      * Warning fields/message IDs/message data (arrays) from/to caller                       CER055
137800200528     C                   PARM                    WFldNamArr                                   CER055
137900200528     C                   PARM                    WMsgIDArr                                    CER055
138000200528     C                   PARM                    WMsgDtaArr                                   CER055
138100200528      * Array index (3P0) from/to caller                                                      CER055
138200200528     C                   PARM                    WIx                                          CER055
138300200528      * Valid Account layout (DS) from/to caller
138400200528     C                   PARM                    ValidAccn
138500200528     C                   PARM                    ValidExBX
138600200528     C                   PARM                    ValidExRI
138700200528      * Revenue Analysis                                                        208221
138800200528     C                   PARM                    CDE002            1            208221
138900200528     C                   PARM                    CRE015            1                        AR947093
139000200528     C                   PARM                    X5ATTY            1                        AR947093
139100200528      *
139200200528      **  GET ZMUSER to access default branch.
139300200528      *
139400200528     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
139500200528     C**********         IN        ZMUSER                                                    BUG8550
139600200528     C**********         UNLOCK    ZMUSER                                                    BUG8550
139700200528      *
139800200528      **  Move program name into *LDA field.
139900200528      *
140000200528     C     *LOCK         IN        LDA
140100200528     C                   MOVEL     'GLAMAD2VL'   DBPGM
140200200528     C                   OUT       LDA
140300200528      *
140400200528      ** Access Bank details via access program
140500200528      *  (database error handling done in access program)
140600200528     C                   CALLB     'AOBANKR0'
140700200528     C                   PARM      '*DBERR '     @RTCD
140800200528     C                   PARM      '*FIRST '     @OPTN
140900200528     C     SDBANK        PARM      SDBANK        DSFDY
141000200528      *                                                                         180721
141100200528      ** Access General Ledger details via access program                       180721
141200200528      *  (database error handling done in access program)                       180721
141300200528     C**********         CALLB     'AOGELRR0'                                   180721        CGL029
141400200528     C                   CALLB     'AOGELRR1'                                                 CGL029
141500200528     C                   PARM      '*DBERR '     @RTCD                          180721
141600200528     C                   PARM      '*FIRST '     @OPTN                          180721
141700200528     C*****SDGELR        PARM      SDGELR        DSFDY                          180721        CGL029
141800200528     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
141900200528      *
142000200528      ** Access MIDAS Modules details via access program
142100200528      *  (database error handling done in access program)
142200200528     C                   CALLB     'AOMMODR0'
142300200528     C                   PARM      '*DBERR '     @RTCD
142400200528     C                   PARM      '*FIRST '     @OPTN
142500200528     C     SDMMOD        PARM      SDMMOD        DSFDY
142600200528      *
142700200528      ** Access Retail details via access program
142800200528      *  (database error handling done in access program)
142900200528     C     BGRTBN        IFEQ      'Y'
143000200528     C                   CALLB     'AORETLR0'
143100200528     C                   PARM      '*DBERR '     @RTCD
143200200528     C                   PARM      '*FIRST '     @OPTN
143300200528     C     SDRETL        PARM      SDRETL        DSFDY
143400200528     C                   ENDIF
143500200528      *
143600200528      ** Access SAR file to determine if CEU013 is present.
143700200528      *
143800200528     C                   CALLB     'AOSARDR0'
143900200528     C                   PARM      *BLANKS       @RTCD
144000200528     C                   PARM      '*VERIFY'     @OPTN
144100200528     C                   PARM      'CRE001'      @SARD
144200200528     C     SCSARD        PARM      SCSARD        DSFDY
144300200528     C     @RTCD         IFNE      *BLANKS
144400200528     C     @RTCD         ANDNE     '*NRF   '
144500200528     C     *LOCK         IN        LDA
144600200528     C                   MOVEL     'SCSARDPD'    DBFILE
144700200528     C                   Z-ADD     1             DBASE
144800200528     C                   MOVEL     'CRE001'      DBKEY
144900200528     C                   OUT       LDA
145000200528     C                   SETON                                        U7U8LR
145100200528     C                   EXSR      #TERM
145200200528     C                   ENDIF
145300200528     C                   MOVEL     'N'           CRE001            1
145400200528     C     @RTCD         IFEQ      *BLANK
145500200528     C                   MOVEL     'Y'           CRE001
145600200528     C                   ENDIF
145700200528                                                                                              CSC011
145800200528      ** Check if CSC011 is installed                                                         CSC011
145900200528                                                                                              CSC011
146000200528      ** CSC011 is a redundant feature. No need to check                                    MD024398
146100200528                                                                                            MD024398
146200200528     C                   EVAL      WRunDay = BJRDNB                                           CSC011
146300200528                                                                                              CSC011
146400200528     C**********         CALLB     'AOSARDR0'                                        CSC011 MD024398
146500200528     C**********         PARM      *BLANKS       PRtCd                               CSC011 MD024398
146600200528     C**********         PARM      '*VERIFY'     POptn                               CSC011 MD024398
146700200528     C**********         PARM      'CSC011'      PSard                               CSC011 MD024398
146800200528     C*****SCSARD        PARM      SCSARD        DSFDY                               CSC011 MD024398
146900200528      **********                                                                     CSC011 MD024398
147000200528     C**********         IF        PRtCd = *Blanks                                   CSC011 MD024398
147100200528     C**********         EVAL      CSC011 = 'Y'                                      CSC011 MD024398
147200200528     C**********         IN        SC24X7                                            CSC011 MD024398
147300200528     C**********         IN        SDSTAT                                            CSC011 MD024398
147400200528     C**********         IF        S1SUPP = LIBR                                     CSC011 MD024398
147500200528     C**********         EVAL      WRunDay = S1DATE                                  CSC011 MD024398
147600200528     C**********         ENDIF                                                       CSC011 MD024398
147700200528      **********                                                                     CSC011 MD024398
147800200528     C**********         ELSE                                                        CSC011 MD024398
147900200528     C                   EVAL      CSC011 = 'N'                                               CSC011
148000200528     C**********         IF        PRtCd <> '*NRF'                                   CSC011 MD024398
148100200528     C******LOCK         IN        LDA                                               CSC011 MD024398
148200200528     C**********         EVAL      DBFILE = 'SCSARDPD'                               CSC011 MD024398
148300200528     C**********         EVAL      DBKEY = 'CSC011'                                  CSC011 MD024398
148400200528     C**********         EVAL      DBASE = 2                                         CSC011 MD024398
148500200528     C**********         OUT       LDA                                               CSC011 MD024398
148600200528     C**********         EXSR      *PSSR                                             CSC011 MD024398
148700200528     C**********         ENDIF                                                       CSC011 MD024398
148800200528      **********                                                                     CSC011 MD024398
148900200528     C**********         ENDIF                                                       CSC011 MD024398
149000200528                                                                                              CER055
149100200528      ** Check if CER055 is installed                                                         CER055
149200200528                                                                                              CER055
149300200528     C                   CALLB     'AOSARDR0'                                                 CER055
149400200528     C                   PARM      *BLANKS       PRtCd                                        CER055
149500200528     C                   PARM      '*VERIFY'     POptn                                        CER055
149600200528     C                   PARM      'CER055'      PSard                                        CER055
149700200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CER055
149800200528                                                                                              CER055
149900200528     C                   IF        PRtCd = *Blanks                                            CER055
150000200528     C                   EVAL      CER055 = 'Y'                                               CER055
150100200528     C                   ELSE                                                                 CER055
150200200528     C                   EVAL      CER055 = 'N'                                               CER055
150300200528     C                   IF        PRtCd <> '*NRF'                                            CER055
150400200528     C     *LOCK         IN        LDA                                                        CER055
150500200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER055
150600200528     C                   EVAL      DBKEY = 'CER055'                                           CER055
150700200528     C                   EVAL      DBASE = 3                                                  CER055
150800200528     C                   OUT       LDA                                                        CER055
150900200528     C                   EXSR      *PSSR                                                      CER055
151000200528     C                   ENDIF                                                                CER055
151100200528     C                   ENDIF                                                                CER055
151200200528      *
151300200528      **  Get the Back Value Limit Date
151400200528                                                                                              CSC011
151500200528     C                   IF        CSC011 = 'Y' AND S1SUPP = LIBR                             CSC011
151600200528     C     WRunDay       SUB       BJBVPD        WWBKVD            5 0                        CSC011
151700200528     C     WRunDay       ADD       BMNDFV        WWFWVD            5 0                        CSC011
151800200528                                                                                              CSC011
151900200528     C                   ELSE                                                                 CSC011
152000200528     C     BJRDNB        SUB       BJBVPD        WWBKVD            5 0
152100200528      *
152200200528      **  Get the Forward Value Limit Date
152300200528     C     BJRDNB        ADD       BMNDFV        WWFWVD            5 0
152400200528     C                   ENDIF                                                                CSC011
152500200528                                                                                              CRE073
152600200528      ** Check if CRE073 is installed                                                         CRE073
152700200528                                                                                              CRE073
152800200528     C                   CALLB     'AOSARDR0'                                                 CRE073
152900200528     C                   PARM      *BLANKS       PRtCd                                        CRE073
153000200528     C                   PARM      '*VERIFY'     POptn                                        CRE073
153100200528     C                   PARM      'CRE073'      PSard                                        CRE073
153200200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
153300200528                                                                                              CRE073
153400200528     C                   IF        PRtCd = *BLANKS                                            CRE073
153500200528     C                   EVAL      CRE073 = 'Y'                                               CRE073
153600200528     C                   ELSE                                                                 CRE073
153700200528     C                   EVAL      CRE073 = 'N'                                               CRE073
153800200528     C                   IF        PRtCd <> '*NRF'                                            CRE073
153900200528     C     *LOCK         IN        LDA                                                        CRE073
154000200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE073
154100200528     C                   EVAL      DBKEY = 'CRE073'                                           CRE073
154200200528     C                   EVAL      DBASE = 4                                                  CRE073
154300200528     C                   OUT       LDA                                                        CRE073
154400200528     C                   EXSR      *PSSR                                                      CRE073
154500200528     C                   ENDIF                                                                CRE073
154600200528                                                                                              CRE073
154700200528     C                   ENDIF                                                                CRE073
154800200528                                                                                              CRE073
154900200528                                                                                              CRE090
155000200528      ** Check if CRE090 is installed                                                         CRE090
155100200528                                                                                              CRE090
155200200528     C                   CALLB     'AOSARDR0'                                                 CRE090
155300200528     C                   PARM      *BLANKS       PRtCd                                        CRE090
155400200528     C                   PARM      '*VERIFY'     POptn                                        CRE090
155500200528     C                   PARM      'CRE090'      PSard                                        CRE090
155600200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE090
155700200528                                                                                              CRE090
155800200528     C                   IF        PRtCd = *BLANKS                                            CRE090
155900200528     C                   EVAL      CRE090 = 'Y'                                               CRE090
156000200528     C                   ELSE                                                                 CRE090
156100200528     C                   EVAL      CRE090 = 'N'                                               CRE090
156200200528     C                   IF        PRtCd <> '*NRF'                                            CRE090
156300200528     C     *LOCK         IN        LDA                                                        CRE090
156400200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE090
156500200528     C                   EVAL      DBKEY = 'CRE090'                                           CRE090
156600200528     C                   EVAL      DBASE = 5                                                  CRE090
156700200528     C                   OUT       LDA                                                        CRE090
156800200528     C                   EXSR      *PSSR                                                      CRE090
156900200528     C                   ENDIF                                                                CRE090
157000200528                                                                                              CRE090
157100200528     C                   ENDIF                                                                CRE090
157200200528                                                                                              CRE090
157300200528      *
157400200528      *  Set up the name of the MSGF from which the message handler will
157500200528      *   get the messages
157600200528     C                   EVAL      #MsgFile = 'DRSMM'
157700200528      *                                                                         180721
157800200528     C                   Movel     'N'           WValforPB         1            180721
157900200528     C                   Movel     *Blanks       WWID              2            180721
158000200528      *                                                                         180721
158100200528     C     BGN4ST        IFEQ      'Y'                                          180721
158200200528      *                                                                         180721
158300200528     C**********         Movel     APFOTranID    WWID                                  180721 CGL029
158400200528     C                   Movel     APFOTran40    WWID                                         CGL029
158500200528      *                                                                         180721
158600200528     C     AMATYP        IFEQ      'R'                                          180721
158700200528      *                                                                         180721
158800200528     C                   Movel     AMCNUM        @CNUM                          180721
158900200528     C                   CALL      'AOCUSTR1'                                   180721
159000200528     C                   PARM      '*DBERR '     @RTCD                          180721
159100200528     C                   PARM      '*KEY   '     @OPTN                          180721
159200200528     C                   PARM                    @CNUM            10            180721
159300200528     C                   PARM      *BLANKS       @CNST             7            180721
159400200528     C     SDCUST        PARM      SDCUST        DSLDY                          180721
159500200528      *                                                                         180721
159600200528     C     BBPRBA        IFEQ      'Y'                                          180721
159700200528     C                   Movel     'Y'           WValforPB                      180721
159800200528     C                   ENDIF                                                  180721
159900200528     C                   ENDIF                                                  180721
160000200528     C                   ENDIF                                                  180721
160100200528                                                                                            MD046635
160200200528     C                   CALLB     'AOSVALR0'                                               MD046635
160300200528     C                   PARM                    @RTCD             7                        MD046635
160400200528     C                   PARM      BRCUSR        @OP01            20                        MD046635
160500200528     C     CurSysVal     PARM                    @VL01           200                        MD046635
160600200528     C                   PARM                    @OP02            20                        MD046635
160700200528     C                   PARM                    @VL02           200                        MD046635
160800200528     C                   PARM                    @OP03            20                        MD046635
160900200528     C                   PARM                    @VL03           200                        MD046635
161000200528     C                   PARM                    @OP04            20                        MD046635
161100200528     C                   PARM                    @VL04           200                        MD046635
161200200528     C                   PARM                    @OP05            20                        MD046635
161300200528     C                   PARM                    @VL05           200                        MD046635
161400200528     C                   PARM                    @OP06            20                        MD046635
161500200528     C                   PARM                    @VL06           200                        MD046635
161600200528     C                   PARM                    @OP07            20                        MD046635
161700200528     C                   PARM                    @VL07           200                        MD046635
161800200528     C                   PARM                    @OP08            20                        MD046635
161900200528     C                   PARM                    @VL08           200                        MD046635
162000200528     C                   PARM                    @OP09            20                        MD046635
162100200528     C                   PARM                    @VL09           200                        MD046635
162200200528     C                   PARM                    @OP10            20                        MD046635
162300200528     C                   PARM                    @VL10           200                        MD046635
162400200528                                                                                            MD046635
162500200528     C/COPY WNCPYSRC,GLAMA2VC03
162600200528
162700200528      ** Program, module and procedure names for database error processing.
162800200528      ** =================================================================
162900200528      ** The following /COPY sets these values, and also defines LDA as
163000200528      ** an external data area
163100200528
163200200528     C                   ENDSR
163300200528      *****************************************************************
163400200528      /EJECT
163500200528      *****************************************************************
163600200528      * RESETERRS - Reset error information that is received back     *
163700200528      *    from each validation module.                               *
163800200528      *****************************************************************
163900200528
164000200528     C     RESETERRS     BEGSR
164100200528
164200200528     C                   EVAL      RetCodeOut = *Blanks
164300200528      *
164400200528      * Reset error & warning fields/message IDs/message data (arrays)
164500200528     C                   MOVEL     *BLANK        FldNamXAr
164600200528     C                   MOVEL     *BLANK        MsgIDXAr
164700200528     C                   MOVEL     *BLANK        MsgDtaXAr
164800200528     C                   MOVEL     *BLANK        WFldNmXAr                                    CER055
164900200528     C                   MOVEL     *BLANK        WMsgIDXAr                                    CER055
165000200528     C                   MOVEL     *BLANK        WMsgDtXAr                                    CER055
165100200528
165200200528     C                   ENDSR
165300200528      *****************************************************************
165400200528      /EJECT
165500200528      *****************************************************************
165600200528      * UPDATERRS - Update error information with that received back  *
165700200528      *    from each validation module.                               *
165800200528      *****************************************************************
165900200528
166000200528     C     UPDATERRS     BEGSR
166100200528      *
166200200528      * Update error fields/message IDs/message data (arrays)
166300200528      *
166400200528     C                   Z-ADD     1             I                 3 0
166500200528     C     *BLANK        LOOKUP    FldNameArr(I)                          99
166600200528     C     *IN99         IFEQ      '1'
166700200528     C                   MOVEA     FldNamXAr     FlDNameArr(I)
166800200528     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
166900200528     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
167000200528     C                   END
167100200528      *
167200200528      * Set Error Index
167300200528     C                   Z-ADD     1             I
167400200528     C     *BLANK        LOOKUP    FldNameArr(I)                          99
167500200528     C     I             SUB       1             Idx
167600200528      *                                                                                       CER055
167700200528      * Update warning fields/message IDs/message data (arrays)                               CER055
167800200528      *                                                                                       CER055
167900200528     C                   Z-ADD     1             I                                            CER055
168000200528     C     *BLANK        LOOKUP    WFldNamArr(I)                          99                  CER055
168100200528     C     *IN99         IFEQ      '1'                                                        CER055
168200200528     C                   MOVEA     WFldNmXAr     WFldNamArr(I)                                CER055
168300200528     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)                                 CER055
168400200528     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)                                CER055
168500200528     C                   END                                                                  CER055
168600200528      *                                                                                       CER055
168700200528      * Set Warning Index                                                                     CER055
168800200528     C                   Z-ADD     1             I                                            CER055
168900200528     C     *BLANK        LOOKUP    WFldNamArr(I)                          99                  CER055
169000200528     C     I             SUB       1             WIx                                          CER055
169100200528      *                                                                                       CER055
169200200528      *
169300200528     C                   ENDSR
169400200528      *****************************************************************
169500200528      /EJECT
169600200528      *****************************************************************
169700200528      * #TERM - Termination processing.
169800200528      *****************************************************************
169900200528     C     #TERM         BEGSR
170000200528      *
170100200528      **  Terminate program
170200200528      *
170300200528     C                   MOVE      '1'           *INLR
170400200528      *
170500200528     C     *INU7         IFEQ      '1'
170600200528     C                   DUMP
170700200528     C                   END
170800200528      *
170900200528     C                   RETURN
171000200528      *
171100200528     C                   ENDSR
171200200528      *****************************************************************
171300200528      /EJECT
171400200528      ********************************************************************
171500200528     C/COPY ZACPYSRC,PSSR_ILE
171600200528      ********************************************************************
171700200528      /EJECT
171800200528**  CPY@
171900200528(c) Finastra International Limited 2001
