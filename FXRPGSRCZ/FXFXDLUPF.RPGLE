     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deals database update')                       *
      *****************************************************************
      *                                                               *
      *  Midas - FX Dealer Module                                     *
      *                                                               *
      *  FXFXDLUPF - FX DEALS FX DATABASE UPDATE                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CDL094             Date 30May14               *
      *                 CSW212             Date 03May12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      *                 BUG27841           Date 09Aug10               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255340             Date 29Jul08               *
      *                 247266             Date 21Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242477             Date 27Sep06               *
      *                 228662             Date 20Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 07Jul06               *
      *                 BUG7461            Date 14Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 208884             Date 29Aug02               *
      *                 GBO014             Date 15Jun04               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5517            Date 19Jan05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CFX114             Date 15Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 21AUG03               *
      *                 CDE005             Date 19Aug03               *
      *                 CSD015             Date 14Oct02               *
      *                 CDL010             Date 02Aug02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 184720             Date 07Nov00               *
      *                 179510             Date 06Nov00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001             Date 12Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 11Nov99               *
      *                 CPB001             Date 01Jun99               *
      *                 CAP013             Date 07Sep99               *
      *                 168345             Date 12Oct99               *
      * Midas DBA 3.00 -----------------Base--------------------------*
      *                 CAP006             DATE 23Feb99               *
      *                 154448             DATE 13Jul98               *
      *                 136434             Date 01Jun98               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date                                    *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  BUG27841 - Status changes to Requires Reauthorisation        *
      *             during Delete Action                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255340 - Move reference rate to its field in FXDEALPP when   *
      *           CDL049 is on.                                       *
      *  247266 - When deal is reversed, saved it as unauthorised.    *
      *  242477 - Applied fix 200709.  2nd leg swap deal number not   *
      *           shown on enquiry via option TRIP-FXDN.              *
      *  228662 - FX deals in API lose Front Office ID.               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  BUG7461 - Authorising Officer shown as QUS                   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  208884 - Delete of unauthorised deal received from interface *
      *           must send a "refused" message to the sender.        *
      *  GBO014 - Perform Override when Exchange Rate Tolerance is    *
      *                    exceeded.                                  *
      *                  - Upgrade to Midasplus                       *
      *           Core hooks amended:FXFXDLFD01,FXFXDLFC14,FXFXDLFF01,*
      *                              FXFXDLFC04                       *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5517- Authorisation Error on FXDL.  Retrieve contents of  *
      *           DTAARA/ZMUSER moved out of INZSR                    *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CFX114 - Core changes for GBO014                             *
      *         - Perform Override when Exchange Rate Tolerance is    *
      *           exceeded.                                           *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:FXFXDLFD01,FXFXDLFC14,FXFXDLFF01,*
      *                              FXFXDLFC04                       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Add ZMUSER processing for Midas Plus.               *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.                                     *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  200400 - Reverse fix 179510 and replace it with a new fix.   *
      *  184720 - Do not check if the Timestamp has changed on Insert.*
      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
      *           Midas  Our  Receive/ Pay  Instructions  respectively
      *           not  correctly  updated .  Introduced  new parametrs
      *           when  calling   ZAALTRECIN/ PAYIN  modules .        *
      *  CDL008 - Continuous Linked Settlement                        *
      *  CDE001 - Data Export - CCRM Limits                           *
      *  CAP051 - Automatic Authorisation (FX Part)                   *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in FXDEALPP               *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  168345 - Prevent two users from accessing same transaction   *
      *           in repair screen at the same cycle, and converting  *
      *           it into two different Midas Deal No.s  .            *
      *           Second user should not be allowed to repair the tran-
      *           saction and convert it into a another Midas Deal    *
      *  CAP006 - Check for deal being updated by another workstation *
      *  154448 - Correct update of online position file for swap deals
      *  136434 - Treasury Management updates were missing from FX    *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
     FFXDEAULL  UF A E           K DISK
     F                                     COMMIT
     F                                     INCLUDE(FXDEALP0)
                                                                                              CSD015
      ** Compliance Watch Hit List                                                            CSD015
     FSDCWHTL1  IF   E           K DISK    INFSR(SRERR)                                       CSD015
     F/COPY WNCPYSRC,FXH00075
                                                                                              CSD015
     FREADVCL1  UF   E           K DISK    INFSR(SRERR)                                       CRE020
     F                                     USROPN                                             CRE020
      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref                            CRE020
                                                                                              CRE020
     F/COPY WNCPYSRC,FXFXDLFF01

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

      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009

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
     D FXVFXD        E DS                  EXTNAME(FXVFXDLPD)
     D  @F3CTL                 1     23
     D  @F3VDY                30     37  0
     D  @F3TDY                38     45  0
     D  @F3OEY                46     53  0
     D  @F3DAN                54     59  0
     D  @F3DDY               161    168  0
     D  @F3ALR1              173    203
     D  @F3ALP1              204    234
     D  @F3ALR2              251    270
     D  @F3ALP2              271    345
     D  @F3REC               400    468
     D  @F3PAY               469   1027
     D  @F3ISDA             1394   2043                                                       CSW212
     D/COPY WNCPYSRC,FXFXDLFD02

      **  DEALS FILE - FX DEALS
     D FXDEAL        E DS                  EXTNAME(FXDEALPP)
     D FXDEALRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D FXDEALPONS    E                     EXTFLD(QQPONS)                                     CGL029
     D FXDEALMOPI    E                     EXTFLD(QQMOPI)                                     CGL029
     D FXDEALDOPI    E                     EXTFLD(QQDOPI)                                     CGL029
     D FXDEALMORI    E                     EXTFLD(QQMORI)                                     CGL029
     D FXDEALDORI    E                     EXTFLD(QQDORI)                                     CGL029
     D  @FHCTL                 1     23
     D  @FHDDY               161    168  0
     D  @FHALR1              173    203
     D  @FHALP1              204    234
     D  @FHALR2              251    270
     D  @FHALP2              271    345
     D  @FHREC               400    468
     D  @FHPAY               469   1027
     D  @FHISDA             1394   2043                                                       CSW212
     D/COPY WNCPYSRC,FXFXDLFD03

     D ChkDealFmt    E DS                  EXTNAME(FXDEALPP)                    CAP006
      ** Rename fields for Timestamp checking                                   CAP006
     D                                     PREFIX(CH)                           CAP006
                                                                                CAP006
     D FXEFXD        E DS                  EXTNAME(FXEFXDLPD)                   CAP006
      * Error indicators                                                        CAP006
                                                                                CAP006
      **  EXTERNALLY DESCRIBED DATA STRUCTURES FOR TEMPLATE FILES FOR
      **  PROJECTED ACCOUNT MOVEMENTS UPDATES
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)
     D Z#XSTS        E DS                  EXTNAME(Z#XST)                       154448

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

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
      ** Midas API Message Header Format Definition                                           CSC011
                                                                                              CSC011
      ** DS for ZMUSER details                                                                CAP084
     D ZMUSER          DS            17                                                       CAP084
     D  PUSRID                 1     10                                                       CAP084
     D  PDBRN                 11     13                                                       CAP084
     D  PDPPT                 14     16                                                       CAP084
                                                                                208884
     D InvRp         E DS                  EXTNAME(FXIFXDLPD)                   208884
     D                                     PREFIX(R:2)                          208884
                                                                                208884
      * RUN DATE & MULTI-BRANCHING INDICATOR

     D RUNDAT          DS
     D  @DLUP                  1      2  0
     D  @MLUP                  3      5
     D  @YLUP                  6      7  0
     D  @MBIN                 13     13
                                                                                CAP006
     D/COPY WNCPYSRC,FXFXDLFD04
      ** Dummy message ID and message file fields for use on the calls to       CAP006
      ** ZAMSGTOOPR                                                             CAP006
     D DummyMsgID      S                   LIKE(#MsgID)                         CAP006
     D DummyMsgF       S             10A                                        CAP006
     D/COPY WNCPYSRC,FXFXDLFD01
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D***PDealNum        S             18A                                             CSC011 CGL029
     D***PADealNum       S             18A                                             CSC011 CGL029
     D PDealNum        S             24A                                                      CGL029
     D PADealNum       S             24A                                                      CGL029
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D PTimestamp      S             26A                                                      CSC011
     D WDealNo         S              6A                                                      CSC011
                                                                                CAP006
      ** Define fields used in CAS001                                                         CAS001
                                                                                              CAS001
     D CAS001          S              1A                                                      CAS001
                                                                                              CAS001
     D WIdx            S              3P 0                                                    CAS004
                                                                                              CAS004
     D CDL010          S              1A                                                      CDL010
      ** Define fields used in CDL010                                                         CDL010
                                                                                              CDL010
      ** Fields used in CSD015                                                                CSD015
                                                                                              CSD015
      ** Second DS for Access Programs, Long DS                                               CSD015
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSD015
                                                                                              CSD015
      ** External DS for Customer Details                                                     CSD015
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
                                                                                              CSD015
      ** External DS for Compliance Watch Transaction Details                                 CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
      ** Watch List Transaction Details Data Structure                                        CSD015
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                  CSD015
                                                                                              CSD015
      ** External DS for Watch List Configuration Data                                        CSD015
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
                                                                                              CSD015
      ** Compliance Engine Free Format String Parameter                                       CSD015
     D PFreeFmtStr     S          30000A                                                      CSD015
                                                                                              CSD015
      ** Array Size Definition                                                                CSD015
     D Elements        C                   CONST(13)                                          CSD015
                                                                                              CSD015
      ** XML Opening Tags for the Compliance Engine                                           CSD015
     D XOT             S             25A   DIM(Elements) PERRCD(1) CTDATA                     CSD015
                                                                                              CSD015
      ** XML Closing Tags for the Compliance Engine                                           CSD015
     D XCT             S             25A   DIM(Elements) PERRCD(1) CTDATA                     CSD015
                                                                                              CSD015
      ** Watch List Fields Array.                                                             CSD015
     D WLF             S             18A   DIM(Elements)                                      CSD015
                                                                                              CSD015
     D CSD015          S              1                                                       CSD015
     D CCF001          S              1                                                       CSD015
     D WFuncType       S              8                                                       CSD015
     D WIdntifier      S             40                                                       CSD015
     D WBranch         S              3                                                       CSD015
     D WLChgFlg        S              1    INZ('N')                                           CSD015
     D WLOKFlg         S              1    INZ('N')                                           CSD015
     D WXMLPacket      S            310                                                       CSD015
     D WData           S            216                                                       CSD015
     D WDate           S             10                                                       CSD015
     D WDateTemp4      S              4                                                       CSD015
     D WDateTemp2A     S              2                                                       CSD015
     D WDateTemp2B     S              2                                                       CSD015
     D Ctr             S              2P 0                                                    CSD015
     D ConvertedAmt    S             18P 3                                                    CSD015
     D PRetCode        S              7                                                       CSD015
     D POption         S              7                                                       CSD015
     D PFunc           S              8                                                       CSD015
     D PCust           S             10                                                       CSD015
     D PStKey          S              7                                                       CSD015
     D PDate           S              6                                                       CSD015
     D PAmt            S             15                                                       CSD015
     D PFmtCCY         S              3                                                       CSD015
     D PDummy6         S              6                                                       CSD015
     D PDummy10        S             10                                                       CSD015
     D PDummy16        S             16                                                       CSD015
     D PDummy35        S             35                                                       CSD015
                                                                                              CSD015
      ** CRE020 Variables                                                                     CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KPrgMn          S             10A   INZ('FXFXDLUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('ForeignExchangeDeals')                        CRE020
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
     D CER043          S              1A                                                      CER043
     D CDL099          S              1A                                                      CDL099
     D/COPY WNCPYSRC,FXH00076
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
     C/COPY WNCPYSRC,FXFXDLFC03
      *                                                                                      BUG5517
      **  Get default branch and user from ZMUSER                                            BUG5517
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG5517
     C                   IN        ZMUSER                                                    BUG5517
     C                   UNLOCK    ZMUSER                                                    BUG5517
     C                   EVAL      PSUser = PUSRID                                           BUG5517
      *
      ** INITIALIZE WORK FIELDS
      *
     C                   MOVEL     *BLANK        Z#BSTS
     C                   MOVEL     *BLANK        Z#ASTS
     C                   MOVEL     *BLANK        Z#WSTS
     C                   MOVEL     *BLANK        Z#XSTS                         154448
      *                                                                         CAP051
      ***  Transaction coming from Interface require an Automatic Authorisation CAP051
      *                                                                         CAP051
     C     CAP051        IFEQ      'Y'                                          CAP051
     C     F3AUTH        ANDEQ     'Y'                                          CAP051
     C                   MOVE      'N'           BNFXAU                         CAP051
     C                   MOVE      'N'           BNFXRA                         CAP051
     C                   ELSE                                                   CAP051
     C                   MOVE      SAVFXAU       BNFXAU                         CAP051
     C                   MOVE      SAVFXRA       BNFXRA                         CAP051
     C                   ENDIF                                                  CAP051
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
     C     F3LACT        CASEQ     'I'           INSERT
     C     F3LACT        CASEQ     'A'           AMEND
     C     F3LACT        CASEQ     'X'           AUTHOR
     C     F3LACT        CASEQ     'D'           DELETE
     C                   END
     C/COPY WNCPYSRC,FXFXDLFC07
      *
      ** DO ON-LINE UPDATES
      *
     C     F3LACT        IFEQ      'I'
     C     F3LACT        OREQ      'A'
     C/COPY WNCPYSRC,FXH00214
     C     F3LACT        OREQ      'D'
     C/COPY WNCPYSRC,FXH00215
     C                   EXSR      ONLNUP
     C                   END
      *
      *
      ** DO TREASURY MANAGEMENT UPDATES
      *
     C     BGTRMG        IFEQ      'Y'
     C*****BGTRMG        ANDNE     'Y'                                          136434
     C     F3LACT        IFEQ      'I'
     C     F3LACT        OREQ      'A'
     C     F3LACT        OREQ      'D'
     C                   EXSR      TREAUP
     C                   END
     C                   END
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed                                              CSC011
      ** and Support System is active                                                         CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   CALLB     'FXFXDLLOG'                                                CSC011
     C                   PARM      *Blanks       RetCodeOut                                   CSC011
     C                   PARM                    F3LACT                                       CSC011
     C                   PARM                    FXVFXD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** If there is no error, write the log file                                             CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *Blanks                                       CSC011
     C                   EVAL      APTGTTYPE  = 'FXFXDL'                                      CSC011
     C                   EVAL      APFOTRANID = F3FRNT                                        CSC011
     C                   EVAL      APRPRLOCN  = F3REPA                                        CSC011
     C                   EVAL      APUSERID   = PSUser                                        CSC011
     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
     C                   MOVEL     F3DN38        PDealNum                                     CSC011
     C                   MOVEL     F3DADN        PADealNum                                    CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *Blanks       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *Blanks       PTimestamp                                   CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM                    PADealNum                                    CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If there is an error in either log file, end program                                 CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
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
     C* INSERT - FX Deal Inserts                                      *
     C*                                                               *
     C*****************************************************************
     C     INSERT        BEGSR
     C*
     C**  IF DEAL IS PART OF A SWAP, OR AN OPTION TAKEDOWN
     C*
     C     F3TYPE        IFEQ      'SW'
     C     F3TYPE        OREQ      'OT'
     C     F3BROK        OREQ      'SWAP'                                                     242477
     C*
     C* ACCESS RELATED DEAL
     C*
     C     @F3DAN        CHAIN     FXDEALP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     @F3DAN        DBKEY
     C                   MOVEL     'FXDEALP0'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      SRERR
     C                   END
     C*
     C**  STORE DETAILS OF RELATED DEAL
     C*
     C                   MOVEL     FXDEAL        Z#WSTS
     C*
     C** IF A SWAP
     C*
     C     F3TYPE        IFEQ      'SW'
     C*
     C** CONVERT RELATED DEAL TO SWAP
     C                   MOVE      F3DN38        FHDADN
     C                   MOVE      'S'           FHDTYP
     C                   MOVE      'SW'          FHTYPE
     C                   END
      *                                                                                       242477
     C     F3BROK        IFEQ      'SWAP'                                                     242477
     C                   MOVE      F3DN38        FHDADN                                       242477
     C                   MOVE      'S'           FHDTYP                                       242477
     C                   ENDIF                                                                242477
      *                                                                                       242477
     C*
     C** IF A TAKEDOWN
     C*
     C     F3TYPE        IFEQ      'OT'
     C*
     C** REDUCE BUY & SELL AMOUNTS
     C                   SUB       F3DAM1        FHDAM1
     C                   SUB       F3DAM2        FHDAM2
     C*
     C** REDUCE DEAL BASE CCY FOR ACCOUNTING EQUIVALENT
     C                   SUB       F3BCAE        FHBCAE
     C*
     C** REDUCE MARGIN AMOUNT
     C                   SUB       F3MGAM        FHMGAM
     C*
     C                   END
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      FHTMST  = TimeStamp                          CAP006
                                                                                CAP006
     C**  UPDATE RELATED DEAL
     C*
     C                   MOVEL     @F3CTL        @FHCTL
      *                                                                                       CDL010
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EXSR      USRUPD                                                     CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C                   UPDATE    FXDEALP0
      *                                                                         CDE001
      ** Data export for CCRM - Limits                                          CDE001
     C                   IF        CDE001 = 'Y'                                 CDE001
     C                   MOVEL     @F3DAN        T#TREF                         CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C**********         PARM                    T#TREF           20                   CDE001 CGL029
     C                   PARM                    T#TREF           26                          CGL029
     C                   PARM      'FXDL'        T#TCAT            4            CDE001
     C                   PARM      *BLANKS       T#RSRV           10            CDE005
     C                   ENDIF                                                  CDE001
     C*                                                                         154448
     C* STORE DETAILS OF AFTER STATUS OF RELATED DEAL                           154448
     C*                                                                         154448
     C                   MOVEL     FXDEAL        Z#XSTS                         154448
     C*
     C**  SAVE RELATED DEAL AMOUNTS
     C*
     C                   MOVE      FHOOFA        @@OOFA           15 0
     C                   MOVE      FHOOSA        @@OOSA           15 0
     C                   END
     C*
     C*
     C**  SET DEAL FIELDS ON INSERT
     C*
     C                   EXSR      SETINS
     C*
     C**  ACCESS DEAL
     C*
     C                   CLEAR                   FXDEAL
     C     F3DN38        CHAIN     FXDEALP0                           99
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     FXDEAL        Z#BSTS
     C*
     C**  UPDATE DEAL
     C*
     C                   MOVEL     FXVFXD        FXDEAL
     C*
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   IF        FHFRNT = *BLANKS                                           CSC011
     C                   MOVE      FHDN38        WDealNo                                      CSC011
     C                   EVAL      FHFRNT = 'MD' + WDealNo                                    CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        FHAFRT = *BLANKS                                           CSC011
     C                   IF        FHDADN <> *BLANKS                                          CSC011
     C                   EVAL      FHAFRT = 'MD' + FHDADN                                     CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EXSR      USRUPD                                                     CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                          CSD015
     C                             AND LIBR = S1MAIN)                                         CSD015
                                                                                              CSD015
     C                   MOVEL     FHRONS        WLF(1)                                       CSD015
     C                   MOVEL     FHROCN        WLF(2)                                       CSD015
     C                   MOVEL     FHRIBN        WLF(3)                                       CSD015
     C                   MOVEL     FHROBN        WLF(4)                                       CSD015
     C                   MOVEL     FHPONS        WLF(5)                                       CSD015
     C                   MOVEL     FHPOCN        WLF(6)                                       CSD015
     C                   MOVEL     FHRVNO        WLF(7)                                       CSD015
     C                   MOVEL     FHRCRN        WLF(8)                                       CSD015
     C                   MOVEL     FHPIBN        WLF(9)                                       CSD015
     C                   MOVEL     FHPOBN        WLF(10)                                      CSD015
     C                   MOVEL     FHAWBN        WLF(11)                                      CSD015
     C                   MoveL     FHBENN        WLF(12)                                      CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
     C                   DOU       Ctr >= Elements                                            CSD015
                                                                                              CSD015
     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
     C                   EVAL      WLOKFlg = 'Y'                                              CSD015
     C                   LEAVE                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = Ctr + 1                                              CSD015
                                                                                              CSD015
     C                   ENDDO                                                                CSD015
                                                                                              CSD015
     C                   IF        WLOKFlg = 'Y'                                              CSD015
     C                   EXSR      SrWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        CDL099 = 'Y'                                               CDL099
      *                                                                                       CDL099
     C                   IF        F3VS2Y = *ZEROS                                            CDL099
     C                   Z-ADD     FHVDYY        FHVS2Y                                       CDL099
     C                   Z-ADD     FHVDMM        FHVS2M                                       CDL099
     C                   Z-ADD     FHVDDD        FHVS2D                                       CDL099
     C                   Z-ADD     FHVDDN        FHS2DN                                       CDL099
      *                                                                                       CDL099
     C                   ELSE                                                                 CDL099
      *                                                                                       CDL099
     C                   EVAL      FHVS2Y = F3VS2Y                                            CDL099
     C                   EVAL      FHVS2D = F3VS2D                                            CDL099
     C                   EVAL      FHVS2M = F3VS2M                                            CDL099
     C                   EVAL      FHS2DN = F3S2DN                                            CDL099
      *                                                                                       CDL099
     C                   ENDIF                                                                CDL099
      *                                                                                       CDL099
     C                   EVAL      FHS1DN = 0                                                 CDL099
     C                   ENDIF                                                                CDL099
      *                                                                                       CDL099
     C*  WRITE (OR UPDATE IF PRESENT) NEW DEAL
     C*
     C     *IN99         IFEQ      '0'
     C                   UPDATE    FXDEALP0
     C                   ELSE
     C                   WRITE     FXDEALP0
     C/COPY WNCPYSRC,FXFXDLFC01
     C                   END
     C/COPY WNCPYSRC,FXFXDLFC04
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     FXDEAL        Z#ASTS
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* AMEND - FX Deal Amends                                        *
     C*                                                               *
     C*****************************************************************
     C     AMEND         BEGSR
     C*
     C**  ACCESS DEAL
     C*
     C     F3DN38        CHAIN     FXDEALP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     F3DN38        DBKEY
     C                   MOVEL     'FXDEALP0'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      SRERR
     C                   END
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     FXDEAL        Z#BSTS
     C/COPY WNCPYSRC,FXFXDLFC08
     C*
     C**  SET DEAL FIELDS ON AMEND
     C*
     C                   EXSR      SETAMD
      *                                                                                       CDL010
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EXSR      USRUPD                                                     CDL010
     C                   ENDIF                                                                CDL010
                                                                                              CSD015
     C                   If        CSD015 = 'Y' AND W1EWLC = 'Y'                              CSD015
     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                          CSD015
     C                             AND LIBR = S1MAIN)                                         CSD015
                                                                                              CSD015
     C                   EVAL      WFuncType = 'FXDEALPP'                                     CSD015
     C                   MOVEL     FHDN38        WIdntifier                                   CSD015
     C                   EVAL      WBranch = FHMBCA                                           CSD015
                                                                                              CSD015
     C     KCwFld        CHAIN     SDCWHTL1                                                   CSD015
                                                                                              CSD015
     C                   IF        %FOUND(SDCWHTL1) AND W3UNCF = 'Y'                          CSD015
                                                                                              CSD015
     C                   MOVEL     FHRONS        WLF(1)                                       CSD015
     C                   MOVEL     FHROCN        WLF(2)                                       CSD015
     C                   MOVEL     FHRIBN        WLF(3)                                       CSD015
     C                   MOVEL     FHROBN        WLF(4)                                       CSD015
     C                   MOVEL     FHPONS        WLF(5)                                       CSD015
     C                   MOVEL     FHPOCN        WLF(6)                                       CSD015
     C                   MOVEL     FHRVNO        WLF(7)                                       CSD015
     C                   MOVEL     FHRCRN        WLF(8)                                       CSD015
     C                   MOVEL     FHPIBN        WLF(9)                                       CSD015
     C                   MOVEL     FHPOBN        WLF(10)                                      CSD015
     C                   MOVEL     FHAWBN        WLF(11)                                      CSD015
     C                   MOVEL     FHBENN        WLF(12)                                      CSD015
     C                   EXSR      SrWatch                                                    CSD015
                                                                                              CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   MOVEA     *BLANKS       WLF                                          CSD015
                                                                                              CSD015
     C                   IF        FHRONS <> CHFHRONS                                         CSD015
     C                   MOVEL     FHRONS        WLF(1)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        FHROCN <> CHFHROCN                                         CSD015
     C                   MOVEL     FHROCN        WLF(2)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        FHRIBN <> CHFHRIBN                                         CSD015
     C                   MOVEL     FHRIBN        WLF(3)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        FHROBN <> CHFHROBN                                         CSD015
     C                   MOVEL     FHROBN        WLF(4)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        FHPONS <> CHFHPONS                                         CSD015
     C                   MOVEL     FHPONS        WLF(5)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        FHPOCN <> CHFHPOCN                                         CSD015
     C                   MOVEL     FHPOCN        WLF(6)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        FHRVNO <> CHFHRVNO                                         CSD015
     C                   MOVEL     FHRVNO        WLF(7)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        FHRCRN <> CHFHRCRN                                         CSD015
     C                   MOVEL     FHRCRN        WLF(8)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        FHPIBN <> CHFHPIBN                                         CSD015
     C                   MOVEL     FHPIBN        WLF(9)                                       CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        FHPOBN <> CHFHPOBN                                         CSD015
     C                   MOVEL     FHPOBN        WLF(10)                                      CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        FHAWBN <> CHFHAWBN                                         CSD015
     C                   MOVEL     FHAWBN        WLF(11)                                      CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        FHBENN <> CHFHBENN                                         CSD015
     C                   MOVEL     FHBENN        WLF(12)                                      CSD015
     C                   EVAL      WLChgFlg = 'Y'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   If        WLChgFlg = 'Y'                                             CSD015
     C                   EXSR      SrWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C*
     C**  UPDATE RECORD
     C*
     C                   EVAL      FHRRAT = F3RRAT                                            255340
     C                   UPDATE    FXDEALP0
     C*
     C**  UPDATE VALID DEAL
     C*
     C                   MOVEL     FXDEAL        FXVFXD
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     FXDEAL        Z#ASTS
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* AUTHOR - FX Deal Authorize                                    *
     C*                                                               *
     C*****************************************************************
     C     AUTHOR        BEGSR
     C*
     C**  ACCESS DEAL
     C*
     C     F3DN38        CHAIN     FXDEALP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     F3DN38        DBKEY
     C                   MOVEL     'FXDEALP0'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   EXSR      SRERR
     C                   END
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     FXDEAL        Z#BSTS
     C*
     C**  SET DEAL FIELDS ON AUTHORIZE
     C*
     C                   EXSR      SETAUT
     C*
      ** User Authorisation details when CDL010 is ON                                         CDL010
     C                   IF        CDL010 = 'Y'                                               CDL010
     C                   EVAL      F3USER = PUSRID                                           BUG7461
     C                   EXSR      USRUPD                                                     CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C**  UPDATE RECORD
     C*
     C                   UPDATE    FXDEALP0
     C*
     C**  UPDATE VALID DEAL
     C*
     C                   MOVEL     FXDEAL        FXVFXD
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     FXDEAL        Z#ASTS
     C/COPY WNCPYSRC,FXFXDLFC11
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* DELETE - FX Deal Deletes                                      *
     C*                                                               *
     C*****************************************************************
     C     DELETE        BEGSR
     C*
     C**  IF DEAL IS PART OF A SWAP, OR AN OPTION TAKEDOWN
     C*
     C     F3TYPE        IFEQ      'SW'
     C     F3TYPE        OREQ      'OT'
     C*
     C* ACCESS RELATED DEAL
     C*
     C     @F3DAN        CHAIN     FXDEALP0                           99
     C*
     C**  DATA BASE ERROR
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     @F3DAN        DBKEY
     C                   MOVEL     'FXDEALP0'    DBFILE
     C                   MOVEL     '004'         DBASE
     C                   EXSR      SRERR
     C                   END
     C*
     C**  STORE DETAILS OF RELATED DEAL
     C*
     C                   MOVEL     FXDEAL        Z#WSTS
     C*
     C** IF A SWAP
     C*
     C     F3TYPE        IFEQ      'SW'
     C*
     C** DELETE RELATED DEAL
     C                   MOVE      'D'           FHDDLT
     C                   MOVE      'D'           FHCHTP
     C                   MOVE      'D'           FHLACT                         154448
     C                   END
     C*
     C** IF A TAKEDOWN
     C*
     C     F3TYPE        IFEQ      'OT'
     C*
     C** INCREASE BUY & SELL AMOUNTS
     C                   ADD       F3DAM1        FHDAM1
     C                   ADD       F3DAM2        FHDAM2
     C*
     C** INCREASE DEAL BASE CCY FOR ACCOUNTING EQUIVALENT
     C                   ADD       F3BCAE        FHBCAE
     C*
     C** INCREASE MARGIN AMOUNT
     C                   ADD       F3MGAM        FHMGAM
     C*
     C                   END
     C*
      ** Timestamp                                                              CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      FHTMST  = TimeStamp                          CAP006
                                                                                CAP006
     C**  UPDATE RELATED DEAL
     C*
     C                   MOVEL     @F3CTL        @FHCTL
     C                   UPDATE    FXDEALP0
      *                                                                         CDE001
      ** Data export for CCRM - Limits                                          CDE001
     C                   IF        CDE001 = 'Y'                                 CDE001
     C                   MOVEL     @F3DAN        T#TREF                         CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C**********         PARM                    T#TREF           20                   CDE001 CGL029
     C                   PARM                    T#TREF                                       CGL029
     C                   PARM      'FXDL'        T#TCAT            4            CDE001
     C                   PARM      *BLANKS       T#RSRV           10            CDE005
     C                   ENDIF                                                  CDE001
     C*                                                                         154448
     C* STORE DETAILS OF AFTER STATUS OF RELATED DEAL                           154448
     C*                                                                         154448
     C                   MOVEL     FXDEAL        Z#XSTS                         154448
     C                   END
     C*
     C**  ACCESS DEAL
     C*
     C     F3DN38        CHAIN     FXDEALP0                           99
     C*
     C**  DATA BASE ERROR IF NOT FOUND
     C*
     C     *IN99         IFEQ      '1'
     C                   MOVEL     F3DN38        DBKEY
     C                   MOVEL     'FXDEALP0'    DBFILE
     C                   MOVEL     '005'         DBASE
     C                   EXSR      SRERR
     C                   END
     C*
     C**  UPDATE 'BEFORE' STATUS
     C*
     C                   MOVEL     FXDEAL        Z#BSTS
     C*
     C**  SET DEAL FIELDS ON DELETE
     C*
     C                   EXSR      SETDEL
                                                                                208884
      ** Send a User Defined Journal Entry to simulate a delete from repair     208884
     C     FHDSTS        IFNE      'A'                                          208884
     C     FHDSTS        ANDNE     'R'                                          208884
     C     FHFRNT        ANDNE     *BLANKS                                      208884
     C                   MOVE      'D'           RACTN                          208884
     C                   MOVE      FHFRNT        RFOTRANID                      208884
     C                   MOVE      FHDN38        RDLNO                          208884
     C                   MOVEL     *BLANKS       EntryData                      208884
     C                   MOVEL     *BLANKS       FileName                       208884
     C                   CALL      'RPC1600'                                    208884
     C                   PARM      InvRp         EntryData      3000            208884
     C                   PARM      'FXIFXDLPD'   FileName         10            208884
     C                   ENDIF                                                  208884
     C*
     C**  UPDATE RECORD
     C*
     C                   UPDATE    FXDEALP0
     C*
     C**  UPDATE VALID DEAL
     C*
     C                   MOVEL     FXDEAL        FXVFXD
     C*
     C**  UPDATE 'AFTER' STATUS
     C*
     C                   MOVEL     FXDEAL        Z#ASTS
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
      ** Deal value date - yyyy       F3VDYY
      ** Deal value date - mm         F3VDMM
      ** Deal value date - dd         F3VDDD
      **  CONVERT VALUE DATE FROM DAY NUMBER TO YMD
      **
     C                   Z-ADD     F3VDDN        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @F3VDY
      **
      ** Deal transaction date - yyyy F3DTYY
      ** Deal transaction date - mm   F3DTMM
      ** Deal transaction date - dd   F3DTDD
      **  CONVERT RUN DATE FROM DAY NUMBER TO YMD
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @F3TDY
      **
      ** Option end date year           F3DOEY
      ** Option end date month          F3DOEM
      ** Option end date day            F3DOED
      **
     C     F3OTDN        IFNE      *ZERO
     C                   Z-ADD     F3OTDN        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @F3OEY
     C                   ELSE
     C                   Z-ADD     *ZERO         @F3OEY
     C                   END
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'I'           @@ACTN            1
     C                   PARM      *BLANK        @@CSTS            1
     C                   PARM                    BNFXAU
     C                   PARM                    BNFXRA
     C                   PARM      *BLANK        @@FSTS            1
     C                   PARM      *BLANK        @@CHTP            1
     C                   MOVEL     @@FSTS        F3DSTS
     C                   MOVEL     @@CHTP        F3CHTP
     C/COPY WNCPYSRC,FXFXDLFC13
      *
      ** Determine deal type indicator
      *
     C     F3TYPE        IFEQ      'FP'
     C     F3TYPE        OREQ      'FS'
     C     F3TYPE        OREQ      'PI'
     C     F3TYPE        OREQ      'SI'
     C     F3TYPE        OREQ      'CX'
     C                   MOVE      *BLANKS       F3DTYP
     C                   END
      *
     C     F3TYPE        IFEQ      'SW'
     C                   MOVE      'S'           F3DTYP
     C                   END
      *
     C     F3TYPE        IFEQ      'OP'
     C                   MOVE      'O'           F3DTYP
     C                   END
      *
     C     F3TYPE        IFEQ      'OT'
     C                   MOVE      'T'           F3DTYP
     C                   END
     C*
     C** BUY AND SELL AMOUNT AND CCY
     C*
     C                   Z-ADD     F3DAM1        F3DBUY
     C                   Z-SUB     F3DAM2        F3DSEL
      **
      ** Deal authorisation officer
      **
     C     @@FSTS        IFEQ      'A'
     C                   MOVEL     PSUser        F3AOFR
     C                   END
      **
      ** Deal user code
      **
     C                   MOVEL     PSUser        F3DUSC
      **
      ** Deal done date - yyyy        F3DDYY
      ** Deal done date - mm          F3DDMM
      ** Deal done date - dd          F3DDDD
      **
     C                   Z-ADD     F3DDDN        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @F3DDY
      **
      ** ALRECI - ALTERNATIVE RECEIVE INSTRUCTIONS
      **
     C                   EXSR      ALRECI
      **
      ** ALPAYI - ALTERNATIVE PAYMENT INSTRUCTIONS
      **
     C                   EXSR      ALPAYI
      **
      ** Time of input
      **
     C                   TIME                    F3ETIM
      *
      ** IF DEAL IS AN OPTION
     C     F3DTYP        IFEQ      'O'
     C                   MOVE      F3DAM1        F3OOFA
     C                   MOVE      F3DAM2        F3OOSA
     C                   END
      *
      ** IF DEAL IS A TAKEDOWN
     C     F3DTYP        IFEQ      'T'
     C                   MOVE      @@OOFA        F3OOFA
     C                   MOVE      @@OOSA        F3OOSA
     C                   END
      **
      ** Deal action date
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          F3ADAT
      **                                                                        CAP006
      ** Timestamp                                                              CAP006
      **                                                                        CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      F3TMESTMP = TimeStamp                        CAP006
                                                                                CAP006
      **                                                                        CAP006
      ** Automatic Authorisation flag                                           CAP051
      *                                                                         CAP051
     C     CAP051        IFEQ      'Y'                                          CAP051
     C                   MOVEL     F3AUTH        FHAUTH                         CAP051
     C                   ELSE                                                   CAP051
     C                   MOVE      *BLANKS       FHAUTH                         CAP051
     C                   ENDIF                                                  CAP051
      *                                                                         CAP051
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
     C                   MOVEL     @F3CTL        @FHCTL
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'A'           @@ACTN
     C                   PARM      FHDSTS        @@CSTS
     C                   PARM                    BNFXAU
     C                   PARM                    BNFXRA
     C                   PARM      *BLANK        @@FSTS
     C                   PARM      *BLANK        @@CHTP
     C                   MOVEL     @@FSTS        FHDSTS
     C                   MOVEL     @@CHTP        FHCHTP
      *
      ** Deal customer shortname
      ** Deal customer number
      *
     C                   MOVEL     F3DCSN        FHDCSN
     C                   MOVEL     F3DCNO        FHDCNO
      **
      ** Deal user code
      **
     C                   MOVEL     PSUser        FHDUSC
      *
      ** Deal branch code
      ** Branch code (alpha)
      *
     C                   MOVEL     F3DBRC        FHDBRC
     C                   MOVEL     F3MBCA        FHMBCA
      *
      ** Deal done date - yyyy
      ** Deal done date - mm
      ** Deal done date - dd
      *
     C                   Z-ADD     F3DDDN        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          @FHDDY
      **
      ** ALRECI - ALTERNATIVE RECEIVE INSTRUCTIONS
      **
     C                   EXSR      ALRECI
     C                   MOVEL     @F3ALR1       @FHALR1
     C                   MOVEL     @F3ALR2       @FHALR2
     C                   MOVEL     F3DORI        FHDORI                                       CGL029
     C                   MOVEL     F3MORI        FHMORI                                       CGL029
      **
      ** ALPAYI - ALTERNATIVE PAYMENT INSTRUCTIONS
      **
     C                   EXSR      ALPAYI
     C                   MOVEL     @F3ALP1       @FHALP1
     C                   MOVEL     @F3ALP2       @FHALP2
     C                   MOVEL     F3DOPI        FHDOPI                                       CGL029
     C                   MOVEL     F3MOPI        FHMOPI                                       CGL029
      *
      ** Deal sub type
      *
     C                   MOVEL     F3STYP        FHSTYP
      *
      ** Broker code
      ** Deal brokerage
      ** Broker currency code
      *
     C                   MOVEL     F3BROK        FHBROK
     C                   MOVEL     F3BRKG        FHBRKG
     C                   MOVEL     F3BKCY        FHBKCY
      **
      ** Deal last action
      **
     C                   MOVEL     'A'           FHLACT
      **
      ** Deal action date
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          FHADAT
      *
      ** Fed funds indicator
      *
     C                   MOVEL     F3FEDF        FHFEDF
      *
      ** Book Code
      *
     C                   MOVEL     F3BOKC        FHBOKC
      *
      ** LINKED DEAL NUMBER
      *
     C                   MOVEL     F3LNKN        FHLNKN
      **
      ** Extended Receipt Instructions
      **
     C                   MOVEL     @F3REC        @FHREC
     C                   MOVEL     F3RONS        FHRONS                                       CGL029
                                                                                              CGL029
     C/COPY WNCPYSRC,FXFXDLFC05
      **
      ** Extended Payment Instructions
      **
     C                   MOVEL     @F3PAY        @FHPAY
     C                   MOVEL     F3PONS        FHPONS                                       CGL029
      *                                                                                       CSW212
     C                   IF        CSW212 = 'Y'                                               CSW212
     C                   MOVEL     @F3ISDA       @FHISDA                                      CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
      * Enhanced Receive Settlement Instructions                                              CDL094
     C                   MOVEL     F3RBB1        FHRBB1                                       CDL094
     C                   MOVEL     F3RBB2        FHRBB2                                       CDL094
     C                   MOVEL     F3RBB3        FHRBB3                                       CDL094
     C                   MOVEL     F3RBB4        FHRBB4                                       CDL094
     C                   MOVEL     F3RBB5        FHRBB5                                       CDL094
     C                   MOVEL     F3RBB6        FHRBB6                                       CDL094
     C/COPY WNCPYSRC,FXFXDLFC06
      *
      ** Originating branch
      *
     C                   MOVEL     F3ORBR        FHORBR
      *
      ** Profit centre
      *
     C                   MOVEL     F3PRFC        FHPRFC
      *
      ** Our Receive Branch
      ** Our Pay Branch
      *
     C                   MOVEL     F3ROBR        FHROBR
     C                   MOVEL     F3POBR        FHPOBR
      *
      ** COVER MESSAGE REQUIRED
      *
     C                   MOVEL     F3CVMR        FHCVMR
      *
      ** Buy forward Points amount
      ** Sell forward Points amount
      ** Input DL base spot rate
      ** Other DL base spot rate
      ** Other DL base spot equiv
      ** Buy DL base fwd points
      ** Sell DL base fwd points
      ** Buy DL base fwd amount
      ** Sell DL base fwd amount
      *
     C                   MOVE      F3BFPA        FHBFPA
     C                   MOVE      F3SFPA        FHSFPA
     C                   MOVE      F3BDBS        FHBDBS
     C                   MOVE      F3SDBS        FHSDBS
     C                   MOVE      F3SDBE        FHSDBE
     C                   MOVE      F3BDBF        FHBDBF
     C                   MOVE      F3SDBF        FHSDBF
     C                   MOVE      F3BDFA        FHBDFA
     C                   MOVE      F3SDFA        FHSDFA
      *
      ** Portfolio reference
      *
     C                   MOVEL     F3PTFR        FHPTFR
      *
      ** FX Netting fields
      *
     C                   MOVEL     F3NBUY        FHNBUY
     C                   MOVE      F3NBRF        FHNBRF
     C                   MOVEL     F3NSEL        FHNSEL
     C                   MOVE      F3NSRF        FHNSRF
     C                   MOVEL     F3MTCH        FHMTCH
      **
      ** EMU Settlement fields
      **
     C                   MOVEL     F3RSCY        FHRSCY
     C                   MOVEL     F3PSCY        FHPSCY
     C                   MOVEL     F3IC72        FHIC72
      *                                                                         CDL008
      ** Move screen field to file field if feature CDL008                      CDL008
      ** is installed.                                                          CDL008
     C                   IF        CDL008 = 'Y'                                 CDL008
     C                   EVAL      FHCLSS = F3CLSS                              CDL008
     C                   ENDIF                                                  CDL008
                                                                                              CAS001
      ** Yield Curves                                                                         CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y'                                               CAS001
     C/COPY WNCPYSRC,FXH00238
     C                   EVAL      FHOYLC = F3OYLC                                            CAS001
     C                   EVAL      FHTYLC = F3TYLC                                            CAS001
     C                   ENDIF                                                                CAS001
      *
      ** Deal date day number
      *
     C                   MOVEL     F3DDDN        FHDDDN
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C     F3FRNT        IFNE      *BLANKS                                      228662
     C                   MOVEL     F3FRNT        FHFRNT                         CAP013
     C                   ENDIF                                                  228662
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C     F3AFRT        IFNE      *BLANKS                                      228662
     C                   MOVEL     F3AFRT        FHAFRT                         CAP013
     C                   ENDIF                                                  228662
      *                                                                         CAP051
      ** Automatic Authorisation flag                                           CAP051
      *                                                                         CAP051
     C     CAP051        IFEQ      'Y'                                          CAP051
     C                   MOVEL     F3AUTH        FHAUTH                         CAP051
     C                   ELSE                                                   CAP051
     C                   MOVE      *BLANKS       FHAUTH                         CAP051
     C                   ENDIF                                                  CAP051
      *                                                                         CAP006
      ** Timestamp                                                              CAP006
      *                                                                         CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      FHTMST  = TimeStamp                          CAP006
                                                                                CAP006
      **                                                                        CAP006
      ** Class                                                                  CDL038
      *                                                                         CDL038
     C                   MOVEL     F3CLAS        FHCLAS                         CDL038
      *                                                                         CDL038
      **  Reciprocal rate indicator                                                           CER043
      *                                                                                       CER043
     C                   IF        CER043 = 'Y'                                               CER043
     C                   EVAL      FHREIN = F3REIN                                            CER043
     C                   ENDIF                                                                CER043
      *                                                                                       CER043
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
     C                   MOVEL     @F3CTL        @FHCTL
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'X'           @@ACTN
     C                   PARM      FHDSTS        @@CSTS
     C                   PARM                    BNFXAU
     C                   PARM                    BNFXRA
     C                   PARM      *BLANK        @@FSTS
     C                   PARM      *BLANK        @@CHTP
     C                   MOVEL     @@FSTS        FHDSTS
     C                   MOVEL     @@CHTP        FHCHTP
      **
      ** Deal last action
      **
     C                   MOVEL     'X'           FHLACT
      **
      ** Deal authorisation officer
      **
     C                   MOVEL     PSUser        FHAOFR
      **
      ** Deal action date
      **
     C                   Z-ADD     BJRDNB        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          FHADAT
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C     F3FRNT        IFNE      *BLANKS                                      228662
     C                   MOVEL     F3FRNT        FHFRNT                         CAP013
     C                   ENDIF                                                  228662
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C     F3AFRT        IFNE      *BLANKS                                      228662
     C                   MOVEL     F3AFRT        FHAFRT                         CAP013
     C                   ENDIF                                                  228662
      *                                                                         CAP006
      ** Timestamp                                                              CAP006
      *                                                                         CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      FHTMST  = TimeStamp                          CAP006
                                                                                CAP006
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
     C                   MOVEL     @F3CTL        @FHCTL
      *
      ** FLAG AS 'DELETED'
      *
     C                   MOVEL     'D'           FHDDLT
      **
      ** Deal Status and Change Type
      **
     C                   CALLB     'ZAFUTSTATP'
     C                   PARM      'D'           @@ACTN
     C                   PARM      FHDSTS        @@CSTS
     C                   PARM                    BNFXAU
     C                   PARM                    BNFXRA
     C                   PARM      *BLANK        @@FSTS
     C                   PARM      *BLANK        @@CHTP
     C                   MOVEL     @@FSTS        FHDSTS
     C                   MOVEL     @@CHTP        FHCHTP
      **
      ** If deal is part of a swap, dealing database updates must ALWAYS
      ** be done. Although this leg may not be authorized, the other leg
      ** might be.
      **
     C     F3TYPE        IFEQ      'SW'
     C                   MOVEL     'R'           FHCHTP
     C                   END
      **
      ** Deal last action
      **
     C                   MOVEL     'D'           FHLACT
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     F3FRNT        FHFRNT                         CAP013
      *                                                                         CAP013
      ** Associated front office transaction ID                                 CAP013
      *                                                                         CAP013
     C                   MOVEL     F3AFRT        FHAFRT                         CAP013
      *                                                                         CAP006
      ** Timestamp                                                              CAP006
      *                                                                         CAP006
     C                   CALLB     'ZAGENTMSTM'                                 CAP006
     C                   PARM                    TimeStamp                      CAP006
                                                                                CAP006
     C                   EVAL      FHTMST  = TimeStamp                          CAP006
                                                                                CAP006
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
     C     F3RSCY        IFNE      *BLANKS
     C                   MOVEL     F3RSCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     F3CCY1        EffSetCcy         3
     C                   ENDIF
      *
      * DETERMINE ALTERNATIVE RECEIVE INSTRUCTIONS
      *
     C                   CALLB     'ZAALTRECIN'
      ** Customer number                                                                      200400
     C**********         PARM      F3DCNO        ##CNUM            6 0                 200400 CSD027
     C                   PARM      F3DCNO        ##CNUM            6                          CSD027
      ** Rec currency
     C                   PARM      EffSetCcy     ##RCCY            3
      ** Rec - settlement method
     C                   PARM      F3RSTM        ##RSTM            2 0
      ** Rec - our nostro
     C**********         PARM      F3RONS        ##RONS           12                          CGL029
     C                   PARM      F3RONS        ##RONS           18                          CGL029
      ** rec - intermediary bank
     C                   PARM      F3RIBN        ##RIBN            8
      ***MIDAS*Our*Receive*Instructions*(*for*Settlm*Meth*'04'*)*********              179510 200400
     C************       PARM                    F3MORI                                179510 200400
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
     C                   Z-ADD     ##ORCM        F3ORCM
     C*
     C** SETTLEMENT TYPE - FRONT OFFICE
     C*
     C                   MOVEL     ##DORM        F3DORM
     C*
     C** OUR SETTLEMENT ACCOUNT - MIDAS
     C*
     C                   MOVEL     ##MORI        F3MORI
     C*
     C** OUR SETTLEMENT ACCOUNT - FRONT OFFICE
     C*
     C                   MOVEL     ##DORI        F3DORI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - MIDAS
     C*
     C                   MOVEL     ##MCPI        F3MCPI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - FRONT OFFICE
     C*
     C                   MOVEL     ##DCPI        F3DCPI
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
     C     F3PSCY        IFNE      *BLANKS
     C                   MOVEL     F3PSCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     F3CCY2        EffSetCcy         3
     C                   ENDIF
      *
      * DETERMINE ALTERNATIVE PAYMENT INSTRUCTIONS
      *
     C                   CALLB     'ZAALTPAYIN'
      ** Customer number                                                                      200400
     C**********         PARM      F3DCNO        ##CNUM            6 0                 200400 CSD027
     C                   PARM      F3DCNO        ##CNUM            6                          CSD027
      ** Pay currency
     C                   PARM      EffSetCcy     ##PCCY            3
      ** Pay - settlement method
     C                   PARM      F3PSTM        ##PSTM            2 0
      ** Pay - our nostro
     C**********         PARM      F3PONS        ##PONS           12                          CGL029
     C                   PARM      F3PONS        ##PONS           18                          CGL029
      ** account with bank
     C                   PARM      F3AWBN        ##AWBN            8
      ** beneficiary
     C                   PARM      F3BENN        ##BENN            8
      ** bank to bank info 1
     C                   PARM      F3BTB1        ##BTB1           35
      ***MIDAS*Our Pay  Instructions ( for Settlm Meth '04' )                          179510 200400
     C************       PARM                    F3MOPI                                179510 200400
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
     C                   MOVEL     ##MOPM        F3MOPM
     C*
     C** SETTLEMENT TYPE - FRONT OFFICE
     C*
     C                   MOVEL     ##DOPM        F3DOPM
     C*
     C** OUR SETTLEMENT ACCOUNT - MIDAS
     C*
     C                   MOVEL     ##MOPI        F3MOPI
     C*
     C** OUR SETTLEMENT ACCOUNT - FRONT OFFICE
     C*
     C                   MOVEL     ##DOPI        F3DOPI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - MIDAS
     C*
     C                   MOVEL     ##MCRI        F3MCRI
     C*
     C** CUSTOMER'S COUNTERPARTY NOSTRO - FRONT OFFICE
     C*
     C                   MOVEL     ##DCRI        F3DCRI
     C*
     C** FOR ACCOUNT OF - MIDAS
     C*
     C                   MOVEL     ##MFAO        F3MFAO
     C*
     C** FOR ACCOUNT OF - FRONT OFFICE
     C*
     C                   MOVEL     ##DFAC        F3DFAC
     C*
     C**  Special instructions.
     C*
     C                   MOVEL     ##SPEC        F3SPEC
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
     C                   MOVEL     'FH'          F3RCID
      **
      ** Logical delete flag
      **
     C                   MOVEL     *BLANK        F3DLTF
      **
      ** Day of last update
      **
     C                   Z-ADD     @DLUP         F3DLUP
      **
      ** Month of last update
      **
     C                   MOVEL     @MLUP         F3MLUP
      **
      ** Year of last update
      **
     C                   Z-ADD     @YLUP         F3YLUP
      **
      ** Time of last update
      **
     C                   TIME                    F3TLUP
      **
      ** Type of last change (set later in this program)
      **
     C                   MOVEL     F3CHTP        F3CHTP
      **
      ** Last change date
      **
     C                   Z-ADD     BJRDNB        F3LCD
      **
      ** Last update user id
      **
     C                   MOVEL     PSUser        F3LUID
      **
     C                   ENDSR
     C*****************************************************************
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
     C     F3USER        IFEQ      *BLANKS                                                    CDL010
     C                   EVAL      FHUSER = PSuser                                            CDL010
     C                   ELSE                                                                 CDL010
     C                   EVAL      FHUSER = F3USER                                            CDL010
     C                   ENDIF                                                                CDL010
      *                                                                                       CDL010
     C                   ENDSR                                                                CDL010
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
     C                   MOVE      F3DN38        MidasDlNum        6            CAP006
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
      *                 b) action code is Insert - 'I'                          168345
      *                 c) Front-Office Id is NOT Blank                         168345
      *                                                                         168345
     C     @Type         IFEQ      '1'                                          168345
     C     F3LACT        ANDEQ     'I'                                          168345
     C     F3FRNT        ANDNE     *BLANKS                                      168345
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
     C     F3LACT        ANDEQ     'I'                                          CAP013
     C                   MOVE      '*FRONT'      @@MODE                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      *BLANKS       @@MODE                         CAP006
     C                   END                                                    CAP006
      *                                                                         168345
     C                   END                                                    168345
                                                                                CAP006
     C                   CALLB     'FXFXDLRTV'                                  CAP006
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
     C                   PARM                    F3LACT                         CAP006
      *                                                                         CAP006
      * Front Office Transaction ID                                             CAP006
     C                   PARM      F3FRNT        FOTRID           20            CAP006
      *                                                                         CAP006
      * Front Office Associated Transaction Id                                  CAP006
     C                   PARM      F3AFRT        FOASID           20            CAP006
      *                                                                         CAP006
      * (Midas) Deal Number                                                     CAP006
     C                   PARM                    MidasDlNum                     CAP006
      *                                                                         CAP006
      * (Midas) Swap/Option Deal Number                                         CAP006
     C                   PARM                    DDSDNO            6            CAP006
      *                                                                         CAP006
      * Booking branch                                                          CAP006
     C                   PARM      F3DBRC        DDBRSN            3            CAP006
      *                                                                         CAP006
      * Originating branch                                                      CAP006
     C                   PARM      F3ORBR        DDORBR            3            CAP006
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
     C                   PARM      *BLANK        OKBRSN                         CAP006
      *                                                                         CAP006
      * OK - Originating branch                                                 CAP006
     C                   PARM                    OKORBR                         CAP006
      *                                                                         CAP006
      * Error fields/message IDs/message data (arrays) from/to caller           CAP006
     C                   PARM      *BLANK        FldNameArr                     CAP006
     C                   PARM      *BLANK        MsgIdArr                       CAP006
     C                   PARM      *BLANK        MsgDtaArr                      CAP006
      *                                                                         CAP006
      * Array index (3P0) from/to caller                                        CAP006
     C                   PARM      *ZERO         Idx               3 0          CAP006
                                                                                              CAS004
      ** Warning error fields/message IDs/message data (arrays) from/to caller                CAS004
                                                                                              CAS004
     C                   PARM      *BLANKS       WFldNamArr                                   CAS004
     C                   PARM      *BLANKS       WMsgIdArr                                    CAS004
     C                   PARM      *BLANKS       WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Warning array index (3P0) from/to caller                                             CAS004
                                                                                              CAS004
     C                   PARM      *ZEROS        WIdx                                         CAS004
                                                                                              CAS004
     C/COPY WNCPYSRC,FXFXDLFC10
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
     C     CHFHTMST      IFNE      F3TMESTMP                                    CAP006
     C     F3LACT        ANDNE     'I'                                          184720
     C*****F3LACT        ANDNE     'D'                                               247266 BUG27841
     C*****F3LACT        ANDNE     'X'                                               247266 BUG27841
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
     C/COPY WNCPYSRC,FXH00192
     C                   CALL      'AOOUFXU0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
     C                   PARM                    Z#XSTS                         154448
     C/COPY WNCPYSRC,FXH00216
     C     @RTCD         IFEQ      '*ERROR*'
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     'AOOUFXU0'    DBFILE
     C                   MOVEL     '991'         DBASE
     C                   EXSR      SRERR
     C                   END
     C/COPY WNCPYSRC,FXFXDLFC12
      *                                                                         CDE001
      ** Data export for CCRM - Limits                                          CDE001
     C                   IF        CDE001 = 'Y'                                 CDE001
     C                   MOVEL     F3DN38        T#TREF                         CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C**********         PARM                    T#TREF           20                   CDE001 CGL029
     C                   PARM                    T#TREF                                       CGL029
     C                   PARM      'FXDL'        T#TCAT            4            CDE001
     C                   PARM      *BLANKS       T#RSRV           10            CDE005
     C                   ENDIF                                                  CDE001
     C/COPY WNCPYSRC,FXH00193
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        F3LACT = 'A' OR                                            CRE020
     C                             F3LACT = 'D'                                               CRE020
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
     C*******************CALL      'FXFXDLUPT'                                  136434
     C                   CALLB     'FXFXDLUPT'                                  136434
     C                   PARM      *BLANK        @RTCD
     C                   PARM      F3LACT        @LACT             1
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS                         136434
     C     @RTCD         IFEQ      '*ERROR '
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     'FXFXDLUPT'   DBFILE
     C                   MOVEL     '992'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
     C                   ENDSR
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
     C                   EVAL      KRefNo = *BLANKS                                           CRE020
     C                   MOVEL     FHDN38        KRefNo                                       CRE020
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
     C                             FHLACT = 'D'                                               CRE020
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
     C                   PARM                    FXVFXD
     C/COPY WNCPYSRC,FXFXDLFC14
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
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      SRERR
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
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      SRERR
     C                   END
      *                                                                         CAP051
      *  Check if feature CAP051 is switched on                                 CAP051
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
     C                   MOVE      BNFXAU        SAVFXAU           1            CAP051
     C                   MOVE      BNFXRA        SAVFXRA           1            CAP051
      *                                                                         CDL008
      ** Access SAR details file to determine if CDL008 is on.                  CDL008
      ** (Continuous Linked Settlement)                                         CDL008
      *                                                                         CDL008
     C                   CALLB     'AOSARDR0'                                   CDL008
     C                   PARM      *BLANKS       @RTCD                          CDL008
     C                   PARM      '*VERIFY'     @OPTN                          CDL008
     C                   PARM      'CDL008'      @SAR                           CDL008
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL008
     C     @RTCD         IFNE      *BLANKS                                      CDL008
     C     @RTCD         ANDNE     '*NRF   '                                    CDL008
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL008
     C                   MOVEL     '903'         DBASE                          CDL008
     C                   MOVEL     'CDL008'      DBKEY                          CDL008
     C                   EXSR      SRERR                                        CDL008
     C                   ENDIF                                                  CDL008
     C     @RTCD         IFEQ      *BLANKS                                      CDL008
     C                   MOVEL     'Y'           CDL008            1            CDL008
     C                   ELSE                                                   CDL008
     C                   MOVEL     'N'           CDL008                         CDL008
     C                   ENDIF                                                  CDL008
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
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS001
     C                   EVAL      DBASE = 904                                                CAS001
     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
     C                   EXSR      SRERR                                                      CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
     C                   IF        PRTCD = *BLANKS                                            CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   ENDIF                                                                CAS001
     C/COPY WNCPYSRC,FXH00239
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
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      SRERR
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
     C*
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
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        (PRtCd <> '*NRF') and                                      CSC011
     C                             (PRtCd <> *Blanks)                                         CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 904                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
      *************                                                                  CAP084  BUG5517
     C******DTAARA*      DEFINE                  ZMUSER                              CAP084  BUG5517
     C*************      IN        ZMUSER                                            CAP084  BUG5517
     C*************      EVAL      PSUser = PUSRID                                   CAP084  BUG5517
                                                                                              CAP084
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSC011
      ** Check if Compliance Watch Enhancment (CSD015) is on.                                 CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRetCode <> *BLANKS) and                                  CSD015
     C                             (PRetCode <> '*NRF   ')                                    CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 907                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRetCode = *BLANKS                                         CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*FIRST'      POption                                      CSD015
     C     SDCWCD        PARM      SDCWCD        DSSDY                                        CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> *BLANKS                                        CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = POption                                            CSD015
     C                   EVAL      DBFILE = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBASE = 909                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   END                                                                  CSD015
                                                                                              CSD015
      ** Access Compliance Watch Transaction details                                          CSD015
                                                                                              CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*KEY    '    POption                                      CSD015
     C                   PARM      'DEALING '    PFunc                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database Error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> *BLANKS                                        CSD015
     C                             AND PRetCode <> '*NRF'                                     CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = PFunc                                              CSD015
     C                   EVAL      DBFILE = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBASE = 908                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      CCF001 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CCF001'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRetCode <> *BLANKS) and                                  CSD015
     C                             (PRetCode <> '*NRF   ')                                    CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CCF001'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 910                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRetCode = *BLANKS                                         CSD015
     C                   EVAL      CCF001 = 'Y'                                               CSD015
     C                   EndIf                                                                CSD015
                                                                                              CSD015
     C     KCwFld        KLIST                                                                CSD015
     C                   KFLD                    WFuncType                                    CSD015
     C                   KFLD                    WIdntifier                                   CSD015
     C                   KFLD                    WBranch                                      CSD015
                                                                                              CSD015
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
                                                                                              CRE020
     C**  READ DTAARA/RUNDAT to access MULTI-BRANCHING flag.
     C*
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
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL010
     C                   EVAL      DBASE = 905                                                CDL010
     C                   EVAL      DBKEY = 'CDL010'                                           CDL010
     C                   EXSR      SRERR                                                      CDL010
     C                   ENDIF                                                                CDL010
     C                   IF        PRTCD = *BLANKS                                            CDL010
     C                   EVAL      CDL010 = 'Y'                                               CDL010
     C                   ELSE                                                                 CDL010
     C                   EVAL      CDL010 = 'N'                                               CDL010
     C                   ENDIF                                                                CDL010
                                                                                              CDL010
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
     C                   EVAL      DBase = 906                                                CRE020
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
     C                   EVAL      DBase = 907                                                CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRtCd                                        CSD083
     C                   PARM      '*VERIFY'     POptn                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRtCd <> *BLANKS AND                                       CSD083
     C                             PRtCd <> '*NRF'                                            CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 912                                                CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      SRErr                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRtCd = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
      *                                                                                       CER043
      ** Call AOSARDR0 to check if CER043 is switched on                                      CER043
      *                                                                                       CER043
     C                   EVAL      CER043 = 'N'                                               CER043
     C                   CALLB     'AOSARDR0'                                                 CER043
     C                   PARM      *BLANKS       PRTCD                                        CER043
     C                   PARM      '*VERIFY'     POPTN                                        CER043
     C                   PARM      'CER043'      PSARD                                        CER043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER043
                                                                                              CER043
     C                   IF        PRTCD <> *BLANKS AND                                       CER043
     C                             PRTCD <> '*NRF   '                                         CER043
     C     *LOCK         IN        LDA                                                        CER043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER043
     C                   EVAL      DBASE = 912                                                CER043
     C                   EVAL      DBKEY = 'CER043'                                           CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      SRERR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   IF        PRTCD = *BLANKS                                            CER043
     C                   EVAL      CER043 = 'Y'                                               CER043
     C                   ENDIF                                                                CER043
     C/COPY WNCPYSRC,FXH00077
                                                                                              CER043
      *                                                                                       CSW212
      ** Check if SWIFT 2012 is on                                                            CSW212
      *                                                                                       CSW212
     C                   MOVEL     *BLANKS       CSW212            1                          CSW212
     C                   CALL      'SWIF2012'                                                 CSW212
     C                   PARM      *BLANKS       PRtCd                                        CSW212
      *                                                                                       CSW212
     C                   IF        PRtCd = 'CSW2012'                                          CSW212
     C                   EVAL      CSW212 = 'Y'                                               CSW212
     C                   ELSE                                                                 CSW212
     C                   EVAL      CSW212 = 'N'                                               CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
      ** Call AOSARDR0 to check if CDL099 is switched on                                      CDL099
      *                                                                                       CDL099
     C                   EVAL      CDL099 = 'N'                                               CDL099
     C                   CALLB     'AOSARDR0'                                                 CDL099
     C                   PARM      *BLANKS       PRTCD                                        CDL099
     C                   PARM      '*VERIFY'     POPTN                                        CDL099
     C                   PARM      'CDL099'      PSARD                                        CDL099
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL099
                                                                                              CDL099
     C                   IF        PRTCD <> *BLANKS AND                                       CDL099
     C                             PRTCD <> '*NRF   '                                         CDL099
     C     *LOCK         IN        LDA                                                        CDL099
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL099
     C                   EVAL      DBASE = 913                                                CDL099
     C                   EVAL      DBKEY = 'CDL099'                                           CDL099
     C                   OUT       LDA                                                        CDL099
     C                   EXSR      SRERR                                                      CDL099
     C                   ENDIF                                                                CDL099
                                                                                              CDL099
     C                   IF        PRTCD = *BLANKS                                            CDL099
     C                   EVAL      CDL099 = 'Y'                                               CDL099
     C                   ENDIF                                                                CDL099
      *                                                                                       CDL099
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C/COPY WNCPYSRC,FXFXDLFC02
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRWatch - Initiates the Midas Compliance Engine.              *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRWatch       BEGSR                                                                CSD015
                                                                                              CSD015
      ** Initialise the Transaction Details parameter.                                        CSD015
                                                                                              CSD015
     C                   CLEAR                   SDWLTD                                       CSD015
                                                                                              CSD015
      ** Setup First Parameter                                                                CSD015
                                                                                              CSD015
     C                   CAT       'FX':0        W4ITEM                                       CSD015
     C                   CAT       FHTYPE:0      W4ITEM                                       CSD015
                                                                                              CSD015
     C                   MOVEL     FHDN38        W4IDEN                                       CSD015
     C                   EVAL      W4BRCH = FHDBRC                                            CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'Y'                                               CSD015
     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      W4FUNT = 'FXDEALPP'                                        CSD015
                                                                                              CSD015
     C                   MOVEL     FHDCNO        PCUST                                        CSD015
     C                   CALLB     'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       PRetCode                                     CSD015
     C                   PARM      '*KEY'        POption                                      CSD015
     C                   Parm                    PCUST                                        CSD015
     C                   PARM      *BLANKS       PSTKEY                                       CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
                                                                                              CSD015
     C                   IF        PRetCode <> *BLANKS                                        CSD015
     C                             AND PRetCode <> '*NRF   '                                  CSD015
     C                   EVAL      DBKEY = POption                                            CSD015
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        CSD015
     C                   EVAL      DBASE = 911                                                CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   MOVE      FHDCNO        W4CNUM                                       CSD015
                                                                                              CSD015
      ** Determine Counterparty Type                                                          CSD015
                                                                                              CSD015
     C                   IF        CCF001 = 'Y'                                               CSD015
     C                   IF        BBCRPC = 'Y'                                               CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        BBLICD <> *BLANKS                                          CSD015
     C                             AND BBLICD <> W1IND1                                       CSD015
     C                             AND BBLICD <> W1IND2                                       CSD015
     C                             AND BBLICD <> W1IND3                                       CSD015
     C                             AND BBLICD <> W1IND4                                       CSD015
     C                             AND BBLICD <> W1IND5                                       CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      W4CUST = BBCRNM + BBCRTN                                   CSD015
                                                                                              CSD015
      ** Convert Dates                                                                        CSD015
                                                                                              CSD015
     C                   MOVE      FHDDYY        WDateTemp4                                   CSD015
     C                   MOVE      FHDDMM        WDateTemp2A                                  CSD015
     C                   MOVE      FHDDDD        WDateTemp2B                                  CSD015
     C                   EVAL      WDate = WDateTemp4 + '-'                                   CSD015
     C                             + WDateTemp2A + '-' +WDateTemp2B                           CSD015
     C                   MOVE      WDate         W4DDAT                                       CSD015
                                                                                              CSD015
     C                   MOVE      FHVDYY        WDateTemp4                                   CSD015
     C                   MOVE      FHVDMM        WDateTemp2A                                  CSD015
     C                   MOVE      FHVDDD        WDateTemp2B                                  CSD015
     C                   EVAL      WDate = WDateTemp4 + '-'                                   CSD015
     C                             + WDateTemp2A + '-' +WDateTemp2B                           CSD015
     C                   MOVE      WDate         W4VDAT                                       CSD015
                                                                                              CSD015
     C                   MOVE      FHDOEY        WDateTemp4                                   CSD015
     C                   MOVE      FHDOEM        WDateTemp2A                                  CSD015
     C                   MOVE      FHDOED        WDateTemp2B                                  CSD015
     C                   EVAL      WDate = WDateTemp4 + '-'                                   CSD015
     C                             + WDateTemp2A + '-' +WDateTemp2B                           CSD015
                                                                                              CSD015
     C                   IF        WDate = '0000-00-00'                                       CSD015
     C                   EVAL      WDate = '0001-01-01'                                       CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   MOVE      WDate         W4MDAT                                       CSD015
                                                                                              CSD015
     C                   EVAL      W4DEN1 = FHCCY1                                            CSD015
     C                   EVAL      W4DEN2 = FHCCY2                                            CSD015
                                                                                              CSD015
     C                   MOVE      FHDBUY        PAMT                                         CSD015
     C                   Exsr      SrCvtAmt                                                   CSD015
     C                   MOVE      ConvertedAmt  W4AMT1                                       CSD015
                                                                                              CSD015
     C                   MOVE      FHDSEL        PAMT                                         CSD015
     C                   Exsr      SrCvtAmt                                                   CSD015
     C                   MOVE      ConvertedAmt  W4AMT2                                       CSD015
                                                                                              CSD015
      ** Build the free format string.                                                        CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
     C                   EVAL      PFreeFmtStr = *BLANKS                                      CSD015
     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
     C                   EVAL      WData = *BLANKS                                            CSD015
                                                                                              CSD015
     C                   DOU       Ctr >= Elements                                            CSD015
                                                                                              CSD015
     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
     C                             AND WLF(Ctr) <> '000000'                                   CSD015
                                                                                              CSD015
     C                   SELECT                                                               CSD015
                                                                                              CSD015
     C                   WHEN      Ctr = 1 AND FHRSCY <> *Blanks                              CSD015
     C                   EVAL      PFmtCCY = FHRSCY                                           CSD015
                                                                                              CSD015
     C                   WHEN      Ctr = 1 AND FHRSCY = *Blanks                               CSD015
     C                   EVAL      PFmtCCY = FHCCY1                                           CSD015
                                                                                              CSD015
     C                   WHEN      Ctr = 5 AND FHPSCY <> *Blanks                              CSD015
     C                   EVAL      PFmtCCY = FHPSCY                                           CSD015
                                                                                              CSD015
     C                   WHEN      Ctr = 5 AND FHPSCY = *Blanks                               CSD015
     C                   EVAL      PFmtCCY = FHCCY2                                           CSD015
                                                                                              CSD015
     C                   ENDSL                                                                CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLFMT'                                                 CSD015
     C                   PARM                    PRetCode                                     CSD015
     C                   PARM                    WLF(Ctr)                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PDummy35                                     CSD015
     C                   PARM                    PFmtCCY                                      CSD015
     C                   PARM                    WData                                        CSD015
     C                   PARM                    PDummy6                                      CSD015
                                                                                              CSD015
     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WData:0       WXMLPacket                                   CSD015
                                                                                              CSD015
     C                   SELECT                                                               CSD015
                                                                                              CSD015
     C                   WHEN      Ctr = 3                                                    CSD015
     C                   CAT       FHRIBA:0      WXMLPacket                                   CSD015
                                                                                              CSD015
     C                   WHEN      Ctr = 8                                                    CSD015
     C                   CAT       FHRCRA:1      WXMLPacket                                   CSD015
                                                                                              CSD015
     C                   WHEN      Ctr = 9                                                    CSD015
     C                   CAT       FHPIBA:1      WXMLPacket                                   CSD015
                                                                                              CSD015
     C                   WHEN      Ctr = 11                                                   CSD015
     C                   CAT       FHAWBA:1      WXMLPacket                                   CSD015
                                                                                              CSD015
     C                   WHEN      Ctr = 12                                                   CSD015
     C                   CAT       FHBENA:1      WXMLPacket                                   CSD015
                                                                                              CSD015
     C                   ENDSL                                                                CSD015
                                                                                              CSD015
     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                  CSD015
                                                                                              CSD015
     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
     C                   EVAL      WData = *BLANKS                                            CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      Ctr = Ctr + 1                                              CSD015
     C                   ENDDO                                                                CSD015
                                                                                              CSD015
      ** Add the Payment Details.                                                             CSD015
                                                                                              CSD015
     C                   IF        FHDTP1 <> *BLANKS OR FHDTP2 <> *BLANKS                     CSD015
     C                             OR FHDTP3 <> *BLANKS OR FHDTP4 <> *BLANKS                  CSD015
                                                                                              CSD015
     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       FHDTP1:0      WXMLPacket                                   CSD015
     C                   CAT       FHDTP2:1      WXMLPacket                                   CSD015
     C                   CAT       FHDTP3:1      WXMLPacket                                   CSD015
     C                   CAT       FHDTP4:1      WXMLPacket                                   CSD015
     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                  CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check for compliance.                                                                CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLCHK'                                                 CSD015
     C                   PARM                    SDWLTD                                       CSD015
     C                   PARM                    PFreeFmtStr                                  CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT
     C*****************************************************
     C*                                                   *
     C* SRERR - EXCEPTION ERRORS                          *
     C*                                                   *
     C*****************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'FXFXDLUPF'   DBPGM            10
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
     C/COPY WNCPYSRC,FXH00078
     C/EJECT
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SrCvtAmt - Converts amount using bound module ZACVTAMT        *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrCvtAmt      BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CALLB     'ZACVTAMT'                                                 CSD015
     C                   PARM                    PRetCode                                     CSD015
     C                   PARM                    FHCCY1                                       CSD015
     C                   PARM                    PAMT                                         CSD015
     C                   PARM                    ConvertedAmt                                 CSD015
     C                   PARM                    PDummy16                                     CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT
     C/COPY WNCPYSRC,FXFXDLFC09
      *********************************************************************
      ** FIELD LOG
      *********************************************************************
      **                                      SET IN     SET IN
      **                                    VALIDATION    THIS    AMENDABLE
      **                                     FUNCTION   FUNCTION
      *********************************************************************
      ** Record identifier            F3RCID              YES       YES
      ** Logical delete flag          F3DLTF              YES       YES
      ** Day of last update           F3DLUP              YES       YES
      ** Month of last update         F3MLUP              YES       YES
      ** Year of last update          F3YLUP              YES       YES
      ** Time of last update          F3TLUP              YES       YES
      ** Type of last change          F3CHTP              YES       YES
      ** Last change date             F3LCD               YES       YES
      ** Last update user id          F3LUID              YES       YES
      ** Deal number 38               F3DN38   YES
      ** Deal value date - yyyy       F3VDYY              YES
      ** Deal value date - mm         F3VDMM              YES
      ** Deal value date - dd         F3VDDD              YES
      ** Deal transaction date - yyyy F3DTYY              YES
      ** Deal transaction date - mm   F3DTMM              YES
      ** Deal transaction date - dd   F3DTDD              YES
      ** Deal option end date - yyyy  F3DOEY              YES
      ** Deal option end date - mm    F3DOEM              YES
      ** Deal option end date - dd    F3DOED              YES
      ** Deal associated deal number  F3DADN   YES
      ** Deal deleted indicator       F3DDLT              YES       YES
      ** Deal status indicator        F3DSTS              YES       YES
      ** Deal type indicator          F3DTYP              YES
      ** Deal customer shortname      F3DCSN   YES                  YES
      ** Deal customer number         F3DCNO   YES                  YES
      ** Exchange rate                F3DXRT   YES
      ** Deal first amount            F3DAM1   YES
      ** Deal first currency dflt     F3CCY1   YES
      ** Deal second currency dflt    F3CCY2   YES
      ** Deal second  amount          F3DAM2   YES
      ** Deal mult/div first amnt ind F3DMD1   YES
      ** Deal buy amount              F3DBUY              YES
      ** Deal sell amount             F3DSEL              YES
      ** Deal base ccy for accounting F3BCAE   YES
      ** Deal base ccy for dealing    F3BCDE   YES
      ** Deal spot base ccy equiv.    F3DSBE   YES
      ** Deal authorisation officer   F3AOFR              YES       YES
      ** Deal user code               F3DUSC              YES       YES
      ** Deal branch code             F3DBRC   YES                  YES
      ** Branch code (alpha)          F3MBCA   YES                  YES
      ** Deal done date - yyyy        F3DDYY              YES       YES
      ** Deal done date - mm          F3DDMM              YES       YES
      ** Deal done date - dd          F3DDDD              YES       YES
      ** Deal forward points          F3FWPP   YES
      ** Deal midas our receve method F3ORCM              YES       YES
      ** Deal our receive method      F3DORM              YES       YES
      ** Deal midas our receive instr F3MORI              YES       YES
      ** Deal our receive instructns  F3DORI              YES       YES
      ** Deal midas our payment meth. F3MOPM              YES       YES
      ** Deal our payment method      F3DOPM              YES       YES
      ** Deal midas our payment instr F3MOPI              YES       YES
      ** Deal our payment instructns  F3DOPI              YES       YES
      ** Deal type                    F3TYPE   YES
      ** Deal sub type                F3STYP   YES                  YES
      ** Broker code                  F3BROK   YES                  YES
      ** Deal brokerage               F3BRKG   YES                  YES
      ** Deal customer payment instr  F3DCPI              YES       YES
      ** Deal midas cust payment inst F3MCPI              YES       YES
      ** Deal customer receive instr  F3DCRI              YES       YES
      ** Deal Customer Receive Instru F3MCRI              YES       YES
      ** Deal for A/C of              F3DFAC              YES       YES
      ** Deal midas ''FOR A/C OF''    F3MFAO              YES       YES
      ** Deal special instructions    F3SPEC              YES       YES
      ** Deal last action             F3LACT   YES                  YES
      ** Time of input                F3ETIM              YES
      ** Dl option orig first amnt    F3OOFA              YES
      ** Dl option orig second amnt   F3OOSA              YES
      ** Broker currency code         F3BKCY   YES                  YES
      ** Deal number pc               F3PCDN--------------------------------
      ** Deal pc transation number    F3PCTN--------------------------------
      ** Deal action date             F3ADAT              YES       YES
      ** Fed funds indicator          F3FEDF   YES                  YES
      ** Book Code                    F3BOKC   YES                  YES
      ** LINKED DEAL NUMBER           F3LNKN   YES                  YES
      ** receipt - settlement method  F3RSTM   YES*                 YES
      ** receipt - our nostro         F3RONS   YES*                 YES
      ** receipt - intermediary bank  F3RIBN   YES*                 YES
      ** receipt - intermediary bank  F3RIBA   YES*                 YES
      ** receipt - ordering bank no   F3ROBN   YES*                 YES
      ** receipt - ordering customer  F3ROCN   YES*                 YES
      ** pay - settlement method      F3PSTM   YES*                 YES
      ** pay - our nostro             F3PONS   YES*                 YES
      ** pay - intermediary bank no   F3PIBN   YES*                 YES
      ** pay - intermediary bank a/c  F3PIBA   YES*                 YES
      ** pay - ordering bank no       F3POBN   YES*                 YES
      ** pay - ordering customer no   F3POCN   YES*                 YES
      ** receiver correspondent no    F3RCRN   YES*                 YES
      ** receiver correspondent a/c l F3RCRA   YES*                 YES
      ** Receiver number              F3RVNO   YES*                 YES
      ** a/c with bank no             F3AWBN   YES*                 YES
      ** a/c with bank a/c line       F3AWBA   YES*                 YES
      ** beneficiary no               F3BENN   YES*                 YES
      ** beneficiary a/c line         F3BENA   YES*                 YES
      ** DETAILS OF PAY 1             F3DTP1   YES*                 YES
      ** DETAILS OF PAY 2             F3DTP2   YES*                 YES
      ** DETAILS OF PAY 3             F3DTP3   YES*                 YES
      ** DETAILS OF PAY 4             F3DTP4   YES*                 YES
      ** details of charges           F3DCHG   YES*                 YES
      ** bank to bank info 1          F3BTB1   YES*                 YES
      ** bank to bank info 2          F3BTB2   YES*                 YES
      ** bank to bank info 3          F3BTB3   YES*                 YES
      ** bank to bank info 4          F3BTB4   YES*                 YES
      ** bank to bank 5               F3BTB5   YES*                 YES
      ** bank to bank 6               F3BTB6   YES*                 YES
      ** Originating branch           F3ORBR   YES                  YES
      ** Profit centre                F3PRFC   YES                  YES
      ** Our Receive Branch           F3ROBR   YES                  YES
      ** Our Pay Branch               F3POBR   YES                  YES
      ** COVER MESSAGE REQUIRED       F3CVMR   YES                  YES
      ** Margin Points                F3MGPT   YES
      ** Margin Amount                F3MGAM   YES
      ** Marg Ccy                     F3MGCY   YES
      ** Marg buy/ sell ind           F3MGBS   YES
      ** Original Spot rate           F3OSRT   YES
      ** Buy forward Points amount    F3BFPA   YES                  YES
      ** Sell forward Points amount   F3SFPA   YES                  YES
      ** Input DL base spot rate      F3BDBS   YES                  YES
      ** Other DL base spot rate      F3SDBS   YES                  YES
      ** Other DL base spot equiv     F3SDBE   YES                  YES
      ** Buy DL base fwd points       F3BDBF   YES                  YES
      ** Sell DL base fwd points      F3SDBF   YES                  YES
      ** Buy DL base fwd amount       F3BDFA   YES                  YES
      ** Sell DL base fwd amount      F3SDFA   YES                  YES
      ** Portfolio reference          F3PTFR   YES                  YES
      ** Net Buy Indicator            F3NBUY   YES                  YES
      ** Net Buy Reference            F3NBRF   YES                  YES
      ** Net Sell Indicator           F3NSEL   YES                  YES
      ** Net Sell Reference           F3NSRF   YES                  YES
      ** Matched Deal                 F3MTCH   YES                  YES
      ** Rec Settle Currency          F3RSCY   YES                  YES
      ** Pay Settle Currency          F3RSCY   YES                  YES
      ** In Currency in Field 72      F3IC72   YES                  YES
      ** Deal date day number         F3DDDN   YES                  YES
      ** Value date day number        F3VDDN   YES
      ** Option to date day number    F3OTDN   YES
      ** Front Office transaction ID  F3FRNT   YES                  YES         CAP013
      ** Associated Front Office Tran F3AFRT   YES                  YES         CAP013
      ** Repair location              F3REPA
      ** Automatic Authorisation      F3AUTH                                    CAP051
      ** CLS Settlement               F3CLSS   YES                  YES         CDL008
      ** Class                        F3CLAS   YES                  YES         CDL038
      *********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** CTDATA XOT - XML Opening Tags for the Compliance Engine.                                   CSD015
