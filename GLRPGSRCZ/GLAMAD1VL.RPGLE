000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas GL Account master details validation')           *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - General Ledger Module                                *
000900200528      *                                                               *
001000200528      *  GLAMAD1VL -  Account Master Details Validation               *
001100200528      *                                                               *
001200200528      *  (c) Finastra International Limited 2001                      *
001300200528      *                                                               *
001400200604      *  Last Amend No. 250822             Date 22May20               *
001500200528      *  Prev Amend No. MD054028           Date 05Sep19               *
001600200528      *                 CER050             Date 16Jun19               *
001700200528      *                 AR1021393          Date 13Nov18               *
001800200528      *                 MD046248           Date 27Oct17               *
001900200528      *                 CGL184             Date 07Dec16               *
002000200528      *                 CGL165             Date 23Feb15               *
002100200528      *                 CER069             Date 03Jul14               *
002200200528      *                 MD024336A          Date 19Aug14               *
002300200528      *                 MD024398           Date 11May14               *
002400200528      *                 CGL123             Date 12Dec12               *
002500200528      *                 CSF011A            Date 28Nov11               *
002600200528      *                 AR869261           Date 13Dec11               *
002700200528      *                 CER049             Date 06Dec10               *
002800200528      *                 CRE073             Date 06Dec10               *
002900200528      *                 CER055             Date 06Dec10               *
003000200528      *                 AR762349           Date 03Jun11               *
003100200528      *                 AR760540A          Date 25May11               *
003200200528      *                 AR761933           Date 26May11               *
003300200528      *                 CRE075             Date 06Dec10               *
003400200528      *                 CER059             Date 19Jul10               *
003500200528      *                 262025             Date 19Oct09               *
003600200528      *                 BUG23886           Date 26May09               *
003700200528      *                 BUG24157           Date 04Jun09               *
003800200528      *                 BUG22747           Date 12Feb09               *
003900200528      *                 BUG22745           Date 09Feb09               *
004000200528      *                 CER048             Date 19May08               *
004100200528      *                 CER047             Date 19May08               *
004200200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
004300200528      *                 BUG27466           Date 21Apr10               *
004400200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
004500200528      *                 256564             Date 17Sep08               *
004600200528      *                 BUG16622           Date 14Mar08               *
004700200528      *                 249054             Date 28May07               *
004800200528      * Midas Plus 1.4 Base ------------------------------------------*
004900200528      * Midas Plus 1.3 ----------- Base ------------------------------*
005000200528      *                 231128             Date 16Oct06               *
005100200528      *                 242488             Date 27Sep06               *
005200200528      *                 227198             Date 30Jun06               *
005300200528      *                 CDL013             Date 08Jun06               *
005400200528      *                 239720             Date 11May06               *
005500200528      *                 238639             Date 27Feb06               *
005600200528      *                 CSD027             Date 09Dec05               *
005700200528      *                 BUG8550            Date 07Oct05               *
005800200528      *                 BUG7967            Date 29Jul05               *
005900200528      *                 BUG8625            Date 29Sep05               *
006000200528      *                 BUG8471            Date 14Sep05               *
006100200528      *                 CAP086             Date 08Jun05               *
006200200528      *                 BUG5340            Date 06Apr05               *
006300200528      *                 BUG4615            Date 26Oct04               *
006400200528      *                 CSD025             Date 11Jan05               *
006500200528      *                 BUG3365            Date 24Jun04               *
006600200528      *                 CLE025             Date 20Oct03               *
006700200528      *                 225892  BUG1522    Date 19Mar04               *
006800200528      *                 CGL029             Date 27Mar04               *
006900200528      *                 CSD012             Date 15Oct02               *
007000200528      *                 208221             Date 11Dec02               *
007100200528      * Midas Release 4.01.02 ----------------------------------------*
007200200528      *                 203214             Date 28May02               *
007300200528      * Midas Release 4.01 -------------------------------------------*
007400200528      *                 CSC011             Date 18Sep01               *
007500200528      * Midas Release 4 --------------- Base -------------------------*
007600200528      *                 CDE002             Date 14Feb99               *
007700200528      * Midas DBA 3.05 -----------------------------------------------*
007800200528      *                 180721             Date 03May00               *
007900200528      *                 CUT009             Date 19Feb01               *
008000200528      * Midas DBA 3.02 -----------------------------------------------*
008100200528      *                 CPB001             Date 19Oct99               *
008200200528      *                 CFT004             Date 05Nov99               *
008300200528      *                 CAP035  *CREATE    Date 19Mar99               *
008400200528      *                                                               *
008500200528      *---------------------------------------------------------------*
008600200528      *                                                               *
008700200528      *  250822 - Next Statement date is incorrect.  Ensure that      *
008800200528      *           DnxtSDat is always called to calculate value based  *
008900200528      *           on Frequency and/or Next Statement Day.             *
009000200528      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
009100200528      *             being updated                                     *
009200200528      *  CER050 - Annualised Percentage Rate                          *
009300200528      *  AR1021393 - Wrong balances on account statement. If stmt freq*
009400200528      *              changed from non-'E' to 'E', issue warning msg   *
009500200528      *              RE72060. (Child: AR1021396)                      *
009600200528      *            - Applied for MD052264.                            *
009700200528      *  MD046248 - Finastra Rebranding                               *
009800200528      *  CGL184 - New Frequencies for Account Statements              *
009900200528      *  CGL165 - Dual Withholding Tax                                *
010000200528      *  CER069 - German Tax Enhancement                              *
010100200528      *  MD024336A - Account name in error as blank if Account not    *
010200200528      *              found                                            *
010300200528      *  MD024398 - API Performance Optimisation                      *
010400200528      *  CGL123 - Issue a warning message during closure of account   *
010500200528      *           if there is a remaining balance at Profit Centre    *
010600200528      *           level.                                              *
010700200528      *           Added hooks: OFCPYSRCZ,CGL123_001                   *
010800200528      *                        OFCPYSRCZ,CGL123_002                   *
010900200528      *                        OFCPYSRCZ,CGL123_003                   *
011000200528      *         - Applied fix AR895874 :                              *
011100200528      *             CGL123 Warning was issued during account creation.*
011200200528      *             Warning message should only be issued during      *
011300200528      *             Account closure. Recompile due to changes in      *
011400200528      *             OFCPYSRCZ,CGL123_003. (Child: AR895875)           *
011500200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
011600200528      *            (Recompile)                                        *
011700200528      *  AR869261 - Account Name defaulted to old customer when       *
011800200528      *             it is manually inserted                           *
011900200528      *  CER049 - Stamp Tax (Recompile)                               *
012000200528      *  CRE073 - Interest Rate Rounding (Recompile)                  *
012100200528      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
012200200528      *           (Recompile)                                         *
012300200528      *  AR762349 - Self-Report Customer validation issues            *
012400200528      *  AR760540A - Block/Refer debit and credit fields are not      *
012500200528      *              defaulted                                        *
012600200528      *  AR761933 - Unable to transamit AMAD transaction via SOAP API *
012700200528      *  CRE075 - Effective Date for Retail Accounts                  *
012800200528      *  CER059 - German Feature Upgrade to Delhi                     *
012900200528      *  262025 - Problem with IBAN number generation. Re-initialize  *
013000200528      *           DDIBAN field when Action Code is Insert.            *
013100200528      *  BUG23886 - Account insert - Taxable indicator defaults       *
013200200528      *           to Threshold                                        *
013300200528      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
013400200528      *             when field is set to Y                            *
013500200528      *  BUG22747 - 'Y' should not be an option if customer is        *
013600200528      *           non-taxable. Correct retrieval of European Tax      *
013700200528      *           status.                                             *
013800200528      *  BUG22745 - Error on defaulting and validation of Tax         *
013900200528      *             Indicator.                                        *
014000200528      *  CER048 - German Features - Taxes                             *
014100200528      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
014200200528      *           (Recompile)                                         *
014300200528      *  BUG27466 - Apply fix BUG25813                                *
014400200528      *  BUG25813 - Duplicate error for account code                  *
014500200528      *  256564 - Recompile due to PF changes done by fix 256330      *
014600200528      *  BUG16622 - Warning message must shown if closing an account  *
014700200528      *             with balance not equal to zero                    *
014800200528      *  249054 - Applied core fix 248025                             *
014900200528      *  248025 - Subject to A/C charge (ATCHIN) should be 'N' if     *
015000200528      *           Fixed A/C Charge (FACH) is 'N' in RE ICD.           *
015100200528      *           Completed fix 242488.                               *
015200200528      *  231128 - Same fix as 242488.                                 *
015300200528      *  242488 - Interest Taxable should not be checked if taxes is  *
015400200528      *           off. Validate other ACCNTBXC fields in all cases.   *
015500200528      *           Apply fix 239720/238639/227198.                     *
015600200528      *  227198 - Unable to insert retail account. Keep getting       *
015700200528      *           message TAM4801 (Interest Taxable must be Y on N)   *
015800200528      *           eventhough the field is not displayed.              *
015900200528      *  CDL013 - Tiered Withholding Tax                              *
016000200528      *  239720 - Interest Taxable should not be checked if taxes is  *
016100200528      *           off. Validate other ACCNTBXC fields in all cases    *
016200200528      *           Applied 238639.                                     *
016300200528      *  238639 - Interest Taxable should not be checked if taxes is  *
016400200528      *           off. Validate other ACCNTBXC fields in all cases    *
016500200528      *           Applied 231128                                      *
016600200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
016700200528      *  BUG8550 - Reposition capture of ZMUSER data area             *
016800200528      *  BUG7967 - Show warning message upon deletion of account      *
016900200528      *            with cheque book details still existing            *
017000200528      *  BUG8625 - Default DDITAX to N if BGNTST is OFF               *
017100200528      *  BUG8471- Cannot authorise deletion in SDA due to DB error    *
017200200528      *  CAP086 - Introduce Auto Authorisation to the API's           *
017300200528      *           without it. (Recompile)                             *
017400200528      *  BUG5340 - Validate TI account details.                       *
017500200528      *  BUG4615 - Show warning message upon deletion of account      *
017600200528      *            with cheque book details still existing            *
017700200528      *  CSD025 - Customer De-Activation                              *
017800200528      *  BUG3365 - Add account sequence to GLVTIAC (SP6GL0001).       *
017900200528      *  CLE025 - Credit Lines (Recompile)                            *
018000200528      *  225892 - Stop job looping when CCY is *Blank                 *
018100200528      *  CGL029 - Increase Account Code to 10 digits                  *
018200200528      *  CSD012 - Standing Data Authorisation                         *
018300200528      *  208221 - Default Margin from Rate/Spread changes (Recompile) *
018400200528      *  203214 - Cannot Amend an account from TOF as block C/D       *
018500200528      *          is not correct in TOF.                               *
018600200528      *  CSC011 - 24x7 Midas Availability                             *
018700200528      *  CDE002 - CCRM Revenue Analysis - Recompile only              *
018800200528      *  180721 - Default "Next Statement Date" when opening          *
018900200528      *           Account coming from interface                       *
019000200528      *         - Retail Account Number must be calculated            *
019100200528      *  CUT009 - Manual addition of core hooks.                      *
019200200528      *  CPB001 - Meridian DBA Middleware Replication Customisation.  *
019300200528      *           Recompiled due to database changes.                 *
019400200528      *  CFT004 - Straight Through Processing Phase 2                 *
019500200528      *         - International Bank Account Numbers                  *
019600200528      *  CAP035 - Midas/ToF Interface                                 *
019700200528      *                                                               *
019800200528      *****************************************************************
019900200528      ** +--------------------------------------+
020000200528      ** ¦ F-specs                              ¦
020100200528      ** ¦ =======                              ¦
020200200528      ** +--------------------------------------+
020300200528      *****************************************************************
020400200528      *                                                                                       CSD012
020500200528     FSDAULGL0  IF   E           K DISK    INFSR(*PSSR)                                       CSD012
020600200528      * RTV : Authorisation Log - by Key                                                      CSD012
020700200528
020800200528     FACCNTL0   IF   E           K DISK    INFSR(*PSSR)                                     BUG16622
020900200528     F                                     PREFIX(A1)                                       BUG16622
021000200528      ** Account details                                                                    BUG16622
021100200528      *                                                                                       CER048
021200200528     FSDACTXL1  IF   E           K DISK                                                       CER048
021300200528      *                                                                                       CER048
021400200528      ** Customer Details by Country of Tax                                                   CER048
021500200528      *                                                                                       CER048
021600200528     FSDCTTXL0  IF   E           K DISK                                                     BUG23886
021700200528      *                                                                                     BUG23886
021800200528      ** Midas SD Country of Tax Codes                                                      BUG23886
021900200528      *                                                                                     BUG23886
022000200528     FSDBRCHL0  IF   E           K DISK    INFSR(*PSSR)                                       262025
022100200528
022200200528      *****************************************************************
022300200528      ** +--------------------------------------+
022400200528      ** ¦ Automatically included D-specs       ¦
022500200528      ** ¦ ==============================       ¦
022600200528      ** +--------------------------------------+
022700200528      **
022800200528      ** Standard D-specs
022900200528      ** ================
023000200528      **
023100200528      ** The following /COPY line includes the LDA layout,
023200200528      ** the copyright array definition,
023300200528      ** and the following named constants:
023400200528      **    True       logical = *on (for indcator processing)
023500200528      **    False      logical = *off (for indcator processing)
023600200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
023700200528      **                                    handler)
023800200528      ** and the following variables:
023900200528      **    RunBefore  1A (for the PSSR)
024000200528
024100200528     D/COPY ZACPYSRC,STD_D_SPEC
024200200528
024300200528      ** Program Status Data Structure
024400200528      ** =============================
024500200528      ** The following /COPY line includes all the defined fields in the
024600200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
024700200528
024800200528     D/COPY ZACPYSRC,PSDS
024900200528      ** The following /COPY line includes definitions for the above fields
025000200528      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
025100200528      ** corresponding fields in the PSDS /COPY member, so that member
025200200528      ** must be included where this one is used.
025300200528
025400200528     D/COPY ZACPYSRC,PROCPARMS
025500200528
025600200528      **--------------------------------------------------------------------------------------------
025700200528      ** The following /COPY line includes the definitions for error and
025800200528      ** warning message arrays.
025900200528     D/COPY ZACPYSRC,ERR_ARRAYS
026000200528      **--------------------------------------------------------------------------------------------
026100200528
026200200528      ** +--------------------------------------+
026300200528      ** ¦ End of automatically included D-specs¦
026400200528      ** ¦ =====================================¦
026500200528      ** +--------------------------------------+
026600200528
026700200528      *****************************************************************
026800200528      /EJECT
026900200528      *****************************************************************
027000200528
027100200528      ** +--------------------------------------+
027200200528      ** ¦ Manually included D-specs            ¦
027300200528      ** ¦ =========================            ¦
027400200528      ** +--------------------------------------+
027500200528
027600200528      ** +--------------------------------------+
027700200528      ** ¦ Named constants                      ¦
027800200528      ** ¦ ===============                      ¦
027900200528      ** +--------------------------------------+
028000200528
028100200528      ** The maximum size of the appended error arrays
028200200528     D XArrayMax       C                   CONST(20)
028300200528
028400200528      ** +--------------------------------------+
028500200528      ** ¦ Arrays and Data Structures           ¦
028600200528      ** ¦ ==========================           ¦
028700200528      ** +--------------------------------------+
028800200528
028900200528      ** Array of Fields in error.
029000200528     D FldNamXAr       S             10A   DIM(XArrayMax)
029100200528
029200200528      ** Array of error message IDs
029300200528     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
029400200528
029500200528      ** Array of error message data.
029600200528     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
029700200528
029800200528      ** Array of Fields with warnings.
029900200528     D WFldNmXAr       S             10A   DIM(XArrayMax)
030000200528
030100200528      ** Array of warning message IDs
030200200528     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
030300200528
030400200528      ** Array of warning message data.
030500200528     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
030600200528
030700200528      ** Flags to indicate whether transaction fields are valid
030800200528     D OKFlagsDS       DS
030900200528     D  DDActnOK                      1A
031000200528     D  DDAccnOK                      1A
031100200528     D  DDRFrAOK                      1A
031200200528     D  DDBrcaOK                      1A
031300200528     D  DDCUSNOK                      1A
031400200528     D  DDCcyOK                       1A
031500200528     D  DDACodOK                      1A
031600200528     D  DDAcSqOK                      1A
031700200528     D  DDAcNoOK                      1A
031800200528     D  DDAnamOK                      1A
031900200528     D  DDDAcOOK                      1A
032000200528     D  DDNStDOK                      1A
032100200528     D  DDStFqOK                      1A
032200200528     D  DDENoCOK                      1A
032300200528     D  DDNSDNOK                      1A
032400200528     D  DDEUSBOK                      1A
032500200528     D  DDPtAdOK                      1A
032600200528     D  DDRefOK                       1A
032700200528     D  DDRADOK                       1A
032800200528     D  DDRACOK                       1A
032900200528     D  DDBADOK                       1A
033000200528     D  DDBACOK                       1A
033100200528     D  DDTIAcOK                      1A
033200200528     D  DDTIANOK                      1A
033300200528     D  DDTIASOK                      1A
033400200528     D  DDPrfCOK                      1A
033500200528     D  DDMFFqOK                      1A
033600200528     D  DDPtfROK                      1A
033700200528     D  DDITAXOK                      1A
033800200528     D  DDTXC1OK                      1A                                                      CGL165
033900200528     D  DDTXC2OK                      1A                                                      CGL165
034000200528     D  DDSTCIOK                      1A
034100200528     D  DDCHINOK                      1A
034200200528     D  DDCHAMOK                      1A
034300200528     D  DDIBANOK                      1A                                        CFT004
034400200528     D  DD24COK                       1A                                                    BUG24157
034500200528     D  DDEFDTOK                      1A                                                      CRE075
034600200528     D  DDAprcOK                      1A                                                      CER050
034700200528
034800200528     D KCNUM           S                   LIKE(DDCUSN)                                     BUG16622
034900200528     D KCCY            S                   LIKE(DDCCY)                                      BUG16622
035000200528     D KACOD           S             10S 0                                                  BUG16622
035100200528     D KACSQ           S              2S 0                                                  BUG16622
035200200528     D KBRCA           S                   LIKE(DDBRCA)                                     BUG16622
035300200528
035400200528      *                                                                                     BUG22747
035500200528      ** External data structures for Location Details                                      BUG22747
035600200528      *                                                                                     BUG22747
035700200528     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                BUG22747
035800200528      *                                                                                     BUG22747
035900200528      ** External data structures for Branch Details                                        BUG22747
036000200528      *                                                                                     BUG22747
036100200528     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                BUG22747
036200200528     D   AQQDFAC     E                     EXTFLD(QQDFAC)                                   BUG22747
036300200528      *                                                                                     BUG22747
036400200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
036500200528      ** EXTERNAL DS FOR BANK DETAILS
036600200528
036700200528     D RETABLE       E DS                  EXTNAME(TABTBRE)
036800200528      ** EXTERNAL DS FOR RETAIL TABLE FILE
036900200528
037000200528     D SDGELR        E DS                  EXTNAME(SDGELRPD)
037100200528      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
037200200528
037300200528     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
037400200528      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
037500200528
037600200528     D SDRETL        E DS                  EXTNAME(SDRETLPD)
037700200528     D  RLACCD       E                     EXTFLD(QQACCD)                                     CGL029
037800200528      ** EXTERNAL DS FOR RETAIL DETAILS
037900200528
038000200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)
038100200528      ** EXTERNAL DS FOR SAR DETAILS
038200200528
038300200528                                                                                              CDL013
038400200528     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CDL013
038500200528      ** EXTERNAL DS FOR CUSTOMER DETAILS                                                     CDL013
038600200528                                                                                              CDL013
038700200528     D SDPORT        E DS                  EXTNAME(SDPORTPD)
038800200528      ** Portfolio Management ICD Details
038900200528
039000200528     D DSFDY         E DS                  EXTNAME(DSFDY)
039100200528      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
039200200528
039300200528     D ValidAccn     E DS                  EXTNAME(GLVAMADPD)
039400200528      * Valid Account layout -> ACCNTAB
039500200528
039600200528     D ValidExBX     E DS                  EXTNAME(GLVAMBXPD)
039700200528     D  GBACCD       E                     EXTFLD(QQACOD)                                     CGL029
039800200528      * Valid Extn. Account layout -> ACCNTBXC
039900200528
040000200528     D TranIn        E DS                  EXTNAME(GLAMADPD)
040100200528      * Incoming Transaction
040200200528
040300200528     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
040400200528      ** 24X7 status data area                                                                CSC011
040500200528                                                                                              CSC011
040600200528     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
040700200528      ** SD data area                                                                         CSC011
040800200528                                                                                              CSC011
040900200528     D ZMUSER          DS            17
041000200528      * ZMUSER data layout
041100200528     D  DBRN                  11     13
041200200528
041300200528     D RUNDAT          DS            13
041400200528      * Rundate data area
041500200528     D  AGMBIN                13     13
041600200528
041700200528     D*PKEY*****       DS            20                                                CSD012 CGL029
041800200528     D PKEY            DS            26                                                       CGL029
041900200528     D PBRCA                   1      3                                                       CSD012
042000200528     D PCUSN                   4      9                                                       CSD012
042100200528     D PCCY                   10     12                                                       CSD012
042200200528     D*PACOD****              13     16                                                CSD012 CGL029
042300200528     D*PACSQ****              17     18                                                CSD012 CGL029
042400200528     D PACOD                  13     22                                                       CGL029
042500200528     D PACSQ                  23     24                                                       CGL029
042600200528                                                                                              CSD012
042700200528     D/COPY OFCPYSRCZ,CGL123_001                                                              CGL123
042800200528      ** +--------------------------------------+
042900200528      ** ¦ Declared variables                   ¦
043000200528      ** ¦ ==================                   ¦
043100200528      ** +--------------------------------------+
043200200528
043300200528      ** Index for arrays of of error message ids etc
043400200528     D Idx             S              3P 0
043500200528
043600200528      ** Index for arrays of of warning message ids etc
043700200528     D WIdx            S              3P 0
043800200528
043900200528      ** Response Mode, received as a parameter from the common header
044000200528     D RespMode        S              1A
044100200528
044200200528      ** Fields defined for Enhancement CSC011                                                CSC011
044300200528     D CSC011          S              1A                                                      CSC011
044400200528     D PRtCd           S              7A                                                      CSC011
044500200528     D POptn           S              7A                                                      CSC011
044600200528     D PSard           S              6A                                                      CSC011
044700200528     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
044800200528      *                                                                                       CGL029
044900200528     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
045000200528      *                                                                                       CGL029
045100200528     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CER048
045200200528                                                                                              CSC011
045300200528     D CER047          S              1A                                                    BUG24157
045400200528     D CER048          S              1A                                                      CER048
045500200528     D PAcHlF          S              1A                                                      CER048
045600200528     D PKey1           S             10A                                                      CER048
045700200528     D PKyst           S              7A                                                      CER048
045800200528      *                                                                                       CER048
045900200528     D KFCusn          S              6A                                                      CER048
046000200528     D KFCtax          S              2A                                                      CER048
046100200528      *                                                                                     BUG23886
046200200528     D KCtTx           S              2A                                                    BUG23886
046300200528     D KCtRe           S              2A                                                    BUG23886
046400200528     D WThrMtd         S              1A                                                    BUG23886
046500200528      *                                                                                       CER048
046600200528     D PBrch           S              3a                                                    BUG22747
046700200528     D PLocn           S              3A                                                    BUG22747
046800200528                                                                                              CRE075
046900200528     D CRE075          S              1A                                                      CRE075
047000200528     D CER069          S              1A                                                      CER069
047100200528     D CGL165          S              1A                                                      CGL165
047200200528     D CGL184          S              1A                                                      CGL184
047300200528     D CER050          S              1A                                                      CER050
047400200528      ** +--------------------------------------+
047500200528      ** ¦ End of D-specs                       ¦
047600200528      ** ¦ ==============                       ¦
047700200528      ** +--------------------------------------+
047800200528
047900200528      ** +----------------------------------------+
048000200528      ** ¦ Hook for non-core D-specs (all types)  ¦
048100200528      ** ¦ also any I-specs (if necessary)        ¦
048200200528      ** ¦ =====================================  ¦
048300200528      ** +----------------------------------------+
048400200528
048500200528      *****************************************************************
048600200528      /EJECT
048700200528      ** +--- Start of Main processing -----------------------------------+
048800200528      ** ¦                                                                ¦
048900200528      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
049000200528      ** ¦ executed at program activation.                                ¦
049100200528      ** ¦                                                                ¦
049200200528      ** +----------------------------------------------------------------+
049300200528      *
049400200528      **  Retrieve ZMUSER details                                                            BUG8550
049500200528                                                                                             BUG8550
049600200528     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
049700200528     C                   IN        ZMUSER                                                    BUG8550
049800200528     C                   UNLOCK    ZMUSER                                                    BUG8550
049900200528      *                                                                                       CUT009
050000200528     C     CHKACC        KLIST                                                              BUG16622
050100200528     C                   KFLD                    KCNUM                                      BUG16622
050200200528     C                   KFLD                    KCCY                                       BUG16622
050300200528     C                   KFLD                    KACOD                                      BUG16622
050400200528     C                   KFLD                    KACSQ                                      BUG16622
050500200528     C                   KFLD                    KBRCA                                      BUG16622
050600200528      *                                                                                     BUG16622
050700200528      /COPY WNCPYSRC,GLAMAD1V01                                                               CUT009
050800200528      ** Call Validation Modules in Sequence
050900200528      *
051000200528      ** Validation for Primary Screen
051100200528     C     WFMT          IFEQ      'F0'
051200200528      ** Validate Action Code, Account Number & Review From Account
051300200528     C                   EXSR      VACCNTKY
051400200528     C                   ENDIF
051500200528      *
051600200528      /COPY WNCPYSRC,GLAMAD1V02                                                               CUT009
051700200528      ** Validation for Key Screen
051800200528     C     WFMT          IFEQ      'FK'
051900200528      ** Run all remaining validation if called from CTL pgm
052000200528     C     WFMT          OREQ      *BLANKS
052100200528      *                                                                                       CSD012
052200200528      ** If Authorisation check is on,                                                        CSD012
052300200528      ** check if unathorised record exists on Authorisation Log.                             CSD012
052400200528 B01 C     AUTHRQ        IFEQ      'Y'                                                        CSD012
052500200528     C     AUTHMD        ANDNE     'X'                                                        CSD012
052600200528     C     DDACTN        ANDNE     'E'                                                        CSD012
052700200528      *                                                                                       CSD012
052800200528     C                   MOVEL     DDBRCA        PBRCA                                        CSD012
052900200528     C                   MOVEL     DDCUSN        PCUSN                                        CSD012
053000200528     C                   MOVEL     DDCCY         PCCY                                         CSD012
053100200528     C                   MOVEL     DDACOD        PACOD                                        CSD012
053200200528     C                   MOVEL     DDACSQ        PACSQ                                        CSD012
053300200528      *                                                                                       CSD012
053400200528     C     PKEY          CHAIN     SDAULGL0                           90                      CSD012
053500200528      *                                                                                       CSD012
053600200528      ** If record exists then prevent amendment and return                                   CSD012
053700200528 B02 C     *IN90         IFEQ      *OFF                                                       CSD012
053800200528     C                   MOVEL     'N'           DDACCNOK                                     CSD012
053900200528     C                   MOVE      1             Idx                                          CSD012
054000200528     C                   MOVEL     DDCUSN        FldNamXAr(Idx)                               CSD012
054100200528     C                   MOVEL     'USR9265'     MsgIDXAr(Idx)                                CSD012
054200200528      *                                                                                       CSD012
054300200528      ** Update error info                                                                    CSD012
054400200528     C                   EXSR      UPDATERRS                                                  CSD012
054500200528      *                                                                                       CSD012
054600200528     C                   RETURN                                                               CSD012
054700200528 E02 C                   ENDIF                                                                CSD012
054800200528 E02 C                   ENDIF                                                                CSD012
054900200528      *                                                                                       CSD012
055000200528      ** Validate Branch
055100200528      /COPY WNCPYSRC,GLAMAD1V03                                                               CUT009
055200200528     C                   EXSR      VBranch
055300200528      /COPY WNCPYSRC,GLAMAD1V04                                                               CUT009
055400200528      ** Validate Customer Number
055500200528      /COPY WNCPYSRC,GLAMAD1V05                                                               CUT009
055600200528     C                   EXSR      VCustNo
055700200528      /COPY WNCPYSRC,GLAMAD1V06                                                               CUT009
055800200528      ** Validate Currency
055900200528      /COPY WNCPYSRC,GLAMAD1V07                                                               CUT009
056000200528     C                   EXSR      VCurrency
056100200528      /COPY WNCPYSRC,GLAMAD1V08                                                               CUT009
056200200528      ** Validate Account Code & Sequence
056300200528      /COPY WNCPYSRC,GLAMAD1V09                                                               CUT009
056400200528     C                   EXSR      VACSQ
056500200528      /COPY WNCPYSRC,GLAMAD1V10                                                               CUT009
056600200528      ** Validate GL & Retail Account Number
056700200528      /COPY WNCPYSRC,GLAMAD1V11                                                               CUT009
056800200528     C                   EXSR      VAccount
056900200528      /COPY WNCPYSRC,GLAMAD1V12                                                               CUT009
057000200528                                                                                            AR869261
057100200528      ** Default Account Name only if the field is blank and all fields                     AR869261
057200200528      ** from the initial screen has been validated                                         AR869261
057300200528                                                                                            AR869261
057400200528     C                   IF        DDBrcaOK = 'Y' AND                                       AR869261
057500200528     C                             DDCUSNOK = 'Y' AND                                       AR869261
057600200528     C                             DDCcyOK  = 'Y' AND                                       AR869261
057700200528     C                             DDACodOK = 'Y' AND                                       AR869261
057800200528     C                             DDAcSqOK = 'Y' AND                                       AR869261
057900200528     C                             DDAcNoOK = 'Y' AND                                       AR869261
058000200528     C                             DDANAM  =  *BLANKS                                       AR869261
058100200528     C                   CALL      'AOCUSTR0'                                               AR869261
058200200528     C                   PARM      '*DBERR '     @RTCD                                      AR869261
058300200528     C                   PARM      '*KEY   '     @OPTN                                      AR869261
058400200528     C                   PARM      DDCUSN        @CUSNN                                     AR869261
058500200528     C                   PARM      *BLANKS       @CSTAT                                     AR869261
058600200528     C     SDCUST        PARM      SDCUST        DSLDY                                      AR869261
058700200528                                                                                            AR869261
058800200528      ** Retrieve Account Name from Customer Report Name                                    AR869261
058900200528                                                                                            AR869261
059000200528     C                   EVAL      DDANAM = BBCRNM                                          AR869261
059100200528     C                   ENDIF                                                              AR869261
059200200528     C                   ENDIF
059300200528      *
059400200528      /COPY WNCPYSRC,GLAMAD1V13                                                               CUT009
059500200528      ** Validation for First Detail Screen
059600200528     C     WFMT          IFEQ      'F1'
059700200528      ** Run all remaining validation if called from CTL pgm
059800200528     C     WFMT          OREQ      *BLANKS
059900200528      *
060000200528      ** Validate Retail Account Name
060100200528      /COPY WNCPYSRC,GLAMAD1V14                                                               CUT009
060200200528                                                                                           MD024336A
060300200528      ** Validate only if Key fields are valid.                                            MD024336A
060400200528                                                                                           MD024336A
060500200528     C                   IF        DDBrcaOK = 'Y' AND                                      MD024336A
060600200528     C                             DDCUSNOK = 'Y' AND                                      MD024336A
060700200528     C                             DDCcyOK  = 'Y' AND                                      MD024336A
060800200528     C                             DDACodOK = 'Y' AND                                      MD024336A
060900200528     C                             DDAcSqOK = 'Y' AND                                      MD024336A
061000200528     C                             DDAcNoOK = 'Y'                                          MD024336A
061100200528     C                   EXSR      VAccntNm
061200200528     C                   ENDIF                                                             MD024336A
061300200528      /COPY WNCPYSRC,GLAMAD1V15                                                               CUT009
061400200528      ** Validate Date Account Opened
061500200528      /COPY WNCPYSRC,GLAMAD1V16                                                               CUT009
061600200528     C                   EXSR      VDatAcOp
061700200528                                                                                              CRE075
061800200528      ** Validate Effective Date for Retail Accounts                                          CRE075
061900200528                                                                                              CRE075
062000200528     C                   IF        CRE075 = 'Y'                                               CRE075
062100200528     C                   EXSR      VEffDate                                                   CRE075
062200200528     C                   ENDIF                                                                CRE075
062300200528                                                                                              CRE075
062400200528      /COPY WNCPYSRC,GLAMAD1V17                                                               CUT009
062500200528      *                                                                         180721
062600200528      ** Default Next Statement Date if necessary                               180721
062700200528     C     BGN4ST        Ifeq      'Y'                                          180721
062800200528     C     DDNSTD        Andeq     *blanks                                      180721
062900200528     C     DDCcyOK       Andeq     'Y'                                                        225892
063000200528     C                   Eval      DDNSTD = *blank                                            250822
063100200528     C                   EXSR      DNxtSDat                                     180721
063200200528     C                   Endif                                                  180721
063300200528      *                                                                         180721
063400200528      ** Validate Next Statement Date
063500200528      /COPY WNCPYSRC,GLAMAD1V18                                                               CUT009
063600200528     C                   EXSR      VNxtSDat
063700200528      /COPY WNCPYSRC,GLAMAD1V19                                                               CUT009
063800200528      ** Validate Frequency, No. of Copies, and Next Statement Day no.
063900200528      /COPY WNCPYSRC,GLAMAD1V20                                                               CUT009
064000200528     C                   EXSR      VFqNcNsd
064100200528      /COPY WNCPYSRC,GLAMAD1V21                                                               CUT009
064200200528      ** Validate Print Address Y/N, and Address Reference
064300200528      /COPY WNCPYSRC,GLAMAD1V22                                                               CUT009
064400200528     C                   EXSR      VPTADREF
064500200528      /COPY WNCPYSRC,GLAMAD1V23                                                               CUT009
064600200528      ** Validate Refer All and Block All
064700200528      /COPY WNCPYSRC,GLAMAD1V24                                                               CUT009
064800200528                                                                                              CRE075
064900200528      ** Process Defaulting of Refer and Block Debit/Credit if CRE075 is ON.                  CRE075
065000200528                                                                                              CRE075
065100200528     C                   IF        CRE075 = 'Y' AND WWRETL = 'Y'                              CRE075
065200200528                                                                                              CRE075
065300200528     C                   IF        DDEFDTOK <> 'N'                                            CRE075
065400200528     C                   EXSR      DRfrNBlk                                                   CRE075
065500200528     C                   ENDIF                                                                CRE075
065600200528                                                                                              CRE075
065700200528     C                   ELSE                                                                 CRE075
065800200528                                                                                              CRE075
065900200528     C     DDRAD         IFEQ      ' '                                                        203214
066000200528     C                   MOVE      'N'           DDRAD                                        203214
066100200528     C                   END                                                                  203214
066200200528     C     DDRAC         IFEQ      ' '                                                        203214
066300200528     C                   MOVE      'N'           DDRAC                                        203214
066400200528     C                   END                                                                  203214
066500200528     C     DDBAD         IFEQ      ' '                                                        203214
066600200528     C                   MOVE      'N'           DDBAD                                        203214
066700200528     C                   END                                                                  203214
066800200528     C     DDBAC         IFEQ      ' '                                                        203214
066900200528     C                   MOVE      'N'           DDBAC                                        203214
067000200528     C                   END                                                                  203214
067100200528                                                                                              CRE075
067200200528     C                   ENDIF                                                                CRE075
067300200528                                                                                              CRE075
067400200528     C                   EXSR      VRfrNBlk
067500200528      /COPY WNCPYSRC,GLAMAD1V25                                                               CUT009
067600200528      *                                                                                     AR761933
067700200528     C     BGN3ST        IFEQ      'Y'                                                      AR761933
067800200528     C     DDTIAC        ANDEQ     ' '                                                      AR761933
067900200528     C                   MOVE      'N'           DDTIAC                                     AR761933
068000200528     C                   ENDIF                                                              AR761933
068100200528      *                                                                                     AR761933
068200200528      ** Validate TI Account
068300200528      /COPY WNCPYSRC,GLAMAD1V26                                                               CUT009
068400200528     C                   EXSR      VTIAccnt
068500200528      /COPY WNCPYSRC,GLAMAD1V27                                                               CUT009
068600200528      ** Validate Statement Balance in Euros and Archiving Frequency
068700200528      /COPY WNCPYSRC,GLAMAD1V28                                                               CUT009
068800200528     C                   EXSR      VEUSBMFQ
068900200528      /COPY WNCPYSRC,GLAMAD1V29                                                               CUT009
069000200528      ** Validate Profit Centre and Portfolio Reference
069100200528      /COPY WNCPYSRC,GLAMAD1V30                                                               CUT009
069200200528     C     DDACODOK      IFEQ      'Y'                                                      BUG25813
069300200528     C                   EXSR      VPRFCPTF
069400200528     C                   ENDIF                                                              BUG25813
069500200528      /COPY WNCPYSRC,GLAMAD1V31                                                               CUT009
069600200528      ** Validate International Bank Account Number IBAN                        CFT004
069700200528      /COPY WNCPYSRC,GLAMAD1V32                                                               CUT009
069800200528     C     CFT004        IFEQ      'Y'                                          CFT004
069900200528      *                                                                                       262025
070000200528      ** Check the Generated Entry Method based on branch code used.                          262025
070100200528      *                                                                                       262025
070200200528     C     DDBRCA        CHAIN     SDBRCHL0                           90                      262025
070300200528     C     *IN90         IFEQ      *OFF                                                       262025
070400200528     C                   MOVEL     A8GENM        WGENM             1                          262025
070500200528     C                   ENDIF                                                                262025
070600200528      *                                                                                       262025
070700200528     C     *IN11         IFEQ      *OFF                                                       262025
070800200528     C     DDACTN        ANDEQ     'I'                                                        262025
070900200528     C     AMATYP        ANDEQ     'R'                                                        262025
071000200528     C     A8GENM        ANDNE     '1'                                                        262025
071100200528     C                   MOVEL     *BLANKS       DDIBAN                                       262025
071200200528     C                   ENDIF                                                                262025
071300200528      *                                                                                       262025
071400200528     C                   EXSR      ValIBAN                                      CFT004
071500200528     C                   ENDIF                                                  CFT004
071600200528      /COPY WNCPYSRC,GLAMAD1V33                                                               CUT009
071700200528      *                                                                                     BUG24157
071800200528      ** Validate KWG @24c reporting                                                        BUG24157
071900200528      *                                                                                     BUG24157
072000200528     C                   IF        CER047 = 'Y'                                             BUG24157
072100200528     C                   EXSR      SRVK24C                                                  BUG24157
072200200528     C                   ENDIF                                                              BUG24157
072300200528      *
072400200528     C     AMATYP        IFEQ      'R'                                                        239720
072500200528     C*****BGWDPR        IFEQ      'Y'                                                        239720
072600200528     C*****AMATYP        ANDEQ     'R'                                                        239720
072700200528      ***********                                                                             239720
072800200528     C*****BGSWRT        IFEQ      'Y'                                                        239720
072900200528     C*****BGNTST        OREQ      'Y'                                                        239720
073000200528     C*****FACH**        OREQ      'Y'                                                        239720
073100200528     C*****TSTMC*        OREQ      'Y'                                                        239720
073200200528      *
073300200528      ** Interest Taxable Flag
073400200528      /COPY WNCPYSRC,GLAMAD1V34                                                               CUT009
073500200528      ** Only validate if Taxable module switched ON                                          227198
073600200528     C     BGNTST        IFEQ      'Y'                                                        227198
073700200528     C                   EXSR      VITAXFLG
073800200528     C                   EXSR      VITAXCOD                                                   CGL165
073900200528     C                   ENDIF                                                                227198
074000200528      /COPY WNCPYSRC,GLAMAD1V35                                                               CUT009
074100200528      ** Statement Charge Flag
074200200528      /COPY WNCPYSRC,GLAMAD1V36                                                               CUT009
074300200528     C                   EXSR      VSTCIFLG
074400200528      /COPY WNCPYSRC,GLAMAD1V37                                                               CUT009
074500200528      ** Subject to Account Charge Flag
074600200528      /COPY WNCPYSRC,GLAMAD1V38                                                               CUT009
074700200528     C                   EXSR      VCHINFLG
074800200528      /COPY WNCPYSRC,GLAMAD1V39                                                               CUT009
074900200528      ** Account Charge Amount
075000200528      /COPY WNCPYSRC,GLAMAD1V40                                                               CUT009
075100200528     C                   EXSR      VCHAM
075200200528      /COPY WNCPYSRC,GLAMAD1V41                                                               CUT009
075300200528      *
075400200528     C**********         ENDIF                                                                239720
075500200528      *
075600200528     C                   ENDIF
075700200528      *
075800200528     C                   ENDIF
075900200528      *                                                                                     BUG16622
076000200528     C                   IF        DDACTN = 'D'                                             BUG16622
076100200528     C                   MOVEL     DDCUSN        KCNUM                                      BUG16622
076200200528     C                   MOVEL     DDCCY         KCCY                                       BUG16622
076300200528     C                   MOVEL     DDACOD        KACOD                                      BUG16622
076400200528     C                   MOVEL     DDACSQ        KACSQ                                      BUG16622
076500200528     C                   MOVEL     DDBRCA        KBRCA                                      BUG16622
076600200528     C     CHKACC        CHAIN     ACCNTABF                                                 BUG16622
076700200528     C                   IF        %FOUND(ACCNTL0)                                          BUG16622
076800200528     C                   IF        A1LDBL <> *ZEROS                                         BUG16622
076900200528     C                             OR A1CLBL <> *ZEROS                                      BUG16622
077000200528     C                   EXSR      RESETERRS                                                BUG16622
077100200528     C                   EVAL      WFldNmXAr(1) = '*ANY   '                                 BUG16622
077200200528     C                   EVAL      WMsgIDXAr(1) = 'RE77101'                                 BUG16622
077300200528     C                   EXSR      UPDATERRS                                                BUG16622
077400200528     C                   ENDIF                                                              BUG16622
077500200528     C                   ENDIF                                                              BUG16622
077600200528     C                   ENDIF                                                              BUG16622
077700200528      *
077800200528     C/COPY OFCPYSRCZ,CGL123_003                                                              CGL123
077900200528      *                                                                                       CER050
078000200528      ** Validate APR Flag                                                                    CER050
078100200528     C                   If        CER050 =  'Y'                                              CER050
078200200528     C                   EXSR      SRVAPRF                                                    CER050
078300200528     C                   EndIf                                                                CER050
078400200528      *  *-------------------------------------------------------*
078500200528      *  * If no errors set up outstanding fields for valid file *
078600200528      *  *-------------------------------------------------------*
078700200528
078800200528     C                   IF        Idx = 0
078900200528     C                   EXSR      SetupValid
079000200528     C                   ENDIF
079100200528      *
079200200528      * RETURN
079300200528      *
079400200528     C                   RETURN
079500200528      *****************************************************************
079600200528     C/EJECT
079700200528     C/COPY WNCPYSRC,GLAMA1VC03
079800200528      *****************************************************************
079900200528      ** VACCNTKY - Validate Action Code, A/c No. & Review from fld
080000200528      *****************************************************************
080100200528     C     VACCNTKY      BEGSR
080200200528
080300200528      * Reset variables updated by each module
080400200528
080500200528     C                   EXSR      RESETERRS
080600200528      *
080700200528     C                   CALLB     'GLVACCD'
080800200528      *
080900200528      * INPUTS
081000200528      *
081100200528      ** Return Code
081200200528     C                   Parm                    RetCodeOut
081300200528      *
081400200528      ** Account Screen fields
081500200528     C                   Parm                    DDACTN
081600200528     C                   Parm                    DDACCN
081700200528     C                   Parm                    DDRFRA
081800200528      *
081900200528     C                   Parm                    @IN34             1
082000200528      *
082100200528      ** ICD
082200200528     C                   Parm                    DBRN
082300200528     C                   Parm                    BJSBRC
082400200528     C                   Parm                    AGMBIN
082500200528      *
082600200528      * OUTPUTS
082700200528      *
082800200528      * Error fields/message IDs/message data (arrays) from/to caller
082900200528     C                   PARM                    FldNamXAr
083000200528     C                   PARM                    MsgIDXAr
083100200528     C                   PARM                    MsgDtaXAr
083200200528      *
083300200528      ** Full GL Account Number
083400200528     C**********         Parm      *BLANKS       WGLKEY           18                          CGL029
083500200528     C                   Parm      *BLANKS       WGLKEY           24                          CGL029
083600200528      *
083700200528      ** Action code - OK
083800200528      ** Account Number - OK
083900200528      ** Review From Account - OK
084000200528     C                   Parm                    DDACTNOK
084100200528     C                   Parm                    DDACCNOK
084200200528     C                   Parm                    DDRFRAOK
084300200528
084400200528      * Update error info with that returned from the validation module
084500200528
084600200528     C                   EXSR      UPDATERRS
084700200528      *
084800200528     C                   ENDSR
084900200528      *****************************************************************
085000200528     C/EJECT
085100200528      *****************************************************************
085200200528      ** VBRANCH - Validate Branch
085300200528      *****************************************************************
085400200528     C     VBRANCH       BEGSR
085500200528
085600200528      * Reset variables updated by each module
085700200528
085800200528     C                   EXSR      RESETERRS
085900200528      *
086000200528     C                   CALLB     'GLVBHCD01'
086100200528      *
086200200528      * INPUTS
086300200528      *
086400200528      ** Return Code
086500200528     C                   PARM                    RetCodeOut
086600200528      *
086700200528      ** Response mode (1A), from source system common header
086800200528     C                   PARM                    RespMode
086900200528      *
087000200528      ** Account Screen fields
087100200528     C                   PARM                    DDBRCA                         booking branch
087200200528     C                   Parm                    DDACTN
087300200528      *
087400200528      ** ICD
087500200528     C                   Parm                    BJSBRC
087600200528     C                   Parm                    DBRN
087700200528     C                   Parm                    AGMBIN
087800200528      *
087900200528      * OUTPUTS
088000200528      *
088100200528      * Error fields/message IDs/message data (arrays) from/to caller
088200200528     C                   PARM                    FldNamXAr
088300200528     C                   PARM                    MsgIDXAr
088400200528     C                   PARM                    MsgDtaXAr
088500200528      *
088600200528      ** Branch Internal Customer
088700200528     C                   Parm                    A8BICN            6
088800200528      *
088900200528      ** Branch code - OK
089000200528     C                   Parm                    DDBrcaOK                         action code
089100200528
089200200528      * Update error info with that returned from the validation module
089300200528
089400200528     C                   EXSR      UPDATERRS
089500200528      *
089600200528     C                   ENDSR
089700200528      *****************************************************************
089800200528     C/EJECT
089900200528      *****************************************************************
090000200528      ** VCUSTNO - Validate Customer Number
090100200528      *****************************************************************
090200200528     C     VCUSTNO       BEGSR
090300200528
090400200528      * Reset variables updated by each module
090500200528
090600200528     C                   EXSR      RESETERRS
090700200528      *
090800200528      ** Validate Customer, Book, Portfolio & Profit Centre
090900200528      *
091000200528     C                   CALLB     'GLVCSNB'
091100200528      *
091200200528      * INPUTS
091300200528      *
091400200528      ** Return Code
091500200528     C                   PARM                    RetCodeOut
091600200528      *
091700200528      ** Account Screen fields
091800200528     C                   PARM                    DDCUSN                         action code
091900200528      *
092000200528      ** Action Code field                                                                    CSD025
092100200528     C                   PARM                    DDACTN                                       CSD025
092200200528      *                                                                                       CSD025
092300200528      * OUTPUTS
092400200528      *
092500200528      * Error fields/message IDs/message data (arrays) from/to caller
092600200528     C                   PARM                    FldNamXAr
092700200528     C                   PARM                    MsgIDXAr
092800200528     C                   PARM                    MsgDtaXAr
092900200528      *
093000200528      ** Customer - OK
093100200528     C                   PARM                    DDCUSNOK                       customer
093200200528
093300200528      * Update error info with that returned from the validation module
093400200528
093500200528     C                   EXSR      UPDATERRS
093600200528      *
093700200528     C                   ENDSR
093800200528      *****************************************************************
093900200528     C/EJECT
094000200528      *****************************************************************
094100200528      ** VCURRENCY - Validate Currency
094200200528      *****************************************************************
094300200528     C     VCURRENCY     BEGSR
094400200528
094500200528      * Reset variables updated by each module
094600200528
094700200528     C                   EXSR      RESETERRS
094800200528      *
094900200528     C                   CALLB     'GLVCYCY'
095000200528      *
095100200528      * INPUTS
095200200528      *
095300200528      ** Return Code
095400200528     C                   PARM                    RetCodeOut
095500200528      *
095600200528      ** Account Screen fields
095700200528     C                   PARM                    DDCCY                          booking branch
095800200528      *
095900200528      * OUTPUTS
096000200528      *
096100200528      * Error fields/message IDs/message data (arrays) from/to caller
096200200528     C                   PARM                    FldNamXAr
096300200528     C                   PARM                    MsgIDXAr
096400200528     C                   PARM                    MsgDtaXAr
096500200528      *
096600200528      ** Currency - OK
096700200528     C                   PARM                    DDCcyOK                          action code
096800200528
096900200528      * Update error info with that returned from the validation module
097000200528
097100200528     C                   EXSR      UPDATERRS
097200200528      *
097300200528     C                   ENDSR
097400200528      *****************************************************************
097500200528     C/EJECT
097600200528      *****************************************************************
097700200528      ** VACSQ    - Validate Account Code and Sequence
097800200528      *****************************************************************
097900200528     C     VACSQ         BEGSR
098000200528
098100200528      * Reset variables updated by each module
098200200528
098300200528     C                   EXSR      RESETERRS
098400200528      *
098500200528     C                   CALLB     'GLVACSQ'
098600200528      *
098700200528      * INPUTS
098800200528      *
098900200528      ** Return Code
099000200528     C                   PARM                    RetCodeOut
099100200528      *
099200200528      ** Account Screen fields
099300200528     C                   Parm                    DDACod                         customer
099400200528     C                   Parm                    DDAcSq                         customer
099500200528     C                   Parm                    DDCUSN                         customer
099600200528      *
099700200528      ** ICD
099800200528     C                   Parm                    A8BICN
099900200528     C                   Parm                    AGMBIN
100000200528      *
100100200528      * OUTPUTS
100200200528      *
100300200528      * Error fields/message IDs/message data (arrays) from/to caller
100400200528     C                   PARM                    FldNamXAr
100500200528     C                   PARM                    MsgIDXAr
100600200528     C                   PARM                    MsgDtaXAr
100700200528      *
100800200528     C                   Parm                    AMATYP            1
100900200528     C                   Parm                    AMSTYP            1
101000200528     C                   Parm                    A5TOIN            1
101100200528     C                   Parm                    WWRETL            1
101200200528      *
101300200528      ** Account Code - Ok
101400200528      ** Account Seq  - Ok
101500200528     C                   Parm                    DDACodOk                       customer
101600200528     C                   Parm                    DDAcSqOk                       customer
101700200528
101800200528      * Update error info with that returned from the validation module
101900200528
102000200528     C                   EXSR      UPDATERRS
102100200528      *
102200200528     C                   ENDSR
102300200528      *****************************************************************
102400200528     C/EJECT
102500200528      *****************************************************************
102600200528      ** VACCOUNT - Validate GL & Retail Account Number
102700200528      *****************************************************************
102800200528     C     VACCOUNT      BEGSR
102900200528
103000200528      * Reset variables updated by each module
103100200528
103200200528     C                   EXSR      RESETERRS
103300200528      *
103400200528     C                   CALLB     'GLVRLAC'
103500200528      *
103600200528      * INPUTS
103700200528      *
103800200528      ** Return Code
103900200528     C                   PARM                    RetCodeOut
104000200528      *
104100200528      ** Account Screen fields
104200200528     C                   Parm                    DDActn
104300200528     C                   Parm                    DDBrca
104400200528     C                   Parm                    DDCUSN
104500200528     C                   Parm                    DDCcy
104600200528     C                   Parm                    DDACod
104700200528     C                   Parm                    DDAcSq
104800200528     C                   Parm                    DDAcNo
104900200528     C                   Parm                    DDANam
105000200528      *
105100200528      ** Output of Sr/VACSQ
105200200528     C                   Parm                    WWRetl
105300200528      *
105400200528      ** ICD
105500200528     C                   Parm                    BMRANR
105600200528     C                   Parm                    BMLDAI
105700200528     C                   Parm                    BGN1ST
105800200528     C**********         Parm                    BJRDNB                                       CSC011
105900200528     C                   PARM                    WRunDay                                      CSC011
106000200528      *
106100200528      ** Access from SDACODPD from pgm/GLVACSQ
106200200528     C                   Parm                    A5TOIN
106300200528      *
106400200528      * OUTPUTS
106500200528      *
106600200528      * Error fields/message IDs/message data (arrays) from/to caller
106700200528     C                   PARM                    FldNamXAr
106800200528     C                   PARM                    MsgIDXAr
106900200528     C                   PARM                    MsgDtaXAr
107000200528      *
107100200528      ** Account Name - Ok
107200200528      ** Retail Account - Ok
107300200528      ** Customer - OK
107400200528      ** Currency - OK
107500200528      ** Account code - OK
107600200528      ** Account Seq - OK
107700200528     C                   Parm                    DDANamOK
107800200528     C                   Parm                    DDAcNoOK
107900200528     C                   Parm                    DDCUSNOK
108000200528     C                   Parm                    DDCcyOK
108100200528     C                   Parm                    DDACodOK
108200200528     C                   Parm                    DDAcSqOK
108300200528                                                                                             BUG4615
108400200528      * Warning message IDs/message data (arrays) from/to caller                             BUG4615
108500200528                                                                                             BUG4615
108600200528     C                   PARM                    WFldNmXAr                                   BUG4615
108700200528     C                   PARM                    WMsgIDXAr                                   BUG4615
108800200528     C                   PARM                    WMsgDtXAr                                   BUG4615
108900200528
109000200528      * Update error info with that returned from the validation module
109100200528
109200200528     C     RetCodeOut    IFNE      *BLANKS                                                    262025
109300200528     C                   MOVE      *ON           *IN11                                        262025
109400200528     C                   ELSE                                                                 262025
109500200528     C                   MOVE      *OFF          *IN11                                        262025
109600200528     C                   ENDIF                                                                262025
109700200528      *                                                                                       262025
109800200528     C                   EXSR      UPDATERRS
109900200528      *
110000200528     C                   ENDSR
110100200528      *****************************************************************
110200200528     C/EJECT
110300200528      *****************************************************************
110400200528      ** VACCNTNM - Validate Account Name
110500200528      *****************************************************************
110600200528     C     VACCNTNM      BEGSR
110700200528
110800200528      * Reset variables updated by each module
110900200528
111000200528     C                   EXSR      RESETERRS
111100200528      *
111200200528     C                   CALLB     'GLVACNM'
111300200528      *
111400200528      * INPUTS
111500200528      *
111600200528      ** Return Code
111700200528     C                   Parm                    RetCodeOut
111800200528      *
111900200528      ** Account Screen fields
112000200528     C                   Parm                    DDANAM
112100200528      *
112200200528      * OUTPUTS
112300200528      *
112400200528      * Error fields/message IDs/message data (arrays) from/to caller
112500200528     C                   PARM                    FldNamXAr
112600200528     C                   PARM                    MsgIDXAr
112700200528     C                   PARM                    MsgDtaXAr
112800200528      *
112900200528      ** Account Name - Ok
113000200528     C                   Parm                    DDANamOK
113100200528
113200200528      * Update error info with that returned from the validation module
113300200528
113400200528     C                   EXSR      UPDATERRS
113500200528      *
113600200528     C                   ENDSR
113700200528      *****************************************************************
113800200528     C/EJECT
113900200528      *****************************************************************
114000200528      ** VDATACOP - Validate Date Account Opend
114100200528      *****************************************************************
114200200528     C     VDATACOP      BEGSR
114300200528
114400200528      * Reset variables updated by each module
114500200528
114600200528     C                   EXSR      RESETERRS
114700200528      *
114800200528     C                   CALLB     'GLVACDT'
114900200528      *
115000200528      * INPUTS
115100200528      *
115200200528      ** Return Code
115300200528     C                   Parm                    RetCodeOut
115400200528      *
115500200528      ** Account Screen fields
115600200528     C                   Parm                    DDACTN
115700200528     C                   Parm                    DDDACO
115800200528      *
115900200528      ** ICD
116000200528     C**********         Parm                    BJRDNB                                       CSC011
116100200528     C                   PARM                    WRunDay                                      CSC011
116200200528     C                   Parm                    BJDFIN
116300200528     C                   Parm                    BJBVPD
116400200528      *
116500200528      * OUTPUTS
116600200528      *
116700200528      * Error fields/message IDs/message data (arrays) from/to caller
116800200528     C                   PARM                    FldNamXAr
116900200528     C                   PARM                    MsgIDXAr
117000200528     C                   PARM                    MsgDtaXAr
117100200528      *
117200200528      ** Date Account Open work field
117300200528     C                   Parm      *ZERO         WWDAcO            5 0
117400200528      *
117500200528      ** Date Account Open - Ok
117600200528     C                   Parm                    DDDAcOOk
117700200528
117800200528      * Update error info with that returned from the validation module
117900200528
118000200528     C                   EXSR      UPDATERRS
118100200528      *
118200200528     C                   ENDSR
118300200528      *****************************************************************
118400200528     C/EJECT                                                                    180721
118500200528      *****************************************************************                       CRE075
118600200528      ** VEFFDATE - Validate Effective Date for Retail Accounts                               CRE075
118700200528      *****************************************************************                       CRE075
118800200528     C     VEFFDATE      BEGSR                                                                CRE075
118900200528                                                                                              CRE075
119000200528      ** Effective Date should only be validated if Date Account Opened                       CRE075
119100200528      ** is valid.                                                                            CRE075
119200200528                                                                                              CRE075
119300200528     C                   IF        DDDAcOOk = 'Y'                                             CRE075
119400200528                                                                                              CRE075
119500200528      ** Reset variables updated by each module                                               CRE075
119600200528                                                                                              CRE075
119700200528     C                   EXSR      RESETERRS                                                  CRE075
119800200528                                                                                              CRE075
119900200528     C                   CALLB     'GLVEFDT'                                                  CRE075
120000200528                                                                                              CRE075
120100200528      ** INPUTS                                                                               CRE075
120200200528                                                                                              CRE075
120300200528      ** Return Code                                                                          CRE075
120400200528                                                                                              CRE075
120500200528     C                   PARM                    RetCodeOut                                   CRE075
120600200528                                                                                              CRE075
120700200528      ** Account Screen fields                                                                CRE075
120800200528                                                                                              CRE075
120900200528     C                   PARM                    DDACTN                         Action code   CRE075
121000200528     C                   PARM                    DDDACO                         DateAccntOpen CRE075
121100200528     C                   PARM                    DDEFDT            6            Effective DateCRE075
121200200528     C                   PARM                    DDCCY                          CCY           CRE075
121300200528     C                   PARM                    DDBRCA                         Booking BranchCRE075
121400200528     C                   PARM                    WWRETL                         Retail Flag   CRE075
121500200528     C                   PARM                    WWDAcO                                       CRE075
121600200528                                                                                              CRE075
121700200528      ** ICD                                                                                  CRE075
121800200528                                                                                              CRE075
121900200528     C                   PARM                    WRunDay                                      CRE075
122000200528     C                   PARM                    BJDFIN                                       CRE075
122100200528     C                   PARM                    BJBVPD                                       CRE075
122200200528     C                   PARM                    BJLCCY                                       CRE075
122300200528     C                   PARM                    BJSLCD                                       CRE075
122400200528                                                                                              CRE075
122500200528      ** Account Key                                                                          CRE075
122600200528                                                                                              CRE075
122700200528     C                   PARM                    DDCUSN                                       CRE075
122800200528     C                   PARM                    DDACOD                                       CRE075
122900200528     C                   PARM                    DDACSQ                                       CRE075
123000200528                                                                                              CRE075
123100200528      ** OUTPUTS                                                                              CRE075
123200200528      ** Error fields/message IDs/message data (arrays) from/to caller                        CRE075
123300200528                                                                                              CRE075
123400200528     C                   PARM                    FldNamXAr                                    CRE075
123500200528     C                   PARM                    MsgIDXAr                                     CRE075
123600200528     C                   PARM                    MsgDtaXAr                                    CRE075
123700200528                                                                                              CRE075
123800200528      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE075
123900200528                                                                                              CRE075
124000200528     C                   PARM                    WFldNmXAr                                    CRE075
124100200528     C                   PARM                    WMsgIDXAr                                    CRE075
124200200528     C                   PARM                    WMsgDtXAr                                    CRE075
124300200528                                                                                              CRE075
124400200528      ** Effective Date work field                                                            CRE075
124500200528                                                                                              CRE075
124600200528     C                   PARM      *ZERO         WWEfdt            5 0                        CRE075
124700200528                                                                                              CRE075
124800200528      ** Effective date - Ok                                                                  CRE075
124900200528                                                                                              CRE075
125000200528     C                   PARM                    DDEFDTOK                                     CRE075
125100200528                                                                                              CRE075
125200200528      ** Update error info with that returned from the validation module                      CRE075
125300200528                                                                                              CRE075
125400200528     C                   EXSR      UPDATERRS                                                  CRE075
125500200528                                                                                              CRE075
125600200528     C                   ENDIF                                                                CRE075
125700200528     C                   ENDSR                                                                CRE075
125800200528      *****************************************************************                       CRE075
125900200528     C/EJECT                                                                                  CRE075
126000200528      *****************************************************************                       CRE075
126100200528      ** DRFRNBLK - Default Refer and Block Debit/Crebit                                      CRE075
126200200528      *****************************************************************                       CRE075
126300200528     C     DRfrNBlk      BEGSR                                                                CRE075
126400200528                                                                                              CRE075
126500200528      ** If a New Retail account is opened and the Effective Date is                          CRE075
126600200528      ** greater than rundate, values are defaulted as follows:                               CRE075
126700200528                                                                                              CRE075
126800200528     C                   IF        (DDACTN = 'I' OR                                           CRE075
126900200528     C                              DDACTN = 'A') AND                                         CRE075
127000200528     C                             WWEfDt > BJRDNB                                            CRE075
127100200528      *                                                                                    AR760540A
127200200528     C     DDBAD         IFEQ      ' '                                                     AR760540A
127300200528     C                   MOVE      'Y'           DDBAD                                     AR760540A
127400200528     C                   END                                                               AR760540A
127500200528     C     DDBAC         IFEQ      ' '                                                     AR760540A
127600200528     C                   MOVE      'Y'           DDBAC                                     AR760540A
127700200528     C                   END                                                               AR760540A
127800200528     C     DDRAD         IFEQ      ' '                                                     AR760540A
127900200528     C                   MOVE      'N'           DDRAD                                     AR760540A
128000200528     C                   END                                                               AR760540A
128100200528     C     DDRAC         IFEQ      ' '                                                     AR760540A
128200200528     C                   MOVE      'N'           DDRAC                                     AR760540A
128300200528     C                   END                                                               AR760540A
128400200528                                                                                              CRE075
128500200528      ** If not equal to the default values issue warning message                             CRE075
128600200528                                                                                              CRE075
128700200528     C                   IF        DDRAD <> 'N' OR                                            CRE075
128800200528     C                             DDRAC <> 'N' OR                                            CRE075
128900200528     C                             DDBAD <> 'Y' OR                                            CRE075
129000200528     C                             DDBAC <> 'Y'                                               CRE075
129100200528                                                                                              CRE075
129200200528     C                   EVAL      WIdx = 1                                                   CRE075
129300200528     C                   EVAL      WFldNmXAr(WIdx) = '*ANY  '                                 CRE075
129400200528     C                   EVAL      WMsgIDXAr(WIdx) = 'RE71076'                                CRE075
129500200528     C                   EXSR      UPDATERRS                                                  CRE075
129600200528     C                   ENDIF                                                                CRE075
129700200528                                                                                              CRE075
129800200528     C                   ELSE                                                                 CRE075
129900200528                                                                                              CRE075
130000200528      ** If a New Retail account is opened with Effective Date less                           CRE075
130100200528      ** or equalto rundate, or if the Effective Date of an existing                          CRE075
130200200528      ** Retail Account is amended to be less than or equal to run-                           CRE075
130300200528      ** date, these field should be defaulted as follows:                                    CRE075
130400200528                                                                                              CRE075
130500200528     C                   IF        (DDACTN = 'I' OR                                           CRE075
130600200528     C                              DDACTN = 'A') AND                                         CRE075
130700200528     C                             WWEfDt <= BJRDNB                                           CRE075
130800200528      *                                                                                    AR760540A
130900200528     C     DDBAD         IFEQ      ' '                                                     AR760540A
131000200528     C                   MOVE      'N'           DDBAD                                     AR760540A
131100200528     C                   END                                                               AR760540A
131200200528     C     DDBAC         IFEQ      ' '                                                     AR760540A
131300200528     C                   MOVE      'N'           DDBAC                                     AR760540A
131400200528     C                   END                                                               AR760540A
131500200528     C     DDRAD         IFEQ      ' '                                                     AR760540A
131600200528     C                   MOVE      'N'           DDRAD                                     AR760540A
131700200528     C                   END                                                               AR760540A
131800200528     C     DDRAC         IFEQ      ' '                                                     AR760540A
131900200528     C                   MOVE      'N'           DDRAC                                     AR760540A
132000200528     C                   END                                                               AR760540A
132100200528                                                                                              CRE075
132200200528      ** If not equal to the default values issue warning message                             CRE075
132300200528                                                                                              CRE075
132400200528     C                   IF        DDRAD <> 'N' OR                                            CRE075
132500200528     C                             DDRAC <> 'N' OR                                            CRE075
132600200528     C                             DDBAD <> 'N' OR                                            CRE075
132700200528     C                             DDBAC <> 'N'                                               CRE075
132800200528     C                   EVAL      WIdx = 1                                                   CRE075
132900200528     C                   EVAL      WFldNmXAr(WIdx) = '*ANY  '                                 CRE075
133000200528     C                   EVAL      WMsgIDXAr(WIdx) = 'RE71077'                                CRE075
133100200528     C                   EXSR      UPDATERRS                                                  CRE075
133200200528     C                   ENDIF                                                                CRE075
133300200528                                                                                              CRE075
133400200528     C                   ENDIF                                                                CRE075
133500200528     C                   ENDIF                                                                CRE075
133600200528                                                                                              CRE075
133700200528     C                   ENDSR                                                                CRE075
133800200528      *****************************************************************                       CRE075
133900200528     C/EJECT                                                                                  CRE075
134000200528      *****************************************************************         180721
134100200528      ** DNXTSDAT - Default Next Statement Date                                 180721
134200200528      *****************************************************************         180721
134300200528     C     DNXTSDAT      BEGSR                                                  180721
134400200528                                                                                180721
134500200528      * Reset variables updated by each module                                  180721
134600200528                                                                                180721
134700200528     C                   EXSR      RESETERRS                                    180721
134800200528      *                                                                         180721
134900200528     C/COPY WNCPYSRC,GLH00799
135000200528     C                   CALLB     'GLDSMDT'                                    180721
135100200528      *                                                                         180721
135200200528      * INPUTS                                                                  180721
135300200528      *                                                                         180721
135400200528      ** Return Code                                                            180721
135500200528     C                   Parm                    RetCodeOut                     180721
135600200528      *                                                                         180721
135700200528      ** Account Screen fields                                                  180721
135800200528     C                   Parm                    DDCCY                          180721
135900200528     C                   Parm                    DDSTFQ                         180721
136000200528     C                   Parm                    DDNSDN                         180721
136100200528      *                                                                         180721
136200200528      ** ICD                                                                    180721
136300200528     C                   Parm                    SDBANK                         180721
136400200528     C                   Parm                    SDGELR                         180721
136500200528     C                   Parm                    CGL184                                       CGL184
136600200528      *                                                                         180721
136700200528      * OUTPUTS                                                                 180721
136800200528      *                                                                         180721
136900200528      ** Next Statement Date                                                    180721
137000200528     C                   Parm                    DDNSTD                         180721
137100200528      *                                                                         180721
137200200528      * Error fields/message IDs/message data (arrays) from/to caller           180721
137300200528     C                   PARM                    FldNamXAr                      180721
137400200528     C                   PARM                    MsgIDXAr                       180721
137500200528     C                   PARM                    MsgDtaXAr                      180721
137600200528      *                                                                         180721
137700200528      ** Next Statement Date - Ok                                               180721
137800200528     C                   Parm                    DDNStDOk                       180721
137900200528                                                                                180721
138000200528     C/COPY WNCPYSRC,GLH00800
138100200528      * Update error info with that returned from the validation module         180721
138200200528                                                                                180721
138300200528     C                   EXSR      UPDATERRS                                    180721
138400200528      *                                                                         180721
138500200528     C                   ENDSR                                                  180721
138600200528      *****************************************************************         180721
138700200528     C/EJECT
138800200528      *****************************************************************
138900200528      ** VNXTSDAT - Validate Next Statement Date
139000200528      *****************************************************************
139100200528     C     VNXTSDAT      BEGSR
139200200528
139300200528      * Reset variables updated by each module
139400200528
139500200528     C                   EXSR      RESETERRS
139600200528      *
139700200528     C                   CALLB     'GLVSMDT'
139800200528      *
139900200528      * INPUTS
140000200528      *
140100200528      ** Return Code
140200200528     C                   Parm                    RetCodeOut
140300200528      *
140400200528      ** Account Screen fields
140500200528     C                   Parm                    DDNSTD
140600200528     C                   Parm                    DDSTFQ
140700200528      *
140800200528      ** Passed from GLVACDT
140900200528     C                   Parm                    WWDACO
141000200528      *
141100200528      ** ICD
141200200528     C**********         Parm                    BJRDNB                                       CSC011
141300200528     C                   PARM                    WRunDay                                      CSC011
141400200528     C                   Parm                    BJDFIN
141500200528     C                   Parm                    BKAPDT
141600200528     C/COPY WNCPYSRC,GLH00718
141700200528      *
141800200528      * OUTPUTS
141900200528      *
142000200528      * Error fields/message IDs/message data (arrays) from/to caller
142100200528     C                   PARM                    FldNamXAr
142200200528     C                   PARM                    MsgIDXAr
142300200528     C                   PARM                    MsgDtaXAr
142400200528      *
142500200528      ** Next Statement Date work field
142600200528     C                   Parm      *ZERO         WWNSTD            5 0
142700200528      *
142800200528      ** Next Statement Date - Ok
142900200528     C                   Parm                    DDNStDOk
143000200528
143100200528      * Update error info with that returned from the validation module
143200200528
143300200528     C                   EXSR      UPDATERRS
143400200528      *
143500200528     C                   ENDSR
143600200528      *****************************************************************
143700200528     C/EJECT
143800200528      *****************************************************************
143900200528      ** VFQNCNSD - Validate Freq, No of Copies and Next Statement Day no.
144000200528      *****************************************************************
144100200528     C     VFQNCNSD      BEGSR
144200200528
144300200528     C                   MoveL     *Blanks       WDAY              2
144400200528     C     BJDFIN        IfEq      'D'
144500200528     C                   MoveL     DDNSTD        WDAY
144600200528     C                   Else
144700200528     C                   Eval      WDAY = %Subst(DDNSTD:3)
144800200528     C                   EndIf
144900200528      *                                                                                    AR1021393
145000200528      ** If Amend, include the current stmt freq value in the parameter                    AR1021393
145100200528      *                                                                                    AR1021393
145200200528     C     DDACTN        IfEq      'A'                                                     AR1021393
145300200528     C     AMORED        AndNe     BJRDNB                                                  AR1021393
145400200528     C                   MoveL     AMSTFQ        WWSTFQ            1                       AR1021393
145500200528     C                   Else                                                              AR1021393
145600200528     C                   MoveL     DDSTFQ        WWSTFQ                                    AR1021393
145700200528     C                   EndIf                                                             AR1021393
145800200528      *
145900200528      * Reset variables updated by each module
146000200528
146100200528     C                   EXSR      RESETERRS
146200200528      *
146300200528     C/COPY WNCPYSRC,GLAMA1VC01
146400200528     C                   CALLB     'GLVSMFQ'
146500200528     C/COPY WNCPYSRC,GLAMA1VC02
146600200528      *
146700200528      * INPUTS
146800200528      *
146900200528      ** Return Code
147000200528     C                   Parm                    RetCodeOut
147100200528      *
147200200528      ** Account Screen fields
147300200528     C                   Parm                    DDStFq
147400200528     C                   Parm                    DDENoC
147500200528     C                   Parm                    DDNSDN
147600200528     C/COPY WNCPYSRC,GLH00719
147700200528      *
147800200528      ** Next Statement Date - Ok
147900200528     C                   Parm                    DDNStDOk
148000200528      *
148100200528      ** ICD
148200200528     C                   Parm                    TTURN
148300200528     C                   Parm                    CNDS
148400200528      *
148500200528      ** Day no in next statement date field
148600200528     C                   Parm                    WDAY
148700200528      *
148800200528     C                   Parm                    CGL184                                       CGL184
148900200528     C                   Parm                    WWSTFQ                                    AR1021393
149000200528      * OUTPUTS
149100200528      *
149200200528      * Error fields/message IDs/message data (arrays) from/to caller
149300200528     C                   PARM                    FldNamXAr
149400200528     C                   PARM                    MsgIDXAr
149500200528     C                   PARM                    MsgDtaXAr
149600200528      *
149700200528      ** Statement Frequency - Ok
149800200528      ** Number of Copies - Ok
149900200528      ** Next Statement Day No - Ok
150000200528     C                   Parm                    DDStFqOk
150100200528     C                   Parm                    DDENoCOk
150200200528     C                   Parm                    DDNSDNOk
150300200528                                                                                           AR1021393
150400200528      * Warning message IDs/message data (arrays) from/to caller                           AR1021393
150500200528                                                                                           AR1021393
150600200528     C                   PARM                    WFldNmXAr                                 AR1021393
150700200528     C                   PARM                    WMsgIDXAr                                 AR1021393
150800200528     C                   PARM                    WMsgDtXAr                                 AR1021393
150900200528
151000200528      * Update error info with that returned from the validation module
151100200528
151200200528     C                   EXSR      UPDATERRS
151300200528      *
151400200528     C                   ENDSR
151500200528      *****************************************************************
151600200528     C/EJECT
151700200528      *****************************************************************
151800200528      ** VPTADREF - Validate Print Addrs Y/N, and Address Reference
151900200528      *****************************************************************
152000200528     C     VPTADREF      BEGSR
152100200528
152200200528      * Reset variables updated by each module
152300200528
152400200528     C                   EXSR      RESETERRS
152500200528      *
152600200528     C                   CALLB     'GLVPIAD'
152700200528      *
152800200528      * INPUTS
152900200528      *
153000200528      ** Return Code
153100200528     C                   Parm                    RetCodeOut
153200200528      *
153300200528      ** Account Screen fields
153400200528     C                   Parm                    DDREF
153500200528     C                   Parm                    DDPTAD
153600200528     C                   Parm                    DDCUSN
153700200528      *
153800200528      * OUTPUTS
153900200528      *
154000200528      * Error fields/message IDs/message data (arrays) from/to caller
154100200528     C                   PARM                    FldNamXAr
154200200528     C                   PARM                    MsgIDXAr
154300200528     C                   PARM                    MsgDtaXAr
154400200528      *
154500200528      ** Address Reference - Ok
154600200528      ** Print Address Ref - Ok
154700200528     C                   Parm                    DDRefOk
154800200528     C                   Parm                    DDPtAdOk
154900200528
155000200528      * Update error info with that returned from the validation module
155100200528
155200200528     C                   EXSR      UPDATERRS
155300200528      *
155400200528     C                   ENDSR
155500200528      *****************************************************************
155600200528     C/EJECT
155700200528      *****************************************************************
155800200528      ** VRFRNBLK - Validate Refer All and Block All
155900200528      *****************************************************************
156000200528     C     VRFRNBLK      BEGSR
156100200528
156200200528      * Reset variables updated by each module
156300200528
156400200528     C                   EXSR      RESETERRS
156500200528      *
156600200528     C                   CALLB     'GLVMCMC'
156700200528      *
156800200528      * INPUTS
156900200528      *
157000200528      ** Return Code
157100200528     C                   Parm                    RetCodeOut
157200200528      *
157300200528      ** Account Screen fields
157400200528     C                   Parm                    DDRAD
157500200528     C                   Parm                    DDRAC
157600200528     C                   Parm                    DDBAD
157700200528     C                   Parm                    DDBAC
157800200528      *
157900200528      * OUTPUTS
158000200528      *
158100200528      * Error fields/message IDs/message data (arrays) from/to caller
158200200528     C                   PARM                    FldNamXAr
158300200528     C                   PARM                    MsgIDXAr
158400200528     C                   PARM                    MsgDtaXAr
158500200528      *
158600200528      ** Refer All Debits - Ok
158700200528      ** Refer All Credits - Ok
158800200528      ** Block All Debits - Ok
158900200528      ** Block All Credits - Ok
159000200528     C                   Parm                    DDRADOk
159100200528     C                   Parm                    DDRACOk
159200200528     C                   Parm                    DDBADOk
159300200528     C                   Parm                    DDBACOk
159400200528
159500200528      * Update error info with that returned from the validation module
159600200528
159700200528     C                   EXSR      UPDATERRS
159800200528      *
159900200528     C                   ENDSR
160000200528      *****************************************************************
160100200528     C/EJECT
160200200528      *****************************************************************
160300200528      ** VTIACCNT - Validate TI Account
160400200528      *****************************************************************
160500200528     C     VTIACCNT      BEGSR
160600200528
160700200528      * Reset variables updated by each module
160800200528
160900200528     C                   EXSR      RESETERRS
161000200528      *
161100200528     C                   CALLB     'GLVTIAC'
161200200528      *
161300200528      * INPUTS
161400200528      *
161500200528      ** Return Code
161600200528     C                   Parm                    RetCodeOut
161700200528      *
161800200528      ** Account Screen fields
161900200528     C                   Parm                    DDACTN
162000200528     C                   Parm                    DDTIAC
162100200528     C                   Parm                    DDTIAN
162200200528     C                   Parm                    DDTIAS
162300200528     C                   Parm                    DDACOD
162400200528     C                   Parm                    DDBRCA
162500200528     C                   Parm                    DDCUSN
162600200528     C                   Parm                    DDCCY
162700200528     C                   Parm                    DDACSQ                                      BUG3365
162800200528      *
162900200528     C                   Parm                    AMA5TIAC
163000200528      *
163100200528      ** ICD
163200200528     C                   Parm                    BGN3ST
163300200528      *
163400200528      * OUTPUTS
163500200528      *
163600200528      * Error fields/message IDs/message data (arrays) from/to caller
163700200528     C                   PARM                    FldNamXAr
163800200528     C                   PARM                    MsgIDXAr
163900200528     C                   PARM                    MsgDtaXAr
164000200528      *
164100200528      * Warning message IDs/message data (arrays) from/to caller
164200200528     C                   PARM                    WFldNmXAr
164300200528     C                   PARM                    WMsgIDXAr
164400200528     C                   PARM                    WMsgDtXAr
164500200528      *
164600200528      ** Indicator 76 & 89 for used in display file
164700200528     C                   Parm                    WIN76             1
164800200528     C                   Parm                    WIN89             1
164900200528      *
165000200528      ** TI Account - OK
165100200528      ** TI Account Number - OK
165200200528      ** TI Account Suffix - OK
165300200528     C                   Parm                    DDTIACOk
165400200528     C                   Parm                    DDTIANOk
165500200528     C                   Parm                    DDTIASOk
165600200528     C                   Parm                    Idx                                         BUG5340
165700200528     C                   Parm                    WIdx                                        BUG5340
165800200528
165900200528      * Update error info with that returned from the validation module
166000200528
166100200528     C                   EXSR      UPDATERRS
166200200528      *
166300200528     C                   ENDSR
166400200528      *****************************************************************
166500200528     C/EJECT
166600200528      *****************************************************************
166700200528      ** VEUSBMFQ - Validate Statement Bal in Euros and Archiving Freq
166800200528      *****************************************************************
166900200528     C     VEUSBMFQ      BEGSR
167000200528
167100200528      * Reset variables updated by each module
167200200528
167300200528     C                   EXSR      RESETERRS
167400200528      *
167500200528     C                   CALLB     'GLVEUBL'
167600200528      *
167700200528      * INPUTS
167800200528      *
167900200528      ** Return Code
168000200528     C                   Parm                    RetCodeOut
168100200528      *
168200200528      ** Account Screen fields
168300200528     C                   Parm                    DDEUSB
168400200528     C                   Parm                    DDMFFQ
168500200528     C                   Parm                    DDCCY
168600200528      *
168700200528      ** ICD
168800200528     C                   Parm                    CEU013
168900200528     C                   Parm                    BGMFIC
169000200528     C**********         Parm                    BJRDNB                                       CSC011
169100200528     C                   PARM                    WRunDay                                      CSC011
169200200528      *
169300200528      * OUTPUTS
169400200528      *
169500200528      * Error fields/message IDs/message data (arrays) from/to caller
169600200528     C                   PARM                    FldNamXAr
169700200528     C                   PARM                    MsgIDXAr
169800200528     C                   PARM                    MsgDtaXAr
169900200528      *
170000200528      ** Statement Bal. in Euros - Ok
170100200528      ** Mrichofiche Frequency - Ok
170200200528     C                   Parm                    DDEUSBOk
170300200528     C                   Parm                    DDMFFQOk
170400200528
170500200528      * Update error info with that returned from the validation module
170600200528
170700200528     C                   EXSR      UPDATERRS
170800200528      *
170900200528     C                   ENDSR
171000200528      *****************************************************************
171100200528     C/EJECT
171200200528      *****************************************************************
171300200528      ** VPRFCPTF - Validate Profit Centre & Portfolio Reference
171400200528      *****************************************************************
171500200528     C     VPRFCPTF      BEGSR
171600200528
171700200528      * Reset variables updated by each module
171800200528
171900200528     C                   EXSR      RESETERRS
172000200528      *
172100200528     C                   CALLB     'GLVPFPO'
172200200528      *
172300200528      * INPUTS
172400200528      *
172500200528      ** Return Code
172600200528     C                   Parm                    RetCodeOut
172700200528      *
172800200528      ** Account Screen fields
172900200528     C                   Parm                    DDACTN
173000200528     C                   Parm                    DDBRCA
173100200528     C                   Parm                    DDCUSN
173200200528     C                   Parm                    DDCCY
173300200528     C                   Parm                    DDACOD
173400200528     C                   Parm                    DDACSQ
173500200528     C                   Parm                    DDPRFC
173600200528     C                   Parm                    DDPTFR
173700200528      *
173800200528     C                   Parm                    AMPRFC
173900200528     C                   Parm                    AMPTFR
174000200528     C                   Parm                    AMATYP
174100200528      *
174200200528      ** ICD
174300200528     C                   Parm                    BKPRCU
174400200528     C                   Parm                    BKPRCA
174500200528     C                   Parm                    BKPCDU
174600200528     C                   Parm                    BGN0ST
174700200528     C                   Parm                    BGPFMG
174800200528     C                   Parm                    BGLMCR
174900200528     C**********         Parm                    BJRDNB                                       CSC011
175000200528     C                   PARM                    WRunDay                                      CSC011
175100200528     C                   Parm                    FCPORS
175200200528     C                   Parm                    FCR997
175300200528     C                   Parm                    BGN4ST                                       CPB001
175400200528      *
175500200528      * OUTPUTS
175600200528      *
175700200528      * Error fields/message IDs/message data (arrays) from/to caller
175800200528     C                   PARM                    FldNamXAr
175900200528     C                   PARM                    MsgIDXAr
176000200528     C                   PARM                    MsgDtaXAr
176100200528      *
176200200528      ** Profit Centre - Ok
176300200528      ** Portfolio Reference - Ok
176400200528      ** Account Code - Ok
176500200528     C                   Parm                    DDPRFCOk
176600200528     C                   Parm                    DDPTFROk
176700200528     C                   Parm                    DDACODOk
176800200528
176900200528      * Update error info with that returned from the validation module
177000200528
177100200528     C                   EXSR      UPDATERRS
177200200528      *
177300200528     C                   ENDSR
177400200528      *****************************************************************         CFT004
177500200528     C/EJECT                                                                    CFT004
177600200528      *****************************************************************         CFT004
177700200528      ** ValIBAN - Validate International Bank Account number                   CFT004
177800200528      *****************************************************************         CFT004
177900200528     C     ValIBAN       BEGSR                                                  CFT004
178000200528                                                                                CFT004
178100200528      * Reset variables updated by each module                                  CFT004
178200200528                                                                                CFT004
178300200528     C                   EXSR      RESETERRS                                    CFT004
178400200528      *                                                                         CFT004
178500200528     C                   CALLB     'GLVIBAC'                                    CFT004
178600200528      *                                                                         CFT004
178700200528      * INPUTS                                                                  CFT004
178800200528      *                                                                         CFT004
178900200528      ** Return Code                                                            CFT004
179000200528     C                   Parm                    RetCodeOut                     CFT004
179100200528      *                                                                         CFT004
179200200528      ** International Bank Account Number (screen)                             CFT004
179300200528     C                   Parm                    DDIBAN                         CFT004
179400200528      ** International Bank Account Number (on file)                            CFT004
179500200528     C                   Parm                    AMIBAN                         CFT004
179600200528      ** International Bank Account Number Sequence                             CFT004
179700200528     C                   Parm                    AMIBSEQN                       CFT004
179800200528      ** Action Code                                                            CFT004
179900200528     C                   Parm                    DDACTN                         CFT004
180000200528      ** Branch Code                                                            CFT004
180100200528     C                   Parm                    DDBRCA                         CFT004
180200200528      ** Customer Number                                                        CFT004
180300200528     C                   Parm                    DDCUSN                         CFT004
180400200528      ** Currency                                                               CFT004
180500200528     C                   Parm                    DDCCY                          CFT004
180600200528      ** Account Code                                                           CFT004
180700200528     C                   Parm                    DDACOD                         CFT004
180800200528      ** Account Sequence                                                       CFT004
180900200528     C                   Parm                    DDACSQ                         CFT004
181000200528      ** Account Type                                                           CFT004
181100200528     C                   Parm                    AMATYP                         CFT004
181200200528      ** Account Number                                                         CFT004
181300200528     C                   Parm                    DDACNO                         CFT004
181400200528      *                                                                         CFT004
181500200528      * OUTPUTS                                                                 CFT004
181600200528      *                                                                         CFT004
181700200528      * Error fields/message IDs/message data (arrays) from/to caller           CFT004
181800200528     C                   PARM                    FldNamXAr                      CFT004
181900200528     C                   PARM                    MsgIDXAr                       CFT004
182000200528     C                   PARM                    MsgDtaXAr                      CFT004
182100200528      *                                                                         CFT004
182200200528      * Warning message IDs/message data (arrays) from/to caller                CFT004
182300200528     C                   PARM                    WFldNmXAr                      CFT004
182400200528     C                   PARM                    WMsgIDXAr                      CFT004
182500200528     C                   PARM                    WMsgDtXAr                      CFT004
182600200528      *                                                                         CFT004
182700200528      ** International Bank Account Number - OK                                 CFT004
182800200528     C                   Parm                    DDIBANOk                       CFT004
182900200528                                                                                CFT004
183000200528      * Update error info with that returned from the validation module         CFT004
183100200528                                                                                CFT004
183200200528     C                   EVAL      DDIBSQ = AMIBSEQN                            CFT004
183300200528     C                   EXSR      UPDATERRS                                    CFT004
183400200528      *                                                                         CFT004
183500200528     C                   ENDSR                                                  CFT004
183600200528      *****************************************************************
183700200528     C/EJECT
183800200528      *****************************************************************
183900200528      *  VITaxFlg - Validate Interest Taxable Flag
184000200528      *****************************************************************
184100200528     C     VITAXFLG      BEGSR
184200200528
184300200528      * Reset variables updated by each module
184400200528
184500200528     C                   EXSR      RESETERRS
184600200528      *                                                                                       CDL013
184700200528     C     CDL013        Ifeq      'Y'                                                        CDL013
184800200528     C*                                                                                       CDL013
184900200528     C                   CALL      'AOCUSTR0'                                                 CDL013
185000200528     C                   PARM      '*MSG    '    @RTCD             7                          CDL013
185100200528     C                   PARM      '*KEY    '    @OPTN             7                          CDL013
185200200528     C                   PARM      DDCUSN        @CUSNN           10                          CDL013
185300200528     C                   PARM                    @CSTAT            7                          CDL013
185400200528     C     SDCUST        PARM      SDCUST        DSFDY                                        CDL013
185500200528     C*                                                                                       CDL013
185600200528     C** Data-base error processing.                                                          CDL013
185700200528     C*                                                                                       CDL013
185800200528     C     @RTCD         IFNE      *BLANKS                                                    CDL013
185900200528     C     @CSTAT        OREQ      '*ERROR'                                                   CDL013
186000200528     C     *LOCK         IN        LDA                                                        CDL013
186100200528     C                   MOVEL     'SDCUSTPD'    DBFILE                                       CDL013
186200200528     C                   Z-ADD     6             DBASE                                        CDL013
186300200528     C                   MOVEL     DDCUSN        DBKEY                                        CDL013
186400200528     C                   OUT       LDA                                                        CDL013
186500200528     C                   EXSR      #TERM                                                      CDL013
186600200528     C                   ENDIF                                                                CDL013
186700200528     C                   ENDIF                                                                CDL013
186800200528     C*                                                                                       CDL013
186900200528      *                                                                         180721
187000200528      ** Default Interest Taxable if necessary                                  180721
187100200528     C     BGN4ST        Ifeq      'Y'                                          180721
187200200528     C     DDITAX        Andeq     *blanks                                      180721
187300200528     C     BGNTST        OrEq      'N'                                                       BUG8625
187400200528     C     DDITAX        AndEq     *blanks                                                   BUG8625
187500200528     C     CDL013        Ifeq      'Y'                                                        CDL013
187600200528     C                   EVAL      DDITAX = BBTAIN                                            CDL013
187700200528     C                   Else                                                                 CDL013
187800200528     C                   EVAL      DDITAX = 'N'                                 180721
187900200528     C                   Endif                                                                CDL013
188000200528     C                   Endif                                                  180721
188100200528      *
188200200528     C                   IF        CER048 = 'Y'                                               CER048
188300200528      *                                                                                       CER048
188400200528     C                   MOVEL     DDCUSN        PKey1                                        CER048
188500200528      *                                                                                       CER048
188600200528     C                   CALL      'AOCUSTR0'                                                 CER048
188700200528     C                   PARM      *BLANKS       PRtcd                                        CER048
188800200528     C                   PARM      '*KEY'        POptn                                        CER048
188900200528     C                   PARM                    PKey1                                        CER048
189000200528     C                   PARM      *BLANKS       PKyst                                        CER048
189100200528     C     SDCUST        PARM      SDCUST        DSLDY                                        CER048
189200200528      *                                                                                       CER048
189300200528      ** Retrieve Country code                                                              BUG22747
189400200528      *                                                                                     BUG22747
189500200528     C                   EXSR      SRCNTRY                                                  BUG22747
189600200528     C                   MOVEL     DDCUSN        KFCusn                                       CER048
189700200528     C**********         MOVEL     BBCOLC        KFCtax                              CER048 BUG22747
189800200528     C                   MOVEL     DVCNCD        KFCtax                                     BUG22747
189900200528      *                                                                                     BUG23886
190000200528      ** Retrieve threshol method                                                           BUG23886
190100200528      *                                                                                     BUG23886
190200200528     C                   EVAL      WThrMtd = *blanks                                        BUG23886
190300200528     C                   EVAL      KCtTx = DVCNCD                                           BUG23886
190400200528     C                   EVAL      KCtRe = BBCOLC                                           BUG23886
190500200528     C     KCTxCd        CHAIN     SDCTTXL0                                                 BUG23886
190600200528     C                   IF        %FOUND(SDCTTXL0)                                         BUG23886
190700200528     C                   EVAL      WThrMtd = EWTHMD                                         BUG23886
190800200528     C                   ENDIF                                                              BUG23886
190900200528      *                                                                                       CER048
191000200528     C     *LOVAL        SETLL     SDACTXL1                                                   CER048
191100200528     C     KLActx        CHAIN     SDACTXL1                                                   CER048
191200200528      *                                                                                       CER048
191300200528     C                   IF        %FOUND(SDACTXL1)                                           CER048
191400200528      *                                                                                       CER048
191500200528     C                   IF        AXETXS = 'T'                                               CER048
191600200528     C                             and WThrMtd = 'Y'                                        BUG23886
191700200528     C                             or AXETXS = 'Y' and CER069 = 'Y'                           CER069
191800200528     C                             and WThrMtd = 'Y'                                          CER069
191900200528     C**********                   AND BBTAIN = 'Y'                                BUG22745 BUG22747
192000200528     C                   EVAL      PAcHlF = 'Y'                                               CER048
192100200528     C                   ELSE                                                                 CER048
192200200528     C                   EVAL      PAcHlF = 'N'                                               CER048
192300200528     C                   ENDIF                                                                CER048
192400200528      *                                                                                       CER048
192500200528     C                   IF        DDITAX = *BLANKS                                           CER048
192600200528     C                   IF        CER069 = 'Y' AND AXETXS <> ' '                             CER069
192700200528     C                   EVAL      DDITAX = 'A'                                               CER069
192800200528     C                   ELSE                                                                 CER069
192900200528      *                                                                                       CER048
193000200528     C                   IF        AXETXS = 'T'                                               CER048
193100200528     C                             and WThrMtd = 'Y'                                        BUG23886
193200200528     C**********                   AND BBTAIN = 'Y'                                BUG22745 BUG22747
193300200528     C                   EVAL      DDITAX = 'T'                                               CER048
193400200528     C                   ELSE                                                                 CER048
193500200528     C                   EVAL      DDITAX = 'N'                                               CER048
193600200528     C                   ENDIF                                                                CER048
193700200528      *                                                                                       CER048
193800200528     C                   ENDIF                                                                CER069
193900200528     C                   ENDIF                                                                CER048
194000200528      *                                                                                       CER048
194100200528     C                   ELSE                                                                 CER048
194200200528      *                                                                                       CER048
194300200528     C                   EVAL      PAcHlF = 'X'                                               CER048
194400200528      *                                                                                       CER048
194500200528     C                   IF        DDITAX = *BLANKS                                           CER048
194600200528     C                   EVAL      DDITAX = 'N'                                               CER048
194700200528     C                   ENDIF                                                                CER048
194800200528      *                                                                                       CER048
194900200528     C                   ENDIF                                                                CER048
195000200528      *                                                                                       CER048
195100200528     C                   ENDIF                                                                CER048
195200200528      *                                                                                       CER048
195300200528     C/COPY WNCPYSRC,GLAMA1VC05
195400200528     C                   CALLB     'GLVITIN'
195500200528      *
195600200528      * INPUTS
195700200528      *
195800200528      ** Return Code
195900200528     C                   Parm                    RetCodeOut
196000200528      *
196100200528      ** Account Screen fields
196200200528     C                   Parm                    DDITAX
196300200528      *                                                                                       CDL013
196400200528      ** Customer type                                                                        CDL013
196500200528     C                   Parm                    BBCSTY                                       CDL013
196600200528      *                                                                                       CDL013
196700200528      ** CDL013 switchable feature                                                            CDL013
196800200528     C                   Parm                    CDL013                                       CDL013
196900200528      ** German Features                                                                      CER048
197000200528     C                   PARM                    PAcHlF                                       CER048
197100200528     C                   PARM                    WThrMtd                                    AR762349
197200200528      *
197300200528      * OUTPUTS
197400200528      *
197500200528      * Error fields/message IDs/message data (arrays) from/to caller
197600200528     C                   PARM                    FldNamXAr
197700200528     C                   PARM                    MsgIDXAr
197800200528     C                   PARM                    MsgDtaXAr
197900200528     C                   PARM                    WFldNmXAr                                    CER048
198000200528     C                   PARM                    WMsgIdXAr                                    CER048
198100200528     C                   PARM                    WMsgDtXAr                                    CER048
198200200528      *
198300200528      ** Interest Taxable - OK
198400200528     C                   Parm                    DDITAXOk
198500200528     C/COPY WNCPYSRC,GLAMA1VC06
198600200528
198700200528      * Update error info with that returned from the validation module
198800200528
198900200528     C                   EXSR      UPDATERRS
199000200528      *
199100200528     C                   ENDSR
199200200528      *****************************************************************
199300200528     C/EJECT                                                                                  CGL165
199400200528      *****************************************************************                       CGL165
199500200528      *  VITaxCod - Validate Interest Taxable Codes                                           CGL165
199600200528      *****************************************************************                       CGL165
199700200528     C     VITAXCOD      BEGSR                                                                CGL165
199800200528                                                                                              CGL165
199900200528      * Reset variables updated by each module                                                CGL165
200000200528                                                                                              CGL165
200100200528     C                   EXSR      RESETERRS                                                  CGL165
200200200528      *                                                                                       CGL165
200300200528     C     CGL165        Ifeq      'Y'                                                        CGL165
200400200528      *                                                                                       CGL165
200500200528      * Default tax codes if blank and account is taxable                                     CGL165
200600200528     C                   IF        DDTXC1 = *BLANKS                                           CGL165
200700200528     C                             AND DDTXC2 = *BLANKS                                       CGL165
200800200528     C                             AND DDITAX = 'Y'                                           CGL165
200900200528      *                                                                                       CGL165
201000200528     C                   MOVEL(P)  DDCUSN        @CUSNN                                       CGL165
201100200528     C                   CALL      'AOCUSTR0'                                                 CGL165
201200200528     C                   PARM      '*MSG    '    @RTCD             7                          CGL165
201300200528     C                   PARM      '*KEY    '    @OPTN             7                          CGL165
201400200528     C                   PARM                    @CUSNN           10                          CGL165
201500200528     C                   PARM                    @CSTAT            7                          CGL165
201600200528     C     SDCUST        PARM      SDCUST        DSSDY                                        CGL165
201700200528      *                                                                                       CGL165
201800200528     C                   MOVEL(P)  DDBRCA        TXBRCA                                       CGL165
201900200528     C                   MOVEL(P)  DDCCY         TXCCY                                        CGL165
202000200528     C                   MOVEL(P)  DDACOD        TXACOD                                       CGL165
202100200528     C                   CALL      'AOWTDFR0'                                                 CGL165
202200200528     C                   PARM                    @RTCD1            1                          CGL165
202300200528     C                   PARM                    TXBRCA            3                          CGL165
202400200528     C                   PARM      *BLANK        TXBOOK            2                          CGL165
202500200528     C                   PARM                    TXCCY             3                          CGL165
202600200528     C                   PARM                    BBCOLC                                       CGL165
202700200528     C                   PARM                    BBCSTY                                       CGL165
202800200528     C                   PARM                    BBLINC                                       CGL165
202900200528     C                   PARM      'RE'          TXMODU            2                          CGL165
203000200528     C                   PARM                    TXACOD           10                          CGL165
203100200528     C                   PARM      *BLANKS       TXPSTP            2                          CGL165
203200200528     C                   PARM                    @WTRC1            2                          CGL165
203300200528     C                   PARM                    @WTRC2            2                          CGL165
203400200528      *                                                                                       CGL165
203500200528     C                   IF        @RTCD1 = '0'                                               CGL165
203600200528     C                   MOVE      @WTRC1        DDTXC1                                       CGL165
203700200528     C                   MOVE      @WTRC2        DDTXC2                                       CGL165
203800200528     C                   ENDIF                                                                CGL165
203900200528      *                                                                                       CGL165
204000200528     C                   ENDIF                                                                CGL165
204100200528      *                                                                                       CGL165
204200200528     C                   CALLB     'GLVITCD'                                                  CGL165
204300200528      *                                                                                       CGL165
204400200528      * INPUTS                                                                                CGL165
204500200528      *                                                                                       CGL165
204600200528      ** Return Code                                                                          CGL165
204700200528     C                   Parm                    RetCodeOut                                   CGL165
204800200528      *                                                                                       CGL165
204900200528      ** Account Screen fields                                                                CGL165
205000200528     C                   Parm                    DDITAX                                       CGL165
205100200528     C                   Parm                    DDTXC1                                       CGL165
205200200528     C                   Parm                    DDTXC2                                       CGL165
205300200528     C                   Parm                    DDCCY                                        CGL165
205400200528      *                                                                                       CGL165
205500200528      *                                                                                       CGL165
205600200528      * OUTPUTS                                                                               CGL165
205700200528      *                                                                                       CGL165
205800200528      * Error fields/message IDs/message data (arrays) from/to caller                         CGL165
205900200528     C                   PARM                    FldNamXAr                                    CGL165
206000200528     C                   PARM                    MsgIDXAr                                     CGL165
206100200528     C                   PARM                    MsgDtaXAr                                    CGL165
206200200528     C                   PARM                    WFldNmXAr                                    CGL165
206300200528     C                   PARM                    WMsgIdXAr                                    CGL165
206400200528     C                   PARM                    WMsgDtXAr                                    CGL165
206500200528      *                                                                                       CGL165
206600200528      ** Tax Codes - OK                                                                       CGL165
206700200528     C                   Parm                    DDTXC1Ok                                     CGL165
206800200528     C                   Parm                    DDTXC2Ok                                     CGL165
206900200528                                                                                              CGL165
207000200528     C                   EndIf                                                                CGL165
207100200528      * Update error info with that returned from the validation module                       CGL165
207200200528                                                                                              CGL165
207300200528     C                   EXSR      UPDATERRS                                                  CGL165
207400200528      *                                                                                       CGL165
207500200528     C                   ENDSR                                                                CGL165
207600200528     C/EJECT
207700200528      *****************************************************************
207800200528      *  VStCIFlg - Validate Statement Charge Flag
207900200528      *****************************************************************
208000200528     C     VSTCIFLG      BEGSR
208100200528
208200200528      * Reset variables updated by each module
208300200528
208400200528     C                   EXSR      RESETERRS
208500200528      *
208600200528     C                   CALLB     'GLVSMIN'
208700200528      *
208800200528      * INPUTS
208900200528      *
209000200528      ** Return Code
209100200528     C                   Parm                    RetCodeOut
209200200528      *
209300200528      ** Account Screen fields
209400200528     C                   Parm                    DDSTCI
209500200528      *
209600200528      * OUTPUTS
209700200528      *
209800200528      * Error fields/message IDs/message data (arrays) from/to caller
209900200528     C                   PARM                    FldNamXAr
210000200528     C                   PARM                    MsgIDXAr
210100200528     C                   PARM                    MsgDtaXAr
210200200528      *
210300200528      ** Statement Charge - OK
210400200528     C                   Parm                    DDSTCIOk
210500200528
210600200528      * Update error info with that returned from the validation module
210700200528
210800200528     C                   EXSR      UPDATERRS
210900200528      *
211000200528     C                   ENDSR
211100200528      *****************************************************************
211200200528     C/EJECT
211300200528      *****************************************************************
211400200528      *  VChInFlg - Validate Subject to Account Charge Flag
211500200528      *****************************************************************
211600200528     C     VCHINFLG      BEGSR
211700200528
211800200528      * Reset variables updated by each module
211900200528
212000200528     C                   EXSR      RESETERRS
212100200528      *
212200200528     C                   CALLB     'GLVACCH'
212300200528      *
212400200528      * INPUTS
212500200528      *
212600200528      ** Return Code
212700200528     C                   Parm                    RetCodeOut
212800200528      *
212900200528      ** Account Screen fields
213000200528     C                   Parm                    DDCHIN
213100200528      *                                                                                       248025
213200200528      ** Fixed Account Charge                                                                 248025
213300200528      *                                                                                       248025
213400200528     C                   Parm                    FACH                                         248025
213500200528      *
213600200528      * OUTPUTS
213700200528      *
213800200528      * Error fields/message IDs/message data (arrays) from/to caller
213900200528     C                   PARM                    FldNamXAr
214000200528     C                   PARM                    MsgIDXAr
214100200528     C                   PARM                    MsgDtaXAr
214200200528      *
214300200528      ** Subject to account charge - Ok
214400200528     C                   Parm                    DDCHINOk
214500200528
214600200528      * Update error info with that returned from the validation module
214700200528
214800200528     C                   EXSR      UPDATERRS
214900200528      *
215000200528     C                   ENDSR
215100200528      *****************************************************************
215200200528     C/EJECT
215300200528      *****************************************************************
215400200528      *  VCHAM    - Validate Account Charge Amount
215500200528      *****************************************************************
215600200528     C     VCHAM         BEGSR
215700200528
215800200528      * Reset variables updated by each module
215900200528
216000200528     C                   EXSR      RESETERRS
216100200528      *
216200200528     C                   CALLB     'GLVCHAM'
216300200528      *
216400200528      * INPUTS
216500200528      *
216600200528      ** Return Code
216700200528     C                   Parm                    RetCodeOut
216800200528      *
216900200528      ** Account Screen fields
217000200528     C                   Parm                    DDCHAM
217100200528     C                   Parm                    DDCHIN
217200200528     C                   Parm                    DDCCY
217300200528      *
217400200528      * OUTPUTS
217500200528      *
217600200528      * Error fields/message IDs/message data (arrays) from/to caller
217700200528     C                   PARM                    FldNamXAr
217800200528     C                   PARM                    MsgIDXAr
217900200528     C                   PARM                    MsgDtaXAr
218000200528      *
218100200528     C                   Parm      *ZERO         WNCHAM            7 0
218200200528      *
218300200528      ** Account Charge Amount - Ok
218400200528     C                   Parm                    DDCHAMOk
218500200528
218600200528      * Update error info with that returned from the validation module
218700200528
218800200528     C                   EXSR      UPDATERRS
218900200528      *
219000200528     C                   ENDSR
219100200528      *****************************************************************                       CER050
219200200528     C/EJECT                                                                                  CER050
219300200528      *****************************************************************                       CER050
219400200528      ** SRVAPRF - Validate APR Flag                                                          CER050
219500200528      *****************************************************************                       CER050
219600200528     C     SRVAPRF       BEGSR                                                                CER050
219700200528                                                                                              CER050
219800200528      * Reset variables updated by each module                                                CER050
219900200528                                                                                              CER050
220000200528     C                   EXSR      RESETERRS                                                  CER050
220100200528      *                                                                                       CER050
220200200528     C                   CALL      'GLVAPRF'                                                  CER050
220300200528      *                                                                                       CER050
220400200528      * INPUTS                                                                                CER050
220500200528      *                                                                                       CER050
220600200528      ** Return Code                                                                          CER050
220700200528     C                   Parm                    RetCodeOut                                   CER050
220800200528      *                                                                                       CER050
220900200528      ** APR Screen fields                                                                    CER050
221000200528     C                   Parm                    DDCUSN                                       CER050
221100200528     C                   Parm                    DDAPRC                                       CER050
221200200528      *                                                                                       CER050
221300200528      * OUTPUTS                                                                               CER050
221400200528      *                                                                                       CER050
221500200528      * Error fields/message IDs/message data (arrays) from/to caller                         CER050
221600200528     C                   PARM                    FldNamXAr                                    CER050
221700200528     C                   PARM                    MsgIDXAr                                     CER050
221800200528     C                   PARM                    MsgDtaXAr                                    CER050
221900200528     C                   PARM                    Idx                                          CER050
222000200528      *                                                                                       CER050
222100200528      * Warning fields/message IDs/message data (arrays) from/to caller                       CER050
222200200528     C                   PARM                    WFldNmXar                                    CER050
222300200528     C                   PARM                    WMsgIdXar                                    CER050
222400200528     C                   PARM                    WMsgDtXAr                                    CER050
222500200528     C                   PARM                    WIdx                                         CER050
222600200528      *                                                                                       CER050
222700200528      ** APR - Ok                                                                             CER050
222800200528     C                   Parm                    DDAPRCOK                                     CER050
222900200528                                                                                              CER050
223000200528      * Update error info with that returned from the validation module                       CER050
223100200528                                                                                              CER050
223200200528     C                   EXSR      UPDATERRS                                                  CER050
223300200528      *                                                                                       CER050
223400200528     C                   ENDSR                                                                CER050
223500200528      *****************************************************************
223600200528     C/EJECT                                                                                  CUT009
223700200528      /COPY WNCPYSRC,GLAMAD1V42                                                               CUT009
223800200528      *****************************************************************                       CUT009
223900200528     C/EJECT
224000200528      *****************************************************************
224100200528      *                                                               *
224200200528      * SETUPVALID - Set up additional fields that are needed on the  *
224300200528      *    Valid file record.                                         *
224400200528      *                                                               *
224500200528      *****************************************************************
224600200528
224700200528     C     SETUPVALID    BEGSR
224800200528      *
224900200528     C                   MOVE      DDCUSN        AMCNUM
225000200528     C                   MOVE      DDCCY         AMCCY
225100200528     C                   MOVE      DDACOD        AMACOD
225200200528     C                   MOVE      DDACSQ        AMACSQ
225300200528     C                   MOVE      DDBRCA        AMBRCA
225400200528     C                   MOVE      DDACNO        AMACNO
225500200528      *
225600200528     C     WFMT          IFEQ      'F1'
225700200528     C     WFMT          OREQ      *BLANKS
225800200528      *
225900200528     C                   MOVE      DDANAM        AMANAM
226000200528     C     DDACTN        IFEQ      'I'
226100200528     C                   Z-ADD     WWDACO        AMDACO
226200200528     C                   ENDIF
226300200528     C                   Z-ADD     WWNSTD        AMNSTD
226400200528     C                   MOVE      DDSTFQ        AMSTFQ
226500200528     C                   MOVE      DDENOC        AMENOC
226600200528     C                   MOVE      DDNSDN        AMSTDY
226700200528     C                   MOVE      DDEUSB        AMEUSB
226800200528
226900200528     C     DDPTAD        IFEQ      'Y'
227000200528     C                   BITON     '2'           AMGLBT
227100200528     C                   ELSE
227200200528     C                   BITOFF    '2'           AMGLBT
227300200528     C                   ENDIF
227400200528
227500200528     C     DDRAD         IFEQ      'Y'
227600200528     C                   BITON     '0'           AMRETB
227700200528     C                   ELSE
227800200528     C                   BITOFF    '0'           AMRETB
227900200528     C                   ENDIF
228000200528
228100200528     C     DDRAC         IFEQ      'Y'
228200200528     C                   BITON     '1'           AMRETB
228300200528     C                   ELSE
228400200528     C                   BITOFF    '1'           AMRETB
228500200528     C                   ENDIF
228600200528
228700200528     C     DDBAD         IFEQ      'Y'
228800200528     C                   BITON     '2'           AMRETB
228900200528     C                   ELSE
229000200528     C                   BITOFF    '2'           AMRETB
229100200528     C                   ENDIF
229200200528
229300200528     C     DDBAC         IFEQ      'Y'
229400200528     C                   BITON     '3'           AMRETB
229500200528     C                   ELSE
229600200528     C                   BITOFF    '3'           AMRETB
229700200528     C                   ENDIF
229800200528
229900200528     C                   MOVEL     DDREF         AMADREF1
230000200528     C                   MOVE      DDREF         AMADREF2
230100200528     C                   MOVE      DDTIAC        AMA5TIAC
230200200528     C                   MOVE      DDTIAN        AMA5TIAN
230300200528     C                   MOVE      DDTIAS        AMA5TIAS
230400200528     C                   MOVE      DDPRFC        AMPRFC
230500200528     C                   MOVE      DDMFFQ        AMMFFQ
230600200528     C                   MOVE      DDPTFR        AMPTFR
230700200528     C                   MOVE      DDITAX        BXITAX
230800200528     C                   IF        CGL165 = 'Y'                                               CGL165
230900200528     C                   MOVE      DDTXC1        BXTXC1                                       CGL165
231000200528     C                   MOVE      DDTXC2        BXTXC2                                       CGL165
231100200528     C                   ENDIF                                                                CGL165
231200200528     C                   MOVE      DDSTCI        BXSTCI
231300200528     C                   MOVE      DDCHIN        BXCHIN
231400200528     C                   Z-ADD     WNCHAM        BXCHAM
231500200528      *
231600200528     C                   ENDIF
231700200528      *
231800200528      ** Populate Extension File key fields
231900200528     C     DDACTN        IFEQ      'I'
232000200528     C*****BGWDPR        ANDEQ     'Y'                                                        239720
232100200528     C     AMATYP        ANDEQ     'R'
232200200528     C     DDACTN        OREQ      'D'                                                       BUG8471
232300200528     C*****BGWDPR        ANDEQ     'Y'                                                BUG8471 242488
232400200528     C     AMATYP        ANDEQ     'R'                                                       BUG8471
232500200528                                                                                             BUG8471
232600200528     C*****BGSWRT        IFEQ      'Y'                                                        239720
232700200528     C*****BGNTST        OREQ      'Y'                                                        239720
232800200528     C*****FACH**        OREQ      'Y'                                                        239720
232900200528     C*****TSTMC*        OREQ      'Y'                                                        239720
233000200528     C                   MOVE      DDCUSN        BXCNUM
233100200528     C                   MOVE      DDCCY         BXCCY
233200200528     C                   MOVE      DDACOD        BXACOD
233300200528     C                   MOVE      DDACSQ        BXACSQ
233400200528     C                   MOVE      DDBRCA        BXBRCA
233500200528     C**********         ENDIF                                                                239720
233600200528     C                   ENDIF
233700200528      *                                                                                     BUG24157
233800200528      ** KWG @24c reporting                                                                 BUG24157
233900200528      *                                                                                     BUG24157
234000200528     C                   IF        CER047 = 'Y'                                             BUG24157
234100200528     C                   EVAL      AMK24C = DD24C                                           BUG24157
234200200528     C                   ENDIF                                                              BUG24157
234300200528      *
234400200528                                                                                              CRE075
234500200528      ** Effective Date for Retail Accounts                                                   CRE075
234600200528                                                                                              CRE075
234700200528     C                   IF        CRE075 = 'Y'                                               CRE075
234800200528     C                   EVAL      AMEFDT = WWEfDt                                            CRE075
234900200528     C                   ENDIF                                                                CRE075
235000200528                                                                                              CRE075
235100200528     C                   If        CER050 = 'Y'                                               CER050
235200200528     C                   Eval      BXAPRC = DDAPRC                                            CER050
235300200528     C                   EndIf                                                                CER050
235400200528     C                   ENDSR
235500200528      *****************************************************************                     BUG22747
235600200528      /EJECT                                                                                BUG22747
235700200528      *****************************************************************                     BUG22747
235800200528      * SRCNTRY- Retrieve correct country codee                       *                     BUG22747
235900200528      *****************************************************************                     BUG22747
236000200528                                                                                            BUG22747
236100200528     C     SRCNTRY       BEGSR                                                              BUG22747
236200200528                                                                                            BUG22747
236300200528     C                   CALL      'AOBRCHR1'                                               BUG22747
236400200528     C                   PARM      *BLANKS       PRtcd                                      BUG22747
236500200528     C                   PARM      '*KEY   '     POptn                                      BUG22747
236600200528     C                   PARM      BBBRCD        PBrch                                      BUG22747
236700200528     C     SDBRCH        PARM      SDBRCH        DSSDY                                      BUG22747
236800200528      *                                                                                     BUG22747
236900200528     C                   IF        PRtcd <> *BLANKS                                         BUG22747
237000200528     C     *LOCK         IN        LDA                                                      BUG22747
237100200528     C                   Z-ADD     004           DBASE                                      BUG22747
237200200528     C                   EVAL      DBFILE = 'SDBRCHPD'                                      BUG22747
237300200528     C                   EVAL      DBKEY = PBrch                                            BUG22747
237400200528     C                   EVAL      DBPGM = 'GLAMAD1VL'                                      BUG22747
237500200528     C                   EVAL      *INU7 = *ON                                              BUG22747
237600200528     C                   EVAL      *INU8 = *ON                                              BUG22747
237700200528     C                   OUT       LDA                                                      BUG22747
237800200528     C                   EXSR      *PSSR                                                    BUG22747
237900200528     C                   ENDIF                                                              BUG22747
238000200528                                                                                            BUG22747
238100200528     C                   CALL      'AOLOCNR0'                                               BUG22747
238200200528     C                   PARM      *BLANKS       PRtcd                                      BUG22747
238300200528     C                   PARM      '*KEY   '     POptn                                      BUG22747
238400200528     C                   PARM      A8LCCD        PLocn                                      BUG22747
238500200528     C     SDLOCN        PARM      SDLOCN        DSFDY                                      BUG22747
238600200528      *                                                                                     BUG22747
238700200528     C                   IF        PRtcd <> *BLANKS                                         BUG22747
238800200528     C     *LOCK         IN        LDA                                                      BUG22747
238900200528     C                   Z-ADD     005           DBASE                                      BUG22747
239000200528     C                   EVAL      DBFILE = 'SDLOCNPD'                                      BUG22747
239100200528     C                   EVAL      DBKEY = PLocn                                            BUG22747
239200200528     C                   EVAL      DBPGM = 'GLAMAD1VL'                                      BUG22747
239300200528     C                   EVAL      *INU7 = *ON                                              BUG22747
239400200528     C                   EVAL      *INU8 = *ON                                              BUG22747
239500200528     C                   OUT       LDA                                                      BUG22747
239600200528     C                   EXSR      *PSSR                                                    BUG22747
239700200528     C                   ENDIF                                                              BUG22747
239800200528                                                                                            BUG22747
239900200528     C                   ENDSR                                                              BUG22747
240000200528      *****************************************************************
240100200528      /EJECT
240200200528      *****************************************************************                     BUG24157
240300200528      ** SRVK24C - Validate KWG §24c reporting                                              BUG24157
240400200528      *****************************************************************                     BUG24157
240500200528     C     SRVK24C       BEGSR                                                              BUG24157
240600200528                                                                                            BUG24157
240700200528      * Reset variables updated by each module                                              BUG24157
240800200528                                                                                            BUG24157
240900200528     C                   EXSR      RESETERRS                                                BUG24157
241000200528      *                                                                                     BUG24157
241100200528     C                   CALLB     'GLVK24C'                                                BUG24157
241200200528      ** Return Code                                                                        BUG24157
241300200528     C                   PARM                    RetCodeOut                                 BUG24157
241400200528      ** KWG §24c reporting field                                                           BUG24157
241500200528     C                   PARM                    DD24C                                      BUG24157
241600200528      ** Customer Number                                                                    BUG24157
241700200528     C                   PARM                    DDCUSN                                     BUG24157
241800200528      * Error fields/message IDs/message data (arrays) from/to caller                       BUG24157
241900200528     C                   PARM                    FldNamXAr                                  BUG24157
242000200528     C                   PARM                    MsgIDXAr                                   BUG24157
242100200528     C                   PARM                    MsgDtaXAr                                  BUG24157
242200200528      * Warning fields/message IDs/message data (arrays) from/to caller                     BUG24157
242300200528     C                   PARM                    WFldNmXAr                                  BUG24157
242400200528     C                   PARM                    WMsgIDXAr                                  BUG24157
242500200528     C                   PARM                    WMsgDtXAr                                  BUG24157
242600200528      * KWG §24c reporting Y/N - Ok Flag                                                    BUG24157
242700200528     C                   PARM                    DD24COK                                    BUG24157
242800200528                                                                                            BUG24157
242900200528      * Update error info with that returned from the validation module                     BUG24157
243000200528                                                                                            BUG24157
243100200528     C                   EXSR      UPDATERRS                                                BUG24157
243200200528      *                                                                                     BUG24157
243300200528     C                   ENDSR                                                              BUG24157
243400200528      *****************************************************************                     BUG24157
243500200528     C/EJECT                                                                                BUG24157
243600200528      *****************************************************************
243700200528      * *INZSR - Program Initialisation routine                       *
243800200528      *****************************************************************
243900200528
244000200528     C     *INZSR        BEGSR
244100200528
244200200528     C     *ENTRY        PLIST
244300200528      * Response mode (1A), from source system common header
244400200528     C                   PARM                    RespMode
244500200528      * Screen Format
244600200528     C                   PARM                    WFMT              2
244700200528      * ICD
244800200528     C                   PARM                    RETABLE
244900200528      * Transaction information (DS) from source system
245000200528     C                   PARM                    TranIn
245100200528      * Front Office ID                                                         180721
245200200528     C**********         PARM                    APFOTranID       20                   180721 CGL029
245300200528     C                   PARM                    APFOTran40       40                          CGL029
245400200528      * Field OK flags (DS) from/to caller
245500200528     C                   PARM                    OKFlagsDS
245600200528      * Error fields/message IDs/message data (arrays) from/to caller
245700200528     C                   PARM                    FldNameArr
245800200528     C                   PARM                    MsgIDArr
245900200528     C                   PARM                    MsgDtaArr
246000200528      * Array index (3P0) from/to caller
246100200528     C                   PARM                    Idx
246200200528      * Warning fields/message IDs/message data (arrays) from/to caller
246300200528     C                   PARM                    WFldNamArr
246400200528     C                   PARM                    WMsgIDArr
246500200528     C                   PARM                    WMsgDtaArr
246600200528      * Array index (3P0) from/to caller
246700200528     C                   PARM                    WIdx
246800200528      * Full GL Account Number
246900200528     C                   Parm                    WGLKEY
247000200528      * IBAN Sequence                                                           CFT004
247100200528     C                   Parm                    DDIBSQ            3            CFT004
247200200528      * Valid Account layout (DS) from/to caller
247300200528     C                   PARM                    ValidAccn
247400200528     C                   PARM                    ValidExBX
247500200528      * Base Rate Auth req                                                                    CSD012
247600200528     C                   PARM                    AUTHRQ            1                          CSD012
247700200528      * Authorisation Mode                                                                    CSD012
247800200528     C                   PARM                    AUTHMD            1                          CSD012
247900200528      *                                                                                     MD054028
248000200528     C                   PARM                    DDAPRC            1                        MD054028
248100200528     C                   PARM                    DDAPDR            8                        MD054028
248200200528     C                   PARM                    DDAPCR            8                        MD054028
248300200528      *
248400200528      **  GET ZMUSER to access default branch.
248500200528      *
248600200528     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
248700200528     C**********         IN        ZMUSER                                                    BUG8550
248800200528     C**********         UNLOCK    ZMUSER                                                    BUG8550
248900200528      *
249000200528      **  GET RUNDAT to access multi-branching indicator
249100200528      *
249200200528     C     *DTAARA       DEFINE                  RUNDAT
249300200528     C                   IN        RUNDAT
249400200528     C                   UNLOCK    RUNDAT
249500200528      *
249600200528      **  Move program name into *LDA field.
249700200528      *
249800200528     C     *LOCK         IN        LDA
249900200528     C                   MOVEL     'GLAMAD1VL'   DBPGM
250000200528     C                   OUT       LDA
250100200528      *
250200200528      ** Access Bank details via access program
250300200528      *  (database error handling done in access program)
250400200528     C                   CALLB     'AOBANKR0'
250500200528     C                   PARM      '*DBERR '     @RTCD
250600200528     C                   PARM      '*FIRST '     @OPTN
250700200528     C     SDBANK        PARM      SDBANK        DSFDY
250800200528      *
250900200528      ** Access General Ledger details via access program
251000200528      *  (database error handling done in access program)
251100200528     C**********         CALLB     'AOGELRR0'                                                 CGL029
251200200528     C                   CALLB     'AOGELRR1'                                                 CGL029
251300200528     C                   PARM      '*DBERR '     @RTCD
251400200528     C                   PARM      '*FIRST '     @OPTN
251500200528     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
251600200528     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
251700200528      *
251800200528      ** Access MIDAS Modules details via access program
251900200528      *  (database error handling done in access program)
252000200528     C                   CALLB     'AOMMODR0'
252100200528     C                   PARM      '*DBERR '     @RTCD
252200200528     C                   PARM      '*FIRST '     @OPTN
252300200528     C     SDMMOD        PARM      SDMMOD        DSFDY
252400200528      *
252500200528      ** Access Retail details via access program
252600200528      *  (database error handling done in access program)
252700200528     C     BGRTBN        IFEQ      'Y'
252800200528     C                   CALLB     'AORETLR0'
252900200528     C                   PARM      '*DBERR '     @RTCD
253000200528     C                   PARM      '*FIRST '     @OPTN
253100200528     C     SDRETL        PARM      SDRETL        DSFDY
253200200528     C                   ENDIF
253300200528      *
253400200528      ** Access default Portfolio Reference via access program
253500200528      *  (database error handling done in access program)
253600200528     C     BGPFMG        IFEQ      'Y'
253700200528     C                   CALL      'AOPORTR0'
253800200528     C                   PARM      'DBERR  '     @RTCD
253900200528     C                   PARM      '*FIRST '     @OPTN
254000200528     C     SDPORT        PARM      SDPORT        DSFDY
254100200528     C                   ENDIF
254200200528      *
254300200528      ** Access SAR file to determine if CEU013 is present.
254400200528      *
254500200528     C                   CALLB     'AOSARDR0'
254600200528     C                   PARM      *BLANKS       @RTCD
254700200528     C                   PARM      '*VERIFY'     @OPTN
254800200528     C                   PARM      'CEU013'      @SARD
254900200528     C     SCSARD        PARM      SCSARD        DSFDY
255000200528     C     @RTCD         IFNE      *BLANKS
255100200528     C     @RTCD         ANDNE     '*NRF   '
255200200528     C     *LOCK         IN        LDA
255300200528     C                   MOVEL     'SCSARDPD'    DBFILE
255400200528     C                   Z-ADD     1             DBASE
255500200528     C                   MOVEL     'CEU013'      DBKEY
255600200528     C                   OUT       LDA
255700200528     C                   SETON                                        U7U8LR
255800200528     C                   EXSR      #TERM
255900200528     C                   ENDIF
256000200528     C                   MOVEL     'N'           CEU013            1
256100200528     C     @RTCD         IFEQ      *BLANK
256200200528     C                   MOVEL     'Y'           CEU013
256300200528     C                   ENDIF
256400200528      *                                                                                       CDL013
256500200528      ** Access SAR file to determine if CDL013 is present.                                   CDL013
256600200528      *                                                                                       CDL013
256700200528     C                   CALLB     'AOSARDR0'                                                 CDL013
256800200528     C                   PARM      *BLANKS       @RTCD                                        CDL013
256900200528     C                   PARM      '*VERIFY'     @OPTN                                        CDL013
257000200528     C                   PARM      'CDL013'      @SARD                                        CDL013
257100200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL013
257200200528     C     @RTCD         IFNE      *BLANKS                                                    CDL013
257300200528     C     @RTCD         ANDNE     '*NRF   '                                                  CDL013
257400200528     C     *LOCK         IN        LDA                                                        CDL013
257500200528     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL013
257600200528     C                   Z-ADD     3             DBASE                                        CDL013
257700200528     C                   MOVEL     'CDL013'      DBKEY                                        CDL013
257800200528     C                   OUT       LDA                                                        CDL013
257900200528     C                   SETON                                        U7U8LR                  CDL013
258000200528     C                   EXSR      #TERM                                                      CDL013
258100200528     C                   ENDIF                                                                CDL013
258200200528     C                   MOVEL     'N'           CDL013            1                          CDL013
258300200528     C     @RTCD         IFEQ      *BLANK                                                     CDL013
258400200528     C                   MOVEL     'Y'           CDL013                                       CDL013
258500200528     C                   ENDIF                                                                CDL013
258600200528      *                                                                                       CDL013
258700200528      *                                                                                       CDL013
258800200528     C/COPY WNCPYSRC,GLH00720
258900200528      *
259000200528     C     CDTO          IFEQ      'Y'
259100200528     C     CHOV          OREQ      'Y'
259200200528     C     FXAC          OREQ      'Y'
259300200528     C     CNDS          OREQ      'Y'
259400200528     C     CDRI          OREQ      'Y'
259500200528     C     CMBL          OREQ      'Y'
259600200528     C     CINA          OREQ      'Y'
259700200528     C                   MOVE      *ON           @IN34
259800200528     C                   ENDIF
259900200528      *
260000200528      ** Access SAR file to determine if CFT004 is present.                     CFT004
260100200528      *                                                                         CFT004
260200200528     C                   CALLB     'AOSARDR0'                                   CFT004
260300200528     C                   PARM      *BLANKS       @RTCD                          CFT004
260400200528     C                   PARM      '*VERIFY'     @OPTN                          CFT004
260500200528     C                   PARM      'CFT004'      @SARD                          CFT004
260600200528     C     SCSARD        PARM      SCSARD        DSFDY                          CFT004
260700200528     C     @RTCD         IFNE      *BLANKS                                      CFT004
260800200528     C     @RTCD         ANDNE     '*NRF   '                                    CFT004
260900200528     C     *LOCK         IN        LDA                                          CFT004
261000200528     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT004
261100200528     C                   Z-ADD     1             DBASE                          CFT004
261200200528     C                   MOVEL     'CFT004'      DBKEY                          CFT004
261300200528     C                   OUT       LDA                                          CFT004
261400200528     C                   SETON                                        U7U8LR    CFT004
261500200528     C                   EXSR      #TERM                                        CFT004
261600200528     C                   ENDIF                                                  CFT004
261700200528     C                   MOVEL     'N'           CFT004            1            CFT004
261800200528     C     @RTCD         IFEQ      *BLANK                                       CFT004
261900200528     C                   MOVEL     'Y'           CFT004                         CFT004
262000200528     C                   ENDIF                                                  CFT004
262100200528     C/COPY WNCPYSRC,GLAMA1VC04
262200200528                                                                                              CSC011
262300200528      ** Check if CSC011 is installed                                                         CSC011
262400200528                                                                                              CSC011
262500200528     C                   EVAL      WRunDay = BJRDNB                                           CSC011
262600200528                                                                                              CSC011
262700200528      ** CSC011 is a redundant feature. No need to check                                    MD024398
262800200528                                                                                            MD024398
262900200528     C**********         CALLB     'AOSARDR0'                                        CSC011 MD024398
263000200528     C**********         PARM      *BLANKS       PRtCd                               CSC011 MD024398
263100200528     C**********         PARM      '*VERIFY'     POptn                               CSC011 MD024398
263200200528     C**********         PARM      'CSC011'      PSard                               CSC011 MD024398
263300200528     C*****SCSARD        PARM      SCSARD        DSFDY                               CSC011 MD024398
263400200528      **********                                                                     CSC011 MD024398
263500200528     C**********         IF        PRtCd = *Blanks                                   CSC011 MD024398
263600200528     C**********         EVAL      CSC011 = 'Y'                                      CSC011 MD024398
263700200528     C**********         IN        SC24X7                                            CSC011 MD024398
263800200528     C**********         IN        SDSTAT                                            CSC011 MD024398
263900200528     C**********         IF        S1SUPP = LIBR                                     CSC011 MD024398
264000200528     C**********         EVAL      WRunDay = S1DATE                                  CSC011 MD024398
264100200528     C**********         ENDIF                                                       CSC011 MD024398
264200200528      **********                                                                     CSC011 MD024398
264300200528     C**********         ELSE                                                        CSC011 MD024398
264400200528     C                   EVAL      CSC011 = 'N'                                               CSC011
264500200528     C**********         IF        PRtCd <> '*NRF'                                   CSC011 MD024398
264600200528     C******LOCK         IN        LDA                                               CSC011 MD024398
264700200528     C**********         EVAL      DBFILE = 'SCSARDPD'                               CSC011 MD024398
264800200528     C**********         EVAL      DBKEY = 'CSC011'                                  CSC011 MD024398
264900200528     C**********         EVAL      DBASE = 2                                         CSC011 MD024398
265000200528     C**********         OUT       LDA                                               CSC011 MD024398
265100200528     C**********         EXSR      *PSSR                                             CSC011 MD024398
265200200528     C**********         ENDIF                                                       CSC011 MD024398
265300200528      **********                                                                     CSC011 MD024398
265400200528     C**********         ENDIF                                                       CSC011 MD024398
265500200528                                                                                              CSC011
265600200528      *                                                                                     BUG24157
265700200528      ** Check if CER047 is installed.                                                      BUG24157
265800200528      *                                                                                     BUG24157
265900200528     C                   CALLB     'AOSARDR0'                                               BUG24157
266000200528     C                   PARM      *BLANKS       PRtCd                                      BUG24157
266100200528     C                   PARM      '*VERIFY'     POptn                                      BUG24157
266200200528     C                   PARM      'CER047'      PSard                                      BUG24157
266300200528     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG24157
266400200528                                                                                            BUG24157
266500200528     C                   EVAL      CER047 = 'N'                                             BUG24157
266600200528     C                   IF        PRtCd = *BLANKS                                          BUG24157
266700200528     C                   EVAL      CER047 = 'Y'                                             BUG24157
266800200528     C                   ENDIF                                                              BUG24157
266900200528                                                                                            BUG24157
267000200528     C                   IF        PRtCd <> *BLANKS  AND  PRtCd <> '*NRF   '                BUG24157
267100200528     C     *LOCK         IN        LDA                                                      BUG24157
267200200528     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG24157
267300200528     C                   EVAL      DBKEY = 'CER047'                                         BUG24157
267400200528     C                   EVAL      DBASE = 6                                                BUG24157
267500200528     C                   OUT       LDA                                                      BUG24157
267600200528     C                   EXSR      *PSSR                                                    BUG24157
267700200528     C                   ENDIF                                                              BUG24157
267800200528      *                                                                                     BUG24157
267900200528      *                                                                                       CER048
268000200528      ** Check if CER048 is installed.                                                        CER048
268100200528      *                                                                                       CER048
268200200528     C                   EVAL      CER048 = 'N'                                               CER048
268300200528     C                   IF        BGNTST = 'Y'                                               CER048
268400200528      *                                                                                       CER048
268500200528     C                   CALLB     'AOSARDR0'                                                 CER048
268600200528     C                   PARM      *BLANKS       PRtCd                                        CER048
268700200528     C                   PARM      '*VERIFY'     POptn                                        CER048
268800200528     C                   PARM      'CER048'      PSard                                        CER048
268900200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
269000200528      *                                                                                       CER048
269100200528     C                   IF        PRtCd <> *BLANKS AND                                       CER048
269200200528     C                             PRtCd <> '*NRF'                                            CER048
269300200528     C     *LOCK         IN        LDA                                                        CER048
269400200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
269500200528     C                   EVAL      DBASE = 3                                                  CER048
269600200528     C                   EVAL      DBKEY = 'CER048'                                           CER048
269700200528     C                   OUT       LDA                                                        CER048
269800200528     C                   EXSR      *PSSR                                                      CER048
269900200528     C                   ENDIF                                                                CER048
270000200528      *                                                                                       CER048
270100200528     C                   IF        PRtCd = *BLANKS                                            CER048
270200200528     C                   EVAL      CER048 = 'Y'                                               CER048
270300200528     C                   ENDIF                                                                CER048
270400200528      *                                                                                       CER048
270500200528     C                   ENDIF                                                                CER048
270600200528      *                                                                                       CER048
270700200528      ** Check if CRE075 is installed.                                                        CRE075
270800200528      *                                                                                       CRE075
270900200528     C                   CALLB     'AOSARDR0'                                                 CRE075
271000200528     C                   PARM      *BLANKS       PRtCd                                        CRE075
271100200528     C                   PARM      '*VERIFY'     POptn                                        CRE075
271200200528     C                   PARM      'CRE075'      PSard                                        CRE075
271300200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE075
271400200528                                                                                              CRE075
271500200528     C                   EVAL      CRE075 = 'N'                                               CRE075
271600200528     C                   IF        PRtCd = *BLANKS                                            CRE075
271700200528     C                   EVAL      CRE075 = 'Y'                                               CRE075
271800200528     C                   ENDIF                                                                CRE075
271900200528                                                                                              CRE075
272000200528     C                   IF        PRtCd <> *BLANKS  AND  PRtCd <> '*NRF   '                  CRE075
272100200528     C     *LOCK         IN        LDA                                                        CRE075
272200200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE075
272300200528     C                   EVAL      DBKEY = 'CRE075'                                           CRE075
272400200528     C                   EVAL      DBASE = 7                                                  CRE075
272500200528     C                   OUT       LDA                                                        CRE075
272600200528     C                   EXSR      *PSSR                                                      CRE075
272700200528     C                   ENDIF                                                                CRE075
272800200528                                                                                              CER069
272900200528      ** Check if CER069 is installed.                                                        CER069
273000200528                                                                                              CER069
273100200528     C                   CALLB     'AOSARDR0'                                                 CER069
273200200528     C                   PARM      *BLANKS       PRtCd                                        CER069
273300200528     C                   PARM      '*VERIFY'     POptn                                        CER069
273400200528     C                   PARM      'CER069'      PSard                                        CER069
273500200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CER069
273600200528                                                                                              CER069
273700200528     C                   EVAL      CER069 = 'N'                                               CER069
273800200528     C                   IF        PRtCd = *BLANKS                                            CER069
273900200528     C                   EVAL      CER069 = 'Y'                                               CER069
274000200528     C                   ENDIF                                                                CER069
274100200528                                                                                              CER069
274200200528     C                   IF        PRtCd <> *BLANKS  AND  PRtCd <> '*NRF   '                  CER069
274300200528     C     *LOCK         IN        LDA                                                        CER069
274400200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER069
274500200528     C                   EVAL      DBKEY = 'CER069'                                           CER069
274600200528     C                   EVAL      DBASE = 8                                                  CER069
274700200528     C                   OUT       LDA                                                        CER069
274800200528     C                   EXSR      *PSSR                                                      CER069
274900200528     C                   ENDIF                                                                CER069
275000200528                                                                                              CER069
275100200528      ** Check if CGL165 is installed.                                                        CER069
275200200528                                                                                              CER069
275300200528     C                   CALLB     'AOSARDR0'                                                 CER069
275400200528     C                   PARM      *BLANKS       PRtCd                                        CER069
275500200528     C                   PARM      '*VERIFY'     POptn                                        CER069
275600200528     C                   PARM      'CGL165'      PSard                                        CER069
275700200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CER069
275800200528                                                                                              CER069
275900200528     C                   EVAL      CGL165 = 'N'                                               CER069
276000200528     C                   IF        PRtCd = *BLANKS                                            CER069
276100200528     C                   EVAL      CGL165 = 'Y'                                               CER069
276200200528     C                   ENDIF                                                                CER069
276300200528     C                   MOVE      *OFF          *IN11                                        262025
276400200528                                                                                              CGL184
276500200528      ** Check if CGL184 is installed.                                                        CGL184
276600200528                                                                                              CGL184
276700200528     C                   CALLB     'AOSARDR0'                                                 CGL184
276800200528     C                   PARM      *BLANKS       PRtCd                                        CGL184
276900200528     C                   PARM      '*VERIFY'     POptn                                        CGL184
277000200528     C                   PARM      'CGL184'      PSard                                        CGL184
277100200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL184
277200200528                                                                                              CGL184
277300200528     C                   EVAL      CGL184 = 'N'                                               CGL184
277400200528     C                   IF        PRtCd = *BLANKS                                            CGL184
277500200528     C                   EVAL      CGL184 = 'Y'                                               CGL184
277600200528     C                   ENDIF                                                                CGL184
277700200528      *                                                                                       262025
277800200528      ** Check if CER050 is installed.                                                        CER050
277900200528                                                                                              CER050
278000200528     C                   CALLB     'AOSARDR0'                                                 CER050
278100200528     C                   PARM      *BLANKS       PRtCd                                        CER050
278200200528     C                   PARM      '*VERIFY'     POptn                                        CER050
278300200528     C                   PARM      'CER050'      PSard                                        CER050
278400200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CER050
278500200528                                                                                              CER050
278600200528     C                   Eval      CER050 = 'N'                                               CER050
278700200528     C                   If        PRtCd = *Blanks                                            CER050
278800200528     C                   Eval      CER050 = 'Y'                                               CER050
278900200528     C                   Endif                                                                CER050
279000200528                                                                                              CER050
279100200528     C     KLActx        KLIST                                                                CER048
279200200528     C                   KFLD                    KFCusn                                       CER048
279300200528     C                   KFLD                    KFCtax                                       CER048
279400200528      *                                                                                     BUG23886
279500200528     C     KCTxCd        KLIST                                                              BUG23886
279600200528     C                   KFLD                    KCtTx                                      BUG23886
279700200528     C                   KFLD                    KCtRe                                      BUG23886
279800200528      *                                                                                     BUG23886
279900200528     C/COPY OFCPYSRCZ,CGL123_002                                                              CGL123
280000200528      *                                                                         CFT004
280100200528      *  Set up the name of the MSGF from which the message handler will
280200200528      *   get the messages
280300200528     C                   EVAL      #MsgFile = 'DRSMM'
280400200528     C/COPY WNCPYSRC,GLAMA1VC07
280500200528
280600200528      ** Program, module and procedure names for database error processing.
280700200528      ** =================================================================
280800200528      ** The following /COPY sets these values, and also defines LDA as
280900200528      ** an external data area
281000200528
281100200528     C                   ENDSR
281200200528      *****************************************************************
281300200528      /EJECT
281400200528      *****************************************************************
281500200528      * RESETERRS - Reset error information that is received back     *
281600200528      *    from each validation module.                               *
281700200528      *****************************************************************
281800200528
281900200528     C     RESETERRS     BEGSR
282000200528
282100200528     C                   EVAL      RetCodeOut = *Blanks
282200200528      *
282300200528      * Reset error & warning fields/message IDs/message data (arrays)
282400200528     C                   MOVEL     *BLANK        FldNamXAr
282500200528     C                   MOVEL     *BLANK        MsgIDXAr
282600200528     C                   MOVEL     *BLANK        MsgDtaXAr
282700200528     C                   MOVEL     *BLANK        WFldNmXAr
282800200528     C                   MOVEL     *BLANK        WMsgIDXAr
282900200528     C                   MOVEL     *BLANK        WMsgDtXAr
283000200528
283100200528     C                   ENDSR
283200200528      *****************************************************************
283300200528      /EJECT
283400200528      *****************************************************************
283500200528      * UPDATERRS - Update error information with that received back  *
283600200528      *    from each validation module.                               *
283700200528      *****************************************************************
283800200528
283900200528     C     UPDATERRS     BEGSR
284000200528      *
284100200528      * Update error fields/message IDs/message data (arrays)
284200200528      *
284300200528     C                   Z-ADD     1             I                 3 0
284400200528     C     *BLANK        LOOKUP    FldNameArr(I)                          99
284500200528     C     *IN99         IFEQ      '1'
284600200528     C                   MOVEA     FldNamXAr     FlDNameArr(I)
284700200528     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
284800200528     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
284900200528     C                   END
285000200528      *
285100200528      * Set Error Index
285200200528     C                   Z-ADD     1             I
285300200528     C     *BLANK        LOOKUP    FldNameArr(I)                          99
285400200528     C     I             SUB       1             Idx
285500200528      *
285600200528      * Update warning fields/message IDs/message data (arrays)
285700200528      *
285800200528     C                   Z-ADD     1             I
285900200528     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
286000200528     C     *IN99         IFEQ      '1'
286100200528     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
286200200528     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
286300200528     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
286400200528     C                   END
286500200528      *
286600200528      * Set Warning Index
286700200528     C                   Z-ADD     1             I
286800200528     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
286900200528     C     I             SUB       1             WIdx
287000200528      *
287100200528     C                   ENDSR
287200200528      *****************************************************************
287300200528      /EJECT
287400200528      *****************************************************************
287500200528      * #TERM - Termination processing.
287600200528      *****************************************************************
287700200528     C     #TERM         BEGSR
287800200528      *
287900200528      **  Terminate program
288000200528      *
288100200528     C                   MOVE      '1'           *INLR
288200200528      *
288300200528     C     *INU7         IFEQ      '1'
288400200528     C                   DUMP
288500200528     C                   END
288600200528      *
288700200528     C                   RETURN
288800200528      *
288900200528     C                   ENDSR
289000200528      *****************************************************************
289100200528      /EJECT
289200200528      ********************************************************************
289300200528     C/COPY ZACPYSRC,PSSR_ILE
289400200528      ********************************************************************
289500200528      /EJECT
289600200528**  CPY@
289700200528(c) Finastra International Limited 2001
