000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas FX Deals database update')                       *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - FX Dealer Module                                     *
000900200528      *                                                               *
001000200528      *  FXFXDLUPF - FX DEALS FX DATABASE UPDATE                      *
001100200528      *                                                               *
001200200528      *  (c) Finastra International Limited 2001                      *
001300200528      *                                                               *
001400200604      *  Last Amend No. 251029             Date 22May20               *
001500200528      *  Prev Amend No. CSD102             Date 08Jan19               *
001600200528      *                 MD046248           Date 27Oct17               *
001700200528      *                 CDL099             Date 06Oct17               *
001800200528      *                 CDL094             Date 30May14               *
001900200528      *                 CSW212             Date 03May12               *
002000200528      *                 CER059             Date 19Jul10               *
002100200528      *                 CER043             Date 19May08               *
002200200528      *                 BUG27841           Date 09Aug10               *
002300200528      *                 CSD083             Date 27May10               *
002400200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
002500200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
002600200528      *                 256564             Date 17Sep08               *
002700200528      *                 255340             Date 29Jul08               *
002800200528      *                 247266             Date 21Jun07               *
002900200528      * Midas Plus 1.4 Base ------------------------------------------*
003000200528      * Midas Plus 1.3 ----------- Base ------------------------------*
003100200528      *                 242477             Date 27Sep06               *
003200200528      *                 228662             Date 20Sep06               *
003300200528      *                 CSD031             Date 10Apr06               *
003400200528      *                 CDL049             Date 07Jul06               *
003500200528      *                 BUG7461            Date 14Jun06               *
003600200528      *                 CSD027             Date 09Dec05               *
003700200528      *                 CDL038             Date 10May05               *
003800200528      *                 208884             Date 29Aug02               *
003900200528      *                 GBO014             Date 15Jun04               *
004000200528      *                 CSW037A            Date 02May05               *
004100200528      *                 BUG5517            Date 19Jan05               *
004200200528      *                 CSD025             Date 11Jan05               *
004300200528      *                 CSW037             Date 15Dec04               *
004400200528      *                 CSW036             Date 15Dec04               *
004500200528      *                 CFX114             Date 15Jun04               *
004600200528      *                 CLE025             Date 20Oct03               *
004700200528      *                 CRE020             Date 20Jan04               *
004800200528      *                 CGL029             Date 01Sep03               *
004900200528      *                 CAP084             Date 21AUG03               *
005000200528      *                 CDE005             Date 19Aug03               *
005100200528      *                 CSD015             Date 14Oct02               *
005200200528      *                 CDL010             Date 02Aug02               *
005300200528      *                 CAS004             Date 26Jun02               *
005400200528      * Midas Release 4.01.02 ----------------------------------------*
005500200528      *                 209009             Date 03Sep02               *
005600200528      * Midas Release 4.01 -------------------------------------------*
005700200528      *                 CAS001             Date 23Nov01               *
005800200528      *                 CSC011             Date 18Sep01               *
005900200528      * Midas Release 4 --------------- Base -------------------------*
006000200528      *                 200400             Date 20Nov01               *
006100200528      * Midas DBA 3.05 -----------------------------------------------*
006200200528      * Midas DBA 3.04 -----------------------------------------------*
006300200528      *                 184720             Date 07Nov00               *
006400200528      *                 179510             Date 06Nov00               *
006500200528      *                 CDL008             Date 02May00               *
006600200528      * Midas DBA 3.03 -----------------------------------------------*
006700200528      *                 CDE001             Date 12Apr00               *
006800200528      * Midas DBA 3.02 -----------------------------------------------*
006900200528      *                 CAP051             Date 11Nov99               *
007000200528      *                 CPB001             Date 01Jun99               *
007100200528      *                 CAP013             Date 07Sep99               *
007200200528      *                 168345             Date 12Oct99               *
007300200528      * Midas DBA 3.00 -----------------Base--------------------------*
007400200528      *                 CAP006             DATE 23Feb99               *
007500200528      *                 154448             DATE 13Jul98               *
007600200528      *                 136434             Date 01Jun98               *
007700200528      *                 CAP002  *CREATE    Date 01Nov97               *
007800200528      *                                                               *
007900200528      *---------------------------------------------------------------*
008000200528      *                                                               *
008100200528      *  251029 - Applied fix 231306.                                 *
008200200528      *  231306 - Handle file locking properly.                       *
008300200528      *  CSD102 - Password Length Extension (Recompile)               *
008400200528      *  MD046248 - Finastra Rebranding                               *
008500200528      *  CDL099 - Split Value Date                                    *
008600200528      *  CDL094 - Enhance  Receive Settlement Instructions            *
008700200528      *  CSW212 - SWIFT 2012 Changes                                  *
008800200528      *  CER059 - German Feature Upgrade to Delhi                     *
008900200528      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
009000200528      *  BUG27841 - Status changes to Requires Reauthorisation        *
009100200528      *             during Delete Action                              *
009200200528      *  CSD083 - Watch List Compliance Upgrade                       *
009300200528      *  256564 - Recompile due to PF changes done by fix 256330      *
009400200528      *  255340 - Move reference rate to its field in FXDEALPP when   *
009500200528      *           CDL049 is on.                                       *
009600200528      *  247266 - When deal is reversed, saved it as unauthorised.    *
009700200528      *  242477 - Applied fix 200709.  2nd leg swap deal number not   *
009800200528      *           shown on enquiry via option TRIP-FXDN.              *
009900200528      *  228662 - FX deals in API lose Front Office ID.               *
010000200528      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
010100200528      *  CDL049 - Addition of a Reference Rate field                  *
010200200528      *  BUG7461 - Authorising Officer shown as QUS                   *
010300200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
010400200528      *  CDL038 - Extended Deal Sub Type                              *
010500200528      *  208884 - Delete of unauthorised deal received from interface *
010600200528      *           must send a "refused" message to the sender.        *
010700200528      *  GBO014 - Perform Override when Exchange Rate Tolerance is    *
010800200528      *                    exceeded.                                  *
010900200528      *                  - Upgrade to Midasplus                       *
011000200528      *           Core hooks amended:FXFXDLFD01,FXFXDLFC14,FXFXDLFF01,*
011100200528      *                              FXFXDLFC04                       *
011200200528      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
011300200528      *  BUG5517- Authorisation Error on FXDL.  Retrieve contents of  *
011400200528      *           DTAARA/ZMUSER moved out of INZSR                    *
011500200528      *  CSD025 - Customer De-Activation                              *
011600200528      *  CSW037 - Additional Field Data on MT300/MT320                *
011700200528      *  CSW036 - Dual SWIFT BIC held on Client Details               *
011800200528      *  CFX114 - Core changes for GBO014                             *
011900200528      *         - Perform Override when Exchange Rate Tolerance is    *
012000200528      *           exceeded.                                           *
012100200528      *         - Upgrade to Midasplus                                *
012200200528      *           Core hooks amended:FXFXDLFD01,FXFXDLFC14,FXFXDLFF01,*
012300200528      *                              FXFXDLFC04                       *
012400200528      *  CLE025 - Credit Lines (Recompile)                            *
012500200528      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
012600200528      *  CGL029 - Increase Account Code to 10 digits                  *
012700200528      *  CAP084 - Add ZMUSER processing for Midas Plus.               *
012800200528      *  CDE005 - Data Export - Reservation ID                        *
012900200528      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
013000200528      *  CDL010 - Prevent last user that actioned the trade from      *
013100200528      *           authorising it.                                     *
013200200528      *  CAS004 - Hedge Accounting Phase A                            *
013300200528      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
013400200528      *           FXCPYSRC.                                           *
013500200528      *  CAS001 - Net Present Value (NPV) Accounting                  *
013600200528      *  CSC011 - 24x7 Midas Availability                             *
013700200528      *  200400 - Reverse fix 179510 and replace it with a new fix.   *
013800200528      *  184720 - Do not check if the Timestamp has changed on Insert.*
013900200528      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
014000200528      *           Midas  Our  Receive/ Pay  Instructions  respectively
014100200528      *           not  correctly  updated .  Introduced  new parametrs
014200200528      *           when  calling   ZAALTRECIN/ PAYIN  modules .        *
014300200528      *  CDL008 - Continuous Linked Settlement                        *
014400200528      *  CDE001 - Data Export - CCRM Limits                           *
014500200528      *  CAP051 - Automatic Authorisation (FX Part)                   *
014600200528      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
014700200528      *           Recompiled due to changes in FXDEALPP               *
014800200528      *  CAP013 - Allow access by Midas transaction ID if not insert  *
014900200528      *  168345 - Prevent two users from accessing same transaction   *
015000200528      *           in repair screen at the same cycle, and converting  *
015100200528      *           it into two different Midas Deal No.s  .            *
015200200528      *           Second user should not be allowed to repair the tran-
015300200528      *           saction and convert it into a another Midas Deal    *
015400200528      *  CAP006 - Check for deal being updated by another workstation *
015500200528      *  154448 - Correct update of online position file for swap deals
015600200528      *  136434 - Treasury Management updates were missing from FX    *
015700200528      *  CAP002 - Conversion of Midas inputs to modular API structure *
015800200528      *                                                               *
015900200528      *****************************************************************
016000200528     FFXDEAULL  UF A E           K DISK
016100200528     F                                     COMMIT
016200200528     F                                     INCLUDE(FXDEALP0)
016300200528                                                                                              CSD015
016400200528      ** Compliance Watch Hit List                                                            CSD015
016500200528     FSDCWHTL1  IF   E           K DISK    INFSR(SRERR)                                       CSD015
016600200528     F/COPY WNCPYSRC,FXH00075
016700200528                                                                                              CSD015
016800200528     FREADVCL1  UF   E           K DISK    INFSR(SRERR)                                       CRE020
016900200528     F                                     USROPN                                             CRE020
017000200528      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref                            CRE020
017100200528                                                                                              CRE020
017200200528     F/COPY WNCPYSRC,FXFXDLFF01
017300200528
017400200528      *****************************************************************
017500200528      ** +--------------------------------------+
017600200528      ** ¦ Automatically included D-specs       ¦
017700200528      ** ¦ ==============================       ¦
017800200528      ** +--------------------------------------+
017900200528      **
018000200528      ** Standard D-specs
018100200528      ** ================
018200200528      **
018300200528      ** The following /COPY line includes the LDA layout,
018400200528      ** the copyright array definition,
018500200528      ** and the following named constants:
018600200528      **    True       logical = *on (for indcator processing)
018700200528      **    False      logical = *off (for indcator processing)
018800200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
018900200528      **                                    handler)
019000200528      ** and the following variables:
019100200528      **    RunBefore  1A (for the PSSR)
019200200528
019300200528     D/COPY ZACPYSRC,STD_D_SPEC
019400200528
019500200528      ** Include the FX standard declares
019600200528     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
019700200528     D/COPY ZACPYSRC,STDDECLARE                                                               209009
019800200528
019900200528      ** Program Status Data Structure
020000200528      ** =============================
020100200528      ** The following /COPY line includes all the defined fields in the
020200200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
020300200528
020400200528     D/COPY ZACPYSRC,PSDS
020500200528
020600200528      **------------------------------------------------------------------------CAP006 -------------
020700200528      ** The following /COPY line includes the definitions for error and        CAP006
020800200528      ** warning message arrays.                                                CAP006
020900200528     D/COPY ZACPYSRC,ERR_ARRAYS                                                 CAP006
021000200528      **------------------------------------------------------------------------CAP006--------------
021100200528                                                                                CAP006
021200200528      ** +--------------------------------------+
021300200528      ** ¦ End of automatically included D-specs¦
021400200528      ** ¦ =====================================¦
021500200528      ** +--------------------------------------+
021600200528
021700200528      *****************************************************************
021800200528
021900200528      ** DEFINE FIELDS FOR ZDATE9
022000200528     D @DAYN           S              5P 0
022100200528     D @YMD            S              8S 0
022200200528     D @RETN           S              1A
022300200528
022400200528      ** Timestamp for the transaction                                          CAP006
022500200528     D TimeStamp       S               Z                                        CAP006
022600200528                                                                                CAP006
022700200528      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR DEAL
022800200528     D FXVFXD        E DS                  EXTNAME(FXVFXDLPD)
022900200528     D  @F3CTL                 1     23
023000200528     D  @F3VDY                30     37  0
023100200528     D  @F3TDY                38     45  0
023200200528     D  @F3OEY                46     53  0
023300200528     D  @F3DAN                54     59  0
023400200528     D  @F3DDY               161    168  0
023500200528     D  @F3ALR1              173    203
023600200528     D  @F3ALP1              204    234
023700200528     D  @F3ALR2              251    270
023800200528     D  @F3ALP2              271    345
023900200528     D  @F3REC               400    468
024000200528     D  @F3PAY               469   1027
024100200528     D  @F3ISDA             1394   2043                                                       CSW212
024200200528     D/COPY WNCPYSRC,FXFXDLFD02
024300200528
024400200528      **  DEALS FILE - FX DEALS
024500200528     D FXDEAL        E DS                  EXTNAME(FXDEALPP)
024600200528     D FXDEALRONS    E                     EXTFLD(QQRONS)                                     CGL029
024700200528     D FXDEALPONS    E                     EXTFLD(QQPONS)                                     CGL029
024800200528     D FXDEALMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
024900200528     D FXDEALDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
025000200528     D FXDEALMORI    E                     EXTFLD(QQMORI)                                     CGL029
025100200528     D FXDEALDORI    E                     EXTFLD(QQDORI)                                     CGL029
025200200528     D  @FHCTL                 1     23
025300200528     D  @FHDDY               161    168  0
025400200528     D  @FHALR1              173    203
025500200528     D  @FHALP1              204    234
025600200528     D  @FHALR2              251    270
025700200528     D  @FHALP2              271    345
025800200528     D  @FHREC               400    468
025900200528     D  @FHPAY               469   1027
026000200528     D  @FHISDA             1394   2043                                                       CSW212
026100200528     D/COPY WNCPYSRC,FXFXDLFD03
026200200528
026300200528     D ChkDealFmt    E DS                  EXTNAME(FXDEALPP)                    CAP006
026400200528      ** Rename fields for Timestamp checking                                   CAP006
026500200528     D                                     PREFIX(CH)                           CAP006
026600200528                                                                                CAP006
026700200528     D FXEFXD        E DS                  EXTNAME(FXEFXDLPD)                   CAP006
026800200528      * Error indicators                                                        CAP006
026900200528                                                                                CAP006
027000200528      **  EXTERNALLY DESCRIBED DATA STRUCTURES FOR TEMPLATE FILES FOR
027100200528      **  PROJECTED ACCOUNT MOVEMENTS UPDATES
027200200528     D Z#BSTS        E DS                  EXTNAME(Z#BST)
027300200528     D Z#ASTS        E DS                  EXTNAME(Z#AST)
027400200528     D Z#WSTS        E DS                  EXTNAME(Z#WST)
027500200528     D Z#XSTS        E DS                  EXTNAME(Z#XST)                       154448
027600200528
027700200528      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS
027800200528
027900200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
028000200528      * DATA STRUCTURE FOR BANK DETAILS
028100200528
028200200528     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
028300200528      * DATA STRUCTURE FOR DEAL DATA CODES
028400200528
028500200528     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
028600200528      * DATA STRUCTURE FOR MODULE DETAILS
028700200528
028800200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP051
028900200528      * DATA STRUCTURE FOR SWITCHABLE FEATURE DETAILS                           CAP051
029000200528                                                                                CAP051
029100200528     D DSFDY         E DS                  EXTNAME(DSFDY)
029200200528      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
029300200528
029400200528     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
029500200528      ** 24X7 status data area                                                                CSC011
029600200528                                                                                              CSC011
029700200528     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
029800200528      ** SD data area                                                                         CSC011
029900200528                                                                                              CSC011
030000200528     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
030100200528      ** Midas API Message Header Format Definition                                           CSC011
030200200528                                                                                              CSC011
030300200528      ** DS for ZMUSER details                                                                CAP084
030400200528     D ZMUSER          DS            17                                                       CAP084
030500200528     D  PUSRID                 1     10                                                       CAP084
030600200528     D  PDBRN                 11     13                                                       CAP084
030700200528     D  PDPPT                 14     16                                                       CAP084
030800200528                                                                                208884
030900200528     D InvRp         E DS                  EXTNAME(FXIFXDLPD)                   208884
031000200528     D                                     PREFIX(R:2)                          208884
031100200528                                                                                208884
031200200528      * RUN DATE & MULTI-BRANCHING INDICATOR
031300200528
031400200528     D RUNDAT          DS
031500200528     D  @DLUP                  1      2  0
031600200528     D  @MLUP                  3      5
031700200528     D  @YLUP                  6      7  0
031800200528     D  @MBIN                 13     13
031900200528                                                                                CAP006
032000200528     D/COPY WNCPYSRC,FXFXDLFD04
032100200528      ** Dummy message ID and message file fields for use on the calls to       CAP006
032200200528      ** ZAMSGTOOPR                                                             CAP006
032300200528     D DummyMsgID      S                   LIKE(#MsgID)                         CAP006
032400200528     D DummyMsgF       S             10A                                        CAP006
032500200528     D/COPY WNCPYSRC,FXFXDLFD01
032600200528      ** Fields defined for Enhancement CSC011                                                CSC011
032700200528                                                                                              CSC011
032800200528     D CSC011          S              1A                                                      CSC011
032900200528     D TRANSDTL        S           5800A                                                      CSC011
033000200528     D***PDealNum        S             18A                                             CSC011 CGL029
033100200528     D***PADealNum       S             18A                                             CSC011 CGL029
033200200528     D PDealNum        S             24A                                                      CGL029
033300200528     D PADealNum       S             24A                                                      CGL029
033400200528     D PRtCd           S              7A                                                      CSC011
033500200528     D POptn           S              7A                                                      CSC011
033600200528     D PSard           S              6A                                                      CSC011
033700200528     D PTimestamp      S             26A                                                      CSC011
033800200528     D WDealNo         S              6A                                                      CSC011
033900200528                                                                                CAP006
034000200528      ** Define fields used in CAS001                                                         CAS001
034100200528                                                                                              CAS001
034200200528     D CAS001          S              1A                                                      CAS001
034300200528                                                                                              CAS001
034400200528     D WIdx            S              3P 0                                                    CAS004
034500200528                                                                                              CAS004
034600200528     D CDL010          S              1A                                                      CDL010
034700200528      ** Define fields used in CDL010                                                         CDL010
034800200528                                                                                              CDL010
034900200528      ** Fields used in CSD015                                                                CSD015
035000200528                                                                                              CSD015
035100200528      ** Second DS for Access Programs, Long DS                                               CSD015
035200200528     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSD015
035300200528                                                                                              CSD015
035400200528      ** External DS for Customer Details                                                     CSD015
035500200528     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
035600200528                                                                                              CSD015
035700200528      ** External DS for Compliance Watch Transaction Details                                 CSD015
035800200528     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
035900200528                                                                                              CSD015
036000200528      ** Watch List Transaction Details Data Structure                                        CSD015
036100200528     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                  CSD015
036200200528                                                                                              CSD015
036300200528      ** External DS for Watch List Configuration Data                                        CSD015
036400200528     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
036500200528                                                                                              CSD015
036600200528      ** Compliance Engine Free Format String Parameter                                       CSD015
036700200528     D PFreeFmtStr     S          30000A                                                      CSD015
036800200528                                                                                              CSD015
036900200528      ** Array Size Definition                                                                CSD015
037000200528     D Elements        C                   CONST(13)                                          CSD015
037100200528                                                                                              CSD015
037200200528      ** XML Opening Tags for the Compliance Engine                                           CSD015
037300200528     D XOT             S             25A   DIM(Elements) PERRCD(1) CTDATA                     CSD015
037400200528                                                                                              CSD015
037500200528      ** XML Closing Tags for the Compliance Engine                                           CSD015
037600200528     D XCT             S             25A   DIM(Elements) PERRCD(1) CTDATA                     CSD015
037700200528                                                                                              CSD015
037800200528      ** Watch List Fields Array.                                                             CSD015
037900200528     D WLF             S             18A   DIM(Elements)                                      CSD015
038000200528                                                                                              CSD015
038100200528     D CSD015          S              1                                                       CSD015
038200200528     D CCF001          S              1                                                       CSD015
038300200528     D WFuncType       S              8                                                       CSD015
038400200528     D WIdntifier      S             40                                                       CSD015
038500200528     D WBranch         S              3                                                       CSD015
038600200528     D WLChgFlg        S              1    INZ('N')                                           CSD015
038700200528     D WLOKFlg         S              1    INZ('N')                                           CSD015
038800200528     D WXMLPacket      S            310                                                       CSD015
038900200528     D WData           S            216                                                       CSD015
039000200528     D WDate           S             10                                                       CSD015
039100200528     D WDateTemp4      S              4                                                       CSD015
039200200528     D WDateTemp2A     S              2                                                       CSD015
039300200528     D WDateTemp2B     S              2                                                       CSD015
039400200528     D Ctr             S              2P 0                                                    CSD015
039500200528     D ConvertedAmt    S             18P 3                                                    CSD015
039600200528     D PRetCode        S              7                                                       CSD015
039700200528     D POption         S              7                                                       CSD015
039800200528     D PFunc           S              8                                                       CSD015
039900200528     D PCust           S             10                                                       CSD015
040000200528     D PStKey          S              7                                                       CSD015
040100200528     D PDate           S              6                                                       CSD015
040200200528     D PAmt            S             15                                                       CSD015
040300200528     D PFmtCCY         S              3                                                       CSD015
040400200528     D PDummy6         S              6                                                       CSD015
040500200528     D PDummy10        S             10                                                       CSD015
040600200528     D PDummy16        S             16                                                       CSD015
040700200528     D PDummy35        S             35                                                       CSD015
040800200528                                                                                              CSD015
040900200528      ** CRE020 Variables                                                                     CRE020
041000200528     D CRE020          S              1A                                                      CRE020
041100200528     D KRefNo          S             30A                                                      CRE020
041200200528     D KPrgMn          S             10A   INZ('FXFXDLUPD ')                                  CRE020
041300200528     D PSysVal01       S             20A   INZ('ForeignExchangeDeals')                        CRE020
041400200528     D PCurSet01       S            200A                                                      CRE020
041500200528     D PSysVal02       S             20A                                                      CRE020
041600200528     D PCurSet02       S            200A                                                      CRE020
041700200528     D PSysVal03       S             20A                                                      CRE020
041800200528     D PCurSet03       S            200A                                                      CRE020
041900200528     D PSysVal04       S             20A                                                      CRE020
042000200528     D PCurSet04       S            200A                                                      CRE020
042100200528     D PSysVal05       S             20A                                                      CRE020
042200200528     D PCurSet05       S            200A                                                      CRE020
042300200528     D PSysVal06       S             20A                                                      CRE020
042400200528     D PCurSet06       S            200A                                                      CRE020
042500200528     D PSysVal07       S             20A                                                      CRE020
042600200528     D PCurSet07       S            200A                                                      CRE020
042700200528     D PSysVal08       S             20A                                                      CRE020
042800200528     D PCurSet08       S            200A                                                      CRE020
042900200528     D PSysVal09       S             20A                                                      CRE020
043000200528     D PCurSet09       S            200A                                                      CRE020
043100200528     D PSysVal10       S             20A                                                      CRE020
043200200528     D PCurSet10       S            200A                                                      CRE020
043300200528     D WSysVal01       S              1A                                                      CRE020
043400200528                                                                                              CRE020
043500200528     D CER043          S              1A                                                      CER043
043600200528     D CDL099          S              1A                                                      CDL099
043700200528     D/COPY WNCPYSRC,FXH00076
043800200528      /EJECT
043900200528     C*****************************************************************
044000200528     C*                                                               *
044100200528     C* MAIN - MAIN BODY                                              *
044200200528     C*                                                               *
044300200528     C*****************************************************************
044400200528     C/COPY WNCPYSRC,FXFXDLFC03
044500200528      *                                                                                      BUG5517
044600200528      **  Get default branch and user from ZMUSER                                            BUG5517
044700200528     C     *DTAARA       DEFINE                  ZMUSER                                      BUG5517
044800200528     C                   IN        ZMUSER                                                    BUG5517
044900200528     C                   UNLOCK    ZMUSER                                                    BUG5517
045000200528     C                   EVAL      PSUser = PUSRID                                           BUG5517
045100200528      *
045200200528      ** INITIALIZE WORK FIELDS
045300200528      *
045400200528     C                   MOVEL     *BLANK        Z#BSTS
045500200528     C                   MOVEL     *BLANK        Z#ASTS
045600200528     C                   MOVEL     *BLANK        Z#WSTS
045700200528     C                   MOVEL     *BLANK        Z#XSTS                         154448
045800200528      *                                                                         CAP051
045900200528      ***  Transaction coming from Interface require an Automatic Authorisation CAP051
046000200528      *                                                                         CAP051
046100200528     C     CAP051        IFEQ      'Y'                                          CAP051
046200200528     C     F3AUTH        ANDEQ     'Y'                                          CAP051
046300200528     C                   MOVE      'N'           BNFXAU                         CAP051
046400200528     C                   MOVE      'N'           BNFXRA                         CAP051
046500200528     C                   ELSE                                                   CAP051
046600200528     C                   MOVE      SAVFXAU       BNFXAU                         CAP051
046700200528     C                   MOVE      SAVFXRA       BNFXRA                         CAP051
046800200528     C                   ENDIF                                                  CAP051
046900200528      *
047000200528      * SET CONTROL FIELDS
047100200528      *
047200200528     C                   EXSR      SETCTL
047300200528      *
047400200528      ** Ensure transaction has not been updated by another workstation         CAP006
047500200528      ** - if so, bypass updating and return to calling program.                CAP006
047600200528     C                   EXSR      CHKOTHUPD                                    CAP006
047700200528                                                                                CAP006
047800200528     C     @@RTCD        IFNE      *BLANKS                                      CAP006
047900200528     C                   GOTO      EXIT                                         CAP006
048000200528     C                   END                                                    CAP006
048100200528                                                                                CAP006
048200200528      * DO INSERT, AMEND, AUTHORIZE OR DELETE PROCESSING
048300200528      *
048400200528     C     F3LACT        CASEQ     'I'           INSERT
048500200528     C     F3LACT        CASEQ     'A'           AMEND
048600200528     C     F3LACT        CASEQ     'X'           AUTHOR
048700200528     C     F3LACT        CASEQ     'D'           DELETE
048800200528     C                   END
048900200528     C/COPY WNCPYSRC,FXFXDLFC07
049000200528      *
049100200528      ** DO ON-LINE UPDATES
049200200528      *
049300200528     C     F3LACT        IFEQ      'I'
049400200528     C     F3LACT        OREQ      'A'
049500200528     C/COPY WNCPYSRC,FXH00214
049600200528     C     F3LACT        OREQ      'D'
049700200528     C/COPY WNCPYSRC,FXH00215
049800200528     C                   EXSR      ONLNUP
049900200528     C                   END
050000200528      *
050100200528      *
050200200528      ** DO TREASURY MANAGEMENT UPDATES
050300200528      *
050400200528     C     BGTRMG        IFEQ      'Y'
050500200528     C*****BGTRMG        ANDNE     'Y'                                          136434
050600200528     C     F3LACT        IFEQ      'I'
050700200528     C     F3LACT        OREQ      'A'
050800200528     C     F3LACT        OREQ      'D'
050900200528     C                   EXSR      TREAUP
051000200528     C                   END
051100200528     C                   END
051200200528                                                                                              CSC011
051300200528      ** If 24x7 Midas Availability is installed                                              CSC011
051400200528      ** and Support System is active                                                         CSC011
051500200528                                                                                              CSC011
051600200528     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
051700200528                                                                                              CSC011
051800200528     C                   CALLB     'FXFXDLLOG'                                                CSC011
051900200528     C                   PARM      *Blanks       RetCodeOut                                   CSC011
052000200528     C                   PARM                    F3LACT                                       CSC011
052100200528     C                   PARM                    FXVFXD                                       CSC011
052200200528     C                   PARM                    TRANSDTL                                     CSC011
052300200528                                                                                              CSC011
052400200528      ** If there is no error, write the log file                                             CSC011
052500200528                                                                                              CSC011
052600200528     C                   IF        RetCodeOut = *Blanks                                       CSC011
052700200528     C                   EVAL      APTGTTYPE  = 'FXFXDL'                                      CSC011
052800200528     C                   EVAL      APFOTRANID = F3FRNT                                        CSC011
052900200528     C                   EVAL      APRPRLOCN  = F3REPA                                        CSC011
053000200528     C                   EVAL      APUSERID   = PSUser                                        CSC011
053100200528     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
053200200528     C                   MOVEL     F3DN38        PDealNum                                     CSC011
053300200528     C                   MOVEL     F3DADN        PADealNum                                    CSC011
053400200528                                                                                              CSC011
053500200528     C                   CALLB     'APLOGTRAN'                                                CSC011
053600200528     C                   PARM      *Blanks       RetCodeOut                                   CSC011
053700200528     C                   PARM                    APHEAD                                       CSC011
053800200528     C                   PARM                    TRANSDTL                                     CSC011
053900200528     C                   PARM      *Blanks       PTimestamp                                   CSC011
054000200528     C                   PARM                    PDealNum                                     CSC011
054100200528     C                   PARM                    PADealNum                                    CSC011
054200200528     C                   ENDIF                                                                CSC011
054300200528                                                                                              CSC011
054400200528      ** If there is an error in either log file, end program                                 CSC011
054500200528                                                                                              CSC011
054600200528     C                   IF        RetCodeOut <> *Blanks                                      CSC011
054700200528     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
054800200528     C                   ENDIF                                                                CSC011
054900200528                                                                                              CSC011
055000200528     C                   ENDIF                                                                CSC011
055100200528      *
055200200528      * EXIT FROM PROGRAM
055300200528     C     EXIT          TAG                                                    CAP006
055400200528      *
055500200528     C                   RETURN
055600200528     C*****************************************************************
055700200528      /EJECT
055800200528     C*****************************************************************
055900200528     C*                                                               *
056000200528     C* INSERT - FX Deal Inserts                                      *
056100200528     C*                                                               *
056200200528     C*****************************************************************
056300200528     C     INSERT        BEGSR
056400200528     C*
056500200528     C**  IF DEAL IS PART OF A SWAP, OR AN OPTION TAKEDOWN
056600200528     C*
056700200528     C     F3TYPE        IFEQ      'SW'
056800200528     C     F3TYPE        OREQ      'OT'
056900200528     C     F3BROK        OREQ      'SWAP'                                                     242477
057000200528     C*
057100200528     C* ACCESS RELATED DEAL
057200200528     C*
057300200528     C*****@F3DAN        CHAIN     FXDEALP0                           99
057400200528     C     @F3DAN        CHAIN     FXDEALP0                           9998                    231306
057500200528      *                                                                                       231306
057600200528     C     *IN98         IFEQ      '1'                                                        231306
057700200528     C                   EXSR      SRERR                                                      231306
057800200528     C                   ENDIF                                                                231306
057900200528     C*
058000200528     C**  DATA BASE ERROR
058100200528     C*
058200200528     C     *IN99         IFEQ      '1'
058300200528     C                   MOVEL     @F3DAN        DBKEY
058400200528     C                   MOVEL     'FXDEALP0'    DBFILE
058500200528     C                   MOVEL     '001'         DBASE
058600200528     C                   EXSR      SRERR
058700200528     C                   END
058800200528     C*
058900200528     C**  STORE DETAILS OF RELATED DEAL
059000200528     C*
059100200528     C                   MOVEL     FXDEAL        Z#WSTS
059200200528     C*
059300200528     C** IF A SWAP
059400200528     C*
059500200528     C     F3TYPE        IFEQ      'SW'
059600200528     C*
059700200528     C** CONVERT RELATED DEAL TO SWAP
059800200528     C                   MOVE      F3DN38        FHDADN
059900200528     C                   MOVE      'S'           FHDTYP
060000200528     C                   MOVE      'SW'          FHTYPE
060100200528     C                   END
060200200528      *                                                                                       242477
060300200528     C     F3BROK        IFEQ      'SWAP'                                                     242477
060400200528     C                   MOVE      F3DN38        FHDADN                                       242477
060500200528     C                   MOVE      'S'           FHDTYP                                       242477
060600200528     C                   ENDIF                                                                242477
060700200528      *                                                                                       242477
060800200528     C*
060900200528     C** IF A TAKEDOWN
061000200528     C*
061100200528     C     F3TYPE        IFEQ      'OT'
061200200528     C*
061300200528     C** REDUCE BUY & SELL AMOUNTS
061400200528     C                   SUB       F3DAM1        FHDAM1
061500200528     C                   SUB       F3DAM2        FHDAM2
061600200528     C*
061700200528     C** REDUCE DEAL BASE CCY FOR ACCOUNTING EQUIVALENT
061800200528     C                   SUB       F3BCAE        FHBCAE
061900200528     C*
062000200528     C** REDUCE MARGIN AMOUNT
062100200528     C                   SUB       F3MGAM        FHMGAM
062200200528     C*
062300200528     C                   END
062400200528     C*
062500200528      ** Timestamp                                                              CAP006
062600200528     C                   CALLB     'ZAGENTMSTM'                                 CAP006
062700200528     C                   PARM                    TimeStamp                      CAP006
062800200528                                                                                CAP006
062900200528     C                   EVAL      FHTMST  = TimeStamp                          CAP006
063000200528                                                                                CAP006
063100200528     C**  UPDATE RELATED DEAL
063200200528     C*
063300200528     C                   MOVEL     @F3CTL        @FHCTL
063400200528      *                                                                                       CDL010
063500200528      ** User Authorisation details when CDL010 is ON                                         CDL010
063600200528     C                   IF        CDL010 = 'Y'                                               CDL010
063700200528     C                   EXSR      USRUPD                                                     CDL010
063800200528     C                   ENDIF                                                                CDL010
063900200528      *                                                                                       CDL010
064000200528     C                   UPDATE    FXDEALP0
064100200528      *                                                                         CDE001
064200200528      ** Data export for CCRM - Limits                                          CDE001
064300200528     C                   IF        CDE001 = 'Y'                                 CDE001
064400200528     C                   MOVEL     @F3DAN        T#TREF                         CDE001
064500200528     C                   CALLB     'DEWRTTRIG'                                  CDE001
064600200528     C**********         PARM                    T#TREF           20                   CDE001 CGL029
064700200528     C                   PARM                    T#TREF           26                          CGL029
064800200528     C                   PARM      'FXDL'        T#TCAT            4            CDE001
064900200528     C                   PARM      *BLANKS       T#RSRV           10            CDE005
065000200528     C                   ENDIF                                                  CDE001
065100200528     C*                                                                         154448
065200200528     C* STORE DETAILS OF AFTER STATUS OF RELATED DEAL                           154448
065300200528     C*                                                                         154448
065400200528     C                   MOVEL     FXDEAL        Z#XSTS                         154448
065500200528     C*
065600200528     C**  SAVE RELATED DEAL AMOUNTS
065700200528     C*
065800200528     C                   MOVE      FHOOFA        @@OOFA           15 0
065900200528     C                   MOVE      FHOOSA        @@OOSA           15 0
066000200528     C                   END
066100200528     C*
066200200528     C*
066300200528     C**  SET DEAL FIELDS ON INSERT
066400200528     C*
066500200528     C                   EXSR      SETINS
066600200528     C*
066700200528     C**  ACCESS DEAL
066800200528     C*
066900200528     C                   CLEAR                   FXDEAL
067000200528     C*****F3DN38        CHAIN     FXDEALP0                           99                      231306
067100200528     C     F3DN38        CHAIN     FXDEALP0                           9998                    231306
067200200528      *                                                                                       231306
067300200528     C     *IN98         IFEQ      '1'                                                        231306
067400200528     C                   EXSR      SRERR                                                      231306
067500200528     C                   ENDIF                                                                231306
067600200528     C*
067700200528     C**  UPDATE 'BEFORE' STATUS
067800200528     C*
067900200528     C                   MOVEL     FXDEAL        Z#BSTS
068000200528     C*
068100200528     C**  UPDATE DEAL
068200200528     C*
068300200528     C                   MOVEL     FXVFXD        FXDEAL
068400200528     C*
068500200528                                                                                              CSC011
068600200528      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
068700200528      ** transaction even if it originated from SIN module.                                   CSC011
068800200528                                                                                              CSC011
068900200528     C                   IF        CSC011 = 'Y'                                               CSC011
069000200528                                                                                              CSC011
069100200528     C                   IF        FHFRNT = *BLANKS                                           CSC011
069200200528     C                   MOVE      FHDN38        WDealNo                                      CSC011
069300200528     C                   EVAL      FHFRNT = 'MD' + WDealNo                                    CSC011
069400200528     C                   ENDIF                                                                CSC011
069500200528                                                                                              CSC011
069600200528     C                   IF        FHAFRT = *BLANKS                                           CSC011
069700200528     C                   IF        FHDADN <> *BLANKS                                          CSC011
069800200528     C                   EVAL      FHAFRT = 'MD' + FHDADN                                     CSC011
069900200528     C                   ENDIF                                                                CSC011
070000200528     C                   ENDIF                                                                CSC011
070100200528                                                                                              CSC011
070200200528     C                   ENDIF                                                                CSC011
070300200528                                                                                              CSC011
070400200528      ** User Authorisation details when CDL010 is ON                                         CDL010
070500200528     C                   IF        CDL010 = 'Y'                                               CDL010
070600200528     C                   EXSR      USRUPD                                                     CDL010
070700200528     C                   ENDIF                                                                CDL010
070800200528      *                                                                                       CDL010
070900200528     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
071000200528     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                          CSD015
071100200528     C                             AND LIBR = S1MAIN)                                         CSD015
071200200528                                                                                              CSD015
071300200528     C                   MOVEL     FHRONS        WLF(1)                                       CSD015
071400200528     C                   MOVEL     FHROCN        WLF(2)                                       CSD015
071500200528     C                   MOVEL     FHRIBN        WLF(3)                                       CSD015
071600200528     C                   MOVEL     FHROBN        WLF(4)                                       CSD015
071700200528     C                   MOVEL     FHPONS        WLF(5)                                       CSD015
071800200528     C                   MOVEL     FHPOCN        WLF(6)                                       CSD015
071900200528     C                   MOVEL     FHRVNO        WLF(7)                                       CSD015
072000200528     C                   MOVEL     FHRCRN        WLF(8)                                       CSD015
072100200528     C                   MOVEL     FHPIBN        WLF(9)                                       CSD015
072200200528     C                   MOVEL     FHPOBN        WLF(10)                                      CSD015
072300200528     C                   MOVEL     FHAWBN        WLF(11)                                      CSD015
072400200528     C                   MoveL     FHBENN        WLF(12)                                      CSD015
072500200528                                                                                              CSD015
072600200528     C                   EVAL      Ctr = 1                                                    CSD015
072700200528     C                   DOU       Ctr >= Elements                                            CSD015
072800200528                                                                                              CSD015
072900200528     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
073000200528     C                   EVAL      WLOKFlg = 'Y'                                              CSD015
073100200528     C                   LEAVE                                                                CSD015
073200200528     C                   ENDIF                                                                CSD015
073300200528                                                                                              CSD015
073400200528     C                   EVAL      Ctr = Ctr + 1                                              CSD015
073500200528                                                                                              CSD015
073600200528     C                   ENDDO                                                                CSD015
073700200528                                                                                              CSD015
073800200528     C                   IF        WLOKFlg = 'Y'                                              CSD015
073900200528     C                   EXSR      SrWatch                                                    CSD015
074000200528     C                   ENDIF                                                                CSD015
074100200528                                                                                              CSD015
074200200528     C                   ENDIF                                                                CSD015
074300200528                                                                                              CSD015
074400200528     C                   IF        CDL099 = 'Y'                                               CDL099
074500200528      *                                                                                       CDL099
074600200528     C                   IF        F3VS2Y = *ZEROS                                            CDL099
074700200528     C                   Z-ADD     FHVDYY        FHVS2Y                                       CDL099
074800200528     C                   Z-ADD     FHVDMM        FHVS2M                                       CDL099
074900200528     C                   Z-ADD     FHVDDD        FHVS2D                                       CDL099
075000200528     C                   Z-ADD     FHVDDN        FHS2DN                                       CDL099
075100200528      *                                                                                       CDL099
075200200528     C                   ELSE                                                                 CDL099
075300200528      *                                                                                       CDL099
075400200528     C                   EVAL      FHVS2Y = F3VS2Y                                            CDL099
075500200528     C                   EVAL      FHVS2D = F3VS2D                                            CDL099
075600200528     C                   EVAL      FHVS2M = F3VS2M                                            CDL099
075700200528     C                   EVAL      FHS2DN = F3S2DN                                            CDL099
075800200528      *                                                                                       CDL099
075900200528     C                   ENDIF                                                                CDL099
076000200528      *                                                                                       CDL099
076100200528     C                   EVAL      FHS1DN = 0                                                 CDL099
076200200528     C                   ENDIF                                                                CDL099
076300200528      *                                                                                       CDL099
076400200528     C*  WRITE (OR UPDATE IF PRESENT) NEW DEAL
076500200528     C*
076600200528     C     *IN99         IFEQ      '0'
076700200528     C                   UPDATE    FXDEALP0
076800200528     C                   ELSE
076900200528     C                   WRITE     FXDEALP0
077000200528     C/COPY WNCPYSRC,FXFXDLFC01
077100200528     C                   END
077200200528     C/COPY WNCPYSRC,FXFXDLFC04
077300200528     C*
077400200528     C**  UPDATE 'AFTER' STATUS
077500200528     C*
077600200528     C                   MOVEL     FXDEAL        Z#ASTS
077700200528     C                   ENDSR
077800200528     C*****************************************************************
077900200528      /EJECT
078000200528     C*****************************************************************
078100200528     C*                                                               *
078200200528     C* AMEND - FX Deal Amends                                        *
078300200528     C*                                                               *
078400200528     C*****************************************************************
078500200528     C     AMEND         BEGSR
078600200528     C*
078700200528     C**  ACCESS DEAL
078800200528     C*
078900200528     C*****F3DN38        CHAIN     FXDEALP0                           99                      231306
079000200528     C     F3DN38        CHAIN     FXDEALP0                           9998                    231306
079100200528      *                                                                                       231306
079200200528     C     *IN98         IFEQ      '1'                                                        231306
079300200528     C                   EXSR      SRERR                                                      231306
079400200528     C                   ENDIF                                                                231306
079500200528     C*
079600200528     C**  DATA BASE ERROR
079700200528     C*
079800200528     C     *IN99         IFEQ      '1'
079900200528     C                   MOVEL     F3DN38        DBKEY
080000200528     C                   MOVEL     'FXDEALP0'    DBFILE
080100200528     C                   MOVEL     '002'         DBASE
080200200528     C                   EXSR      SRERR
080300200528     C                   END
080400200528     C*
080500200528     C**  UPDATE 'BEFORE' STATUS
080600200528     C*
080700200528     C                   MOVEL     FXDEAL        Z#BSTS
080800200528     C/COPY WNCPYSRC,FXFXDLFC08
080900200528     C*
081000200528     C**  SET DEAL FIELDS ON AMEND
081100200528     C*
081200200528     C                   EXSR      SETAMD
081300200528      *                                                                                       CDL010
081400200528      ** User Authorisation details when CDL010 is ON                                         CDL010
081500200528     C                   IF        CDL010 = 'Y'                                               CDL010
081600200528     C                   EXSR      USRUPD                                                     CDL010
081700200528     C                   ENDIF                                                                CDL010
081800200528                                                                                              CSD015
081900200528     C                   If        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
082000200528     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                          CSD015
082100200528     C                             AND LIBR = S1MAIN)                                         CSD015
082200200528                                                                                              CSD015
082300200528     C                   EVAL      WFuncType = 'FXDEALPP'                                     CSD015
082400200528     C                   MOVEL     FHDN38        WIdntifier                                   CSD015
082500200528     C                   EVAL      WBranch = FHMBCA                                           CSD015
082600200528                                                                                              CSD015
082700200528     C     KCwFld        CHAIN     SDCWHTL1                                                   CSD015
082800200528                                                                                              CSD015
082900200528     C                   IF        %FOUND(SDCWHTL1) AND W3UNCF = 'Y'                          CSD015
083000200528                                                                                              CSD015
083100200528     C                   MOVEL     FHRONS        WLF(1)                                       CSD015
083200200528     C                   MOVEL     FHROCN        WLF(2)                                       CSD015
083300200528     C                   MOVEL     FHRIBN        WLF(3)                                       CSD015
083400200528     C                   MOVEL     FHROBN        WLF(4)                                       CSD015
083500200528     C                   MOVEL     FHPONS        WLF(5)                                       CSD015
083600200528     C                   MOVEL     FHPOCN        WLF(6)                                       CSD015
083700200528     C                   MOVEL     FHRVNO        WLF(7)                                       CSD015
083800200528     C                   MOVEL     FHRCRN        WLF(8)                                       CSD015
083900200528     C                   MOVEL     FHPIBN        WLF(9)                                       CSD015
084000200528     C                   MOVEL     FHPOBN        WLF(10)                                      CSD015
084100200528     C                   MOVEL     FHAWBN        WLF(11)                                      CSD015
084200200528     C                   MOVEL     FHBENN        WLF(12)                                      CSD015
084300200528     C                   EXSR      SrWatch                                                    CSD015
084400200528                                                                                              CSD015
084500200528     C                   ELSE                                                                 CSD015
084600200528                                                                                              CSD015
084700200528     C                   MOVEA     *BLANKS       WLF                                          CSD015
084800200528                                                                                              CSD015
084900200528     C                   IF        FHRONS <> CHFHRONS                                         CSD015
085000200528     C                   MOVEL     FHRONS        WLF(1)                                       CSD015
085100200528     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
085200200528     C                   ENDIF                                                                CSD015
085300200528                                                                                              CSD015
085400200528     C                   IF        FHROCN <> CHFHROCN                                         CSD015
085500200528     C                   MOVEL     FHROCN        WLF(2)                                       CSD015
085600200528     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
085700200528     C                   ENDIF                                                                CSD015
085800200528                                                                                              CSD015
085900200528     C                   IF        FHRIBN <> CHFHRIBN                                         CSD015
086000200528     C                   MOVEL     FHRIBN        WLF(3)                                       CSD015
086100200528     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
086200200528     C                   ENDIF                                                                CSD015
086300200528                                                                                              CSD015
086400200528     C                   IF        FHROBN <> CHFHROBN                                         CSD015
086500200528     C                   MOVEL     FHROBN        WLF(4)                                       CSD015
086600200528     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
086700200528     C                   ENDIF                                                                CSD015
086800200528                                                                                              CSD015
086900200528     C                   IF        FHPONS <> CHFHPONS                                         CSD015
087000200528     C                   MOVEL     FHPONS        WLF(5)                                       CSD015
087100200528     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
087200200528     C                   ENDIF                                                                CSD015
087300200528                                                                                              CSD015
087400200528     C                   IF        FHPOCN <> CHFHPOCN                                         CSD015
087500200528     C                   MOVEL     FHPOCN        WLF(6)                                       CSD015
087600200528     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
087700200528     C                   ENDIF                                                                CSD015
087800200528                                                                                              CSD015
087900200528     C                   IF        FHRVNO <> CHFHRVNO                                         CSD015
088000200528     C                   MOVEL     FHRVNO        WLF(7)                                       CSD015
088100200528     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
088200200528     C                   ENDIF                                                                CSD015
088300200528                                                                                              CSD015
088400200528     C                   IF        FHRCRN <> CHFHRCRN                                         CSD015
088500200528     C                   MOVEL     FHRCRN        WLF(8)                                       CSD015
088600200528     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
088700200528     C                   ENDIF                                                                CSD015
088800200528                                                                                              CSD015
088900200528     C                   IF        FHPIBN <> CHFHPIBN                                         CSD015
089000200528     C                   MOVEL     FHPIBN        WLF(9)                                       CSD015
089100200528     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
089200200528     C                   ENDIF                                                                CSD015
089300200528                                                                                              CSD015
089400200528     C                   IF        FHPOBN <> CHFHPOBN                                         CSD015
089500200528     C                   MOVEL     FHPOBN        WLF(10)                                      CSD015
089600200528     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
089700200528     C                   ENDIF                                                                CSD015
089800200528                                                                                              CSD015
089900200528     C                   IF        FHAWBN <> CHFHAWBN                                         CSD015
090000200528     C                   MOVEL     FHAWBN        WLF(11)                                      CSD015
090100200528     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
090200200528     C                   ENDIF                                                                CSD015
090300200528                                                                                              CSD015
090400200528     C                   IF        FHBENN <> CHFHBENN                                         CSD015
090500200528     C                   MOVEL     FHBENN        WLF(12)                                      CSD015
090600200528     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
090700200528     C                   ENDIF                                                                CSD015
090800200528                                                                                              CSD015
090900200528     C                   If        WLChgFlg = 'Y'                                             CSD015
091000200528     C                   EXSR      SrWatch                                                    CSD015
091100200528     C                   ENDIF                                                                CSD015
091200200528                                                                                              CSD015
091300200528     C                   ENDIF                                                                CSD015
091400200528                                                                                              CSD015
091500200528     C                   ENDIF                                                                CSD015
091600200528                                                                                              CSD015
091700200528     C*
091800200528     C**  UPDATE RECORD
091900200528     C*
092000200528     C                   EVAL      FHRRAT = F3RRAT                                            255340
092100200528     C                   UPDATE    FXDEALP0
092200200528     C*
092300200528     C**  UPDATE VALID DEAL
092400200528     C*
092500200528     C                   MOVEL     FXDEAL        FXVFXD
092600200528     C*
092700200528     C**  UPDATE 'AFTER' STATUS
092800200528     C*
092900200528     C                   MOVEL     FXDEAL        Z#ASTS
093000200528     C*
093100200528     C                   ENDSR
093200200528     C*****************************************************************
093300200528      /EJECT
093400200528     C*****************************************************************
093500200528     C*                                                               *
093600200528     C* AUTHOR - FX Deal Authorize                                    *
093700200528     C*                                                               *
093800200528     C*****************************************************************
093900200528     C     AUTHOR        BEGSR
094000200528     C*
094100200528     C**  ACCESS DEAL
094200200528     C*
094300200528     C*****F3DN38        CHAIN     FXDEALP0                           99                      231306
094400200528     C     F3DN38        CHAIN     FXDEALP0                           9998                    231306
094500200528      *                                                                                       231306
094600200528     C     *IN98         IFEQ      '1'                                                        231306
094700200528     C                   EXSR      SRERR                                                      231306
094800200528     C                   ENDIF                                                                231306
094900200528     C*
095000200528     C**  DATA BASE ERROR
095100200528     C*
095200200528     C     *IN99         IFEQ      '1'
095300200528     C                   MOVEL     F3DN38        DBKEY
095400200528     C                   MOVEL     'FXDEALP0'    DBFILE
095500200528     C                   MOVEL     '003'         DBASE
095600200528     C                   EXSR      SRERR
095700200528     C                   END
095800200528     C*
095900200528     C**  UPDATE 'BEFORE' STATUS
096000200528     C*
096100200528     C                   MOVEL     FXDEAL        Z#BSTS
096200200528     C*
096300200528     C**  SET DEAL FIELDS ON AUTHORIZE
096400200528     C*
096500200528     C                   EXSR      SETAUT
096600200528     C*
096700200528      ** User Authorisation details when CDL010 is ON                                         CDL010
096800200528     C                   IF        CDL010 = 'Y'                                               CDL010
096900200528     C                   EVAL      F3USER = PUSRID                                           BUG7461
097000200528     C                   EXSR      USRUPD                                                     CDL010
097100200528     C                   ENDIF                                                                CDL010
097200200528      *                                                                                       CDL010
097300200528     C**  UPDATE RECORD
097400200528     C*
097500200528     C                   UPDATE    FXDEALP0
097600200528     C*
097700200528     C**  UPDATE VALID DEAL
097800200528     C*
097900200528     C                   MOVEL     FXDEAL        FXVFXD
098000200528     C*
098100200528     C**  UPDATE 'AFTER' STATUS
098200200528     C*
098300200528     C                   MOVEL     FXDEAL        Z#ASTS
098400200528     C/COPY WNCPYSRC,FXFXDLFC11
098500200528     C*
098600200528     C                   ENDSR
098700200528     C*****************************************************************
098800200528      /EJECT
098900200528     C*****************************************************************
099000200528     C*                                                               *
099100200528     C* DELETE - FX Deal Deletes                                      *
099200200528     C*                                                               *
099300200528     C*****************************************************************
099400200528     C     DELETE        BEGSR
099500200528     C*
099600200528     C**  IF DEAL IS PART OF A SWAP, OR AN OPTION TAKEDOWN
099700200528     C*
099800200528     C     F3TYPE        IFEQ      'SW'
099900200528     C     F3TYPE        OREQ      'OT'
100000200528     C*
100100200528     C* ACCESS RELATED DEAL
100200200528     C*
100300200528     C*****@F3DAN        CHAIN     FXDEALP0                           99                      231306
100400200528     C     @F3DAN        CHAIN     FXDEALP0                           9998                    231306
100500200528      *                                                                                       231306
100600200528     C     *IN98         IFEQ      '1'                                                        231306
100700200528     C                   EXSR      SRERR                                                      231306
100800200528     C                   ENDIF                                                                231306
100900200528     C*
101000200528     C**  DATA BASE ERROR
101100200528     C*
101200200528     C     *IN99         IFEQ      '1'
101300200528     C                   MOVEL     @F3DAN        DBKEY
101400200528     C                   MOVEL     'FXDEALP0'    DBFILE
101500200528     C                   MOVEL     '004'         DBASE
101600200528     C                   EXSR      SRERR
101700200528     C                   END
101800200528     C*
101900200528     C**  STORE DETAILS OF RELATED DEAL
102000200528     C*
102100200528     C                   MOVEL     FXDEAL        Z#WSTS
102200200528     C*
102300200528     C** IF A SWAP
102400200528     C*
102500200528     C     F3TYPE        IFEQ      'SW'
102600200528     C*
102700200528     C** DELETE RELATED DEAL
102800200528     C                   MOVE      'D'           FHDDLT
102900200528     C                   MOVE      'D'           FHCHTP
103000200528     C                   MOVE      'D'           FHLACT                         154448
103100200528     C                   END
103200200528     C*
103300200528     C** IF A TAKEDOWN
103400200528     C*
103500200528     C     F3TYPE        IFEQ      'OT'
103600200528     C*
103700200528     C** INCREASE BUY & SELL AMOUNTS
103800200528     C                   ADD       F3DAM1        FHDAM1
103900200528     C                   ADD       F3DAM2        FHDAM2
104000200528     C*
104100200528     C** INCREASE DEAL BASE CCY FOR ACCOUNTING EQUIVALENT
104200200528     C                   ADD       F3BCAE        FHBCAE
104300200528     C*
104400200528     C** INCREASE MARGIN AMOUNT
104500200528     C                   ADD       F3MGAM        FHMGAM
104600200528     C*
104700200528     C                   END
104800200528     C*
104900200528      ** Timestamp                                                              CAP006
105000200528     C                   CALLB     'ZAGENTMSTM'                                 CAP006
105100200528     C                   PARM                    TimeStamp                      CAP006
105200200528                                                                                CAP006
105300200528     C                   EVAL      FHTMST  = TimeStamp                          CAP006
105400200528                                                                                CAP006
105500200528     C**  UPDATE RELATED DEAL
105600200528     C*
105700200528     C                   MOVEL     @F3CTL        @FHCTL
105800200528     C                   UPDATE    FXDEALP0
105900200528      *                                                                         CDE001
106000200528      ** Data export for CCRM - Limits                                          CDE001
106100200528     C                   IF        CDE001 = 'Y'                                 CDE001
106200200528     C                   MOVEL     @F3DAN        T#TREF                         CDE001
106300200528     C                   CALLB     'DEWRTTRIG'                                  CDE001
106400200528     C**********         PARM                    T#TREF           20                   CDE001 CGL029
106500200528     C                   PARM                    T#TREF                                       CGL029
106600200528     C                   PARM      'FXDL'        T#TCAT            4            CDE001
106700200528     C                   PARM      *BLANKS       T#RSRV           10            CDE005
106800200528     C                   ENDIF                                                  CDE001
106900200528     C*                                                                         154448
107000200528     C* STORE DETAILS OF AFTER STATUS OF RELATED DEAL                           154448
107100200528     C*                                                                         154448
107200200528     C                   MOVEL     FXDEAL        Z#XSTS                         154448
107300200528     C                   END
107400200528     C*
107500200528     C**  ACCESS DEAL
107600200528     C*
107700200528     C*****F3DN38        CHAIN     FXDEALP0                           99                      231306
107800200528     C     F3DN38        CHAIN     FXDEALP0                           9998                    231306
107900200528      *                                                                                       231306
108000200528     C     *IN98         IFEQ      '1'                                                        231306
108100200528     C                   EXSR      SRERR                                                      231306
108200200528     C                   ENDIF                                                                231306
108300200528     C*
108400200528     C**  DATA BASE ERROR IF NOT FOUND
108500200528     C*
108600200528     C     *IN99         IFEQ      '1'
108700200528     C                   MOVEL     F3DN38        DBKEY
108800200528     C                   MOVEL     'FXDEALP0'    DBFILE
108900200528     C                   MOVEL     '005'         DBASE
109000200528     C                   EXSR      SRERR
109100200528     C                   END
109200200528     C*
109300200528     C**  UPDATE 'BEFORE' STATUS
109400200528     C*
109500200528     C                   MOVEL     FXDEAL        Z#BSTS
109600200528     C*
109700200528     C**  SET DEAL FIELDS ON DELETE
109800200528     C*
109900200528     C                   EXSR      SETDEL
110000200528                                                                                208884
110100200528      ** Send a User Defined Journal Entry to simulate a delete from repair     208884
110200200528     C     FHDSTS        IFNE      'A'                                          208884
110300200528     C     FHDSTS        ANDNE     'R'                                          208884
110400200528     C     FHFRNT        ANDNE     *BLANKS                                      208884
110500200528     C                   MOVE      'D'           RACTN                          208884
110600200528     C                   MOVE      FHFRNT        RFOTRANID                      208884
110700200528     C                   MOVE      FHDN38        RDLNO                          208884
110800200528     C                   MOVEL     *BLANKS       EntryData                      208884
110900200528     C                   MOVEL     *BLANKS       FileName                       208884
111000200528     C                   CALL      'RPC1600'                                    208884
111100200528     C                   PARM      InvRp         EntryData      3000            208884
111200200528     C                   PARM      'FXIFXDLPD'   FileName         10            208884
111300200528     C                   ENDIF                                                  208884
111400200528     C*
111500200528     C**  UPDATE RECORD
111600200528     C*
111700200528     C                   UPDATE    FXDEALP0
111800200528     C*
111900200528     C**  UPDATE VALID DEAL
112000200528     C*
112100200528     C                   MOVEL     FXDEAL        FXVFXD
112200200528     C*
112300200528     C**  UPDATE 'AFTER' STATUS
112400200528     C*
112500200528     C                   MOVEL     FXDEAL        Z#ASTS
112600200528     C*
112700200528     C                   ENDSR
112800200528     C*****************************************************************
112900200528      /EJECT
113000200528     C*****************************************************************
113100200528     C*                                                               *
113200200528     C* SETINS - SET DEAL FIELDS ON INSERT                            *
113300200528     C*                                                               *
113400200528     C*****************************************************************
113500200528     C     SETINS        BEGSR
113600200528      **
113700200528      ** Deal value date - yyyy       F3VDYY
113800200528      ** Deal value date - mm         F3VDMM
113900200528      ** Deal value date - dd         F3VDDD
114000200528      **  CONVERT VALUE DATE FROM DAY NUMBER TO YMD
114100200528      **
114200200528     C                   Z-ADD     F3VDDN        @DAYN
114300200528     C                   CALLB     'ZDATE9'
114400200528     C                   PARM                    @DAYN
114500200528     C                   PARM                    @YMD
114600200528     C                   PARM                    @RETN
114700200528     C                   Z-ADD     @YMD          @F3VDY
114800200528      **
114900200528      ** Deal transaction date - yyyy F3DTYY
115000200528      ** Deal transaction date - mm   F3DTMM
115100200528      ** Deal transaction date - dd   F3DTDD
115200200528      **  CONVERT RUN DATE FROM DAY NUMBER TO YMD
115300200528      **
115400200528     C                   Z-ADD     BJRDNB        @DAYN
115500200528     C                   CALLB     'ZDATE9'
115600200528     C                   PARM                    @DAYN
115700200528     C                   PARM                    @YMD
115800200528     C                   PARM                    @RETN
115900200528     C                   Z-ADD     @YMD          @F3TDY
116000200528      **
116100200528      ** Option end date year           F3DOEY
116200200528      ** Option end date month          F3DOEM
116300200528      ** Option end date day            F3DOED
116400200528      **
116500200528     C     F3OTDN        IFNE      *ZERO
116600200528     C                   Z-ADD     F3OTDN        @DAYN
116700200528     C                   CALLB     'ZDATE9'
116800200528     C                   PARM                    @DAYN
116900200528     C                   PARM                    @YMD
117000200528     C                   PARM                    @RETN
117100200528     C                   Z-ADD     @YMD          @F3OEY
117200200528     C                   ELSE
117300200528     C                   Z-ADD     *ZERO         @F3OEY
117400200528     C                   END
117500200528      **
117600200528      ** Deal Status and Change Type
117700200528      **
117800200528     C                   CALLB     'ZAFUTSTATP'
117900200528     C                   PARM      'I'           @@ACTN            1
118000200528     C                   PARM      *BLANK        @@CSTS            1
118100200528     C                   PARM                    BNFXAU
118200200528     C                   PARM                    BNFXRA
118300200528     C                   PARM      *BLANK        @@FSTS            1
118400200528     C                   PARM      *BLANK        @@CHTP            1
118500200528     C                   MOVEL     @@FSTS        F3DSTS
118600200528     C                   MOVEL     @@CHTP        F3CHTP
118700200528     C/COPY WNCPYSRC,FXFXDLFC13
118800200528      *
118900200528      ** Determine deal type indicator
119000200528      *
119100200528     C     F3TYPE        IFEQ      'FP'
119200200528     C     F3TYPE        OREQ      'FS'
119300200528     C     F3TYPE        OREQ      'PI'
119400200528     C     F3TYPE        OREQ      'SI'
119500200528     C     F3TYPE        OREQ      'CX'
119600200528     C                   MOVE      *BLANKS       F3DTYP
119700200528     C                   END
119800200528      *
119900200528     C     F3TYPE        IFEQ      'SW'
120000200528     C                   MOVE      'S'           F3DTYP
120100200528     C                   END
120200200528      *
120300200528     C     F3TYPE        IFEQ      'OP'
120400200528     C                   MOVE      'O'           F3DTYP
120500200528     C                   END
120600200528      *
120700200528     C     F3TYPE        IFEQ      'OT'
120800200528     C                   MOVE      'T'           F3DTYP
120900200528     C                   END
121000200528     C*
121100200528     C** BUY AND SELL AMOUNT AND CCY
121200200528     C*
121300200528     C                   Z-ADD     F3DAM1        F3DBUY
121400200528     C                   Z-SUB     F3DAM2        F3DSEL
121500200528      **
121600200528      ** Deal authorisation officer
121700200528      **
121800200528     C     @@FSTS        IFEQ      'A'
121900200528     C                   MOVEL     PSUser        F3AOFR
122000200528     C                   END
122100200528      **
122200200528      ** Deal user code
122300200528      **
122400200528     C                   MOVEL     PSUser        F3DUSC
122500200528      **
122600200528      ** Deal done date - yyyy        F3DDYY
122700200528      ** Deal done date - mm          F3DDMM
122800200528      ** Deal done date - dd          F3DDDD
122900200528      **
123000200528     C                   Z-ADD     F3DDDN        @DAYN
123100200528     C                   CALLB     'ZDATE9'
123200200528     C                   PARM                    @DAYN
123300200528     C                   PARM                    @YMD
123400200528     C                   PARM                    @RETN
123500200528     C                   Z-ADD     @YMD          @F3DDY
123600200528      **
123700200528      ** ALRECI - ALTERNATIVE RECEIVE INSTRUCTIONS
123800200528      **
123900200528     C                   EXSR      ALRECI
124000200528      **
124100200528      ** ALPAYI - ALTERNATIVE PAYMENT INSTRUCTIONS
124200200528      **
124300200528     C                   EXSR      ALPAYI
124400200528      **
124500200528      ** Time of input
124600200528      **
124700200528     C                   TIME                    F3ETIM
124800200528      *
124900200528      ** IF DEAL IS AN OPTION
125000200528     C     F3DTYP        IFEQ      'O'
125100200528     C                   MOVE      F3DAM1        F3OOFA
125200200528     C                   MOVE      F3DAM2        F3OOSA
125300200528     C                   END
125400200528      *
125500200528      ** IF DEAL IS A TAKEDOWN
125600200528     C     F3DTYP        IFEQ      'T'
125700200528     C                   MOVE      @@OOFA        F3OOFA
125800200528     C                   MOVE      @@OOSA        F3OOSA
125900200528     C                   END
126000200528      **
126100200528      ** Deal action date
126200200528      **
126300200528     C                   Z-ADD     BJRDNB        @DAYN
126400200528     C                   CALLB     'ZDATE9'
126500200528     C                   PARM                    @DAYN
126600200528     C                   PARM                    @YMD
126700200528     C                   PARM                    @RETN
126800200528     C                   Z-ADD     @YMD          F3ADAT
126900200528      **                                                                        CAP006
127000200528      ** Timestamp                                                              CAP006
127100200528      **                                                                        CAP006
127200200528     C                   CALLB     'ZAGENTMSTM'                                 CAP006
127300200528     C                   PARM                    TimeStamp                      CAP006
127400200528                                                                                CAP006
127500200528     C                   EVAL      F3TMESTMP = TimeStamp                        CAP006
127600200528                                                                                CAP006
127700200528      **                                                                        CAP006
127800200528      ** Automatic Authorisation flag                                           CAP051
127900200528      *                                                                         CAP051
128000200528     C     CAP051        IFEQ      'Y'                                          CAP051
128100200528     C                   MOVEL     F3AUTH        FHAUTH                         CAP051
128200200528     C                   ELSE                                                   CAP051
128300200528     C                   MOVE      *BLANKS       FHAUTH                         CAP051
128400200528     C                   ENDIF                                                  CAP051
128500200528      *                                                                         CAP051
128600200528     C                   ENDSR
128700200528     C*****************************************************************
128800200528      /EJECT
128900200528     C*****************************************************************
129000200528     C*                                                               *
129100200528     C* SETAMD - SET DEAL FIELDS ON AMEND                             *
129200200528     C*                                                               *
129300200528     C*****************************************************************
129400200528     C     SETAMD        BEGSR
129500200528      *
129600200528      ** UPDATE CONTROL FIELDS
129700200528      *
129800200528     C                   MOVEL     @F3CTL        @FHCTL
129900200528      **
130000200528      ** Deal Status and Change Type
130100200528      **
130200200528     C                   CALLB     'ZAFUTSTATP'
130300200528     C                   PARM      'A'           @@ACTN
130400200528     C                   PARM      FHDSTS        @@CSTS
130500200528     C                   PARM                    BNFXAU
130600200528     C                   PARM                    BNFXRA
130700200528     C                   PARM      *BLANK        @@FSTS
130800200528     C                   PARM      *BLANK        @@CHTP
130900200528     C                   MOVEL     @@FSTS        FHDSTS
131000200528     C                   MOVEL     @@CHTP        FHCHTP
131100200528      *
131200200528      ** Deal customer shortname
131300200528      ** Deal customer number
131400200528      *
131500200528     C                   MOVEL     F3DCSN        FHDCSN
131600200528     C                   MOVEL     F3DCNO        FHDCNO
131700200528      **
131800200528      ** Deal user code
131900200528      **
132000200528     C                   MOVEL     PSUser        FHDUSC
132100200528      *
132200200528      ** Deal branch code
132300200528      ** Branch code (alpha)
132400200528      *
132500200528     C                   MOVEL     F3DBRC        FHDBRC
132600200528     C                   MOVEL     F3MBCA        FHMBCA
132700200528      *
132800200528      ** Deal done date - yyyy
132900200528      ** Deal done date - mm
133000200528      ** Deal done date - dd
133100200528      *
133200200528     C                   Z-ADD     F3DDDN        @DAYN
133300200528     C                   CALLB     'ZDATE9'
133400200528     C                   PARM                    @DAYN
133500200528     C                   PARM                    @YMD
133600200528     C                   PARM                    @RETN
133700200528     C                   Z-ADD     @YMD          @FHDDY
133800200528      **
133900200528      ** ALRECI - ALTERNATIVE RECEIVE INSTRUCTIONS
134000200528      **
134100200528     C                   EXSR      ALRECI
134200200528     C                   MOVEL     @F3ALR1       @FHALR1
134300200528     C                   MOVEL     @F3ALR2       @FHALR2
134400200528     C                   MOVEL     F3DORI        FHDORI                                       CGL029
134500200528     C                   MOVEL     F3MORI        FHMORI                                       CGL029
134600200528      **
134700200528      ** ALPAYI - ALTERNATIVE PAYMENT INSTRUCTIONS
134800200528      **
134900200528     C                   EXSR      ALPAYI
135000200528     C                   MOVEL     @F3ALP1       @FHALP1
135100200528     C                   MOVEL     @F3ALP2       @FHALP2
135200200528     C                   MOVEL     F3DOPI        FHDOPI                                       CGL029
135300200528     C                   MOVEL     F3MOPI        FHMOPI                                       CGL029
135400200528      *
135500200528      ** Deal sub type
135600200528      *
135700200528     C                   MOVEL     F3STYP        FHSTYP
135800200528      *
135900200528      ** Broker code
136000200528      ** Deal brokerage
136100200528      ** Broker currency code
136200200528      *
136300200528     C                   MOVEL     F3BROK        FHBROK
136400200528     C                   MOVEL     F3BRKG        FHBRKG
136500200528     C                   MOVEL     F3BKCY        FHBKCY
136600200528      **
136700200528      ** Deal last action
136800200528      **
136900200528     C                   MOVEL     'A'           FHLACT
137000200528      **
137100200528      ** Deal action date
137200200528      **
137300200528     C                   Z-ADD     BJRDNB        @DAYN
137400200528     C                   CALLB     'ZDATE9'
137500200528     C                   PARM                    @DAYN
137600200528     C                   PARM                    @YMD
137700200528     C                   PARM                    @RETN
137800200528     C                   Z-ADD     @YMD          FHADAT
137900200528      *
138000200528      ** Fed funds indicator
138100200528      *
138200200528     C                   MOVEL     F3FEDF        FHFEDF
138300200528      *
138400200528      ** Book Code
138500200528      *
138600200528     C                   MOVEL     F3BOKC        FHBOKC
138700200528      *
138800200528      ** LINKED DEAL NUMBER
138900200528      *
139000200528     C                   MOVEL     F3LNKN        FHLNKN
139100200528      **
139200200528      ** Extended Receipt Instructions
139300200528      **
139400200528     C                   MOVEL     @F3REC        @FHREC
139500200528     C                   MOVEL     F3RONS        FHRONS                                       CGL029
139600200528                                                                                              CGL029
139700200528     C/COPY WNCPYSRC,FXFXDLFC05
139800200528      **
139900200528      ** Extended Payment Instructions
140000200528      **
140100200528     C                   MOVEL     @F3PAY        @FHPAY
140200200528     C                   MOVEL     F3PONS        FHPONS                                       CGL029
140300200528      *                                                                                       CSW212
140400200528     C                   IF        CSW212 = 'Y'                                               CSW212
140500200528     C                   MOVEL     @F3ISDA       @FHISDA                                      CSW212
140600200528     C                   ENDIF                                                                CSW212
140700200528      *                                                                                       CSW212
140800200528      * Enhanced Receive Settlement Instructions                                              CDL094
140900200528     C                   MOVEL     F3RBB1        FHRBB1                                       CDL094
141000200528     C                   MOVEL     F3RBB2        FHRBB2                                       CDL094
141100200528     C                   MOVEL     F3RBB3        FHRBB3                                       CDL094
141200200528     C                   MOVEL     F3RBB4        FHRBB4                                       CDL094
141300200528     C                   MOVEL     F3RBB5        FHRBB5                                       CDL094
141400200528     C                   MOVEL     F3RBB6        FHRBB6                                       CDL094
141500200528     C/COPY WNCPYSRC,FXFXDLFC06
141600200528      *
141700200528      ** Originating branch
141800200528      *
141900200528     C                   MOVEL     F3ORBR        FHORBR
142000200528      *
142100200528      ** Profit centre
142200200528      *
142300200528     C                   MOVEL     F3PRFC        FHPRFC
142400200528      *
142500200528      ** Our Receive Branch
142600200528      ** Our Pay Branch
142700200528      *
142800200528     C                   MOVEL     F3ROBR        FHROBR
142900200528     C                   MOVEL     F3POBR        FHPOBR
143000200528      *
143100200528      ** COVER MESSAGE REQUIRED
143200200528      *
143300200528     C                   MOVEL     F3CVMR        FHCVMR
143400200528      *
143500200528      ** Buy forward Points amount
143600200528      ** Sell forward Points amount
143700200528      ** Input DL base spot rate
143800200528      ** Other DL base spot rate
143900200528      ** Other DL base spot equiv
144000200528      ** Buy DL base fwd points
144100200528      ** Sell DL base fwd points
144200200528      ** Buy DL base fwd amount
144300200528      ** Sell DL base fwd amount
144400200528      *
144500200528     C                   MOVE      F3BFPA        FHBFPA
144600200528     C                   MOVE      F3SFPA        FHSFPA
144700200528     C                   MOVE      F3BDBS        FHBDBS
144800200528     C                   MOVE      F3SDBS        FHSDBS
144900200528     C                   MOVE      F3SDBE        FHSDBE
145000200528     C                   MOVE      F3BDBF        FHBDBF
145100200528     C                   MOVE      F3SDBF        FHSDBF
145200200528     C                   MOVE      F3BDFA        FHBDFA
145300200528     C                   MOVE      F3SDFA        FHSDFA
145400200528      *
145500200528      ** Portfolio reference
145600200528      *
145700200528     C                   MOVEL     F3PTFR        FHPTFR
145800200528      *
145900200528      ** FX Netting fields
146000200528      *
146100200528     C                   MOVEL     F3NBUY        FHNBUY
146200200528     C                   MOVE      F3NBRF        FHNBRF
146300200528     C                   MOVEL     F3NSEL        FHNSEL
146400200528     C                   MOVE      F3NSRF        FHNSRF
146500200528     C                   MOVEL     F3MTCH        FHMTCH
146600200528      **
146700200528      ** EMU Settlement fields
146800200528      **
146900200528     C                   MOVEL     F3RSCY        FHRSCY
147000200528     C                   MOVEL     F3PSCY        FHPSCY
147100200528     C                   MOVEL     F3IC72        FHIC72
147200200528      *                                                                         CDL008
147300200528      ** Move screen field to file field if feature CDL008                      CDL008
147400200528      ** is installed.                                                          CDL008
147500200528     C                   IF        CDL008 = 'Y'                                 CDL008
147600200528     C                   EVAL      FHCLSS = F3CLSS                              CDL008
147700200528     C                   ENDIF                                                  CDL008
147800200528                                                                                              CAS001
147900200528      ** Yield Curves                                                                         CAS001
148000200528                                                                                              CAS001
148100200528     C                   IF        CAS001 = 'Y'                                               CAS001
148200200528     C/COPY WNCPYSRC,FXH00238
148300200528     C                   EVAL      FHOYLC = F3OYLC                                            CAS001
148400200528     C                   EVAL      FHTYLC = F3TYLC                                            CAS001
148500200528     C                   ENDIF                                                                CAS001
148600200528      *
148700200528      ** Deal date day number
148800200528      *
148900200528     C                   MOVEL     F3DDDN        FHDDDN
149000200528      *                                                                         CAP013
149100200528      ** Front office transaction ID                                            CAP013
149200200528      *                                                                         CAP013
149300200528     C     F3FRNT        IFNE      *BLANKS                                      228662
149400200528     C                   MOVEL     F3FRNT        FHFRNT                         CAP013
149500200528     C                   ENDIF                                                  228662
149600200528      *                                                                         CAP013
149700200528      ** Associated front office transaction ID                                 CAP013
149800200528      *                                                                         CAP013
149900200528     C     F3AFRT        IFNE      *BLANKS                                      228662
150000200528     C                   MOVEL     F3AFRT        FHAFRT                         CAP013
150100200528     C                   ENDIF                                                  228662
150200200528      *                                                                         CAP051
150300200528      ** Automatic Authorisation flag                                           CAP051
150400200528      *                                                                         CAP051
150500200528     C     CAP051        IFEQ      'Y'                                          CAP051
150600200528     C                   MOVEL     F3AUTH        FHAUTH                         CAP051
150700200528     C                   ELSE                                                   CAP051
150800200528     C                   MOVE      *BLANKS       FHAUTH                         CAP051
150900200528     C                   ENDIF                                                  CAP051
151000200528      *                                                                         CAP006
151100200528      ** Timestamp                                                              CAP006
151200200528      *                                                                         CAP006
151300200528     C                   CALLB     'ZAGENTMSTM'                                 CAP006
151400200528     C                   PARM                    TimeStamp                      CAP006
151500200528                                                                                CAP006
151600200528     C                   EVAL      FHTMST  = TimeStamp                          CAP006
151700200528                                                                                CAP006
151800200528      **                                                                        CAP006
151900200528      ** Class                                                                  CDL038
152000200528      *                                                                         CDL038
152100200528     C                   MOVEL     F3CLAS        FHCLAS                         CDL038
152200200528      *                                                                         CDL038
152300200528      **  Reciprocal rate indicator                                                           CER043
152400200528      *                                                                                       CER043
152500200528     C                   IF        CER043 = 'Y'                                               CER043
152600200528     C                   EVAL      FHREIN = F3REIN                                            CER043
152700200528     C                   ENDIF                                                                CER043
152800200528      *                                                                                       CER043
152900200528     C                   ENDSR
153000200528     C*****************************************************************
153100200528      /EJECT
153200200528     C*****************************************************************
153300200528     C*                                                               *
153400200528     C* SETAUT - SET DEAL FIELDS ON AUTHORIZE                         *
153500200528     C*                                                               *
153600200528     C*****************************************************************
153700200528     C     SETAUT        BEGSR
153800200528      *
153900200528      ** UPDATE CONTROL FIELDS
154000200528      *
154100200528     C                   MOVEL     @F3CTL        @FHCTL
154200200528      **
154300200528      ** Deal Status and Change Type
154400200528      **
154500200528     C                   CALLB     'ZAFUTSTATP'
154600200528     C                   PARM      'X'           @@ACTN
154700200528     C                   PARM      FHDSTS        @@CSTS
154800200528     C                   PARM                    BNFXAU
154900200528     C                   PARM                    BNFXRA
155000200528     C                   PARM      *BLANK        @@FSTS
155100200528     C                   PARM      *BLANK        @@CHTP
155200200528     C                   MOVEL     @@FSTS        FHDSTS
155300200528     C                   MOVEL     @@CHTP        FHCHTP
155400200528      **
155500200528      ** Deal last action
155600200528      **
155700200528     C                   MOVEL     'X'           FHLACT
155800200528      **
155900200528      ** Deal authorisation officer
156000200528      **
156100200528     C                   MOVEL     PSUser        FHAOFR
156200200528      **
156300200528      ** Deal action date
156400200528      **
156500200528     C                   Z-ADD     BJRDNB        @DAYN
156600200528     C                   CALLB     'ZDATE9'
156700200528     C                   PARM                    @DAYN
156800200528     C                   PARM                    @YMD
156900200528     C                   PARM                    @RETN
157000200528     C                   Z-ADD     @YMD          FHADAT
157100200528      *                                                                         CAP013
157200200528      ** Front office transaction ID                                            CAP013
157300200528      *                                                                         CAP013
157400200528     C     F3FRNT        IFNE      *BLANKS                                      228662
157500200528     C                   MOVEL     F3FRNT        FHFRNT                         CAP013
157600200528     C                   ENDIF                                                  228662
157700200528      *                                                                         CAP013
157800200528      ** Associated front office transaction ID                                 CAP013
157900200528      *                                                                         CAP013
158000200528     C     F3AFRT        IFNE      *BLANKS                                      228662
158100200528     C                   MOVEL     F3AFRT        FHAFRT                         CAP013
158200200528     C                   ENDIF                                                  228662
158300200528      *                                                                         CAP006
158400200528      ** Timestamp                                                              CAP006
158500200528      *                                                                         CAP006
158600200528     C                   CALLB     'ZAGENTMSTM'                                 CAP006
158700200528     C                   PARM                    TimeStamp                      CAP006
158800200528                                                                                CAP006
158900200528     C                   EVAL      FHTMST  = TimeStamp                          CAP006
159000200528                                                                                CAP006
159100200528      *
159200200528     C                   ENDSR
159300200528     C*****************************************************************
159400200528      /EJECT
159500200528     C*****************************************************************
159600200528     C*                                                               *
159700200528     C* SETDEL - SET DEAL FIELDS ON DELETE                            *
159800200528     C*                                                               *
159900200528     C*****************************************************************
160000200528     C     SETDEL        BEGSR
160100200528      *
160200200528      ** UPDATE CONTROL FIELDS
160300200528      *
160400200528     C                   MOVEL     @F3CTL        @FHCTL
160500200528      *
160600200528      ** FLAG AS 'DELETED'
160700200528      *
160800200528     C                   MOVEL     'D'           FHDDLT
160900200528      **
161000200528      ** Deal Status and Change Type
161100200528      **
161200200528     C                   CALLB     'ZAFUTSTATP'
161300200528     C                   PARM      'D'           @@ACTN
161400200528     C                   PARM      FHDSTS        @@CSTS
161500200528     C                   PARM                    BNFXAU
161600200528     C                   PARM                    BNFXRA
161700200528     C                   PARM      *BLANK        @@FSTS
161800200528     C                   PARM      *BLANK        @@CHTP
161900200528     C                   MOVEL     @@FSTS        FHDSTS
162000200528     C                   MOVEL     @@CHTP        FHCHTP
162100200528      **
162200200528      ** If deal is part of a swap, dealing database updates must ALWAYS
162300200528      ** be done. Although this leg may not be authorized, the other leg
162400200528      ** might be.
162500200528      **
162600200528     C     F3TYPE        IFEQ      'SW'
162700200528     C                   MOVEL     'R'           FHCHTP
162800200528     C                   END
162900200528      **
163000200528      ** Deal last action
163100200528      **
163200200528     C                   MOVEL     'D'           FHLACT
163300200528      *                                                                         CAP013
163400200528      ** Front office transaction ID                                            CAP013
163500200528      *                                                                         CAP013
163600200528     C                   MOVEL     F3FRNT        FHFRNT                         CAP013
163700200528      *                                                                         CAP013
163800200528      ** Associated front office transaction ID                                 CAP013
163900200528      *                                                                         CAP013
164000200528     C                   MOVEL     F3AFRT        FHAFRT                         CAP013
164100200528      *                                                                         CAP006
164200200528      ** Timestamp                                                              CAP006
164300200528      *                                                                         CAP006
164400200528     C                   CALLB     'ZAGENTMSTM'                                 CAP006
164500200528     C                   PARM                    TimeStamp                      CAP006
164600200528                                                                                CAP006
164700200528     C                   EVAL      FHTMST  = TimeStamp                          CAP006
164800200528                                                                                CAP006
164900200528      *
165000200528     C                   ENDSR
165100200528     C*****************************************************************
165200200528      /EJECT
165300200528     C*****************************************************************
165400200528     C*                                                               *
165500200528     C* ALRECI - ALTERNATIVE RECEIVE INSTRUCTIONS                     *
165600200528     C*                                                               *
165700200528     C*****************************************************************
165800200528     C     ALRECI        BEGSR
165900200528      *
166000200528      * EFFECTIVE SETTLEMENT CURRENCY
166100200528      *
166200200528     C     F3RSCY        IFNE      *BLANKS
166300200528     C                   MOVEL     F3RSCY        EffSetCcy
166400200528     C                   ELSE
166500200528     C                   MOVEL     F3CCY1        EffSetCcy         3
166600200528     C                   ENDIF
166700200528      *
166800200528      * DETERMINE ALTERNATIVE RECEIVE INSTRUCTIONS
166900200528      *
167000200528     C                   CALLB     'ZAALTRECIN'
167100200528      ** Customer number                                                                      200400
167200200528     C**********         PARM      F3DCNO        ##CNUM            6 0                 200400 CSD027
167300200528     C                   PARM      F3DCNO        ##CNUM            6                          CSD027
167400200528      ** Rec currency
167500200528     C                   PARM      EffSetCcy     ##RCCY            3
167600200528      ** Rec - settlement method
167700200528     C                   PARM      F3RSTM        ##RSTM            2 0
167800200528      ** Rec - our nostro
167900200528     C**********         PARM      F3RONS        ##RONS           12                          CGL029
168000200528     C                   PARM      F3RONS        ##RONS           18                          CGL029
168100200528      ** rec - intermediary bank
168200200528     C                   PARM      F3RIBN        ##RIBN            8
168300200528      ***MIDAS*Our*Receive*Instructions*(*for*Settlm*Meth*'04'*)*********              179510 200400
168400200528     C************       PARM                    F3MORI                                179510 200400
168500200528      ** midas our receive method
168600200528     C                   PARM                    ##ORCM            2 0
168700200528      ** our receive method
168800200528     C                   PARM                    ##DORM            5
168900200528      ** midas our receive instructions
169000200528     C**********         PARM                    ##MORI           12                          CGL029
169100200528     C                   PARM                    ##MORI           18                          CGL029
169200200528      ** our receive instructions
169300200528     C**********         PARM                    ##DORI           12                          CGL029
169400200528     C                   PARM                    ##DORI           18                          CGL029
169500200528      ** midas customer payment instructions
169600200528     C                   PARM                    ##MCPI           10
169700200528      ** customer payment instructions
169800200528     C                   PARM                    ##DCPI           10
169900200528      *
170000200528     C*
170100200528     C** SETTLEMENT TYPE - MIDAS
170200200528     C*
170300200528     C                   Z-ADD     ##ORCM        F3ORCM
170400200528     C*
170500200528     C** SETTLEMENT TYPE - FRONT OFFICE
170600200528     C*
170700200528     C                   MOVEL     ##DORM        F3DORM
170800200528     C*
170900200528     C** OUR SETTLEMENT ACCOUNT - MIDAS
171000200528     C*
171100200528     C                   MOVEL     ##MORI        F3MORI
171200200528     C*
171300200528     C** OUR SETTLEMENT ACCOUNT - FRONT OFFICE
171400200528     C*
171500200528     C                   MOVEL     ##DORI        F3DORI
171600200528     C*
171700200528     C** CUSTOMER'S COUNTERPARTY NOSTRO - MIDAS
171800200528     C*
171900200528     C                   MOVEL     ##MCPI        F3MCPI
172000200528     C*
172100200528     C** CUSTOMER'S COUNTERPARTY NOSTRO - FRONT OFFICE
172200200528     C*
172300200528     C                   MOVEL     ##DCPI        F3DCPI
172400200528     C*
172500200528     C                   ENDSR
172600200528     C*****************************************************************
172700200528      /EJECT
172800200528     C*****************************************************************
172900200528     C*                                                               *
173000200528     C* ALPAYI - ALTERNATIVE PAYMENT INSTRUCTIONS                     *
173100200528     C*                                                               *
173200200528     C*****************************************************************
173300200528     C     ALPAYI        BEGSR
173400200528      *
173500200528      * EFFECTIVE SETTLEMENT CURRENCY
173600200528      *
173700200528     C     F3PSCY        IFNE      *BLANKS
173800200528     C                   MOVEL     F3PSCY        EffSetCcy
173900200528     C                   ELSE
174000200528     C                   MOVEL     F3CCY2        EffSetCcy         3
174100200528     C                   ENDIF
174200200528      *
174300200528      * DETERMINE ALTERNATIVE PAYMENT INSTRUCTIONS
174400200528      *
174500200528     C                   CALLB     'ZAALTPAYIN'
174600200528      ** Customer number                                                                      200400
174700200528     C**********         PARM      F3DCNO        ##CNUM            6 0                 200400 CSD027
174800200528     C                   PARM      F3DCNO        ##CNUM            6                          CSD027
174900200528      ** Pay currency
175000200528     C                   PARM      EffSetCcy     ##PCCY            3
175100200528      ** Pay - settlement method
175200200528     C                   PARM      F3PSTM        ##PSTM            2 0
175300200528      ** Pay - our nostro
175400200528     C**********         PARM      F3PONS        ##PONS           12                          CGL029
175500200528     C                   PARM      F3PONS        ##PONS           18                          CGL029
175600200528      ** account with bank
175700200528     C                   PARM      F3AWBN        ##AWBN            8
175800200528      ** beneficiary
175900200528     C                   PARM      F3BENN        ##BENN            8
176000200528      ** bank to bank info 1
176100200528     C                   PARM      F3BTB1        ##BTB1           35
176200200528      ***MIDAS*Our Pay  Instructions ( for Settlm Meth '04' )                          179510 200400
176300200528     C************       PARM                    F3MOPI                                179510 200400
176400200528      ** midas our payment method
176500200528     C                   PARM                    ##MOPM            2 0
176600200528      ** our payment method
176700200528     C                   PARM                    ##DOPM            5
176800200528      ** midas our payment instructions
176900200528     C**********         PARM                    ##MOPI           12                          CGL029
177000200528     C                   PARM                    ##MOPI           18                          CGL029
177100200528      ** our payment instructions
177200200528     C**********         PARM                    ##DOPI           12                          CGL029
177300200528     C                   PARM                    ##DOPI           18                          CGL029
177400200528      ** midas customer receive instructions
177500200528     C                   PARM                    ##MCRI           10
177600200528      ** customer receive instructions
177700200528     C                   PARM                    ##DCRI           10
177800200528      ** midas for account of
177900200528     C                   PARM                    ##MFAO           10
178000200528      ** for account of
178100200528     C                   PARM                    ##DFAC           10
178200200528      ** special instructions
178300200528     C                   PARM                    ##SPEC           35
178400200528     C*
178500200528     C** SETTLEMENT TYPE - MIDAS
178600200528     C*
178700200528     C                   MOVEL     ##MOPM        F3MOPM
178800200528     C*
178900200528     C** SETTLEMENT TYPE - FRONT OFFICE
179000200528     C*
179100200528     C                   MOVEL     ##DOPM        F3DOPM
179200200528     C*
179300200528     C** OUR SETTLEMENT ACCOUNT - MIDAS
179400200528     C*
179500200528     C                   MOVEL     ##MOPI        F3MOPI
179600200528     C*
179700200528     C** OUR SETTLEMENT ACCOUNT - FRONT OFFICE
179800200528     C*
179900200528     C                   MOVEL     ##DOPI        F3DOPI
180000200528     C*
180100200528     C** CUSTOMER'S COUNTERPARTY NOSTRO - MIDAS
180200200528     C*
180300200528     C                   MOVEL     ##MCRI        F3MCRI
180400200528     C*
180500200528     C** CUSTOMER'S COUNTERPARTY NOSTRO - FRONT OFFICE
180600200528     C*
180700200528     C                   MOVEL     ##DCRI        F3DCRI
180800200528     C*
180900200528     C** FOR ACCOUNT OF - MIDAS
181000200528     C*
181100200528     C                   MOVEL     ##MFAO        F3MFAO
181200200528     C*
181300200528     C** FOR ACCOUNT OF - FRONT OFFICE
181400200528     C*
181500200528     C                   MOVEL     ##DFAC        F3DFAC
181600200528     C*
181700200528     C**  Special instructions.
181800200528     C*
181900200528     C                   MOVEL     ##SPEC        F3SPEC
182000200528     C*
182100200528     C                   ENDSR
182200200528     C*****************************************************************
182300200528      /EJECT
182400200528     C*****************************************************************
182500200528     C*                                                               *
182600200528     C* SETCTL - SET CONTROL FIELDS                                   *
182700200528     C*                                                               *
182800200528     C*****************************************************************
182900200528     C     SETCTL        BEGSR
183000200528      **
183100200528      ** Record identifier
183200200528      **
183300200528     C                   MOVEL     'FH'          F3RCID
183400200528      **
183500200528      ** Logical delete flag
183600200528      **
183700200528     C                   MOVEL     *BLANK        F3DLTF
183800200528      **
183900200528      ** Day of last update
184000200528      **
184100200528     C                   Z-ADD     @DLUP         F3DLUP
184200200528      **
184300200528      ** Month of last update
184400200528      **
184500200528     C                   MOVEL     @MLUP         F3MLUP
184600200528      **
184700200528      ** Year of last update
184800200528      **
184900200528     C                   Z-ADD     @YLUP         F3YLUP
185000200528      **
185100200528      ** Time of last update
185200200528      **
185300200528     C                   TIME                    F3TLUP
185400200528      **
185500200528      ** Type of last change (set later in this program)
185600200528      **
185700200528     C                   MOVEL     F3CHTP        F3CHTP
185800200528      **
185900200528      ** Last change date
186000200528      **
186100200528     C                   Z-ADD     BJRDNB        F3LCD
186200200528      **
186300200528      ** Last update user id
186400200528      **
186500200528     C                   MOVEL     PSUser        F3LUID
186600200528      **
186700200528     C                   ENDSR
186800200528     C*****************************************************************
186900200528      /EJECT                                                                                  CDL010
187000200528     C****************************************************************                        CDL010
187100200528     C*                                                              *                        CDL010
187200200528     C* USRUPD    - Update the Last Amend/Insert User field .        *                        CDL010
187300200528     C*                                                              *                        CDL010
187400200528     C****************************************************************                        CDL010
187500200528     C     USRUPD        BEGSR                                                                CDL010
187600200528      *                                                                                       CDL010
187700200528      **  Update User Details                                                                 CDL010
187800200528      *                                                                                       CDL010
187900200528     C     F3USER        IFEQ      *BLANKS                                                    CDL010
188000200528     C                   EVAL      FHUSER = PSuser                                            CDL010
188100200528     C                   ELSE                                                                 CDL010
188200200528     C                   EVAL      FHUSER = F3USER                                            CDL010
188300200528     C                   ENDIF                                                                CDL010
188400200528      *                                                                                       CDL010
188500200528     C                   ENDSR                                                                CDL010
188600200528      /EJECT
188700200528     C*****************************************************************         CAP006
188800200528     C*                                                               *         CAP006
188900200528     C* CHKOTHUPD - Check for update by another workstation           *         CAP006
189000200528     C*                                                               *         CAP006
189100200528     C*****************************************************************         CAP006
189200200528     C     CHKOTHUPD     BEGSR                                                  CAP006
189300200528                                                                                CAP006
189400200528      ** Retrieve current deal details                                          CAP006
189500200528                                                                                CAP006
189600200528     C                   MOVE      F3DN38        MidasDlNum        6            CAP006
189700200528                                                                                CAP006
189800200528      ** Determine whether program is running interactively or in batch         CAP006
189900200528      **  ( 0 = batch   1 = interactive)                                        CAP006
190000200528      *                                                                         CAP006
190100200528     C                   CALLB     'ZARTVJOBA'                                  CAP006
190200200528     C                   PARM                    @Return           6            CAP006
190300200528     C                   PARM                    @type             1            CAP006
190400200528      *                                                                         CAP006
190500200528      * Allow access to transaction record by Front-Office ID when in Repair    168345
190600200528      * mode for inserts . Set  *RTV module  parameter @@MODE  to   *FRONT      168345
190700200528      * if the pgm is:  a) running in Interactive mode - @Type= 1   ~~~~~~      168345
190800200528      *                 b) action code is Insert - 'I'                          168345
190900200528      *                 c) Front-Office Id is NOT Blank                         168345
191000200528      *                                                                         168345
191100200528     C     @Type         IFEQ      '1'                                          168345
191200200528     C     F3LACT        ANDEQ     'I'                                          168345
191300200528     C     F3FRNT        ANDNE     *BLANKS                                      168345
191400200528      *                                                                         168345
191500200528     C                   MOVE      '*FRONT'      @@MODE                         168345
191600200528      *                                                                         168345
191700200528     C                   ELSE                                                   168345
191800200528      *                                                                         168345
191900200528      * Otherwise, if running in batch use Front-Office ID                      168345
192000200528      *            (if insert)                                                  CAP013
192100200528      *            else, use Midas Deal Number                                  168345
192200200528      *                                                                         168345
192300200528     C     @Type         IFEQ      '0'                                          CAP006
192400200528     C     F3LACT        ANDEQ     'I'                                          CAP013
192500200528     C                   MOVE      '*FRONT'      @@MODE                         CAP006
192600200528     C                   ELSE                                                   CAP006
192700200528     C                   MOVE      *BLANKS       @@MODE                         CAP006
192800200528     C                   END                                                    CAP006
192900200528      *                                                                         168345
193000200528     C                   END                                                    168345
193100200528                                                                                CAP006
193200200528     C                   CALLB     'FXFXDLRTV'                                  CAP006
193300200528      * INPUTS                                                                  CAP006
193400200528      *                                                                         CAP006
193500200528      * Return code                                                             CAP006
193600200528     C                   PARM      *BLANK        RetCodeOut                     CAP006
193700200528      *                                                                         CAP006
193800200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP006
193900200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP006
194000200528      *                                                                         CAP006
194100200528     C                   PARM                    @@MODE            6            CAP006
194200200528      *                                                                         CAP006
194300200528      * Response mode                                                           CAP006
194400200528     C                   PARM      ' '           @@RSMD            1            CAP006
194500200528      *                                                                         CAP006
194600200528      * Action Code                                                             CAP006
194700200528     C                   PARM                    F3LACT                         CAP006
194800200528      *                                                                         CAP006
194900200528      * Front Office Transaction ID                                             CAP006
195000200528     C                   PARM      F3FRNT        FOTRID           20            CAP006
195100200528      *                                                                         CAP006
195200200528      * Front Office Associated Transaction Id                                  CAP006
195300200528     C                   PARM      F3AFRT        FOASID           20            CAP006
195400200528      *                                                                         CAP006
195500200528      * (Midas) Deal Number                                                     CAP006
195600200528     C                   PARM                    MidasDlNum                     CAP006
195700200528      *                                                                         CAP006
195800200528      * (Midas) Swap/Option Deal Number                                         CAP006
195900200528     C                   PARM                    DDSDNO            6            CAP006
196000200528      *                                                                         CAP006
196100200528      * Booking branch                                                          CAP006
196200200528     C                   PARM      F3DBRC        DDBRSN            3            CAP006
196300200528      *                                                                         CAP006
196400200528      * Originating branch                                                      CAP006
196500200528     C                   PARM      F3ORBR        DDORBR            3            CAP006
196600200528      *                                                                         CAP006
196700200528      * OUTPUTS                                                                 CAP006
196800200528      *                                                                         CAP006
196900200528      * (Current) deal in file format                                           CAP006
197000200528     C                   PARM                    ChkDealFmt                     CAP006
197100200528      *                                                                         CAP006
197200200528      * OK - Action code                                                        CAP006
197300200528     C                   PARM      *BLANK        OKACTN                         CAP006
197400200528      *                                                                         CAP006
197500200528      * OK - Deal Number                                                        CAP006
197600200528     C                   PARM      *BLANK        OKDLNO                         CAP006
197700200528      *                                                                         CAP006
197800200528      * OK - Booking branch                                                     CAP006
197900200528     C                   PARM      *BLANK        OKBRSN                         CAP006
198000200528      *                                                                         CAP006
198100200528      * OK - Originating branch                                                 CAP006
198200200528     C                   PARM                    OKORBR                         CAP006
198300200528      *                                                                         CAP006
198400200528      * Error fields/message IDs/message data (arrays) from/to caller           CAP006
198500200528     C                   PARM      *BLANK        FldNameArr                     CAP006
198600200528     C                   PARM      *BLANK        MsgIdArr                       CAP006
198700200528     C                   PARM      *BLANK        MsgDtaArr                      CAP006
198800200528      *                                                                         CAP006
198900200528      * Array index (3P0) from/to caller                                        CAP006
199000200528     C                   PARM      *ZERO         Idx               3 0          CAP006
199100200528                                                                                              CAS004
199200200528      ** Warning error fields/message IDs/message data (arrays) from/to caller                CAS004
199300200528                                                                                              CAS004
199400200528     C                   PARM      *BLANKS       WFldNamArr                                   CAS004
199500200528     C                   PARM      *BLANKS       WMsgIdArr                                    CAS004
199600200528     C                   PARM      *BLANKS       WMsgDtaArr                                   CAS004
199700200528                                                                                              CAS004
199800200528      ** Warning array index (3P0) from/to caller                                             CAS004
199900200528                                                                                              CAS004
200000200528     C                   PARM      *ZEROS        WIdx                                         CAS004
200100200528                                                                                              CAS004
200200200528     C/COPY WNCPYSRC,FXFXDLFC10
200300200528      *                                                                         CAP006
200400200528      *                                                                         CAP006
200500200528      ** Error if Timestamp is not the same (record has been changed            CAP006
200600200528      **  by another workstation)                                               CAP006
200700200528                                                                                CAP006
200800200528      ** Processing varies according to mode program is running in.             CAP006
200900200528      ** In interacive mode simply check whether the timestamp field            CAP006
201000200528      ** has been updated since the original deal was fetched by this           CAP006
201100200528      ** program.                                                               CAP006
201200200528      ** In batch (API input) check return parameters from Retrieve             CAP006
201300200528      ** module for errors, and send message to system operator.                CAP006
201400200528                                                                                CAP006
201500200528      ** Interactive mode:                                                      CAP006
201600200528                                                                                CAP006
201700200528     C     @TYPE         IFEQ      '1'                                          CAP006
201800200528                                                                                CAP006
201900200528     C     CHFHTMST      IFNE      F3TMESTMP                                    CAP006
202000200528     C     F3LACT        ANDNE     'I'                                          184720
202100200528     C*****F3LACT        ANDNE     'D'                                               247266 BUG27841
202200200528     C*****F3LACT        ANDNE     'X'                                               247266 BUG27841
202300200528     C                   MOVEL     '*RECUPD'     @@RTCD                         CAP006
202400200528     C                   END                                                    CAP006
202500200528                                                                                CAP006
202600200528      ** Batch mode:                                                            CAP006
202700200528     C                   ELSE                                                   CAP006
202800200528     C     OKACTN        IFEQ      'N'                                          CAP006
202900200528     C     OKDLNO        OREQ      'N'                                          CAP006
203000200528     C                   MOVEL     '*RECUPD'     @@RTCD                         CAP006
203100200528     C                   Z-ADD     1             C                 2 0          CAP006
203200200528                                                                                CAP006
203300200528     C     C             DOWLE     ArrayMax                                     CAP006
203400200528     C     FldNameArr(C) ANDNE     *BLANKS                                      CAP006
203500200528     C*******************MOVEL     *BLANKS       DBError          28     CAP006 CAP013
203600200528     C*******************MOVEL     MsgIDArr(C)   DBError                 CAP006 CAP013
203700200528     C                   CLEAR                   DBError         132            CAP013
203800200528     C                   EVAL      DBerror = 'Update error: ' + FOTRID          CAP013
203900200528     C                   CALLB     'ZAMSGTOOPR'                                 CAP006
204000200528     C                   PARM                    MsgSndRtn        10            CAP006
204100200528     C                   PARM                    DBError                        CAP006
204200200528     C                   PARM                    DummyMsgID                     CAP006
204300200528     C                   PARM                    DummyMsgF                      CAP006
204400200528     C                   ADD       1             C                              CAP006
204500200528     C                   END                                                    CAP006
204600200528      *                                                                                       231306
204700200528      **  Produce DUMP if error on validation found for easier analysis                       231306
204800200528      *                                                                                       231306
204900200528     C                   MOVEL     MidasDlNum    DBKEY                                        231306
205000200528     C                   MOVEL     'FXDEALP0'    DBFILE                                       231306
205100200528     C                   MOVEL     '016'         DBASE                                        231306
205200200528     C                   DUMP                                                                 231306
205300200528                                                                                CAP006
205400200528     C                   END                                                    CAP006
205500200528                                                                                CAP006
205600200528     C                   END                                                    CAP006
205700200528                                                                                CAP006
205800200528     C                   ENDSR                                                  CAP006
205900200528     C*****************************************************************         CAP006
206000200528      /EJECT                                                                    CAP006
206100200528     C*****************************************************************
206200200528     C*                                                               *
206300200528     C* ONLNUP - ON-LINE UPDATES (MEMOS, PRONO, OLPOS, RSACMTPD)      *
206400200528     C*                                                               *
206500200528     C*****************************************************************
206600200528     C     ONLNUP        BEGSR
206700200528      *
206800200528     C/COPY WNCPYSRC,FXH00192
206900200528     C                   CALL      'AOOUFXU0'
207000200528     C                   PARM      *BLANK        @RTCD
207100200528     C                   PARM                    Z#BSTS
207200200528     C                   PARM                    Z#ASTS
207300200528     C                   PARM                    Z#WSTS
207400200528     C                   PARM                    Z#XSTS                         154448
207500200528     C/COPY WNCPYSRC,FXH00216
207600200528     C     @RTCD         IFEQ      '*ERROR*'
207700200528     C                   MOVEL     *BLANK        DBKEY
207800200528     C                   MOVEL     'AOOUFXU0'    DBFILE
207900200528     C                   MOVEL     '991'         DBASE
208000200528     C                   EXSR      SRERR
208100200528     C                   END
208200200528     C/COPY WNCPYSRC,FXFXDLFC12
208300200528      *                                                                         CDE001
208400200528      ** Data export for CCRM - Limits                                          CDE001
208500200528     C                   IF        CDE001 = 'Y'                                 CDE001
208600200528     C                   MOVEL     F3DN38        T#TREF                         CDE001
208700200528     C                   CALLB     'DEWRTTRIG'                                  CDE001
208800200528     C**********         PARM                    T#TREF           20                   CDE001 CGL029
208900200528     C                   PARM                    T#TREF                                       CGL029
209000200528     C                   PARM      'FXDL'        T#TCAT            4            CDE001
209100200528     C                   PARM      *BLANKS       T#RSRV           10            CDE005
209200200528     C                   ENDIF                                                  CDE001
209300200528     C/COPY WNCPYSRC,FXH00193
209400200528                                                                                              CRE020
209500200528      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
209600200528                                                                                              CRE020
209700200528     C                   IF        F3LACT = 'A' OR                                            CRE020
209800200528     C                             F3LACT = 'D'                                               CRE020
209900200528     C                   IF        CRE020 = 'Y' AND                                           CRE020
210000200528     C                             WSysVal01 = 'Y'                                            CRE020
210100200528     C                   EXSR      SRIdxTrn                                                   CRE020
210200200528     C                   ENDIF                                                                CRE020
210300200528     C                   ENDIF                                                                CRE020
210400200528      *                                                                                       231306
210500200528     C     @RTCD         IFEQ      '*RECLCK'                                                  231306
210600200528     C                   EXSR      SRERR                                                      231306
210700200528     C                   ENDIF                                                                231306
210800200528      *
210900200528     C                   ENDSR
211000200528     C*****************************************************************
211100200528      /EJECT
211200200528     C*****************************************************************
211300200528     C*                                                               *
211400200528     C* TREAUP - TREASURY MANAGEMENT UPDATES                          *
211500200528     C*                                                               *
211600200528     C*****************************************************************
211700200528     C     TREAUP        BEGSR
211800200528      *
211900200528     C*******************CALL      'FXFXDLUPT'                                  136434
212000200528     C                   CALLB     'FXFXDLUPT'                                  136434
212100200528     C                   PARM      *BLANK        @RTCD
212200200528     C                   PARM      F3LACT        @LACT             1
212300200528     C                   PARM                    Z#BSTS
212400200528     C                   PARM                    Z#ASTS
212500200528     C                   PARM                    Z#WSTS                         136434
212600200528     C     @RTCD         IFEQ      '*ERROR '
212700200528     C                   MOVEL     *BLANK        DBKEY
212800200528     C                   MOVEL     'FXFXDLUPT'   DBFILE
212900200528     C                   MOVEL     '992'         DBASE
213000200528     C                   EXSR      SRERR
213100200528     C                   END
213200200528      *
213300200528     C                   ENDSR
213400200528      *****************************************************************                       CRE020
213500200528      /EJECT                                                                                  CRE020
213600200528      *****************************************************************                       CRE020
213700200528      *                                                               *                       CRE020
213800200528      *  SRIdxTrn - Handles the advice index of the current           *                       CRE020
213900200528      *             transaction.                                      *                       CRE020
214000200528      *                                                               *                       CRE020
214100200528      *****************************************************************                       CRE020
214200200528     C     SRIdxTrn      BEGSR                                                                CRE020
214300200528                                                                                              CRE020
214400200528      ** Initialise key values.                                                               CRE020
214500200528                                                                                              CRE020
214600200528     C                   EVAL      KRefNo = *BLANKS                                           CRE020
214700200528     C                   MOVEL     FHDN38        KRefNo                                       CRE020
214800200528                                                                                              CRE020
214900200528      ** Begin advice index processing.                                                       CRE020
215000200528                                                                                              CRE020
215100200528     C                   OPEN      READVCL1                                                   CRE020
215200200528                                                                                              CRE020
215300200528     C     KADVC         SETLL     READVCL1                                                   CRE020
215400200528     C     KADVC         READE     READVCL1                                                   CRE020
215500200528                                                                                              CRE020
215600200528     C                   DOW       NOT %EOF                                                   CRE020
215700200528                                                                                              CRE020
215800200528      ** Execute amend processing if necessary.                                               CRE020
215900200528                                                                                              CRE020
216000200528     C                   IF        RAUTHI = 'Y' AND                                           CRE020
216100200528     C                             RSAPIN = 'N'                                               CRE020
216200200528     C                   MOVE      'N'           RAUTHI                                       CRE020
216300200528     C                   UPDATE    READVCD0                                                   CRE020
216400200528     C                   ENDIF                                                                CRE020
216500200528                                                                                              CRE020
216600200528      ** Execute reversal processing if necessary.                                            CRE020
216700200528                                                                                              CRE020
216800200528     C                   IF        RAUTHI = 'N' AND                                           CRE020
216900200528     C                             RSAPIN = ' ' AND                                           CRE020
217000200528     C                             FHLACT = 'D'                                               CRE020
217100200528     C                   EVAL      RCHTYP = 'R'                                               CRE020
217200200528     C                   EVAL      RAUTHI = 'Y'                                               CRE020
217300200528     C                   EVAL      RSAPIN = 'Y'                                               CRE020
217400200528     C                   UPDATE    READVCD0                                                   CRE020
217500200528     C                   ENDIF                                                                CRE020
217600200528                                                                                              CRE020
217700200528     C     KADVC         READE     READVCL1                                                   CRE020
217800200528     C                   ENDDO                                                                CRE020
217900200528                                                                                              CRE020
218000200528     C                   CLOSE     READVCL1                                                   CRE020
218100200528                                                                                              CRE020
218200200528     C                   ENDSR                                                                CRE020
218300200528      *****************************************************************
218400200528      /EJECT
218500200528      *****************************************************************
218600200528      *                                                               *
218700200528      * *INZSR - Program Initialisation routine                       *
218800200528      *                                                               *
218900200528      * Called by: Main processing                                    *
219000200528      *                                                               *
219100200528      * Calls: None                                                   *
219200200528      *                                                               *
219300200528      *****************************************************************
219400200528     C     *INZSR        BEGSR
219500200528      *
219600200528      ** PARAMETERS
219700200528      *
219800200528     C     *ENTRY        PLIST
219900200528     C                   PARM                    @@RTCD            7
220000200528     C                   PARM                    FXVFXD
220100200528     C/COPY WNCPYSRC,FXFXDLFC14
220200200528     C*
220300200528     C** ACCESS BANK DETAILS
220400200528     C*
220500200528     C                   CALLB     'AOBANKR0'
220600200528     C                   PARM      '*MSG    '    @RTCD             7
220700200528     C                   PARM      '*FIRST  '    @OPTN             7
220800200528     C     SDBANK        PARM      SDBANK        DSFDY
220900200528     C*
221000200528     C* DATABASE ERROR
221100200528     C*
221200200528     C     @RTCD         IFNE      *BLANK
221300200528     C                   MOVEL     @OPTN         DBKEY
221400200528     C                   MOVEL     'SDBANKPD'    DBFILE
221500200528     C                   MOVEL     '900'         DBASE
221600200528     C                   EXSR      SRERR
221700200528     C                   END
221800200528     C*
221900200528     C*  ACCESS DEAL DATA
222000200528     C*
222100200528     C**********         CALLB     'AODEALR0'                                                 CGL029
222200200528     C                   CALLB     'AODEALR1'                                                 CGL029
222300200528     C                   PARM      '*MSG    '    @RTCD
222400200528     C                   PARM      '*FIRST  '    @OPTN
222500200528     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
222600200528     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
222700200528     C*
222800200528     C* DATABASE ERROR
222900200528     C*
223000200528     C     @RTCD         IFNE      *BLANK
223100200528     C                   MOVEL     @OPTN         DBKEY
223200200528     C                   MOVEL     'SDDEALPD'    DBFILE
223300200528     C                   MOVEL     '901'         DBASE
223400200528     C                   EXSR      SRERR
223500200528     C                   END
223600200528      *                                                                         CAP051
223700200528      *  Check if feature CAP051 is switched on                                 CAP051
223800200528      *                                                                         CAP051
223900200528     C                   MOVE      'N'           CAP051            1            CAP051
224000200528     C                   CALLB     'AOSARDR0'                                   CAP051
224100200528     C                   PARM      *BLANKS       @RTCD                          CAP051
224200200528     C                   PARM      '*VERIFY '    @OPTN                          CAP051
224300200528     C                   PARM      'CAP051'      @SAR              6            CAP051
224400200528     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
224500200528      *                                                                         CAP051
224600200528     C     @RTCD         IFEQ      *BLANK                                       CAP051
224700200528     C                   MOVE      'Y'           CAP051                         CAP051
224800200528     C                   ENDIF                                                  CAP051
224900200528      *                                                                         CAP051
225000200528     C                   MOVE      BNFXAU        SAVFXAU           1            CAP051
225100200528     C                   MOVE      BNFXRA        SAVFXRA           1            CAP051
225200200528      *                                                                         CDL008
225300200528      ** Access SAR details file to determine if CDL008 is on.                  CDL008
225400200528      ** (Continuous Linked Settlement)                                         CDL008
225500200528      *                                                                         CDL008
225600200528     C                   CALLB     'AOSARDR0'                                   CDL008
225700200528     C                   PARM      *BLANKS       @RTCD                          CDL008
225800200528     C                   PARM      '*VERIFY'     @OPTN                          CDL008
225900200528     C                   PARM      'CDL008'      @SAR                           CDL008
226000200528     C     SCSARD        PARM      SCSARD        DSFDY                          CDL008
226100200528     C     @RTCD         IFNE      *BLANKS                                      CDL008
226200200528     C     @RTCD         ANDNE     '*NRF   '                                    CDL008
226300200528     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL008
226400200528     C                   MOVEL     '903'         DBASE                          CDL008
226500200528     C                   MOVEL     'CDL008'      DBKEY                          CDL008
226600200528     C                   EXSR      SRERR                                        CDL008
226700200528     C                   ENDIF                                                  CDL008
226800200528     C     @RTCD         IFEQ      *BLANKS                                      CDL008
226900200528     C                   MOVEL     'Y'           CDL008            1            CDL008
227000200528     C                   ELSE                                                   CDL008
227100200528     C                   MOVEL     'N'           CDL008                         CDL008
227200200528     C                   ENDIF                                                  CDL008
227300200528                                                                                              CAS001
227400200528      ** Access SAR details file to determine if CAS001 is on.                                CAS001
227500200528      ** (Net Present Value Accounting)                                                       CAS001
227600200528                                                                                              CAS001
227700200528     C                   CALLB     'AOSARDR0'                                                 CAS001
227800200528     C                   PARM      *BLANKS       PRTCD                                        CAS001
227900200528     C                   PARM      '*VERIFY'     POPTN                                        CAS001
228000200528     C                   PARM      'CAS001'      PSARD                                        CAS001
228100200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
228200200528                                                                                              CAS001
228300200528     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
228400200528     C                             PRTCD <> '*NRF   '                                         CAS001
228500200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS001
228600200528     C                   EVAL      DBASE = 904                                                CAS001
228700200528     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
228800200528     C                   EXSR      SRERR                                                      CAS001
228900200528     C                   ENDIF                                                                CAS001
229000200528                                                                                              CAS001
229100200528     C                   IF        PRTCD = *BLANKS                                            CAS001
229200200528     C                   EVAL      CAS001 = 'Y'                                               CAS001
229300200528     C                   ELSE                                                                 CAS001
229400200528     C                   EVAL      CAS001 = 'N'                                               CAS001
229500200528     C                   ENDIF                                                                CAS001
229600200528     C/COPY WNCPYSRC,FXH00239
229700200528     C*
229800200528     C** ACCESS MIDAS MODULE DETAILS
229900200528     C*
230000200528     C                   CALLB     'AOMMODR0'
230100200528     C                   PARM      '*MSG    '    @RTCD
230200200528     C                   PARM      '*FIRST  '    @OPTN
230300200528     C     SDMMOD        PARM      SDMMOD        DSFDY
230400200528     C*
230500200528     C* DATABASE ERROR
230600200528     C*
230700200528     C     @RTCD         IFNE      *BLANK
230800200528     C                   MOVEL     @OPTN         DBKEY
230900200528     C                   MOVEL     'SDMMODPD'    DBFILE
231000200528     C                   MOVEL     '902'         DBASE
231100200528     C                   EXSR      SRERR
231200200528     C                   END
231300200528      *                                                                         CDE001
231400200528      ** Determine if Data Export for CCRM Limits is active                     CDE001
231500200528     C                   CALL      'AOSARDR0'                                   CDE001
231600200528     C                   PARM      *BLANKS       @RTCD                          CDE001
231700200528     C                   PARM      '*VERIFY'     @OPTN                          CDE001
231800200528     C                   PARM      'CDE001'      @SARD             6            CDE001
231900200528      *                                                                         CDE001
232000200528     C     @RTCD         IFEQ      *BLANK                                       CDE001
232100200528     C                   MOVEL     'Y'           CDE001            1            CDE001
232200200528     C                   ENDIF                                                  CDE001
232300200528     C*
232400200528      ** Check if CSC011 is installed                                                         CSC011
232500200528                                                                                              CSC011
232600200528     C                   CALLB     'AOSARDR0'                                                 CSC011
232700200528     C                   PARM      *BLANKS       PRtCd                                        CSC011
232800200528     C                   PARM      '*VERIFY'     POptn                                        CSC011
232900200528     C                   PARM      'CSC011'      PSard                                        CSC011
233000200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
233100200528                                                                                              CSC011
233200200528     C                   IF        PRtCd = *Blanks                                            CSC011
233300200528     C                   EVAL      CSC011 = 'Y'                                               CSC011
233400200528     C                   IN        SC24X7                                                     CSC011
233500200528     C**********         IN        SDSTAT                                              CSC011 CSD015
233600200528     C                   ELSE                                                                 CSC011
233700200528     C                   EVAL      CSC011 = 'N'                                               CSC011
233800200528     C                   ENDIF                                                                CSC011
233900200528                                                                                              CSC011
234000200528     C                   IF        (PRtCd <> '*NRF') and                                      CSC011
234100200528     C                             (PRtCd <> *Blanks)                                         CSC011
234200200528     C     *LOCK         IN        LDA                                                        CSC011
234300200528     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
234400200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
234500200528     C                   EVAL      DBASE = 904                                                CSC011
234600200528     C                   OUT       LDA                                                        CSC011
234700200528     C                   EXSR      SRERR                                                      CSC011
234800200528     C                   ENDIF                                                                CSC011
234900200528      *************                                                                  CAP084  BUG5517
235000200528     C******DTAARA*      DEFINE                  ZMUSER                              CAP084  BUG5517
235100200528     C*************      IN        ZMUSER                                            CAP084  BUG5517
235200200528     C*************      EVAL      PSUser = PUSRID                                   CAP084  BUG5517
235300200528                                                                                              CAP084
235400200528                                                                                              CSD015
235500200528     C                   IN        SDSTAT                                                     CSD015
235600200528                                                                                              CSC011
235700200528      ** Check if Compliance Watch Enhancment (CSD015) is on.                                 CSD015
235800200528                                                                                              CSD015
235900200528     C                   EVAL      CSD015 = 'N'                                               CSD015
236000200528                                                                                              CSD015
236100200528     C                   CALLB     'AOSARDR0'                                                 CSD015
236200200528     C                   PARM      *BLANKS       PRetCode                                     CSD015
236300200528     C                   PARM      '*VERIFY'     POption                                      CSD015
236400200528     C                   PARM      'CSD015'      PSard                                        CSD015
236500200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
236600200528                                                                                              CSD015
236700200528      ** Database error                                                                       CSD015
236800200528                                                                                              CSD015
236900200528     C                   IF        (PRetCode <> *BLANKS) and                                  CSD015
237000200528     C                             (PRetCode <> '*NRF   ')                                    CSD015
237100200528     C     *LOCK         IN        LDA                                                        CSD015
237200200528     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
237300200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
237400200528     C                   EVAL      DBASE = 907                                                CSD015
237500200528     C                   OUT       LDA                                                        CSD015
237600200528     C                   EXSR      SRERR                                                      CSD015
237700200528     C                   ENDIF                                                                CSD015
237800200528                                                                                              CSD015
237900200528     C                   IF        PRetCode = *BLANKS                                         CSD015
238000200528     C                   EVAL      CSD015 = 'Y'                                               CSD015
238100200528                                                                                              CSD015
238200200528     C                   CALLB     'AOCWCDR0'                                                 CSD015
238300200528     C                   PARM      *BLANKS       PRetCode                                     CSD015
238400200528     C                   PARM      '*FIRST'      POption                                      CSD015
238500200528     C     SDCWCD        PARM      SDCWCD        DSSDY                                        CSD015
238600200528                                                                                              CSD015
238700200528     C                   IF        PRetCode <> *BLANKS                                        CSD015
238800200528     C     *LOCK         IN        LDA                                                        CSD015
238900200528     C                   EVAL      DBKEY = POption                                            CSD015
239000200528     C                   EVAL      DBFILE = 'SDCWCDPD'                                        CSD015
239100200528     C                   EVAL      DBASE = 909                                                CSD015
239200200528     C                   OUT       LDA                                                        CSD015
239300200528     C                   EXSR      SRERR                                                      CSD015
239400200528     C                   END                                                                  CSD015
239500200528                                                                                              CSD015
239600200528      ** Access Compliance Watch Transaction details                                          CSD015
239700200528                                                                                              CSD015
239800200528     C                   CALLB     'AOWLCCR0'                                                 CSD015
239900200528     C                   PARM      *BLANKS       PRetCode                                     CSD015
240000200528     C                   PARM      '*KEY    '    POption                                      CSD015
240100200528     C                   PARM      'DEALING '    PFunc                                        CSD015
240200200528     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
240300200528                                                                                              CSD015
240400200528      ** Database Error                                                                       CSD015
240500200528                                                                                              CSD015
240600200528     C                   IF        PRetCode <> *BLANKS                                        CSD015
240700200528     C                             AND PRetCode <> '*NRF'                                     CSD015
240800200528     C     *LOCK         IN        LDA                                                        CSD015
240900200528     C                   EVAL      DBKEY = PFunc                                              CSD015
241000200528     C                   EVAL      DBFILE = 'SDWLCCPD'                                        CSD015
241100200528     C                   EVAL      DBASE = 908                                                CSD015
241200200528     C                   OUT       LDA                                                        CSD015
241300200528     C                   EXSR      SRERR                                                      CSD015
241400200528     C                   ENDIF                                                                CSD015
241500200528                                                                                              CSD015
241600200528     C                   ENDIF                                                                CSD015
241700200528                                                                                              CSD015
241800200528     C                   EVAL      CCF001 = 'N'                                               CSD015
241900200528                                                                                              CSD015
242000200528     C                   CALLB     'AOSARDR0'                                                 CSD015
242100200528     C                   PARM      *BLANKS       PRetCode                                     CSD015
242200200528     C                   PARM      '*VERIFY'     POption                                      CSD015
242300200528     C                   PARM      'CCF001'      PSard                                        CSD015
242400200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
242500200528                                                                                              CSD015
242600200528      ** Database error                                                                       CSD015
242700200528                                                                                              CSD015
242800200528     C                   IF        (PRetCode <> *BLANKS) and                                  CSD015
242900200528     C                             (PRetCode <> '*NRF   ')                                    CSD015
243000200528     C     *LOCK         IN        LDA                                                        CSD015
243100200528     C                   EVAL      DBKEY = 'CCF001'                                           CSD015
243200200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
243300200528     C                   EVAL      DBASE = 910                                                CSD015
243400200528     C                   OUT       LDA                                                        CSD015
243500200528     C                   EXSR      SRERR                                                      CSD015
243600200528     C                   ENDIF                                                                CSD015
243700200528                                                                                              CSD015
243800200528     C                   IF        PRetCode = *BLANKS                                         CSD015
243900200528     C                   EVAL      CCF001 = 'Y'                                               CSD015
244000200528     C                   EndIf                                                                CSD015
244100200528                                                                                              CSD015
244200200528     C     KCwFld        KLIST                                                                CSD015
244300200528     C                   KFLD                    WFuncType                                    CSD015
244400200528     C                   KFLD                    WIdntifier                                   CSD015
244500200528     C                   KFLD                    WBranch                                      CSD015
244600200528                                                                                              CSD015
244700200528      ** Midas RE Settled Transaction Index File Key List                                     CRE020
244800200528                                                                                              CRE020
244900200528     C     KADVC         KLIST                                                                CRE020
245000200528     C                   KFLD                    KRefNo                                       CRE020
245100200528     C                   KFLD                    KPrgMn                                       CRE020
245200200528                                                                                              CRE020
245300200528     C**  READ DTAARA/RUNDAT to access MULTI-BRANCHING flag.
245400200528     C*
245500200528      ** Access SAR details file to determine if CDL010 is on.                                CDL010
245600200528      ** (Dealing Transaction Authorisation)                                                  CDL010
245700200528                                                                                              CDL010
245800200528     C                   CALLB     'AOSARDR0'                                                 CDL010
245900200528     C                   PARM      *BLANKS       PRTCD                                        CDL010
246000200528     C                   PARM      '*VERIFY'     POPTN                                        CDL010
246100200528     C                   PARM      'CDL010'      PSARD                                        CDL010
246200200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL010
246300200528     C                   IF        PRTCD <> *BLANKS AND                                       CDL010
246400200528     C                             PRTCD <> '*NRF   '                                         CDL010
246500200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL010
246600200528     C                   EVAL      DBASE = 905                                                CDL010
246700200528     C                   EVAL      DBKEY = 'CDL010'                                           CDL010
246800200528     C                   EXSR      SRERR                                                      CDL010
246900200528     C                   ENDIF                                                                CDL010
247000200528     C                   IF        PRTCD = *BLANKS                                            CDL010
247100200528     C                   EVAL      CDL010 = 'Y'                                               CDL010
247200200528     C                   ELSE                                                                 CDL010
247300200528     C                   EVAL      CDL010 = 'N'                                               CDL010
247400200528     C                   ENDIF                                                                CDL010
247500200528                                                                                              CDL010
247600200528      ** Check if CRE020 is enabled.                                                          CRE020
247700200528                                                                                              CRE020
247800200528     C                   CALLB     'AOSARDR0'                                                 CRE020
247900200528     C                   PARM      *BLANKS       PRtCd                                        CRE020
248000200528     C                   PARM      '*VERIFY'     POptn                                        CRE020
248100200528     C                   PARM      'CRE020'      PSARD                                        CRE020
248200200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
248300200528                                                                                              CRE020
248400200528     C                   EVAL      CRE020 = 'N'                                               CRE020
248500200528                                                                                              CRE020
248600200528     C                   IF        PRtCd = *BLANKS                                            CRE020
248700200528     C                   EVAL      CRE020 = 'Y'                                               CRE020
248800200528     C                   ELSE                                                                 CRE020
248900200528                                                                                              CRE020
249000200528     C                   IF        PRtCd <> '*NRF'                                            CRE020
249100200528     C     *LOCK         IN        LDA                                                        CRE020
249200200528     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
249300200528     C                   EVAL      DBase = 906                                                CRE020
249400200528     C                   EVAL      DBKey = 'CRE020'                                           CRE020
249500200528     C                   OUT       LDA                                                        CRE020
249600200528     C                   EXSR      SRErr                                                      CRE020
249700200528     C                   ENDIF                                                                CRE020
249800200528                                                                                              CRE020
249900200528     C                   ENDIF                                                                CRE020
250000200528                                                                                              CRE020
250100200528      ** Check if a System Value exists for this maintenance.                                 CRE020
250200200528                                                                                              CRE020
250300200528     C                   IF        CRE020 = 'Y'                                               CRE020
250400200528                                                                                              CRE020
250500200528     C                   CALLB     'AOSVALR0'                                                 CRE020
250600200528     C                   PARM      *BLANKS       PRtCd                                        CRE020
250700200528     C                   PARM                    PSysVal01                                    CRE020
250800200528     C                   PARM                    PCurSet01                                    CRE020
250900200528     C                   PARM                    PSysVal02                                    CRE020
251000200528     C                   PARM                    PCurSet02                                    CRE020
251100200528     C                   PARM                    PSysVal03                                    CRE020
251200200528     C                   PARM                    PCurSet03                                    CRE020
251300200528     C                   PARM                    PSysVal04                                    CRE020
251400200528     C                   PARM                    PCurSet04                                    CRE020
251500200528     C                   PARM                    PSysVal05                                    CRE020
251600200528     C                   PARM                    PCurSet05                                    CRE020
251700200528     C                   PARM                    PSysVal06                                    CRE020
251800200528     C                   PARM                    PCurSet06                                    CRE020
251900200528     C                   PARM                    PSysVal07                                    CRE020
252000200528     C                   PARM                    PCurSet07                                    CRE020
252100200528     C                   PARM                    PSysVal08                                    CRE020
252200200528     C                   PARM                    PCurSet08                                    CRE020
252300200528     C                   PARM                    PSysVal09                                    CRE020
252400200528     C                   PARM                    PCurSet09                                    CRE020
252500200528     C                   PARM                    PSysVal10                                    CRE020
252600200528     C                   PARM                    PCurSet10                                    CRE020
252700200528                                                                                              CRE020
252800200528     C                   EVAL      WSysVal01 = 'N'                                            CRE020
252900200528                                                                                              CRE020
253000200528     C                   IF        PRtCd = *BLANKS                                            CRE020
253100200528     C                   MOVEL     PCurSet01     WSysVal01                                    CRE020
253200200528     C                   ELSE                                                                 CRE020
253300200528                                                                                              CRE020
253400200528     C                   IF        PRtCd <> '*NRF'                                            CRE020
253500200528     C     *LOCK         IN        LDA                                                        CRE020
253600200528     C                   EVAL      DBFile = 'SDSVALPD'                                        CRE020
253700200528     C                   EVAL      DBase = 907                                                CRE020
253800200528     C                   EVAL      DBKey = PSysVal01                                          CRE020
253900200528     C                   OUT       LDA                                                        CRE020
254000200528     C                   EXSR      SRErr                                                      CRE020
254100200528     C                   ENDIF                                                                CRE020
254200200528                                                                                              CRE020
254300200528     C                   ENDIF                                                                CRE020
254400200528                                                                                              CRE020
254500200528     C                   ENDIF                                                                CRE020
254600200528                                                                                              CRE020
254700200528      ** Check if Watch List Element (CSD083) is on                                           CSD083
254800200528                                                                                              CSD083
254900200528     C                   CALLB     'AOSARDR0'                                                 CSD083
255000200528     C                   PARM      *BLANKS       PRtCd                                        CSD083
255100200528     C                   PARM      '*VERIFY'     POptn                                        CSD083
255200200528     C                   PARM      'CSD083'      PSARD                                        CSD083
255300200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
255400200528                                                                                              CSD083
255500200528     C                   IF        PRtCd <> *BLANKS AND                                       CSD083
255600200528     C                             PRtCd <> '*NRF'                                            CSD083
255700200528     C     *LOCK         IN        LDA                                                        CSD083
255800200528     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
255900200528     C                   EVAL      DBase = 912                                                CSD083
256000200528     C                   EVAL      DBKey = 'CSD083'                                           CSD083
256100200528     C                   OUT       LDA                                                        CSD083
256200200528     C                   EXSR      SRErr                                                      CSD083
256300200528     C                   ENDIF                                                                CSD083
256400200528                                                                                              CSD083
256500200528     C                   IF        PRtCd = *BLANKS                                            CSD083
256600200528     C                   EVAL      CSD015 = 'N'                                               CSD083
256700200528     C                   ENDIF                                                                CSD083
256800200528      *                                                                                       CER043
256900200528      ** Call AOSARDR0 to check if CER043 is switched on                                      CER043
257000200528      *                                                                                       CER043
257100200528     C                   EVAL      CER043 = 'N'                                               CER043
257200200528     C                   CALLB     'AOSARDR0'                                                 CER043
257300200528     C                   PARM      *BLANKS       PRTCD                                        CER043
257400200528     C                   PARM      '*VERIFY'     POPTN                                        CER043
257500200528     C                   PARM      'CER043'      PSARD                                        CER043
257600200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
257700200528                                                                                              CER043
257800200528     C                   IF        PRTCD <> *BLANKS AND                                       CER043
257900200528     C                             PRTCD <> '*NRF   '                                         CER043
258000200528     C     *LOCK         IN        LDA                                                        CER043
258100200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
258200200528     C                   EVAL      DBASE = 912                                                CER043
258300200528     C                   EVAL      DBKEY = 'CER043'                                           CER043
258400200528     C                   OUT       LDA                                                        CER043
258500200528     C                   EXSR      SRERR                                                      CER043
258600200528     C                   ENDIF                                                                CER043
258700200528                                                                                              CER043
258800200528     C                   IF        PRTCD = *BLANKS                                            CER043
258900200528     C                   EVAL      CER043 = 'Y'                                               CER043
259000200528     C                   ENDIF                                                                CER043
259100200528     C/COPY WNCPYSRC,FXH00077
259200200528                                                                                              CER043
259300200528      *                                                                                       CSW212
259400200528      ** Check if SWIFT 2012 is on                                                            CSW212
259500200528      *                                                                                       CSW212
259600200528     C                   MOVEL     *BLANKS       CSW212            1                          CSW212
259700200528     C                   CALL      'SWIF2012'                                                 CSW212
259800200528     C                   PARM      *BLANKS       PRtCd                                        CSW212
259900200528      *                                                                                       CSW212
260000200528     C                   IF        PRtCd = 'CSW2012'                                          CSW212
260100200528     C                   EVAL      CSW212 = 'Y'                                               CSW212
260200200528     C                   ELSE                                                                 CSW212
260300200528     C                   EVAL      CSW212 = 'N'                                               CSW212
260400200528     C                   ENDIF                                                                CSW212
260500200528      *                                                                                       CSW212
260600200528      ** Call AOSARDR0 to check if CDL099 is switched on                                      CDL099
260700200528      *                                                                                       CDL099
260800200528     C                   EVAL      CDL099 = 'N'                                               CDL099
260900200528     C                   CALLB     'AOSARDR0'                                                 CDL099
261000200528     C                   PARM      *BLANKS       PRTCD                                        CDL099
261100200528     C                   PARM      '*VERIFY'     POPTN                                        CDL099
261200200528     C                   PARM      'CDL099'      PSARD                                        CDL099
261300200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL099
261400200528                                                                                              CDL099
261500200528     C                   IF        PRTCD <> *BLANKS AND                                       CDL099
261600200528     C                             PRTCD <> '*NRF   '                                         CDL099
261700200528     C     *LOCK         IN        LDA                                                        CDL099
261800200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL099
261900200528     C                   EVAL      DBASE = 913                                                CDL099
262000200528     C                   EVAL      DBKEY = 'CDL099'                                           CDL099
262100200528     C                   OUT       LDA                                                        CDL099
262200200528     C                   EXSR      SRERR                                                      CDL099
262300200528     C                   ENDIF                                                                CDL099
262400200528                                                                                              CDL099
262500200528     C                   IF        PRTCD = *BLANKS                                            CDL099
262600200528     C                   EVAL      CDL099 = 'Y'                                               CDL099
262700200528     C                   ENDIF                                                                CDL099
262800200528      *                                                                                       CDL099
262900200528     C     *DTAARA       DEFINE                  RUNDAT
263000200528     C                   IN        RUNDAT
263100200528     C/COPY WNCPYSRC,FXFXDLFC02
263200200528     C*
263300200528     C                   ENDSR
263400200528      *****************************************************************
263500200528      /EJECT                                                                                  CSD015
263600200528      *****************************************************************                       CSD015
263700200528      *                                                               *                       CSD015
263800200528      * SRWatch - Initiates the Midas Compliance Engine.              *                       CSD015
263900200528      *                                                               *                       CSD015
264000200528      *****************************************************************                       CSD015
264100200528     C     SRWatch       BEGSR                                                                CSD015
264200200528                                                                                              CSD015
264300200528      ** Initialise the Transaction Details parameter.                                        CSD015
264400200528                                                                                              CSD015
264500200528     C                   CLEAR                   SDWLTD                                       CSD015
264600200528                                                                                              CSD015
264700200528      ** Setup First Parameter                                                                CSD015
264800200528                                                                                              CSD015
264900200528     C                   CAT       'FX':0        W4ITEM                                       CSD015
265000200528     C                   CAT       FHTYPE:0      W4ITEM                                       CSD015
265100200528                                                                                              CSD015
265200200528     C                   MOVEL     FHDN38        W4IDEN                                       CSD015
265300200528     C                   EVAL      W4BRCH = FHDBRC                                            CSD015
265400200528                                                                                              CSD015
265500200528     C                   IF        CSC011 = 'Y'                                               CSD015
265600200528     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
265700200528     C                   ELSE                                                                 CSD015
265800200528     C                   EVAL      W4SYSM = LIBR                                              CSD015
265900200528     C                   ENDIF                                                                CSD015
266000200528                                                                                              CSD015
266100200528     C                   EVAL      W4FUNT = 'FXDEALPP'                                        CSD015
266200200528                                                                                              CSD015
266300200528     C                   MOVEL     FHDCNO        PCUST                                        CSD015
266400200528     C                   CALLB     'AOCUSTR0'                                                 CSD015
266500200528     C                   PARM      *BLANKS       PRetCode                                     CSD015
266600200528     C                   PARM      '*KEY'        POption                                      CSD015
266700200528     C                   Parm                    PCUST                                        CSD015
266800200528     C                   PARM      *BLANKS       PSTKEY                                       CSD015
266900200528     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
267000200528                                                                                              CSD015
267100200528     C                   IF        PRetCode <> *BLANKS                                        CSD015
267200200528     C                             AND PRetCode <> '*NRF   '                                  CSD015
267300200528     C                   EVAL      DBKEY = POption                                            CSD015
267400200528     C                   EVAL      DBFILE = 'SDCUSTPD'                                        CSD015
267500200528     C                   EVAL      DBASE = 911                                                CSD015
267600200528     C                   EXSR      SRERR                                                      CSD015
267700200528     C                   ENDIF                                                                CSD015
267800200528                                                                                              CSD015
267900200528     C                   MOVE      FHDCNO        W4CNUM                                       CSD015
268000200528                                                                                              CSD015
268100200528      ** Determine Counterparty Type                                                          CSD015
268200200528                                                                                              CSD015
268300200528     C                   IF        CCF001 = 'Y'                                               CSD015
268400200528     C                   IF        BBCRPC = 'Y'                                               CSD015
268500200528     C                   EVAL      W4CTYP = 'C'                                               CSD015
268600200528     C                   ELSE                                                                 CSD015
268700200528     C                   EVAL      W4CTYP = 'I'                                               CSD015
268800200528     C                   ENDIF                                                                CSD015
268900200528     C                   ELSE                                                                 CSD015
269000200528     C                   IF        BBLICD <> *BLANKS                                          CSD015
269100200528     C                             AND BBLICD <> W1IND1                                       CSD015
269200200528     C                             AND BBLICD <> W1IND2                                       CSD015
269300200528     C                             AND BBLICD <> W1IND3                                       CSD015
269400200528     C                             AND BBLICD <> W1IND4                                       CSD015
269500200528     C                             AND BBLICD <> W1IND5                                       CSD015
269600200528     C                   EVAL      W4CTYP = 'C'                                               CSD015
269700200528     C                   ELSE                                                                 CSD015
269800200528     C                   EVAL      W4CTYP = 'I'                                               CSD015
269900200528     C                   ENDIF                                                                CSD015
270000200528     C                   ENDIF                                                                CSD015
270100200528                                                                                              CSD015
270200200528     C                   EVAL      W4CUST = BBCRNM + BBCRTN                                   CSD015
270300200528                                                                                              CSD015
270400200528      ** Convert Dates                                                                        CSD015
270500200528                                                                                              CSD015
270600200528     C                   MOVE      FHDDYY        WDateTemp4                                   CSD015
270700200528     C                   MOVE      FHDDMM        WDateTemp2A                                  CSD015
270800200528     C                   MOVE      FHDDDD        WDateTemp2B                                  CSD015
270900200528     C                   EVAL      WDate = WDateTemp4 + '-'                                   CSD015
271000200528     C                             + WDateTemp2A + '-' +WDateTemp2B                           CSD015
271100200528     C                   MOVE      WDate         W4DDAT                                       CSD015
271200200528                                                                                              CSD015
271300200528     C                   MOVE      FHVDYY        WDateTemp4                                   CSD015
271400200528     C                   MOVE      FHVDMM        WDateTemp2A                                  CSD015
271500200528     C                   MOVE      FHVDDD        WDateTemp2B                                  CSD015
271600200528     C                   EVAL      WDate = WDateTemp4 + '-'                                   CSD015
271700200528     C                             + WDateTemp2A + '-' +WDateTemp2B                           CSD015
271800200528     C                   MOVE      WDate         W4VDAT                                       CSD015
271900200528                                                                                              CSD015
272000200528     C                   MOVE      FHDOEY        WDateTemp4                                   CSD015
272100200528     C                   MOVE      FHDOEM        WDateTemp2A                                  CSD015
272200200528     C                   MOVE      FHDOED        WDateTemp2B                                  CSD015
272300200528     C                   EVAL      WDate = WDateTemp4 + '-'                                   CSD015
272400200528     C                             + WDateTemp2A + '-' +WDateTemp2B                           CSD015
272500200528                                                                                              CSD015
272600200528     C                   IF        WDate = '0000-00-00'                                       CSD015
272700200528     C                   EVAL      WDate = '0001-01-01'                                       CSD015
272800200528     C                   ENDIF                                                                CSD015
272900200528                                                                                              CSD015
273000200528     C                   MOVE      WDate         W4MDAT                                       CSD015
273100200528                                                                                              CSD015
273200200528     C                   EVAL      W4DEN1 = FHCCY1                                            CSD015
273300200528     C                   EVAL      W4DEN2 = FHCCY2                                            CSD015
273400200528                                                                                              CSD015
273500200528     C                   MOVE      FHDBUY        PAMT                                         CSD015
273600200528     C                   Exsr      SrCvtAmt                                                   CSD015
273700200528     C                   MOVE      ConvertedAmt  W4AMT1                                       CSD015
273800200528                                                                                              CSD015
273900200528     C                   MOVE      FHDSEL        PAMT                                         CSD015
274000200528     C                   Exsr      SrCvtAmt                                                   CSD015
274100200528     C                   MOVE      ConvertedAmt  W4AMT2                                       CSD015
274200200528                                                                                              CSD015
274300200528      ** Build the free format string.                                                        CSD015
274400200528                                                                                              CSD015
274500200528     C                   EVAL      Ctr = 1                                                    CSD015
274600200528     C                   EVAL      PFreeFmtStr = *BLANKS                                      CSD015
274700200528     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
274800200528     C                   EVAL      WData = *BLANKS                                            CSD015
274900200528                                                                                              CSD015
275000200528     C                   DOU       Ctr >= Elements                                            CSD015
275100200528                                                                                              CSD015
275200200528     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
275300200528     C                             AND WLF(Ctr) <> '000000'                                   CSD015
275400200528                                                                                              CSD015
275500200528     C                   SELECT                                                               CSD015
275600200528                                                                                              CSD015
275700200528     C                   WHEN      Ctr = 1 AND FHRSCY <> *Blanks                              CSD015
275800200528     C                   EVAL      PFmtCCY = FHRSCY                                           CSD015
275900200528                                                                                              CSD015
276000200528     C                   WHEN      Ctr = 1 AND FHRSCY = *Blanks                               CSD015
276100200528     C                   EVAL      PFmtCCY = FHCCY1                                           CSD015
276200200528                                                                                              CSD015
276300200528     C                   WHEN      Ctr = 5 AND FHPSCY <> *Blanks                              CSD015
276400200528     C                   EVAL      PFmtCCY = FHPSCY                                           CSD015
276500200528                                                                                              CSD015
276600200528     C                   WHEN      Ctr = 5 AND FHPSCY = *Blanks                               CSD015
276700200528     C                   EVAL      PFmtCCY = FHCCY2                                           CSD015
276800200528                                                                                              CSD015
276900200528     C                   ENDSL                                                                CSD015
277000200528                                                                                              CSD015
277100200528     C                   CALL      'SDCWLFMT'                                                 CSD015
277200200528     C                   PARM                    PRetCode                                     CSD015
277300200528     C                   PARM                    WLF(Ctr)                                     CSD015
277400200528     C                   PARM                    PDummy35                                     CSD015
277500200528     C                   PARM                    PDummy35                                     CSD015
277600200528     C                   PARM                    PDummy35                                     CSD015
277700200528     C                   PARM                    PDummy35                                     CSD015
277800200528     C                   PARM                    PDummy35                                     CSD015
277900200528     C                   PARM                    PFmtCCY                                      CSD015
278000200528     C                   PARM                    WData                                        CSD015
278100200528     C                   PARM                    PDummy6                                      CSD015
278200200528                                                                                              CSD015
278300200528     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
278400200528     C                   CAT       WData:0       WXMLPacket                                   CSD015
278500200528                                                                                              CSD015
278600200528     C                   SELECT                                                               CSD015
278700200528                                                                                              CSD015
278800200528     C                   WHEN      Ctr = 3                                                    CSD015
278900200528     C                   CAT       FHRIBA:0      WXMLPacket                                   CSD015
279000200528                                                                                              CSD015
279100200528     C                   WHEN      Ctr = 8                                                    CSD015
279200200528     C                   CAT       FHRCRA:1      WXMLPacket                                   CSD015
279300200528                                                                                              CSD015
279400200528     C                   WHEN      Ctr = 9                                                    CSD015
279500200528     C                   CAT       FHPIBA:1      WXMLPacket                                   CSD015
279600200528                                                                                              CSD015
279700200528     C                   WHEN      Ctr = 11                                                   CSD015
279800200528     C                   CAT       FHAWBA:1      WXMLPacket                                   CSD015
279900200528                                                                                              CSD015
280000200528     C                   WHEN      Ctr = 12                                                   CSD015
280100200528     C                   CAT       FHBENA:1      WXMLPacket                                   CSD015
280200200528                                                                                              CSD015
280300200528     C                   ENDSL                                                                CSD015
280400200528                                                                                              CSD015
280500200528     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
280600200528     C                   CAT       WXMLPacket:0  PFreeFmtStr                                  CSD015
280700200528                                                                                              CSD015
280800200528     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
280900200528     C                   EVAL      WData = *BLANKS                                            CSD015
281000200528     C                   ENDIF                                                                CSD015
281100200528                                                                                              CSD015
281200200528     C                   EVAL      Ctr = Ctr + 1                                              CSD015
281300200528     C                   ENDDO                                                                CSD015
281400200528                                                                                              CSD015
281500200528      ** Add the Payment Details.                                                             CSD015
281600200528                                                                                              CSD015
281700200528     C                   IF        FHDTP1 <> *BLANKS OR FHDTP2 <> *BLANKS                     CSD015
281800200528     C                             OR FHDTP3 <> *BLANKS OR FHDTP4 <> *BLANKS                  CSD015
281900200528                                                                                              CSD015
282000200528     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
282100200528     C                   CAT       FHDTP1:0      WXMLPacket                                   CSD015
282200200528     C                   CAT       FHDTP2:1      WXMLPacket                                   CSD015
282300200528     C                   CAT       FHDTP3:1      WXMLPacket                                   CSD015
282400200528     C                   CAT       FHDTP4:1      WXMLPacket                                   CSD015
282500200528     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
282600200528     C                   CAT       WXMLPacket:0  PFreeFmtStr                                  CSD015
282700200528                                                                                              CSD015
282800200528     C                   ENDIF                                                                CSD015
282900200528                                                                                              CSD015
283000200528      ** Check for compliance.                                                                CSD015
283100200528                                                                                              CSD015
283200200528     C                   CALL      'SDCWLCHK'                                                 CSD015
283300200528     C                   PARM                    SDWLTD                                       CSD015
283400200528     C                   PARM                    PFreeFmtStr                                  CSD015
283500200528                                                                                              CSD015
283600200528     C                   ENDSR                                                                CSD015
283700200528      *****************************************************************                       CSD015
283800200528      /EJECT
283900200528     C*****************************************************
284000200528     C*                                                   *
284100200528     C* SRERR - EXCEPTION ERRORS                          *
284200200528     C*                                                   *
284300200528     C*****************************************************
284400200528     C     SRERR         BEGSR
284500200528     C*
284600200528     C     *IN98         IFEQ      '1'                                                        231306
284700200528     C     @RTCD         OREQ      '*RECLCK'                                                  231306
284800200528     C                   MOVEL     '*RECLCK'     @@RTCD                                       231306
284900200528     C                   SETON                                        LR                      231306
285000200528     C                   ELSE                                                                 231306
285100200528      *                                                                                       231306
285200200528     C                   MOVEL     '*ERROR '     @@RTCD
285300200528     C                   MOVEL     'FXFXDLUPF'   DBPGM            10
285400200528     C                   MOVE      '1'           *INU7
285500200528     C                   MOVE      '1'           *INU8
285600200528     C                   MOVE      '1'           *INLR
285700200528     C                   DUMP
285800200528      *                                                                                       231306
285900200528     C                   ENDIF                                                                231306
286000200528      *                                                                                       231306
286100200528     C*
286200200528     C**  TERMINATE THE PROGRAM
286300200528     C*
286400200528     C                   RETURN
286500200528     C*
286600200528     C                   ENDSR
286700200528     C*****************************************************
286800200528     C/COPY WNCPYSRC,FXH00078
286900200528     C/EJECT
287000200528      *****************************************************************                       CSD015
287100200528      *                                                               *                       CSD015
287200200528      * SrCvtAmt - Converts amount using bound module ZACVTAMT        *                       CSD015
287300200528      *                                                               *                       CSD015
287400200528      *****************************************************************                       CSD015
287500200528     C     SrCvtAmt      BEGSR                                                                CSD015
287600200528                                                                                              CSD015
287700200528     C                   CALLB     'ZACVTAMT'                                                 CSD015
287800200528     C                   PARM                    PRetCode                                     CSD015
287900200528     C                   PARM                    FHCCY1                                       CSD015
288000200528     C                   PARM                    PAMT                                         CSD015
288100200528     C                   PARM                    ConvertedAmt                                 CSD015
288200200528     C                   PARM                    PDummy16                                     CSD015
288300200528                                                                                              CSD015
288400200528     C                   ENDSR                                                                CSD015
288500200528      *****************************************************************                       CSD015
288600200528      /EJECT
288700200528     C/COPY WNCPYSRC,FXFXDLFC09
288800200528      *********************************************************************
288900200528      ** FIELD LOG
289000200528      *********************************************************************
289100200528      **                                      SET IN     SET IN
289200200528      **                                    VALIDATION    THIS    AMENDABLE
289300200528      **                                     FUNCTION   FUNCTION
289400200528      *********************************************************************
289500200528      ** Record identifier            F3RCID              YES       YES
289600200528      ** Logical delete flag          F3DLTF              YES       YES
289700200528      ** Day of last update           F3DLUP              YES       YES
289800200528      ** Month of last update         F3MLUP              YES       YES
289900200528      ** Year of last update          F3YLUP              YES       YES
290000200528      ** Time of last update          F3TLUP              YES       YES
290100200528      ** Type of last change          F3CHTP              YES       YES
290200200528      ** Last change date             F3LCD               YES       YES
290300200528      ** Last update user id          F3LUID              YES       YES
290400200528      ** Deal number 38               F3DN38   YES
290500200528      ** Deal value date - yyyy       F3VDYY              YES
290600200528      ** Deal value date - mm         F3VDMM              YES
290700200528      ** Deal value date - dd         F3VDDD              YES
290800200528      ** Deal transaction date - yyyy F3DTYY              YES
290900200528      ** Deal transaction date - mm   F3DTMM              YES
291000200528      ** Deal transaction date - dd   F3DTDD              YES
291100200528      ** Deal option end date - yyyy  F3DOEY              YES
291200200528      ** Deal option end date - mm    F3DOEM              YES
291300200528      ** Deal option end date - dd    F3DOED              YES
291400200528      ** Deal associated deal number  F3DADN   YES
291500200528      ** Deal deleted indicator       F3DDLT              YES       YES
291600200528      ** Deal status indicator        F3DSTS              YES       YES
291700200528      ** Deal type indicator          F3DTYP              YES
291800200528      ** Deal customer shortname      F3DCSN   YES                  YES
291900200528      ** Deal customer number         F3DCNO   YES                  YES
292000200528      ** Exchange rate                F3DXRT   YES
292100200528      ** Deal first amount            F3DAM1   YES
292200200528      ** Deal first currency dflt     F3CCY1   YES
292300200528      ** Deal second currency dflt    F3CCY2   YES
292400200528      ** Deal second  amount          F3DAM2   YES
292500200528      ** Deal mult/div first amnt ind F3DMD1   YES
292600200528      ** Deal buy amount              F3DBUY              YES
292700200528      ** Deal sell amount             F3DSEL              YES
292800200528      ** Deal base ccy for accounting F3BCAE   YES
292900200528      ** Deal base ccy for dealing    F3BCDE   YES
293000200528      ** Deal spot base ccy equiv.    F3DSBE   YES
293100200528      ** Deal authorisation officer   F3AOFR              YES       YES
293200200528      ** Deal user code               F3DUSC              YES       YES
293300200528      ** Deal branch code             F3DBRC   YES                  YES
293400200528      ** Branch code (alpha)          F3MBCA   YES                  YES
293500200528      ** Deal done date - yyyy        F3DDYY              YES       YES
293600200528      ** Deal done date - mm          F3DDMM              YES       YES
293700200528      ** Deal done date - dd          F3DDDD              YES       YES
293800200528      ** Deal forward points          F3FWPP   YES
293900200528      ** Deal midas our receve method F3ORCM              YES       YES
294000200528      ** Deal our receive method      F3DORM              YES       YES
294100200528      ** Deal midas our receive instr F3MORI              YES       YES
294200200528      ** Deal our receive instructns  F3DORI              YES       YES
294300200528      ** Deal midas our payment meth. F3MOPM              YES       YES
294400200528      ** Deal our payment method      F3DOPM              YES       YES
294500200528      ** Deal midas our payment instr F3MOPI              YES       YES
294600200528      ** Deal our payment instructns  F3DOPI              YES       YES
294700200528      ** Deal type                    F3TYPE   YES
294800200528      ** Deal sub type                F3STYP   YES                  YES
294900200528      ** Broker code                  F3BROK   YES                  YES
295000200528      ** Deal brokerage               F3BRKG   YES                  YES
295100200528      ** Deal customer payment instr  F3DCPI              YES       YES
295200200528      ** Deal midas cust payment inst F3MCPI              YES       YES
295300200528      ** Deal customer receive instr  F3DCRI              YES       YES
295400200528      ** Deal Customer Receive Instru F3MCRI              YES       YES
295500200528      ** Deal for A/C of              F3DFAC              YES       YES
295600200528      ** Deal midas ''FOR A/C OF''    F3MFAO              YES       YES
295700200528      ** Deal special instructions    F3SPEC              YES       YES
295800200528      ** Deal last action             F3LACT   YES                  YES
295900200528      ** Time of input                F3ETIM              YES
296000200528      ** Dl option orig first amnt    F3OOFA              YES
296100200528      ** Dl option orig second amnt   F3OOSA              YES
296200200528      ** Broker currency code         F3BKCY   YES                  YES
296300200528      ** Deal number pc               F3PCDN--------------------------------
296400200528      ** Deal pc transation number    F3PCTN--------------------------------
296500200528      ** Deal action date             F3ADAT              YES       YES
296600200528      ** Fed funds indicator          F3FEDF   YES                  YES
296700200528      ** Book Code                    F3BOKC   YES                  YES
296800200528      ** LINKED DEAL NUMBER           F3LNKN   YES                  YES
296900200528      ** receipt - settlement method  F3RSTM   YES*                 YES
297000200528      ** receipt - our nostro         F3RONS   YES*                 YES
297100200528      ** receipt - intermediary bank  F3RIBN   YES*                 YES
297200200528      ** receipt - intermediary bank  F3RIBA   YES*                 YES
297300200528      ** receipt - ordering bank no   F3ROBN   YES*                 YES
297400200528      ** receipt - ordering customer  F3ROCN   YES*                 YES
297500200528      ** pay - settlement method      F3PSTM   YES*                 YES
297600200528      ** pay - our nostro             F3PONS   YES*                 YES
297700200528      ** pay - intermediary bank no   F3PIBN   YES*                 YES
297800200528      ** pay - intermediary bank a/c  F3PIBA   YES*                 YES
297900200528      ** pay - ordering bank no       F3POBN   YES*                 YES
298000200528      ** pay - ordering customer no   F3POCN   YES*                 YES
298100200528      ** receiver correspondent no    F3RCRN   YES*                 YES
298200200528      ** receiver correspondent a/c l F3RCRA   YES*                 YES
298300200528      ** Receiver number              F3RVNO   YES*                 YES
298400200528      ** a/c with bank no             F3AWBN   YES*                 YES
298500200528      ** a/c with bank a/c line       F3AWBA   YES*                 YES
298600200528      ** beneficiary no               F3BENN   YES*                 YES
298700200528      ** beneficiary a/c line         F3BENA   YES*                 YES
298800200528      ** DETAILS OF PAY 1             F3DTP1   YES*                 YES
298900200528      ** DETAILS OF PAY 2             F3DTP2   YES*                 YES
299000200528      ** DETAILS OF PAY 3             F3DTP3   YES*                 YES
299100200528      ** DETAILS OF PAY 4             F3DTP4   YES*                 YES
299200200528      ** details of charges           F3DCHG   YES*                 YES
299300200528      ** bank to bank info 1          F3BTB1   YES*                 YES
299400200528      ** bank to bank info 2          F3BTB2   YES*                 YES
299500200528      ** bank to bank info 3          F3BTB3   YES*                 YES
299600200528      ** bank to bank info 4          F3BTB4   YES*                 YES
299700200528      ** bank to bank 5               F3BTB5   YES*                 YES
299800200528      ** bank to bank 6               F3BTB6   YES*                 YES
299900200528      ** Originating branch           F3ORBR   YES                  YES
300000200528      ** Profit centre                F3PRFC   YES                  YES
300100200528      ** Our Receive Branch           F3ROBR   YES                  YES
300200200528      ** Our Pay Branch               F3POBR   YES                  YES
300300200528      ** COVER MESSAGE REQUIRED       F3CVMR   YES                  YES
300400200528      ** Margin Points                F3MGPT   YES
300500200528      ** Margin Amount                F3MGAM   YES
300600200528      ** Marg Ccy                     F3MGCY   YES
300700200528      ** Marg buy/ sell ind           F3MGBS   YES
300800200528      ** Original Spot rate           F3OSRT   YES
300900200528      ** Buy forward Points amount    F3BFPA   YES                  YES
301000200528      ** Sell forward Points amount   F3SFPA   YES                  YES
301100200528      ** Input DL base spot rate      F3BDBS   YES                  YES
301200200528      ** Other DL base spot rate      F3SDBS   YES                  YES
301300200528      ** Other DL base spot equiv     F3SDBE   YES                  YES
301400200528      ** Buy DL base fwd points       F3BDBF   YES                  YES
301500200528      ** Sell DL base fwd points      F3SDBF   YES                  YES
301600200528      ** Buy DL base fwd amount       F3BDFA   YES                  YES
301700200528      ** Sell DL base fwd amount      F3SDFA   YES                  YES
301800200528      ** Portfolio reference          F3PTFR   YES                  YES
301900200528      ** Net Buy Indicator            F3NBUY   YES                  YES
302000200528      ** Net Buy Reference            F3NBRF   YES                  YES
302100200528      ** Net Sell Indicator           F3NSEL   YES                  YES
302200200528      ** Net Sell Reference           F3NSRF   YES                  YES
302300200528      ** Matched Deal                 F3MTCH   YES                  YES
302400200528      ** Rec Settle Currency          F3RSCY   YES                  YES
302500200528      ** Pay Settle Currency          F3RSCY   YES                  YES
302600200528      ** In Currency in Field 72      F3IC72   YES                  YES
302700200528      ** Deal date day number         F3DDDN   YES                  YES
302800200528      ** Value date day number        F3VDDN   YES
302900200528      ** Option to date day number    F3OTDN   YES
303000200528      ** Front Office transaction ID  F3FRNT   YES                  YES         CAP013
303100200528      ** Associated Front Office Tran F3AFRT   YES                  YES         CAP013
303200200528      ** Repair location              F3REPA
303300200528      ** Automatic Authorisation      F3AUTH                                    CAP051
303400200528      ** CLS Settlement               F3CLSS   YES                  YES         CDL008
303500200528      ** Class                        F3CLAS   YES                  YES         CDL038
303600200528      *********************************************************************
303700200528**  CPY@
303800200528(c) Finastra International Limited 2001
303900200528** CTDATA XOT - XML Opening Tags for the Compliance Engine.                                   CSD015
304000200528<Receipt Our Nostro>                                                                          CSD015
304100200528<Receipt Ord Customer>                                                                        CSD015
304200200528<Receipt Int Bank>                                                                            CSD015
304300200528<Receipt Ord Bank>                                                                            CSD015
304400200528<Payment Our Nostro>                                                                          CSD015
304500200528<Payment Ord Customer>                                                                        CSD015
304600200528<Payment Receiver>                                                                            CSD015
304700200528<Payment Receiver Corr>                                                                       CSD015
304800200528<Payment Int Bank>                                                                            CSD015
304900200528<Payment Ord Bank>                                                                            CSD015
305000200528<Payment A/C with Bank>                                                                       CSD015
305100200528<Payment Beneficiary>                                                                         CSD015
305200200528<Payment Details of Pay>                                                                      CSD015
305300200528** CTDATA XCT - XML Closing Tags for the Compliance Engine.                                   CSD015
305400200528</Receipt Our Nostro>                                                                         CSD015
305500200528</Receipt Ord Customer>                                                                       CSD015
305600200528</Receipt Int Bank>                                                                           CSD015
305700200528</Receipt Ord Bank>                                                                           CSD015
305800200528</Payment Our Nostro>                                                                         CSD015
305900200528</Payment Ord Customer>                                                                       CSD015
306000200528</Payment Receiver>                                                                           CSD015
306100200528</Payment Receiver Corr>                                                                      CSD015
306200200528</Payment Int Bank>                                                                           CSD015
306300200528</Payment Ord Bank>                                                                           CSD015
306400200528</Payment A/C with Bank>                                                                      CSD015
306500200528</Payment Beneficiary>                                                                        CSD015
306600200528</Payment Details of Pay>                                                                     CSD015
