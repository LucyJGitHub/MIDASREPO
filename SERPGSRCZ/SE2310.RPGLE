000100200616     H DEBUG
000200200616     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200616      *****************************************************************
000400200616/*STD *  RPGBASEMOD                                                   *
000500200616/*EXI *  TEXT('Midas SE Position Settlement Split for CSE023')        *
000600200616      *****************************************************************
000700200616      *                                                               *
000800200616      *  Midas - Securities Trading  Module                           *
000900200616      *                                                               *
001000200616      *  SE2310 - SE Position Settlement Split for Treaty Withholding *
001100200616      *           Tax                                                 *
001200200616      *                                                               *
001300200616      *  Function:  This program sub-divides each position settlement *
001400200616      *             record into either records for different  Tax     *
001500200616      *             groups or records for different  beneficial       *
001600200616      *             owners.                                           *
001700200616      *                                                               *
001800200616      *  (c) Finastra International Limited 2001                      *
001900200616      *                                                               *
001901200616      *  Last Amend No. AR324886           Date 01Jun20               *
002000200616      *  Prev Amend No. MD046248           Date 27Oct17               *
002100200616      *                 233071             Date 28Mar12               *
002200200616      * Bank Fusion Midas 1.4 Base -----------------------------------*
002300200616      * Midas Plus 1.4 Base 04 ---------------------------------------*
002400200616      * Midas Plus 1.4 Base ------------------------------------------*
002500200616      *                 245798             Date 19Feb07               *
002600200616      *                 236594             Date 17May05               *
002700200616      *                 CSD079             Date 05Feb07               *
002800200616      * Midas Plus 1.3 ----------- Base ------------------------------*
002900200616      *                 CSD031             Date 10Apr06               *
003000200616      *                 CSD027             Date 09Dec05               *
003100200616      *                 233709             Date 12Jun05               *
003200200616      *                 CSE071             Date 19Jul05               *
003300200616      *                 CSW037A            Date 02May05               *
003400200616      *                 218116             Date 22May03               *
003500200616      *                 216559             Date 03Apr03               *
003600200616      *                 216556             Date 03Apr03               *
003700200616      *                 215575             Date 13Mar03               *
003800200616      *                 229342             Date 01Nov02               *
003900200616      *                 CSD025             Date 11Jan05               *
004000200616      *                 CSW037             Date 15Dec04               *
004100200616      *                 CSW036             Date 15Dec04               *
004200200616      *                 CLE025             Date 20Oct03               *
004300200616      *                 CGL029             Date 01Sep03               *
004400200616      * Midas Release 4 --------------- Base -------------------------*
004500200616      * Midas DBA 3.05 -----------------------------------------------*
004600200616      *                 187745             Date 12Jan01               *
004700200616      *                 187962             Date 21Dec00               *
004800200616      * Midas DBA 3.04 -----------------------------------------------*
004900200616      *                 187179             Date 01Dec00               *
005000200616      *                 186303             Date 14Nov00               *
005100200616      *                 186237             Date 13Nov00               *
005200200616      *                 186001             Date 08Nov00               *
005300200616      *                 186000             Date 08Nov00               *
005400200616      *                 185936             Date 06Nov00               *
005500200616      *                 186051             Date 30Oct00               *
005600200616      *                 186050             Date 30Oct00               *
005700200616      *                 185756             Date 25Oct00               *
005800200616      *                 185748             Date 25Oct00               *
005900200616      *                 185731             Date 25Oct00               *
006000200616      *                 185604             Date 230ct00               *
006100200616      *                 185292             Date 20Oct00               *
006200200616      *                 CSE023  *CREATE    Date 18Aug00               *
006300200616      *                                                               *
006400200616      *---------------------------------------------------------------*
006500200616      *                                                               *
006501200616      *  AR324886 - Implement 4-eyes processing in Position           *
006502200616      *             Settlement Maintenance.                           *
006600200616      *  MD046248 - Finastra Rebranding                               *
006700200616      *  233071 - Database error 106 in program AOTXBSR0 due to blank *
006800200616      *           tax basket.  Default tax basket with WK_TXBS only   *
006900200616      *           if it is not blank, otherwise should still use      *
007000200616      *           value of WHTXBS or WTTXBS.                          *
007100200616      *         - Applied for AR942829                                *
007200200616      *  245798 - Apply 236594.                                       *
007300200616      *  236594 - Decimal data error with fields added by fix 233711  *
007400200616      *  CSD079 - Enhanced Customer Maintenance API (Recompile)       *
007500200616      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
007600200616      *  CSD027 - Conversion Of Customer Number to Alpha              *
007700200616      *  233709 - POSETD layout changed (recompile)                   *
007800200616      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
007900200616      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
008000200616      *  218116 - Database error occurs due to a blank tax basket.    *
008100200616      *           Fix is to code condition properly since APIE value  *
008200200616      *           can only be 'Y' or blank.                           *
008300200616      *  216559 - Tax basket not correctly applied for exemption.     *
008400200616      *  216556 - For position settlement 'R' for a customer no tax   *
008500200616      *           should be calculated.                               *
008600200616      *  215575 - Wrong position settlement generated for corporate   *
008700200616      *           action for depot. No check on actual cash.          *
008800200616      *  229342 - No DB Error if customer is flagged for closure      *
008900200616      *  CSD025 - Customer De-Activation                              *
009000200616      *  CSW037 - Additional Field Data on MT300/MT320                *
009100200616      *  CSW036 - Dual SWIFT BIC held on Client Details               *
009200200616      *  CLE025 - Credit Lines (Recompile)                            *
009300200616      *  CGL029 - Increase Account Code to 10 digits                  *
009400200616      *  187745 - For tax basket, check Customer/Beneficial owner     *
009500200616      *           details first before Treaty tax details             *
009600200616      *  187962 - If the tax basket is blank, then the description    *
009700200616      *           for the tax basket should be blank.                 *
009800200616      *  187179 - Program unable to set up tax basket foe QI caused   *
009900200616      *           DB error in calculation of tax.                     *
010000200616      *  186303 - OID = 'S', withholding tax only apply to customer   *
010100200616      *           with documentation = 'U' or 'N'.                    *
010200200616      *  186237 - A customer with documentation 'L' has got a tax     *
010300200616      *           deduction on a maturity                             *
010400200616      *  186001 - Withholding tax for User Holding                    *
010500200616      *  186000 - Tax Identification Number needs to be added to      *
010600200616      *           Customer Withholding Tax Details                    *
010700200616      *  185936 - Depot position settlement not the same as customer  *
010800200616      *           position settlement.                                *
010900200616      *  186051 - Gross/Net Amount is being shown as zero for a       *
011000200616      *           maturity event position which is not taxable        *
011100200616      *  186050 - Beneficial owner is not being shown in screen/report*
011200200616      *  185756 - Divide by zero occured for customer holdings whose  *
011300200616      *           intermediary clients details were not completed     *
011400200616      *  185748 - Position Settlement record for beneficial owner     *
011500200616      *           holding has a wrong recipient code                  *
011600200616      *  185731 - Divide by zero occured for maturity events without  *
011700200616      *           any holdings                                        *
011800200616      *  185604 - Incorrect data being added to the rounding record   *
011900200616      *  185292 - Change in the processing of OID for client without  *
012000200616      *           documentation.                                      *
012100200616      *  CSE023 - Treaty Withholding Tax                              *
012200200616      *                                                               *
012300200616      *****************************************************************
012400200616      *                                                               *
012500200616      *  Use of indicators.                                           *
012600200616      *                                                               *
012700200616      *    XX         Function of indicators                          *
012800200616      *                                                               *
012900200616      *    21     Record missing from SECTYD                          *
013000200616      *    22     Record missing from INVTPD                          *
013100200616      *    23     Write to POSETD/Update POSET5 indicator             *
013200200616      *                                                               *
013300200616      *    25     No record found in CPOSND                           *
013400200616      *    26     No record found in UDEPP                            *
013500200616      *    27     No record found in UDEPH                            *
013600200616      *    28     No record found in SECDEPL6                         *
013700200616      *    29     No record found in CDEPH                            *
013800200616      *    30     No record found in CDEPS                            *
013900200616      *    31     Record not found in SDWHTTPD                        *
014000200616      *    32     Record not found in SDWTCSPD                        *
014100200616      *    33     Record not found in SDBNFOL1                        *
014200200616      *    34     No record found in SDINTCLPD                        *
014300200616      *                                                               *
014400200616      *   LR :    Last record                                         *
014500200616      *   U7/U8 : Database error                                      *
014600200616      *                                                               *
014700200616      *****************************************************************
014800200616      *                                                               *
014900200616      *  S U B R O U T I N E  I N D E X                               *
015000200616      *                                                               *
015100200616      * SRCust      Process Customer Position Settlement Record       *
015200200616      * SRCustInfo  Get Customer withholding Tax detail               *
015300200616      * SRSingleRec Process withholding Tax for single individual     *
015400200616      *             Customer.                                         *
015500200616      * SRCalTax    Get Tax Basket Information and Calculate Tax      *
015600200616      *             amount.                                           *
015700200616      * SRInter     Process Withholding Tax for Intermediary          *
015800200616      * SRGetBenTax Get Tax Basket for Beneficial Owner               *
015900200616      * SRWrtOrUpd  Write new Position record or Update position      *
016000200616      * SRDepot     Process Depot Position Settlement Record          *
016100200616      * SRUDPos     Get User Depot Position and update Position       *
016200200616      * SRCPoset    Get Customer Depot Position                       *
016300200616      * SRSetlAmt   Calculate Settlement Amount                       *
016400200616      * SRNDIFF     Output position different                         *
016500200616      * *INZSR      Initialise                                        *
016600200616      * *PSSR       Error processing                                  *
016700200616      *                                                               *
016800200616      *****************************************************************
016900200616
017000200616     FPOSET5    UF A E           K DISK
017100200616      ** Position Settlement
017200200616     F                                     RENAME(POSETDF:POSETUP)
017300200616     F                                     PREFIX(Nw_)
017400200616     FPOSETD    O    E             DISK
017500200616      ** Position Settlement for output only
017600200616     F                                     RENAME(POSETDF:POSETUP2)
017700200616     F                                     PREFIX(Nw_)
017701200616     FPSAUTD    O    E             DISK                                                     AR324886
017702200616      ** SE Position Settlement Authorisation detail                                        AR324886
017703200616      *                                                                                     AR324886
017800200616     FSECOALL4  IF   E           K DISK                                                       215575
017900200616      ** Corporate allocation Client - MC                                                     215575
018000200616     FSECTY     IF   E           K DISK
018100200616      ** Security Detail
018200200616     F                                     PREFIX(SE_)
018300200616     FINVTP     IF   E           K DISK
018400200616      ** Investment type Detail
018500200616     FSDWTCSL1  IF   E           K Disk
018600200616      ** Customer Withholding Tax detail - WH
018700200616     FSDWHTTL0  IF   E           K Disk
018800200616      ** Treaty Withholding Tax Detail - WT
018900200616     FSDBNFOL1  IF   E           K Disk
019000200616      ** Beneficial Owner Detail - (Including Depot as Key)
019100200616     FSDINTCLL1 IF   E           K Disk
019200200616      ** Intermediary Client Detail - IN
019300200616     FUDEPP     IF   E           K Disk
019400200616      ** User Depot Position
019500200616     F                                     RENAME(UDEPPDF:UDEPPDF1)
019600200616     F                                     PREFIX(LU_)
019700200616     FUDEPH     IF   E           K Disk
019800200616      ** User Depot Position
019900200616     F                                     RENAME(UDEPPDF:UDEPPDF2)
020000200616     F                                     PREFIX(LU_)
020100200616     FSECDEPL6  IF   E           K Disk
020200200616      ** Customer Depot Position
020300200616     F                                     PREFIX(LC_)
020400200616     FCDEPH     IF   E           K Disk
020500200616      ** Customer Depot Position
020600200616     F                                     RENAME(CDEPPDF:CDEPPDF2)
020700200616     F                                     PREFIX(LC_)
020800200616     FCDEPS     IF   E           K Disk
020900200616      ** Customer Depot Position - Live position Only
021000200616     F                                     RENAME(CDEPPDF:CDEPPDF3)
021100200616     F                                     PREFIX(LC_)
021200200616     FCPOSN     IF   E           K Disk
021300200616      ** Customer Position
021400200616     F                                     PREFIX(CP_)
021500200616     FBKPHD     IF   E           K Disk                                         186001
021600200616      ** Book Position Header - Live Position                                   186001
021700200616     F                                     PREFIX(BH_)                          186001
021800200616      *****************************************************************
021900200616      ** +--------------------------------------+
022000200616      ** ¦ Automatically included D-specs       ¦
022100200616      ** ¦ ==============================       ¦
022200200616      ** +--------------------------------------+
022300200616      *
022400200616      ** Standard D-specs
022500200616      ** ================
022600200616      **
022700200616      ** The following /COPY line includes the LDA layout,
022800200616      ** the copyright array definition,
022900200616      ** and the following named constants:
023000200616      **    True       logical = *on (for indcator processing)
023100200616      **    False      logical = *off (for indicator processing)
023200200616      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
023300200616      **                                    handler)
023400200616      ** and the following variables:
023500200616      **    RunBefore  1A (for the PSSR)
023600200616      *
023700200616      /COPY ZACPYSRC,STD_D_SPEC
023800200616      *
023900200616      ** Program Status Data Structure
024000200616      ** =============================
024100200616      ** The following /COPY line includes all the defined fields in the
024200200616      ** PSDS.  They have meaningful names, prefixed by 'PS'.
024300200616      *
024400200616      /COPY ZACPYSRC,PSDS
024500200616      *
024600200616      ** The following /COPY line includes the definitions for error and
024700200616      ** warning message arrays.
024800200616      *
024900200616      /COPY ZACPYSRC,ERR_ARRAYS
025000200616      *
025100200616      ** +--------------------------------------+
025200200616      ** ¦ End of automatically included D-specs¦
025300200616      ** ¦ =====================================¦
025400200616      ** +--------------------------------------+
025500200616
025600200616      *****************************************************************
025700200616      /EJECT
025800200616      *****************************************************************
025900200616
026000200616      ** +--------------------------------------+
026100200616      ** ¦ Manually included D-specs            ¦
026200200616      ** ¦ =========================            ¦
026300200616      ** +--------------------------------------+
026400200616
026500200616     D InPoset       E DS                  EXTNAME(POSETD)
026600200616     D                                     PREFIX(In_)
026700200616
026800200616     D OutPoset      E DS                  EXTNAME(POSETD)
026900200616     D                                     PREFIX(Nw_)
027000200616
027100200616     D WrkPoset      E DS                  EXTNAME(POSETD)
027200200616     D                                     PREFIX(Wk_)
027300200616
027400200616     D P@DATA          DS           128
027500200616     D** Data structure for the parameter passed to and from SEZ010
027600200616     D P@CLAS                  1      1
027700200616     D P@PPRE                  2      2
027800200616     D P@PAMD                  3     15  0
027900200616     D P@PCHA                 16     28  0
028000200616     D P@PCAM                 29     41  0
028100200616     D P@TASO                 42     54  0
028200200616     D P@TAUS                 55     67  0
028300200616     D P@PSXR                 68     80  8
028400200616     D P@PMDI                 81     81
028500200616     D P@PNCY                 82     84
028600200616     D P@PSCU                 85     87
028700200616     D P@PSAT                 88    100  0
028800200616     D P@FXMR                101    113  8
028900200616     D P@MAMT                114    126  0
029000200616     D P@TDTP                127    128
029100200616
029200200616      ** ICD/SD Data Structures
029300200616      ** ----------------------
029400200616
029500200616      ** External DS for Bank Details
029600200616     D SDBANK        E DS                  EXTNAME(SDBANKPD)
029700200616
029800200616      ** Customer file
029900200616     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
030000200616
030100200616      ** Data Structure for Currency Details
030200200616     D SDCURR        E DS                  EXTNAME(SDCURRPD)
030300200616
030400200616      ** Data Structure for Branch Details                                      186001
030500200616     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                    186001
030600200616     D QQDFA1        E                     EXTFLD(QQDFAC)                                     CGL029
030700200616                                                                                186001
030800200616      ** DS for Access Programs, Short DS
030900200616     D DSFDY         E DS                  EXTNAME(DSFDY)
031000200616
031100200616      **  Long DS for access programs
031200200616     D DSSDY         E DS                  EXTNAME(DSSDY)
031300200616      *                                                                                       229342
031400200616      ** DS for access objects - long data structure                                          229342
031500200616     D DSLDY         E DS                  EXTNAME(DSLDY)                                     229342
031501200616     D SDSTAT        E DS                  EXTNAME(SDSTAT)                                  AR324886
031502200616      ** SD data area                                                                       AR324886
031503200616      *                                                                                     AR324886
031600200616
031700200616      ** +--------------------------------------+
031800200616      ** ¦ Declared variables                   ¦
031900200616      ** ¦ ==================                   ¦
032000200616      ** +--------------------------------------+
032100200616
032200200616     D @AccAmtDue      S             13  0
032300200616     D @AccPosit       S             13  0
032400200616     D @Acccharge      S             13  0
032500200616     D @AccComm        S             13  0
032600200616     D @AccDpIncome    S             13  0
032700200616     D @AccDpPosit     S             13  0
032800200616     D @AccDpcharge    S             13  0
032900200616     D @AccDpComm      S             13  0
033000200616     D @AmtDiff        S             13  0
033100200616     D @Bendept        S                   LIKE(BNDEPT)
033200200616     D @Book           S                   LIKE(LU_UDBK)
033300200616     D @CallFrom       S              1                                         186001
033400200616     D @ChgDiff        S             13  0
033500200616     D @Cost           S             13  0
033600200616     D @CountryTax     S                   LIKE(WHCRTT)
033700200616     D @CommDiff       S             13  0
033800200616     D @CTotAmt        S             13  0
033900200616     D @CTotNoml       S             13  0
034000200616     D @CTotChg        S             13  0
034100200616     D @CTotComm       S             13  0
034200200616     D @Cust           S                   LIKE(BBCUST)
034300200616     D @CustNDTXBS     S                   LIKE(WTDBDC)
034400200616     D @CustNo         S                   LIKE(LC_CDCN)
034500200616     D @Depot          S                   LIKE(BBCUST)
034600200616     D @DepotNo        S                   LIKE(LC_CDPT)
034700200616     D @Discount       S             20  8
034800200616     D @HoldingCust    S                   LIKE(INCNUM)
034900200616     D @HoldingDept    S                   LIKE(BNDEPT)
035000200616     D @INBONO         S                   LIKE(INBONO)
035100200616     D @INCNUM         S                   LIKE(INCNUM)
035200200616     D InDivDate       S              5  0
035300200616     D InTVPosit       S              1
035400200616     D @LCouponD       S              5  0
035500200616     D @Loc            S                   LIKE(BBCOLC)
035600200616     D Lt_PBCA         S                   LIKE(Wk_PBCA)
035700200616     D Lt_PSSH         S                   LIKE(Wk_PSSH)
035800200616     D Lt_PCPY         S                   LIKE(Wk_PCPY)
035900200616     D Lt_PDUD         S                   LIKE(Wk_PDUD)
036000200616     D Lt_PEVT         S                   LIKE(Wk_PEVT)
036100200616     D Lt_TNLU         S                   LIKE(Wk_TNLU)
036200200616     D Lt_TXBS         S                   LIKE(Wk_TXBS)
036300200616     D Lt_EXCD         S                   LIKE(Wk_EXCD)
036400200616     D Lt_BNFO         S                   LIKE(Wk_BNFO)
036500200616     D @Mket           S                   LIKE(LU_UDMK)
036600200616     D @NomlDiff       S             13  0
036700200616     D @NoDoc          S              1
036800200616     D @NoTax          S              1
036900200616     D NWrtn           S              3  0
037000200616     D @PositDate      S              5  0
037100200616     D @PDate          S                   LIKE(LU_UDDT)
037200200616     D PgmErr          S              1
037300200616     D @Rec_Found      S              1
037400200616     D @RoundingRec    S              1
037500200616     D @Secty          S                   LIKE(INSECS)
037600200616     D @SetExCode      S              1
037700200616     D @SITP           S                   LIKE(SE_SITP)
037800200616     D @TreatyTax      S              1
037900200616     D @TVInd          S              1                                         186001
038000200616     D @U_Cost         S             15  0                                      186001
038100200616     D @U_Exnml        S                   LIKE(LU_UECN)
038200200616     D @U_TDnml        S                   LIKE(LU_UDNT)
038300200616     D @U_VDnml        S                   LIKE(LU_UDNV)
038400200616     D @UnitIncome     S             13  9
038500200616     D Upd_Rounding    S              1                                         185604
038600200616     D @WhingTax       S                   LIKE(NW_PAMD)
038700200616
038800200616      ** +--------------------------------------+
038900200616      ** ¦ End of D-specs                       ¦
039000200616      ** ¦ ==============                       ¦
039100200616      ** +--------------------------------------+
039200200616
039300200616      *****************************************************************
039400200616      /EJECT
039500200616      *****************************************************************
039600200616     C
039700200616      ** +--- Start of Main processing -----------------------------------+
039800200616      ** ¦                                                                ¦
039900200616      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
040000200616      ** ¦ executed at program activation.                                ¦
040100200616      ** ¦                                                                ¦
040200200616      ** +----------------------------------------------------------------+
040300200616      *
040400200616      ** Get Security Details
040500200616      *
040600200616
040700200616     C                   MOVE      IN_PSSH       @Secty
040800200616     C     IN_PSSH       CHAIN     SECTY                              21
040900200616     C     *IN21         IFEQ      '1'
041000200616     C     *LOCK         IN        LDA
041100200616     C                   EVAL      DBFILE =  'SECTYD'
041200200616     C                   EVAL      DBKEY  =  In_PSSH
041300200616     C                   EVAL      DBPGM  =  PSProcPgm
041400200616     C                   EVAL      DBASE  =  102
041500200616     C                   EVAL      DBMOD  =  PSProcMod
041600200616     C                   EVAL      DBPROC =  'MAIN'
041700200616     C                   OUT       LDA
041800200616     C                   EXSR      *PSSR
041900200616     C                   ENDIF
042000200616      *
042100200616      ** If no error and Country of Tax Treaty in the security detail
042200200616      ** is equal to *BLANK, then output the original record to file.
042300200616      *
042400200616     C     SE_CRTT       IFEQ      *BLANK
042500200616     C                   EVAL      @TreatyTax = 'N'
042600200616     C                   EVAL      Wk_RPCD = *BLANKS                            185748
042700200616     C                   EXSR      SRWrtOrUpd
042800200616     C                   ELSE
042900200616     C                   EVAL      @TreatyTax = 'Y'
043000200616     C                   EVAL      Wk_CRTX = SE_CRTT
043100200616     C                   EVAL      Wk_ICTP = SE_INCT
043200200616
043300200616     C                   ENDIF
043400200616      *
043500200616      ** If Treaty Tax processing is needed
043600200616      *
043700200616     C                   IF        @TreatyTax = 'Y'
043800200616      *
043900200616      ** Get Investment Details
044000200616      *
044100200616     C     InvestKey     CHAIN     INVTP                              22
044200200616     C     *IN22         IFEQ      '1'
044300200616     C     *LOCK         IN        LDA
044400200616     C                   EVAL      DBFILE =  'INVTPD'
044500200616     C                   EVAL      DBKEY  =  SE_SITP
044600200616     C                   EVAL      DBPGM  =  PSProcPgm
044700200616     C                   EVAL      DBASE  =  103
044800200616     C                   EVAL      DBMOD  =  PSProcMod
044900200616     C                   EVAL      DBPROC =  'MAIN'
045000200616     C                   OUT       LDA
045100200616     C                   EXSR      *PSSR
045200200616     C                   ENDIF
045300200616      *
045400200616      ** Process input Position Settlement record depending on the Customer
045500200616      ** type.
045600200616      *
045700200616     C     IN_CTYP       IFEQ      'C'
045800200616     C                   MOVE      In_PCPY       @Cust
045900200616     C                   MOVE      In_PCPY       @HoldingCust
046000200616     C                   EXSR      SRCust
046100200616     C                   ELSE
046200200616     C                   EXSR      SRDepot
046300200616     C                   ENDIF
046400200616
046500200616     C                   ENDIF
046600200616      *
046700200616     C                   SETON                                        LR
046800200616     C                   RETURN
046900200616
047000200616      *****************************************************************
047100200616      /EJECT
047200200616      *****************************************************************
047300200616      *                                                               *
047400200616      * SRCust - Process Customer Position Settlement Record          *
047500200616      *                                                               *
047600200616      * Called by: Main, SRCPoset                                     *
047700200616      *                                                               *
047800200616      * Calls: SRCustInfo, SRWrtOrUpd, SRSingleRec, SRInter           *
047900200616      *                                                               *
048000200616      *****************************************************************
048100200616
048200200616     C     SRCust        BEGSR
048300200616
048400200616     C                   MOVE      ' '           @CallFrom                      186001
048500200616     C                   EXSR      SRCustInfo
048600200616      *
048700200616      ** If no withholding tax needs to be appied to the customer
048800200616      ** or Customer is exempt from tax
048900200616      ** Then If it is a customer's position settlement
049000200616      **      Then output the original record to file.
049100200616      **      ELSE Setup position settlement record using customer depot
049200200616      **           position information and group the result in the correct
049300200616      **           tax basket.
049400200616      *
049500200616     C                   IF        In_PPRE = 'R' and In_CTYP = 'C'                            216556
049600200616     C                   EVAL      @NoTax = 'Y'                                               216556
049700200616     C                   END                                                                  216556
049800200616      *                                                                                       216556
049900200616     C     @NoTax        IFEQ      'Y'
050000200616
050100200616     C                   EVAL      Wk_TASO = 0
050200200616     C                   EVAL      Wk_TAUS = 0
050300200616     C                   EVAL      Wk_TASR = 0
050400200616     C***********        EVAL      Wk_DAMT = 0                                  186051
050500200616     C                   EVAL      Wk_DAMT = In_DAMT                            186051
050600200616      *
050700200616      ** If Position Settlement is for Customer Position then
050800200616      ** find out what depot the holding is at.
050900200616      *
051000200616     C**********         EVAL      LC_CDPT = 0                                                CSD027
051100200616     C                   EVAL      LC_CDPT = *BLANKS                                          CSD027
051200200616     C                   IF        In_CTYP = 'C'
051300200616     C     CdepsPKey     CHAIN     CDEPS                              30
051400200616     C**********         IF        LC_CDPT <> 0                                               CSD027
051500200616     C                   IF        LC_CDPT <> *BLANKS                                         CSD027
051600200616     C                   MOVE      LC_CDPT       Wk_DEPT
051700200616     C                   ENDIF
051800200616     C                   ENDIF
051900200616     C**********         IF        LC_CDPT = 0                                                CSD027
052000200616     C                   IF        LC_CDPT = *BLANKS                                          CSD027
052100200616     C                   MOVE      *BLANKS       Wk_DEPT
052200200616     C                   ENDIF
052300200616
052400200616     C                   EVAL      Wk_RPCD = WHRPCD                             185748
052500200616     C                   EXSR      SRWrtOrUpd
052600200616     C                   ENDIF
052700200616      *
052800200616      ** If withholding Tax needs to be applied and Documentation status
052900200616      ** is not equal to 'I', then calculte tax for single customer
053000200616      ** Else calculate tax for Intermediary.
053100200616      *
053200200616     C     @NoTax        IFEQ      'N'
053300200616
053400200616     C                   IF        WHDCRC <> 'I'
053500200616     C                   EXSR      SRSingleRec
053600200616
053700200616     C                   ELSE
053800200616     C                   EXSR      SRInter
053900200616     C                   ENDIF
054000200616
054100200616     C                   ENDIF
054200200616
054300200616     C                   ENDSR
054400200616      *****************************************************************
054500200616      /EJECT
054600200616      *****************************************************************
054700200616      *                                                               *
054800200616      * SRCustInfo - Get Customer withholding Tax details             *
054900200616      *                                                               *
055000200616      * Called by: SRCust                                             *
055100200616      *                                                               *
055200200616      * Calls:                                                        *
055300200616      *                                                               *
055400200616      *****************************************************************
055500200616
055600200616     C     SRCustInfo    BEGSR
055700200616
055800200616      ** Only Process this part if not call from Subroutine SRICInfo            186001
055900200616      *                                                                         186001
056000200616     C                   IF        @CallFrom <> 'U'                             186001
056100200616                                                                                186001
056200200616     C                   IF        In_CTYP = 'C'
056300200616     C                   EVAL      @CTotAmt = In_PAMD
056400200616     C                   EVAL      @CTotNoml = In_PNMP
056500200616     C                   EVAL      @CTotChg = In_PCHA
056600200616     C                   EVAL      @CTotComm = In_PCAM
056700200616     C                   ELSE
056800200616     C                   EVAL      @CTotNoml = Wk_PNMP
056900200616     C                   EVAL      @CTotAmt = In_PAMD * @CTotNoml / In_PNMP
057000200616     C                   EVAL      @CTotChg = In_PCHA * @CTotNoml / In_PNMP
057100200616     C                   EVAL      @CTotComm = In_PCAM * @CTotNoml / In_PNMP
057200200616     C                   ENDIF
057300200616      *
057400200616      ** If Position Settlement record is for Maturity Event, and the
057500200616      ** OID indicator on security details is equal to 'Y'
057600200616      ** or OID indicator is equal to 'S' (Short term security)                 185292
057700200616      ** then need to calculate the cost for the holding.
057800200616      *
057900200616     C*************      IF        In_PEVT = 'MT' and SE_OIDI = 'Y'             185292
058000200616     C                   EVAL      @Discount = 0                                185292
058100200616     C                   EVAL      In_DAMT = 0                                  185292
058200200616     C                   IF        In_PEVT = 'MT'                               185292
058300200616     C                   IF        SE_OIDI = 'Y' or SE_OIDI = 'S'               185292
058400200616     C                   MOVE      @Cust         @CustNo
058500200616     C     CposnKey      CHAIN     CPOSN                              25
058600200616     C                   IF        *IN25 = '1'
058700200616     C                   EVAL      CP_CSPT = 0
058800200616     C                   EVAL      CP_CSNT = 1
058900200616     C                   ENDIF
059000200616                                                                                185731
059100200616     C                   IF        CP_CSNT = 0                                  185731
059200200616     C                   EVAL      @Cost = 0                                    185731
059300200616     C                   ELSE                                                   185731
059400200616     C                   EVAL      @Cost = @CTotNoml * CP_CSPT / CP_CSNT
059500200616     C                   ENDIF                                                  185731
059600200616     C                   EVAL      @Discount = @CTotAmt -  @Cost
059700200616     C                   EVAL      In_DAMT = @Discount
059800200616
059900200616     C*************      ELSE
060000200616     C*************      EVAL      In_DAMT = 0
060100200616     C                   ENDIF
060200200616     C                   ENDIF                                                  185292
060300200616
060400200616     C                   ENDIF
060500200616      *
060600200616      ** Get Customer Country of residence
060700200616      *
060800200616     C*******************CALLB     'AOCUSTR0'                                                 229342
060900200616     C                   CALLB     'AOCUSTR1'                                                 229342
061000200616     C                   PARM      *BLANKS       @RTCD             7
061100200616     C                   PARM      '*KEY   '     @OPTN             7
061200200616     C                   PARM      @Cust         @KEY1            10
061300200616     C                   PARM                    @KYST             7
061400200616     C*****SDCUST        PARM      SDCUST        DSSDY                                        229342
061500200616     C     SDCUST        PARM      SDCUST        DSLDY                                        229342
061600200616      *
061700200616      ** If Customer detail not found, issue DB error.
061800200616      *
061900200616     C     @RTCD         IFNE      *BLANKS
062000200616     C     BBCLST        ANDNE     'Y'                                                        229342
062100200616     C     *LOCK         IN        LDA
062200200616     C                   EVAL      DBFILE =  'SDCUSTPD'
062300200616     C                   EVAL      DBKEY  =  @KEY1
062400200616     C                   EVAL      DBPGM  =  PSProcPgm
062500200616     C                   EVAL      DBASE  =  104
062600200616     C                   EVAL      DBMOD  =  PSProcMod
062700200616     C                   EVAL      DBPROC =  'SRCustInfo'
062800200616     C                   OUT       LDA
062900200616     C                   EXSR      *PSSR
063000200616     C                   ENDIF
063100200616      *
063200200616      ** Initialise work fields
063300200616      *
063400200616     C                   EVAL      @NoTax = 'N'
063500200616     C                   EVAL      @NoDoc = 'N'
063600200616     C                   EVAL      @SetExCode = 'N'
063700200616      *
063800200616      ** Initialise Exemption Code, Beneficial Number, and Tax Basket.
063900200616      *
064000200616     C                   EVAL      Wk_EXCD = '  '
064100200616     C                   EVAL      Wk_BNFO = *BLANKS
064200200616     C                   EVAL      Wk_TXBS = '  '
064300200616     C                   EVAL      Wk_TXBN = '  '                                             187962
064400200616      *
064500200616      ** Get withholding tax information for
064600200616      ** Country of Treaty, Investment type and location.
064700200616      *
064800200616     C                   MOVE      SE_SITP       @SITP
064900200616     C                   EVAL      @Loc = BBCOLC
065000200616
065100200616     C     Wt_TreatKy    CHAIN     SDWHTTL0                           31
065200200616      *
065300200616      ** If no record found, then check if there is a record for general use
065400200616      ** Country of Treaty,  *BLANK (Investment) and location.
065500200616      *
065600200616     C     *IN31         IFEQ      '1'
065700200616     C                   MOVE      '0'           *IN31
065800200616     C                   MOVE      '   '         @SITP
065900200616     C     Wt_TreatKy    CHAIN     SDWHTTL0                           31
066000200616     C                   ENDIF
066100200616      *
066200200616      ** If no record found, then check if there is a record for general use
066300200616      ** Country of Treaty, Investment type and *BLANK (Location)
066400200616      ** to get default tax basket for No Documentation.
066500200616      *
066600200616     C     *IN31         IFEQ      '1'
066700200616     C                   MOVE      '0'           *IN31
066800200616     C                   MOVE      SE_SITP       @SITP
066900200616     C                   EVAL      @NoDoc = 'Y'
067000200616     C     Wt_TreatPky   CHAIN     SDWHTTL0                           31
067100200616     C                   ENDIF
067200200616      *
067300200616      ** If no record found, then check if there is a record for general use
067400200616      ** Country of Treaty, *BLANK (Investment) and *BLANK (Location)
067500200616      ** to get default tax basket for No Documentation.
067600200616      *
067700200616     C     *IN31         IFEQ      '1'
067800200616     C                   MOVE      '0'           *IN31
067900200616     C                   MOVE      *BLANKS       @SITP
068000200616     C                   EVAL      @NoDoc = 'Y'
068100200616     C     Wt_TreatPky   CHAIN     SDWHTTL0                           31
068200200616     C                   ENDIF
068300200616      *
068400200616      ** If no record found, then Data Base Error
068500200616      *
068600200616     C     *IN31         IFEQ      '1'
068700200616     C     *LOCK         IN        LDA
068800200616     C                   EVAL      DBFILE =  'SDWHTTPD'
068900200616     C                   EVAL      DBKEY  =  SE_CRTT + SE_SITP + BBCOLC
069000200616     C                   EVAL      DBPGM  =  PSProcPgm
069100200616     C                   EVAL      DBASE  =  105
069200200616     C                   EVAL      DBMOD  =  PSProcMod
069300200616     C                   EVAL      DBPROC =  'SRCustInfo'
069400200616     C                   OUT       LDA
069500200616     C                   EXSR      *PSSR
069600200616     C                   ENDIF
069700200616      *
069800200616      ** Save Customer No documentation tax basket
069900200616      *
070000200616     C                   EVAL      @CustNDTXBS = WTDBDC
070100200616      *
070200200616      ** Get Customer Withholding Tax detail
070300200616      *
070400200616     C     Wt_CustKey    CHAIN     SDWTCSL1                           32
070500200616      *
070600200616      ** If no record found, then treat the customer as no documentation
070700200616      ** and donot need to set up exemtion code.
070800200616      *
070900200616     C     *IN32         IFEQ      '1'
071000200616     C                   EVAL      @NoDoc = 'Y'
071100200616     C                   EVAL      @SetExCode = 'Y'
071200200616     C                   ELSE
071300200616      *                                                                                       187745
071400200616      ** But if tax basket from Customer details is not blank, revert                         187745
071500200616      ** to previous logic: dont treat the customer as no documentation                       187745
071600200616      *                                                                                       187745
071700200616     C                   IF        @NoDoc = 'Y'                                               187745
071800200616     C                   IF        WHTXBS <> *Blank AND WHDCRC <> 'E'                         187745
071900200616     C                             OR WHDCRC = 'E' AND WHEXCD <> *Blank                       187745
072000200616     C                   EVAL      @NoDoc = 'N'                                               187745
072100200616     C                   ENDIF                                                                187745
072200200616     C                   ENDIF                                                                187745
072300200616      *
072400200616      ** Check if Customer is exempted from Tax.
072500200616      *
072600200616      ** If security is interest bearing, ie processing type is 1,3,5,6,8,9
072700200616      ** and allow for portfolio income exemption is 'Y' and customer
072800200616      ** documentation is 'L'or 'Y', then it is exempt from Tax.
072900200616      *
073000200616     C                   IF        SE_APIE = 'Y'
073100200616
073200200616     C                   IF        WHDCRC = 'L' or WHDCRC = 'Y'
073300200616
073400200616     C                   IF        PROT = '1' OR PROT = '3' or PROT = '5'
073500200616     C                             OR PROT = '6' OR PROT = '8' or PROT = '9'
073600200616     C**********         EVAL      @NoTax = 'Y'                                               216559
073700200616      *
073800200616      ** Tax basket = Default Portfolio Exemption Tax Basket
073900200616      *
074000200616     C                   EVAL      Wk_TXBS = WTPFEX
074100200616     C                   IF        Wk_TXBS = *BLANK                                           187962
074200200616     C                   EVAL      Wk_TXBN = *BLANKS                                          187962
074300200616     C                   ENDIF                                                                187962
074400200616      *
074500200616      ** Set up Exemption Code
074600200616      ** If exemption code on customer detail = *BLANK then use exemption
074700200616      ** code from treaty detail.
074800200616      *
074900200616     C                   EVAL      @SetExCode = 'Y'
075000200616     C                   IF        WHEXCD <> *BLANK
075100200616     C                   EVAL      WK_EXCD = WHEXCD
075200200616     C                   ELSE
075300200616     C                   EVAL      Wk_EXCD = WTEXPI
075400200616     C                   ENDIF
075500200616     C                   ENDIF
075600200616
075700200616     C                   ENDIF
075800200616     C                   ENDIF
075900200616      *
076000200616      ** If the customer documentation is 'E' then the customer is exempted
076100200616      ** from Tax.
076200200616      *
076300200616     C                   IF        WHDCRC = 'E'
076400200616     C                   EVAL      @NoTax = 'Y'
076500200616      *
076600200616      ** Tax basket = Customer Tax Basket
076700200616      *
076800200616     C                   EVAL      Wk_TXBS = WHTXBS
076900200616     C                   IF        Wk_TXBS = *BLANK                                           187962
077000200616     C                   EVAL      Wk_TXBN = *BLANKS                                          187962
077100200616     C                   ENDIF                                                                187962
077200200616      *
077300200616      ** Set up Exemption Code
077400200616      ** If exemption code on customer detail = *BLANK then use exemption
077500200616      ** code from treaty detail.
077600200616      *
077700200616     C                   EVAL      @SetExCode = 'Y'
077800200616
077900200616     C                   IF        WHEXCD <> *BLANKS
078000200616     C                   EVAL      Wk_EXCD = WHEXCD
078100200616     C                   ELSE
078200200616     C                   EVAL      Wk_EXCD = WTEXCD
078300200616     C                   ENDIF
078400200616
078500200616     C                   ENDIF
078600200616      *                                                                         186303
078700200616      ** If OID = 'S', event = 'MT' and Documentation status is not 'U'         186303
078800200616      ** and is not 'N' then no tax will be calculated.                         186303
078900200616      *                                                                         186303
079000200616     C                   IF        WHDCRC <> 'U' AND WHDCRC <> 'N' AND          186303
079100200616     C                             WHDCRC <> 'I' AND                            186303
079200200616     C                             In_PEVT = 'MT' AND SE_OIDI = 'S'             186303
079300200616     C                   EVAL      @NoTax = 'Y'                                 186303
079400200616     C                   EVAL      Wk_EXCD = *BLANK                             186303
079500200616     C                   EVAL      Wk_TXBS = *BLANK                             186303
079600200616     C                   EVAL      Wk_TXBN = *BLANK                             186303
079700200616     C                   EVAL      Wk_DAMT = 0                                  186303
079800200616     C                   EVAL      @SetExCode = 'Y'                             186303
079900200616     C                   ENDIF                                                  186303
080000200616
080100200616     C                   ENDIF
080200200616
080300200616     C                   ENDSR
080400200616      *****************************************************************
080500200616      /EJECT
080600200616      *****************************************************************
080700200616      *                                                               *
080800200616      * SRSingleRec - Process withholding Tax for single individual   *
080900200616      *               Customer.                                       *
081000200616      *                                                               *
081100200616      * Called by: SRCust                                             *
081200200616      *                                                               *
081300200616      * Calls: SRCalTax, SRWrtOrUpd                                   *
081400200616      *                                                               *
081500200616      *****************************************************************
081600200616
081700200616     C     SRSingleRec   BEGSR
081800200616      *
081900200616      ** Get Tax rate for Customer with no documentation.
082000200616      *
082100200616     C                   IF        WHDCRC = 'N' or @NoDoc = 'Y'
082200200616
082300200616     C                   EVAL      @TaxBasket = WTDBDC
082400200616      *
082500200616      ** If position settlement is for Maturity and OID indicator is 'S'        185292
082600200616      ** then use Backup withholding tax rate.                                  185292
082700200616      *                                                                         185292
082800200616     C                   EVAL      Wk_EXCD = ' '                                185292
082900200616     C                   EVAL      @SetExCode = 'Y'                             185292
083000200616     C                   IF        In_PEVT = 'MT' and SE_OIDI = 'S'             185292
083100200616     C                   EVAL      @TaxBasket = WTDRBW                          185292
083200200616     C                   ENDIF                                                  185292
083300200616
083400200616     C                   ELSE
083500200616      *
083600200616      ** Get Tax rate for Undeclared Customer - Backup withholding tax rate
083700200616      *
083800200616     C                   IF        WHDCRC = 'U'
083900200616     C                   EVAL      Wk_EXCD = ' '                                185292
084000200616     C                   EVAL      @SetExCode = 'Y'                             185292
084100200616     C                   EVAL      @TaxBasket = WTDRBW
084200200616     C                   ELSE
084300200616      *
084400200616      ** Get Tax rate for Customer with completed documentation
084500200616      ** If Tax basket on Customer detail = *BLANK then use tax basket from
084600200616      ** treaty detail.
084700200616      *
084800200616     C**********         IF        SE_APIE = 'N'                                       216559 218116
084900200616     C                   IF        SE_APIE = ' '                                              218116
085000200616     C                             OR Wk_TXBS = *BLANKS                                       233071
085100200616     C                   IF        WHTXBS <> *BLANKS
085200200616     C                   EVAL      @TaxBasket = WHTXBS
085300200616     C                   ELSE
085400200616     C                   EVAL      @TaxBasket = WTTXBS
085500200616     C                   ENDIF
085600200616     C                   ELSE                                                                 216559
085700200616     C                   EVAL      @TaxBasket = Wk_TXBS                                       216559
085800200616     C                   END                                                                  216559
085900200616      *
086000200616      ** Set up Exemption Code
086100200616      ** If Exemption Code from customer is *BLANK then use exemption
086200200616      ** Code from the treaty
086300200616      *
086400200616     C                   If        @SetExCode = 'N'
086500200616     C                   If        @TaxBasket = WHTXBS or WHEXCD <> *BLANKS
086600200616     C                   EVAL      Wk_EXCD = WHEXCD
086700200616     C                   ELSE
086800200616     C                   EVAL      Wk_EXCD = WTEXCD
086900200616     C                   ENDIF
087000200616     C                   EVAL      @SetExCode = 'Y'
087100200616     C                   ENDIF
087200200616
087300200616     C                   ENDIF
087400200616
087500200616     C                   ENDIF
087600200616      *
087700200616      ** If Position Settlement is for Customer Position then
087800200616      ** find out what depot the holding is at.
087900200616      *
088000200616     C**********         EVAL      LC_CDPT = 0                                                CSD027
088100200616     C                   EVAL      LC_CDPT = *BLANKS                                          CSD027
088200200616     C                   IF        In_CTYP = 'C'
088300200616     C     CdepsPKey     CHAIN     CDEPS                              30
088400200616     C**********         IF        LC_CDPT <> 0                                               CSD027
088500200616     C                   IF        LC_CDPT <> *BLANKS                                         CSD027
088600200616     C                   MOVE      LC_CDPT       Wk_DEPT
088700200616     C                   ENDIF
088800200616     C                   ENDIF
088900200616     C**********         IF        LC_CDPT = 0                                                CSD027
089000200616     C                   IF        LC_CDPT = *BLANKS                                          CSD027
089100200616     C                   MOVE      *BLANKS       Wk_DEPT
089200200616     C                   ENDIF
089300200616      *
089400200616      ** Set up Nominal and charges fields
089500200616      *
089600200616     C     COALRF        IFEQ      *BLANKS                                                    215575
089700200616     C     IN_CTYP       OREQ      'C'                                                        215575
089800200616     C                   EVAL      Wk_PNMP = @CTotNoml
089900200616
090000200616     C                   EVAL      Wk_PAMD = @CTotAmt
090100200616     C                   END                                                                  215575
090200200616     C                   EVAL      Wk_PCHA = @CTotChg
090300200616     C                   EVAL      Wk_PCAM = @CTotComm
090400200616      *
090500200616      ** Calculate withholding Tax
090600200616      *
090700200616     C                   EXSR      SRCalTax
090800200616      *                                                                         186000
090900200616      ** Set Up TIN                                                             186000
091000200616      *                                                                         186000
091100200616     C                   EVAL      Wk_CTIN = WHTIN                              186000
091200200616      *
091300200616      ** Output to POSETD
091400200616      *
091500200616     C                   EVAL      Wk_RPCD = WHRPCD                             185748
091600200616     C                   EXSR      SRWrtOrUpd
091700200616
091800200616     C                   ENDSR
091900200616      *****************************************************************
092000200616      /EJECT
092100200616      *****************************************************************
092200200616      *                                                               *
092300200616      * SRCalTax - Get Tax Basket Information and Calculate Tax amount*
092400200616      *                                                               *
092500200616      * Called by: SRSingleRec, SRInter, SRNDIFF                      *
092600200616      *                                                               *
092700200616      * Calls:                                                        *
092800200616      *                                                               *
092900200616      *****************************************************************
093000200616
093100200616     C     SRCalTax      BEGSR
093200200616     C                   EVAL      @CountryTax = SE_CRTT
093300200616     C                   EVAL      @EffDate   = IN_PDUD
093400200616
093500200616     C                   CALL      'AOTXBSR0'
093600200616     C                   PARM                    @RtnCode          7
093700200616     C                   PARM      '*KEY   '     @OptionCode       7
093800200616     C                   PARM                    @CountryTax       2
093900200616     C                   PARM                    @TaxBasket        2
094000200616     C                   PARM                    @EffDate          5 0
094100200616     C                   PARM                    @RtNarr          15
094200200616     C                   PARM                    @RtTaxRate        6 4
094300200616
094400200616     C                   IF        @RtnCode <> *BLANKS
094500200616     C     *LOCK         IN        LDA
094600200616     C                   EVAL      DBFILE =  'AOTXBSR0'
094700200616     C                   EVAL      DBKEY  =  @CountryTax + @TaxBasket + @RtnCode
094800200616     C                   EVAL      DBPGM  =  PSProcPgm
094900200616     C                   EVAL      DBASE  =  106
095000200616     C                   EVAL      DBMOD  =  PSProcMod
095100200616     C                   EVAL      DBPROC =  'SRCalTax'
095200200616     C                   OUT       LDA
095300200616     C                   EXSR      *PSSR
095400200616     C                   ENDIF
095500200616      *
095600200616      ** If no Error, then Calculate Withholding Tax.
095700200616      *
095800200616     C                   IF        In_PEVT = 'MT'
095900200616     C                   EVAL      @WhingTax = @Discount * @RtTaxRate / 100
096000200616     C                   EVAL      Wk_DAMT = @Discount
096100200616     C                   ELSE
096200200616     C                   EVAL      @WhingTax = Wk_PAMD * @RtTaxRate / 100
096300200616     C                   EVAL      Wk_DAMT = 0
096400200616     C                   ENDIF
096500200616      *
096600200616      ** If Position is -ve, then no withholding tax
096700200616      *
096800200616     C                   IF        Wk_PNMP < 0
096900200616     C                   EVAL      @WhingTax = 0
097000200616     C                   EVAL      @TaxBasket = *BLANKS
097100200616     C                   EVAL      @RtNarr = *BLANKS
097200200616     C                   ENDIF
097300200616
097400200616     C                   IF        WTDTSU = 'S'
097500200616     C                   EVAL      Wk_TASO = @WhingTax
097600200616     C                   EVAL      Wk_TAUS = 0
097700200616     C                   ELSE
097800200616     C                   EVAL      Wk_TAUS = @WhingTax
097900200616     C                   EVAL      Wk_TASO = 0
098000200616     C                   ENDIF
098100200616
098200200616     C                   EVAL      Wk_TASR = 0
098300200616      *
098400200616      ** To ensure taht the output Tax basket is the tax basket used for
098500200616      ** the calucaltion of tax.
098600200616      *
098700200616     C                   EVAL      Wk_TXBS = @TaxBasket
098800200616     C                   EVAL      Wk_TXBN = @RtNarr
098900200616
099000200616     C                   ENDSR
099100200616      *****************************************************************
099200200616      /EJECT
099300200616      *****************************************************************
099400200616      *                                                               *
099500200616      * SRInter - Process Withholding Tax for Intermediary            *
099600200616      *                                                               *
099700200616      * Called by: SRCust                                             *
099800200616      *                                                               *
099900200616      * Calls: SRCalTax, SRWrtOrUpd, SRNDIFF                          *
100000200616      *                                                               *
100100200616      *****************************************************************
100200200616
100300200616     C     SRInter       BEGSR
100400200616      *
100500200616      ** Initialise cumulative fields
100600200616      *
100700200616     C                   EVAL      @AccAmtDue = 0
100800200616     C                   EVAL      @AccPosit = 0
100900200616     C                   EVAL      @AccCharge = 0
101000200616     C                   EVAL      @AccComm = 0
101100200616     C                   EVAL      @Rec_Found = 'N'
101200200616     C                   EVAL      @RoundingRec = 'N'
101300200616     C                   EVAL      Wk_DEPT = *BLANKS
101400200616      *
101500200616      ** set up Holding Depot for Intermediary Details
101600200616      *
101700200616     C                   IF        In_CTYP = 'C'
101800200616     C                   EVAL      @HoldingDept = *LOVAL
101900200616     C                   ELSE
102000200616     C                   MOVE      In_PCPY       @HoldingDept
102100200616     C                   END
102200200616      *
102300200616      ** Get beneficial Holding by reading Intermediary detail until EOF.
102400200616      *
102500200616
102600200616     C     InterMlkey    SETLL     SDINTCLL1                          34
102700200616
102800200616     C     *IN34         DOUEQ     '1'
102900200616
103000200616     C                   IF        In_CTYP = 'C'
103100200616     C     InterMCkey    READE     SDINTCLL1                              34
103200200616     C                   ELSE
103300200616     C     InterMlkey    READE     SDINTCLL1                              34
103400200616     C                   ENDIF
103500200616
103600200616     C                   IF        *IN34 = '0'
103700200616     C                             AND INTOTH <> 0                              185756
103800200616      *
103900200616      ** Initialise exemption code and tax basket for each beneficial owner
104000200616      *
104100200616     C                   EVAL      Wk_TXBS = '  '
104200200616     C                   EVAL      Wk_EXCD = '  '
104300200616     C                   EVAL      @SetExCode = 'N'
104400200616     C                   IF        In_CTYP = 'C'
104500200616     C                   MOVE      INDEPT        Wk_DEPT
104600200616     C                   ENDIF
104700200616      *
104800200616      ** Workout the total holding for the beneficial owner
104900200616      ** (If the total holding in the Intermediary Client details is equal
105000200616      ** to the total holding for the customer, then use the holding from
105100200616      ** file, else use the ratio between the total holding and the holding
105200200616      ** to caluclate the holding for the beneficial owner.)
105300200616      *
105400200616     C                   IF        @CTotNoml = INTOTH
105500200616     C                   EVAL      Wk_PNMP = INHLDN
105600200616     C                   ELSE
105700200616     C                   EVAL      Wk_PNMP = @CTotNoml * INHLDN / INTOTH
105800200616     C                   ENDIF
105900200616      *
106000200616      ** Workout the total amount due to the beneficial owner
106100200616      *
106200200616     C                   EVAL      Wk_PAMD = @CTotAmt * Wk_PNMP / @CTotNoml
106300200616
106400200616     C************       IF        In_PEVT = 'MT' and SE_OIDI = 'Y'             185292
106500200616     C                   IF        In_PEVT = 'MT'                               185292
106600200616     C                   IF        SE_OIDI = 'Y' OR SE_OIDI = 'S'               185292
106700200616     C                   EVAL      @Cost = Wk_PNMP * CP_CSPT / CP_CSNT
106800200616     C                   EVAL      @Discount = Wk_PAMD - @Cost
106900200616     C                   ENDIF
107000200616     C                   ENDIF                                                  185292
107100200616      *
107200200616      ** Set up Withholding Tax Basket
107300200616      *
107400200616     C                   EXSR      SRGetBenTax
107500200616      *                                                                         186237
107600200616     C                   IF        In_PEVT = 'MT'                               186237
107700200616     C                   EVAL      Wk_DAMT = @Discount                          186237
107800200616     C                   ELSE                                                   186237
107900200616     C                   EVAL      Wk_DAMT = 0                                  186237
108000200616     C                   ENDIF                                                  186237
108100200616      *
108200200616      ** Calucalte Withholding Tax
108300200616      *
108400200616     C                   IF        @NoTax = 'N'
108500200616     C                   EXSR      SRCalTax
108600200616     C                   ELSE                                                   186303
108700200616     C                   EVAL      Wk_TASO = 0                                  186303
108800200616     C                   EVAL      Wk_TAUS = 0                                  186303
108900200616     C                   EVAL      Wk_TASR = 0                                  186303
109000200616     C                   EVAL      Wk_TXBN = @RtNarr                            186237
109100200616     C                   ENDIF
109200200616      *
109300200616      ** Set up fields for position settlement
109400200616      *
109500200616     C***********        IF        WHINTS <> 'QI' AND WHINTS <> 'WA'            186050
109600200616     C                   EVAL      Wk_BNFO = INBONO
109700200616     C                   EVAL      Wk_CTIN = INCSTN
109800200616     C***********        ELSE                                                   186050
109900200616     C***********        EVAL      Wk_BNFO = *BLANKS                            186050
110000200616     C***********        EVAL      Wk_CTIN = *BLANKS                            186050
110100200616     C***********        ENDIF                                                  186050
110200200616
110300200616     C                   EXSR      SRWrtOrUpd
110400200616
110500200616     C                   IF        Wk_PNMP <> 0
110600200616     C                   EVAL      @AccAmtDue = @AccAmtDue + Wk_PAMD
110700200616     C                   EVAL      @AccPosit = @AccPosit + Wk_PNMP
110800200616     C                   EVAL      @AccCharge = @AccCharge + Wk_PCHA
110900200616     C                   EVAL      @AccComm = @AccComm + Wk_PCAM
111000200616     C                   ENDIF
111100200616
111200200616     C                   ENDIF
111300200616     C                   ENDDO
111400200616      *
111500200616      ** Check for rounding error
111600200616      *
111700200616     C                   EVAL      @NomlDiff = @CTotNoml - @AccPosit
111800200616     C                   EVAL      @AmtDiff  = @CTotAmt - @AccAmtDue
111900200616     C                   EVAL      @ChgDiff  = @CTotChg - @AccCharge
112000200616     C                   EVAL      @CommDiff = @CTotComm - @AccComm
112100200616      *
112200200616      ** Output a new position settlement record if Nominal is not the
112300200616      ** same as the total nominal and it will be taxed as it is without
112400200616      ** any documentation.
112500200616      *
112600200616     C                   IF        @NomlDiff <> 0
112700200616     C                   EXSR      SRNDIFF
112800200616     C                   END
112900200616
113000200616     C                   IF        @AmtDiff <> 0 or
113100200616     C                             @ChgDiff <> 0 or @CommDiff <> 0
113200200616      *
113300200616      ** Get position settlement record to update rounding
113400200616      ** If Record for rounding is defined then get the position settlement
113500200616      ** using the last key.
113600200616      *
113700200616     C                   IF        @Rec_Found = 'Y'
113800200616     C                   EVAL      Wk_PBCA = Lt_PBCA
113900200616     C                   EVAL      Wk_PSSH = Lt_PSSH
114000200616     C                   EVAL      Wk_PCPY = Lt_PCPY
114100200616     C                   EVAL      Wk_PDUD = Lt_PDUD
114200200616     C                   EVAL      Wk_PEVT = Lt_PEVT
114300200616     C                   EVAL      Wk_TNLU = Lt_TNLU
114400200616     C                   EVAL      Wk_TXBS = Lt_TXBS
114500200616     C                   EVAL      Wk_EXCD = Lt_EXCD
114600200616     C                   EVAL      Wk_BNFO = Lt_BNFO
114700200616     C                   ENDIF
114800200616      *                                                                         185604
114900200616      ** Initialise work fields                                                 185604
115000200616      *                                                                         185604
115100200616     C                   EVAL      Wk_PNMP = 0                                  185604
115200200616     C                   EVAL      Wk_TASO = 0                                  185604
115300200616     C                   EVAL      Wk_TAUS = 0                                  185604
115400200616     C                   EVAL      Wk_PSAT = 0                                  185604
115500200616     C                   EVAL      Wk_DAMT = 0                                  185604
115600200616     C                   EVAL      Upd_Rounding = 'Y'                           185604
115700200616      *
115800200616      ** Else add the rounding to the last position settlement record.
115900200616      *
116000200616
116100200616     C                   EVAL      Wk_PAMD = @AmtDiff
116200200616     C*******************EVAL      Nw_PCHA = @ChgDiff                           185604
116300200616     C*******************EVAL      Nw_PCAM = @CommDiff                          185604
116400200616     C                   EVAL      Wk_PCHA = @ChgDiff                           185604
116500200616     C                   EVAL      Wk_PCAM = @CommDiff                          185604
116600200616
116700200616     C                   EXSR      SRWrtOrUpd
116800200616
116900200616     C                   EVAL      Upd_Rounding = 'N'                           185604
117000200616
117100200616     C                   ENDIF
117200200616
117300200616     C                   ENDSR
117400200616      *****************************************************************
117500200616      /EJECT
117600200616      *****************************************************************
117700200616      *                                                               *
117800200616      * SRGetBenTax - Get Tax Basket for Beneficial Owner             *
117900200616      *                                                               *
118000200616      * Called by: SRInter                                            *
118100200616      *                                                               *
118200200616      * Calls:                                                        *
118300200616      *                                                               *
118400200616      *****************************************************************
118500200616
118600200616     C     SRGetBenTax   BEGSR
118700200616      *
118800200616      ** Get Benefical Owners details - If Beneficial Owner Number is not
118900200616      ** equal to *BLANK
119000200616      *
119100200616     C                   IF        INBONO <> *BLANK
119200200616
119300200616     C                   EVAL      @INCNUM = INCNUM
119400200616     C                   EVAL      @INBONO = INBONO
119500200616     C                   EVAL      @HoldingDept = INDEPT
119600200616     C                   EVAL      @BenDept = @HoldingDept                      185936
119700200616     C     SDBNFOKey     CHAIN     SDBNFOL1                           33
119800200616     C                   IF        *IN33 = '1'
119900200616     C**************     EVAL      @Holdingdept = *BLANKS
120000200616     C                   EVAL      @BenDept = *BLANKS                           185936
120100200616     C     SDBNFOKey     CHAIN     SDBNFOL1                           33
120200200616      *
120300200616      ** If no record found, then Database error
120400200616      *
120500200616     C     *IN31         IFEQ      '1'
120600200616     C     *LOCK         IN        LDA
120700200616     C                   EVAL      DBFILE =  'SDBNFOPD'
120800200616     C                   EVAL      DBKEY  =  SE_CRTT + INCNUM + INBONO
120900200616     C                   EVAL      DBPGM  =  PSProcPgm
121000200616     C                   EVAL      DBASE  =  110
121100200616     C                   EVAL      DBMOD  =  PSProcMod
121200200616     C                   EVAL      DBPROC =  'SRGetBenTax'
121300200616     C                   OUT       LDA
121400200616     C                   EXSR      *PSSR
121500200616     C                   ENDIF
121600200616     C                   ENDIF
121700200616
121800200616     C                   ELSE
121900200616     C                   MOVE      '1'           *IN33
122000200616
122100200616     C                   ENDIF
122200200616      *
122300200616      ** Initialise Exemption Code, Beneficial Number, and Tax Basket.
122400200616      *
122500200616     C                   EVAL      @RoundingRec = 'N'
122600200616     C***********        EVAL      Wk_RPCD = *BLANKS                            185748
122700200616     C                   EVAL      @NoDoc = 'N'
122800200616     C                   EVAL      @NoTax = 'N'
122900200616      *
123000200616      ** If Beneficial Owner record found
123100200616      *
123200200616     C                   IF        *IN33 = '0'
123300200616
123400200616     C                   IF        BNDFRD = 'Y'
123500200616     C                   EVAL      @RoundingRec = 'Y'
123600200616     C                   ENDIF
123700200616      *
123800200616      ** Set Up Recipient Code for Beneficial Owner
123900200616      ** (Only if record found and the position settlement is for
124000200616      **  Customer).
124100200616      *
124200200616     C                   IF        In_CTYP = 'C'
124300200616     C                   EVAL      Wk_RPCD = BNRPCD
124400200616     C                   ENDIF
124500200616      *
124600200616      ** Get withholding tax information for
124700200616      ** Country of Treaty, Investment type and location.
124800200616      ** with location from the benefical owner detail if not *BLANK
124900200616      *
125000200616     C                   IF        BNCTRS <> *BLANKS
125100200616     C                   MOVE      SE_SITP       @SITP
125200200616     C                   EVAL      @Loc = BNCTRS
125300200616
125400200616     C     Wt_TreatKy    CHAIN     SDWHTTL0                           31
125500200616      *
125600200616      ** If no record found, then check if there is a record for general use
125700200616      ** Country of Treaty,  *BLANK (Investment) and location.
125800200616      *
125900200616     C     *IN31         IFEQ      '1'
126000200616     C                   MOVE      '0'           *IN31
126100200616     C                   MOVE      '   '         @SITP
126200200616     C     Wt_TreatKy    CHAIN     SDWHTTL0                           31
126300200616     C                   ENDIF
126400200616      *
126500200616      ** If no record found, then check if there is a record for general use
126600200616      ** Country of Treaty, Investment type and *BLANK (Location)
126700200616      ** for default tax basket for no documentation.
126800200616      *
126900200616     C     *IN31         IFEQ      '1'
127000200616     C                   MOVE      '0'           *IN31
127100200616     C                   MOVE      SE_SITP       @SITP
127200200616     C                   EVAL      @NoDoc = 'Y'
127300200616     C     Wt_TreatPky   CHAIN     SDWHTTL0                           31
127400200616     C                   ENDIF
127500200616      *
127600200616      ** If no record found, then check if there is a record for general use
127700200616      ** Country of Treaty, *BLANKS (Investment) and *BLANK (Location)
127800200616      ** for default tax basket for no documentation.
127900200616      *
128000200616     C     *IN31         IFEQ      '1'
128100200616     C                   MOVE      '0'           *IN31
128200200616     C                   MOVE      *BLANKS       @SITP
128300200616     C                   EVAL      @NoDoc = 'Y'
128400200616     C     Wt_TreatPky   CHAIN     SDWHTTL0                           31
128500200616     C                   ENDIF
128600200616      *
128700200616      ** If no record found, then DBase error.
128800200616      *
128900200616     C     *IN31         IFEQ      '1'
129000200616     C     *LOCK         IN        LDA
129100200616     C                   EVAL      DBFILE =  'SDWHTTPD'
129200200616     C                   EVAL      DBKEY  =  SE_CRTT + SE_SITP + BNCTRS
129300200616     C                   EVAL      DBPGM  =  PSProcPgm
129400200616     C                   EVAL      DBASE  =  107
129500200616     C                   EVAL      DBMOD  =  PSProcMod
129600200616     C                   EVAL      DBPROC =  'SRGetBenTax'
129700200616     C                   OUT       LDA
129800200616     C                   EXSR      *PSSR
129900200616     C                   ENDIF
130000200616     C                   ENDIF
130100200616      *                                                                                       187745
130200200616      ** But if tax basket from Beneficial owner details is not blank,                        187745
130300200616      ** dont treat the beneficial owner as no documentation                                  187745
130400200616      *                                                                                       187745
130500200616     C                   IF        @NoDoc = 'Y'                                               187745
130600200616     C                   IF        BNTXBS <> *Blank AND BNDCRC <> 'E'                         187745
130700200616     C                             OR BNDCRC = 'E' AND BNEXCD <> *Blank                       187745
130800200616     C                   EVAL      @NoDoc = 'N'                                               187745
130900200616     C                   ENDIF                                                                187745
131000200616     C                   ENDIF                                                                187745
131100200616      *
131200200616      ** Check if Customer is exempted from Tax.
131300200616      *
131400200616      ** If security is interest bearing, ie processing type is 1,3,5,6,8,9
131500200616      ** and allow for portfolio income exemption is 'Y' and customer
131600200616      ** documentation is 'L'or 'Y', then it is exempt from Tax.
131700200616      *
131800200616     C                   IF        SE_APIE = 'Y'
131900200616
132000200616     C                   IF        BNDCRC = 'L' or BNDCRC = 'Y'
132100200616
132200200616     C                   IF        PROT = '1' OR PROT = '3' or PROT = '5'
132300200616     C                             OR PROT = '6' OR PROT = '8' or PROT = '9'
132400200616
132500200616     C                   EVAL      @NoTax = 'Y'
132600200616      *
132700200616      ** Tax basket = Default Portfolio Exemption Tax Basket
132800200616      *
132900200616     C                   EVAL      Wk_TXBS = WTPFEX
133000200616      *
133100200616      ** Set up Exemption Code
133200200616      ** If exemption code on customer detail = *BLANK then use exemption
133300200616      ** code from treaty detail.
133400200616      *
133500200616     C                   EVAL      @SetExCode = 'Y'
133600200616     C                   IF        BNEXCD <> *BLANK
133700200616     C                   EVAL      WK_EXCD = BNEXCD
133800200616     C                   ELSE
133900200616     C                   EVAL      Wk_EXCD = WTEXPI
134000200616     C                   ENDIF
134100200616     C                   ENDIF
134200200616
134300200616     C                   ENDIF
134400200616     C                   ENDIF
134500200616      *
134600200616      ** If the customer documentation is 'E' then the customer is exempted
134700200616      ** from Tax.
134800200616      *
134900200616     C                   IF        BNDCRC = 'E'
135000200616     C                   EVAL      @NoTax = 'Y'
135100200616      *
135200200616      ** Tax basket = Customer Tax Basket
135300200616      *
135400200616     C                   EVAL      Wk_TXBS = BNTXBS
135500200616     C                   IF        Wk_TXBS = *BLANK                                           187962
135600200616     C                   EVAL      Wk_TXBN = *BLANKS                                          187962
135700200616     C                   ENDIF                                                                187962
135800200616      *
135900200616      ** Set up Exemption Code
136000200616      ** If exemption code on customer detail = *BLANK then use exemption
136100200616      ** code from treaty detail.
136200200616      *
136300200616     C                   EVAL      @SetExCode = 'Y'
136400200616
136500200616     C                   IF        BNEXCD <> *BLANKS
136600200616     C                   EVAL      Wk_EXCD = BNEXCD
136700200616     C                   ELSE
136800200616     C                   EVAL      Wk_EXCD = WTEXCD
136900200616     C                   ENDIF
137000200616
137100200616     C                   ENDIF
137200200616      *                                                                         186303
137300200616      ** If OID = 'S', event = 'MT' and Documentation status is not 'U'         186303
137400200616      ** and is not 'N' then no tax will be calculated.                         186303
137500200616      *                                                                         186303
137600200616     C                   IF        BNDCRC <> 'U' AND BNDCRC <> 'N' AND          186303
137700200616     C                             In_PEVT = 'MT' AND SE_OIDI = 'S'             186303
137800200616     C                   EVAL      @NoTax = 'Y'                                 186303
137900200616     C                   EVAL      Wk_EXCD = *BLANK                             186303
138000200616     C                   EVAL      Wk_TXBS = *BLANK                             186303
138100200616     C                   EVAL      Wk_TXBN = *BLANK                             186303
138200200616     C                   EVAL      Wk_DAMT = 0                                  186303
138300200616     C                   EVAL      @SetExCode = 'Y'                             186303
138400200616     C                   ENDIF                                                  186303
138500200616
138600200616      *                                                                         186303
138700200616      ** Get Tax Basket if tax calucaltion is needed                            186303
138800200616      *                                                                         186303
138900200616     C                   IF        @NoTax = 'N'                                 186303
139000200616      *
139100200616      ** Get Tax rate for Customer with no documentation.
139200200616      *
139300200616     C                   IF        BNDCRC = 'N' or @NoDoc = 'Y'
139400200616
139500200616     C                   EVAL      @TaxBasket = WTDBDC
139600200616      *                                                                         185292
139700200616      ** If position settlement is for Maturity and OID indicator is 'S'        185292
139800200616      ** then use Backup withholding tax rate.                                  185292
139900200616      *                                                                         185292
140000200616     C                   EVAL      Wk_EXCD = ' '                                185292
140100200616     C                   EVAL      @SetExCode = 'Y'                             185292
140200200616     C                   IF        In_PEVT = 'MT' and SE_OIDI = 'S'             185292
140300200616     C                   EVAL      @TaxBasket = WTDRBW                          185292
140400200616     C                   ENDIF                                                  185292
140500200616
140600200616     C                   ELSE
140700200616      *
140800200616      ** Get Tax rate for Undeclared Customer - Backup withholding tax rate
140900200616      *
141000200616     C                   IF        BNDCRC = 'U'
141100200616     C                   EVAL      Wk_EXCD = ' '                                185292
141200200616     C                   EVAL      @SetExCode = 'Y'                             185292
141300200616     C                   EVAL      @TaxBasket = WTDRBW
141400200616     C                   ELSE
141500200616      *
141600200616      ** Get Tax rate for Customer with completed documentation
141700200616      ** If Tax basket on Customer detail = *BLANK then use tax basket from
141800200616      ** treaty detail.
141900200616      *
142000200616     C                   IF        INTXBS <> *BLANKS
142100200616     C                   EVAL      @TaxBasket = INTXBS
142200200616     C                   ELSE
142300200616     C                   IF        BNTXBS <> *BLANKS
142400200616     C                   EVAL      @TaxBasket = BNTXBS
142500200616     C                   ELSE
142600200616     C                   EVAL      @TaxBasket = WTTXBS
142700200616     C                   ENDIF
142800200616     C                   ENDIF
142900200616      *
143000200616      ** Set up Exemption Code
143100200616      ** If Exemption Code from customer is *BLANK then use exemption
143200200616      ** Code from the treaty
143300200616      *
143400200616     C                   If        @SetExCode = 'N'
143500200616     C                   If        @TaxBasket = BNTXBS or BNEXCD <> *BLANKS
143600200616     C                             or @TaxBasket = INTXBS
143700200616     C                   EVAL      Wk_EXCD = BNEXCD
143800200616     C                   ELSE
143900200616     C                   EVAL      Wk_EXCD = WTEXCD
144000200616     C                   ENDIF
144100200616     C                   EVAL      @SetExCode = 'Y'
144200200616     C                   ENDIF
144300200616
144400200616     C                   ENDIF
144500200616
144600200616     C                   ENDIF
144700200616     C                   ENDIF
144800200616     C                   ENDIF                                                  187179
144900200616
145000200616     C                   IF        *IN33 = '1'
145100200616      *
145200200616      ** 1. No Docoumentation - use the no documentation basket
145300200616      ** 2. Use Tax Basket from Intermediary holding detail if set up
145400200616      ** 3. Use tax basket from Treaty if none set up for above.
145500200616      *
145600200616      ** CASE 1
145700200616     C                   IF        @NoDoc = 'Y'
145800200616     C                   EVAL      Wk_EXCD = '  '
145900200616     C                   EVAL      @SetExCode = '  '
146000200616     C                   EVAL      @TaxBasket = WTDBDC
146100200616
146200200616     C                   ELSE
146300200616      ** CASE 2
146400200616     C                   IF        INTXBS <> *BLANK
146500200616     C                   EVAL      @TaxBasket = INTXBS
146600200616
146700200616     C                   ELSE
146800200616      ** CASE 3
146900200616     C                   EVAL      @TaxBasket = WTTXBS
147000200616     C                   IF        @SetExCode = 'N'
147100200616     C                   EVAL      Wk_EXCD = WTEXCD
147200200616     C                   EVAL      @SetExCode = 'Y'
147300200616     C                   ENDIF
147400200616
147500200616     C                   ENDIF
147600200616     C                   ENDIF
147700200616      *                                                                         187179
147800200616      ** If OID = 'S', event = 'MT' then no tax will be calculate               187179
147900200616      *                                                                         187179
148000200616     C                   IF        In_PEVT = 'MT' AND SE_OIDI = 'S'             187179
148100200616     C                   EVAL      @NoTax = 'Y'                                 187179
148200200616     C                   EVAL      Wk_EXCD = *BLANK                             187179
148300200616     C                   EVAL      Wk_TXBS = *BLANK                             187179
148400200616     C                   EVAL      Wk_TXBN = *BLANK                             187179
148500200616     C                   EVAL      Wk_DAMT = 0                                  187179
148600200616     C                   EVAL      @SetExCode = 'Y'                             187179
148700200616     C                   ENDIF                                                  187179
148800200616
148900200616     C                   ENDIF
149000200616
149100200616     C************       ENDIF                                           186303 187179
149200200616                                                                                186303
149300200616     C                   ENDSR
149400200616      *****************************************************************
149500200616      /EJECT
149600200616      *****************************************************************
149700200616      *                                                               *
149800200616      * SRWrtOrUpd - Write new Position record or Update position     *
149900200616      *              record if record with the same key exist on file.*
150000200616      *                                                               *
150100200616      * Called by: SRCust, SRSingleRec, SRInter, SRNDIFF, SRUDPos     *
150200200616      *                                                               *
150300200616      * Calls: SRSetlAmt                                              *
150400200616      *                                                               *
150500200616      *****************************************************************
150600200616
150700200616     C     SRWrtOrUpd    BEGSR
150800200616      *
150900200616      ** Only output to file if holding is not equal 0.
151000200616      *
151100200616     C*******************IF        Wk_PNMP <> 0                                 185604
151200200616     C                   IF        Wk_PNMP <> 0 or Upd_Rounding = 'Y'           185604
151300200616
151400200616     C                   EVAL      *IN23 = '1'
151500200616      *
151600200616      ** Only if the Security is cover by the Treaty withholding Tax.
151700200616      *
151800200616     C                   IF        @TreatyTax = 'Y'
151900200616      *
152000200616      ** Set up recipient Code if the position settlement is for
152100200616      ** Customer position.
152200200616      *
152300200616     C***********        EVAL      Wk_RPCD = WHRPCD                             185748
152400200616      *
152500200616      ** Calculate Settlement Amount - only if Withholding Tax is being
152600200616      ** calculated or the Nominal position is not the same as the original
152700200616      ** position settlement.
152800200616      *
152900200616     C                   IF        Wk_PNMP <> In_PNMP OR Wk_TASO <> 0
153000200616     C                             OR Wk_TAUS <> 0
153100200616
153200200616     C*******************IF        Wk_PNMP <> In_PNMP                           185604
153300200616     C     COALRF        IFEQ      *BLANKS                                                    215575
153400200616     C     IN_CTYP       OREQ      'C'                                                        215575
153500200616     C                   IF        Wk_PNMP <> In_PNMP AND Wk_PNMP <> 0          185604
153600200616     C                   EVAL      Wk_PAMD = In_PAMD * Wk_PNMP / In_PNMP
153700200616     C                   EVAL      Wk_PCHA = In_PCHA * Wk_PNMP / In_PNMP
153800200616     C                   EVAL      Wk_PCAM = In_PCAM * Wk_PNMP / In_PNMP
153900200616     C                   ENDIF
154000200616     C                   END                                                                  215575
154100200616
154200200616     C                   EXSR      SRSetlAmt
154300200616     C                   ENDIF
154400200616      *
154500200616      ** If the record will be used to correct rounding, then store the key
154600200616      *
154700200616     C                   IF        @RoundingRec = 'Y'
154800200616     C                   EVAL      Lt_PBCA = Wk_PBCA
154900200616     C                   EVAL      Lt_PSSH = Wk_PSSH
155000200616     C                   EVAL      Lt_PCPY = Wk_PCPY
155100200616     C                   EVAL      Lt_PDUD = Wk_PDUD
155200200616     C                   EVAL      Lt_PEVT = Wk_PEVT
155300200616     C                   EVAL      Lt_TNLU = Wk_TNLU
155400200616     C                   EVAL      Lt_TXBS = Wk_TXBS
155500200616     C                   EVAL      Lt_EXCD = Wk_EXCD
155600200616     C                   EVAL      Lt_BNFO = Wk_BNFO
155700200616     C                   EVAL      @Rec_Found = 'Y'
155800200616     C                   EVAL      @RoundingRec = 'N'
155900200616     C                   ENDIF
156000200616      *
156100200616      ** If this is position settlement for depot, then do not output
156200200616      ** Exemption Code, Recipient Code, Income type, Beneficial owner,
156300200616      ** and Tax ID number.
156400200616      *
156500200616     C                   IF        Wk_CTYP = 'D'
156600200616     C                   EVAL      Wk_RPCD = *BLANKS
156700200616     C                   EVAL      Wk_BNFO = *BLANKS
156800200616     C                   EVAL      Wk_CTIN = *BLANKS
156900200616     C                   EVAL      Wk_DEPT = *BLANKS
157000200616     C                   ENDIF
157100200616      *
157200200616      ** Check if a record for this customer and tax basket already in file.
157300200616      *
157400200616     C     PosetKey      CHAIN     POSET5                             23
157500200616
157600200616     C                   ENDIF
157700200616      *
157800200616      ** If record not on file, write a new record.
157900200616      *
158000200616     C     *IN23         IFEQ      '1'
158100200616
158200200616     C                   EVAL      OutPoset = WrkPoset
158300200616     C     COALRF        IFNE      *BLANKS                                                    215575
158400200616     C                   EVAL      Wk_PAMD = 0                                                215575
158500200616     C                   END                                                                  215575
158600200616     C                   WRITE     POSETUP2
158601200616     C                   EXSR      PSAUDT                                                   AR324886
158700200616     C                   ADD       1             NWrtn
158800200616
158900200616     C                   ELSE
159000200616      *
159100200616      ** If record found, and RECI is not equal to '*', then combine
159200200616      ** position holding, tax amount, settlement amount to file
159300200616      *
159400200616     C                   IF        Nw_RECI <> '*'
159500200616
159600200616     C                   EVAL      Nw_PNMP = Nw_PNMP + Wk_PNMP
159700200616     C                   EVAL      Nw_PAMD = Nw_PAMD + Wk_PAMD
159800200616     C                   EVAL      Nw_PCHA = Nw_PCHA + Wk_PCHA
159900200616     C                   EVAL      Nw_PCAM = Nw_PCAM + Wk_PCAM
160000200616     C                   EVAL      Nw_PSAT = Nw_PSAT + Wk_PSAT
160100200616     C                   EVAL      Nw_TASO = Nw_TASO + Wk_TASO
160200200616     C                   EVAL      Nw_TAUS = Nw_TAUS + Wk_TAUS
160300200616     C                   EVAL      Nw_DAMT = Nw_DAMT + Wk_DAMT
160400200616
160500200616     C                   ELSE
160600200616
160700200616     C                   EVAL      OutPoset = WrkPoset
160800200616     C     COALRF        IFNE      *BLANKS                                                    215575
160900200616     C                   EVAL      Wk_PAMD = 0                                                215575
161000200616     C                   END                                                                  215575
161100200616
161200200616     C                   ENDIF
161300200616
161400200616     C                   UPDATE    POSETUP
161500200616     C                   ENDIF
161600200616
161700200616     C                   ENDIF
161800200616
161900200616     C                   ENDSR
162000200616      *****************************************************************
162100200616      /EJECT
162200200616      *****************************************************************
162300200616      *                                                               *
162400200616      * SRDepot - Process Depot Position Settlement Record            *
162500200616      *                                                               *
162600200616      * Called by: Main                                               *
162700200616      *                                                               *
162800200616      * Calls: SRUDPos, SRCPoset                                      *
162900200616      *                                                               *
163000200616      *****************************************************************
163100200616
163200200616     C     SRDepot       BEGSR
163300200616      *
163400200616      ** Get customer detail to check if they have a  SWIFT Address
163500200616      *
163600200616     C                   MOVE      In_PCPY       @Depot
163700200616     C*******************CALLB     'AOCUSTR0'                                                 229342
163800200616     C                   CALLB     'AOCUSTR1'                                                 229342
163900200616     C                   PARM      *BLANKS       @RTCD             7
164000200616     C                   PARM      '*KEY   '     @OPTN             7
164100200616     C                   PARM      @Depot        @KEY1            10
164200200616     C                   PARM                    @KYST             7
164300200616     C*****SDCUST        PARM      SDCUST        DSSDY                                        229342
164400200616     C     SDCUST        PARM      SDCUST        DSLDY                                        229342
164500200616      *
164600200616      ** If Customer detail not found, issue DB error.
164700200616      *
164800200616     C     @RTCD         IFNE      *BLANKS
164900200616     C     BBCLST        ANDNE     'Y'                                                        229342
165000200616     C     *LOCK         IN        LDA
165100200616     C                   EVAL      DBFILE =  'SDCUSTPD'
165200200616     C                   EVAL      DBKEY  =  @KEY1 + @RTCD
165300200616     C                   EVAL      DBPGM  =  PSProcPgm
165400200616     C                   EVAL      DBASE  =  108
165500200616     C                   EVAL      DBMOD  =  PSProcMod
165600200616     C                   EVAL      DBPROC =  'SRDepot'
165700200616     C                   OUT       LDA
165800200616     C                   EXSR      *PSSR
165900200616     C                   ELSE
166000200616     C                   IF        BBCSID = *BLANKS AND BBSTAD = *BLANKS
166100200616     C                             AND BBTXA1 = *BLANKS
166200200616     C                   EVAL      Wk_MT5R = 'N'
166300200616     C                   ELSE
166400200616     C                   EVAL      Wk_MT5R = 'Y'
166500200616     C                   ENDIF
166600200616     C                   ENDIF
166700200616      *
166800200616      ** Get Total User Position for the Depot.
166900200616      ** Generate Position Settlement for user position if it is not equal
167000200616      ** to zero.
167100200616      *
167200200616     C                   EXSR      SRUDPos
167300200616      *
167400200616      ** Generate Position Settlement for Customer Depot Position.
167500200616      *
167600200616     C                   IF        In_PNMP <> Wk_PNMP
167700200616     C                   EXSR      SRCPoset
167800200616     C                   ENDIF
167900200616      *
168000200616     C                   ENDSR
168100200616      *****************************************************************
168200200616      /EJECT
168300200616      *****************************************************************
168400200616      *                                                               *
168500200616      * SRUDPos  - Get User Depot Position and update Position        *
168600200616      *            Settlement File.                                   *
168700200616      *                                                               *
168800200616      * Called by: SRDepot                                            *
168900200616      *                                                               *
169000200616      * Calls:  SRWrtOrUpd                                            *
169100200616      *                                                               *
169200200616      *****************************************************************
169300200616     C     SRUDPos       BEGSR
169400200616      *                                                                         186001
169500200616      ** Get Internal Customer Information                                      186001
169600200616      *                                                                         186001
169700200616     C                   EXSR      SRICInfo                                     186001
169800200616                                                                                186001
169900200616      ** Initialise work fields                                                 186001
170000200616      *                                                                         186001
170100200616     C                   MOVE      *LOVAL        @Book
170200200616     C                   MOVE      *LOVAL        @Mket
170300200616     C                   EVAL      @U_EXnml = 0                                 186001
170400200616     C                   EVAL      @U_TDnml = 0                                 186001
170500200616     C                   EVAL      @U_VDnml = 0                                 186001
170600200616     C                   EVAL      @U_Cost = 0                                  186001
170700200616                                                                                186001
170800200616     C     UdeppFKey     SETLL     UDEPP                              26
170900200616     C     *IN26         DOUEQ     '1'
171000200616     C     UdeppSKey     READE     UDEPP                                  26
171100200616     C                   IF        *IN26 = '0'
171200200616     C                   EVAL      *IN27 = '0'
171300200616      *
171400200616      ** If Position date is greater than the coupon/dividend date then
171500200616      ** get position record before that date.
171600200616      *
171700200616     C                   IF        LU_UDDT > @PositDate
171800200616     C                   EVAL      @PDate = @PositDate
171900200616     C                   EVAL      @Book = LU_UDBK
172000200616     C                   EVAL      @Mket = LU_UDMK
172100200616     C     UdepHFKey     SETGT     UDEPH
172200200616     C     UdeppFKey     READPE    UDEPH                                  27
172300200616
172400200616     C                   ENDIF
172500200616
172600200616     C                   IF        *IN27 = '0'
172700200616      *
172800200616      ** For Coupon Event, if position date is less than the last coupon
172900200616      ** date, then the ex-coupon nominal should be zero.
173000200616      *
173100200616     C                   IF        In_PEVT = 'CP' and LU_UDDT < @LCouponD
173200200616     C                   EVAL      LU_UECN = 0
173300200616     C                   ENDIF
173400200616      *                                                                         186001
173500200616      ** If it is for Maturity Event, then get the book cost                    186001
173600200616      *                                                                         186001
173700200616     C                   IF        In_PEVT = 'MT'                               186001
173800200616     C                   EXSR      SRGetBkCost                                  186001
173900200616     C                   EVAL      @U_Cost = @U_Cost + ZCONS                    186001
174000200616     C                   ENDIF                                                  186001
174100200616
174200200616     C                   EVAL      @U_EXnml = @U_Exnml + LU_UECN
174300200616     C                   EVAL      @U_TDnml = @U_TDnml + LU_UDNT
174400200616     C                   EVAL      @U_VDnml = @U_VDnml + LU_UDNV
174500200616     C                   ENDIF
174600200616     C     COALRF        IFNE      *BLANKS                                                    215575
174700200616     C     CorpabKey     CHAIN     SECOALL4                           21                      215575
174800200616     C     *IN21         IFEQ      '0'                                                        215575
174900200616      *                                                                                       215575
175000200616      ***  Total Cash = Actual Cash Allocation + Cash Rounding                                215575
175100200616      *                                                                                       215575
175200200616     C                   Z-ADD     MCACAA        WWPAMD           17 0                        215575
175300200616     C                   ADD       MCACAR        WWPAMD                                       215575
175400200616     C                   ADD       WWPAMD        Wk_PAMD                                      215575
175500200616     C                   SUB       WWPAMD        IN_PAMD                                      215575
175600200616                                                                                              215575
175700200616     C                   END                                                                  215575
175800200616     C                   END                                                                  215575
175900200616     C                   ENDIF
176000200616     C                   ENDDO
176100200616
176200200616     C                   IF        In_PEVT = 'CP'
176300200616     C                   EVAL      @U_VDnml = @U_VDnml - LU_UECN
176400200616     C                   ENDIF
176500200616      *
176600200616      ** For Dividend Event, Set up to use trade date position if specified.
176700200616      *
176800200616     C                   IF        InTVPosit = 'T'
176900200616     C                   EVAL      Wk_PNMP = @U_TDnml
177000200616     C                   ELSE
177100200616     C                   EVAL      Wk_PNMP = @U_VDnml
177200200616     C                   ENDIF
177300200616      *                                                                         186001
177400200616      ** Calculate Amount Due                                                   186001
177500200616      *                                                                         186001
177600200616     C     COALRF        IFEQ      *BLANKS                                                    215575
177700200616     C                   EVAL      Wk_PAMD = In_PAMD * Wk_PNMP / In_PNMP        186001
177800200616     C                   END                                                                  215575
177900200616      *                                                                         186001
178000200616      ** Calculate discount amount for Maturity.                                186001
178100200616      *                                                                         186001
178200200616     C                   EVAL      @Discount = 0                                186001
178300200616     C***********        IF        In_PEVT = 'MT'                        186001 186303
178400200616     C                   IF        In_PEVT = 'MT' AND @NoTax = 'N'              186303
178500200616     C                   EVAL      @Discount = Wk_PAMD - @U_Cost                186001
178600200616     C                   ENDIF                                                  186001
178700200616      *                                                                         186001
178800200616      ** Calculate Withholding Tax                                              186001
178900200616      *                                                                         186001
179000200616     C                   EVAL      Wk_TASO = 0                                  186001
179100200616     C                   EVAL      Wk_TAUS = 0                                  186001
179200200616     C                   EVAL      Wk_TASR = 0                                  186001
179300200616     C                   IF        @NoTax <> 'Y'                                186001
179400200616     C                   EXSR      SRCalTax                                     186001
179500200616     C                   ENDIF                                                  186001
179600200616      *
179700200616      ** Exemption Code for user position always = *BLANK
179800200616      *
179900200616     C                   EVAL      Wk_EXCD = '  '
180000200616     C                   EVAL      @SetExCode = 'Y'
180100200616
180200200616     C                   EVAL      Wk_RPCD = *BLANKS                            185748
180300200616     C                   EXSR      SRWrtOrUpd
180400200616
180500200616     C                   ENDSR
180600200616      *****************************************************************
180700200616      /EJECT                                                                    186001
180800200616      *****************************************************************         186001
180900200616      *                                                               *         186001
181000200616      * SRICInfo - Get Internal Customer Information                  *         186001
181100200616      *                                                               *         186001
181200200616      * Called by: SRUDPos                                            *         186001
181300200616      *                                                               *         186001
181400200616      * Calls:                                                        *         186001
181500200616      *                                                               *         186001
181600200616      *****************************************************************         186001
181700200616     C     SRICInfo      BEGSR                                                  186001
181800200616      *                                                                         186001
181900200616      ** Get Internal Customer                                                  186001
182000200616      *                                                                         186001
182100200616     C**********         CALLB     'AOBRCHR0'                                          186001 CGL029
182200200616     C                   CALL      'AOBRCHR1'                                                 CGL029
182300200616     C                   PARM      *BLANKS       @RTCD             7            186001
182400200616     C                   PARM      '*KEY   '     @OPTN             7            186001
182500200616     C                   PARM      In_PBCA       @DDPBA            3            186001
182600200616     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 186001 CGL029
182700200616     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
182800200616      *                                                                         186001
182900200616      **  Invalid Branch                                                        186001
183000200616      *                                                                         186001
183100200616     C     @RTCD         IFNE      *BLANKS                                      186001
183200200616     C     *LOCK         IN        LDA                                          186001
183300200616     C                   EVAL      DBFILE =  'SDBRCHPD'                         186001
183400200616     C                   EVAL      DBKEY  =  In_PBCA                            186001
183500200616     C                   EVAL      DBPGM  =  PSProcPgm                          186001
183600200616     C                   EVAL      DBASE  =  102                                186001
183700200616     C                   EVAL      DBMOD  =  PSProcMod                          186001
183800200616     C                   EVAL      DBPROC =  'SRUDPos'                          186001
183900200616     C                   OUT       LDA                                          186001
184000200616     C                   EXSR      *PSSR                                        186001
184100200616     C                   END                                                    186001
184200200616      *                                                                         186001
184300200616      ** Get Tax Basket for Withholding Tax                                     186001
184400200616      *                                                                         186001
184500200616     C                   MOVE      A8BICN        @Cust                          186001
184600200616     C                   MOVE      'U'           @CallFrom                      186001
184700200616     C                   EXSR      SRCustInfo                                   186001
184800200616      *                                                                         186001
184900200616      ** Get Tax rate for Customer with no documentation.                       186001
185000200616      *                                                                         186001
185100200616     C                   IF        @NoDoc = 'Y'                                 186001
185200200616                                                                                186001
185300200616     C                   EVAL      @TaxBasket = WTDBDC                          186001
185400200616      *                                                                         186001
185500200616      ** If position settlement is for Maturity and OID indicator is 'S'        186001
185600200616      ** then use Backup withholding tax rate.                                  186001
185700200616      *                                                                         186001
185800200616     C                   EVAL      Wk_EXCD = ' '                                186001
185900200616     C                   EVAL      @SetExCode = 'Y'                             186001
186000200616     C                   IF        In_PEVT = 'MT' and SE_OIDI = 'S'             186001
186100200616     C                   EVAL      @TaxBasket = WTDRBW                          186001
186200200616     C                   ENDIF                                                  186001
186300200616                                                                                186001
186400200616     C                   ELSE                                                   186001
186500200616      *                                                                         186001
186600200616      ** Get Tax rate for Customer with completed documentation                 186001
186700200616      ** If Tax basket on Customer detail = *BLANK then use tax basket from     186001
186800200616      ** treaty detail.                                                         186001
186900200616      *                                                                         186001
187000200616     C                   IF        @NoTax <> 'Y'                                186303
187100200616                                                                                186303
187200200616     C                   IF        WHTXBS <> *BLANKS                            186001
187300200616     C                   EVAL      @TaxBasket = WHTXBS                          186001
187400200616     C                   ELSE                                                   186001
187500200616     C                   EVAL      @TaxBasket = WTTXBS                          186001
187600200616     C                   ENDIF                                                  186001
187700200616                                                                                186303
187800200616     C                   ELSE                                                   186303
187900200616     C                   EVAL      @TaxBasket = *BLANKS                         186303
188000200616     C                   ENDIF                                                  186303
188100200616                                                                                186303
188200200616     C                   ENDIF                                                  186001
188300200616                                                                                186001
188400200616     C                   ENDSR                                                  186001
188500200616      *****************************************************************         186001
188600200616      /EJECT                                                                    186001
188700200616      *****************************************************************         186001
188800200616      *                                                               *         186001
188900200616      * SRGetBkCost - Get book value for matured Security             *         186001
189000200616      *                                                               *         186001
189100200616      * Called by: SRUDPos                                            *         186001
189200200616      *                                                               *         186001
189300200616      * Calls:                                                        *         186001
189400200616      *                                                               *         186001
189500200616      *****************************************************************         186001
189600200616     C     SRGetBkCost   BEGSR                                                  186001
189700200616      *                                                                         186001
189800200616      ** Get the latest price from Book Position Header (value date)            186001
189900200616      *                                                                         186001
190000200616     C                   EVAL      @TVInd = 'V'                                 186001
190100200616     C     BKPHDKey      CHAIN     BKPHD                              43        186001
190200200616      *                                                                         186001
190300200616      ** If no record found then issued DB error.                               186001
190400200616      *                                                                         186001
190500200616     C     *IN43         IFEQ      '1'                                          186001
190600200616     C     *LOCK         IN        LDA                                          186001
190700200616     C                   EVAL      DBFILE =  'BKPHDD'                           186001
190800200616     C                   EVAL      DBKEY  =  LU_UDSN + LU_UDBK                  186001
190900200616     C                   EVAL      DBPGM  =  PSProcPgm                          186001
191000200616     C                   EVAL      DBASE  =  112                                186001
191100200616     C                   EVAL      DBMOD  =  PSProcMod                          186001
191200200616     C                   EVAL      DBPROC =  'SRGetBkCost'                      186001
191300200616     C                   OUT       LDA                                          186001
191400200616     C                   EXSR      *PSSR                                        186001
191500200616     C                   ENDIF                                                  186001
191600200616      *                                                                         186001
191700200616      ** GET NOMINAL CURRENCY DECIMAL PLACES                                    186001
191800200616      *                                                                         186001
191900200616     C                   CALLB     'AOCURRR0'                                   186001
192000200616     C                   PARM      '*MSG   '     @RTCD             7            186001
192100200616     C                   PARM      '*KEY   '     @OPTN             7            186001
192200200616     C                   PARM      SE_NMCY       @AJCD             3            186001
192300200616     C     SDCURR        PARM      SDCURR        DSSDY                          186001
192400200616      *                                                                         186001
192500200616      ** DATABASE ERROR                                                         186001
192600200616      *                                                                         186001
192700200616     C     @RTCD         IFNE      *BLANK                                       186001
192800200616     C     *LOCK         IN        LDA                                          186001
192900200616     C                   EVAL      DBFILE =  'SDCURRPD'                         186001
193000200616     C                   EVAL      DBKEY  =  @AJCD                              186001
193100200616     C                   EVAL      DBPGM  =  PSProcPgm                          186001
193200200616     C                   EVAL      DBASE  =  113                                186001
193300200616     C                   EVAL      DBMOD  =  PSProcMod                          186001
193400200616     C                   EVAL      DBPROC =  'SRGetBkCost'                      186001
193500200616     C                   OUT       LDA                                          186001
193600200616     C                   EXSR      *PSSR                                        186001
193700200616     C                   ENDIF                                                  186001
193800200616                                                                                186001
193900200616     C                   MOVE      A6NBDP        NomCcyDec         1 0          186001
194000200616     C                   Z-ADD     BH_LAVP       ZPRC                           186001
194100200616     C                   Z-ADD     LU_UDNV       ZNOML                          186001
194200200616     C                   CALLB     'ZCNSD'                                      186001
194300200616     C                   PARM                    ZNOML            15 0          186001
194400200616     C                   PARM                    ZPRC             16 9          186001
194500200616     C                   PARM      SE_SPBS       SPBS              1            186001
194600200616     C                   PARM      SE_NMDP       NMDP              1 0          186001
194700200616     C                   PARM      NomCcyDec     ZCDP              1 0          186001
194800200616     C                   PARM                    ZCONS            15 0          186001
194900200616                                                                                186001
195000200616     C                   ENDSR                                                  186001
195100200616      *****************************************************************         186001
195200200616      /EJECT
195300200616      *****************************************************************
195400200616      *                                                               *
195500200616      * SRCPoset - Get Customer Depot Position                        *
195600200616      *                                                               *
195700200616      * Called by: SRDepot                                            *
195800200616      *                                                               *
195900200616      * Calls:  SRCust                                                *
196000200616      *                                                               *
196100200616      *****************************************************************
196200200616     C     SRCPoset      BEGSR
196300200616      *
196400200616      ** Get Customer Depot Position that makes up the depot position
196500200616      *
196600200616     C                   MOVE      *LOVAL        @CustNo
196700200616     C                   EVAL      @DepotNo = In_PCPY
196800200616     C     CdeppFKey     SETLL     SECDEPL6                           28
196900200616     C     *IN28         DOWEQ     '0'
197000200616     C     CdeppSKey     READE     SECDEPL6                               28
197100200616      *
197200200616      ** If Position date is greater than the coupon/dividend date then
197300200616      ** get position record before that date.
197400200616      *
197500200616     C                   IF        *IN28 = '0'
197600200616     C                   EVAL      *IN29 = '0'
197700200616      *
197800200616      ** If Position date is greater than the coupon/dividend date then
197900200616      ** get position record before that date.
198000200616      *
198100200616     C                   IF        LC_DDTE > @PositDate
198200200616     C                   EVAL      @PDate = @PositDate
198300200616     C                   EVAL      @CustNo = LC_CDCN
198400200616     C     CdepHFKey     SETGT     CDEPH
198500200616     C     CdepHSKey     READPE    CDEPH                                  29
198600200616
198700200616     C                   ENDIF
198800200616
198900200616     C     *IN29         IFEQ      '0'
199000200616     C                   MOVE      LC_CDCN       @Cust
199100200616     C                   MOVE      @Cust         @HoldingCust
199200200616      *
199300200616      ** For Coupon Event, if position date is less than the last coupon
199400200616      ** date, then the ex-coupon nominal should be zero.
199500200616      *
199600200616     C                   IF        In_PEVT = 'CP' and LC_DDTE < @LCouponD
199700200616     C                   EVAL      LC_CECN = 0
199800200616     C                   ENDIF
199900200616      *
200000200616      ** For Dividend Event, Set up to use trade date position if specified.
200100200616      *
200200200616     C                   IF        In_PEVT <> 'CP' and InTVPosit = 'T'
200300200616     C                             and In_PEVT <> 'MT'
200400200616     C                   EVAL      Wk_PNMP = LC_CDNT
200500200616     C                   ELSE
200600200616     C                   EVAL      Wk_PNMP = LC_CDNV - LC_CECN
200700200616     C                   ENDIF
200800200616
200900200616      *                                                                                       215575
201000200616     C                   IF        IN_PEVT <> 'CP' and IN_PEVT <> 'MT' and                    215575
201100200616     C                             IN_PEVT <> 'DV' and IN_PEVT <> 'MR'                        215575
201200200616     C                                                                                        215575
201300200616      ** Full Key Lists for Corporate allocation - SECOALL4                                   215575
201400200616      *  Client                                                                               215575
201500200616     C     CorpacKey     KLIST                                                                215575
201600200616     C                   KFLD                    COALRF                                       215575
201700200616     C                   KFLD                    In_PBCA                                      215575
201800200616     C                   KFLD                    In_PCPY                                      215575
201900200616     C                   KFLD                    CASH                                         215575
202000200616     C                   KFLD                    MCLIN                                        215575
202100200616     C                   KFLD                    In_PBCD                                      215575
202200200616     C                   KFLD                    LC_CDCN                                      215575
202300200616     C                   KFLD                    LC_PTFR                                      215575
202400200616                                                                                              245575
202500200616     C     CorpacKey     CHAIN     SECOALL4                           21                      215575
202600200616     C     *IN21         IFEQ      '0'                                                        215575
202700200616      *                                                                                       215575
202800200616      ***  Total Cash = Actual Cash Allocation + Cash Rounding                                215575
202900200616      *                                                                                       215575
203000200616     C                   Z-ADD     MCACAA        WWPAMD           17 0                        215575
203100200616     C                   ADD       MCACAR        WWPAMD                                       215575
203200200616     C                   Z-ADD     WWPAMD        Wk_PAMD                                      215575
203300200616     C                   SUB       WWPAMD        IN_PAMD                                      215575
203400200616                                                                                              215575
203500200616     C                   END                                                                  215575
203600200616      *                                                                                       215575
203700200616     C                   END                                                                  215575
203800200616      *                                                                                       215575
203900200616     C                   EXSR      SRCust
204000200616     C                   ENDIF
204100200616     C                   ENDIF
204200200616     C                   ENDDO
204300200616
204400200616     C                   ENDSR
204500200616      *****************************************************************
204600200616      /EJECT
204700200616      *****************************************************************
204800200616      *                                                               *
204900200616      * SRSetlAmt - Calculate Settlement Amount                       *
205000200616      *                                                               *
205100200616      * Called by: SRWrtOrUpd                                         *
205200200616      *                                                               *
205300200616      * Calls:  SEZ010                                                *
205400200616      *                                                               *
205500200616      *****************************************************************
205600200616     C     SRSetlAmt     BEGSR
205700200616      *
205800200616      ** Set up parameter for call to SEZ010
205900200616      *
206000200616     C                   IF        In_CTYP = 'D'
206100200616     C                   MOVE      'X'           P@CLAS
206200200616     C                   ELSE
206300200616     C                   MOVE      'D'           P@CLAS
206400200616     C                   END
206500200616
206600200616     C                   MOVEL     Wk_PPRE       P@PPRE
206700200616     C                   Z-ADD     Wk_PAMD       P@PAMD
206800200616     C                   Z-ADD     Wk_PCHA       P@PCHA
206900200616     C                   Z-ADD     Wk_PCAM       P@PCAM
207000200616     C                   Z-ADD     Wk_TASO       P@TASO
207100200616     C                   Z-ADD     Wk_TAUS       P@TAUS
207200200616     C                   Z-ADD     Wk_PSXR       P@PSXR
207300200616     C                   MOVEL     Wk_PMDI       P@PMDI
207400200616     C                   MOVEL     Wk_PNCY       P@PNCY
207500200616     C                   MOVEL     Wk_PSCU       P@PSCU
207600200616
207700200616     C                   IF        In_CTYP = 'D'
207800200616     C                   MOVE      'TS'          P@TDTP
207900200616     C                   ELSE
208000200616     C                   MOVE      'TP'          P@TDTP
208100200616     C                   ENDIF
208200200616
208300200616     C                   Z-ADD     0             P@FXMR
208400200616     C                   Z-ADD     0             P@MAMT
208500200616     C*
208600200616     C** Call SEZ010 to calculate the settlement amount in settle ccy
208700200616     C*
208800200616     C                   CALL      'SEZ010'
208900200616     C                   PARM      *BLANKS       P@RCDE            7
209000200616     C                   PARM                    P@DATA
209100200616     C     P@RCDE        IFEQ      *BLANKS
209200200616     C                   Z-ADD     P@PSAT        Wk_PSAT
209300200616     C                   ELSE
209400200616     C     *LOCK         IN        LDA
209500200616     C                   EVAL      DBFILE =  'SEZ010'
209600200616     C                   EVAL      DBKEY  =  P@RCDE
209700200616     C                   EVAL      DBPGM  =  PSProcPgm
209800200616     C                   EVAL      DBASE  =  109
209900200616     C                   EVAL      DBMOD  =  PSProcMod
210000200616     C                   EVAL      DBPROC =  'SRSetlAmt'
210100200616     C                   OUT       LDA
210200200616     C                   EXSR      *PSSR
210300200616     C                   ENDIF
210400200616
210500200616     C                   ENDSR
210600200616      *****************************************************************
210700200616      /EJECT
210800200616      *****************************************************************
210900200616      *                                                               *
211000200616      * SRNDIFF - Output position different                           *
211100200616      *                                                               *
211200200616      * Called by: SRInter                                            *
211300200616      *                                                               *
211400200616      * Calls: SRCalTax, SRWrtOrUpd                                   *
211500200616      *                                                               *
211600200616      *****************************************************************
211700200616     C     SRNDIFF       BEGSR
211800200616      *
211900200616      ** If nothing set up for Beneficial Owner the find depot for
212000200616      ** position
212100200616      *
212200200616     C                   IF        In_CTYP = 'C' and Wk_DEPT = *BLANKS
212300200616      *
212400200616      ** If Position Settlement is for Customer Position then
212500200616      ** find out what depot the holding is at.
212600200616      *
212700200616     C**********         EVAL      LC_CDPT = 0                                                CSD027
212800200616     C                   EVAL      LC_CDPT = *BLANKS                                          CSD027
212900200616     C     CdepsPKey     CHAIN     CDEPS                              30
213000200616     C**********         IF        LC_CDPT <> 0                                               CSD027
213100200616     C                   IF        LC_CDPT <> *BLANKS                                         CSD027
213200200616     C                   MOVE      LC_CDPT       Wk_DEPT
213300200616     C                   ENDIF
213400200616     C**********         IF        LC_CDPT = 0                                                CSD027
213500200616     C                   IF        LC_CDPT = *BLANKS                                          CSD027
213600200616     C                   MOVE      *BLANKS       Wk_DEPT
213700200616     C                   ENDIF
213800200616     C                   ENDIF
213900200616      *
214000200616      ** Get Tax rate for Customer with no documentation.
214100200616      *
214200200616     C                   EVAL      @TaxBasket = @CustNDTXBS
214300200616     C                   EVAL      Wk_EXCD = '  '
214400200616
214500200616     C                   EVAL      Wk_PNMP = @NomlDiff
214600200616     C                   EVAL      Wk_PAMD = @AmtDiff
214700200616     C                   EVAL      Wk_PCHA = @ChgDiff
214800200616     C                   EVAL      Wk_PCAM = @CommDiff
214900200616                                                                                185292
215000200616     C************       IF        In_PEVT = 'MT'  and SE_OIDI = 'Y'            185292
215100200616     C                   IF        In_PEVT = 'MT'                               185292
215200200616     C                   IF        SE_OIDI = 'Y' OR SE_OIDI = 'S'               185292
215300200616     C                   EVAL      @Cost = Wk_PNMP * CP_CSPT / CP_CSNT
215400200616     C                   EVAL      @Discount = Wk_PAMD - @Cost
215500200616     C                   ENDIF
215600200616     C                   ENDIF                                                  185292
215700200616      *
215800200616      ** Get Tax Rate and calculate withholding Tax
215900200616      *
216000200616     C                   EXSR      SRCalTax
216100200616      *
216200200616      ** Set up fields for position settlement
216300200616      *
216400200616     C                   EVAL      Wk_BNFO = *BLANKS
216500200616     C                   EVAL      Wk_CTIN = *BLANKS
216600200616
216700200616     C                   EVAL      Wk_RPCD = WHRPCD                             185748
216800200616     C                   EXSR      SRWrtOrUpd
216900200616
217000200616     C                   EVAL      @NomlDiff = 0
217100200616     C                   EVAL      @AmtDiff = 0
217200200616     C                   EVAL      @ChgDiff = 0
217300200616     C                   EVAL      @CommDiff = 0
217400200616
217500200616     C                   ENDSR
217600200616      *****************************************************************
217700200616      /EJECT
217800200616      *****************************************************************
217900200616      *                                                               *
218000200616      * *InzSR - Program Initialisation routine                       *
218100200616      *                                                               *
218200200616      * Called by: Implicitly on program activation                   *
218300200616      *                                                               *
218400200616      * Calls:                                                        *
218500200616      *                                                               *
218600200616      *****************************************************************
218700200616
218800200616     C     *InzSR        BEGSR
218900200616      *
219000200616      ** Key Lists for Withholding Tax Customer detail
219100200616      *
219200200616     C     Wt_CustKey    KLIST
219300200616     C                   KFLD                    @Cust
219400200616     C                   KFLD                    SE_CRTT
219500200616      *
219600200616      ** Key Lists for Withholding Tax Treaty detail
219700200616      *
219800200616     C     Wt_TreatKy    KLIST
219900200616     C                   KFLD                    SE_CRTT
220000200616     C                   KFLD                    @SITP
220100200616     C                   KFLD                    @Loc
220200200616      *
220300200616      ** Partial Key Lists for Withholding Tax Treaty detail
220400200616      *
220500200616     C     Wt_TreatPky   KLIST
220600200616     C                   KFLD                    SE_CRTT
220700200616     C                   KFLD                    @SITP
220800200616      *
220900200616      ** Key Lists for Intermediary Client Detail - for Depot Position
221000200616      **                                            settlement
221100200616      *
221200200616     C     InterMlKey    KLIST
221300200616     C                   KFLD                    @HoldingCust
221400200616     C                   KFLD                    @Secty
221500200616     C                   KFLD                    @HoldingDept
221600200616      *
221700200616      ** Key Lists for Intermediary Client Detail - for Customer Position
221800200616      **                                            settlement
221900200616      *
222000200616     C     InterMCKey    KLIST
222100200616     C                   KFLD                    @HoldingCust
222200200616     C                   KFLD                    @Secty
222300200616      *
222400200616      ** Key Lists for Investment Type
222500200616      *
222600200616     C     InvestKey     KLIST
222700200616     C                   KFLD                    SE_NMCY
222800200616     C                   KFLD                    SE_SITP
222900200616      *
223000200616      ** Short Key Lists for Customer Depot (Live record) - CDEPS
223100200616      *
223200200616     C     CdepsPKey     KLIST
223300200616     C                   KFLD                    In_PSSH
223400200616     C                   KFLD                    In_PCPY
223500200616      *
223600200616      ** Short Key Lists for User Depot File - UDEPP
223700200616      *
223800200616     C     UdeppSKey     KLIST
223900200616     C                   KFLD                    In_PBCA
224000200616     C                   KFLD                    In_PSSH
224100200616     C                   KFLD                    In_PCPY
224200200616      *
224300200616      ** Full Key Lists for User Depot File - UDEPP
224400200616      *
224500200616     C     UdeppFKey     KLIST
224600200616     C                   KFLD                    In_PBCA
224700200616     C                   KFLD                    In_PSSH
224800200616     C                   KFLD                    In_PCPY
224900200616     C                   KFLD                    @Book
225000200616     C                   KFLD                    @Mket
225100200616      *
225200200616      ** Full Key Lists for User Depot File - UDEPH
225300200616      *
225400200616     C     UdepHFKey     KLIST
225500200616     C                   KFLD                    In_PBCA
225600200616     C                   KFLD                    In_PSSH
225700200616     C                   KFLD                    In_PCPY
225800200616     C                   KFLD                    @Book
225900200616     C                   KFLD                    @Mket
226000200616     C                   KFLD                    @PDate
226100200616      *
226200200616      ** Short Key Lists for Customer Depot - SECDEPL6
226300200616      *
226400200616     C     CdeppSKey     KLIST
226500200616     C                   KFLD                    In_PBCA
226600200616     C                   KFLD                    In_PSSH
226700200616     C                   KFLD                    In_PMAR
226800200616     C                   KFLD                    @DepotNo
226900200616      *
227000200616      ** Full Key Lists for Customer Depot - SECDEPL6
227100200616      *
227200200616     C     CdeppFKey     KLIST
227300200616     C                   KFLD                    In_PBCA
227400200616     C                   KFLD                    In_PSSH
227500200616     C                   KFLD                    In_PMAR
227600200616     C                   KFLD                    @DepotNo
227700200616     C                   KFLD                    @CustNo
227800200616      *
227900200616      ** Short Key Lists for Customer Depot - CDEPH
228000200616      *
228100200616     C     CdepHSKey     KLIST
228200200616     C                   KFLD                    In_PBCA
228300200616     C                   KFLD                    @CustNo
228400200616     C                   KFLD                    In_PSSH
228500200616     C                   KFLD                    @DepotNo
228600200616     C                   KFLD                    In_PMAR
228700200616      *
228800200616      ** Full Key Lists for Customer Depot - SECDEPL6
228900200616      *
229000200616     C     CdepHFKey     KLIST
229100200616     C                   KFLD                    In_PBCA
229200200616     C                   KFLD                    @CustNo
229300200616     C                   KFLD                    In_PSSH
229400200616     C                   KFLD                    @DepotNo
229500200616     C                   KFLD                    In_PMAR
229600200616     C                   KFLD                    @PDate
229700200616      *
229800200616      ** Key Lists for Beneficial Owner Detail - SDBNFOL1
229900200616      *
230000200616     C     SDBNFOKey     KLIST
230100200616     C                   KFLD                    @INCNUM
230200200616     C                   KFLD                    SE_CRTT
230300200616     C**************     KFLD                    @HoldingDept                   185936
230400200616     C                   KFLD                    @BenDept                       185936
230500200616     C                   KFLD                    @INBONO
230600200616      *
230700200616      ** Part Key Lists for Beneficial Owner Detail - SDBNFOL1
230800200616      *
230900200616     C     SDBNFOPKey    KLIST
231000200616     C                   KFLD                    @INCNUM
231100200616     C                   KFLD                    SE_CRTT
231200200616      *
231300200616      ** Key Lists for Position Settlement File
231400200616      *
231500200616     C     PosetKey      KLIST
231600200616     C                   KFLD                    Wk_PBCA
231700200616     C                   KFLD                    Wk_PSSH
231800200616     C                   KFLD                    Wk_PCPY
231900200616     C                   KFLD                    Wk_PDUD
232000200616     C                   KFLD                    Wk_PEVT
232100200616     C                   KFLD                    Wk_PTFR
232200200616     C                   KFLD                    Wk_TNLU
232300200616     C                   KFLD                    Wk_TXBS
232400200616     C                   KFLD                    Wk_EXCD
232500200616     C                   KFLD                    Wk_BNFO
232600200616      *
232700200616      ** Key Lists for Customer Position File -CPOSN
232800200616      *
232900200616     C     CposnKey      KLIST
233000200616     C                   KFLD                    Wk_PBCA
233100200616     C                   KFLD                    Wk_PSSH
233200200616     C                   KFLD                    @CustNo
233300200616      *                                                                         186001
233400200616      ** Key Lists for Book Position Header File - BKPHD                        186001
233500200616      *                                                                         186001
233600200616     C     BKPHDKey      KLIST                                                  186001
233700200616     C                   KFLD                    LU_UDSN                        186001
233800200616     C                   KFLD                    LU_UDBA                        186001
233900200616     C                   KFLD                    LU_UDBK                        186001
234000200616     C                   KFLD                    LU_UDMK                        186001
234100200616     C                   KFLD                    @TVInd                         186001
234200200616
234300200616      ** Full Key Lists for Corporate allocation - SECOALL4                                   215575
234400200616      *  Book                                                                                 215575
234500200616     C     CorpabKey     KLIST                                                                215575
234600200616     C                   KFLD                    COALRF                                       215575
234700200616     C                   KFLD                    In_PBCA                                      215575
234800200616     C                   KFLD                    In_PCPY                                      215575
234900200616     C                   KFLD                    CASH                                         215575
235000200616     C                   KFLD                    MBOOK                                        215575
235100200616     C                   KFLD                    LU_UDBK                                      215575
235200200616     C                   KFLD                    CUSTOM                                       215575
235300200616     C                   KFLD                    PORTFO                                       215575
235400200616      *
235500200616      ** Program Input Paramenters
235600200616      *
235700200616     C     *Entry        PLIST
235800200616      *
235900200616      ** INPUT fields
236000200616      *
236100200616      ** Original Position Settlement record to be written
236200200616      *
236300200616     C                   PARM                    InPoset
236400200616      *
236500200616      ** Trade/Value Date position for Dividend
236600200616      *
236700200616     C                   PARM                    InTVPosit
236800200616      *
236900200616      ** Dividend Date / Last Coupon Date
237000200616      *
237100200616     C                   PARM                    InDivDate
237200200616      *
237300200616      ** OUTPUT fields
237400200616      *
237500200616     C                   PARM                    NWrtn                          No of record written
237600200616     C                   PARM                    PgmErr                         Program Error
237700200616     C
237800200616      *                                                                                       215575
237900200616     C                   MOVE      In_PSPI       COALRF            6                          215575
238000200616     C                   MOVE      '**CASH**  '  CASH             10                          215575
238100200616     C                   MOVE      'B'           MBOOK             1                          215575
238200200616     C                   MOVE      'C'           MCLIN             1                          215575
238300200616     C                   EVAL      In_PSPI = *BLANKS                                          215575
238400200616     C**********         Z-ADD     *ZERO         CUSTOM            6 0                 215575 CSD027
238500200616     C                   MOVE      *BLANKS       CUSTOM            6                          CSD027
238600200616     C                   MOVE      *BLANKS       PORTFO            4                          215575
238700200616      *                                                                                       215575
238800200616      *
238900200616      ** Initialize Output fields
239000200616      *
239100200616     C                   EVAL      NWrtn = 0
239200200616     C                   EVAL      PgmErr= 'N'
239300200616      *
239400200616      ** Initialize program name
239500200616      *
239600200616     C                   MOVEL     'SE2310'      DBPGM
239700200616      *
239800200616      ** ACCESS BANK DETAILS
239900200616      *
240000200616     C                   CALLB     'AOBANKR0'
240100200616     C                   PARM      *BLANKS       @RTCD             7
240200200616     C                   PARM      '*FIRST '     @OPTN             7
240300200616     C     SDBANK        PARM      SDBANK        DSFDY
240400200616      *
240500200616      * DATABASE ERROR
240600200616      *
240700200616     C     @RTCD         IFNE      *BLANKS
240800200616     C     *LOCK         IN        LDA
240900200616     C                   EVAL      DBFILE =  'SDBANKPD'
241000200616     C                   EVAL      DBKEY  =  @OPTN
241100200616     C                   EVAL      DBPGM  =  PSProcPgm
241200200616     C                   EVAL      DBASE  =  101
241300200616     C                   EVAL      DBMOD  =  PSProcMod
241400200616     C                   EVAL      DBPROC =  '*InzSR'
241500200616     C                   OUT       LDA
241600200616     C                   EXSR      *PSSR
241700200616     C                   END
241800200616      *
241900200616      ** Initialise Treaty Tax fields
242000200616      *
242100200616     C                   EVAL      @RoundingRec = 'N'
242200200616     C                   EVAL      Upd_Rounding = 'N'                           185604
242300200616
242400200616     C                   EVAL      In_PSEQ =  001
242500200616     C                   EVAL      In_CTIN = *BLANKS
242600200616     C                   EVAL      In_PREF = '000000'
242700200616     C                   EVAL      In_MT5G = 'N'
242800200616     C                   EVAL      In_MT5R = 'N'
242900200616     C                   EVAL      In_BNFO = *BLANKS
243000200616     C                   EVAL      In_ICTP = *BLANKS
243100200616     C                   EVAL      In_CRTX = *BLANKS
243200200616     C                   EVAL      In_TXBS = *BLANKS
243300200616     C                   EVAL      In_TXBN = *BLANKS
243400200616     C                   EVAL      In_EXCD = *BLANKS
243500200616     C                   EVAL      In_DEPT = *BLANKS
243600200616      *
243700200616      ** If it is Dividend Event, then use Dividend date as Event Date.
243800200616      *
243900200616     C                   If        In_PEVT <> 'CP' and In_PEVT <> 'MT'
244000200616     C                   EVAL      @PositDate = InDivDate
244100200616     C                   ELSE
244200200616     C                   EVAL      @PositDate = In_PSVL
244300200616     C                   ENDIF
244400200616
244500200616     C                   IF        In_PEVT = 'CP'
244600200616     C                   EVAL      @LCouponD = InDivDate
244700200616     C                   ENDIF
244800200616
244900200616     C                   MOVE      InPoset       WrkPoset
245000200616     C     COALRF        IFNE      *BLANKS                                                    215575
245100200616     C                   EVAL      Wk_PAMD = 0                                                215575
245200200616     C                   END                                                                  215575
245300200616     C                   EVAL      Wk_TXCY = '   '                                            236594
245400200616     C                   EVAL      Wk_TXNM = 0                                                236594
245500200616     C                   EVAL      Wk_TXST = 0                                                236594
245600200616     C                   EVAL      Wk_TAXA = 0                                                236594
245601200616     C     *DTAARA       DEFINE                  SDSTAT                                     AR324886
245602200616     C                   IN        SDSTAT                                                   AR324886
245700200616
245800200616     C                   ENDSR
245900200616      *****************************************************************
245901200616      /EJECT                                                                                AR324886
245902200616      *****************************************************************                     AR324886
245903200616     C     PSAUDT        BEGSR                                                              AR324886
245904200616      *                                                                                     AR324886
245905200616     C                   EVAL      PARECI = Nw_RECI                                         AR324886
245906200616     C                   EVAL      PAPBCA = Nw_PBCA                                         AR324886
245907200616     C                   EVAL      PAPSSH = Nw_PSSH                                         AR324886
245908200616     C                   EVAL      PAPCPY = Nw_PCPY                                         AR324886
245909200616     C                   EVAL      PAPDUD = Nw_PDUD                                         AR324886
245910200616     C                   EVAL      PAPEVT = Nw_PEVT                                         AR324886
245911200616     C                   EVAL      PAPTFR = Nw_PTFR                                         AR324886
245912200616     C                   EVAL      PATNLU = Nw_TNLU                                         AR324886
245913200616     C                   EVAL      PATXBS = Nw_TXBS                                         AR324886
245914200616     C                   EVAL      PABNFO = Nw_BNFO                                         AR324886
245915200616     C                   EVAL      PAEXCD = Nw_EXCD                                         AR324886
245916200616     C                   EVAL      PALUSR = LIBR + 'OWNER'                                  AR324886
245917200616     C                   EVAL      PALCD  = Nw_LCD                                          AR324886
245918200616     C                   EVAL      PALCTP = Nw_CHTP                                         AR324886
245919200616     C                   WRITE     PSAUTDF                                                  AR324886
245920200616      *                                                                                     AR324886
245921200616     C                   ENDSR                                                              AR324886
245922200616      *****************************************************************                     AR324886
246000200616      /EJECT
246100200616      *****************************************************************
246200200616      *                                                               *
246300200616      * *PSSR  - Program exception error routine                      *
246400200616      *          Called automatically if a program error occurs,      *
246500200616      *          or directly by the program code using EXSR.          *
246600200616      *          This subroutine DUMPs the program just once.         *
246700200616      *                                                               *
246800200616      * Called by: (**calling routines**)                             *
246900200616      *                                                               *
247000200616      * Calls:                                                        *
247100200616      *                                                               *
247200200616      *****************************************************************
247300200616      *
247400200616     C     *PSSR         BEGSR
247500200616      *
247600200616     C     @RUN          IFEQ      *BLANK
247700200616     C                   MOVE      'Y'           @RUN              1
247800200616     C                   DUMP
247900200616     C                   END
248000200616      *
248100200616     C                   MOVE      'Y'           PgmErr
248200200616     C                   EVAL      *INU7 = *ON
248300200616     C                   EVAL      *INU8 = *ON
248400200616     C                   EVAL      *INLR = *ON
248500200616     C                   RETURN
248600200616      *
248700200616     C                   ENDSR
248800200616      *
248900200616      ********************************************************************
249000200616**  CPY@
249100200616(c) Finastra International Limited 2001
