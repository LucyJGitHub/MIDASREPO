000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas MM Deal amendments database update')             *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - MM Dealer Module                                     *
000900200528      *                                                               *
001000200528      *  MMDEAMUPM - DEAL AMENDMENTS MM DATABASE UPDATE               *
001100200528      *                                                               *
001200200528      *  (c) Finastra International Limited 2001                      *
001300200528      *                                                               *
001400200528      *  (c) Finastra International Limited 2001                      *
001500200528      *                                                               *
001600200604      *  Last Amend No. 260173             Date 22May20               *
001700200528      *  Prev Amend No. CER050             Date 16Jun19               *
001800200528      *                 CSD102             Date 08Jan19               *
001900200528      *                 MD046248           Date 27Oct17               *
002000200528      *                 CGL165             Date 17Feb15               *
002100200528      *                 CDL096             Date 22Sep14               *
002200200528      *                 CDL094             Date 30May14               *
002300200528      *                 AR1044820          Date 17Jul13               *
002400200528      *                 AR821086           Date 30Aug11               *
002500200528      *                 CER049             Date 06Dec10               *
002600200528      *                 CRE073             Date 06Dec10               *
002700200528      *                 CSD083             Date 27May10               *
002800200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
002900200528      *                 259421             Date 16Apr09               *
003000200528      *                 258907             Date 26Feb08               *
003100200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
003200200528      * Midas Plus 1.4 Base ------------------------------------------*
003300200528      * Midas Plus 1.3 ----------- Base ------------------------------*
003400200528      *                 242552             Date 21Sep06               *
003500200528      *                 CSD031             Date 10Apr06               *
003600200528      *                 BUG7461            Date 14Jun06               *
003700200528      *                 CDL049             Date 11Jul06               *
003800200528      *                 CSD027A            Date 16May05               *
003900200528      *                 CSD027             Date 09Dec05               *
004000200528      *                 CDL038             Date 10May05               *
004100200528      *                 BUG8014            Date 15Aug05               *
004200200528      *                 CDL033             Date 10Feb05               *
004300200528      *                 CSW037A            Date 02May05               *
004400200528      *                 208884             Date 29Aug02               *
004500200528      *                 BUG6156            Date 15Mar05               *
004600200528      *                 CSD025             Date 11Jan05               *
004700200528      *                 CSW037             Date 15Dec04               *
004800200528      *                 CSW036             Date 15Dec04               *
004900200528      *                 BUG3499            Date 30Jun04               *
005000200528      *                 BUG3045            Date 01Jun04               *
005100200528      *                 CGL014             Date 20Oct03               *
005200200528      *                 CDL022             Date 03Feb04               *
005300200528      *                 CDL020             Date 03Feb04               *
005400200528      *                 CDL017             Date 03Feb04               *
005500200528      *                 NAD002             Date 26Mar04               *
005600200528      *                 CRE020             Date 20Jan04               *
005700200528      *                 CGL029             Date 01Sep03               *
005800200528      *                 222727             Date 05Nov03               *
005900200528      *                 222059             Date 10Oct03               *
006000200528      *                 CAP084             Date 25Jun03               *
006100200528      *                 CDE005             Date 19Aug02               *
006200200528      *                 CAS006             Date 21Jan03               *
006300200528      *                 CAS005             Date 16Dec02               *
006400200528      *                 CSD015             Date 14Oct02               *
006500200528      *                 CDL010             Date 02Aug02               *
006600200528      * Midas Release 4.01 -------------------------------------------*
006700200528      *                 CAS001             Date 23Nov01               *
006800200528      *                 CSC011             Date 18Sep01               *
006900200528      * Midas Release 4 --------------- Base -------------------------*
007000200528      *                 200400             Date 20Nov01               *
007100200528      * Midas DBA 3.04 -----------------------------------------------*
007200200528      *                 179510             Date 07Nov00               *
007300200528      * Midas DBA 3.03 -----------------------------------------------*
007400200528      *                 CDE001             Date 13Apr00               *
007500200528      * Midas DBA 3.02 -----------------------------------------------*
007600200528      *                 CAP051             Date 12Nov99               *
007700200528      *                 CDL007             Date 12Oct99               *
007800200528      *                 CPB001             Date 01Jun99               *
007900200528      *                 CAP013             Date 07Sep99               *
008000200528      *                 168345             Date 13Oct99               *
008100200528      * Midas DBA 3.01 -----------------------------------------------*
008200200528      *                 CDL006             Date 26Apr99               *
008300200528      * Midas DBA 3.00 ---------------- Base -------------------------*
008400200528      *                 CAP006             DATE 08Mar99               *
008500200528      *                 CAP002  *CREATE    Date 01Nov97               *
008600200528      *                                                               *
008700200528      *---------------------------------------------------------------*
008800200528      *                                                               *
008900200528      *  260173 - Synchronize parameter in MMDEAMRTV to avoid         *
009000200528      *           parameter mismatch. Apply fix 258724.               *
009100200528      *  CER050 - Annualised Percentage Rate (Recompile)              *
009200200528      *  CSD102 - Password Length Extension (Recompile)               *
009300200528      *  MD046248 - Finastra Rebranding                               *
009400200528      *  CGL165 - Dual Withholding Tax (Recompile)                    *
009500200528      *  CDL096 - Business Day Conventions on MM Deals                *
009600200528      *           (Recompile)                                         *
009700200528      *  CDL094 - Enhance Receive Settlement Instructions             *
009800200528      *  AR1044820 - Incorrect projected movements for Adjustment to  *
009900200528      *              Accrued Interest. Added parameters BeDealsDtlC,  *
010000200528      *              AfDealsDtlC, and CALLER for AOOUMMU0.            *
010100200528      *              (Child: AR1044821)                               *
010200200528      *  AR821086 - No stamp tax shadow posting generated for LDNI    *
010300200528      *             and DEAM                                          *
010400200528      *  CER049 - Stamp Tax                                           *
010500200528      *  CRE073 - Interest Rate Rounding (Recompile)                  *
010600200528      *  CSD083 - Watch List Compliance Upgrade                       *
010700200528      *  259421 - Check if java user before writing on DEAMSIQD.      *
010800200528      *  258907 - Amended program to populate DEAMSIQD when a deal    *
010900200528      *           amendment is inserted through an API and prevent    *
011000200528      *           errors from the deal amendment screen.              *
011100200528      *  242552 - MM Deal Amend loses Front Office Id when authorised *
011200200528      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
011300200528      *  BUG7461 - Authorising Officer shown as QUS                   *
011400200528      *  CDL049 - Addition of a Reference Rate field (recompile)      *
011500200528      *  CSD027A- Conversion Of Cust. no. to alpha (post build 103)   *
011600200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
011700200528      *  CDL038 - Extended Deal Sub Type                              *
011800200528      *  BUG8014 - Validate Date Format Indicator correctly.          *
011900200528      *  CDL033 - Floating Rate CDs Issued                            *
012000200528      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
012100200528      *  208884 - Delete of unauthorised deal received from interface *
012200200528      *           must send a "refused" message to the sender.        *
012300200528      *  BUG6156- DEAM - on amend, record not updated.                *
012400200528      *  CSD025 - Customer De-Activation                              *
012500200528      *  CSW037 - Additional Field Data on MT300/MT320                *
012600200528      *  CSW036 - Dual SWIFT BIC held on Client Details               *
012700200528      *  BUG3499- Decimal Data Error (Recompile)                      *
012800200528      *  BUG3045- Settlement details are not being updated for        *
012900200528      *           new amendment type 'EM'.                            *
013000200528      *  CGL014 - Collaterals Processing (Recompile)                  *
013100200528      *  CDL022 - Deal Amendment Changes (Recompile)                  *
013200200528      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
013300200528      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
013400200528      *  NAD002 - 10-Digit Account Code Errors                        *
013500200528      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
013600200528      *  CGL029 - Increase Account Code to 10 digits                  *
013700200528      *  222727 - Release 5.0 errors  (Recompile)                     *
013800200528      *  222059 - Timestamp error on insert/update of deal amendment  *
013900200528      *  CAP084 - Creation of wrappers for use with front end.        *
014000200528      *  CDE005 - Data Export - Reservation ID                        *
014100200528      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
014200200528      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
014300200528      *           (Recompile)                                         *
014400200528      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
014500200528      *  CDL010 - Prevent last user that actioned the trade from      *
014600200528      *           authorising it.                                     *
014700200528      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
014800200528      *  CSC011 - 24x7 Midas Availability                             *
014900200528      *  200400 - Reverse fix 179510 and replace it with a new fix.   *
015000200528      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
015100200528      *           Midas  Our  Receive/ Pay  Instructions  respectively*
015200200528      *           not  correctly  updated .  Introduced  new parametrs*
015300200528      *           when  calling   ZAALTRECIN/ PAYIN  modules .        *
015400200528      *  CDE001 - Data Export - CCRM Limits                           *
015500200528      *  CAP051 - Automatic Authorisation (MM Part)                   *
015600200528      *  CDL007 - Deposit Breakdown Penalty                           *
015700200528      *           Recompiled due to changes in MMDELDPP               *
015800200528      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
015900200528      *           Recompiled due to changes in MMDELDPP               *
016000200528      *  CAP013 - Allow access by Midas transaction ID if not insert  *
016100200528      *  168345 - Prevent two users from accessing same transaction   *
016200200528      *           in repair screen at the same cycle, and converting  *
016300200528      *           it into two different Midas Deal No.s  .            *
016400200528      *           Second user should not be allowed to repair the     *
016500200528      *           transaction and convert it into a another           *
016600200528      *           Midas Deal.                                         *
016700200528      *  CDL006 - Dealing Fiduciary.                                  *
016800200528      *  CAP006 - Check for deal being updated by another workstation *
016900200528      *  CAP002 - Conversion of Midas inputs to modular API structure *
017000200528      *                                                               *
017100200528      *****************************************************************
017200200528     FMMDAMULL  UF A E           K DISK
017300200528     F                                     COMMIT
017400200528     FMMDEALLL  IF   E           K DISK    INFDS(FDS)
017500200528     F                                     INCLUDE(MMDELDP0: MMDENBP0)
017600200528      *                                                                                       258907
017700200528     FDEAMSIQD  UF A E           K DISK    INFSR(SRERR)                                       258907
017800200528     F                                     PREFIX(DHC_)
017900200528                                                                                              CSD015
018000200528      ** Compliance Watch Hit List                                                            CSD015
018100200528     FSDCWHTL1  IF   E           K DISK    INFSR(SRERR)                                       CSD015
018200200528
018300200528     FREADVCL2  UF   E           K DISK    INFSR(SRERR)                                       CRE020
018400200528     F                                     USROPN                                             CRE020
018500200528      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref/Seq No                     CRE020
018600200528                                                                                              CSD015
018700200528     F/COPY WNCPYSRC,MMH00170
018800200528      *****************************************************************
018900200528      ** +--------------------------------------+
019000200528      ** ¦ Automatically included D-specs       ¦
019100200528      ** ¦ ==============================       ¦
019200200528      ** +--------------------------------------+
019300200528      **
019400200528      ** Standard D-specs
019500200528      ** ================
019600200528      **
019700200528      ** The following /COPY line includes the LDA layout,
019800200528      ** the copyright array definition,
019900200528      ** and the following named constants:
020000200528      **    True       logical = *on (for indcator processing)
020100200528      **    False      logical = *off (for indcator processing)
020200200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
020300200528      **                                    handler)
020400200528      ** and the following variables:
020500200528      **    RunBefore  1A (for the PSSR)
020600200528
020700200528     D/COPY ZACPYSRC,STD_D_SPEC
020800200528
020900200528      ** Include the MM standard declares
021000200528     D/COPY ZACPYSRC,STDDECLARE
021100200528
021200200528      ** Program Status Data Structure
021300200528      ** =============================
021400200528      ** The following /COPY line includes all the defined fields in the
021500200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
021600200528
021700200528     D/COPY ZACPYSRC,PSDS
021800200528
021900200528      **------------------------------------------------------------------------CAP006 -------------
022000200528      ** The following /COPY line includes the definitions for error and        CAP006
022100200528      ** warning message arrays.                                                CAP006
022200200528     D/COPY ZACPYSRC,ERR_ARRAYS                                                 CAP006
022300200528      **------------------------------------------------------------------------CAP006--------------
022400200528                                                                                CAP006
022500200528      ** +--------------------------------------+
022600200528      ** ¦ End of automatically included D-specs¦
022700200528      ** ¦ =====================================¦
022800200528      ** +--------------------------------------+
022900200528
023000200528      *****************************************************************
023100200528
023200200528      ** DEFINE FIELDS FOR ZDATE9
023300200528     D @DAYN           S              5P 0
023400200528     D @YMD            S              8S 0
023500200528     D @RETN           S              1A
023600200528
023700200528      ** Timestamp for the transaction                                          CAP006
023800200528     D TimeStamp       S               Z                                        CAP006
023900200528                                                                                CAP006
024000200528      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR DEAL AMENDMENT
024100200528     D MMVDEM        E DS                  EXTNAME(MMVDEAMPD)
024200200528     D  @IGCTL                 1     23
024300200528     D  @IGVDY                49     56  0
024400200528     D  @IGTDY                57     64  0
024500200528     D  @IGDDY                71     78  0
024600200528     D  @IGALR                93    143
024700200528     D  @IGALP               144    249
024800200528     D  @IGREC               300    368
024900200528     D  @IGPY1               369    574
025000200528     D  @IGPY2               575    717
025100200528     D  @IGPY3               718    927
025200200528
025300200528      **  DEAMS FILE - DEAL AMENDMENTS
025400200528     D MMDEAM        E DS                  EXTNAME(MMDEAMPP)
025500200528     D MMDEAMDORI    E                     EXTFLD(QQDORI)                                     CGL029
025600200528     D MMDEAMMORI    E                     EXTFLD(QQMORI)                                     CGL029
025700200528     D MMDEAMDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
025800200528     D MMDEAMMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
025900200528     D MMDEAMRONS    E                     EXTFLD(QQRONS)                                     CGL029
026000200528     D MMDEAMPONS    E                     EXTFLD(QQPONS)                                     CGL029
026100200528     D  @HNCTL                 1     23
026200200528     D  @HNALR                93    143
026300200528     D  @HNALP               144    249
026400200528     D  @HNREC               300    368
026500200528     D  @HNPY1               369    574
026600200528     D  @HNPY2               575    717
026700200528     D  @HNPY3               718    927
026800200528
026900200528      **  DEALS FILE - LOANS/DEPOSITS & NAS ISSUED
027000200528     D MMDELD        E DS                  EXTNAME(MMDELDPP)
027100200528     D MMDELDDORI    E                     EXTFLD(QQDORI)                                     CGL029
027200200528     D MMDELDMORI    E                     EXTFLD(QQMORI)                                     CGL029
027300200528     D MMDELDDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
027400200528     D MMDELDMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
027500200528     D MMDELDRONS    E                     EXTFLD(QQRONS)                                     CGL029
027600200528     D MMDELDPONS    E                     EXTFLD(QQPONS)                                     CGL029
027700200528     D  @HKVDY                50     57  0
027800200528
027900200528     D/COPY WNCPYSRC,MMH00171
028000200528      **  DEALS FILE - NEGOTIABLE ASSETS BOUGHT
028100200528     D MMDENB        E DS                  EXTNAME(MMDENBPP)
028200200528     D  @HLVDY                50     57  0
028300200528
028400200528     D ChkDealFmt    E DS                  EXTNAME(MMDEAMPP)                    CAP006
028500200528      ** Rename fields for Timestamp checking                                   CAP006
028600200528     D                                     PREFIX(CH)                           CAP006
028700200528                                                                                CAP006
028800200528     D MMEDEM        E DS                  EXTNAME(MMEDEAMPD)                   CAP006
028900200528      * Error indicators                                                        CAP006
029000200528                                                                                CAP006
029100200528      **  EXTERNALLY DESCRIBED DATA STRUCTURES FOR TEMPLATE FILES FOR
029200200528      **  PROJECTED ACCOUNT MOVEMENTS UPDATES
029300200528     D Z#BSTS        E DS                  EXTNAME(Z#BST)
029400200528     D Z#ASTS        E DS                  EXTNAME(Z#AST)
029500200528     D Z#WSTS        E DS                  EXTNAME(Z#WST)
029600200528     D DLDLQD        E DS                  EXTNAME(DLSTMPPD)                                  CER049
029700200528
029800200528      ** FILE STATUS DATA STRUCTURE - RECORD FORMAT
029900200528     D FDS             DS
030000200528     D  ##FORM           *RECORD
030100200528
030200200528      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS
030300200528
030400200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
030500200528      * DATA STRUCTURE FOR BANK DETAILS
030600200528
030700200528     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
030800200528      * DATA STRUCTURE FOR DEAL DATA CODES
030900200528
031000200528     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
031100200528      * DATA STRUCTURE FOR MODULE DETAILS
031200200528
031300200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP051
031400200528      * DATA STRUCTURE FOR SWITCHABLE FEATURE DETAILS                           CAP051
031500200528                                                                                CAP051
031600200528     D DSFDY         E DS                  EXTNAME(DSFDY)
031700200528      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
031800200528                                                                                              CSC011
031900200528     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
032000200528      ** SD data area                                                                         CSC011
032100200528                                                                                              CSC011
032200200528     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
032300200528      ** 24X7 status dataarea                                                                 CSC011
032400200528                                                                                              CSC011
032500200528     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
032600200528      ** Midas API Message Header Format Definition                                           CSC011
032700200528                                                                                              CSD015
032800200528     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
032900200528      ** Compliance Watch Configuration Data DS                                               CSD015
033000200528                                                                                              CSD015
033100200528     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
033200200528      ** External DS for Customer Details                                                     CSD015
033300200528                                                                                              CSD015
033400200528     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
033500200528      ** External DS for Watch List Checking Details                                          CSD015
033600200528                                                                                              CSD015
033700200528     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                  CSD015
033800200528      ** Watch List Transaction Details Data Structure                                        CSD015
033900200528                                                                                              CSD015
034000200528     D WLFBC         E DS                  EXTNAME(MMDEAMPP)                                  CSD015
034100200528     D                                     PREFIX(BC:2)                                       CSD015
034200200528     D MMDEAMDORI2   E                     EXTFLD(QQDORI)                                     CGL029
034300200528     D MMDEAMMORI2   E                     EXTFLD(QQMORI)                                     CGL029
034400200528     D MMDEAMDOPI2   E                     EXTFLD(QQDOPI)                                     CGL029
034500200528     D MMDEAMMOPI2   E                     EXTFLD(QQMOPI)                                     CGL029
034600200528     D MMDEAMRONS2   E                     EXTFLD(QQRONS)                                     CGL029
034700200528     D MMDEAMPONS2   E                     EXTFLD(QQPONS)                                     CGL029
034800200528      ** Backup Container of the Watch List Fields                                            CSD015
034900200528                                                                                              CSD015
035000200528     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSD015
035100200528      * Long DS for Access Programs                                                           CSD015
035200200528
035300200528     D InvRp         E DS                  EXTNAME(MMIDEAMPD)                                 208884
035400200528     D                                     PREFIX(R:2)                                        208884
035500200528                                                                                              208884
035600200528     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                AR821086
035700200528      ** File - Payment Further Settlement Instructions                                     AR821086
035800200528                                                                                            AR821086
035900200528     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                AR821086
036000200528      ** File - Receive Further Settlement Instructions                                     AR821086
036100200528      * RUN DATE & MULTI-BRANCHING INDICATOR
036200200528
036300200528     D RUNDAT          DS
036400200528     D  @DLUP                  1      2  0
036500200528     D  @MLUP                  3      5
036600200528     D  @YLUP                  6      7  0
036700200528     D  @MBIN                 13     13
036800200528                                                                                CAP006
036900200528      **  Data Structure to split value date used in key to deams file          CAP006
037000200528     D                 DS                                                       CAP006
037100200528     D  @KVALD                 1      8  0 INZ(0)                               CAP006
037200200528     D  @VDYY                  1      4  0                                      CAP006
037300200528     D  @VYEAR                 3      4  0                                      CAP006
037400200528     D  @VDMM                  5      6  0                                      CAP006
037500200528     D  @VDDD                  7      8  0                                      CAP006
037600200528                                                                                CAP006
037700200528     D                 DS                                                       CAP006
037800200528      **  Data Structure for screen value date                                  CAP006
037900200528     D  ValueDate              1      6                                         CAP006
038000200528     D  @DSPD                  1      2                                         CAP006
038100200528     D  @DSPM                  3      4                                         CAP006
038200200528     D  @DSPY                  5      6                                         CAP006
038300200528                                                                                             BUG7461
038400200528     D ZMUSER        E DS                  EXTNAME(ZMUSER)                                   BUG7461
038500200528                                                                                CAP006
038600200528      ** Dummy message ID and message file fields for use on the calls to       CAP006
038700200528      ** ZAMSGTOOPR                                                             CAP006
038800200528     D DummyMsgID      S                   LIKE(#MsgID)                         CAP006
038900200528     D DummyMsgF       S             10A                                        CAP006
039000200528                                                                                CAP006
039100200528     D CSC011          S              1A   INZ('N')                                           CSC011
039200200528     D TRANSDTL        S           5800A                                                      CSC011
039300200528     D PTimestamp      S             26A                                                      CSC011
039400200528     D*PDealNo         S             18A                                               CSC011 CGL029
039500200528     D*PADealNo        S             18A                                               CSC011 CGL029
039600200528     D PDealNo         S             24A                                                      CGL029
039700200528     D PADealNo        S             24A                                                      CGL029
039800200528     D WYear           S              4A                                                      CSC011
039900200528     D WMonth          S              2A                                                      CSC011
040000200528     D WDay            S              2A                                                      CSC011
040100200528     D WDeal           S              6A                                                      CSC011
040200200528     D PRTCD           S              7A                                                      CSC011
040300200528     D POPTN           S              7A                                                      CSC011
040400200528     D PSARD           S              6A                                                      CSC011
040500200528                                                                                              CSC011
040600200528      ** Max. no. of elements associated with the CE arrays.                                  CSD015
040700200528     D ArrMax          C                   CONST(13)                                          CSD015
040800200528                                                                                              CSD015
040900200528      ** XML Opening Tags for the Compliance Engine.                                          CSD015
041000200528     D XOT             S             25A   DIM(ArrMax) PERRCD(1) CTDATA                       CSD015
041100200528                                                                                              CSD015
041200200528      ** XML Closing Tags for the Compliance Engine.                                          CSD015
041300200528     D XCT             S             25A   DIM(ArrMax) PERRCD(1) CTDATA                       CSD015
041400200528                                                                                              CSD015
041500200528      ** Formatted Watch List Fields Array.                                                   CSD015
041600200528     D WLF             S             35A   DIM(ArrMax)                                        CSD015
041700200528                                                                                              CSD015
041800200528      ** Watch List Fields Account line Array.                                                CSD015
041900200528     D WLFSD           S             35A   DIM(ArrMax)                                        CSD015
042000200528                                                                                              CSD015
042100200528      ** Parameter on access to Customer Details                                              CSD015
042200200528     D PCustNo         S             10A                                                      CSD015
042300200528     D PErrInf         S              7A                                                      CSD015
042400200528                                                                                              CSD015
042500200528      ** Compliance Watch Indicator                                                           CSD015
042600200528     D CSD015          S              1A   INZ('N')                                           CSD015
042700200528                                                                                              CSD015
042800200528      ** Concord Interface Development Indicator                                              CSD015
042900200528     D CCF001          S              1A   INZ('N')                                           CSD015
043000200528                                                                                              CSD015
043100200528      ** AOWLCCR0 Function Code Parameter                                                     CSD015
043200200528     D PFuncCode       S              8                                                       CSD015
043300200528                                                                                              CSD015
043400200528      ** Compliance Engine Free Format String Parameter                                       CSD015
043500200528     D PFreeFmtStr     S          30000A                                                      CSD015
043600200528                                                                                              CSD015
043700200528      ** SDCWLFMT Parameters                                                                  CSD015
043800200528     D PInpA           S             35                                                       CSD015
043900200528     D PInpB           S             35                                                       CSD015
044000200528     D PInpC           S             35                                                       CSD015
044100200528     D PInpD           S             35                                                       CSD015
044200200528     D PInpE           S             35                                                       CSD015
044300200528                                                                                              CSD015
044400200528      ** ZACVTAMT Parameters                                                                  CSD015
044500200528     D PZARtCd         S             10                                                       CSD015
044600200528     D PZACcy          S              3                                                       CSD015
044700200528     D PZANtvAmt       S             15                                                       CSD015
044800200528     D PZAAmt          S             18  3                                                    CSD015
044900200528     D PZACvtAmt       S             16                                                       CSD015
045000200528                                                                                              CSD015
045100200528      ** Working Date Data Structure                                                          CSD015
045200200528     D WDATE           DS                                                                     CSD015
045300200528     D  WLongYr                1      4  0                                                    CSD015
045400200528     D  WShortYr               3      4  0                                                    CSD015
045500200528     D  WMnth                  5      6  0                                                    CSD015
045600200528     D  WDays                  7      8  0                                                    CSD015
045700200528                                                                                              CSD015
045800200528      ** Work Variables                                                                       CSD015
045900200528     D Ctr             S              2  0                                                    CSD015
046000200528     D WData           S            216                                                       CSD015
046100200528     D WData2          S              6                                                       CSD015
046200200528     D WXMLPacket      S            400                                                       CSD015
046300200528     D WMoveMode       S              1                                                       CSD015
046400200528     D WCompMode       S              1                                                       CSD015
046500200528     D WChgFlg         S              1                                                       CSD015
046600200528     D WOKFlg          S              1                                                       CSD015
046700200528     D WRetryFlg       S              1                                                       CSD015
046800200528     D WCtrpRpt        S             30                                                       CSD015
046900200528     D WCtrpTyp        S              1                                                       CSD015
047000200528     D WDDT            S             10A                                                      CSD015
047100200528     D WAMT            S             18  3                                                    CSD015
047200200528     D WCcy            S              3                                                       CSD015
047300200528     D WHNDA3          S              6A                                                      CSD015
047400200528     D WHNVDY          S              4A                                                      CSD015
047500200528     D WHNVDM          S              2A                                                      CSD015
047600200528     D WHNVDD          S              2A                                                      CSD015
047700200528     D WHNDS3          S              3A                                                      CSD015
047800200528                                                                                              CSD015
047900200528      ** Compliance Watch Hit List Key Fields                                                 CSD015
048000200528     D KFuncType       S              8A                                                      CSD015
048100200528     D KIden           S             40A                                                      CSD015
048200200528     D KBranch         S              3A                                                      CSD015
048300200528                                                                                              CSD015
048400200528      ** WMoveMode Constants                                                                  CSD015
048500200528     D ALL             C                   CONST('A')                                         CSD015
048600200528     D CHANGED         C                   CONST('C')                                         CSD015
048700200528                                                                                              CSD015
048800200528      ** WCompMode Constants                                                                  CSD015
048900200528     D OnInsert        C                   CONST('I')                                         CSD015
049000200528     D OnAmend         C                   CONST('A')                                         CSD015
049100200528                                                                                              CSD015
049200200528      ** Define fields used in CDL010                                                         CDL010
049300200528     D CDL010          S              1A                                                      CDL010
049400200528                                                                                              CDL010
049500200528      ** CRE020 Variables                                                                     CRE020
049600200528     D CRE020          S              1A                                                      CRE020
049700200528     D KRefNo          S             30A                                                      CRE020
049800200528     D KSeqNo          S              3A                                                      CRE020
049900200528     D KPrgMn          S             10A   INZ('MMDEAMUPD ')                                  CRE020
050000200528     D PSysVal01       S             20A   INZ('DealAmendments      ')                        CRE020
050100200528     D PCurSet01       S            200A                                                      CRE020
050200200528     D PSysVal02       S             20A                                                      CRE020
050300200528     D PCurSet02       S            200A                                                      CRE020
050400200528     D PSysVal03       S             20A                                                      CRE020
050500200528     D PCurSet03       S            200A                                                      CRE020
050600200528     D PSysVal04       S             20A                                                      CRE020
050700200528     D PCurSet04       S            200A                                                      CRE020
050800200528     D PSysVal05       S             20A                                                      CRE020
050900200528     D PCurSet05       S            200A                                                      CRE020
051000200528     D PSysVal06       S             20A                                                      CRE020
051100200528     D PCurSet06       S            200A                                                      CRE020
051200200528     D PSysVal07       S             20A                                                      CRE020
051300200528     D PCurSet07       S            200A                                                      CRE020
051400200528     D PSysVal08       S             20A                                                      CRE020
051500200528     D PCurSet08       S            200A                                                      CRE020
051600200528     D PSysVal09       S             20A                                                      CRE020
051700200528     D PCurSet09       S            200A                                                      CRE020
051800200528     D PSysVal10       S             20A                                                      CRE020
051900200528     D PCurSet10       S            200A                                                      CRE020
052000200528     D WSysVal01       S              1A                                                      CRE020
052100200528                                                                                              CRE020
052200200528     D PAFRCD          S            100A                                                      CDL033
052300200528     D PBFRCD          S            100A                                                      CDL033
052400200528     D CDL033          S              1A   INZ('N')                                           CDL033
052500200528      ** Switchable Feature CDL033                                                            CDL033
052600200528      **                                                                                      CDL033
052700200528      *                                                                                    AR1044820
052800200528      ** DS for DEALSDC - Before being updated by a program.                               AR1044820
052900200528      *                                                                                    AR1044820
053000200528     D BeDealsDtlC   E DS                  EXTNAME(DEALSDC)                                AR1044820
053100200528     D                                     PREFIX(BE_)                                     AR1044820
053200200528      *                                                                                    AR1044820
053300200528      ** DS for DEALSDC - After being updated by a program.                                AR1044820
053400200528      *                                                                                    AR1044820
053500200528     D AfDealsDtlC   E DS                  EXTNAME(DEALSDC)                                AR1044820
053600200528     D                                     PREFIX(AF_)                                     AR1044820
053700200528      /EJECT
053800200528     C*****************************************************************
053900200528     C*                                                               *
054000200528     C* MAIN - MAIN BODY                                              *
054100200528     C*                                                               *
054200200528     C*****************************************************************
054300200528     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7461
054400200528     C                   IN        ZMUSER                                                    BUG7461
054500200528     C                   UNLOCK    ZMUSER                                                    BUG7461
054600200528      *
054700200528      ** INITIALIZE WORK FIELDS
054800200528      *
054900200528     C                   MOVEL     *BLANK        Z#BSTS
055000200528     C                   MOVEL     *BLANK        Z#ASTS
055100200528     C                   MOVEL     *BLANK        Z#WSTS
055200200528      *                                                                         CAP051
055300200528      ***  Transaction coming from Interface require an Automatic Authorisation CAP051
055400200528      *                                                                         CAP051
055500200528     C     CAP051        IFEQ      'Y'                                          CAP051
055600200528     C     IGAUTH        ANDEQ     'Y'                                          CAP051
055700200528     C                   MOVE      'N'           BNMMAU                         CAP051
055800200528     C                   MOVE      'N'           BNMMRA                         CAP051
055900200528     C                   ELSE                                                   CAP051
056000200528     C                   MOVE      SAVMAU        BNMMAU                         CAP051
056100200528     C                   MOVE      SAVMRA        BNMMRA                         CAP051
056200200528     C                   ENDIF                                                  CAP051
056300200528      *
056400200528      * SET CONTROL FIELDS
056500200528      *
056600200528     C                   EXSR      SETCTL
056700200528      *
056800200528      * CVTVDT - CONVERT DEAL AMENDMENT VALUE DATE TO YYYYMMDD FORMAT
056900200528      *
057000200528     C                   EXSR      CVTVDT
057100200528      *
057200200528      ** Ensure transaction has not been updated by another workstation         CAP006
057300200528      *INSERT so, bypass updating and return to calling program.                CAP006
057400200528     C                   EXSR      CHKOTHUPD                                    CAP006
057500200528                                                                                CAP006
057600200528     C     @@RTCD        IFNE      *BLANKS                                      CAP006
057700200528     C                   GOTO      EXIT                                         CAP006
057800200528     C                   END                                                    CAP006
057900200528                                                                                CAP006
058000200528      * DO INSERT, AMEND, AUTHORIZE OR DELETE PROCESSING
058100200528      *
058200200528     C     IGLACT        CASEQ     'I'           INSERT
058300200528     C     IGLACT        CASEQ     'A'           AMEND
058400200528     C     IGLACT        CASEQ     'X'           AUTHOR
058500200528     C     IGLACT        CASEQ     'D'           DELETE
058600200528     C                   END
058700200528      *
058800200528      ** DO ON-LINE UPDATES
058900200528      *
059000200528     C     IGLACT        IFEQ      'I'
059100200528     C     IGLACT        OREQ      'A'
059200200528     C     IGLACT        OREQ      'D'
059300200528     C                   EXSR      ONLNUP
059400200528     C                   END
059500200528      *
059600200528      *
059700200528      ** DO TREASURY MANAGEMENT UPDATES
059800200528      *
059900200528     C     BGTRMG        IFEQ      'Y'
060000200528     C     IGLACT        IFEQ      'I'
060100200528     C     IGLACT        OREQ      'A'
060200200528     C     IGLACT        OREQ      'D'
060300200528     C                   EXSR      TREAUP
060400200528     C                   END
060500200528     C                   END
060600200528                                                                                              CSC011
060700200528      ** If 24x7 Midas Availability is installed, write to the standard                       CSC011
060800200528      ** log file when support system is active                                               CSC011
060900200528                                                                                              CSC011
061000200528     C                   IF        CSC011 = 'Y' AND                                           CSC011
061100200528     C                             S1SUPP = LIBR                                              CSC011
061200200528                                                                                              CSC011
061300200528      ** Setup Loans/Deposits support log                                                     CSC011
061400200528                                                                                              CSC011
061500200528     C                   CALLB     'MMDEAMLOG'                                                CSC011
061600200528     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
061700200528     C                   PARM                    IGLACT                                       CSC011
061800200528     C                   PARM                    MMVDEM                                       CSC011
061900200528     C                   PARM                    TRANSDTL                                     CSC011
062000200528                                                                                              CSC011
062100200528      ** Write to support database log file                                                   CSC011
062200200528                                                                                              CSC011
062300200528     C                   IF        RetCodeOut = *BLANKS                                       CSC011
062400200528                                                                                              CSC011
062500200528     C                   EVAL      APTGTTYPE = 'MMDEAM'                                       CSC011
062600200528     C                   EVAL      APUSERID = PSUser                                          CSC011
062700200528     C                   EVAL      APRPRLOCN = IGREPA                                         CSC011
062800200528     C                   MOVEL     IGFRNT        APFOTRANID                                   CSC011
062900200528     C                   MOVEL     IGVDYY        WYear                                        CSC011
063000200528     C                   MOVEL     IGVDMM        WMonth                                       CSC011
063100200528     C                   MOVEL     IGVDDD        WDay                                         CSC011
063200200528     C                   MOVEL     IGDA38        WDeal                                        CSC011
063300200528     C                   EVAL      PDealNo = WDeal + WYear + WMonth                           CSC011
063400200528     C                                       + WDay + SequenceNo                              CSC011
063500200528                                                                                              CSC011
063600200528     C                   IF        IGAFRT = *BLANKS                                           CSC011
063700200528     C     ##FORM        IFEQ      'MMDELDP0'                                                 CSC011
063800200528     C                   MOVEL     HKFRNT        APFOASOCID                                   CSC011
063900200528     C                   ELSE                                                                 CSC011
064000200528     C                   MOVEL     HLFRNT        APFOASOCID                                   CSC011
064100200528     C                   ENDIF                                                                CSC011
064200200528                                                                                              CSC011
064300200528     C                   ELSE                                                                 CSC011
064400200528     C                   MOVEL     IGAFRT        APFOASOCID                                   CSC011
064500200528     C                   ENDIF                                                                CSC011
064600200528                                                                                              CSC011
064700200528     C                   CALLB     'APLOGTRAN'                                                CSC011
064800200528     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
064900200528     C                   PARM                    APHEAD                                       CSC011
065000200528     C                   PARM                    TRANSDTL                                     CSC011
065100200528     C                   PARM      *BLANKS       PTimestamp                                   CSC011
065200200528     C                   PARM                    PDealNo                                      CSC011
065300200528     C                   PARM      *BLANKS       PADealNo                                     CSC011
065400200528                                                                                              CSC011
065500200528     C                   ENDIF                                                                CSC011
065600200528                                                                                              CSC011
065700200528      ** If error occured,                                                                    CSC011
065800200528                                                                                              CSC011
065900200528     C                   IF        RetCodeOut <> *BLANKS                                      CSC011
066000200528                                                                                              CSC011
066100200528     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
066200200528                                                                                              CSC011
066300200528     C                   ENDIF                                                                CSC011
066400200528                                                                                              CSC011
066500200528     C                   ENDIF                                                                CSC011
066600200528      *
066700200528      * EXIT FROM PROGRAM
066800200528     C     EXIT          TAG                                                    CAP006
066900200528      *
067000200528     C                   RETURN
067100200528     C*****************************************************************
067200200528      /EJECT
067300200528     C*****************************************************************
067400200528     C*                                                               *
067500200528     C* INSERT - Deal Amendment Inserts                               *
067600200528     C*                                                               *
067700200528     C*****************************************************************
067800200528     C     INSERT        BEGSR
067900200528     C*
068000200528     C** ACCESS RELATED DEAL INFORMATION
068100200528     C*
068200200528     C                   EXSR      ACRDEL
068300200528     C*
068400200528     C**  SET DEAL FIELDS ON INSERT
068500200528     C*
068600200528     C                   EXSR      SETINS
068700200528     C*
068800200528     C**  ACCESS DEAL AMENDMENT
068900200528     C*
069000200528     C                   CLEAR                   MMDEAM
069100200528     C     DEAMK         CHAIN     MMDEAMP0                           99
069200200528     C*
069300200528     C**  UPDATE 'BEFORE' STATUS
069400200528     C*
069500200528     C                   MOVEL     MMDEAM        Z#BSTS
069600200528     C                   MOVEL     MMDEAM        WLFBC                                        CSD015
069700200528     C*
069800200528     C**  UPDATE DEAL AMENDMENT
069900200528     C*
070000200528     C                   MOVEL     MMVDEM        MMDEAM
070100200528                                                                                CDL006
070200200528      ** Fiduciary charge details                                               CDL006
070300200528      ** - Fiduciary charge code                                                CDL006
070400200528                                                                                CDL006
070500200528     C                   Eval      FCGC = IGFCGC                                CDL006
070600200528                                                                                CDL006
070700200528      ** - Fiduciary charge code description                                    CDL006
070800200528                                                                                CDL006
070900200528     C                   Eval      FCGD = IGFCGD                                CDL006
071000200528                                                                                CDL006
071100200528      ** - Fiduciary charge amount                                              CDL006
071200200528                                                                                CDL006
071300200528     C                   Eval      FXGA = IGFXGA                                CDL006
071400200528     C*
071500200528      ** Timestamp                                                              CAP006
071600200528     C                   CALLB     'ZAGENTMSTM'                                 CAP006
071700200528     C                   PARM                    TimeStamp                      CAP006
071800200528                                                                                CAP006
071900200528     C                   EVAL      HNTMST  = TimeStamp                          CAP006
072000200528                                                                                CAP006
072100200528      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
072200200528      ** transaction even if it originated from SIN module.                                   CSC011
072300200528                                                                                              CSC011
072400200528     C                   IF        CSC011 = 'Y'                                               CSC011
072500200528                                                                                              CSC011
072600200528     C                   IF        HNFRNT = *BLANKS                                           CSC011
072700200528     C                   MOVEL     HNVDYY        WYear                                        CSC011
072800200528     C                   MOVEL     HNVDMM        WMonth                                       CSC011
072900200528     C                   MOVEL     HNVDDD        WDay                                         CSC011
073000200528     C                   MOVEL     HNDA38        WDeal                                        CSC011
073100200528     C                   EVAL      HNFRNT = 'MD' + WDeal + WYear +                            CSC011
073200200528     C                                      WMonth + WDay + SequenceNo                        CSC011
073300200528     C                   ENDIF                                                                CSC011
073400200528     C                   ENDIF                                                                CSC011
073500200528     C                                                                                        CSC011
073600200528     C*  WRITE (OR UPDATE IF PRESENT) NEW DEAL AMENDMENT
073700200528      *                                                                                       CDL010
073800200528      ** User Authorisation details when CDL010 is ON                                         CDL010
073900200528     C                   IF        CDL010 = 'Y'                                               CDL010
074000200528     C                   EXSR      USRUPD                                                     CDL010
074100200528     C                   ENDIF                                                                CDL010
074200200528      *                                                                                       CDL010
074300200528     C     *IN99         IFEQ      '0'
074400200528      *                                                                                       CSD015
074500200528      ** Check for compliance if necessary.                                                   CSD015
074600200528      *                                                                                       CSD015
074700200528     C                   IF        CSD015 = 'Y' AND                                           CSD015
074800200528     C                             W1EWLC = 'Y'                                               CSD015
074900200528                                                                                              CSD015
075000200528     C                   IF        CSC011 <> 'Y' OR                                           CSD015
075100200528     C                             (CSC011 = 'Y' AND                                          CSD015
075200200528     C                             S1MAIN = LIBR)                                             CSD015
075300200528     C                   EVAL      WCompMode = OnAmend                                        CSD015
075400200528      *                                                                                       CSD015
075500200528      ** Handles fields checking during insert action                                         CSD015
075600200528      *                                                                                       CSD015
075700200528     C                   EXSR      SRCompChk                                                  CSD015
075800200528     C                   ENDIF                                                                CSD015
075900200528                                                                                              CSD015
076000200528     C                   ENDIF                                                                CSD015
076100200528                                                                                              CSD015
076200200528     C                   UPDATE    MMDEAMP0
076300200528     C                   ELSE
076400200528      *                                                                                       CSD015
076500200528      ** Before writing to file MMDEAMPP, check if Compliance                                 CSD015
076600200528      ** Watch is installed, W1EWLC = 'Y' and any of the                                      CSD015
076700200528      ** watch list fields has been entered                                                   CSD015
076800200528      *                                                                                       CSD015
076900200528     C                   IF        CSD015 = 'Y' AND                                           CSD015
077000200528     C                             W1EWLC = 'Y'                                               CSD015
077100200528                                                                                              CSD015
077200200528     C                   IF        CSC011 <> 'Y' OR                                           CSD015
077300200528     C                             (CSC011 = 'Y' AND                                          CSD015
077400200528     C                             S1MAIN = LIBR)                                             CSD015
077500200528     C                   EVAL      WCompMode = OnInsert                                       CSD015
077600200528      *                                                                                       CSD015
077700200528      ** Handles fields checking during insert action                                         CSD015
077800200528      *                                                                                       CSD015
077900200528     C                   EXSR      SRCompChk                                                  CSD015
078000200528     C                   ENDIF                                                                CSD015
078100200528                                                                                              CSD015
078200200528     C                   ENDIF                                                                CSD015
078300200528                                                                                              CSD015
078400200528     C                   WRITE     MMDEAMP0
078500200528     C                   END
078600200528     C*
078700200528     C**  UPDATE 'AFTER' STATUS
078800200528     C*
078900200528     C                   MOVEL     MMDEAM        Z#ASTS
079000200528      *                                                                                       258907
079100200528     C     IGLACT        IFEQ      'I'                                                        258907
079200200528     C     PSJobName     ANDNE     'QZDASOINIT'                                               259421
079300200528      *                                                                                       258907
079400200528     C                   MOVEL     IGBRCA        DHC_DIBRCA                                   258907
079500200528     C                   Z-ADD     IGDA38        DHC_DIDLNO                                   258907
079600200528     C                   Z-ADD     IGDVSD        DHC_DIVDAT                                   258907
079700200528     C                   Z-ADD     IGDS38        DHC_DIDASN                                   258907
079800200528     C                   MOVEL     IGFRNT        DHC_DIFRID                                   258907
079900200528      *                                                                                       258907
080000200528      * Write to DEAMSIQD                                                                     258907
080100200528     C                   WRITE     DEAMSQD0                             81                    258907
080200200528      *                                                                                       258907
080300200528      * If an error occurs on the file, then end                                              258907
080400200528      *                                                                                       258907
080500200528     C     *IN81         IFEQ      '1'                                                        258907
080600200528     C                   MOVEL     IGDA38        DBKEY                                        258907
080700200528     C                   MOVEL     'DEAMSIQD'    DBFILE                                       258907
080800200528     C                   MOVEL     '007'         DBASE                                        258907
080900200528     C                   EXSR      SRERR                                                      258907
081000200528      *                                                                                       258907
081100200528     C                   END                                                                  258907
081200200528      *                                                                                       258907
081300200528     C                   ENDIF                                                                258907
081400200528     C*
081500200528     C                   ENDSR
081600200528     C*****************************************************************
081700200528      /EJECT
081800200528     C*****************************************************************
081900200528     C*                                                               *
082000200528     C* AMEND - Deal Amendment Amends                                 *
082100200528     C*                                                               *
082200200528     C*****************************************************************
082300200528     C     AMEND         BEGSR
082400200528     C*
082500200528     C** ACCESS RELATED DEAL INFORMATION
082600200528     C*
082700200528     C                   EXSR      ACRDEL
082800200528     C*
082900200528     C**  ACCESS DEAL AMENDMENT
083000200528     C*
083100200528     C     DEAMK         CHAIN     MMDEAMP0                           99
083200200528     C*
083300200528     C**  DATA BASE ERROR
083400200528     C*
083500200528     C     *IN99         IFEQ      '1'
083600200528     C                   MOVEL     IGDA38        DBKEY
083700200528     C                   MOVEL     'MMDEAMP0'    DBFILE                         ************
083800200528     C                   MOVEL     '001'         DBASE                          * DBERR 001*
083900200528     C                   EXSR      SRERR                                        ************
084000200528     C                   END
084100200528     C*
084200200528     C**  UPDATE 'BEFORE' STATUS
084300200528     C*
084400200528     C                   MOVEL     MMDEAM        Z#BSTS
084500200528     C                   MOVEL     MMDEAM        WLFBC                                        CSD015
084600200528     C*
084700200528     C**  SET DEAL FIELDS ON AMEND
084800200528     C*
084900200528     C                   EXSR      SETAMD
085000200528     C*
085100200528      ** Timestamp                                                              CAP006
085200200528     C                   CALLB     'ZAGENTMSTM'                                 CAP006
085300200528     C                   PARM                    TimeStamp                      CAP006
085400200528                                                                                CAP006
085500200528     C                   EVAL      HNTMST  = TimeStamp                          CAP006
085600200528      *                                                                                       CDL010
085700200528      ** User Authorisation details when CDL010 is ON                                         CDL010
085800200528     C                   IF        CDL010 = 'Y'                                               CDL010
085900200528     C                   EXSR      USRUPD                                                     CDL010
086000200528     C                   ENDIF                                                                CDL010
086100200528      *                                                                                       CDL010
086200200528      *                                                                                       CSD015
086300200528      ** Check for compliance if necessary.                                                   CSD015
086400200528      *                                                                                       CSD015
086500200528     C                   IF        CSD015 = 'Y' AND                                           CSD015
086600200528     C                             W1EWLC = 'Y'                                               CSD015
086700200528                                                                                              CSD015
086800200528     C                   IF        CSC011 <> 'Y' OR                                           CSD015
086900200528     C                             (CSC011 = 'Y' AND                                          CSD015
087000200528     C                             S1MAIN = LIBR)                                             CSD015
087100200528     C                   EVAL      WCompMode = OnAmend                                        CSD015
087200200528      *                                                                                       CSD015
087300200528      ** Handles fields checking during amend action                                          CSD015
087400200528      *                                                                                       CSD015
087500200528     C                   EXSR      SRCompChk                                                  CSD015
087600200528     C                   ENDIF                                                                CSD015
087700200528                                                                                              CSD015
087800200528     C                   ENDIF                                                                CSD015
087900200528                                                                                              CSD015
088000200528     C**  UPDATE DEAL AMENDMENT
088100200528     C*
088200200528     C                   UPDATE    MMDEAMP0
088300200528     C*
088400200528     C**  UPDATE VALID DEAL
088500200528     C*
088600200528     C                   MOVEL     MMDEAM        MMVDEM
088700200528     C*
088800200528     C**  UPDATE 'AFTER' STATUS
088900200528     C*
089000200528     C                   MOVEL     MMDEAM        Z#ASTS
089100200528     C*
089200200528     C                   ENDSR
089300200528     C*****************************************************************
089400200528      /EJECT
089500200528     C*****************************************************************
089600200528     C*                                                               *
089700200528     C* AUTHOR - Deal Amendment Authorize                             *
089800200528     C*                                                               *
089900200528     C*****************************************************************
090000200528     C     AUTHOR        BEGSR
090100200528     C*
090200200528     C** ACCESS RELATED DEAL INFORMATION
090300200528     C*
090400200528     C                   EXSR      ACRDEL
090500200528     C*
090600200528     C**  ACCESS DEAL AMENDMENT
090700200528     C*
090800200528     C     DEAMK         CHAIN     MMDEAMP0                           99
090900200528     C*
091000200528     C**  DATA BASE ERROR
091100200528     C*
091200200528     C     *IN99         IFEQ      '1'
091300200528     C                   MOVEL     IGDA38        DBKEY
091400200528     C                   MOVEL     'MMDEAMP0'    DBFILE                         ************
091500200528     C                   MOVEL     '002'         DBASE                          * DBERR 002*
091600200528     C                   EXSR      SRERR                                        ************
091700200528     C                   END
091800200528     C*
091900200528     C**  UPDATE 'BEFORE' STATUS
092000200528     C*
092100200528     C                   MOVEL     MMDEAM        Z#BSTS
092200200528     C*
092300200528     C**  SET DEAL FIELDS ON AUTHORIZE
092400200528     C*
092500200528     C                   EXSR      SETAUT
092600200528     C*
092700200528     C/COPY WNCPYSRC,MMH00137
092800200528      ** Timestamp                                                              CAP006
092900200528     C                   CALLB     'ZAGENTMSTM'                                 CAP006
093000200528     C                   PARM                    TimeStamp                      CAP006
093100200528                                                                                CAP006
093200200528     C                   EVAL      HNTMST  = TimeStamp                          CAP006
093300200528     C/COPY WNCPYSRC,MMDEAMMC01
093400200528      *                                                                                       CDL010
093500200528      ** User Authorisation details when CDL010 is ON                                         CDL010
093600200528     C                   IF        CDL010 = 'Y'                                               CDL010
093700200528     C                   EVAL      IGUSER = USRID                                            BUG7461
093800200528     C                   EXSR      USRUPD                                                     CDL010
093900200528     C                   ENDIF                                                                CDL010
094000200528      *                                                                                       CDL010
094100200528     C**  UPDATE DEAL AMENDMENT
094200200528     C*
094300200528     C                   UPDATE    MMDEAMP0
094400200528     C/COPY WNCPYSRC,MMH00172
094500200528     C*
094600200528     C**  UPDATE VALID DEAL
094700200528     C*
094800200528     C                   MOVEL     MMDEAM        MMVDEM
094900200528     C*
095000200528     C**  UPDATE 'AFTER' STATUS
095100200528     C*
095200200528     C                   MOVEL     MMDEAM        Z#ASTS
095300200528     C*
095400200528     C                   ENDSR
095500200528     C*****************************************************************
095600200528      /EJECT
095700200528     C*****************************************************************
095800200528     C*                                                               *
095900200528     C* DELETE - Deal Amendment Deletes                               *
096000200528     C*                                                               *
096100200528     C*****************************************************************
096200200528     C     DELETE        BEGSR
096300200528     C*
096400200528     C** ACCESS RELATED DEAL INFORMATION
096500200528     C*
096600200528     C                   EXSR      ACRDEL
096700200528     C*
096800200528     C**  ACCESS DEAL AMENDMENT
096900200528     C*
097000200528     C     DEAMK         CHAIN     MMDEAMP0                           99
097100200528     C*
097200200528     C**  DATA BASE ERROR
097300200528     C*
097400200528     C     *IN99         IFEQ      '1'
097500200528     C                   MOVEL     IGDA38        DBKEY
097600200528     C                   MOVEL     'MMDEAMP0'    DBFILE                         ************
097700200528     C                   MOVEL     '003'         DBASE                          * DBERR 003*
097800200528     C                   EXSR      SRERR                                        ************
097900200528     C                   END
098000200528     C*
098100200528     C**  UPDATE 'BEFORE' STATUS
098200200528     C*
098300200528     C                   MOVEL     MMDEAM        Z#BSTS
098400200528     C*
098500200528     C**  SET DEAL FIELDS ON DELETE
098600200528     C*
098700200528     C                   EXSR      SETDEL
098800200528     C*
098900200528      ** Timestamp                                                              CAP006
099000200528     C                   CALLB     'ZAGENTMSTM'                                 CAP006
099100200528     C                   PARM                    TimeStamp                      CAP006
099200200528                                                                                CAP006
099300200528     C                   EVAL      HNTMST  = TimeStamp                          CAP006
099400200528                                                                                CAP006
099500200528      ** Send a User Defined Journal Entry to simulate a delete from repair                   208884
099600200528     C     HNDSTS        IFNE      'A'                                                        208884
099700200528     C     HNDSTS        ANDNE     'R'                                                        208884
099800200528     C     HNFRNT        ANDNE     *BLANKS                                                    208884
099900200528     C                   MOVE      'D'           RACTN                                        208884
100000200528     C                   MOVE      HNFRNT        RFOTRANID                                    208884
100100200528     C                   MOVE      HNDA38        RDLNO                                        208884
100200200528     C                   MOVEL     *BLANKS       EntryData                                    208884
100300200528     C                   MOVEL     *BLANKS       FileName                                     208884
100400200528     C                   CALL      'RPC1600'                                                  208884
100500200528     C                   PARM      InvRp         EntryData      3000                          208884
100600200528     C                   PARM      'MMIDEAMPD'   FileName         10                          208884
100700200528     C                   ENDIF                                                                208884
100800200528     C*                                                                                       208884
100900200528     C**  UPDATE DEAL AMENDMENT
101000200528     C*
101100200528     C                   UPDATE    MMDEAMP0
101200200528     C*
101300200528     C**  UPDATE VALID DEAL
101400200528     C*
101500200528     C                   MOVEL     MMDEAM        MMVDEM
101600200528     C*
101700200528     C**  UPDATE 'AFTER' STATUS
101800200528     C*
101900200528     C                   MOVEL     MMDEAM        Z#ASTS
102000200528      *
102100200528     C                   ENDSR
102200200528     C****************************************************************                        CDL010
102300200528      /EJECT                                                                                  CDL010
102400200528     C****************************************************************                        CDL010
102500200528     C*                                                              *                        CDL010
102600200528     C* USRUPD    - Update the Last Amend/Insert User field .        *                        CDL010
102700200528     C*                                                              *                        CDL010
102800200528     C****************************************************************                        CDL010
102900200528     C     USRUPD        BEGSR                                                                CDL010
103000200528      *                                                                                       CDL010
103100200528      **  Update User Details                                                                 CDL010
103200200528      *                                                                                       CDL010
103300200528     C     IGUSER        IFEQ      *BLANKS                                                    CDL010
103400200528     C                   EVAL      HNUSER = PSuser                                            CDL010
103500200528     C                   ELSE                                                                 CDL010
103600200528     C                   EVAL      HNUSER = IGUSER                                            CDL010
103700200528     C                   ENDIF                                                                CDL010
103800200528      *                                                                                       CDL010
103900200528     C                   ENDSR                                                                CDL010
104000200528     C*****************************************************************
104100200528      /EJECT
104200200528     C*****************************************************************
104300200528     C*                                                               *
104400200528     C* SETINS - SET DEAL FIELDS ON INSERT                            *
104500200528     C*                                                               *
104600200528     C*****************************************************************
104700200528     C     SETINS        BEGSR
104800200528      **
104900200528      ** Deal value date - yyyy/mm/dd determined in CVTVDT
105000200528      **
105100200528      ** Deal transaction date - yyyy IGDTYY
105200200528      ** Deal transaction date - mm   IGDTMM
105300200528      ** Deal transaction date - dd   IGDTDD
105400200528      **  CONVERT RUN DATE FROM DAY NUMBER TO YMD
105500200528      **
105600200528     C                   Z-ADD     BJRDNB        @DAYN
105700200528     C                   CALLB     'ZDATE9'
105800200528     C                   PARM                    @DAYN
105900200528     C                   PARM                    @YMD
106000200528     C                   PARM                    @RETN
106100200528     C                   Z-ADD     @YMD          @IGTDY
106200200528      **
106300200528      ** Deal Status and Change Type
106400200528      **
106500200528     C                   CALLB     'ZAFUTSTATP'
106600200528     C                   PARM      'I'           @@ACTN            1
106700200528     C                   PARM      *BLANK        @@CSTS            1
106800200528     C                   PARM                    BNMMAU
106900200528     C                   PARM                    BNMMRA
107000200528     C                   PARM      *BLANK        @@FSTS            1
107100200528     C                   PARM      *BLANK        @@CHTP            1
107200200528     C                   MOVEL     @@FSTS        IGDSTS
107300200528     C                   MOVEL     @@CHTP        IGCHTP
107400200528      **
107500200528      ** Deal type
107600200528      **
107700200528     C                   MOVEL     IGMTYP        IGTYPE
107800200528     C     IGTYPE        IFEQ      'SC'
107900200528     C                   MOVEL     'RC'          IGTYPE
108000200528     C                   END
108100200528      **
108200200528      ** Deam deal date - yyyy        IGDDYY
108300200528      ** Deam deal date - mm          IGDDMM
108400200528      ** Deam deal date - dd          IGDDDD
108500200528      **
108600200528     C                   Z-ADD     BJRDNB        @DAYN
108700200528     C                   CALLB     'ZDATE9'
108800200528     C                   PARM                    @DAYN
108900200528     C                   PARM                    @YMD
109000200528     C                   PARM                    @RETN
109100200528     C                   Z-ADD     @YMD          @IGDDY
109200200528      **
109300200528      ** CALCULATE SETTLE INTEREST
109400200528      **
109500200528     C     IGMTYP        IFEQ      'SI'
109600200528     C                   EXSR      CLSINT
109700200528     C                   Z-ADD     ##SINT        IGAMNP
109800200528     C                   END
109900200528      **
110000200528      ** IF PRINCIPAL DECREASE OF DEPOSIT TAKEN
110100200528      ** OR PRINCIPAL INCREASE OF DEPOSIT PLACED
110200200528      ** OR SETTLE INTEREST OF DEPOSIT TAKEN
110300200528      **
110400200528     C     IGTYPE        IFEQ      'PD'
110500200528     C     W#LOD         ANDEQ     'D'
110600200528     C     IGTYPE        OREQ      'PI'
110700200528     C     W#LOD         ANDEQ     'L'
110800200528     C     IGTYPE        OREQ      'SI'
110900200528     C     W#LOD         ANDEQ     'D'
111000200528     C     IGTYPE        OREQ      'EM'                                                      BUG3045
111100200528     C     IGPENP        ANDEQ     'P'                                                       BUG3045
111200200528      *
111300200528      * DETERMINE ALTERNATIVE PAY INSTRUCTIONS
111400200528      *
111500200528     C                   EXSR      ALPAYI
111600200528      **
111700200528      ** IF PRINCIPAL DECREASE OF DEPOSIT PLACED
111800200528      ** OR PRINCIPAL INCREASE OF DEPOSIT TAKEN
111900200528      ** OR SETTLE INTEREST OF DEPOSIT PLACED
112000200528      **
112100200528     C                   ELSE
112200200528     C     IGTYPE        IFEQ      'PD'
112300200528     C     W#LOD         ANDEQ     'L'
112400200528     C     IGTYPE        OREQ      'PI'
112500200528     C     W#LOD         ANDEQ     'D'
112600200528     C     IGTYPE        OREQ      'SI'
112700200528     C     W#LOD         ANDEQ     'L'
112800200528     C     IGTYPE        OREQ      'EM'                                                      BUG3045
112900200528     C     IGPENP        ANDEQ     'R'                                                       BUG3045
113000200528      *
113100200528      * DETERMINE ALTERNATIVE REC INSTRUCTIONS
113200200528      *
113300200528     C                   EXSR      ALRECI
113400200528     C                   END
113500200528     C                   END
113600200528      **
113700200528      ** Deam original deal type
113800200528      **
113900200528     C                   MOVE      W#TYPE        IGOGDT
114000200528      **
114100200528      ** Original deal sub type
114200200528      **
114300200528     C                   MOVE      W#STYP        IGOSTP
114400200528      **                                                                                      CDL038
114500200528      ** Original deal class                                                                  CDL038
114600200528      **                                                                                      CDL038
114700200528     C                   MOVE      W#CLAS        IGCLAS                                       CDL038
114800200528      **
114900200528      ** Dm midas original deal type
115000200528      **
115100200528     C                   MOVE      W#MTYP        IGOMDT
115200200528      **
115300200528      ** Time of input
115400200528      **
115500200528     C                   TIME                    IGTIME
115600200528      **
115700200528      ** Deal user code
115800200528      **
115900200528     C                   MOVEL     PSUser        IGDUSC
116000200528      **
116100200528      ** Deal authorisation officer
116200200528      **
116300200528     C     @@FSTS        IFEQ      'A'
116400200528     C                   MOVEL     PSUser        IGAOFR
116500200528     C                   END
116600200528      **
116700200528      ** Deal action date
116800200528      **
116900200528     C                   Z-ADD     BJRDNB        @DAYN
117000200528     C                   CALLB     'ZDATE9'
117100200528     C                   PARM                    @DAYN
117200200528     C                   PARM                    @YMD
117300200528     C                   PARM                    @RETN
117400200528     C                   Z-ADD     @YMD          IGLDAT
117500200528      *
117600200528      ** Branch Code - Alpha
117700200528      *
117800200528     C                   MOVE      W#BRCA        IGBRCA
117900200528      *
118000200528     C                   ENDSR
118100200528     C*****************************************************************
118200200528      /EJECT
118300200528     C*****************************************************************
118400200528     C*                                                               *
118500200528     C* SETAMD - SET DEAL FIELDS ON AMEND                             *
118600200528     C*                                                               *
118700200528     C*****************************************************************
118800200528     C     SETAMD        BEGSR
118900200528      *
119000200528      ** UPDATE CONTROL FIELDS
119100200528      *
119200200528     C                   MOVEL     @IGCTL        @HNCTL
119300200528      **
119400200528      ** Deal Status and Change Type
119500200528      **
119600200528     C                   CALLB     'ZAFUTSTATP'
119700200528     C                   PARM      'A'           @@ACTN
119800200528     C                   PARM      HNDSTS        @@CSTS
119900200528     C                   PARM                    BNMMAU
120000200528     C                   PARM                    BNMMRA
120100200528     C                   PARM      *BLANK        @@FSTS
120200200528     C                   PARM      *BLANK        @@CHTP
120300200528     C                   MOVEL     @@FSTS        HNDSTS
120400200528     C                   MOVEL     @@CHTP        HNCHTP
120500200528      **
120600200528      ** IF PRINCIPAL DECREASE OF DEPOSIT TAKEN
120700200528      ** OR PRINCIPAL INCREASE OF DEPOSIT PLACED
120800200528      ** OR SETTLE INTEREST OF DEPOSIT TAKEN
120900200528      **
121000200528     C     IGTYPE        IFEQ      'PD'
121100200528     C     W#LOD         ANDEQ     'D'
121200200528     C     IGTYPE        OREQ      'PI'
121300200528     C     W#LOD         ANDEQ     'L'
121400200528     C     IGTYPE        OREQ      'SI'
121500200528     C     W#LOD         ANDEQ     'D'
121600200528     C     IGTYPE        OREQ      'EM'                                                      BUG3045
121700200528     C     IGPENP        ANDEQ     'P'                                                       BUG3045
121800200528      *
121900200528      * DETERMINE ALTERNATIVE PAY INSTRUCTIONS
122000200528      *
122100200528     C                   EXSR      ALPAYI
122200200528     C                   MOVEL     @IGALP        @HNALP
122300200528     C*******************MOVEL     IGDOPI        HNDORI                                CGL029 NAD002
122400200528     C*******************MOVEL     IGMOPI        HNMORI                                CGL029 NAD002
122500200528     C                   MOVEL     IGDOPI        HNDOPI                                       NAD002
122600200528     C                   MOVEL     IGMOPI        HNMOPI                                       NAD002
122700200528      **
122800200528      ** IF PRINCIPAL DECREASE OF DEPOSIT PLACED
122900200528      ** OR PRINCIPAL INCREASE OF DEPOSIT TAKEN
123000200528      ** OR SETTLE INTEREST OF DEPOSIT PLACED
123100200528      **
123200200528     C                   ELSE
123300200528     C     IGTYPE        IFEQ      'PD'
123400200528     C     W#LOD         ANDEQ     'L'
123500200528     C     IGTYPE        OREQ      'PI'
123600200528     C     W#LOD         ANDEQ     'D'
123700200528     C     IGTYPE        OREQ      'SI'
123800200528     C     W#LOD         ANDEQ     'L'
123900200528     C     IGTYPE        OREQ      'EM'                                                      BUG3045
124000200528     C     IGPENP        ANDEQ     'R'                                                       BUG3045
124100200528      *
124200200528      * DETERMINE ALTERNATIVE REC INSTRUCTIONS
124300200528      *
124400200528     C                   EXSR      ALRECI
124500200528     C                   MOVEL     @IGALR        @HNALR
124600200528     C                   MOVEL     IGDORI        HNDORI                                       CGL029
124700200528     C                   MOVEL     IGMORI        HNMORI                                       CGL029
124800200528     C                   END
124900200528     C                   END
125000200528      **
125100200528      ** Deal last action
125200200528      **
125300200528     C                   MOVEL     'A'           HNLACT
125400200528      **
125500200528      ** Deal user code
125600200528      **
125700200528     C                   MOVEL     PSUser        HNDUSC
125800200528      **
125900200528      ** Deal action date
126000200528      **
126100200528     C                   Z-ADD     BJRDNB        @DAYN
126200200528     C                   CALLB     'ZDATE9'
126300200528     C                   PARM                    @DAYN
126400200528     C                   PARM                    @YMD
126500200528     C                   PARM                    @RETN
126600200528     C                   Z-ADD     @YMD          HNLDAT
126700200528      **
126800200528      ** Extended Receipt Instructions
126900200528      **
127000200528     C                   MOVEL     @IGREC        @HNREC
127100200528     C                   MOVEL     IGRONS        HNRONS                                       CGL029
127200200528      **
127300200528      * Enhanced Receive Settlement Instructions                                              CDL094
127400200528     C                   MOVEL     IGRBB1        HNRBB1                                       CDL094
127500200528     C                   MOVEL     IGRBB2        HNRBB2                                       CDL094
127600200528     C                   MOVEL     IGRBB3        HNRBB3                                       CDL094
127700200528     C                   MOVEL     IGRBB4        HNRBB4                                       CDL094
127800200528     C                   MOVEL     IGRBB5        HNRBB5                                       CDL094
127900200528     C                   MOVEL     IGRBB6        HNRBB6                                       CDL094
128000200528      *                                                                                       CDL094
128100200528      ** Extended Payment Instructions
128200200528      **
128300200528     C                   MOVEL     @IGPY1        @HNPY1
128400200528     C*******************MOVEL     IGRONS        HNRONS                                CGL029 NAD002
128500200528     C                   MOVEL     IGPONS        HNPONS                                       NAD002
128600200528     C                   MOVEL     @IGPY2        @HNPY2
128700200528     C                   MOVEL     @IGPY3        @HNPY3
128800200528      **
128900200528      ** Our Settlement Branch
129000200528      **
129100200528     C                   MOVEL     IGOSBR        HNOSBR
129200200528      **
129300200528      ** COVER MESSAGE REQUIRED
129400200528      **
129500200528     C                   MOVEL     IGCVMR        HNCVMR
129600200528      **
129700200528      ** EMU Settlement fields
129800200528      **
129900200528     C                   MOVEL     IGSTCY        HNSTCY
130000200528     C                   MOVEL     IGIC72        HNIC72
130100200528      *                                                                         CAP013
130200200528      ** Front office transaction ID                                            CAP013
130300200528      *                                                                         CAP013
130400200528     C     IGFRNT        IFNE      *BLANK                                       242552
130500200528     C                   MOVEL     IGFRNT        HNFRNT                         CAP013
130600200528     C                   ENDIF                                                  242552
130700200528      *                                                                         CAP013
130800200528      ** Associated front office transaction ID                                 CAP013
130900200528      *                                                                         CAP013
131000200528     C     IGAFRT        IFNE      *BLANK                                       242552
131100200528     C                   MOVEL     IGAFRT        HNAFRT                         CAP013
131200200528     C                   ENDIF                                                  242552
131300200528      **                                                                        CAP051
131400200528      ** Automatic Authorisation flag                                           CAP051
131500200528      **                                                                        CAP051
131600200528     C     CAP051        IFEQ      'Y'                                          CAP051
131700200528     C                   MOVEL     IGAUTH        HNAUTH                         CAP051
131800200528     C                   ELSE                                                   CAP051
131900200528     C                   MOVE      *BLANKS       HNAUTH                         CAP051
132000200528     C                   ENDIF                                                  CAP051
132100200528      **                                                                                      CDL017
132200200528      ** Early Maturity Fields                                                                CDL017
132300200528      **                                                                                      CDL017
132400200528     C     IGMTYP        IFEQ      'EM'                                                       CDL017
132500200528     C                   MOVE      PSuser        HNUSER                                       CDL017
132600200528     C                   Z-ADD     IGAMNP        HNAMNP                                       CDL017
132700200528     C                   Z-ADD     IGINTR        HNINTR                                       CDL017
132800200528     C                   MOVE      IGPENP        HNPENP                                       CDL017
132900200528     C                   Z-ADD     IGEMDT        HNEMDT                                       CDL017
133000200528     C                   MOVE      IGBSRT        HNBSRT                                       CDL017
133100200528     C                   Z-ADD     IGBRTE        HNBRTE                                       CDL017
133200200528     C                   ENDIF                                                                CDL017
133300200528      **                                                                                     BUG6156
133400200528      ** Base Rate fields                                                                    BUG6156
133500200528      **                                                                                     BUG6156
133600200528     C     IGMTYP        IFEQ      'BC'                                                      BUG6156
133700200528     C                   MOVE      PSuser        HNUSER                                      BUG6156
133800200528     C                   MOVE      IGBSRT        HNBSRT                                      BUG6156
133900200528     C                   Z-ADD     IGBRTE        HNBRTE                                      BUG6156
134000200528     C                   ENDIF                                                               BUG6156
134100200528      *
134200200528     C                   ENDSR
134300200528     C*****************************************************************
134400200528      /EJECT
134500200528     C*****************************************************************
134600200528     C*                                                               *
134700200528     C* SETAUT - SET DEAL FIELDS ON AUTHORIZE                         *
134800200528     C*                                                               *
134900200528     C*****************************************************************
135000200528     C     SETAUT        BEGSR
135100200528      *
135200200528      ** UPDATE CONTROL FIELDS
135300200528      *
135400200528     C                   MOVEL     @IGCTL        @HNCTL
135500200528      **
135600200528      ** Deal Status and Change Type
135700200528      **
135800200528     C                   CALLB     'ZAFUTSTATP'
135900200528     C                   PARM      'X'           @@ACTN
136000200528     C                   PARM      HNDSTS        @@CSTS
136100200528     C                   PARM                    BNMMAU
136200200528     C                   PARM                    BNMMRA
136300200528     C                   PARM      *BLANK        @@FSTS
136400200528     C                   PARM      *BLANK        @@CHTP
136500200528     C                   MOVEL     @@FSTS        HNDSTS
136600200528     C                   MOVEL     @@CHTP        HNCHTP
136700200528      **
136800200528      ** Deal last action
136900200528      **
137000200528     C                   MOVEL     'X'           HNLACT
137100200528      **
137200200528      ** Deal authorisation officer
137300200528      **
137400200528     C                   MOVEL     PSUser        HNAOFR
137500200528      **
137600200528      ** Deal action date
137700200528      **
137800200528     C                   Z-ADD     BJRDNB        @DAYN
137900200528     C                   CALLB     'ZDATE9'
138000200528     C                   PARM                    @DAYN
138100200528     C                   PARM                    @YMD
138200200528     C                   PARM                    @RETN
138300200528     C                   Z-ADD     @YMD          HNLDAT
138400200528      *                                                                         CAP013
138500200528      ** Front office transaction ID                                            CAP013
138600200528      *                                                                         CAP013
138700200528     C     IGFRNT        IFNE      *BLANK                                       242552
138800200528     C                   MOVEL     IGFRNT        HNFRNT                         CAP013
138900200528     C                   ENDIF                                                  242552
139000200528      *                                                                         CAP013
139100200528      ** Associated front office transaction ID                                 CAP013
139200200528      *                                                                         CAP013
139300200528     C     IGAFRT        IFNE      *BLANK                                       242552
139400200528     C                   MOVEL     IGAFRT        HNAFRT                         CAP013
139500200528     C                   ENDIF                                                  242552
139600200528      *
139700200528     C                   ENDSR
139800200528     C*****************************************************************
139900200528      /EJECT
140000200528     C*****************************************************************
140100200528     C*                                                               *
140200200528     C* SETDEL - SET DEAL FIELDS ON DELETE                            *
140300200528     C*                                                               *
140400200528     C*****************************************************************
140500200528     C     SETDEL        BEGSR
140600200528      *
140700200528      ** UPDATE CONTROL FIELDS
140800200528      *
140900200528     C                   MOVEL     @IGCTL        @HNCTL
141000200528      *
141100200528      ** FLAG AS 'DELETED'
141200200528      *
141300200528     C                   MOVEL     'D'           HNDDLT
141400200528      **
141500200528      ** Deal Status and Change Type
141600200528      **
141700200528     C                   CALLB     'ZAFUTSTATP'
141800200528     C                   PARM      'D'           @@ACTN
141900200528     C                   PARM      HNDSTS        @@CSTS
142000200528     C                   PARM                    BNMMAU
142100200528     C                   PARM                    BNMMRA
142200200528     C                   PARM      *BLANK        @@FSTS
142300200528     C                   PARM      *BLANK        @@CHTP
142400200528     C                   MOVEL     @@FSTS        HNDSTS
142500200528     C                   MOVEL     @@CHTP        HNCHTP
142600200528      **
142700200528      ** Deal last action
142800200528      **
142900200528     C                   MOVEL     'D'           HNLACT
143000200528      *                                                                         CAP013
143100200528      ** Front office transaction ID                                            CAP013
143200200528      *                                                                         CAP013
143300200528     C     IGFRNT        IFNE      *BLANK                                       242552
143400200528     C                   MOVEL     IGFRNT        HNFRNT                         CAP013
143500200528     C                   ENDIF                                                  242552
143600200528      *                                                                         CAP013
143700200528      ** Associated front office transaction ID                                 CAP013
143800200528      *                                                                         CAP013
143900200528     C     IGAFRT        IFNE      *BLANK                                       242552
144000200528     C                   MOVEL     IGAFRT        HNAFRT                         CAP013
144100200528     C                   ENDIF                                                  242552
144200200528      **                                                                        CAP051
144300200528      ** Automatic Authorisation flag                                           CAP051
144400200528      **                                                                        CAP051
144500200528     C     CAP051        IFEQ      'Y'                                          CAP051
144600200528     C                   MOVEL     IGAUTH        HNAUTH                         CAP051
144700200528     C                   ELSE                                                   CAP051
144800200528     C                   MOVE      *BLANKS       HNAUTH                         CAP051
144900200528     C                   ENDIF                                                  CAP051
145000200528      *
145100200528     C                   ENDSR
145200200528     C*****************************************************************
145300200528      /EJECT
145400200528     C*****************************************************************
145500200528     C*                                                               *
145600200528     C* ALRECI - ALTERNATIVE RECEIVE INSTRUCTIONS                     *
145700200528     C*                                                               *
145800200528     C*****************************************************************
145900200528     C     ALRECI        BEGSR
146000200528      *
146100200528      * EFFECTIVE SETTLEMENT CURRENCY
146200200528      *
146300200528     C     IGSTCY        IFNE      *BLANKS
146400200528     C                   MOVEL     IGSTCY        EffSetCcy
146500200528     C                   ELSE
146600200528     C                   MOVEL     IGCCY         EffSetCcy         3
146700200528     C                   ENDIF
146800200528      *
146900200528      * DETERMINE ALTERNATIVE RECEIVE INSTRUCTIONS
147000200528      *
147100200528     C                   CALLB     'ZAALTRECIN'
147200200528      ** Customer number                                                                      200400
147300200528     C**********         PARM      IGCNUM        ##CNUM            6 0                 200400 CSD027
147400200528     C                   PARM      IGCNUM        ##CNUM            6                          CSD027
147500200528      ** Rec currency
147600200528     C                   PARM      EffSetCcy     ##RCCY            3
147700200528      ** Rec - settlement method
147800200528     C                   PARM      IGRSTM        ##RSTM            2 0
147900200528      ** Rec - our nostro
148000200528     C**********         PARM      IGRONS        ##RONS           12                          CGL029
148100200528     C                   PARM      IGRONS        ##RONS           18                          CGL029
148200200528      ** rec - intermediary bank
148300200528     C                   PARM      IGRIBN        ##RIBN            8
148400200528      ***MIDAS*Our*Receive*Instructions*(*for*Settlm*Meth*'04'*)*********              179510 200400
148500200528     C************       PARM                    IGMORI                                179510 200400
148600200528      ** midas our receive method
148700200528     C                   PARM                    ##ORCM            2 0
148800200528      ** our receive method
148900200528     C                   PARM                    ##DORM            5
149000200528      ** midas our receive instructions
149100200528     C**********         PARM                    ##MORI           12                          CGL029
149200200528     C                   PARM                    ##MORI           18                          CGL029
149300200528      ** our receive instructions
149400200528     C**********         PARM                    ##DORI           12                          CGL029
149500200528     C                   PARM                    ##DORI           18                          CGL029
149600200528      ** midas customer payment instructions
149700200528     C                   PARM                    ##MCPI           10
149800200528      ** customer payment instructions
149900200528     C                   PARM                    ##DCPI           10
150000200528      *
150100200528     C*
150200200528     C** SETTLEMENT TYPE - MIDAS
150300200528     C*
150400200528     C                   Z-ADD     ##ORCM        IGORCM
150500200528     C*
150600200528     C** SETTLEMENT TYPE - FRONT OFFICE
150700200528     C*
150800200528     C                   MOVEL     ##DORM        IGDORM
150900200528     C*
151000200528     C** OUR SETTLEMENT ACCOUNT - MIDAS
151100200528     C*
151200200528     C                   MOVEL     ##MORI        IGMORI
151300200528     C*
151400200528     C** OUR SETTLEMENT ACCOUNT - FRONT OFFICE
151500200528     C*
151600200528     C                   MOVEL     ##DORI        IGDORI
151700200528     C*
151800200528     C** CUSTOMER'S COUNTERPARTY NOSTRO - MIDAS
151900200528     C*
152000200528     C                   MOVEL     ##MCPI        IGMCPI
152100200528     C*
152200200528     C** CUSTOMER'S COUNTERPARTY NOSTRO - FRONT OFFICE
152300200528     C*
152400200528     C                   MOVEL     ##DCPI        IGDCPI
152500200528     C*
152600200528     C                   ENDSR
152700200528     C*****************************************************************
152800200528      /EJECT
152900200528     C*****************************************************************
153000200528     C*                                                               *
153100200528     C* ALPAYI - ALTERNATIVE PAYMENT INSTRUCTIONS                     *
153200200528     C*                                                               *
153300200528     C*****************************************************************
153400200528     C     ALPAYI        BEGSR
153500200528      *
153600200528      * EFFECTIVE SETTLEMENT CURRENCY
153700200528      *
153800200528     C     IGSTCY        IFNE      *BLANKS
153900200528     C                   MOVEL     IGSTCY        EffSetCcy
154000200528     C                   ELSE
154100200528     C                   MOVEL     IGCCY         EffSetCcy         3
154200200528     C                   ENDIF
154300200528      *
154400200528      * DETERMINE ALTERNATIVE PAYMENT INSTRUCTIONS
154500200528      *
154600200528     C                   CALLB     'ZAALTPAYIN'
154700200528      ** Customer number                                                                      200400
154800200528     C**********         PARM      IGCNUM        ##CNUM            6 0                200400 CSD027A
154900200528     C                   PARM      IGCNUM        ##CNUM            6                         CSD027A
155000200528      ** Pay currency
155100200528     C                   PARM      EffSetCcy     ##PCCY            3
155200200528      ** Pay - settlement method
155300200528     C                   PARM      IGPSTM        ##PSTM            2 0
155400200528      ** Pay - our nostro
155500200528     C**********         PARM      IGPONS        ##PONS           12                          CGL029
155600200528     C                   PARM      IGPONS        ##PONS           18                          CGL029
155700200528      ** account with bank
155800200528     C                   PARM      IGAWBN        ##AWBN            8
155900200528      ** beneficiary
156000200528     C                   PARM      IGBENN        ##BENN            8
156100200528      ** bank to bank info 1
156200200528     C                   PARM      IGBTB1        ##BTB1           35
156300200528      ***MIDAS*Our Pay  Instructions ( for Settlm Meth '04' )                          179510 200400
156400200528     C************       PARM                    IGMOPI                                179510 200400
156500200528      ** midas our payment method
156600200528     C                   PARM                    ##MOPM            2 0
156700200528      ** our payment method
156800200528     C                   PARM                    ##DOPM            5
156900200528      ** midas our payment instructions
157000200528     C**********         PARM                    ##MOPI           12                          CGL029
157100200528     C                   PARM                    ##MOPI           18                          CGL029
157200200528      ** our payment instructions
157300200528     C**********         PARM                    ##DOPI           12                          CGL029
157400200528     C                   PARM                    ##DOPI           18                          CGL029
157500200528      ** midas customer receive instructions
157600200528     C                   PARM                    ##MCRI           10
157700200528      ** customer receive instructions
157800200528     C                   PARM                    ##DCRI           10
157900200528      ** midas for account of
158000200528     C                   PARM                    ##MFAO           10
158100200528      ** for account of
158200200528     C                   PARM                    ##DFAC           10
158300200528      ** special instructions
158400200528     C                   PARM                    ##SPEC           35
158500200528     C*
158600200528     C** SETTLEMENT TYPE - MIDAS
158700200528     C*
158800200528     C                   MOVEL     ##MOPM        IGMOPM
158900200528     C*
159000200528     C** SETTLEMENT TYPE - FRONT OFFICE
159100200528     C*
159200200528     C                   MOVEL     ##DOPM        IGDOPM
159300200528     C*
159400200528     C** OUR SETTLEMENT ACCOUNT - MIDAS
159500200528     C*
159600200528     C                   MOVEL     ##MOPI        IGMOPI
159700200528     C*
159800200528     C** OUR SETTLEMENT ACCOUNT - FRONT OFFICE
159900200528     C*
160000200528     C                   MOVEL     ##DOPI        IGDOPI
160100200528     C*
160200200528     C** CUSTOMER'S COUNTERPARTY NOSTRO - MIDAS
160300200528     C*
160400200528     C                   MOVEL     ##MCRI        IGMCRI
160500200528     C*
160600200528     C** CUSTOMER'S COUNTERPARTY NOSTRO - FRONT OFFICE
160700200528     C*
160800200528     C                   MOVEL     ##DCRI        IGDCRI
160900200528     C*
161000200528     C** FOR ACCOUNT OF - MIDAS
161100200528     C*
161200200528     C                   MOVEL     ##MFAO        IGMFAO
161300200528     C*
161400200528     C** FOR ACCOUNT OF - FRONT OFFICE
161500200528     C*
161600200528     C                   MOVEL     ##DFAC        IGDFAC
161700200528     C*
161800200528     C**  Special instructions.
161900200528     C*
162000200528     C                   MOVEL     ##SPEC        IGSPEC
162100200528     C*
162200200528     C                   ENDSR
162300200528     C*****************************************************************
162400200528      /EJECT
162500200528     C*****************************************************************
162600200528     C*                                                               *
162700200528     C* SETCTL - SET CONTROL FIELDS                                   *
162800200528     C*                                                               *
162900200528     C*****************************************************************
163000200528     C     SETCTL        BEGSR
163100200528      **
163200200528      ** Record identifier
163300200528      **
163400200528     C                   MOVEL     'HN'          IGRCID
163500200528      **
163600200528      ** Logical delete flag
163700200528      **
163800200528     C                   MOVEL     *BLANK        IGDLTF
163900200528      **
164000200528      ** Day of last update
164100200528      **
164200200528     C                   Z-ADD     @DLUP         IGDLUP
164300200528      **
164400200528      ** Month of last update
164500200528      **
164600200528     C                   MOVEL     @MLUP         IGMLUP
164700200528      **
164800200528      ** Year of last update
164900200528      **
165000200528     C                   Z-ADD     @YLUP         IGYLUP
165100200528      **
165200200528      ** Time of last update
165300200528      **
165400200528     C                   TIME                    IGTLUP
165500200528      **
165600200528      ** Type of last change (set in validation function)
165700200528      **
165800200528     C                   MOVEL     IGCHTP        IGCHTP
165900200528      **
166000200528      ** Last change date
166100200528      **
166200200528     C                   Z-ADD     BJRDNB        IGLCD
166300200528      **
166400200528      ** Last update user id
166500200528      **
166600200528     C                   MOVEL     PSUser        IGLUID
166700200528      **
166800200528     C                   ENDSR
166900200528     C*****************************************************************
167000200528      /EJECT
167100200528     C*****************************************************************         CAP006
167200200528     C*                                                               *         CAP006
167300200528     C* CHKOTHUPD - Check for update by another workstation           *         CAP006
167400200528     C*                                                               *         CAP006
167500200528     C*****************************************************************         CAP006
167600200528     C     CHKOTHUPD     BEGSR                                                  CAP006
167700200528                                                                                CAP006
167800200528      ** Retrieve current deal details                                          CAP006
167900200528                                                                                CAP006
168000200528     C                   MOVE      IGDA38        MidasDlNum        6            CAP006
168100200528     C                   MOVE      IGDS38        SequenceNo        3            CAP006
168200200528     C                   MOVE      IGAMNP        DeamAmount       15            CAP006
168300200528                                                                                CAP006
168400200528     C                   Z-ADD     @IGVDY        @KVALD                         CAP006
168500200528     C                   MOVE      @VYEAR        @DSPY                          CAP006
168600200528     C                   IF        BJDFIN = 'D'                                              BUG8014
168700200528     C                   MOVE      @VDMM         @DSPM                          CAP006
168800200528     C                   MOVE      @VDDD         @DSPD                          CAP006
168900200528     C                   ELSE                                                                BUG8014
169000200528     C                   MOVE      @VDDD         @DSPM                                       BUG8014
169100200528     C                   MOVE      @VDMM         @DSPD                                       BUG8014
169200200528     C                   ENDIF                                                               BUG8014
169300200528                                                                                CAP006
169400200528      ** Determine whether program is running interactively or in batch         CAP006
169500200528      **  ( 0 = batch   1 = interactive)                                        CAP006
169600200528      *                                                                         CAP006
169700200528     C                   CALLB     'ZARTVJOBA'                                  CAP006
169800200528     C                   PARM                    @Return           6            CAP006
169900200528     C                   PARM                    @type             1            CAP006
170000200528      *                                                                         CAP006
170100200528      * Allow access to transaction record by Front-Office ID when in Repair    168345
170200200528      * mode for inserts . Set  *RTV module  parameter @@MODE  to   *FRONT      168345
170300200528      * if the pgm is:  a) running in Interactive mode - @Type= 1   ~~~~~~      168345
170400200528      * and             b) action code is Insert - 'I'                          168345
170500200528      * and             c) Front-Office Id is NOT Blank                         168345
170600200528      *                                                                         168345
170700200528     C     @Type         IFEQ      '1'                                          168345
170800200528     C     IGLACT        ANDEQ     'I'                                          168345
170900200528     C     IGFRNT        ANDNE     *BLANKS                                      168345
171000200528      *                                                                         168345
171100200528     C                   MOVE      '*FRONT'      @@MODE                         168345
171200200528      *                                                                         168345
171300200528     C                   ELSE                                                   168345
171400200528      *                                                                         168345
171500200528      * Otherwise, if running in batch use Front-Office ID                      168345
171600200528      *            (if insert)                                                  CAP013
171700200528      *            else, use Midas Deal Number                                  168345
171800200528      *                                                                         168345
171900200528     C     @Type         IFEQ      '0'                                          CAP006
172000200528     C     IGLACT        ANDEQ     'I'                                          CAP013
172100200528     C                   MOVE      '*FRONT'      @@MODE                         CAP006
172200200528     C                   ELSE                                                   CAP006
172300200528     C                   MOVE      *BLANKS       @@MODE                         CAP006
172400200528     C                   END                                                    CAP006
172500200528      *                                                                         168345
172600200528     C                   END                                                    168345
172700200528                                                                                CAP006
172800200528     C                   CALLB     'MMDEAMRTV'                                  CAP006
172900200528      * INPUTS                                                                  CAP006
173000200528      *                                                                         CAP006
173100200528      * Return code                                                             CAP006
173200200528     C                   PARM      *BLANK        RetCodeOut                     CAP006
173300200528      *                                                                         CAP006
173400200528      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP006
173500200528      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP006
173600200528      *                                                                         CAP006
173700200528     C                   PARM                    @@MODE            6            CAP006
173800200528      *                                                                         CAP006
173900200528      * Response mode                                                           CAP006
174000200528     C                   PARM      ' '           @@RSMD            1            CAP006
174100200528      *                                                                         CAP006
174200200528      * Action Code                                                             CAP006
174300200528     C                   PARM                    IGLACT                         CAP006
174400200528      *                                                                         CAP006
174500200528      * Front Office Transaction ID                                             CAP006
174600200528     C                   PARM      IGFRNT        FOTRID           20            CAP006
174700200528      *                                                                         CAP006
174800200528      * Front Office Associated Transaction Id                                  CAP006
174900200528     C                   PARM      IGAFRT        FOASID           20            CAP006
175000200528      *                                                                         CAP006
175100200528      * (Midas) Deal Number                                                     CAP006
175200200528     C                   PARM                    MidasDlNum                     CAP006
175300200528      *                                                                         CAP006
175400200528      * Value Date
175500200528     C                   PARM      ValueDate     DDVDAT            6
175600200528      *
175700200528      * Sequence Number
175800200528     C                   PARM      SequenceNo    DDDS38            3
175900200528      *
176000200528      * Deal Amendment Amount
176100200528     C                   PARM      DeamAmount    DDAMNP           15
176200200528      *
176300200528      * Deal Amendment Type
176400200528     C                   PARM      IGMTYP        DDMTYP            2
176500200528      * Action Code (Reversal transaction)                                                    260173
176600200528     C                   PARM      *BLANK        @ACTRV            1                          260173
176700200528      *
176800200528      * OUTPUTS                                                                 CAP006
176900200528      *                                                                         CAP006
177000200528      * (Current) deal in file format                                           CAP006
177100200528     C                   PARM                    ChkDealFmt                     CAP006
177200200528      *                                                                         CAP006
177300200528      * OK - Action code                                                        CAP006
177400200528     C                   PARM      *BLANK        OKACTN                         CAP006
177500200528      *                                                                         CAP006
177600200528      * OK - Deal Number                                                        CAP006
177700200528     C                   PARM      *BLANK        OKDLNO                         CAP006
177800200528      *                                                                         CAP006
177900200528      * OK - Value Date
178000200528     C                   PARM      *BLANK        OKVDAT            1
178100200528      *
178200200528      * OK - Sequence Number
178300200528     C                   PARM      *BLANK        OKSEQN            1
178400200528      *
178500200528      * Error fields/message IDs/message data (arrays) from/to caller           CAP006
178600200528     C                   PARM      *BLANK        FldNameArr                     CAP006
178700200528     C                   PARM      *BLANK        MsgIdArr                       CAP006
178800200528     C                   PARM      *BLANK        MsgDtaArr                      CAP006
178900200528      *                                                                         CAP006
179000200528      * Array index (3P0) from/to caller                                        CAP006
179100200528     C                   PARM      *ZERO         Idx               3 0          CAP006
179200200528      *                                                                         CAP006
179300200528      *                                                                         CAP006
179400200528      ** Error if Timestamp is not the same (record has been changed            CAP006
179500200528      **  by another workstation)                                               CAP006
179600200528                                                                                CAP006
179700200528      ** Processing varies according to mode program is running in.             CAP006
179800200528      ** In interacive mode simply check whether the timestamp field            CAP006
179900200528      ** has been updated since the original deal was fetched by this           CAP006
180000200528      ** program.                                                               CAP006
180100200528      ** In batch (API input) check return parameters from Retrieve             CAP006
180200200528      ** module for errors, and send message to system operator.                CAP006
180300200528                                                                                CAP006
180400200528      ** Interactive mode:                                                      CAP006
180500200528                                                                                CAP006
180600200528     C     @TYPE         IFEQ      '1'                                          CAP006
180700200528                                                                                CAP006
180800200528     C     CHHNTMST      IFNE      IGTMESTMP                                    CAP006
180900200528     C                   MOVEL     '*RECUPD'     @@RTCD                         CAP006
181000200528     C                   END                                                    CAP006
181100200528                                                                                CAP006
181200200528      ** Batch mode:                                                            CAP006
181300200528     C                   ELSE                                                   CAP006
181400200528     C     OKACTN        IFEQ      'N'                                          CAP006
181500200528     C     OKDLNO        OREQ      'N'                                          CAP006
181600200528     C                   MOVEL     '*RECUPD'     @@RTCD                         CAP006
181700200528     C                   Z-ADD     1             C                 2 0          CAP006
181800200528                                                                                CAP006
181900200528     C     C             DOWLE     ArrayMax                                     CAP006
182000200528     C     FldNameArr(C) ANDNE     *BLANKS                                      CAP006
182100200528     C*******************MOVEL     *BLANKS       DBError          28     CAP006 CAP013
182200200528     C*******************MOVEL     MsgIDArr(C)   DBError                 CAP006 CAP013
182300200528     C                   CLEAR                   DBError         132            CAP013
182400200528     C                   EVAL      DBerror = 'Update error: ' + FOTRID          CAP013
182500200528     C                   CALLB     'ZAMSGTOOPR'                                 CAP006
182600200528     C                   PARM                    MsgSndRtn        10            CAP006
182700200528     C                   PARM                    DBError                        CAP006
182800200528     C                   PARM                    DummyMsgID                     CAP006
182900200528     C                   PARM                    DummyMsgF                      CAP006
183000200528     C                   ADD       1             C                              CAP006
183100200528     C                   END                                                    CAP006
183200200528                                                                                CAP006
183300200528     C                   END                                                    CAP006
183400200528                                                                                CAP006
183500200528     C                   END                                                    CAP006
183600200528                                                                                CAP006
183700200528     C                   ENDSR                                                  CAP006
183800200528     C*****************************************************************         CAP006
183900200528      /EJECT                                                                    CAP006
184000200528     C*****************************************************************
184100200528     C*                                                               *
184200200528     C* ONLNUP - ON-LINE UPDATES (MEMOS, PRONO, OLPOS, RSACMTPD)      *
184300200528     C*                                                               *
184400200528     C*****************************************************************
184500200528     C     ONLNUP        BEGSR
184600200528      *
184700200528     C                   CALL      'AOOUMMU0'
184800200528     C                   PARM      *BLANK        @RTCD
184900200528     C                   PARM                    Z#BSTS
185000200528     C                   PARM                    Z#ASTS
185100200528     C                   PARM                    Z#WSTS
185200200528     C                   PARM      *BLANK        @AURO             1
185300200528     C                   PARM                    #FPAYF                                     AR821086
185400200528     C                   PARM                    #FRECF                                     AR821086
185500200528      ** FRCD Issued Extension details before update                                          CDL033
185600200528     C                   PARM      *BLANKS       PBFRCD                                       CDL033
185700200528      ** FRCD Issued Extension details after update                                           CDL033
185800200528     C                   PARM      *BLANKS       PAFRCD                                       CDL033
185900200528     C                   PARM      *BLANKS       DLDLQD                                       CER049
186000200528     C                   PARM      *BLANKS       BeDealsDtlC                               AR1044820
186100200528     C                   PARM      *BLANKS       AfDealsDtlC                               AR1044820
186200200528      *                                                                                    AR1044820
186300200528      ** Calling Program                                                                   AR1044820
186400200528      *                                                                                    AR1044820
186500200528     C                   PARM      *BLANKS       CALLER           10                       AR1044820
186600200528     C/COPY WNCPYSRC,MMDEAMMC04
186700200528     C     @RTCD         IFEQ      '*ERROR*'
186800200528     C                   MOVEL     *BLANK        DBKEY
186900200528     C                   MOVEL     'AOOUMMU0'    DBFILE                         *************
187000200528     C                   MOVEL     '991'         DBASE                          * DBERR 991 *
187100200528     C                   EXSR      SRERR                                        *************
187200200528     C                   END
187300200528      *                                                                         CDE001
187400200528      ** Data export for CCRM - Limits                                          CDE001
187500200528     C                   IF        CDE001 = 'Y'                                 CDE001
187600200528     C                   MOVEL     IGDA38        T#TREF                         CDE001
187700200528     C                   CALLB     'DEWRTTRIG'                                  CDE001
187800200528     C**********         PARM                    T#TREF           20                   CDE001 CGL029
187900200528     C                   PARM                    T#TREF           26                          CGL029
188000200528     C                   PARM      'LDNI'        T#TCAT            4            CDE001
188100200528     C                   PARM      *BLANKS       T#RSRV           10            CDE005
188200200528     C                   ENDIF                                                  CDE001
188300200528     C/COPY WNCPYSRC,MMDEAMMC02
188400200528      *
188500200528                                                                                              CRE020
188600200528      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
188700200528                                                                                              CRE020
188800200528     C                   IF        IGLACT = 'A' OR                                            CRE020
188900200528     C                             IGLACT = 'D'                                               CRE020
189000200528     C                   IF        CRE020 = 'Y' AND                                           CRE020
189100200528     C                             WSysVal01 = 'Y'                                            CRE020
189200200528     C                   EXSR      SRIdxTrn                                                   CRE020
189300200528     C                   ENDIF                                                                CRE020
189400200528     C                   ENDIF                                                                CRE020
189500200528     C                   ENDSR
189600200528     C*****************************************************************
189700200528      /EJECT
189800200528     C*****************************************************************
189900200528     C*                                                               *
190000200528     C* TREAUP - TREASURY MANAGEMENT UPDATES                          *
190100200528     C*                                                               *
190200200528     C*****************************************************************
190300200528     C     TREAUP        BEGSR
190400200528      *
190500200528     C                   CALLB     'MMDEAMUPT'
190600200528     C                   PARM      *BLANK        @RTCD
190700200528     C                   PARM      IGLACT        @LACT             1
190800200528     C                   PARM                    Z#BSTS
190900200528     C                   PARM                    Z#ASTS
191000200528     C                   PARM                    Z#WSTS
191100200528     C     @RTCD         IFEQ      '*ERROR '
191200200528     C                   MOVEL     *BLANK        DBKEY
191300200528     C                   MOVEL     'MMDEAMTU'    DBFILE                         *************
191400200528     C                   MOVEL     '992'         DBASE                          * DBERR 992 *
191500200528     C                   EXSR      SRERR                                        *************
191600200528     C                   END
191700200528      *
191800200528     C                   ENDSR
191900200528      *****************************************************************
192000200528      /EJECT
192100200528     C*****************************************************************
192200200528     C*                                                               *
192300200528     C* CLSINT - CALCULATE SETTLE INTEREST                            *
192400200528     C*                                                               *
192500200528     C*****************************************************************
192600200528     C     CLSINT        BEGSR
192700200528      *
192800200528     C                   CALLB     'ZADEAMSINT'
192900200528      *
193000200528      ** INPUT
193100200528      *
193200200528      ** Deal number
193300200528     C                   PARM      IGDA38        ##DA38            6 0
193400200528      *
193500200528      ** Value date of deal amendment - Midas day number
193600200528     C                   PARM      IGDVSD        ##VDAT            5 0
193700200528      *
193800200528      ** Deal type of related deal
193900200528     C                   PARM      W#MTYP        ##MTYP            2
194000200528      *
194100200528      ** Value date of related deal - YYYYMMDD
194200200528     C                   PARM      W#RVDY        ##RVDY            8 0
194300200528      *
194400200528      ** Principal of related deal
194500200528     C                   PARM      W#AMT         ##AMT            15 0
194600200528      *
194700200528      ** Interest rate of related deal
194800200528     C                   PARM      W#INTR        ##INTR           11 7
194900200528      *
195000200528      ** Calculation method of related deal
195100200528     C                   PARM      W#CALC        ##CALC            1
195200200528      *
195300200528      ** Round down interest indicator of related deal
195400200528     C                   PARM      W#RDFC        ##RDFC            1
195500200528      *
195600200528      ** OUTPUT
195700200528      *
195800200528      ** Settle Interest
195900200528     C                   PARM      *ZERO         ##SINT           13 0
196000200528      *
196100200528     C                   ENDSR
196200200528      *****************************************************************
196300200528      /EJECT
196400200528     C*****************************************************************
196500200528     C*                                                               *
196600200528     C* CVTVDT - CONVERT DEAL AMENDMENT VALUE DATE TO YYYYMMDD FORMAT *
196700200528     C*                                                               *
196800200528     C*****************************************************************
196900200528     C     CVTVDT        BEGSR
197000200528      **
197100200528      ** Deam value date - yyyy       IGVDYY
197200200528      ** Deam value date - mm         IGVDMM
197300200528      ** Deam value date - dd         IGVDDD
197400200528      **  CONVERT VALUE DATE FROM DAY NUMBER TO YMD
197500200528      **
197600200528     C                   Z-ADD     IGDVSD        @DAYN
197700200528     C                   CALLB     'ZDATE9'
197800200528     C                   PARM                    @DAYN
197900200528     C                   PARM                    @YMD
198000200528     C                   PARM                    @RETN
198100200528     C                   Z-ADD     @YMD          @IGVDY
198200200528      *
198300200528     C                   ENDSR
198400200528      *****************************************************************
198500200528      /EJECT
198600200528     C*****************************************************************
198700200528     C*                                                               *
198800200528     C* ACRDEL - ACCESS RELATED DEAL INFORMATION                      *
198900200528     C*                                                               *
199000200528     C*****************************************************************
199100200528     C     ACRDEL        BEGSR
199200200528      *
199300200528      **  ACCESS RELATED MM DEAL
199400200528      *
199500200528     C     IGDA38        CHAIN     MMDEALLL                           99
199600200528      *
199700200528      **  DATABASE ERROR IF DEAL NOT FOUND
199800200528      *
199900200528     C     *IN99         IFEQ      '1'
200000200528     C                   MOVEL     IGDA38        DBKEY
200100200528     C                   MOVEL     'MMDEALLL'    DBFILE                         *************
200200200528     C                   MOVEL     '800'         DBASE                          * DBERR 800 *
200300200528     C                   EXSR      SRERR                                        *************
200400200528     C                   RETURN
200500200528     C                   END
200600200528      *
200700200528      * LOAD RELATED DEAL WORK FIELDS ACCORDING TO FORMAT READ
200800200528      *
200900200528     C     ##FORM        IFEQ      'MMDELDP0'
201000200528     C                   MOVE      HKTYPE        W#TYPE            2
201100200528     C                   MOVE      HKSTYP        W#STYP            2
201200200528     C                   MOVE      HKCLAS        W#CLAS            4                          CDL038
201300200528     C                   MOVEL     HKMTYP        W#MTYP            2
201400200528     C                   MOVEL     @HKVDY        W#RVDY            8 0
201500200528     C                   Z-ADD     HKAMNP        W#AMT            15 0
201600200528     C                   Z-ADD     HKINTR        W#INTR           11 7
201700200528     C                   MOVEL     HKICMT        W#CALC            1
201800200528     C                   MOVEL     HKRDFC        W#RDFC            1
201900200528     C                   MOVEL     HKBRCA        W#BRCA            3
202000200528      *
202100200528     C                   MOVEL     MMDELD        Z#WSTS
202200200528      *
202300200528     C                   ELSE
202400200528     C                   MOVE      HLTYPE        W#TYPE
202500200528     C                   MOVE      HLSTYP        W#STYP
202600200528     C                   MOVE      HLCLAS        W#CLAS                                       CDL038
202700200528     C                   MOVEL     HLMTYP        W#MTYP
202800200528     C                   MOVEL     @HLVDY        W#RVDY
202900200528     C                   Z-ADD     HLFVAL        W#AMT
203000200528     C                   Z-ADD     HLFRAT        W#INTR
203100200528     C                   MOVEL     HLICMT        W#CALC
203200200528     C                   MOVEL     HLRDFC        W#RDFC
203300200528     C                   MOVEL     HLBRCA        W#BRCA
203400200528      *
203500200528     C                   MOVEL     MMDENB        Z#WSTS
203600200528      *
203700200528     C                   END
203800200528      *
203900200528      * LOAN OR DEPOSIT TYPE DEAL?
204000200528      *
204100200528     C     W#MTYP        IFEQ      'IT'
204200200528     C     W#MTYP        OREQ      'TD'
204300200528     C     W#MTYP        OREQ      'CI'
204400200528     C     W#MTYP        OREQ      'CD'
204500200528     C     W#MTYP        OREQ      'CF'                                                       CDL033
204600200528     C     CDL033        ANDEQ     'Y'                                                        CDL033
204700200528     C                   MOVEL     'D'           W#LOD             1
204800200528     C                   ELSE
204900200528     C                   MOVEL     'L'           W#LOD
205000200528     C                   END
205100200528      *
205200200528     C                   ENDSR
205300200528      *****************************************************************                       CSD015
205400200528      /EJECT                                                                                  CSD015
205500200528      *****************************************************************                       CSD015
205600200528      *                                                               *                       CSD015
205700200528      * SRWTCH - Initiates the Midas Compliance Engine.               *                       CSD015
205800200528      *                                                               *                       CSD015
205900200528      *****************************************************************                       CSD015
206000200528     C     SRWTCH        BEGSR                                                                CSD015
206100200528      *                                                                                       CSD015
206200200528      ** Initialise the Transaction Details Parameter                                         CSD015
206300200528      ** ============================================                                         CSD015
206400200528      *                                                                                       CSD015
206500200528     C                   CLEAR                   SDWLTD                                       CSD015
206600200528      *                                                                                       CSD015
206700200528      ** Item Type, Identifier, and Branch information.                                       CSD015
206800200528      *                                                                                       CSD015
206900200528     C                   CAT       'MM':0        W4ITEM                                       CSD015
207000200528     C                   CAT       HNMTYP:0      W4ITEM                                       CSD015
207100200528      *                                                                                       CSD015
207200200528     C                   MOVE      HNDA38        WHNDA3                                       CSD015
207300200528     C                   MOVE      HNVDYY        WHNVDY                                       CSD015
207400200528     C                   MOVE      HNVDMM        WHNVDM                                       CSD015
207500200528     C                   MOVE      HNVDDD        WHNVDD                                       CSD015
207600200528     C                   MOVE      HNDS38        WHNDS3                                       CSD015
207700200528     C                   EVAL      W4IDEN = WHNDA3 + WHNVDY + WHNVDM +                        CSD015
207800200528     C                             WHNVDD + WHNDS3                                            CSD015
207900200528     C                   MOVEL     HNBRCA        W4BRCH                                       CSD015
208000200528      *                                                                                       CSD015
208100200528      ** Select the System Prefix.                                                            CSD015
208200200528      *                                                                                       CSD015
208300200528     C                   IF        CSC011 = 'Y'                                               CSD015
208400200528     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
208500200528     C                   ELSE                                                                 CSD015
208600200528     C                   EVAL      W4SYSM = LIBR                                              CSD015
208700200528     C                   ENDIF                                                                CSD015
208800200528      *                                                                                       CSD015
208900200528     C                   MOVEL     'MMDEAMPP'    W4FUNT                                       CSD015
209000200528      *                                                                                       CSD015
209100200528      ** Get the Counter Party Detail.                                                        CSD015
209200200528      *                                                                                       CSD015
209300200528     C                   EXSR      SRGetCtrpDet                                               CSD015
209400200528     C                   MOVEL     HNCNUM        W4CNUM                                       CSD015
209500200528     C                   MOVEL     WCtrpTyp      W4CTYP                                       CSD015
209600200528     C                   MOVEL     WCtrpRpt      W4CUST                                       CSD015
209700200528      *                                                                                       CSD015
209800200528      ** Get the Deal Date.                                                                   CSD015
209900200528      *                                                                                       CSD015
210000200528     C                   MOVE      @IGDDY        WDATE                                        CSD015
210100200528     C                   MOVE      WLongYr       WYear                                        222059
210200200528     C                   MOVE      WMnth         WMonth                                       222059
210300200528     C                   MOVE      WDays         WDay                                         222059
210400200528     C                   EVAL      WDDT = WYear + '-'                                         CSD015
210500200528     C                             + WMonth + '-' +WDay                                       CSD015
210600200528     C                   MOVEL     WDDT          W4DDAT                                       CSD015
210700200528      *                                                                                       CSD015
210800200528      ** Get the Value Date.                                                                  CSD015
210900200528      *                                                                                       CSD015
211000200528     C                   MOVE      @IGVDY        WDATE                                        CSD015
211100200528     C                   MOVE      WLongYr       WYear                                        222059
211200200528     C                   MOVE      WMnth         WMonth                                       222059
211300200528     C                   MOVE      WDays         WDay                                         222059
211400200528     C                   EVAL      WDDT = WYear + '-'                                         CSD015
211500200528     C                             + WMonth + '-' +WDay                                       CSD015
211600200528     C                   MOVEL     WDDT          W4VDAT                                       CSD015
211700200528                                                                                              CSD015
211800200528     C                   IF        WDDT = '0000-00-00'                                        CSD015
211900200528     C                   EVAL      WDDT = '0001-01-01'                                        CSD015
212000200528     C                   ENDIF                                                                CSD015
212100200528                                                                                              CSD015
212200200528      *                                                                                       CSD015
212300200528      ** Currency and Amount information.                                                     CSD015
212400200528      *                                                                                       CSD015
212500200528     C                   MOVEL     HNCCY         W4DEN1                                       CSD015
212600200528      *                                                                                       CSD015
212700200528     C                   MOVEL     HNCCY         PZACcy                                       CSD015
212800200528     C                   MOVE      *BLANKS       PZANtvAmt                                    CSD015
212900200528     C                   MOVE      HNAMNP        PZANtvAmt                                    CSD015
213000200528     C                   EXSR      SRAmtToNum                                                 CSD015
213100200528     C                   EVAL      W4AMT1 = WAMT                                              CSD015
213200200528      *                                                                                       CSD015
213300200528      ** Build the Free Format String                                                         CSD015
213400200528      ** ============================                                                         CSD015
213500200528      *                                                                                       CSD015
213600200528      ** Initialise additional account line.                                                  CSD015
213700200528      *                                                                                       CSD015
213800200528     C                   MOVEA     *BLANKS       WLFSD                                        CSD015
213900200528     C                   MOVEL     HNRIBA        WLFSD(2)                                     CSD015
214000200528     C                   MOVEL     HNPIBA        WLFSD(6)                                     CSD015
214100200528     C                   MOVEL     HNRCRA        WLFSD(9)                                     CSD015
214200200528     C                   MOVEL     HNAWBA        WLFSD(11)                                    CSD015
214300200528     C                   MOVEL     HNBENA        WLFSD(12)                                    CSD015
214400200528      *                                                                                       CSD015
214500200528      ** Begin string and packet assembly.                                                    CSD015
214600200528      *                                                                                       CSD015
214700200528     C                   EVAL      Ctr = 1                                                    CSD015
214800200528     C                   EVAL      PFreeFmtStr = *BLANKS                                      CSD015
214900200528     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
215000200528     C                   EVAL      WData = *BLANKS                                            CSD015
215100200528     C                   EVAL      WData2 = *BLANKS                                           CSD015
215200200528      *                                                                                       CSD015
215300200528     C                   DOU       Ctr = ArrMax                                               CSD015
215400200528      *                                                                                       CSD015
215500200528     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
215600200528      *                                                                                       CSD015
215700200528      ** Select the currency for nostro fields.                                               CSD015
215800200528      *                                                                                       CSD015
215900200528     C                   IF        Ctr = 1 OR                                                 CSD015
216000200528     C                             Ctr = 5                                                    CSD015
216100200528     C                   IF        HNSTCY <> *BLANKS                                          CSD015
216200200528     C                   EVAL      WCcy = HNSTCY                                              CSD015
216300200528     C                   ELSE                                                                 CSD015
216400200528     C                   EVAL      WCcy = HNCCY                                               CSD015
216500200528     C                   ENDIF                                                                CSD015
216600200528     C                   ENDIF                                                                CSD015
216700200528      *                                                                                       CSD015
216800200528      ** Call the detail retriever program.                                                   CSD015
216900200528      *                                                                                       CSD015
217000200528     C                   CALL      'SDCWLFMT'                                                 CSD015
217100200528     C                   PARM      *BLANKS       @RtCd                                        CSD015
217200200528     C                   PARM                    WLF(Ctr)                                     CSD015
217300200528     C                   PARM      *BLANKS       PInpA                                        CSD015
217400200528     C                   PARM      *BLANKS       PInpB                                        CSD015
217500200528     C                   PARM      *BLANKS       PInpC                                        CSD015
217600200528     C                   PARM      *BLANKS       PInpD                                        CSD015
217700200528     C                   PARM      *BLANKS       PInpE                                        CSD015
217800200528     C                   PARM                    WCcy                                         CSD015
217900200528     C                   PARM                    WData                                        CSD015
218000200528     C                   PARM                    WData2                                       CSD015
218100200528      *                                                                                       CSD015
218200200528     C                   IF        WData <> *BLANKS AND                                       CSD015
218300200528     C                             @RtCd = *BLANKS                                            CSD015
218400200528     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
218500200528     C                   CAT       WData:0       WXMLPacket                                   CSD015
218600200528     C                   CAT       WLFSD(Ctr):1  WXMLPacket                                   CSD015
218700200528     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
218800200528     C                   CAT       WXMLPacket:0  PFreeFmtStr                                  CSD015
218900200528     C                   ENDIF                                                                CSD015
219000200528      *                                                                                       CSD015
219100200528     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
219200200528     C                   EVAL      WData = *BLANKS                                            CSD015
219300200528     C                   EVAL      WCcy = *BLANKS                                             CSD015
219400200528      *                                                                                       CSD015
219500200528     C                   ENDIF                                                                CSD015
219600200528      *                                                                                       CSD015
219700200528     C                   EVAL      Ctr = Ctr + 1                                              CSD015
219800200528      *                                                                                       CSD015
219900200528     C                   ENDDO                                                                CSD015
220000200528      *                                                                                       CSD015
220100200528      ** Add the Payment Details.                                                             CSD015
220200200528      *                                                                                       CSD015
220300200528     C                   IF        HNDTP1 <> *BLANKS OR                                       CSD015
220400200528     C                             HNDTP2 <> *BLANKS OR                                       CSD015
220500200528     C                             HNDTP3 <> *BLANKS OR                                       CSD015
220600200528     C                             HNDTP4 <> *BLANKS                                          CSD015
220700200528      *                                                                                       CSD015
220800200528     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
220900200528     C                   CAT       HNDTP1:0      WXMLPacket                                   CSD015
221000200528     C                   CAT       HNDTP2:1      WXMLPacket                                   CSD015
221100200528     C                   CAT       HNDTP3:1      WXMLPacket                                   CSD015
221200200528     C                   CAT       HNDTP4:1      WXMLPacket                                   CSD015
221300200528     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
221400200528     C                   CAT       WXMLPacket:0  PFreeFmtStr                                  CSD015
221500200528      *                                                                                       CSD015
221600200528     C                   ENDIF                                                                CSD015
221700200528      *                                                                                       CSD015
221800200528      ** Check for compliance.                                                                CSD015
221900200528      *                                                                                       CSD015
222000200528     C                   IF        PFreeFmtStr <> *BLANKS                                     CSD015
222100200528     C                   CALL      'SDCWLCHK'                                                 CSD015
222200200528     C                   PARM                    SDWLTD                                       CSD015
222300200528     C                   PARM                    PFreeFmtStr                                  CSD015
222400200528     C                   ENDIF                                                                CSD015
222500200528      *                                                                                       CSD015
222600200528     C                   ENDSR                                                                CSD015
222700200528      *****************************************************************                       CSD015
222800200528      /EJECT                                                                                  CSD015
222900200528      *****************************************************************                       CSD015
223000200528      *                                                               *                       CSD015
223100200528      * SRCompChk - Handles the entire compliance checking            *                       CSD015
223200200528      *                                                               *                       CSD015
223300200528      *****************************************************************                       CSD015
223400200528     C     SRCompChk     BEGSR                                                                CSD015
223500200528      *                                                                                       CSD015
223600200528     C                   SELECT                                                               CSD015
223700200528      *                                                                                       CSD015
223800200528      ** Execute a direct compliance check on insert operations.                              CSD015
223900200528      *                                                                                       CSD015
224000200528     C                   WHEN      WCompMode = OnInsert                                       CSD015
224100200528      *                                                                                       CSD015
224200200528     C                   EVAL      WMoveMode = ALL                                            CSD015
224300200528      *                                                                                       CSD015
224400200528      ** Move relevant file fields to their respective                                        CSD015
224500200528      ** Watch List fields and then check for useful                                          CSD015
224600200528      ** fields to return to the Compliance Engine.                                           CSD015
224700200528      *                                                                                       CSD015
224800200528     C                   EXSR      SRDBFsToWLFs                                               CSD015
224900200528     C                   EXSR      SRWLFChk                                                   CSD015
225000200528      *                                                                                       CSD015
225100200528     C                   IF        WOKFlg = 'Y'                                               CSD015
225200200528     C                   EXSR      SRWTCH                                                     CSD015
225300200528     C                   ENDIF                                                                CSD015
225400200528      *                                                                                       CSD015
225500200528      ** If the action associated with the current record is Amend,                           CSD015
225600200528      ** check first if this record has been analysed by the CE.                              CSD015
225700200528      *                                                                                       CSD015
225800200528     C                   WHEN      WCompMode = OnAmend                                        CSD015
225900200528      *                                                                                       CSD015
226000200528     C                   EXSR      SRRetryChk                                                 CSD015
226100200528      *                                                                                       CSD015
226200200528     C                   IF        WRetryFlg = 'Y'                                            CSD015
226300200528     C                   EVAL      WMoveMode = ALL                                            CSD015
226400200528     C                   ELSE                                                                 CSD015
226500200528     C                   EVAL      WMoveMode = CHANGED                                        CSD015
226600200528     C                   ENDIF                                                                CSD015
226700200528      *                                                                                       CSD015
226800200528     C                   EXSR      SRDBFsToWLFs                                               CSD015
226900200528     C                   EXSR      SRWLFChk                                                   CSD015
227000200528     C                   IF        (WOKFlg = 'Y' AND                                          CSD015
227100200528     C                             WChgFlg = 'Y') OR                                          CSD015
227200200528     C                             WRetryFlg = 'Y'                                            CSD015
227300200528     C                   EXSR      SRWTCH                                                     CSD015
227400200528     C                   ENDIF                                                                CSD015
227500200528      *                                                                                       CSD015
227600200528     C                   ENDSL                                                                CSD015
227700200528      *                                                                                       CSD015
227800200528     C                   ENDSR                                                                CSD015
227900200528      *****************************************************************                       CSD015
228000200528      /EJECT                                                                                  CSD015
228100200528      *****************************************************************                       CSD015
228200200528      *                                                               *                       CSD015
228300200528      * SRDBFsToWLFs - Moves relevant database fields to their        *                       CSD015
228400200528      *                respective Watch List Fields.                  *                       CSD015
228500200528      *                                                               *                       CSD015
228600200528      *****************************************************************                       CSD015
228700200528     C     SRDBFsToWLFs  BEGSR                                                                CSD015
228800200528      *                                                                                       CSD015
228900200528      ** Initialise the Watch List Fields array to blanks.                                    CSD015
229000200528      *                                                                                       CSD015
229100200528     C                   MOVEA     *BLANKS       WLF                                          CSD015
229200200528      *                                                                                       CSD015
229300200528     C                   SELECT                                                               CSD015
229400200528      *                                                                                       CSD015
229500200528      ** Execute an unconditional move if necessary.                                          CSD015
229600200528      *                                                                                       CSD015
229700200528     C                   WHEN      WMoveMode = ALL                                            CSD015
229800200528      *                                                                                       CSD015
229900200528     C                   MOVEL     HNRONS        WLF(1)                                       CSD015
230000200528     C                   MOVEL     HNRIBN        WLF(2)                                       CSD015
230100200528     C                   MOVEL     HNROBN        WLF(3)                                       CSD015
230200200528     C                   MOVEL     HNROCN        WLF(4)                                       CSD015
230300200528     C                   MOVEL     HNPONS        WLF(5)                                       CSD015
230400200528     C                   MOVEL     HNPIBN        WLF(6)                                       CSD015
230500200528     C                   MOVEL     HNPOBN        WLF(7)                                       CSD015
230600200528     C                   MOVEL     HNPOCN        WLF(8)                                       CSD015
230700200528     C                   MOVEL     HNRCRN        WLF(9)                                       CSD015
230800200528     C                   MOVEL     HNRVNO        WLF(10)                                      CSD015
230900200528     C                   MOVEL     HNAWBN        WLF(11)                                      CSD015
231000200528     C                   MOVEL     HNBENN        WLF(12)                                      CSD015
231100200528      *                                                                                       CSD015
231200200528     C                   WHEN      WMoveMode = CHANGED                                        CSD015
231300200528      *                                                                                       CSD015
231400200528      ** Move only the fields that have changed since the last save.                          CSD015
231500200528      *                                                                                       CSD015
231600200528     C                   EVAL      WChgFlg = 'N'                                              CSD015
231700200528      *                                                                                       CSD015
231800200528     C                   IF        HNRONS <> BCRONS                                           CSD015
231900200528     C                   MOVEL     HNRONS        WLF(1)                                       CSD015
232000200528     C                   EVAL      WChgFlg = 'Y'                                              CSD015
232100200528     C                   ENDIF                                                                CSD015
232200200528      *                                                                                       CSD015
232300200528     C                   IF        HNRIBN <> BCRIBN                                           CSD015
232400200528     C                   MOVEL     HNRIBN        WLF(2)                                       CSD015
232500200528     C                   EVAL      WChgFlg = 'Y'                                              CSD015
232600200528     C                   ENDIF                                                                CSD015
232700200528      *                                                                                       CSD015
232800200528     C                   IF        HNROBN <> BCROBN                                           CSD015
232900200528     C                   MOVEL     HNROBN        WLF(3)                                       CSD015
233000200528     C                   EVAL      WChgFlg = 'Y'                                              CSD015
233100200528     C                   ENDIF                                                                CSD015
233200200528      *                                                                                       CSD015
233300200528     C                   IF        HNROCN <> BCROCN                                           CSD015
233400200528     C                   MOVEL     HNROCN        WLF(4)                                       CSD015
233500200528     C                   EVAL      WChgFlg = 'Y'                                              CSD015
233600200528     C                   ENDIF                                                                CSD015
233700200528      *                                                                                       CSD015
233800200528     C                   IF        HNPONS <> BCPONS                                           CSD015
233900200528     C                   MOVEL     HNPONS        WLF(5)                                       CSD015
234000200528     C                   EVAL      WChgFlg = 'Y'                                              CSD015
234100200528     C                   ENDIF                                                                CSD015
234200200528      *                                                                                       CSD015
234300200528     C                   IF        HNPIBN <> BCPIBN                                           CSD015
234400200528     C                   MOVEL     HNPIBN        WLF(6)                                       CSD015
234500200528     C                   EVAL      WChgFlg = 'Y'                                              CSD015
234600200528     C                   ENDIF                                                                CSD015
234700200528      *                                                                                       CSD015
234800200528     C                   IF        HNPOBN <> BCPOBN                                           CSD015
234900200528     C                   MOVEL     HNPOBN        WLF(7)                                       CSD015
235000200528     C                   EVAL      WChgFlg = 'Y'                                              CSD015
235100200528     C                   ENDIF                                                                CSD015
235200200528      *                                                                                       CSD015
235300200528     C                   IF        HNPOCN <> BCPOCN                                           CSD015
235400200528     C                   MOVEL     HNPOCN        WLF(8)                                       CSD015
235500200528     C                   EVAL      WChgFlg = 'Y'                                              CSD015
235600200528     C                   ENDIF                                                                CSD015
235700200528      *                                                                                       CSD015
235800200528     C                   IF        HNRCRN <> BCRCRN                                           CSD015
235900200528     C                   MOVEL     HNRCRN        WLF(9)                                       CSD015
236000200528     C                   EVAL      WChgFlg = 'Y'                                              CSD015
236100200528     C                   ENDIF                                                                CSD015
236200200528      *                                                                                       CSD015
236300200528     C                   IF        HNRVNO <> BCRVNO                                           CSD015
236400200528     C                   MOVEL     HNRVNO        WLF(10)                                      CSD015
236500200528     C                   EVAL      WChgFlg = 'Y'                                              CSD015
236600200528     C                   ENDIF                                                                CSD015
236700200528      *                                                                                       CSD015
236800200528     C                   IF        HNAWBN <> BCAWBN                                           CSD015
236900200528     C                   MOVEL     HNAWBN        WLF(11)                                      CSD015
237000200528     C                   EVAL      WChgFlg = 'Y'                                              CSD015
237100200528     C                   ENDIF                                                                CSD015
237200200528      *                                                                                       CSD015
237300200528     C                   IF        HNBENN <> BCBENN                                           CSD015
237400200528     C                   MOVEL     HNBENN        WLF(12)                                      CSD015
237500200528     C                   EVAL      WChgFlg = 'Y'                                              CSD015
237600200528     C                   ENDIF                                                                CSD015
237700200528      *                                                                                       CSD015
237800200528     C                   IF        HNDTP1 <> BCDTP1 OR                                        CSD015
237900200528     C                             HNDTP2 <> BCDTP2 OR                                        CSD015
238000200528     C                             HNDTP3 <> BCDTP3 OR                                        CSD015
238100200528     C                             HNDTP4 <> BCDTP4                                           CSD015
238200200528     C                   EVAL      WChgFlg = 'Y'                                              CSD015
238300200528     C                   ENDIF                                                                CSD015
238400200528      *                                                                                       CSD015
238500200528     C                   ENDSL                                                                CSD015
238600200528      *                                                                                       CSD015
238700200528     C                   ENDSR                                                                CSD015
238800200528      *****************************************************************                       CSD015
238900200528      /EJECT                                                                                  CSD015
239000200528      *****************************************************************                       CSD015
239100200528      *                                                               *                       CSD015
239200200528      * SRWLFChk - Checks if there is something useful to return      *                       CSD015
239300200528      *            to the Compliance Engine.                          *                       CSD015
239400200528      *                                                               *                       CSD015
239500200528      *****************************************************************                       CSD015
239600200528     C     SRWLFChk      BEGSR                                                                CSD015
239700200528      *                                                                                       CSD015
239800200528      ** Check the Watch List Fields array.                                                   CSD015
239900200528      *                                                                                       CSD015
240000200528     C                   EVAL      WOKFlg = 'N'                                               CSD015
240100200528     C                   EVAL      Ctr = 1                                                    CSD015
240200200528      *                                                                                       CSD015
240300200528     C                   DOU       Ctr = (ArrMax - 1)                                         CSD015
240400200528     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
240500200528     C                   EVAL      WOKFlg = 'Y'                                               CSD015
240600200528     C                   LEAVE                                                                CSD015
240700200528     C                   ENDIF                                                                CSD015
240800200528     C                   EVAL      Ctr = Ctr + 1                                              CSD015
240900200528     C                   ENDDO                                                                CSD015
241000200528      *                                                                                       CSD015
241100200528      ** Check the Payment Details.                                                           CSD015
241200200528      *                                                                                       CSD015
241300200528     C                   IF        WOKFlg = 'N'                                               CSD015
241400200528     C                   IF        HNDTP1 <> *BLANKS OR                                       CSD015
241500200528     C                             HNDTP2 <> *BLANKS OR                                       CSD015
241600200528     C                             HNDTP3 <> *BLANKS OR                                       CSD015
241700200528     C                             HNDTP4 <> *BLANKS                                          CSD015
241800200528     C                   EVAL      WOKFlg = 'Y'                                               CSD015
241900200528     C                   ENDIF                                                                CSD015
242000200528     C                   ENDIF                                                                CSD015
242100200528      *                                                                                       CSD015
242200200528     C                   ENDSR                                                                CSD015
242300200528      *****************************************************************                       CSD015
242400200528      /EJECT                                                                                  CSD015
242500200528      *****************************************************************                       CSD015
242600200528      *                                                               *                       CSD015
242700200528      * SRRetryChk - Checks if the current record is unconfirmed by   *                       CSD015
242800200528      *              the Compliance Engine.                           *                       CSD015
242900200528      *                                                               *                       CSD015
243000200528      *****************************************************************                       CSD015
243100200528     C     SRRetryChk    BEGSR                                                                CSD015
243200200528      *                                                                                       CSD015
243300200528     C                   EVAL      WRetryFlg = 'N'                                            CSD015
243400200528     C                   EVAL      KFuncType = *BLANKS                                        CSD015
243500200528     C                   EVAL      KIden = *BLANKS                                            CSD015
243600200528     C                   EVAL      KBranch = *BLANKS                                          CSD015
243700200528      *                                                                                       CSD015
243800200528     C                   MOVEL     'MMDEAMPP'    KFuncType                                    CSD015
243900200528     C                   MOVE      HNDA38        WHNDA3                                       CSD015
244000200528     C                   MOVE      HNVDYY        WHNVDY                                       CSD015
244100200528     C                   MOVE      HNVDMM        WHNVDM                                       CSD015
244200200528     C                   MOVE      HNVDDD        WHNVDD                                       CSD015
244300200528     C                   MOVE      HNDS38        WHNDS3                                       CSD015
244400200528     C                   EVAL      KIden = WHNDA3 + WHNVDY + WHNVDM +                         CSD015
244500200528     C                             WHNVDD + WHNDS3                                            CSD015
244600200528     C                   MOVEL     HNBRCA        KBranch                                      CSD015
244700200528      *                                                                                       CSD015
244800200528     C     KCWHT         CHAIN     SDCWHTL1                                                   CSD015
244900200528      *                                                                                       CSD015
245000200528     C                   IF        %FOUND(SDCWHTL1) AND                                       CSD015
245100200528     C                             W3UNCF = 'Y'                                               CSD015
245200200528     C                   EVAL      WRetryFlg = 'Y'                                            CSD015
245300200528     C                   ENDIF                                                                CSD015
245400200528      *                                                                                       CSD015
245500200528     C                   ENDSR                                                                CSD015
245600200528      *****************************************************************                       CSD015
245700200528      /EJECT                                                                                  CSD015
245800200528      *****************************************************************                       CSD015
245900200528      *                                                               *                       CSD015
246000200528      * SRGetCtrpDet - Gets the Counterparty Details given a Customer *                       CSD015
246100200528      *                Number.                                        *                       CSD015
246200200528      *                                                               *                       CSD015
246300200528      *****************************************************************                       CSD015
246400200528     C     SRGetCtrpDet  BEGSR                                                                CSD015
246500200528      *                                                                                       CSD015
246600200528      ** Initialise the relevant variables.                                                   CSD015
246700200528      *                                                                                       CSD015
246800200528     C                   EVAL      PCustNo = *BLANKS                                          CSD015
246900200528     C                   EVAL      WCtrpRpt = *BLANKS                                         CSD015
247000200528     C                   EVAL      WCtrpTyp = *BLANKS                                         CSD015
247100200528     C                   MOVEL     HNCNUM        PCustNo                                      CSD015
247200200528      *                                                                                       CSD015
247300200528      ** Get the Customer Detail.                                                             CSD015
247400200528      *                                                                                       CSD015
247500200528     C                   CALLB     'AOCUSTR0'                                                 CSD015
247600200528     C                   PARM      *BLANKS       @RtCd                                        CSD015
247700200528     C                   PARM      '*KEY   '     @Optn                                        CSD015
247800200528     C                   PARM                    PCustNo                                      CSD015
247900200528     C                   PARM      *BLANKS       PErrInf                                      CSD015
248000200528     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
248100200528      *                                                                                       CSD015
248200200528     C                   IF        @RtCd = *BLANKS                                            CSD015
248300200528      *                                                                                       CSD015
248400200528      ** Assemble the Counter Party information.                                              CSD015
248500200528      *                                                                                       CSD015
248600200528     C     BBCRNM        CAT       BBCRTN        WCtrpRpt                                     CSD015
248700200528      *                                                                                       CSD015
248800200528      ** Determine the Counterparty Type.                                                     CSD015
248900200528      *                                                                                       CSD015
249000200528     C                   IF        CCF001 = 'Y'                                               CSD015
249100200528      *                                                                                       CSD015
249200200528     C                   IF        BBCRPC = 'Y'                                               CSD015
249300200528     C                   EVAL      WCtrpTyp = 'C'                                             CSD015
249400200528     C                   ELSE                                                                 CSD015
249500200528     C                   EVAL      WCtrpTyp = 'I'                                             CSD015
249600200528     C                   ENDIF                                                                CSD015
249700200528      *                                                                                       CSD015
249800200528     C                   ELSE                                                                 CSD015
249900200528      *                                                                                       CSD015
250000200528     C                   IF        BBLICD <> *BLANKS AND                                      CSD015
250100200528     C                             BBLICD <> W1IND1  AND                                      CSD015
250200200528     C                             BBLICD <> W1IND2  AND                                      CSD015
250300200528     C                             BBLICD <> W1IND3  AND                                      CSD015
250400200528     C                             BBLICD <> W1IND4  AND                                      CSD015
250500200528     C                             BBLICD <> W1IND5                                           CSD015
250600200528     C                   EVAL      WCtrpTyp = 'C'                                             CSD015
250700200528     C                   ELSE                                                                 CSD015
250800200528     C                   EVAL      WCtrpTyp = 'I'                                             CSD015
250900200528     C                   ENDIF                                                                CSD015
251000200528      *                                                                                       CSD015
251100200528     C                   ENDIF                                                                CSD015
251200200528      *                                                                                       CSD015
251300200528     C                   ELSE                                                                 CSD015
251400200528      *                                                                                       CSD015
251500200528      ** Handle Database Errors if any occur.                                                 CSD015
251600200528      *                                                                                       CSD015
251700200528     C                   IF        @RtCd <> '*NRF'                                            CSD015
251800200528     C     *LOCK         IN        LDA                                                        CSD015
251900200528     C                   EVAL      DBKey = @Optn                                              CSD015
252000200528     C                   EVAL      DBFile = 'SDCUSTPD'                                        CSD015
252100200528     C                   EVAL      DBase = 907                                                CSD015
252200200528     C                   OUT       LDA                                                        CSD015
252300200528     C                   EXSR      SRERR                                                      CSD015
252400200528     C                   ENDIF                                                                CSD015
252500200528      *                                                                                       CSD015
252600200528     C                   ENDIF                                                                CSD015
252700200528      *                                                                                       CSD015
252800200528     C                   ENDSR                                                                CSD015
252900200528      *****************************************************************                       CSD015
253000200528      /EJECT                                                                                  CSD015
253100200528      *****************************************************************                       CSD015
253200200528      *                                                               *                       CSD015
253300200528      * SRAmtToNum  - Converts an amount into numeric format data.    *                       CSD015
253400200528      *                                                               *                       CSD015
253500200528      *****************************************************************                       CSD015
253600200528     C     SRAmtToNum    BEGSR                                                                CSD015
253700200528      *                                                                                       CSD015
253800200528      ** Directly convert the given amount into numerical format.                             CSD015
253900200528      *                                                                                       CSD015
254000200528     C                   CALL      'ZACVTAMT'                                                 CSD015
254100200528     C                   PARM      *BLANKS       PZARtCd                                      CSD015
254200200528     C                   PARM                    PZACcy                                       CSD015
254300200528     C                   PARM                    PZANtvAmt                                    CSD015
254400200528     C                   PARM                    PZAAmt                                       CSD015
254500200528     C                   PARM                    PZACvtAmt                                    CSD015
254600200528      *                                                                                       CSD015
254700200528     C                   EVAL      WAMT = PZAAmt                                              CSD015
254800200528      *                                                                                       CSD015
254900200528     C                   ENDSR                                                                CSD015
255000200528      *****************************************************************                       CRE020
255100200528      /EJECT                                                                                  CRE020
255200200528      *****************************************************************                       CRE020
255300200528      *                                                               *                       CRE020
255400200528      *  SRIdxTrn - Handles the advice index of the current           *                       CRE020
255500200528      *             transaction.                                      *                       CRE020
255600200528      *                                                               *                       CRE020
255700200528      *****************************************************************                       CRE020
255800200528     C     SRIdxTrn      BEGSR                                                                CRE020
255900200528                                                                                              CRE020
256000200528      ** Initialise key values.                                                               CRE020
256100200528                                                                                              CRE020
256200200528     C                   MOVE      *BLANKS       KRefNo                                       CRE020
256300200528     C                   MOVE      *BLANKS       KSeqNo                                       CRE020
256400200528     C                   MOVEL     HNDA38        KRefNo                                       CRE020
256500200528     C                   MOVEL     HNDS38        KSeqNo                                       CRE020
256600200528                                                                                              CRE020
256700200528      ** Begin advice index processing.                                                       CRE020
256800200528                                                                                              CRE020
256900200528     C                   OPEN      READVCL2                                                   CRE020
257000200528                                                                                              CRE020
257100200528     C     KADVC         SETLL     READVCL2                                                   CRE020
257200200528     C     KADVC         READE     READVCL2                                                   CRE020
257300200528                                                                                              CRE020
257400200528     C                   DOW       NOT %EOF                                                   CRE020
257500200528                                                                                              CRE020
257600200528      ** Execute amend processing if necessary.                                               CRE020
257700200528                                                                                              CRE020
257800200528     C                   IF        RAUTHI = 'Y' AND                                           CRE020
257900200528     C                             RSAPIN = 'N'                                               CRE020
258000200528     C                   MOVE      'N'           RAUTHI                                       CRE020
258100200528     C                   UPDATE    READVCD0                                                   CRE020
258200200528     C                   ENDIF                                                                CRE020
258300200528                                                                                              CRE020
258400200528      ** Execute reversal processing if necessary.                                            CRE020
258500200528                                                                                              CRE020
258600200528     C                   IF        RAUTHI = 'N' AND                                           CRE020
258700200528     C                             RSAPIN = ' ' AND                                           CRE020
258800200528     C                             HNLACT = 'D'                                               CRE020
258900200528     C                   EVAL      RCHTYP = 'R'                                               CRE020
259000200528     C                   EVAL      RAUTHI = 'Y'                                               CRE020
259100200528     C                   EVAL      RSAPIN = 'Y'                                               CRE020
259200200528     C                   UPDATE    READVCD0                                                   CRE020
259300200528     C                   ENDIF                                                                CRE020
259400200528                                                                                              CRE020
259500200528     C     KADVC         READE     READVCL2                                                   CRE020
259600200528     C                   ENDDO                                                                CRE020
259700200528                                                                                              CRE020
259800200528     C                   CLOSE     READVCL2                                                   CRE020
259900200528                                                                                              CRE020
260000200528     C                   ENDSR                                                                CRE020
260100200528      *****************************************************************
260200200528      /EJECT
260300200528      *****************************************************************
260400200528      *                                                               *
260500200528      * *INZSR - Program Initialisation routine                       *
260600200528      *                                                               *
260700200528      * Called by: Main processing                                    *
260800200528      *                                                               *
260900200528      * Calls: None                                                   *
261000200528      *                                                               *
261100200528      *****************************************************************
261200200528     C     *INZSR        BEGSR
261300200528      *
261400200528      ** PARAMETERS
261500200528      *
261600200528     C     *ENTRY        PLIST
261700200528     C                   PARM                    @@RTCD            7
261800200528     C                   PARM                    MMVDEM
261900200528      *                                                                                       CSD015
262000200528      ** Compliance Watch Hit List Key.                                                       CSD015
262100200528      *                                                                                       CSD015
262200200528     C     KCWHT         KLIST                                                                CSD015
262300200528     C                   KFLD                    KFuncType                                    CSD015
262400200528     C                   KFLD                    KIden                                        CSD015
262500200528     C                   KFLD                    KBranch                                      CSD015
262600200528                                                                                              CRE020
262700200528      ** Midas RE Settled Transaction Index File Key List                                     CRE020
262800200528                                                                                              CRE020
262900200528     C     KADVC         KLIST                                                                CRE020
263000200528     C                   KFLD                    KRefNo                                       CRE020
263100200528     C                   KFLD                    KPrgMn                                       CRE020
263200200528     C                   KFLD                    KSeqNo                                       CRE020
263300200528     C*
263400200528     C** ACCESS BANK DETAILS
263500200528     C*
263600200528     C                   CALLB     'AOBANKR0'
263700200528     C                   PARM      '*MSG    '    @RTCD             7
263800200528     C                   PARM      '*FIRST  '    @OPTN             7
263900200528     C     SDBANK        PARM      SDBANK        DSFDY
264000200528     C*
264100200528     C* DATABASE ERROR
264200200528     C*
264300200528     C     @RTCD         IFNE      *BLANK
264400200528     C                   MOVEL     @OPTN         DBKEY
264500200528     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
264600200528     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
264700200528     C                   EXSR      SRERR                                        *************
264800200528     C                   END
264900200528     C*
265000200528     C*  ACCESS DEAL DATA
265100200528     C*
265200200528     C**********         CALLB     'AODEALR0'                                                 CGL029
265300200528     C                   CALLB     'AODEALR1'                                                 CGL029
265400200528     C                   PARM      '*MSG    '    @RTCD
265500200528     C                   PARM      '*FIRST  '    @OPTN
265600200528     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
265700200528     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
265800200528     C*
265900200528     C* DATABASE ERROR
266000200528     C*
266100200528     C     @RTCD         IFNE      *BLANK
266200200528     C                   MOVEL     @OPTN         DBKEY
266300200528     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
266400200528     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
266500200528     C                   EXSR      SRERR                                        *************
266600200528     C                   END
266700200528      *                                                                         CAP051
266800200528      *  ACCESS DEAL DATA                                                       CAP051
266900200528      *                                                                         CAP051
267000200528     C                   MOVE      'N'           CAP051            1            CAP051
267100200528     C                   CALLB     'AOSARDR0'                                   CAP051
267200200528     C                   PARM      *BLANKS       @RTCD                          CAP051
267300200528     C                   PARM      '*VERIFY '    @OPTN                          CAP051
267400200528     C                   PARM      'CAP051'      @SAR              6            CAP051
267500200528     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
267600200528      *                                                                         CAP051
267700200528     C     @RTCD         IFEQ      *BLANK                                       CAP051
267800200528     C                   MOVE      'Y'           CAP051                         CAP051
267900200528     C                   ENDIF                                                  CAP051
268000200528      *                                                                         CAP051
268100200528     C                   MOVE      BNMMAU        SAVMAU            1            CAP051
268200200528     C                   MOVE      BNMMRA        SAVMRA            1            CAP051
268300200528     C*
268400200528     C** ACCESS MIDAS MODULE DETAILS
268500200528     C*
268600200528     C                   CALLB     'AOMMODR0'
268700200528     C                   PARM      '*MSG    '    @RTCD
268800200528     C                   PARM      '*FIRST  '    @OPTN
268900200528     C     SDMMOD        PARM      SDMMOD        DSFDY
269000200528     C*
269100200528     C* DATABASE ERROR
269200200528     C*
269300200528     C     @RTCD         IFNE      *BLANK
269400200528     C                   MOVEL     @OPTN         DBKEY
269500200528     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
269600200528     C                   MOVEL     '902'         DBASE                          * DBERR 902 *
269700200528     C                   EXSR      SRERR                                        *************
269800200528     C                   END
269900200528      *                                                                         CDE001
270000200528      ** Determine if Data Export for CCRM Limits is active                     CDE001
270100200528     C                   CALL      'AOSARDR0'                                   CDE001
270200200528     C                   PARM      *BLANKS       @RTCD                          CDE001
270300200528     C                   PARM      '*VERIFY'     @OPTN                          CDE001
270400200528     C                   PARM      'CDE001'      @SARD             6            CDE001
270500200528      *                                                                         CDE001
270600200528     C     @RTCD         IFEQ      *BLANK                                       CDE001
270700200528     C                   MOVEL     'Y'           CDE001            1            CDE001
270800200528     C                   ENDIF                                                  CDE001
270900200528                                                                                              CSC011
271000200528      ** Check if CSC011 is installed                                                         CSC011
271100200528                                                                                              CSC011
271200200528     C                   CALLB     'AOSARDR0'                                                 CSC011
271300200528     C                   PARM      *BLANKS       PRTCD                                        CSC011
271400200528     C                   PARM      '*VERIFY'     POPTN                                        CSC011
271500200528     C                   PARM      'CSC011'      PSARD                                        CSC011
271600200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
271700200528                                                                                              CSC011
271800200528     C                   IF        PRTCD = *Blanks                                            CSC011
271900200528                                                                                              CSC011
272000200528     C                   EVAL      CSC011 = 'Y'                                               CSC011
272100200528                                                                                              CSC011
272200200528     C                   IN        SC24X7                                                     CSC011
272300200528     C**********         IN        SDSTAT                                              CSC011 CSD015
272400200528     C                   ELSE                                                                 CSC011
272500200528                                                                                              CSC011
272600200528      ** Database error                                                                       CSC011
272700200528                                                                                              CSC011
272800200528     C                   IF        PRTCD <> '*NRF'                                            CSC011
272900200528     C     *LOCK         IN        LDA                                                        CSC011
273000200528     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
273100200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
273200200528     C                   EVAL      DBASE = 903                                                CSC011
273300200528     C                   OUT       LDA                                                        CSC011
273400200528     C                   EXSR      SRERR                                                      CSC011
273500200528     C                   ENDIF                                                                CSC011
273600200528                                                                                              CSC011
273700200528     C                   ENDIF                                                                CSC011
273800200528                                                                                              CDL010
273900200528      ** Access SAR details file to determine if CDL010 is on.                                CDL010
274000200528      ** (Dealing Transaction Authorisation)                                                  CDL010
274100200528                                                                                              CDL010
274200200528     C                   CALLB     'AOSARDR0'                                                 CDL010
274300200528     C                   PARM      *BLANKS       @RTCD                                        CDL010
274400200528     C                   PARM      '*VERIFY'     @OPTN                                        CDL010
274500200528     C                   PARM      'CDL010'      @SARD             6                          CDL010
274600200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL010
274700200528     C                   IF        @RTCD <> *BLANKS AND                                       CDL010
274800200528     C                             @RTCD <> '*NRF   '                                         CDL010
274900200528     C     *LOCK         IN        LDA                                                        CDL010
275000200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL010
275100200528     C                   EVAL      DBASE = 902                                                CDL010
275200200528     C                   EVAL      DBKEY = 'CDL010'                                           CDL010
275300200528     C                   OUT       LDA                                                        CDL010
275400200528     C                   EXSR      SRERR                                                      CDL010
275500200528     C                   ENDIF                                                                CDL010
275600200528     C                   IF        @RTCD = *BLANKS                                            CDL010
275700200528     C                   EVAL      CDL010 = 'Y'                                               CDL010
275800200528     C                   ELSE                                                                 CDL010
275900200528     C                   EVAL      CDL010 = 'N'                                               CDL010
276000200528     C                   ENDIF                                                                CDL010
276100200528                                                                                              CSD015
276200200528     C                   IN        SDSTAT                                                     CSD015
276300200528                                                                                              CSD015
276400200528      **  Access SAR details to see if CSD015 is switched on.                                 CSD015
276500200528                                                                                              CSD015
276600200528     C                   CALLB     'AOSARDR0'                                                 CSD015
276700200528     C                   PARM      *BLANKS       @RtCd                                        CSD015
276800200528     C                   PARM      '*VERIFY'     @Optn                                        CSD015
276900200528     C                   PARM      'CSD015'      @SARD                                        CSD015
277000200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
277100200528                                                                                              CSD015
277200200528     C                   IF        @RtCd = *BLANKS                                            CSD015
277300200528     C                   EVAL      CSD015 = 'Y'                                               CSD015
277400200528     C                   ELSE                                                                 CSD015
277500200528                                                                                              CSD015
277600200528      ** Database error                                                                       CSD015
277700200528                                                                                              CSD015
277800200528     C                   IF        @RtCd <> '*NRF'                                            CSD015
277900200528     C     *LOCK         IN        LDA                                                        CSD015
278000200528     C                   EVAL      DBKey = 'CSD015'                                           CSD015
278100200528     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
278200200528     C                   EVAL      DBase = 904                                                CSD015
278300200528     C                   OUT       LDA                                                        CSD015
278400200528     C                   EXSR      SRERR                                                      CSD015
278500200528     C                   ENDIF                                                                CSD015
278600200528                                                                                              CSD015
278700200528     C                   ENDIF                                                                CSD015
278800200528                                                                                              CSD015
278900200528      ** Check if transactions are being monitored by Compliance Watch.                       CSD015
279000200528                                                                                              CSD015
279100200528     C                   IF        CSD015 = 'Y'                                               CSD015
279200200528                                                                                              CSD015
279300200528     C                   CALL      'AOWLCCR0'                                                 CSD015
279400200528     C                   PARM      *BLANKS       @RtCd                                        CSD015
279500200528     C                   PARM      '*KEY   '     @Optn                                        CSD015
279600200528     C                   PARM      'DEALING '    PFuncCode                                    CSD015
279700200528     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
279800200528                                                                                              CSD015
279900200528      ** Database error                                                                       CSD015
280000200528                                                                                              CSD015
280100200528     C                   IF        @RtCd <> *BLANKS AND                                       CSD015
280200200528     C                             @RtCd <> '*NRF'                                            CSD015
280300200528     C     *LOCK         IN        LDA                                                        CSD015
280400200528     C                   EVAL      DBKey = 'DEALING'                                          CSD015
280500200528     C                   EVAL      DBFile = 'SDWLCCPD'                                        CSD015
280600200528     C                   EVAL      DBase = 905                                                CSD015
280700200528     C                   OUT       LDA                                                        CSD015
280800200528     C                   EXSR      SRERR                                                      CSD015
280900200528     C                   ENDIF                                                                CSD015
281000200528                                                                                              CSD015
281100200528     C                   ENDIF                                                                CSD015
281200200528                                                                                              CSD015
281300200528      **  Access SAR details to see if CCF001 is switched on.                                 CSD015
281400200528                                                                                              CSD015
281500200528     C                   CALLB     'AOSARDR0'                                                 CSD015
281600200528     C                   PARM      *BLANKS       @RtCd                                        CSD015
281700200528     C                   PARM      '*VERIFY'     @Optn                                        CSD015
281800200528     C                   PARM      'CCF001'      @SARD                                        CSD015
281900200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
282000200528                                                                                              CSD015
282100200528     C                   IF        @RtCd = *BLANKS                                            CSD015
282200200528     C                   EVAL      CCF001 = 'Y'                                               CSD015
282300200528     C                   ELSE                                                                 CSD015
282400200528                                                                                              CSD015
282500200528      ** Database error                                                                       CSD015
282600200528                                                                                              CSD015
282700200528     C                   IF        @RtCd <> '*NRF'                                            CSD015
282800200528     C     *LOCK         IN        LDA                                                        CSD015
282900200528     C                   EVAL      DBKey = 'CCF001'                                           CSD015
283000200528     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
283100200528     C                   EVAL      DBase = 906                                                CSD015
283200200528     C                   OUT       LDA                                                        CSD015
283300200528     C                   EXSR      SRERR                                                      CSD015
283400200528     C                   ENDIF                                                                CSD015
283500200528                                                                                              CSD015
283600200528     C                   ENDIF                                                                CSD015
283700200528                                                                                              CSD015
283800200528      **  Access Compliance Watch Configuration Data if necessary.                            CSD015
283900200528                                                                                              CSD015
284000200528     C                   IF        CSD015 = 'Y'                                               CSD015
284100200528                                                                                              CSD015
284200200528     C                   CALL      'AOCWCDR0'                                                 CSD015
284300200528     C                   PARM      *BLANKS       @RtCd                                        CSD015
284400200528     C                   PARM      '*FIRST '     @Optn                                        CSD015
284500200528     C     SDCWCD        PARM      SDCWCD        DSSDY                                        CSD015
284600200528                                                                                              CSD015
284700200528     C                   IF        @RtCd <> *BLANKS                                           CSD015
284800200528     C     *LOCK         IN        LDA                                                        CSD015
284900200528     C                   EVAL      DBKey = @Optn                                              CSD015
285000200528     C                   EVAL      DBFile = 'SDCWCDPD'                                        CSD015
285100200528     C                   EVAL      DBase = 908                                                CSD015
285200200528     C                   OUT       LDA                                                        CSD015
285300200528     C                   EXSR      SRERR                                                      CSD015
285400200528     C                   ENDIF                                                                CSD015
285500200528                                                                                              CSD015
285600200528     C                   ENDIF                                                                CSD015
285700200528                                                                                              CSD015
285800200528      ** Check if CRE020 is enabled.                                                          CRE020
285900200528                                                                                              CRE020
286000200528     C                   CALLB     'AOSARDR0'                                                 CRE020
286100200528     C                   PARM      *BLANKS       PRtCd                                        CRE020
286200200528     C                   PARM      '*VERIFY'     POptn                                        CRE020
286300200528     C                   PARM      'CRE020'      PSARD                                        CRE020
286400200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
286500200528                                                                                              CRE020
286600200528     C                   EVAL      CRE020 = 'N'                                               CRE020
286700200528                                                                                              CRE020
286800200528     C                   IF        PRtCd = *BLANKS                                            CRE020
286900200528     C                   EVAL      CRE020 = 'Y'                                               CRE020
287000200528     C                   ELSE                                                                 CRE020
287100200528                                                                                              CRE020
287200200528     C                   IF        PRtCd <> '*NRF'                                            CRE020
287300200528     C     *LOCK         IN        LDA                                                        CRE020
287400200528     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
287500200528     C                   EVAL      DBase = 909                                                CRE020
287600200528     C                   EVAL      DBKey = 'CRE020'                                           CRE020
287700200528     C                   OUT       LDA                                                        CRE020
287800200528     C                   EXSR      SRErr                                                      CRE020
287900200528     C                   ENDIF                                                                CRE020
288000200528                                                                                              CRE020
288100200528     C                   ENDIF                                                                CRE020
288200200528                                                                                              CRE020
288300200528      ** Check if a System Value exists for this maintenance.                                 CRE020
288400200528                                                                                              CRE020
288500200528     C                   IF        CRE020 = 'Y'                                               CRE020
288600200528                                                                                              CRE020
288700200528     C                   CALLB     'AOSVALR0'                                                 CRE020
288800200528     C                   PARM      *BLANKS       PRtCd                                        CRE020
288900200528     C                   PARM                    PSysVal01                                    CRE020
289000200528     C                   PARM                    PCurSet01                                    CRE020
289100200528     C                   PARM                    PSysVal02                                    CRE020
289200200528     C                   PARM                    PCurSet02                                    CRE020
289300200528     C                   PARM                    PSysVal03                                    CRE020
289400200528     C                   PARM                    PCurSet03                                    CRE020
289500200528     C                   PARM                    PSysVal04                                    CRE020
289600200528     C                   PARM                    PCurSet04                                    CRE020
289700200528     C                   PARM                    PSysVal05                                    CRE020
289800200528     C                   PARM                    PCurSet05                                    CRE020
289900200528     C                   PARM                    PSysVal06                                    CRE020
290000200528     C                   PARM                    PCurSet06                                    CRE020
290100200528     C                   PARM                    PSysVal07                                    CRE020
290200200528     C                   PARM                    PCurSet07                                    CRE020
290300200528     C                   PARM                    PSysVal08                                    CRE020
290400200528     C                   PARM                    PCurSet08                                    CRE020
290500200528     C                   PARM                    PSysVal09                                    CRE020
290600200528     C                   PARM                    PCurSet09                                    CRE020
290700200528     C                   PARM                    PSysVal10                                    CRE020
290800200528     C                   PARM                    PCurSet10                                    CRE020
290900200528                                                                                              CRE020
291000200528     C                   EVAL      WSysVal01 = 'N'                                            CRE020
291100200528                                                                                              CRE020
291200200528     C                   IF        PRtCd = *BLANKS                                            CRE020
291300200528     C                   MOVEL     PCurSet01     WSysVal01                                    CRE020
291400200528     C                   ELSE                                                                 CRE020
291500200528                                                                                              CRE020
291600200528     C                   IF        PRtCd <> '*NRF'                                            CRE020
291700200528     C     *LOCK         IN        LDA                                                        CRE020
291800200528     C                   EVAL      DBFile = 'SDSVALPD'                                        CRE020
291900200528     C                   EVAL      DBase = 910                                                CRE020
292000200528     C                   EVAL      DBKey = PSysVal01                                          CRE020
292100200528     C                   OUT       LDA                                                        CRE020
292200200528     C                   EXSR      SRErr                                                      CRE020
292300200528     C                   ENDIF                                                                CRE020
292400200528                                                                                              CRE020
292500200528     C                   ENDIF                                                                CRE020
292600200528                                                                                              CRE020
292700200528     C                   ENDIF                                                                CRE020
292800200528      *                                                                                       CDL033
292900200528      ** Determine if Floating Rate CD Issued feature is                                      CDL033
293000200528      ** switched on.                                                                         CDL033
293100200528      *                                                                                       CDL033
293200200528     C                   MOVE      *BLANKS       CDL033                                       CDL033
293300200528     C                   CALL      'AOSARDR0'                                                 CDL033
293400200528     C                   PARM      *BLANKS       PRTCD                                        CDL033
293500200528     C                   PARM      '*VERIFY'     POPTN                                        CDL033
293600200528     C                   PARM      'CDL033'      PSARD                                        CDL033
293700200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
293800200528      *                                                                                       CDL033
293900200528     C     PRTCD         IFEQ      *BLANKS                                                    CDL033
294000200528     C                   MOVE      'Y'           CDL033                                       CDL033
294100200528     C                   ELSE                                                                 CDL033
294200200528     C     PRTCD         IFNE      '*NRF   '                                                  CDL033
294300200528     C     *LOCK         IN        LDA                                                        CDL033
294400200528     C                   MOVE      '911'         DBASE                                        CDL033
294500200528     C                   MOVEL     'CDL033  '    DBKEY                                        CDL033
294600200528     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL033
294700200528     C                   OUT       LDA                                                        CDL033
294800200528     C                   EXSR      *PSSR                                                      CDL033
294900200528     C                   ENDIF                                                                CDL033
295000200528     C                   ENDIF                                                                CDL033
295100200528                                                                                              CSD083
295200200528      ** Check if Watch List Element (CSD083) is on                                           CSD083
295300200528                                                                                              CSD083
295400200528     C                   CALL      'AOSARDR0'                                                 CSD083
295500200528     C                   PARM      *BLANKS       PRTCD                                        CSD083
295600200528     C                   PARM      '*VERIFY'     POPTN                                        CSD083
295700200528     C                   PARM      'CSD083'      PSARD                                        CSD083
295800200528     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
295900200528                                                                                              CSD083
296000200528     C                   IF        PRTCD <> *BLANKS AND                                       CSD083
296100200528     C                             PRTCD <> '*NRF   '                                         CSD083
296200200528     C     *LOCK         IN        LDA                                                        CSD083
296300200528     C                   EVAL      DBASE = 912                                                CSD083
296400200528     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
296500200528     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
296600200528     C                   OUT       LDA                                                        CSD083
296700200528     C                   EXSR      *PSSR                                                      CSD083
296800200528     C                   ENDIF                                                                CSD083
296900200528                                                                                              CSD083
297000200528     C                   IF        PRTCD = *BLANKS                                            CSD083
297100200528     C                   EVAL      CSD015 = 'N'                                               CSD083
297200200528     C                   ENDIF                                                                CSD083
297300200528     C*
297400200528     C**  READ DTAARA/RUNDAT to access MULTI-BRANCHING flag.
297500200528     C*
297600200528     C     *DTAARA       DEFINE                  RUNDAT
297700200528     C                   IN        RUNDAT
297800200528                                                                                              CAP084
297900200528      ** Check whether user is a web browser user, if so overwrite                            CAP084
298000200528     C                   CALL      'SFC000026'                                                CAP084
298100200528     C                   PARM      *BLANKS       USER             10                          CAP084
298200200528      *                                                                                       CAP084
298300200528     C                   IF        USER <> *BLANKS                                            CAP084
298400200528     C                   MOVEL     USER          PSUser                                       CAP084
298500200528     C                   ENDIF                                                                CAP084
298600200528      *
298700200528      * KEY LISTS
298800200528      *
298900200528     C     DEAMK         KLIST
299000200528     C                   KFLD                    IGDA38
299100200528     C                   KFLD                    IGVDYY
299200200528     C                   KFLD                    IGVDMM
299300200528     C                   KFLD                    IGVDDD
299400200528     C                   KFLD                    IGDS38
299500200528     C*
299600200528     C/COPY WNCPYSRC,MMDEAMMC03
299700200528     C                   ENDSR
299800200528      *****************************************************************
299900200528      /EJECT
300000200528     C*****************************************************
300100200528     C*                                                   *
300200200528     C* SRERR - EXCEPTION ERRORS                          *
300300200528     C*                                                   *
300400200528     C*****************************************************
300500200528     C     SRERR         BEGSR
300600200528     C*
300700200528     C                   MOVEL     '*ERROR '     @@RTCD
300800200528     C                   MOVEL     'MMDEAMUPM'   DBPGM            10
300900200528     C                   MOVE      '1'           *INU7
301000200528     C                   MOVE      '1'           *INU8
301100200528     C                   MOVE      '1'           *INLR
301200200528     C                   DUMP
301300200528     C*
301400200528     C**  TERMINATE THE PROGRAM
301500200528     C*
301600200528     C                   RETURN
301700200528     C*
301800200528     C                   ENDSR
301900200528     C*****************************************************
302000200528     C/COPY ZACPYSRC,PSSR_ILE                                                                 CDL033
302100200528      *****************************************************                                   CDL033
302200200528      /EJECT
302300200528      *********************************************************************
302400200528      ** FIELD LOG
302500200528      *********************************************************************
302600200528      **                                      SET IN     SET IN
302700200528      **                                    VALIDATION    THIS    AMENDABLE
302800200528      **                                     FUNCTION   FUNCTION
302900200528      *********************************************************************
303000200528      ** Record identifier            HNRCID              YES       YES
303100200528      ** Logical delete flag          HNDLTF              YES       YES
303200200528      ** Day of last update           HNDLUP              YES       YES
303300200528      ** Month of last update         HNMLUP              YES       YES
303400200528      ** Year of last update          HNYLUP              YES       YES
303500200528      ** Time of last update          HNTLUP              YES       YES
303600200528      ** Type of last change          HNCHTP              YES       YES
303700200528      ** Last change date             HNLCD               YES       YES
303800200528      ** Last update user id          HNLUID              YES       YES
303900200528      ** Deam associated deal number  HNDMAD--------------------------------
304000200528      ** Deam associated deal number  HNDA38   YES
304100200528      ** Deam sequence number pc      HNDMSQ--------------------------------
304200200528      ** Deam sequence number 38      HNDS38   YES
304300200528      ** Currency code                HNCCY    YES
304400200528      ** Currency decimal places      HNCYDP   YES
304500200528      ** Deal value date - yyyy       HNVDYY              YES
304600200528      ** Deal value date - mm         HNVDMM              YES
304700200528      ** Deal value date - dd         HNVDDD              YES
304800200528      ** Deal transaction date - yyyy HNDTYY              YES
304900200528      ** Deal transaction date - mm   HNDTMM              YES
305000200528      ** Deal transaction date - dd   HNDTDD              YES
305100200528      ** Deal deleted indicator       HNDDLT              YES
305200200528      ** Deal status indicator        HNDSTS              YES
305300200528      ** MIDAS deal type              HNMTYP   YES
305400200528      ** Deal type                    HNTYPE              YES
305500200528      ** Deam deal date - yyyy        HNDMDY              YES
305600200528      ** Deam deal date - mm          HNDMDM              YES
305700200528      ** Deam deal date -dd           HNDMDD              YES
305800200528      ** Amount                       HNAMNP   YES        YES
305900200528      ** Interest rate                HNINTR   YES
306000200528      ** Deal our receive method      HNDORM              YES       YES
306100200528      ** Deal midas our receve method HNORCM              YES       YES
306200200528      ** Deal our receive instructns  HNDORI              YES       YES
306300200528      ** Deal midas our receive instr HNMORI              YES       YES
306400200528      ** Deal customer payment instr  HNDCPI              YES       YES
306500200528      ** Deal midas cust payment inst HNMCPI              YES       YES
306600200528      ** Deal our payment method      HNDOPM              YES       YES
306700200528      ** Deal midas our payment meth. HNMOPM              YES       YES
306800200528      ** Deal our payment instructns  HNDOPI              YES       YES
306900200528      ** Deal midas our payment instr HNMOPI              YES       YES
307000200528      ** Deal customer receive instr  HNDCRI              YES       YES
307100200528      ** Deal Customer Receive Instru HNMCRI              YES       YES
307200200528      ** Deal for A/C of              HNDFAC              YES       YES
307300200528      ** Deal midas ''FOR A/C OF''    HNMFAO              YES       YES
307400200528      ** Deal special instructions    HNSPEC              YES       YES
307500200528      ** Deam original deal type      HNOGDT              YES
307600200528      ** Original deal sub type       HNOSTP              YES
307700200528      ** Deam original deal rbs ind   HNORBS--------------------------------
307800200528      ** Dm midas original deal type  HNOMDT              YES
307900200528      ** Customer number              HNCNUM   YES
308000200528      ** Customer short name          HNCSNM   YES
308100200528      ** Deal pc transation number    HNPCTN--------------------------------
308200200528      ** Confirm/delete reply         HNCDRP--------------------------------
308300200528      ** Deal last action             HNLACT              YES
308400200528      ** Time of input                HNTIME              YES
308500200528      ** Deal user code               HNDUSC              YES
308600200528      ** Deal authorisation officer   HNAOFR              YES
308700200528      ** Deal action date             HNLDAT              YES
308800200528      ** receipt - settlement method  HNRSTM   YES*                 YES
308900200528      ** receipt - our nostro         HNRONS   YES*                 YES
309000200528      ** receipt - intermediary bank  HNRIBN   YES*                 YES
309100200528      ** receipt - intermediary bank  HNRIBA   YES*                 YES
309200200528      ** receipt - ordering bank no   HNROBN   YES*                 YES
309300200528      ** receipt - ordering customer  HNROCN   YES*                 YES
309400200528      ** pay - settlement method      HNPSTM   YES*                 YES
309500200528      ** pay - our nostro             HNPONS   YES*                 YES
309600200528      ** pay - intermediary bank no   HNPIBN   YES*                 YES
309700200528      ** pay - intermediary bank a/c  HNPIBA   YES*                 YES
309800200528      ** pay - ordering bank no       HNPOBN   YES*                 YES
309900200528      ** pay - ordering customer no   HNPOCN   YES*                 YES
310000200528      ** receiver correspondent no    HNRCRN   YES*                 YES
310100200528      ** receiver correspondent a/c l HNRCRA   YES*                 YES
310200200528      ** Receiver number              HNRVNO   YES*                 YES
310300200528      ** a/c with bank no             HNAWBN   YES*                 YES
310400200528      ** a/c with bank a/c line       HNAWBA   YES*                 YES
310500200528      ** beneficiary no               HNBENN   YES*                 YES
310600200528      ** beneficiary a/c line         HNBENA   YES*                 YES
310700200528      ** DETAILS OF PAY 1             HNDTP1   YES*                 YES
310800200528      ** DETAILS OF PAY 2             HNDTP2   YES*                 YES
310900200528      ** DETAILS OF PAY 3             HNDTP3   YES*                 YES
311000200528      ** DETAILS OF PAY 4             HNDTP4   YES*                 YES
311100200528      ** details of charges           HNDCHG   YES*                 YES
311200200528      ** bank to bank info 1          HNBTB1   YES*                 YES
311300200528      ** bank to bank info 2          HNBTB2   YES*                 YES
311400200528      ** bank to bank info 3          HNBTB3   YES*                 YES
311500200528      ** bank to bank info 4          HNBTB4   YES*                 YES
311600200528      ** bank to bank 5               HNBTB5   YES*                 YES
311700200528      ** bank to bank 6               HNBTB6   YES*                 YES
311800200528      ** Our settlement branch        HNOSBR   YES*
311900200528      ** COVER MESSAGE REQUIRED       HNCVMR   YES*
312000200528      ** Branch Code - Alpha          HNBRCA              YES
312100200528      ** Funding Spread/Rate          HNFSRP   YES
312200200528      ** Interest Rate Change Flag    HNIRCF   YES
312300200528      ** Funding Rate Change Flag     HNFRCF   YES
312400200528      ** Settlement Currency          HNSTCY   YES*                 YES
312500200528      ** In Currency in Field 72      HNIC72   YES*                 YES
312600200528      ** Front Office Transaction Id  HNFRNT   YES                  YES         CAP013
312700200528      ** Assoc Front Office Trans Id  HNAFRT   YES                  YES         CAP013
312800200528      ** Deal Repair Location         HNREPA   YES
312900200528      ** Automatic Authorisation      HNAUTH   NO                               CAP051
313000200528      ****************************************************************
313100200528**  CPY@
313200200528(c) Finastra International Limited 2001
313300200528** CTDATA XOT - XML Opening Tags for the Compliance Engine.                                   CSD015
313400200528<Receipt Our Nostro>                                                                          CSD015
313500200528<Receipt Inter. Bank>                                                                         CSD015
313600200528<Receipt Ordering Bank>                                                                       CSD015
313700200528<Receipt Ord. Customer>                                                                       CSD015
313800200528<Payment Our Nostro>                                                                          CSD015
313900200528<Payment Inter. Bank>                                                                         CSD015
314000200528<Payment Ord. Bank>                                                                           CSD015
314100200528<Payment Ord. Customer>                                                                       CSD015
314200200528<Payment Rec. Corr.>                                                                          CSD015
314300200528<Payment Recipient>                                                                           CSD015
314400200528<Payment Acc. with Bank>                                                                      CSD015
314500200528<Payment Beneficiary>                                                                         CSD015
314600200528<Payment Details>                                                                             CSD015
314700200528** CTDATA XCT - XML Closing Tags for the Compliance Engine.                                   CSD015
314800200528</Receipt Our Nostro>                                                                         CSD015
314900200528</Receipt Inter. Bank>                                                                        CSD015
315000200528</Receipt Ordering Bank>                                                                      CSD015
315100200528</Receipt Ord. Customer>                                                                      CSD015
315200200528</Payment Our Nostro>                                                                         CSD015
315300200528</Payment Inter. Bank>                                                                        CSD015
315400200528</Payment Ord. Bank>                                                                          CSD015
315500200528</Payment Ord. Customer>                                                                      CSD015
315600200528</Payment Rec. Corr.>                                                                         CSD015
315700200528</Payment Recipient>                                                                          CSD015
315800200528</Payment Acc. with Bank>                                                                     CSD015
315900200528</Payment Beneficiary>                                                                        CSD015
316000200528</Payment Details>                                                                            CSD015
