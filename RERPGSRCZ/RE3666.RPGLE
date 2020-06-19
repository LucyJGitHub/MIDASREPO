000100200529     H DEBUG
000200200529      *****************************************************************
000300200529/*STD *  RPGBASEBND                                                   *
000400200529/*EXI *  TEXT('Midas RE Generate entries - income and expense')       *
000500200529      *****************************************************************
000600200529      *                                                               *
000700200529      *  Midas - Retail Module                                        *
000800200529      *                                                               *
000900200529      *  RE3666 - GENERATE ENTRIES - INCOME & EXPENSE                 *
001000200529      *                                                               *
001100200529      *  (c) Finastra International Limited 2001                      *
001200200529      *                                                               *
001300200604      *  Last Amend No. 250390             Date 22May20               *
001400200529      *  Prev Amend No. MD046248           Date 27Oct17               *
001500200529      *                 MD039111           Date 01Jun16               *
001600200529      *                 MD034990           Date 25May16               *
001700200529      *                 CRE100             Date 21Mar14               *
001800200529      *                 MD022635           Date 30Sep13               *
001900200529      *                 MD021155 *CONVERT  Date 10Jul13               *
002000200529      *                 MD020099           Date 22Apr13               *
002100200529      *                 CRE093             Date 06Aug12               *
002200200529      *                 CGL120             Date 06Aug12               *
002300200529      *                 261620             Date 28Nov12               *
002400200529      *                 220323             Date 06Oct12               *
002500200529      *                 CRE083AC           Date 06Aug12               *
002600200529      *                 CRE073             Date 06Dec10               *
002700200529      *                 CRE075             Date 06Dec10               *
002800200529      *                 AR676213           Date 19Nov10               *
002900200529      *                 CER059             Date 19Jul10               *
003000200529      *                 CER047             Date 19May08               *
003100200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
003200200529      *                 260297A            Date 28May09               *
003300200529      *                 CSC042             Date 16Feb09               *
003400200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
003500200529      * Midas Plus 1.4 Base ------------------------------------------*
003600200529      * Midas Plus 1.3 ----------- Base ------------------------------*
003700200529      *                 BUG12635           Date 19Dec06               *
003800200529      *                 CSD031             Date 10Apr06               *
003900200529      *                 CSD027             Date 09Dec05               *
004000200529      *                 CSW037A            Date 02May05               *
004100200529      *                 CSD025             Date 11Jan05               *
004200200529      *                 CSW037             Date 15Dec04               *
004300200529      *                 CSW036             Date 15Dec04               *
004400200529      *                 BUG4096            Date 03Sep04               *
004500200529      *                 CLE025             Date 20Oct03               *
004600200529      *                 CGL029             Date 01Sep03               *
004700200529      *                 CRE008             Date 19Feb02               *
004800200529      *                 CGL020             Date 12Dec02               *
004900200529      * Midas Release 4 --------------- Base -------------------------*
005000200529      * Midas DBA 3.05 -----------------------------------------------*
005100200529      *                 CPB002             Date 25Aug00               *
005200200529      * Midas DBA 3.04 -----------------------------------------------*
005300200529      * Midas DBA 3.03 -----------------------------------------------*
005400200529      * Midas DBA 3.02 -----------------------------------------------*
005500200529      *                 157064             Date 02Jul99               *
005600200529      * Midas DBA 3.01 -----------------------------------------------*
005700200529      *                 CGL007             Date 26Mar99               *
005800200529      * Midas DBA 3.00 ---------------- Base -------------------------*
005900200529      *                 139903             DATE 26JUL98               *
006000200529      *                 CSD005             Date 02Mar99               *
006100200529      *                 CTI002             DATE 09Sep98               *
006200200529      *                 103460             DATE 06Mar98               *
006300200529      *                 101709             DATE 29Apr97               *
006400200529      *                 CRE001             Date 20Feb97               *
006500200529      *                 104075             DATE 12FEB97               *
006600200529      *                 095479             DATE 25OCT95               *
006700200529      *                 093825             DATE 05OCT95               *
006800200529      *                 S01408             DATE 06SEP95               *
006900200529      *                 086125             DATE 16MAR95               *
007000200529      *                 S01522             DATE 25JAN95               *
007100200529      *                 075257             DATE 01SEP94               *
007200200529      *                 052664             DATE 02SEP93               *
007300200529      *                 S01413 *CREATE     DATE 13APR93               *
007400200529      *                                                               *
007500200529      *****************************************************************
007600200529      *                                                               *
007700200529      *  250390 - In SR/SRPNAR, initialized field ##NARR for new      *
007800200529      *           transaction and use MOVEL in moving DSPNAR to       *
007900200529      *           ##NARR.  Applied fix 248456.                        *
008000200529      *  MD046248 - Finastra Rebranding                               *
008100200529      *  MD039111 - REC3666 in MSGW during COB                        *
008200200529      *  MD034990 - Postings not posted against account sequence of   *
008300200529      *             the retail account.                               *
008400200529      *  CRE100 - Allow Customer Number For Retail Accrual And Charge *
008500200529      *           Postings.                                           *
008600200529      *  MD022635 - Multiple reconciliation differences field OTRF,   *
008700200529      *             OTST, FACO needs to be populated.                 *
008800200529      *  MD021155 - COB Restructure Phase 1 remnants                  *
008900200529      *           - Code not annotated correctly                      *
009000200529      *  MD020099 - Amount accrual postings fields for Extension File *
009100200529      *             Reference Number and late Accrual Indicator       *
009200200529      *             display +++++ instead of zero or blank            *
009300200529      *  CRE093 - Tactical COB changes REC3666                        *
009400200529      *  CGL120 - GL COB Components Task Split                        *
009500200529      *  261620 - Multiple reconciliation differences that seem to be *
009600200529      *           caused by CRE008.                                   *
009700200529      *           Amended in such a way that the population of FACO,  *
009800200529      *           OTRF & OTST will be correct.                        *
009900200529      *         - Applied for AR1006287 (Child: AR1006288)            *
010000200529      *  220323 - Retail Capitalisation and Income/Expense postings   *
010100200529      *           difference. Calculated interest has 0.01            *
010200200529      *           discrepancy. Externalise SR/ZICD and patterned      *
010300200529      *           additional fix from ZINTDYZ2. Removed *DEFN for     *
010400200529      *           fields ZISY2, ZINOM and ZIM2 so that this program   *
010500200529      *           can be recompiled. "OUT  LDA" should be performed   *
010600200529      *           immediately.  Removed it from SR/*PSSR and placed   *
010700200529      *           it in correct location. The correct location should *
010800200529      *           be after few lines from *LOCK IN LDA.               *
010900200529      *         - Applied for 259032.                                 *
011000200529      *         - Added German Feature checking in SCSARDPD.          *
011100200529      *  CRE083AC - COB Restructure - RE COB Optimisation Phase 1     *
011200200529      *           - Cache details returned by AOACODR0 into an array  *
011300200529      *             to minimize calls to the said program             *
011400200529      *  CRE073 - Interest Rate Rounding (Recompile)                  *
011500200529      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
011600200529      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
011700200529      *  CER059 - German Feature Upgrade to Delhi                     *
011800200529      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
011900200529      *           (Recompile)                                         *
012000200529      *  260297A- Incorrect interest calculation w/ calc basis 6.     *
012100200529      *           Recompile using the correct src for ZICDREZ2.       *
012200200529      *  CSC042 - COB Performance fixes                               *
012300200529      *           AOBRCHR* is called more than 1 Million times for    *
012400200529      *           205 records.                                        *
012500200529      *  BUG12635 - Fix Threshold balance lookup for Rate/Sprd        *
012600200529      *             extraction                                        *
012700200529      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
012800200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
012900200529      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
013000200529      *  CSD025 - Customer De-Activation                              *
013100200529      *  CSW037 - Additional Field Data on MT300/MT320                *
013200200529      *  CSW036 - Dual SWIFT BIC held on Client Details               *
013300200529      *  BUG4096 - Extra accrual generated on monthend run. Amended   *
013400200529      *            program to end when APDA > DNWD. Applied fix       *
013500200529      *            218823.                                            *
013600200529      *  CLE025 - Credit Lines                                        *
013700200529      *  CGL029 - Increase Account Code to 10 digits                  *
013800200529      *  CRE008 - Cash Management                                     *
013900200529      *  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
014000200529      *           Information                                         *
014100200529      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
014200200529      *           (Recompiled)                                        *
014300200529      *  157064 - Amended to post a reversing entry for the accrual   *
014400200529      *           account based on the DIIE/CIIE of the secondary     *
014500200529      *           account when processing linked accounts during COB. *
014600200529      *  CGL007 - Account Postings Enquiry                            *
014700200529      *  139903 - Packed field CHGA written to file as zoned causing  *
014800200529      *           overwriting of BOKC and other fields, causes        *
014900200529      *           MCC0320 to fail.  Also change NITMS                 *
015000200529      *  CSD005 - Standing Data Account Narrative.  Add new field     *
015100200529      *           to SDACODPD.  Recompilation of programs.            *
015200200529      *  CTI002 - Recompiled : File SDACODPD changed                  *
015300200529      *  103460 - Only charge interest if the balance exceeds the     *
015400200529      *           initial threshhold.                                 *
015500200529      *  101709 - Incorrect message id for Retail a/c posting         *
015600200529      *           narrative.  New one added to message file.          *
015700200529      *  CRE001 - Overdraft Interest Calculation:                     *
015800200529      *           Recompiled due to changes in Retail Accrued         *
015900200529      *           Interest Charges file LF/REACR.                     *
016000200529      *  104075 - Posting date incorrect on non-working days.         *
016100200529      *           (Part of 096487).                                   *
016200200529      *  095479 - Format Narrative if REPNAR not on.                  *
016300200529      *  093825 - No narrative ouput if UDC feature REPNAR is off     *
016400200529      *  S01408 - Addition of hook RE3666CCP1.                        *
016500200529      *           Addition of hook RE3666OOP1.                        *
016600200529      *           Addition of hook RE3666OOP2.                        *
016700200529      *  086125 - Add new parameter to AOPNARR0                       *
016800200529      *  S01522 - Call to AOPNARR0 if switchable feature installed    *
016900200529      *           and UDC present                                     *
017000200529      *  075257 - Major accrual probs when have both DR and CR        *
017100200529      *           accrual caused by a backvaluation. A CAIC amount is *
017200200529      *           used for the following account causing two errors.  *
017300200529      *  052664 - Suppress Calculation of Accrued Interest as this    *
017400200529      *           will now be done by RE3662.                         *
017500200529      *  S01413 - Retail 3 Incorporation.                             *
017600200529      *                                                               *
017700200529      *****************************************************************
017800200529
017900200529     FREACRD    UF   E             DISK    COMMIT
018000200529     F                                     RECNO(RRN)
018100200529     FACCNT     UF   E           K DISK    COMMIT
018200200529     FREACRDPD  IF   E             DISK
018300200529     FREHRCJ    IF   E           K DISK
018400200529     FREHRDJ    IF   E           K DISK
018500200529     FREGAHLJ2  IF   E           K DISK    USROPN
018600200529     FREZSHLJ2  IF   E           K DISK    USROPN
018700200529     FACRLAR    O    F  110        DISK    COMMIT
018800200529     FREACRLZZ  O    F    5        DISK    COMMIT
018900200529     FGEIERPD   O    F  620        DISK    COMMIT
019000200529     FREGEIEZZ  O    F   23        DISK    COMMIT
019100200529     FRE3666AU  O    F  132        PRINTER
019200200529     F/COPY WNCPYSRC,RE3666F001
019300200529
019400200529      *****************************************************************
019500200529      *                                                               *
019600200529      *   F U N C T I O N   O F   I N D I C A T O R S                 *
019700200529      *                                                               *
019800200529      *       02      REACR Detail Record                             *
019900200529      *       03      REACR Trailer/Catchall.                         *
020000200529      *       04      REACR Closed Account                            *
020100200529      *       30      First cycle file header output.                 *
020200200529      *       31      Retail A/C No. present                          *
020300200529      *       33      Outstanding Debit accrued interest is zero.     *
020400200529      *       34      Outstanding Credit accrued interest is zero.    *
020500200529      *       40      First cycle calculations done                   *
020600200529      *       41      Total CR amt to post is negative                *
020700200529      *       42            DR         DITTO                          *
020800200529      *       60      Posting amount zero                             *
020900200529      *       61      Total accrual zero                              *
021000200529      *       70      Profit Centre not used                          *
021100200529      *       80      Output GEIER detail                             *
021200200529      *       81      Output Debit ACRL record                        *
021300200529      *       82      Output Credit ACRL record                       *
021400200529      *       83      Debit posting                                   *
021500200529      *       84      Credit posting                                  *
021600200529      *       85      Update A/C Master record                        *
021700200529      *       86      Update REACR detail record                      *
021800200529      *       87      No. of records out of balance                   *
021900200529      *       91-99   Subroutines.                                    *
022000200529      *          U7   Database Error                                  *
022100200529      *          U8   File out of Balance                             *
022200200529      *                                                               *
022300200529      *****************************************************************
022400200529
022500200529     ** Arrays to hold acumulating debit & credit hash totals
022600200529     ** Items 1 & 2 in each arrays are DR & CR hash totals for ACCNT
022700200529     ** Not used by Retail II. because of inclusion of REACR file.
022800200529
022900200529     D INT             S             15  0 DIM(3)
023000200529     D DEC             S              3  0 DIM(3)
023100200529     D ZIR             S             11  7 DIM(11)
023200200529     D ZIB             S             15  0 DIM(11) ASCEND
023300200529     D ZIN             S             13  0 DIM(11)
023400200529     D ZIA             S             15  0 DIM(11)
023500200529     D ZIA1            S             30  9 DIM(11)
023600200529     D/COPY ZSRSRC,ZDATE2Z1LE
023700200529     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
023800200529                                                                                              CRE100
023900200529      ** System Value Array Definition                                                        CRE100
024000200529     D*SVAL*****       S             20    DIM(1) CTDATA PERRCD(1)                   CRE100 MD034990
024100200529     D SVAL            S             20    DIM(2) CTDATA PERRCD(1)                          MD034990
024200200529     D ##BR            S              3    DIM(999)
024300200529     D ##BI            S              6    DIM(999)
024400200529
024500200529      ** Define array to hold Account Codes and details from AOACODR0.
024600200529
024700200529     D ##AC            S             10    DIM(300)
024800200529     D ##AR            S             47    DIM(300)
024900200529     D #LRU            S             13  0 DIM(300)
025000200529     D #LRUC           S             13  0 DIM(300)
025100200529     D QQACOD          S              4  0
025200200529     D XRFN            S             10  0
025300200529     D LTAI            S              1  0
025400200529
025500200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
025600200529     D  TITL         E                     EXTFLD(BJURPT)
025700200529     D  DNWD         E                     EXTFLD(BJDNWD)
025800200529
025900200529     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
026000200529      ** Module Details Accessed via access program
026100200529
026200200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)
026300200529      ** SAR File details accessed via access program AOSARDR0
026400200529
026500200529     D CGPNAR        E DS                  EXTNAME(CGPNARPD)
026600200529      ** UDC Multi Language Narrative Data Structure
026700200529
026800200529     D ##PRM1          DS
026900200529      ** Data Structure for Customer and Branch
027000200529
027100200529     D  A#CUST                 1      6
027200200529     D  A#BRCA                 7      9
027300200529
027400200529     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
027500200529      ** Customer Details Data Structure
027600200529
027700200529     D SDGELR        E DS                  EXTNAME(SDGELRPD)
027800200529     D  APDA         E                     EXTFLD(BKAPDT)
027900200529     D  PFCU         E                     EXTFLD(BKPRCU)
028000200529     D  QQACC1       E                     EXTFLD(QQACCD)
028100200529
028200200529     D SDRETL        E DS                  EXTNAME(SDRETLPD)
028300200529     D  LDAC         E                     EXTFLD(BMLDAI)
028400200529     D  QQACC2       E                     EXTFLD(QQACCD)
028500200529
028600200529      ** Branch Codes Record
028700200529
028800200529     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
028900200529     D  BICN         E                     EXTFLD(A8BICN)
029000200529     D  QQDFA1       E                     EXTFLD(QQDFAC)
029100200529
029200200529     D SDACOD        E DS                  EXTNAME(SDACODPD)
029300200529     D  ATYP         E                     EXTFLD(A5ACTY)
029400200529     D  ACCS         E                     EXTFLD(A5ACSC)
029500200529     D  DIAD         E                     EXTFLD(A5DIAD)
029600200529     D  DIAC         E                     EXTFLD(A5DIAC)
029700200529     D  CIAD         E                     EXTFLD(A5CIAD)
029800200529     D  CIAC         E                     EXTFLD(A5CIAC)
029900200529     D  QQACC3       E                     EXTFLD(QQACCD)
030000200529
030100200529      ** Data Structure for ACOD details caching.
030200200529
030300200529     D ACODDS          DS            47
030400200529     D  #ATYP                  1      1
030500200529     D  #ACCS                  2      3
030600200529     D  #DIAD                  4     13
030700200529     D  #DIAC                 14     23
030800200529     D  #CIAD                 24     33
030900200529     D  #CIAC                 34     43
031000200529     D  #QQACC                44     47
031100200529
031200200529      ** Data Structure for Date format DD/MM/YY
031300200529
031400200529     D                 DS
031500200529     D  RESULT                 1      6  0
031600200529     D  ZDAY                   1      2  0
031700200529     D  ZMTH                   3      4  0
031800200529     D  ZYEAR                  5      6  0
031900200529
032000200529      ** Data Structure for Beginning Date
032100200529
032200200529     D                 DS
032300200529     D  SRES                   1      6  0
032400200529     D  ZISD                   1      2  0
032500200529     D  ZISM                   3      4  0
032600200529     D  ZISY                   5      6  0
032700200529
032800200529      ** Data Structure for Finishing Date
032900200529
033000200529     D                 DS
033100200529     D  FRES                   1      6  0
033200200529     D  ZIFD                   1      2  0
033300200529     D  ZIFM                   3      4  0
033400200529     D  ZIFY                   5      6  0
033500200529
033600200529      ** Data Structure for Beginning Date MM/DD/YY
033700200529
033800200529     D                 DS
033900200529     D  SRESX                  1      6  0
034000200529     D  ZISMX                  1      2  0
034100200529     D  ZISDX                  3      4  0
034200200529     D  ZISYX                  5      6  0
034300200529
034400200529      ** Data Structure for Finishing Date MM/DD/YY
034500200529
034600200529     D                 DS
034700200529     D  FRESX                  1      6  0
034800200529     D  ZIFMX                  1      2  0
034900200529     D  ZIFDX                  3      4  0
035000200529     D  ZIFYX                  5      6  0
035100200529
035200200529      ** Data Structure to split from alpha to numeric Debit and
035300200529      ** Credit balances
035400200529
035500200529     D WDBAL           DS
035600200529     D  ZIBD                   1     88P 0
035700200529     D                                     DIM(11)
035800200529     D  ZBD01                  1      8P 0
035900200529     D  ZBD02                  9     16P 0
036000200529     D  ZBD03                 17     24P 0
036100200529     D  ZBD04                 25     32P 0
036200200529     D  ZBD05                 33     40P 0
036300200529     D  ZBD06                 41     48P 0
036400200529     D  ZBD07                 49     56P 0
036500200529     D  ZBD08                 57     64P 0
036600200529     D  ZBD09                 65     72P 0
036700200529     D  ZBD10                 73     80P 0
036800200529     D  ZBD11                 81     88P 0
036900200529     D  ZBD12                 89     96P 0
037000200529
037100200529     D WCBAL           DS
037200200529     D  ZIBC                   1     88P 0
037300200529     D                                     DIM(11)
037400200529     D  ZBC01                  1      8P 0
037500200529     D  ZBC02                  9     16P 0
037600200529     D  ZBC03                 17     24P 0
037700200529     D  ZBC04                 25     32P 0
037800200529     D  ZBC05                 33     40P 0
037900200529     D  ZBC06                 41     48P 0
038000200529     D  ZBC07                 49     56P 0
038100200529     D  ZBC08                 57     64P 0
038200200529     D  ZBC09                 65     72P 0
038300200529     D  ZBC10                 73     80P 0
038400200529     D  ZBC11                 81     88P 0
038500200529     D  ZBC12                 89     96P 0
038600200529
038700200529      ** Data Structure to split from alpha to numeric Debit and
038800200529      ** Credit rates
038900200529
039000200529     D WDRAT           DS
039100200529     D  ZIRD                   1     66P 7
039200200529     D                                     DIM(11)
039300200529     D  ZRD01                  1      6P 7
039400200529     D  ZRD02                  7     12P 7
039500200529     D  ZRD03                 13     18P 7
039600200529     D  ZRD04                 19     24P 7
039700200529     D  ZRD05                 25     30P 7
039800200529     D  ZRD06                 31     36P 7
039900200529     D  ZRD07                 37     42P 7
040000200529     D  ZRD08                 43     48P 7
040100200529     D  ZRD09                 49     54P 7
040200200529     D  ZRD10                 55     60P 7
040300200529     D  ZRD11                 61     66P 7
040400200529     D  ZRD12                 67     72P 7
040500200529
040600200529     D WCRAT           DS
040700200529     D  ZIRC                   1     66P 7
040800200529     D                                     DIM(11)
040900200529     D  ZRC01                  1      6P 7
041000200529     D  ZRC02                  7     11P 7
041100200529     D  ZRC03                 13     18P 7
041200200529     D  ZRC04                 19     24P 7
041300200529     D  ZRC05                 25     30P 7
041400200529     D  ZRC06                 31     36P 7
041500200529     D  ZRC07                 37     42P 7
041600200529     D  ZRC08                 43     48P 7
041700200529     D  ZRC09                 49     54P 7
041800200529     D  ZRC10                 55     60P 7
041900200529     D  ZRC11                 61     66P 7
042000200529     D  ZRC12                 67     72P 7
042100200529     D/COPY WNCPYSRC,RE3666I001
042200200529
042300200529      ** Key Data Structure : REHKEY to fill LKEY if error
042400200529
042500200529     D                 DS
042600200529     D  REHKEY                 1     29
042700200529     D  BRCA                   1      3
042800200529     D  CNUM                   4      9
042900200529     D  REHCCY                10     12
043000200529     D  ACOD                  13     22  0
043100200529     D  ACSQ                  23     24  0
043200200529     D  REHDAT                25     29  0
043300200529
043400200529      ** Table Key-Data Structure
043500200529
043600200529     D                 DS
043700200529     D  KEYTAB                 1     12
043800200529      **   KEY FOR ACCOUNT CODES RECORDS
043900200529
044000200529     D  RECTKY                 1      2
044100200529     D  ACODKY                 2     11
044200200529     D  SRECKY                12     12
044300200529      ** Key for Branch Codes records
044400200529
044500200529     D  BRCAKY                10     12
044600200529
044700200529      ** Data Area Rundat
044800200529
044900200529     D RUNDAT          DS
045000200529     D  RUNA                   1      7
045100200529     D  RUND                   8     10P 0
045200200529     D  SSF                   11     11
045300200529     D  DATF                  12     12
045400200529     D  MBIN                  13     13
045500200529
045600200529      ** Standard Local Data Area fields
045700200529
045800200529     D LDA             DS           256
045900200529     D  LPROC                  1      8
046000200529     D  LFILE                134    141
046100200529     D  LKEY                 142    170
046200200529     D  LPROG                171    180
046300200529     D  LDBNO                181    183  0
046400200529     D  DBFILE               134    141
046500200529     D  DBKEY                142    170
046600200529     D  DBPGM                171    180
046700200529     D  DBASE                181    183  0
046800200529     D  LRUND                187    191  0
046900200529     D  LRUNA                192    198
047000200529
047100200529      ** Data Structure for key in database error
047200200529
047300200529     D ACKEY1          DS
047400200529     D  CNUM1                  1      6
047500200529     D  CNUM1A                 1      6
047600200529     D  CCY1                   7      9
047700200529     D  ACOD1                 10     19  0
047800200529     D  ACSQ1                 20     21  0
047900200529     D  ACSQ1A                20     21
048000200529     D  BRCA1                 22     24
048100200529
048200200529     D DSFDY         E DS                  EXTNAME(DSFDY)
048300200529      ** First DS for access programs, short Data Structure
048400200529
048500200529     D DSSDY         E DS                  EXTNAME(DSSDY)
048600200529      ** Second DS for access programs, long Data Structure
048700200529
048800200529     D DSPNAR          DS            30
048900200529      ** DS to set up Posting Narrative
049000200529
049100200529     D  D#TXT                  1      6
049200200529     D  D#CNUM                 7     12
049300200529     D  D#CCY                 13     15
049400200529     D  D#ACOD                16     25
049500200529     D  D#ACSQ                26     27
049600200529     D  D#BRCA                28     30
049700200529     D  D#ACNO                14     23
049800200529
049900200529      ** Constant Value
050000200529
050100200529     D I#TXT           C                   CONST('ACCR. ')
050200200529
050300200529      ** Account Master detail record
050400200529
050500200529     IACCNTABF
050600200529     I              ACNO                        AACNO
050700200529     I              DAIC                        ADAIC
050800200529     I              CAIC                        ACAIC
050900200529     I              GADI                        AGADI
051000200529     I              GACI                        AGACI
051100200529     I              MADI                        AMADI
051200200529     I              MACI                        AMACI
051300200529     I              PFCU                        APFCU
051400200529
051500200529      ** REACR file - Detail record
051600200529
051700200529     IREACRDF
051800200529     I              DAIC1                       DAIC
051900200529     I              CAIC1                       CAIC
052000200529     I              CUST                        CNUM
052100200529     I              ACCY                        CCY
052200200529     I              ASEQ                        ACSQ
052300200529     I              LCD                         RHISD
052400200529     I              HISB                        RHISB
052500200529
052600200529      ** Rename REHRCJF format fields - REHRCJ file
052700200529
052800200529     IREHRCJF
052900200529     I              INTH                        INTHC
053000200529
053100200529      ** Rename REHRDJF format fields - REHRDJ file
053200200529
053300200529     IREHRDJF
053400200529     I              INTH                        INTHD
053500200529
053600200529     I/COPY WNCPYSRC,RE3666I002
053700200529      *****************************************************************
053800200529     C/EJECT
053900200529      *****************************************************************
054000200529
054100200529      ** Key Field to access to REHRDJ/REHRCJ file
054200200529
054300200529     C     DCKEY         KLIST
054400200529     C                   KFLD                    BRCA
054500200529     C                   KFLD                    CNUM
054600200529     C                   KFLD                    CCY
054700200529     C                   KFLD                    ACOD
054800200529     C                   KFLD                    ACSQ
054900200529     C                   KFLD                    KDATE
055000200529
055100200529      ** Key Field to access to ACCNT file
055200200529
055300200529     C     ACCKEY        KLIST
055400200529     C                   KFLD                    CNUM
055500200529     C                   KFLD                    CCY
055600200529     C                   KFLD                    ACOD
055700200529     C                   KFLD                    ACSQ
055800200529     C                   KFLD                    BRCA
055900200529
056000200529      ** Work Fields definition
056100200529
056200200529     C                   MOVE      *BLANKS       ERRDAT           15
056300200529     C     *LIKE         DEFINE    ACOD          ZLYCHK
056400200529     C     *LIKE         DEFINE    RUND          ZIBEG
056500200529     C     *LIKE         DEFINE    RUND          ZIEND
056600200529     C     *LIKE         DEFINE    RUND          KDATE
056700200529     C     *LIKE         DEFINE    RUND          ZIBW1
056800200529     C     *LIKE         DEFINE    RUND          ZILPCP
056900200529     C     *LIKE         DEFINE    RUND          ZIDREM
057000200529     C     *LIKE         DEFINE    RUND          ZIDW2
057100200529     C     *LIKE         DEFINE    RUND          ZID1
057200200529     C     *LIKE         DEFINE    RUND          ZID2
057300200529     C     *LIKE         DEFINE    RUND          ZLDTM
057400200529     C     *LIKE         DEFINE    RUND          ZIREM
057500200529     C     *LIKE         DEFINE    RHISB         DINT
057600200529     C     *LIKE         DEFINE    RHISB         CINT
057700200529     C     *LIKE         DEFINE    RHISB         ZIAMT
057800200529     C     *LIKE         DEFINE    RHISB         ZIAMT1
057900200529     C     *LIKE         DEFINE    RHISB         ZIAMTR
058000200529     C     *LIKE         DEFINE    RHISB         ZITHR
058100200529     C     *LIKE         DEFINE    RHISB         ZBAL
058200200529     C     *LIKE         DEFINE    DRIC          ZERROR
058300200529     C     *LIKE         DEFINE    DRIC          ZICALC
058400200529     C     *LIKE         DEFINE    DRIC          LOOP
058500200529     C     *LIKE         DEFINE    ACSQ          ZICT
058600200529     C     *LIKE         DEFINE    ACSQ          ZIDW1
058700200529     C     *LIKE         DEFINE    ACSQ          ZIM1
058800200529     C     *LIKE         DEFINE    ACSQ          ZLYREM
058900200529     C     *LIKE         DEFINE    ACSQ          ZIY1
059000200529     C     *LIKE         DEFINE    ACSQ          ZIMAN
059100200529     C     *LIKE         DEFINE    ACSQ          Z
059200200529     C     *LIKE         DEFINE    ACSQ          Y
059300200529     C                   Z-ADD     *ZEROS        ZIFY2             3 0
059400200529     C     *LIKE         DEFINE    DIIE          ZINTR
059500200529     C     *LIKE         DEFINE    DRIS          ZIRATE
059600200529
059700200529     C     *DTAARA       DEFINE                  LDA
059800200529     C     *DTAARA       DEFINE                  RUNDAT
059900200529
060000200529      **   First Cycle Calcs
060100200529
060200200529     C                   SETOFF                                       30
060300200529     C  N40              SETON                                        30
060400200529     C   40              GOTO      DETAIL
060500200529     C                   SETON                                        40
060600200529     C                   Z-ADD     0             QQACOD
060700200529     C                   Z-ADD     0             XRFN
060800200529     C                   Z-ADD     0             LTAI
060900200529     C                   MOVEA     CPY@          BIS@             80
061000200529     C                   Z-ADD     0             ##BNDX            4 0
061100200529     C     *LIKE         DEFINE    ##BNDX        B
061200200529     C     *LIKE         DEFINE    ##BNDX        ##BSV
061300200529
061400200529      ** Define variables for LRU and initializations
061500200529
061600200529     C                   Z-ADD     0             #LEAST           13 0
061700200529     C     *LIKE         DEFINE    #LEAST        ##LC
061800200529
061900200529     C                   Z-ADD     0             ##ANDX            4 0
062000200529     C     *LIKE         DEFINE    ##ANDX        A
062100200529     C     *LIKE         DEFINE    ##ANDX        ##ASAV
062200200529     C                   Z-ADD     300           ##ANDX
062300200529     C                   Z-ADD     0             ##LC
062400200529
062500200529     C                   IN        RUNDAT
062600200529
062700200529     C                   MOVE      ' '           BLK200          200
062800200529     C                   BITOFF    '1'           PRIN              1
062900200529
063000200529     C                   Z-ADD     RUND          LRUND
063100200529     C                   MOVE      RUNA          LRUNA
063200200529
063300200529     C     DATF          IFEQ      'M'
063400200529     C                   SETON                                        98
063500200529     C                   END
063600200529
063700200529     C                   MOVEL     'RE3666'      LPROG
063800200529     C                   MOVEL     'RE3666'      DBPGM
063900200529     C                   MOVE      *BLANKS       LFILE
064000200529     C                   MOVEL     'REACR'       LFILE
064100200529     C                   MOVEL     'ZERROR'      ERRDAT
064200200529     C                   MOVE      ' =    '      ERRDAT
064300200529     C                   Z-ADD     *ZEROS        ZIWRK1           30 9
064400200529     C                   Z-ADD     *ZEROS        ZIWRK2           30 9
064500200529     C                   Z-ADD     *ZEROS        ZDAYN2            9 4
064600200529     C                   CALL      'AOBANKR0'
064700200529     C                   PARM      '*MSG   '     @RTCD             7
064800200529     C                   PARM      '*FIRST '     @OPTN             7
064900200529     C     SDBANK        PARM      SDBANK        DSFDY
065000200529     C     @RTCD         IFNE      *BLANK
065100200529     C     *LOCK         IN        LDA
065200200529     C                   MOVEL     'SDBANKPD'    DBFILE
065300200529     C                   MOVEL     @OPTN         DBKEY
065400200529     C                   Z-ADD     001           DBASE
065500200529     C                   OUT       LDA
065600200529     C                   SETON                                        U7LR
065700200529     C                   EXSR      *PSSR
065800200529     C                   END
065900200529
066000200529     C/COPY WNCPYSRC,RE3666C024
066100200529
066200200529      ** Call Module Prog. for module details.
066300200529     C                   CALL      'AOMMODR0'
066400200529     C                   PARM      '*MSG   '     @RTCD
066500200529     C                   PARM      '*FIRST '     @OPTN
066600200529     C     SDMMOD        PARM      SDMMOD        DSFDY
066700200529
066800200529     C     @RTCD         IFNE      *BLANK
066900200529     C     *LOCK         IN        LDA
067000200529     C                   MOVEL     'SDMMODPD'    DBFILE
067100200529     C                   Z-ADD     86            DBASE
067200200529     C                   MOVEL     @OPTN         DBKEY
067300200529     C                   OUT       LDA
067400200529     C                   SETON                                        U7LR
067500200529     C                   EXSR      *PSSR
067600200529     C                   ELSE
067700200529     C/COPY WNCPYSRC,REH00404
067800200529
067900200529      ** Call SAR Prog. for Switchable feature
068000200529
068100200529     C                   MOVE      'N'           REPNAR            1
068200200529     C                   MOVE      '0'           *IN65
068300200529     C     BGN1ST        IFEQ      'Y'
068400200529     C/COPY WNCPYSRC,REH00405
068500200529
068600200529     C                   CALL      'AOSARDR0'
068700200529     C                   PARM      '       '     @RTCD
068800200529     C                   PARM      '*VERIFY'     @OPTN
068900200529     C                   PARM      'REPNAR'      @SARD             6
069000200529     C     SCSARD        PARM      SCSARD        DSFDY
069100200529
069200200529     C     @RTCD         IFNE      *BLANK
069300200529     C     @RTCD         ANDNE     '*NRF   '
069400200529     C     *LOCK         IN        LDA
069500200529     C                   MOVEL     'SCSARDPD'    DBFILE
069600200529     C                   Z-ADD     87            DBASE
069700200529     C                   MOVEL     @SARD         DBKEY
069800200529     C                   OUT       LDA
069900200529     C                   SETON                                        U7LR
070000200529     C                   EXSR      *PSSR
070100200529     C                   ENDIF
070200200529
070300200529     C     @RTCD         IFEQ      *BLANK
070400200529     C                   MOVE      'Y'           REPNAR
070500200529     C                   MOVE      '1'           *IN65
070600200529     C                   ENDIF
070700200529     C                   ENDIF
070800200529     C                   ENDIF
070900200529
071000200529      ** Access SAR details to see if CGL020 is enabled.
071100200529
071200200529     C                   CALL      'AOSARDR0'
071300200529     C                   PARM      *BLANKS       @RTCD
071400200529     C                   PARM      '*VERIFY'     @OPTN
071500200529     C                   PARM      'CGL020'      @SARD
071600200529     C     SCSARD        PARM      SCSARD        DSFDY
071700200529
071800200529     C                   MOVE      'N'           CGL020            1
071900200529     C     @RTCD         IFEQ      *BLANKS
072000200529     C                   MOVE      'Y'           CGL020
072100200529     C                   ELSE
072200200529
072300200529     C     @RTCD         IFNE      '*NRF'
072400200529     C     *LOCK         IN        LDA
072500200529     C                   MOVEL     'SCSARDPD'    DBFILE
072600200529     C                   MOVEL     @SARD         DBKEY
072700200529     C                   Z-ADD     88            DBASE
072800200529     C                   MOVE      *ON           *INU7
072900200529     C                   MOVE      *ON           *INLR
073000200529     C                   EXSR      *PSSR
073100200529     C                   ENDIF
073200200529
073300200529     C                   ENDIF
073400200529
073500200529      ** Determine if Cash Management is installed
073600200529
073700200529     C                   CALL      'AOSARDR0'
073800200529     C                   PARM      '       '     @RTCD
073900200529     C                   PARM      '*VERIFY'     @OPTN
074000200529     C                   PARM      'CRE008'      @SARD
074100200529     C     @RTCD         IFNE      *BLANK
074200200529     C     @RTCD         ANDNE     '*NRF   '
074300200529     C     *LOCK         IN        LDA
074400200529     C                   MOVEL     'SCSARDPD'    DBFILE
074500200529     C                   Z-ADD     210           DBASE
074600200529     C                   MOVEL     @SARD         DBKEY
074700200529     C                   SETON                                        U7LR
074800200529     C                   EXSR      *PSSR
074900200529     C                   ENDIF
075000200529     C     @RTCD         IFEQ      *BLANK
075100200529     C                   MOVEL     'Y'           CRE008            1
075200200529     C                   OPEN      REGAHLJ2
075300200529     C                   OPEN      REZSHLJ2
075400200529     C                   ENDIF
075500200529
075600200529      ** Call AOSARDR0 to check for CER016
075700200529
075800200529     C                   CALL      'AOSARDR0'
075900200529     C                   PARM      *BLANKS       @RTCD
076000200529     C                   PARM      '*VERIFY'     @OPTN
076100200529     C                   PARM      'CER016'      @SARD
076200200529     C     SCSARD        PARM      SCSARD        DSFDY
076300200529
076400200529     C     @RTCD         IFEQ      *BLANKS
076500200529     C                   MOVE      'Y'           CER016            1
076600200529     C                   MOVE      'Y'           WFIRST            1
076700200529
076800200529     C                   ELSE
076900200529     C                   MOVE      'N'           CER016
077000200529     C                   MOVE      'N'           WFIRST
077100200529     C                   ENDIF
077200200529
077300200529     C     @RTCD         IFNE      *BLANKS
077400200529     C     @RTCD         ANDNE     '*NRF   '
077500200529
077600200529     C     *LOCK         IN        LDA
077700200529     C                   MOVEL     'CER016'      DBKEY
077800200529     C                   MOVEL     'SCSARDPD'    DBFILE
077900200529     C                   Z-ADD     106           DBASE
078000200529     C                   OUT       LDA
078100200529     C                   EXSR      *PSSR
078200200529
078300200529     C                   ENDIF
078400200529                                                                                              CRE100
078500200529      ** Determine system values whether internal postings for interest                       CRE100
078600200529      ** accrual should be posted at customer or bank level.                                  CRE100
078700200529                                                                                              CRE100
078800200529     C                   Eval      *IN38 = *Off                                               CRE100
078900200529     C                   Eval      *IN39 = *Off                                             MD034990
079000200529      *                                                                                       CRE100
079100200529     C                   Call      'AOSVALR0'                                                 CRE100
079200200529     C**********         Parm      *Blanks       W0RTCD            1                 CRE100 MD039111
079300200529     C                   Parm      *Blanks       W0RTCD            7                        MD039111
079400200529     C                   Parm      SVAL(1)       PVALK1           20                          CRE100
079500200529     C                   Parm      *Blanks       PVAL1           200                          CRE100
079600200529     C**********         Parm      *Blanks       PVALK2           20                 CRE100 MD034990
079700200529     C                   Parm      SVAL(2)       PVALK2           20                        MD034990
079800200529     C                   Parm      *Blanks       PVAL2           200                          CRE100
079900200529     C                   Parm      *Blanks       PVALK3           20                          CRE100
080000200529     C                   Parm      *Blanks       PVAL3           200                          CRE100
080100200529     C                   Parm      *Blanks       PVALK4           20                          CRE100
080200200529     C                   Parm      *Blanks       PVAL4           200                          CRE100
080300200529     C                   Parm      *Blanks       PVALK5           20                          CRE100
080400200529     C                   Parm      *Blanks       PVAL5           200                          CRE100
080500200529     C                   Parm      *Blanks       PVALK6           20                          CRE100
080600200529     C                   Parm      *Blanks       PVAL6           200                          CRE100
080700200529     C                   Parm      *Blanks       PVALK7           20                          CRE100
080800200529     C                   PARM      *Blanks       PVAL7           200                          CRE100
080900200529     C                   PARM      *Blanks       PVALK8           20                          CRE100
081000200529     C                   PARM      *Blanks       PVAL8           200                          CRE100
081100200529     C                   PARM      *Blanks       PVALK9           20                          CRE100
081200200529     C                   PARM      *Blanks       PVAL9           200                          CRE100
081300200529     C                   PARM      *Blanks       PVALK10          20                          CRE100
081400200529     C                   PARM      *Blanks       PVAL10          200                          CRE100
081500200529      *                                                                                       CRE100
081600200529     C                   If        W0RTCD = *Blanks                                           CRE100
081700200529      *                                                                                       CRE100
081800200529     C                   If        PVAL1 = 'Y'                                                CRE100
081900200529     C                   Eval      *IN38 = *On                                                CRE100
082000200529     C                   Endif                                                                CRE100
082100200529      *                                                                                       CRE100
082200200529     C                   If        PVAL2 = 'Y'                                              MD034990
082300200529     C                   Eval      *IN39 = *On                                              MD034990
082400200529     C                   Endif                                                              MD034990
082500200529      *                                                                                     MD034990
082600200529     C                   Else                                                                 CRE100
082700200529      *                                                                                       CRE100
082800200529     C                   If        W0RTCD <> '*NRF'                                           CRE100
082900200529     C     *Lock         In        LDA                                                        CRE100
083000200529     C                   Eval      DBASE = 107                                                CRE100
083100200529     C                   Eval      DBFILE = 'SDSVALPD'                                        CRE100
083200200529     C                   Eval      DBKEY = PVALK1                                             CRE100
083300200529     C                   Out       LDA                                                        CRE100
083400200529     C                   Exsr      *PSSR                                                      CRE100
083500200529     C                   Endif                                                                CRE100
083600200529      *                                                                                       CRE100
083700200529     C                   Endif                                                                CRE100
083800200529
083900200529     C/COPY WNCPYSRC,RE3666C031
084000200529     C                   CALL      'AOGELRR1'
084100200529     C                   PARM      '*MSG   '     @RTCD
084200200529     C                   PARM      '*FIRST '     @OPTN
084300200529     C     SDGELR        PARM      SDGELR        DSSDY
084400200529     C/COPY WNCPYSRC,RE3666C032
084500200529     C     @RTCD         IFNE      *BLANK
084600200529     C     *LOCK         IN        LDA
084700200529     C                   MOVEL     'SDGELRPD'    DBFILE
084800200529     C                   MOVEL     @OPTN         DBKEY
084900200529     C                   Z-ADD     002           DBASE
085000200529     C                   OUT       LDA
085100200529     C                   SETON                                        U7LR
085200200529     C                   EXSR      *PSSR
085300200529     C                   END
085400200529
085500200529      ** If Profit Centre is not used, blank the Profit Centre field
085600200529      ** in all related files
085700200529
085800200529     C     PFCU          IFNE      'Y'
085900200529     C                   SETON                                        70
086000200529     C                   END
086100200529
086200200529     C     MBIN          IFEQ      'Y'
086300200529     C                   MOVE      '1'           *IN50
086400200529     C                   ELSE
086500200529     C                   MOVE      '0'           *IN50
086600200529     C                   END
086700200529     C/COPY WNCPYSRC,RE3666C019
086800200529
086900200529     C   LR              GOTO      END
087000200529
087100200529     C                   CALL      'AORETLR0'
087200200529     C                   PARM      '*MSG   '     @RTCD
087300200529     C                   PARM      '*FIRST '     @OPTN
087400200529     C     SDRETL        PARM      SDRETL        DSFDY
087500200529     C     @RTCD         IFNE      *BLANK
087600200529     C     *LOCK         IN        LDA
087700200529     C                   MOVEL     'SDRETLPD'    DBFILE
087800200529     C                   MOVEL     @OPTN         DBKEY
087900200529     C                   Z-ADD     007           DBASE
088000200529     C                   OUT       LDA
088100200529     C                   SETON                                        U7LR
088200200529     C                   EXSR      *PSSR
088300200529     C                   END
088400200529
088500200529     C   LR              GOTO      END
088600200529
088700200529     C                   Z-ADD     RUND          RNDT              5 0
088800200529     C                   Z-ADD     APDA          RUND
088900200529
089000200529     C     LDAC          IFNE      'Y'
089100200529     C                   ADD       1             RUND
089200200529     C                   END
089300200529
089400200529     C                   Z-ADD     0             ZERO03            3 0
089500200529     C                   Z-ADD     0             ZERO5             5 0
089600200529     C                   Z-ADD     0             ZERO15           15 0
089700200529     C                   Z-ADD     0             ZERO13           13 0
089800200529
089900200529     C                   MOVE      '  '          BLNK12           12
090000200529
090100200529     C                   Z-ADD     0             RRACM             5 0
090200200529     C                   Z-ADD     0             RRN               9 0
090300200529
090400200529     C/COPY WNCPYSRC,RE3666CCP1
090500200529
090600200529      ** Initialise Account Posting fields for PF/GEIERPD.
090700200529
090800200529     C                   Z-ADD     *ZEROS        SDLB             15 0
090900200529     C                   Z-ADD     *ZEROS        SDCB             15 0
091000200529     C                   Z-ADD     *ZEROS        CHGA             13 0
091100200529     C                   MOVE      *BLANK        REBI              1
091200200529     C                   MOVE      *BLANKS       PRFC              4
091300200529     C                   MOVE      *BLANKS       OTRF             21
091400200529     C                   MOVEL     '91080'       OTTP             10
091500200529     C                   MOVE      *BLANKS       OTST             10
091600200529     C                   MOVE      *BLANKS       BOKC              2
091700200529
091800200529      ** Initialise fields for Management Accounting
091900200529
092000200529     C                   Z-ADD     0             VOIN              1 0
092100200529     C                   Z-ADD     235959        PTIM              6 0
092200200529     C                   Z-ADD     1             NITMS             5 0
092300200529
092400200529      ** Clear the AML Fee Fields for CGL020 enhancement
092500200529
092600200529     C                   MOVE      *BLANK        ACKEY            20
092700200529     C                   MOVE      *BLANK        FEEFLG            1
092800200529     C                   Z-ADD     0             FEEVAL           13 0
092900200529     C                   Z-ADD     0             FEEPCT            5 2
093000200529     C                   MOVE      *BLANKS       RORACT           20
093100200529     C                   MOVE      *BLANKS       RORCTY            2
093200200529     C                   MOVE      *BLANKS       RORBNK           20
093300200529     C                   MOVE      *BLANKS       RORCDE           11
093400200529     C                   MOVE      *BLANKS       PORACT           20
093500200529     C                   MOVE      *BLANKS       PORCTY            2
093600200529     C                   MOVE      *BLANKS       PORBNK           20
093700200529     C                   MOVE      *BLANKS       PORCDE           11
093800200529     C                   MOVE      *BLANKS       DSTACT           35
093900200529     C                   MOVE      *BLANKS       DSTCTY            2
094000200529     C                   MOVE      *BLANKS       DSTBNK           20
094100200529     C                   Z-ADD     *ZEROS        SETDAT            5 0
094200200529     C                   MOVE      *BLANKS       TICKER           10
094300200529     C                   MOVE      *BLANKS       EXCHNG           20
094400200529     C                   Z-ADD     *ZEROS        NOMINL           13 2
094500200529     C                   MOVE      *BLANKS       FPTRID           16
094600200529     C                   Z-ADD     0             ORAMT            13 0
094700200529
094800200529      ** Main Processing
094900200529
095000200529     C     DETAIL        TAG
095100200529
095200200529      ** Do not generate postings if Accr Profit Date > Next Working Day
095300200529
095400200529     C     APDA          IFGE      DNWD
095500200529     C                   MOVE      *ON           *INLR
095600200529     C                   GOTO      END
095700200529     C                   ENDIF
095800200529
095900200529     C                   READ      REACRDPD
096000200529     C     REFERN        SETLL     REACRD
096100200529     C                   READ      REACRD
096200200529     C                   DOW       NOT %EOF(REACRD) AND RRN <= RETERN
096300200529
096400200529      ** Set off Indicators
096500200529
096600200529     C                   SETOFF                                       020304
096700200529     C                   SETOFF                                       6082
096800200529     C                   SETOFF                                       808185
096900200529     C                   MOVE      '0'           *IN86
097000200529
097100200529     C/COPY WNCPYSRC,RE3666C025
097200200529
097300200529      ** Records read
097400200529
097500200529     C     RECI          IFEQ      'D'
097600200529
097700200529     C                   SETON                                        02
097800200529     C                   ELSE
097900200529     C     RECI          IFEQ      'C'
098000200529     C                   SETON                                        04
098100200529     C                   ELSE
098200200529     C                   SETON                                        03
098300200529     C                   END
098400200529
098500200529     C                   END
098600200529     C   04
098700200529     COR 02RRACM         ADD       1             RRACM
098800200529
098900200529     C   04
099000200529     COR 03              GOTO      END
099100200529
099200200529      ** Access Details
099300200529      ** Get Account Codes details
099400200529
099500200529     C                   MOVE      ACOD          ACODKY
099600200529     C/COPY WNCPYSRC,RE3666C012
099700200529     C                   CALL      'AOACODR0'
099800200529     C                   PARM      '*MSG   '     @RTCD
099900200529     C                   PARM      '*KEY   '     @OPTN
100000200529     C                   PARM      ACODKY        @ACOD            10
100100200529     C     SDACOD        PARM      SDACOD        DSSDY
100200200529     C     @RTCD         IFNE      *BLANK
100300200529     C     *LOCK         IN        LDA
100400200529     C                   MOVEL     'SDACODPD'    DBFILE
100500200529     C                   MOVEL     @ACOD         DBKEY
100600200529     C                   Z-ADD     004           DBASE
100700200529     C                   OUT       LDA
100800200529     C                   SETON                                        U7LR
100900200529     C                   EXSR      *PSSR
101000200529     C                   END
101100200529     C   U7              GOTO      END
101200200529
101300200529      ** Get Branch details
101400200529
101500200529     C                   MOVEL     BRCA          ##KB
101600200529     C                   EXSR      ##CHKB
101700200529
101800200529      ** If branch is in the array then use the details
101900200529
102000200529     C     ##FIC         IFEQ      'Y'
102100200529     C                   EXSR      ##SETB
102200200529     C                   ELSE
102300200529     C                   CALL      'AOBRCHR1'
102400200529     C                   PARM      '*MSG   '     @RTCD
102500200529     C                   PARM      '*KEY   '     @OPTN
102600200529     C                   PARM      BRCA          @BRCA             3
102700200529     C     SDBRCH        PARM      SDBRCH        DSSDY
102800200529     C     @RTCD         IFNE      *BLANK
102900200529     C     *LOCK         IN        LDA
103000200529     C                   MOVEL     'SDBRCHPD'    DBFILE
103100200529     C                   MOVEL     @BRCA         DBKEY
103200200529     C                   Z-ADD     005           DBASE
103300200529     C                   OUT       LDA
103400200529     C                   SETON                                        U7LR
103500200529     C                   EXSR      *PSSR
103600200529     C                   ELSE
103700200529
103800200529      ** Details found on the DB so add them to the array
103900200529      ** if the array still has room
104000200529
104100200529     C                   EXSR      ##ADDB
104200200529     C                   END
104300200529     C                   ENDIF
104400200529     C   U7              GOTO      END
104500200529
104600200529      ** Save original Account Code information for future use
104700200529
104800200529     C                   MOVE      DIAD          DIAD1            10
104900200529     C                   MOVE      DIAC          DIAC1            10
105000200529     C                   MOVE      CIAD          CIAD1            10
105100200529     C                   MOVE      CIAC          CIAC1            10
105200200529     C/COPY WNCPYSRC,RE3666C014
105300200529
105400200529      ** Interest calculation between two dates and update DR/CR
105500200529      ** interest on REACR file
105600200529
105700200529     C                   MOVE      CNUM          CNUM1
105800200529     C                   MOVE      CCY           CCY1
105900200529     C                   MOVE      ACOD          ACOD1
106000200529     C                   MOVE      ACSQ          ACSQ1
106100200529     C                   MOVE      BRCA          BRCA1
106200200529     C                   EXSR      ACTCHN
106300200529     C   U7              GOTO      END
106400200529     C/COPY WNCPYSRC,RE3666C004
106500200529
106600200529     C                   Z-ADD     *ZEROS        DINT
106700200529     C                   Z-ADD     *ZEROS        CINT
106800200529     C                   Z-ADD     *ZEROS        INRT
106900200529     C                   Z-ADD     *ZEROS        INTP
107000200529     C                   Z-ADD     *ZEROS        ZINTR
107100200529     C                   Z-ADD     *ZEROS        ZLDTM
107200200529
107300200529      ** Suppress calculation of accrued interest as this is now
107400200529      ** done by RE3662
107500200529
107600200529     C     DINT          IFNE      0
107700200529     C     CINT          ORNE      0
107800200529     C                   ADD       DINT          DAIC
107900200529     C                   ADD       CINT          CAIC
108000200529     C                   MOVE      '1'           *IN86
108100200529     C                   EXSR      OUTPUT
108200200529     C                   END
108300200529
108400200529      ** Process Debits
108500200529
108600200529     C     DEBITS        TAG
108700200529
108800200529      ** Do not process debit accruals for secondary accounts.
108900200529      ** Instead, post a reversing entry to PF/GEIERPD and also
109000200529      ** to PF/ACRLAR when DIIE is not equal to zero.
109100200529
109200200529     C     LTAC          IFEQ      *ZERO
109300200529     C/COPY WNCPYSRC,RE3666C005
109400200529     C                   Z-ADD     DAIC          OAINTD           15 0
109500200529     C     OAINTD        ADD       MADI          OAINTD
109600200529     C     OAINTD        ADD       GADI          OAINTD
109700200529     C     OAINTD        COMP      0                                      33
109800200529
109900200529     C     AACNO         COMP      0                                  3131
110000200529     C     OAINTD        SUB       DIIE          PSTAD            13 0  4260
110100200529     C                   ELSE
110200200529     C                   Z-SUB     DIIE          PSTAD                  4260
110300200529     C                   ENDIF
110400200529     C     DIIE          ADD       PSTAD         DAID             13 0    61
110500200529     C   61DIIE          COMP      0                                      61
110600200529     C                   Z-ADD     PSTAD         DAIP             13 0
110700200529     C   42              Z-SUB     PSTAD         PSTAD
110800200529
110900200529      ** Do not output record if total is zero & no changes this month
111000200529
111100200529     C   61              GOTO      DGEIER
111200200529     C                   SETON                                        81
111300200529     C                   EXSR      OUTPUT
111400200529     C     RWACRL        ADD       1             RWACRL            5 0
111500200529
111600200529      ** If zero do not output debit interest posting records
111700200529
111800200529     C     DGEIER        TAG
111900200529
112000200529     C   60              GOTO      CREDIT
112100200529
112200200529      ** Posting to income amount - CR if interest is debit
112300200529
112400200529     C                   MOVE      DIAC1         ACODGE           10
112500200529     C/COPY WNCPYSRC,RE3666C015
112600200529     C                   MOVE      '1'           DRCRGE            1
112700200529     C   42              MOVE      '0'           DRCRGE
112800200529     C                   EXSR      ACDCHN
112900200529     C   LR              GOTO      END
113000200529
113100200529     C                   SETON                                        8083
113200200529     C/COPY WNCPYSRC,RE3666C026
113300200529     C*****CRE008        IFEQ      'Y'                                                      MD022635
113400200529     C                   MOVEL     DIAC1         OTST
113500200529     C                   MOVE      'DIAC'        OTST
113600200529     C**********         ENDIF                                                              MD022635
113700200529     C                   EXSR      OUTPUT
113800200529     C*****CRE008        IFEQ      'Y'                                                      MD022635
113900200529     C                   MOVEL     *BLANK        OTST
114000200529     C**********         ENDIF                                                              MD022635
114100200529     C/COPY WNCPYSRC,RE3666C027
114200200529
114300200529      ** Posting to A.I. receivable account - DB if interest is debit
114400200529
114500200529     C                   MOVE      DIAD1         ACODGE
114600200529     C/COPY WNCPYSRC,RE3666C016
114700200529     C                   MOVE      '0'           DRCRGE
114800200529     C   42              MOVE      '1'           DRCRGE
114900200529     C                   EXSR      ACDCHN
115000200529     C   LR              GOTO      END
115100200529
115200200529     C                   SETON                                        8083
115300200529     C*****CRE008        IFEQ      'Y'                                                      MD022635
115400200529     C                   MOVEL     DIAD1         OTST
115500200529     C                   MOVE      'DIAD'        OTST
115600200529     C**********         ENDIF                                                              MD022635
115700200529     C                   EXSR      OUTPUT
115800200529     C*****CRE008        IFEQ      'Y'                                                      MD022635
115900200529     C                   MOVEL     *BLANK        OTST
116000200529     C**********         ENDIF                                                              MD022635
116100200529
116200200529      ** Control Totals
116300200529      ** Hash total of records written to GEIER
116400200529
116500200529     C                   Z-ADD     3             S                 2 0
116600200529     C     PSTAD         DIV       500           ZZAMT
116700200529     C                   EXSR      HASH
116800200529
116900200529      ** Count of records written to GEIER
117000200529
117100200529     C     RWGEI         ADD       2             RWGEI             5 0
117200200529
117300200529      ** Process Credits
117400200529
117500200529     C     CREDIT        TAG
117600200529
117700200529      ** Do not process credit accruals for secondary accounts.
117800200529      ** Instead, post a reversing entry to PF/GEIERPD and also
117900200529      ** to PF/ACRLAR when CIIE is not equal to zero.
118000200529     C     LTAC          IFEQ      *ZERO
118100200529     C                   Z-ADD     CAIC          OAINTC           15 0
118200200529     C     OAINTC        ADD       MACI          OAINTC
118300200529     C     OAINTC        ADD       GACI          OAINTC
118400200529     C     OAINTC        COMP      0                                      34
118500200529
118600200529     C     AACNO         COMP      0                                  3131
118700200529     C     OAINTC        SUB       CIIE          PSTAC            13 0  4160
118800200529     C                   ELSE
118900200529     C                   Z-SUB     CIIE          PSTAC                  4160
119000200529     C                   ENDIF
119100200529     C     CIIE          ADD       PSTAC         CAID             13 0    61
119200200529     C   61CIIE          COMP      0                                      61
119300200529     C                   Z-ADD     PSTAC         CAIP             13 0
119400200529     C   41              Z-SUB     PSTAC         PSTAC
119500200529
119600200529      ** Do not output record if total is zero & no changes this month
119700200529
119800200529     C   61              GOTO      CGEIER
119900200529     C                   SETON                                        82
120000200529     C                   EXSR      OUTPUT
120100200529     C     RWACRL        ADD       1             RWACRL
120200200529
120300200529      ** If zero do not output credit interest posting records
120400200529
120500200529     C     CGEIER        TAG
120600200529
120700200529     C   60              GOTO      END1
120800200529
120900200529      ** Posting to Expense Account - DR if interest is credit
121000200529
121100200529     C                   MOVE      CIAD1         ACODGE
121200200529     C/COPY WNCPYSRC,RE3666C017
121300200529     C                   MOVE      '1'           DRCRGE
121400200529     C  N41              MOVE      '0'           DRCRGE
121500200529     C                   EXSR      ACDCHN
121600200529     C   LR              GOTO      END
121700200529
121800200529     C                   SETON                                        8084
121900200529     C/COPY WNCPYSRC,RE3666C028
122000200529     C*****CRE008        IFEQ      'Y'                                                      MD022635
122100200529     C                   MOVEL     CIAD1         OTST
122200200529     C                   MOVE      'CIAD'        OTST
122300200529     C**********         ENDIF                                                              MD022635
122400200529     C                   EXSR      OUTPUT
122500200529     C*****CRE008        IFEQ      'Y'                                                      MD022635
122600200529     C                   MOVEL     *BLANK        OTST
122700200529     C**********         ENDIF                                                              MD022635
122800200529     C/COPY WNCPYSRC,RE3666C029
122900200529
123000200529      ** Posting to A.I. payable account - CR if interest is credit
123100200529
123200200529     C                   MOVE      CIAC1         ACODGE
123300200529     C/COPY WNCPYSRC,RE3666C018
123400200529     C                   MOVE      '0'           DRCRGE
123500200529     C  N41              MOVE      '1'           DRCRGE
123600200529     C                   EXSR      ACDCHN
123700200529     C   LR              GOTO      END
123800200529     C                   SETON                                        8084
123900200529     C*****CRE008        IFEQ      'Y'                                                      MD022635
124000200529     C                   MOVEL     CIAC1         OTST
124100200529     C                   MOVE      'CIAC'        OTST
124200200529     C**********         ENDIF                                                              MD022635
124300200529     C                   EXSR      OUTPUT
124400200529     C*****CRE008        IFEQ      'Y'                                                      MD022635
124500200529     C                   MOVEL     *BLANK        OTST
124600200529     C**********         ENDIF                                                              MD022635
124700200529
124800200529      ** Hash total of records written to GEIER
124900200529
125000200529     C                   Z-ADD     3             S
125100200529     C     PSTAC         DIV       500           ZZAMT
125200200529     C                   EXSR      HASH
125300200529
125400200529      ** Count of records written to GEIER
125500200529
125600200529     C     RWGEI         ADD       2             RWGEI
125700200529     C/COPY WNCPYSRC,RE3666C006
125800200529
125900200529     C     END1          TAG
126000200529
126100200529      ** Update ACCNT record with new fields
126200200529
126300200529     C                   SETON                                        85
126400200529     C                   EXSR      OUTPUT
126500200529     C/COPY WNCPYSRC,REH00153
126600200529     C     END           TAG
126700200529
126800200529     C                   MOVEL     LKEY          KEY              15
126900200529     C     *INLR         IFEQ      *ON
127000200529     C     *INU7         ANDEQ     *ON
127100200529     C                   EXSR      *PSSR
127200200529     C                   ENDIF
127300200529
127400200529     C                   READ      REACRD
127500200529     C                   ENDDO
127600200529
127700200529      ** Update trailers
127800200529      ** REACRLZZ trailer
127900200529
128000200529     C                   ADD       RWACRL        NOREZ             5 0
128100200529
128200200529      ** REGEIEZZ trailer
128300200529
128400200529     C                   ADD       RWGEI         NORE1             5 0
128500200529     C     HRWN          MULT      1000          #WRK20           20 0
128600200529     C     #WRK20        ADD       HRDC          TFILE            20 0
128700200529     C     INT(3)        MULT      1000          #WRK20
128800200529     C     #WRK20        ADD       DEC(3)        TCOUN            20 0
128900200529     C     TCOUN         ADD       TFILE         #WRK20
129000200529     C     #WRK20        DIV       1000          HRWN             15 0
129100200529     C     HRWN          MULT      1000          #HRWN            20 0
129200200529     C     #WRK20        SUB       #HRWN         HRDC              3 0
129300200529
129400200529     C                   MOVE      *ON           *INLR
129500200529
129600200529      ** Level Breaks & Subroutines
129700200529
129800200529      *****************************************************************
129900200529      /EJECT
130000200529      *****************************************************************
130100200529      *  ##CHKA - check if ACOD is already cached in the array.       *
130200200529      *      Called by: ACDCHN                                        *
130300200529      *      Calls: None                                              *
130400200529      *****************************************************************
130500200529     C     ##CHKA        BEGSR
130600200529     C                   MOVE      *IN20         #IN20             1
130700200529
130800200529     C                   ADD       1             ##LC
130900200529     C     *LIKE         DEFINE    ACODGE        ##KA
131000200529     C                   MOVEL     *BLANK        ##AFIC            1
131100200529
131200200529      ** Restore saved value of A index
131300200529
131400200529     C                   Z-ADD     ##ASAV        A
131500200529
131600200529      ** Defend against A == 0
131700200529
131800200529     C     A             IFEQ      0
131900200529     C                   Z-ADD     1             A
132000200529     C                   ENDIF
132100200529
132200200529      ** Is this the same as the last LOKUP? if so, we can bypass LOKUP
132300200529
132400200529     C     ##KA          IFEQ      ##AC(A)
132500200529     C                   SETON                                        20
132600200529     C                   ELSE
132700200529
132800200529      ** Begin lookup from last saved or if full, start from 1.
132900200529
133000200529     C     ##ANDX        IFEQ      0
133100200529     C                   Z-ADD     1             A
133200200529     C                   ELSE
133300200529     C                   Z-ADD     ##ANDX        A
133400200529     C                   ENDIF
133500200529
133600200529     C     ##KA          LOOKUP    ##AC(A)                                20
133700200529     C                   ENDIF
133800200529
133900200529     C     *IN20         IFEQ      *ON
134000200529
134100200529      ** Update LRU
134200200529
134300200529     C                   MOVE      ##LC          #LRU(A)
134400200529
134500200529      ** Save the last update to A
134600200529
134700200529     C                   Z-ADD     A             ##ASAV
134800200529
134900200529      ** Turn on indicator so that program will know it is in the array
135000200529
135100200529     C                   MOVEL     'Y'           ##AFIC
135200200529     C                   ENDIF
135300200529
135400200529     C                   MOVE      #IN20         *IN20
135500200529     C                   ENDSR
135600200529      *****************************************************************
135700200529      *  ##ADDA - This subroutine adds the newly acquired SDACOD to   *
135800200529      *           the cache. If the cache is full, it replaces the    *
135900200529      *           least recently used.                                *
136000200529      *      Called by: ACDCHN                                        *
136100200529      *      Calls: None                                              *
136200200529      *****************************************************************
136300200529     C     ##ADDA        BEGSR
136400200529     C                   MOVE      *IN40         #IN40             1
136500200529
136600200529      ** Check if there is still an available slot in the array.
136700200529
136800200529     C     ##ANDX        IFNE      0
136900200529     C                   Z-ADD     ##ANDX        A
137000200529
137100200529     C                   MOVE      ATYP          #ATYP
137200200529     C                   MOVE      ACCS          #ACCS
137300200529     C                   MOVE      DIAD          #DIAD
137400200529     C                   MOVE      DIAC          #DIAC
137500200529     C                   MOVE      CIAD          #CIAD
137600200529     C                   MOVE      CIAC          #CIAC
137700200529     C                   MOVE      QQACC3        #QQACC
137800200529
137900200529     C                   MOVE      ACODGE        ##AC(A)
138000200529     C                   MOVE      ACODDS        ##AR(A)
138100200529
138200200529     C                   MOVE      ##LC          #LRU(A)
138300200529     C                   SUB       1             ##ANDX
138400200529
138500200529      ** Else replace the LRU
138600200529
138700200529     C                   ELSE
138800200529     C                   Z-ADD     1             A
138900200529     C                   MOVEA     #LRU          #LRUC
139000200529     C                   SORTA     #LRUC
139100200529     C                   Z-ADD     #LRUC(1)      #LEAST
139200200529     C     #LEAST        LOOKUP    #LRU(A)                                40
139300200529
139400200529     C                   MOVE      ATYP          #ATYP
139500200529     C                   MOVE      ACCS          #ACCS
139600200529     C                   MOVE      DIAD          #DIAD
139700200529     C                   MOVE      DIAC          #DIAC
139800200529     C                   MOVE      CIAD          #CIAD
139900200529     C                   MOVE      CIAC          #CIAC
140000200529     C                   MOVE      QQACC3        #QQACC
140100200529
140200200529     C                   MOVE      ACODGE        ##AC(A)
140300200529     C                   MOVE      ACODDS        ##AR(A)
140400200529
140500200529     C                   MOVE      ##LC          #LRU(A)
140600200529     C                   ENDIF
140700200529
140800200529      ** Update ASAVE so next call to ##CHKB checks
140900200529      ** this newly added element.
141000200529
141100200529     C                   Z-ADD     A             ##ASAV
141200200529     C                   MOVE      #IN40         *IN40
141300200529     C                   ENDSR
141400200529      *****************************************************************
141500200529      *  ##SETA - Retrieve data from the cache.                       *
141600200529      *      Called by: ACDCHN                                        *
141700200529      *      Calls: None                                              *
141800200529      *****************************************************************
141900200529     C     ##SETA        BEGSR
142000200529     C                   MOVEL     ##AC(A)       ACODGE
142100200529     C                   MOVEL     ##AR(A)       ACODDS
142200200529     C                   MOVE      #ATYP         ATYP
142300200529     C                   MOVE      #ACCS         ACCS
142400200529     C                   MOVE      #DIAD         DIAD
142500200529     C                   MOVE      #DIAC         DIAC
142600200529     C                   MOVE      #CIAD         CIAD
142700200529     C                   MOVE      #CIAC         CIAC
142800200529     C                   MOVE      #QQACC        QQACC3
142900200529     C                   ENDSR
143000200529      *****************************************************************
143100200529      /EJECT
143200200529      *****************************************************************
143300200529
143400200529      ** ##CHKB - Subroutine to check the Branch in the arrays
143500200529
143600200529     C     ##CHKB        BEGSR
143700200529
143800200529     C     *LIKE         DEFINE    A8BRCD        ##KB
143900200529
144000200529      ** Set off the branch found indicator
144100200529
144200200529     C                   MOVEL     *BLANK        ##FIC             1
144300200529
144400200529      ** Save the state of indicator 30 so it can be reset at the end
144500200529      ** of the SR as it may be used elsewhere in the code
144600200529
144700200529     C     *IN30         IFEQ      *ON
144800200529     C                   MOVEL     'Y'           #IN30             1
144900200529     C                   ELSE
145000200529     C                   MOVEL     'N'           #IN30
145100200529     C                   ENDIF
145200200529
145300200529     C                   SETOFF                                           30
145400200529
145500200529      ** Restore the saved Value of B
145600200529
145700200529     C                   Z-ADD     ##BSV         B
145800200529
145900200529      ** Check whether details for Branch already in array
146000200529      ** Is this the same as the last LOKUP, if so we can bypass
146100200529      ** the LOKUP
146200200529      ** Defend against B being 0
146300200529
146400200529     C     B             IFEQ      0
146500200529     C                   Z-ADD     1             B
146600200529     C                   ENDIF
146700200529
146800200529      ** If the branch being checked is the same then use these
146900200529      ** details rather than doing a LOKUP
147000200529
147100200529     C     ##KB          IFEQ      ##BR(B)
147200200529
147300200529      ** Found so seton 30
147400200529
147500200529     C                   SETON                                            30
147600200529     C                   ELSE
147700200529     C                   Z-ADD     1             B
147800200529     C     ##KB          LOOKUP    ##BR(B)                                30
147900200529     C                   ENDIF
148000200529
148100200529      ** Save the last update to B
148200200529
148300200529     C     *IN30         IFEQ      *ON
148400200529     C                   Z-ADD     B             ##BSV
148500200529
148600200529      ** Set the indicator to show the data was found
148700200529
148800200529     C                   MOVEL     'Y'           ##FIC
148900200529     C                   ENDIF
149000200529
149100200529      ** Reset the state of indicator 30.
149200200529
149300200529     C     #IN30         IFEQ      'Y'
149400200529     C                   MOVEL     *ON           *IN30
149500200529     C                   ELSE
149600200529     C                   MOVEL     *OFF          *IN30
149700200529     C                   ENDIF
149800200529
149900200529     C                   ENDSR
150000200529      *****************************************************************
150100200529      /EJECT
150200200529      *****************************************************************
150300200529
150400200529      ** ##SETB - Sets up the SDBRCHPD fields used in the code from the
150500200529      ** arrays
150600200529
150700200529     C     ##SETB        BEGSR
150800200529
150900200529     C                   MOVEL     ##BR(B)       A8BRCD
151000200529     C                   MOVEL     ##BI(B)       BICN
151100200529
151200200529     C                   ENDSR
151300200529      *****************************************************************
151400200529      /EJECT
151500200529      *****************************************************************
151600200529
151700200529      ** ##ADDB - Adds the SDBRCHPD fields used in the code to the
151800200529      ** arrays
151900200529
152000200529     C     ##ADDB        BEGSR
152100200529
152200200529      ** If there is still room in the array then add the details
152300200529
152400200529     C     ##BNDX        IFLT      999
152500200529     C                   ADD       1             ##BNDX
152600200529     C                   Z-ADD     ##BNDX        B
152700200529     C                   MOVEL     A8BRCD        ##BR(B)
152800200529     C                   MOVEL     BICN          ##BI(B)
152900200529     C                   ENDIF
153000200529
153100200529      ** Update ##BSV  so next call to ##CHKB checks this latest
153200200529      ** addition to the array files
153300200529
153400200529     C                   Z-ADD     B             ##BSV
153500200529
153600200529     C                   ENDSR
153700200529      *****************************************************************
153800200529      /EJECT
153900200529      *****************************************************************
154000200529
154100200529      ** Subr. to chain to A/C Codes table records
154200200529
154300200529     C     ACDCHN        BEGSR
154400200529
154500200529     C                   MOVEL     ACODGE        ##KA
154600200529     C                   EXSR      ##CHKA
154700200529
154800200529     C     ##AFIC        IFEQ      'Y'
154900200529     C                   EXSR      ##SETA
155000200529     C                   ELSE
155100200529     C                   CALL      'AOACODR0'
155200200529     C                   PARM      '*MSG   '     @RTCD
155300200529     C                   PARM      '*KEY   '     @OPTN
155400200529     C                   PARM      ACODGE        @ACOD
155500200529     C     SDACOD        PARM      SDACOD        DSSDY
155600200529     C     @RTCD         IFNE      *BLANK
155700200529     C     *LOCK         IN        LDA
155800200529     C                   MOVEL     'SDACODPD'    DBFILE
155900200529     C                   MOVEL     @ACOD         DBKEY
156000200529     C                   Z-ADD     006           DBASE
156100200529     C                   OUT       LDA
156200200529     C                   SETON                                        U7LR
156300200529     C                   EXSR      *PSSR
156400200529     C                   ELSE
156500200529
156600200529      ** If found, add the details into the array
156700200529
156800200529     C                   EXSR      ##ADDA
156900200529     C                   END
157000200529     C                   ENDIF
157100200529     C                   ENDSR
157200200529
157300200529      ** Subr. to do EXCPT OUTPUT
157400200529
157500200529     C     OUTPUT        BEGSR
157600200529
157700200529      ** Move values to exception fields
157800200529
157900200529     C                   Z-ADD     DIIE          DAIL             13 0
158000200529     C                   Z-ADD     CIIE          CAIL             13 0
158100200529     C                   Z-ADD     ZIEND         RHISD
158200200529     C                   Z-ADD     APDA          LPAR
158300200529
158400200529      ** CIIE must be conditioned otherwise DR output will change CIIE
158500200529      ** before it is used in credit selection check for *IN60.
158600200529
158700200529     C     *IN83         IFEQ      '1'
158800200529     C                   Z-ADD     DAID          DIIE
158900200529     C                   END
159000200529     C                   Z-ADD     APDA          LPAP
159100200529     C     *IN84         IFEQ      '1'
159200200529     C                   Z-ADD     CAID          CIIE
159300200529     C                   END
159400200529
159500200529     C/COPY WNCPYSRC,REH00166
159600200529     C     *IN70         IFEQ      '1'
159700200529     C                   MOVE      *BLANKS       PRFC
159800200529     C                   END
159900200529
160000200529      ** Get the posting narrative if a posting is to be output.
160100200529
160200200529     C     *IN80         IFEQ      *ON
160300200529     C                   EXSR      SRPNAR
160400200529     C/COPY WNCPYSRC,RE3666C030
160500200529     C                   ENDIF
160600200529     C     *IN80         IFEQ      *ON
160700200529     C*****CRE008        ANDEQ     'Y'                                                      MD022635
160800200529     C                   EXSR      ACCDET
160900200529     C                   ENDIF
161000200529     C                   Z-ADD     0             XRFN                                         CRE100
161100200529
161200200529     C/COPY WNCPYSRC,RE3666C003
161300200529     C                   EXCEPT
161400200529
161500200529     C                   SETOFF                                       808182
161600200529     C                   SETOFF                                       838485
161700200529     C                   MOVE      '0'           *IN86
161800200529     C                   ENDSR
161900200529      *****************************************************************
162000200529     C/EJECT
162100200529      *****************************************************************
162200200529     C     ACCDET        BEGSR
162300200529
162400200529     C                   MOVEL     BRCA1         ORBR              3
162500200529     C                   MOVEL     CCY1          TRCCY             3
162600200529     C                   MOVEL     *BLANK        FACO             10
162700200529     C                   MOVEL     ACOD1         FACO
162800200529     C                   MOVEL     *BLANK        OTRF
162900200529     C                   CAT       CNUM1A:0      OTRF
163000200529     C                   CAT       ACSQ1A:0      OTRF
163100200529     C                   MOVEL     *BLANK        TRST              2
163200200529     C     CRE008        IFEQ      'Y'
163300200529     C     CMACKY        CHAIN     REGAHLJ2                           99
163400200529     C  N99              MOVEL     'G'           TRST
163500200529     C     CMACKY        CHAIN     REZSHLJ2                           99
163600200529     C  N99              MOVE      'Z'           TRST
163700200529     C                   ENDIF
163800200529
163900200529     C     CMACKY        KLIST
164000200529     C                   KFLD                    CNUM1
164100200529     C                   KFLD                    CCY1
164200200529     C                   KFLD                    ACOD1
164300200529     C                   KFLD                    ACSQ1
164400200529     C                   KFLD                    BRCA1
164500200529
164600200529     C                   ENDSR
164700200529
164800200529      ** Subr. to chain Account Master file
164900200529
165000200529     C     ACTCHN        BEGSR
165100200529
165200200529     C                   SETOFF                                       01
165300200529     C     ACCKEY        CHAIN     ACCNT                              99
165400200529     C     *IN99         IFEQ      '1'
165500200529     C                   SETON                                        U7LR
165600200529     C                   END
165700200529     C   U7              MOVE      *BLANKS       LFILE
165800200529     C   U7              MOVEL     'ACCNT'       LFILE
165900200529     C   U7              MOVE      BLK200        LKEY
166000200529     C   U7              MOVEL     ACKEY1        LKEY
166100200529     C   U7              Z-ADD     003           LDBNO
166200200529
166300200529     C/COPY WNCPYSRC,RE3666C013
166400200529     C                   ENDSR
166500200529
166600200529      ** Subr. to accumulate hash totals
166700200529
166800200529     C     HASH          BEGSR
166900200529
167000200529     C                   Z-ADD     INT(S)        ZZTOTI
167100200529     C                   Z-ADD     DEC(S)        ZZTOTD
167200200529
167300200529     C                   EXSR      GLZADD
167400200529
167500200529     C                   Z-ADD     ZZTOTI        INT(S)           15 0
167600200529     C                   Z-ADD     ZZTOTD        DEC(S)            3 0
167700200529
167800200529     C                   ENDSR
167900200529
168000200529      ** Subroutine to add an amount (ZZAMT) to the total (ZZTOTI,ZZTOTD)
168100200529      ** ind '99' is set by an overflow error
168200200529
168300200529     CSR   GLZADD        BEGSR
168400200529
168500200529     CSR                 Z-ADD     ZZAMT         ZZAMT            15 3    91
168600200529     CSR 91              GOTO      ZZAEND
168700200529
168800200529      ** Split ZZAMT into integer and decimal fields
168900200529
169000200529     CSR                 Z-ADD     ZZAMT         ZZAMTI           15 0
169100200529     CSR                 MOVE      ZZAMT         ZZAMTD            3 0
169200200529
169300200529      ** Both ZZAMTI and ZZAMTD contain a 'sign' zone now
169400200529
169500200529     CSR                 EXSR      GLZSUM
169600200529     CSR   ZZAEND        ENDSR
169700200529
169800200529      ** Subroutine to carry out the addition for subroutines -
169900200529      ** GLZADD, GLZSUB, GLZCMP.
170000200529      ** parameters passed -
170100200529      ** I/P ZZAMTI ZZAMTD
170200200529      ** O/P ZZTOTI ZZTOTD ZZNEGD IND 96 IND 99.
170300200529
170400200529     CSR   GLZSUM        BEGSR
170500200529
170600200529     CSR                 Z-ADD     ZZTOTI        ZZTOTI           15 0
170700200529     CSR                 Z-ADD     ZZTOTD        ZZTOTD            3 0
170800200529     CSR                 SETOFF                                       919293
170900200529     CSR                 SETOFF                                       949599
171000200529
171100200529      ** Determine sign of ZZAMTI & D, 92 if neg
171200200529
171300200529     CSR   ZZAMTI        COMP      0                                    9293
171400200529     CSR 93ZZAMTD        COMP      0                                    9293
171500200529     CSR 93              GOTO      ZZSEND
171600200529
171700200529      ** Determine sign of ZZTOTI & D, 91 if neg
171800200529
171900200529     CSR   ZZTOTI        COMP      0                                    9193
172000200529     CSR 93ZZTOTD        COMP      0                                    9193
172100200529
172200200529      ** If ZZTOTAL is zero, return ZZAMOUNT
172300200529
172400200529     CSR 93              Z-ADD     ZZAMTI        ZZTOTI
172500200529     CSR 93              Z-ADD     ZZAMTD        ZZTOTD
172600200529     CSR 93              GOTO      ZZSEND
172700200529
172800200529      ** If signs differ, bypass overflow checks
172900200529
173000200529     CSR 91
173100200529     CANN92
173200200529     CORN91
173300200529     CAN 92              GOTO      ZZOFPS
173400200529
173500200529     CSR   ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
173600200529     CSR   ZZWK2         COMP      999                                93
173700200529     CSRN93ZZWK2         COMP      -999                                 93
173800200529
173900200529     CSR 93
174000200529     CANN92ZZAMTI        ADD       1             ZZWK3            15 0
174100200529     CSR 93
174200200529     CAN 92ZZAMTI        SUB       1             ZZWK3
174300200529     CSR 93ZZTOTI        ADD       ZZWK3         ZZWK3
174400200529     CSRN93ZZTOTI        ADD       ZZAMTI        ZZWK3
174500200529
174600200529      ** If the modulus of ZZWK3 is LT MOD. ZZTOTI then O/F has occured
174700200529
174800200529     CSRN92ZZWK3         COMP      ZZTOTI                               99
174900200529     CSR 92ZZWK3         COMP      ZZTOTI                             99
175000200529     CSRN99              Z-ADD     ZZWK2         ZZTOTD
175100200529     CSRN99              Z-ADD     ZZWK3         ZZTOTI
175200200529
175300200529      ** If O/F zeroize ZZAMT , Ind '99' set and ZZTOT fields left intact
175400200529
175500200529     CSR 99              Z-ADD     0             ZZAMT            15 3
175600200529     CSR                 GOTO      ZZSEND
175700200529
175800200529      ** The 'signs' are different
175900200529
176000200529     CSR   ZZOFPS        TAG
176100200529
176200200529      ** If ZZAMT was negative, make it pos. to COMP with ZZTOT
176300200529
176400200529     CSR 92              Z-SUB     ZZAMTI        ZZAMTI           15 0
176500200529     CSR 92              Z-SUB     ZZAMTD        ZZAMTD            3 0
176600200529
176700200529      ** if ZZTOT was negative, make it pos. to COMP with ZZAMT
176800200529
176900200529     CSR 91              Z-SUB     ZZTOTI        ZZTOTI
177000200529     CSR 91              Z-SUB     ZZTOTD        ZZTOTD
177100200529
177200200529      ** Both ZZAMT and ZZTOT are now positive
177300200529
177400200529     CSR   ZZTOTI        COMP      ZZAMTI                             93  95
177500200529     CSR 95ZZTOTD        COMP      ZZAMTD                             93  95
177600200529
177700200529      ** If ZZTOT eq. ZZAMT return zero
177800200529
177900200529     CSR 95              Z-ADD     0             ZZTOTI
178000200529     CSR 95              Z-ADD     0             ZZTOTD
178100200529     CSR 95              GOTO      ZZSEND
178200200529
178300200529      ** If ZZTOT GT ZZAMT
178400200529
178500200529     CSR 93ZZAMTD        COMP      ZZTOTD                             94
178600200529     CSR 93
178700200529     CAN 94ZZTOTI        SUB       1             ZZTOTI
178800200529     CSR 93
178900200529     CAN 94ZZTOTD        ADD       1000          ZZWK2
179000200529     CSR 93ZZTOTI        SUB       ZZAMTI        ZZTOTI
179100200529     CSR 93
179200200529     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
179300200529     CSR 93
179400200529     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
179500200529
179600200529      ** If ZZAMT GT ZZTOT
179700200529
179800200529     CSRN93ZZTOTD        COMP      ZZAMTD                             94
179900200529     CSRN93
180000200529     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
180100200529     CSRN93
180200200529     CAN 94ZZAMTD        ADD       1000          ZZWK2
180300200529     CSRN93
180400200529     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
180500200529     CSRN93
180600200529     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
180700200529     CSRN93
180800200529     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
180900200529     CSRN93
181000200529     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
181100200529
181200200529      ** Reverse sign of ZZTOT if larger I/P fields were negative
181300200529
181400200529     CSR                 SETOFF                                       94
181500200529     CSR 93
181600200529     CAN 91
181700200529     CORN93
181800200529     CAN 92              SETON                                        94
181900200529     CSR 94              Z-SUB     ZZTOTI        ZZTOTI
182000200529     CSR 94              Z-SUB     ZZTOTD        ZZTOTD
182100200529
182200200529      ** Restore sign of ZZAMTI & ZZAMTD if it was reversed
182300200529
182400200529     CSR 92              Z-SUB     ZZAMTI        ZZAMTI
182500200529     CSR 92              Z-SUB     ZZAMTD        ZZAMTD
182600200529     CSR   ZZSEND        TAG
182700200529
182800200529      ** If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD
182900200529
183000200529     CSR                 SETOFF                                       96
183100200529     CSR   ZZTOTD        COMP      0                                      91
183200200529     CSR 91ZZTOTI        COMP      0                                    96
183300200529     CSR 96              MOVE      '.000-'       ZZNEGD            5
183400200529     CSR                 ENDSR
183500200529
183600200529      ** DBSR SR. to detect a database error from INTCAL
183700200529
183800200529     C     DBSR          BEGSR
183900200529
184000200529     C                   MOVE      '1'           *INLR
184100200529     C                   MOVE      '1'           *INU7
184200200529     C                   GOTO      END
184300200529
184400200529     C                   ENDSR
184500200529
184600200529      *****************************************************************
184700200529      *                                                               *
184800200529      * *PSSR  --- SUBROUTINE TO HANDLE ABNORMAL ERROR CONDITIONS     *
184900200529      *                                                               *
185000200529      * CALLED FROM: AFTER ABNORNAL OPERATION OCCURS                  *
185100200529      *                                                               *
185200200529      * CALLS: NOTHING                                                *
185300200529      *                                                               *
185400200529      *****************************************************************
185500200529
185600200529     C     *PSSR         BEGSR
185700200529
185800200529     C     @RUN          IFEQ      *BLANKS
185900200529     C                   MOVE      'Y'           @RUN              1
186000200529     C                   DUMP
186100200529     C                   OUT       LDA
186200200529     C                   END
186300200529
186400200529     C                   ENDSR
186500200529      *****************************************************************
186600200529      *                                                               *
186700200529      *  INTCAL subroutine for interest calculation between two dates *
186800200529      *                                                               *
186900200529      *      Called by       External program                         *
187000200529      *      Calls           CRINIT,DATEIN,DRINIT,ZIC00,ZIC01,ZIC02   *
187100200529      *****************************************************************
187200200529     C     INTCAL        BEGSR
187300200529
187400200529      ** Loading of currency to chain to REHRDJ/REHRCJ files
187500200529
187600200529     C                   MOVE      CCY           REHCCY
187700200529     C                   Z-ADD     *ZEROS        INRT
187800200529     C                   Z-ADD     *ZEROS        INTP
187900200529     C                   Z-ADD     *ZEROS        INST
188000200529     C                   Z-ADD     *ZEROS        ZINTR
188100200529     C                   Z-ADD     *ZEROS        ZLDTM
188200200529
188300200529      ** Debit processing
188400200529
188500200529     C     RHISB         IFGT      *ZEROS
188600200529     C     MNBL          ORGT      *ZEROS
188700200529     C                   EXSR      DRINIT
188800200529     C                   END
188900200529
189000200529     C                   Z-ADD     INRT          ZIRATE
189100200529     C                   Z-ADD     INTP          ZICT
189200200529     C                   Z-ADD     DRIC          ZICALC
189300200529     C                   Z-ADD     RHISD         ZIBEG
189400200529     C                   Z-ADD     RUND          ZIEND
189500200529     C/COPY WNCPYSRC,RE3666C020
189600200529
189700200529     C     INTP          IFLT      3
189800200529     C     RHISB         IFGT      0
189900200529     C                   Z-ADD     RHISB         ZIAMT
190000200529     C     ZICT          CASEQ     0             ZIC00
190100200529     C     ZICT          CASEQ     1             ZIC01
190200200529     C     ZICT          CASEQ     2             ZIC02
190300200529     C                   END
190400200529     C                   Z-ADD     ZINTR         DINT
190500200529     C                   END
190600200529
190700200529     C                   ELSE
190800200529
190900200529      ** Searching end-of-month date
191000200529
191100200529     C                   EXSR      DATEIN
191200200529
191300200529     C     RUND          IFLE      ZLDTM
191400200529     C     MNBL          IFGT      0
191500200529     C                   Z-ADD     MNBL          ZIAMT
191600200529     C     INTP          IFEQ      3
191700200529     C                   Z-ADD     1             ZICT
191800200529     C                   ELSE
191900200529     C                   Z-ADD     2             ZICT
192000200529     C                   END
192100200529     C     ZICT          CASEQ     1             ZIC01
192200200529     C     ZICT          CASEQ     2             ZIC02
192300200529     C                   END
192400200529     C                   Z-ADD     ZINTR         DINT
192500200529     C                   END
192600200529
192700200529     C                   ELSE
192800200529
192900200529      ** if change of month occurs with methods 3 & 4 then two processings
193000200529      ** First Processing:
193100200529
193200200529     C     MNBL          IFGT      0
193300200529     C                   Z-ADD     MNBL          ZIAMT
193400200529     C                   Z-ADD     ZLDTM         ZIEND
193500200529     C     INTP          IFEQ      3
193600200529     C                   Z-ADD     1             ZICT
193700200529     C                   ELSE
193800200529     C                   Z-ADD     2             ZICT
193900200529     C                   END
194000200529     C     ZICT          CASEQ     1             ZIC01
194100200529     C     ZICT          CASEQ     2             ZIC02
194200200529     C                   END
194300200529     C                   Z-ADD     ZINTR         DINT
194400200529     C                   END
194500200529
194600200529      ** Second Processing:
194700200529
194800200529     C     RHISB         IFGT      0
194900200529     C                   Z-ADD     RHISB         ZIAMT
195000200529     C                   Z-ADD     ZLDTM         ZIBEG
195100200529     C                   Z-ADD     RUND          ZIEND
195200200529     C     INTP          IFEQ      3
195300200529     C                   Z-ADD     1             ZICT
195400200529     C                   ELSE
195500200529     C                   Z-ADD     2             ZICT
195600200529     C                   END
195700200529     C     ZICT          CASEQ     1             ZIC01
195800200529     C     ZICT          CASEQ     2             ZIC02
195900200529     C                   END
196000200529     C                   ADD       ZINTR         DINT
196100200529     C                   END
196200200529
196300200529     C                   END
196400200529
196500200529     C                   END
196600200529     C/COPY WNCPYSRC,RE3666C021
196700200529
196800200529      ** Credit Processing
196900200529
197000200529     C                   Z-ADD     *ZEROS        INRT
197100200529     C                   Z-ADD     *ZEROS        INTP
197200200529     C                   Z-ADD     *ZEROS        INST
197300200529     C                   Z-ADD     *ZEROS        ZINTR
197400200529     C                   Z-ADD     *ZEROS        ZLDTM
197500200529
197600200529     C     RHISB         IFLT      *ZEROS
197700200529     C     MNBL          ORLT      *ZEROS
197800200529     C                   EXSR      CRINIT
197900200529     C                   END
198000200529
198100200529     C                   Z-ADD     INRT          ZIRATE
198200200529     C                   Z-ADD     INTP          ZICT
198300200529     C                   Z-ADD     CRIC          ZICALC
198400200529     C                   Z-ADD     RHISD         ZIBEG
198500200529     C                   Z-ADD     RUND          ZIEND
198600200529
198700200529     C     INTP          IFLT      3
198800200529     C     RHISB         IFLT      0
198900200529     C                   Z-ADD     RHISB         ZIAMT
199000200529     C     ZICT          CASEQ     0             ZIC00
199100200529     C     ZICT          CASEQ     1             ZIC01
199200200529     C     ZICT          CASEQ     2             ZIC02
199300200529     C                   END
199400200529     C                   Z-ADD     ZINTR         CINT
199500200529     C                   END
199600200529
199700200529     C                   ELSE
199800200529
199900200529      ** Searching end-of-month date
200000200529
200100200529     C                   EXSR      DATEIN
200200200529
200300200529     C     RUND          IFLE      ZLDTM
200400200529     C     MNBL          IFGT      0
200500200529     C                   Z-ADD     MNBL          ZIAMT
200600200529     C     INTP          IFEQ      3
200700200529     C                   Z-ADD     1             ZICT
200800200529     C                   ELSE
200900200529     C                   Z-ADD     2             ZICT
201000200529     C                   END
201100200529     C     ZICT          CASEQ     1             ZIC01
201200200529     C     ZICT          CASEQ     2             ZIC02
201300200529     C                   END
201400200529     C                   Z-ADD     ZINTR         CINT
201500200529     C                   END
201600200529
201700200529     C                   ELSE
201800200529
201900200529      ** If change of month occurs with methods 3 & 4 then two processings
202000200529      ** First Processing:
202100200529
202200200529     C     MNBL          IFGT      0
202300200529     C                   Z-ADD     MNBL          ZIAMT
202400200529     C                   Z-ADD     ZLDTM         ZIEND
202500200529     C     INTP          IFEQ      3
202600200529     C                   Z-ADD     1             ZICT
202700200529     C                   ELSE
202800200529     C                   Z-ADD     2             ZICT
202900200529     C                   END
203000200529     C     ZICT          CASEQ     1             ZIC01
203100200529     C     ZICT          CASEQ     2             ZIC02
203200200529     C                   END
203300200529     C                   Z-ADD     ZINTR         CINT
203400200529     C                   END
203500200529
203600200529      ** Second Processing:
203700200529
203800200529     C     RHISB         IFGT      0
203900200529     C                   Z-ADD     RHISB         ZIAMT
204000200529     C                   Z-ADD     ZLDTM         ZIBEG
204100200529     C                   Z-ADD     RUND          ZIEND
204200200529     C     INTP          IFEQ      3
204300200529     C                   Z-ADD     1             ZICT
204400200529     C                   ELSE
204500200529     C                   Z-ADD     2             ZICT
204600200529     C                   END
204700200529     C     ZICT          CASEQ     1             ZIC01
204800200529     C     ZICT          CASEQ     2             ZIC02
204900200529     C                   END
205000200529     C                   ADD       ZINTR         CINT
205100200529     C                   END
205200200529
205300200529     C                   END
205400200529
205500200529     C                   END
205600200529
205700200529     C                   ENDSR
205800200529     C/COPY ZSRSRC,ZICDREZ2LE
205900200529      *****************************************************************
206000200529     C/EJECT
206100200529      *****************************************************************
206200200529
206300200529      ** ZIC00 subroutine to calculate interest (type=00)
206400200529      **     Called by       INTCAL
206500200529      **     Calls           ZICD
206600200529
206700200529     C     ZIC00         BEGSR
206800200529     C/COPY WNCPYSRC,RE3666C001
206900200529
207000200529      ** Reverse sign of amount if it's negative
207100200529
207200200529     C     ZIAMT         IFLT      0
207300200529     C                   Z-SUB     ZIAMT         ZIAMT
207400200529     C                   END
207500200529
207600200529      ** Find number of days to calculate interest according to calc. basis
207700200529      ** For calc basis 6, use the factored number of days
207800200529
207900200529     C     ZIAMT         MULT      ZIRATE        ZIWRK1
208000200529     C     ZICALC        IFEQ      6
208100200529     C     ZIWRK1        MULT      INT6DY        ZIWRK2
208200200529
208300200529     C                   ELSE
208400200529     C     ZIWRK1        MULT      ZDAYN2        ZIWRK2
208500200529     C                   ENDIF
208600200529
208700200529     C     ZICALC        IFEQ      7
208800200529     C     ZICALC        OREQ      5
208900200529     C     ZICALC        OREQ      3
209000200529     C     ZICALC        OREQ      2
209100200529     C     ZIWRK2        DIV(H)    36000         ZINTR
209200200529     C                   END
209300200529
209400200529     C     ZICALC        IFEQ      4
209500200529     C     ZICALC        OREQ      1
209600200529     C     ZIWRK2        DIV(H)    36500         ZINTR
209700200529     C                   END
209800200529
209900200529     C     ZICALC        IFEQ      6
210000200529     C     ZIWRK2        DIV(H)    36600         ZINTR
210100200529     C                   END
210200200529
210300200529     C/COPY WNCPYSRC,RE3666C002
210400200529     C                   ENDSR
210500200529      ********************************************************************
210600200529     C/EJECT
210700200529      ********************************************************************
210800200529
210900200529      ** ZIC01 subroutine to calculate interest (type=01)
211000200529      **     Called by       INTCAL
211100200529      **     Calls           ZICD
211200200529
211300200529     C     ZIC01         BEGSR
211400200529     C/COPY WNCPYSRC,RE3666C008
211500200529
211600200529      ** Reverse sign of amount if it's negative
211700200529
211800200529     C     ZIAMT         IFLT      0
211900200529     C                   Z-SUB     ZIAMT         ZIAMT
212000200529     C                   END
212100200529
212200200529      ** Initialize work fields
212300200529
212400200529     C                   Z-ADD     ZIAMT         ZIAMT1
212500200529     C                   Z-ADD     1             Z
212600200529     C                   Z-ADD     *ZEROS        ZIAMTR
212700200529     C                   Z-ADD     *ZEROS        ZIA
212800200529     C                   Z-ADD     *ZEROS        ZIA1
212900200529     C                   Z-ADD     *ZEROS        LOOP
213000200529     C                   Z-ADD     *ZEROS        Y
213100200529     C                   Z-ADD     *ZEROS        ZIN
213200200529
213300200529      ** Interest is only calculated on an amount that exceeds the
213400200529      ** initial threshold balance
213500200529
213600200529     C     ZIAMT         IFGT      ZITHR
213700200529
213800200529      ** Find number of days to calculate interest according to calc. basis
213900200529
214000200529     C     LOOP          DOWEQ     0
214100200529     C                   Z-ADD     ZIAMT1        ZIAMTR
214200200529
214300200529     C     Z             IFEQ      11
214400200529     C                   Z-ADD     ZIAMTR        ZIA(Z)
214500200529     C                   Z-ADD     1             LOOP
214600200529
214700200529     C                   ELSE
214800200529     C                   ADD       1             Y
214900200529     C                   ADD       1             Z
215000200529
215100200529     C     ZIB(Z)        IFEQ      0
215200200529     C                   ADD       ZIAMTR        ZIA(Y)
215300200529     C                   Z-ADD     1             LOOP
215400200529
215500200529     C                   ELSE
215600200529     C     ZIB(Z)        SUB       ZIB(Y)        ZBAL
215700200529     C     ZIAMTR        SUB       ZBAL          ZIAMT1
215800200529
215900200529     C     ZIAMT1        IFLE      0
216000200529     C                   ADD       ZIAMTR        ZIA(Y)
216100200529     C                   Z-ADD     1             LOOP
216200200529
216300200529     C                   ELSE
216400200529     C                   ADD       ZBAL          ZIA(Y)
216500200529
216600200529     C                   END
216700200529
216800200529     C                   END
216900200529
217000200529     C                   END
217100200529
217200200529     C                   END
217300200529
217400200529      ** if the sub-type is from 50000 to 99999, calculate the interest
217500200529      ** on the amount exceeding the initial threshold. Otherwise, the
217600200529      ** interest is calculated on the whole balance whenever it exceeds
217700200529      ** the initial threshold.
217800200529
217900200529     C     INST          IFGE      50000
218000200529     C                   Z-ADD     1             Z
218100200529     C     Z             DOWLT     12
218200200529     C     ZITHR         ANDGT     0
218300200529     C     ZIA(Z)        SUB       ZITHR         ZIA(Z)
218400200529     C     ZIA(Z)        IFLT      0
218500200529     C                   Z-SUB     ZIA(Z)        ZITHR
218600200529     C                   Z-ADD     0             ZIA(Z)
218700200529     C                   ELSE
218800200529     C                   Z-ADD     0             ZITHR
218900200529     C                   END
219000200529     C                   ADD       1             Z
219100200529     C                   END
219200200529     C                   END
219300200529
219400200529      ** For calc basis 6, use the factored number of days
219500200529
219600200529     C     ZIA           MULT      ZIR           ZIA1
219700200529     C     ZICALC        IFEQ      6
219800200529     C     ZIA1          MULT      INT6DY        ZIA1
219900200529
220000200529     C                   ELSE
220100200529     C     ZIA1          MULT      ZDAYN2        ZIA1
220200200529     C                   ENDIF
220300200529
220400200529     C     ZICALC        IFEQ      7
220500200529     C     ZICALC        OREQ      5
220600200529     C     ZICALC        OREQ      3
220700200529     C     ZICALC        OREQ      2
220800200529     C     ZIA1          DIV(H)    36000         ZIN
220900200529
221000200529     C                   END
221100200529
221200200529     C     ZICALC        IFEQ      4
221300200529     C     ZICALC        OREQ      1
221400200529     C     ZIA1          DIV(H)    36500         ZIN
221500200529
221600200529     C                   END
221700200529
221800200529     C     ZICALC        IFEQ      6
221900200529     C     ZIA1          DIV(H)    36600         ZIN
222000200529
222100200529     C                   END
222200200529     C                   XFOOT     ZIN           ZINTR
222300200529
222400200529     C                   END
222500200529     C/COPY WNCPYSRC,RE3666C009
222600200529
222700200529     C                   ENDSR
222800200529      *****************************************************************
222900200529     C/EJECT
223000200529      *****************************************************************
223100200529
223200200529      ** ZIC02 subroutine to calculate interest (type=02)
223300200529      **     Called by       INTCAL
223400200529      **     Calls           ZICD
223500200529
223600200529     C     ZIC02         BEGSR
223700200529     C/COPY WNCPYSRC,RE3666C010
223800200529
223900200529      ** Fill the end of the table with highval
224000200529
224100200529     C                   Z-ADD     2             Z
224200200529     C     Z             DOWLE     11
224300200529     C     ZIB(Z)        IFEQ      *ZEROS
224400200529     C                   Z-ADD     *HIVAL        ZIB(Z)
224500200529     C                   END
224600200529     C                   ADD       1             Z
224700200529     C                   END
224800200529
224900200529      ** Reverse sign of amount if it's negative
225000200529
225100200529     C     ZIAMT         IFLT      0
225200200529     C                   Z-SUB     ZIAMT         ZIAMT
225300200529     C                   END
225400200529
225500200529      ** Interest is only calculated on an amount that exceeds the
225600200529      ** initial threshold balance
225700200529
225800200529     C     ZIAMT         IFGT      ZITHR
225900200529
226000200529      ** Find number of days to calculate interest according to calc. basis
226100200529      ** Make sure the correct Rate is used when History balance has a
226200200529      ** matching threshold balance.
226300200529
226400200529     C                   Z-ADD     1             Z
226500200529     C     ZIAMT         LOOKUP    ZIB(Z)                                 40
226600200529     C     *IN40         IFEQ      *OFF
226700200529     C                   Z-ADD     1             Z
226800200529     C     ZIAMT         LOOKUP    ZIB(Z)                               40
226900200529     C                   ENDIF
227000200529
227100200529      ** if the sub-type is from 50000 to 99999, calculate the interest
227200200529      ** on the amount exceeding the initial threshold. Otherwise, the
227300200529      ** interest is calculated on the whole balance whenever it exceeds
227400200529      ** the initial threshold.
227500200529
227600200529     C     INST          IFGE      50000
227700200529     C     ZIAMT         SUB       ZITHR         ZIAMT
227800200529     C                   END
227900200529
228000200529      ** For calc basis 6, use the factored number of days
228100200529
228200200529     C     ZIAMT         MULT      ZIR(Z)        ZIWRK1
228300200529     C     ZICALC        IFEQ      6
228400200529     C     ZIWRK1        MULT      INT6DY        ZIWRK2
228500200529
228600200529     C                   ELSE
228700200529     C     ZIWRK1        MULT      ZDAYN2        ZIWRK2
228800200529     C                   ENDIF
228900200529
229000200529     C     ZICALC        IFEQ      7
229100200529     C     ZICALC        OREQ      5
229200200529     C     ZICALC        OREQ      3
229300200529     C     ZICALC        OREQ      2
229400200529     C     ZIWRK2        DIV(H)    36000         ZINTR
229500200529
229600200529     C                   END
229700200529
229800200529     C     ZICALC        IFEQ      4
229900200529     C     ZICALC        OREQ      1
230000200529     C     ZIWRK2        DIV(H)    36500         ZINTR
230100200529
230200200529     C                   END
230300200529
230400200529     C     ZICALC        IFEQ      6
230500200529     C     ZIWRK2        DIV(H)    36600         ZINTR
230600200529
230700200529     C                   END
230800200529
230900200529     C/COPY WNCPYSRC,RE3666C022
231000200529     C/COPY WNCPYSRC,RE3666C023
231100200529     C                   END
231200200529     C/COPY WNCPYSRC,RE3666C011
231300200529
231400200529     C                   ENDSR
231500200529      *****************************************************************
231600200529     C/EJECT
231700200529      *****************************************************************
231800200529
231900200529      ** DRINIT subroutine for debit rates loading
232000200529      **     Called by       INTCAL
232100200529      **     Calls           DBSR
232200200529
232300200529     C     DRINIT        BEGSR
232400200529
232500200529     C                   Z-ADD     *ZEROS        ZIRD
232600200529     C                   Z-ADD     *ZEROS        ZIBD
232700200529     C                   Z-ADD     *ZERO         ZITHR
232800200529     C                   Z-ADD     *ZEROS        INTHD
232900200529
233000200529      ** Chain to Debit Rate Changes file
233100200529
233200200529     C                   Z-ADD     DRCD          KDATE
233300200529
233400200529     C     DCKEY         CHAIN     REHRDJ                             99
233500200529
233600200529      ** Error in REHRDJ
233700200529
233800200529     C     *IN99         IFEQ      '1'
233900200529     C     DRIB          ANDEQ     *ZEROS
234000200529     C     DRIS          ANDEQ     *ZEROS
234100200529     C                   MOVE      '0'           *IN99
234200200529     C                   END
234300200529
234400200529     C     *IN99         IFEQ      '1'
234500200529     C                   MOVE      *BLANKS       LFILE
234600200529     C                   Z-ADD     92            LDBNO
234700200529     C                   MOVEL     'REHRDJ'      LFILE
234800200529     C                   Z-ADD     KDATE         REHDAT
234900200529     C                   MOVE      *BLANKS       LKEY
235000200529     C                   MOVEL     REHKEY        LKEY
235100200529     C                   EXSR      DBSR
235200200529     C                   END
235300200529
235400200529      ** Pick-up debit threshold balance
235500200529
235600200529     C                   Z-ADD     INTHD         ZITHR
235700200529
235800200529      ** Setup work debit fields with fields read
235900200529
236000200529     C     RAT2          IFNE      *BLANKS
236100200529     C                   MOVEL     RAT2          WDRAT
236200200529     C                   END
236300200529
236400200529     C     RAT3          IFNE      *BLANKS
236500200529     C                   MOVE      RAT3          WDRAT
236600200529     C                   END
236700200529
236800200529     C     BAL2          IFNE      *BLANKS
236900200529     C                   MOVEL     BAL2          WDBAL
237000200529     C                   END
237100200529
237200200529     C     BAL3          IFNE      *BLANKS
237300200529     C                   MOVE      BAL3          WDBAL
237400200529     C                   END
237500200529
237600200529      ** Loading of debit interest rates and debit interest balances
237700200529
237800200529     C                   Z-ADD     ZIRD          ZIR
237900200529     C                   Z-ADD     ZIBD          ZIB
238000200529
238100200529     C                   ENDSR
238200200529
238300200529      *****************************************************************
238400200529     C/EJECT
238500200529      *****************************************************************
238600200529
238700200529      ** CRINIT subroutine for credit rates loading
238800200529      **     Called by       INTCAL
238900200529      **     Calls           DBSR
239000200529
239100200529     C     CRINIT        BEGSR
239200200529
239300200529     C                   Z-ADD     *ZEROS        ZIRC
239400200529     C                   Z-ADD     *ZEROS        ZIBC
239500200529     C                   Z-ADD     *ZERO         ZITHR
239600200529     C                   Z-ADD     *ZEROS        INTHC
239700200529
239800200529      ** Chain to Credit Rate Changes file
239900200529
240000200529     C                   Z-ADD     CRCD          KDATE
240100200529
240200200529     C     DCKEY         CHAIN     REHRCJ                             99
240300200529
240400200529      ** Error in REHRCJ
240500200529
240600200529     C     *IN99         IFEQ      '1'
240700200529     C     CRIB          ANDEQ     *ZEROS
240800200529     C     CRIS          ANDEQ     *ZEROS
240900200529     C                   MOVE      '0'           *IN99
241000200529     C                   END
241100200529
241200200529     C     *IN99         IFEQ      '1'
241300200529     C                   MOVE      *BLANKS       LFILE
241400200529     C                   Z-ADD     93            LDBNO
241500200529     C                   MOVEL     'REHRCJ'      LFILE
241600200529     C                   Z-ADD     KDATE         REHDAT
241700200529     C                   MOVE      *BLANKS       LKEY
241800200529     C                   MOVEL     REHKEY        LKEY
241900200529     C                   EXSR      DBSR
242000200529     C                   END
242100200529
242200200529      ** Pick-up credit threshold balance
242300200529
242400200529     C                   Z-ADD     INTHC         ZITHR
242500200529
242600200529      ** setup work credit fields with fields read processing
242700200529
242800200529     C     RAT2          IFNE      *BLANKS
242900200529     C                   MOVEL     RAT2          WCRAT
243000200529     C                   END
243100200529
243200200529     C     RAT3          IFNE      *BLANKS
243300200529     C                   MOVE      RAT3          WCRAT
243400200529     C                   END
243500200529
243600200529     C     BAL2          IFNE      *BLANKS
243700200529     C                   MOVEL     BAL2          WCBAL
243800200529     C                   END
243900200529
244000200529     C     BAL3          IFNE      *BLANKS
244100200529     C                   MOVE      BAL3          WCBAL
244200200529     C                   END
244300200529
244400200529      ** Loading of credit interest rates and credit interest balances
244500200529
244600200529     C                   Z-ADD     ZIRC          ZIR
244700200529     C                   Z-ADD     ZIBC          ZIB
244800200529
244900200529     C                   ENDSR
245000200529
245100200529      *****************************************************************
245200200529     C/EJECT
245300200529      *****************************************************************
245400200529
245500200529      ** DATEIN subroutine for date init processing
245600200529      **     Called by       INTCAL
245700200529      **     Calls           DBSR
245800200529
245900200529     C     DATEIN        BEGSR
246000200529
246100200529      ** Work Field init
246200200529
246300200529     C                   Z-ADD     *ZEROS        ZLDTM
246400200529
246500200529      ** Calculating date from day number (REACR histore date)
246600200529
246700200529     C                   Z-ADD     RHISD         ZDAYNO
246800200529     C                   EXSR      ZDATE2
246900200529
247000200529      ** Verify if error
247100200529
247200200529     C     *IN99         IFNE      '0'
247300200529     C                   MOVE      *BLANKS       LFILE
247400200529     C                   Z-ADD     94            LDBNO
247500200529     C                   MOVEL     'ZDATE2'      LFILE
247600200529     C                   MOVE      ZERROR        ERRDAT
247700200529     C                   MOVE      *BLANKS       LKEY
247800200529     C                   MOVEL     ERRDAT        LKEY
247900200529     C                   MOVEA     '1'           *IN(89)
248000200529     C                   EXSR      DBSR
248100200529     C                   END
248200200529
248300200529      ** Calculating first day of this month to calculate the last one
248400200529
248500200529     C                   Z-ADD     ZDATE         RESULT
248600200529     C                   Z-ADD     1             ZDAY
248700200529     C                   Z-ADD     RESULT        ZDATE
248800200529     C                   EXSR      ZDATE1
248900200529
249000200529      ** Verify if error
249100200529
249200200529     C     *IN99         IFNE      '0'
249300200529     C                   MOVE      *BLANKS       LFILE
249400200529     C                   Z-ADD     95            LDBNO
249500200529     C                   MOVEL     'ZDATE1'      LFILE
249600200529     C                   MOVE      ZERROR        ERRDAT
249700200529     C                   MOVE      *BLANKS       LKEY
249800200529     C                   MOVEL     ERRDAT        LKEY
249900200529     C                   MOVEA     '1'           *IN(89)
250000200529     C                   EXSR      DBSR
250100200529     C                   END
250200200529
250300200529     C     ZMTH          IFEQ      12
250400200529     C                   Z-ADD     1             ZMTH
250500200529     C                   ADD       1             ZYEAR
250600200529     C                   ELSE
250700200529     C                   ADD       1             ZMTH
250800200529     C                   END
250900200529
251000200529     C                   Z-ADD     RESULT        ZDATE
251100200529     C                   EXSR      ZDATE1
251200200529
251300200529      ** Verify if error
251400200529
251500200529     C     *IN99         IFNE      '0'
251600200529     C                   MOVE      *BLANKS       LFILE
251700200529     C                   Z-ADD     96            LDBNO
251800200529     C                   MOVEL     'ZDATE1'      LFILE
251900200529     C                   MOVE      ZERROR        ERRDAT
252000200529     C                   MOVE      *BLANKS       LKEY
252100200529     C                   MOVEL     ERRDAT        LKEY
252200200529     C                   MOVEA     '1'           *IN(89)
252300200529     C                   EXSR      DBSR
252400200529     C                   END
252500200529
252600200529     C     ZDAYNO        SUB       1             ZLDTM
252700200529
252800200529     C                   ENDSR
252900200529
253000200529      ********************************************************************
253100200529     C/EJECT
253200200529      ********************************************************************
253300200529      *   Subroutine SRPNAR determines the required narratives.          *
253400200529      ********************************************************************
253500200529     C     SRPNAR        BEGSR
253600200529
253700200529      ** Define the data structure parameter:
253800200529
253900200529     C     *LIKE         DEFINE    CGPNAR        ##PNAR
254000200529
254100200529      ** Define the narrative fields:
254200200529
254300200529     C                   MOVE      *BLANKS       O#PNAR           30
254400200529     C                   MOVE      *BLANKS       ##NARR
254500200529
254600200529      ** If the facility is switched off or unavailable,
254700200529      ** or UDC is not installed, exit this subroutine:
254800200529
254900200529     C     REPNAR        IFNE      'Y'
255000200529
255100200529      **  Determine the current narrative and message id to use (*IN31
255200200529      **  signifies Retail Account Number.)
255300200529
255400200529     C                   CLEAR                   DSPNAR
255500200529     C                   MOVE      I#TXT         D#TXT
255600200529     C     *IN31         IFEQ      *ON
255700200529     C                   MOVE      AACNO         D#ACNO
255800200529     C                   ELSE
255900200529     C                   MOVE      CNUM          D#CNUM
256000200529     C                   MOVE      CCY           D#CCY
256100200529     C                   MOVE      ACOD          D#ACOD
256200200529     C                   MOVE      ACSQ          D#ACSQ
256300200529     C                   MOVE      BRCA          D#BRCA
256400200529     C                   ENDIF
256500200529     C**********         MOVE      DSPNAR        O#PNAR                                       095479
256600200529     C                   MOVEL     DSPNAR        O#PNAR
256700200529     C                   GOTO      EXPNAR
256800200529     C                   ENDIF
256900200529
257000200529      ** Determine the customer's name:
257100200529      ** OUTPUT CALLS SRPNAM and OUTPUT can be called many times for same
257200200529      ** customer. If this is the same customer as the last CHAIN then use
257300200529      ** the last information gathered rather than call AOCUSTR* again
257400200529
257500200529     C                   MOVEL(P)  CNUM          ##KEY
257600200529
257700200529     C     *LIKE         DEFINE    CNUM          ##LCUS
257800200529     C     *LIKE         DEFINE    BBCRNM        ##LCRN
257900200529     C     CNUM          IFEQ      ##LCUS
258000200529     C                   MOVEL     ##LCRN        BBCRNM
258100200529     C                   ELSE
258200200529     C                   CALL      'AOCUSTR0'
258300200529     C                   PARM                    ##RTN             7
258400200529     C                   PARM      '*KEY   '     ##OPT             7
258500200529     C                   PARM                    ##KEY            10
258600200529     C                   PARM                    ##STS             7
258700200529     C     SDCUST        PARM      SDCUST        DSSDY
258800200529
258900200529     C     ##RTN         IFNE      *BLANKS
259000200529     C                   MOVEL     'SDCUSTPD'    DBFILE
259100200529     C                   MOVEL     '101'         DBASE
259200200529     C                   MOVEL     ##KEY         DBKEY
259300200529     C                   EXSR      *PSSR
259400200529     C                   ELSE
259500200529     C                   MOVEL     CNUM          ##LCUS
259600200529     C                   MOVEL     BBCRNM        ##LCRN
259700200529     C                   ENDIF
259800200529     C                   ENDIF
259900200529      *****************************************************************
260000200529     C/EJECT
260100200529      *****************************************************************
260200200529
260300200529      **  Determine the current narrative and message id to use (*IN31
260400200529      **  signifies Retail Account Number.)
260500200529
260600200529     C                   CLEAR                   DSPNAR
260700200529     C                   MOVE      I#TXT         D#TXT
260800200529     C     *IN31         IFEQ      *ON
260900200529     C                   MOVE      AACNO         D#ACNO
261000200529     C                   MOVE      'GB00752'     ##MGID
261100200529     C                   ELSE
261200200529     C                   MOVE      CNUM          D#CNUM
261300200529     C                   MOVE      CCY           D#CCY
261400200529     C                   MOVE      ACOD          D#ACOD
261500200529     C                   MOVE      ACSQ          D#ACSQ
261600200529     C                   MOVE      BRCA          D#BRCA
261700200529     C                   MOVE      'GB00380'     ##MGID
261800200529     C                   ENDIF
261900200529     C**********         MOVE DSPNAR    ##NARR                                       S01522 250390
262000200529     C                   MOVEL     DSPNAR        ##NARR
262100200529
262200200529      ** Determine the value for the first narrative using AOPNARR0:
262300200529
262400200529     C                   CLEAR                   CGPNAR
262500200529     C                   CLEAR                   ##PRM1
262600200529
262700200529     C                   MOVE      'RE'          MNMODI
262800200529     C                   MOVE      CNUM          MNCUST
262900200529     C                   MOVE      CCY           MNCYCD
263000200529     C                   MOVE      ACOD          MNACCD
263100200529     C                   MOVE      ACSQ          MNACSQ
263200200529     C                   MOVE      BRCA          MNBRCA
263300200529     C                   MOVE      AACNO         MNRACN
263400200529     C                   MOVE      BOKC          MNBOKC
263500200529     C                   MOVE      BBCRNM        MNCRNM
263600200529     C                   MOVEL(P)  ##NARR        MNNARR
263700200529     C                   MOVE      CNUM          MNASOC
263800200529     C/COPY WNCPYSRC,REH00406
263900200529
264000200529     C                   CALL      'AOPNARR0'
264100200529     C                   PARM                    ##RTN
264200200529     C                   PARM                    ##MGID            7
264300200529     C                   PARM                    ##PRM1
264400200529     C     CGPNAR        PARM      CGPNAR        ##PNAR
264500200529     C                   PARM                    ##NARR           50
264600200529     C/COPY WNCPYSRC,REH00407
264700200529
264800200529     C     ##RTN         IFNE      *BLANKS
264900200529     C                   MOVEL     'CGPNARPD'    DBFILE
265000200529     C                   MOVEL     '102'         DBASE
265100200529     C                   MOVEL     MNCUST        DBKEY
265200200529     C                   EXSR      *PSSR
265300200529     C                   ENDIF
265400200529
265500200529     C                   MOVEL     ##NARR        O#PNAR
265600200529
265700200529     C     EXPNAR        TAG
265800200529
265900200529     C                   ENDSR
266000200529      *****************************************************************
266100200529     C/COPY WNCPYSRC,RE3666C007
266200200529     C/COPY ZSRSRC,ZDATE2Z2LE
266300200529     C/COPY ZSRSRC,ZDATE1Z2LE
266400200529      *****************************************************************
266500200529
266600200529      ** Generated Entries
266700200529
266800200529      ** Detail Record
266900200529
267000200529     OGEIERPD   E    80
267100200529     O                                            1 'P'
267200200529
267300200529     O/COPY WNCPYSRC,RE3666OOP1
267400200529
267500200529     O                       BICN                 7
267600200529
267700200529     O/COPY WNCPYSRC,RE3666OOP2
267800200529
267900200529     O               38      CNUM                 7                                           CRE100
268000200529     O                       CCY                 10
268100200529     O                       QQACOD              14
268200200529     O/COPY WNCPYSRC,RE3666O003
268300200529     O                                           16 '01'
268400200529     O               39      ACSQ                16                                         MD034990
268500200529     O/COPY WNCPYSRC,RE3666O004
268600200529     O                                           32 '0000000000'
268700200529     O                       RNDT                35P
268800200529     O                       APDA                38P
268900200529     O                                           43 '91080'
269000200529     O              N65                          49 'ACCR. '
269100200529     O              N65N31   CNUM                55
269200200529     O              N65N31   CCY                 58
269300200529     O              N65N31   ACOD                68
269400200529     O              N65N31   ACSQ                70
269500200529     O              N65N31   BRCA                73
269600200529     O              N65 31   AACNO               63
269700200529     O               65      O#PNAR              73
269800200529     O                  83   PSTAD               80P
269900200529     O                  84   PSTAC               80P
270000200529     O                       DRCRGE              81
270100200529     O                       CNUM                87
270200200529     O                                           95 '00000000'
270300200529     O                                          102 'GE-IER'
270400200529     O                       BRCA               105
270500200529     O                                          106 '0'
270600200529     O                       ZERO03             108P
270700200529     O                       ZERO5              114P
270800200529     O                       ATYP               124
270900200529     O                       PRIN               128
271000200529     O                                          129 'I'
271100200529     O                                          130 '1'
271200200529     O              N70      PRFC               134
271300200529     O                       PTIM               140
271400200529     O                       VOIN               141
271500200529     O                       ACCS               146
271600200529     O                       LTAI               147
271700200529     O                       FACO               194
271800200529     O                       OTST               240
271900200529     O                       OTTP               250
272000200529     O                       SDCB               258P
272100200529     O                       SDLB               266P
272200200529     O                       BOKC               268
272300200529     O                       NITMS              271P
272400200529     O                       REBI               272
272500200529     O                       CHGA               279P
272600200529     O                       TRCCY              302
272700200529     O                       ORBR               309
272800200529     O                       XRFN               329
272900200529     O                       TRST               331
273000200529     O                       ACKEY              351
273100200529     O                       FEEFLG             352
273200200529     O                       FEEVAL             359P
273300200529     O                       FEEPCT             364
273400200529     O                       RORACT             384
273500200529     O                       RORCTY             386
273600200529     O                       RORBNK             406
273700200529     O                       RORCDE             417
273800200529     O                       PORACT             437
273900200529     O                       PORCTY             439
274000200529     O                       PORBNK             459
274100200529     O                       PORCDE             470
274200200529     O                       DSTACT             505
274300200529     O                       DSTCTY             507
274400200529     O                       DSTBNK             527
274500200529     O                       SETDAT             530P
274600200529     O                       TICKER             540
274700200529     O                       EXCHNG             560
274800200529     O                       NOMINL             573
274900200529     O                       FPTRID             589
275000200529     O                       ACODGE             599
275100200529     O                       OTRF               620
275200200529     O                       ORAMT              316P
275300200529
275400200529      ** Blank Profit Centre if Profit Centre not used
275500200529
275600200529     O               70                         134 '    '
275700200529
275800200529      ** Monthly Accruals
275900200529
276000200529      ** Detail Record
276100200529     O/COPY WNCPYSRC,RE3666O001
276200200529
276300200529     OACRLAR    E    81
276400200529     O         OR    82
276500200529     O                                            1 'D'
276600200529     O                       BRCA                 4
276700200529     O                       CNUM                10
276800200529     O                       CCY                 13
276900200529     O                       ACSQ                19
277000200529     O                       AACNO               29
277100200529     O                       ZERO13              36P
277200200529     O                       ZERO13              43P
277300200529     O                       ZERO13              50P
277400200529     O                  81   DAID                36P
277500200529     O                  81   DAIL                43P
277600200529     O                  81   DAIP                50P
277700200529     O                       ZERO13              57P
277800200529     O                       ZERO13              64P
277900200529     O                       ZERO13              71P
278000200529     O                  82   CAID                57P
278100200529     O                  82   CAIL                64P
278200200529     O                  82   CAIP                71P
278300200529     O                       ACOD                90
278400200529     O                  81   DIAD1              100
278500200529     O                  81   DIAC1              110
278600200529     O                  82   CIAD1              100
278700200529     O                  82   CIAC1              110
278800200529     O/COPY WNCPYSRC,RE3666O002
278900200529
279000200529      ** Trailer
279100200529
279200200529     OREACRLZZ  T
279300200529     O                       NOREZ                3P
279400200529     OREGEIEZZ  T
279500200529     O                       NORE1
279600200529     O                       HRWN                13P
279700200529     O                       HRDC                15P
279800200529
279900200529      ** REACR Detail
280000200529
280100200529     OREACRDF   E    86
280200200529
280300200529     O                       DAIC
280400200529     O                       CAIC
280500200529     O                       RHISD
280600200529     O/COPY WNCPYSRC,REH00154
280700200529
280800200529      ** Account Master
280900200529
281000200529     OACCNTABF  E    85
281100200529
281200200529      ** Debit fields
281300200529
281400200529     O                       LPAR
281500200529     O                       DIIE
281600200529
281700200529      ** Credit fields
281800200529
281900200529     O                       LPAP
282000200529     O                       CIIE
282100200529
282200200529      ** Blank profit centre if Profit Centre not used
282300200529
282400200529     O                       PRFC
282500200529
282600200529      ** File Controls
282700200529
282800200529     ORE3666AU  T    LR                     2 03
282900200529     O                                           22 'REFERENCE RE3666AU'
283000200529     O                       TITL                89
283100200529     O                                          104 'DATE'
283200200529     O                       RUNA               113
283300200529     O                                          122 'PAGE'
283400200529     O                       PAGE          Z    127
283500200529     O          T    LR                     1 08
283600200529     O                                           63 'POSTINGS TO INCOME'
283700200529     O                                           73 ' & EXPENSE'
283800200529     O                                           89 'RUN CONTROLS'
283900200529     O          T    LR                     3
284000200529     O                                           63 '------------------'
284100200529     O                                           73 '----------'
284200200529     O          T    LR                     3 24
284300200529     O                                           22 'FILE CONTROLS -'
284400200529     O          T    LRNU7                  1 35
284500200529     O                                           42 'GENERATED ENTRIES FILE'
284600200529     O          T    LRNU7                  2
284700200529     O                                           73 'NUMBER OF RECORDS WRITTE'
284800200529     O                                           74 'N'
284900200529     O                       RWGEI         3     89
285000200529     O          T    LRNU7                  1
285100200529     O                                           42 'MONTHLY ACCRUALS FILE'
285200200529     O          T    LRNU7                  3
285300200529     O                                           73 'NUMBER OF RECORDS WRITTE'
285400200529     O                                           74 'N'
285500200529     O                       RWACRL        3     89
285600200529
285700200529      ** Database Error
285800200529
285900200529     O          T    LR U7                    43
286000200529     O                                           58 'DATABASE ERROR '
286100200529     O                       DBASE               61
286200200529     O                                           75 'IN PROGRAM '
286300200529     O                       DBPGM               85
286400200529     O          T    LR U7               2
286500200529     O                                           48 'FILE '
286600200529     O                       DBFILE              56
286700200529     O                                           62 ', KEY '
286800200529     O                       DBKEY               91
286900200529**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
2870002005290366073110961461
287100200529**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
287200200529000031059090120151181212243273304334365
287300200529**   ZMNM - MONTHS SHORT NAMES
287400200529JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
287500200529** CPY@   **      OBJECT COPYRIGHT
287600200529(c) Finastra International Limited 2001
287700200529**   SVAL  -  SYSTEM VALUES ARRAY                                                             CRE100
287800200529RET_INTAC_CUST_LVL                                                                            CRE100
287900200529RET_SEQ_CUST_LVL                                                                            MD034990