<Receipt Our Nostro>                                                                          CSD015
<Receipt Ord Customer>                                                                        CSD015
<Receipt Int Bank>                                                                            CSD015
<Receipt Ord Bank>                                                                            CSD015
<Payment Our Nostro>                                                                          CSD015
<Payment Ord Customer>                                                                        CSD015
<Payment Receiver>                                                                            CSD015
<Payment Receiver Corr>                                                                       CSD015
<Payment Int Bank>                                                                            CSD015
<Payment Ord Bank>                                                                            CSD015
<Payment A/C with Bank>                                                                       CSD015
<Payment Beneficiary>                                                                         CSD015
<Payment Details of Pay>                                                                      CSD015
** CTDATA XCT - XML Closing Tags for the Compliance Engine.                                   CSD015
</Receipt Our Nostro>                                                                         CSD015
</Receipt Ord Customer>                                                                       CSD015
</Receipt Int Bank>                                                                           CSD015
</Receipt Ord Bank>                                                                           CSD015
</Payment Our Nostro>                                                                         CSD015
</Payment Ord Customer>                                                                       CSD015
</Payment Receiver>                                                                           CSD015
</Payment Receiver Corr>                                                                      CSD015
</Payment Int Bank>                                                                           CSD015
</Payment Ord Bank>                                                                           CSD015
</Payment A/C with Bank>                                                                      CSD015
</Payment Beneficiary>                                                                        CSD015
</Payment Details of Pay>                                                                     CSD015
