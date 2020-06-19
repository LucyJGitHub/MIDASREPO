000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas GL Credit interest and charges dtls Validati')   *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - General Ledger Module                                *
000900200528      *                                                               *
001000200528      *  GLAMAD3VL -  Credit Interest and Charges Details Validation  *
001100200528      *                                                               *
001200200528      *  (c) Finastra International Limited 2001                      *
001300200528      *                                                               *
001400200604      *  Last Amend No. 250822             Date 22May20               *
001500200604      *  Prev Amend No. 252664             Date 22May20               *
001600200604      *                 CER050             Date 16Jun19               *
001700200528      *                 MD053611           Date 19Aug19               *
001800200528      *                 MD046248           Date 27Oct17               *
001900200528      *                 MD047680           Date 08Sep17               *
002000200528      *                 MD046635           Date 10Aug17               *
002100200528      *                 MD020938           Date 19Jun13               *
002200200528      *                 CGL165             Date 17Feb15               *
002300200528      *                 CRE090             Date 14Feb14               *
002400200528      *                 MD024398           Date 11May14               *
002500200528      *                 MD000091           Date 07May13               *
002600200528      *                 AR947093A          Date 04May12               *
002700200528      *                 AR947093           Date 26Apr12               *
002800200528      *                 AR944106           Date 30Mar12               *
002900200528      *                 AR847249           Date 28Jan12               *
003000200528      *                 AR854615           Date 19Jan12               *
003100200528      *                 CSF011A            Date 28Nov11               *
003200200528      *                 CRE073             Date 06Dec10               *
003300200528      *                 CER055             Date 06Dec10               *
003400200528      *                 CRE075             Date 06Dec10               *
003500200528      *                 AR702741           Date 02Feb11               *
003600200528      *                 CER059             Date 19Jul10               *
003700200528      *                 BUG24157           Date 04Jun09               *
003800200528      *                 CER047             Date 19May08               *
003900200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
004000200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
004100200528      * Midas Plus 1.4 Base ------------------------------------------*
004200200528      * Midas Plus 1.3 ----------- Base ------------------------------*
004300200528      *                 CSD031             Date 10Apr06               *
004400200528      *                 CSD027             Date 09Dec05               *
004500200528      *                 BUG8550            Date 05Oct05               *
004600200528      *                 CAP086             Date 08Jun05               *
004700200528      *                 CSW037A            Date 02May05               *
004800200528      *                 CSD025             Date 11Jan05               *
004900200528      *                 CSW037             Date 15Dec04               *
005000200528      *                 CSW036             Date 15Dec04               *
005100200528      *                 CLE025             Date 20Oct03               *
005200200528      *                 CGL029             Date 01Sep03               *
005300200528      *                 208221             Date 11Dec02               *
005400200528      * Midas Release 4.01 -------------------------------------------*
005500200528      *                 CSC011             Date 18Sep01               *
005600200528      * Midas Release 4 --------------- Base -------------------------*
005700200528      * Midas DBA 3.05 -----------------------------------------------*
005800200528      *                 180721             Date 03May00               *
005900200528      *                 CUT009             Date 19Feb01               *
006000200528      * Midas DBA 3.02 -----------------------------------------------*
006100200528      *                 CFT004             Date 12Nov99               *
006200200528      *                 CPB001             Date 23Aug99               *
006300200528      *                 CAP035  *CREATE    Date 19Mar99               *
006400200528      *                                                               *
006500200528      *---------------------------------------------------------------*
006600200528      *                                                               *
006700200528      *  252664 - Do not set to blanks field DDNCID                   *
006800200528      *  250822 - Used the day number from ToF and ensure that        *
006900200528      *           ZFREQB2 is called. Patterned fix after 210058.      *
007000200528      *  CER050 - Annualised Percentage Rate (Recompile)              *
007100200528      *  MD053611 - Add validation when changing the interest         *
007200200528      *             calculation type.                                 *
007300200528      *  MD046248 - Finastra Rebranding                               *
007400200528      *  MD047680 - Prevent validation of authority to the account    *
007500200528      *             branch if branch value is blank                   *
007600200528      *  MD046635 - User permissions are not verified on account      *
007700200528      *             input via AMAD API. Change the validation so that *
007800200528      *             the user inserting an account is always validated *
007900200528      *             to have authority to the branch of the account.   *
008000200528      *  MD020938 - Create new system values to check the branch/user *
008100200528      *             authority.                                        *
008200200528      *  CGL165 - Dual Withholding Tax (Recompile)                    *
008300200528      *  CRE090 - Delay Capitalisation of Interest                    *
008400200528      *  MD024398 - API Performance Optimisation                      *
008500200528      *  MD000091 - Event Codes Substitution                          *
008600200528      *  AR947093A - Base Rate amendment resulted to 0 interest rate  *
008700200528      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
008800200528      *  AR944106 - Incorrect spread as calculated by the system      *
008900200528      *  AR847249 - Negative interest is shown in the main list and   *
009000200528      *             Loan Details enquiry screen                       *
009100200528      *  AR854615 - Contractual spread indicator is always +          *
009200200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
009300200528      *            (Recompile)                                        *
009400200528      *  CRE073 - Interest Rate Rounding                              *
009500200528      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
009600200528      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
009700200528      *  AR702741 - Include location as parameter in ZFREQB to        *
009800200528      *             determine the next settlement date                *
009900200528      *             (Child: AR702742)                                 *
010000200528      *  CER059 - German Feature Upgrade to Delhi                     *
010100200528      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
010200200528      *             when field is set to Y (Recompile)                *
010300200528      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
010400200528      *           (Recompile)                                         *
010500200528      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
010600200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
010700200528      *  BUG8550 - Reposition capture of ZMUSER data area             *
010800200528      *  CAP086 - Introduce Auto Authorisation to the API's           *
010900200528      *           without it. (Recompile)                             *
011000200528      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
011100200528      *  CSD025 - Customer De-Activation                              *
011200200528      *  CSW037 - Additional Field Data on MT300/MT320                *
011300200528      *  CSW036 - Dual SWIFT BIC held on Client Details               *
011400200528      *  CLE025 - Credit Lines (Recompile)                            *
011500200528      *  CGL029 - Increase Account Code to 10 digits                  *
011600200528      *  208221 - Default Margin from Rate/Spread changes             *
011700200528      *  CSC011 - 24x7 Midas Availability                             *
011800200528      *  180721 - Default "Next Statement Date" when opening          *
011900200528      *           Account coming from interface                       *
012000200528      *         - Retail Account Number must be calculated            *
012100200528      *  CUT009 - Manual addition of core hooks.                      *
012200200528      *  CFT004 - Straight Through Processing Phase 2.                *
012300200528      *         - International Bank Account Numbers(Recompile Only)  *
012400200528      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
012500200528      *           Recompiled due to database changes                  *
012600200528      *  CAP035 - Midas/ToF Interface                                 *
012700200528      *                                                               *
012800200528      *****************************************************************
012900200528      ** +--------------------------------------+
013000200528      ** ¦ F-specs                              ¦
013100200528      ** ¦ =======                              ¦
013200200528      ** +--------------------------------------+
013300200528      *****************************************************************
013400200528     F/COPY WNCPYSRC,GLAMA3VF01
013500200528
013600200528      *****************************************************************
013700200528      ** +--------------------------------------+
013800200528      ** ¦ Automatically included D-specs       ¦
013900200528      ** ¦ ==============================       ¦
014000200528      ** +--------------------------------------+
014100200528      **
014200200528      ** Standard D-specs
014300200528      ** ================
014400200528      **
014500200528      ** The following /COPY line includes the LDA layout,
014600200528      ** the copyright array definition,
014700200528      ** and the following named constants:
014800200528      **    True       logical = *on (for indcator processing)
014900200528      **    False      logical = *off (for indcator processing)
015000200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
015100200528      **                                    handler)
015200200528      ** and the following variables:
015300200528      **    RunBefore  1A (for the PSSR)
015400200528
015500200528     D/COPY ZACPYSRC,STD_D_SPEC
015600200528
015700200528      ** Program Status Data Structure
015800200528      ** =============================
015900200528      ** The following /COPY line includes all the defined fields in the
016000200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
016100200528
016200200528     D/COPY ZACPYSRC,PSDS
016300200528      ** The following /COPY line includes definitions for the above fields
016400200528      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
016500200528      ** corresponding fields in the PSDS /COPY member, so that member
016600200528      ** must be included where this one is used.
016700200528
016800200528     D/COPY ZACPYSRC,PROCPARMS
016900200528
017000200528      **--------------------------------------------------------------------------------------------
017100200528      ** The following /COPY line includes the definitions for error and
017200200528      ** warning message arrays.
017300200528     D/COPY ZACPYSRC,ERR_ARRAYS
017400200528      **--------------------------------------------------------------------------------------------
017500200528
017600200528      ** +--------------------------------------+
017700200528      ** ¦ End of automatically included D-specs¦
017800200528      ** ¦ =====================================¦
017900200528      ** +--------------------------------------+
018000200528
018100200528      *****************************************************************
018200200528      /EJECT
018300200528      *****************************************************************
018400200528
018500200528      ** +--------------------------------------+
018600200528      ** ¦ Manually included D-specs            ¦
018700200528      ** ¦ =========================            ¦
018800200528      ** +--------------------------------------+
018900200528
019000200528      ** +--------------------------------------+
019100200528      ** ¦ Named constants                      ¦
019200200528      ** ¦ ===============                      ¦
019300200528      ** +--------------------------------------+
019400200528
019500200528      ** The maximum size of the appended error arrays
019600200528     D XArrayMax       C                   CONST(20)
019700200528
019800200528      ** +--------------------------------------+
019900200528      ** ¦ Arrays and Data Structures           ¦
020000200528      ** ¦ ==========================           ¦
020100200528      ** +--------------------------------------+
020200200528
020300200528      ** Array of Fields in error.
020400200528     D FldNamXAr       S             10A   DIM(XArrayMax)
020500200528
020600200528      ** Array of error message IDs
020700200528     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
020800200528
020900200528      ** Array of error message data.
021000200528     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
021100200528
021200200528      ** Array of Fields with warnings.                                                     AR847249
021300200528     D WFldNmXAr       S             10A   DIM(XArrayMax)                                   AR847249
021400200528                                                                                            AR847249
021500200528      ** Array of warning message IDs                                                       AR847249
021600200528     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                      AR847249
021700200528                                                                                            AR847249
021800200528      ** Array of warning message data.                                                     AR847249
021900200528     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                    AR847249
022000200528                                                                                            AR847249
022100200528      ** Flags to indicate whether transaction fields are valid
022200200528     D OKFlagsDS       DS
022300200528     D  DDCRIBOK                      1A
022400200528     D  DDCRISOK                      1A
022500200528     D  DDCSIGOK                      1A
022600200528     D  DDCICTOK                      1A
022700200528     D  DDCCSTOK                      1A
022800200528     D  DDCRCDOK                      1A
022900200528     D  DDCRICOK                      1A
023000200528     D  DDNCIDOK                      1A
023100200528     D  DDCRIFOK                      1A
023200200528     D  DDCNCDOK                      1A
023300200528     D  DDCRBROK                      1A
023400200528     D  DDCACPOK                      1A
023500200528     D  DDCHGTOK                      1A
023600200528     D  DDCHSTOK                      1A
023700200528     D  DDCHBROK                      1A
023800200528     D  DDCHCPOK                      1A
023900200528     D  DDTCHOOK                      1A
024000200528     D  DDCCSPOK                      1A                                                      CRE073
024100200528     D  DDCCSGOK                      1A                                                      CRE073
024200200528     D  DDCRMTOK                      1A                                                      CRE073
024300200528     D  DDCRFDOK                      1A                                                      CRE073
024400200528
024500200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
024600200528      ** EXTERNAL DS FOR BANK DETAILS
024700200528                                                                                180721
024800200528     D SDGELR        E DS                  EXTNAME(SDGELRPD)                    180721
024900200528      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS                                 180721
025000200528
025100200528     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
025200200528      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
025300200528
025400200528     D SDRETL        E DS                  EXTNAME(SDRETLPD)
025500200528     D SDRETLACCD    E                     EXTFLD(QQACCD)                                     CGL029
025600200528      ** EXTERNAL DS FOR RETAIL DETAILS
025700200528
025800200528     D SDCURR        E DS                  EXTNAME(SDCURRPD)
025900200528      ** EXTERNAL DS FOR CURRENCY DETAILS
026000200528                                                                                180721
026100200528     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    180721
026200200528      ** EXTERNAL DS FOR CUSTOMER DETAILS                                       180721
026300200528
026400200528     D DSFDY         E DS                  EXTNAME(DSFDY)
026500200528      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
026600200528
026700200528     D DSSDY         E DS                  EXTNAME(DSSDY)
026800200528      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
026900200528                                                                                180721
027000200528     DDSLDY          E DS                  EXTNAME(DSLDY)                       180721
027100200528      ** THIRD DS FOR ACCESS PROGRAMS, VERY LONG DATA STRUCTURE                 180721
027200200528
027300200528     D ValidAccn     E DS                  EXTNAME(GLVAMADPD)
027400200528      * Valid Account layout -> ACCNTAB
027500200528
027600200528     D ValidExRI     E DS                  EXTNAME(GLVAMRIPD)
027700200528     D GLRIACOD      E                     EXTFLD(QQACOD)                                     CGL029
027800200528      * Valid Extn. Account layout -> REIACD
027900200528                                                                                              208221
028000200528     D ValidExBX     E DS                  EXTNAME(GLVAMBXPD)                                 208221
028100200528     D GLBXACOD      E                     EXTFLD(QQACOD)                                     CGL029
028200200528      * Valid Extn. Account layout -> ACCNTBXC                                                208221
028300200528                                                                                              208221
028400200528     D TranIn4       E DS                  EXTNAME(GLAMCOPD)                                  208221
028500200528      * Incoming Transaction (screen 4)                                                       208221
028600200528
028700200528     D TranIn3       E DS                  EXTNAME(GLAMCIPD)
028800200528      * Incoming Transaction (screen 3)
028900200528
029000200528     D TranIn1       E DS                  EXTNAME(GLAMADPD)
029100200528      * Incoming Transaction (screen 1)
029200200528
029300200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
029400200528      ** External DS for SAR Details                                                          CSC011
029500200528                                                                                              CSC011
029600200528     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
029700200528      ** 24X7 status data area                                                                CSC011
029800200528                                                                                              CSC011
029900200528     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
030000200528      ** SD data area                                                                         CSC011
030100200528                                                                                              CSC011
030200200528     D ZMUSER          DS            17
030300200528      * ZMUSER data layout
030400200528     D  DBRN                  11     13
030500200528
030600200528      ** +--------------------------------------+
030700200528      ** ¦ Declared variables                   ¦
030800200528      ** ¦ ==================                   ¦
030900200528      ** +--------------------------------------+
031000200528
031100200528      **                                                                                    MD000091
031200200528     D BChar           DS                                                                   MD000091
031300200528     D   BLen                  1      2B 0                                                  MD000091
031400200528     D   LenStr                1      2                                                     MD000091
031500200528     D   MsgDtaTmp                   99                                                     MD000091
031600200528                                                                                            MD000091
031700200528      ** Index for arrays of of error message ids etc
031800200528     D Idx             S              3P 0
031900200528     D WIx             S              3P 0                                                  AR847249
032000200528     D Indx            S              3P 0                                                    CRE073
032100200528
032200200528      ** Fields defined for Enhancement CSC011                                                CSC011
032300200528     D CSC011          S              1A                                                      CSC011
032400200528     D PRtCd           S              7A                                                      CSC011
032500200528     D POptn           S              7A                                                      CSC011
032600200528     D PSard           S              6A                                                      CSC011
032700200528     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
032800200528                                                                                              CSC011
032900200528      ** CER055 Overdraft Processing Flag                                                     CER055
033000200528     D CER055          S              1A                                                      CER055
033100200528     D CRE073          S              1A   INZ('N')                                           CRE073
033200200528     D TMCNSP          S             11P 7                                                    CRE073
033300200528     D NEWSRT          S             11P 7                                                    CRE073
033400200528     D WSPREAD         S             11P 7                                                    CRE073
033500200528     D NEWFRT          S             11P 7                                                  AR847249
033600200528     D PModule         S              6A                                                      CRE073
033700200528     D PCurset         S              2P 0                                                    CRE073
033800200528     D CRE090          S              1A   INZ('N')                                           CRE090
033900200528      ** Constant paramater for AOSVALR0                                                    MD020938
034000200528     D BRCUSR          C                   CONST('CheckBrchUserAuthori')                    MD020938
034100200528     D CurSysVal       DS           200                                                     MD020938
034200200528     D CurVal                  1      1                                                     MD020938
034300200528      ** +--------------------------------------+
034400200528      ** ¦ End of D-specs                       ¦
034500200528      ** ¦ ==============                       ¦
034600200528      ** +--------------------------------------+
034700200528
034800200528      ** +----------------------------------------+
034900200528      ** ¦ Hook for non-core D-specs (all types)  ¦
035000200528      ** ¦ also any I-specs (if necessary)        ¦
035100200528      ** ¦ =====================================  ¦
035200200528      ** +----------------------------------------+
035300200528
035400200528      *****************************************************************
035500200528      /EJECT
035600200528      ** +--- Start of Main processing -----------------------------------+
035700200528      ** ¦                                                                ¦
035800200528      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
035900200528      ** ¦ executed at program activation.                                ¦
036000200528      ** ¦                                                                ¦
036100200528      ** +----------------------------------------------------------------+
036200200528                                                                                             BUG8550
036300200528      **  GET ZMUSER to access default branch.                                               BUG8550
036400200528                                                                                             BUG8550
036500200528     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
036600200528     C                   IN        ZMUSER                                                    BUG8550
036700200528     C                   UNLOCK    ZMUSER                                                    BUG8550
036800200528
036900200528     C                   Z-Add     0             WWCBRT           11 7
037000200528     C                   Z-ADD     0             WWBRTT           11 7                      AR944106
037100200528     C                   Move      DDCRCD        WWCRCD            6
037200200528      *
037300200528     C                   Move      *Off          WIN44             1
037400200528     C     RINOALT       IfGT      0
037500200528     C                   Move      *On           WIN44
037600200528     C                   Endif
037700200528      *
037800200528      ** Access Currency details via access program
037900200528      *  (database error handling done in access program)
038000200528     C                   CALLB     'AOCURRR0'
038100200528     C                   PARM      '*DBERR '     @RTCD
038200200528     C                   PARM      '*KEY   '     @OPTN
038300200528     C                   PARM      DDCCY         @CCY              3
038400200528     C     SDCURR        PARM      SDCURR        DSSDY
038500200528
038600200528      * Call Validation Modules in Sequence
038700200528
038800200528      ** Validate Base Rate Type
038900200528      /COPY WNCPYSRC,GLAMAD3V01                                                               CUT009
039000200528     C                   EXSR      VBRATE
039100200528      *                                                                                       CRE073
039200200528     C                   IF        CRE073 = 'Y'                                               CRE073
039300200528                                                                                              CRE073
039400200528     C                   EVAL      PModule = 'AMADCr'                                         CRE073
039500200528                                                                                              CRE073
039600200528      ** Validate Contractual Spread/Sign                                                     CRE073
039700200528                                                                                              CRE073
039800200528     C                   EXSR      SRSPSG                                                     CRE073
039900200528                                                                                              CRE073
040000200528      ** Validate Rounding Method                                                             CRE073
040100200528                                                                                              CRE073
040200200528     C                   IF        DDCCSPOK <> 'N'                                            CRE073
040300200528     C                   EXSR      SRRNDM                                                     CRE073
040400200528                                                                                              CRE073
040500200528      ** Validate Rounding Fraction/Decimal                                                   CRE073
040600200528                                                                                              CRE073
040700200528     C                   EXSR      SRRNDF                                                     CRE073
040800200528                                                                                              CRE073
040900200528      ** If all interest rate rounding related fields are valid                               CRE073
041000200528      ** compute for the new spread rate                                                      CRE073
041100200528                                                                                              CRE073
041200200528     C                   IF        DDCCSPOK <> 'N' AND                                        CRE073
041300200528     C                             DDCCSGOK <> 'N' AND                                        CRE073
041400200528     C                             DDCRMTOK <> 'N' AND                                        CRE073
041500200528     C                             DDCRFDOK <> 'N'                                            CRE073
041600200528     C                   EXSR      SRSPRT                                                     CRE073
041700200528                                                                                              CRE073
041800200528     C                   ENDIF                                                                CRE073
041900200528     C                   ENDIF                                                                CRE073
042000200528      *                                                                                       CRE073
042100200528     C                   ELSE                                                                 CRE073
042200200528      /COPY WNCPYSRC,GLAMAD3V02                                                               CUT009
042300200528      ** Validate Rate/Spread & Sign
042400200528      /COPY WNCPYSRC,GLAMAD3V03                                                               CUT009
042500200528     C                   EXSR      VSRATE
042600200528     C                   ENDIF                                                                CRE073
042700200528      *                                                                                       CRE073
042800200528      /COPY WNCPYSRC,GLAMAD3V04                                                               CUT009
042900200528      ** Validate Interest Calc. Type/Subtype
043000200528      /COPY WNCPYSRC,GLAMAD3V05                                                               CUT009
043100200528     C                   EXSR      VICALC
043200200528      /COPY WNCPYSRC,GLAMAD3V06                                                               CUT009
043300200528      ** Validate This Change Value Date
043400200528      /COPY WNCPYSRC,GLAMAD3V07                                                               CUT009
043500200528     C**********         IF        CRE015 = 'N' OR                                AR947093 AR947093A
043600200528     C**********                   X5ATTY <>'P'                                   AR947093 AR947093A
043700200528     C                   EXSR      VCVDAT
043800200528     C**********         ENDIF                                                    AR947093 AR947093A
043900200528      /COPY WNCPYSRC,GLAMAD3V08                                                               CUT009
044000200528      ** Validate Calculation Basis
044100200528      /COPY WNCPYSRC,GLAMAD3V09                                                               CUT009
044200200528     C                   EXSR      VICALB
044300200528      /COPY WNCPYSRC,GLAMAD3V10                                                               CUT009
044400200528      ** Validate Next Capitalisation Date, Frequency & Day no.
044500200528      /COPY WNCPYSRC,GLAMAD3V11                                                               CUT009
044600200528     C                   EXSR      VNXCAP
044700200528      /COPY WNCPYSRC,GLAMAD3V12                                                               CUT009
044800200528      ** Validate Alternate A/C Cr. Interest Branch and Account
044900200528      /COPY WNCPYSRC,GLAMAD3V13                                                               CUT009
045000200528     C                   EXSR      VBRACP
045100200528      /COPY WNCPYSRC,GLAMAD3V14                                                               CUT009
045200200528      ** Validate Overdraft
045300200528      /COPY WNCPYSRC,GLAMAD3V15                                                               CUT009
045400200528     C                   EXSR      VCHRGS
045500200528      /COPY WNCPYSRC,GLAMAD3V16                                                               CUT009
045600200528      *
045700200528      *  *-------------------------------------------------------*
045800200528      *  * If no errors set up outstanding fields for valid file *
045900200528      *  *-------------------------------------------------------*
046000200528
046100200528     C                   IF        Idx = 0
046200200528     C                   EXSR      SetupValid
046300200528     C                   Else
046400200528     C                   Move      WWCRCD        DDCRCD
046500200528     C                   ENDIF
046600200528      *
046700200528      * RETURN
046800200528      *
046900200528     C                   RETURN
047000200528      *****************************************************************
047100200528     C/EJECT
047200200528      *****************************************************************
047300200528      ** VBRATE - Validate Base Rate Type
047400200528      *****************************************************************
047500200528     C     VBRATE        BEGSR
047600200528
047700200528      * Reset variables updated by each module
047800200528
047900200528     C                   EXSR      RESETERRS
048000200528      *
048100200528     C                   CALLB     'GLVCRBS'
048200200528      *
048300200528      * INPUTS
048400200528      *
048500200528      ** Return Code
048600200528     C                   PARM                    RetCodeOut
048700200528      *
048800200528      ** Account Screen fields
048900200528     C                   Parm                    DDCRIB
049000200528     C                   Parm                    DDCCY
049100200528     C                   Parm                    DDDACO
049200200528     C                   Parm                    DDCICT
049300200528     C                   Parm                    DDCCST
049400200528     C                   Parm                    DDCRIS                         180721
049500200528      *
049600200528      ** ICD
049700200528     C                   Parm                    BJDFIN
049800200528      *                                                                         180721
049900200528      ** Supplemental Validation for PB Customer (Y/N)                          180721
050000200528     C                   Parm                    WValforPB                      180721
050100200528      *
050200200528      * OUTPUTS
050300200528      *
050400200528      * Error fields/message IDs/message data (arrays) from/to caller
050500200528     C                   PARM                    FldNamXAr
050600200528     C                   PARM                    MsgIDXAr
050700200528     C                   PARM                    MsgDtaXAr
050800200528      *
050900200528     C                   Parm      *ZERO         WWVCRC            5 0
051000200528     C                   Parm                    WWCBRT
051100200528     C                   PARM                    WWBRTT                                     AR944106
051200200528      *
051300200528      ** Base Rate Type - OK
051400200528     C                   Parm                    DDCRIBOk
051500200528
051600200528      * Update error info with that returned from the validation module
051700200528
051800200528     C                   EXSR      UPDATERRS
051900200528      *
052000200528     C                   ENDSR
052100200528      *****************************************************************
052200200528     C/EJECT
052300200528      *****************************************************************
052400200528      *  VSRATE - Validate Rate/Spread & Sign
052500200528      *****************************************************************
052600200528     C     VSRATE        BEGSR
052700200528
052800200528      * Reset variables updated by each module
052900200528
053000200528     C                   EXSR      RESETERRS
053100200528      *
053200200528     C                   CALLB     'GLVCRRT'
053300200528      *
053400200528      * INPUTS
053500200528      *
053600200528      ** Return Code
053700200528     C                   PARM                    RetCodeOut
053800200528      *
053900200528      ** Account Screen fields
054000200528     C                   Parm                    DDCRIS
054100200528     C                   Parm                    DDCSIG
054200200528     C                   Parm                    DDCICT
054300200528     C                   Parm                    DDCCST
054400200528      *
054500200528      * OUTPUTS
054600200528      *
054700200528      * Error fields/message IDs/message data (arrays) from/to caller
054800200528     C                   PARM                    FldNamXAr
054900200528     C                   PARM                    MsgIDXAr
055000200528     C                   PARM                    MsgDtaXAr
055100200528      *
055200200528     C                   Parm      *ZERO         WNCRIS           11 7
055300200528      *
055400200528      ** Rate/Spread - OK
055500200528      ** Rate/Spread Sign - OK
055600200528     C                   Parm                    DDCRISOk
055700200528     C                   Parm                    DDCSIGOk
055800200528
055900200528      * Update error info with that returned from the validation module
056000200528
056100200528     C                   EXSR      UPDATERRS
056200200528      *
056300200528     C                   ENDSR
056400200528      *****************************************************************
056500200528     C/EJECT
056600200528      *****************************************************************
056700200528      ** VICALC - Validate Interest Calc. Type/Subtype
056800200528      *****************************************************************
056900200528     C     VICALC        BEGSR
057000200528
057100200528      * Reset variables updated by each module
057200200528
057300200528     C                   EXSR      RESETERRS
057400200528      *
057500200528     C                   CALLB     'GLVCRIT02'
057600200528      *
057700200528      * INPUTS
057800200528      *
057900200528      ** Return Code
058000200528     C                   PARM                    RetCodeOut
058100200528      *
058200200528      ** Account Screen fields
058300200528     C                   Parm                    DDCICT
058400200528     C                   Parm                    DDCCST
058500200528     C                   Parm                    DDCRIB
058600200528     C                   Parm                    DDCRIS
058700200528     C                   Parm                    DDCSIG
058800200528     C                   Parm                    DDCCY
058900200528     C                   PARM                    DDCUSN                                     MD053611
059000200528     C                   PARM                    DDACOD                                     MD053611
059100200528     C                   PARM                    DDBRCA                                     MD053611
059200200528     C                   PARM                    DDACSQ                                     MD053611
059300200528      *
059400200528     C                   Parm                    WWVCRC
059500200528     C                   Parm                    WWCBRT
059600200528     C                   Parm                    CER055                                       CER055
059700200528      *
059800200528      * OUTPUTS
059900200528      *
060000200528      * Error fields/message IDs/message data (arrays) from/to caller
060100200528     C                   PARM                    FldNamXAr
060200200528     C                   PARM                    MsgIDXAr
060300200528     C                   PARM                    MsgDtaXAr
060400200528      * Warning fields/message IDs/message data (arrays) from/to caller                     MD053611
060500200528     C                   PARM                    WFldNmXAr                                  MD053611
060600200528     C                   PARM                    WMsgIDXAr                                  MD053611
060700200528     C                   PARM                    WMsgDtXAr                                  MD053611
060800200528      *
060900200528      ** Interest Calc. Type - Ok
061000200528      ** Interest Calc. Subtype - Ok
061100200528     C                   Parm                    DDCICTOk
061200200528     C                   Parm                    DDCCSTOk
061300200528      *
061400200528
061500200528      * Update error info with that returned from the validation module
061600200528
061700200528     C                   EXSR      UPDATERRS
061800200528      *
061900200528     C                   ENDSR
062000200528      *****************************************************************
062100200528     C/EJECT
062200200528      *****************************************************************
062300200528      *  VCVDAT - Validate This Change Value Date
062400200528      *****************************************************************
062500200528     C     VCVDAT        BEGSR
062600200528
062700200528      * Reset variables updated by each module
062800200528
062900200528     C                   EXSR      RESETERRS
063000200528                                                                                180721
063100200528     C     WValforPB     Ifeq      'Y'                                          180721
063200200528     C     DDCRCD        Andeq     *Blanks                                      180721
063300200528     C     DDACTN        Andeq     'I'                                          180721
063400200528     C     WWID          Andeq     'TO'                                         180721
0635002005283676  *                                                                         180721
0636002005283677  **   Convert Day Number to Date                                           180721
0637002005283678 C                   Callb     'ZDATE2'                                     180721
063800200528     C**********         parm      BJRDNB        ZDAYNO                                180721 CSC011
063900200528     C                   PARM      WRunDay       ZDAYNO                                       CSC011
064000200528     C                   parm                    BJDFIN                         180721
064100200528     C                   parm                    ZNDATE            6 0          180721
064200200528     C                   parm                    ZADATE            7            180721
064300200528                                                                                180721
064400200528     C                   movel     ZNDATE        DDCRCD                         180721
064500200528     C                   Endif                                                  180721
064600200528      *
064700200528     C                   CALLB     'GLVCRDT'
064800200528      *
064900200528      * INPUTS
065000200528      *
065100200528      ** Return Code
065200200528     C                   PARM                    RetCodeOut
065300200528      *
065400200528      ** Account Screen fields
065500200528     C                   Parm                    DDCRCD
065600200528     C                   Parm                    DDACTN
065700200528     C                   Parm                    DDCRIB
065800200528     C                   Parm                    WNCRIS
065900200528     C                   Parm                    DDCICT
066000200528     C                   Parm                    DDCCST
066100200528     C                   Parm                    DDDACO
066200200528      *
066300200528     C                   Parm                    WWVCRC
066400200528      *
066500200528     C                   Parm                    AMCRIB
066600200528     C                   Parm                    AMCRIS
066700200528     C                   Parm                    AMOLCR
066800200528     C                   Parm                    RICICT
066900200528     C                   Parm                    RICCST
067000200528      *
067100200528      ** ICD
067200200528     C**********         Parm                    BJRDNB                                       CSC011
067300200528     C                   PARM                    WRunDay                                      CSC011
067400200528     C                   Parm                    BJDFIN
067500200528     C                   Parm                    WWBKVD
067600200528      * Front Office ID                                                         180721
067700200528     C**********         PARM                    APFOTranID                            180721 CGL029
067800200528     C                   PARM                    APFOTran40                                   CGL029
067900200528      *
068000200528      * OUTPUTS
068100200528      *
068200200528      * Error fields/message IDs/message data (arrays) from/to caller
068300200528     C                   PARM                    FldNamXAr
068400200528     C                   PARM                    MsgIDXAr
068500200528     C                   PARM                    MsgDtaXAr
068600200528      *
068700200528     C                   Parm      *ZERO         WNCRCD            5 0
068800200528      *
068900200528      ** This Change Value Date - Ok
069000200528     C                   Parm                    DDCRCDOk
069100200528
069200200528      * Update error info with that returned from the validation module
069300200528
069400200528     C                   EXSR      UPDATERRS
069500200528      *
069600200528     C                   ENDSR
069700200528      *****************************************************************
069800200528     C/EJECT
069900200528      *****************************************************************
070000200528      ** VICALB - Validate Calculation Basis
070100200528      *****************************************************************
070200200528     C     VICALB        BEGSR
070300200528
070400200528      * Reset variables updated by each module
070500200528
070600200528     C                   EXSR      RESETERRS
070700200528      *
070800200528     C                   CALLB     'GLVCRCC'
070900200528      *
071000200528      * INPUTS
071100200528      *
071200200528      ** Return Code
071300200528     C                   Parm                    RetCodeOut
071400200528      *
071500200528      ** Account Screen fields
071600200528     C                   Parm                    DDCRIC
071700200528     C                   Parm                    DDCRIB
071800200528     C                   Parm                    DDCRIS
071900200528     C                   Parm                    DDCSIG
072000200528     C                   Parm                    DDCICT
072100200528     C                   Parm                    DDCCST
072200200528      *
072300200528      ** Standing Data
072400200528     C                   PARM                    A6DICB
072500200528      *
072600200528      * OUTPUTS
072700200528      *
072800200528      * Error fields/message IDs/message data (arrays) from/to caller
072900200528     C                   PARM                    FldNamXAr
073000200528     C                   PARM                    MsgIDXAr
073100200528     C                   PARM                    MsgDtaXAr
073200200528      *
073300200528      ** Calculation Basis - OK
073400200528     C                   Parm                    DDCRICOk
073500200528
073600200528      * Update error info with that returned from the validation module
073700200528
073800200528     C                   EXSR      UPDATERRS
073900200528      *
074000200528     C                   ENDSR
074100200528      *****************************************************************
074200200528     C/EJECT
074300200528      *****************************************************************
074400200528      ** VNXCAP - Validate Next Capital. Date, Frequency & Day no
074500200528      *****************************************************************
074600200528     C     VNXCAP        BEGSR
074700200528     C**********         Eval      DDNCID = *blank                                     250822 252664
074800200528
074900200528      * Reset variables updated by each module
075000200528
075100200528     C                   EXSR      RESETERRS
075200200528                                                                                180721
075300200528     C     WValforPB     Ifeq      'Y'                                          180721
075400200528     C     DDNCID        Andeq     *Blanks                                      180721
075500200528                                                                                180721
075600200528     C*****DDCRIF        Ifeq      'D'                                                 180721 250822
075700200528     C     DDCRIF        Ifne      'D'                                                        250822
075800200528     C                   Movel     DDCNCD        ZMDAY                          180721
075900200528     C                   Else                                                   180721
076000200528     C                   Z-add     *zeros        ZMDAY                          180721
076100200528     C                   Endif                                                  180721
076200200528                                                                                180721
076300200528     C**********         CallB     'ZFREQB'                                            180721 250822
076400200528     C                   CallB     'ZFREQB2'                                                  250822
076500200528     C                   Parm      *blanks       RetCodeIn                      180721
076600200528     C                   Parm      DDCRIF        ZFREQ             1            180721
076700200528     C**********         Parm      BJRDNB        ZDAYNO            5 0                 180721 CSC011
076800200528     C                   PARM      WRunDay       ZDAYNO            5 0                        CSC011
076900200528     C                   Parm      DDCcy         ZCCY              3            180721
077000200528     C                   Parm      *BLANKS       ZLOC              3                        AR702741
077100200528     C                   Parm                    ZMDAY             2 0          180721
077200200528     C                   Parm                    BJDFIN                         180721
077300200528     C                   Parm      SDGELR        SDGELR                         180721
077400200528                                                                                180721
077500200528     C     RetCodeIn     Ifeq      *blanks                                      180721
077600200528     C     ZdayNo        Andne     *zeros                                       180721
0777002005283676  *                                                                         180721
0778002005283677  **   Convert Day Number to Date                                           180721
0779002005283678 C                   Callb     'ZDATE2'                                     180721
078000200528     C                   parm                    ZDAYNO                         180721
078100200528     C                   parm                    BJDFIN                         180721
078200200528     C                   parm                    ZNDATE            6 0          180721
078300200528     C                   parm                    ZADATE            7            180721
078400200528                                                                                180721
078500200528     C                   movel     ZNDATE        DDNCID                         180721
078600200528     C                   Endif                                                  180721
078700200528                                                                                180721
078800200528     C                   Move      *blanks       RetCodeIn                      180721
078900200528     C                   Endif                                                  180721
079000200528      *
079100200528     C                   CALLB     'GLVCRFQ'
079200200528      *
079300200528      * INPUTS
079400200528      *
079500200528      ** Return Code
079600200528     C                   Parm                    RetCodeOut
079700200528      *
079800200528      ** Account Screen fields
079900200528     C                   Parm                    DDNCID
080000200528     C                   Parm                    DDCRIF
080100200528     C                   Parm                    DDCNCD
080200200528     C                   Parm                    DDCRIB
080300200528     C                   Parm                    DDCRIS
080400200528     C                   Parm                    DDCSIG
080500200528     C                   Parm                    DDCICT
080600200528     C                   Parm                    DDCCST
080700200528     C                   Parm                    DDDACO
080800200528      *
080900200528      ** ICD
081000200528     C**********         Parm                    BJRDNB                                       CSC011
081100200528     C                   PARM                    WRunDay                                      CSC011
081200200528     C                   Parm                    BJDFIN
081300200528     C                   Parm                    BMLDAI
081400200528     C                   PARM                    CRE090                                       CRE090
081500200528     C/COPY WNCPYSRC,GLAMA3VC01
081600200528      *
081700200528      * OUTPUTS
081800200528      *
081900200528      * Error fields/message IDs/message data (arrays) from/to caller
082000200528     C                   PARM                    FldNamXAr
082100200528     C                   PARM                    MsgIDXAr
082200200528     C                   PARM                    MsgDtaXAr
082300200528      *
082400200528     C                   Parm      *ZERO         WNNCID            5 0
082500200528     C                   Parm      *ZERO         WNCRDY            2 0
082600200528      *
082700200528      ** Next Capitalisation Date - Ok
082800200528      ** Next Capitalisation Freq - Ok
082900200528      ** Next Capitalisation Day  - Ok
083000200528     C                   Parm                    DDNCIDOk
083100200528     C                   Parm                    DDCRIFOk
083200200528     C                   Parm                    DDCNCDOk
083300200528     C/COPY WNCPYSRC,GLAMA3VC02
083400200528
083500200528      * Update error info with that returned from the validation module
083600200528
083700200528     C                   EXSR      UPDATERRS
083800200528      *
083900200528     C                   ENDSR
084000200528      *****************************************************************
084100200528     C/EJECT
084200200528      *****************************************************************
084300200528      ** VBRACP - Validate Alternate A/C Dr. Interest Branch
084400200528      *****************************************************************
084500200528     C     VBRACP        BEGSR
084600200528
084700200528      * Reset variables updated by each module
084800200528
084900200528     C                   EXSR      RESETERRS
085000200528      *
085100200528     C                   CALLB     'GLVCRIT01'
085200200528      *
085300200528      * INPUTS
085400200528      *
085500200528      ** Return Code
085600200528     C                   Parm                    RetCodeOut
085700200528      *
085800200528      ** Account Screen fields
085900200528     C                   Parm                    DDCRBR
086000200528     C                   Parm                    DDCACP
086100200528     C                   Parm                    DDCRIB
086200200528     C                   Parm                    DDCSIG
086300200528     C                   Parm                    DDACNO
086400200528     C                   Parm                    DDBRCA
086500200528     C                   Parm                    DDACTN
086600200528     C                   Parm                    DDCUSN
086700200528     C                   Parm                    DDCCY
086800200528     C                   Parm                    DDACOD
086900200528     C                   Parm                    DDACSQ
087000200528      *
087100200528     C                   Parm                    WIN44
087200200528      *
087300200528      ** ICD
087400200528     C                   Parm                    DBRN
087500200528      *
087600200528      * OUTPUTS
087700200528      *
087800200528      * Error fields/message IDs/message data (arrays) from/to caller
087900200528     C                   PARM                    FldNamXAr
088000200528     C                   PARM                    MsgIDXAr
088100200528     C                   PARM                    MsgDtaXAr
088200200528      *
088300200528      ** Alternate Account Branch - Ok
088400200528      ** Alternate Account - Ok
088500200528      ** Rate Spread Sign - Ok
088600200528     C                   Parm                    DDCRBROk
088700200528     C                   Parm                    DDCACPOk
088800200528     C                   Parm                    DDCSIGOk
088900200528
089000200528      * Update error info with that returned from the validation module
089100200528
089200200528     C                   EXSR      UPDATERRS
089300200528
089400200528     C                   If        DDCRBROk = 'Y' AND                                       MD046635
089500200528     C                             DDCACPOk = 'Y' AND                                       MD046635
089600200528     C**********                   CurVal   = 'Y'                                  MD046635 MD047680
089700200528     C                             CurVal   = 'Y' AND                                       MD047680
089800200528     C                             DDCRBR <> *BLANKS                                        MD047680
089900200528                                                                                            MD046635
090000200528     C                   EXSR      RESETERRS                                                MD046635
090100200528     C                   MOVE      DDACTN        ZACTN                                      MD046635
090200200528     C                   CALL      'ZVACTBU'                                                MD046635
090300200528     C                   PARM                    ZACTN             1                        MD046635
090400200528     C                   PARM      DDCRBR        ZBR               3                        MD046635
090500200528     C                   PARM                    ERR               1 0                      MD046635
090600200528      *                                                                                     MD046635
090700200528      **   If action invalid for user                                                       MD046635
090800200528      *                                                                                     MD046635
090900200528     C     ERR           IFEQ      1                                                        MD046635
091000200528     C                   Z-ADD     1             I                                          MD046635
091100200528     C                   MOVEL     'DDCRBR'      FldNamXAr(I)                               MD046635
091200200528     C                   MOVEL     'RE71070'     MsgIDXAr(I)                                MD046635
091300200528     C                   ENDIF                                                              MD046635
091400200528                                                                                            MD046635
091500200528     C     ERR           IFEQ      2                                                        MD046635
091600200528     C                   Z-ADD     1             I                                          MD046635
091700200528     C     DDACTN        IFEQ      'I'                                                      MD046635
091800200528     C                   MOVEL     'DDCRBR'      FldNamXAr(I)                               MD046635
091900200528     C                   MOVEL     'RE7102B'     MsgIDXAr(I)                                MD046635
092000200528     C                   ENDIF                                                              MD046635
092100200528     C     DDACTN        IFEQ      'A'                                                      MD046635
092200200528     C                   MOVEL     'DDCRBR'      FldNamXAr(I)                               MD046635
092300200528     C                   MOVEL     'RE7103B'     MsgIDXAr(I)                                MD046635
092400200528     C                   ENDIF                                                              MD046635
092500200528     C     DDACTN        IFEQ      'D'                                                      MD046635
092600200528     C                   MOVEL     'DDCRBR'      FldNamXAr(I)                               MD046635
092700200528     C                   MOVEL     'RE7104B'     MsgIDXAr(I)                                MD046635
092800200528     C                   ENDIF                                                              MD046635
092900200528     C                   ENDIF                                                              MD046635
093000200528                                                                                            MD046635
093100200528     C     ERR           IFEQ      1                                                        MD046635
093200200528     C     ERR           OREQ      2                                                        MD046635
093300200528     C                   MOVE      'N'           DDCRBROk                                   MD046635
093400200528     C                   ENDIF                                                              MD046635
093500200528                                                                                            MD046635
093600200528     C                   EXSR      UPDATERRS                                                MD046635
093700200528     C                   ENDIF                                                              MD046635
093800200528      *                                                                                     MD020938
093900200528     C*****DDCRBR        IFEQ      *Blanks                                         MD020938 MD046635
094000200528     C*****BRIND         ANDEQ     'Y'                                             MD020938 MD046635
094100200528     C**********         MOVE      *BLANKS       BRIND                             MD020938 MD046635
094200200528     C**********         Move      ZBR           DDCRBR                            MD020938 MD046635
094300200528     C**********         ENDIF                                                     MD020938 MD046635
094400200528      *
094500200528     C                   ENDSR
094600200528      *****************************************************************
094700200528     C/EJECT
094800200528      *****************************************************************
094900200528      *  VCHRGS - Validate Charges
095000200528      *****************************************************************
095100200528     C     VCHRGS        BEGSR
095200200528
095300200528      * Reset variables updated by each module
095400200528
095500200528     C                   EXSR      RESETERRS
095600200528      *
095700200528     C                   CALLB     'GLVCHDE'
095800200528      *
095900200528      * INPUTS
096000200528      *
096100200528      ** Return Code
096200200528     C                   Parm                    RetCodeOut
096300200528      *
096400200528      ** Account Screen fields
096500200528     C                   Parm                    DDCHGT
096600200528     C                   Parm                    DDCHST
096700200528     C                   Parm                    DDCHBR
096800200528     C                   Parm                    DDCHCP
096900200528     C                   Parm                    DDTCHO
097000200528     C                   Parm                    DDACNO
097100200528     C                   Parm                    DDACTN
097200200528     C                   Parm                    DDBRCA
097300200528     C                   Parm                    DDCUSN
097400200528     C                   Parm                    DDCCY
097500200528     C                   Parm                    DDACOD
097600200528     C                   Parm                    DDACSQ
097700200528      *
097800200528     C                   Parm                    WIN44
097900200528      *
098000200528      ** ICD
098100200528     C                   Parm                    DBRN
098200200528     C                   Parm                    A6NBDP
098300200528     C                   Parm                    TCAL
098400200528      *
098500200528      * OUTPUTS
098600200528      *
098700200528      * Error fields/message IDs/message data (arrays) from/to caller
098800200528     C                   PARM                    FldNamXAr
098900200528     C                   PARM                    MsgIDXAr
099000200528     C                   PARM                    MsgDtaXAr
099100200528      *
099200200528     C                   PARM      *ZERO         WNTCHO            7 0
099300200528      *
099400200528      ** Charges Calculation Type - Ok
099500200528      ** Charges Calculation Subtype - Ok
099600200528      ** Alternate A/C Charges Branch - Ok
099700200528      ** Alternate A/C Charges Account - Ok
099800200528      ** Transaction Charges Override - Ok
099900200528     C                   Parm                    DDCHGTOk
100000200528     C                   Parm                    DDCHSTOk
100100200528     C                   Parm                    DDCHBROk
100200200528     C                   Parm                    DDCHCPOk
100300200528     C                   Parm                    DDTCHOOk
100400200528
100500200528      * Update error info with that returned from the validation module
100600200528
100700200528     C                   EXSR      UPDATERRS
100800200528                                                                                            MD046635
100900200528     C                   IF        DDCHBROk = 'Y' AND                                       MD046635
101000200528     C                             DDCHCPOk = 'Y' AND                                       MD046635
101100200528     C**********                   CurVal   = 'Y'                                  MD046635 MD047680
101200200528     C                             CurVal   = 'Y' AND                                       MD047680
101300200528     C                             DDCHBR <> *BLANKS                                        MD047680
101400200528                                                                                            MD046635
101500200528     C                   EXSR      RESETERRS                                                MD046635
101600200528                                                                                            MD046635
101700200528     C                   MOVE      DDACTN        ZACTN                                      MD046635
101800200528     C                   CALL      'ZVACTBU'                                                MD046635
101900200528     C                   PARM                    ZACTN                                      MD046635
102000200528     C                   PARM      DDCHBR        ZBR                                        MD046635
102100200528     C                   PARM                    ERR                                        MD046635
102200200528      *                                                                                     MD046635
102300200528      **   If action invalid for user                                                       MD046635
102400200528      *                                                                                     MD046635
102500200528     C     ERR           IFEQ      1                                                        MD046635
102600200528     C                   Z-ADD     1             I                                          MD046635
102700200528     C                   MOVEL     'DDCHBR'      FldNamXAr(I)                               MD046635
102800200528     C                   MOVEL     'RE71070'     MsgIDXAr(I)                                MD046635
102900200528     C                   ENDIF                                                              MD046635
103000200528      *                                                                                     MD046635
103100200528     C     ERR           IFEQ      2                                                        MD046635
103200200528     C                   Z-ADD     1             I                                          MD046635
103300200528     C     DDACTN        IFEQ      'I'                                                      MD046635
103400200528     C                   MOVEL     'DDCHBR'      FldNamXAr(I)                               MD046635
103500200528     C                   MOVEL     'RE7102B'     MsgIDXAr(I)                                MD046635
103600200528     C                   ENDIF                                                              MD046635
103700200528     C     DDACTN        IFEQ      'A'                                                      MD046635
103800200528     C                   MOVEL     'DDCHBR'      FldNamXAr(I)                               MD046635
103900200528     C                   MOVEL     'RE7103B'     MsgIDXAr(I)                                MD046635
104000200528     C                   ENDIF                                                              MD046635
104100200528     C     DDACTN        IFEQ      'D'                                                      MD046635
104200200528     C                   MOVEL     'DDCHBR'      FldNamXAr(I)                               MD046635
104300200528     C                   MOVEL     'RE7104B'     MsgIDXAr(I)                                MD046635
104400200528     C                   ENDIF                                                              MD046635
104500200528     C                   ENDIF                                                              MD046635
104600200528      *                                                                                     MD046635
104700200528     C     ERR           IFEQ      1                                                        MD046635
104800200528     C     ERR           OREQ      2                                                        MD046635
104900200528     C                   MOVE      'N'           DDCHBROk                                   MD046635
105000200528     C                   ENDIF                                                              MD046635
105100200528      *                                                                                     MD046635
105200200528     C                   EXSR      UPDATERRS                                                MD046635
105300200528     C                   ENDIF                                                              MD046635
105400200528      *                                                                                     MD020938
105500200528     C*****DDCRBR        IFEQ      *Blanks                                         MD020938 MD046635
105600200528     C*****BRIND         ANDEQ     'Y'                                             MD020938 MD046635
105700200528     C**********         MOVE      *BLANKS       BRIND                             MD020938 MD046635
105800200528     C**********         Move      ZBR           DDCRBR                            MD020938 MD046635
105900200528     C**********         ENDIF                                                     MD020938 MD046635
106000200528      *
106100200528     C                   ENDSR
106200200528      *****************************************************************                       CRE073
106300200528      /EJECT                                                                                  CRE073
106400200528      *****************************************************************                       CRE073
106500200528      *                                                               *                       CRE073
106600200528      *  SRSPSG - Validate Contractual Spread/Sign                    *                       CRE073
106700200528      *                                                               *                       CRE073
106800200528      *****************************************************************                       CRE073
106900200528     C     SRSPSG        BEGSR                                                                CRE073
107000200528                                                                                              CRE073
107100200528     C                   EXSR      RESETERRS                                                  CRE073
107200200528                                                                                              CRE073
107300200528     C                   CALL      'ZAVCSPSG'                                                 CRE073
107400200528     C                   PARM      *BLANKS       PRTCD                                        CRE073
107500200528     C                   PARM      *BLANKS       DDBASR           12                          CRE073
107600200528     C                   PARM      *BLANKS       DDBRTT            2                          CRE073
107700200528     C                   PARM      *BLANKS       DDFXRT           12                          CRE073
107800200528     C                   PARM                    DDCCSP                                       CRE073
107900200528     C                   PARM                    DDCCSG                                       CRE073
108000200528     C                   PARM      *ZEROS        TMCNSP                                       CRE073
108100200528     C                   PARM                    PModule                                      CRE073
108200200528     C                   PARM      *ZEROS        PCurset                                      CRE073
108300200528     C                   PARM                    FldNamXAr                                    CRE073
108400200528     C                   PARM                    MsgIDXAr                                     CRE073
108500200528     C                   PARM                    MsgDtaXAr                                    CRE073
108600200528     C                   PARM      *ZEROS        Indx                                         CRE073
108700200528     C                   PARM                    DDCCSPOK                                     CRE073
108800200528     C                   PARM                    DDCCSGOK                                     CRE073
108900200528                                                                                              CRE073
109000200528     C                   EXSR      UPDATERRS                                                  CRE073
109100200528                                                                                              CRE073
109200200528     C                   ENDSR                                                                CRE073
109300200528      *****************************************************************                       CRE073
109400200528      /EJECT                                                                                  CRE073
109500200528      *****************************************************************                       CRE073
109600200528      *                                                               *                       CRE073
109700200528      *  SRRNDM - Validate Rounding Method                            *                       CRE073
109800200528      *                                                               *                       CRE073
109900200528      *****************************************************************                       CRE073
110000200528     C     SRRNDM        BEGSR                                                                CRE073
110100200528                                                                                              CRE073
110200200528     C                   EXSR      RESETERRS                                                  CRE073
110300200528                                                                                              CRE073
110400200528     C                   CALL      'ZAVRNDMT'                                                 CRE073
110500200528     C                   PARM      *BLANKS       PRTCD                                        CRE073
110600200528     C                   PARM                    DDCRMT                                       CRE073
110700200528     C                   PARM                    DDCCSP                                       CRE073
110800200528     C                   PARM                    DDCRFD                                       CRE073
110900200528     C                   PARM                    PModule                                      CRE073
111000200528     C                   PARM      *ZEROS        PCurset                                      CRE073
111100200528     C                   PARM                    FldNamXAr                                    CRE073
111200200528     C                   PARM                    MsgIDXAr                                     CRE073
111300200528     C                   PARM                    MsgDtaXAr                                    CRE073
111400200528     C                   PARM      *ZEROS        Indx                                         CRE073
111500200528     C                   PARM                    DDCRMTOK                                     CRE073
111600200528                                                                                              CRE073
111700200528     C                   EXSR      UPDATERRS                                                  CRE073
111800200528                                                                                              CRE073
111900200528     C                   ENDSR                                                                CRE073
112000200528      *****************************************************************                       CRE073
112100200528      /EJECT                                                                                  CRE073
112200200528      *****************************************************************                       CRE073
112300200528      *                                                               *                       CRE073
112400200528      *  SRRNDF - Validate Fraction/Decimal                           *                       CRE073
112500200528      *                                                               *                       CRE073
112600200528      *****************************************************************                       CRE073
112700200528     C     SRRNDF        BEGSR                                                                CRE073
112800200528                                                                                              CRE073
112900200528     C                   EXSR      RESETERRS                                                  CRE073
113000200528                                                                                              CRE073
113100200528     C                   CALL      'ZAVRNDFD'                                                 CRE073
113200200528     C                   PARM      *BLANKS       PRTCD                                        CRE073
113300200528     C                   PARM                    DDCRFD                                       CRE073
113400200528     C                   PARM                    DDCCSP                                       CRE073
113500200528     C                   PARM                    DDCRMT                                       CRE073
113600200528     C                   PARM                    PModule                                      CRE073
113700200528     C                   PARM      *ZEROS        PCurset                                      CRE073
113800200528     C                   PARM                    FldNamXAr                                    CRE073
113900200528     C                   PARM                    MsgIDXAr                                     CRE073
114000200528     C                   PARM                    MsgDtaXAr                                    CRE073
114100200528     C                   PARM      *ZEROS        Indx                                         CRE073
114200200528     C                   PARM                    DDCRFDOK                                     CRE073
114300200528                                                                                              CRE073
114400200528     C                   EXSR      UPDATERRS                                                  CRE073
114500200528                                                                                              CRE073
114600200528     C                   ENDSR                                                                CRE073
114700200528      *****************************************************************                       CRE073
114800200528      /EJECT                                                                                  CRE073
114900200528      *****************************************************************                       CRE073
115000200528      *                                                               *                       CRE073
115100200528      *  SRSPRT - Compute for the new spread rate based on the        *                       CRE073
115200200528      *           rounding rules                                      *                       CRE073
115300200528      *                                                               *                       CRE073
115400200528      *****************************************************************                       CRE073
115500200528     C     SRSPRT        BEGSR                                                                CRE073
115600200528                                                                                              CRE073
115700200528     C                   IF        CRE015  = 'Y'  AND                                       AR947093
115800200528     C                             X5ATTY = 'P'                                             AR947093
115900200528     C**********         MOVE      AMCRIS        NEWSRT                           AR947093 AR947093A
116000200528     C**********         MOVE      AMCRIS        WNCRIS                           AR947093 AR947093A
116100200528     C                   CallB     'ZALIGN'                                                AR947093A
116200200528     C                   Parm                    ZAlignOk          1                       AR947093A
116300200528     C                   Parm      DDCRIS        ZField           16                       AR947093A
116400200528     C                   Parm      7             ZADec                                     AR947093A
116500200528     C                   Parm      4             ZADig             2 0                     AR947093A
116600200528     C                   IF        ZAlignOk = 'Y'                                          AR947093A
116700200528     C                   Move      ZField        NEWSRT                                    AR947093A
116800200528     C                   IF        DDCSIG  = '-'                                           AR947093A
116900200528     C                   MULT      -1            NEWSRT                                    AR947093A
117000200528     C                   ENDIF                                                             AR947093A
117100200528     C                   Z-ADD     NEWSRT        WNCRIS                                    AR947093A
117200200528     C                   ENDIF                                                             AR947093A
117300200528     C                                                                                     AR947093A
117400200528     C                   ELSE                                                               AR947093
117500200528     C                   CALL      'ZACALCSPRT'                                               CRE073
117600200528     C                   PARM      *BLANKS       PRTCD                                        CRE073
117700200528     C**********         PARM                    WWCBRT                              CRE073 AR944106
117800200528     C                   PARM                    WWBRTT                                     AR944106
117900200528     C                   PARM                    TMCNSP                                       CRE073
118000200528     C                   PARM                    DDCCSG                                       CRE073
118100200528     C                   PARM                    DDCRMT                                       CRE073
118200200528     C                   PARM                    DDCRFD                                       CRE073
118300200528     C                   PARM      *ZEROS        NEWSRT                                       CRE073
118400200528     C                   PARM      *ZEROS        NEWFRT                                     AR847249
118500200528                                                                                              CRE073
118600200528     C                   IF        PRTCD <> *BLANKS                                           CRE073
118700200528     C                   EXSR      *PSSR                                                      CRE073
118800200528     C                   ENDIF                                                                CRE073
118900200528                                                                                              CRE073
119000200528     C**********         IF        NEWFRT <= *ZEROS AND                            AR847249 AR947093
119100200528     C**********                   DDCRMT <> *BLANKS                               AR847249 AR947093
119200200528     C**********         EVAL      DDCRMTOK = 'N'                                  AR847249 AR947093
119300200528     C**********         EVAL      FldNamXAr(1) = 'DDCRMT'                         AR847249 AR947093
119400200528     C**********         EVAL      MsgIDXAr(1)  = 'USS0015'                        AR847249 AR947093
119500200528      **********                                                                   AR847249 AR947093
119600200528     C**********         EVAL      MsgDtaXAr(1) = %EDITC(NEWFRT:'J')               AR847249 AR947093
119700200528     C**********         EXSR      UPDATERRS                                       AR847249 AR947093
119800200528     C**********         ELSE                                                      AR847249 AR947093
119900200528     C                   IF        NEWSRT = *ZERO                                             CRE073
120000200528     C                   EVAL      DDCRIS = *BLANKS                                           CRE073
120100200528     C                   EVAL      DDCSIG = *BLANKS                                           CRE073
120200200528     C                   ELSE                                                                 CRE073
120300200528     C                   Z-ADD     *ZEROS        WSPREAD                                      CRE073
120400200528     C                   IF        NEWSRT < *ZERO                                             CRE073
120500200528                                                                                            AR847249
120600200528     C                   EVAL      DDCRISOK = 'W'                                           AR847249
120700200528     C                   EVAL      WFldNmXAr(1) = 'DDCRIS'                                  AR847249
120800200528     C                   EVAL      WMsgIDXAr(1) = 'USS0016'                                 AR847249
120900200528     C**********         EVAL      WMsgDtXAr(1) = %EDITC(NEWSRT:'J')               AR847249 MD000091
121000200528     C                   EVAL      MsgDtaTmp = %EDITC(NEWSRT:'J')                           MD000091
121100200528     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
121200200528     C                   EVAL      WMsgDtXAr(1) = LenStr +%TRIM(MsgDtaTmp)                  MD000091
121300200528     C                   EXSR      UPDATERRS                                                AR847249
121400200528     C**********         MOVE      '-'           DDCSIG                              CRE073 AR854615
121500200528     C**********         MOVE      '+'           DDCSIG                            AR854615 AR847249
121600200528     C                   IF        DDCCSG = '+'                                             AR847249
121700200528     C                   MOVE      '-'           DDCSIG                                       CRE073
121800200528     C                   ELSEIF    DDCCSG = '-'                                             AR847249
121900200528     C                   MOVE      '+'           DDCSIG                                     AR847249
122000200528     C                   ENDIF                                                              AR847249
122100200528                                                                                            AR847249
122200200528     C                   EVAL      WSPREAD = %ABS(NEWSRT)                                     CRE073
122300200528     C                   ELSE                                                                 CRE073
122400200528     C**********         MOVE      '+'           DDCSIG                              CRE073 AR854615
122500200528     C                   MOVE      DDCCSG        DDCSIG                                     AR854615
122600200528     C                   Z-ADD     NEWSRT        WSPREAD                                      CRE073
122700200528     C                   ENDIF                                                                CRE073
122800200528     C                   MOVE      *BLANKS       ZFIELD                                       CRE073
122900200528     C                   MOVE(P)   WSPREAD       ZFIELD                                       CRE073
123000200528     C                   Z-ADD     7             ZADEC                                        CRE073
123100200528     C                   CALLB     'ZEDIT'                                                    CRE073
123200200528     C                   PARM                    ZFIELD           16                          CRE073
123300200528     C                   PARM                    ZADEC             1 0                        CRE073
123400200528     C                   MOVE      ZFIELD        DDCRIS                                       CRE073
123500200528     C                   ENDIF                                                                CRE073
123600200528     C                   IF        DDCCSG = '-'                                             AR854615
123700200528     C**********                   AND NEWSRT > 0                                 AR854615 AR947093A
123800200528      ** Convert to positive for Negative spread rate                                       AR854615
123900200528     C**********                   OR  NEWSRT < 0                                 AR854615 AR947093A
124000200528     C                   MULT      -1            NEWSRT                                     AR854615
124100200528     C                   ENDIF                                                              AR854615
124200200528     C                   Z-ADD     NEWSRT        WNCRIS                                       CRE073
124300200528     C                   ENDIF                                                              AR847249
124400200528                                                                                              CRE073
124500200528     C                   ENDSR                                                                CRE073
124600200528      *****************************************************************
124700200528     C/EJECT
124800200528      /COPY WNCPYSRC,GLAMAD3V17                                                               CUT009
124900200528      *****************************************************************
125000200528     C/EJECT
125100200528      *****************************************************************
125200200528      *                                                               *
125300200528      * SETUPVALID - Set up additional fields that are needed on the  *
125400200528      *    Valid file record.                                         *
125500200528      *                                                               *
125600200528      *****************************************************************
125700200528
125800200528     C     SETUPVALID    BEGSR
125900200528      *
126000200528     C                   MOVE      DDCRIB        AMCRIB
126100200528      *                                                                                       CRE073
126200200528     C                   IF        CRE073 = 'Y'                                               CRE073
126300200528     C                   Z-ADD     TMCNSP        AMCCSP                                       CRE073
126400200528     C                   MOVEL     DDCCSG        AMCCSG                                       CRE073
126500200528     C                   MOVEL     DDCRMT        AMCRMT                                       CRE073
126600200528     C                   MOVEL     DDCRFD        AMCRFD                                       CRE073
126700200528     C                   Z-ADD     NEWSRT        AMCRIS                                       CRE073
126800200528      *                                                                                       CRE073
126900200528     C                   ELSE                                                                 CRE073
127000200528     C                   Z-ADD     WNCRIS        AMCRIS
127100200528     C                   ENDIF                                                                CRE073
127200200528     C                   Z-ADD     WNCRCD        AMCRCD
127300200528     C                   Move      DDCICT        RICICT
127400200528     C                   Move      DDCCST        RICCST
127500200528     C                   MOVE      DDCRIC        AMCRIC
127600200528     C                   Z-ADD     WNNCID        AMNCID
127700200528     C                   MOVE      DDCRIF        AMCRIF
127800200528     C                   Z-ADD     WNCRDY        AMCRDY
127900200528     C                   Move      DDCRBR        RICRBR
128000200528     C                   Move      DDCACP        RICACP
128100200528     C                   Move      DDCHBR        RICHBR
128200200528     C                   Move      DDCHCP        RICHAC
128300200528     C                   Move      DDCHGT        RICHGT
128400200528     C                   Move      DDCHST        RICHST
128500200528     C                   Z-ADD     WNTCHO        RITCHO
128600200528     C*                                                                                       208221
128700200528     C** Check if Revenue Analysis (CDE002) is present                                        208221
128800200528     C*                                                                                       208221
128900200528     C     CDE002        IFEQ      'Y'                                                        208221
129000200528     C*                                                                                       208221
129100200528     C** Only default on Insert. Note if the rate/spread is zero,                             208221
129200200528     C** the margin will default to zero                                                      208221
129300200528     C*                                                                                       208221
129400200528     C     DDACTN        IFEQ      'I'                                                        208221
129500200528     C     DDCRIB        IFNE      *BLANKS                                                    208221
129600200528     C                   Z-SUB     WNCRIS        BXCRMG                                       208221
129700200528     C                   MOVEL     'Y'           BXOVRC                                       208221
129800200528     C                   MOVEL     'Y'           DDOVRC                                       208221
129900200528     C                   MOVE      BXCRMG        ZFLD15                                       208221
130000200528     C                   EVAL      ZDECS= 7                                                   208221
130100200528     C                   CALLB     'ZSEDIT'                                                   208221
130200200528     C                   PARM                    ZFLD15           15 0                        208221
130300200528     C                   PARM                    ZDECS             1 0                        208221
130400200528     C                   PARM      *BLANKS       ZECODE            1                          208221
130500200528     C                   PARM                    ZOUT21           21                          208221
130600200528     C                   EVAL      DDCRMG= %SUBST(ZOUT21:10:12)                               208221
130700200528     C                   ELSE                                                                 208221
130800200528     C                   MOVEL     *BLANKS       BXCRMG                                       208221
130900200528     C                   MOVEL     *BLANKS       BXOVRC                                       208221
131000200528     C                   MOVEL     *BLANKS       DDCRMG                                       208221
131100200528     C                   MOVEL     *BLANKS       DDOVRC                                       208221
131200200528     C                   ENDIF                                                                208221
131300200528     C                   ENDIF                                                                208221
131400200528     C                   ENDIF                                                                208221
131500200528     C*                                                                                       208221
131600200528      *
131700200528     C                   ENDSR
131800200528      *****************************************************************
131900200528      /EJECT
132000200528      *****************************************************************
132100200528      * *INZSR - Program Initialisation routine                       *
132200200528      *****************************************************************
132300200528
132400200528     C     *INZSR        BEGSR
132500200528
132600200528     C     *ENTRY        PLIST
132700200528      * Transaction information (DS) from source system
132800200528     C                   PARM                    TranIn1
132900200528     C                   PARM                    TranIn3
133000200528     C                   PARM                    TranIn4                                      208221
133100200528      * ICD
133200200528     C                   PARM                    TCAL              1
133300200528      * Front Office ID                                                         180721
133400200528     C**********         PARM                    APFOTranID       20                   180721 CGL029
133500200528     C                   PARM                    APFOTran40       40                          CGL029
133600200528      * Field OK flags (DS) from/to caller
133700200528     C                   PARM                    OKFlagsDS
133800200528      * Error fields/message IDs/message data (arrays) from/to caller
133900200528     C                   PARM                    FldNameArr
134000200528     C                   PARM                    MsgIDArr
134100200528     C                   PARM                    MsgDtaArr
134200200528      * Array index (3P0) from/to caller
134300200528     C                   PARM                    Idx
134400200528      ** Warning fields/message IDs/message data (arrays) from/to caller                    AR847249
134500200528     C                   PARM                    WFldNamArr                                 AR847249
134600200528     C                   PARM                    WMsgIDArr                                  AR847249
134700200528     C                   PARM                    WMsgDtaArr                                 AR847249
134800200528      ** Array index (3P0) from/to caller                                                   AR847249
134900200528     C                   PARM                    WIx                                        AR847249
135000200528      * Valid Account layout (DS) from/to caller
135100200528     C                   PARM                    ValidAccn
135200200528     C                   PARM                    ValidExRI
135300200528     C                   PARM                    ValidExBX                      208221
135400200528      * Revenue Analysis                                                        208221
135500200528     C                   PARM                    CDE002            1            208221
135600200528     C                   PARM                    CRE015            1                        AR947093
135700200528     C                   PARM                    X5ATTY            1                        AR947093
135800200528      *
135900200528      **  GET ZMUSER to access default branch.
136000200528      *
136100200528     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
136200200528     C**********         IN        ZMUSER                                                    BUG8550
136300200528     C**********         UNLOCK    ZMUSER                                                    BUG8550
136400200528      *
136500200528      **  Move program name into *LDA field.
136600200528      *
136700200528     C     *LOCK         IN        LDA
136800200528     C                   MOVEL     'GLAMAD3VL'   DBPGM
136900200528     C                   OUT       LDA
137000200528      *
137100200528      ** Access Bank details via access program
137200200528      *  (database error handling done in access program)
137300200528     C                   CALLB     'AOBANKR0'
137400200528     C                   PARM      '*DBERR '     @RTCD
137500200528     C                   PARM      '*FIRST '     @OPTN
137600200528     C     SDBANK        PARM      SDBANK        DSFDY
137700200528      *                                                                         180721
137800200528      ** Access General Ledger details via access program                       180721
137900200528      *  (database error handling done in access program)                       180721
138000200528     C**********         CALLB     'AOGELRR0'                                   180721        CGL029
138100200528     C                   CALLB     'AOGELRR1'                                                 CGL029
138200200528     C                   PARM      '*DBERR '     @RTCD                          180721
138300200528     C                   PARM      '*FIRST '     @OPTN                          180721
138400200528     C*****SDGELR        PARM      SDGELR        DSFDY                          180721        CGL029
138500200528     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
138600200528      *
138700200528      ** Access MIDAS Modules details via access program
138800200528      *  (database error handling done in access program)
138900200528     C                   CALLB     'AOMMODR0'
139000200528     C                   PARM      '*DBERR '     @RTCD
139100200528     C                   PARM      '*FIRST '     @OPTN
139200200528     C     SDMMOD        PARM      SDMMOD        DSFDY
139300200528      *
139400200528      ** Access Retail details via access program
139500200528      *  (database error handling done in access program)
139600200528     C     BGRTBN        IFEQ      'Y'
139700200528     C                   CALLB     'AORETLR0'
139800200528     C                   PARM      '*DBERR '     @RTCD
139900200528     C                   PARM      '*FIRST '     @OPTN
140000200528     C     SDRETL        PARM      SDRETL        DSFDY
140100200528     C                   ENDIF
140200200528                                                                                              CSC011
140300200528      ** Check if CSC011 is installed                                                         CSC011
140400200528                                                                                              CSC011
140500200528      ** CSC011 is a redundant feature. No need to check it                                 MD024398
140600200528                                                                                            MD024398
140700200528     C                   EVAL      WRunDay = BJRDNB                                           CSC011
140800200528                                                                                              CSC011
140900200528     C**********         CALLB     'AOSARDR0'                                        CSC011 MD024398
141000200528     C**********         PARM      *BLANKS       PRtCd                               CSC011 MD024398
141100200528     C**********         PARM      '*VERIFY'     POptn                               CSC011 MD024398
141200200528     C**********         PARM      'CSC011'      PSard                               CSC011 MD024398
141300200528     C*****SCSARD        PARM      SCSARD        DSFDY                               CSC011 MD024398
141400200528      **********                                                                     CSC011 MD024398
141500200528     C**********         IF        PRtCd = *Blanks                                   CSC011 MD024398
141600200528     C**********         EVAL      CSC011 = 'Y'                                      CSC011 MD024398
141700200528     C**********         IN        SC24X7                                            CSC011 MD024398
141800200528     C**********         IN        SDSTAT                                            CSC011 MD024398
141900200528     C**********         IF        S1SUPP = LIBR                                     CSC011 MD024398
142000200528     C**********         EVAL      WRunDay = S1DATE                                  CSC011 MD024398
142100200528     C**********         ENDIF                                                       CSC011 MD024398
142200200528      **********                                                                     CSC011 MD024398
142300200528     C**********         ELSE                                                        CSC011 MD024398
142400200528     C                   EVAL      CSC011 = 'N'                                               CSC011
142500200528     C**********         IF        PRtCd <> '*NRF'                                   CSC011 MD024398
142600200528     C******LOCK         IN        LDA                                               CSC011 MD024398
142700200528     C**********         EVAL      DBFILE = 'SCSARDPD'                               CSC011 MD024398
142800200528     C**********         EVAL      DBKEY = 'CSC011'                                  CSC011 MD024398
142900200528     C**********         EVAL      DBASE = 1                                         CSC011 MD024398
143000200528     C**********         OUT       LDA                                               CSC011 MD024398
143100200528     C**********         EXSR      *PSSR                                             CSC011 MD024398
143200200528     C**********         ENDIF                                                       CSC011 MD024398
143300200528      **********                                                                     CSC011 MD024398
143400200528     C**********         ENDIF                                                       CSC011 MD024398
143500200528                                                                                              CER055
143600200528      ** Check if CER055 is installed                                                         CER055
143700200528                                                                                              CER055
143800200528     C                   CALLB     'AOSARDR0'                                                 CER055
143900200528     C                   PARM      *BLANKS       PRtCd                                        CER055
144000200528     C                   PARM      '*VERIFY'     POptn                                        CER055
144100200528     C                   PARM      'CER055'      PSard                                        CER055
144200200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CER055
144300200528                                                                                              CER055
144400200528     C                   IF        PRtCd = *Blanks                                            CER055
144500200528     C                   EVAL      CER055 = 'Y'                                               CER055
144600200528     C                   ELSE                                                                 CER055
144700200528     C                   EVAL      CER055 = 'N'                                               CER055
144800200528     C                   IF        PRtCd <> '*NRF'                                            CER055
144900200528     C     *LOCK         IN        LDA                                                        CER055
145000200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER055
145100200528     C                   EVAL      DBKEY = 'CER055'                                           CER055
145200200528     C                   EVAL      DBASE = 2                                                  CER055
145300200528     C                   OUT       LDA                                                        CER055
145400200528     C                   EXSR      *PSSR                                                      CER055
145500200528     C                   ENDIF                                                                CER055
145600200528     C                   ENDIF                                                                CER055
145700200528      *
145800200528      **  Get the Back Value Limit Date
145900200528                                                                                              CSC011
146000200528     C                   IF        CSC011 = 'Y' AND S1SUPP = LIBR                             CSC011
146100200528     C     WRunDay       SUB       BJBVPD        WWBKVD            5 0                        CSC011
146200200528     C     WRunDay       ADD       BMNDFV        WWFWVD            5 0                        CSC011
146300200528                                                                                              CSC011
146400200528     C                   ELSE                                                                 CSC011
146500200528     C     BJRDNB        SUB       BJBVPD        WWBKVD            5 0
146600200528      *
146700200528      **  Get the Forward Value Limit Date
146800200528     C     BJRDNB        ADD       BMNDFV        WWFWVD            5 0
146900200528     C                   ENDIF                                                                CSC011
147000200528                                                                                              CRE073
147100200528      ** Check if CRE073 is installed                                                         CRE073
147200200528                                                                                              CRE073
147300200528     C                   CALLB     'AOSARDR0'                                                 CRE073
147400200528     C                   PARM      *BLANKS       PRtCd                                        CRE073
147500200528     C                   PARM      '*VERIFY'     POptn                                        CRE073
147600200528     C                   PARM      'CRE073'      PSard                                        CRE073
147700200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
147800200528                                                                                              CRE073
147900200528     C                   IF        PRtCd = *BLANKS                                            CRE073
148000200528     C                   EVAL      CRE073 = 'Y'                                               CRE073
148100200528     C                   ELSE                                                                 CRE073
148200200528     C                   EVAL      CRE073 = 'N'                                               CRE073
148300200528     C                   IF        PRtCd <> '*NRF'                                            CRE073
148400200528     C     *LOCK         IN        LDA                                                        CRE073
148500200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE073
148600200528     C                   EVAL      DBKEY = 'CRE073'                                           CRE073
148700200528     C                   EVAL      DBASE = 3                                                  CRE073
148800200528     C                   OUT       LDA                                                        CRE073
148900200528     C                   EXSR      *PSSR                                                      CRE073
149000200528     C                   ENDIF                                                                CRE073
149100200528                                                                                              CRE073
149200200528     C                   ENDIF                                                                CRE073
149300200528                                                                                              CRE073
149400200528                                                                                              CRE090
149500200528      ** Check if CRE090 is installed                                                         CRE090
149600200528                                                                                              CRE090
149700200528     C                   CALLB     'AOSARDR0'                                                 CRE090
149800200528     C                   PARM      *BLANKS       PRtCd                                        CRE090
149900200528     C                   PARM      '*VERIFY'     POptn                                        CRE090
150000200528     C                   PARM      'CRE090'      PSard                                        CRE090
150100200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE090
150200200528                                                                                              CRE090
150300200528     C                   IF        PRtCd = *BLANKS                                            CRE090
150400200528     C                   EVAL      CRE090 = 'Y'                                               CRE090
150500200528     C                   ELSE                                                                 CRE090
150600200528     C                   EVAL      CRE090 = 'N'                                               CRE090
150700200528     C                   IF        PRtCd <> '*NRF'                                            CRE090
150800200528     C     *LOCK         IN        LDA                                                        CRE090
150900200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE090
151000200528     C                   EVAL      DBKEY = 'CRE090'                                           CRE090
151100200528     C                   EVAL      DBASE = 4                                                  CRE090
151200200528     C                   OUT       LDA                                                        CRE090
151300200528     C                   EXSR      *PSSR                                                      CRE090
151400200528     C                   ENDIF                                                                CRE090
151500200528                                                                                              CRE090
151600200528     C                   ENDIF                                                                CRE090
151700200528                                                                                              CRE090
151800200528      *
151900200528      *  Set up the name of the MSGF from which the message handler will
152000200528      *   get the messages
152100200528     C                   EVAL      #MsgFile = 'DRSMM'
152200200528      *                                                                         180721
152300200528     C                   Movel     'N'           WValforPB         1            180721
152400200528     C                   Movel     *Blanks       WWID              2            180721
152500200528      *                                                                         180721
152600200528     C     BGN4ST        IFEQ      'Y'                                          180721
152700200528      *                                                                         180721
152800200528     C**********         Movel     APFOTranID    WWID                                  180721 CGL029
152900200528     C                   Movel     APFOTran40    WWID                                         CGL029
153000200528      *                                                                         180721
153100200528     C     AMATYP        IFEQ      'R'                                          180721
153200200528      *                                                                         180721
153300200528     C                   Movel     AMCNUM        @CNUM                          180721
153400200528     C                   CALL      'AOCUSTR1'                                   180721
153500200528     C                   PARM      '*DBERR '     @RTCD                          180721
153600200528     C                   PARM      '*KEY   '     @OPTN                          180721
153700200528     C                   PARM                    @CNUM            10            180721
153800200528     C                   PARM      *BLANKS       @CNST             7            180721
153900200528     C     SDCUST        PARM      SDCUST        DSLDY                          180721
154000200528      *                                                                         180721
154100200528     C     BBPRBA        IFEQ      'Y'                                          180721
154200200528     C                   Movel     'Y'           WValforPB                      180721
154300200528     C                   ENDIF                                                  180721
154400200528     C                   ENDIF                                                  180721
154500200528     C                   ENDIF                                                  180721
154600200528                                                                                            MD046635
154700200528     C                   CALLB     'AOSVALR0'                                               MD046635
154800200528     C                   PARM                    @RTCD             7                        MD046635
154900200528     C                   PARM      BRCUSR        @OP01            20                        MD046635
155000200528     C     CurSysVal     PARM                    @VL01           200                        MD046635
155100200528     C                   PARM                    @OP02            20                        MD046635
155200200528     C                   PARM                    @VL02           200                        MD046635
155300200528     C                   PARM                    @OP03            20                        MD046635
155400200528     C                   PARM                    @VL03           200                        MD046635
155500200528     C                   PARM                    @OP04            20                        MD046635
155600200528     C                   PARM                    @VL04           200                        MD046635
155700200528     C                   PARM                    @OP05            20                        MD046635
155800200528     C                   PARM                    @VL05           200                        MD046635
155900200528     C                   PARM                    @OP06            20                        MD046635
156000200528     C                   PARM                    @VL06           200                        MD046635
156100200528     C                   PARM                    @OP07            20                        MD046635
156200200528     C                   PARM                    @VL07           200                        MD046635
156300200528     C                   PARM                    @OP08            20                        MD046635
156400200528     C                   PARM                    @VL08           200                        MD046635
156500200528     C                   PARM                    @OP09            20                        MD046635
156600200528     C                   PARM                    @VL09           200                        MD046635
156700200528     C                   PARM                    @OP10            20                        MD046635
156800200528     C                   PARM                    @VL10           200                        MD046635
156900200528                                                                                            MD046635
157000200528     C/COPY WNCPYSRC,GLAMA3VC03
157100200528
157200200528      ** Program, module and procedure names for database error processing.
157300200528      ** =================================================================
157400200528      ** The following /COPY sets these values, and also defines LDA as
157500200528      ** an external data area
157600200528
157700200528     C                   ENDSR
157800200528      *****************************************************************
157900200528      /EJECT
158000200528      *****************************************************************
158100200528      * RESETERRS - Reset error information that is received back     *
158200200528      *    from each validation module.                               *
158300200528      *****************************************************************
158400200528
158500200528     C     RESETERRS     BEGSR
158600200528
158700200528     C                   EVAL      RetCodeOut = *Blanks
158800200528      *
158900200528      * Reset error & warning fields/message IDs/message data (arrays)
159000200528     C                   MOVEL     *BLANK        FldNamXAr
159100200528     C                   MOVEL     *BLANK        MsgIDXAr
159200200528     C                   MOVEL     *BLANK        MsgDtaXAr
159300200528     C                   MOVEL     *BLANK        WFldNmXAr                                  AR847249
159400200528     C                   MOVEL     *BLANK        WMsgIDXAr                                  AR847249
159500200528     C                   MOVEL     *BLANK        WMsgDtXAr                                  AR847249
159600200528
159700200528     C                   ENDSR
159800200528      *****************************************************************
159900200528      /EJECT
160000200528      *****************************************************************
160100200528      * UPDATERRS - Update error information with that received back  *
160200200528      *    from each validation module.                               *
160300200528      *****************************************************************
160400200528
160500200528     C     UPDATERRS     BEGSR
160600200528      *
160700200528      * Update error fields/message IDs/message data (arrays)
160800200528      *
160900200528     C                   Z-ADD     1             I                 3 0
161000200528     C     *BLANK        LOOKUP    FldNameArr(I)                          99
161100200528     C     *IN99         IFEQ      '1'
161200200528     C                   MOVEA     FldNamXAr     FlDNameArr(I)
161300200528     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
161400200528     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
161500200528     C                   END
161600200528      *
161700200528      * Set Error Index
161800200528     C                   Z-ADD     1             I
161900200528     C     *BLANK        LOOKUP    FldNameArr(I)                          99
162000200528     C     I             SUB       1             Idx
162100200528                                                                                            AR847249
162200200528      ** Update warning fields/message IDs/message data (arrays)                            AR847249
162300200528                                                                                            AR847249
162400200528     C                   Z-ADD     1             I                                          AR847249
162500200528     C     *BLANK        LOOKUP    WFldNamArr(I)                          99                AR847249
162600200528     C     *IN99         IFEQ      '1'                                                      AR847249
162700200528     C                   MOVEA     WFldNmXAr     WFldNamArr(I)                              AR847249
162800200528     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)                               AR847249
162900200528     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)                              AR847249
163000200528     C                   END                                                                AR847249
163100200528                                                                                            AR847249
163200200528      ** Set Warning Index                                                                  AR847249
163300200528     C                   Z-ADD     1             I                                          AR847249
163400200528     C     *BLANK        LOOKUP    WFldNamArr(I)                          99                AR847249
163500200528     C     I             SUB       1             WIx                                        AR847249
163600200528      *
163700200528     C                   ENDSR
163800200528      *****************************************************************
163900200528      /EJECT
164000200528      *****************************************************************
164100200528      * #TERM - Termination processing.
164200200528      *****************************************************************
164300200528     C     #TERM         BEGSR
164400200528      *
164500200528      **  Terminate program
164600200528      *
164700200528     C                   MOVE      '1'           *INLR
164800200528      *
164900200528     C     *INU7         IFEQ      '1'
165000200528     C                   DUMP
165100200528     C                   END
165200200528      *
165300200528     C                   RETURN
165400200528      *
165500200528     C                   ENDSR
165600200528      *****************************************************************
165700200528      /EJECT
165800200528      ********************************************************************
165900200528     C/COPY ZACPYSRC,PSSR_ILE
166000200528      ********************************************************************
166100200528      /EJECT
166200200528**  CPY@
166300200528(c) Finastra International Limited 2001
