     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Deal amendments database update')             *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMDEAMUPM - DEAL AMENDMENTS MM DATABASE UPDATE               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 30May14               *
      *                 AR1044820          Date 17Jul13               *
      *                 AR821086           Date 30Aug11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 259421             Date 16Apr09               *
      *                 258907             Date 26Feb08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242552             Date 21Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG7461            Date 14Jun06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027A            Date 16May05               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG8014            Date 15Aug05               *
      *                 CDL033             Date 10Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 208884             Date 29Aug02               *
      *                 BUG6156            Date 15Mar05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3499            Date 30Jun04               *
      *                 BUG3045            Date 01Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 NAD002             Date 26Mar04               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222059             Date 10Oct03               *
      *                 CAP084             Date 25Jun03               *
      *                 CDE005             Date 19Aug02               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CSD015             Date 14Oct02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001             Date 13Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 12Nov99               *
      *                 CDL007             Date 12Oct99               *
      *                 CPB001             Date 01Jun99               *
      *                 CAP013             Date 07Sep99               *
      *                 168345             Date 13Oct99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             DATE 08Mar99               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data.    *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *  AR1044820 - Incorrect projected movements for Adjustment to  *
      *              Accrued Interest. Added parameters BeDealsDtlC,  *
      *              AfDealsDtlC, and CALLER for AOOUMMU0.            *
      *              (Child: AR1044821)                               *
      *  AR821086 - No stamp tax shadow posting generated for LDNI    *
      *             and DEAM                                          *
      *  CER049 - Stamp Tax                                           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  259421 - Check if java user before writing on DEAMSIQD.      *
      *  258907 - Amended program to populate DEAMSIQD when a deal    *
      *           amendment is inserted through an API and prevent    *
      *           errors from the deal amendment screen.              *
      *  242552 - MM Deal Amend loses Front Office Id when authorised *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG7461 - Authorising Officer shown as QUS                   *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027A- Conversion Of Cust. no. to alpha (post build 103)   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG8014 - Validate Date Format Indicator correctly.          *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  208884 - Delete of unauthorised deal received from interface *
      *           must send a "refused" message to the sender.        *
      *  BUG6156- DEAM - on amend, record not updated.                *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3499- Decimal Data Error (Recompile)                      *
      *  BUG3045- Settlement details are not being updated for        *
      *           new amendment type 'EM'.                            *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *  NAD002 - 10-Digit Account Code Errors                        *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  222059 - Timestamp error on insert/update of deal amendment  *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.                                     *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CSC011 - 24x7 Midas Availability                             *
      *  200400 - Reverse fix 179510 and replace it with a new fix.   *
      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
      *           Midas  Our  Receive/ Pay  Instructions  respectively*
      *           not  correctly  updated .  Introduced  new parametrs*
      *           when  calling   ZAALTRECIN/ PAYIN  modules .        *
      *  CDE001 - Data Export - CCRM Limits                           *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *           Recompiled due to changes in MMDELDPP               *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDELDPP               *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  168345 - Prevent two users from accessing same transaction   *
      *           in repair screen at the same cycle, and converting  *
      *           it into two different Midas Deal No.s  .            *
      *           Second user should not be allowed to repair the     *
      *           transaction and convert it into a another           *
      *           Midas Deal.                                         *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP006 - Check for deal being updated by another workstation *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
     FMMDAMULL  UF A E           K DISK
     F                                     COMMIT
     FMMDEALLL  IF   E           K DISK    INFDS(FDS)
     F                                     INCLUDE(MMDELDP0: MMDENBP0)
      *                                                                                       258907
     FDEAMSIQD  UF A E           K DISK    INFSR(SRERR)                                       258907
     F                                     PREFIX(DHC_)
                                                                                              CSD015
      ** Compliance Watch Hit List                                                            CSD015
     FSDCWHTL1  IF   E           K DISK    INFSR(SRERR)                                       CSD015

     FREADVCL2  UF   E           K DISK    INFSR(SRERR)                                       CRE020
     F                                     USROPN                                             CRE020
      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref/Seq No                     CRE020
                                                                                              CSD015
     F/COPY WNCPYSRC,MMH00170
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      **------------------------------------------------------------------------CAP006 -------------
      ** The following /COPY line includes the definitions for error and        CAP006
      ** warning message arrays.                                                CAP006
     D/COPY ZACPYSRC,ERR_ARRAYS                                                 CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************

      ** DEFINE FIELDS FOR ZDATE9
     D @DAYN           S              5P 0
     D @YMD            S              8S 0
     D @RETN           S              1A

      ** Timestamp for the transaction                                          CAP006
     D TimeStamp       S               Z                                        CAP006
                                                                                CAP006
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR DEAL AMENDMENT
     D MMVDEM        E DS                  EXTNAME(MMVDEAMPD)
     D  @IGCTL                 1     23
     D  @IGVDY                49     56  0
     D  @IGTDY                57     64  0
     D  @IGDDY                71     78  0
     D  @IGALR                93    143
     D  @IGALP               144    249
     D  @IGREC               300    368
     D  @IGPY1               369    574
     D  @IGPY2               575    717
     D  @IGPY3               718    927

      **  DEAMS FILE - DEAL AMENDMENTS
     D MMDEAM        E DS                  EXTNAME(MMDEAMPP)
     D MMDEAMDORI    E                     EXTFLD(QQDORI)                                     CGL029
     D MMDEAMMORI    E                     EXTFLD(QQMORI)                                     CGL029
     D MMDEAMDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
     D MMDEAMMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
     D MMDEAMRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D MMDEAMPONS    E                     EXTFLD(QQPONS)                                     CGL029
     D  @HNCTL                 1     23
     D  @HNALR                93    143
     D  @HNALP               144    249
     D  @HNREC               300    368
     D  @HNPY1               369    574
     D  @HNPY2               575    717
     D  @HNPY3               718    927

      **  DEALS FILE - LOANS/DEPOSITS & NAS ISSUED
     D MMDELD        E DS                  EXTNAME(MMDELDPP)
     D MMDELDDORI    E                     EXTFLD(QQDORI)                                     CGL029
     D MMDELDMORI    E                     EXTFLD(QQMORI)                                     CGL029
     D MMDELDDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
     D MMDELDMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
     D MMDELDRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D MMDELDPONS    E                     EXTFLD(QQPONS)                                     CGL029
     D  @HKVDY                50     57  0

     D/COPY WNCPYSRC,MMH00171
      **  DEALS FILE - NEGOTIABLE ASSETS BOUGHT
     D MMDENB        E DS                  EXTNAME(MMDENBPP)
     D  @HLVDY                50     57  0

     D ChkDealFmt    E DS                  EXTNAME(MMDEAMPP)                    CAP006
      ** Rename fields for Timestamp checking                                   CAP006
     D                                     PREFIX(CH)                           CAP006
                                                                                CAP006
     D MMEDEM        E DS                  EXTNAME(MMEDEAMPD)                   CAP006
      * Error indicators                                                        CAP006
                                                                                CAP006
      **  EXTERNALLY DESCRIBED DATA STRUCTURES FOR TEMPLATE FILES FOR
      **  PROJECTED ACCOUNT MOVEMENTS UPDATES
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)
     D DLDLQD        E DS                  EXTNAME(DLSTMPPD)                                  CER049

      ** FILE STATUS DATA STRUCTURE - RECORD FORMAT
     D FDS             DS
     D  ##FORM           *RECORD

      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS

     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      * DATA STRUCTURE FOR DEAL DATA CODES

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * DATA STRUCTURE FOR MODULE DETAILS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP051
      * DATA STRUCTURE FOR SWITCHABLE FEATURE DETAILS                           CAP051
                                                                                CAP051
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status dataarea                                                                 CSC011
                                                                                              CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
      ** Midas API Message Header Format Definition                                           CSC011
                                                                                              CSD015
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
      ** Compliance Watch Configuration Data DS                                               CSD015
                                                                                              CSD015
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
      ** External DS for Customer Details                                                     CSD015
                                                                                              CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
      ** External DS for Watch List Checking Details                                          CSD015
                                                                                              CSD015
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                  CSD015
      ** Watch List Transaction Details Data Structure                                        CSD015
                                                                                              CSD015
     D WLFBC         E DS                  EXTNAME(MMDEAMPP)                                  CSD015
     D                                     PREFIX(BC:2)                                       CSD015
     D MMDEAMDORI2   E                     EXTFLD(QQDORI)                                     CGL029
     D MMDEAMMORI2   E                     EXTFLD(QQMORI)                                     CGL029
     D MMDEAMDOPI2   E                     EXTFLD(QQDOPI)                                     CGL029
     D MMDEAMMOPI2   E                     EXTFLD(QQMOPI)                                     CGL029
     D MMDEAMRONS2   E                     EXTFLD(QQRONS)                                     CGL029
     D MMDEAMPONS2   E                     EXTFLD(QQPONS)                                     CGL029
      ** Backup Container of the Watch List Fields                                            CSD015
                                                                                              CSD015
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSD015
      * Long DS for Access Programs                                                           CSD015

     D InvRp         E DS                  EXTNAME(MMIDEAMPD)                                 208884
     D                                     PREFIX(R:2)                                        208884
                                                                                              208884
     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                AR821086
      ** File - Payment Further Settlement Instructions                                     AR821086
                                                                                            AR821086
     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                AR821086
      ** File - Receive Further Settlement Instructions                                     AR821086
      * RUN DATE & MULTI-BRANCHING INDICATOR

     D RUNDAT          DS
     D  @DLUP                  1      2  0
     D  @MLUP                  3      5
     D  @YLUP                  6      7  0
     D  @MBIN                 13     13
                                                                                CAP006
      **  Data Structure to split value date used in key to deams file          CAP006
     D                 DS                                                       CAP006
     D  @KVALD                 1      8  0 INZ(0)                               CAP006
     D  @VDYY                  1      4  0                                      CAP006
     D  @VYEAR                 3      4  0                                      CAP006
     D  @VDMM                  5      6  0                                      CAP006
     D  @VDDD                  7      8  0                                      CAP006
                                                                                CAP006
     D                 DS                                                       CAP006
      **  Data Structure for screen value date                                  CAP006
     D  ValueDate              1      6                                         CAP006
     D  @DSPD                  1      2                                         CAP006
     D  @DSPM                  3      4                                         CAP006
     D  @DSPY                  5      6                                         CAP006
                                                                                             BUG7461
     D ZMUSER        E DS                  EXTNAME(ZMUSER)                                   BUG7461
                                                                                CAP006
      ** Dummy message ID and message file fields for use on the calls to       CAP006
      ** ZAMSGTOOPR                                                             CAP006
     D DummyMsgID      S                   LIKE(#MsgID)                         CAP006
     D DummyMsgF       S             10A                                        CAP006
                                                                                CAP006
     D CSC011          S              1A   INZ('N')                                           CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PTimestamp      S             26A                                                      CSC011
     D*PDealNo         S             18A                                               CSC011 CGL029
     D*PADealNo        S             18A                                               CSC011 CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D WYear           S              4A                                                      CSC011
     D WMonth          S              2A                                                      CSC011
     D WDay            S              2A                                                      CSC011
     D WDeal           S              6A                                                      CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                              CSC011
      ** Max. no. of elements associated with the CE arrays.                                  CSD015
     D ArrMax          C                   CONST(13)                                          CSD015
                                                                                              CSD015
      ** XML Opening Tags for the Compliance Engine.                                          CSD015
     D XOT             S             25A   DIM(ArrMax) PERRCD(1) CTDATA                       CSD015
                                                                                              CSD015
      ** XML Closing Tags for the Compliance Engine.                                          CSD015
     D XCT             S             25A   DIM(ArrMax) PERRCD(1) CTDATA                       CSD015
                                                                                              CSD015
      ** Formatted Watch List Fields Array.                                                   CSD015
     D WLF             S             35A   DIM(ArrMax)                                        CSD015
                                                                                              CSD015
      ** Watch List Fields Account line Array.                                                CSD015
     D WLFSD           S             35A   DIM(ArrMax)                                        CSD015
                                                                                              CSD015
      ** Parameter on access to Customer Details                                              CSD015
     D PCustNo         S             10A                                                      CSD015
     D PErrInf         S              7A                                                      CSD015
                                                                                              CSD015
      ** Compliance Watch Indicator                                                           CSD015
     D CSD015          S              1A   INZ('N')                                           CSD015
                                                                                              CSD015
      ** Concord Interface Development Indicator                                              CSD015
     D CCF001          S              1A   INZ('N')                                           CSD015
                                                                                              CSD015
      ** AOWLCCR0 Function Code Parameter                                                     CSD015
     D PFuncCode       S              8                                                       CSD015
                                                                                              CSD015
      ** Compliance Engine Free Format String Parameter                                       CSD015
     D PFreeFmtStr     S          30000A                                                      CSD015
                                                                                              CSD015
      ** SDCWLFMT Parameters                                                                  CSD015
     D PInpA           S             35                                                       CSD015
     D PInpB           S             35                                                       CSD015
     D PInpC           S             35                                                       CSD015
     D PInpD           S             35                                                       CSD015
     D PInpE           S             35                                                       CSD015
                                                                                              CSD015
      ** ZACVTAMT Parameters                                                                  CSD015
     D PZARtCd         S             10                                                       CSD015
     D PZACcy          S              3                                                       CSD015
     D PZANtvAmt       S             15                                                       CSD015
     D PZAAmt          S             18  3                                                    CSD015
     D PZACvtAmt       S             16                                                       CSD015
                                                                                              CSD015
      ** Working Date Data Structure                                                          CSD015
     D WDATE           DS                                                                     CSD015
     D  WLongYr                1      4  0                                                    CSD015
     D  WShortYr               3      4  0                                                    CSD015
     D  WMnth                  5      6  0                                                    CSD015
     D  WDays                  7      8  0                                                    CSD015
                                                                                              CSD015
      ** Work Variables                                                                       CSD015
     D Ctr             S              2  0                                                    CSD015
     D WData           S            216                                                       CSD015
     D WData2          S              6                                                       CSD015
     D WXMLPacket      S            400                                                       CSD015
     D WMoveMode       S              1                                                       CSD015
     D WCompMode       S              1                                                       CSD015
     D WChgFlg         S              1                                                       CSD015
     D WOKFlg          S              1                                                       CSD015
     D WRetryFlg       S              1                                                       CSD015
     D WCtrpRpt        S             30                                                       CSD015
     D WCtrpTyp        S              1                                                       CSD015
     D WDDT            S             10A                                                      CSD015
     D WAMT            S             18  3                                                    CSD015
     D WCcy            S              3                                                       CSD015
     D WHNDA3          S              6A                                                      CSD015
     D WHNVDY          S              4A                                                      CSD015
     D WHNVDM          S              2A                                                      CSD015
     D WHNVDD          S              2A                                                      CSD015
     D WHNDS3          S              3A                                                      CSD015
                                                                                              CSD015
      ** Compliance Watch Hit List Key Fields                                                 CSD015
     D KFuncType       S              8A                                                      CSD015
     D KIden           S             40A                                                      CSD015
     D KBranch         S              3A                                                      CSD015
                                                                                              CSD015
      ** WMoveMode Constants                                                                  CSD015
     D ALL             C                   CONST('A')                                         CSD015
     D CHANGED         C                   CONST('C')                                         CSD015
                                                                                              CSD015
      ** WCompMode Constants                                                                  CSD015
     D OnInsert        C                   CONST('I')                                         CSD015
     D OnAmend         C                   CONST('A')                                         CSD015
                                                                                              CSD015
      ** Define fields used in CDL010                                                         CDL010
     D CDL010          S              1A                                                      CDL010
                                                                                              CDL010
      ** CRE020 Variables                                                                     CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KSeqNo          S              3A                                                      CRE020
     D KPrgMn          S             10A   INZ('MMDEAMUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('DealAmendments      ')                        CRE020
     D PCurSet01       S            200A                                                      CRE020
     D PSysVal02       S             20A                                                      CRE020
     D PCurSet02       S            200A                                                      CRE020
     D PSysVal03       S             20A                                                      CRE020
     D PCurSet03       S            200A                                                      CRE020
     D PSysVal04       S             20A                                                      CRE020
     D PCurSet04       S            200A                                                      CRE020
     D PSysVal05       S             20A                                                      CRE020
     D PCurSet05       S            200A                                                      CRE020
     D PSysVal06       S             20A                                                      CRE020
     D PCurSet06       S            200A                                                      CRE020
     D PSysVal07       S             20A                                                      CRE020
     D PCurSet07       S            200A                                                      CRE020
     D PSysVal08       S             20A                                                      CRE020
     D PCurSet08       S            200A                                                      CRE020
     D PSysVal09       S             20A                                                      CRE020
     D PCurSet09       S            200A                                                      CRE020
     D PSysVal10       S             20A                                                      CRE020
     D PCurSet10       S            200A                                                      CRE020
     D WSysVal01       S              1A                                                      CRE020
                                                                                              CRE020
     D PAFRCD          S            100A                                                      CDL033
     D PBFRCD          S            100A                                                      CDL033
     D CDL033          S              1A   INZ('N')                                           CDL033
      ** Switchable Feature CDL033                                                            CDL033
      **                                                                                      CDL033
      *                                                                                    AR1044820
      ** DS for DEALSDC - Before being updated by a program.                               AR1044820
      *                                                                                    AR1044820
     D BeDealsDtlC   E DS                  EXTNAME(DEALSDC)                                AR1044820
     D                                     PREFIX(BE_)                                     AR1044820
      *                                                                                    AR1044820
      ** DS for DEALSDC - After being updated by a program.                                AR1044820
      *                                                                                    AR1044820
     D AfDealsDtlC   E DS                  EXTNAME(DEALSDC)                                AR1044820
     D                                     PREFIX(AF_)                                     AR1044820
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7461
     C                   IN        ZMUSER                                                    BUG7461
     C                   UNLOCK    ZMUSER                                                    BUG7461
      *
      ** INITIALIZE WORK FIELDS
      *
     C                   MOVEL     *BLANK        Z#BSTS
     C                   MOVEL     *BLANK        Z#ASTS
     C                   MOVEL     *BLANK        Z#WSTS
      *                                                                         CAP051
      ***  Transaction coming from Interface require an Automatic Authorisation CAP051
      *                                                                         CAP051
     C     CAP051        IFEQ      'Y'                                          CAP051
     C     IGAUTH        ANDEQ     'Y'                                          CAP051
     C                   MOVE      'N'           BNMMAU                         CAP051
     C                   MOVE      'N'           BNMMRA                         CAP051
     C                   ELSE                                                   CAP051
     C                   MOVE      SAVMAU        BNMMAU                         CAP051
     C                   MOVE      SAVMRA        BNMMRA                         CAP051
     C                   ENDIF                                                  CAP051
      *
      * SET CONTROL FIELDS
      *
     C                   EXSR      SETCTL
      *
      * CVTVDT - CONVERT DEAL AMENDMENT VALUE DATE TO YYYYMMDD FORMAT
      *
     C                   EXSR      CVTVDT
      *
      ** Ensure transaction has not been updated by another workstation         CAP006
      *INSERT so, bypass updating and return to calling program.                CAP006
     C                   EXSR      CHKOTHUPD                                    CAP006
                                                                                CAP006
     C     @@RTCD        IFNE      *BLANKS                                      CAP006
     C                   GOTO      EXIT                                         CAP006
     C                   END                                                    CAP006
                                                                                CAP006
      * DO INSERT, AMEND, AUTHORIZE OR DELETE PROCESSING
      *
     C     IGLACT        CASEQ     'I'           INSERT
     C     IGLACT        CASEQ     'A'           AMEND
     C     IGLACT        CASEQ     'X'           AUTHOR
     C     IGLACT        CASEQ     'D'           DELETE
     C                   END
      *
      ** DO ON-LINE UPDATES
      *
     C     IGLACT        IFEQ      'I'
     C     IGLACT        OREQ      'A'
     C     IGLACT        OREQ      'D'
     C                   EXSR      ONLNUP
     C                   END
      *
      *
      ** DO TREASURY MANAGEMENT UPDATES
      *
     C     BGTRMG        IFEQ      'Y'
     C     IGLACT        IFEQ      'I'
     C     IGLACT        OREQ      'A'
     C     IGLACT        OREQ      'D'
     C                   EXSR      TREAUP
     C                   END
     C                   END
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed, write to the standard                       CSC011
      ** log file when support system is active                                               CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
                                                                                              CSC011
      ** Setup Loans/Deposits support log                                                     CSC011
                                                                                              CSC011
     C                   CALLB     'MMDEAMLOG'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    IGLACT                                       CSC011
     C                   PARM                    MMVDEM                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** Write to support database log file                                                   CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *BLANKS                                       CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'MMDEAM'                                       CSC011
     C                   EVAL      APUSERID = PSUser                                          CSC011
     C                   EVAL      APRPRLOCN = IGREPA                                         CSC011
     C                   MOVEL     IGFRNT        APFOTRANID                                   CSC011
     C                   MOVEL     IGVDYY        WYear                                        CSC011
     C                   MOVEL     IGVDMM        WMonth                                       CSC011
     C                   MOVEL     IGVDDD        WDay                                         CSC011
     C                   MOVEL     IGDA38        WDeal                                        CSC011
     C                   EVAL      PDealNo = WDeal + WYear + WMonth                           CSC011
     C                                       + WDay + SequenceNo                              CSC011
                                                                                              CSC011
     C                   IF        IGAFRT = *BLANKS                                           CSC011
     C     ##FORM        IFEQ      'MMDELDP0'                                                 CSC011
     C                   MOVEL     HKFRNT        APFOASOCID                                   CSC011
     C                   ELSE                                                                 CSC011
     C                   MOVEL     HLFRNT        APFOASOCID                                   CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   MOVEL     IGAFRT        APFOASOCID                                   CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       PTimestamp                                   CSC011
     C                   PARM                    PDealNo                                      CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If error occured,                                                                    CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *BLANKS                                      CSC011
                                                                                              CSC011
     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *
      * EXIT FROM PROGRAM
     C     EXIT          TAG                                                    CAP006
      *
     C                   RETURN
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* INSERT - Deal Amendment Inserts                               *
     C*                                                               *
     C*****************************************************************
     C     INSERT        BEGSR
     C*
     C** ACCESS RELATED DEAL INFORMATION
     C*
     C                   EXSR      ACRDEL
     C*
     C**  SET DEAL FIELDS ON INSERT
     C*
     C                   EXSR      SETINS
     C*
     C**  ACCESS DEAL AMENDMENT
     C*
     C                   CLEAR                   MMDEAM
     C     DEAMK         CHAIN     MMDEAMP0                           99
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     MMDEAM        Z#BSTS
     C                   MOVEL     MMDEAM        WLFBC                                        CSD015
     C*
     C**  UPDATE DEAL AMENDMENT
     C*
     C                   MOVEL     MMVDEM        MMDEAM
                                                                                CDL006
      ** Fiduciary charge details                                               CDL006
      ** - Fiduciary charge code                                                CDL006
                                                                                CDL006
     C                   Eval      FCGC = IGFCGC                                CDL006
                                                                                CDL006
      ** - Fiduciary charge code description                                    CDL006
                                                                                CDL006
     C                   Eval      FCGD = IGFCGD                                CDL006
                                                                                CDL006
      ** - Fiduciary charge amount                                              CDL006
                                                                                CDL006
     C                   Eval      FXGA = IGFXGA                                CDL006
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      HNTMST  = TimeStamp                          CAP006
                                                                                CAP006
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   IF        HNFRNT = *BLANKS                                           CSC011
     C                   MOVEL     HNVDYY        WYear                                        CSC011
     C                   MOVEL     HNVDMM        WMonth                                       CSC011
     C                   MOVEL     HNVDDD        WDay                                         CSC011
     C                   MOVEL     HNDA38        WDeal                                        CSC011
     C                   EVAL      HNFRNT = 'MD' + WDeal + WYear +                            CSC011
     C                                      WMonth + WDay + SequenceNo                        CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
     C                                                                                        CSC011
     C*  WRITE (OR UPDATE IF PRESENT) NEW DEAL AMENDMENT
      *                                                                                       CDL010
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EXSR      USRUPD                                                     CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C     *IN99         IFEQ      '0'
      *                                                                                       CSD015
      ** Check for compliance if necessary.                                                   CSD015
      *                                                                                       CSD015
     C                   IF        CSD015 = 'Y' AND                                           CSD015
     C                             W1EWLC = 'Y'                                               CSD015
                                                                                              CSD015
     C                   IF        CSC011 <> 'Y' OR                                           CSD015
     C                             (CSC011 = 'Y' AND                                          CSD015
     C                             S1MAIN = LIBR)                                             CSD015
     C                   EVAL      WCompMode = OnAmend                                        CSD015
      *                                                                                       CSD015
      ** Handles fields checking during insert action                                         CSD015
      *                                                                                       CSD015
     C                   EXSR      SRCompChk                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   UPDATE    MMDEAMP0
     C                   ELSE
      *                                                                                       CSD015
      ** Before writing to file MMDEAMPP, check if Compliance                                 CSD015
      ** Watch is installed, W1EWLC = 'Y' and any of the                                      CSD015
      ** watch list fields has been entered                                                   CSD015
      *                                                                                       CSD015
     C                   IF        CSD015 = 'Y' AND                                           CSD015
     C                             W1EWLC = 'Y'                                               CSD015
                                                                                              CSD015
     C                   IF        CSC011 <> 'Y' OR                                           CSD015
     C                             (CSC011 = 'Y' AND                                          CSD015
     C                             S1MAIN = LIBR)                                             CSD015
     C                   EVAL      WCompMode = OnInsert                                       CSD015
      *                                                                                       CSD015
      ** Handles fields checking during insert action                                         CSD015
      *                                                                                       CSD015
     C                   EXSR      SRCompChk                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   WRITE     MMDEAMP0
     C                   END
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     MMDEAM        Z#ASTS
      *                                                                                       258907
     C     IGLACT        IFEQ      'I'                                                        258907
     C     PSJobName     ANDNE     'QZDASOINIT'                                               259421
      *                                                                                       258907
     C                   MOVEL     IGBRCA        DHC_DIBRCA                                   258907
     C                   Z-ADD     IGDA38        DHC_DIDLNO                                   258907
     C                   Z-ADD     IGDVSD        DHC_DIVDAT                                   258907
     C                   Z-ADD     IGDS38        DHC_DIDASN                                   258907
     C                   MOVEL     IGFRNT        DHC_DIFRID                                   258907
      *                                                                                       258907
      * Write to DEAMSIQD                                                                     258907
     C                   WRITE     DEAMSQD0                             81                    258907
      *                                                                                       258907
      * If an error occurs on the file, then end                                              258907
      *                                                                                       258907
     C     *IN81         IFEQ      '1'                                                        258907
     C                   MOVEL     IGDA38        DBKEY                                        258907
     C                   MOVEL     'DEAMSIQD'    DBFILE                                       258907
     C                   MOVEL     '007'         DBASE                                        258907
     C                   EXSR      SRERR                                                      258907
      *                                                                                       258907
     C                   END                                                                  258907
      *                                                                                       258907
     C                   ENDIF                                                                258907
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* AMEND - Deal Amendment Amends                                 *
     C*                                                               *
     C*****************************************************************
     C     AMEND         BEGSR
     C*
     C** ACCESS RELATED DEAL INFORMATION
     C*
     C                   EXSR      ACRDEL
     C*
     C**  ACCESS DEAL AMENDMENT
     C*
     C     DEAMK         CHAIN     MMDEAMP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     IGDA38        DBKEY
     C                   MOVEL     'MMDEAMP0'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     MMDEAM        Z#BSTS
     C                   MOVEL     MMDEAM        WLFBC                                        CSD015
     C*
     C**  SET DEAL FIELDS ON AMEND
     C*
     C                   EXSR      SETAMD
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      HNTMST  = TimeStamp                          CAP006
      *                                                                                       CDL010
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EXSR      USRUPD                                                     CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
      *                                                                                       CSD015
      ** Check for compliance if necessary.                                                   CSD015
      *                                                                                       CSD015
     C                   IF        CSD015 = 'Y' AND                                           CSD015
     C                             W1EWLC = 'Y'                                               CSD015
                                                                                              CSD015
     C                   IF        CSC011 <> 'Y' OR                                           CSD015
     C                             (CSC011 = 'Y' AND                                          CSD015
     C                             S1MAIN = LIBR)                                             CSD015
     C                   EVAL      WCompMode = OnAmend                                        CSD015
      *                                                                                       CSD015
      ** Handles fields checking during amend action                                          CSD015
      *                                                                                       CSD015
     C                   EXSR      SRCompChk                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C**  UPDATE DEAL AMENDMENT
     C*
     C                   UPDATE    MMDEAMP0
     C*
     C**  UPDATE VALID DEAL
     C*
     C                   MOVEL     MMDEAM        MMVDEM
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     MMDEAM        Z#ASTS
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* AUTHOR - Deal Amendment Authorize                             *
     C*                                                               *
     C*****************************************************************
     C     AUTHOR        BEGSR
     C*
     C** ACCESS RELATED DEAL INFORMATION
     C*
     C                   EXSR      ACRDEL
     C*
     C**  ACCESS DEAL AMENDMENT
     C*
     C     DEAMK         CHAIN     MMDEAMP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     IGDA38        DBKEY
     C                   MOVEL     'MMDEAMP0'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     MMDEAM        Z#BSTS
     C*
     C**  SET DEAL FIELDS ON AUTHORIZE
     C*
     C                   EXSR      SETAUT
     C*
     C/COPY WNCPYSRC,MMH00137
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      HNTMST  = TimeStamp                          CAP006
     C/COPY WNCPYSRC,MMDEAMMC01
      *                                                                                       CDL010
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EVAL      IGUSER = USRID                                            BUG7461
     C                   EXSR      USRUPD                                                     CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C**  UPDATE DEAL AMENDMENT
     C*
     C                   UPDATE    MMDEAMP0
     C/COPY WNCPYSRC,MMH00172
     C*
     C**  UPDATE VALID DEAL
     C*
     C                   MOVEL     MMDEAM        MMVDEM
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     MMDEAM        Z#ASTS
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* DELETE - Deal Amendment Deletes                               *
     C*                                                               *
     C*****************************************************************
     C     DELETE        BEGSR
     C*
     C** ACCESS RELATED DEAL INFORMATION
     C*
     C                   EXSR      ACRDEL
     C*
     C**  ACCESS DEAL AMENDMENT
     C*
     C     DEAMK         CHAIN     MMDEAMP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     IGDA38        DBKEY
     C                   MOVEL     'MMDEAMP0'    DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 003*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     MMDEAM        Z#BSTS
     C*
     C**  SET DEAL FIELDS ON DELETE
     C*
     C                   EXSR      SETDEL
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      HNTMST  = TimeStamp                          CAP006
                                                                                CAP006
      ** Send a User Defined Journal Entry to simulate a delete from repair                   208884
     C     HNDSTS        IFNE      'A'                                                        208884
     C     HNDSTS        ANDNE     'R'                                                        208884
     C     HNFRNT        ANDNE     *BLANKS                                                    208884
     C                   MOVE      'D'           RACTN                                        208884
     C                   MOVE      HNFRNT        RFOTRANID                                    208884
     C                   MOVE      HNDA38        RDLNO                                        208884
     C                   MOVEL     *BLANKS       EntryData                                    208884
     C                   MOVEL     *BLANKS       FileName                                     208884
     C                   CALL      'RPC1600'                                                  208884
     C                   PARM      InvRp         EntryData      3000                          208884
     C                   PARM      'MMIDEAMPD'   FileName         10                          208884
     C                   ENDIF                                                                208884
     C*                                                                                       208884
     C**  UPDATE DEAL AMENDMENT
     C*
     C                   UPDATE    MMDEAMP0
     C*
     C**  UPDATE VALID DEAL
     C*
     C                   MOVEL     MMDEAM        MMVDEM
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     MMDEAM        Z#ASTS
      *
     C                   ENDSR
     C****************************************************************                        CDL010
      /EJECT                                                                                  CDL010
     C****************************************************************                        CDL010
     C*                                                              *                        CDL010
     C* USRUPD    - Update the Last Amend/Insert User field .        *                        CDL010
     C*                                                              *                        CDL010
     C****************************************************************                        CDL010
     C     USRUPD        BEGSR                                                                CDL010
      *                                                                                       CDL010
      **  Update User Details                                                                 CDL010
      *                                                                                       CDL010
     C     IGUSER        IFEQ      *BLANKS                                                    CDL010
     C                   EVAL      HNUSER = PSuser                                            CDL010
     C                   ELSE                                                                 CDL010
     C                   EVAL      HNUSER = IGUSER                                            CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C                   ENDSR                                                                CDL010
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETINS - SET DEAL FIELDS ON INSERT                            *
     C*                                                               *
     C*****************************************************************
     C     SETINS        BEGSR
      **
      ** Deal value date - yyyy/mm/dd determined in CVTVDT
      **
      ** Deal transaction date - yyyy IGDTYY
      ** Deal transaction date - mm   IGDTMM
      ** Deal transaction date - dd   IGDTDD
      **  CONVERT RUN DATE FROM DAY NUMBER TO YMD
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IGTDY
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'I'           @@ACTN            1
     C                   PARM      *BLANK        @@CSTS            1
     C                   PARM                    BNMMAU
     C                   PARM                    BNMMRA
     C                   PARM      *BLANK        @@FSTS            1
     C                   PARM      *BLANK        @@CHTP            1
     C                   MOVEL     @@FSTS        IGDSTS
     C                   MOVEL     @@CHTP        IGCHTP
      **
      ** Deal type
      **
     C                   MOVEL     IGMTYP        IGTYPE
     C     IGTYPE        IFEQ      'SC'
     C                   MOVEL     'RC'          IGTYPE
     C                   END
      **
      ** Deam deal date - yyyy        IGDDYY
      ** Deam deal date - mm          IGDDMM
      ** Deam deal date - dd          IGDDDD
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IGDDY
      **
      ** CALCULATE SETTLE INTEREST
      **
     C     IGMTYP        IFEQ      'SI'
     C                   EXSR      CLSINT
     C                   Z-ADD     ##SINT        IGAMNP
     C                   END
      **
      ** IF PRINCIPAL DECREASE OF DEPOSIT TAKEN
      ** OR PRINCIPAL INCREASE OF DEPOSIT PLACED
      ** OR SETTLE INTEREST OF DEPOSIT TAKEN
      **
     C     IGTYPE        IFEQ      'PD'
     C     W#LOD         ANDEQ     'D'
     C     IGTYPE        OREQ      'PI'
     C     W#LOD         ANDEQ     'L'
     C     IGTYPE        OREQ      'SI'
     C     W#LOD         ANDEQ     'D'
     C     IGTYPE        OREQ      'EM'                                                      BUG3045
     C     IGPENP        ANDEQ     'P'                                                       BUG3045
      *
      * DETERMINE ALTERNATIVE PAY INSTRUCTIONS
      *
     C                   EXSR      ALPAYI
      **
      ** IF PRINCIPAL DECREASE OF DEPOSIT PLACED
      ** OR PRINCIPAL INCREASE OF DEPOSIT TAKEN
      ** OR SETTLE INTEREST OF DEPOSIT PLACED
      **
     C                   ELSE
     C     IGTYPE        IFEQ      'PD'
     C     W#LOD         ANDEQ     'L'
     C     IGTYPE        OREQ      'PI'
     C     W#LOD         ANDEQ     'D'
     C     IGTYPE        OREQ      'SI'
     C     W#LOD         ANDEQ     'L'
     C     IGTYPE        OREQ      'EM'                                                      BUG3045
     C     IGPENP        ANDEQ     'R'                                                       BUG3045
      *
      * DETERMINE ALTERNATIVE REC INSTRUCTIONS
      *
     C                   EXSR      ALRECI
     C                   END
     C                   END
      **
      ** Deam original deal type
      **
     C                   MOVE      W#TYPE        IGOGDT
      **
      ** Original deal sub type
      **
     C                   MOVE      W#STYP        IGOSTP
      **                                                                                      CDL038
      ** Original deal class                                                                  CDL038
      **                                                                                      CDL038
     C                   MOVE      W#CLAS        IGCLAS                                       CDL038
      **
      ** Dm midas original deal type
      **
     C                   MOVE      W#MTYP        IGOMDT
      **
      ** Time of input
      **
     C                   TIME                    IGTIME
      **
      ** Deal user code
      **
     C                   MOVEL     PSUser        IGDUSC
      **
      ** Deal authorisation officer
      **
     C     @@FSTS        IFEQ      'A'
     C                   MOVEL     PSUser        IGAOFR
     C                   END
      **
      ** Deal action date
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          IGLDAT
      *
      ** Branch Code - Alpha
      *
     C                   MOVE      W#BRCA        IGBRCA
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETAMD - SET DEAL FIELDS ON AMEND                             *
     C*                                                               *
     C*****************************************************************
     C     SETAMD        BEGSR
      *
      ** UPDATE CONTROL FIELDS
      *
     C                   MOVEL     @IGCTL        @HNCTL
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'A'           @@ACTN
     C                   PARM      HNDSTS        @@CSTS
     C                   PARM                    BNMMAU
     C                   PARM                    BNMMRA
     C                   PARM      *BLANK        @@FSTS
     C                   PARM      *BLANK        @@CHTP
     C                   MOVEL     @@FSTS        HNDSTS
     C                   MOVEL     @@CHTP        HNCHTP
      **
      ** IF PRINCIPAL DECREASE OF DEPOSIT TAKEN
      ** OR PRINCIPAL INCREASE OF DEPOSIT PLACED
      ** OR SETTLE INTEREST OF DEPOSIT TAKEN
      **
     C     IGTYPE        IFEQ      'PD'
     C     W#LOD         ANDEQ     'D'
     C     IGTYPE        OREQ      'PI'
     C     W#LOD         ANDEQ     'L'
     C     IGTYPE        OREQ      'SI'
     C     W#LOD         ANDEQ     'D'
     C     IGTYPE        OREQ      'EM'                                                      BUG3045
     C     IGPENP        ANDEQ     'P'                                                       BUG3045
      *
      * DETERMINE ALTERNATIVE PAY INSTRUCTIONS
      *
     C                   EXSR      ALPAYI
     C                   MOVEL     @IGALP        @HNALP
     C*******************MOVEL     IGDOPI        HNDORI                                CGL029 NAD002
     C*******************MOVEL     IGMOPI        HNMORI                                CGL029 NAD002
     C                   MOVEL     IGDOPI        HNDOPI                                       NAD002
     C                   MOVEL     IGMOPI        HNMOPI                                       NAD002
      **
      ** IF PRINCIPAL DECREASE OF DEPOSIT PLACED
      ** OR PRINCIPAL INCREASE OF DEPOSIT TAKEN
      ** OR SETTLE INTEREST OF DEPOSIT PLACED
      **
     C                   ELSE
     C     IGTYPE        IFEQ      'PD'
     C     W#LOD         ANDEQ     'L'
     C     IGTYPE        OREQ      'PI'
     C     W#LOD         ANDEQ     'D'
     C     IGTYPE        OREQ      'SI'
     C     W#LOD         ANDEQ     'L'
     C     IGTYPE        OREQ      'EM'                                                      BUG3045
     C     IGPENP        ANDEQ     'R'                                                       BUG3045
      *
      * DETERMINE ALTERNATIVE REC INSTRUCTIONS
      *
     C                   EXSR      ALRECI
     C                   MOVEL     @IGALR        @HNALR
     C                   MOVEL     IGDORI        HNDORI                                       CGL029
     C                   MOVEL     IGMORI        HNMORI                                       CGL029
     C                   END
     C                   END
      **
      ** Deal last action
      **
     C                   MOVEL     'A'           HNLACT
      **
      ** Deal user code
      **
     C                   MOVEL     PSUser        HNDUSC
      **
      ** Deal action date
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          HNLDAT
      **
      ** Extended Receipt Instructions
      **
     C                   MOVEL     @IGREC        @HNREC
     C                   MOVEL     IGRONS        HNRONS                                       CGL029
      **
      * Enhanced Receive Settlement Instructions                                              CDL094
     C                   MOVEL     IGRBB1        HNRBB1                                       CDL094
     C                   MOVEL     IGRBB2        HNRBB2                                       CDL094
     C                   MOVEL     IGRBB3        HNRBB3                                       CDL094
     C                   MOVEL     IGRBB4        HNRBB4                                       CDL094
     C                   MOVEL     IGRBB5        HNRBB5                                       CDL094
     C                   MOVEL     IGRBB6        HNRBB6                                       CDL094
      *                                                                                       CDL094
      ** Extended Payment Instructions
      **
     C                   MOVEL     @IGPY1        @HNPY1
     C*******************MOVEL     IGRONS        HNRONS                                CGL029 NAD002
     C                   MOVEL     IGPONS        HNPONS                                       NAD002
     C                   MOVEL     @IGPY2        @HNPY2
     C                   MOVEL     @IGPY3        @HNPY3
      **
      ** Our Settlement Branch
      **
     C                   MOVEL     IGOSBR        HNOSBR
      **
      ** COVER MESSAGE REQUIRED
      **
     C                   MOVEL     IGCVMR        HNCVMR
      **
      ** EMU Settlement fields
      **
     C                   MOVEL     IGSTCY        HNSTCY
     C                   MOVEL     IGIC72        HNIC72
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C     IGFRNT        IFNE      *BLANK                                       242552
     C                   MOVEL     IGFRNT        HNFRNT                         CAP013
     C                   ENDIF                                                  242552
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C     IGAFRT        IFNE      *BLANK                                       242552
     C                   MOVEL     IGAFRT        HNAFRT                         CAP013
     C                   ENDIF                                                  242552
      **                                                                        CAP051
      ** Automatic Authorisation flag                                           CAP051
      **                                                                        CAP051
     C     CAP051        IFEQ      'Y'                                          CAP051
     C                   MOVEL     IGAUTH        HNAUTH                         CAP051
     C                   ELSE                                                   CAP051
     C                   MOVE      *BLANKS       HNAUTH                         CAP051
     C                   ENDIF                                                  CAP051
      **                                                                                      CDL017
      ** Early Maturity Fields                                                                CDL017
      **                                                                                      CDL017
     C     IGMTYP        IFEQ      'EM'                                                       CDL017
     C                   MOVE      PSuser        HNUSER                                       CDL017
     C                   Z-ADD     IGAMNP        HNAMNP                                       CDL017
     C                   Z-ADD     IGINTR        HNINTR                                       CDL017
     C                   MOVE      IGPENP        HNPENP                                       CDL017
     C                   Z-ADD     IGEMDT        HNEMDT                                       CDL017
     C                   MOVE      IGBSRT        HNBSRT                                       CDL017
     C                   Z-ADD     IGBRTE        HNBRTE                                       CDL017
     C                   ENDIF                                                                CDL017
      **                                                                                     BUG6156
      ** Base Rate fields                                                                    BUG6156
      **                                                                                     BUG6156
     C     IGMTYP        IFEQ      'BC'                                                      BUG6156
     C                   MOVE      PSuser        HNUSER                                      BUG6156
     C                   MOVE      IGBSRT        HNBSRT                                      BUG6156
     C                   Z-ADD     IGBRTE        HNBRTE                                      BUG6156
     C                   ENDIF                                                               BUG6156
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETAUT - SET DEAL FIELDS ON AUTHORIZE                         *
     C*                                                               *
     C*****************************************************************
     C     SETAUT        BEGSR
      *
      ** UPDATE CONTROL FIELDS
      *
     C                   MOVEL     @IGCTL        @HNCTL
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'X'           @@ACTN
     C                   PARM      HNDSTS        @@CSTS
     C                   PARM                    BNMMAU
     C                   PARM                    BNMMRA
     C                   PARM      *BLANK        @@FSTS
     C                   PARM      *BLANK        @@CHTP
     C                   MOVEL     @@FSTS        HNDSTS
     C                   MOVEL     @@CHTP        HNCHTP
      **
      ** Deal last action
      **
     C                   MOVEL     'X'           HNLACT
      **
      ** Deal authorisation officer
      **
     C                   MOVEL     PSUser        HNAOFR
      **
      ** Deal action date
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          HNLDAT
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C     IGFRNT        IFNE      *BLANK                                       242552
     C                   MOVEL     IGFRNT        HNFRNT                         CAP013
     C                   ENDIF                                                  242552
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C     IGAFRT        IFNE      *BLANK                                       242552
     C                   MOVEL     IGAFRT        HNAFRT                         CAP013
     C                   ENDIF                                                  242552
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETDEL - SET DEAL FIELDS ON DELETE                            *
     C*                                                               *
     C*****************************************************************
     C     SETDEL        BEGSR
      *
      ** UPDATE CONTROL FIELDS
      *
     C                   MOVEL     @IGCTL        @HNCTL
      *
      ** FLAG AS 'DELETED'
      *
     C                   MOVEL     'D'           HNDDLT
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'D'           @@ACTN
     C                   PARM      HNDSTS        @@CSTS
     C                   PARM                    BNMMAU
     C                   PARM                    BNMMRA
     C                   PARM      *BLANK        @@FSTS
     C                   PARM      *BLANK        @@CHTP
     C                   MOVEL     @@FSTS        HNDSTS
     C                   MOVEL     @@CHTP        HNCHTP
      **
      ** Deal last action
      **
     C                   MOVEL     'D'           HNLACT
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C     IGFRNT        IFNE      *BLANK                                       242552
     C                   MOVEL     IGFRNT        HNFRNT                         CAP013
     C                   ENDIF                                                  242552
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C     IGAFRT        IFNE      *BLANK                                       242552
     C                   MOVEL     IGAFRT        HNAFRT                         CAP013
     C                   ENDIF                                                  242552
      **                                                                        CAP051
      ** Automatic Authorisation flag                                           CAP051
      **                                                                        CAP051
     C     CAP051        IFEQ      'Y'                                          CAP051
     C                   MOVEL     IGAUTH        HNAUTH                         CAP051
     C                   ELSE                                                   CAP051
     C                   MOVE      *BLANKS       HNAUTH                         CAP051
     C                   ENDIF                                                  CAP051
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* ALRECI - ALTERNATIVE RECEIVE INSTRUCTIONS                     *
     C*                                                               *
     C*****************************************************************
     C     ALRECI        BEGSR
      *
      * EFFECTIVE SETTLEMENT CURRENCY
      *
     C     IGSTCY        IFNE      *BLANKS
     C                   MOVEL     IGSTCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     IGCCY         EffSetCcy         3
     C                   ENDIF
      *
      * DETERMINE ALTERNATIVE RECEIVE INSTRUCTIONS
      *
     C                   CALLB     'ZAALTRECIN'
      ** Customer number                                                                      200400
     C**********         PARM      IGCNUM        ##CNUM            6 0                 200400 CSD027
     C                   PARM      IGCNUM        ##CNUM            6                          CSD027
      ** Rec currency
     C                   PARM      EffSetCcy     ##RCCY            3
      ** Rec - settlement method
     C                   PARM      IGRSTM        ##RSTM            2 0
      ** Rec - our nostro
     C**********         PARM      IGRONS        ##RONS           12                          CGL029
     C                   PARM      IGRONS        ##RONS           18                          CGL029
      ** rec - intermediary bank
     C                   PARM      IGRIBN        ##RIBN            8
      ***MIDAS*Our*Receive*Instructions*(*for*Settlm*Meth*'04'*)*********              179510 200400
     C************       PARM                    IGMORI                                179510 200400
      ** midas our receive method
     C                   PARM                    ##ORCM            2 0
      ** our receive method
     C                   PARM                    ##DORM            5
      ** midas our receive instructions
     C**********         PARM                    ##MORI           12                          CGL029
     C                   PARM                    ##MORI           18                          CGL029
      ** our receive instructions
     C**********         PARM                    ##DORI           12                          CGL029
     C                   PARM                    ##DORI           18                          CGL029
      ** midas customer payment instructions
     C                   PARM                    ##MCPI           10
      ** customer payment instructions
     C                   PARM                    ##DCPI           10
      *
     C*
     C** SETTLEMENT TYPE - MIDAS
     C*
     C                   Z-ADD     ##ORCM        IGORCM
     C*
     C** SETTLEMENT TYPE - FRONT OFFICE
     C*
     C                   MOVEL     ##DORM        IGDORM
     C*
     C** OUR SETTLEMENT ACCOUNT - MIDAS
     C*
     C                   MOVEL     ##MORI        IGMORI
     C*
     C** OUR SETTLEMENT ACCOUNT - FRONT OFFICE
     C*
     C                   MOVEL     ##DORI        IGDORI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - MIDAS
     C*
     C                   MOVEL     ##MCPI        IGMCPI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - FRONT OFFICE
     C*
     C                   MOVEL     ##DCPI        IGDCPI
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* ALPAYI - ALTERNATIVE PAYMENT INSTRUCTIONS                     *
     C*                                                               *
     C*****************************************************************
     C     ALPAYI        BEGSR
      *
      * EFFECTIVE SETTLEMENT CURRENCY
      *
     C     IGSTCY        IFNE      *BLANKS
     C                   MOVEL     IGSTCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     IGCCY         EffSetCcy         3
     C                   ENDIF
      *
      * DETERMINE ALTERNATIVE PAYMENT INSTRUCTIONS
      *
     C                   CALLB     'ZAALTPAYIN'
      ** Customer number                                                                      200400
     C**********         PARM      IGCNUM        ##CNUM            6 0                200400 CSD027A
     C                   PARM      IGCNUM        ##CNUM            6                         CSD027A
      ** Pay currency
     C                   PARM      EffSetCcy     ##PCCY            3
      ** Pay - settlement method
     C                   PARM      IGPSTM        ##PSTM            2 0
      ** Pay - our nostro
     C**********         PARM      IGPONS        ##PONS           12                          CGL029
     C                   PARM      IGPONS        ##PONS           18                          CGL029
      ** account with bank
     C                   PARM      IGAWBN        ##AWBN            8
      ** beneficiary
     C                   PARM      IGBENN        ##BENN            8
      ** bank to bank info 1
     C                   PARM      IGBTB1        ##BTB1           35
      ***MIDAS*Our Pay  Instructions ( for Settlm Meth '04' )                          179510 200400
     C************       PARM                    IGMOPI                                179510 200400
      ** midas our payment method
     C                   PARM                    ##MOPM            2 0
      ** our payment method
     C                   PARM                    ##DOPM            5
      ** midas our payment instructions
     C**********         PARM                    ##MOPI           12                          CGL029
     C                   PARM                    ##MOPI           18                          CGL029
      ** our payment instructions
     C**********         PARM                    ##DOPI           12                          CGL029
     C                   PARM                    ##DOPI           18                          CGL029
      ** midas customer receive instructions
     C                   PARM                    ##MCRI           10
      ** customer receive instructions
     C                   PARM                    ##DCRI           10
      ** midas for account of
     C                   PARM                    ##MFAO           10
      ** for account of
     C                   PARM                    ##DFAC           10
      ** special instructions
     C                   PARM                    ##SPEC           35
     C*
     C** SETTLEMENT TYPE - MIDAS
     C*
     C                   MOVEL     ##MOPM        IGMOPM
     C*
     C** SETTLEMENT TYPE - FRONT OFFICE
     C*
     C                   MOVEL     ##DOPM        IGDOPM
     C*
     C** OUR SETTLEMENT ACCOUNT - MIDAS
     C*
     C                   MOVEL     ##MOPI        IGMOPI
     C*
     C** OUR SETTLEMENT ACCOUNT - FRONT OFFICE
     C*
     C                   MOVEL     ##DOPI        IGDOPI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - MIDAS
     C*
     C                   MOVEL     ##MCRI        IGMCRI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - FRONT OFFICE
     C*
     C                   MOVEL     ##DCRI        IGDCRI
     C*
     C** FOR ACCOUNT OF - MIDAS
     C*
     C                   MOVEL     ##MFAO        IGMFAO
     C*
     C** FOR ACCOUNT OF - FRONT OFFICE
     C*
     C                   MOVEL     ##DFAC        IGDFAC
     C*
     C**  Special instructions.
     C*
     C                   MOVEL     ##SPEC        IGSPEC
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETCTL - SET CONTROL FIELDS                                   *
     C*                                                               *
     C*****************************************************************
     C     SETCTL        BEGSR
      **
      ** Record identifier
      **
     C                   MOVEL     'HN'          IGRCID
      **
      ** Logical delete flag
      **
     C                   MOVEL     *BLANK        IGDLTF
      **
      ** Day of last update
      **
     C                   Z-ADD     @DLUP         IGDLUP
      **
      ** Month of last update
      **
     C                   MOVEL     @MLUP         IGMLUP
      **
      ** Year of last update
      **
     C                   Z-ADD     @YLUP         IGYLUP
      **
      ** Time of last update
      **
     C                   TIME                    IGTLUP
      **
      ** Type of last change (set in validation function)
      **
     C                   MOVEL     IGCHTP        IGCHTP
      **
      ** Last change date
      **
     C                   Z-ADD     BJRDNB        IGLCD
      **
      ** Last update user id
      **
     C                   MOVEL     PSUser        IGLUID
      **
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************         CAP006
     C*                                                               *         CAP006
     C* CHKOTHUPD - Check for update by another workstation           *         CAP006
     C*                                                               *         CAP006
     C*****************************************************************         CAP006
     C     CHKOTHUPD     BEGSR                                                  CAP006
                                                                                CAP006
      ** Retrieve current deal details                                          CAP006
                                                                                CAP006
     C                   MOVE      IGDA38        MidasDlNum        6            CAP006
     C                   MOVE      IGDS38        SequenceNo        3            CAP006
     C                   MOVE      IGAMNP        DeamAmount       15            CAP006
                                                                                CAP006
     C                   Z-ADD     @IGVDY        @KVALD                         CAP006
     C                   MOVE      @VYEAR        @DSPY                          CAP006
     C                   IF        BJDFIN = 'D'                                              BUG8014
     C                   MOVE      @VDMM         @DSPM                          CAP006
     C                   MOVE      @VDDD         @DSPD                          CAP006
     C                   ELSE                                                                BUG8014
     C                   MOVE      @VDDD         @DSPM                                       BUG8014
     C                   MOVE      @VDMM         @DSPD                                       BUG8014
     C                   ENDIF                                                               BUG8014
                                                                                CAP006
      ** Determine whether program is running interactively or in batch         CAP006
      **  ( 0 = batch   1 = interactive)                                        CAP006
      *                                                                         CAP006
     C                   CALLB     'ZARTVJOBA'                                  CAP006
     C                   PARM                    @Return           6            CAP006
     C                   PARM                    @type             1            CAP006
      *                                                                         CAP006
      * Allow access to transaction record by Front-Office ID when in Repair    168345
      * mode for inserts . Set  *RTV module  parameter @@MODE  to   *FRONT      168345
      * if the pgm is:  a) running in Interactive mode - @Type= 1   ~~~~~~      168345
      * and             b) action code is Insert - 'I'                          168345
      * and             c) Front-Office Id is NOT Blank                         168345
      *                                                                         168345
     C     @Type         IFEQ      '1'                                          168345
     C     IGLACT        ANDEQ     'I'                                          168345
     C     IGFRNT        ANDNE     *BLANKS                                      168345
      *                                                                         168345
     C                   MOVE      '*FRONT'      @@MODE                         168345
      *                                                                         168345
     C                   ELSE                                                   168345
      *                                                                         168345
      * Otherwise, if running in batch use Front-Office ID                      168345
      *            (if insert)                                                  CAP013
      *            else, use Midas Deal Number                                  168345
      *                                                                         168345
     C     @Type         IFEQ      '0'                                          CAP006
     C     IGLACT        ANDEQ     'I'                                          CAP013
     C                   MOVE      '*FRONT'      @@MODE                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      *BLANKS       @@MODE                         CAP006
     C                   END                                                    CAP006
      *                                                                         168345
     C                   END                                                    168345
                                                                                CAP006
     C                   CALLB     'MMDEAMRTV'                                  CAP006
      * INPUTS                                                                  CAP006
      *                                                                         CAP006
      * Return code                                                             CAP006
     C                   PARM      *BLANK        RetCodeOut                     CAP006
      *                                                                         CAP006
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP006
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP006
      *                                                                         CAP006
     C                   PARM                    @@MODE            6            CAP006
      *                                                                         CAP006
      * Response mode                                                           CAP006
     C                   PARM      ' '           @@RSMD            1            CAP006
      *                                                                         CAP006
      * Action Code                                                             CAP006
     C                   PARM                    IGLACT                         CAP006
      *                                                                         CAP006
      * Front Office Transaction ID                                             CAP006
     C                   PARM      IGFRNT        FOTRID           20            CAP006
      *                                                                         CAP006
      * Front Office Associated Transaction Id                                  CAP006
     C                   PARM      IGAFRT        FOASID           20            CAP006
      *                                                                         CAP006
      * (Midas) Deal Number                                                     CAP006
     C                   PARM                    MidasDlNum                     CAP006
      *                                                                         CAP006
      * Value Date
     C                   PARM      ValueDate     DDVDAT            6
      *
      * Sequence Number
     C                   PARM      SequenceNo    DDDS38            3
      *
      * Deal Amendment Amount
     C                   PARM      DeamAmount    DDAMNP           15
      *
      * Deal Amendment Type
     C                   PARM      IGMTYP        DDMTYP            2
      *
      * OUTPUTS                                                                 CAP006
      *                                                                         CAP006
      * (Current) deal in file format                                           CAP006
     C                   PARM                    ChkDealFmt                     CAP006
      *                                                                         CAP006
      * OK - Action code                                                        CAP006
     C                   PARM      *BLANK        OKACTN                         CAP006
      *                                                                         CAP006
      * OK - Deal Number                                                        CAP006
     C                   PARM      *BLANK        OKDLNO                         CAP006
      *                                                                         CAP006
      * OK - Value Date
     C                   PARM      *BLANK        OKVDAT            1
      *
      * OK - Sequence Number
     C                   PARM      *BLANK        OKSEQN            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller           CAP006
     C                   PARM      *BLANK        FldNameArr                     CAP006
     C                   PARM      *BLANK        MsgIdArr                       CAP006
     C                   PARM      *BLANK        MsgDtaArr                      CAP006
      *                                                                         CAP006
      * Array index (3P0) from/to caller                                        CAP006
     C                   PARM      *ZERO         Idx               3 0          CAP006
      *                                                                         CAP006
      *                                                                         CAP006
      ** Error if Timestamp is not the same (record has been changed            CAP006
      **  by another workstation)                                               CAP006
                                                                                CAP006
      ** Processing varies according to mode program is running in.             CAP006
      ** In interacive mode simply check whether the timestamp field            CAP006
      ** has been updated since the original deal was fetched by this           CAP006
      ** program.                                                               CAP006
      ** In batch (API input) check return parameters from Retrieve             CAP006
      ** module for errors, and send message to system operator.                CAP006
                                                                                CAP006
      ** Interactive mode:                                                      CAP006
                                                                                CAP006
     C     @TYPE         IFEQ      '1'                                          CAP006
                                                                                CAP006
     C     CHHNTMST      IFNE      IGTMESTMP                                    CAP006
     C                   MOVEL     '*RECUPD'     @@RTCD                         CAP006
     C                   END                                                    CAP006
                                                                                CAP006
      ** Batch mode:                                                            CAP006
     C                   ELSE                                                   CAP006
     C     OKACTN        IFEQ      'N'                                          CAP006
     C     OKDLNO        OREQ      'N'                                          CAP006
     C                   MOVEL     '*RECUPD'     @@RTCD                         CAP006
     C                   Z-ADD     1             C                 2 0          CAP006
                                                                                CAP006
     C     C             DOWLE     ArrayMax                                     CAP006
     C     FldNameArr(C) ANDNE     *BLANKS                                      CAP006
     C*******************MOVEL     *BLANKS       DBError          28     CAP006 CAP013
     C*******************MOVEL     MsgIDArr(C)   DBError                 CAP006 CAP013
     C                   CLEAR                   DBError         132            CAP013
     C                   EVAL      DBerror = 'Update error: ' + FOTRID          CAP013
     C                   CALLB     'ZAMSGTOOPR'                                 CAP006
     C                   PARM                    MsgSndRtn        10            CAP006
     C                   PARM                    DBError                        CAP006
     C                   PARM                    DummyMsgID                     CAP006
     C                   PARM                    DummyMsgF                      CAP006
     C                   ADD       1             C                              CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   ENDSR                                                  CAP006
     C*****************************************************************         CAP006
      /EJECT                                                                    CAP006
     C*****************************************************************
     C*                                                               *
     C* ONLNUP - ON-LINE UPDATES (MEMOS, PRONO, OLPOS, RSACMTPD)      *
     C*                                                               *
     C*****************************************************************
     C     ONLNUP        BEGSR
      *
     C                   CALL      'AOOUMMU0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
     C                   PARM      *BLANK        @AURO             1
     C                   PARM                    #FPAYF                                     AR821086
     C                   PARM                    #FRECF                                     AR821086
      ** FRCD Issued Extension details before update                                          CDL033
     C                   PARM      *BLANKS       PBFRCD                                       CDL033
      ** FRCD Issued Extension details after update                                           CDL033
     C                   PARM      *BLANKS       PAFRCD                                       CDL033
     C                   PARM      *BLANKS       DLDLQD                                       CER049
     C                   PARM      *BLANKS       BeDealsDtlC                               AR1044820
     C                   PARM      *BLANKS       AfDealsDtlC                               AR1044820
      *                                                                                    AR1044820
      ** Calling Program                                                                   AR1044820
      *                                                                                    AR1044820
     C                   PARM      *BLANKS       CALLER           10                       AR1044820
     C/COPY WNCPYSRC,MMDEAMMC04
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     'AOOUMMU0'    DBFILE                         *************
     C                   MOVEL     '991'         DBASE                          * DBERR 991 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *                                                                         CDE001
      ** Data export for CCRM - Limits                                          CDE001
     C                   IF        CDE001 = 'Y'                                 CDE001
     C                   MOVEL     IGDA38        T#TREF                         CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C**********         PARM                    T#TREF           20                   CDE001 CGL029
     C                   PARM                    T#TREF           26                          CGL029
     C                   PARM      'LDNI'        T#TCAT            4            CDE001
     C                   PARM      *BLANKS       T#RSRV           10            CDE005
     C                   ENDIF                                                  CDE001
     C/COPY WNCPYSRC,MMDEAMMC02
      *
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        IGLACT = 'A' OR                                            CRE020
     C                             IGLACT = 'D'                                               CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* TREAUP - TREASURY MANAGEMENT UPDATES                          *
     C*                                                               *
     C*****************************************************************
     C     TREAUP        BEGSR
      *
     C                   CALLB     'MMDEAMUPT'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      IGLACT        @LACT             1
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
     C     @RTCD         IFEQ      '*ERROR '
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     'MMDEAMTU'    DBFILE                         *************
     C                   MOVEL     '992'         DBASE                          * DBERR 992 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* CLSINT - CALCULATE SETTLE INTEREST                            *
     C*                                                               *
     C*****************************************************************
     C     CLSINT        BEGSR
      *
     C                   CALLB     'ZADEAMSINT'
      *
      ** INPUT
      *
      ** Deal number
     C                   PARM      IGDA38        ##DA38            6 0
      *
      ** Value date of deal amendment - Midas day number
     C                   PARM      IGDVSD        ##VDAT            5 0
      *
      ** Deal type of related deal
     C                   PARM      W#MTYP        ##MTYP            2
      *
      ** Value date of related deal - YYYYMMDD
     C                   PARM      W#RVDY        ##RVDY            8 0
      *
      ** Principal of related deal
     C                   PARM      W#AMT         ##AMT            15 0
      *
      ** Interest rate of related deal
     C                   PARM      W#INTR        ##INTR           11 7
      *
      ** Calculation method of related deal
     C                   PARM      W#CALC        ##CALC            1
      *
      ** Round down interest indicator of related deal
     C                   PARM      W#RDFC        ##RDFC            1
      *
      ** OUTPUT
      *
      ** Settle Interest
     C                   PARM      *ZERO         ##SINT           13 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* CVTVDT - CONVERT DEAL AMENDMENT VALUE DATE TO YYYYMMDD FORMAT *
     C*                                                               *
     C*****************************************************************
     C     CVTVDT        BEGSR
      **
      ** Deam value date - yyyy       IGVDYY
      ** Deam value date - mm         IGVDMM
      ** Deam value date - dd         IGVDDD
      **  CONVERT VALUE DATE FROM DAY NUMBER TO YMD
      **
     C                   Z-ADD     IGDVSD        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IGVDY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* ACRDEL - ACCESS RELATED DEAL INFORMATION                      *
     C*                                                               *
     C*****************************************************************
     C     ACRDEL        BEGSR
      *
      **  ACCESS RELATED MM DEAL
      *
     C     IGDA38        CHAIN     MMDEALLL                           99
      *
      **  DATABASE ERROR IF DEAL NOT FOUND
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     IGDA38        DBKEY
     C                   MOVEL     'MMDEALLL'    DBFILE                         *************
     C                   MOVEL     '800'         DBASE                          * DBERR 800 *
     C                   EXSR      SRERR                                        *************
     C                   RETURN
     C                   END
      *
      * LOAD RELATED DEAL WORK FIELDS ACCORDING TO FORMAT READ
      *
     C     ##FORM        IFEQ      'MMDELDP0'
     C                   MOVE      HKTYPE        W#TYPE            2
     C                   MOVE      HKSTYP        W#STYP            2
     C                   MOVE      HKCLAS        W#CLAS            4                          CDL038
     C                   MOVEL     HKMTYP        W#MTYP            2
     C                   MOVEL     @HKVDY        W#RVDY            8 0
     C                   Z-ADD     HKAMNP        W#AMT            15 0
     C                   Z-ADD     HKINTR        W#INTR           11 7
     C                   MOVEL     HKICMT        W#CALC            1
     C                   MOVEL     HKRDFC        W#RDFC            1
     C                   MOVEL     HKBRCA        W#BRCA            3
      *
     C                   MOVEL     MMDELD        Z#WSTS
      *
     C                   ELSE
     C                   MOVE      HLTYPE        W#TYPE
     C                   MOVE      HLSTYP        W#STYP
     C                   MOVE      HLCLAS        W#CLAS                                       CDL038
     C                   MOVEL     HLMTYP        W#MTYP
     C                   MOVEL     @HLVDY        W#RVDY
     C                   Z-ADD     HLFVAL        W#AMT
     C                   Z-ADD     HLFRAT        W#INTR
     C                   MOVEL     HLICMT        W#CALC
     C                   MOVEL     HLRDFC        W#RDFC
     C                   MOVEL     HLBRCA        W#BRCA
      *
     C                   MOVEL     MMDENB        Z#WSTS
      *
     C                   END
      *
      * LOAN OR DEPOSIT TYPE DEAL?
      *
     C     W#MTYP        IFEQ      'IT'
     C     W#MTYP        OREQ      'TD'
     C     W#MTYP        OREQ      'CI'
     C     W#MTYP        OREQ      'CD'
     C     W#MTYP        OREQ      'CF'                                                       CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
     C                   MOVEL     'D'           W#LOD             1
     C                   ELSE
     C                   MOVEL     'L'           W#LOD
     C                   END
      *
     C                   ENDSR
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRWTCH - Initiates the Midas Compliance Engine.               *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRWTCH        BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Initialise the Transaction Details Parameter                                         CSD015
      ** ============================================                                         CSD015
      *                                                                                       CSD015
     C                   CLEAR                   SDWLTD                                       CSD015
      *                                                                                       CSD015
      ** Item Type, Identifier, and Branch information.                                       CSD015
      *                                                                                       CSD015
     C                   CAT       'MM':0        W4ITEM                                       CSD015
     C                   CAT       HNMTYP:0      W4ITEM                                       CSD015
      *                                                                                       CSD015
     C                   MOVE      HNDA38        WHNDA3                                       CSD015
     C                   MOVE      HNVDYY        WHNVDY                                       CSD015
     C                   MOVE      HNVDMM        WHNVDM                                       CSD015
     C                   MOVE      HNVDDD        WHNVDD                                       CSD015
     C                   MOVE      HNDS38        WHNDS3                                       CSD015
     C                   EVAL      W4IDEN = WHNDA3 + WHNVDY + WHNVDM +                        CSD015
     C                             WHNVDD + WHNDS3                                            CSD015
     C                   MOVEL     HNBRCA        W4BRCH                                       CSD015
      *                                                                                       CSD015
      ** Select the System Prefix.                                                            CSD015
      *                                                                                       CSD015
     C                   IF        CSC011 = 'Y'                                               CSD015
     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   MOVEL     'MMDEAMPP'    W4FUNT                                       CSD015
      *                                                                                       CSD015
      ** Get the Counter Party Detail.                                                        CSD015
      *                                                                                       CSD015
     C                   EXSR      SRGetCtrpDet                                               CSD015
     C                   MOVEL     HNCNUM        W4CNUM                                       CSD015
     C                   MOVEL     WCtrpTyp      W4CTYP                                       CSD015
     C                   MOVEL     WCtrpRpt      W4CUST                                       CSD015
      *                                                                                       CSD015
      ** Get the Deal Date.                                                                   CSD015
      *                                                                                       CSD015
     C                   MOVE      @IGDDY        WDATE                                        CSD015
     C                   MOVE      WLongYr       WYear                                        222059
     C                   MOVE      WMnth         WMonth                                       222059
     C                   MOVE      WDays         WDay                                         222059
     C                   EVAL      WDDT = WYear + '-'                                         CSD015
     C                             + WMonth + '-' +WDay                                       CSD015
     C                   MOVEL     WDDT          W4DDAT                                       CSD015
      *                                                                                       CSD015
      ** Get the Value Date.                                                                  CSD015
      *                                                                                       CSD015
     C                   MOVE      @IGVDY        WDATE                                        CSD015
     C                   MOVE      WLongYr       WYear                                        222059
     C                   MOVE      WMnth         WMonth                                       222059
     C                   MOVE      WDays         WDay                                         222059
     C                   EVAL      WDDT = WYear + '-'                                         CSD015
     C                             + WMonth + '-' +WDay                                       CSD015
     C                   MOVEL     WDDT          W4VDAT                                       CSD015
                                                                                              CSD015
     C                   IF        WDDT = '0000-00-00'                                        CSD015
     C                   EVAL      WDDT = '0001-01-01'                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      *                                                                                       CSD015
      ** Currency and Amount information.                                                     CSD015
      *                                                                                       CSD015
     C                   MOVEL     HNCCY         W4DEN1                                       CSD015
      *                                                                                       CSD015
     C                   MOVEL     HNCCY         PZACcy                                       CSD015
     C                   MOVE      *BLANKS       PZANtvAmt                                    CSD015
     C                   MOVE      HNAMNP        PZANtvAmt                                    CSD015
     C                   EXSR      SRAmtToNum                                                 CSD015
     C                   EVAL      W4AMT1 = WAMT                                              CSD015
      *                                                                                       CSD015
      ** Build the Free Format String                                                         CSD015
      ** ============================                                                         CSD015
      *                                                                                       CSD015
      ** Initialise additional account line.                                                  CSD015
      *                                                                                       CSD015
     C                   MOVEA     *BLANKS       WLFSD                                        CSD015
     C                   MOVEL     HNRIBA        WLFSD(2)                                     CSD015
     C                   MOVEL     HNPIBA        WLFSD(6)                                     CSD015
     C                   MOVEL     HNRCRA        WLFSD(9)                                     CSD015
     C                   MOVEL     HNAWBA        WLFSD(11)                                    CSD015
     C                   MOVEL     HNBENA        WLFSD(12)                                    CSD015
      *                                                                                       CSD015
      ** Begin string and packet assembly.                                                    CSD015
      *                                                                                       CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
     C                   EVAL      PFreeFmtStr = *BLANKS                                      CSD015
     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
     C                   EVAL      WData = *BLANKS                                            CSD015
     C                   EVAL      WData2 = *BLANKS                                           CSD015
      *                                                                                       CSD015
     C                   DOU       Ctr = ArrMax                                               CSD015
      *                                                                                       CSD015
     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
      *                                                                                       CSD015
      ** Select the currency for nostro fields.                                               CSD015
      *                                                                                       CSD015
     C                   IF        Ctr = 1 OR                                                 CSD015
     C                             Ctr = 5                                                    CSD015
     C                   IF        HNSTCY <> *BLANKS                                          CSD015
     C                   EVAL      WCcy = HNSTCY                                              CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WCcy = HNCCY                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Call the detail retriever program.                                                   CSD015
      *                                                                                       CSD015
     C                   CALL      'SDCWLFMT'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM                    WLF(Ctr)                                     CSD015
     C                   PARM      *BLANKS       PInpA                                        CSD015
     C                   PARM      *BLANKS       PInpB                                        CSD015
     C                   PARM      *BLANKS       PInpC                                        CSD015
     C                   PARM      *BLANKS       PInpD                                        CSD015
     C                   PARM      *BLANKS       PInpE                                        CSD015
     C                   PARM                    WCcy                                         CSD015
     C                   PARM                    WData                                        CSD015
     C                   PARM                    WData2                                       CSD015
      *                                                                                       CSD015
     C                   IF        WData <> *BLANKS AND                                       CSD015
     C                             @RtCd = *BLANKS                                            CSD015
     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WData:0       WXMLPacket                                   CSD015
     C                   CAT       WLFSD(Ctr):1  WXMLPacket                                   CSD015
     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                  CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
     C                   EVAL      WData = *BLANKS                                            CSD015
     C                   EVAL      WCcy = *BLANKS                                             CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   EVAL      Ctr = Ctr + 1                                              CSD015
      *                                                                                       CSD015
     C                   ENDDO                                                                CSD015
      *                                                                                       CSD015
      ** Add the Payment Details.                                                             CSD015
      *                                                                                       CSD015
     C                   IF        HNDTP1 <> *BLANKS OR                                       CSD015
     C                             HNDTP2 <> *BLANKS OR                                       CSD015
     C                             HNDTP3 <> *BLANKS OR                                       CSD015
     C                             HNDTP4 <> *BLANKS                                          CSD015
      *                                                                                       CSD015
     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       HNDTP1:0      WXMLPacket                                   CSD015
     C                   CAT       HNDTP2:1      WXMLPacket                                   CSD015
     C                   CAT       HNDTP3:1      WXMLPacket                                   CSD015
     C                   CAT       HNDTP4:1      WXMLPacket                                   CSD015
     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                  CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Check for compliance.                                                                CSD015
      *                                                                                       CSD015
     C                   IF        PFreeFmtStr <> *BLANKS                                     CSD015
     C                   CALL      'SDCWLCHK'                                                 CSD015
     C                   PARM                    SDWLTD                                       CSD015
     C                   PARM                    PFreeFmtStr                                  CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRCompChk - Handles the entire compliance checking            *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRCompChk     BEGSR                                                                CSD015
      *                                                                                       CSD015
     C                   SELECT                                                               CSD015
      *                                                                                       CSD015
      ** Execute a direct compliance check on insert operations.                              CSD015
      *                                                                                       CSD015
     C                   WHEN      WCompMode = OnInsert                                       CSD015
      *                                                                                       CSD015
     C                   EVAL      WMoveMode = ALL                                            CSD015
      *                                                                                       CSD015
      ** Move relevant file fields to their respective                                        CSD015
      ** Watch List fields and then check for useful                                          CSD015
      ** fields to return to the Compliance Engine.                                           CSD015
      *                                                                                       CSD015
     C                   EXSR      SRDBFsToWLFs                                               CSD015
     C                   EXSR      SRWLFChk                                                   CSD015
      *                                                                                       CSD015
     C                   IF        WOKFlg = 'Y'                                               CSD015
     C                   EXSR      SRWTCH                                                     CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** If the action associated with the current record is Amend,                           CSD015
      ** check first if this record has been analysed by the CE.                              CSD015
      *                                                                                       CSD015
     C                   WHEN      WCompMode = OnAmend                                        CSD015
      *                                                                                       CSD015
     C                   EXSR      SRRetryChk                                                 CSD015
      *                                                                                       CSD015
     C                   IF        WRetryFlg = 'Y'                                            CSD015
     C                   EVAL      WMoveMode = ALL                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WMoveMode = CHANGED                                        CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   EXSR      SRDBFsToWLFs                                               CSD015
     C                   EXSR      SRWLFChk                                                   CSD015
     C                   IF        (WOKFlg = 'Y' AND                                          CSD015
     C                             WChgFlg = 'Y') OR                                          CSD015
     C                             WRetryFlg = 'Y'                                            CSD015
     C                   EXSR      SRWTCH                                                     CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSL                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRDBFsToWLFs - Moves relevant database fields to their        *                       CSD015
      *                respective Watch List Fields.                  *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRDBFsToWLFs  BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Initialise the Watch List Fields array to blanks.                                    CSD015
      *                                                                                       CSD015
     C                   MOVEA     *BLANKS       WLF                                          CSD015
      *                                                                                       CSD015
     C                   SELECT                                                               CSD015
      *                                                                                       CSD015
      ** Execute an unconditional move if necessary.                                          CSD015
      *                                                                                       CSD015
     C                   WHEN      WMoveMode = ALL                                            CSD015
      *                                                                                       CSD015
     C                   MOVEL     HNRONS        WLF(1)                                       CSD015
     C                   MOVEL     HNRIBN        WLF(2)                                       CSD015
     C                   MOVEL     HNROBN        WLF(3)                                       CSD015
     C                   MOVEL     HNROCN        WLF(4)                                       CSD015
     C                   MOVEL     HNPONS        WLF(5)                                       CSD015
     C                   MOVEL     HNPIBN        WLF(6)                                       CSD015
     C                   MOVEL     HNPOBN        WLF(7)                                       CSD015
     C                   MOVEL     HNPOCN        WLF(8)                                       CSD015
     C                   MOVEL     HNRCRN        WLF(9)                                       CSD015
     C                   MOVEL     HNRVNO        WLF(10)                                      CSD015
     C                   MOVEL     HNAWBN        WLF(11)                                      CSD015
     C                   MOVEL     HNBENN        WLF(12)                                      CSD015
      *                                                                                       CSD015
     C                   WHEN      WMoveMode = CHANGED                                        CSD015
      *                                                                                       CSD015
      ** Move only the fields that have changed since the last save.                          CSD015
      *                                                                                       CSD015
     C                   EVAL      WChgFlg = 'N'                                              CSD015
      *                                                                                       CSD015
     C                   IF        HNRONS <> BCRONS                                           CSD015
     C                   MOVEL     HNRONS        WLF(1)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HNRIBN <> BCRIBN                                           CSD015
     C                   MOVEL     HNRIBN        WLF(2)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HNROBN <> BCROBN                                           CSD015
     C                   MOVEL     HNROBN        WLF(3)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HNROCN <> BCROCN                                           CSD015
     C                   MOVEL     HNROCN        WLF(4)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HNPONS <> BCPONS                                           CSD015
     C                   MOVEL     HNPONS        WLF(5)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HNPIBN <> BCPIBN                                           CSD015
     C                   MOVEL     HNPIBN        WLF(6)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HNPOBN <> BCPOBN                                           CSD015
     C                   MOVEL     HNPOBN        WLF(7)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HNPOCN <> BCPOCN                                           CSD015
     C                   MOVEL     HNPOCN        WLF(8)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HNRCRN <> BCRCRN                                           CSD015
     C                   MOVEL     HNRCRN        WLF(9)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HNRVNO <> BCRVNO                                           CSD015
     C                   MOVEL     HNRVNO        WLF(10)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HNAWBN <> BCAWBN                                           CSD015
     C                   MOVEL     HNAWBN        WLF(11)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HNBENN <> BCBENN                                           CSD015
     C                   MOVEL     HNBENN        WLF(12)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HNDTP1 <> BCDTP1 OR                                        CSD015
     C                             HNDTP2 <> BCDTP2 OR                                        CSD015
     C                             HNDTP3 <> BCDTP3 OR                                        CSD015
     C                             HNDTP4 <> BCDTP4                                           CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSL                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRWLFChk - Checks if there is something useful to return      *                       CSD015
      *            to the Compliance Engine.                          *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRWLFChk      BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Check the Watch List Fields array.                                                   CSD015
      *                                                                                       CSD015
     C                   EVAL      WOKFlg = 'N'                                               CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
      *                                                                                       CSD015
     C                   DOU       Ctr = (ArrMax - 1)                                         CSD015
     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
     C                   EVAL      WOKFlg = 'Y'                                               CSD015
     C                   LEAVE                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   EVAL      Ctr = Ctr + 1                                              CSD015
     C                   ENDDO                                                                CSD015
      *                                                                                       CSD015
      ** Check the Payment Details.                                                           CSD015
      *                                                                                       CSD015
     C                   IF        WOKFlg = 'N'                                               CSD015
     C                   IF        HNDTP1 <> *BLANKS OR                                       CSD015
     C                             HNDTP2 <> *BLANKS OR                                       CSD015
     C                             HNDTP3 <> *BLANKS OR                                       CSD015
     C                             HNDTP4 <> *BLANKS                                          CSD015
     C                   EVAL      WOKFlg = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRRetryChk - Checks if the current record is unconfirmed by   *                       CSD015
      *              the Compliance Engine.                           *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRRetryChk    BEGSR                                                                CSD015
      *                                                                                       CSD015
     C                   EVAL      WRetryFlg = 'N'                                            CSD015
     C                   EVAL      KFuncType = *BLANKS                                        CSD015
     C                   EVAL      KIden = *BLANKS                                            CSD015
     C                   EVAL      KBranch = *BLANKS                                          CSD015
      *                                                                                       CSD015
     C                   MOVEL     'MMDEAMPP'    KFuncType                                    CSD015
     C                   MOVE      HNDA38        WHNDA3                                       CSD015
     C                   MOVE      HNVDYY        WHNVDY                                       CSD015
     C                   MOVE      HNVDMM        WHNVDM                                       CSD015
     C                   MOVE      HNVDDD        WHNVDD                                       CSD015
     C                   MOVE      HNDS38        WHNDS3                                       CSD015
     C                   EVAL      KIden = WHNDA3 + WHNVDY + WHNVDM +                         CSD015
     C                             WHNVDD + WHNDS3                                            CSD015
     C                   MOVEL     HNBRCA        KBranch                                      CSD015
      *                                                                                       CSD015
     C     KCWHT         CHAIN     SDCWHTL1                                                   CSD015
      *                                                                                       CSD015
     C                   IF        %FOUND(SDCWHTL1) AND                                       CSD015
     C                             W3UNCF = 'Y'                                               CSD015
     C                   EVAL      WRetryFlg = 'Y'                                            CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRGetCtrpDet - Gets the Counterparty Details given a Customer *                       CSD015
      *                Number.                                        *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRGetCtrpDet  BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Initialise the relevant variables.                                                   CSD015
      *                                                                                       CSD015
     C                   EVAL      PCustNo = *BLANKS                                          CSD015
     C                   EVAL      WCtrpRpt = *BLANKS                                         CSD015
     C                   EVAL      WCtrpTyp = *BLANKS                                         CSD015
     C                   MOVEL     HNCNUM        PCustNo                                      CSD015
      *                                                                                       CSD015
      ** Get the Customer Detail.                                                             CSD015
      *                                                                                       CSD015
     C                   CALLB     'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*KEY   '     @Optn                                        CSD015
     C                   PARM                    PCustNo                                      CSD015
     C                   PARM      *BLANKS       PErrInf                                      CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
      *                                                                                       CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
      *                                                                                       CSD015
      ** Assemble the Counter Party information.                                              CSD015
      *                                                                                       CSD015
     C     BBCRNM        CAT       BBCRTN        WCtrpRpt                                     CSD015
      *                                                                                       CSD015
      ** Determine the Counterparty Type.                                                     CSD015
      *                                                                                       CSD015
     C                   IF        CCF001 = 'Y'                                               CSD015
      *                                                                                       CSD015
     C                   IF        BBCRPC = 'Y'                                               CSD015
     C                   EVAL      WCtrpTyp = 'C'                                             CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WCtrpTyp = 'I'                                             CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ELSE                                                                 CSD015
      *                                                                                       CSD015
     C                   IF        BBLICD <> *BLANKS AND                                      CSD015
     C                             BBLICD <> W1IND1  AND                                      CSD015
     C                             BBLICD <> W1IND2  AND                                      CSD015
     C                             BBLICD <> W1IND3  AND                                      CSD015
     C                             BBLICD <> W1IND4  AND                                      CSD015
     C                             BBLICD <> W1IND5                                           CSD015
     C                   EVAL      WCtrpTyp = 'C'                                             CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WCtrpTyp = 'I'                                             CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ELSE                                                                 CSD015
      *                                                                                       CSD015
      ** Handle Database Errors if any occur.                                                 CSD015
      *                                                                                       CSD015
     C                   IF        @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = @Optn                                              CSD015
     C                   EVAL      DBFile = 'SDCUSTPD'                                        CSD015
     C                   EVAL      DBase = 907                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRAmtToNum  - Converts an amount into numeric format data.    *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRAmtToNum    BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Directly convert the given amount into numerical format.                             CSD015
      *                                                                                       CSD015
     C                   CALL      'ZACVTAMT'                                                 CSD015
     C                   PARM      *BLANKS       PZARtCd                                      CSD015
     C                   PARM                    PZACcy                                       CSD015
     C                   PARM                    PZANtvAmt                                    CSD015
     C                   PARM                    PZAAmt                                       CSD015
     C                   PARM                    PZACvtAmt                                    CSD015
      *                                                                                       CSD015
     C                   EVAL      WAMT = PZAAmt                                              CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CRE020
      /EJECT                                                                                  CRE020
      *****************************************************************                       CRE020
      *                                                               *                       CRE020
      *  SRIdxTrn - Handles the advice index of the current           *                       CRE020
      *             transaction.                                      *                       CRE020
      *                                                               *                       CRE020
      *****************************************************************                       CRE020
     C     SRIdxTrn      BEGSR                                                                CRE020
                                                                                              CRE020
      ** Initialise key values.                                                               CRE020
                                                                                              CRE020
     C                   MOVE      *BLANKS       KRefNo                                       CRE020
     C                   MOVE      *BLANKS       KSeqNo                                       CRE020
     C                   MOVEL     HNDA38        KRefNo                                       CRE020
     C                   MOVEL     HNDS38        KSeqNo                                       CRE020
                                                                                              CRE020
      ** Begin advice index processing.                                                       CRE020
                                                                                              CRE020
     C                   OPEN      READVCL2                                                   CRE020
                                                                                              CRE020
     C     KADVC         SETLL     READVCL2                                                   CRE020
     C     KADVC         READE     READVCL2                                                   CRE020
                                                                                              CRE020
     C                   DOW       NOT %EOF                                                   CRE020
                                                                                              CRE020
      ** Execute amend processing if necessary.                                               CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'Y' AND                                           CRE020
     C                             RSAPIN = 'N'                                               CRE020
     C                   MOVE      'N'           RAUTHI                                       CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Execute reversal processing if necessary.                                            CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N' AND                                           CRE020
     C                             RSAPIN = ' ' AND                                           CRE020
     C                             HNLACT = 'D'                                               CRE020
     C                   EVAL      RCHTYP = 'R'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'Y'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C     KADVC         READE     READVCL2                                                   CRE020
     C                   ENDDO                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL2                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    MMVDEM
      *                                                                                       CSD015
      ** Compliance Watch Hit List Key.                                                       CSD015
      *                                                                                       CSD015
     C     KCWHT         KLIST                                                                CSD015
     C                   KFLD                    KFuncType                                    CSD015
     C                   KFLD                    KIden                                        CSD015
     C                   KFLD                    KBranch                                      CSD015
                                                                                              CRE020
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
     C                   KFLD                    KSeqNo                                       CRE020
     C*
     C** ACCESS BANK DETAILS
     C*
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C* DATABASE ERROR
     C*
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      SRERR                                        *************
     C                   END
     C*
     C*  ACCESS DEAL DATA
     C*
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
     C*
     C* DATABASE ERROR
     C*
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *                                                                         CAP051
      *  ACCESS DEAL DATA                                                       CAP051
      *                                                                         CAP051
     C                   MOVE      'N'           CAP051            1            CAP051
     C                   CALLB     'AOSARDR0'                                   CAP051
     C                   PARM      *BLANKS       @RTCD                          CAP051
     C                   PARM      '*VERIFY '    @OPTN                          CAP051
     C                   PARM      'CAP051'      @SAR              6            CAP051
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
      *                                                                         CAP051
     C     @RTCD         IFEQ      *BLANK                                       CAP051
     C                   MOVE      'Y'           CAP051                         CAP051
     C                   ENDIF                                                  CAP051
      *                                                                         CAP051
     C                   MOVE      BNMMAU        SAVMAU            1            CAP051
     C                   MOVE      BNMMRA        SAVMRA            1            CAP051
     C*
     C** ACCESS MIDAS MODULE DETAILS
     C*
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C*
     C* DATABASE ERROR
     C*
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 902 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *                                                                         CDE001
      ** Determine if Data Export for CCRM Limits is active                     CDE001
     C                   CALL      'AOSARDR0'                                   CDE001
     C                   PARM      *BLANKS       @RTCD                          CDE001
     C                   PARM      '*VERIFY'     @OPTN                          CDE001
     C                   PARM      'CDE001'      @SARD             6            CDE001
      *                                                                         CDE001
     C     @RTCD         IFEQ      *BLANK                                       CDE001
     C                   MOVEL     'Y'           CDE001            1            CDE001
     C                   ENDIF                                                  CDE001
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C**********         IN        SDSTAT                                              CSC011 CSD015
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 903                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CDL010
      ** Access SAR details file to determine if CDL010 is on.                                CDL010
      ** (Dealing Transaction Authorisation)                                                  CDL010
                                                                                              CDL010
     C                   CALLB     'AOSARDR0'                                                 CDL010
     C                   PARM      *BLANKS       @RTCD                                        CDL010
     C                   PARM      '*VERIFY'     @OPTN                                        CDL010
     C                   PARM      'CDL010'      @SARD             6                          CDL010
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL010
     C                   IF        @RTCD <> *BLANKS AND                                       CDL010
     C                             @RTCD <> '*NRF   '                                         CDL010
     C     *LOCK         IN        LDA                                                        CDL010
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL010
     C                   EVAL      DBASE = 902                                                CDL010
     C                   EVAL      DBKEY = 'CDL010'                                           CDL010
     C                   OUT       LDA                                                        CDL010
     C                   EXSR      SRERR                                                      CDL010
     C                   ENDIF                                                                CDL010
     C                   IF        @RTCD = *BLANKS                                            CDL010
     C                   EVAL      CDL010 = 'Y'                                               CDL010
     C                   ELSE                                                                 CDL010
     C                   EVAL      CDL010 = 'N'                                               CDL010
     C                   ENDIF                                                                CDL010
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      **  Access SAR details to see if CSD015 is switched on.                                 CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*VERIFY'     @Optn                                        CSD015
     C                   PARM      'CSD015'      @SARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CSD015'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 904                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if transactions are being monitored by Compliance Watch.                       CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
                                                                                              CSD015
     C                   CALL      'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*KEY   '     @Optn                                        CSD015
     C                   PARM      'DEALING '    PFuncCode                                    CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> *BLANKS AND                                       CSD015
     C                             @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'DEALING'                                          CSD015
     C                   EVAL      DBFile = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBase = 905                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access SAR details to see if CCF001 is switched on.                                 CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*VERIFY'     @Optn                                        CSD015
     C                   PARM      'CCF001'      @SARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
     C                   EVAL      CCF001 = 'Y'                                               CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CCF001'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 906                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access Compliance Watch Configuration Data if necessary.                            CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
                                                                                              CSD015
     C                   CALL      'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*FIRST '     @Optn                                        CSD015
     C     SDCWCD        PARM      SDCWCD        DSSDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> *BLANKS                                           CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = @Optn                                              CSD015
     C                   EVAL      DBFile = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBase = 908                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if CRE020 is enabled.                                                          CRE020
                                                                                              CRE020
     C                   CALLB     'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM      '*VERIFY'     POptn                                        CRE020
     C                   PARM      'CRE020'      PSARD                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   EVAL      CRE020 = 'N'                                               CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBase = 909                                                CRE020
     C                   EVAL      DBKey = 'CRE020'                                           CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Check if a System Value exists for this maintenance.                                 CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
                                                                                              CRE020
     C                   CALLB     'AOSVALR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM                    PSysVal01                                    CRE020
     C                   PARM                    PCurSet01                                    CRE020
     C                   PARM                    PSysVal02                                    CRE020
     C                   PARM                    PCurSet02                                    CRE020
     C                   PARM                    PSysVal03                                    CRE020
     C                   PARM                    PCurSet03                                    CRE020
     C                   PARM                    PSysVal04                                    CRE020
     C                   PARM                    PCurSet04                                    CRE020
     C                   PARM                    PSysVal05                                    CRE020
     C                   PARM                    PCurSet05                                    CRE020
     C                   PARM                    PSysVal06                                    CRE020
     C                   PARM                    PCurSet06                                    CRE020
     C                   PARM                    PSysVal07                                    CRE020
     C                   PARM                    PCurSet07                                    CRE020
     C                   PARM                    PSysVal08                                    CRE020
     C                   PARM                    PCurSet08                                    CRE020
     C                   PARM                    PSysVal09                                    CRE020
     C                   PARM                    PCurSet09                                    CRE020
     C                   PARM                    PSysVal10                                    CRE020
     C                   PARM                    PCurSet10                                    CRE020
                                                                                              CRE020
     C                   EVAL      WSysVal01 = 'N'                                            CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   MOVEL     PCurSet01     WSysVal01                                    CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SDSVALPD'                                        CRE020
     C                   EVAL      DBase = 910                                                CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CDL033
      ** Determine if Floating Rate CD Issued feature is                                      CDL033
      ** switched on.                                                                         CDL033
      *                                                                                       CDL033
     C                   MOVE      *BLANKS       CDL033                                       CDL033
     C                   CALL      'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       PRTCD                                        CDL033
     C                   PARM      '*VERIFY'     POPTN                                        CDL033
     C                   PARM      'CDL033'      PSARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
      *                                                                                       CDL033
     C     PRTCD         IFEQ      *BLANKS                                                    CDL033
     C                   MOVE      'Y'           CDL033                                       CDL033
     C                   ELSE                                                                 CDL033
     C     PRTCD         IFNE      '*NRF   '                                                  CDL033
     C     *LOCK         IN        LDA                                                        CDL033
     C                   MOVE      '911'         DBASE                                        CDL033
     C                   MOVEL     'CDL033  '    DBKEY                                        CDL033
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRTCD                                        CSD083
     C                   PARM      '*VERIFY'     POPTN                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRTCD <> *BLANKS AND                                       CSD083
     C                             PRTCD <> '*NRF   '                                         CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBASE = 912                                                CSD083
     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
     C*
     C**  READ DTAARA/RUNDAT to access MULTI-BRANCHING flag.
     C*
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
                                                                                              CAP084
      ** Check whether user is a web browser user, if so overwrite                            CAP084
     C                   CALL      'SFC000026'                                                CAP084
     C                   PARM      *BLANKS       USER             10                          CAP084
      *                                                                                       CAP084
     C                   IF        USER <> *BLANKS                                            CAP084
     C                   MOVEL     USER          PSUser                                       CAP084
     C                   ENDIF                                                                CAP084
      *
      * KEY LISTS
      *
     C     DEAMK         KLIST
     C                   KFLD                    IGDA38
     C                   KFLD                    IGVDYY
     C                   KFLD                    IGVDMM
     C                   KFLD                    IGVDDD
     C                   KFLD                    IGDS38
     C*
     C/COPY WNCPYSRC,MMDEAMMC03
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************
     C*                                                   *
     C* SRERR - EXCEPTION ERRORS                          *
     C*                                                   *
     C*****************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'MMDEAMUPM'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*****************************************************
     C/COPY ZACPYSRC,PSSR_ILE                                                                 CDL033
      *****************************************************                                   CDL033
      /EJECT
      *********************************************************************
      ** FIELD LOG
      *********************************************************************
      **                                      SET IN     SET IN
      **                                    VALIDATION    THIS    AMENDABLE
      **                                     FUNCTION   FUNCTION
      *********************************************************************
      ** Record identifier            HNRCID              YES       YES
      ** Logical delete flag          HNDLTF              YES       YES
      ** Day of last update           HNDLUP              YES       YES
      ** Month of last update         HNMLUP              YES       YES
      ** Year of last update          HNYLUP              YES       YES
      ** Time of last update          HNTLUP              YES       YES
      ** Type of last change          HNCHTP              YES       YES
      ** Last change date             HNLCD               YES       YES
      ** Last update user id          HNLUID              YES       YES
      ** Deam associated deal number  HNDMAD--------------------------------
      ** Deam associated deal number  HNDA38   YES
      ** Deam sequence number pc      HNDMSQ--------------------------------
      ** Deam sequence number 38      HNDS38   YES
      ** Currency code                HNCCY    YES
      ** Currency decimal places      HNCYDP   YES
      ** Deal value date - yyyy       HNVDYY              YES
      ** Deal value date - mm         HNVDMM              YES
      ** Deal value date - dd         HNVDDD              YES
      ** Deal transaction date - yyyy HNDTYY              YES
      ** Deal transaction date - mm   HNDTMM              YES
      ** Deal transaction date - dd   HNDTDD              YES
      ** Deal deleted indicator       HNDDLT              YES
      ** Deal status indicator        HNDSTS              YES
      ** MIDAS deal type              HNMTYP   YES
      ** Deal type                    HNTYPE              YES
      ** Deam deal date - yyyy        HNDMDY              YES
      ** Deam deal date - mm          HNDMDM              YES
      ** Deam deal date -dd           HNDMDD              YES
      ** Amount                       HNAMNP   YES        YES
      ** Interest rate                HNINTR   YES
      ** Deal our receive method      HNDORM              YES       YES
      ** Deal midas our receve method HNORCM              YES       YES
      ** Deal our receive instructns  HNDORI              YES       YES
      ** Deal midas our receive instr HNMORI              YES       YES
      ** Deal customer payment instr  HNDCPI              YES       YES
      ** Deal midas cust payment inst HNMCPI              YES       YES
      ** Deal our payment method      HNDOPM              YES       YES
      ** Deal midas our payment meth. HNMOPM              YES       YES
      ** Deal our payment instructns  HNDOPI              YES       YES
      ** Deal midas our payment instr HNMOPI              YES       YES
      ** Deal customer receive instr  HNDCRI              YES       YES
      ** Deal Customer Receive Instru HNMCRI              YES       YES
      ** Deal for A/C of              HNDFAC              YES       YES
      ** Deal midas ''FOR A/C OF''    HNMFAO              YES       YES
      ** Deal special instructions    HNSPEC              YES       YES
      ** Deam original deal type      HNOGDT              YES
      ** Original deal sub type       HNOSTP              YES
      ** Deam original deal rbs ind   HNORBS--------------------------------
      ** Dm midas original deal type  HNOMDT              YES
      ** Customer number              HNCNUM   YES
      ** Customer short name          HNCSNM   YES
      ** Deal pc transation number    HNPCTN--------------------------------
      ** Confirm/delete reply         HNCDRP--------------------------------
      ** Deal last action             HNLACT              YES
      ** Time of input                HNTIME              YES
      ** Deal user code               HNDUSC              YES
      ** Deal authorisation officer   HNAOFR              YES
      ** Deal action date             HNLDAT              YES
      ** receipt - settlement method  HNRSTM   YES*                 YES
      ** receipt - our nostro         HNRONS   YES*                 YES
      ** receipt - intermediary bank  HNRIBN   YES*                 YES
      ** receipt - intermediary bank  HNRIBA   YES*                 YES
      ** receipt - ordering bank no   HNROBN   YES*                 YES
      ** receipt - ordering customer  HNROCN   YES*                 YES
      ** pay - settlement method      HNPSTM   YES*                 YES
      ** pay - our nostro             HNPONS   YES*                 YES
      ** pay - intermediary bank no   HNPIBN   YES*                 YES
      ** pay - intermediary bank a/c  HNPIBA   YES*                 YES
      ** pay - ordering bank no       HNPOBN   YES*                 YES
      ** pay - ordering customer no   HNPOCN   YES*                 YES
      ** receiver correspondent no    HNRCRN   YES*                 YES
      ** receiver correspondent a/c l HNRCRA   YES*                 YES
      ** Receiver number              HNRVNO   YES*                 YES
      ** a/c with bank no             HNAWBN   YES*                 YES
      ** a/c with bank a/c line       HNAWBA   YES*                 YES
      ** beneficiary no               HNBENN   YES*                 YES
      ** beneficiary a/c line         HNBENA   YES*                 YES
      ** DETAILS OF PAY 1             HNDTP1   YES*                 YES
      ** DETAILS OF PAY 2             HNDTP2   YES*                 YES
      ** DETAILS OF PAY 3             HNDTP3   YES*                 YES
      ** DETAILS OF PAY 4             HNDTP4   YES*                 YES
      ** details of charges           HNDCHG   YES*                 YES
      ** bank to bank info 1          HNBTB1   YES*                 YES
      ** bank to bank info 2          HNBTB2   YES*                 YES
      ** bank to bank info 3          HNBTB3   YES*                 YES
      ** bank to bank info 4          HNBTB4   YES*                 YES
      ** bank to bank 5               HNBTB5   YES*                 YES
      ** bank to bank 6               HNBTB6   YES*                 YES
      ** Our settlement branch        HNOSBR   YES*
      ** COVER MESSAGE REQUIRED       HNCVMR   YES*
      ** Branch Code - Alpha          HNBRCA              YES
      ** Funding Spread/Rate          HNFSRP   YES
      ** Interest Rate Change Flag    HNIRCF   YES
      ** Funding Rate Change Flag     HNFRCF   YES
      ** Settlement Currency          HNSTCY   YES*                 YES
      ** In Currency in Field 72      HNIC72   YES*                 YES
      ** Front Office Transaction Id  HNFRNT   YES                  YES         CAP013
      ** Assoc Front Office Trans Id  HNAFRT   YES                  YES         CAP013
      ** Deal Repair Location         HNREPA   YES
      ** Automatic Authorisation      HNAUTH   NO                               CAP051
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** CTDATA XOT - XML Opening Tags for the Compliance Engine.                                   CSD015
<Receipt Our Nostro>                                                                          CSD015
<Receipt Inter. Bank>                                                                         CSD015
<Receipt Ordering Bank>                                                                       CSD015
<Receipt Ord. Customer>                                                                       CSD015
<Payment Our Nostro>                                                                          CSD015
<Payment Inter. Bank>                                                                         CSD015
<Payment Ord. Bank>                                                                           CSD015
<Payment Ord. Customer>                                                                       CSD015
<Payment Rec. Corr.>                                                                          CSD015
<Payment Recipient>                                                                           CSD015
<Payment Acc. with Bank>                                                                      CSD015
<Payment Beneficiary>                                                                         CSD015
<Payment Details>                                                                             CSD015
** CTDATA XCT - XML Closing Tags for the Compliance Engine.                                   CSD015
</Receipt Our Nostro>                                                                         CSD015
</Receipt Inter. Bank>                                                                        CSD015
</Receipt Ordering Bank>                                                                      CSD015
</Receipt Ord. Customer>                                                                      CSD015
</Payment Our Nostro>                                                                         CSD015
</Payment Inter. Bank>                                                                        CSD015
</Payment Ord. Bank>                                                                          CSD015
</Payment Ord. Customer>                                                                      CSD015
</Payment Rec. Corr.>                                                                         CSD015
</Payment Recipient>                                                                          CSD015
</Payment Acc. with Bank>                                                                     CSD015
</Payment Beneficiary>                                                                        CSD015
</Payment Details>                                                                            CSD015
