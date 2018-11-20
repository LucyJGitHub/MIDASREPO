     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs Purchased MM Database Update')            *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMNASPUPM - NAS PURCHASED MM DATABASE UPDATE                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 AR1044820          Date 17Jul13               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG17482           Date 02Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 BUG7461            Date 14Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9711            Date 26Jan06               *
      *                 BUG8504            Date 15Sep05               *
      *                 CAS009             Date 04May04               *
      *                 CAP086             Date 08Jun05               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 NAD002             Date 26Mar04               *
      *                 CRE020             Date 20Jan04               *
      *                 TDA012             Date 18Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 04Jul03               *
      *                 CDE005             Date 20Aug02               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CSD015             Date 14Oct02               *
      *                 CDL010             Date 02Aug02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 08Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001             Date 13Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP013             Date 07Sep99               *
      *                 168345             Date 13Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP006             Date 11Mar99               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR1044820 - Incorrect projected movements for Adjustment to  *
      *              Accrued Interest. Added parameters BeDealsDtlC,  *
      *              AfDealsDtlC, and CALLER for AOOUMMU0.            *
      *              Parameter mismatch occurred when AOOUMMU0 is     *
      *              called and user is unable to insert a NA's       *
      *              Purchased. Added parameters PFPAYF and PFRECF    *
      *              for AOOUMMU0 and do not set PARM RetCodeOut to   *
      *              blanks for MMNASPRTV.                            *
      *              (Child: AR1044821)                               *
      *  CER049 - Stamp Tax                                           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17482 - Serious midas error on reject and authorise       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  BUG7461 - Authorising Officer shown as QUS                   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9711- Changes to MMVNASPPD/MMVNASSPD (re-compile)         *
      *  BUG8504- Set Change Type(CHTP) to I during Insert mode       *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  NAD002 - 10-Digit Account Code Errors                        *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  TDA012 - Fix 10-digit account code processing.               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - For INSERT mode, do not check change in timestamp.  *
      *  CDE005 - Data Export - Reservation ID                        *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.                                     *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  200400 - Reverse fix 179510 and replace it with a new fix.   *
      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
      *           Midas  Our  Receive/ Pay  Instructions  respectively*
      *           not  correctly  updated .  Introduced  new parametrs*
      *           when  calling   ZAALTRECIN/ PAYIN  modules .        *
      *  CDE001 - Data Export - CCRM Limits                           *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  168345 - Prevent two users from accessing same transaction   *
      *           in repair screen at the same cycle, and converting  *
      *           it into two different Midas Deal No.s  .            *
      *           Second user should not be allowed to repair the tran-
      *           saction and convert it into a  another Midas Deal . *
      *  CAP006 - Check for deal being updated by another workstation *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FMMDEAULL  UF A E           K DISK
     F                                     COMMIT
     F                                     INCLUDE(MMDENBP0: MMDENSP0)
                                                                                              CSD015
      ** Compliance Watch Hit List                                                            CSD015
     FSDCWHTL1  IF   E           K DISK    INFSR(SRERR)                                       CSD015
                                                                                              CSD015
     FREADVCL1  UF   E           K DISK    INFSR(SRERR)                                       CRE020
     F                                     USROPN                                             CRE020
      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref                            CRE020
                                                                                              CRE020
     FMMEIRDL9  UF   E           K DISK                                                       CAS009
     F                                     COMMIT                                             CAS009
                                                                                              CAS009
     F/COPY WNCPYSRC,MMNASPMF01
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
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR DEAL
     D MMVNAP        E DS                  EXTNAME(MMVNASPPD)
     D  @IHCTL                 1     23
     D  @IHDAN                36     41  0
     D  @IHVDY                50     57  0
     D  @IHTDY                58     65  0
     D  @IHDDY               111    118  0
     D  @IHNIY               179    186  0
     D  @IHSLY               223    230  0
     D  @IHIAY               257    264  0
     D  @IHMDY               265    272  0
     D  @IHALR               285    335
     D  @IHALP               336    441
     D  @IHREC               463    531
     D  @IHPAY               532   1090
     D**@IHALREx            1245   1280                                                CGL029 TDA012
     D**@IHALPEx            1281   1316                                                CGL029 TDA012
     D**@IHRECEx            1317   1334                                                CGL029 TDA012
     D**@IHPAYEx            1335   1352                                                CGL029 TDA012
     D**@IHALREx            1260   1295                                                TDA012 NAD002
     D**@IHALPEx            1296   1331                                                TDA012 NAD002
     D**@IHRECEx            1332   1349                                                TDA012 NAD002
     D**@IHPAYEx            1350   1367                                                TDA012 NAD002
 
     D/COPY WNCPYSRC,MMNASPMD01
      **  DEALS FILE - NEGOTIABLE ASSETS PURCHASED
     D MMDENB        E DS                  EXTNAME(MMDENBPP)
     D QQDOR1        E                     EXTFLD(DORIQQ)                                     CGL029
     D QQMOR1        E                     EXTFLD(MORIQQ)                                     CGL029
     D QQDOP1        E                     EXTFLD(DOPIQQ)                                     CGL029
     D QQMOP1        E                     EXTFLD(MOPIQQ)                                     CGL029
     D QQRON1        E                     EXTFLD(RONSQQ)                                     CGL029
     D QQPON1        E                     EXTFLD(PONSQQ)                                     CGL029
     D  @HLCTL                 1     23
     D  @HLNIY               179    186  0
     D  @HLALR               285    335
     D  @HLALP               336    441
     D  @HLREC               463    531
     D  @HLPAY               532   1090
     D**@HLALREx            1245   1280                                                CGL029 TDA012
     D**@HLALPEx            1281   1316                                                CGL029 TDA012
     D**@HLRECEx            1317   1334                                                CGL029 TDA012
     D**@HLPAYEx            1335   1352                                                CGL029 TDA012
     D**@HLALREx            1260   1295                                                TDA012 NAD002
     D**@HLALPEx            1296   1331                                                TDA012 NAD002
     D**@HLRECEx            1332   1349                                                TDA012 NAD002
     D**@HLPAYEx            1350   1367                                                TDA012 NAD002
 
      **  DEALS FILE - NEGOTIABLE ASSETS SOLD
     D MMDENS        E DS                  EXTNAME(MMDENSPP)
     D QQDOR2        E                     EXTFLD(DORIQQ)                                     CGL029
     D QQMOR2        E                     EXTFLD(MORIQQ)                                     CGL029
     D QQRON2        E                     EXTFLD(RONSQQ)                                     CGL029
     D QQPON2        E                     EXTFLD(PONSQQ)                                     CGL029
     D  @HMNIY               152    159  0
 
     D ChkDealFmt    E DS                  EXTNAME(MMDENBPP)                    CAP006
      ** Rename fields for Timestamp checking                                   CAP006
     D                                     PREFIX(CH)                           CAP006
                                                                                CAP006
     D MMENAP        E DS                  EXTNAME(MMENASPPD)                   CAP006
      * Error indicators                                                        CAP006
                                                                                CAP006
      **  EXTERNALLY DESCRIBED DATA STRUCTURES FOR TEMPLATE FILES FOR
      **  PROJECTED ACCOUNT MOVEMENTS UPDATES
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)
     D DLDLQD        E DS                  EXTNAME(DLSTMPPD)                                  CER049
 
 
      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      * DATA STRUCTURE FOR DEAL DATA CODES
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * DATA STRUCTURE FOR MODULE DETAILS
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status dataarea                                                                 CSC011
                                                                                              CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
      ** Midas API Message Header Format Definition                                           CSC011
                                                                                              CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
     D                                     PREFIX(S_)                                         CSC011
      ** External DS for SAR Details                                                          CSC011
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
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
      ** Compliance Watch Configuration Data DS                                               CSD015
                                                                                              CSD015
     D WLFBC         E DS                  EXTNAME(MMDEALLL:MMDENBP0)                         CSD015
     D                                     PREFIX(BC:2)                                       CSD015
      ** Backup Container of the Watch List Fields                                            CSD015
     D  BCMORIQQ     E                     EXTFLD(MORIQQ)                                     CGL029
     D  BCMOPIQQ     E                     EXTFLD(MOPIQQ)                                     CGL029
     D  BCPONSQQ     E                     EXTFLD(PONSQQ)                                     CGL029
                                                                                              CSD015
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSD015
      * Long DS for Access Programs                                                           CSD015
                                                                                              CSD015
      * RUN DATE & MULTI-BRANCHING INDICATOR
 
     D RUNDAT          DS
     D  @DLUP                  1      2  0
     D  @MLUP                  3      5
     D  @YLUP                  6      7  0
     D  @MBIN                 13     13
                                                                                CAP006
      ** Working Date Data Structure                                                          CSD015
     D WDATE           DS                                                                     CSD015
     D  WLongYr                1      4  0                                                    CSD015
     D  WShortYr               3      4  0                                                    CSD015
     D  WMonth                 5      6  0                                                    CSD015
     D  WDay                   7      8  0                                                    CSD015
                                                                                              CSD015
      ** ZDATE Data Structure                                                                 CSD015
     D ZDATE           DS                                                                     CSD015
     D  PZDate                 1      6  0                                                    CSD015
     D  PZDay                  1      2  0                                                    CSD015
     D  PZMonth                3      4  0                                                    CSD015
     D  PZYear                 5      6  0                                                    CSD015
                                                                                              CSD015
     D ZMUSER        E DS                  EXTNAME(ZMUSER)                                   BUG7461
                                                                                             BUG7461
      ** Dummy message ID and message file fields for use on the calls to       CAP006
      ** ZAMSGTOOPR                                                             CAP006
     D DummyMsgID      S                   LIKE(#MsgID)                         CAP006
     D DummyMsgF       S             10A                                        CAP006
                                                                                              CSD015
      ** Max. no. of elements associated with the CE arrays.                                  CSD015
     D ArrMax          C                   CONST(13)                                          CSD015
                                                                                              CSD015
      ** XML Opening Tags for the Compliance Engine.                                          CSD015
     D XOT             S             25A   DIM(ArrMax) PERRCD(1) CTDATA                       CSD015
                                                                                              CSD015
      ** XML Closing Tags for the Compliance Engine.                                          CSD015
     D XCT             S             25A   DIM(ArrMax) PERRCD(1) CTDATA                       CSD015
                                                                                              CSD015
      ** Watch List Fields Array.                                                             CSD015
     D WLF             S             35A   DIM(ArrMax)                                        CSD015
                                                                                              CSD015
      ** Watch List Fields Standing Data Array.                                               CSD015
     D WLFSD           S             35A   DIM(ArrMax)                                        CSD015
                                                                                              CSD015
     D CSC011          S              1A   INZ('N')                                           CSC011
                                                                                              CAP086
     D CAP086          S              1A   INZ('N')                                           CAP086
      ** Auto Authorisation flag                                                              CAP086
                                                                                              CAP086
     D PTimestamp      S             26A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
     D WDealNo         S              6A                                                      CSC011
     D***PDealNo         S             18A                                             CSC011 CGL029
     D***PADealNo        S             18A                                             CSC011 CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PCustNo         S             10A                                                      CSD015
     D PErrInf         S              7A                                                      CSD015
                                                                                              CSC011
      ** Define fields used in CAS001                                                         CAS001
                                                                                              CAS001
     D CAS001          S              1A                                                      CAS001
                                                                                              CAS001
      ** Index for arrays of of warning message ids etc                                       CAS004
     D WIdx            S              3P 0                                                    CAS004
                                                                                              CAS004
      ** Define fields used in CDL010                                                         CDL010
     D CDL010          S              1A                                                      CDL010
                                                                                              CDL010
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
     D POutA           S              6                                                       CSD015
                                                                                              CSD015
      ** ZDATE1 Parameters                                                                    CSD015
     D PZDateIn        S              6                                                       CSD015
     D PZDayNo         S              5  0                                                    CSD015
     D PZDateFmt       S              1                                                       CSD015
     D PZRtCd          S              1                                                       CSD015
                                                                                              CSD015
      ** ZACVTDATE Parameters                                                                 CSD015
     D PZADayNo        S              5                                                       CSD015
     D PZADDT          S               D                                                      CSD015
     D PZACvtDate      S             10                                                       CSD015
                                                                                              CSD015
      ** ZACVTAMT Parameters                                                                  CSD015
     D PZARtCd         S             10                                                       CSD015
     D PZACcy          S              3                                                       CSD015
     D PZANtvAmt       S             15                                                       CSD015
     D PZAAmt          S             18  3                                                    CSD015
     D PZACvtAmt       S             16                                                       CSD015
                                                                                              CSD015
      ** Working Variables                                                                    CSD015
     D Ctr             S              2  0                                                    CSD015
     D WData           S            216                                                       CSD015
     D WXMLPacket      S            400                                                       CSD015
     D WMoveMode       S              1                                                       CSD015
     D WCompMode       S              1                                                       CSD015
     D WChgFlg         S              1                                                       CSD015
     D WOKFlg          S              1                                                       CSD015
     D WRetryFlg       S              1                                                       CSD015
     D WCtrpRpt        S             30                                                       CSD015
     D WCtrpTyp        S              1                                                       CSD015
     D WDDT            S               D                                                      CSD015
     D WAMT            S             18  3                                                    CSD015
     D WCcy            S              3                                                       CSD015
     D ##DOPI          S             18                                                       CGL029
     D ##DORI          S             18                                                       CGL029
     D ##MOPI          S             18                                                       CGL029
     D ##MORI          S             18                                                       CGL029
     D ##PONS          S             18                                                       CGL029
     D ##RONS          S             18                                                       CGL029
     D T#TREF          S             26                                                       CGL029
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
      ** Define fields used in CAS005                                                         CAS005
                                                                                              CAS005
     D CAS005          S              1A                                                      CAS005
                                                                                              CAS005
      ** Define fields used in CRE020                                                         CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KPrgMn          S             10A   INZ('MMNASPUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('NAsPurchased        ')                        CRE020
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
     D CAS009          S              1A                                                      CAS009
                                                                                              CAS009
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
      *                                                                                    AR1044820
      ** File - Payment Further Settlement Instructions                                    AR1044820
      *                                                                                    AR1044820
     D PFPAYF        E DS                  EXTNAME(SDFSFPPD)                               AR1044820
      *                                                                                    AR1044820
      ** File - Receive Further Settlement Instructions                                    AR1044820
      *                                                                                    AR1044820
     D PFRECF        E DS                  EXTNAME(SDFSFRPD)                               AR1044820
      /EJECT                                                                                  CSD015
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
     C     CAP051        IFEQ      'Y'                                                      BUG17482
     C     IHAUTH        ANDEQ     'Y'                                                      BUG17482
     C                   MOVE      'N'           BNMMAU                                     BUG17482
     C                   MOVE      'N'           BNMMRA                                     BUG17482
     C                   ELSE                                                               BUG17482
     C                   MOVE      SAVMMAU       BNMMAU                                     BUG17482
     C                   MOVE      SAVMMRA       BNMMRA                                     BUG17482
     C                   ENDIF                                                              BUG17482
      *
      * SET CONTROL FIELDS
      *
     C                   EXSR      SETCTL
      *
     C/COPY WNCPYSRC,MMNASPMC04
      ** Ensure transaction has not been updated by another workstation         CAP006
      ** - if so, bypass updating and return to calling program.                CAP006
     C                   EXSR      CHKOTHUPD                                    CAP006
                                                                                CAP006
     C     @@RTCD        IFNE      *BLANKS                                      CAP006
     C                   GOTO      EXIT                                         CAP006
     C                   END                                                    CAP006
                                                                                CAP006
      * DO INSERT, AMEND, AUTHORIZE OR DELETE PROCESSING
      *
     C     IHLACT        CASEQ     'I'           INSERT
     C     IHLACT        CASEQ     'A'           AMEND
     C     IHLACT        CASEQ     'X'           AUTHOR
     C     IHLACT        CASEQ     'D'           DELETE
     C                   END
     C/COPY WNCPYSRC,MMNASPMC06
      *
      ** DO ON-LINE UPDATES
      *
     C     IHLACT        IFEQ      'I'
     C     IHLACT        OREQ      'A'
     C     IHLACT        OREQ      'D'
     C                   EXSR      ONLNUP
     C                   END
      *
      *
      ** DO TREASURY MANAGEMENT UPDATES
      *
     C     BGTRMG        IFEQ      'Y'
     C     IHLACT        IFEQ      'I'
     C     IHLACT        OREQ      'A'
     C     IHLACT        OREQ      'D'
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
     C                   CALLB     'MMNASPLOG'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    IHLACT                                       CSC011
     C                   PARM                    MMVNAP                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** Write to support database log file                                                   CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *BLANKS                                       CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'MMNASP'                                       CSC011
     C                   EVAL      APUSERID = PSUser                                          CSC011
     C                   EVAL      APRPRLOCN = IHREPA                                         CSC011
     C                   MOVEL     IHFRNT        APFOTRANID                                   CSC011
     C                   MOVEL     IHAFRT        APFOASOCID                                   CSC011
     C                   MOVEL     IHDN38        PDealNo                                      CSC011
     C                   MOVEL     IHDADN        PADealNo                                     CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       PTimestamp                                   CSC011
     C                   PARM                    PDealNo                                      CSC011
     C                   PARM                    PADealNo                                     CSC011
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
     C/COPY WNCPYSRC,MMNASPMC01
     C*****************************************************************
     C*                                                               *
     C* INSERT - Negotiable Assets Purchased Inserts                  *
     C*                                                               *
     C*****************************************************************
     C     INSERT        BEGSR
     C*
     C**  SET DEAL FIELDS ON INSERT
     C*
     C                   EXSR      SETINS
     C*
     C**  ACCESS DEAL
     C*
     C                   CLEAR                   MMDENB
     C     IHDN38        CHAIN     MMDENBP0                           99
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     MMDENB        Z#BSTS
     C                   MOVEL     MMDENB        WLFBC                                        CSD015
     C*
     C**  UPDATE DEAL
     C*
     C                   MOVEL     MMVNAP        MMDENB
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      HLTMST  = TimeStamp                          CAP006
                                                                                CAP006
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        HLFRNT = *BLANKS                                           CSC011
     C                   MOVE      HLDN38        WDealNo                                      CSC011
     C                   EVAL      HLFRNT = 'MD' + WDealNo                                    CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EXSR      USRUPD                                                     CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C*  WRITE (OR UPDATE IF PRESENT) NEW DEAL
     C*
     C     *IN99         IFEQ      '0'
                                                                                              CSD015
      ** If Compliance Watch is enabled, check the new or updated                             CSD015
      ** transactions for compliance.                                                         CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' AND                                           CSD015
     C                             W1EWLC = 'Y'                                               CSD015
                                                                                              CSD015
     C                   IF        CSC011 <> 'Y' OR                                           CSD015
     C                             (CSC011 = 'Y' AND                                          CSD015
     C                             S1MAIN = LIBR)                                             CSD015
     C                   EVAL      WCompMode = OnAmend                                        CSD015
     C                   EXSR      SRCompChk                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y' AND                                           CAP086
     C                             IHAUTH = 'Y'                                               CAP086
     C                   EVAL      HLAUTH = IHAUTH                                            CAP086
     C                   EVAL      HLDSTS = 'A'                                               CAP086
     C                   ENDIF                                                                CAP086
     C                   IF        CAP051 = 'Y'                                             BUG17482
     C                   EVAL      HLAUTH = IHAUTH                                          BUG17482
     C                   ENDIF                                                              BUG17482
                                                                                              CAP086
     C                   UPDATE    MMDENBP0
     C                   ELSE
     C/COPY WNCPYSRC,MMNASPMC05
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' AND                                           CSD015
     C                             W1EWLC = 'Y'                                               CSD015
                                                                                              CSD015
     C                   IF        CSC011 <> 'Y' OR                                           CSD015
     C                             (CSC011 = 'Y' AND                                          CSD015
     C                             S1MAIN = LIBR)                                             CSD015
     C                   EVAL      WCompMode = OnInsert                                       CSD015
     C                   EXSR      SRCompChk                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y' AND                                           CAP086
     C                             IHAUTH = 'Y'                                               CAP086
     C                   EVAL      HLAUTH = IHAUTH                                            CAP086
     C                   EVAL      HLDSTS = 'A'                                               CAP086
     C                   ENDIF                                                                CAP086
     C                   IF        CAP051 = 'Y'                                             BUG17482
     C                   EVAL      HLAUTH = IHAUTH                                          BUG17482
     C                   ENDIF                                                              BUG17482
                                                                                              CAP086
     C                   WRITE     MMDENBP0
     C                   END
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     MMDENB        Z#ASTS
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* AMEND - Negotiable Assets Purchased Amends                    *
     C*                                                               *
     C*****************************************************************
     C     AMEND         BEGSR
     C*
     C**  ACCESS DEAL
     C*
     C     IHDN38        CHAIN     MMDENBP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     IHDN38        DBKEY
     C                   MOVEL     'MMDENBP0'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
      *                                                                                       CAS009
      * Set EIR Recalculation Indicator to 'Y' when interest payment is changed               CAS009
      * and deal is found in MMEIRDPD.                                                        CAS009
      *                                                                                       CAS009
     C                   IF        CAS009 = 'Y'                                               CAS009
      *                                                                                       CAS009
     C                   IF        IHIPFQ <> HLIPFQ                                           CAS009
     C                             OR IHNIPD <> HLNIPD                                        CAS009
     C                             OR IHIPDM <> HLIPDM                                        CAS009
      *                                                                                       CAS009
     C     IHDN38        CHAIN     MMEIRDL9                                                   CAS009
     C                   IF        %FOUND(MMEIRDL9)                                           CAS009
     C                   EVAL      EIRCAL = 'Y'                                               CAS009
     C                   UPDATE    MMEIRDD0                                                   CAS009
     C                   ENDIF                                                                CAS009
      *                                                                                       CAS009
     C                   ENDIF                                                                CAS009
      *                                                                                       CAS009
     C                   ENDIF                                                                CAS009
      *                                                                                       CAS009
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     MMDENB        Z#BSTS
     C                   MOVEL     MMDENB        WLFBC                                        CSD015
     C/COPY WNCPYSRC,MMNASPMC07
     C*
     C**  SET DEAL FIELDS ON AMEND
     C*
     C                   EXSR      SETAMD
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      HLTMST  = TimeStamp                          CAP006
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
     C                   EXSR      SRCompChk                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C**  UPDATE RECORD
     C*
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EXSR      USRUPD                                                     CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y' AND                                           CAP086
     C                             IHAUTH = 'Y'                                               CAP086
     C                   EVAL      HLAUTH = IHAUTH                                            CAP086
     C                   EVAL      HLDSTS = 'A'                                               CAP086
     C                   ENDIF                                                                CAP086
     C                   IF        CAP051 = 'Y'                                             BUG17482
     C                   EVAL      HLAUTH = IHAUTH                                          BUG17482
     C                   ENDIF                                                              BUG17482
                                                                                              CAP086
     C                   UPDATE    MMDENBP0
     C*
     C**  UPDATE VALID DEAL
     C*
     C                   MOVEL     MMDENB        MMVNAP
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     MMDENB        Z#ASTS
     C*
     C**  IF RELATED NA SOLD IS PRESENT, ACCESS IT
     C*
     C     IHDADN        IFNE      *BLANK
     C     IHDADN        ANDNE     *ZEROS
     C*
     C     @IHDAN        CHAIN     MMDENSP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     @IHDAN        DBKEY
     C                   MOVEL     'MMDENSP0'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C**  UPDATE CHANGED DETAILS ON NA SOLD
     C*
     C                   MOVEL     HLBRCA        HMBRCA
     C                   MOVEL     HLDBRC        HMDBRC
     C                   MOVEL     HLCDRF        HMCDRF
     C                   Z-ADD     @HLNIY        @HMNIY
     C                   MOVEL     HLIPFQ        HMIPFQ
     C                   Z-ADD     HLIPDM        HMIPDM
     C                   MOVEL     HLISUR        HMISUR
     C                   Z-ADD     HLNIPD        HMNIPD
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
     C                   EVAL      HMTMST  = TimeStamp                          CAP006
                                                                                CAP006
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EXSR      USRUPDS                                                    CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C                   UPDATE    MMDENSP0
     C*
     C**  SAVE NA SOLD DETAILS
     C*
     C                   MOVEL     MMDENS        Z#WSTS
     C                   END
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* AUTHOR - Negotiable Assets Purchased Authorize                *
     C*                                                               *
     C*****************************************************************
     C     AUTHOR        BEGSR
     C*
     C**  ACCESS DEAL
     C*
     C     IHDN38        CHAIN     MMDENBP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     IHDN38        DBKEY
     C                   MOVEL     'MMDENBP0'    DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 003*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     MMDENB        Z#BSTS
     C*
     C**  SET DEAL FIELDS ON AUTHORIZE
     C*
     C                   EXSR      SETAUT
     C/COPY WNCPYSRC,MMH00139
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      HLTMST  = TimeStamp                          CAP006
     C/COPY WNCPYSRC,MMNASPMC09
                                                                                CAP006
     C**  UPDATE RECORD
     C*
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EVAL      IHUSER = USRID                                            BUG7461
     C                   EXSR      USRUPD                                                     CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C                   UPDATE    MMDENBP0
     C*
     C**  UPDATE VALID DEAL
     C*
     C                   MOVEL     MMDENB        MMVNAP
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     MMDENB        Z#ASTS
     C*
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
     C     IHUSER        IFEQ      *BLANKS                                                    CDL010
     C                   EVAL      HLUSER = PSuser                                            CDL010
     C                   ELSE                                                                 CDL010
     C                   EVAL      HLUSER = IHUSER                                            CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C                   ENDSR                                                                CDL010
     C****************************************************************                        CDL010
      /EJECT                                                                                  CDL010
     C****************************************************************                        CDL010
     C*                                                              *                        CDL010
     C* USRUPDS   - Update the Last Amend/Insert User field .        *                        CDL010
     C*                                                              *                        CDL010
     C****************************************************************                        CDL010
     C     USRUPDS       BEGSR                                                                CDL010
      *                                                                                       CDL010
      **  Update User Details                                                                 CDL010
      *                                                                                       CDL010
     C     IHUSER        IFEQ      *BLANKS                                                    CDL010
     C                   EVAL      HMUSER = PSuser                                            CDL010
     C                   ELSE                                                                 CDL010
     C                   EVAL      HMUSER = IHUSER                                            CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C                   ENDSR                                                                CDL010
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* DELETE - Negotiable Assets Purchased Deletes                  *
     C*                                                               *
     C*****************************************************************
     C     DELETE        BEGSR
     C*
     C**  ACCESS DEAL
     C*
     C     IHDN38        CHAIN     MMDENBP0                           99
     C*
     C**  DATA BASE ERROR IF NOT FOUND
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     IHDN38        DBKEY
     C                   MOVEL     'MMDENBP0'    DBFILE                         ************
     C                   MOVEL     '004'         DBASE                          * DBERR 004*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     MMDENB        Z#BSTS
     C*
     C**  SET DEAL FIELDS ON DELETE
     C*
     C                   EXSR      SETDEL
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      HLTMST  = TimeStamp                          CAP006
                                                                                CAP006
     C**  UPDATE RECORD
     C*
     C                   UPDATE    MMDENBP0
     C*
     C**  UPDATE VALID DEAL
     C*
     C                   MOVEL     MMDENB        MMVNAP
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     MMDENB        Z#ASTS
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SETINS - SET DEAL FIELDS ON INSERT                            *
     C*                                                               *
     C*****************************************************************
     C     SETINS        BEGSR
      **
      ** Deal value date - yyyy       IHVDYY
      ** Deal value date - mm         IHVDMM
      ** Deal value date - dd         IHVDDD
      **  CONVERT VALUE DATE FROM DAY NUMBER TO YMD
      *
     C                   Z-ADD     IHDVSD        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IHVDY
      **
      ** Deal transaction date - yyyy IHDTYY
      ** Deal transaction date - mm   IHDTMM
      ** Deal transaction date - dd   IHDTDD
      **  CONVERT RUN DATE FROM DAY NUMBER TO YMD
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IHTDY
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
     C                   MOVEL     @@FSTS        IHDSTS
                                                                                             BUG8504
     C                   IF        CAP086 = 'Y' AND                                          BUG8504
     C                             IHAUTH = 'Y'                                              BUG8504
     C                   EVAL      IHCHTP = 'I'                                              BUG8504
     C                   ELSE                                                                BUG8504
     C                   MOVEL     @@CHTP        IHCHTP
     C                   ENDIF                                                               BUG8504
      **
      ** MIDAS deal type
      **
     C                   MOVEL     IHTYPE        IHMTYP
      **
      ** Rollover/bought/sold indic
      **
     C                   MOVEL     'B'           IHRBSI
      **
      ** Deal type (OLD DRS DEAL TYPE)
      **
     C     IHMTYP        IFEQ      'C1'
     C     IHMTYP        OREQ      'C2'
     C     IHMTYP        OREQ      'TB'
     C     IHMTYP        OREQ      'TA'
     C                   MOVE      IHMTYP        IHTYPE
     C                   END
     C     IHMTYP        IFEQ      'BP'
     C                   MOVE      'BO'          IHTYPE
     C                   END
     C     IHMTYP        IFEQ      'BD'
     C                   MOVE      'BI'          IHTYPE
     C                   END
     C     IHMTYP        IFEQ      'DA'
     C                   MOVE      'BA'          IHTYPE
     C                   END
      *
      ** FOR DISCOUNTED NEGOTIABLE ASSETS, I.E. NO YIELD INPUT
      ** CALCULATE THE YIELD
      *
     C     IHMTYP        IFNE      'C1'
     C     IHINTR        ANDEQ     0
     C                   EXSR      CALYLD
     C                   Z-ADD     @@YLD         IHINTR
     C                   END
      **
      ** Deal done date - yyyy        IHDDYY
      ** Deal done date - mm          IHDDMM
      ** Deal done date - dd          IHDDDD
      **
     C                   Z-ADD     IHDDND        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IHDDY
      **
      ** Time of input
      **
     C                   TIME                    IHTIME
      **
      ** Deal user code
      **
     C                   MOVEL     PSUser        IHDUSC
      **
      ** Deal authorisation officer
      **
     C     @@FSTS        IFEQ      'A'
     C                   MOVEL     PSUser        IHAOFR
     C                   END
      **
      ** Deal action date
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          IHLDAT
      **
      ** Start/last interst year date IHSLYY
      ** Start/last interst mnth date IHSLMM
      ** Start/last interest day date IHSLDD
      **  CONVERT START/LAST INT PAY DATE FROM DAY NUMBER TO YMD
      **  (DEFAULT FIRST TO VALUE DATE IF DEAL IS PRIMARY CD)
      **
     C     IHMTYP        IFEQ      'C1'                                     4177
     C                   Z-ADD     IHDVSD        IHSLID
     C                   END
      *
     C     IHSLID        IFNE      *ZERO
     C                   Z-ADD     IHSLID        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IHSLY
     C                   ELSE
     C                   Z-ADD     *ZERO         @IHSLY
     C                   END
      **
      ** Nxt intrst pay year date     IHNIYY
      ** Nxt intrst paym mth date     IHNIMM
      ** Next int payment day date    IHNIDD
      **  CONVERT NEXT INT PAY DATE FROM DAY NUMBER TO YMD
      *
     C     IHNIPD        IFNE      *ZERO
     C                   Z-ADD     IHNIPD        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IHNIY
     C                   ELSE
     C                   Z-ADD     *ZERO         @IHNIY
     C                   END
      *
      **  IF INTEREST BEARING NEGOTIABLE ASSET
      *
     C                   Z-ADD     *ZERO         IHMPIT
     C     IHMTYP        IFEQ      'C1'
     C     IHMTYP        OREQ      'C2'
     C     IHMTYP        OREQ      'BP'
     C     IHMTYP        OREQ      'BD'
      *
      * CALCULATE PURCHASED INTEREST
      *
     C     IHFRAT        IFNE      *ZERO
     C     IHFVAL        ANDNE     *ZERO
     C     IHICMT        ANDNE     *ZERO
     C     IHSLID        ANDNE     *ZERO
     C     IHDVSD        ANDNE     *ZERO
     C                   EXSR      CALPIN
     C                   Z-ADD     @@INTR        IHMPIT
     C                   END
     C                   END
      *
      **  DISCOUNT AMOUNT = FACE VALUE + AMOUNT + PURCHASED INTEREST
      *
     C     IHFVAL        ADD       IHAMNP        IHDCAM
     C                   ADD       IHMPIT        IHDCAM
      *
      ** SOLD INDICATOR
      *
     C     IHDADN        IFNE      *BLANK
     C     IHDADN        ANDNE     *ZEROS
     C                   MOVEL     '2'           IHSOLD
     C                   ELSE
     C     IHSLDB        IFNE      *BLANK
     C                   MOVEL     '1'           IHSOLD
     C                   ELSE
     C                   MOVEL     *BLANK        IHSOLD
     C                   END
     C                   END
      **
      ** Interest accrual contr year  IHIAYY
      ** Intrst accrual contr method  IHIAMM
      ** Intrst accrual contr day     IHIADD
      **  CONVERT VALUE DATE FROM DAY NUMBER TO YMD
     C*
     C                   Z-ADD     IHDVSD        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IHIAY
      **
      ** Maturity date year           IHMDYY
      ** Maturity date month          IHMDMM
      ** Maturity date day            IHMDDD
      **
     C                   Z-ADD     IHMATD        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @IHMDY
      *
      ** Original Purchase Price
     C     IHAMNP        IFLT      0
     C                   Z-SUB     IHAMNP        IHOPUP
     C                   ELSE
     C                   Z-ADD     IHAMNP        IHOPUP
     C                   ENDIF
      ** No. of parcels/assets not sold
     C                   MOVE      IHPSZE        IHNSDD
      *
      **
      ** ALRECI - ALTERNATIVE RECEIVE INSTRUCTIONS
      **
     C                   EXSR      ALRECI
      **
      ** ALPAYI - ALTERNATIVE PAYMENT INSTRUCTIONS
      **
     C                   EXSR      ALPAYI
      **
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
     C                   MOVEL     @IHCTL        @HLCTL
      **
      ** Broker code
      **
     C                   MOVEL     IHBKCD        HLBKCD
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'A'           @@ACTN
     C                   PARM      HLDSTS        @@CSTS
     C                   PARM                    BNMMAU
     C                   PARM                    BNMMRA
     C                   PARM      *BLANK        @@FSTS
     C                   PARM      *BLANK        @@CHTP
     C                   MOVEL     @@FSTS        HLDSTS
     C                   MOVEL     @@CHTP        HLCHTP
      **
      ** Deal subtype
      **
     C                   MOVEL     IHSTYP        HLSTYP
      **
      ** Customer short name
      ** Customer number
      **
     C                   MOVEL     IHCSNM        HLCSNM
     C                   MOVEL     IHCNUM        HLCNUM
      **
      ** Branch code (alpha)
      ** Deal branch code
      **
     C                   MOVEL     IHDBRC        HLBRCA
     C                   MOVEL     IHDBRC        HLDBRC
      **
      ** Deal brokerage
      ** Broker currency code
      ** Broker ccy decimal places
      **
     C                   MOVEL     IHBRKG        HLBRKG
     C                   MOVEL     IHBKCY        HLBKCY
     C                   MOVEL     IHBCDP        HLBCDP
      **
      ** Fed funds indicator
      **
     C                   MOVEL     IHFEDF        HLFEDF
      **
      ** Cd reference  (n.a. ref number)
      **
     C                   MOVEL     IHCDRF        HLCDRF
      **
      ** Deal last action
      **
     C                   MOVEL     'A'           HLLACT
      **
      ** Deal user code
      **
     C                   MOVEL     PSUser        HLDUSC
      **
      ** Deal action date
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          HLLDAT
      **
      ** Nxt intrst pay year date
      ** Nxt intrst paym mth date
      ** Next int payment day date
      **  CONVERT NEXT INT PAY DATE FROM DAY NUMBER TO YMD
      *
     C     IHNIPD        IFNE      *ZERO
     C                   Z-ADD     IHNIPD        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @HLNIY
     C                   ELSE
     C                   Z-ADD     *ZERO         @HLNIY
     C                   END
      **
      ** Interest payment frequency
      **
     C                   MOVEL     IHIPFQ        HLIPFQ
      **
      ** Ldi int payment day in month
      **
     C                   MOVEL     IHIPDM        HLIPDM
      **
      ** Issuer
      ** Issued by customer number
      **
     C                   MOVEL     IHISUR        HLISUR
     C                   MOVEL     IHISCN        HLISCN
      **
      ** Account sequence number
      **
     C                   MOVEL     IHACSQ        HLACSQ
      **
      ** ALRECI - ALTERNATIVE RECEIVE INSTRUCTIONS
      **
     C                   EXSR      ALRECI
     C                   MOVEL     @IHALR        @HLALR
     C                   MOVEL     IHDORI        HLDORI                                       NAD002
     C                   MOVEL     IHMORI        HLMORI                                       NAD002
     C**********         MOVEL     @IHALREx      @HLALREx                              CGL029 NAD002
      **
      ** ALPAYI - ALTERNATIVE PAYMENT INSTRUCTIONS
      **
     C                   EXSR      ALPAYI
     C                   MOVEL     @IHALP        @HLALP
     C                   MOVEL     IHDOPI        HLDOPI                                       NAD002
     C                   MOVEL     IHMOPI        HLMOPI                                       NAD002
     C**********         MOVEL     @IHALPEx      @HLALPEx                              CGL029 NAD002
      **
      ** Book Code
      **
     C                   MOVEL     IHBOKC        HLBOKC
      **
      ** LINKED DEAL NUMBER
      **
     C                   MOVEL     IHLNKN        HLLNKN
      **
      ** Bill Depot Id
      **
     C                   MOVEL     IHBDID        HLBDID
      **
      ** Extended Receipt Instructions
      **
     C                   MOVEL     @IHREC        @HLREC
     C                   MOVEL     IHRONS        HLRONS                                       NAD002
     C**********         MOVEL     @IHRECEx      @HLRECEx                              CGL029 NAD002
      **
      ** Extended Payment Instructions
      **
     C                   MOVEL     @IHPAY        @HLPAY
     C                   MOVEL     IHPONS        HLPONS                                       NAD002
     C**********         MOVEL     @IHPAYEx      @HLPAYEx                              CGL029 NAD002
      **
      ** Originating branch
      **
     C                   MOVEL     IHORBR        HLORBR
      **
      ** Profit centre
      **
     C                   MOVEL     IHPRFC        HLPRFC
      **
      ** Our Pay Branch
      ** Our Receive Branch
      **
     C                   MOVEL     IHPOBR        HLPOBR
     C                   MOVEL     IHROBR        HLROBR
      **
      ** COVER MESSAGE REQUIRED
      **
     C                   MOVEL     IHCVMR        HLCVMR
      **
      ** Funding details
      **
     C                   Z-ADD     IHFSRP        HLFSRP
     C                   MOVE      IHFSGN        HLFSGN
     C                   MOVE      IHFPRC        HLFPRC
      **
      ** EMU Settlement fields
      **
     C                   MOVEL     IHSTCY        HLSTCY
     C                   MOVEL     IHIC72        HLIC72
      **
      ** Next interest payment date
      **
     C                   MOVEL     IHNIPD        HLNIPD
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     IHFRNT        HLFRNT                         CAP013
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C                   MOVEL     IHAFRT        HLAFRT                         CAP013
      *
      ** Yield Curves                                                                         CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y'                                               CAS001
     C                   EVAL      HLOYLC = IHOYLC                                            CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
      ** Liquidity Premuim                                                                    CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      HLLQPR = IHLQPR                                            CAS005
     C                   EVAL      HLLQPS = IHLQPS                                            CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Class                                                                                CDL038
     C                   MOVEL     IHCLAS        HLCLAS                                       CDL038
                                                                                              CDL038
      ** Reference Rate                                                                       CDL049
     C                   MOVEL     IHRRAT        HLRRAT                                       CDL049
                                                                                              CDL049
     C/COPY WNCPYSRC,MMNASPMC02
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
     C                   MOVEL     @IHCTL        @HLCTL
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'X'           @@ACTN
     C                   PARM      HLDSTS        @@CSTS
     C                   PARM                    BNMMAU
     C                   PARM                    BNMMRA
     C                   PARM      *BLANK        @@FSTS
     C                   PARM      *BLANK        @@CHTP
     C                   MOVEL     @@FSTS        HLDSTS
     C                   MOVEL     @@CHTP        HLCHTP
      **
      ** Deal last action
      **
     C                   MOVEL     'X'           HLLACT
      **
      ** Deal authorisation officer
      **
     C                   MOVEL     PSUser        HLAOFR
      **
      ** Deal action date
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          HLLDAT
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     IHFRNT        HLFRNT                         CAP013
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C                   MOVEL     IHAFRT        HLAFRT                         CAP013
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
     C                   MOVEL     @IHCTL        @HLCTL
      *
      ** FLAG AS 'DELETED'
      *
     C                   MOVEL     'D'           HLDDLT
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'D'           @@ACTN
     C                   PARM      HLDSTS        @@CSTS
     C                   PARM                    BNMMAU
     C                   PARM                    BNMMRA
     C                   PARM      *BLANK        @@FSTS
     C                   PARM      *BLANK        @@CHTP
     C                   MOVEL     @@FSTS        HLDSTS
     C                   MOVEL     @@CHTP        HLCHTP
      **
      ** Deal last action
      **
     C                   MOVEL     'D'           HLLACT
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     IHFRNT        HLFRNT                         CAP013
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C                   MOVEL     IHAFRT        HLAFRT                         CAP013
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
     C     IHSTCY        IFNE      *BLANKS
     C                   MOVEL     IHSTCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     IHCCY         EffSetCcy         3
     C                   ENDIF
      *
      * DETERMINE ALTERNATIVE RECEIVE INSTRUCTIONS
      *
     C                   CALLB     'ZAALTRECIN'
      ** Customer number                                                                      200400
     C**********         PARM      IHCNUM        ##CNUM            6 0                 200400 CSD027
     C                   PARM      IHCNUM        ##CNUM            6                          CSD027
      ** Rec currency
     C                   PARM      EffSetCcy     ##RCCY            3
      ** Rec - settlement method
     C                   PARM      IHRSTM        ##RSTM            2 0
      ** Rec - our nostro
     C**********         PARM      IHRONS        ##RONS           12                          CGL029
     C                   PARM      IHRONS        ##RONS                                       CGL029
      ** rec - intermediary bank
     C                   PARM      IHRIBN        ##RIBN            8
      ***MIDAS*Our*Receive*Instructions*(*for*Settlm*Meth*'04'*)*********              179510 200400
     C************       PARM                    IHMORI                                179510 200400
      ** midas our receive method
     C                   PARM                    ##ORCM            2 0
      ** our receive method
     C                   PARM                    ##DORM            5
      ** midas our receive instructions
     C**********         PARM                    ##MORI           12                          CGL029
     C                   PARM                    ##MORI                                       CGL029
      ** our receive instructions
     C**********         PARM                    ##DORI           12                          CGL029
     C                   PARM                    ##DORI                                       CGL029
      ** midas customer payment instructions
     C                   PARM                    ##MCPI           10
      ** customer payment instructions
     C                   PARM                    ##DCPI           10
      *
     C*
     C** SETTLEMENT TYPE - MIDAS
     C*
     C                   Z-ADD     ##ORCM        IHORCM
     C*
     C** SETTLEMENT TYPE - FRONT OFFICE
     C*
     C                   MOVEL     ##DORM        IHDORM
     C*
     C** OUR SETTLEMENT ACCOUNT - MIDAS
     C*
     C                   MOVEL     ##MORI        IHMORI
     C*
     C** OUR SETTLEMENT ACCOUNT - FRONT OFFICE
     C*
     C                   MOVEL     ##DORI        IHDORI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - MIDAS
     C*
     C                   MOVEL     ##MCPI        IHMCPI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - FRONT OFFICE
     C*
     C                   MOVEL     ##DCPI        IHDCPI
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
     C     IHSTCY        IFNE      *BLANKS
     C                   MOVEL     IHSTCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     IHCCY         EffSetCcy         3
     C                   ENDIF
      *
      * DETERMINE ALTERNATIVE PAYMENT INSTRUCTIONS
      *
     C                   CALLB     'ZAALTPAYIN'
      ** Customer number                                                                      200400
     C**********         PARM      IHCNUM        ##CNUM            6 0                 200400 CSD027
     C                   PARM      IHCNUM        ##CNUM            6                          CSD027
      ** Pay currency
     C                   PARM      EffSetCcy     ##PCCY            3
      ** Pay - settlement method
     C                   PARM      IHPSTM        ##PSTM            2 0
      ** Pay - our nostro
     C**********         PARM      IHPONS        ##PONS           12                          CGL029
     C                   PARM      IHPONS        ##PONS                                       CGL029
      ** account with bank
     C                   PARM      IHAWBN        ##AWBN            8
      ** beneficiary
     C                   PARM      IHBENN        ##BENN            8
      ** bank to bank info 1
     C                   PARM      IHBTB1        ##BTB1           35
      ***MIDAS*Our Pay  Instructions ( for Settlm Meth '04' )                          179510 200400
     C************       PARM                    IHMOPI                                179510 200400
      ** midas our payment method
     C                   PARM                    ##MOPM            2 0
      ** our payment method
     C                   PARM                    ##DOPM            5
      ** midas our payment instructions
     C**********         PARM                    ##MOPI           12                          CGL029
     C                   PARM                    ##MOPI                                       CGL029
      ** our payment instructions
     C**********         PARM                    ##DOPI           12                          CGL029
     C                   PARM                    ##DOPI                                       CGL029
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
     C                   MOVEL     ##MOPM        IHMOPM
     C*
     C** SETTLEMENT TYPE - FRONT OFFICE
     C*
     C                   MOVEL     ##DOPM        IHDOPM
     C*
     C** OUR SETTLEMENT ACCOUNT - MIDAS
     C*
     C                   MOVEL     ##MOPI        IHMOPI
     C*
     C** OUR SETTLEMENT ACCOUNT - FRONT OFFICE
     C*
     C                   MOVEL     ##DOPI        IHDOPI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - MIDAS
     C*
     C                   MOVEL     ##MCRI        IHMCRI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - FRONT OFFICE
     C*
     C                   MOVEL     ##DCRI        IHDCRI
     C*
     C** FOR ACCOUNT OF - MIDAS
     C*
     C                   MOVEL     ##MFAO        IHMFAO
     C*
     C** FOR ACCOUNT OF - FRONT OFFICE
     C*
     C                   MOVEL     ##DFAC        IHDFAC
     C*
     C**  Special instructions.
     C*
     C                   MOVEL     ##SPEC        IHSPEC
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
     C                   MOVEL     'HL'          IHRCID
      **
      ** Logical delete flag
      **
     C                   MOVEL     *BLANK        IHDLTF
      **
      ** Day of last update
      **
     C                   Z-ADD     @DLUP         IHDLUP
      **
      ** Month of last update
      **
     C                   MOVEL     @MLUP         IHMLUP
      **
      ** Year of last update
      **
     C                   Z-ADD     @YLUP         IHYLUP
      **
      ** Time of last update
      **
     C                   TIME                    IHTLUP
      **
      ** Type of last change (set in validation function)
      **
     C                   MOVEL     IHCHTP        IHCHTP
      **
      ** Last change date
      **
     C                   Z-ADD     BJRDNB        IHLCD
      **
      ** Last update user id
      **
     C                   MOVEL     PSUser        IHLUID
      **
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CALPIN - CALCULATE PURCHASED INTEREST                        *
     C*                                                              *
     C****************************************************************
     C     CALPIN        BEGSR
     C*
     C* START DATE = START/LAST INT DATE, END DATE = VALUE DATE
     C*
     C                   Z-ADD     IHSLID        @@BEG
     C                   Z-ADD     IHDVSD        @@END
     C*
     C* PRINCIPAL, RATE, CALCULATION METHOD, ROUND DOWN INTEREST
     C*
     C                   Z-ADD     IHFVAL        @@AMT
     C                   Z-ADD     IHFRAT        @@RATE
     C                   MOVEL     IHICMT        @@CALC
     C                   MOVE      IHRDFC        @@RDFC
      *
     C                   CALLB     'MM1030'
     C                   PARM                    @@BEG             5 0
     C                   PARM                    @@END             5 0
     C                   PARM                    @@CALC            1
     C                   PARM                    @@AMT            15 0
     C                   PARM                    @@RATE           11 7
     C                   PARM                    @@RDFC            1
     C                   PARM      *ZERO         @@INTR           15 0
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CALYLD - CALCULATE YIELD                                     *
     C*                                                              *
     C****************************************************************
     C     CALYLD        BEGSR
     C*
     C* START DATE = VALUE DATE, END DATE = MATURITY DATE
     C*
     C                   Z-ADD     IHDVSD        @@BEG
     C                   Z-ADD     IHMATD        @@END
     C*
     C* DISCOUNT RATE, CALCULATION METHOD
     C*
     C                   Z-ADD     IHDCRT        @@DIRT
     C                   MOVEL     IHICMT        @@CALC
     C*
     C                   CALLB     'MM1025'
     C                   PARM                    @@BEG             5 0
     C                   PARM                    @@END             5 0
     C                   PARM                    @@DIRT           11 7
     C                   PARM                    @@CALC            1
     C                   PARM      *ZERO         @@YLD            11 7
      *
     C                   ENDSR
     C****************************************************************
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
     C                   MOVE      IHDN38        MidasDlNum        6            CAP006
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
     C     IHLACT        ANDEQ     'I'                                          168345
     C     IHFRNT        ANDNE     *BLANKS                                      168345
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
     C     IHLACT        ANDEQ     'I'                                          CAP013
     C                   MOVE      '*FRONT'      @@MODE                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      *BLANKS       @@MODE                         CAP006
     C                   END                                                    CAP006
      *                                                                         168345
     C                   END                                                    168345
                                                                                CAP006
     C                   CALLB     'MMNASPRTV'                                  CAP006
      * INPUTS                                                                  CAP006
      *                                                                         CAP006
      * Return code                                                             CAP006
     C**********         PARM      *BLANK        RetCodeOut                         CAP006 AR1044820
     C                   PARM                    RetCodeOut                                AR1044820
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
     C                   PARM                    IHLACT                         CAP006
      *                                                                         CAP006
      * Front Office Transaction ID                                             CAP006
     C                   PARM      IHFRNT        FOTRID           20            CAP006
      *                                                                         CAP006
      * (Midas) Deal Number                                                     CAP006
     C                   PARM                    MidasDlNum                     CAP006
      *                                                                         CAP006
      * Booking branch                                                          CAP006
     C                   PARM      IHBRCA        DDBRCA            3            CAP006
      *                                                                         CAP006
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
      * OK - Booking branch                                                     CAP006
     C                   PARM      *BLANK        OKBRCA                         CAP006
      *                                                                         CAP006
      * Error fields/message IDs/message data (arrays) from/to caller           CAP006
     C                   PARM      *BLANK        FldNameArr                     CAP006
     C                   PARM      *BLANK        MsgIdArr                       CAP006
     C                   PARM      *BLANK        MsgDtaArr                      CAP006
      *                                                                         CAP006
      * Array index (3P0) from/to caller                                        CAP006
     C                   PARM      *ZERO         Idx               3 0          CAP006
                                                                                              CAS004
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
                                                                                              CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Array index (3P0) from/to caller                                                     CAS004
                                                                                              CAS004
     C                   PARM                    WIdx                                         CAS004
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
     C     CHHLTMST      IFNE      IHTMESTMP                                    CAP006
     C     IHLACT        ANDNE     'I'                                          CAP084
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
     C                   PARM                    PFPAYF                                    AR1044820
     C                   PARM                    PFRECF                                    AR1044820
      ** FRCD Issued Extension details before update                                          CDL033
     C                   PARM      *BLANKS       PBFRCD          100                          CDL033
      ** FRCD Issued Extension details after update                                           CDL033
     C                   PARM      *BLANKS       PAFRCD          100                          CDL033
     C                   PARM      *BLANKS       DLDLQD                                       CER049
     C                   PARM      *BLANKS       BeDealsDtlC                               AR1044820
     C                   PARM      *BLANKS       AfDealsDtlC                               AR1044820
      *                                                                                    AR1044820
      ** Calling Program                                                                   AR1044820
      *                                                                                    AR1044820
     C                   PARM      *BLANKS       CALLER           10                       AR1044820
     C/COPY WNCPYSRC,MMNASPMC11
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     'AOOUMMU0'    DBFILE                         *************
     C                   MOVEL     '991'         DBASE                          * DBERR 991 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *                                                                         CDE001
      ** Data export for CCRM - Limits                                          CDE001
     C                   IF        CDE001 = 'Y'                                 CDE001
     C                   MOVEL     IHDN38        T#TREF                         CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C**********         PARM                    T#TREF           20                   CDE001 CGL029
     C                   PARM                    T#TREF                                       CGL029
     C                   PARM      'NASP'        T#TCAT            4            CDE001
     C                   PARM      *BLANKS       T#RSRV           10            CDE005
     C                   ENDIF                                                  CDE001
     C/COPY WNCPYSRC,MMNASPMC10
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        IHLACT = 'A' OR                                            CRE020
     C                             IHLACT = 'D'                                               CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
      *
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
     C                   CALLB     'MMNASPUPT'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      IHLACT        @LACT             1
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
     C     @RTCD         IFEQ      '*ERROR '
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     'MMNASPUPT'   DBFILE                         *************
     C                   MOVEL     '992'         DBASE                          * DBERR 992 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRWatch - Initiates the Midas Compliance Engine.              *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRWatch       BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Initialise the Transaction Details Parameter                                         CSD015
      ** ============================================                                         CSD015
      *                                                                                       CSD015
     C                   CLEAR                   SDWLTD                                       CSD015
      *                                                                                       CSD015
      ** Item Type, Identifier, and Branch information.                                       CSD015
      *                                                                                       CSD015
     C                   CAT       'MM':0        W4ITEM                                       CSD015
     C                   CAT       HLTYPE:0      W4ITEM                                       CSD015
      *                                                                                       CSD015
     C                   MOVEL     HLDN38        W4IDEN                                       CSD015
     C                   MOVEL     HLBRCA        W4BRCH                                       CSD015
      *                                                                                       CSD015
      ** Select the System Prefix.                                                            CSD015
      *                                                                                       CSD015
     C                   IF        CSC011 = 'Y'                                               CSD015
     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   MOVEL     'MMDENBPP'    W4FUNT                                       CSD015
      *                                                                                       CSD015
      ** Get the Counterparty Detail.                                                         CSD015
      *                                                                                       CSD015
     C                   EXSR      SRGetCtrpDet                                               CSD015
     C                   MOVEL     HLCNUM        W4CNUM                                       CSD015
     C                   MOVEL     WCtrpTyp      W4CTYP                                       CSD015
     C                   MOVEL     WCtrpRpt      W4CUST                                       CSD015
      *                                                                                       CSD015
      ** Get the Deal Date.                                                                   CSD015
      *                                                                                       CSD015
     C                   MOVE      @IHDDY        WDATE                                        CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4DDAT = WDDT                                              CSD015
      *                                                                                       CSD015
      ** Get the Value Date.                                                                  CSD015
      *                                                                                       CSD015
     C                   MOVE      @IHVDY        WDATE                                        CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4VDAT = WDDT                                              CSD015
      *                                                                                       CSD015
      ** Get the Maturity Date.                                                               CSD015
      *                                                                                       CSD015
     C                   MOVE      @IHMDY        WDATE                                        CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4MDAT = WDDT                                              CSD015
      *                                                                                       CSD015
      ** Currency and Amount information.                                                     CSD015
      *                                                                                       CSD015
     C                   MOVEL     HLCCY         W4DEN1                                       CSD015
     C                   MOVEL     HLCCY         PZACcy                                       CSD015
     C                   MOVE      *BLANKS       PZANtvAmt                                    CSD015
     C                   MOVE      HLAMNP        PZANtvAmt                                    CSD015
     C                   EXSR      SRAmtToNum                                                 CSD015
     C                   EVAL      W4AMT1 = WAMT                                              CSD015
      *                                                                                       CSD015
      ** Build the Free Format String                                                         CSD015
      ** ============================                                                         CSD015
      *                                                                                       CSD015
      ** Initialise additional standing data.                                                 CSD015
      *                                                                                       CSD015
     C                   MOVEA     *BLANKS       WLFSD                                        CSD015
     C                   MOVEL     HLRIBA        WLFSD(2)                                     CSD015
     C                   MOVEL     HLPIBA        WLFSD(6)                                     CSD015
     C                   MOVEL     HLRCRA        WLFSD(9)                                     CSD015
     C                   MOVEL     HLAWBA        WLFSD(11)                                    CSD015
     C                   MOVEL     HLBENA        WLFSD(12)                                    CSD015
      *                                                                                       CSD015
      ** Begin string and packet assembly.                                                    CSD015
      *                                                                                       CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
     C                   EVAL      PFreeFmtStr = *BLANKS                                      CSD015
     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
     C                   EVAL      WData = *BLANKS                                            CSD015
      *                                                                                       CSD015
     C                   DOU       Ctr = ArrMax                                               CSD015
      *                                                                                       CSD015
     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
      *                                                                                       CSD015
      ** Select the currency for nostro fields.                                               CSD015
      *                                                                                       CSD015
     C                   IF        Ctr = 1 OR                                                 CSD015
     C                             Ctr = 5                                                    CSD015
     C                   IF        HLSTCY <> *BLANKS                                          CSD015
     C                   EVAL      WCcy = HLSTCY                                              CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WCcy = HLCCY                                               CSD015
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
     C                   PARM                    POutA                                        CSD015
      *                                                                                       CSD015
     C                   IF        WData <> *BLANKS AND                                       CSD015
     C                             %CHECK('0 ':WData) <> 0 AND                                CSD015
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
     C                   IF        HLDTP1 <> *BLANKS OR                                       CSD015
     C                             HLDTP2 <> *BLANKS OR                                       CSD015
     C                             HLDTP3 <> *BLANKS OR                                       CSD015
     C                             HLDTP4 <> *BLANKS                                          CSD015
      *                                                                                       CSD015
     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       HLDTP1:0      WXMLPacket                                   CSD015
     C                   CAT       HLDTP2:1      WXMLPacket                                   CSD015
     C                   CAT       HLDTP3:1      WXMLPacket                                   CSD015
     C                   CAT       HLDTP4:1      WXMLPacket                                   CSD015
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
      * SRCompChk - Handles the entire compliance chkng. activities.  *                       CSD015
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
      ** Move Database file fields into watch list fields array                               CSD015
      *                                                                                       CSD015
     C                   EXSR      SRDBFsToWLFs                                               CSD015
      *                                                                                       CSD015
      ** Check if watch list engine needs to be called                                        CSD015
      *                                                                                       CSD015
     C                   EXSR      SRWLFChk                                                   CSD015
      *                                                                                       CSD015
     C                   IF        WOKFlg = 'Y'                                               CSD015
     C                   EXSR      SRWatch                                                    CSD015
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
      ** Move Database file fields into watch list fields array                               CSD015
      *                                                                                       CSD015
     C                   EXSR      SRDBFsToWLFs                                               CSD015
      *                                                                                       CSD015
      ** Check if watch list engine needs to be called                                        CSD015
      *                                                                                       CSD015
     C                   EXSR      SRWLFChk                                                   CSD015
      *                                                                                       CSD015
     C                   IF        (WOKFlg = 'Y' AND                                          CSD015
     C                             WChgFlg = 'Y') OR                                          CSD015
     C                             WRetryFlg = 'Y'                                            CSD015
     C                   EXSR      SRWatch                                                    CSD015
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
     C                   MOVEL     HLRONS        WLF(1)                                       CSD015
     C                   MOVEL     HLRIBN        WLF(2)                                       CSD015
     C                   MOVEL     HLROBN        WLF(3)                                       CSD015
     C                   MOVEL     HLROCN        WLF(4)                                       CSD015
     C                   MOVEL     HLPONS        WLF(5)                                       CSD015
     C                   MOVEL     HLPIBN        WLF(6)                                       CSD015
     C                   MOVEL     HLPOBN        WLF(7)                                       CSD015
     C                   MOVEL     HLPOCN        WLF(8)                                       CSD015
     C                   MOVEL     HLRCRN        WLF(9)                                       CSD015
     C                   MOVEL     HLRVNO        WLF(10)                                      CSD015
     C                   MOVEL     HLAWBN        WLF(11)                                      CSD015
     C                   MOVEL     HLBENN        WLF(12)                                      CSD015
      *                                                                                       CSD015
     C                   WHEN      WMoveMode = CHANGED                                        CSD015
      *                                                                                       CSD015
      ** Move only the fields that have changed since the last save.                          CSD015
      *                                                                                       CSD015
     C                   EVAL      WChgFlg = 'N'                                              CSD015
      *                                                                                       CSD015
     C                   IF        HLRONS <> BCRONS                                           CSD015
     C                   MOVEL     HLRONS        WLF(1)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HLRIBN <> BCRIBN                                           CSD015
     C                   MOVEL     HLRIBN        WLF(2)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HLROBN <> BCROBN                                           CSD015
     C                   MOVEL     HLROBN        WLF(3)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HLROCN <> BCROCN                                           CSD015
     C                   MOVEL     HLROCN        WLF(4)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HLPONS <> BCPONS                                           CSD015
     C                   MOVEL     HLPONS        WLF(5)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HLPIBN <> BCPIBN                                           CSD015
     C                   MOVEL     HLPIBN        WLF(6)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HLPOBN <> BCPOBN                                           CSD015
     C                   MOVEL     HLPOBN        WLF(7)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HLPOCN <> BCPOCN                                           CSD015
     C                   MOVEL     HLPOCN        WLF(8)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HLRCRN <> BCRCRN                                           CSD015
     C                   MOVEL     HLRCRN        WLF(9)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HLRVNO <> BCRVNO                                           CSD015
     C                   MOVEL     HLRVNO        WLF(10)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HLAWBN <> BCAWBN                                           CSD015
     C                   MOVEL     HLAWBN        WLF(11)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HLBENN <> BCBENN                                           CSD015
     C                   MOVEL     HLBENN        WLF(12)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HLDTP1 <> BCDTP1 OR                                        CSD015
     C                             HLDTP2 <> BCDTP2 OR                                        CSD015
     C                             HLDTP3 <> BCDTP3 OR                                        CSD015
     C                             HLDTP4 <> BCDTP4                                           CSD015
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
     C                   DOU       Ctr = ArrMax                                               CSD015
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
     C                   IF        HLDTP1 <> *BLANKS OR                                       CSD015
     C                             HLDTP2 <> *BLANKS OR                                       CSD015
     C                             HLDTP3 <> *BLANKS OR                                       CSD015
     C                             HLDTP4 <> *BLANKS                                          CSD015
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
     C                   MOVEL     'MMDENBPP'    KFuncType                                    CSD015
     C                   MOVEL     HLDN38        KIden                                        CSD015
     C                   MOVEL     HLBRCA        KBranch                                      CSD015
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
     C                   MOVEL     HLCNUM        PCustNo                                      CSD015
      *                                                                                       CSD015
      ** Get the Customer Detail.                                                             CSD015
      *                                                                                       CSD015
     C                   CALL      'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*KEY   '     @Optn                                        CSD015
     C                   PARM                    PCustNo                                      CSD015
     C                   PARM      *BLANKS       PErrInf                                      CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
      *                                                                                       CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
      *                                                                                       CSD015
      ** Assemble the Counterparty Report information.                                        CSD015
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
     C                   EVAL      DBase = 908                                                CSD015
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
      * SRDateToDDT - Converts a date into Date Data Type format.     *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRDateToDDT   BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Move working date fields to ZDATE fields.                                            CSD015
      *                                                                                       CSD015
     C                   EVAL      PZDay =  WDay                                              CSD015
     C                   EVAL      PZMonth = WMonth                                           CSD015
     C                   EVAL      PZYear = WShortYr                                          CSD015
      *                                                                                       CSD015
      ** Convert the date into Midas Day Number.                                              CSD015
      *                                                                                       CSD015
     C                   MOVE      PZDate        PZDateIn                                     CSD015
     C                   MOVE      BJDFIN        PZDateFmt                                    CSD015
      *                                                                                       CSD015
     C                   CALLB     'ZDATE1'                                                   CSD015
     C                   PARM                    PZDateIn                                     CSD015
     C                   PARM                    PZDayNo                                      CSD015
     C                   PARM                    PZDateFmt                                    CSD015
     C                   PARM      *BLANKS       PZRtCd                                       CSD015
      *                                                                                       CSD015
      ** Convert the derived Midas Day Number into Date Data Type.                            CSD015
      *                                                                                       CSD015
     C                   MOVE      PZDayNo       PZADayNo                                     CSD015
      *                                                                                       CSD015
     C                   CALL      'ZACVTDATE'                                                CSD015
     C                   PARM      *BLANKS       PZARtCd                                      CSD015
     C                   PARM                    PZADayNo                                     CSD015
     C                   PARM                    PZADDT                                       CSD015
     C                   PARM                    PZACvtDate                                   CSD015
      *                                                                                       CSD015
     C                   EVAL      WDDT = PZADDT                                              CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRAmtToNum - Converts a native amount into numerical format.  *                       CSD015
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
      *****************************************************************                       CSD015
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
     C                   EVAL      KRefNo = *BLANKS                                           CRE020
     C                   MOVEL     HLDN38        KRefNo                                       CRE020
                                                                                              CRE020
      ** Begin advice index processing.                                                       CRE020
                                                                                              CRE020
     C                   OPEN      READVCL1                                                   CRE020
                                                                                              CRE020
     C     KADVC         SETLL     READVCL1                                                   CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
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
     C                             HLLACT = 'D'                                               CRE020
     C                   EVAL      RCHTYP = 'R'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'Y'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
     C                   ENDDO                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      *****************************************************************                       CRE020
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
     C                   PARM                    MMVNAP
      *                                                                                       CSD015
      ** Compliance Watch Hit List Key.                                                       CSD015
      *                                                                                       CSD015
     C     KCWHT         KLIST                                                                CSD015
     C                   KFLD                    KFuncType                                    CSD015
     C                   KFLD                    KIden                                        CSD015
     C                   KFLD                    KBranch                                      CSD015
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
      *                                                                                     BUG17482
      ** Check if feature CAP051 is switched on                                             BUG17482
      *                                                                                     BUG17482
     C                   MOVE      'N'           CAP051            1                        BUG17482
     C                   CALLB     'AOSARDR0'                                               BUG17482
     C                   PARM      *BLANKS       @RTCD                                      BUG17482
     C                   PARM      '*VERIFY '    @OPTN                                      BUG17482
     C                   PARM      'CAP051'      @SAR              6                        BUG17482
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG17482
      *                                                                                     BUG17482
     C     @RTCD         IFEQ      *BLANK                                                   BUG17482
     C                   MOVE      'Y'           CAP051                                     BUG17482
     C                   ENDIF                                                              BUG17482
      *                                                                                     BUG17482
     C                   MOVE      BNMMAU        SAVMMAU           1                        BUG17482
     C                   MOVE      BNMMRA        SAVMMRA           1                        BUG17482
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
                                                                                              CAS001
      ** Access SAR details file to determine if CAS001 is on.                                CAS001
      ** (Net Present Value Accounting)                                                       CAS001
                                                                                              CAS001
     C                   CALLB     'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRTCD                                        CAS001
     C                   PARM      '*VERIFY'     POPTN                                        CAS001
     C                   PARM      'CAS001'      PSARD                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
                                                                                              CAS001
     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
     C                             PRTCD <> '*NRF   '                                         CAS001
     C     *LOCK         IN        LDA                                                        CAS001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS001
     C                   EVAL      DBASE = 903                                                CAS001
     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
     C                   OUT       LDA                                                        CAS001
     C                   EXSR      SRERR                                                      CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
     C                   IF        PRTCD = *BLANKS                                            CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   ENDIF                                                                CAS001
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
     C                   IN        SC24X7                                                     CSC011
     C**********         IN        SDSTAT                                              CSC011 CSD015
                                                                                              CSC011
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
     C                   PARM      *BLANKS       PRTCD                                        CDL010
     C                   PARM      '*VERIFY'     POPTN                                        CDL010
     C                   PARM      'CDL010'      PSARD                                        CDL010
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL010
     C                   IF        PRTCD <> *BLANKS AND                                       CDL010
     C                             PRTCD <> '*NRF   '                                         CDL010
     C     *LOCK         IN        LDA                                                        CDL010
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL010
     C                   EVAL      DBASE = 904                                                CDL010
     C                   EVAL      DBKEY = 'CDL010'                                           CDL010
     C                   OUT       LDA                                                        CDL010
     C                   EXSR      SRERR                                                      CDL010
     C                   ENDIF                                                                CDL010
     C                   IF        PRTCD = *BLANKS                                            CDL010
     C                   EVAL      CDL010 = 'Y'                                               CDL010
     C                   ELSE                                                                 CDL010
     C                   EVAL      CDL010 = 'N'                                               CDL010
     C                   ENDIF                                                                CDL010
                                                                                              CSD015
      **  Access the SDSTAT Data Area.                                                        CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      **  Access SAR details to see if CSD015 is switched on.                                 CSD015
                                                                                              CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
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
      **  Access the Compliance Watch Configuration Data.                                     CSD015
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
     C                   EVAL      DBase = 906                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access SAR details to see if CCF001 is switched on.                                 CSD015
                                                                                              CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
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
     C                   EVAL      DBase = 907                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
                                                                                              CAS005
      ** Access SAR details file to determine if CAS005 is on.                                CAS005
      ** (Enhancements to CAS001, CAS002 and CAS004)                                          CAS005
                                                                                              CAS005
     C                   CALLB     'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRTCD                                        CAS005
     C                   PARM      '*VERIFY'     POPTN                                        CAS005
     C                   PARM      'CAS005'      PSARD                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
     C                   IF        PRTCD <> *BLANKS AND                                       CAS005
     C                             PRTCD <> '*NRF   '                                         CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS005
     C                   EVAL      DBASE = 904                                                CAS005
     C                   EVAL      DBKEY = 'CAS005'                                           CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      SRERR                                                      CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        PRTCD = *BLANKS                                            CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      CAS005 = 'N'                                               CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CRE020
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
                                                                                              CAP086
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALL      'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS AND                                       CAP086
     C                             @RTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'MMNASPUPM'                                        CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 911                                               CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      SRErr                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANK                                             CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CRE020
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
      *                                                                                       CAS009
      ** Access SAR details file to determine if CAS009 is on.                                CAS009
      *                                                                                       CAS009
                                                                                              CAS009
     C                   CALLB     'AOSARDR0'                                                 CAS009
     C                   PARM      *BLANKS       PRTCD                                        CAS009
     C                   PARM      '*VERIFY'     POPTN                                        CAS009
     C                   PARM      'CAS009'      PSARD                                        CAS009
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS009
     C                   IF        PRTCD <> *BLANKS AND                                       CAS009
     C                             PRTCD <> '*NRF   '                                         CAS009
     C     *LOCK         IN        LDA                                                        CAS009
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS009
     C                   EVAL      DBASE = 909                                                CAS009
     C                   EVAL      DBKEY = 'CAS009'                                           CAS009
     C                   OUT       LDA                                                        CAS009
     C                   EXSR      SRERR                                                      CAS009
     C                   ENDIF                                                                CAS009
     C                   IF        PRTCD = *BLANKS                                            CAS009
     C                   EVAL      CAS009 = 'Y'                                               CAS009
     C                   ELSE                                                                 CAS009
     C                   EVAL      CAS009 = 'N'                                               CAS009
     C                   ENDIF                                                                CAS009
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRTCD                                        CSD083
     C                   PARM      '*VERIFY'     POPTN                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRTCD <> *BLANKS AND                                       CSD083
     C                             PRTCD <> '*NRF   '                                         CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBASE = 912                                                CSD083
     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      SRERR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
     C/COPY WNCPYSRC,MMH00140
     C*
     C**  READ DTAARA/RUNDAT to access MULTI-BRANCHING flag.
     C*
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C*
     C/COPY WNCPYSRC,MMNASPMC03
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
     C                   MOVEL     'MMNASPUPM'   DBPGM            10
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
     C/EJECT
     C/COPY WNCPYSRC,MMNASPMC08
      *********************************************************************
      ** FIELD LOG
      *********************************************************************
      **                                      SET IN     SET IN
      **                                    VALIDATION    THIS    AMENDABLE
      **                                     FUNCTION   FUNCTION
      *********************************************************************
      ** Record identifier            HLRCID              YES       YES
      ** Logical delete flag          HLDLTF              YES       YES
      ** Day of last update           HLDLUP              YES       YES
      ** Month of last update         HLMLUP              YES       YES
      ** Year of last update          HLYLUP              YES       YES
      ** Time of last update          HLTLUP              YES       YES
      ** Type of last change          HLCHTP              YES       YES
      ** Last change date             HLLCD               YES       YES
      ** Last update user id          HLLUID              YES       YES
      ** Deal number pc               HLPCDN -----------------------------
      ** Deal number 38               HLDN38   YES
      ** Deal associated deal number  HLDADN
      ** Broker code                  HLBKCD   YES                  YES
      ** Currency code                HLCCY    YES
      ** Currency decimal places      HLCYDP   YES
      ** Deal value date - yyyy       HLVDYY              YES
      ** Deal value date - mm         HLVDMM              YES
      ** Deal value date - dd         HLVDDD              YES
      ** Deal transaction date - yyyy HLDTYY              YES
      ** Deal transaction date - mm   HLDTMM              YES
      ** Deal transaction date - dd   HLDTDD              YES
      ** Deal deleted indicator       HLDDLT              YES
      ** Deal status indicator        HLDSTS              YES       YES
      ** MIDAS deal type              HLMTYP              YES
      ** Rollover/bought/sold indic   HLRBSI              YES
      ** Deal type                    HLTYPE   YES        YES
      ** Deal subtype                 HLSTYP   YES                  YES
      ** Customer short name          HLCSNM   YES                  YES
      ** Customer number              HLCNUM   YES                  YES
      ** Amount                       HLAMNP   YES
      ** Interest rate                HLINTR   YES
      ** Branch code (alpha)          HLBRCA   YES                  YES
      ** Deal branch code             HLDBRC   YES                  YES
      ** Deal done date - yyyy        HLDDYY              YES
      ** Deal done date - mm          HLDDMM              YES
      ** Deal done date - dd          HLDDDD              YES
      ** Deal brokerage               HLBRKG   YES                  YES
      ** Broker currency code         HLBKCY   YES                  YES
      ** Broker ccy decimal places    HLBCDP   YES                  YES
      ** Fed funds indicator          HLFEDF   YES                  YES
      ** Cd reference                 HLCDRF   YES                  YES
      ** Deal pc transation number    HLPCTN--------------------------------
      ** Confirm/delete reply         HLCDRP--------------------------------
      ** Deal last action             HLLACT   YES                  YES
      ** Time of input                HLTIME              YES
      ** Deal user code               HLDUSC              YES
      ** Deal authorisation officer   HLAOFR              YES
      ** Deal action date             HLLDAT              YES
      ** Nxt intrst pay year date     HLNIYY              YES       YES
      ** Nxt intrst paym mth date     HLNIMM              YES       YES
      ** Next int payment day date    HLNIDD              YES       YES
      ** Interest payment frequency   HLIPFQ   YES                  YES
      ** Interest calculation method  HLICMT   YES
      ** Ldi int payment day in month HLIPDM   YES                  YES
      ** Total midas interest         HLMTTI   YES
      ** Face value                   HLFVAL   YES
      ** Issuer                       HLISUR   YES                  YES
      ** Issued by customer number    HLISCN   YES                  YES
      ** Start/last interest year     HLLIYY              YES
      ** Start/last interest month    HLLIMM              YES
      ** Start/last interest day      HLLIDD              YES
      ** Face rate                    HLFRAT   YES
      ** Discount rate                HLDCRT   YES
      ** MIDAS discount amount        HLDCAM              YES
      ** Nab na being sold by         HLSLDB   YES
      ** Account sequence number      HLACSQ   YES                  YES
      ** Sold indicator               HLSOLD              YES
      ** Interest accrual contr year  HLIAYY              YES
      ** Intrst accrual contr method  HLIAMM              YES
      ** Intrst accrual contr day     HLIADD              YES
      ** Maturity date year           HLMDYY              YES
      ** Maturity date month          HLMDMM              YES
      ** Maturity date day            HLMDDD              YES
      ** Facility                     HLFCLY--------------------------------
      ** Base currency rate           HLBRAT   YES
      ** Deal our receive method      HLDORM              YES       YES
      ** Deal midas our receve method HLORCM              YES       YES
      ** Deal our receive instructns  HLDORI              YES       YES
      ** Deal midas our receive instr HLMORI              YES       YES
      ** Deal customer payment instr  HLDCPI              YES       YES
      ** Deal midas cust payment inst HLMCPI              YES       YES
      ** Deal our payment method      HLDOPM              YES       YES
      ** Deal midas our payment meth. HLMOPM              YES       YES
      ** Deal our payment instructns  HLDOPI              YES       YES
      ** Deal midas our payment instr HLMOPI              YES       YES
      ** Deal customer receive instr  HLDCRI              YES       YES
      ** Deal Customer Receive Instru HLMCRI              YES       YES
      ** Deal for A/C of              HLDFAC              YES       YES
      ** Deal midas ''FOR A/C OF''    HLMFAO              YES       YES
      ** Deal special instructions    HLSPEC              YES       YES
      ** Midas mult/div indicator     HLMMDI   YES
      ** NAS net value                HLNANV   YES
      ** Book Code                    HLBOKC   YES                  YES
      ** LINKED DEAL NUMBER           HLLNKN   YES                  YES
      ** Bill Depot Id                HLBDID   YES                  YES
      ** receipt - settlement method  HLRSTM   YES*                 YES
      ** receipt - our nostro         HLRONS   YES*                 YES
      ** receipt - intermediary bank  HLRIBN   YES*                 YES
      ** receipt - intermediary bank  HLRIBA   YES*                 YES
      ** receipt - ordering bank no   HLROBN   YES*                 YES
      ** receipt - ordering customer  HLROCN   YES*                 YES
      ** pay - settlement method      HLPSTM   YES*                 YES
      ** pay - our nostro             HLPONS   YES*                 YES
      ** pay - intermediary bank no   HLPIBN   YES*                 YES
      ** pay - intermediary bank a/c  HLPIBA   YES*                 YES
      ** pay - ordering bank no       HLPOBN   YES*                 YES
      ** pay - ordering customer no   HLPOCN   YES*                 YES
      ** receiver correspondent no    HLRCRN   YES*                 YES
      ** receiver correspondent a/c l HLRCRA   YES*                 YES
      ** Receiver number              HLRVNO   YES*                 YES
      ** a/c with bank no             HLAWBN   YES*                 YES
      ** a/c with bank a/c line       HLAWBA   YES*                 YES
      ** beneficiary no               HLBENN   YES*                 YES
      ** beneficiary a/c line         HLBENA   YES*                 YES
      ** DETAILS OF PAY 1             HLDTP1   YES*                 YES
      ** DETAILS OF PAY 2             HLDTP2   YES*                 YES
      ** DETAILS OF PAY 3             HLDTP3   YES*                 YES
      ** DETAILS OF PAY 4             HLDTP4   YES*                 YES
      ** details of charges           HLDCHG   YES*                 YES
      ** bank to bank info 1          HLBTB1   YES*                 YES
      ** bank to bank info 2          HLBTB2   YES*                 YES
      ** bank to bank info 3          HLBTB3   YES*                 YES
      ** bank to bank info 4          HLBTB4   YES*                 YES
      ** bank to bank 5               HLBTB5   YES*                 YES
      ** bank to bank 6               HLBTB6   YES*                 YES
      ** Originating branch           HLORBR   YES                  YES
      ** Profit centre                HLPRFC   YES                  YES
      ** Our Receive Branch           HLROBR   YES*                 YES
      ** Our Pay Branch               HLPOBR   YES*                 YES
      ** COVER MESSAGE REQUIRED       HLCVMR   YES*                 YES
      ** Round down interest          HLRDFC   YES
      ** Number of assets/parcels not HLNSDD              YES
      ** Parcel Indicator             HLPCLI   YES
      ** Parcel size (no. of saleable HLPSZE   YES
      ** Original purchase price      HLOPUP              YES
      ** Number assets/parcels sold   HLNSLD
      ** Funding Spread/Rate          HLFSRP   YES                  YES
      ** Funding Spread Sign          HLFSGN   YES                  YES
      ** Funding Profit Centre        HLFPRC   YES                  YES
      ** Settlement Currency          HLSTCY   YES                  YES
      ** In Currency in Field 72      HLIC72   YES                  YES
      ** Deal value/start date        HLDVSD   YES
      ** Deal done date               HLDDND   YES
      ** Next interest payment date   HLNIPD   YES                  YES
      ** Start date or last int. date HLSLID   YES        YES
      ** Maturity date                HLMATD   YES
      ** Front Office Transaction Id  HLFRNT   YES                  YES         CAP013
      ** Assoc Front Office Trans Id  HLAFRT   YES                  YES         CAP013
      ** Deal Repair Location         REPAIR
      ** Class                        HLCLAS   YES                  YES         CDL038
      *********************************************************************
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
**  CPY@
(c) Finastra International Limited 2001
** CTDATA XOT - XML Opening Tags for the Compliance Engine.                                   CSD015
<Receipt Our Nostro>                                                                          CSD015
<Receipt Inter. Bank>                                                                         CSD015
<Receipt Ord. Bank>                                                                           CSD015
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
</Receipt Ord. Bank>                                                                          CSD015
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
