     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs sold MM database update')                 *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMNASSUPM - NAS SOLD MM DATABASE UPDATE                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
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
      *                 225817 (BG1772)    Date 19Mar04               *
      *                 NAD002             Date 26Mar04               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 222373             Date 24Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CSD015             Date 14Oct02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01 -------------------------------------------*
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
      *                 CAP006             Date 12Mar99               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR1044820 - Incorrect projected movements for Adjustment to  *
      *              Accrued Interest. Added parameters BeDealsDtlC,  *
      *              AfDealsDtlC, and CALLER when calling AOOUMMU0.   *
      *              Parameter mismatch occurred when AOOUMMU0 is     *
      *              called and user is unable to insert a NA's       *
      *              Purchased. Added parameters PFPAYF and PFRECF    *
      *              for AOOUMMU0 (Child: AR1044821)                  *
      *  CER049 - Stamp Tax                                           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17482 - Serious midas error on reject and authorise       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  BUG7461 - Authorising Officer shown as QUS                   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9711- Changes to MMVNASPPD/MMVNASSPD (re-compile)         *
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
      *  225817 - The insert user can also authorise the N/A purch.   *
      *           Do not amend the last insert/amend user of MMDENBPP.*
      *           BG1772 is applying this Release 5.0 fix to MidasPlus*
      *  NAD002 - 10-Digit Account Code Errors                        *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  222373 - Parameter Mismatch                                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.                                     *
      *  CSC011 - 24x7 Midas Availability                             *
      *  200400 - Reverse fix 179510 and replace it with a new fix.   *
      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
      *           Midas  Our  Receive/ Pay  Instructions  respectively*
      *           not  correctly  updated .  Introduced  new parametrs*
      *           when  calling   ZAALTRECIN    module  .             *
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

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

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
     FMMEIRDL5  UF   E           K DISK    COMMIT                                             CAS009
     F/COPY WNCPYSRC,MMNASSMF01
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

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
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR DEAL
     D MMVNAS        E DS                  EXTNAME(MMVNASSPD)
     D  @ILCTL                 1     23
     D  @ILDAN                36     41  0
     D  @ILVDY                50     57  0
     D  @ILTDY                58     65  0
     D  @ILDDY               111    118  0
     D  @ILMDY               208    215  0                                                    CSD015
     D  @ILALR               228    278
     D  @ILREC               314    382
     D**@ILALREx            1055   1090                                                CGL029 NAD002
     D**@ILRECEx            1091   1108                                                CGL029 NAD002

      **  DEALS FILE - NEGOTIABLE ASSETS SOLD
     D MMDENS        E DS                  EXTNAME(MMDENSPP)
     D QQDOR1        E                     EXTFLD(DORIQQ)                                     CGL029
     D QQMOR1        E                     EXTFLD(MORIQQ)                                     CGL029
     D QQRON1        E                     EXTFLD(RONSQQ)                                     CGL029
     D QQPON1        E                     EXTFLD(PONSQQ)                                     CGL029
     D  @HMCTL                 1     23
     D  @HMDAN                36     41  0
     D  @HMALR               228    278
     D  @HMREC               314    382
     D**@HMALREx            1055   1090                                                CGL029 NAD002
     D**@HMRECEx            1091   1108                                                CGL029 NAD002
     D/COPY WNCPYSRC,MMNASSMD01

      **  DEALS FILE - NEGOTIABLE ASSETS BOUGHT
     D MMDENB        E DS                  EXTNAME(MMDENBPP)
     D QQDOR2        E                     EXTFLD(DORIQQ)                                     CGL029
     D QQMOR2        E                     EXTFLD(MORIQQ)                                     CGL029
     D QQRON2        E                     EXTFLD(RONSQQ)                                     CGL029
     D QQPON2        E                     EXTFLD(PONSQQ)                                     CGL029

     D ChkDealFmt    E DS                  EXTNAME(MMDENSPP)                    CAP006
      ** Rename fields for Timestamp checking                                   CAP006
     D                                     PREFIX(CH)                           CAP006
                                                                                CAP006
     D MMENAS        E DS                  EXTNAME(MMENASSPD)                   CAP006
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

      ** Switchable Features Description                                                      CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
     D  SCLCD        E                     EXTFLD(LCD)                                        CSC011
                                                                                              CSC011
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
     D WLFBC         E DS                  EXTNAME(MMDEALLL:MMDENSP0)                         CSD015
     D                                     PREFIX(BC:2)                                       CSD015
      ** Backup Container of the Watch List Fields                                            CSD015
     D  BCMORIQQ     E                     EXTFLD(MORIQQ)                                     CGL029
     D  BCPONSQQ     E                     EXTFLD(PONSQQ)                                     CGL029
                                                                                              CSD015
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
                                                                                              CSD015
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSD015
      * Long DS for Access Programs                                                           CSD015

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
      ** Midas API Message Header Format Definition                                           CSC011
                                                                                              CSC011
      ** SD data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      * RUN DATE & MULTI-BRANCHING INDICATOR

     D RUNDAT          DS
     D  @DLUP                  1      2  0
     D  @MLUP                  3      5
     D  @YLUP                  6      7  0
     D  @MBIN                 13     13
                                                                                              CSD015
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
                                                                                             BUG7461
     D ZMUSER        E DS                  EXTNAME(ZMUSER)                                   BUG7461

      ** Dummy message ID and message file fields for use on the calls to       CAP006
      ** ZAMSGTOOPR                                                             CAP006
     D DummyMsgID      S                   LIKE(#MsgID)                         CAP006
     D DummyMsgF       S             10A                                        CAP006
                                                                                              CDL010
      ** Define fields used in CDL010                                                         CDL010
     D CDL010          S              1A                                                      CDL010
                                                                                CAP006
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
      ** Watch List Fields Standing Data Array.                                               CSD015
     D WLFSD           S             35A   DIM(ArrMax)                                        CSD015
                                                                                              CSD015
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** DEFINE FIELDS FOR ZDATE9
     D @DAYN           S              5P 0
     D @YMD            S              8S 0
     D @RETN           S              1A

      ** DEFINE FIELDS FOR ZDATE10                                                            CAS009
     D                 DS                                                                     CAS009
     D  P@YYMD                 1      8S 0                                                    CAS009
     D  P@YY                   1      4S 0                                                    CAS009
     D  P@MM                   5      6S 0                                                    CAS009
     D  P@DD                   7      8S 0                                                    CAS009
                                                                                              CAS009
      ** Timestamp for the transaction                                          CAP006
     D TimeStamp       S               Z                                        CAP006
                                                                                CAP006
     D CSC011          S              1A                                                      CSC011
                                                                                              CAP086
     D CAP086          S              1A   INZ('N')                                           CAP086
      ** Auto Authorisation flag                                                              CAP086
                                                                                              CAP086
     D TRANSDTL        S           5800A                                                      CSC011
     D PTimestamp      S             26A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D*PDealNum        S             18A                                               CSC011 CGL029
     D*PADealNo        S             18A                                               CSC011 CGL029
     D PDealNum        S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D WDealNo         S              6A                                                      CSC011
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
      ** SDCWLFMT Parameters.                                                                 CSD015
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
                                                                                              CSD015
      ** Compliance Watch Hit List Key Fields                                                 CSD015
     D KFuncType       S              8A                                                      CSD015
     D KIden           S             40A                                                      CSD015
     D KBranch         S              3A                                                      CSD015
                                                                                              CSD015
     D ##DORI          S             18A                                                      CGL029
     D ##MORI          S             18A                                                      CGL029
     D ##RONS          S             18A                                                      CGL029
     D T#TREF          S             26A                                                      CGL029
                                                                                              CGL029
      ** WMoveMode Constants                                                                  CSD015
     D ALL             C                   CONST('A')                                         CSD015
     D CHANGED         C                   CONST('C')                                         CSD015
                                                                                              CSD015
      ** WCompMode Constants                                                                  CSD015
     D OnInsert        C                   CONST('I')                                         CSD015
     D OnAmend         C                   CONST('A')                                         CSD015
                                                                                              CSD015
      ** Define fields used in CRE020                                                         CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KPrgMn          S             10A   INZ('MMNASSUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('NAsSold             ')                        CRE020
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
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
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
     C     CAP051        IFEQ      'Y'                                                      BUG17482
     C     ILAUTH        ANDEQ     'Y'                                                      BUG17482
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
     C     ILLACT        CASEQ     'I'           INSERT
     C     ILLACT        CASEQ     'A'           AMEND
     C     ILLACT        CASEQ     'X'           AUTHOR
     C     ILLACT        CASEQ     'D'           DELETE
     C                   END
     C/COPY WNCPYSRC,MMNASSMC02
      *
      ** DO ON-LINE UPDATES
      *
     C     ILLACT        IFEQ      'I'
     C     ILLACT        OREQ      'A'
     C     ILLACT        OREQ      'D'
     C                   EXSR      ONLNUP
     C                   END
      *
      *
      ** DO TREASURY MANAGEMENT UPDATES
      *
     C     BGTRMG        IFEQ      'Y'
     C     ILLACT        IFEQ      'I'
     C     ILLACT        OREQ      'A'
     C     ILLACT        OREQ      'D'
     C                   EXSR      TREAUP
     C                   END
     C                   END
      *
      ** If 24x7 Midas Availability is installed                                              CSC011
      ** and Support System is active                                                         CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   CALLB     'MMNASSLOG'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    ILLACT                                       CSC011
     C                   PARM                    MMVNAS                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** If there is no error, write the log file                                             CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *BLANKS                                       CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'MMNASS'                                       CSC011
     C                   EVAL      APFOTRANID = ILFRNT                                        CSC011
     C                   EVAL      APFOASOCID = ILAFRT                                        CSC011
     C                   EVAL      APRPRLOCN  = ILREPA                                        CSC011
     C                   EVAL      APUSERID   = PSUser                                        CSC011
     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
                                                                                              CSC011
     C                   MOVEL     ILDN38        PDealNum                                     CSC011
     C                   EVAL      PADealNo = ILDADN                                          CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       PTimestamp                                   CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM                    PADealNo                                     CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If there is an error in either log file, end program                                 CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      * EXIT FROM PROGRAM
     C     EXIT          TAG                                                    CAP006
      *
     C                   RETURN
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* INSERT - Negotiable Assets Sold Inserts                       *
     C*                                                               *
     C*****************************************************************
     C     INSERT        BEGSR
     C*
     C**  ACCESS RELATED NA BOUGHT
     C*
     C     @ILDAN        CHAIN     MMDENBP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     @ILDAN        DBKEY
     C                   MOVEL     'MMDENBP0'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C**  STORE DETAILS OF RELATED NA BOUGHT
     C*
     C                   MOVEL     MMDENB        Z#WSTS
     C*
     C** If parcelled NA (the Parcel indicator on the NA bought is 'P')
     C** update the number sold and not sold fields on the NA bought.
     C*
     C     HLPCLI        IFEQ      'P'
     C                   ADD       ILPSZE        HLNSLD
     C                   SUB       ILPSZE        HLNSDD
     C                   ELSE
     C*
     C** If not parcelled,
     C** update associated deal number with single related deal number
     C*
     C                   MOVEL     ILDN38        HLDADN
     C                   END
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
     C                   EVAL      HLTMST  = TimeStamp                          CAP006

      **********************************************************************           CDL010 225817
      ***User*Authorisation*details*when*CDL010*is*ON***********************           CDL010 225817
     C**********         IF        CDL010 = 'Y'                                        CDL010 225817
     C**********         EXSR      USRUPD                                              CDL010 225817
     C**********         ENDIF                                                         CDL010 225817
      *
     C**  UPDATE RELATED NA BOUGHT
     C*
     C                   UPDATE    MMDENBP0
     C*
     C**  SET DEAL FIELDS ON INSERT
     C*
     C                   EXSR      SETINS
     C*
     C**  ACCESS NA SOLD
     C*
     C                   CLEAR                   MMDENS
     C     ILDN38        CHAIN     MMDENSP0                           99
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     MMDENS        Z#BSTS
     C                   MOVEL     MMDENS        WLFBC                                        CSD015
     C*
     C**  UPDATE NA SOLD
     C*
     C                   MOVEL     MMVNAS        MMDENS
      *
     C                   IF        CAS009 = 'Y'                                               CAS009
      *                                                                                       CAS009
     C     @ILDAN        CHAIN     MMEIRDL5                                                   CAS009
     C                   IF        %FOUND(MMEIRDL5)                                           CAS009
                                                                                              CAS009
     C                   EVAL      P@YY = ILVDYY                                              CAS009
     C                   EVAL      P@MM = ILVDMM                                              CAS009
     C                   EVAL      P@DD = ILVDDD                                              CAS009
                                                                                              CAS009
     C                   CALLB     'ZDATE10'                                                  CAS009
     C                   PARM                    P@YYMD                                       CAS009
     C                   PARM      *ZEROS        P@DYNO            5 0                        CAS009
      *                                                                                       CAS009
     C                   IF        P@DYNO <= EIENDT                                           CAS009
     C                   EVAL      EIRCAL = 'Y'                                               CAS009
     C                   EVAL      EIADJP = 'Y'                                               CAS009
     C                   UPDATE    MMEIRDD0                                                   CAS009
     C                   ENDIF                                                                CAS009
      *                                                                                       CAS009
     C                   ENDIF                                                                CAS009
      *                                                                                       CAS009
     C                   ENDIF                                                                CAS009
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
     C                   EVAL      HMTMST  = TimeStamp                          CAP006
                                                                                CAP006
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        HMFRNT = *BLANKS                                           CSC011
     C                   MOVE      HMDN38        WDealNo                                      CSC011
     C                   EVAL      HMFRNT = 'MD' + WDealNo                                    CSC011
     C                   ENDIF                                                                CSC011
     C                   IF        HMAFRT = *BLANKS                                           CSC011
     C                   EVAL      HMAFRT = 'MD' + HMDADN                                     CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CDL010
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EXSR      USRUPDS                                                    CDL010
     C                   ENDIF                                                                CDL010

     C*  WRITE (OR UPDATE IF PRESENT) NEW NA SOLD
     C*
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
     C                   EXSR      SRCompChk                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y' AND                                           CAP086
     C                             ILAUTH = 'Y'                                               CAP086
     C                   EVAL      HMAUTH = ILAUTH                                            CAP086
     C                   EVAL      HMDSTS = 'A'                                               CAP086
     C                   ENDIF                                                                CAP086
     C                   IF        CAP051 = 'Y'                                             BUG17482
     C                   EVAL      HMAUTH = ILAUTH                                          BUG17482
     C                   ENDIF                                                              BUG17482
                                                                                              CAP086
     C                   UPDATE    MMDENSP0
     C                   ELSE
     C/COPY WNCPYSRC,MMNASSMC01
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
     C                             ILAUTH = 'Y'                                               CAP086
     C                   EVAL      HMAUTH = ILAUTH                                            CAP086
     C                   EVAL      HMDSTS = 'A'                                               CAP086
     C                   ENDIF                                                                CAP086
     C                   IF        CAP051 = 'Y'                                             BUG17482
     C                   EVAL      HMAUTH = ILAUTH                                          BUG17482
     C                   ENDIF                                                              BUG17482
                                                                                              CAP086
     C                   WRITE     MMDENSP0
     C                   END
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     MMDENS        Z#ASTS
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* AMEND - Negotiable Assets Sold Amends                         *
     C*                                                               *
     C*****************************************************************
     C     AMEND         BEGSR
     C*
     C**  ACCESS NA SOLD
     C*
     C     ILDN38        CHAIN     MMDENSP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     ILDN38        DBKEY
     C                   MOVEL     'MMDENSP0'    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     MMDENS        Z#BSTS
     C                   MOVEL     MMDENS        WLFBC                                        CSD015
     C/COPY WNCPYSRC,MMNASSMC03
     C*
     C**  SET DEAL FIELDS ON AMEND
     C*
     C                   EXSR      SETAMD
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
     C                   EVAL      HMTMST  = TimeStamp                          CAP006
      *                                                                                       CDL010
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EXSR      USRUPDS                                                    CDL010
     C                   ENDIF                                                                CDL010
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
     C**  UPDATE NA SOLD
     C*
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y' AND                                           CAP086
     C                             ILAUTH = 'Y'                                               CAP086
     C                   EVAL      HMAUTH = ILAUTH                                            CAP086
     C                   EVAL      HMDSTS = 'A'                                               CAP086
     C                   ENDIF                                                                CAP086
     C                   IF        CAP051 = 'Y'                                             BUG17482
     C                   EVAL      HMAUTH = ILAUTH                                          BUG17482
     C                   ENDIF                                                              BUG17482
                                                                                              CAP086
     C                   UPDATE    MMDENSP0
     C*
     C**  UPDATE VALID DEAL
     C*
     C                   MOVEL     MMDENS        MMVNAS
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     MMDENS        Z#ASTS
     C*
     C**  ACCESS RELATED NA BOUGHT
     C*
     C     @HMDAN        CHAIN     MMDENBP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     @HMDAN        DBKEY
     C                   MOVEL     'MMDENBP0'    DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 003*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C* STORE DETAILS OF RELATED NA BOUGHT
     C*
     C                   MOVEL     MMDENB        Z#WSTS

     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* AUTHOR - Negotiable Assets Sold Authorize                     *
     C*                                                               *
     C*****************************************************************
     C     AUTHOR        BEGSR
     C*
     C**  ACCESS NA SOLD
     C*
     C     ILDN38        CHAIN     MMDENSP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     ILDN38        DBKEY
     C                   MOVEL     'MMDENSP0'    DBFILE                         ************
     C                   MOVEL     '004'         DBASE                          * DBERR 004*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     MMDENS        Z#BSTS
     C*
     C**  SET DEAL FIELDS ON AUTHORIZE
     C*
     C                   EXSR      SETAUT
     C/COPY WNCPYSRC,MMH00141
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
     C                   EVAL      HMTMST  = TimeStamp                          CAP006
     C/COPY WNCPYSRC,MMNASSMC06
                                                                                CAP006
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EVAL      ILUSER = USRID                                            BUG7461
     C                   EXSR      USRUPDS                                                    CDL010
     C                   ENDIF                                                                CDL010
     C**  UPDATE NA SOLD
     C*
     C                   UPDATE    MMDENSP0
     C*
     C**  UPDATE VALID DEAL
     C*
     C                   MOVEL     MMDENS        MMVNAS
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     MMDENS        Z#ASTS
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                              *                        CDL010
     C* USRUPD    - Update the Last Amend/Insert User field .        *                        CDL010
     C*                                                              *                        CDL010
     C****************************************************************                        CDL010
     C     USRUPD        BEGSR                                                                CDL010
      *                                                                                       CDL010
      **  Update User Details                                                                 CDL010
      *                                                                                       CDL010
     C     ILUSER        IFEQ      *BLANKS                                                    CDL010
     C                   EVAL      HLUSER = PSuser                                            CDL010
     C                   ELSE                                                                 CDL010
     C                   EVAL      HLUSER = ILUSER                                            CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C                   ENDSR                                                                CDL010
     C*****************************************************************                       CDL010
      /EJECT                                                                                  CDL010
     C*****************************************************************                       CDL010
     C*                                                              *                        CDL010
     C* USRUPDS   - Update the Last Amend/Insert User field .        *                        CDL010
     C*                                                              *                        CDL010
     C****************************************************************                        CDL010
     C     USRUPDS       BEGSR                                                                CDL010
      *                                                                                       CDL010
      **  Update User Details                                                                 CDL010
      *                                                                                       CDL010
     C     ILUSER        IFEQ      *BLANKS                                                    CDL010
     C                   EVAL      HMUSER = PSuser                                            CDL010
     C                   ELSE                                                                 CDL010
     C                   EVAL      HMUSER = ILUSER                                            CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C                   ENDSR                                                                CDL010
     C*****************************************************************                       CDL010
      /EJECT                                                                                  CDL010
     C*                                                               *
     C* DELETE - Negotiable Assets Sold Deletes                       *
     C*                                                               *
     C*****************************************************************
     C     DELETE        BEGSR
     C*
     C**  ACCESS NA SOLD
     C*
     C     ILDN38        CHAIN     MMDENSP0                           99
     C*
     C**  DATA BASE ERROR IF NOT FOUND
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     ILDN38        DBKEY
     C                   MOVEL     'MMDENSP0'    DBFILE                         ************
     C                   MOVEL     '005'         DBASE                          * DBERR 005*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     MMDENS        Z#BSTS
     C*
     C**  SET DEAL FIELDS ON DELETE
     C*
     C                   EXSR      SETDEL
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
     C                   EVAL      HMTMST  = TimeStamp                          CAP006
                                                                                CAP006
     C**  UPDATE NA SOLD
     C*
     C                   UPDATE    MMDENSP0
     C*
     C**  UPDATE VALID DEAL
     C*
     C                   MOVEL     MMDENS        MMVNAS
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     MMDENS        Z#ASTS
     C*
     C**  ACCESS RELATED NA BOUGHT
     C*
     C     @HMDAN        CHAIN     MMDENBP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     @HMDAN        DBKEY
     C                   MOVEL     'MMDENBP0'    DBFILE                         ************
     C                   MOVEL     '006'         DBASE                          * DBERR 006*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C* STORE DETAILS OF RELATED NA BOUGHT
     C*
     C                   MOVEL     MMDENB        Z#WSTS
     C*
     C** If parcelled NA (the Parcel indicator on the NA bought is 'P')
     C** update the number sold and not sold fields on the NA bought.
     C*
     C     HLPCLI        IFEQ      'P'
     C                   SUB       HMPSZE        HLNSLD
     C                   ADD       HMPSZE        HLNSDD
     C*
     C** If not parcelled,
     C** blank associated deal number
     C*
     C                   ELSE
     C                   MOVE      *BLANK        HLDADN
     C                   END
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
     C                   EVAL      HLTMST  = TimeStamp                          CAP006
                                                                                CAP006
     C**  UPDATE RELATED NA BOUGHT
     C*
     C                   UPDATE    MMDENBP0
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
      ** Deal value date - yyyy       ILVDYY
      ** Deal value date - mm         ILVDMM
      ** Deal value date - dd         ILVDDD
      **  CONVERT VALUE DATE FROM DAY NUMBER TO YMD
      **
     C                   Z-ADD     ILDVSD        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @ILVDY
      **
      ** Deal transaction date - yyyy ILDTYY
      ** Deal transaction date - mm   ILDTMM
      ** Deal transaction date - dd   ILDTDD
      **  CONVERT RUN DATE FROM DAY NUMBER TO YMD
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @ILTDY
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
     C                   MOVEL     @@FSTS        ILDSTS
     C                   MOVEL     @@CHTP        ILCHTP
      **
      ** MIDAS deal type
      **
     C                   MOVEL     ILTYPE        ILMTYP
      **
      ** Rollover/bought/sold indic
      **
     C                   MOVEL     'S'           ILRBSI
      **
      ** Deal type (OLD DRS DEAL TYPE) - SET TO THAT ON NAB
      **
     C                   MOVEL     HLTYPE        ILTYPE
      **
      ** Branch codes - SET TO THOSE ON NAB
      **
     C                   MOVE      HLBRCA        ILBRCA
     C                   MOVE      HLDBRC        ILDBRC
      **
      ** Deal done date - yyyy        ILDDYY
      ** Deal done date - mm          ILDDMM
      ** Deal done date - dd          ILDDDD
      **
     C                   Z-ADD     ILDDND        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @ILDDY
      **
      ** CD reference - SET TO THAT ON NAB
      **
     C                   MOVE      HLCDRF        ILCDRF
      **
      ** Next interest payment date - SET TO THAT ON NAB
      **
     C                   Z-ADD     HLNIYY        ILNIYY
     C                   Z-ADD     HLNIMM        ILNIMM
     C                   Z-ADD     HLNIDD        ILNIDD
      **
      ** Interest payment frequency - SET TO THAT ON NAB
      **
     C                   MOVE      HLIPFQ        ILIPFQ
      **
      ** Interest calculation method - SET TO THAT ON NAB
      **
     C                   MOVE      HLICMT        ILICMT
      **
      ** Ldi int payment day in month - SET TO THAT ON NAB
      **
     C                   Z-ADD     HLIPDM        ILIPDM
      **
      ** Start/last int payment date - SET TO THAT ON NAB
      **
     C                   Z-ADD     HLLIYY        ILLIYY
     C                   Z-ADD     HLLIMM        ILLIMM
     C                   Z-ADD     HLLIDD        ILLIDD
      **
      ** Face rate - SET TO THAT ON NAB
      ** (This is the interest rate on interest bearing NAs)
      **
     C                   Z-ADD     HLFRAT        ILFRAT
      **
      ** Maturity date - SET TO THAT ON NAB
      **
     C                   Z-ADD     HLMDYY        ILMDYY
     C                   Z-ADD     HLMDMM        ILMDMM
     C                   Z-ADD     HLMDDD        ILMDDD
      **
      ** Base currency rate - SET TO THAT ON NAB
      **
     C                   Z-ADD     HLBRAT        ILBRAT
      **
      ** ALRECI - ALTERNATIVE RECEIVE INSTRUCTIONS
      **
     C                   EXSR      ALRECI
      **
      ** Time of input
      **
     C                   TIME                    ILTIME
      **
      ** Deal user code
      **
     C                   MOVEL     PSUser        ILDUSC
      **
      ** Deal authorisation officer
      **
     C     @@FSTS        IFEQ      'A'
     C                   MOVEL     PSUser        ILAOFR
     C                   END
      **
      ** Deal action date
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          ILLDAT
      **
      ** Parcel indicator - SET TO THAT ON NAB
      **
     C                   MOVE      HLPCLI        ILPCLI
      **
      ** Next interest payment date  - SET TO THAT ON NAB
      ** Start/last int payment date - SET TO THAT ON NAB
      ** Maturity date               - SET TO THAT ON NAB
      **
     C                   MOVEL     HLNIPD        ILNIPD
     C                   MOVEL     HLSLID        ILSLID
     C                   MOVEL     HLMATD        ILMATD
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
     C                   MOVEL     @ILCTL        @HMCTL
      **
      ** Broker code
      **
     C                   MOVEL     ILBKCD        HMBKCD
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'A'           @@ACTN
     C                   PARM      HMDSTS        @@CSTS
     C                   PARM                    BNMMAU
     C                   PARM                    BNMMRA
     C                   PARM      *BLANK        @@FSTS
     C                   PARM      *BLANK        @@CHTP
     C                   MOVEL     @@FSTS        HMDSTS
     C                   MOVEL     @@CHTP        HMCHTP
      **
      ** Deal subtype
      **
     C                   MOVEL     ILSTYP        HMSTYP
      **
      ** Customer short name
      ** Customer number
      **
     C                   MOVEL     ILCSNM        HMCSNM
     C                   MOVEL     ILCNUM        HMCNUM
      **
      ** Deal brokerage
      ** Broker currency code
      ** Broker ccy decimal places
      **
     C                   MOVEL     ILBRKG        HMBRKG
     C                   MOVEL     ILBKCY        HMBKCY
     C                   MOVEL     ILBCDP        HMBCDP
      **
      ** Fed funds indicator
      **
     C                   MOVEL     ILFEDF        HMFEDF
      **
      ** ALRECI - ALTERNATIVE RECEIVE INSTRUCTIONS
      **
     C                   EXSR      ALRECI
     C                   MOVEL     @ILALR        @HMALR
     C                   MOVEL     ILDORI        HMDORI                                       NAD002
     C                   MOVEL     ILMORI        HMMORI                                       NAD002
     C**********         MOVEL     @ILALREx      @HMALREx                              CGL029 NAD002
      **
      ** Deal last action
      **
     C                   MOVEL     'A'           HMLACT
      **
      ** Deal user code
      **
     C                   MOVEL     PSUser        HMDUSC
      **
      ** Deal action date
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          HMLDAT
      **
      ** Book Code
      **
     C                   MOVEL     ILBOKC        HMBOKC
      **
      ** LINKED DEAL NUMBER
      **
     C                   MOVEL     ILLNKN        HMLNKN
      **
      ** Extended Receipt Instructions
      **
     C                   MOVEL     @ILREC        @HMREC
     C                   MOVEL     ILRONS        HMRONS                                       NAD002
     C**********         MOVEL     @ILRECEx      @HMRECEx                              CGL029 NAD002
      **
      ** Originating branch
      **
     C                   MOVEL     ILORBR        HMORBR
      **
      ** Profit centre
      **
     C                   MOVEL     ILPRFC        HMPRFC
      **
      ** Our Receive Branch
      **
     C                   MOVEL     ILROBR        HMROBR
      **
      ** EMU Settlement fields
      **
     C                   MOVEL     ILSTCY        HMSTCY
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     ILFRNT        HMFRNT                         CAP013
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C                   MOVEL     ILAFRT        HMAFRT                         CAP013
                                                                                              CDL038
      ** Class                                                                                CDL038
     C                   MOVEL     ILCLAS        HMCLAS                                       CDL038
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
     C                   MOVEL     @ILCTL        @HMCTL
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'X'           @@ACTN
     C                   PARM      HMDSTS        @@CSTS
     C                   PARM                    BNMMAU
     C                   PARM                    BNMMRA
     C                   PARM      *BLANK        @@FSTS
     C                   PARM      *BLANK        @@CHTP
     C                   MOVEL     @@FSTS        HMDSTS
     C                   MOVEL     @@CHTP        HMCHTP
      **
      ** Deal last action
      **
     C                   MOVEL     'X'           HMLACT
      **
      ** Deal authorisation officer
      **
     C                   MOVEL     PSUser        HMAOFR
      **
      ** Deal action date
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          HMLDAT
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     ILFRNT        HMFRNT                         CAP013
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C                   MOVEL     ILAFRT        HMAFRT                         CAP013
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
     C                   MOVEL     @ILCTL        @HMCTL
      *
      ** FLAG AS 'DELETED'
      *
     C                   MOVEL     'D'           HMDDLT
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'D'           @@ACTN
     C                   PARM      HMDSTS        @@CSTS
     C                   PARM                    BNMMAU
     C                   PARM                    BNMMRA
     C                   PARM      *BLANK        @@FSTS
     C                   PARM      *BLANK        @@CHTP
     C                   MOVEL     @@FSTS        HMDSTS
     C                   MOVEL     @@CHTP        HMCHTP
      **
      ** Deal last action
      **
     C                   MOVEL     'D'           HMLACT
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     ILFRNT        HMFRNT                         CAP013
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C                   MOVEL     ILAFRT        HMAFRT                         CAP013
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
     C     ILSTCY        IFNE      *BLANKS
     C                   MOVEL     ILSTCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     ILCCY         EffSetCcy         3
     C                   ENDIF
      *
      * DETERMINE ALTERNATIVE RECEIVE INSTRUCTIONS
      *
     C                   CALLB     'ZAALTRECIN'
      ** Customer number                                                                      200400
     C**********         PARM      ILCNUM        ##CNUM            6 0                 200400 CSD027
     C                   PARM      ILCNUM        ##CNUM            6                          CSD027
      ** Rec currency
     C                   PARM      EffSetCcy     ##RCCY            3
      ** Rec - settlement method
     C                   PARM      ILRSTM        ##RSTM            2 0
      ** Rec - our nostro
     C**********         PARM      ILRONS        ##RONS           12                          CGL029
     C                   PARM      ILRONS        ##RONS                                       CGL029
      ** rec - intermediary bank
     C                   PARM      ILRIBN        ##RIBN            8
      ***MIDAS*Our*Receive*Instructions*(*for*Settlm*Meth*'04'*)*********              179510 200400
     C************       PARM                    ILMORI                                179510 200400
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
     C                   Z-ADD     ##ORCM        ILORCM
     C*
     C** SETTLEMENT TYPE - FRONT OFFICE
     C*
     C                   MOVEL     ##DORM        ILDORM
     C*
     C** OUR SETTLEMENT ACCOUNT - MIDAS
     C*
     C                   MOVEL     ##MORI        ILMORI
     C*
     C** OUR SETTLEMENT ACCOUNT - FRONT OFFICE
     C*
     C                   MOVEL     ##DORI        ILDORI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - MIDAS
     C*
     C                   MOVEL     ##MCPI        ILMCPI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - FRONT OFFICE
     C*
     C                   MOVEL     ##DCPI        ILDCPI
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
     C                   MOVEL     'HM'          ILRCID
      **
      ** Logical delete flag
      **
     C                   MOVEL     *BLANK        ILDLTF
      **
      ** Day of last update
      **
     C                   Z-ADD     @DLUP         ILDLUP
      **
      ** Month of last update
      **
     C                   MOVEL     @MLUP         ILMLUP
      **
      ** Year of last update
      **
     C                   Z-ADD     @YLUP         ILYLUP
      **
      ** Time of last update
      **
     C                   TIME                    ILTLUP
      **
      ** Type of last change (set in validation function)
      **
     C                   MOVEL     ILCHTP        ILCHTP
      **
      ** Last change date
      **
     C                   Z-ADD     BJRDNB        ILLCD
      **
      ** Last update user id
      **
     C                   MOVEL     PSUser        ILLUID
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
     C                   MOVE      ILDN38        MidasDlNum        6            CAP006
     C                   MOVE      ILDADN        PurchDlNum        6            CAP006
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
     C     ILLACT        ANDEQ     'I'                                          168345
     C     ILFRNT        ANDNE     *BLANKS                                      168345
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
     C     ILLACT        ANDEQ     'I'                                          CAP013
     C                   MOVE      '*FRONT'      @@MODE                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      *BLANKS       @@MODE                         CAP006
     C                   END                                                    CAP006
      *                                                                         168345
     C                   END                                                    168345
                                                                                CAP006
     C                   CALLB     'MMNASSRTV'                                  CAP006
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
     C                   PARM                    ILLACT                         CAP006
      *                                                                         CAP006
      * Front Office Transaction ID                                             CAP006
     C                   PARM      ILFRNT        FOTRID           20            CAP006
      *                                                                         CAP006
      * Front Office Associated Transaction Id                                  CAP006
     C                   PARM      ILAFRT        FOASID           20            CAP006
      *                                                                         CAP006
      * (Midas) Deal Number                                                     CAP006
     C                   PARM                    MidasDlNum                     CAP006
      *                                                                         CAP006
      * (Midas) Associated Deal Number                                          CAP006
     C                   PARM                    PurchDlNum                     CAP006
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
     C     CHHMTMST      IFNE      ILTMST                                       CAP006
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
     C/COPY WNCPYSRC,MMNASSMC08
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     'AOOUMMU0'    DBFILE                         *************
     C                   MOVEL     '991'         DBASE                          * DBERR 991 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *                                                                         CDE001
      ** Data export for CCRM - Limits                                          CDE001
     C                   IF        CDE001 = 'Y'                                 CDE001
     C                   MOVEL     ILDADN        T#TREF                         CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C**********         PARM                    T#TREF           20                   CDE001 CGL029
     C                   PARM                    T#TREF                                       CGL029
     C                   PARM      'NASP'        T#TCAT            4            CDE001
     C                   PARM                    T#RSRV           10            222373
     C                   ENDIF                                                  CDE001
     C/COPY WNCPYSRC,MMNASSMC07
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        ILLACT = 'A' OR                                            CRE020
     C                             ILLACT = 'D'                                               CRE020
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
     C                   CALLB     'MMNASSUPT'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      ILLACT        @LACT             1
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
     C     @RTCD         IFEQ      '*ERROR '
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     'MMNASSUPT'   DBFILE                         *************
     C                   MOVEL     '992'         DBASE                          * DBERR 992 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSD015
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
     C                   CAT       HMTYPE:0      W4ITEM                                       CSD015
      *                                                                                       CSD015
     C                   MOVEL     HMDN38        W4IDEN                                       CSD015
     C                   MOVEL     HMBRCA        W4BRCH                                       CSD015
      *                                                                                       CSD015
      ** Select the System Prefix.                                                            CSD015
      *                                                                                       CSD015
     C                   IF        CSC011 = 'Y'                                               CSD015
     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   MOVEL     'MMDENSPP'    W4FUNT                                       CSD015
      *                                                                                       CSD015
      ** Get the Counterparty Detail.                                                         CSD015
      *                                                                                       CSD015
     C                   EXSR      SRGetCtrpDet                                               CSD015
     C                   MOVEL     HMCNUM        W4CNUM                                       CSD015
     C                   MOVEL     WCtrpTyp      W4CTYP                                       CSD015
     C                   MOVEL     WCtrpRpt      W4CUST                                       CSD015
      *                                                                                       CSD015
      ** Get the Deal Date.                                                                   CSD015
      *                                                                                       CSD015
     C                   MOVE      @ILDDY        WDATE                                        CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4DDAT = WDDT                                              CSD015
      *                                                                                       CSD015
      ** Get the Value Date.                                                                  CSD015
      *                                                                                       CSD015
     C                   MOVE      @ILVDY        WDATE                                        CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4VDAT = WDDT                                              CSD015
      *                                                                                       CSD015
      ** Get the Maturity Date.                                                               CSD015
      *                                                                                       CSD015
     C                   MOVE      @ILMDY        WDATE                                        CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4MDAT = WDDT                                              CSD015
      *                                                                                       CSD015
      ** Currency and Amount information.                                                     CSD015
      *                                                                                       CSD015
     C                   MOVEL     HMCCY         W4DEN1                                       CSD015
     C                   MOVEL     HMCCY         PZACcy                                       CSD015
     C                   MOVE      *BLANKS       PZANtvAmt                                    CSD015
     C                   MOVE      HMAMNP        PZANtvAmt                                    CSD015
     C                   EXSR      SRAmtToNum                                                 CSD015
     C                   EVAL      W4AMT1 = WAMT                                              CSD015
      *                                                                                       CSD015
      ** Build the Free Format String                                                         CSD015
      ** ============================                                                         CSD015
      *                                                                                       CSD015
      ** Initialise additional standing data.                                                 CSD015
      *                                                                                       CSD015
     C                   MOVEA     *BLANKS       WLFSD                                        CSD015
     C                   MOVEL     HMRIBA        WLFSD(2)                                     CSD015
     C                   MOVEL     HMPIBA        WLFSD(6)                                     CSD015
     C                   MOVEL     HMRCRA        WLFSD(9)                                     CSD015
     C                   MOVEL     HMAWBA        WLFSD(11)                                    CSD015
     C                   MOVEL     HMBENA        WLFSD(12)                                    CSD015
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
     C                   IF        HMSTCY <> *BLANKS                                          CSD015
     C                   EVAL      WCcy = HMSTCY                                              CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WCcy = HMCCY                                               CSD015
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
     C                   IF        HMDTP1 <> *BLANKS OR                                       CSD015
     C                             HMDTP2 <> *BLANKS OR                                       CSD015
     C                             HMDTP3 <> *BLANKS OR                                       CSD015
     C                             HMDTP4 <> *BLANKS                                          CSD015
      *                                                                                       CSD015
     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       HMDTP1:0      WXMLPacket                                   CSD015
     C                   CAT       HMDTP2:1      WXMLPacket                                   CSD015
     C                   CAT       HMDTP3:1      WXMLPacket                                   CSD015
     C                   CAT       HMDTP4:1      WXMLPacket                                   CSD015
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
      ** Verify if transaction is on the hit list file but Unconfirmed                        CSD015
      *                                                                                       CSD015
     C                   EXSR      SRRetryChk                                                 CSD015
      *                                                                                       CSD015
     C                   IF        WRetryFlg = 'Y'                                            CSD015
     C                   EVAL      WMoveMode = ALL                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WMoveMode = CHANGED                                        CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Move database file fields into watch list fields array                               CSD015
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
     C                   MOVEL     HMRONS        WLF(1)                                       CSD015
     C                   MOVEL     HMRIBN        WLF(2)                                       CSD015
     C                   MOVEL     HMROBN        WLF(3)                                       CSD015
     C                   MOVEL     HMROCN        WLF(4)                                       CSD015
     C                   MOVEL     HMPONS        WLF(5)                                       CSD015
     C                   MOVEL     HMPIBN        WLF(6)                                       CSD015
     C                   MOVEL     HMPOBN        WLF(7)                                       CSD015
     C                   MOVEL     HMPOCN        WLF(8)                                       CSD015
     C                   MOVEL     HMRCRN        WLF(9)                                       CSD015
     C                   MOVEL     HMRVNO        WLF(10)                                      CSD015
     C                   MOVEL     HMAWBN        WLF(11)                                      CSD015
     C                   MOVEL     HMBENN        WLF(12)                                      CSD015
      *                                                                                       CSD015
     C                   WHEN      WMoveMode = CHANGED                                        CSD015
      *                                                                                       CSD015
      ** Move only the fields that have changed since the last save.                          CSD015
      *                                                                                       CSD015
     C                   EVAL      WChgFlg = 'N'                                              CSD015
      *                                                                                       CSD015
     C                   IF        HMRONS <> BCRONS                                           CSD015
     C                   MOVEL     HMRONS        WLF(1)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HMRIBN <> BCRIBN                                           CSD015
     C                   MOVEL     HMRIBN        WLF(2)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HMROBN <> BCROBN                                           CSD015
     C                   MOVEL     HMROBN        WLF(3)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HMROCN <> BCROCN                                           CSD015
     C                   MOVEL     HMROCN        WLF(4)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HMPONS <> BCPONS                                           CSD015
     C                   MOVEL     HMPONS        WLF(5)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HMPIBN <> BCPIBN                                           CSD015
     C                   MOVEL     HMPIBN        WLF(6)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HMPOBN <> BCPOBN                                           CSD015
     C                   MOVEL     HMPOBN        WLF(7)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HMPOCN <> BCPOCN                                           CSD015
     C                   MOVEL     HMPOCN        WLF(8)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HMRCRN <> BCRCRN                                           CSD015
     C                   MOVEL     HMRCRN        WLF(9)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HMRVNO <> BCRVNO                                           CSD015
     C                   MOVEL     HMRVNO        WLF(10)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HMAWBN <> BCAWBN                                           CSD015
     C                   MOVEL     HMAWBN        WLF(11)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HMBENN <> BCBENN                                           CSD015
     C                   MOVEL     HMBENN        WLF(12)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        HMDTP1 <> BCDTP1 OR                                        CSD015
     C                             HMDTP2 <> BCDTP2 OR                                        CSD015
     C                             HMDTP3 <> BCDTP3 OR                                        CSD015
     C                             HMDTP4 <> BCDTP4                                           CSD015
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
     C                   IF        HMDTP1 <> *BLANKS OR                                       CSD015
     C                             HMDTP2 <> *BLANKS OR                                       CSD015
     C                             HMDTP3 <> *BLANKS OR                                       CSD015
     C                             HMDTP4 <> *BLANKS                                          CSD015
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
     C                   MOVEL     'MMDENSPP'    KFuncType                                    CSD015
     C                   MOVEL     HMDN38        KIden                                        CSD015
     C                   MOVEL     HMBRCA        KBranch                                      CSD015
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
     C                   MOVEL     HMCNUM        PCustNo                                      CSD015
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
     C                   MOVEL     HMDN38        KRefNo                                       CRE020
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
     C                             HMLACT = 'D'                                               CRE020
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
     C                   PARM                    MMVNAS
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
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C**********         IN        SDSTAT                                              CSC011 CSD015
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
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
     C                   EVAL      DBPGM = 'MMNASSUPM'                                        CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 910                                               CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
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
                                                                                              CRE020
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
     C                   EVAL      DBASE = 911                                                CSD083
     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      SRERR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
     C/COPY WNCPYSRC,MMH00142
     C*
     C**  READ DTAARA/RUNDAT to access MULTI-BRANCHING flag.
     C*
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C/COPY WNCPYSRC,MMNASSMC04

      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------

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
     C                   MOVEL     'MMNASSUPM'   DBPGM            10
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
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY WNCPYSRC,MMNASSMC05
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *********************************************************************
      ** FIELD LOG
      *********************************************************************
      **                                      SET IN     SET IN
      **                                    VALIDATION    THIS    AMENDABLE
      **                                     FUNCTION   FUNCTION
      *********************************************************************
      ** Record identifier            HMRCID              YES       YES
      ** Logical delete flag          HMDLTF              YES       YES
      ** Day of last update           HMDLUP              YES       YES
      ** Month of last update         HMMLUP              YES       YES
      ** Year of last update          HMYLUP              YES       YES
      ** Time of last update          HMTLUP              YES       YES
      ** Type of last change          HMCHTP              YES       YES
      ** Last change date             HMLCD               YES       YES
      ** Last update user id          HMLUID              YES       YES
      ** Deal number pc               HMPCDN -----------------------------
      ** Deal number 38               HMDN38   YES
      ** Deal associated deal number  HMDADN   YES
      ** Broker code                  HMBKCD   YES                  YES
      ** Currency code                HMCCY    YES
      ** Currency decimal places      HMCYDP   YES
      ** Deal value date - yyyy       HMVDYY              YES
      ** Deal value date - mm         HMVDMM              YES
      ** Deal value date - dd         HMVDDD              YES
      ** Deal transaction date - yyyy HMDTYY              YES
      ** Deal transaction date - mm   HMDTMM              YES
      ** Deal transaction date - dd   HMDTDD              YES
      ** Deal deleted indicator       HMDDLT              YES
      ** Deal status indicator        HMDSTS              YES       YES
      ** MIDAS deal type              HMMTYP              YES
      ** Rollover/bought/sold indic   HMRBSI              YES
      ** Deal type                    HMTYPE              YES-NAB
      ** Deal subtype                 HMSTYP   YES                  YES
      ** Customer short name          HMCSNM   YES                  YES
      ** Customer number              HMCNUM   YES                  YES
      ** Amount                       HMAMNP   YES
      ** Interest rate                HMINTR   YES
      ** Branch code (alpha)          HMBRCA              YES-NAB
      ** Deal branch code             HMDBRC              YES-NAB
      ** Deal done date - yyyy        HMDDYY              YES
      ** Deal done date - mm          HMDDMM              YES
      ** Deal done date - dd          HMDDDD              YES
      ** Deal brokerage               HMBRKG   YES                  YES
      ** Broker currency code         HMBKCY   YES                  YES
      ** Broker ccy decimal places    HMBCDP   YES                  YES
      ** Fed funds indicator          HMFEDF   YES                  YES
      ** Cd reference                 HMCDRF              YES-NAB
      ** Nxt intrst pay year date     HMNIYY              YES-NAB
      ** Nxt intrst paym mth date     HMNIMM              YES-NAB
      ** Next int payment day date    HMNIDD              YES-NAB
      ** Interest payment frequency   HMIPFQ              YES-NAB
      ** Interest calculation method  HMICMT              YES-NAB
      ** Ldi int payment day in month HMIPDM              YES-NAB
      ** Face value                   HMFVAL   YES
      ** Issuer                       HMISUR   YES
      ** Issued by customer number    HMISCN   YES
      ** Start/last interest year     HMLIYY              YES-NAB
      ** Start/last interest month    HMLIMM              YES-NAB
      ** Start/last interest day      HMLIDD              YES-NAB
      ** Face rate                    HMFRAT              YES-NAB
      ** Discount rate                HMDCRT--------------------------------
      ** Maturity date year           HMMDYY              YES-NAB
      ** Maturity date month          HMMDMM              YES-NAB
      ** Maturity date day            HMMDDD              YES-NAB
      ** Facility                     HMFCLY--------------------------------
      ** Base currency rate           HMBRAT              YES-NAB
      ** Deal our receive method      HMDORM              YES       YES
      ** Deal midas our receve method HMORCM              YES       YES
      ** Deal our receive instructns  HMDORI              YES       YES
      ** Deal midas our receive instr HMMORI              YES       YES
      ** Deal customer payment instr  HMDCPI              YES       YES
      ** Deal midas cust payment inst HMMCPI              YES       YES
      ** Deal pc transation number    HMPCTN--------------------------------
      ** Confirm/delete reply         HMCDRP--------------------------------
      ** Deal last action             HMLACT   YES                  YES
      ** Time of input                HMTIME              YES
      ** Deal user code               HMDUSC              YES
      ** Deal authorisation officer   HMAOFR              YES
      ** Deal action date             HMLDAT              YES
      ** Book Code                    HMBOKC   YES                  YES
      ** LINKED DEAL NUMBER           HMLNKN   YES                  YES
      ** receipt - settlement method  HMRSTM   YES*                 YES
      ** receipt - our nostro         HMRONS   YES*                 YES
      ** receipt - intermediary bank  HMRIBN   YES*                 YES
      ** receipt - intermediary bank  HMRIBA   YES*                 YES
      ** receipt - ordering bank no   HMROBN   YES*                 YES
      ** receipt - ordering customer  HMROCN   YES*                 YES
      ** pay - settlement method      HMPSTM--------------------------------
      ** pay - our nostro             HMPONS--------------------------------
      ** pay - intermediary bank no   HMPIBN--------------------------------
      ** pay - intermediary bank a/c  HMPIBA--------------------------------
      ** pay - ordering bank no       HMPOBN--------------------------------
      ** pay - ordering customer no   HMPOCN--------------------------------
      ** receiver correspondent no    HMRCRN--------------------------------
      ** receiver correspondent a/c l HMRCRA--------------------------------
      ** Receiver number              HMRVNO--------------------------------
      ** a/c with bank no             HMAWBN--------------------------------
      ** a/c with bank a/c line       HMAWBA--------------------------------
      ** beneficiary no               HMBENN--------------------------------
      ** beneficiary a/c line         HMBENA--------------------------------
      ** DETAILS OF PAY 1             HMDTP1--------------------------------
      ** DETAILS OF PAY 2             HMDTP2--------------------------------
      ** DETAILS OF PAY 3             HMDTP3--------------------------------
      ** DETAILS OF PAY 4             HMDTP4--------------------------------
      ** details of charges           HMDCHG--------------------------------
      ** bank to bank info 1          HMBTB1--------------------------------
      ** bank to bank info 2          HMBTB2--------------------------------
      ** bank to bank info 3          HMBTB3--------------------------------
      ** bank to bank info 4          HMBTB4--------------------------------
      ** bank to bank 5               HMBTB5--------------------------------
      ** bank to bank 6               HMBTB6--------------------------------
      ** Originating branch           HMORBR   YES                  YES
      ** Profit centre                HMPRFC   YES                  YES
      ** Our Receive Branch           HMROBR   YES                  YES
      ** COVER MESSAGE REQUIRED       HMCVMR--------------------------------
      ** Parcel Indicator             HMPCLI              YES-NAB
      ** Parcel size (no. of saleable HMPSZE   YES
      ** Deal value/start date        HMDVSD   YES
      ** Deal done date               HMDDND   YES
      ** Next interest payment date   HMNIPD              YES-NAB
      ** Start date or last int. date HMSLID              YES-NAB
      ** Maturity date                HMMATD              YES-NAB
      ** Front Office Transaction Id  HMFRNT   YES                  YES         CAP013
      ** Assoc Front Office Trans Id  HMAFRT   YES                  YES         CAP013
      ** Deal Repair Location         HMREPA
      ** Class                        HMCLAS   YES                  YES         CDL038
      ********************************************************************
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
