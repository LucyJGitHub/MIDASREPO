     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits DL database update')           *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMLDNIUPD - LOANS/DEPOSITS DL DATABASE UPDATE                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 AR784570           Date 21Feb17               *
      *                 CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD026719           Date 19Aug14               *
      *                 MD025467           Date 12May14               *
      *                 MD025244           Date 09May14               *
      *                 AR582922           Date 30Aug12               *
      *                 260363             Date 30Aug12               *
      *                 AR863263           Date 11Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 AR787620           Date 10Jun11               *
      *                 261319             Date 04Aug09               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24144           Date 12May09               *
      *                 229360             Date 10Sep04               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248932             Date 20Jul07               *
      *                 247104             Date 20Jun07               *
      *                 246801             Date 28May07               *
      *                 247835             Date 23May07               *
      *                 BUG5169            Date 04Oct06               *
      *                 BUG13224           Date 06Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 239566             Date 05May06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10725           Date 02Mar06               *
      *                 CGL035             Date 01Mar05               *
      *                 BUG8874            Date 05Oct05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7904            Date 20Jul05               *
      *                 CAS009             Date 16May05               *
      *                 CDL033             Date 10Feb05               *
      *                 221673             Date 10Feb05               *
      *                 BUG6225            Date 16Mar05               *
      *                 BUG6191            Date 09Mar05               *
      *                 CGL014             Date 20Oct03               *
      *                 NAD002             Date 26Mar04               *
      *                 CRE020             Date 20Jan04               *
      *                 TDA012             Date 18Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 224059             Date 30Dec02               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209895             Date 14Jan03               *
      *                 209760             Date 14Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 202780             Date 08Feb02               *
      *                 188621             Date 18Jun01               *
      *                 185914             Date 14May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      *                 CAP042             Date 08Jan01               *
      *                 185801             Date 26Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 155792             Date 03Oct00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSW200             DATE 21Aug00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             DATE 09Nov99               *
      *                 CDL007             DATE 05Oct99               *
      *                 CGL011             Date 20Sep99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 154477             Date 29Jan99               *
      *                 CAP004             Date 07Sep98               *
      *                 CAP003             Date 05May98               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  AR784570 - Condition whether internal customer of customer   *
      *             inputted by the user to be used for CI deal.      *
      *             Apply fixes 255909 and 256390. (Child: AR784571)  *
      *           - Applied for MD044115.                             *
      *  CGL165 - Dual Withholding Tax                                *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *  MD026719 - Deal takes base rate as per wrong date. Reverse   *
      *             fix 229360.                                       *
      *           - Applied for MD028339.                             *
      *  MD025467 - API locking issue. Redesign approach.             *
      *  MD025244 - Locking on LDNI trailer file. API issue.          *
      *  AR582922 - DL: MMM payments was not generated after          *
      *             settlement account. Generate pay/recieve messages *
      *             when Maturity Date is amended and it is within    *
      *             telex notice days. (Child: AR582923)              *
      *  260363 - SWIFT messages generation error.                    *
      *  AR863263 - Further Pay/Receipt Settlement Accounts are       *
      *             reset to blanks                                   *
      *  CRE073 - Interest Rate Rounding                              *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,MMH00016                                 *
      *             WNCPYSRC,MMH00006                                 *
      *             WNCPYSRC,MMH00007                                 *
      *             WNCPYSRC,MMH00008                                 *
      *             WNCPYSRC,MMH00009                                 *
      *             WNCPYSRC,MMH00020                                 *
      *             WNCPYSRC,MMH00010                                 *
      *  261319 - For amend, regenerate Pay/Receive messages if       *
      *           there is a Accrued Interest Adjustment.             *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  BUG24144 - Missing Parameters in call to MMLDNIUPD           *
      *  229360 - When base rates are amended prior to maturity, base *
      *           rate field takes on the new value instead of the old*
      *           resulting to a discrepancy with the front office    *
      *           record.                                             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248932 - Produce a confirmation when the interest            *
      *           counterparty nostro was amended.                    *
      *  247104 - Only one of either Settlement Payment or            *
      *           Settlement Receipt is amended but both Pay/Rec      *
      *           messages are cancelled and regenerated. This is     *
      *           because pay/rec indicators (PRI1 and PRI3) are set  *
      *           without checking which side was amended.            *
      *           Applied fix 247151                                  *
      *  247151 - Check settlement side                               *
      *  246801 - When CSW025 is switched on always produce a         *
      *           confirmation/Pay_Receives as Bank may need to break *
      *           a multiple mesasage. i.e. If an MT203/MT210 multiple*
      *           has been generated previously a null amendment may  *
      *           be required to break this deal out of the multiple. *
      *           MT292 not produced with new MT202 after deal front  *
      *           office id amended. PRI1 & PRI3 were set on but      *
      *           CNRQ was not so DLC0210A never got to produce the   *
      *           MT292. Fix is not to set on PRI indicators if no    *
      *           conf is required.                                   *
      *  247835 - On change of interest settlement method/account     *
      *           produce a confirmation. Set CNRQ = 'Y'              *
      *  BUG5169 - Actual Interest Rate may not be amended (CDL020).  *
      *  BUG13224 - Serious Midas error when authorising or           *
      *             deleting a deal that has a zero (0) spread rate   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  239566 - When the deal is rollover to EURO, the field RBDA   *
      *           should be the rollover amount in original currency. *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10725 - Fiduciary code/charges are not updated during     *
      *             insertion thereby causing Midasplus error in      *
      *             deal amendments                                   *
      *  CGL035 - EUSD Upgrade to MidasPlus (Recompile)               *
      *  BUG8874 - Properly initialise new Floating Rate CD fields    *
      *            as these cause decimal data error during file      *
      *            update when feature CDL033 is switched off.        *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG7904- During switch-off, CDL033 fields update result to   *
      *           decimal data error.                                 *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  221673 - No need to check the value of IKNGVI.               *
      *           Apply fix 220497.                                   *
      *  BUG6225 - *** Already a part of BUG6191 ***                  *
      *          - System should not generate Amendment Confirmation  *
      *            if only rollover details or other insignificant    *
      *            details were changed in the deal. Remove           *
      *            comparison of 'Cover MT202 Required' flag when     *
      *            setting Confirmation Requested to 'Y'. Cover MT202 *
      *            is supposed to be blank in MMDELDPP (for screen    *
      *            display) but must be 'N' in DEALSDC.               *
      *  BUG6191- Validate CVMR correctly for changed status.         *
      *  CGL014 - Collaterals Processing                              *
      *  NAD002 - 10-Digit Account Code Errors                        *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  TDA012 - Fix 10-digit account code processing.               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  224059 - Error when authorising deal                         *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Autumatic Rollover of Fixed Term Loan/Deposit       *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  209895 - No confirmation generated during amend if BLL2II    *
      *           is "Y" and settlement instructions are blanks. Make *
      *           sure that CNRQ is "Y" after settlement instructions *
      *           have been changed to certain values.                *
      *  209760 - TOTI in DEALSDC after changing MDAT.                *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  202780 - Reverse 185914                                      *
      *  188621 - Perform WRITE/UPDATE operation to LF/BKRAT only if  *
      *           switchable feature AUS007 is ON and deal's Rate     *
      *           Amount Indicator is not equal to blank.  This is    *
      *           to include those deals with blank R/A Indicator     *
      *           in the Brokerage Report if AUS007 is ON.            *
      *  185914 - Output transaction customer not BICN to CNUM for    *
      *           'CI' deal.                                          *
      *  CSD006 - Use long DS with SDBSRTPD.                          *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *  185801 - Output to DTRIX a record for the rolled over deal   *
      *           if maturity messages are due when the rollover deal *
      *           is deleted.                                         *
      *  155792 - Check other amended fields relevant for generation  *
      *           of an amended confirmation.  And default workfield  *
      *           @@CNRQ to 'N' to prevent a blank CNRQ in DTRIXDD.   *
      *  CDL008 - Continuous Linked Settlement (recompile DEALSDB)    *
      *  CSW200 - SWIFT 2000 changes                                  *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *  CGL011 - Collateral Processing for Midas                     *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  154477 - Recompile for change to MMVLDNIPD.                  *
      *  CAP004 - API's Phase 3.                                      *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs. (RECOMPILED)                           *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FMMDELULL  UF A E           K DISK
     F                                     COMMIT
     F                                     INCLUDE(DEALSDCF)
     F                                     INCLUDE(DEALSDFF)
     FBKRAT     UF A E           K DISK
     F                                     COMMIT
     FSDTIX     UF A E           K DISK
     F                                     COMMIT
     F                                     PREFIX(DX)
     FHIST1     UF   E           K DISK
     F                                     PREFIX(HS)
                                                                                              CRE020
     FREADVCL1  UF   E           K DISK    COMMIT                                             CRE020
     F                                     USROPN                                             CRE020
      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref                            CRE020
                                                                                              CRE020
     F/COPY WNCPYSRC,MMLDNIDF01

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

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID LOAN/DEPOSIT
     D MMVLDN        E DS                  EXTNAME(MMVLDNIPD)
     D  @MMREC               456    524
     D  @MMPY1               525    730
     D  @MMPY2               731    873
     D  @MMPY3               874   1083
     D**@MMRECEx            1741   1758                                                CGL029 TDA012
     D**@MMPY1Ex            1759   1776                                                CGL029 TDA012
     D**@MMRECEx            1756   1773                                                TDA012 NAD002
     D**@MMPY1Ex            1774   1791                                                TDA012 NAD002
     D  @MMPY4              1850   1896                                                       CDL033
                                                                                              CDL096
      ** Business Day Convention fields                                                       CDL096
     D  @MMDET              2148   2181                                                       CDL096

      ** Tax Codes                                                                            CGL165
     D  @MMTXC              2182   2185                                                       CGL165

      **  DEALS FILE - LOANS/DEPOSITS/NAS ISSUED
     D DEALS         E DS                  EXTNAME(DEALSDC)
     D  @DLREC               429    497
     D  @DLPY1               498    703
     D  @DLPY2               704    846
     D  @DLPY3               847   1056
     D**@DLRECEx            1708   1725                                                CGL029 TDA012
     D**@DLPY1Ex            1726   1743                                                CGL029 TDA012
     D**@DLRECEx            1757   1774                                                TDA012 NAD002
     D**@DLPY1Ex            1775   1792                                                TDA012 NAD002
     D  @DLPY4              1851   1897                                                       CDL033
     D  @DLDET              2350   2383                                                       CDL096
     D  @DLTXC              2384   2387                                                       CGL165

      **  Time data structure for DTRIX.
     D                 DS
     D  @XTIME                 1      6  0
     D  DXTIM                  1      4  0

      **  Data structure for IKTNTR                                                           CAS005
     D                 DS                                                                     CAS005
     D  IKTNTR2                      15  0                                                    CAS005
     D  IKTNTR_A                     15                                                       CAS005
                                                                                              CAS005
      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS

     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)                                BUG24144
      ** File - Payment Further Settlement Instructions                                     BUG24144
                                                                                            BUG24144
     D #FRECF        E DS                  EXTNAME(SDFSFRPD)                                BUG24144
      ** File - Receive Further Settlement Instructions                                     BUG24144
                                                                                            BUG24144
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS

     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ** External DS for TRADE Details

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for BRANCH Details

     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      ** External DS for BASE RATE Details

     D SDBSHS        E DS                  EXTNAME(SDBSHSPD)                                 BUG5169
      ** External DS for Historic Base Rate details                                          BUG5169
                                                                                             BUG5169
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY Details
                                                                                              CGL011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL011
     D                                     PREFIX(S_)                                         CGL011
      ** External DS for SAR Details                                                          CGL011

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D/COPY WNCPYSRC,MMLDNIDD02
     D MPHAS           DS             1                                                     MD025244
      ** Data Structure for MPHAS Dataarea                                                  MD025244
      *                                                                                     MD025244
                                                                                CDL006
     D***CDL006*         S              1A   IMPORT                                  CDL006 BUG10725
     D CDL006          S              1A                                                    BUG10725
     D CDL096          S              1A                                                      CDL096
     D CGL165          S              1A                                                      CGL165
                                                                                              CAP042
     D CAP042          S              1A                                                      CAP042
                                                                                              CAS001
      ** Define fields used in CAS001                                                         CAS001
                                                                                              CAS001
     D CAS001          S              1A                                                      CAS001
     D PRTCD           S              7A                                                      CAS001
     D POPTN           S              7A                                                      CAS001
     D PSARD           S              6A                                                      CAS001
                                                                                              CAS004
      ** Define fields used in CAS004                                                         CAS004
                                                                                              CAS004
     D CAS004          S              1A                                                      CAS004

      ** Define fields used in CAS005                                                         CAS005
                                                                                              CAS005
     D CAS005          S              1A                                                      CAS005
     D WNTR            S             11  7                                                    224059
     D WTOTI           S             15  0                                                    224059
                                                                                              CAS005
      ** CRE020 Variables                                                                     CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KPrgMn          S             10A   INZ('MMLDNIUPD ')                                  CRE020
     D*PSysVal01       S             20A   INZ('LoansDeposNAsIssued ')               CRE020 AR784570
     D PSysVal01       S             20A                                                    AR784570
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
     D WNew            S              1A                                                      CRE020
                                                                                              CRE020
     D CSW050          S              1A                                                      246801
     D CER020          S              1A                                                      CER020
     D CRE073          S              1A                                                      CRE073
     D W#FRNT          S              8A                                                    MD025244
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************

     C/COPY WNCPYSRC,MMLDNIDC01
      * EXIT IF NOT INSERTION, AMENDMENT OR REVERSAL

     C     IKCHTP        IFNE      'I'
     C     IKCHTP        ANDNE     'A'
     C     IKCHTP        ANDNE     'R'
     C                   RETURN
     C                   END

      * INSERT, AMEND, OR REVERSE THE DEAL

     C                   MOVE      ' '           RecSd             1                          260363
     C                   MOVE      ' '           PaySd             1                          260363
                                                                                              260363
     C     IKCHTP        CASEQ     'I'           LDINS
     C     IKCHTP        CASEQ     'A'           LDAMD
     C     IKCHTP        CASEQ     'R'           LDDEL
     C                   END

     C     AUS007        IFEQ      'Y'                                                        188621
     C     IKRACD        ANDNE     ' '                                                        188621
      *                                                                                       188621
      * UPDATE AUSTRALIAN BROKERAGE RATES FILE

     C     IKCHTP        CASEQ     'I'           RATINS
     C     IKCHTP        CASEQ     'R'           RATDEL
     C                   END
     C                   ENDIF                                                                188621

     C/COPY WNCPYSRC,MMLDNIDC02
      * SET PAY/RECEIVE INDICATORS TO BE WRITTEN TO DTRIX

     C     @@CNRQ        IFEQ      'Y'                                                        246801
     C                   EXSR      PYRCIN
     C                   ELSE                                                                 246801
     C                   Z-ADD     *ZERO         @@PRI1                                       246801
     C                   Z-ADD     *ZERO         @@PRI2                                       246801
     C                   Z-ADD     *ZERO         @@PRI3                                       246801
     C                   ENDIF                                                                246801

      * WRITE A DTRIX RECORD

     C                   EXSR      WRTDTX

      * UPDATE THE DTRIX HEADER RECORD

     C                   EXSR      UPDDTH

     C/COPY WNCPYSRC,MMLDNIDC03
      ** UPDATE THE DEALS FILE TRAILER
      ** ON INSERTS AND REVERSALS

     C     IKCHTP        IFEQ      'I'
     C     IKCHTP        OREQ      'R'
     C                   EXSR      UPDTRL
     C                   END
     C/COPY WNCPYSRC,MMH00016
      *
      * EXIT FROM PROGRAM
      *
     C                   RETURN
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* LDINS  - INSERT A LOAN/DEPOSIT                               *
     C*                                                              *
     C****************************************************************
     C     LDINS         BEGSR

      * SET CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX

     C                   EXSR      CNFINS

      * INITIALIZE DEAL

     C                   CLEAR                   DEALS
      *                                                                                      BUG8874
      ** Initialise fields for CDL033 - Floating Rate CDs Issued feature                     BUG8874
      ** as CLEAR above does not seem to reset the fields correctly.                         BUG8874
     C                   Z-ADD     0             XKRCDT                                      BUG8874
     C                   MOVEL     *BLANKS       XKRCFR                                      BUG8874
     C                   Z-ADD     0             XKRCDM                                      BUG8874
     C                   MOVEL     *BLANKS       XKSTRF                                      BUG8874
     C                   Z-ADD     0             XKSTRT                                      BUG8874
     C                   Z-ADD     0             XKAILC                                      BUG8874
     C                   Z-ADD     0             XKACDA                                      BUG8874
     C                   MOVEL     *BLANKS       XKSTVF                                      BUG8874
     C                   MOVEL     *BLANKS       XKBSVF                                      BUG8874
     C                   Z-ADD     0             XKFXDM                                      BUG8874
     C                   Z-ADD     0             XKINFD                                      BUG8874
     C                   MOVEL     *BLANKS       XKINFF                                      BUG8874
     C                   Z-ADD     0             XKBSRF                                      BUG8874
     C                   MOVEL     *BLANKS       XKFRCI                                      BUG8874
     C                   MOVEL     *BLANKS       XKFYLD                                      BUG8874

      * RECORD ID

     C                   MOVEL     'D'           RECI

      * DEAL NUMBER & RECORD TYPE

     C                   Z-ADD     IKDN38        DLNO
     C                   MOVE      'C'           RCDT

      * DEAL RECORD CODE

     C     IKMTYP        IFEQ      'IT'
     C     IKMTYP        OREQ      'TD'
     C     IKMTYP        OREQ      'CD'
     C     IKMTYP        OREQ      'CI'
     C     IKMTYP        OREQ      'BB'
     C     IKMTYP        OREQ      'CO'
     C     IKMTYP        OREQ      'ID'
     C     IKMTYP        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'FT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
      ** If deal type is 'CF' and CDL033 switchable feature is 'Y'                            CDL033
     C     IKMTYP        OREQ      'CF'                                                       CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
     C/COPY WNCPYSRC,MMLDNIDC09
     C                   Z-ADD     16            RCDC
     C                   ELSE
     C                   Z-ADD     15            RCDC
     C                   END

      ***DEAL*CUSTOMER*-*BICN*OF*BRANCH*IF*CD*ISSUED                                          185914
      *  DEAL CUSTOMER - BICN OF BRANCH IF CD ISSUED                                          202780
      *                                                                                     AR784570
      ** Check system value whether branch internal customer or the                         AR784570
      ** original customer inputted will be used for CI deals.                              AR784570
      *                                                                                     AR784570
     C                   EVAL      PSysVal01 = 'MM/CIDealsDefaulting'                       AR784570
     C                   CALLB     'AOSVALR0'                                               AR784570
     C                   PARM      *BLANKS       PRtCd                                      AR784570
     C                   PARM                    PSysVal01                                  AR784570
     C                   PARM                    PCurSet01                                  AR784570
     C                   PARM                    PSysVal02                                  AR784570
     C                   PARM                    PCurSet02                                  AR784570
     C                   PARM                    PSysVal03                                  AR784570
     C                   PARM                    PCurSet03                                  AR784570
     C                   PARM                    PSysVal04                                  AR784570
     C                   PARM                    PCurSet04                                  AR784570
     C                   PARM                    PSysVal05                                  AR784570
     C                   PARM                    PCurSet05                                  AR784570
     C                   PARM                    PSysVal06                                  AR784570
     C                   PARM                    PCurSet06                                  AR784570
     C                   PARM                    PSysVal07                                  AR784570
     C                   PARM                    PCurSet07                                  AR784570
     C                   PARM                    PSysVal08                                  AR784570
     C                   PARM                    PCurSet08                                  AR784570
     C                   PARM                    PSysVal09                                  AR784570
     C                   PARM                    PCurSet09                                  AR784570
     C                   PARM                    PSysVal10                                  AR784570
     C                   PARM                    PCurSet10                                  AR784570
      *                                                                                     AR784570
     C                   EVAL      CIdeals = 'N'                                            AR784570
      *                                                                                     AR784570
      ** If the system value is not found issue a database error                            AR784570
      *                                                                                     AR784570
     C                   IF        PRtCd = *BLANKS                                          AR784570
     C                   MOVEL     PCurSet01     CIdeals           1                        AR784570
     C                   ELSE                                                               AR784570
      *                                                                                     AR784570
     C                   IF        PRtCd <> '*NRF'                                          AR784570
     C     *LOCK         IN        LDA                                                      AR784570
     C                   EVAL      DBFile = 'SDSVALPD'                                      AR784570
     C                   EVAL      DBase = 916                                              AR784570
     C                   EVAL      DBKey = PSysVal01                                        AR784570
     C                   OUT       LDA                                                      AR784570
     C                   EXSR      SRErr                                                    AR784570
     C                   ENDIF                                                              AR784570
      *                                                                                     AR784570
     C                   ENDIF                                                              AR784570

     C*****IKMTYP        IFEQ      'CI'                                                       185914
     C**********         EXSR      ACSBRN                                                     185914
     C**********         MOVE      A8BICN        CNUM                                         185914
     C**********         ELSE                                                                 185914
     C     IKMTYP        IFEQ      'CI'                                                       202780
     C     CIdeals       ANDEQ     'Y'                                                      AR784570
     C     IKMTYP        OREQ      'CF'                                                       CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
     C/COPY WNCPYSRC,MMLDNIDC10
     C                   EXSR      ACSBRN                                                     202780
     C                   MOVE      A8BICN        CNUM                                         202780
     C                   ELSE                                                                 202780
     C**********         Z-ADD     IKCNUM        CNUM                                         CSD027
     C                   EVAL      CNUM = IKCNUM                                              CSD027
     C**********         END                                                                  185914
     C                   END                                                                  202780
      *
      * BRANCH
     C                   MOVEL     IKBRCA        BRCA
      *
      * DEAL TYPE
     C                   MOVE      IKMTYP        DTYP
      *
      * DEAL SUB-TYPE
     C                   MOVE      IKSTYP        DLST
      *
      * DEAL DATE
     C                   Z-ADD     IKDDND        DDAT
      *
      * VALUE DATE
     C                   Z-ADD     IKDVSD        VDAT
      *
      * MATURITY DATE
     C                   Z-ADD     IKMATD        MDAT
      *
      * ACCOUNT SEQUENCE
     C                   Z-ADD     IKACSQ        CDAS
      *
      * BROKER CODE
     C                   MOVE      IKBKCD        BRKC
      *
      * BROKERAGE
     C     IKBRKG        IFEQ      *ALL'9'
     C                   Z-ADD     0             BAGE
     C                   ELSE
     C                   Z-ADD     IKBRKG        BAGE
     C                   END
      *
      * CURRENCY
     C                   MOVE      IKCCY         CCY
      *
      * PRINCIPAL
     C     IKAMNP        IFLT      0
     C                   Z-SUB     IKAMNP        PCPL
     C                   ELSE
     C                   Z-ADD     IKAMNP        PCPL
     C                   END
      *                                                                                       CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   Z-ADD     PCPL          FSPAMT                                       CAS005
     C                   ENDIF                                                                CAS005
      *
      * INT.CAPITALIZATION
     C                   MOVE      IKCPTI        INTC
      *
      * BASE RATE CODE & BASE RATE
      *
     C     IKBSRC        IFEQ      *BLANK
     C                   Z-ADD     *ZERO         BRTT
     C                   Z-ADD     *ZERO         BRTE
     C                   ELSE
     C                   MOVE      IKBSRC        BRTT
      *
      * ACCESS BASE RATE
     C                   Z-ADD     *ZEROS        WkBaseRate                                  BUG5169
     C                   EXSR      ACSBRT
      *
     C*****IKIIRT        IFEQ      *ZERO                                             229360 MD026719
      **********                                                                     229360 MD026719
     C*****IKINTR        IFLT      *ZERO                                             229360 MD026719
     C**********         Z-SUB     IKINTR        WINTR                               229360 MD026719
     C**********         ELSE                                                        229360 MD026719
     C**********         Z-ADD     IKINTR        WINTR                               229360 MD026719
     C**********         ENDIF                                                       229360 MD026719
      **********                                                                     229360 MD026719
     C**********         SUB       IKSPRD        WINTR            11 7               229360 MD026719
     C**********         ENDIF                                                       229360 MD026719
      **********                                                                     229360 MD026719
      ** Use current or next rate according to deal value date
      *
     C     IKDVSD        IFLT      BAVDNR
     C                   Z-ADD     BACBSR        BRTE
      **********                                                                     229360 MD026719
     C*****IKIIRT        IFEQ      *ZERO                                             229360 MD026719
     C*****WINTR         IFNE      BACBSR                                            229360 MD026719
     C**********         Z-ADD     WINTR         BRTE                                229360 MD026719
     C**********         ENDIF                                                       229360 MD026719
     C**********         ENDIF                                                       229360 MD026719
      **********                                                                     229360 MD026719
     C                   ELSE
     C                   Z-ADD     BANBRT        BRTE
      **********                                                                     229360 MD026719
     C*****IKIIRT        IFEQ      *ZERO                                             229360 MD026719
     C*****WINTR         IFNE      BANBRT                                            229360 MD026719
     C**********         Z-ADD     WINTR         BRTE                                229360 MD026719
     C**********         ENDIF                                                       229360 MD026719
     C**********         ENDIF                                                       229360 MD026719
      **********                                                                     229360 MD026719
     C                   END
      *
     C     CDL020        IFEQ      'Y'                                                       BUG5169
     C                   Z-ADD     WkBaseRate    BRTE                                        BUG5169
     C                   ENDIF                                                               BUG5169

     C                   END
      *
      * RATE/SPREAD
     C     IKBSRC        IFEQ      *BLANK
     C*
     C*****IKNGVI        IFEQ      'Y'                                                        221673
     C**********         Z-SUB     IKIIRT        RTSP                                         221673
     C**********         ELSE                                                                 221673
     C                   Z-ADD     IKIIRT        RTSP
     C**********         END                                                                  221673
     C*
     C                   ELSE
     C                   Z-ADD     IKSPRD        RTSP
     C                   END
      *
      * INTEREST RATE - which will already have the right sign

     C                   Z-ADD     IKINTR        INTR

      * NOTICE DAYS
     C                   Z-ADD     IKNTCE        NOTD

      * REF.NO. OF NA
     C                   MOVE      IKCDRF        RNNA
      *
      * CURR.HLDR OF NA
     C**********         Z-ADD     IKMCDH        CHNA                                         CSD027
     C                   EVAL      CHNA = IKMCDH                                              CSD027
      *
      * FACILITY TYPE
     C                   MOVEL     IKFCLY        FACT
      *
      * FACILITY NUMBER
     C                   MOVE      IKFCLY        FCNO
      *
      * ORIGINAL PRINCIPAL
     C     IKMTYP        IFEQ      'CD'
     C     IKMTYP        OREQ      'CL'
     C     IKMTYP        OREQ      'DL'
     C     IKMTYP        OREQ      'IL'
     C     IKMTYP        OREQ      'ID'
     C     IKMTYP        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'DP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'LP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'CF'                                                       CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
     C     IKAMNP        IFLT      0
     C                   Z-SUB     IKAMNP        OPAM
     C                   ELSE
     C                   Z-ADD     IKAMNP        OPAM
     C                   END
     C                   ELSE
     C                   Z-ADD     *ZERO         OPAM
     C                   END
      *
      * BASE CCY EXCHANGE RATE
     C                   Z-ADD     IKBRAT        BCXR
      *
      * ACCESS DEAL CURRENCY DETAILS
      *
     C                   EXSR      ACSDCY
      *
      * LIMIT CCY EXCHANGE RATE
     C                   Z-ADD     A6ERLC        LCXR
      *
      * START & MATURITY DATE INSTRUCTIONS
      *
     C     IKMTYP        IFEQ      'IT'
     C     IKMTYP        OREQ      'TD'
     C     IKMTYP        OREQ      'CD'
     C     IKMTYP        OREQ      'CI'
     C     IKMTYP        OREQ      'ID'
     C     IKMTYP        OREQ      'FT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'CF'                                                       CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
     C/COPY WNCPYSRC,MMLDNIDC11
     C                   Z-ADD     IKORCM        SDST
     C                   MOVE      IKMORI        OSDA
     C                   MOVEL     IKMCPI        TSTN
     C                   Z-ADD     IKMOPM        MDST
     C                   MOVE      IKMOPI        OMDA
     C                   MOVE      IKMCRI        TMAN
     C                   ELSE
     C                   Z-ADD     IKMOPM        SDST
     C                   MOVE      IKMOPI        OSDA
     C                   MOVE      IKMCRI        TSTN
     C                   Z-ADD     IKORCM        MDST
     C                   MOVE      IKMORI        OMDA
     C                   MOVEL     IKMCPI        TMAN
     C                   END
      *
      * ROLLOVER OF DEAL NUMBER
      * & ROLLOVER DEAL AMOUNT
      *
     C                   MOVE      *BLANK        RODN
     C                   Z-ADD     *ZERO         RODA
      *
     C     IKMTYP        IFNE      'ID'
     C     IKMTYP        ANDNE     'IL'
     C                   MOVE      IKDADN        RODN
     C*
     C**  IF DEAL ASSOCIATED NUMBER = ZERO, ROLLOVER OF DEAL
     C**  AMOUNT = ZERO
     C     IKDADN        IFEQ      *BLANKS
     C     IKDADN        OREQ      '000000'
     C                   Z-ADD     *ZERO         RODA
     C                   ELSE
     C                   Z-ADD     IKRBAT        RODA
     C                   END
     C                   END
      *
      * ROLLED OVER BY DEAL NUMBER
      * & ROLLED OVER BY DEAL AMOUNT
      *
     C                   MOVE      *ZERO         RBDN
     C                   Z-ADD     *ZERO         RBDA
      *
      * INTEREST CALC BASIS
     C                   MOVE      IKICMT        ICBS
      *
      * INTEREST PAY FREQUENCY
     C                   MOVE      IKIPFQ        IPFR
      *
      * TOTAL INTEREST
     C     IKMTTI        IFLT      0
     C                   Z-SUB     IKMTTI        TOTI
     C                   ELSE
     C                   Z-ADD     IKMTTI        TOTI
     C                   END
     C                   Z-ADD     0             FSTOTN                                       224059
     C                   IF        CAS005 = 'Y'                                               CAS005
     C     TOTI          IFNE      0                                                          224059
     C     IKLQPS        IFEQ      '+'                                                        224059
     C                   EVAL      WNTR = IKINTR + IKLQPR                                     224059
     C                   ELSE                                                                 224059
     C                   EVAL      WNTR = IKINTR - IKLQPR                                     224059
     C                   ENDIF                                                                224059
                                                                                            BUG13224
     C                   IF        IKINTR <> 0                                              BUG13224
     C     TOTI          DIV       IKINTR        WTOTI                                        224059
     C     WTOTI         MULT      WNTR          IKTNTR                                       224059
     C                   ENDIF                                                              BUG13224
                                                                                              224059
     C                   EVAL      IKTNTR2 = IKTNTR                                           CAS005
     C     IKTNTR_A      IFEQ      ' '                                                        CAS005
     C                   EVAL      IKTNTR = 0                                                 CAS005
     C                   ENDIF                                                                CAS005
     C     IKTNTR        IFLT      0                                                          CAS005
     C                   Z-SUB     IKTNTR        FSTOTN                                       CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-ADD     IKTNTR        FSTOTN                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                224059
      *
      * NEXT INT PAY DATE
     C                   Z-ADD     IKNIPD        NIDT
      *
      * INT. BASE DATE
     C                   Z-ADD     IKNIPD        IBDT
      *
      * START/LAST INT DATE
     C                   Z-ADD     IKDVSD        SLID
      *
      * INTEREST ACCRUAL FIELDS
      *
     C                   Z-ADD     *ZERO         AIPD
     C                   Z-ADD     *ZERO         DLRC
     C                   Z-ADD     IKDVSD        IACD
     C                   Z-ADD     *ZERO         AITC
     C                   Z-ADD     *ZERO         AIAN
     C                   Z-ADD     *ZERO         AIAP
     C                   Z-ADD     *ZERO         IPRD
     C                   Z-ADD     *ZERO         IPRM
     C                   Z-ADD     *ZERO         ICTD
      *
      * IF FIRST & LAST DAY INTEREST = Y
      * CALCULATE THE ONE DAY'S INTEREST DIFFERENCE, AND PUT IT IN AIAN
      *
     C     IKFLID        IFEQ      'Y'
     C                   EXSR      CAL1DY
     C                   END
      *
      * DEAL AMEND VALUE DATE & SEQ
      *
     C                   Z-ADD     *ZERO         DAVD
     C                   Z-ADD     *ZERO         DASN
      *
      * FOR A/C OF & SPECIAL INSTRUCTIONS
      *
     C                   MOVE      IKMFAO        FACO
     C                   MOVE      IKSPEC        SPI
      *
      * INT.DAY IN MONTH
     C                   Z-ADD     IKIPDM        INTF
      *
      * TAXABLE IND AND TAX FIELDS
      *
     C                   MOVE      IKMTAX        TAXI
     C                   Z-ADD     *ZERO         TAXD
     C                   Z-ADD     *ZERO         TAXM
      *
      ** INITIALIZE BITS for static and non static indicators.
      *
     C                   BITOFF    '01234567'    DNSI
     C                   BITOFF    '01234567'    DSTI
     C                   BITOFF    '01234567'    CNFI
     C                   BITOFF    '01234567'    ACEI
     C                   BITOFF    '01234567'    TLXI
      *
      * NON-STATIC BIT = LOAN
      *
     C     IKMTYP        IFNE      'IT'
     C     IKMTYP        ANDNE     'TD'
     C     IKMTYP        ANDNE     'CD'
     C     IKMTYP        ANDNE     'CI'
     C     IKMTYP        ANDNE     'ID'
     C*****CDL006******  ANDEQ     'N'                                                 CDL006 209760
     C     CDL006        ANDNE     'Y'                                                        209760
     C     IKMTYP        ORNE      'IT'                                         CDL006
     C     IKMTYP        ANDNE     'TD'                                         CDL006
     C     IKMTYP        ANDNE     'CD'                                         CDL006
     C     IKMTYP        ANDNE     'CI'                                         CDL006
     C     IKMTYP        ANDNE     'ID'                                         CDL006
     C     IKMTYP        ANDNE     'FT'                                         CDL006
     C     IKMTYP        ANDNE     'DT'                                         CDL006
     C     IKMTYP        ANDNE     'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C                   BITON     '0'           DNSI
     C                   END
     C/COPY WNCPYSRC,MMLDNIDC12
      *                                                                                       CDL033
      ** Extra processing for CF deals.                                                       CDL033
      ** If deal type is 'CF' and CDL033 switchable feature is 'Y'                            CDL033
      *                                                                                       CDL033
     C     IKMTYP        IFEQ      'CF'                                                       CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
     C                   BITOFF    '0'           DNSI                                         CDL033
     C                   BITON     '2'           DNSI                                         CDL033
     C                   ENDIF                                                                CDL033
      *
      * NON-STATIC BIT = TOTAL INTEREST OVERRIDE
      *
     C     IKBSRC        IFNE      *BLANK
     C     IKMTYP        OREQ      'CD'
     C     IKMTYP        OREQ      'CL'
     C     IKMTYP        OREQ      'DL'
     C     IKMTYP        OREQ      'IL'
     C     IKMTYP        OREQ      'ID'
     C     IKMTYP        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'DP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'LP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKFLID        OREQ      'Y'
     C                   BITON     '2'           DNSI
     C                   END
     C/COPY WNCPYSRC,MMLDNIDC23
      *
      * STATIC BIT = BROKERAGE IS ZERO WITH BROKER
      *
     C     IKBKCD        IFNE      'TELX'
     C     IKBKCD        ANDNE     'MAIL'
     C     IKBKCD        ANDNE     'PHON'
     C     IKBKCD        ANDNE     *BLANK
     C     IKBRKG        IFEQ      *ALL'9'
     C                   BITON     '0'           DSTI
     C                   END
     C                   END
      *
      * STATIC BIT = NEGATIVE INTEREST
      *
     C     IKNGVI        IFEQ      'Y'
     C                   BITON     '1'           DSTI
     C                   END
      *
      * STATIC BIT = FEDERAL FUNDS & DEPOSIT
      *
     C     IKFEDF        IFEQ      'Y'
     C     IKCCY         ANDEQ     BLUSCY
     C     IKAMNP        ANDGT     *ZERO
     C                   BITON     '2'           DSTI
     C                   END
      *
      * STATIC BIT = FEDERAL FUNDS & LOAN
      *
     C     IKFEDF        IFEQ      'Y'
     C     IKCCY         ANDEQ     BLUSCY
     C     IKAMNP        ANDLT     *ZERO
     C                   BITON     '3'           DSTI
     C                   END
      *
      * LAST SWIFT SEQUENCES
      *
     C                   Z-ADD     *ZERO         LSWC
     C                   Z-ADD     *ZERO         LSWS
      *
      * ORIGINAL ENTRY DATE, LAST CHANGE DATE & LAST CHANGE TYPE
      *
     C                   Z-ADD     BJRDNB        ORED
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      IKCHTP        CHTP
     C                   Z-ADD     *ZERO         TNLU
      *
      ** REPO/PLEDGE INDICATOR AND NUMBER
     C                   MOVE      IKDRID        DRID
     C                   MOVE      IKDDMR        DDMR
      *
      ** BOOK CODE
     C                   MOVE      IKBOKC        BOKC
      *
      ** LINKED DEAL NUMBER
     C                   MOVE      IKLNKN        LNKDN
      *
      * RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @MMREC        @DLREC
     C                   MOVE      IKRMAC        FSRMAC                                       CDL018
     C                   MOVEL     IKRONS        RONS                                         NAD002
     C**********         MOVEL     @MMRECEx      @DLRECEx                              CGL029 NAD002
      *                                                                                       CDL094
      * Enhanced Receive Settlement Instructions                                              CDL094
     C                   MOVEL     IKRBB1        RBTB1                                        CDL094
     C                   MOVEL     IKRBB2        RBTB2                                        CDL094
     C                   MOVEL     IKRBB3        RBTB3                                        CDL094
     C                   MOVEL     IKRBB4        RBTB4                                        CDL094
     C                   MOVEL     IKRBB5        RBTB5                                        CDL094
     C                   MOVEL     IKRBB6        RBTB6                                        CDL094
      ** Update Business Day Conventions fields                                               CDL096
     C                   EVAL      @DLDET = @MMDET                                            CDL096
      *
      ** Update Tax Code fields                                                               CGL165
     C                   IF        CGL165 = 'Y'                                               CGL165
     C                   EVAL      @DLTXC = @MMTXC                                            CGL165
     C                   ENDIF                                                                CGL165
      * PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @MMPY1        @DLPY1
     C                   MOVEL     @MMPY2        @DLPY2
     C                   MOVEL     @MMPY3        @DLPY3
     C*****CDL033********IFEQ      'Y'                                                 CDL033 CDL038
     C                   MOVEL     @MMPY4        @DLPY4                                       CDL033
     C*******************ENDIF                                                         CDL033 CDL038
     C                   MOVE      IKPMAC        FSPMAC                                       CDL018
     C                   MOVEL     IKPONS        PONS                                         NAD002
     C**********         MOVEL     @MMPY1Ex      @DLPY1Ex                              CGL029 NAD002
      *
      * ORIGINATING BRANCH
     C                   MOVEL     IKORBR        ORBR
      *
      * PROFIT CENTRE
     C                   MOVEL     IKPRFC        PRFC
      *
      * OUR REC & PAY SETTLEMENT BRANCHES
      *
     C                   MOVEL     IKROBR        ROBR
     C                   MOVEL     IKPOBR        POBR
      *
      * COVER MESSAGE REQUIRED
      *
     C     IKCVMR        IFNE      'Y'
     C                   MOVE      'N'           CVMR
     C                   ELSE
     C                   MOVE      'Y'           CVMR
     C                   END
      *
      * ROUND DOWN INT, FIRST/LAST DAY INT, FRONT-UP INT.
      *
     C                   MOVE      IKRDFC        JRDFC
     C                   MOVE      IKFLID        JFLID
     C                   MOVE      IKFUID        FUID
      *
      ** Set up the enhanced rollover processing fields
      *
     C                   MOVEL     IKAURO        AURO
     C                   MOVEL     IKIPDS        IPDS
     C                   MOVEL     IKROFQ        ROFQ
     C                   MOVEL     IKRLDN        RLDN
     C                   MOVEL     IKCNNA        CNNA
     C                   MOVEL     IKIMET        IMET
     C                   MOVEL     IKINSA        INSA
     C                   MOVEL     IKINOS        INOS
     C                   MOVEL     IKWRPI        WRPI
      *
      ** Portfolio Reference
      *
     C                   MOVE      IKPTFR        PTFR
      *
      ** FX Rate at Deal Date
      *
     C                   Z-ADD     *ZERO         FXRD
      *
      **  Set up funding information fields
      *
     C                   Z-ADD     IKFSRP        FSRP
     C                   MOVE      IKFSGN        FSGN
     C                   MOVE      IKFPRC        FPRC
     C                   Z-ADD     IKDVSD        FCTD
     C                   Z-ADD     0             TCOF
     C                   Z-ADD     0             ACPD
     C                   Z-ADD     0             ACDA
     C                   Z-ADD     0             ACAP
     C                   Z-ADD     0             ACAN
     C                   Z-ADD     0             COFD
     C                   Z-ADD     0             COFM
     C                   Z-ADD     0             CFCD
      *
      **  If first & last day interest = Y, calculate the one day's
      **  funding interest difference and put it in ACAN
      *
     C     IKFLID        IFEQ      'Y'
     C                   EXSR      CAL1DYFND
     C                   END
      *
      ** EMU Settlement fields
      *
     C                   MOVEL     IKSTCY        STCY
     C                   MOVEL     IKIC72        IC72
     C                   MOVEL     IKISCY        ISCY
     C                   MOVEL     IKII72        II72
      *                                                                         CAP004
      * Rollover To/from Currency (CEU015)                                      CAP004
     C                   MOVE      IKRTFC        RTFC                           CAP004
      *                                                                         CDL007
      * Breakdown Fields                                                        CDL007
     C                   Z-ADD     0             PENA                           CDL007
     C                   Z-ADD     0             OMDT                           CDL007
     C                   MOVEL     *BLANKS       BUSR                           CDL007
     C                   MOVEL     *BLANKS       PRIN                           CDL007
      * Automatic Authorisation                                                 CAP051
     C                   MOVEL     IKAUTH        AUTH                           CAP051
                                                                                CDL006
      ** Set up fiduciary fields                                                CDL006
                                                                                CDL006
     C     CDL006        IFEQ      'Y'                                          CDL006
     C                   MOVE      IKFCGC        FCGC                           CDL006
     C                   MOVE      IKFCGD        FCGD                           CDL006
     C                   Z-ADD     IKFCGA        FCGA                           CDL006
     C                   Z-ADD     IKFCGT        FCGT                           CDL006
     C                   MOVE      IKFCMC        FCMC                           CDL006
     C                   MOVE      IKFCMD        FCMD                           CDL006
     C                   Z-ADD     IKFCMA        FCMA                           CDL006
     C                   Z-ADD     IKFCMT        FCMT                           CDL006
     C                   MOVE      IKFTST        FTST                           CDL006
     C                   MOVE      IKFRN1        FRN1                           CDL006
     C                   MOVE      IKFRN2        FRN2                           CDL006
     C                   MOVE      IKFRN3        FRN3                           CDL006
     C                   MOVE      IKFRN4        FRN4                           CDL006
     C                   ENDIF                                                  CDL006
      *                                                                                       CGL011
      ** Initialise Collateral Flag and Amount                                                CGL011
      *                                                                                       CGL011
     C     CGL011        IfEq      'Y'                                                        CGL011
     C                   Move      *BLANK        COLF                                         CGL011
     C                   Z-Add     *ZEROS        COLA                                         CGL011
     C                   EndIf                                                                CGL011
                                                                                              CAS001
      ** Yield Curves                                                                         CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y'                                               CAS001
     C                             OR CAS004 = 'Y'                                            CAS004
     C                   EVAL      FSOYLC = IKOYLC                                            CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS005
      ** Liquidity Premium                                                                    CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSLQPR = IKLQPR                                            CAS005
     C                   EVAL      FSLQPS = IKLQPS                                            CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CDL016
      ** Rollover Indicator                                                                   CDL016
     C                   IF        CDL016 = 'Y'                                               CDL016
     C                   EVAL      FSROLI = IKROLI                                            CDL016
                                                                                              CDL016
      ** Source of Funds                                                                      CDL016
     C                   EVAL      FSSOFD = IKSOFD                                            CDL016
                                                                                              CDL016
      ** Blocked Indicator                                                                    CDL016
     C                   EVAL      FSBLKA = IKBLKA                                            CDL016
     C                   ENDIF                                                                CDL016
                                                                                              CDL019
      ** Fix Base Rate                                                                        CDL019
     C                   IF        CDL019 = 'Y'                                               CDL019
     C                   EVAL      FSFBRT = IKFBRT                                            CDL019
     C                   ENDIF                                                                CDL019
     C                   Z-ADD     *ZEROS        BCAM                                         CGL014
     C                   Z-ADD     IKRCDT        XKRCDT                                      BUG7904
     C                   Z-ADD     IKRCDM        XKRCDM                                      BUG7904
     C                   Z-ADD     IKSTRT        XKSTRT                                      BUG7904
     C                   Z-ADD     IKAILC        XKAILC                                      BUG7904
     C                   Z-ADD     IKACDA        XKACDA                                      BUG7904
     C                   Z-ADD     IKFXDM        XKFXDM                                      BUG7904
     C                   Z-ADD     IKINFD        XKINFD                                      BUG7904
     C                   Z-ADD     IKBSRF        XKBSRF                                      BUG7904
                                                                                              CDL038
      **  Class                                                                               CDL038
     C                   MOVE      IKCLAS        CLAS                                         CDL038
      **  Reference Rate                                                                      CDL049
     C**********         MOVE      IKRRAT        FSRRAT                              CDL049 BUG24144
     C                   MOVE      *ZERO         FSRRAT                                     BUG24144
      *                                                                                       CER020
      ** Initial Start Date, Final Maturity Date and                                          CER020
      ** Original Deal Number                                                                 CER020
      *                                                                                       CER020
     C                   IF        CER020 = 'Y'                                               CER020
      *                                                                                       CER020
     C                   EVAL      ISDT = IKISDT                                              CER020
     C                   EVAL      FMDT = IKFMDT                                              CER020
      *                                                                                       CER020
     C                   IF        IKORDN <> *BLANKS                                          CER020
      *                                                                                       CER020
     C                   EVAL      ORDN = %DEC(IKORDN:6:0)                                    CER020
     C                   ELSE                                                                 CER020
     C                   EVAL      ORDN = %DEC(IKDN38:6:0)                                    CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
                                                                                              CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   Z-ADD     IKCNSP        CNSP                                         CRE073
     C                   MOVE      IKRDMT        RDMT                                         CRE073
     C                   MOVE      IKRDFD        RDFD                                         CRE073
     C                   ENDIF                                                                CRE073
      *
      * WRITE DEAL
      *
     C                   WRITE     DEALSDCF
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C/COPY WNCPYSRC,MMLDNIDC25
      *
      ** Update associated record, if there is one.
      *
     C     IKDADN        IFNE      *BLANK
     C     IKDADN        ANDNE     *ZEROS
     C     IKMTYP        ANDNE     'ID'
     C     IKMTYP        ANDNE     'IL'
      *
     C                   MOVE      IKDADN        DLNO
     C     DLNO          CHAIN     DEALSDCF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     DLNO          DBKEY
     C                   MOVEL     'DEALSDC '    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      * UPDATE ROLLED OVER BY DEAL NUMBER
      * & ROLLED OVER BY DEAL AMOUNT
      *
     C                   Z-ADD     IKDN38        RBDN
      *                                                                                       239566
     C                   IF        CEU015 = 'Y'                                               239566
     C                             AND IKRTFC <> *BLANKS                                      239566
     C                             AND IKCCY <> IKRTFC                                        239566
      *                                                                                       239566
     C                   IF        IKORDA < 0                                                 239566
     C                   Z-SUB     IKORDA        RBDA                                         239566
     C                   ELSE                                                                 239566
     C                   Z-ADD     IKORDA        RBDA                                         239566
     C                   ENDIF                                                                239566
      *                                                                                       239566
     C                   ELSE                                                                 239566
      *                                                                                       239566
     C     IKAMNP        IFLT      *ZERO
     C                   Z-SUB     IKAMNP        RBDA
     C                   ELSE
     C                   Z-ADD     IKAMNP        RBDA
     C                   END
      *                                                                                       239566
     C                   ENDIF                                                                239566
      *                                                                                       239566
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'A'           CHTP
     C                   MOVE      'Y'           WRPI
      *                                                                         CAP004
      * If rollover from/to currency is present (when CEU015 is switched on)    CAP004
      * on rollover deal, update same field on rolled over deal.                CAP004
      *                                                                         CAP004
     C     IKRTFC        IFNE      *BLANKS                                      CAP004
     C                   MOVE      IKCCY         RTFC                           CAP004
     C                   ELSE                                                   CAP004
     C                   MOVE      *BLANKS       RTFC                           CAP004
     C                   ENDIF                                                  CAP004
      *
     C                   UPDATE    DEALSDCF
      *
     C                   END
     C/COPY WNCPYSRC,MMLDNIDC20
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* LDAMD  - AMEND A LOAN/DEPOSIT                                *
     C*                                                              *
     C****************************************************************
     C     LDAMD         BEGSR
      *
      * ACCESS DEAL
      *
     C     IKDN38        CHAIN     DEALSDCF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     IKDN38        DBKEY
     C                   MOVEL     'DEALSDC '    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*                                                                                       247151
     C**********         MOVE      ' '           RecSd             1                 247151 AR582922
     C**********         MOVE      ' '           PaySd             1                 247151 AR582922
     C     @MMREC        IFNE      @DLREC                                                     247151
     C     IKRMAC        ORNE      FSRMAC                                                     247151
     C     IKRONS        ORNE      RONS                                                       247151
     C                   MOVE      'Y'           RecSd             1                          247151
     C                   Endif                                                                247151
     C     @MMPY1        IFNE      @DLPY1                                                     247151
     C     @MMPY2        ORNE      @DLPY2                                                     247151
     C     @MMPY3        ORNE      @DLPY3                                                     247151
     C     IKPMAC        ORNE      FSPMAC                                                     247151
     C     IKPONS        ORNE      PONS                                                       247151
     C                   MOVE      'Y'           PaySd             1                          247151
     C                   Endif                                                                247151
     C*                                                                                       247151
     C/COPY WNCPYSRC,MMLDNIDC13
      *                                                                                       CDL033
      ** Extra processing for CF deals.                                                       CDL033
      ** If deal type is 'CF' and CDL033 switchable feature is 'Y'                            CDL033
      *                                                                                       CDL033
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C     IKMTYP        ANDEQ     'CF'                                                       CDL033
      *                                                                                       CDL033
      ** Update effective rate.                                                               CDL033
      *                                                                                       CDL033
     C                   Z-ADD     IKINTR        INTR                                         CDL033
      *                                                                                       CDL033
      ** Update total interest.                                                               CDL033
      *                                                                                       CDL033
     C     IKMTTI        IFLT      *ZERO                                                      CDL033
     C                   Z-SUB     IKMTTI        TOTI                                         CDL033
     C                   ELSE                                                                 CDL033
     C                   Z-ADD     IKMTTI        TOTI                                         CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   ENDIF                                                                CDL033
      *
      * SET CONFIRMATION BIT ON DEAL
      * AND CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX
      *
     C                   EXSR      CNFAMD
      *
      * DEAL SUB-TYPE
     C                   MOVE      IKSTYP        DLST
      *
      * DEAL DATE
     C                   Z-ADD     IKDDND        DDAT
      *
      ** Check system value whether branch internal customer or the                         AR784570
      ** original customer inputted will be used for CI deals.                              AR784570
      *                                                                                     AR784570
     C                   EVAL      PSysVal01 = 'MM/CIDealsDefaulting'                       AR784570
     C                   CALLB     'AOSVALR0'                                               AR784570
     C                   PARM      *BLANKS       PRtCd                                      AR784570
     C                   PARM                    PSysVal01                                  AR784570
     C                   PARM                    PCurSet01                                  AR784570
     C                   PARM                    PSysVal02                                  AR784570
     C                   PARM                    PCurSet02                                  AR784570
     C                   PARM                    PSysVal03                                  AR784570
     C                   PARM                    PCurSet03                                  AR784570
     C                   PARM                    PSysVal04                                  AR784570
     C                   PARM                    PCurSet04                                  AR784570
     C                   PARM                    PSysVal05                                  AR784570
     C                   PARM                    PCurSet05                                  AR784570
     C                   PARM                    PSysVal06                                  AR784570
     C                   PARM                    PCurSet06                                  AR784570
     C                   PARM                    PSysVal07                                  AR784570
     C                   PARM                    PCurSet07                                  AR784570
     C                   PARM                    PSysVal08                                  AR784570
     C                   PARM                    PCurSet08                                  AR784570
     C                   PARM                    PSysVal09                                  AR784570
     C                   PARM                    PCurSet09                                  AR784570
     C                   PARM                    PSysVal10                                  AR784570
     C                   PARM                    PCurSet10                                  AR784570
      *                                                                                     AR784570
     C                   EVAL      CIdeals = 'N'                                            AR784570
      *                                                                                     AR784570
      ** If the system value is not found issue a database error                            AR784570
      *                                                                                     AR784570
     C                   IF        PRtCd = *BLANKS                                          AR784570
     C                   MOVEL     PCurSet01     CIdeals           1                        AR784570
     C                   ELSE                                                               AR784570
      *                                                                                     AR784570
     C                   IF        PRtCd <> '*NRF'                                          AR784570
     C     *LOCK         IN        LDA                                                      AR784570
     C                   EVAL      DBFile = 'SDSVALPD'                                      AR784570
     C                   EVAL      DBase = 916                                              AR784570
     C                   EVAL      DBKey = PSysVal01                                        AR784570
     C                   OUT       LDA                                                      AR784570
     C                   EXSR      SRErr                                                    AR784570
     C                   ENDIF                                                              AR784570
      *                                                                                     AR784570
     C                   ENDIF                                                              AR784570
      ***DEAL*CUSTOMER*-*BICN*OF*BRANCH*IF*CD*ISSUED*                                         185914
      *  DEAL CUSTOMER - BICN OF BRANCH IF CD ISSUED                                          202780
     C*****IKMTYP        IFEQ      'CI'                                                       185914
     C**********         EXSR      ACSBRN                                                     185914
     C**********         MOVE      A8BICN        CNUM                                         185914
     C**********         ELSE                                                                 185914
     C     IKMTYP        IFEQ      'CI'                                                       202780
     C     CIdeals       ANDEQ     'Y'                                                      AR784570
     C     IKMTYP        OREQ      'CF'                                                       CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
     C/COPY WNCPYSRC,MMLDNIDC14
     C                   EXSR      ACSBRN                                                     202780
     C                   MOVE      A8BICN        CNUM                                         202780
     C                   ELSE                                                                 202780
     C**********         Z-ADD     IKCNUM        CNUM                                         CSD027
     C                   EVAL      CNUM = IKCNUM                                              CSD027
     C**********         END                                                                  185914
     C                   END                                                                  202780
      *
      * IF MATURITY DATE HAS CHANGED
      *
     C     IKMATD        IFNE      MDAT
     C     IKMTYP        ANDNE     'CD'
     C     IKMTYP        ANDNE     'CL'
     C     IKMTYP        ANDNE     'DL'
     C     IKMTYP        ANDNE     'IL'
     C     IKMTYP        ANDNE     'ID'
     C*****CDL006******  ANDEQ     'N'                                                 CDL006 209760
     C     CDL006        ANDNE     'Y'                                                        209760
     C     IKMATD        ORNE      MDAT                                         CDL006
     C     IKMTYP        ANDNE     'CD'                                         CDL006
     C     IKMTYP        ANDNE     'CL'                                         CDL006
     C     IKMTYP        ANDNE     'DL'                                         CDL006
     C     IKMTYP        ANDNE     'IL'                                         CDL006
     C     IKMTYP        ANDNE     'ID'                                         CDL006
     C     IKMTYP        ANDNE     'DT'                                         CDL006
     C     IKMTYP        ANDNE     'LT'                                         CDL006
     C     IKMTYP        ANDNE     'DP'                                         CDL006
     C     IKMTYP        ANDNE     'LP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C                   BITON     '2'           DNSI
     C     IKMTTI        IFLT      0
     C                   Z-SUB     IKMTTI        TOTI
     C                   ELSE
     C                   Z-ADD     IKMTTI        TOTI
     C                   END
     C                   IF        CAS005 = 'Y'                                               CAS005
     C     IKTNTR        IFLT      0                                                          CAS005
     C                   Z-SUB     IKTNTR        FSTOTN                                       CAS005
     C                   ELSE                                                                 CAS005
     C                   Z-ADD     IKTNTR        FSTOTN                                       CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
     C                   END
      *
      * MATURITY DATE
     C                   Z-ADD     MDAT          @@MDAT            5 0
     C                   Z-ADD     IKMATD        MDAT
      *
      * NOTICE DAYS
     C                   Z-ADD     IKNTCE        NOTD
      *
      * REF.NO. OF NA
     C                   MOVE      IKCDRF        RNNA
      *
      * CURR.HLDR OF NA
     C**********         Z-ADD     IKMCDH        CHNA                                         CSD027
     C                   EVAL      CHNA = IKMCDH                                              CSD027
      *
      *
      * START & MATURITY DATE INSTRUCTIONS
      *
     C     IKMTYP        IFEQ      'IT'
     C     IKMTYP        OREQ      'TD'
     C     IKMTYP        OREQ      'CD'
     C     IKMTYP        OREQ      'CI'
     C     IKMTYP        OREQ      'ID'
     C     IKMTYP        OREQ      'FT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'CF'                                                       CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
     C/COPY WNCPYSRC,MMLDNIDC15
     C                   Z-ADD     IKORCM        SDST
     C                   MOVE      IKMORI        OSDA
     C                   MOVEL     IKMCPI        TSTN
     C                   Z-ADD     IKMOPM        MDST
     C                   MOVE      IKMOPI        OMDA
     C                   MOVE      IKMCRI        TMAN
     C                   ELSE
     C                   Z-ADD     IKMOPM        SDST
     C                   MOVE      IKMOPI        OSDA
     C                   MOVE      IKMCRI        TSTN
     C                   Z-ADD     IKORCM        MDST
     C                   MOVE      IKMORI        OMDA
     C                   MOVEL     IKMCPI        TMAN
     C                   END
      *
      * INTEREST CALC BASIS
     C                   MOVE      IKICMT        ICBS
      *
      * INTEREST PAY FREQUENCY
     C                   MOVE      IKIPFQ        IPFR
      *
      * If interest date has been changed, update interest base date
      * also and reset telex ind bit 2
      *
     C                   Z-ADD     NIDT          @@NIDT            5 0                      AR582922
     C     IKNIPD        IFNE      NIDT
     C                   Z-ADD     IKNIPD        NIDT
     C                   Z-ADD     IKNIPD        IBDT
     C                   BITOFF    '2'           TLXI
     C                   END
      *                                                                                       CDL033
      ** If CF deal being processed, regenerate interest message.                             CDL033
      *                                                                                       CDL033
     C     IKMTYP        IFEQ      'CF'                                                       CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
     C                   BITOFF    '12'          TLXI                                         CDL033
     C                   ENDIF                                                                CDL033
     C/COPY WNCPYSRC,MMLDNIDC16
      *
      * FOR A/C OF & SPECIAL INSTRUCTIONS
      *
     C                   MOVE      IKMFAO        FACO
     C                   MOVE      IKSPEC        SPI
      *
      * INT.DAY IN MONTH
     C                   Z-ADD     IKIPDM        INTF
      *
      * TAXABLE IND
     C                   MOVE      IKMTAX        TAXI
      *
      * LAST CHANGE DATE & LAST CHANGE TYPE
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'A'           CHTP
      *
      ** REPO/PLEDGE INDICATOR AND NUMBER
     C                   MOVE      IKDRID        DRID
     C                   MOVE      IKDDMR        DDMR
      *
      ** BOOK CODE
     C                   MOVE      IKBOKC        BOKC
      *
      ** LINKED DEAL NUMBER
     C                   MOVE      IKLNKN        LNKDN
      *
      * RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @MMREC        @DLREC
     C                   MOVE      IKRMAC        FSRMAC                                       CDL018
     C                   MOVEL     IKRONS        RONS                                         NAD002
     C**********         MOVEL     @MMRECEx      @DLRECEx                              CGL029 NAD002
      *                                                                                       CDL094
      * Enhanced Receive Settlement Instructions                                              CDL094
     C                   MOVEL     IKRBB1        RBTB1                                        CDL094
     C                   MOVEL     IKRBB2        RBTB2                                        CDL094
     C                   MOVEL     IKRBB3        RBTB3                                        CDL094
     C                   MOVEL     IKRBB4        RBTB4                                        CDL094
     C                   MOVEL     IKRBB5        RBTB5                                        CDL094
     C                   MOVEL     IKRBB6        RBTB6                                        CDL094
      ** Update Business Day Conventions fields                                               CDL096
     C                   EVAL      @DLDET = @MMDET                                            CDL096
      *
      ** Update Tax Code fields                                                               CGL165
     C                   IF        CGL165 = 'Y'                                               CGL165
     C                   EVAL      @DLTXC = @MMTXC                                            CGL165
     C                   ENDIF                                                                CGL165
      * PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @MMPY1        @DLPY1
     C                   MOVEL     @MMPY2        @DLPY2
     C                   MOVEL     @MMPY3        @DLPY3
     C*****CDL033********IFEQ      'Y'                                                 CDL033 CDL038
     C                   MOVEL     @MMPY4        @DLPY4                                       CDL033
     C*******************ENDIF                                                         CDL033 CDL038
     C                   MOVE      IKPMAC        FSPMAC                                       CDL018
     C                   MOVEL     IKPONS        PONS                                         NAD002
     C**********         MOVEL     @MMPY1Ex      @DLPY1Ex                              CGL029 NAD002
      *
      * ORIGINATING BRANCH
     C                   MOVEL     IKORBR        ORBR
      *
      * PROFIT CENTRE
     C                   MOVEL     IKPRFC        PRFC
      *
      * OUR REC & PAY SETTLEMENT BRANCHES
      *
     C                   MOVEL     IKROBR        ROBR
     C                   MOVEL     IKPOBR        POBR
      *
      * COVER MESSAGE REQUIRED
      *
     C     IKCVMR        IFNE      'Y'
     C                   MOVE      'N'           CVMR
     C                   ELSE
     C                   MOVE      'Y'           CVMR
     C                   END
      *
      * ROUND DOWN INT, FIRST/LAST DAY INT, FRONT-UP INT.
      *
     C                   MOVE      IKRDFC        JRDFC
     C                   MOVE      IKFLID        JFLID
     C                   MOVE      IKFUID        FUID
     C*
     C** Set up the enhanced rollover processing fields
     C*
     C                   MOVEL     IKAURO        AURO
     C                   MOVEL     IKIPDS        IPDS
     C                   MOVEL     IKROFQ        ROFQ
     C                   MOVEL     IKRLDN        RLDN
     C                   MOVEL     IKCNNA        CNNA
     C                   MOVEL     IKIMET        IMET
     C                   MOVEL     IKINSA        INSA
     C                   MOVEL     IKINOS        INOS
     C                   MOVEL     IKWRPI        WRPI
      *
      ** Portfolio Reference
      *
     C                   MOVE      IKPTFR        PTFR
      *
      **  Set up funding information fields
      *
     C                   Z-ADD     IKFSRP        FSRP
     C                   MOVE      IKFSGN        FSGN
     C                   MOVE      IKFPRC        FPRC
      *
      **  If first & last day interest = Y, calculate the one day's
      **  funding interest difference and put it in ACAN
      *
     C     IKFLID        IFEQ      'Y'
     C                   EXSR      CAL1DYFND
     C                   END
      *
      ** EMU Settlement fields
      *
     C                   MOVEL     IKSTCY        STCY
     C                   MOVEL     IKIC72        IC72
     C                   MOVEL     IKISCY        ISCY
     C                   MOVEL     IKII72        II72
      *                                                                         CDL007
      * Breakdown Fields                                                        CDL007
     C                   Z-ADD     IKPENA        PENA                           CDL007
     C                   Z-ADD     IKOMDT        OMDT                           CDL007
     C                   MOVEL     IKBUSR        BUSR                           CDL007
     C                   MOVEL     IKPRIN        PRIN                           CDL007
      * Automatic Authorisation                                                 CAP051
     C                   MOVEL     IKAUTH        AUTH                           CAP051
                                                                                CDL006
      ** Set up fiduciary fields                                                CDL006
                                                                                CDL006
     C     CDL006        IFEQ      'Y'                                          CDL006
     C                   MOVE      IKFCGC        FCGC                           CDL006
     C                   MOVE      IKFCGD        FCGD                           CDL006
     C                   Z-ADD     IKFCGA        FCGA                           CDL006
     C                   Z-ADD     IKFCGT        FCGT                           CDL006
     C                   MOVE      IKFCMC        FCMC                           CDL006
     C                   MOVE      IKFCMD        FCMD                           CDL006
     C                   Z-ADD     IKFCMA        FCMA                           CDL006
     C                   Z-ADD     IKFCMT        FCMT                           CDL006
     C                   MOVE      IKFTST        FTST                           CDL006
     C                   MOVE      IKFRN1        FRN1                           CDL006
     C                   MOVE      IKFRN2        FRN2                           CDL006
     C                   MOVE      IKFRN3        FRN3                           CDL006
     C                   MOVE      IKFRN4        FRN4                           CDL006
     C                   ENDIF                                                  CDL006
                                                                                              CAS001
      ** Yield Curves                                                                         CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y'                                               CAS001
     C                             OR CAS004 = 'Y'                                            CAS004
     C                   EVAL      FSOYLC = IKOYLC                                            CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS005
      ** Liquidity Premium                                                                    CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSLQPR = IKLQPR                                            CAS005
     C                   EVAL      FSLQPS = IKLQPS                                            CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CDL016
      ** Rollover Indicator                                                                   CDL016
     C                   IF        CDL016 = 'Y'                                               CDL016
     C                   EVAL      FSROLI = IKROLI                                            CDL016
                                                                                              CDL016
      ** Source of Funds                                                                      CDL016
     C                   EVAL      FSSOFD = IKSOFD                                            CDL016
                                                                                              CDL016
      ** Blocked Indicator                                                                    CDL016
     C                   EVAL      FSBLKA = IKBLKA                                            CDL016
     C                   ENDIF                                                                CDL016
                                                                                              CDL019
      ** Fix Base Rate                                                                        CDL019
     C                   IF        CDL019 = 'Y'                                               CDL019
     C                   EVAL      FSFBRT = IKFBRT                                            CDL019
     C                   ENDIF                                                                CDL019
                                                                                              CDL038
      **  Class                                                                               CDL038
     C                   MOVE      IKCLAS        CLAS                                         CDL038
      **  Reference Rate                                                                      CDL049
     C**********         MOVE      IKRRAT        FSRRAT                              CDL049 BUG24144
     C                   MOVE      *ZERO         FSRRAT                                     BUG24144
      *                                                                                       CER020
      ** Initial Start Date, Final Maturity Date and                                          CER020
      ** Original Deal Number                                                                 CER020
      *                                                                                       CER020
     C                   IF        CER020 = 'Y'                                               CER020
      *                                                                                       CER020
     C                   EVAL      ISDT = IKISDT                                              CER020
     C                   EVAL      FMDT = IKFMDT                                              CER020
      *                                                                                       CER020
     C                   IF        IKORDN <> *ZEROS                                           CER020
      *                                                                                       CER020
     C                   EVAL      ORDN = %DEC(IKORDN:6:0)                                    CER020
     C                   ELSE                                                                 CER020
     C                   EVAL      ORDN = %DEC(IKDN38:6:0)                                    CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *
      * UPDATE DEAL
      *
     C                   UPDATE    DEALSDCF
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C/COPY WNCPYSRC,MMLDNIDC26
      *
      * IF MATURITY DATE CHANGED, UPDATE APPROPRIATE
      * RECORD ON DEAL HISTORY FILE
      *
     C     MDAT          IFNE      @@MDAT
     C                   EXSR      UPDHST
     C                   END
     C/COPY WNCPYSRC,MMLDNIDC21
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* LDDEL  - DELETE A LOAN/DEPOSIT                               *
     C*                                                              *
     C****************************************************************
     C     LDDEL         BEGSR
      *
      * ACCESS DEAL
      *
     C     IKDN38        CHAIN     DEALSDCF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     IKDN38        DBKEY
     C                   MOVEL     'DEALSDC '    DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 003*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      * SET CONFIRMATION BIT ON DEAL
      * AND CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX
      *
     C                   EXSR      CNFDEL
      *
      * SET RECORD ID TO 'REVERSED'
      *
     C                   MOVE      'R'           RECI
      *
      ** LAST CHANGE DATE & TYPE
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'R'           CHTP
      *
     C                   UPDATE    DEALSDCF
      *
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** If the associated deal number on the standard deal is
      ** non-zero, use the number to access the related deal record
      ** on DEALSDC.
      *
     C     IKDADN        IFNE      *BLANK
     C     IKDADN        ANDNE     *ZEROS
     C     IKMTYP        ANDNE     'ID'
     C     IKMTYP        ANDNE     'IL'
     C                   MOVE      IKDADN        DLNO
     C     DLNO          CHAIN     DEALSDCF                           99
      *
     C     *IN99         IFNE      '1'
     C                   Z-ADD     *ZERO         RBDN
     C                   Z-ADD     *ZERO         RBDA
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'A'           CHTP
     C                   MOVE      *BLANKS       RTFC                           CAP004
     C                   UPDATE    DEALSDCF
                                                                                185801
      ** Determine if maturity messages are due to be generated.                185801
                                                                                185801
     C                   EXSR      PYRCIN2                                      185801
                                                                                185801
      ** Output a record to DTRIXDD with PRI3 set to '1' if they are.           185801
                                                                                185801
     C     ROPRI3        IFEQ      1                                            185801
     C                   EXSR      WRTDTX2                                      185801
     C                   EXSR      UPDDTH                                       185801
     C                   ENDIF                                                  185801
                                                                                185801
     C                   END
      *
     C                   END
     C/COPY WNCPYSRC,MMLDNIDC22
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* PYRCIN - DETERMINE PAY/RECEIVE INDICATORS                    *
     C*                                                              *
     C****************************************************************
     C     PYRCIN        BEGSR
      *
     C                   Z-ADD     *ZERO         @@PRI1            1 0
     C                   Z-ADD     *ZERO         @@PRI2            1 0
     C                   Z-ADD     *ZERO         @@PRI3            1 0
     C*****************************************************************              247151 AR582922
     C*****RecSd         Ifeq      ' '                                               247151 AR582922
     C*****PaySd         Andeq     ' '                                               247151 AR582922
      *
      * PAY/RECEIVE INDICATOR 1 = VALUE DATE
      * ------------------------------------
      *                                                                                     AR582922
      ** If action is not amend                                                             AR582922
      *                                                                                     AR582922
     C     IKCHTP        IFNE      'A'                                                      AR582922
      *                                                                                     AR582922
      ** or Receipt Side is amended and deposit type                                        AR582922
      *                                                                                     AR582922
     C     IKCHTP        OREQ      'A'                                                      AR582922
     C     RecSd         ANDEQ     'Y'                                                      AR582922
     C     RCDC          ANDEQ     16                                                       AR582922
      *                                                                                     AR582922
      ** or Payment Side is amended and loan type                                           AR582922
      *                                                                                     AR582922
     C     IKCHTP        OREQ      'A'                                                      AR582922
     C     PaySd         ANDEQ     'Y'                                                      AR582922
     C     RCDC          ANDEQ     15                                                       AR582922
      *
      ** Determine if local or deal currency to be used
      ** in holiday checking
      *
     C                   MOVEL     'L'           @DLOLC
     C                   MOVEL     *BLANK        @NOSTR
      *
     C     IKMTYP        IFEQ      'IT'
     C     IKMTYP        OREQ      'TD'
     C     IKMTYP        OREQ      'CD'
     C     IKMTYP        OREQ      'FT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
      *
     C     IKRSTM        IFEQ      01
     C     IKRSTM        OREQ      07
     C     IKRSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IKRONS        @NOSTR
     C**********         MOVEL     @MMRECEx      @DLRECEx                              CGL029 NAD002
     C                   END
      *
     C                   ELSE
      *
     C     IKPSTM        IFEQ      01
     C     IKPSTM        OREQ      07
     C     IKPSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IKPONS        @NOSTR
     C                   END
      *
     C                   END
      *
      ** DETERMINE TELEX DUE DATE
      *
     C                   EXSR      TLXDUE
      *
      * Set PRI1 if value date is within telex notice period
      *
     C     IKDVSD        IFGE      BJRDNB
     C     IKDVSD        ANDLE     @TLXDU
     C/COPY WNCPYSRC,MMLDNIDC04
     C                   Z-ADD     1             @@PRI1
     C                   END
     C                   ENDIF                                                              AR582922
      *
      ** PAY/RECEIVE INDICATOR 2 = INTEREST PAY DATE
      *  -------------------------------------------
      *                                                                                     AR582922
      ** If action is not amend                                                             AR582922
      *                                                                                     AR582922
     C     IKCHTP        IFNE      'A'                                                      AR582922
      *                                                                                     AR582922
      ** or Receipt Side is amended and loan type                                           AR582922
      *                                                                                     AR582922
     C     IKCHTP        OREQ      'A'                                                      AR582922
     C     RecSd         ANDEQ     'Y'                                                      AR582922
     C     RCDC          ANDEQ     15                                                       AR582922
      *                                                                                     AR582922
      ** or Interest Payment date is amended and loan type                                  AR582922
      *                                                                                     AR582922
     C     IKCHTP        OREQ      'A'                                                      AR582922
     C     IKNIPD        ANDNE     @@NIDT                                                   AR582922
     C     IKRSTM        ANDNE     *ZERO                                                    AR582922
     C     RCDC          ANDEQ     15                                                       AR582922
      *                                                                                     AR582922
      ** or Payment Side is amended and deposit type                                        AR582922
      *                                                                                     AR582922
     C     IKCHTP        OREQ      'A'                                                      AR582922
     C     PaySd         ANDEQ     'Y'                                                      AR582922
     C     RCDC          ANDEQ     16                                                       AR582922
      *                                                                                     AR582922
      ** or Interest Payment date is amended and deposit type                               AR582922
      *                                                                                     AR582922
     C     IKCHTP        OREQ      'A'                                                      AR582922
     C     IKNIPD        ANDNE     @@NIDT                                                   AR582922
     C     IKPSTM        ANDNE     *ZERO                                                    AR582922
     C     RCDC          ANDEQ     16                                                       AR582922
      *
      ** Determine if local or deal currency to be used
      ** in holiday checking
      *
     C                   MOVEL     'L'           @DLOLC
     C                   MOVEL     *BLANK        @NOSTR
      *
     C     IKMTYP        IFEQ      'IT'
     C     IKMTYP        OREQ      'TD'
     C     IKMTYP        OREQ      'CD'
     C     IKMTYP        OREQ      'FT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
      *
     C     IKPSTM        IFEQ      01
     C     IKPSTM        OREQ      07
     C     IKPSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IKPONS        @NOSTR
     C                   END
      *
     C                   ELSE
      *
     C     IKRSTM        IFEQ      01
     C     IKRSTM        OREQ      07
     C     IKRSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IKRONS        @NOSTR
     C                   END
      *
     C                   END
      *
      ** DETERMINE TELEX DUE DATE
      *
     C/COPY WNCPYSRC,MMLDNIDC05
     C                   EXSR      TLXDUE
     C/COPY WNCPYSRC,MMLDNIDC06
      *
      * Set PRI2 if interest pay date is within telex notice period
      *
     C     IKNIPD        IFNE      *ZERO
     C     IKNIPD        ANDGE     BJRDNB
     C     IKNIPD        ANDLE     @TLXDU
     C/COPY WNCPYSRC,MMLDNIDC07
     C                   Z-ADD     1             @@PRI2
     C                   END
     C                   ENDIF                                                              AR582922
      *
      ** PAY/RECEIVE INDICATOR 3 = MATURITY DATE
      *  ---------------------------------------
      *                                                                                     AR582922
      ** If action is not amend                                                             AR582922
      *                                                                                     AR582922
     C     IKCHTP        IFNE      'A'                                                      AR582922
      *                                                                                     AR582922
      ** or Receipt Side is amended and loan type                                           AR582922
      *                                                                                     AR582922
     C     IKCHTP        OREQ      'A'                                                      AR582922
     C     RecSd         ANDEQ     'Y'                                                      AR582922
     C     RCDC          ANDEQ     15                                                       AR582922
      *                                                                                     AR582922
      ** or Maturity date is amended and loan type                                          AR582922
      *                                                                                     AR582922
     C     IKCHTP        OREQ      'A'                                                      AR582922
     C     IKMATD        ANDNE     @@MDAT                                                   AR582922
     C     IKRSTM        ANDNE     *ZERO                                                    AR582922
     C     RCDC          ANDEQ     15                                                       AR582922
      *                                                                                     AR582922
     C     IKCHTP        OREQ      'A'                                                      AR582922
     C     IKNIPD        ANDNE     @@NIDT                                                   AR582922
     C     IKRSTM        ANDNE     *ZERO                                                    AR582922
     C     RCDC          ANDEQ     15                                                       AR582922
     C     IKMATD        ANDEQ     @@MDAT                                                   AR582922
      *                                                                                     AR582922
      ** or Payment Side is amended and deposit type                                        AR582922
      *                                                                                     AR582922
     C     IKCHTP        OREQ      'A'                                                      AR582922
     C     PaySd         ANDEQ     'Y'                                                      AR582922
     C     RCDC          ANDEQ     16                                                       AR582922
      *                                                                                     AR582922
      ** or Maturity date is amended and deposit type                                       AR582922
      *                                                                                     AR582922
     C     IKCHTP        OREQ      'A'                                                      AR582922
     C     IKMATD        ANDNE     @@MDAT                                                   AR582922
     C     IKPSTM        ANDNE     *ZERO                                                    AR582922
     C     RCDC          ANDEQ     16                                                       AR582922
      *                                                                                     AR582922
     C     IKCHTP        OREQ      'A'                                                      AR582922
     C     IKNIPD        ANDNE     @@NIDT                                                   AR582922
     C     IKPSTM        ANDNE     *ZERO                                                    AR582922
     C     RCDC          ANDEQ     16                                                       AR582922
     C     IKMATD        ANDEQ     @@MDAT                                                   AR582922
      *
      ** Determine if local or deal currency to be used
      ** in holiday checking
      *
     C                   MOVEL     'L'           @DLOLC
     C                   MOVEL     *BLANK        @NOSTR
      *
     C     IKMTYP        IFEQ      'IT'
     C     IKMTYP        OREQ      'TD'
     C     IKMTYP        OREQ      'CD'
     C     IKMTYP        OREQ      'FT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     IKMTYP        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
      *
     C     IKPSTM        IFEQ      01
     C     IKPSTM        OREQ      07
     C     IKPSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IKPONS        @NOSTR
     C                   END
      *
     C                   ELSE
      *
     C     IKRSTM        IFEQ      01
     C     IKRSTM        OREQ      07
     C     IKRSTM        OREQ      08
     C                   MOVE      'D'           @DLOLC
     C                   MOVEL     IKRONS        @NOSTR
     C                   END
      *
     C                   END
      *
      ** DETERMINE TELEX DUE DATE
      *
     C                   EXSR      TLXDUE
      *
      * Set PRI3 if maturity date is within telex notice period
      *
     C     IKMATD        IFGE      BJRDNB
     C     IKMATD        ANDLE     @TLXDU
     C     IKMTYP        ANDNE     'IL'
     C     IKMTYP        ANDNE     'ID'
     C/COPY WNCPYSRC,MMLDNIDC08
     C*
     C     IKAURO        IFNE      'Y'
     C     IKAURO        OREQ      'Y'
     C     IKROBY        ANDNE     *BLANKS
     C                   Z-ADD     1             @@PRI3
     C                   END
      *
     C                   END
     C                   ENDIF                                                              AR582922
     C*****************************************************************              247151 AR582922
     C**********         Else                                                        247151 AR582922
     C*****RecSd         Ifeq      'Y'                                               247151 AR582922
     C**********         Z-ADD     1             @@PRI1                              247151 AR582922
     C**********         Endif                                                       247151 AR582922
     C*****PaySd         Ifeq      'Y'                                               247151 AR582922
     C**********         Z-ADD     1             @@PRI3                              247151 AR582922
     C**********         Endif                                                       247151 AR582922
     C**********         Endif                                                       247151 AR582922
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFINS - SET CONFIRMATION INDICATOR ON INSERTION             *
     C*                                                              *
     C****************************************************************
     C     CNFINS        BEGSR
      *
     C                   MOVE      'N'           @@CNRQ            1
      *
      *
      * CONFIRMATION REQUIRED IF SETTLEMENT INSTRUCTIONS PRESENT
      * OR IF 2 LEVEL INPUT NOT PRESENT
      *
     C     IKRSTM        IFNE      *ZERO
     C     IKPSTM        ORNE      *ZERO
     C     BLL2II        OREQ      'N'
     C     IKMTYP        OREQ      'IL'                                                       CAP042
     C     IKMTYP        OREQ      'ID'                                                       CAP042
     C                   MOVE      'Y'           @@CNRQ
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFAMD - SET CONFIRMATION INDICATOR ON AMENDMENT             *
     C*                                                              *
     C****************************************************************
     C     CNFAMD        BEGSR
      *                                                                                       155792
     C                   MOVE      'N'           @@CNRQ                                       155792
     C                   TESTB     '2'           DNSI                     99                  261319
      *
      * IF SETTLEMENT INSTRUCTIONS WERE PREVIOUSLY PRESENT
      * OR IF 2 LEVEL INPUT NOT PRESENT
      *
     C     RSTM          IFNE      *ZERO
     C     PSTM          ORNE      *ZERO
     C     IKRSTM        ORNE      *ZERO                                                      209895
     C     IKPSTM        ORNE      *ZERO                                                      209895
     C     BLL2II        OREQ      'N'
     C     CAP042        OREQ      'Y'                                                        CAP042
      *
      ** If settlement instruction fields have changed
      *
     C     RSTM          IFNE      IKRSTM
     C     RONS          ORNE      IKRONS
     C     RIBN          ORNE      IKRIBN
     C     RIBA          ORNE      IKRIBA                                                     155792
     C     ROBN          ORNE      IKROBN                                                     155792
     C     ROCN          ORNE      IKROCN                                                     155792
     C     PSTM          ORNE      IKPSTM
     C     PONS          ORNE      IKPONS
     C     PIBN          ORNE      IKPIBN                                                     155792
     C     PIBA          ORNE      IKPIBA                                                     155792
     C     POBN          ORNE      IKPOBN                                                     155792
     C     POCN          ORNE      IKPOCN                                                     155792
     C     RCRN          ORNE      IKRCRN                                                     155792
     C     RCRA          ORNE      IKRCRA                                                     155792
     C     RVNO          ORNE      IKRVNO                                                     155792
     C     AWBN          ORNE      IKAWBN
     C     AWBA          ORNE      IKAWBA                                                     155792
     C     BENN          ORNE      IKBENN
     C     BENA          ORNE      IKBENA                                                     155792
     C     DTP1          ORNE      IKDTP1                                                     155792
     C     DTP2          ORNE      IKDTP2                                                     155792
     C     DTP3          ORNE      IKDTP3                                                     155792
     C     DTP4          ORNE      IKDTP4                                                     155792
     C     DCHG          ORNE      IKDCHG                                                     155792
     C     BTB1          ORNE      IKBTB1
     C     BTB2          ORNE      IKBTB2                                                     155792
     C     BTB3          ORNE      IKBTB3                                                     155792
     C     BTB4          ORNE      IKBTB4                                                     155792
     C     BTB5          ORNE      IKBTB5                                                     155792
     C     BTB6          ORNE      IKBTB6                                                     155792
     C     RBTB1         ORNE      IKRBB1                                                     CDL094
     C     RBTB2         ORNE      IKRBB2                                                     CDL094
     C     RBTB3         ORNE      IKRBB3                                                     CDL094
     C     RBTB4         ORNE      IKRBB4                                                     CDL094
     C     RBTB5         ORNE      IKRBB5                                                     CDL094
     C     RBTB6         ORNE      IKRBB6                                                     CDL094
     C*****CVMR*         ORNE      IKCVMR                                     155792 BUG6191 BUG6225
     C     CVMR          OREQ      'Y'                                                       BUG6191
     C     IKCVMR        ANDNE     'Y'                                                       BUG6191
     C     CVMR          OREQ      'N'                                                       BUG6191
     C     IKCVMR        ANDNE     'N'                                                       BUG6191
     C     IKCVMR        ANDNE     ' '                                                       BUG6191
     C     STCY          ORNE      IKSTCY                                                     155792
     C     IC72          ORNE      IKIC72                                                     155792
      *
      ** or if deal contract fields have changed
      *
     C     MDAT          ORNE      IKMATD
     C     NIDT          ORNE      IKNIPD
     C     IPFR          ORNE      IKIPFQ
     C     INTF          ORNE      IKIPDM
                                                                                              CAP042
     C     IKMTYP        OREQ      'IL'                                                       CAP042
     C     IKMTYP        OREQ      'ID'                                                       CAP042
     C     FSOYLC        ORNE      IKOYLC                                                     CAS001
     C     CAS001        ANDEQ     'Y'                                                        CAS001
     C     FSOYLC        ORNE      IKOYLC                                                     CAS004
     C     CAS004        ANDEQ     'Y'                                                        CAS004
     C     FSLQPR        ORNE      IKLQPR                                                     CAS005
     C     FSLQPS        ANDNE     IKLQPS                                                     CAS005
     C     CAS005        ANDEQ     'Y'                                                        CAS005
     C     CSW050        OREQ      'Y'                                                        246801
     C     IMET          ORNE      IKIMET                                                     247835
     C     INSA          ORNE      IKINSA                                                     247835
     C     INOS          ORNE      IKINOS                                                     248932
      *                                                                                       261319
      ** or if interest adjustment is present                                                 261319
      *                                                                                       261319
     C     *IN99         OREQ      *ON                                                        261319
      *
      ** Produce a confirmation now
      *
     C                   BITOFF    '0'           CNFI
     C                   MOVE      'Y'           @@CNRQ
      *
      * Set off maturity and interest indicators if past value date
      *
     C     ORED          IFLT      BJRDNB
     C     VDAT          ANDLT     BJRDNB
      *                                                                         CSW200
     C                   IF        CSW200 <> 'CSW200'                           CSW200
     C                   BITOFF    '12'          CNFI
     C                   ELSE                                                   CSW200
     C                   IF        DTYP = 'IP'  or  DTYP = 'IT'  or             CSW200
     C                             DTYP = 'TI'  or  DTYP = 'TD'                 CSW200
     C                   BITOFF    '2'           CNFI                           CSW200
     C                   ELSE                                                   CSW200
     C                   BITOFF    '12'          CNFI                           CSW200
     C                   ENDIF                                                  CSW200
     C                   ENDIF                                                  CSW200
      *                                                                         CSW200
     C                   END
      *
     C                   END
     C                   END
     C/COPY WNCPYSRC,MMLDNIDC17
      *                                                                                       CDL033
      ** If CF deal being processed, regenerate confirmation                                  CDL033
      ** and advices.                                                                         CDL033
      *                                                                                       CDL033
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C     IKMTYP        ANDEQ     'CF'                                                       CDL033
      *                                                                                       CDL033
     C     RSTM          IFNE      *ZERO                                                      CDL033
     C     PSTM          ORNE      *ZERO                                                      CDL033
     C     IKRSTM        ORNE      *ZERO                                                      CDL033
     C     IKPSTM        ORNE      *ZERO                                                      CDL033
     C     BLL2II        OREQ      'N'                                                        CDL033
     C                   BITOFF    '012'         CNFI                                         CDL033
     C                   MOVE      'Y'           @@CNRQ                                       CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFDEL - SET CONFIRMATION INDICATOR ON DELETION              *
     C*                                                              *
     C****************************************************************
     C     CNFDEL        BEGSR
      *                                                                                       155792
     C                   MOVE      'N'           @@CNRQ                                       155792
      *
      * CONFIRMATION REQUIRED IF ONE PRODUCED PREVIOUSLY
      *
     C                   TESTB     '7'           CNFI                     99
     C     *IN99         IFEQ      '1'
     C     IKMTYP        OREQ      'IL'                                                       CAP042
     C     CAP042        ANDEQ     'Y'                                                        CAP042
     C     IKMTYP        OREQ      'ID'                                                       CAP042
     C     CAP042        ANDEQ     'Y'                                                        CAP042
     C                   BITOFF    '0'           CNFI
     C                   MOVE      'Y'           @@CNRQ
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* WRTDTX - WRITE A DTRIX RECORD                                *
     C*                                                              *
     C****************************************************************
     C     WRTDTX        BEGSR
      *
      **  SET FIELDS ON RECORD TO BE WRITTEN TO DTRIXDD
      *
     C                   MOVE      'D'           DXRECI
     C                   MOVE      'D'           DXRCDT
     C                   Z-ADD     IKDN38        DXDLNO
     C                   Z-ADD     *ZERO         DXVDAT
     C                   Z-ADD     *ZERO         DXDASN
     C                   MOVE      IKCHTP        DXCHTP
     C                   MOVE      @@CNRQ        DXCNRQ
     C                   MOVE      'N'           DXCNPR
     C                   MOVE      ' '           DXREPR
     C                   TIME                    @XTIME
     C                   MOVE      @@PRI1        DXPRI1
     C                   MOVE      @@PRI2        DXPRI2
     C                   MOVE      @@PRI3        DXPRI3
     C                   Z-ADD     0             DXICIN
     C                   MOVEL     IKBRCA        DXBRCA
     C                   Z-ADD     *ZERO         DXTNLU
                                                                                              CAP042
      ** Set the value of Deal Amendment Delete Indicator                                     CAP042
                                                                                              CAP042
     C                   IF        IKMTYP = 'IL' and CAP042 = 'Y' or                          CAP042
     C                             IKMTYP = 'ID' and CAP042 = 'Y'                             CAP042
     C                   EVAL      DXDADI = 'N'                                               CAP042
     C                   ENDIF                                                                CAP042
     C*
     C                   WRITE     DTRIXDF
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDDTH - UPDATE THE DTRIX HEADER RECORD                      *
     C*                                                              *
     C****************************************************************
     C     UPDDTH        BEGSR
      *
      ** Access the header record
      *
     C                   Z-ADD     *ZERO         DXDLNO
     C     DXDLNO        CHAIN     DTRIXHF                            99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     DXDLNO        DBKEY
     C                   MOVEL     'DTRIXHF '    DBFILE                         ************
     C                   MOVEL     '004'         DBASE                          * DBERR 004*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      * Add 1 to number of deal records (on DTRIXDD)
      *
     C                   ADD       1             DXNDLR
      *
     C                   UPDATE    DTRIXHF
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDTRL- UPDATE THE DEALS FILE TRAILER                        *
     C*                                                              *
     C****************************************************************
     C     UPDTRL        BEGSR
      *
     C     MTHREAD       IFEQ      'Y'                                                      MD025244
     C                   MOVE      DLNO          EAPIC                                      MD025244
     C                   MOVEL     'LDNI'        EAPIC                                      MD025244
     C                   ELSE                                                               MD025244
     C                   MOVE      *BLANKS       EAPIC                                      MD025244
     C                   ENDIF                                                              MD025244
      *                                                                                     MD025244
     C                   CALLB     'ZADLTRLRUD'
      *
      ** Return Code
     C                   PARM      *BLANKS       @@RTCD            7
      *
      ** Change Type
     C                   PARM      IKCHTP        @@CHTP            1
      *
      ** Amount
     C                   PARM      IKAMNP        @@AMNP           15 0
      *
      ** Run Date
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    EAPIC            10                        MD025244
      *
      ** DATABASE ERROR
      *
     C     @@RTCD        IFEQ      '*ERROR '
     C                   MOVEL     '999999'      DBKEY
     C                   MOVEL     'DEALSDF '    DBFILE                         ************
     C                   MOVEL     '005'         DBASE                          * DBERR 005*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* TLXDUE - DETERMINE TELEX DUE DATE                            *
     C*                                                              *
     C****************************************************************
     C     TLXDUE        BEGSR
      *
      * EFFECTIVE SETTLEMENT CURRENCY
      *
     C     IKSTCY        IFNE      *BLANKS
     C                   MOVEL     IKSTCY        EffSetCcy
     C                   ELSE
     C                   MOVEL     IKCCY         EffSetCcy         3
     C                   ENDIF
     C/COPY WNCPYSRC,MMH00006
      *
     C                   CALLB     'ZATLXDUEDT'
      *
      ** Deal or local Currency
     C                   PARM                    @DLOLC            1
      *
      ** Currency
     C                   PARM      EffSetCcy     @CCY              3
      *
      ** Nostro
     C                   PARM                    @NOSTR            2
      *
      ** Date of Next Working Day
     C                   PARM                    BJDNWD            5 0
      *
      ** Local Currency
     C                   PARM                    BJLCCY            3
      *
      ** System Location
     C                   PARM                    BJSLCD            3
      *
      ** Telex Due Date
     C                   PARM      *ZERO         @TLXDU            5 0
     C/COPY WNCPYSRC,MMH00007
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CAL1DY - CALCULATE ONE DAY'S INTEREST                        *
     C*                                                              *
     C****************************************************************
     C     CAL1DY        BEGSR
     C*
     C* START DATE = VALUE DATE, END DATE = MATURITY DATE
     C*
     C                   Z-ADD     IKDVSD        @@BEG
     C                   Z-ADD     IKMATD        @@END
     C*
     C* PRINCIPAL, RATE, CALCULATION METHOD, ROUND DOWN INTEREST
     C*
     C     IKAMNP        IFLT      *ZERO
     C                   Z-SUB     IKAMNP        @@AMT            15 0
     C                   ELSE
     C                   Z-ADD     IKAMNP        @@AMT            15 0
     C                   END
     C                   Z-ADD     IKINTR        @@RATE           11 7
     C                   MOVEL     IKICMT        @@CALC            1
     C                   MOVEL     IKRDFC        @@RDFC            1
      *
     C                   CALLB     'MM1030'
     C                   PARM                    @@BEG             5 0
     C                   PARM                    @@END             5 0
     C                   PARM                    @@CALC            1
     C                   PARM                    @@AMT            15 0
     C                   PARM                    @@RATE           11 7
     C                   PARM                    @@RDFC            1
     C                   PARM      *ZERO         @@INTR           15 0
     C*
     C* CALCULATE INTEREST FROM VALUE DATE TO MATURITY DATE
     C*
     C                   Z-SUB     @@INTR        AIAN
     C*
     C* CALCULATE INTEREST FROM VALUE DATE TO MATURITY DATE + 1
     C*
     C                   ADD       1             @@END
      *
     C                   CALLB     'MM1030'
     C                   PARM                    @@BEG             5 0
     C                   PARM                    @@END             5 0
     C                   PARM                    @@CALC            1
     C                   PARM                    @@AMT            15 0
     C                   PARM                    @@RATE           11 7
     C                   PARM                    @@RDFC            1
     C                   PARM                    @@INTR           15 0
      *
     C                   ADD       @@INTR        AIAN
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CAL1DYFND - CALCULATE ONE DAY'S FUNDING INTEREST             *
     C*                                                              *
     C****************************************************************
     C     CAL1DYFND     BEGSR
     C*
     C* START DATE = VALUE DATE, END DATE = MATURITY DATE
     C*
     C                   Z-ADD     IKDVSD        @@BEG
     C                   Z-ADD     IKMATD        @@END
     C*
     C* PRINCIPAL, RATE, CALCULATION METHOD, ROUND DOWN INTEREST
     C*
     C     IKAMNP        IFLT      *ZERO
     C                   Z-SUB     IKAMNP        @@AMT
     C                   ELSE
     C                   Z-ADD     IKAMNP        @@AMT
     C                   END
     C*
     C                   SELECT
     C     IKFSGN        WHENEQ    ' '
     C                   Z-ADD     IKFSRP        @@RATE
     C     IKFSGN        WHENEQ    '+'
     C     IKINTR        ADD       IKFSRP        @@RATE
     C     IKFSGN        WHENEQ    '-'
     C     IKINTR        SUB       IKFSRP        @@RATE
     C                   ENDSL
     C*
     C                   MOVEL     IKICMT        @@CALC            1
     C                   MOVEL     IKRDFC        @@RDFC            1
      *
     C                   CALLB     'MM1030'
     C                   PARM                    @@BEG             5 0
     C                   PARM                    @@END             5 0
     C                   PARM                    @@CALC            1
     C                   PARM                    @@AMT            15 0
     C                   PARM                    @@RATE           11 7
     C                   PARM                    @@RDFC            1
     C                   PARM      *ZERO         @@INTR           15 0
     C*
     C* CALCULATE INTEREST FROM VALUE DATE TO MATURITY DATE
     C*
     C                   Z-SUB     @@INTR        ACAN
     C*
     C* CALCULATE INTEREST FROM VALUE DATE TO MATURITY DATE + 1
     C*
     C                   ADD       1             @@END
      *
     C                   CALLB     'MM1030'
     C                   PARM                    @@BEG             5 0
     C                   PARM                    @@END             5 0
     C                   PARM                    @@CALC            1
     C                   PARM                    @@AMT            15 0
     C                   PARM                    @@RATE           11 7
     C                   PARM                    @@RDFC            1
     C                   PARM                    @@INTR           15 0
      *
     C                   ADD       @@INTR        ACAN
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* RATINS - UPDATE AUS.BROK.RATES FILE ON INSERTION             *
     C*                                                              *
     C****************************************************************
     C     RATINS        BEGSR
     C*
     C     IKDN38        CHAIN     BKRAT                              99
      *
     C                   MOVE      'D'           RECI
     C                   Z-ADD     IKDN38        DLNO
     C                   MOVEL     IKRACD        RACD
     C                   Z-ADD     0             BACD
     C                   Z-ADD     0             BRPD
     C                   Z-ADD     0             BAPD
     C                   MOVEL     IKBRCA        BRCA
      *
     C     *IN99         IFEQ      '0'
     C                   UPDATE    BKRATAAF
     C                   ELSE
     C                   WRITE     BKRATAAF
     C                   END
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* RATDEL - UPDATE AUS.BROK.RATES FILE ON DELETION              *
     C*                                                              *
     C****************************************************************
     C     RATDEL        BEGSR
     C*
     C     IKDN38        CHAIN     BKRAT                              99
     C     *IN99         IFEQ      '0'
     C                   MOVE      'R'           RECI
     C                   UPDATE    BKRATAAF
     C                   END
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDHST - UPDATE DEAL HISTORY                                 *
     C*                                                              *
     C****************************************************************
     C     UPDHST        BEGSR
     C*
     C** Read through history records till OB (Opening Balance) or
     C** LD (Lodgement) record found. Then check if maturity date is
     C** different, if so update history record.
     C*
     C     IKDN38        SETLL     HIST1
     C     IKDN38        READE     HIST1                                  99
      *
     C     *IN99         DOWEQ     '0'
     C     HSRTYP        IFEQ      'OB'
     C     HSRTYP        OREQ      'LD'
     C     HSMDAT        IFNE      MDAT
     C                   Z-ADD     MDAT          HSMDAT
     C                   UPDATE    HISTSAAF
     C                   END
     C                   END
     C     IKDN38        READE     HIST1                                  99
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* ACSBRN - ACCESS BRANCH DETAILS                               *
     C*                                                              *
     C****************************************************************
     C     ACSBRN        BEGSR
      *
      ** Access branch record to pick up branch internal
      ** customer number.
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      IKBRCA        @DSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @DSNB         DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE                         ************
     C                   MOVEL     '006'         DBASE                          * DBERR 006*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* ACSBRT - ACCESS BASE RATE                                    *
     C*                                                              *
     C****************************************************************
     C     ACSBRT        BEGSR
      *
      ** Access base rate record
      *
     C                   CALLB     'AOBSRTR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      IKCCY         @AJCD             3
     C                   PARM      IKBSRC        @DWNB             2
     C*****SDBSRT        PARM      SDBSRT        DSFDY                          CSD006
     C     SDBSRT        PARM      SDBSRT        DSSDY                          CSD006
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     IKCCY         @DBFD             8
     C                   MOVE      IKBSRC        @DBFD
     C                   MOVEL     @DBFD         DBKEY
     C                   MOVEL     'SDBSRTPD'    DBFILE                         ************
     C                   MOVEL     '007'         DBASE                          * DBERR 007*
     C                   EXSR      SRERR                                        ************
     C                   END
                                                                                             BUG5169
      ** Get Historic Base Rate or Current Base Rate depending on                            BUG5169
      ** Value Date of the Deal                                                              BUG5169
                                                                                             BUG5169
     C                   Z-ADD     *ZEROS        WkBaseRate       11 7                       BUG5169
                                                                                             BUG5169
     C     @RTCD         IFEQ      *BLANKS                                                   BUG5169
     C     CDL020        ANDEQ     'Y'                                                       BUG5169
                                                                                             BUG5169
     C     IKDVSD        IFGE      BAVDRC                                                    BUG5169
     C     IKDVSD        ORGE      BAVDNR                                                    BUG5169
                                                                                             BUG5169
      ** Determine actual base rate                                                          BUG5169
                                                                                             BUG5169
     C     IKDVSD        IFLT      BAVDNR                                                    BUG5169
     C                   Z-ADD     BACBSR        WkBaseRate       11 7                       BUG5169
     C                   ELSE                                                                BUG5169
     C                   Z-ADD     BANBRT        WkBaseRate                                  BUG5169
     C                   ENDIF                                                               BUG5169
                                                                                             BUG5169
      ** Access Historic Base Rates                                                          BUG5169
                                                                                             BUG5169
     C                   ELSE                                                                BUG5169
     C                   Z-ADD     0             @BSRT             2 0                       BUG5169
     C                   MOVE      IKBSRC        @BSRT                                       BUG5169
                                                                                             BUG5169
     C                   CALL      'AOBSHSR0'                                                BUG5169
     C                   PARM      *BLANKS       @RTCD                                       BUG5169
     C                   PARM      '*KEY   '     @OPTN                                       BUG5169
     C                   PARM      IKCCY         @AJCD                                       BUG5169
     C                   PARM      @BSRT         @DEFFNDRT         2 0                       BUG5169
     C                   PARM      IKDVSD        @HISTDATE         5 0                       BUG5169
     C     SDBSHS        PARM      SDBSHS        DSFDY                                       BUG5169
                                                                                             BUG5169
     C     @RTCD         IFEQ      *BLANKS                                                   BUG5169
                                                                                             BUG5169
     C     BAVDNR        IFGE      G0HIDT                                                    BUG5169
     C     BAVDNR        ANDLE     IKDVSD                                                    BUG5169
     C                   Z-ADD     BANBRT        WkBaseRate                                  BUG5169
     C                   ELSE                                                                BUG5169
     C                   Z-ADD     G0CBSR        WkBaseRate                                  BUG5169
     C                   ENDIF                                                               BUG5169
                                                                                             BUG5169
      ** Get current base rate if not found on Base Rate History file                        BUG5169
                                                                                             BUG5169
     C                   ELSE                                                                BUG5169
                                                                                             BUG5169
     C     IKDVSD        IFLT      BAVDNR                                                    BUG5169
     C                   Z-ADD     BACBSR        WkBaseRate       11 7                       BUG5169
     C                   ELSE                                                                BUG5169
     C                   Z-ADD     BANBRT        WkBaseRate                                  BUG5169
     C                   ENDIF                                                               BUG5169
                                                                                             BUG5169
     C                   ENDIF                                                               BUG5169
                                                                                             BUG5169
     C                   ENDIF                                                               BUG5169
                                                                                             BUG5169
     C                   ENDIF                                                  @RETURN      BUG5169
                                                                                             BUG5169
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* ACSDCY - ACCESS DEAL CURRENCY DETAILS                        *
     C*                                                              *
     C****************************************************************
     C     ACSDCY        BEGSR
      *
      ** Access currency details using deal currency.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      IKCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @AJCD         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '008'         DBASE                          * DBERR 008*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   ENDSR
     C****************************************************************
      /EJECT                                                                    185801
      ****************************************************************          185801
      *                                                              *          185801
      * PYRCIN2 - Determine maturity pay/receive indicator           *          185801
      *                                                              *          185801
      ****************************************************************          185801
     C     PYRCIN2       BEGSR                                                  185801
                                                                                185801
     C                   Z-ADD     *ZERO         ROPRI3            1 0          185801
                                                                                185801
      ** PAY/RECEIVE INDICATOR 3 = MATURITY DATE                                185801
      ** ---------------------------------------                                185801
                                                                                185801
      ** Determine if local or deal currency to be used                         185801
      ** in holiday checking.                                                   185801
                                                                                185801
     C                   MOVEL     'L'           RDLOLC                         185801
     C                   MOVEL     *BLANK        RNOSTR                         185801
                                                                                185801
     C     DTYP          IFEQ      'IT'                                         185801
     C     DTYP          OREQ      'TD'                                         185801
     C     DTYP          OREQ      'CD'                                         185801
     C     DTYP          OREQ      'FT'                                         185801
     C     CDL006        ANDEQ     'Y'                                          185801
     C     DTYP          OREQ      'DT'                                         185801
     C     CDL006        ANDEQ     'Y'                                          185801
     C     DTYP          OREQ      'LT'                                         185801
     C     CDL006        ANDEQ     'Y'                                          185801
                                                                                185801
     C     PSTM          IFEQ      01                                           185801
     C     PSTM          OREQ      07                                           185801
     C     PSTM          OREQ      08                                           185801
     C                   MOVE      'D'           RDLOLC                         185801
     C                   MOVEL     PONS          RNOSTR                         185801
     C                   ENDIF                                                  185801
                                                                                185801
     C                   ELSE                                                   185801
                                                                                185801
     C     RSTM          IFEQ      01                                           185801
     C     RSTM          OREQ      07                                           185801
     C     RSTM          OREQ      08                                           185801
     C                   MOVE      'D'           RDLOLC                         185801
     C                   MOVEL     RONS          RNOSTR                         185801
     C                   ENDIF                                                  185801
                                                                                185801
     C                   ENDIF                                                  185801
                                                                                185801
      ** Determine telex due date.                                              185801
                                                                                185801
     C                   EXSR      TLXDUE2                                      185801
                                                                                185801
      ** Set PRI3 if maturity date is within telex notice period.               185801
                                                                                185801
     C     MDAT          IFGE      BJRDNB                                       185801
     C     MDAT          ANDLE     RTLXDU                                       185801
     C     DTYP          ANDNE     'IL'                                         185801
     C     DTYP          ANDNE     'ID'                                         185801
                                                                                185801
     C     AURO          IFNE      'Y'                                          185801
     C     AURO          OREQ      'Y'                                          185801
     C     RBDN          ANDNE     0                                            185801
     C                   Z-ADD     1             ROPRI3                         185801
     C                   ENDIF                                                  185801
                                                                                185801
     C                   ENDIF                                                  185801
                                                                                185801
     C                   ENDSR                                                  185801
      ****************************************************************          185801
      /EJECT                                                                    185801
      ****************************************************************          185801
      *                                                              *          185801
      * WRTDTX - Write a DTRIX record                                *          185801
      *                                                              *          185801
      ****************************************************************          185801
     C     WRTDTX2       BEGSR                                                  185801
                                                                                185801
      ** Set fields on record to be written to DTRIXDD.                         185801
                                                                                185801
     C                   MOVE      'D'           DXRECI                         185801
     C                   MOVE      'D'           DXRCDT                         185801
     C                   Z-ADD     DLNO          DXDLNO                         185801
     C                   Z-ADD     *ZERO         DXVDAT                         185801
     C                   Z-ADD     *ZERO         DXDASN                         185801
     C                   MOVE      CHTP          DXCHTP                         185801
     C                   MOVE      'N'           DXCNRQ                         185801
     C                   MOVE      'N'           DXCNPR                         185801
     C                   MOVE      ' '           DXREPR                         185801
     C                   TIME                    @XTIME                         185801
     C                   Z-ADD     0             DXPRI1                         185801
     C                   Z-ADD     0             DXPRI2                         185801
     C                   Z-ADD     ROPRI3        DXPRI3                         185801
     C                   Z-ADD     0             DXICIN                         185801
     C                   MOVEL     BRCA          DXBRCA                         185801
     C                   Z-ADD     *ZERO         DXTNLU                         185801
                                                                                185801
     C                   WRITE     DTRIXDF                                      185801
                                                                                185801
     C                   ENDSR                                                  185801
      ****************************************************************          185801
      /EJECT                                                                    185801
      ****************************************************************          185801
      *                                                              *          185801
      * TLXDUE2 - Determine telex due date                           *          185801
      *                                                              *          185801
      ****************************************************************          185801
     C     TLXDUE2       BEGSR                                                  185801
                                                                                185801
      ** Effective settlement currency                                          185801
                                                                                185801
     C     STCY          IFNE      *BLANKS                                      185801
     C                   MOVEL     STCY          EffSetCcy                      185801
     C                   ELSE                                                   185801
     C                   MOVEL     CCY           EffSetCcy         3            185801
     C                   ENDIF                                                  185801
     C/COPY WNCPYSRC,MMH00008
                                                                                185801
     C                   CALLB     'ZATLXDUEDT'                                 185801
                                                                                185801
      ** Deal or local Currency                                                 185801
     C                   PARM                    RDLOLC            1            185801
                                                                                185801
      ** Currency                                                               185801
     C                   PARM      EffSetCcy     RCCY              3            185801
                                                                                185801
      ** Nostro                                                                 185801
     C                   PARM                    RNOSTR            2            185801
                                                                                185801
      ** Date of Next Working Day                                               185801
     C                   PARM                    BJDNWD            5 0          185801
                                                                                185801
      ** Local Currency                                                         185801
     C                   PARM                    BJLCCY            3            185801
                                                                                185801
      ** System Location                                                        185801
     C                   PARM                    BJSLCD            3            185801
                                                                                185801
      ** Telex Due Date                                                         185801
     C                   PARM      *ZERO         RTLXDU            5 0          185801
                                                                                185801
     C/COPY WNCPYSRC,MMH00009
     C                   ENDSR                                                  185801
      ****************************************************************          185801
      /EJECT
      *****************************************************************
      ****************************************************************          185801
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
     C                   MOVEL     DLNO          KRefNo                                       CRE020
                                                                                              CRE020
      ** Begin advice index processing.                                                       CRE020
                                                                                              CRE020
     C                   MOVE      *BLANK        WNew                                         CRE020
                                                                                              CRE020
     C                   OPEN      READVCL1                                                   CRE020
                                                                                              CRE020
     C     KADVC         SETLL     READVCL1                                                   CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   DOW       NOT %EOF                                                   CRE020
                                                                                              CRE020
      ** Check first if this is a new advice index.                                           CRE020
                                                                                              CRE020
     C                   IF        WNew = *BLANK                                              CRE020
     C                   IF        RCHTYP = 'I' AND                                           CRE020
     C                             RSAPIN = 'N'                                               CRE020
     C                   MOVE      'Y'           WNew                                         CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'N'           WNew                                         CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Set default values if the advice indicator is equal to blank.                        CRE020
                                                                                              CRE020
     C                   IF        RSAPIN = ' '                                               CRE020
                                                                                              CRE020
      ** Change type is always 'I' for newly inserted records.                                CRE020
                                                                                              CRE020
     C                   MOVE      'I'           RCHTYP                                       CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Execute reversal processing if necessary.                                            CRE020
                                                                                              CRE020
     C                   IF        CHTP = 'R'                                                 CRE020
                                                                                              CRE020
      ** Delete the advice index if the current record is a new deal.                         CRE020
      ** Reverse it otherwise.                                                                CRE020
                                                                                              CRE020
     C                   MOVE      'R'           RCHTYP                                       CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
                                                                                              CRE020
     C                   IF        WNew = 'Y'                                                 CRE020
     C                   MOVE      'Y'           RSAPIN                                       CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Execute amend processing.                                                            CRE020
                                                                                              CRE020
     C                   IF        WNew = 'Y'                                                 CRE020
     C                   MOVE      'I'           RCHTYP                                       CRE020
                                                                                              CRE020
      ** Change field values only if the authorise indicator is equal to 'N'.                 CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   MOVE      CHTP          RCHTYP                                       CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   UPDATE    READVCD0                                                   CRE020
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
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    MMVLDN
     C**********         PARM      *blanks       #FPAYF                            BUG24144 AR863263
     C**********         PARM      *blanks       #FRECF                            BUG24144 AR863263
     C**********         PARM      *blanks       PBFRCD          100               BUG24144 AR863263
     C**********         PARM      *blanks       PAFRCD          100               BUG24144 AR863263
     C                   PARM                    #FPAYF                                     AR863263
     C                   PARM                    #FRECF                                     AR863263
     C                   PARM                    PBFRCD          100                        AR863263
     C                   PARM                    PAFRCD          100                        AR863263
     C/COPY WNCPYSRC,MMLDNIDC18
                                                                                              CRE020
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *
      ** ACCESS TRADING DETAILS
      *
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDTRADPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *                                                                                       CGL011
      ** Access SAR details file to determine if CGL011                                       CGL011
      ** (Collateral Details) is on.                                                          CGL011
      *                                                                                       CGL011
     C                   CALLB     'AOSARDR0'                                                 CGL011
     C                   PARM      *BLANKS       @RTCD                                        CGL011
     C                   PARM      '*VERIFY'     @OPTN                                        CGL011
     C                   PARM      'CGL011'      PSARD             6                          CGL011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL011
      *                                                                                       CGL011
      ** An NRF (No Record Found) return code is valid.                                       CGL011
      ** Issue database error only for error return codes.                                    CGL011
      *                                                                                       CGL011
     C     @RTCD         IFNE      *BLANKS                                                    CGL011
     C     @RTCD         ANDNE     '*NRF   '                                                  CGL011
     C     *LOCK         IN        LDA                                                        CGL011
     C                   MOVEL     'CGL011'      DBKEY                                        CGL011
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL011
     C                   Z-ADD     902           DBASE                                        CGL011
     C                   OUT       LDA                                                        CGL011
     C                   EXSR      SRERR                                                      CGL011
     C                   ENDIF                                                                CGL011
      *                                                                                       CGL011
     C                   MOVEL     'N'           CGL011                                       CGL011
     C     @RTCD         IFEQ      *BLANK                                                     CGL011
     C                   MOVEL     'Y'           CGL011            1                          CGL011
     C                   ENDIF                                                                CGL011
     C/COPY WNCPYSRC,MMLDNIDC24
      *                                                                                       188621
      ** Access SAR details file to determine if AUS007                                       188621
      ** (Australian Brokerage) switchable feature is ON                                      188621
      *                                                                                       188621
     C                   CALLB     'AOSARDR0'                                                 188621
     C                   PARM      *BLANKS       @RTCD                                        188621
     C                   PARM      '*VERIFY'     @OPTN                                        188621
     C                   PARM      'AUS007'      PSARD                                        188621
     C     SCSARD        PARM      SCSARD        DSFDY                                        188621
      *                                                                                       188621
      ** An NRF (No Record Found) return code is valid.                                       188621
      ** Issue database error only for error return codes.                                    188621
      *                                                                                       188621
     C     @RTCD         IFNE      *BLANKS                                                    188621
     C     @RTCD         ANDNE     '*NRF   '                                                  188621
     C     *LOCK         IN        LDA                                                        188621
     C                   MOVEL     'AUS007'      DBKEY                                        188621
     C                   MOVEL     'SCSARDPD'    DBFILE                                       188621
     C                   Z-ADD     904           DBASE                                        188621
     C                   OUT       LDA                                                        188621
     C                   EXSR      SRERR                                                      188621
     C                   ENDIF                                                                188621
      *                                                                                       188621
     C                   MOVEL     'N'           AUS007                                       188621
     C     @RTCD         IFEQ      *BLANK                                                     188621
     C                   MOVEL     'Y'           AUS007            1                          188621
     C                   ENDIF                                                                188621
                                                                                              CAP042
      ** Check if CAP042 is installed                                                         CAP042
                                                                                              CAP042
     C                   EVAL      CAP042 = 'N'                                               CAP042
     C                   CALLB     'AOSARDR0'                                                 CAP042
     C                   PARM      *BLANKS       @RTCD                                        CAP042
     C                   PARM      '*VERIFY'     @OPTN                                        CAP042
     C                   PARM      'CAP042'      PSARD                                        CAP042
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP042
                                                                                              CAP042
     C                   IF        @RTCD = *Blanks                                            CAP042
     C                   EVAL      CAP042 = 'Y'                                               CAP042
     C                   ELSE                                                                 CAP042
                                                                                              CAP042
      ** Database error                                                                       CAP042
                                                                                              CAP042
     C                   IF        @RTCD <> '*NRF'                                            CAP042
     C     *LOCK         IN        LDA                                                        CAP042
     C                   MOVEL     'CAP042'      DBKEY                                        CAP042
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP042
     C                   Z-ADD     903           DBASE                                        CAP042
     C                   OUT       LDA                                                        CAP042
     C                   EXSR      SRERR                                                      CAP042
     C                   ENDIF                                                                CAP042
     C                   ENDIF                                                                CAP042
     C*
      ** Check if SWIFT 2000 is applicable.                                     CSW200
                                                                                CSW200
     C                   CALLB     'SWIF2000'                                   CSW200
     C                   PARM      *BLANKS       CSW200            6            CSW200
                                                                                CSW200
      ** Access SAR details file to determine if CAS001 is on.                                CAS001
      ** (Net Present Value Accounting)                                                       CAS001
                                                                                              CAS001
     C                   CALLB     'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRTCD                                        CAS001
     C                   PARM      '*VERIFY'     POPTN                                        CAS001
     C                   PARM      'CAS001'      PSARD                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
     C                             PRTCD <> '*NRF   '                                         CAS001
     C     *LOCK         IN        LDA                                                        CAS001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS001
     C                   EVAL      DBASE = 905                                                CAS001
     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
     C                   OUT       LDA                                                        CAS001
     C                   EXSR      SRERR                                                      CAS001
     C                   ENDIF                                                                CAS001
     C                   IF        PRTCD = *BLANKS                                            CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   ENDIF                                                                CAS001
     C*
      ** Access SAR details file to determine if CAS004 is on.                                CAS004
      ** (Hedge Accounting)                                                                   CAS004
                                                                                              CAS004
     C                   CALLB     'AOSARDR0'                                                 CAS004
     C                   PARM      *BLANKS       PRTCD                                        CAS004
     C                   PARM      '*VERIFY'     POPTN                                        CAS004
     C                   PARM      'CAS004'      PSARD                                        CAS004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS004
                                                                                              CAS004
     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '                    CAS004
     C     *LOCK         IN        LDA                                                        CAS004
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS004
     C                   EVAL      DBASE = 906                                                CAS004
     C                   EVAL      DBKEY = 'CAS004'                                           CAS004
     C                   OUT       LDA                                                        CAS004
     C                   EXSR      SRERR                                                      CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   IF        PRTCD = *BLANKS                                            CAS004
     C                   EVAL      CAS004 = 'Y'                                               CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      CAS004 = 'N'                                               CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** Access SAR details file to determine if CAS005 is on.                                CAS005
      ** (Enhancements to CAS001, CAS002 and CAS004)                                          CAS005
                                                                                              CAS005
     C                   CALLB     'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRTCD                                        CAS005
     C                   PARM      '*VERIFY'     POPTN                                        CAS005
     C                   PARM      'CAS005'      PSARD                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
     C                   IF        PRTCD <> *BLANKS and PRTCD <> '*NRF   '                    CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS005
     C                   EVAL      DBASE = 907                                                CAS005
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
     C/COPY WNCPYSRC,MMH00020
                                                                                              CAS005
      ** Access SAR details file to determine if CDL016 is switched on                        CDL016
      ** (Autumatic Rollover of Fixed Term Loan/Deposit)                                      CDL016
                                                                                              CDL016
     C                   CallB     'AOSARDR0'                                                 CDL016
     C                   Parm      *Blanks       PRTCD                                        CDL016
     C                   Parm      '*VERIFY'     POPTN                                        CDL016
     C                   Parm      'CDL016'      PSARD                                        CDL016
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL016
      *                                                                                       CDL016
     C                   Move      'N'           CDL016            1                          CDL016
     C                   If        PRTCD = *Blanks                                            CDL016
     C                   Eval      CDL016 = 'Y'                                               CDL016
     C                   Endif                                                                CDL016
                                                                                              CDL019
      ** Access SAR details file to determine if CDL019 is switched on                        CDL019
      ** (Allow Base Rate Changes on Fixed Deposits/Loans)                                    CDL019
                                                                                              CDL019
     C                   CallB     'AOSARDR0'                                                 CDL019
     C                   Parm      *Blanks       PRTCD                                        CDL019
     C                   Parm      '*VERIFY'     POPTN                                        CDL019
     C                   Parm      'CDL019'      PSARD                                        CDL019
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL019
      *                                                                                       CDL019
     C                   Move      'N'           CDL019            1                          CDL019
     C                   If        PRTCD = *Blanks                                            CDL019
     C                   Eval      CDL019 = 'Y'                                               CDL019
     C                   Endif                                                                CDL019
                                                                                              CDL019
      ** Access SAR details file to determine if CDL020 is switched on                       BUG5169
      ** (Apply Base Rate at Value Date)                                                     BUG5169
                                                                                             BUG5169
     C                   CallB     'AOSARDR0'                                                BUG5169
     C                   Parm      *Blanks       PRTCD                                       BUG5169
     C                   Parm      '*VERIFY'     POPTN                                       BUG5169
     C                   Parm      'CDL020'      PSARD                                       BUG5169
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG5169
      *                                                                                      BUG5169
     C                   Move      'N'           CDL020            1                         BUG5169
     C                   If        PRTCD = *Blanks                                           BUG5169
     C                   Eval      CDL020 = 'Y'                                              BUG5169
     C                   Endif                                                               BUG5169
                                                                                             BUG5169
      ** Check if CRE020 is enabled.                                                          CRE020
                                                                                              CRE020
     C                   EVAL      PSysVal01 = 'LoansDeposNAsIssued '                       AR784570
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
     C                   EVAL      DBase = 908                                                CRE020
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
     C                   EVAL      DBase = 909                                                CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CDL033
      ** Access SAR details file to determine if CDL033                                       CDL033
      ** (Floating Rate CDs Issued) is on.                                                    CDL033
      *                                                                                       CDL033
     C                   CALLB     'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       @RTCD                                        CDL033
     C                   PARM      '*VERIFY'     @OPTN                                        CDL033
     C                   PARM      'CDL033'      PSARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
      *                                                                                       CDL033
      ** An NRF (No Record Found) return code is valid.                                       CDL033
      ** Issue database error only for error return codes.                                    CDL033
      *                                                                                       CDL033
     C     @RTCD         IFNE      *BLANKS                                                    CDL033
     C     @RTCD         ANDNE     '*NRF   '                                                  CDL033
     C     *LOCK         IN        LDA                                                        CDL033
     C                   MOVEL     'CDL033'      DBKEY                                        CDL033
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL033
     C                   Z-ADD     910           DBASE                                        CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EXSR      SRERR                                                      CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   MOVEL     'N'           CDL033                                       CDL033
     C     @RTCD         IFEQ      *BLANK                                                     CDL033
     C                   MOVEL     'Y'           CDL033            1                          CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Check if Fiduciary Dealing is installed                                            BUG10725
                                                                                            BUG10725
     C                   CALLB     'AOSARDR0'                                               BUG10725
     C                   PARM      *BLANKS       PRtCd                                      BUG10725
     C                   PARM      '*VERIFY'     POptn                                      BUG10725
     C                   PARM      'CDL006'      PSARD                                      BUG10725
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG10725
                                                                                            BUG10725
     C                   EVAL      CDL006 = 'N'                                             BUG10725
                                                                                            BUG10725
     C                   IF        PRtCd = *BLANKS                                          BUG10725
     C                   EVAL      CDL006 = 'Y'                                             BUG10725
     C                   ELSE                                                               BUG10725
                                                                                            BUG10725
     C                   IF        PRtCd <> '*NRF'                                          BUG10725
     C     *LOCK         IN        LDA                                                      BUG10725
     C                   EVAL      DBFile = 'SCSARDPD'                                      BUG10725
     C                   EVAL      DBase = 911                                              BUG10725
     C                   EVAL      DBKey = 'CDL006'                                         BUG10725
     C                   OUT       LDA                                                      BUG10725
     C                   EXSR      SRErr                                                    BUG10725
     C                   ENDIF                                                              BUG10725
                                                                                            BUG10725
     C                   ENDIF                                                              BUG10725
                                                                                              239566
      ** Access SAR details file to determine if CEU015 is switched on                        239566
                                                                                              239566
     C                   CallB     'AOSARDR0'                                                 239566
     C                   Parm      *Blanks       PRTCD                                        239566
     C                   Parm      '*VERIFY'     POPTN                                        239566
     C                   Parm      'CEU015'      PSARD                                        239566
     C     SCSARD        Parm      SCSARD        DSFDY                                        239566
      *                                                                                       239566
     C                   Move      'N'           CEU015            1                          239566
     C                   If        PRTCD = *Blanks                                            239566
     C                   Eval      CEU015 = 'Y'                                               239566
     C                   Endif                                                                239566
                                                                                            BUG10725
                                                                                              246801
      ** Access SAR details file to determine if CSW050 is on.                                246801
      ** (Multiple Payments mesasages)                                                        246801
                                                                                              246801
     C                   CALLB     'AOSARDR0'                                                 246801
     C                   PARM      *BLANKS       PRTCD                                        246801
     C                   PARM      '*VERIFY'     POPTN                                        246801
     C                   PARM      'CSW050'      PSARD                                        246801
     C     SCSARD        PARM      SCSARD        DSFDY                                        246801
     C                   IF        PRTCD <> *BLANKS AND                                       246801
     C                             PRTCD <> '*NRF   '                                         246801
     C                   EVAL      DBFILE = 'SCSARDPD'                                        246801
     C                   EVAL      DBASE = 915                                                246801
     C                   EVAL      DBKEY = 'CSW050'                                           246801
     C                   EXSR      SRERR                                                      246801
     C                   ENDIF                                                                246801
     C                   IF        PRTCD = *BLANKS                                            246801
     C                   EVAL      CSW050 = 'Y'                                               246801
     C                   ELSE                                                                 246801
     C                   EVAL      CSW050 = 'N'                                               246801
     C                   ENDIF                                                                246801
      *                                                                                       CER020
      ** Access SAR details file to determine if CER020 is on.                                CER020
      *                                                                                       CER020
     C                   CALLB     'AOSARDR0'                                                 CER020
     C                   PARM      *BLANKS       PRTCD                                        CER020
     C                   PARM      '*VERIFY'     POPTN                                        CER020
     C                   PARM      'CER020'      PSARD                                        CER020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER020
      *                                                                                       CER020
     C                   IF        PRTCD = *BLANKS                                            CER020
      *                                                                                       CER020
     C                   EVAL      CER020 = 'Y'                                               CER020
     C                   ELSE                                                                 CER020
     C                   EVAL      CER020 = 'N'                                               CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
                                                                                              246801
      *                                                                                       CRE073
      ** Access SAR details file to determine if CRE073 is on.                                CRE073
      *                                                                                       CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM      '*VERIFY'     POPTN                                        CRE073
     C                   PARM      'CRE073'      PSARD                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
      *                                                                                       CRE073
     C                   IF        PRTCD = *BLANKS                                            CRE073
      *                                                                                       CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      CRE073 = 'N'                                               CRE073
      *                                                                                       CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
      *                                                                                     MD025244
      ** Get MPHAS dataarea.                                                                MD025244
      *                                                                                     MD025244
     C     *DTAARA       DEFINE                  MPHAS                                      MD025244
     C                   IN        MPHAS                                                    MD025244
     C                   UNLOCK    MPHAS                                                    MD025244
      *                                                                                     MD025244
     C                   MOVEL     IKFRNT        W#FRNT                                     MD025244
     C                   MOVE      *BLANKS       EAPIC                                      MD025244
     C                   MOVEL     'N'           MTHREAD           1                        MD025244
      *                                                                                     MD025244
     C**********         IF        MPHAS = 'A' AND                                 MD025244 MD025467
     C**********                   W#FRNT <> 'LE000473'                            MD025244 MD025467
     C                   IF        MPHAS <> 'C'                                             MD025467
     C                   MOVEL     'Y'           MTHREAD                                    MD025244
     C                   ENDIF                                                              MD025244
     C/COPY WNCPYSRC,MMH00010
      *                                                                                       CDL096
      ** Access SAR details file to determine if CDL096 is on.                                CDL096
      *                                                                                       CDL096
     C                   CALLB     'AOSARDR0'                                                 CDL096
     C                   PARM      *BLANKS       PRTCD                                        CDL096
     C                   PARM      '*VERIFY'     POPTN                                        CDL096
     C                   PARM      'CDL096'      PSARD                                        CDL096
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL096
      *                                                                                       CDL096
     C                   IF        PRTCD = *BLANKS                                            CDL096
     C                   EVAL      CDL096 = 'Y'                                               CDL096
     C                   ELSEIF    PRTCD = '*NRF'                                             CDL096
     C                   EVAL      CDL096 = 'N'                                               CDL096
     C                   ELSE                                                                 CDL096
                                                                                              CDL096
      ** Access program error                                                                 CDL096
     C                   MOVEL     'CDL096'      DBKEY                                        CDL096
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL096
     C                   MOVEL     '912'         DBASE                                        CDL096
     C                   EXSR      SRERR                                                      CDL096
     C                   ENDIF                                                                CDL096
                                                                                              CDL096
      ** Access SAR details file to determine if CGL165 is on.                                CGL165
      *                                                                                       CGL165
     C                   CALLB     'AOSARDR0'                                                 CGL165
     C                   PARM      *BLANKS       PRTCD                                        CGL165
     C                   PARM      '*VERIFY'     POPTN                                        CGL165
     C                   PARM      'CGL165'      PSARD                                        CGL165
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL165
      *                                                                                       CGL165
     C                   IF        PRTCD = *BLANKS                                            CGL165
     C                   EVAL      CGL165 = 'Y'                                               CGL165
     C                   ELSE                                                                 CGL165
     C                   EVAL      CGL165 = 'N'                                               CGL165
     C                   ENDIF                                                                CGL165
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'MMLDNIUPD'   DBPGM            10
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
     C****************************************************************
     C/COPY WNCPYSRC,MMLDNIDC19
**  CPY@
(c) Finastra International Limited 2001
